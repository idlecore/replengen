# 14 — Sprite Animation

Status: ready-for-agent
Type: task
Blocked by: 08

## What

Animations from Aseprite JSON exports and grid spritesheets. The current frame is derived from the Ticks elapsed since `:sprite` changed.

## Acceptance criteria

- `hero.png` plus `hero.json` (an Aseprite export with tags) provide the Animation keywords `:hero/idle`, `:hero/run` and so on, with per-frame durations. Loop direction follows the tag, at least forward and ping-pong.
- A grid spritesheet declared with `:assets {:hero {:frames [16 16] :animations {:run {:frames [0 1 2 3] :fps 10}}}}` works the same way.
- The core records `:replengen/sprite-since` (the Tick at which `:sprite` last changed). Setting the same `:sprite` again does not restart the Animation.
- The renderer computes the frame purely from `tick - sprite-since` and the Animation's timings, so pausing, stepping and replay all freeze or reproduce the Animation exactly.
- Re-exporting the JSON hot-swaps timings live (issue 08).
- Headless tests cover frame derivation.

## References

- GLOSSARY: Animation; Grilling decision: Q25

## Comments
