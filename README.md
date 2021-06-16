# Setup

## Debian/Ubuntu

```sudo apt install gringo clasp```

## Other platforms

For other linux distributions, you may find the package ```clingo``` in your package repository.
For downloads and setup intructions on other platforms, see the official documentation at https://potassco.org/doc/start/.

# Execution

After installing ```clingo``` you can run the example program as follows:

```clingo progs.lp example.lp```

or by using the ```run.sh``` script.

# Validation

The file ```example.lp``` demonstrates the usage of this prototypical ProGS validator.
It requires encoding a property graph using the predicates ```edge/3```, ```label/2``` and ```property/3```, which correspond to the components <img src="https://render.githubusercontent.com/render/math?math=\rho">, <img src="https://render.githubusercontent.com/render/math?math=\lambda"> and <img src="https://render.githubusercontent.com/render/math?math=\omega">.
Node and edge shapes can be defined using ```nodeshape/3``` and ```edgeshape/3```. 
For the abstract syntax of constraints and target queries, please inspect ```progs.lp``` or the given examples.
For more information about the ProGS shape validation language, see the following paper:

TODO
