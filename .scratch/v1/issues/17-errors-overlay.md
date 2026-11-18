# 17 — Atomic Ticks and the error overlay

Status: ready-for-agent
Type: task
Blocked by: 06

## What

Ticks are atomic, errors pause the game, and there's a dev overlay, in `replengen.platform.overlay` plus wrapping in the loop.

## Acceptance criteria

- If any System or Effect handler throws, the Tick is discarded. `engen/world` keeps the last good World and the loop pauses.
- Errors are wrapped with context: the System keyword and its source location if available, the Entity id and Entity (for per-entity Systems), the Tick number, and the original exception.
- The dev overlay shows the System, the Entity, the error, and how to recover ("fix and save", `resume!`, `reset!`).
- Saving a fix triggers a hot reload that automatically retries the failed Tick and resumes if it succeeds.
- `(engen/last-error)` returns `{:system :entity :world :ctx :error}`. `(engen/retry!)` re-runs that Tick.
- The same path handles invalid Effects and System keywords that aren't registered.
- Release builds log the error once per System and skip the failing Tick. No overlay.
- The overlay is drawn on its own layer that Game code can't reach.

## References

- Grilling decision: Q26

## Comments
