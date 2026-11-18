# 08 — Assets

Status: ready-for-agent
Type: task
Blocked by: 07

## What

Resolve Asset keywords by file-path convention, load them, hot-swap them when files change, and show placeholders for missing ones. Lives in `replengen.platform.assets`.

## Acceptance criteria

- `assets/sprites/hero.png` is available as `:hero`. If two files would produce the same keyword, the folder-qualified form (`:sprites/hero`) is required and a warning says so.
- `:assets` in the Game overrides or adds metadata per keyword: renaming, grid spritesheet `:frames [w h]`, a sound's default volume.
- Loading uses Pixi `Assets`, and the loop starts only after the initial load has finished.
- A missing Asset renders as a magenta placeholder of a sensible size and logs exactly one warning, naming the keyword and the paths searched.
- In dev, changing an Asset file replaces the texture (or sound, or font) in the running game within about one second, with no reload and no change to the World.

## Open implementation question

The mechanism for hot-swapping Asset files. One option is a small dev-time file watcher that notifies the browser through the shadow-cljs dev server or a websocket. Another is shadow-cljs's own `:watch-dir` hooks. The convention-based lookup also needs a manifest of which files exist; decide whether it's generated at build time or served by a dev endpoint. Record the choice in the ns docstring.

## References

- GLOSSARY: Asset; Grilling decision: Q15

## Comments
