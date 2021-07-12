#!/usr/bin/python3

import sys
import os
import argparse
import calendar
import time
import shutil
import subprocess

from src.shapeTranspiler import transpile
from src.graphEncoder import encode


# Basic setup.

ap = argparse.ArgumentParser(prog='ProGS',
                             description='Run validation on property graphs. For basic validation use \'validate\' mode.',
			     epilog='Philipp Seifer @ https://github.com/softlang/progs')
ap.version = '0.1'
ap.add_argument('-v', action='version')
ap.add_argument('--debug', action='store_true', 
  help='run in debug mode, keep intermediate results')

apsub = ap.add_subparsers(dest='subparser', 
  help='see <command> -h for help on subcommand')


# Validate parser (main tool).

validate_parser = apsub.add_parser('validate', 
  description='Validate a graph in one of the supported formats.')

validate_parser.add_argument(
  'shapes', metavar='shapes', type=str, help='the shapes file')

validate_parser.add_argument('-s','--no-assignment', action='store_true', 
  help='do not output the assignment, only satisfiability')

validate_graph_group = validate_parser.add_mutually_exclusive_group(required=True)

validate_graph_group.add_argument('-g', '--graph', metavar='FILE', 
  help='ASP encoding of a property graph')
validate_graph_group.add_argument('-d', '--neo4j-db', metavar='FOLDER', 
  help='path to local neo4j instance (root dir)')
validate_graph_group.add_argument('-j', '--json', metavar='FILE', 
  help='JSON dump conforming to neo4j JSON format')

#validate_parser.add_argument('-s', '--shapes', dest='shapes', help='...')


# Export parser.

export_parser = apsub.add_parser('export',
  description='Export Neo4j instance and store result.')
export_parser.add_argument('neo4j', metavar='FOLDER', type=str, 
  help='path to local neo4j instance (root dir)')
export_parser.add_argument('json', metavar='FILE', type=str, 
  help='JSON dump target file')


# Convert parser.

export_parser = apsub.add_parser('convert',
  description='Encode a JSON graph in ASP.')
export_parser.add_argument('json', metavar='FILE', type=str, 
  help='JSON file with graph.')
export_parser.add_argument('asp', metavar='FILE', type=str, 
  help='ASP target file.')


# Transpile parser.

export_parser = apsub.add_parser('parse',
  description='Parse a shapes file. Optionally output the ASP encoded result.')
export_parser.add_argument('progs', metavar='FILE', type=str, 
  help='Progs shapes file.')
export_parser.add_argument('-o', '--out', metavar='FILE', type=str, 
  help='ASP target file.')


# Implementation

def cleanup(debug):
    if not debug:
        try:
            shutil.rmtree(tempdir)
        except OSError as e:
            print ("Unable to delete %s - %s." % (e.filename, e.strerror))


def tempfile(name):
    return os.path.join(tempdir,name)


def toTempfile(name,content):
    new_file = open(tempfile(name), "w")
    new_file.write(content)
    new_file.close()


def convertShapes(shapes_file):
    shapes = transpile(shapes_file, 'src/grammar.ebnf')
    toTempfile("shapes.lp", shapes)


def runValidation(graph,no_assignment):
    if no_assignment:
        subprocess.run(["clingo", 
            "src/progs.lp", 
            "src/no-display.lp", 
            tempfile("shapes.lp"), 
            graph])
    else:
        subprocess.run(["clingo", 
            "src/progs.lp", 
            "src/display.lp", 
            tempfile("shapes.lp"), 
            graph])


def validateLP(graph,no_assignment):
    runValidation(graph,no_assignment)


def validateJSON(json,no_assignment):
    g = encode(json)
    toTempfile("graph.lp",g)
    runValidation(tempfile("graph.lp"),no_assignment)


def export4j(db,target):
    subprocess.run([os.path.join(db,'bin','cypher-shell'),
        'CALL apoc.export.json.all(\"exported.json\",{useTypes:true})'])
    shutil.move(os.path.join(db,'import','exported.json'), target)


def validate4J(db,no_assignment):
    export4j(db,tempfile("graph.json"))
    validateJSON(tempfile("graph.json"),no_assignment)


# Main command modes.

def validate(shapes,graph,json,neo4j_db,debug,no_assignment):
    try:
        os.makedirs(tempdir)
        convertShapes(shapes)
        if graph != None:
            validateLP(graph,no_assignment)
        elif json != None:
            validateJSON(json,no_assignment)
        else:
            validate4J(neo4j_db,no_assignment)
    finally:
        cleanup(debug)


def export(neo4j,json,debug):
    try:
        os.makedirs(tempdir)
        export4j(neo4j,json)
    finally:
        cleanup(debug)


def convert(json,asp,debug):
    try:
        os.makedirs(tempdir)
        new_file = open(asp, "w")
        new_file.write(encode(json))
        new_file.close()
    finally:
        cleanup(debug)


def parse(progs,out,debug):
    try:
        os.makedirs(tempdir)
        s = convertShapes(progs)
        if out != None:
            shutil.move(tempfile("shapes.lp"), out)
    finally:
        cleanup(debug)


# Main

def main():
    args = ap.parse_args()
    kwargs = vars(args)

    # Invoke the primary mode command.
    globals()[kwargs.pop('subparser')](**kwargs)

# Temporary outdir.
ts = calendar.timegm(time.gmtime())
tempdir = "out"+str(ts)

if __name__ == '__main__':
    # Show help if called with no arguments.
    if len(sys.argv)==1:
        ap.print_help(sys.stderr)
        sys.exit(0)
    main()