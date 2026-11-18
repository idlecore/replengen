# v1 spec

Status: ready-for-agent

## Goal

A developer with a little Clojure and a little game-dev experience can build an original side-scrolling platformer **live at the REPL, without reloading the page**. The game has:
- a player that runs and jumps (variable-height jumps) with gravity and solid-tile collision
- walking enemies the player can stomp
- coins and a score HUD
- a goal flag
- sound
- title, play and game-over Scenes, with lives kept in the Session

The level is a text-grid Tilemap with a following Camera and animated sprites.

## Done when

- `examples/platformer` implements the game above, using only `replengen.core :as engen`.
- Every part of that game can be changed while it runs, without a page reload or losing the World: Systems, `:systems` order, `:controls`, the Tilemap text, Assets (sprites, Animation timings, sounds, fonts).
- A throwing System pauses the game with the error overlay, and saving a fix resumes it.
- `rewind!` followed by `replay!` re-runs recorded input through the edited code.
- The example's game logic has tests that run headlessly on the JVM and in Node.
- The headless benchmark meets the target: 1,000 Entities, under 4ms per Tick.
- `clojure -Tnew create :template replengen/game` produces a project that runs with `npm run dev`.

## Design

See [`docs/architecture.md`](../../docs/architecture.md), [`GLOSSARY.md`](../../GLOSSARY.md) and [`docs/adr/`](../../docs/adr/). The issues cite decisions by number (Qn), which are listed in [`decisions.md`](decisions.md).

## Out of scope

Everything in the "Explicitly deferred" section of the architecture doc.

## Issues

| # | Issue | Blocked by |
|---|---|---|
| 01 | [Project skeleton](issues/01-project-skeleton.md) | — |
| 02 | [World and Entities](issues/02-world-and-entities.md) | 01 |
| 03 | [Systems and the Tick](issues/03-systems-and-tick.md) | 02 |
| 04 | [Effects](issues/04-effects.md) | 03 |
| 05 | [Game declaration, Scenes and Session](issues/05-game-scenes-session.md) | 04 |
| 06 | [Platform loop and hot reload](issues/06-platform-loop-hot-reload.md) | 05 |
| 07 | [Rendering by convention](issues/07-rendering.md) | 06 |
| 08 | [Assets](issues/08-assets.md) | 07 |
| 09 | [Input and Actions](issues/09-input-actions.md) | 06 |
| 10 | [Collision detection and Contacts](issues/10-collision-detection.md) | 04 |
| 11 | [Text-grid Tilemaps and Spawn Markers](issues/11-text-grid-tilemaps.md) | 05, 07 |
| 12 | [Kinematic movement against Tiles](issues/12-kinematic-move.md) | 10, 11 |
| 13 | [Camera](issues/13-camera.md) | 07, 11 |
| 14 | [Sprite Animation](issues/14-animation.md) | 08 |
| 15 | [Bitmap-font text](issues/15-text.md) | 08 |
| 16 | [Audio](issues/16-audio.md) | 08 |
| 17 | [Atomic Ticks and the error overlay](issues/17-errors-overlay.md) | 06 |
| 18 | [History, rewind, replay and Snapshots](issues/18-history.md) | 09, 17 |
| 19 | [Dev inspection tools](issues/19-dev-tools.md) | 17 |
| 20 | [Headless benchmarks and performance](issues/20-performance.md) | 10, 12 |
| 21 | [Platformer example](issues/21-platformer-example.md) | 12, 13, 14, 15, 16, 18 |
| 22 | [Game template](issues/22-game-template.md) | 21 |

## Comments
