-- Turn search text into reusable rules for checking items.
local Lexer = require("resources/lib/query/lexer")
local Evaluator = require("resources/lib/query/evaluator")
local LuceneMatch = require("resources/lib/text/lucene_match")
local LuceneRegex = require("resources/lib/text/lucene_regex")
local ItemFilter = require("resources/lib/catalog/item_filter")

local Compiler = {}
local Plan = {}
Plan.__index = Plan

local MAX_QUERY_LENGTH = 100000
local MAX_CLAUSES = 4096
local COMPILE_CACHE_SIZE = 32
local compileCache = {}
local compileOrder = {}

local Parser = {}
Parser.__index = Parser

-- Explain a search error and point to the character that caused it.
local function parseFailure(parser, message, token)
    token = token or parser.tokens[parser.index]
    return nil, message .. " at character " .. tostring(token.position) .. "."
end

-- Read the search piece we are currently processing.
function Parser:Current()
    return self.tokens[self.index]
end

-- Look ahead without moving past the current search piece.
function Parser:Peek(offset)
    return self.tokens[self.index + (offset or 1)]
end

-- Move past the current search piece if it is the expected kind.
function Parser:Consume(kind)
    local current = self:Current()
    if kind ~= nil and current.kind ~= kind then
        return nil
    end
    self.index = self.index + 1
    return current
end

-- Read a ^ number that makes this search rule count more toward the score.
function Parser:ApplyBoost(node)
    if self:Current().kind ~= "BOOST" then
        return node, nil
    end
    local caret = self:Consume("BOOST")
    local factor = self:Current()
    if
        factor.kind ~= "TERM"
        or factor.position ~= caret.position + 1
        or string.match(factor.value, "^%d+%.?%d*$") == nil
    then
        return parseFailure(
            self,
            "Lucene boosts require a positive numeric factor immediately after ^",
            factor
        )
    end
    local value = tonumber(factor.value)
    if value == nil or value <= 0 then
        return parseFailure(self, "Lucene boost factors must be greater than zero", factor)
    end
    self:Consume()
    node.boost = value
    node.source = tostring(node.source or "") .. "^" .. factor.raw
    return node, nil
end

-- Read one end of a range, treating * as an open end.
local function rangeBoundary(parser)
    local current = parser:Current()
    if current.kind ~= "TERM" and current.kind ~= "PHRASE" then
        return parseFailure(parser, "RuneQL expected a range boundary", current)
    end
    parser:Consume()
    if current.kind == "TERM" and current.value == "*" then
        return nil, nil
    end
    return current.value, nil
end

-- Read a range such as tier:[70 TO 90].
function Parser:ParseRange(field)
    local opening = self:Consume()
    local lower, reason = rangeBoundary(self)
    if reason ~= nil then
        return nil, reason
    end
    if self:Consume("TO") == nil then
        return parseFailure(self, "RuneQL ranges require an uppercase TO")
    end
    local upper
    upper, reason = rangeBoundary(self)
    if reason ~= nil then
        return nil, reason
    end
    local closing = self:Current()
    if closing.kind ~= "RANGE_END_INCLUSIVE" and closing.kind ~= "RANGE_END_EXCLUSIVE" then
        return parseFailure(self, "RuneQL found an unterminated range", closing)
    end
    self:Consume()
    return {
        type = "range",
        field = field,
        lower = lower,
        upper = upper,
        includeLower = opening.kind == "RANGE_INCLUSIVE",
        includeUpper = closing.kind == "RANGE_END_INCLUSIVE",
        source = (field and (field .. ":") or "")
            .. opening.raw
            .. tostring(lower or "*")
            .. " TO "
            .. tostring(upper or "*")
            .. closing.raw,
    },
        nil
end

-- Check whether a search word starts with an unsupported * or ?.
local function hasLeadingWildcard(term)
    return (string.sub(term.raw, 1, 1) == "*" or string.sub(term.raw, 1, 1) == "?")
        and term.raw ~= "*"
end

