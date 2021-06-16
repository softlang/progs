#!/bin/bash

"$1/bin/cypher-shell" "CALL apoc.export.json.all(\"graph.json\",{useTypes:true})"\
    -u "$2"\
    -p "$3"

mv "$1/import/graph.json" .
