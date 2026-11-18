# RuneQL

RuneQL gives RuneScape client plugins a shared item catalog and query API. It combines item names from the client with bundled categories and attributes, so plugins can search by name, item identity, and item details.

## Before you start

Enable **RuneQL** in the client's plugin manager before using a plugin that needs it, such as [Bank Tags](https://github.com/RS3-Dev/BankTags). RuneQL is a library; it has no separate interface to open.

The item name index builds in the background when RuneQL loads. Searches can return partial results until indexing finishes. Plugins can check `Catalog.IndexStatus()` for progress.

## Manual installation

Download a release ZIP from the [releases page](https://github.com/RS3-Dev/RuneQL/releases) and extract it into a `runeql` folder in your RuneScape beta client's plugins directory. `main.lua`, `plugin.json`, and `resources/` should sit directly inside that folder. Enable RuneQL in the plugin manager.

## Use the API

RuneQL publishes its API as `_G.__runeql_api` while enabled. Check for it before searching, and obtain it again after a plugin reload.

```lua
local runeql = rawget(_G, "__runeql_api")
if runeql then
    local results, total, reason = runeql.Catalog.Search("category:potions", 40)
    if results then
        for _, item in ipairs(results) do
            print(item.configName, item.displayName)
        end
    end
end
```

- `Catalog.Find(text, limit, options)` searches item names.
- `Catalog.Search(query, limit, options)` searches names and structured fields.
- `Catalog.Get(configName)` looks up an item by its stable internal name.
- `Catalog.GetFields(configName)` reads bundled attributes without waiting for the name index.
- `Catalog.Categories()`, `Catalog.Fields()`, and `Catalog.Values(fieldKey, options)` expose category and field information for search interfaces.
- `Compile(query, options)` returns a reusable plan, or `nil` and an error. Use `plan:Evaluate(row)` to get a match, score, and evidence, or `plan:Score(row)` for a score.
- `CompileConfigSet(configNames, options)` builds a plan from internal item names.
- `Capabilities()` lists supported search features.

Queries support terms, quoted phrases, field filters, Boolean operators, grouping, ranges, wildcards, fuzzy matching, regular expressions, proximity, and boosting. For example, `category:potions` restricts results to finished potions. Category keys are available through `Catalog.Categories()`; use these keys when constructing filters.

## Item filtering

Searches and compiled plans exclude items marked deleted by native client metadata by default. Pass `{ includeDeleted = true }` to include them. Items with unavailable deletion metadata remain searchable.

Pass `{ bankableOnly = true }` to require confirmed bankability from the client. Items with unavailable bankability metadata are excluded by this option. Both options can be combined:

```lua
local results, total, reason = runeql.Catalog.Find("rune", 40, {
    bankableOnly = true,
    includeDeleted = false,
    includeFields = false,
})
```

`includeFields = false` is supported by `Catalog.Find` to omit bundled attributes from results. `Catalog.IsBankable(configName)` and `Catalog.IsDeleted(configName)` return `true`, `false`, or `nil` when the client metadata is unavailable. Direct `Catalog.Get` lookups remain available for deleted items.

## Tests

Run from the repository root with Lua 5.4:

```sh
lua tests/deleted_filter.lua
```

The regression test mocks native client metadata and checks deleted-item filtering, bankability, query caching, catalog iteration, and explicit item lookups. It runs outside the game client without a test framework. Also try changes in RuneScape, including initial indexing, reloads, and searches through a consuming plugin.

## Contributing and license

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines. RuneQL code uses the [BSD-2-Clause license](LICENSE).
