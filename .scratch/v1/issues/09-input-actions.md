# 09 — Input and Actions

Status: ready-for-agent
Type: task
Blocked by: 06

## What

Named Actions bound in `:controls`, with an input snapshot taken once per Tick. The pure query functions live in `replengen.input` (`.cljc`) and DOM capture lives in `replengen.platform.input`.

## Acceptance criteria

- `:controls {:jump [:space :w] ...}` binds Actions to keys and mouse buttons.
- The platform layer gathers DOM events between Ticks. Each Tick gets one immutable snapshot in `(:input ctx)`.
- `down?`, `pressed?` (went down during this Tick) and `released?` take an Action, or a raw key such as `:key/space`.
- The pointer position is available in World coordinates. That conversion depends on the Camera: use the identity transform until issue 13.
- `(engen/bind! :jump [:x])` rebinds an Action live.
- Snapshots are plain data and can be recorded, which issue 18 needs.
- The core query functions are tested headlessly with synthetic snapshots.
- Actions are not tied to keys anywhere in the design, so gamepad and touch input can be added later.

## References

- GLOSSARY: Action; Grilling decision: Q16

## Comments
