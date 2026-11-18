# replengen

A REPL-first 2D game engine for ClojureScript. Games are built and changed live while they run.

## Language

**History**:
The recent sequence of Worlds and the input of each Tick, kept during development so play can be rewound and replayed.
_Avoid_: Timeline, log, undo stack

**Snapshot**:
A World saved under a name so it can be restored later.
_Avoid_: Save, checkpoint, save state

**Game**:
The declaration of a game: its title, size, ordered Systems and how to build its initial World. It is data, separate from any running World.
_Avoid_: App, config, project

**World**:
The single immutable value that holds the entire state of a running game at a given moment.
_Avoid_: State, game state, store

**Entity**:
One thing in the World, such as a ship, a rock or a score label. It is identified by an id and made up of Components.
_Avoid_: Game object, actor, node, sprite

**Component**:
One named piece of data on an Entity, such as its position, velocity or sprite.
_Avoid_: Property, attribute, trait

**System**:
A pure function that advances the World by acting on every Entity that has a particular set of Components.
_Avoid_: Manager, processor, script, behavior

**Tick**:
One step of the game, in which every System advances the World once.
_Avoid_: Frame, update, step

**Effect**:
A description, as data, of something that should happen outside a System's pure update, such as playing a sound, spawning or destroying an Entity, or changing scene.
_Avoid_: Command, action, side effect, event

**Scene**:
A named mode of a Game, such as title, play or game over. It has its own Systems and its own way to build initial Entities. Exactly one Scene is active at a time.
_Avoid_: Screen, level, state, room

**Session**:
The part of the World that survives a change of Scene, such as the high score or settings.
_Avoid_: Globals, persistent state, save data

**Action**:
A named player intent, such as thrust or fire, that the Game binds to keys, buttons or pointer input.
_Avoid_: Control, binding, command, input event

**Tilemap**:
A grid of Tiles that makes up a level's static geometry. It is held in the World as one piece of grid data, not as Entities.
_Avoid_: Level, map, grid, tileset

**Tile**:
One cell of a Tilemap, such as ground, block or empty, which may be solid.
_Avoid_: Block, cell

**Spawn Marker**:
A position in a Tilemap that becomes a real Entity, such as the player, an enemy or a coin, when the level is loaded.
_Avoid_: Spawn point, placeholder, entity tile

**Collision Group**:
A named category of colliding Entities, such as bullet or rock, used to ask which kinds of things touched.
_Avoid_: Layer, mask, tag

**Contact**:
A pair of Entities whose colliders overlap during a given Tick.
_Avoid_: Collision, hit, overlap event

**Asset**:
An image, sound, font or spritesheet that the Game uses, referred to by a keyword that comes from its file path.
_Avoid_: Resource, media, file

**Animation**:
A named sequence of sprite frames from an Asset, such as hero run, that an Entity shows by naming it as its sprite.
_Avoid_: Clip, sequence, anim

**Layer**:
A named tier that sets the drawing order of Entities, such as background, actors or HUD. It is either world-space, which scrolls with the Camera, or screen-space, which stays fixed.
_Avoid_: Z-index, depth, group

**Camera**:
The single view onto the World that decides which part of world-space is on screen. It can follow an Entity.
_Avoid_: Viewport, view, stage
