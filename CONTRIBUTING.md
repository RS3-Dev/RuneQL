# Contributing

Keep RuneQL small, readable and focused on shared item search, query evaluation,
and catalog metadata. Bank interfaces and tag layouts belong in consuming plugins.

- Open an issue before adding or changing a public API so we can discuss the need
  and how other plugins would use it.
- Keep pull requests focused. Avoid unrelated rewrites, new dependencies and
  abstractions that make a simple change harder to follow.
- Use clear names and short comments that a new junior developer can follow.
  Explain necessary technical terms in plain language; avoid repeating the code.
- AI assistance is welcome, but you must understand and review everything you
  submit. Do not submit code you cannot explain or maintain.
- Do not use AI to generate your PR body. The PR body must be handwritten.
  Pull requests with AI-generated bodies will be closed.
- Run `lua tests/deleted_filter.lua` with Lua 5.4 from the repository root.
  See the [test instructions](README.md#tests) for details.
- Try your changes in RuneScape. Check initial indexing, plugin reloads, item
  searches and a consuming plugin such as Bank Tags. For filter changes, check
  bankable, non-bankable, deleted and unknown-metadata items.
- For catalog corrections, include example item config names and the evidence
  behind the classification. Preserve source attribution and licensing.
- Explain what changed, why, how you checked it and any problems still known.
  Update the docs or examples when their behavior changes.

Code contributions use the project's [BSD-2-Clause license](LICENSE).
