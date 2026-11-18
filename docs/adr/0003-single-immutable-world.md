# The whole game is one immutable World value

All game state lives in one immutable World. Pure functions advance it each tick, and rendering is reconciled from it onto Pixi's display tree. We rejected mutable game objects (the Unity/Phaser style), even though game devs know them better, because hot reload, REPL inspection, snapshots and replay all depend on state having one inspectable value that is separate from behaviour. The cost is per-frame allocation from persistent data. A sanctioned escape hatch for mutable, performance-heavy subsystems (e.g. particles) can be added later without changing this model.

## Consequences

- The World holds only plain data and never function values. Behaviour is referenced by keyword and resolved through a registry at tick time. Re-evaluating a function at the REPL therefore takes effect for every existing Entity on the next tick, and the World stays printable, diffable and serialisable. The engine warns when a function value ends up in the World.
