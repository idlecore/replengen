# ClojureScript-first on a JavaScript engine, not a Java engine

replengen was first meant to sit on a mature Java engine (libGDX), but web is as important a target as desktop. No proven path runs Clojure on a JVM game engine in the browser: TeaVM barely supports reflection or runtime class loading, CheerpJ's LWJGL support is only partial, and GWT only takes Java source. So replengen is written in ClojureScript on a mature JavaScript 2D engine. Desktop ships as the same web build wrapped in a desktop shell. We get one runtime and shadow-cljs hot reload, and we give up the JVM REPL and JVM libraries.

## Considered Options

- **JVM + libGDX, web via TeaVM or CheerpJ**: rejected; unproven for Clojure and high risk.
- **Shared `.cljc` game code with a libGDX backend and a JS backend**: rejected; two engine bindings that must behave identically doubles the work and leads to desktop and web drifting apart.
