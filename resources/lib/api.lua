-- Share the search tools and catalog through one API for other plugins.
local Catalog = require("resources/lib/catalog/catalog")
local Compiler = require("resources/lib/query/compiler")

local RuneQL = {
    API_VERSION = 2,
    LANGUAGE_VERSION = 3,
    VERSION = "1.0.2",
    MAX_QUERY_LENGTH = Compiler.MAX_QUERY_LENGTH,
    MAX_CLAUSES = Compiler.MAX_CLAUSES,
    LUCENE_DIALECT = "classic-10.3",
    Catalog = Catalog,
}

RuneQL.Compile = Compiler.Compile
RuneQL.CompileConfigSet = Compiler.CompileConfigSet
RuneQL.Parse = Compiler.Parse
RuneQL.IsPlan = Compiler.IsPlan

-- Score how well an item name and its details match the search.
function RuneQL.ScoreName(query, name, item, options)
    query = tostring(query or "")
    local plan = Compiler.Compile(query, options)
    if plan == nil then
        return nil
    end
    local row = {
        name = name ~= nil and tostring(name) or nil,
        configName = type(item) == "table" and item.configName or nil,
        quantity = type(item) == "table" and item.quantity or nil,
        fields = type(item) == "table" and item.fields or nil,
    }
    return plan:Score(row)
end

-- List the search features this version supports.
function RuneQL.Capabilities()
    return {
        luceneClassic = "10.3",
        name = true,
        terms = true,
        phrases = true,
        fields = true,
        boolean = true,
        grouping = true,
        requiredProhibited = true,
        escaping = true,
        ranges = true,
        wildcard = true,
        fuzzy = true,
        alternatives = false,
        callerSources = true,
        catalog = true,
        catalogAttributes = true,
        catalogCategories = true,
        catalogFieldMetadata = true,
        catalogFieldValues = true,
        catalogSearch = true,
        bankableFilter = true,
        deletedFilter = true,
        regex = true,
        structuredPredicates = true,
        configIdentity = true,
        proximity = true,
        boosting = true,
    }
end

return RuneQL
