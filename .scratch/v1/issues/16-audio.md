# 16 — Audio

Status: ready-for-agent
Type: task
Blocked by: 08

## What

`:sound/*` Effects played through `@pixi/sound`, in `replengen.platform.audio`.

## Acceptance criteria

- `[:sound/play :coin]` plays `assets/sounds/coin.*`. Optional options map `{:volume :rate}`.
- Sound Effects are run by the platform layer after the Tick (issue 06), never from inside core.
- Ticks re-run during `replay!` (issue 18) do *not* play sound by default.
- The browser's autoplay restriction is handled: audio unlocks on the first input, with no errors before that.
- A missing sound logs one warning and does not crash.
- The `@pixi/sound` dependency sits behind a small internal interface so it can be swapped for another audio library.

## References

- Grilling decisions: Q10, Q17 follow-up (audio choice)

## Comments
