# 10 — Collision detection and Contacts

Status: ready-for-agent
Type: task
Blocked by: 04

## What

The `:collider` Component and the built-in `:replengen/detect-collisions` System, in `replengen.collision` (`.cljc`). It detects Contacts only and does no physics response.

## Acceptance criteria

- `:collider {:shape :rect :size [w h]}` or `{:shape :circle :radius r}`, each with a `:group`. Optional `:offset` from `:position`.
- `:replengen/detect-collisions` is a registered System that users place in `:systems` explicitly.
- It builds a spatial hash and records the overlapping pairs as this Tick's Contacts under `:replengen/contacts`. Contacts are replaced every Tick.
- `(engen/contacts world :player :enemy)` returns `[player-id enemy-id]` pairs, ordered to match the order the groups were asked for.
- Overlap tests are correct for rect vs rect, circle vs circle and rect vs circle, including edges and touching-but-not-overlapping cases.
- Tests run headlessly, with a benchmark hook ready for issue 20.

## References

- GLOSSARY: Collision Group, Contact
- Grilling decisions: Q17, Q23 (one collider shape)

## Comments
