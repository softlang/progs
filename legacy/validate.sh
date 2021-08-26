#!/bin/bash

# Validate <graph> against <shapes>.

[ $# -ne 2 ] && echo "Usage: ./validate.sh <graph> <shapes>" && exit

tmpfile=$(mktemp /tmp/converted-shapes-XXX.lp)

./scripts/shapeTranspiler.py -i "$2" > "$tmpfile"

clingo src/progs.lp src/display.lp "$1" "$tmpfile"

rm "$tmpfile"