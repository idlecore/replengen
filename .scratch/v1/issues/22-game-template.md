# 22 — Game template

Status: ready-for-agent
Type: task
Blocked by: 21

## What

A `deps-new` template, so that `clojure -Tnew create :template replengen/game :name me/my-game` produces a working project.

## Acceptance criteria

- The generated project contains:
  - `deps.edn`, `shadow-cljs.edn` and `package.json`
  - `src/<name>/core.cljs`: a steerable, jumping character on a small text-grid level
  - `assets/` with placeholder art and the default font
  - `test/`, with one headless test
  - a README
- `npm install && npm run dev` opens the browser with the game running and an nREPL available. The README states the port and gives connection notes for CIDER, Calva and Cursive.
- Generated code uses `(:require [replengen.core :as engen])` and only the public API.
- CI generates a project from the template and runs its test.

## References

- Grilling decisions: Q19, Q29/Q30 (naming)

## Comments
