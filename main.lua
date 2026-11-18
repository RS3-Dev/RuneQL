-- Start RuneQL with fresh code and share its search tools with other plugins.
if package ~= nil and package.loaded ~= nil then
    for moduleName in pairs(package.loaded) do
        if type(moduleName) == "string" and moduleName:sub(1, 10) == "resources/" then
            package.loaded[moduleName] = nil
        end
    end
end

local API = require("resources/lib/api")
local ClientIndex = require("resources/lib/catalog/client_index")
_G.__runeql_api = API
ClientIndex.Start()

log(
    "RuneQL Core loaded; API v",
    API.API_VERSION,
    ", language v",
    API.LANGUAGE_VERSION,
    ", Lucene ",
    API.LUCENE_DIALECT
)

-- Stop sharing this copy of RuneQL when the plugin closes.
function PluginShutdown()
    if rawget(_G, "__runeql_api") == API then
        ClientIndex.Stop()
        _G.__runeql_api = nil
    end
end

return API
