-- Share optional item restrictions across catalog searches and prepared queries.
local ClientIndex = require("resources/lib/catalog/client_index")
local Filter = {}

-- Searches exclude native deletion markers unless includeDeleted is true.
-- Validate shared search options without changing the caller's table.
function Filter.Parse(options, allowFieldSelection)
    if options == nil then
        return false
    end
    if type(options) ~= "table" then
        return nil, "Options must be a table"
    end
    for key in pairs(options) do
        if key ~= "bankableOnly" and key ~= "includeDeleted" and not (allowFieldSelection and key == "includeFields") then
            return nil, "Unknown item filter option: " .. tostring(key)
        end
    end
    if options.bankableOnly ~= nil and type(options.bankableOnly) ~= "boolean" then
        return nil, "bankableOnly must be a boolean"
    end
    if options.includeFields ~= nil and type(options.includeFields) ~= "boolean" then
        return nil, "includeFields must be a boolean"
    end
    if options.includeDeleted ~= nil and type(options.includeDeleted) ~= "boolean" then
        return nil, "includeDeleted must be a boolean"
    end
    return options.bankableOnly == true
end

-- Hide deleted cache entries by default, independently of banking restrictions.
function Filter.Allows(configName, bankableOnly, includeDeleted)
    if not includeDeleted and ClientIndex.IsDeleted(configName) == true then
        return false
    end
    return not bankableOnly or ClientIndex.IsBankable(configName) == true
end

return Filter
