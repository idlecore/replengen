# 05 — Game declaration, Scenes and Session

Status: ready-for-agent
Type: task
Blocked by: 04

## What

The Game map, the active Scene, switching Scenes, and the Session, in `replengen.scene` (`.cljc`).

## Acceptance criteria

- The Game map has `:title`, `:size`, `:start`, `:scenes`, `:controls`, `:layers` and `:assets`, with the shape given in `docs/architecture.md`.
- A Game without `:scenes`, with `:init` and `:systems` at the top level, is treated as a single implicit Scene.
- `(init-world game)` builds a World for the `:start` Scene from that Scene's `:init`.
- The `[:scene/goto :play]` Effect replaces `:entities` (and the Tilemap and Camera) using the target Scene's `:init`, and keeps `:session` and the id counter.
- The Tick uses the active Scene's `:systems`.
- The Game map is validated with clear errors: missing `:init`, an unknown `:start` Scene, a malformed `:layers` entry.
- Tests: switching Scenes keeps the Session, and an implicit Scene works.

## References

- GLOSSARY: Game, Scene, Session
- Grilling decisions: Q13, Q14

## Comments
