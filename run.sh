#!/bin/bash

[ $# -ne 2 ] && echo "Usage: ./run.sh <graph> <shapes>" && exit

clingo src/progs.lp src/display.lp "$1" "$2"
