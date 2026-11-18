-- Compare words and phrases, including wildcards and spelling differences.
local LuceneRegex = require("resources/lib/text/lucene_regex")

local LuceneMatch = {}

-- Ignore capitals, display formatting, and extra spacing around text.
local function normalize(value)
    return string
        .lower(tostring(value == nil and "" or value))
        :gsub("<[^>]*>", "")
        :match("^%s*(.-)%s*$")
end

-- Split cleaned text into searchable words and numbers.
local function terms(value)
    local result = {}
    for word in string.gmatch(normalize(value), "[%w]+") do
        result[#result + 1] = word
    end
    return result
end

-- Keep cleaned text and its words ready for repeated comparisons.
local function prepared(value)
    if type(value) == "table" and value.__runeqlPrepared == true then
        return value
    end
    local normalized = normalize(value)
    local analyzed = terms(normalized)
    if #analyzed == 0 and normalized ~= "" then
        analyzed[1] = normalized
    end
    return {
        __runeqlPrepared = true,
        normalized = normalized,
        terms = analyzed,
        scalar = type(value) == "number" or type(value) == "boolean",
    }
end

-- Count the fewest spelling changes needed, including swapped neighbours.
local function osaDistance(left, right, maximum)
    left, right = normalize(left), normalize(right)
    local leftLength, rightLength = #left, #right
    if math.abs(leftLength - rightLength) > maximum then
        return maximum + 1
    end

    local previousPrevious = nil
    local previous = {}
    for column = 0, rightLength do
        previous[column] = column
    end

    for row = 1, leftLength do
        local current = { [0] = row }
        local rowMinimum = current[0]
        local leftCharacter = string.sub(left, row, row)
        for column = 1, rightLength do
            local cost = leftCharacter == string.sub(right, column, column) and 0 or 1
            local value =
                math.min(previous[column] + 1, current[column - 1] + 1, previous[column - 1] + cost)
            if
                row > 1
                and column > 1
                and previousPrevious ~= nil
                and leftCharacter == string.sub(right, column - 1, column - 1)
                and string.sub(left, row - 1, row - 1) == string.sub(right, column, column)
            then
                value = math.min(value, previousPrevious[column - 2] + 1)
            end
            current[column] = value
            rowMinimum = math.min(rowMinimum, value)
        end
        if rowMinimum > maximum then
            return maximum + 1
        end
        previousPrevious, previous = previous, current
    end
    return previous[rightLength]
end

local LUA_PATTERN_MAGIC = {
    ["^"] = true,
    ["$"] = true,
    ["("] = true,
    [")"] = true,
    ["%"] = true,
    ["."] = true,
    ["["] = true,
    ["]"] = true,
    ["+"] = true,
    ["-"] = true,
}

-- Turn * and ? shortcuts into a pattern Lua can match.
local function wildcardPattern(raw)
    local parts = { "^" }
    local index = 1
    while index <= #raw do
        local character = string.sub(raw, index, index)
        if character == "\\" and index < #raw then
            index = index + 1
            character = string.sub(raw, index, index)
            parts[#parts + 1] = LUA_PATTERN_MAGIC[character] and ("%" .. character) or character
        elseif character == "*" then
            parts[#parts + 1] = ".*"
        elseif character == "?" then
            parts[#parts + 1] = "."
        else
            parts[#parts + 1] = LUA_PATTERN_MAGIC[character] and ("%" .. character) or character
        end
        index = index + 1
    end
    parts[#parts + 1] = "$"
    return table.concat(parts)
end

-- Check whether * or ? is active rather than escaped as ordinary text.
function LuceneMatch.HasWildcard(raw)
    local escaped = false
    for index = 1, #raw do
        local character = string.sub(raw, index, index)
        if escaped then
            escaped = false
        elseif character == "\\" then
            escaped = true
        elseif character == "*" or character == "?" then
            return true
        end
    end
    return false
end

-- Prepare a word search, including its wildcard or allowed spelling changes.
function LuceneMatch.CompileTerm(query, raw, fuzzyEdits)
    query = normalize(query)
    local queryTerms = terms(query)
    if #queryTerms == 0 and query ~= "" then
        queryTerms[1] = query
    end
    local wildcard = LuceneMatch.HasWildcard(raw)
    return {
        query = query,
        fuzzyEdits = fuzzyEdits,
        queryTerms = queryTerms,
        wildcard = wildcard,
        pattern = wildcard and wildcardPattern(string.lower(raw)) or nil,
    }
end

-- Score the best matching word while keeping numbers and booleans exact.
function LuceneMatch.MatchTerm(compiled, value)
    local analysis = prepared(value)
    if analysis.scalar then
        if compiled.fuzzyEdits ~= nil or compiled.wildcard then
            return nil
        end
        return analysis.normalized == compiled.query and 100 or nil
    end

    local candidates = analysis.terms
    local best = nil
    for _, candidate in ipairs(candidates) do
        local score = nil
        if compiled.fuzzyEdits ~= nil then
            local distance = osaDistance(compiled.query, candidate, compiled.fuzzyEdits)
            if
                distance <= compiled.fuzzyEdits
                and distance < math.min(#compiled.query, #candidate)
            then
                score = 80 - distance * 10
            end
        elseif compiled.wildcard then
            if string.match(candidate, compiled.pattern) ~= nil then
                score = 70
            end
        else
            for _, queryTerm in ipairs(compiled.queryTerms) do
                if candidate == queryTerm then
                    score = 100
                    break
                end
            end
        end
        if score ~= nil and (best == nil or score > best) then
            best = score
        end
    end
    return best
end

-- Prepare the words that must appear in a phrase.
function LuceneMatch.CompilePhrase(query)
    return terms(query)
end

-- Find an exact sequence of words and return its score.
function LuceneMatch.MatchPhrase(wanted, value)
    local available = prepared(value).terms
    if #wanted == 0 then
        return nil
    end
    for startIndex = 1, #available - #wanted + 1 do
        local matches = true
        for offset = 1, #wanted do
            if available[startIndex + offset - 1] ~= wanted[offset] then
                matches = false
                break
            end
        end
        if matches then
            return 120 + #wanted
        end
    end
    return nil
end

-- Find how far words must move to form the requested phrase.
local function phraseSlop(wanted, available)
    local candidates = {}
    for wantedIndex, word in ipairs(wanted) do
        local positions = {}
        for availableIndex, candidate in ipairs(available) do
            if candidate == word then
                positions[#positions + 1] = availableIndex
            end
        end
        if #positions == 0 then
            return nil
        end
        candidates[wantedIndex] = positions
    end

    local chosen = {}
    local used = {}
    local best = nil
    local explored = 0
    -- Try possible word positions to find the closest phrase match.
    local function visit(index)
        if best == 0 or explored > 20000 then
            return
        end
        if index > #wanted then
            explored = explored + 1
            local offsets = {}
            for wantedIndex, position in ipairs(chosen) do
                offsets[#offsets + 1] = position - wantedIndex
            end
            table.sort(offsets)
            local origin = offsets[math.floor((#offsets + 1) / 2)]
            local cost = 0
            for _, offset in ipairs(offsets) do
                cost = cost + math.abs(offset - origin)
            end
            if best == nil or cost < best then
                best = cost
            end
            return
        end
        for _, position in ipairs(candidates[index]) do
            if not used[position] then
                used[position] = true
                chosen[index] = position
                visit(index + 1)
                used[position] = nil
            end
        end
    end
    visit(1)
    return best
end

-- Score a phrase whose words are close enough under the requested allowance.
function LuceneMatch.MatchProximity(wanted, value, maximumSlop)
    local available = prepared(value).terms
    if #wanted == 0 then
        return nil
    end
    local slop = phraseSlop(wanted, available)
    if slop == nil or slop > maximumSlop then
        return nil
    end
    return 115 + #wanted - slop
end

-- Score a word that matches the prepared character pattern.
function LuceneMatch.Regex(regexAst, value)
    local analysis = prepared(value)
    if analysis.scalar then
        return nil
    end
    for _, candidate in ipairs(analysis.terms) do
        if LuceneRegex.Match(regexAst, candidate) then
            return 75
        end
    end
    return nil
end

-- Make text cleanup available to the rest of the search engine.
function LuceneMatch.Normalize(value)
    return normalize(value)
end

-- Make reusable text preparation available to the rest of the search engine.
function LuceneMatch.Prepare(value)
    return prepared(value)
end

return LuceneMatch
