-- Read and match character patterns used in /pattern/ searches.
local LuceneRegex = {}

local MAX_REPEAT = 1000
local MAX_DEPTH = 64

local Parser = {}
Parser.__index = Parser

-- Explain a pattern error and point to the character that caused it.
local function failure(parser, message)
    return nil, message .. " at regular-expression character " .. tostring(parser.index) .. "."
end

-- Read the pattern character we are currently processing.
function Parser:Current()
    return string.sub(self.pattern, self.index, self.index)
end

-- Move past one pattern character if it is the expected one.
function Parser:Consume(character)
    if character ~= nil and self:Current() ~= character then
        return false
    end
    self.index = self.index + 1
    return true
end

-- Create a rule that matches one ordinary character.
local function literal(value)
    return { type = "literal", value = value }
end

-- Join character rules in order, simplifying an empty or single-rule sequence.
local function sequence(nodes)
    if #nodes == 0 then
        return { type = "empty_string" }
    end
    if #nodes == 1 then
        return nodes[1]
    end
    return { type = "concat", children = nodes }
end

-- Read an allowed or excluded character group such as [a-z] or [^0-9].
function Parser:ParseClass()
    self:Consume("[")
    local negated = false
    if self:Current() == "^" then
        negated = true
        self:Consume()
    end
    local ranges = {}
    local first = true
    while self.index <= #self.pattern do
        if self:Current() == "]" and not first then
            self:Consume()
            return { type = "class", negated = negated, ranges = ranges }, nil
        end
        first = false
        local left = self:Current()
        if left == "\\" then
            self:Consume()
            if self.index > #self.pattern then
                return failure(self, "RuneQL found an incomplete regex class escape")
            end
            left = self:Current()
        end
        self:Consume()
        local right = left
        if
            self:Current() == "-"
            and string.sub(self.pattern, self.index + 1, self.index + 1) ~= "]"
        then
            self:Consume()
            if self.index > #self.pattern then
                return failure(self, "RuneQL found an incomplete regex character range")
            end
            right = self:Current()
            if right == "\\" then
                self:Consume()
                if self.index > #self.pattern then
                    return failure(self, "RuneQL found an incomplete regex character range")
                end
                right = self:Current()
            end
            self:Consume()
        end
        if string.byte(left) > string.byte(right) then
            return failure(self, "RuneQL found a reversed regex character range")
        end
        ranges[#ranges + 1] = { string.byte(left), string.byte(right) }
    end
    return failure(self, "RuneQL found an unterminated regex character class")
end

-- Read quoted text that should match exactly within the pattern.
function Parser:ParseQuoted()
    self:Consume('"')
    local nodes = {}
    while self.index <= #self.pattern do
        local character = self:Current()
        if character == '"' then
            self:Consume()
            return sequence(nodes), nil
        end
        if character == "\\" then
            self:Consume()
            if self.index > #self.pattern then
                return failure(self, "RuneQL found an incomplete quoted regex escape")
            end
            character = self:Current()
        end
        nodes[#nodes + 1] = literal(character)
        self:Consume()
    end
    return failure(self, "RuneQL found an unterminated quoted regex string")
end

-- Read a range of numbers written as <10-20>.
function Parser:ParseInterval()
    local lower, upper = string.match(string.sub(self.pattern, self.index), "^<(%d+)%-(%d+)>")
    if lower == nil then
        return failure(self, "RuneQL regex named automata are unavailable without a provider")
    end
    if tonumber(lower) > tonumber(upper) then
        return failure(self, "RuneQL found a reversed regex numeric interval")
    end
    self.index = self.index + #lower + #upper + 3
    return {
        type = "interval",
        lower = tonumber(lower),
        upper = tonumber(upper),
        digits = #lower == #upper and #lower or nil,
    },
        nil
end

-- Read one character rule or a group of character rules.
function Parser:ParseAtom(depth)
    if depth > MAX_DEPTH then
        return failure(self, "RuneQL regex nesting is too deep")
    end
    local character = self:Current()
    if character == "" then
        return failure(self, "RuneQL expected a regex expression")
    elseif character == "(" then
        self:Consume()
        local node, reason = self:ParseUnion(depth + 1)
        if node == nil then
            return nil, reason
        end
        if not self:Consume(")") then
            return failure(self, "RuneQL found an unterminated regex group")
        end
        return node, nil
    elseif character == "[" then
        return self:ParseClass()
    elseif character == '"' then
        return self:ParseQuoted()
    elseif character == "<" then
        return self:ParseInterval()
    elseif character == "." then
        self:Consume()
        return { type = "any_character" }, nil
    elseif character == "@" then
        self:Consume()
        return { type = "any_string" }, nil
    elseif character == "#" then
        self:Consume()
        return { type = "empty_language" }, nil
    elseif character == "~" then
        self:Consume()
        local child, reason = self:ParseAtom(depth + 1)
        if child == nil then
            return nil, reason
        end
        return { type = "complement", child = child }, nil
    elseif character == "\\" then
        self:Consume()
        if self.index > #self.pattern then
            return failure(self, "RuneQL found an incomplete regex escape")
        end
        character = self:Current()
        self:Consume()
        return literal(character), nil
    elseif
        character == ")"
        or character == "|"
        or character == "&"
        or character == "?"
        or character == "*"
        or character == "+"
        or character == "{"
        or character == "}"
    then
        return failure(self, "RuneQL found an unexpected regex operator")
    end
    self:Consume()
    return literal(character), nil
end

-- Read how often a rule may repeat, using symbols such as * or {2,4}.
function Parser:ParseRepeat(depth)
    local node, reason = self:ParseAtom(depth)
    if node == nil then
        return nil, reason
    end
    while true do
        local character = self:Current()
        local minimum, maximum
        if character == "?" then
            minimum, maximum = 0, 1
            self:Consume()
        elseif character == "*" then
            minimum, maximum = 0, nil
            self:Consume()
        elseif character == "+" then
            minimum, maximum = 1, nil
            self:Consume()
        elseif character == "{" then
            local raw, first, comma, second =
                string.match(string.sub(self.pattern, self.index), "^(%{(%d+)(,?)(%d*)%})")
            if raw == nil then
                return failure(self, "RuneQL found an invalid regex repetition")
            end
            minimum = tonumber(first)
            maximum = comma == "" and minimum or tonumber(second)
            if minimum > MAX_REPEAT or (maximum ~= nil and maximum > MAX_REPEAT) then
                return failure(self, "RuneQL regex repetitions cannot exceed 1,000")
            end
            if maximum ~= nil and minimum > maximum then
                return failure(self, "RuneQL found a reversed regex repetition range")
            end
            self.index = self.index + #raw
        else
            break
        end
        node = { type = "repeat", child = node, minimum = minimum, maximum = maximum }
    end
    return node, nil
end

-- Read rules that must match one after another.
function Parser:ParseConcat(depth)
    local nodes = {}
    while self.index <= #self.pattern do
        local character = self:Current()
        if character == ")" or character == "|" or character == "&" then
            break
        end
        local node, reason = self:ParseRepeat(depth)
        if node == nil then
            return nil, reason
        end
        nodes[#nodes + 1] = node
    end
    return sequence(nodes), nil
end

-- Read & rules that must both match the same text.
function Parser:ParseIntersection(depth)
    local node = nil
    repeat
        local right, reason = self:ParseConcat(depth)
        if right == nil then
            return nil, reason
        end
        node = node and { type = "intersection", left = node, right = right } or right
    until not self:Consume("&")
    return node, nil
end

-- Read alternative patterns separated by |.
function Parser:ParseUnion(depth)
    local nodes = {}
    repeat
        local node, reason = self:ParseIntersection(depth)
        if node == nil then
            return nil, reason
        end
        nodes[#nodes + 1] = node
    until not self:Consume("|")
    if #nodes == 1 then
        return nodes[1], nil
    end
    return { type = "union", children = nodes }, nil
end

-- Remember one position where a pattern match can end.
local function add(target, value)
    target[value] = true
end

-- Combine possible match endings without keeping duplicates.
local function merge(target, source)
    for value in pairs(source) do
        target[value] = true
    end
end

-- Find every possible ending for this pattern rule, reusing earlier checks.
local function matchNode(node, text, startIndex, memo)
    local nodeMemo = memo[node]
    if nodeMemo == nil then
        nodeMemo = {}
        memo[node] = nodeMemo
    elseif nodeMemo[startIndex] ~= nil then
        return nodeMemo[startIndex]
    end

    local result = {}
    nodeMemo[startIndex] = result
    local kind = node.type
    if kind == "empty_string" then
        add(result, startIndex)
    elseif kind == "empty_language" then
        return result
    elseif kind == "literal" then
        if string.sub(text, startIndex, startIndex) == node.value then
            add(result, startIndex + 1)
        end
    elseif kind == "any_character" then
        if startIndex <= #text then
            add(result, startIndex + 1)
        end
    elseif kind == "class" then
        if startIndex <= #text then
            local byte = string.byte(text, startIndex)
            local matched = false
            for _, range in ipairs(node.ranges) do
                if byte >= range[1] and byte <= range[2] then
                    matched = true
                    break
                end
            end
            if node.negated then
                matched = not matched
            end
            if matched then
                add(result, startIndex + 1)
            end
        end
    elseif kind == "any_string" then
        for index = startIndex, #text + 1 do
            add(result, index)
        end
    elseif kind == "interval" then
        for finish = startIndex, #text do
            local raw = string.sub(text, startIndex, finish)
            if
                string.match(raw, "^%d+$") ~= nil
                and (node.digits == nil or #raw == node.digits)
            then
                local value = tonumber(raw)
                if value >= node.lower and value <= node.upper then
                    add(result, finish + 1)
                end
            end
        end
    elseif kind == "union" then
        for _, child in ipairs(node.children) do
            merge(result, matchNode(child, text, startIndex, memo))
        end
    elseif kind == "intersection" then
        local left = matchNode(node.left, text, startIndex, memo)
        local right = matchNode(node.right, text, startIndex, memo)
        for finish in pairs(left) do
            if right[finish] then
                add(result, finish)
            end
        end
    elseif kind == "complement" then
        local excluded = matchNode(node.child, text, startIndex, memo)
        for finish = startIndex, #text + 1 do
            if not excluded[finish] then
                add(result, finish)
            end
        end
    elseif kind == "concat" then
        local positions = { [startIndex] = true }
        for _, child in ipairs(node.children) do
            local nextPositions = {}
            for position in pairs(positions) do
                merge(nextPositions, matchNode(child, text, position, memo))
            end
            positions = nextPositions
            if next(positions) == nil then
                break
            end
        end
        merge(result, positions)
    elseif kind == "repeat" then
        local positions = { [startIndex] = true }
        local maximum = node.maximum or (#text - startIndex + 2 + node.minimum)
        for count = 0, maximum do
            if count >= node.minimum then
                merge(result, positions)
            end
            if count == maximum or next(positions) == nil then
                break
            end
            local nextPositions = {}
            for position in pairs(positions) do
                merge(nextPositions, matchNode(node.child, text, position, memo))
            end
            local changed = false
            for position in pairs(nextPositions) do
                if not positions[position] then
                    changed = true
                    break
                end
            end
            positions = nextPositions
            if not changed and node.maximum == nil then
                break
            end
        end
    end
    return result
end

-- Check a character pattern and prepare its matching rules.
function LuceneRegex.Compile(pattern)
    pattern = string.lower(tostring(pattern or ""))
    if pattern == "" then
        return nil, "RuneQL regular expressions cannot be empty."
    end
    local parser = setmetatable({ pattern = pattern, index = 1 }, Parser)
    local ast, reason = parser:ParseUnion(0)
    if ast == nil then
        return nil, reason
    end
    if parser.index <= #pattern then
        return failure(parser, "RuneQL could not parse the remainder of this regex")
    end
    return ast, nil
end

-- Check whether a prepared pattern matches the entire supplied word.
function LuceneRegex.Match(ast, value)
    if type(ast) ~= "table" then
        return false
    end
    value = string.lower(tostring(value or ""))
    local endings = matchNode(ast, value, 1, {})
    return endings[#value + 1] == true
end

return LuceneRegex
