# 13 — Camera

Status: ready-for-agent
Type: task
Blocked by: 07, 11

## What

The Camera stored as World data, the built-in `:replengen/camera` System (in `replengen.camera`, `.cljc`), and the platform render transform.

## Acceptance criteria

- World `:camera {:position [x y] :follow id :deadzone [w h] :bounds :tilemap :zoom n}`.
- `:replengen/camera` follows the Entity with the given id, inside the deadzone, clamped to the bounds (the Tilemap's extents, or an explicit rect).
- It does nothing when `:follow` is unset or the Entity is gone.
- The renderer transforms world-space Layers by the Camera. Screen-space Layers are unaffected.
- Pointer coordinates (issue 09) convert through the Camera.
- `swap!` on `:camera` at the REPL takes effect on the next frame, e.g. following another Entity or zooming.
- Headless tests for following, the deadzone and clamping.

## References

- GLOSSARY: Camera, Layer; Grilling decision: Q24

## Comments
