# 21 — Platformer example (v1 yardstick)

Status: ready-for-agent
Type: task
Blocked by: 12, 13, 14, 15, 16, 18

## What

An original platformer in `examples/platformer`, built only on `replengen.core :as engen`. This issue proves the v1 spec's "Done when" list.

## Acceptance criteria

- Gameplay:
  - a player who runs and jumps (variable-height jump: releasing early cuts the jump short)
  - walking enemies that turn at walls and ledges and are stomped from above; touching one from the side costs a life
  - coins and a score HUD
  - a goal flag that ends the level
  - title, play and game-over Scenes, with lives and the high score in the Session
- Uses original or CC0 placeholder art, sounds and levels. Nothing taken from existing commercial games.
- A text-grid level about 200 Tiles wide, with a following Camera.
- `test/` contains headless tests of the example's game logic: stomping, collecting coins, dying, Scene changes.
- A `WALKTHROUGH.md` in the example scripts the live-REPL demo:
  - change jump height while standing on a ledge
  - add a coin row to the Tilemap
  - swap a sprite
  - introduce a bug, watch it pause, fix it, watch it resume
  - rewind and replay a jump with new gravity
- Every step in `WALKTHROUGH.md` works without a page reload. Verify and tick them off in this issue's comments.

## References

- `.scratch/v1/spec.md`; Grilling decision: Q21

## Comments
