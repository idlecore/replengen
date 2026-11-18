# 11 — Text-grid Tilemaps and Spawn Markers

Status: ready-for-agent
Type: task
Blocked by: 05, 07

## What

Text-grid Tilemaps (`replengen.tilemap`, `.cljc`) and Tilemap rendering (in the platform layer).

## Acceptance criteria

- `(engen/tilemap legend rows)` returns Tilemap data. The legend maps characters to Tile keywords or Spawn Marker keywords, and rows are strings. Tile size is configurable, defaulting to 16.
- Tilemap data does not depend on the text format. The text grid is only one loader, so LDtk can be added later.
- Each Tile type declares metadata (`:solid?` and the sprite to draw), e.g. through a `reg-tile` or a Tile map in the Game.
- Spawn Markers become Entities through spawn functions registered by keyword, `(engen/spawn :player (fn [pos] {...}))`, when a level is loaded and on `reset!`.
- Helper functions: `tile-at`, and `tiles-in-rect` (for issue 12).
- Rendering: the Tilemap draws as a batched world-space Layer, never as one Entity per Tile.
- Re-evaluating the Tilemap definition at the REPL replaces the World's Tile grid live and keeps existing Entities.
- Errors for an unknown legend character (naming the row and column) and for ragged rows.

## References

- GLOSSARY: Tilemap, Tile, Spawn Marker
- Grilling decisions: Q21, Q22

## Comments
