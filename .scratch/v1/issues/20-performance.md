# 20 — Headless benchmarks and performance

Status: ready-for-agent
Type: task
Blocked by: 10, 12

## What

Headless benchmarks for the performance target, and the optimisation needed to meet it.

## Acceptance criteria

- `bench/` scenario: 1,000 moving Entities with colliders, a 300×30 Tilemap, and the built-in Systems plus a few per-entity user Systems.
- The scenario reports mean and p95 Tick time.
- It runs on the JVM, and in Node because that's closer to the browser's JS engine.
- The target is under 4ms per Tick, measured in Node. Optimise until it's met, documenting any technique that changes the code's shape.
- CI runs the benchmark and fails on a regression beyond a set threshold compared with a stored baseline.
- A browser check (a manual or scripted page) confirms 60 Ticks per second with rendering on a mid-range machine. Record the result in this issue's comments.

## References

- Grilling decision: Q32

## Comments
