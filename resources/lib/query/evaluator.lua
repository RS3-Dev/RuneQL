-- Check an item's details against prepared search rules.
local LuceneMatch = require("resources/lib/text/lucene_match")
local Catalog = require("resources/lib/catalog/catalog")

local Evaluator = {}
local catalogFieldNames = {}
for _, key in ipairs(Catalog.FieldNames()) do
    catalogFieldNames[string.lower(key)] = true
end

-- Add a single value or a list of values to the details being checked.
local function append(target, values)
    if values == nil then
        return
    end
    if type(values) == "table" then
        local count = 0
        for _, value in ipairs(values) do
            target[#target + 1] = value
            count = count + 1
        end
        if count == 0 then
            for key, value in pairs(values) do
                if type(key) == "string" and value == true then
                    target[#target + 1] = key
                end
            end
        end
    else
        target[#target + 1] = values
    end
end

-- Read a named detail without caring about capitals in its field name.
local function fieldValue(fields, wanted)
    if type(fields) ~= "table" then
        return nil
    end
    if fields[wanted] ~= nil then
        return fields[wanted]
    end
    for key, value in pairs(fields) do
        if string.lower(tostring(key)) == wanted then
            return value
        end
    end
    return nil
end

-- Look up the item's catalog entry once and remember if it is missing.
local function catalogRecord(context)
    if context.catalog == nil then
        local configName = context.row.configName
        context.catalog = type(configName) == "string" and Catalog.Get(configName) or false
    end
    return context.catalog or nil
end

-- Read stored attributes by internal name without requiring a client display-name lookup.
local function catalogFields(context)
    if context.catalogFields == nil then
        local configName = context.row.configName
        context.catalogFields = type(configName) == "string" and Catalog.GetFields(configName)
            or false
    end
    return context.catalogFields or nil
end

-- Use the supplied display name, falling back to the catalog when needed.
local function itemName(context)
    if context.row.name ~= nil then
        return context.row.name
    end
    if context.row.displayName ~= nil then
        return context.row.displayName
    end
    local item = catalogRecord(context)
    return item and item.name or nil
end

-- Gather a field's values, favouring supplied details over catalog defaults.
local function valuesFor(context, field)
    field = string.lower(tostring(field or "_all"))
    if context.values[field] ~= nil then
        return context.values[field]
    end
    local row = context.row
    local values = {}
    if field == "_all" then
        append(values, itemName(context))
        append(values, row.alias)
        append(values, row.aliases)
        append(values, fieldValue(row.fields, "alias"))
        append(values, fieldValue(row.fields, "aliases"))
    elseif field == "name" then
        append(values, itemName(context))
    elseif field == "configname" then
        append(values, row.configName)
    elseif field == "qty" or field == "quantity" or field == "count" then
        append(values, row.quantity or row.qty or row.count)
    else
        local value = fieldValue(row.fields, field)
        if value == nil then
            value = fieldValue(row, field)
        end
        if value == nil then
            value = fieldValue(catalogFields(context), field)
        end
        if value == nil and not catalogFieldNames[field] then
            local item = catalogRecord(context)
            if item ~= nil then
                value = fieldValue(item, field)
            end
        end
        append(values, value)
    end
    context.values[field] = values
    return values
end

-- Prepare a field's text once so its words can be checked efficiently.
local function analyzedValuesFor(context, field)
    field = string.lower(tostring(field or "_all"))
    if context.analyzed[field] ~= nil then
        return context.analyzed[field]
    end
    local result = {}
    for _, value in ipairs(valuesFor(context, field)) do
        result[#result + 1] = LuceneMatch.Prepare(value)
    end
    context.analyzed[field] = result
    return result
end

-- Record which search rule matched and how much it added to the score.
local function evidence(node, score)
    return {
        kind = node.type,
        field = node.field or "_all",
        clause = node.source,
        score = score,
    }
end

-- Reuse an expensive text comparison within the caller's search session.
local function cachedScore(context, node, value, match, matcher, option)
    if context.session == nil then
        return match(matcher, value, option)
    end
    local matches = context.session.matches
    if matches == nil then
        matches = {}
        context.session.matches = matches
    end
    local nodeCache = matches[node]
    if nodeCache == nil then
        nodeCache = {}
        matches[node] = nodeCache
    end
    local key = (value.scalar and "scalar:" or "text:") .. value.normalized
    local cached = nodeCache[key]
    if cached ~= nil then
        return cached ~= false and cached or nil
    end
    local score = match(matcher, value, option)
    nodeCache[key] = score ~= nil and score or false
    return score
end

-- Keep the highest score a text rule earns across a field's prepared values.
local function bestScore(node, context, cacheable, match, matcher, option)
    local best = nil
    for _, value in ipairs(analyzedValuesFor(context, node.field)) do
        local score
        if cacheable then
            score = cachedScore(context, node, value, match, matcher, option)
        else
            score = match(matcher, value, option)
        end
        if score ~= nil and (best == nil or score > best) then
            best = score
        end
    end
    if best == nil then
        return false, 0, {}
    end
    return true, best, { evidence(node, best) }
end

-- Find the best match for one word, wildcard, or typo-tolerant search.
local function evaluateTerm(node, context)
    return bestScore(node, context, node.fuzzyEdits ~= nil, LuceneMatch.MatchTerm, node.matcher)
end

-- Find the best match for a phrase, optionally allowing gaps between words.
local function evaluatePhrase(node, context)
    if node.proximity ~= nil then
        return bestScore(
            node,
            context,
            true,
            LuceneMatch.MatchProximity,
            node.matcher,
            node.proximity
        )
    end
    return bestScore(node, context, false, LuceneMatch.MatchPhrase, node.matcher)
end

-- Find the best word matching a character pattern.
local function evaluateRegex(node, context)
    return bestScore(node, context, true, LuceneMatch.Regex, node.regex)
end

-- Compare two values as numbers when possible, otherwise as text.
local function compareValue(value, boundary)
    local valueNumber, boundaryNumber = tonumber(value), tonumber(boundary)
    if valueNumber ~= nil and boundaryNumber ~= nil then
        if valueNumber < boundaryNumber then
            return -1
        end
        if valueNumber > boundaryNumber then
            return 1
        end
        return 0
    end
    local left = LuceneMatch.Normalize(value)
    local right = LuceneMatch.Normalize(boundary)
    if left < right then
        return -1
    end
    if left > right then
        return 1
    end
    return 0
end

-- Check whether any field value falls within the requested range.
local function evaluateRange(node, context)
    for _, value in ipairs(valuesFor(context, node.field)) do
        local lowerOK = true
        local upperOK = true
        if node.lower ~= nil then
            local comparison = compareValue(value, node.lower)
            lowerOK = node.includeLower and comparison >= 0 or comparison > 0
        end
        if node.upper ~= nil then
            local comparison = compareValue(value, node.upper)
            upperOK = node.includeUpper and comparison <= 0 or comparison < 0
        end
        if lowerOK and upperOK then
            return true, 90, { evidence(node, 90) }
        end
    end
    return false, 0, {}
end

-- Check whether an item's internal name is in the caller's saved selection.
local function evaluateTermSet(node, context)
    for _, value in ipairs(valuesFor(context, node.field)) do
        local key = string.lower(tostring(value or ""))
        if node.values[key] == true then
            local score = 100
            return true,
                score,
                {
                    evidence({
                        type = node.type,
                        field = node.field,
                        source = node.sources[key],
                    }, score),
                }
        end
    end
    return false, 0, {}
end

local evaluate

-- Combine required, optional, and excluded matches into one result.
local function evaluateBoolean(node, context)
    local score = 0
    local resultEvidence = {}
    local mustCount, shouldCount, shouldMatches = 0, 0, 0
    for _, clause in ipairs(node.clauses) do
        local matched, clauseScore, clauseEvidence = evaluate(clause.query, context)
        if clause.occur == "MUST" then
            mustCount = mustCount + 1
            if not matched then
                return false, 0, {}
            end
        elseif clause.occur == "MUST_NOT" then
            if matched then
                return false, 0, {}
            end
        else
            shouldCount = shouldCount + 1
            if matched then
                shouldMatches = shouldMatches + 1
            end
        end
        if matched and clause.occur ~= "MUST_NOT" then
            score = score + clauseScore
            for _, item in ipairs(clauseEvidence) do
                resultEvidence[#resultEvidence + 1] = item
            end
        end
    end
    if mustCount == 0 then
        if shouldCount == 0 or shouldMatches == 0 then
            return false, 0, {}
        end
    end
    return true, score, resultEvidence
end

-- Apply a rule's extra importance to its score and matching reasons.
local function applyBoost(node, matched, score, resultEvidence)
    local boost = tonumber(node.boost)
    if not matched or boost == nil or boost == 1 then
        return matched, score, resultEvidence
    end
    score = score * boost
    for _, item in ipairs(resultEvidence) do
        item.score = item.score * boost
    end
    return matched, score, resultEvidence
end

-- Choose the right check for this rule and apply any score adjustment.
evaluate = function(node, context)
    local matched, score, resultEvidence
    if node.type == "match_all" then
        matched, score, resultEvidence = true, 1, { evidence(node, 1) }
    elseif node.type == "term" then
        matched, score, resultEvidence = evaluateTerm(node, context)
    elseif node.type == "phrase" then
        matched, score, resultEvidence = evaluatePhrase(node, context)
    elseif node.type == "regex" then
        matched, score, resultEvidence = evaluateRegex(node, context)
    elseif node.type == "range" then
        matched, score, resultEvidence = evaluateRange(node, context)
    elseif node.type == "term_set" then
        matched, score, resultEvidence = evaluateTermSet(node, context)
    elseif node.type == "boolean" then
        matched, score, resultEvidence = evaluateBoolean(node, context)
    else
        matched, score, resultEvidence = false, 0, {}
    end
    return applyBoost(node, matched, score, resultEvidence)
end

-- Start checking an item with fresh temporary values and an optional shared cache.
function Evaluator.Evaluate(node, row, session)
    return evaluate(node, {
        row = row or {},
        values = {},
        analyzed = {},
        session = session,
    })
end

return Evaluator
