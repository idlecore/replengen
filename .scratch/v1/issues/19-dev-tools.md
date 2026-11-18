# 19 — Dev inspection tools

Status: ready-for-agent
Type: task
Blocked by: 17

## What

`tap>` helpers, the per-System timing meter, and debug drawing.

## Acceptance criteria

- `(engen/tap-entity id)` taps the Entity every Tick, or only when it changes. `(engen/tap-effects)` taps each Tick's Effects. Both can be stopped by calling them again or with an `untap-*` function.
- Both work with any `tap>` viewer (Portal, Reveal, Calva) with no dependency on a specific one.
- The timing meter in the dev overlay shows each System's time per Tick (smoothed) and the total compared with the 4ms budget, and highlights any System over budget.
- `(engen/debug-draw! true)` draws collider outlines (coloured by Collision Group), the Camera deadzone and bounds, and Spawn Marker positions.
- None of this is present in release builds.

## References

- Grilling decisions: Q32, Q34

## Comments
