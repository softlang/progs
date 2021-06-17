#!/bin/bash

# Create a JSON dump of Neo4j DB <neo4j-db-root> (e.g.,
# "$HOME/.local/share/neo4j-relate/dbmss/dbms-<..ID...>") and then run
# validation with <shapes>.

[ $# -ne 2 ] && echo "Usage: ./validate-neo4j.sh <neo4j-db-dir> <shapes>" && exit

tmpfile=$(mktemp /tmp/exported-neo4j-json-dump-XXX.json)

# Export DB.

./scripts/export-db.sh "$1" "$tmpfile"

./scripts/validate-neo4j-dump.sh "exported.json" "$2"

rm "$tmpfile"
