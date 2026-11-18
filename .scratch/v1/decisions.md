# v1 design decisions (grilling session, 2026-11-18)

The issues cite these as "Grilling decision: Qn". The four decisions with lasting consequences also have ADRs (`docs/adr/`).

| Q | Decision |
|---|---|
| 1 | 2D only for v1. The core abstractions must not rule out 3D. |
| 2 | Web and desktop are equal targets. JVM engines can't run Clojure in the browser, so the engine is ClojureScript on a JS engine, with desktop as a wrapped web build. **ADR 0001** |
| 3 | PixiJS v8 is used purely as the renderer. replengen owns the model, loop, input, collision and Scenes. **ADR 0002** |
| 4 | The audience has a little Clojure and a little game-dev experience. A clean, simple, efficient Clojure API is the priority, and game-dev concepts are fine where they help. |
| 5 | The whole game is one immutable World, advanced by pure functions, with rendering derived from it. A mutable escape hatch comes later. **ADR 0003** |
| 6 | Entities are maps stored by id, and Components are keys on those maps (ECS-lite). Storage layout is internal. |
| 7 | The World is pure data. Behaviour is referenced by keyword through a registry, and the engine warns when a function value ends up in the World. |
| 8 | Systems are the only place logic lives. No per-Entity behaviours or scripts. |
| 9 | Systems come in two tiers: query plus per-entity function (default), and raw World → World. Both receive `ctx`. |
| 10 | Side effects are Effects: data collected during the Tick and run afterwards by keyword-registered handlers. Returning nil from a per-entity System destroys the Entity. |
| 11 | A fixed timestep of 60 Ticks per second, independent of rendering. `pause!`, `step!`, `resume!` and `set-speed!`. |
| 12 | Rendering by convention from renderable Components, reconciled by Entity id, ordered by `:layer` and `:z`. No user-written render function. |
| 13 | The Game is one data map with an ordered `:systems` list. Hot reload keeps the World, and `reset!` rebuilds it explicitly. |
| 14 | Named Scenes, one active at a time, switched with the `:scene/goto` Effect. The Session survives the switch. A Game without `:scenes` is one implicit Scene. |
| 15 | Asset keywords come from file paths, `:assets` provides overrides, Assets hot-swap on change, and missing Assets show placeholders. |
| 16 | Named Actions in `:controls`, an input snapshot per Tick, `down?`, `pressed?` and `released?`, a raw-key fallback, and live `bind!`. |
| 17 | Collision detection only, with Contacts grouped by Collision Group. Physics comes later as an opt-in module. |
| 18 | A headless `.cljc` core with a ClojureScript platform layer. **ADR 0004** |
| 19 | shadow-cljs, published to Clojars with npm dependencies, plus a deps-new template that runs with `npm run dev`. No custom CLI. |
| 20 | Desktop packaging is deferred. Nothing may assume the game runs in a browser tab. |
| 21 | The v1 yardstick is an original side-scrolling platformer. Tilemaps, the Camera, Animation and kinematic Tile collision join v1. Rigid-body physics, slopes, moving platforms and parallax stay out. |
| 22 | Text-grid Tilemaps now, LDtk later. Tiles are grid data, not Entities, and Spawn Markers become Entities through registered spawn functions. |
| 23 | The built-in `:replengen/move` System handles gravity and resolves solid Tiles one axis at a time, writing `:touching`. There is one `:collider` shape. |
| 24 | A single Camera stored as top-level World data, updated by the built-in `:replengen/camera` System. Each Layer is `:world` or `:screen` space. |
| 25 | `:sprite` names an Animation, and frames are derived from the Ticks elapsed since it changed. Aseprite tags and grid sheets are both supported, and `:flip-x?` mirrors. |
| 26 | Ticks are atomic. An error discards the Tick, pauses the game and shows the dev overlay. Saving a fix resumes, and `last-error` and `retry!` are available. Release builds log and skip. |
| 27 | A dev-only History of 600 Ticks: `rewind!`, `replay!` through new code, `history`, `diff`, `snapshot!` and `restore!`. |
| 28 | Entity ids are generated from a counter in the World, with an optional explicit `:replengen/id`. A duplicate explicit id is an error. |
| 29 | One public namespace that re-exports everything. Engine-written keys are namespaced, and built-in Components the user writes are not. |
| 30 | The namespace is `replengen.core`, suggested alias `:as engen` (to avoid clashing with re-frame's `re`). Reserved keys and built-in Systems use `:replengen/...`. |
| 31 | A monorepo with one library artifact. The example and template use path dependencies, and the `.cljc` core is separated from `platform/` by directory. |
| 32 | Performance target: 1,000 Entities at 60 Ticks per second with a Tick budget under 4ms. Spatial hash, identity-skipping rendering, batched updates, a per-System meter, and CI benchmarks. |
| 33 | Bitmap-font text generated from font files, plus a bundled default pixel font. |
| 34 | Inspection through the REPL and `tap>`. The dev overlay shows the error panel, per-System timings and debug drawing. A clickable inspector comes later. |
| 35 | MIT license. |
| 36 | The deferred list in `docs/architecture.md` is binding: v1 must not make any of it harder to add. |

Audio: `@pixi/sound` behind the `:sound/*` Effects, swappable.
