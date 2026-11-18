# 06 — Platform loop and hot reload

Status: ready-for-agent
Type: task
Blocked by: 05

## What

The browser game loop in `replengen.platform.loop`, plus `start!` and the loop controls exported from `replengen.core`.

## Acceptance criteria

- `(engen/start! game)` creates the Pixi application at `:size`, builds the World, and starts a `requestAnimationFrame` loop. Calling it again replaces the Game but keeps the World.
- Fixed timestep: real time accumulates, and 60 Ticks per second run by default. The number of catch-up Ticks per frame is capped. The latest World is rendered once per frame (rendering itself is issue 07).
- `pause!`, `resume!`, `step!` (exactly one Tick) and `set-speed!`.
- `engen/world` is the public atom. `swap!` on it from the REPL is reflected on the next frame.
- Hot reload: after shadow-cljs reloads code, the next Tick uses the re-registered Systems and the current Game map (`:systems` order, `:controls`, `:layers`). The World is untouched.
- `(engen/reset!)` rebuilds the World from the active Scene's `:init`. `(engen/goto! :scene)` switches Scene from the REPL.
- Effects that the core passes out of the Tick are sent to platform handlers (audio arrives in issue 16).
- Nothing here assumes the game runs in a browser tab. No URL routing, and no required `localStorage` (deferred desktop packaging).

## References

- `docs/architecture.md`: Tick pipeline, Hot reload
- Grilling decisions: Q11, Q13, Q19

## Comments