-- Read one search rule, including its field, group, phrase, or pattern.
function Parser:ParsePrimary(inheritedField)
    local field = inheritedField
    local current = self:Current()
    if current.kind == "TERM" and self:Peek().kind == "COLON" then
        field = string.lower(current.value)
        self:Consume()
        self:Consume("COLON")
        current = self:Current()
    end

    if current.kind == "LPAREN" then
        self:Consume()
        local grouped, reason = self:ParseQuery(field, "RPAREN")
        if grouped == nil then
            return nil, reason
        end
        if self:Consume("RPAREN") == nil then
            return parseFailure(self, "RuneQL found an unterminated group")
        end
        return self:ApplyBoost(grouped)
    elseif current.kind == "RANGE_INCLUSIVE" or current.kind == "RANGE_EXCLUSIVE" then
        local range, reason = self:ParseRange(field or "_all")
        if range == nil then
            return nil, reason
        end
        return self:ApplyBoost(range)
    elseif current.kind == "REGEX" then
        self:Consume()
        local regex, reason = LuceneRegex.Compile(current.value)
        if regex == nil then
            return nil, reason
        end
        return self:ApplyBoost({
            type = "regex",
            field = field or "_all",
            value = current.value,
            regex = regex,
            source = (field and (field .. ":") or "") .. current.raw,
        })
    elseif current.kind == "PHRASE" then
        self:Consume()
        local proximity = nil
        if self:Current().kind == "TILDE" then
            local tilde = self:Consume("TILDE")
            local distance = self:Current()
            if
                distance.kind ~= "TERM"
                or distance.position ~= tilde.position + 1
                or string.match(distance.value, "^%d+$") == nil
            then
                return parseFailure(
                    self,
                    "Lucene phrase proximity requires a non-negative integer",
                    distance
                )
            end
            proximity = tonumber(distance.value)
            self:Consume()
        end
        local phrase = {
            type = "phrase",
            field = field or "_all",
            value = current.value,
            proximity = proximity,
            matcher = LuceneMatch.CompilePhrase(current.value),
            source = (field and (field .. ":") or "")
                .. current.raw
                .. (proximity ~= nil and ("~" .. tostring(proximity)) or ""),
        }
        return self:ApplyBoost(phrase)
    elseif current.kind ~= "TERM" then
        return parseFailure(self, "RuneQL expected a term, phrase, range, or group", current)
    end

    self:Consume()
    if field == "*" and current.value == "*" then
        return self:ApplyBoost({ type = "match_all", field = "*", source = "*:*" })
    end
    if hasLeadingWildcard(current) then
        return parseFailure(self, "Lucene terms cannot begin with a wildcard", current)
    end

    local fuzzyEdits = nil
    if self:Current().kind == "TILDE" then
        if LuceneMatch.HasWildcard(current.raw) then
            return parseFailure(self, "Lucene fuzzy terms cannot contain wildcards", current)
        end
        local tilde = self:Consume()
        fuzzyEdits = 2
        local distance = self:Current()
        if
            distance.kind == "TERM"
            and string.match(distance.value, "^%d+$") ~= nil
            and distance.position == tilde.position + 1
        then
            fuzzyEdits = tonumber(distance.value)
            self:Consume()
        elseif distance.kind == "TERM" and distance.position == tilde.position + 1 then
            return parseFailure(
                self,
                "Lucene fuzzy edit distance must be an integer between 0 and 2",
                distance
            )
        end
        if fuzzyEdits < 0 or fuzzyEdits > 2 then
            return parseFailure(
                self,
                "Lucene fuzzy edit distance must be between 0 and 2",
                distance
            )
        end
    end
    local term = {
        type = "term",
        field = field or "_all",
        value = current.value,
        raw = current.raw,
        fuzzyEdits = fuzzyEdits,
        matcher = LuceneMatch.CompileTerm(current.value, current.raw, fuzzyEdits),
        source = (field and (field .. ":") or "")
            .. current.raw
            .. (fuzzyEdits ~= nil and ("~" .. tostring(fuzzyEdits)) or ""),
    }
    return self:ApplyBoost(term)
