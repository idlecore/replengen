# 12 — Kinematic movement against Tiles

Status: ready-for-agent
Type: task
Blocked by: 10, 11

## What

The built-in `:replengen/move` System, in `replengen.move` (`.cljc`).

## Acceptance criteria

- It applies `:gravity` to `:velocity`, then integrates `:velocity` with the fixed `dt`.
- For colliders with `:solid-tiles? true`, it moves on the X axis and resolves against solid Tiles, then does the same on the Y axis. On contact it clears the velocity component on that axis.
- It writes `:touching` as the set of sides currently against a solid Tile.
- Only the Tiles under the swept collider are examined.
- Exact Tile edges don't cause jitter.
- No tunnelling at speeds up to one Tile per Tick. The supported maximum speed is documented.
- Entities without `:solid-tiles?` just integrate.
- Headless tests: landing, head bumps, wall slides, corners, standing still on the ground over 1,000 Ticks, and a fall-through check at high speed.
- Built so it can be extended or replaced later (slopes, moving platforms).

## References

- Grilling decisions: Q21, Q23

## Comments
