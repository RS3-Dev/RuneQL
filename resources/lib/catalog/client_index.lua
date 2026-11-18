-- Build the item-name index from the current client, without bundled name data.
local Index = {}
local EVENT_KEY = "runeql_client_item_index"
local BATCH_SIZE = 100
local SCAN_LIMIT = 100000
local entries, groups, byConfigName, seenIds = {}, {}, {}, {}
local bankability = {}
local deletion = {}
local configCount, revision, nextId, lookupErrors = 0, 0, 0, 0
local state, phase, enumeration, enumerationError = "waiting", nil, "pending", nil
local iterator, iteratorState, iteratorKey
local dirty, subscribed = false, false

-- Clean up an item name so spacing, capitals, and punctuation do not affect searches.
function Index.Normalize(value)
    return string
        .lower(tostring(value or ""))
        :gsub("<[^>]*>", " ")
        :gsub("[^a-z0-9]+", " ")
        :match("^%s*(.-)%s*$")
        :gsub("%s+", " ")
end

-- Write scan progress to the client console when logging is available.
local function report(message)
    if type(log) == "function" then
        log(message)
    end
end

-- Find the client's item definitions when they become available.
local function objectNamespace()
    local source = config ~= nil and config.Obj or nil
    return source ~= nil and source.FromID ~= nil and source or nil
end

-- Ask the client for one item by its internal name or current numeric ID.
local function objectFor(key)
    local source = objectNamespace()
    if source == nil then
        return nil
    end
    if type(key) == "number" then
        return source.FromID(key)
    end
    return source[key]
end

-- Read one native property without letting an unavailable field hide the whole item.
local function property(object, key)
    return object[key]
end

-- Use a native property when the client exposes it.
local function optionalProperty(object, key)
    local ok, value = pcall(property, object, key)
    if ok then
        return value
    end
    return nil
end

-- Read the client's banking restriction, keeping unavailable information unknown.
local function readBankability(configName)
    local object = objectFor(configName)
    if object == nil or config.Param == nil then
        return nil
    end
    local restriction = config.Param.NONBANKABLE
    local params = optionalProperty(object, "params")
    if restriction == nil or type(params) ~= "table" then
        return nil
    end
    for _, parameter in ipairs(params) do
        if parameter == restriction or tostring(parameter) == tostring(restriction) then
            local value = object:GetParamValue(parameter)
            if value == nil then
                return nil
            end
            return value == false or tonumber(value) == 0
        end
    end
    return true
end

-- Remember each item's banking status until reload, retrying unavailable client reads.
function Index.IsBankable(configName)
    if type(configName) ~= "string" or configName == "" then
        return nil
    end
    local key = string.upper(configName)
    if bankability[key] ~= nil then
        return bankability[key]
    end
    local ok, value = pcall(readBankability, key)
    if ok then
        bankability[key] = value
        return value
    end
    return nil
end

-- Read native deletion markers; bundled catalog categories describe a different taxonomy.
local function readDeletion(configName)
    local object = objectFor(configName)
    if object == nil then
        return nil
    end
    local category = optionalProperty(object, "category")
    if tonumber(category) == 15 then
        return true
    end
    local marker = config.Param and (config.Param.QUICKCHAT_DONT_LIST or config.Param.quickchat_dont_list)
    local params = optionalProperty(object, "params")
    if marker == nil or type(params) ~= "table" then
        return nil
    end
    for _, parameter in ipairs(params) do
        if parameter == marker or tostring(parameter) == tostring(marker) then
            local value = object:GetParamValue(parameter)
            if value == nil then
                return nil
            end
            return value ~= false and tonumber(value) ~= 0
        end
    end
    -- Retry incomplete metadata later rather than caching an unknown category.
    if category ~= nil then
        return false
    end
    return nil
end

-- Cache known deletion status, retrying missing or temporarily unavailable metadata.
function Index.IsDeleted(configName)
    if type(configName) ~= "string" or configName == "" then
        return nil
    end
    local key = string.upper(configName)
    if deletion[key] ~= nil then
        return deletion[key]
    end
    local ok, value = pcall(readDeletion, key)
    if ok then
        deletion[key] = value
        return value
    end
    return nil
end

-- Read item names and identities, including clients that only print the internal name.
local function describe(object)
    local configName = optionalProperty(object, "configName")
    local objectID = tonumber(optionalProperty(object, "id"))
    if objectID == nil or type(configName) ~= "string" or configName == "" then
        local printedName, printedID = tostring(object):match("config%.Obj%.([^%(]+)%((-?%d+)%)")
        objectID = objectID or tonumber(printedID)
        if type(configName) ~= "string" or configName == "" then
            configName = printedName
        end
    end
    return objectID, configName, optionalProperty(object, "name")
end

