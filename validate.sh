#!/bin/bash

# Validate <graph> against <shapes>.

[ $# -ne 2 ] && echo "Usage: ./validate.sh <graph> <shapes>" && exit

clingo src/progs.lp src/display.lp "$1" "$2"
