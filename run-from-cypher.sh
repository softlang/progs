#!/bin/bash

# Note: Update the location of your database and login information.
# (You should not expose login credentials of real databases).

[ $# -ne 1 ] && echo "Usage: ./run-from-cypher.sh <shapes>" && exit

cypher="$HOME/.local/share/neo4j-relate/dbmss/dbms-1b99865d-2ef1-4ade-9c2c-dde4149fce19"
user="neo4j"
password="1234"

# Export DB.

./scripts/from-cypher.sh "$cypher" "$user" "$password"

# Convert from JSON to ASP encoding.

./scripts/translate.py -i "graph.json" > graph.lp

clingo src/progs.lp src/display.lp graph.lp "$1"
