-- Split search text into words, phrases, and search symbols.
local Lexer = {}

local SPECIAL = {
    ["("] = "LPAREN",
    [")"] = "RPAREN",
    [":"] = "COLON",
    ["+"] = "PLUS",
    ["-"] = "MINUS",
    ["!"] = "NOT",
    ["["] = "RANGE_INCLUSIVE",
    ["{"] = "RANGE_EXCLUSIVE",
    ["]"] = "RANGE_END_INCLUSIVE",
    ["}"] = "RANGE_END_EXCLUSIVE",
    ["~"] = "TILDE",
    ["^"] = "BOOST",
}

-- Keep one search word or symbol together with its position in the text.
local function token(kind, value, raw, position)
    return { kind = kind, value = value, raw = raw or value, position = position }
end

-- Explain a reading error and point to the character that caused it.
local function failure(message, position)
    return nil, message .. " at character " .. tostring(position) .. "."
end

local DELIMITED = {
    ['"'] = {
        kind = "PHRASE",
        incomplete = "RuneQL found an incomplete escape",
        unterminated = "RuneQL found an unterminated quoted phrase",
    },
    ["/"] = {
        kind = "REGEX",
        keepEscapes = true,
        incomplete = "RuneQL found an incomplete regular expression escape",
        unterminated = "RuneQL found an unterminated regular expression",
    },
}

-- Read a quoted phrase or character pattern up to its closing mark.
local function delimited(query, startIndex)
    local closing = string.sub(query, startIndex, startIndex)
    local style = DELIMITED[closing]
    local value = {}
    local index = startIndex + 1
    while index <= #query do
        local character = string.sub(query, index, index)
        if character == "\\" then
            if index == #query then
                return failure(style.incomplete, index)
            end
            local escaped = string.sub(query, index + 1, index + 1)
            value[#value + 1] = style.keepEscapes and "\\" .. escaped or escaped
            index = index + 2
        elseif character == closing then
            local raw = string.sub(query, startIndex, index)
            return token(style.kind, table.concat(value), raw, startIndex), nil, index + 1
        else
            value[#value + 1] = character
            index = index + 1
        end
    end
    return failure(style.unterminated, startIndex)
end

-- Read one search word and recognise words such as AND and OR.
local function term(query, startIndex)
    local value = {}
    local escaped = {}
    local index = startIndex
    while index <= #query do
        local character = string.sub(query, index, index)
        if
            string.match(character, "%s") ~= nil
            or SPECIAL[character] ~= nil
            or character == '"'
            or character == "/"
        then
            break
        end
        if character == "&" and string.sub(query, index, index + 1) == "&&" then
            break
        end
        if character == "|" and string.sub(query, index, index + 1) == "||" then
            break
        end
        if character == "\\" then
            if index == #query then
                return failure("RuneQL found an incomplete escape", index)
            end
            local nextCharacter = string.sub(query, index + 1, index + 1)
            value[#value + 1] = nextCharacter
            escaped[#value] = true
            index = index + 2
        else
            value[#value + 1] = character
            index = index + 1
        end
    end
    if #value == 0 then
        return failure("RuneQL could not read this query token", startIndex)
    end

    local decoded = table.concat(value)
    local kind = "TERM"
    if next(escaped) == nil then
        if decoded == "AND" then
            kind = "AND"
        elseif decoded == "OR" then
            kind = "OR"
        elseif decoded == "NOT" then
            kind = "NOT"
        elseif decoded == "TO" then
            kind = "TO"
        end
    end
    local result = token(kind, decoded, string.sub(query, startIndex, index - 1), startIndex)
    result.escaped = escaped
    return result, nil, index
end

-- Break the complete search into readable pieces and report invalid symbols.
function Lexer.Tokenize(query)
    query = tostring(query or "")
    local tokens = {}
    local index = 1
    while index <= #query do
        local character = string.sub(query, index, index)
        if string.match(character, "%s") ~= nil then
            index = index + 1
        elseif string.sub(query, index, index + 1) == "&&" then
            tokens[#tokens + 1] = token("AND", "AND", "&&", index)
            index = index + 2
        elseif string.sub(query, index, index + 1) == "||" then
            tokens[#tokens + 1] = token("OR", "OR", "||", index)
            index = index + 2
        elseif character == "&" or character == "|" then
            return failure("RuneQL expected && or ||", index)
        elseif SPECIAL[character] ~= nil then
            tokens[#tokens + 1] = token(SPECIAL[character], character, character, index)
            index = index + 1
        else
            local reader = DELIMITED[character] ~= nil and delimited or term
            local result, reason, nextIndex = reader(query, index)
            if result == nil then
                return nil, reason
            end
            tokens[#tokens + 1], index = result, nextIndex
        end
    end
    tokens[#tokens + 1] = token("EOF", "", "", #query + 1)
    return tokens, nil
end

return Lexer
