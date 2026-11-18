# 01 — Project skeleton

Status: ready-for-agent
Type: task
Blocked by: —

## What

Set up the monorepo so that every later issue has somewhere to land.

## Acceptance criteria

- `deps.edn` (the library), `shadow-cljs.edn` (dev builds for examples and tests), and `package.json` with `pixi.js` v8 and `@pixi/sound`.
- MIT `LICENSE`.
- `src/replengen/core.cljc` exists as the public API namespace, empty except for its ns docstring.
- An empty `src/replengen/platform/` directory.
- Directory structure matches the "Repository layout" section of `docs/architecture.md`, with `test/`, `bench/`, `examples/platformer/` and `template/` stubs.
- Tests run on the JVM (`clojure -X:test`, or equivalent) and in Node (a shadow-cljs `:node-test` build). A trivial test passes in both.
- A check that fails if any `.cljc` file under `src/replengen/` (other than `platform/`) requires a `replengen.platform.*` namespace, a `js/` global or `pixi`. ADR 0004.
- CI runs both test targets and the platform-dependency check.
- The npm script `npm run dev` starts a shadow-cljs watch for `examples/platformer`, using a placeholder page.

## References

- ADR 0001, ADR 0004
- `docs/architecture.md`: Repository layout

## Comments
