#!/bin/bash

# Validate the JSON dump <dump> with shapes <shapes>.

[ $# -ne 2 ] && echo "Usage: ./validate-neo4j-dump.sh <dump> <shapes>" && exit

tmpfile=$(mktemp /tmp/converted-neo4j-dump-XXX.lp)

# Convert from JSON to ASP encoding.

./scripts/translate.py -i "$1" > "$tmpfile"

clingo src/progs.lp src/display.lp "$tmpfile" "$2"

rm "$tmpfile"