# Setup

Running prototypical ProGS validation requires the [Clingo](https://potassco.org/clingo/) ASP system, which consists of the Gringo grounder and Clasp solver.
Clingo is free software published under the MIT license. The GitHub repository can be found [here](https://github.com/potassco/clingo).
In addition, Python 3 is required. Bash is required for utility scripts only. Python requirements can be installed with:

```sh
pip install -r requirements.txt
```

## Debian/Ubuntu

On Debian and derivatives, Clingo is available through two separate packages:

```sh
sudo apt install gringo clasp
```

## Other platforms

For other GNU/Linux distributions, you may find the ```clingo``` package in your distro package repository. For macOS, ```clingo``` packages are available via Homebrew and MacPorts.
For download and setup instructions on other platforms, please consult the [official documentation](https://potassco.org/doc/start/).
Alternatively, an instance of Clingo is hosted [here](https://potassco.org/clingo/run/). In order to use the online version, simply
copy & paste the contents of [progs.lp](src/progs.lp) (and [display.lp](src/display.lp)) and example graphs and shapes (or your custom instances).

# Execution

After installing ```clingo``` you can validate the example graph as follows:

```sh
./validate.sh paper-example/graph.lp paper-example/shapes.progs
```

By default, this will output only 1 faithful assignment and SATISFIABLE (or UNSATISFIABLE). In order to obtain at most N solutions, supply the additional argument N (see below) to the clingo call. To obtain all solutions, use N = 0.

```sh
clingo N src/progs.lp src/display.lp paper-example/graph.lp paper-example/shapes.progs
```

# Validation

The examples in folder [paper-example](paper-example) demonstrate the usage of this validator.
It requires encoding a property graph using the predicates ```edge/3```, ```label/2``` and ```property/3```, which correspond to the components <img src="https://render.githubusercontent.com/render/math?math=\rho">, <img src="https://render.githubusercontent.com/render/math?math=\lambda"> and <img src="https://render.githubusercontent.com/render/math?math=\sigma"> of a property graph <img src="https://render.githubusercontent.com/render/math?math=G = (N,E,\rho,\lambda,\sigma)">.
Node and edge shapes can be defined using a concrete syntax defined by the grammar in [grammar.ebnf](src/grammar.ebnf).
For the examples of the concrete syntax of constraints and target queries, please see [shapes.progs](paper-example/shapes.progs) or [shapes.progs](movie-example/shapes.progs) or the example below.

```
NODE movieShape [:movie] { 
    :movie &
    =1 title.string 
};

NODE actorShape [BOTTOM] {
    :person &
    >=1 :acted_in.movieShape &
    >=1 name.string
};

EDGE actedInShape [:acted_in] {
    << actorShape &
    >> movieShape
};
```

For more information about the ProGS shape validation language, see the following [paper](http://www.google.de):

```bibtex
TBD
```

# Validating Neo4j/Cypher Graphs

ProGS can be used to validate Neo4j graphs via the ```validate-neo4j.sh``` script.
This relies on exporting a cypher graph through the cypher-shell (in JSON format) and converting the JSON encoding to our ASP encoding:

```sh
./run-from-cypher.sh <neo4j-db-location> <shapes>
```

where ```<shapes>``` is a file with ASP encoded shapes and ```<neo4j-db-location>``` the local path of the Neo4j instance. The folder [movie-example](movie-example) contains shapes for validating the Neo4j example movie database.
Note, that we convert all property names and labels to lower case. We also replace " with ' in strings. We only support integer and string property values. All other properties are converted to strings via the Python ```str``` function.

Validation of other property graph models is possible by either exporting graphs in the same JSON format as Neo4j (an then using [translate.py](scripts/translate.py)) or by writing a custom conversion to the ASP encoding used by ProGS.
There are also a number of other scripts in the [scripts](scripts) folder, e.g., for validating a JSON dump obtained by other means, such as through the Neo4j Browser or a remote Neo4j instance:

```sh
./scripts/validate-neo4j-dump.sh <json> <shapes>
```

# References

This ASP encoding is inspired by [SHaclEX](https://github.com/weso/shaclex), an implementation of SHACL and ShEx that
features a prototypical ASP-based validation engine. See also [this](https://labra.weso.es/pdf/2018_SlidesNegationRecursionValidatingRDF.pdf) talk.

# TODO

- Write test cases (and perhaps a simple test framework?)
- Implement path evaluation and missing constraints. Update greaterEq to use paths.
- Allow list of targets in "[" "]", where bottom is just "[]".
