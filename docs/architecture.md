# replengen architecture

replengen is a REPL-first 2D game engine for ClojureScript. A running game is one immutable **World** value, advanced by pure **Systems** at a fixed rate and drawn by PixiJS. Saving a file changes the game's behaviour without losing its state.

Vocabulary is defined in [`GLOSSARY.md`](../GLOSSARY.md). Decisions with lasting consequences are in [`docs/adr/`](adr/).

## Principles

1. **One World, plain data.** All game state lives in a single immutable value. It never holds functions, Pixi objects or other mutable state. Behaviour is referenced by keyword and resolved through a registry at Tick time. ([ADR 0003](adr/0003-single-immutable-world.md))
2. **Systems are the only logic.** There are no per-Entity scripts and no callbacks. A System is a pure function, and side effects are returned as data (Effects).
3. **Deterministic Ticks.** A Tick is a function of the World, the Tick context and the input snapshot. It runs at a fixed timestep and is atomic: either every System succeeds or the Tick is discarded.
4. **Purity is structural.** The core is `.cljc` and cannot see Pixi or the browser. Only the platform layer touches the outside world. ([ADR 0004](adr/0004-headless-cljc-core.md))
5. **Reload keeps the World.** Hot reload swaps code. Rebuilding the World is always explicit (`reset!`).
6. **The developer experience is the product.** Clear errors, visible placeholders, live tuning, rewind and replay.

## Layers

```
┌───────────────────────────────────────────────────────────────┐
│ Game code  (user .cljs / .cljc)                               │
│   (ns my.game (:require [replengen.core :as engen]))          │
├───────────────────────────────────────────────────────────────┤
│ replengen.core: public API, re-exports only                   │
├──────────────────────────────┬────────────────────────────────┤
│ Core  (.cljc, headless)      │ Platform  (.cljs, browser)     │
│  world   system   effect     │  loop      rAF, timestep,      │
│  tick    scene    input      │            pause/step/speed    │
│  collision  move  camera     │  render    World → Pixi tree   │
│  tilemap  animation  history │  assets    loading, hot-swap   │
│                              │  audio     @pixi/sound         │
│                              │  input     DOM → snapshots     │
│                              │  overlay   errors, timings,    │
│                              │            debug draw          │
├──────────────────────────────┴────────────────────────────────┤
│ PixiJS v8 · @pixi/sound · browser                             │
└───────────────────────────────────────────────────────────────┘
```

- **Core** never requires anything from `platform/`. This is enforced by tests and lint, and it makes the core runnable on the JVM (`clojure.test`) and in Node.
- **Platform** owns every mutable object: the Pixi application and its display objects, loaded textures and sounds, DOM listeners, and the atom holding the current World.

## Data shapes

### World

```clojure
{:scene     :play                          ; active Scene
 :entities  {:player  {...}                ; Entity id → Entity map
             :e/1042  {...}}
 :tilemap   {...}                          ; grid data for the current level (not Entities)
 :camera    {:position [x y] :follow :player :deadzone [64 32] :bounds :tilemap :zoom 1}
 :session   {:lives 3 :high-score 4200}    ; survives Scene changes
 :replengen/tick     18402                 ; engine bookkeeping uses :replengen/*
 :replengen/next-id  1043
 :replengen/contacts {...}}                ; this Tick's Contacts, by Collision Group pair
```

### Entity

An Entity is a map of Components. Components that the user writes and the engine reads are unnamespaced. Keys that the engine writes are `:replengen/*`.

| Component | Read by | Meaning |
|---|---|---|
| `:position [x y]` | render, move, collision | World-space position |
| `:velocity [vx vy]` | `:replengen/move` | Units per second |
| `:gravity n` | `:replengen/move` | Downward acceleration |
| `:collider {:shape :rect\|:circle ... :group kw :solid-tiles? bool}` | collision, move | One shape for Contacts and Tile resolution |
| `:sprite kw` | render, animation | Static image or Animation keyword (`:hero/run`) |
| `:flip-x? bool` | render | Mirror horizontally |
| `:text str` `:font kw` `:font-size n` `:color kw` | render | Bitmap-font text |
| `:shape {...}` | render | Simple vector shape |
| `:layer kw` `:z n` | render | Drawing order |
| `:touching #{:top :bottom :left :right}` | user Systems | Written by `:replengen/move` |
| `:replengen/id` | everyone | Explicit id (optional; otherwise generated) |
| `:replengen/sprite-since` | render | Tick at which `:sprite` last changed |

### Game

```clojure
{:title    "Platformer"
 :size     [320 180]
 :start    :title
 :controls {:left [:arrow-left :a] :right [:arrow-right :d] :jump [:space :w]}
 :layers   [[:background :world] [:tiles :world] [:actors :world] [:hud :screen]]
 :assets   {:hero {:frames [16 16]}}       ; optional overrides only
 :scenes   {:title     {:init title-world :systems [::menu]}
            :play      {:init play-world
                        :systems [::run ::jump :replengen/move :replengen/detect-collisions
                                  ::stomp ::collect ::hero-anim :replengen/camera ::hud]}
            :game-over {:init over-world :systems [::menu]}}}
```

A Game without `:scenes` has one implicit Scene, so `:init` and `:systems` can sit at the top level.

## The Tick pipeline

```
input snapshot ─┐
                ▼
World(n) ──► for each System in the active Scene, in order ──► World' + collected Effects
                │   per-entity:  (fn [entity ctx] → entity | nil)   nil = destroy
                │   raw:         (fn [world ctx]  → world (+ effects))
                ▼
      run Effect handlers (:spawn, :destroy, :scene/goto, :sound/play, ...)
                │   handlers that change the World run in core
                │   external ones (sound) are passed to the platform
                ▼
             World(n+1) ──► History ring buffer (dev only)
                │
                ▼
      render: reconcile Entities, Tilemap and Camera onto Pixi (every display frame)
```

