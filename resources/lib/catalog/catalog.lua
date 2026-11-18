-- Look up client item names and join them to the bundled item attributes.
local Catalog = {}
local Manifest = require("resources/data/catalog_manifest")
local ClientIndex = require("resources/lib/catalog/client_index")
local ItemFilter = require("resources/lib/catalog/item_filter")
local normalize = ClientIndex.Normalize
local attributeShards = {}
local discoveryData = nil

-- Load field names and suggested values the first time they are needed.
local function discovery()
    if discoveryData == nil then
        discoveryData = require("resources/catalog/discovery")
    end
    return discoveryData
end

-- Make an independent copy so callers cannot change the shared catalog.
local function copy(value)
    if type(value) ~= "table" then
        return value
    end
    local result = {}
    for key, child in pairs(value) do
        result[key] = copy(child)
    end
    return result
end

-- Load only the small catalog file containing this item's details.
local function fieldsFor(configName)
    local shard = 0
    for index = 1, #configName do
        shard = (shard * 31 + string.byte(configName, index)) % Manifest.shardCount
    end
    if attributeShards[shard] == nil then
        attributeShards[shard] = require(string.format("resources/catalog/attributes_%02d", shard))
    end
    return attributeShards[shard][configName]
end

-- Copy an item's details and flag an unclassified item for review.
local function copiedFields(configName)
    local fields = copy(fieldsFor(configName) or {})
    fields.category = fields.category or "needs-review"
    return fields
end

-- Combine an item's name, internal key, and details into a fresh result.
local function copyRecord(entry, configName, includeFields)
    return {
        configName = configName,
        displayName = entry[2],
        name = entry[2],
        normalizedName = entry[1],
        fields = includeFields ~= false and copiedFields(configName) or nil,
    }
end

