#!/bin/bash

# Export a Neo4j DB to JSON.

[ $# -ne 2 ] && echo "Usage: ./export-db.sh <neo4j-db-dir> <file-target>" && exit

# Create the dump. May require entering login credentials.

"$1/bin/cypher-shell" "CALL apoc.export.json.all(\"exported.json\",{useTypes:true})"

mv "$1/import/exported.json" "$2"
