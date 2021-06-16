#!/usr/bin/python3

import json
import sys
import getopt

# Note:
# - We take only the first element of lists (properties) and drop tail!
# - Any Label or Property Name is modified, such that the first character
#   is lower case.
# - We replace " with ' in strings.

def lowerFirst(s):
    if s:
        return s[:1].lower() + s[1:]
    else:
        return ""

def putLabel(i, l):
    print("label({},{}).".format(i,lowerFirst(l)))


def clean(s):
    return s.replace('"', '\'')


def typeValue(v):
    if isinstance(v, int):
        return "integer({})".format(v)
    elif isinstance(v, list):
        return typeValue(v[0])
    else:
        return "string(\"{}\")".format(clean(str(v)))


def putProperty(i, k, v):
    print("property({},{},{}).".format(i, lowerFirst(k), typeValue(v)))


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


def main(argv):
    infile="graph.json"
    try:
        opts, args = getopt.getopt(argv,"hi:",["ifile="])
    except getopt.GetoptError:
        print("Usage: translate.py -i <inputfile>")
        sys.exit(1)
    for opt,arg in opts:
      if opt == '-h':
         print('test.py -i <inputfile>')
         sys.exit()
      elif opt in ("-i", "--ifile"):
         infile = arg

    with open(infile) as f:
        for line in f:
            try:
                data = json.loads(line)
                if data["type"] == "node":
                    handleNode(data)
                else:
                    handleEdge(data)
            except:
                sys.stderr.write("[WARNING] Ignoring malformed JSON: " + json.dumps(data) + "\n")

if __name__ == "__main__":
   main(sys.argv[1:])