-- Find items by name, placing exact and beginning-of-name matches first.
function Catalog.Find(query, limit, options)
    local bankableOnly, reason = ItemFilter.Parse(options, true)
    if bankableOnly == nil then
        return nil, 0, reason
    end
    local includeFields = options == nil or options.includeFields ~= false
    local needle = normalize(query)
    if needle == "" then
        return {}, 0
    end

    local buckets = { {}, {}, {}, {} }
    local totalMatches = 0
    local maximum = math.max(1, math.floor(tonumber(limit) or 40))
    for _, entry in ipairs(ClientIndex.Entries()) do
        local normalizedName = entry[1]
        local position = string.find(normalizedName, needle, 1, true)
        if position ~= nil then
            local rank = 4
            if normalizedName == needle then
                rank = 1
            elseif position == 1 then
                rank = 2
            elseif string.find(normalizedName, " " .. needle, 1, true) ~= nil then
                rank = 3
            end
            for _, configName in ipairs(entry[3]) do
                if ItemFilter.Allows(configName, bankableOnly, options and options.includeDeleted == true) then
                    totalMatches = totalMatches + 1
                    if #buckets[rank] < maximum then
                        buckets[rank][#buckets[rank] + 1] = { entry, configName }
                    end
                end
            end
        end
    end

    local results = {}
    for rank = 1, #buckets do
        for _, match in ipairs(buckets[rank]) do
            results[#results + 1] = copyRecord(match[1], match[2], includeFields)
            if #results >= maximum then
                break
            end
        end
        if #results >= maximum then
            break
        end
    end
    return results, totalMatches
end

-- Return one item by its stable internal name.
function Catalog.Get(configName)
    configName = tostring(configName or "")
    if configName == "" then
        return nil
    end
    local value = ClientIndex.Get(configName)
    return value ~= nil and copyRecord(value.entry, value.configName) or nil
end

-- Ask whether the client allows this item in a bank, or return nil if unavailable.
function Catalog.IsBankable(configName)
    return ClientIndex.IsBankable(configName)
end

-- Ask whether native client metadata marks this item as deleted.
function Catalog.IsDeleted(configName)
    return ClientIndex.IsDeleted(configName)
end

-- Read stored item details without waiting for the client's name index.
function Catalog.GetFields(configName)
    if type(configName) ~= "string" or configName == "" then
        return nil
    end
    local canonical = string.upper(configName)
    if fieldsFor(canonical) ~= nil then
        return copiedFields(canonical)
    end
    local value = ClientIndex.Get(configName)
    return value ~= nil and copiedFields(value.configName) or nil
end

-- List the available item categories and their display names.
function Catalog.Categories()
    return copy(Manifest.categories)
end

-- List the field names that searches can use.
function Catalog.FieldNames()
    return copy(Manifest.fields)
end

-- Describe each field's name, data type, and whether it holds a list.
function Catalog.Fields()
    return copy(discovery().fields)
end

-- List suggested field values, with optional text filtering and a result limit.
function Catalog.Values(fieldKey, options)
    if type(fieldKey) ~= "string" then
        return nil, nil, "Field key must be a string"
    end
    local canonical
    for _, key in ipairs(Manifest.fields) do
        if string.lower(key) == string.lower(fieldKey) then
            canonical = key
            break
        end
    end
    if canonical == nil then
        return nil, nil, "Unknown catalog field: " .. fieldKey
    end
    if options == nil then
        options = {}
    end
    if type(options) ~= "table" then
        return nil, nil, "Options must be a table"
    end
    for key in pairs(options) do
        if key ~= "query" and key ~= "limit" then
            return nil, nil, "Unknown value option: " .. tostring(key)
        end
    end
    if options.query ~= nil and type(options.query) ~= "string" then
        return nil, nil, "Query must be a string"
    end
    local maximum = options.limit
    if
        maximum ~= nil
        and (
            type(maximum) ~= "number"
            or maximum ~= maximum
            or maximum == math.huge
            or maximum < 1
            or maximum % 1 ~= 0
        )
    then
        return nil, nil, "Limit must be a positive finite integer"
    end
    local needle = string.lower(options.query or "")
    local results, total = {}, 0
    for _, row in ipairs(discovery().values[canonical] or {}) do
        if
            string.find(string.lower(tostring(row.value)), needle, 1, true)
            or string.find(string.lower(row.label), needle, 1, true)
        then
            total = total + 1
            if maximum == nil or #results < maximum then
                results[#results + 1] = copy(row)
            end
        end
    end
    return results, total
end

-- Report the catalog version and item, name-group, and category counts.
function Catalog.Info()
    return {
        schemaVersion = Manifest.schemaVersion,
        revision = Manifest.revision,
        discoveryRevision = Manifest.revision,
        configCount = Manifest.configCount,
        nameGroupCount = Manifest.nameGroupCount,
        attributeCount = Manifest.attributeCount,
        categoryCount = #Manifest.categories,
    }
end

-- Report how far the client-only name index has progressed.
function Catalog.IndexStatus()
    return ClientIndex.Status()
end

-- Search all catalog items and return the best matches first.
function Catalog.Search(query, limit, options)
    local plan, reason = require("resources/lib/query/compiler").Compile(query, options)
    if plan == nil then
        return nil, 0, reason
    end
    local maximum = math.max(1, math.floor(tonumber(limit) or 40))
    local best, total = {}, 0
    for _, entry in ipairs(ClientIndex.Entries()) do
        for _, configName in ipairs(entry[3]) do
            local row = {
                configName = configName,
                name = entry[2],
                displayName = entry[2],
                normalizedName = entry[1],
                fields = fieldsFor(configName) or {},
            }
            if row.fields.category == nil then
                row.fields = copy(row.fields)
                row.fields.category = "needs-review"
            end
            local score = plan:Score(row)
            if score ~= nil then
                total = total + 1
                if #best < maximum or score > best[#best].score then
                    local position = #best + 1
                    while position > 1 and score > best[position - 1].score do
                        position = position - 1
                    end
                    table.insert(
                        best,
                        position,
                        { score = score, entry = entry, configName = configName }
                    )
                    if #best > maximum then
                        table.remove(best)
                    end
                end
            end
        end
    end
    local results = {}
    for index, match in ipairs(best) do
        results[index] = copyRecord(match.entry, match.configName)
        results[index].score = match.score
    end
    return results, total
end

-- Pass each catalog item to the caller until it asks to stop.
function Catalog.Each(callback, options)
    local bankableOnly, reason = ItemFilter.Parse(options)
    if bankableOnly == nil then
        return nil, reason
    end
    for _, entry in ipairs(ClientIndex.Entries()) do
        for _, configName in ipairs(entry[3]) do
            if
                ItemFilter.Allows(configName, bankableOnly, options and options.includeDeleted == true)
                and callback(copyRecord(entry, configName)) == false
            then
                return false
            end
        end
    end
    return true
end

return Catalog
