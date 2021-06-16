# Setup

Running prototypical ProGS validation only requires the [Clingo](https://potassco.org/clingo/) ASP system, which consists of the Gringo grounder and Clasp solver.
Clingo is free software published under the MIT license. The GitHub repository can be found [here](https://github.com/potassco/clingo).

## Debian/Ubuntu

On Debian and derivatives, Clingo is available through two separate packages:

```sudo apt install gringo clasp```

## Other platforms

For other linux distributions, you may find the package ```clingo``` in your package repository.
For downloads and setup intructions on other platforms, please consult the [official documentation](https://potassco.org/doc/start/).
Alternatively, an instance of Clingo is hosted [here](https://potassco.org/clingo/run/). To use the online version, simply
copy the contents of ```progs.lp``` and an example (or your own example instance) into the tool.

# Execution

After installing ```clingo``` you can run the example program as follows:

```clingo progs.lp example.lp```

or by using the ```run.sh``` script.

# Validation

The file ```example.lp``` demonstrates the usage of this prototypical ProGS validator.
It requires encoding a property graph using the predicates ```edge/3```, ```label/2``` and ```property/3```, which correspond to the components <img src="https://render.githubusercontent.com/render/math?math=\rho">, <img src="https://render.githubusercontent.com/render/math?math=\lambda"> and <img src="https://render.githubusercontent.com/render/math?math=\sigma"> of a property graph <img src="https://render.githubusercontent.com/render/math?math=G = (N,E,\rho,\lambda,\sigma)">.
Node and edge shapes can be defined using ```nodeshape/3``` and ```edgeshape/3```. 
For the abstract syntax of constraints and target queries, please inspect ```progs.lp``` or the given examples.
For more information about the ProGS shape validation language, see the following paper:

TODO
