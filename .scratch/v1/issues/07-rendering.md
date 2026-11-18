# 07 — Rendering by convention

Status: ready-for-agent
Type: task
Blocked by: 06

## What

Reconcile the World onto Pixi's display tree, in `replengen.platform.render`.

## Acceptance criteria

- Layers come from `:layers` in the Game, in order, each either `:world` or `:screen` space. `:z` orders Entities within a Layer. Entities without `:layer` go to a documented default Layer.
- An Entity with `:sprite` (a static image for now), `:shape` or `:text` (stubbed until issue 15) gets a Pixi display object keyed by Entity id. That object is created, updated (position, `:rotation`, `:flip-x?`, `:z`, Layer) and removed as the Entity changes.
- An Entity that is `identical?` to the previous frame's is skipped.
- Changing an Entity's `:layer` moves its display object to the new Layer.
- Changing `:layers` in the Game live rebuilds the Layer containers without a reload.
- World-space Layers sit under one container that the Camera transforms later (issue 13). Until then it uses the identity transform.
- A spike or test shows hundreds of moving Entities rendering smoothly.

## References

- Grilling decision: Q12; GLOSSARY: Layer

## Comments