-- Add an item once and group configurations that share the same display name.
local function remember(objectID, configName, displayName)
    if type(objectID) ~= "number" or objectID < 0 or objectID % 1 ~= 0 then
        return nil
    end
    if type(configName) ~= "string" or configName == "" or configName == "UNKNOWN" then
        return nil
    end
    if type(displayName) ~= "string" or displayName == "" then
        return nil
    end
    local key = string.upper(configName)
    local existing = byConfigName[key]
    if existing ~= nil then
        return existing
    end
    local entry = groups[displayName]
    if entry == nil then
        entry = { Index.Normalize(displayName), displayName, {} }
        groups[displayName] = entry
        entries[#entries + 1] = entry
    end
    entry[3][#entry[3] + 1] = configName
    local value = { entry = entry, configName = configName }
    byConfigName[key], seenIds[objectID] = value, true
    configCount, revision, dirty = configCount + 1, revision + 1, true
    return value
end

-- Safely read one client item, leaving unavailable definitions out of the index.
local function readObject(key)
    local ok, object = pcall(objectFor, key)
    if not ok then
        lookupErrors = lookupErrors + 1
        return nil
    end
    if object == nil then
        return nil
    end
    local valid, objectID, configName, displayName = pcall(describe, object)
    if not valid then
        lookupErrors = lookupErrors + 1
        return nil
    end
    if type(key) == "string" and string.upper(tostring(configName)) ~= string.upper(key) then
        return nil
    end
    return remember(objectID, configName, displayName)
end

-- Open the client's named item list if the host allows it to be walked.
local function namedItems()
    if id == nil or id.Obj == nil then
        return nil
    end
    return pairs(id.Obj)
end

-- Sort name groups consistently when a caller searches or lists the index.
local function compareEntries(left, right)
    if left[1] == right[1] then
        return left[2] < right[2]
    end
    return left[1] < right[1]
end

-- Return the names discovered so far, without doing a full scan during a search.
function Index.Entries()
    if dirty then
        table.sort(entries, compareEntries)
        for _, entry in ipairs(entries) do
            table.sort(entry[3])
        end
        dirty = false
    end
    return entries
end

-- Resolve a known internal name immediately, even before background indexing finishes.
function Index.Get(configName)
    if type(configName) ~= "string" or configName == "" then
        return nil
    end
    local key = string.upper(configName)
    return byConfigName[key] or readObject(key)
end

-- Report actual client coverage separately from the bundled attribute catalog's counts.
function Index.Status()
    return {
        source = "client",
        state = state,
        configCount = configCount,
        nameGroupCount = #entries,
        revision = revision,
        nextId = nextId,
        scanLimit = SCAN_LIMIT,
        nameEnumeration = enumeration,
        enumerationError = enumerationError,
        lookupErrors = lookupErrors,
    }
end

-- Remove the background job when the plugin stops or scanning finishes.
function Index.Stop()
    if subscribed then
        Event.Logic.Unsubscribe(EVENT_KEY)
    end
    subscribed = false
end

-- Read a small batch of client definitions without blocking the game for a full scan.
function Index.Step()
    if state == "ready" then
        return
    end
    local available, source = pcall(objectNamespace)
    if not available or source == nil then
        return
    end
    if phase == nil then
        local ok, first, second, third = pcall(namedItems)
        iterator, iteratorState, iteratorKey = ok and first or nil, second, third
        enumeration = iterator ~= nil and "indexing" or "unavailable"
        if not ok then
            enumerationError = tostring(first)
        end
        phase, state = iterator ~= nil and "names" or "ids", "indexing"
        report("RuneQL client item index started; reading 100 definitions per update.")
    end
    for _ = 1, BATCH_SIZE do
        if phase == "names" then
            local ok, key, value = pcall(iterator, iteratorState, iteratorKey)
            if not ok or key == nil then
                enumeration = ok and "done" or "failed"
                if not ok then
                    enumerationError = tostring(key)
                end
                iterator, iteratorState, iteratorKey, phase = nil, nil, nil, "ids"
            else
                iteratorKey = key
                if type(value) == "number" and value >= 0 and value % 1 == 0 then
                    if not seenIds[value] then
                        readObject(value)
                    end
                elseif type(key) == "number" and type(value) == "string" then
                    readObject(value)
                end
            end
        elseif nextId <= SCAN_LIMIT then
            if not seenIds[nextId] then
                readObject(nextId)
            end
            nextId = nextId + 1
        else
            state = "ready"
            Index.Stop()
            report(
                string.format(
                    "RuneQL client item index ready: %d configurations, %d name groups; scanned IDs 0-%d.",
                    configCount,
                    #entries,
                    SCAN_LIMIT
                )
            )
            return
        end
    end
end

-- Schedule the background scan and replace any subscription left by an earlier reload.
function Index.Start()
    if state == "ready" then
        return true
    end
    if Event == nil or Event.Logic == nil then
        return false
    end
    Event.Logic.Unsubscribe(EVENT_KEY)
    Event.Logic.Subscribe(EVENT_KEY, Index.Step)
    subscribed = true
    return true
end

return Index
