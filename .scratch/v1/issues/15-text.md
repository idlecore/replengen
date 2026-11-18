# 15 — Bitmap-font text

Status: ready-for-agent
Type: task
Blocked by: 08

## What

The `:text` Component, rendered with Pixi bitmap fonts.

## Acceptance criteria

- `{:text "SCORE 0" :font :press-start :font-size 8 :color :white}` renders crisply. Changing the text every Tick doesn't re-rasterise the font.
- `.ttf` and `.woff2` files in `assets/fonts/` are converted to bitmap fonts at load time and referenced by keyword. They hot-swap like other Assets.
- A bundled default pixel font, with a license compatible with MIT, is used when `:font` is omitted.
- A missing font falls back to the default font with one warning.
- Single run of text only. Rich text and wrapping are deferred.

## References

- Grilling decision: Q33

## Comments
