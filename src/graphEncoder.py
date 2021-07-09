#!/usr/bin/python3

import json
import sys
from io import StringIO
import getopt

# Note:
# - We convert everything to lower case.
# - We replace " with ' in string values.

def putLabel(i, l):
    print("label({},{}).".format(i,l.lower()))


def clean(s):
    return s.replace('"', '\'')


def typeValue(v):
    if isinstance(v, int):
        return "integer({})".format(v)
    else:
        return "string(\"{}\")".format(clean(str(v)))


def putProperty(i, k, v):
    if isinstance(v,list):
        for vi in v:
            putProperty(i,k,vi)
    else:
        print("property({},{},{}).".format(i, k.lower(), typeValue(v)))


def putEdge(n1, e, n2):
    print("edge({},{},{}).".format(n1,e,n2))


def handleNode(data):
    nid = data["id"]
    try:
        label = data["label"]
        putLabel(nid, label)
    except KeyError:
        pass
    try:
        labels = data["labels"]
        for label in labels:
            putLabel(nid, label)
    except KeyError:
        pass
    try:
        properties = data["properties"]
        for k,v in properties.items():
            putProperty(nid,k,v)
    except KeyError:
        pass


def handleEdge(data):
    eid = data["id"]
    try:
        label = data["label"]
        putLabel(eid, label)
    except KeyError:
        pass
    try:
        labels = data["labels"]
        for label in labels:
            putLabel(eid, label)
    except KeyError:
        pass
    try:
        properties = data["properties"]
        for k,v in properties.items():
            putProperty(eid,k,v)
    except KeyError:
        pass
    start = data["start"]["id"]
    end = data["end"]["id"]
    putEdge(start, eid, end)


def encode(infile):
    sout = sys.stdout  
    result = StringIO()
    sys.stdout = result

    with open(infile) as f:
        for line in f:
            try:
                data = json.loads(line)
                if data['type'] == 'node':
                    handleNode(data)
                else:
                    handleEdge(data)
            except:
                sys.stderr.write("[WARNING] Ignoring malformed JSON: " + json.dumps(data) + "\n")

    sys.stdout = sout
    return result.getvalue()


def main(argv):
    infile = 'graph.json'
    usage = "Usage: translate.py -i <inputfile>"

    # Show help if called with no arguments.
    if len(sys.argv)==1:
        print(usage)
        sys.exit(0)

    try:
        opts, args = getopt.getopt(argv,'hi:',['ifile='])
    except getopt.GetoptError:
        print(usage)
        sys.exit(1)
    for opt,arg in opts:
      if opt == '-h':
         print(usage)
         sys.exit()
      elif opt in ('-i', '--ifile'):
         infile = arg
    print(encode(infile))

if __name__ == '__main__':
   main(sys.argv[1:])