# 18 — History, rewind, replay and Snapshots

Status: ready-for-agent
Type: task
Blocked by: 09, 17

## What

The dev-only History ring buffer and the REPL controls around it, in `replengen.history` (`.cljc`) plus the loop wiring.

## Acceptance criteria

- In dev builds, every Tick appends `{:tick n :world w :input snapshot}` to a bounded ring buffer. The default capacity is 600 Ticks (10 seconds) and it's configurable.
- `(engen/rewind! n)` pauses the game and makes the World from n Ticks ago current.
- `(engen/replay!)` re-runs the recorded input from that point through the *currently registered* Systems, discarding the old future.
- `(engen/history)` returns the buffer. `(engen/diff tick-a tick-b)` returns a readable data diff of the two Worlds.
- `(engen/snapshot! :name)` and `(engen/restore! :name)` save and restore a World by name. Snapshots are independent of the buffer.
- Determinism test, headless: running a recorded input log twice gives identical Worlds, including generated ids.
- Memory check: a 600-Tick buffer for the platformer example stays within a reasonable bound (measure and document it).
- History is not present in release builds.

## References

- GLOSSARY: History, Snapshot; Grilling decision: Q27

## Comments
