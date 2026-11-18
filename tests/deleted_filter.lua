-- Run with Lua from the repository root; native client metadata is mocked.
local marker, nonbankable = {}, {}
local objects = {}
local function item(key, category, hidden, cannotBank)
    local values, params = {}, {}
    if hidden ~= nil then
        params[#params + 1], values[marker] = marker, hidden
    end
    if cannotBank ~= nil then
        params[#params + 1], values[nonbankable] = nonbankable, cannotBank
    end
    objects[key] = {
        id = #params + string.byte(key), configName = key, name = "Test item",
        category = category, params = params,
        GetParamValue = function(_, parameter) return values[parameter] end,
    }
end
config = { Param = { QUICKCHAT_DONT_LIST = marker, NONBANKABLE = nonbankable } }
config.Obj = setmetatable({ FromID = function() end }, { __index = objects })
item("ACTIVE", 1, nil, 0)
item("CATEGORY", 15, nil, 0)
item("PARAM", 1, 1, 0)
item("ZERO", 1, 0, 0)
item("FALSE", 1, false, 0)
item("BLOCKED", 15, 1, 1)
local api = require("resources/lib/api")
local catalog = api.Catalog
for key in pairs(objects) do assert(catalog.Get(key)) end
assert(catalog.IsDeleted("CATEGORY") == true)
assert(catalog.IsDeleted("PARAM") == true)
assert(catalog.IsDeleted("ZERO") == false)
assert(catalog.IsDeleted("FALSE") == false)
local _, count = catalog.Find("test")
assert(count == 3, tostring(count))
_, count = catalog.Find("test", 40, { includeDeleted = true })
assert(count == 6)
_, count = catalog.Search("*:*", 40)
assert(count == 3)
_, count = catalog.Search("*:*", 40, { includeDeleted = true, bankableOnly = true })
assert(count == 5)
local seen = 0
catalog.Each(function() seen = seen + 1 end)
assert(seen == 3)
seen = 0
catalog.Each(function() seen = seen + 1 end, { includeDeleted = true })
assert(seen == 6)
local default = assert(api.Compile("*:*"))
local included = assert(api.Compile("*:*", { includeDeleted = true }))
assert(default ~= included)
assert(default == api.Compile("*:*", { includeDeleted = false }))
assert(default:Evaluate({ configName = "CATEGORY" }) == false)
assert(included:Evaluate({ configName = "CATEGORY" }) == true)
assert(default:Requirements().configName)
assert(not included:Requirements().configName)
assert(api.CompileConfigSet({ "CATEGORY" }):Evaluate({ configName = "CATEGORY" }) == false)
assert(api.CompileConfigSet({ "CATEGORY" }, { includeDeleted = true }):Evaluate({ configName = "CATEGORY" }) == true)
assert(api.Compile("*:*", { includeDeleted = "yes" }) == nil)
assert(api.ScoreName("test", "Test item", { configName = "PARAM" }) == nil)
assert(api.ScoreName("test", "Test item", { configName = "PARAM" }, { includeDeleted = true }) ~= nil)
-- Missing client metadata must remain searchable and be retried once available.
assert(catalog.IsDeleted("LATE") == nil)
item("LATE", 15)
assert(catalog.IsDeleted("LATE") == true)
assert(catalog.Get("CATEGORY") ~= nil)
print("deleted item filtering passed")
