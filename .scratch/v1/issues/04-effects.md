# 04 — Effects

Status: ready-for-agent
Type: task
Blocked by: 03

## What

Effects as data: Systems emit them, the Tick collects them, and handlers registered by keyword run them after the Systems. Lives in `replengen.effect` (`.cljc`).

## Acceptance criteria

- `(fx entity-or-world & effects)` attaches Effects such as `[:spawn {...}]` or `[:sound/play :coin]`. This works in both per-entity and raw Systems.
- Returning `nil` from a per-entity System destroys that Entity.
- After all Systems have run, the Tick runs the collected Effects in emission order, through a handler registry (`reg-effect`).
- Built-in core handlers `:spawn` and `:destroy` change the World.
- Effects that the core does not handle (e.g. `:sound/*`) are returned in the Tick result for the platform layer to run.
- Effect data never stays in the World after the Tick.
- An unknown Effect keyword or a malformed payload raises a clear error naming the Effect and the System that emitted it.
- Tests cover spawning from a per-entity System, destroying via nil, ordering, and unknown Effects.

## Open implementation question

Whether `fx` carries Effects as metadata on the returned map or under a reserved `:replengen/fx` key that the engine strips. Pick one, document it in the ns docstring, and test that it never leaks into the World.

## References

- GLOSSARY: Effect
- Grilling decision: Q10

## Comments
