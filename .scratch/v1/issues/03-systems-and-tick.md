# 03 — Systems and the Tick

Status: ready-for-agent
Type: task
Blocked by: 02

## What

`defsystem`, the System registry, and a pure `tick` function, in `replengen.system` and `replengen.tick` (`.cljc`).

## Acceptance criteria

- `(defsystem name {:query [...]} (fn [entity ctx] ...))` defines a per-entity System, and `(defsystem name {:raw true} (fn [world ctx] ...))` defines a raw one. Both register under a namespaced keyword (`::name`) in a registry.
- Re-evaluating a `defsystem` replaces its registry entry, so the next Tick uses the new code.
- The registry is looked up by keyword at Tick time. Systems are never captured as closures in the World or the Game.
- `(tick world systems ctx)` runs the Systems in order and returns the new World with `:replengen/tick` incremented. It returns Effects separately (wired up in issue 04).
- A per-entity System runs on every Entity that has all of its `:query` keys. The results are applied in one batched update (transients or equivalent).
- `ctx` contains `:dt` (fixed), `:tick`, `:input` and `:game`.
- An unknown System keyword raises a clear error naming the keyword and listing the closest registered matches.
- In dev builds, the function guard from issue 02 runs after each Tick and warns about any function values found in the World.
- Tests: ordering, query matching, re-registration, determinism (the same inputs give an identical World).

## References

- ADR 0003; GLOSSARY: System, Tick
- Grilling decisions: Q8 (Systems only), Q9 (two tiers), Q11 (fixed timestep)

## Comments
