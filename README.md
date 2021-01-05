# CC '21 Artifacts #90 Overview

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4399899.svg)](https://doi.org/10.5281/zenodo.4399899)

> # *Communication-Safe Web Programming in TypeScript with Routed Multiparty Session Types*
> 
> #### Anson Miu, Francisco Ferreira, Nobuko Yoshida and Fangyi Zhou

Our paper presents **STScript**,
a toolchain that generates TypeScript APIs for communication-safe
web development over WebSockets, and **RouST**, a new session type theory
that supports multiparty communications with routing mechanisms.

This overview describes the steps to assess the practical claims of the paper using the artifact.

1. **[Getting Started](#getting-started)**
    - [1.1](#obtain-image) Obtain the Artifact (Docker image)
    - [1.2](#run-image) Run the Artifact
    - [1.3](#artifact-layout) Artifact Layout

2. **[Experiment Workflow](#workflow)**
    - [2.1](#workflow-tests) End-to-End Tests
    - [2.2](#workflow-case-studies) Case Studies
      - [_Noughts and Crosses_](#noughts-and-crosses)
      - [_Travel Agency_](#travel-agency)
      - [_Battleships_](#battleships)
    - [2.3](#workflow-perf-benchmarks) Performance Benchmarks

3. **[Experiment Customisation](#customise)**
    - [3.1](#customise-case-studies) Case Studies
    - [3.2](#customise-perf-benchmarks) Performance Benchmarks

---
---

## <a name="getting-started"></a> 1 Getting Started

In this section, we outline how to access and run the artifact.
We also introduce the layout of this repository,
which is used to build the artifact Docker image.

---

### <a name="obtain-image"></a> 1.1 Obtain the Artifact (Docker image)

We provide a [Docker image](https://doi.org/10.5281/zenodo.4399899)
with the necessary dependencies.
The following steps assume a Unix environment with Docker
properly installed. Other platforms supported by Docker may find a similar
way to import the Docker image.

Make sure that the Docker daemon is running.
Load the Docker image (use `sudo` if necessary):

```bash
$ docker load < stscript-cc21-artifact.tar.gz
```

You should see the following as output after the last operation:

```bash
Loaded image: stscript-cc21-artifact
```  

***Alternatively***, you can build the Docker image from source:

```bash
$ git clone --recursive \
	https://github.com/STScript-2020/cc21-artifact
$ cd cc21-artifact
$ docker build . -t "stscript-cc21-artifact"
```

---

### <a name="run-image"></a> 1.2 Run the Artifact (Docker image)

To run the image, run the command
(use `sudo` if necessary):

```bash
$ docker run -it -p 127.0.0.1:5000:5000 \
		-p 127.0.0.1:8080:8080 -p 127.0.0.1:8888:8888 \
		stscript-cc21-artifact
```

This command exposes the terminal of the _container_.
To run the STScript toolchain (e.g. show the helptext):

```bash
stscript@stscript:~$ codegen --help
```

For example, the following command reads as follows:

```bash
$ codegen ~/protocols/TravelAgency.scr TravelAgency A \
	browser -s S -o ~/case-studies/TravelAgency/client/src
```

1. Generate APIs for role `A` of the `TravelAgency`
protocol specified in `~/protocols/TravelAgency.scr`;

2. Role `A` is implemented as a `browser` endpoint,
and assume role `S` to be the server;

3. Output the generated APIs under the path `~/case-studies/TravelAgency/client/src`

---

### <a name="artifact-layout"></a> 1.3 Artifact Layout

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

---
---

## <a name="workflow"></a> 2 Experiment Workflow

In this section, we explain the workflow for carrying
out the experiments to verify the claims made in our paper.

---

### <a name="workflow-tests"></a> 2.1 End-to-End Tests

To run the end-to-end tests:

```bash
# Run from any directory
$ run_tests
```

The end-to-end tests verify that

* STScript correctly parses the Scribble protocol specification files, and,
* STScript correctly generates TypeScript APIs, and,
* The generated APIs can be type-checked by the TypeScript Compiler successfully.

The protocol specification files, describing the multiparty communication, are
located in `~/codegen/tests/system/examples`.
The generated APIs are saved under `~/web-sandbox` (which is a
sandbox environment set up for the TypeScript Compiler) and are deleted when the test
finishes.

Verify that all tests pass. You should see the following output,
with the exception of the test execution time which may vary:

```
-------------------------------------------------------
Ran 14 tests in 171.137s
OK
```

Passing the end-to-end tests means that our STScript toolchain correctly
generates type-correct TypeScript code.

---

### <a name="workflow-case-studies"></a> 2.2 Case Studies

We include three case studies of realistic web applications, namely _Noughts and Crosses_,
_Travel Agency_ and _Battleships_,
implemented using the generated APIs to show the expressiveness
of the generated APIs and the compatibility with modern web
programming practices.

#### <a name="noughts-and-crosses"></a> __✅ _Noughts and Crosses___

This is the classic turn-based 2-player game as introduced in
§5.
To generate the APIs for both players and the game server:

```bash
# Run from any directory
$ build_noughts-and-crosses
```

To run the case study:

```bash
$ cd ~/case-studies/NoughtsAndCrosses
$ npm start
```

Visit `http://localhost:8080` on two web browser windows
side-by-side, one for each player.
Play the game;
you may refer to https://youtu.be/SBANcdwpYPw for an example game execution
as a starting point.

You may also verify the following:

1. Open 4 web browsers to play 2 games simultaneously.
Observe that the state of each game board is consistent with its
game, i.e. moves do not get propagated to the wrong game.

2. Open 2 web browsers to play a game, and close one of them
mid-game. Observe that the remaining web browser is notified that
their opponent has forfeited the match.

_Additional Notes:_

* Refresh both web browsers to start a new game.
* Stop the web application by pressing `Ctrl+C` on the terminal.

#### <a name="travel-agency"></a> __✅ _Travel Agency___

This is the running example of our paper, as introduced in
§1.
To generate the APIs for both travellers and the agency:

```bash
# Run from any directory
$ build_travel-agency
```

To run the case study:
```bash
$ cd ~/case-studies/TravelAgency
$ npm start
```

Visit `http://localhost:8080` on two web browser windows
side-by-side, one for each traveller.
Execute the Travel Agency service;
you may refer to https://youtu.be/mZzIBYP_Xac for an example execution
as a starting point.

1. Log in as `Friend` and `Customer` on separate windows.

2. As `Friend`, suggest 'Tokyo'. As `Customer`, query for 'Tokyo'.
Expect to see that there is no availability.

3. As `Friend`, suggest 'Edinburgh'. As `Customer`, query for 'Edinburgh'.
Expect to see that there is availability, then ask `Friend`. As `Friend`, enter
a valid numeric split and press `OK`. As `Customer`, enter any string for your name
and any numeric value for credit card and press `OK`. Expect to see that both roles
show success messages.

4. Refresh both web browsers and log in as `Friend` and `Customer` on separate windows again.
As `Friend`, suggest 'Edinburgh' again. As `Customer`, query for 'Edinburgh'.
Expect to see that there is no availability, as the last seat has been taken.

Stop the web application by pressing `Ctrl+C` on the terminal.

#### <a name="battleships"></a> __✅ _Battleships___

This is a turn-based 2-player board game
with more complex application logic compared with
_Noughts and Crosses_.
To generate the APIs for both players and the game server:

```bash
# Run from any directory
$ build_battleships
```

To run the case study:

```bash
$ cd ~/case-studies/Battleships
$ npm start
```

Visit `http://localhost:8080` on two web browser windows
side-by-side, one for each player.
Play the game;
you may refer to https://youtu.be/cGrKIZHgAtE for an example game execution
as a starting point.

_Additional Notes:_

* Refresh both web browsers to start a new game.
* Stop the web application by pressing `Ctrl+C` on the terminal.

---

### <a name="workflow-perf-benchmarks"></a> 2.3 Performance Benchmarks

We include a script to run the performance benchmarks
as introduced in Appendix C.1.
By default, the script executes the same experiment configurations -- parameterising the `Ping Pong` protocol with
and without additional UI requirements with 100 and 1000 messages,
and running each experiment 20 times.
Refer to [3.2](#customise-perf-benchmarks) on how to customise these parameters.

To run the performance benchmarks:
```bash
$ cd ~/perf-benchmarks
$ ./run_benchmark.sh
```

___Note:___ If the terminal log gets stuck at
`Loaded client page`, open a web browser and access
http://localhost:5000.

#### __Terminology Alignment__
Observe the following discrepancies between the artifact
and the paper:

* The `simple_pingpong` example in the artifact refers to
	the `Ping Pong` protocol _without_ UI requirements
	in the paper.
* The `complex_pingpong` example in the artifact refers to
	the `Ping Pong` protocol _with_ UI requirements
	in the paper.

To visualise the performance benchmarks, run:

```bash
$ cd ~/perf-benchmarks
$ jupyter notebook --ip=0.0.0.0
/* ...snip... */
	To access the notebook, open this file in a browser:
		/* ...snip... */
	Or copy and paste one of these URLs:
	   http://ststcript:8888/?token=<token>
	or http://127.0.0.1:8888/?token=<token>
```

Use a web browser to open the URL
in the terminal output
beginning with `http://127.0.0.1:8888`.
Open the _STScript Benchmark Visualisation.ipynb_ notebook.

Click on _Kernel -> Restart \& Run All_ from the top menu bar.

#### __Data Alignment__

Tables 1 and 2 (from the paper)
can be located by scrolling to the end (bottom) of the notebook.

#### __Observations__

Verify the following claims made in the paper against
the tables printed at the end (bottom) of the notebook.

* Simple Ping Pong ("w/o req"):

  * Time taken by `node` is _less_ than time taken by `react`, which entails that _"the round trip time is
	dominated by the browser-side message processing time_".

  * The delta (of **`mpst`** relative to **`bare`**) for the `React` endpoints is _greater_ than the delta for the `Node` endpoints, which entails that _"**`mpst`** introduces overhead dominated by the React.js session runtime"_.

* Complex Ping Pong ("w/ req"):

  * Inspect the difference between the message processing time
	across __Simple Ping Pong__ and __Complex Ping Pong__.
	This difference is _greater_ for **`bare`**
	implementations compared with **`mpst`**
	implementations, which entails that
  _"the UI requirements require **`bare`** to perform
	additional state updates and rendering, reducing the overhead
	relative to **`mpst`**"_.

Stop the notebook server by pressing `Ctrl+C` on the terminal,
and confirm the shutdown command by entering `y`.

---
---

## <a name="customise"></a> 3 Experiment Customisation

In this section, we show how to customise the
experiment workflow to implement your own use case.

---

### <a name="customise-case-studies"></a> 3.1 Case Studies

We provide a step-by-step guide on implementing your own
web applications using STScript under the
[**wiki**](https://github.com/STScript-2020/cc21-artifact/wiki/STScript:-Writing-Communication-Safe-Web-Applications).

We use the `Adder` protocol as an example, but
you are free to use your own protocol. Other examples of protocols
(including `Adder`) can be found under `~/protocols`.

---

### <a name="customise-perf-benchmarks"></a> 3.2 Performance Benchmarks

You can customise the _number of messages_ (exchanged
during the `Ping Pong` protocol) and the
_number of runs_ for each experiment.
These parameters are represented in the `run_benchmark.sh`
script by the `-m` and `-r` flags respectively.

For example, to set up two configurations -- running `Ping Pong` with `100` round trips and `1000` round trips -- and run each configuration `100` times:

```bash
$ cd ~/perf-benchmarks
$ ./run_benchmark.sh -m 100 1000 -r 100
```

___Note:___ running `./run_benchmark.sh`
will clear any existing logs.

Refer to [§2.3](#workflow-perf-benchmarks) for instructions on
visualising the logs from the performance benchmarks.

___Note:___ If you change the message configuration (i.e.
the `-m` flag), update the `NUM_MSGS` tuple located
in the first cell of the notebook as shown below:

```python
# Update these variables if you wish to
# visualise other benchmarks.
VARIANTS = ('bare', 'mpst')
NUM_MSGS = (100, 1000)
```

---
---

## Licence

This work is licensed under Apache 2.0 Licence.
