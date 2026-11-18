# 02 — World and Entities

Status: ready-for-agent
Type: task
Blocked by: 01

## What

The World data shape, plus pure functions for creating, reading and removing Entities, in `replengen.world` (`.cljc`).

## Acceptance criteria

- A World is a map containing `:entities` (id → Entity), `:session`, `:replengen/tick` and `:replengen/next-id`.
- `spawn`: Entity map → `[world' id]` (or a threading-friendly variant). The id is the Entity's `:replengen/id` if it has one, otherwise a generated `:e/<n>` taken from `:replengen/next-id` in the World. That keeps ids deterministic under replay.
- Spawning a duplicate explicit `:replengen/id` throws an `ex-info` error that names the id.
- `destroy`, `entity` (lookup) and `query` (Entities that have all the given Component keys).
- Dev-mode function guard: a helper that walks a World and reports the path of any function value. It is called by the Tick in dev builds (issue 03).
- Tests run on the JVM and in Node.

## Notes

- Component vectors are `[x y]`. Don't bake 2D into anything other than the built-in Components (deferred 3D).

## References

- ADR 0003; GLOSSARY: World, Entity, Component
- Grilling decisions: Q6 (Entity maps by id), Q7 (World is pure data), Q28 (ids)

## Comments