end

-- Record whether a rule is required, optional, or excluded.
local function addClause(clauses, conjunction, modifier, query)
    if conjunction == "AND" and #clauses > 0 and clauses[#clauses].occur ~= "MUST_NOT" then
        clauses[#clauses].occur = "MUST"
    end

    local occur = "SHOULD"
    if modifier == "PROHIBITED" then
        occur = "MUST_NOT"
    elseif modifier == "REQUIRED" or conjunction == "AND" then
        occur = "MUST"
    end
    clauses[#clauses + 1] = { occur = occur, query = query }
end

-- Combine search rules using AND, OR, and exclusion signs.
function Parser:ParseQuery(inheritedField, stopKind)
    local clauses = {}
    local expectingClause = true
    local conjunction = nil

    while self:Current().kind ~= "EOF" and self:Current().kind ~= stopKind do
        local current = self:Current()
        if current.kind == "RPAREN" and stopKind ~= "RPAREN" then
            return parseFailure(self, "RuneQL found an unexpected closing parenthesis", current)
        end
        if not expectingClause and (current.kind == "AND" or current.kind == "OR") then
            conjunction = current.kind
            self:Consume()
            expectingClause = true
            current = self:Current()
        elseif not expectingClause then
            conjunction = nil -- Lucene's default operator is OR.
            expectingClause = true
        elseif current.kind == "AND" or current.kind == "OR" then
            return parseFailure(
                self,
                "RuneQL found a Boolean operator without a left clause",
                current
            )
        end

        local modifier = nil
        current = self:Current()
        if current.kind == "PLUS" then
            modifier = "REQUIRED"
            self:Consume()
        elseif current.kind == "MINUS" or current.kind == "NOT" then
            modifier = "PROHIBITED"
            self:Consume()
        end

        local query, reason = self:ParsePrimary(inheritedField)
        if query == nil then
            return nil, reason
        end
        addClause(clauses, conjunction, modifier, query)
        self.clauseCount = self.clauseCount + 1
        if self.clauseCount > MAX_CLAUSES then
            return parseFailure(self, "RuneQL queries can contain at most 4,096 clauses")
        end
        expectingClause = false
        conjunction = nil
    end

    if #clauses == 0 then
        return parseFailure(self, "RuneQL queries cannot be empty")
    end
    if expectingClause then
        return parseFailure(self, "RuneQL expected a clause after the Boolean operator")
    end
    return { type = "boolean", clauses = clauses }, nil
end

local ID_FIELDS = { id = true, itemid = true, objectid = true, containsid = true }

-- Reject searches using changeable item numbers instead of stable names.
local function rejectIDFields(node)
    if node.type == "boolean" then
        for _, clause in ipairs(node.clauses) do
            local reason = rejectIDFields(clause.query)
            if reason ~= nil then
                return reason
            end
        end
        return nil
    end
    local field = string.lower(tostring(node.field or ""))
    if ID_FIELDS[field] then
        return "RuneQL item IDs are unsupported; search by display name and persist config names."
    end
end

-- List the item details needed to check this search.
local function collectRequirements(node, result)
    if node.type == "boolean" then
        for _, clause in ipairs(node.clauses) do
            collectRequirements(clause.query, result)
        end
    elseif node.type ~= "match_all" then
        result[node.field or "_all"] = true
    end
end

-- Check an item and return its match, score, and reasons.
function Plan:Evaluate(row, session)
    if not ItemFilter.Allows(row and row.configName, self.bankableOnly, self.includeDeleted) then
        return false, nil, {}
    end
    local matched, score, evidence = Evaluator.Evaluate(self.ast, row, session)
    return matched, matched and score or nil, evidence
end

-- Return an item's match score and reasons, or no score if it fails.
function Plan:Score(row, session)
    local matched, score, evidence = self:Evaluate(row, session)
    return matched and score or nil, evidence
end

-- Score a display name and return the first search rule it matched.
function Plan:ScoreName(name)
    local score, evidence = self:Score({ name = tostring(name or "") })
    local clause = evidence ~= nil and evidence[1] ~= nil and evidence[1].clause or nil
    return score, clause
end

-- Tell the caller which item details this search needs.
function Plan:Requirements()
    local result = {}
    collectRequirements(self.ast, result)
    if self.bankableOnly or not self.includeDeleted then
        result.configName = true
    end
    return result
end

-- Check search syntax and turn it into a set of matching rules.
function Compiler.Parse(query)
    query = tostring(query or "")
    if #query > MAX_QUERY_LENGTH then
        return nil, "RuneQL queries can contain at most 100,000 bytes."
    end
    local tokens, reason = Lexer.Tokenize(query)
    if tokens == nil then
        return nil, reason
    end
    local parser = setmetatable({ tokens = tokens, index = 1, clauseCount = 0 }, Parser)
    local ast
    ast, reason = parser:ParseQuery(nil, nil)
    if ast == nil then
        return nil, reason
    end
    if parser:Current().kind ~= "EOF" then
        return parseFailure(parser, "RuneQL could not parse the remainder of this query")
    end
    reason = rejectIDFields(ast)
    if reason ~= nil then
        return nil, reason
    end
    return ast, nil
end

-- Prepare a reusable search, reusing one of the last 32 searches when possible.
function Compiler.Compile(query, options)
    local bankableOnly, reason = ItemFilter.Parse(options)
    if bankableOnly == nil then
        return nil, reason
    end
    query = tostring(query or "")
    local includeDeleted = options ~= nil and options.includeDeleted == true
    local cacheKey = (bankableOnly and "bankable:" or "all:")
        .. (includeDeleted and "deleted:" or "active:") .. query
    local cached = compileCache[cacheKey]
    if cached ~= nil then
        for index, value in ipairs(compileOrder) do
            if value == cacheKey then
                table.remove(compileOrder, index)
                break
            end
        end
        compileOrder[#compileOrder + 1] = cacheKey
        return cached.plan, cached.reason
    end

    local ast
    ast, reason = Compiler.Parse(query)
    local plan = ast ~= nil
            and setmetatable({
                languageVersion = 3,
                luceneDialect = "classic-10.3",
                source = query,
                ast = ast,
                bankableOnly = bankableOnly,
                includeDeleted = options ~= nil and options.includeDeleted == true,
            }, Plan)
        or nil
    compileCache[cacheKey] = { plan = plan, reason = reason }
    compileOrder[#compileOrder + 1] = cacheKey
    if #compileOrder > COMPILE_CACHE_SIZE then
        compileCache[table.remove(compileOrder, 1)] = nil
    end
    return plan, reason
end

-- Build a search that accepts only the supplied stable internal item names.
function Compiler.CompileConfigSet(configNames, options)
    local bankableOnly, reason = ItemFilter.Parse(options)
    if bankableOnly == nil then
        return nil, reason
    end
    local values, sources = {}, {}
    for key, value in pairs(type(configNames) == "table" and configNames or {}) do
        local configName = type(key) == "number" and value or (value == true and key or nil)
        configName = tostring(configName or ""):match("^%s*(.-)%s*$")
        if configName ~= "" then
            local normalized = string.lower(configName)
            values[normalized] = true
            sources[normalized] = configName
        end
    end
    return setmetatable({
        languageVersion = 3,
        luceneDialect = "classic-10.3",
        source = "<config-set>",
        bankableOnly = bankableOnly,
        includeDeleted = options ~= nil and options.includeDeleted == true,
        ast = {
            type = "term_set",
            field = "configName",
            values = values,
            sources = sources,
        },
    }, Plan)
end

-- Check whether a value is a search prepared by this copy of RuneQL.
function Compiler.IsPlan(value)
    return getmetatable(value) == Plan
end

Compiler.MAX_QUERY_LENGTH = MAX_QUERY_LENGTH
Compiler.MAX_CLAUSES = MAX_CLAUSES
Compiler.COMPILE_CACHE_SIZE = COMPILE_CACHE_SIZE

return Compiler
