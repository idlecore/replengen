# PixiJS as the renderer; replengen owns the game model

We use PixiJS purely for rendering and asset loading. replengen owns the world model, update loop, input, collision and scenes. We chose this over a full framework like Phaser because those frameworks bring their own mutable, class-based object model and scene lifecycle. A Clojure layer would then have to wrap that model or fight it, which undermines a data-first, hot-reloadable design. The cost is that replengen has to build or integrate features Phaser includes, such as audio, collision, tilemaps and tweens.
