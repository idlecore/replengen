# replengen

A REPL-first 2D game engine for ClojureScript, built on [PixiJS](https://pixijs.com/).

The whole game is one immutable World advanced by pure Systems. You edit code at the REPL and the running game changes immediately, without a page reload and without losing your place.

> **Status:** design stage. Nothing here runs yet. The v1 plan is in [`.scratch/v1/`](.scratch/v1/spec.md).

## A taste of the planned API

```clojure
(ns my.game (:require [replengen.core :as engen]))

(engen/defsystem jump {:query [:player-controlled :touching]}
  (fn [e {:keys [input]}]
    (if (and (engen/pressed? input :jump) (contains? (:touching e) :bottom))
      (assoc-in e [:velocity 1] -520)
      e)))
```

## Design docs

- [Architecture](docs/architecture.md)
- [Glossary](GLOSSARY.md)
- [Architecture decision records](docs/adr/)

## License

MIT
