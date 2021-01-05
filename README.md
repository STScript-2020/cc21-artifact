# CC '21 Artifacts #90 Overview

> # *Communication-Safe Web Programming in TypeScript with Routed Multiparty Session Types*
> 
> #### Anson Miu, Francisco Ferreira, Nobuko Yoshida and Fangyi Zhou

Our paper presents **STScript**,
a toolchain that generates TypeScript APIs for communication-safe
web development over WebSockets, and **RouST**, a new session type theory
that supports multiparty communications with routing mechanisms.

## Artifact Layout
- `scribble-java` contains the [Scribble toolchain](https://github.com/scribble/scribble-java),
  for handling multiparty protocol descriptions, a dependency of our toolchain.
- `codegen` contains the source code of our code generator, written in Python, which generates
  TypeScript code for implementing the provided multiparty protocol.
- `protocols` contains various Scribble protocol descriptions, including those used in the case
  studies.
- `case-studies` contains 3 case studies of implementing interactive web applications with our
  toolchain, namely _Noughts and Crosses_, _Travel Agency_, and _Battleships_.
- `perf-benchmarks`contains the code to generate performance benchmarks, including an iPython
  notebook to visualise the benchmarks collected from an experiment run.
- `scripts` contains various convenient scripts to run the toolchain and build the case studies.
- `web-sandbox` contains configuration files for the web development, e.g. TypeScript configurations
  and NPM `package.json` files.

## Licence

This work is licensed under Apache 2.0 Licence.