- **`ctx`** holds `{:dt fixed-dt :tick n :input snapshot :game game}`. Systems never read clocks or the DOM.
- **Fixed timestep.** The default is 60 Ticks per second. The platform loop accumulates real time, runs zero or more Ticks per display frame (capped, to avoid a spiral of ever-growing catch-up), then renders the latest World once.
- **Atomicity.** If any System or Effect handler throws, the whole Tick is discarded. The last good World stays current, the loop pauses, and in dev builds an overlay names the System, the Entity and the error.
- **Function guard.** In dev builds, a function value found in the World raises a clear warning.

## Hot reload

- shadow-cljs reloads changed namespaces. `defsystem` re-registers the System under the same keyword, so the next Tick runs the new code.
- The Game map is re-read after every reload, so changes to `:systems` order, `:controls` or `:layers` take effect live.
- The World atom is never touched by reload. `(engen/reset!)` rebuilds it from the active Scene's `:init`.
- Changed Asset files are reloaded in place. Entities hold only keywords, so nothing in the World changes.
- Re-evaluating a text-grid Tilemap replaces the World's tile grid but keeps live Entities.

## Development tools (dev builds only)

| Tool | API |
|---|---|
| Loop control | `pause!` `resume!` `step!` `set-speed!` |
| World access | `@engen/world`, `swap!` directly |
| Scenes | `goto!` `reset!` |
| History | `rewind!` `replay!` (recorded input through current code) `history` `diff` |
| Snapshots | `snapshot!` `restore!` |
| Errors | `last-error` `retry!` |
| Inspection | `tap-entity` `tap-effects` (any `tap>` viewer) |
| Overlay | error panel, per-System timing meter, `debug-draw!` for colliders and Camera |
| Input | `bind!` to rebind an Action live |

Release builds remove History and the overlay. Errors are logged and the failing Tick is skipped.

## Rendering

- The renderer keeps a map from Entity id to Pixi display object. Each frame it creates, updates or removes display objects. It skips any Entity that is `identical?` to the one it saw on the previous frame.
- Layers are Pixi containers created from `:layers`. World-space Layers sit under a container transformed by the Camera; screen-space Layers do not.
- The Tilemap renders as its own world-space Layer, using batched tile sprites rather than per-tile Entities.
- An Animation's frame is `(quot (- tick sprite-since) frame-duration-in-ticks)`, using the timings from the Asset's metadata.
- A missing Asset renders as a magenta placeholder and logs one warning, naming the keyword and the paths searched.

## Assets

- **Convention:** `assets/sprites/hero.png` becomes `:hero`. When a name is ambiguous, the folder qualifies it (`:sprites/hero`).
- **Spritesheets:** an Aseprite JSON export next to the PNG turns its tags into Animation keywords (`:hero/run`). Grid sheets are declared through `:assets` overrides.
- **Fonts:** `.ttf` and `.woff2` files in `assets/fonts/` are converted to bitmap fonts at load time. A default pixel font is bundled.
- **Sounds:** `assets/sounds/*.ogg|mp3|wav` are played through `[:sound/play kw]` Effects.

## Collision and movement

- **`:replengen/detect-collisions`** builds a spatial hash of all colliders and records the overlapping pairs, indexed by Collision Group, as this Tick's Contacts. User Systems ask for them with `(engen/contacts world :player :enemy)`. The engine only detects Contacts; deciding what happens is up to user Systems.
- **`:replengen/move`** applies `:gravity`, then integrates `:velocity`. For colliders with `:solid-tiles?`, it resolves the X axis first and then the Y axis against the solid Tiles under the collider, and writes `:touching`.
- Rigid-body physics is deferred. When it arrives, it will be an opt-in module using the mutable-subsystem escape hatch.

## Repository layout

```
replengen/
├── deps.edn  shadow-cljs.edn  package.json  LICENSE (MIT)
├── src/replengen/
│   ├── core.cljc                  public API (re-exports)
│   ├── world.cljc system.cljc effect.cljc tick.cljc scene.cljc input.cljc
│   ├── collision.cljc move.cljc camera.cljc tilemap.cljc animation.cljc history.cljc
│   └── platform/                  loop.cljs render.cljs assets.cljs audio.cljs input.cljs overlay.cljs
├── test/replengen/                JVM + Node
├── bench/                         headless benchmarks (CI)
├── examples/platformer/           the v1 yardstick game
├── template/                      deps-new game template
└── docs/  GLOSSARY.md
```

## Performance target

1,000 active Entities and a 300×30 Tilemap at 60 Ticks per second, with all Systems together taking under 4ms per Tick, on a mid-range 2020 laptop in Chrome or Firefox. The techniques that get there:
- a spatial hash for collision
- looking up only the Tiles under each collider
- identity-skipping rendering
- batched Entity updates in per-entity Systems

Headless benchmarks guard against regressions in CI.

## Explicitly deferred

3D, desktop packaging, the mutable escape hatch, rigid-body physics, slopes, moving platforms, LDtk levels, Scene stacks, gamepad and touch input, parallax, particles, tweening, UI widgets, rich text, multiple cameras, a clickable inspector and History scrubber, split Clojars artifacts, and save files.

v1 must not make any of these harder to add. In particular:
- the core never depends on the platform layer
- nothing assumes the game runs in a browser tab
- Tilemap data is independent of the text-grid loader
- Actions are not tied to keys
