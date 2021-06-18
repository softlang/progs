#!/usr/bin/python3

import sys
import getopt
from lark import Lark, Transformer

constraint_store = set()

class ShapeTransformer(Transformer):

    # Shapes

    def nodeshape(self, c):
        return 'nodeshape({},{},{}).'.format(c[0],c[2],c[1])

    def edgeshape(self, c):
        return 'edgeshape({},{},{}).'.format(c[0],c[2],c[1])

    # Node Target

    def nodetarget(self, items):
        return items[0]
    
    def nid(self, n):
        return 'node({})'.format(n[0])

    def bot(self, b):
        return 'bottom'

    def property(self, k):
        return "hasProperty({})".format(k[0])

    # Node Constraint

    def nodeconstraint_basic(self, items):
        c = items[0]
        constraint_store.add(c)
        return c

    def nodeconstraint_and(self, items):
        c = 'and({},{})'.format(items[0], items[1])
        constraint_store.add(c)
        return c

    def nodeconstraint_or(self, items):
        c = 'negate(and(negate({}),negate({})))'.format(items[0],items[1])
        constraint_store.add(c)
        return c

    def top(self, b):
        return 'top'

    def rnid(self, n):
        c = 'nodeID({})'.format(n[0])
        constraint_store.add(c)
        return c

    def negate(self, n):
        c = 'negate({})'.format(n[0])
        constraint_store.add(c)
        return c

    def path(self, p):
        return p[0]

    def greatereq(self, p):
        dat = p[0].data
        c = ''
        if dat == 'ge':
            c = 'greaterEq({},{},{})'.format(p[2],p[3],p[1])
        elif dat == 'le':
            c1 = 'greaterEq({},{},{})'.format(p[2],p[3],p[1]+1)
            constraint_store.add(c1)
            c = 'negate({})'.format(c1),
        elif dat == 'eq':
            c1 = 'greaterEq({},{},{})'.format(p[2],p[3],p[1]+1)
            c2 = 'greaterEq({},{},{})'.format(p[2],p[3],p[1])
            c3 = 'negate({})'.format(c1)
            constraint_store.add(c1)
            constraint_store.add(c2)
            constraint_store.add(c3)
            c = 'and({},{})'.format(c2,c3)
        elif dat == 'gr': 
            c = 'greaterEq({},{},{})'.format(p[2],p[3],p[1]+1)
        else: # ls
            c1 = 'greaterEq({},{},{})'.format(p[2],p[3],p[1])
            constraint_store.add(c1)
            c = 'negate({})'.format(c1),
        constraint_store.add(c)
        return c

    def greatereqe(self, p):
        dat = p[0].data
        c = ''
        if dat == 'ge':
            c = 'greaterEqE({},{})'.format(p[2],p[1])
        elif dat == 'le':
            c1 = 'greaterEqE({},{})'.format(p[2],p[1]+1)
            constraint_store.add(c1)
            c = 'negate({})'.format(c1),
        elif dat == 'eq':
            c1 = 'greaterEqE({},{})'.format(p[2],p[1]+1)
            c2 = 'greaterEqE({},{})'.format(p[2],p[1])
            c3 = 'negate({})'.format(c1)
            constraint_store.add(c1)
            constraint_store.add(c2)
            constraint_store.add(c3)
            c = 'and({},{})'.format(c2,c3)
        elif dat == 'gr': 
            c = 'greaterEqE({},{})'.format(p[2],p[1]+1)
        else: # ls
            c1 = 'greaterEqE({},{})'.format(p[2],p[1])
            constraint_store.add(c1)
            c = 'negate({})'.format(c1),
        constraint_store.add(c)
        return c

    def countprop(self, p):
        dat = p[0].data
        c = ''
        if dat == 'ge':
            c = 'countProp({},{},{})'.format(p[2],p[3],p[1])
        elif dat == 'le':
            c1 = 'countProp({},{},{})'.format(p[2],p[3],p[1]+1)
            constraint_store.add(c1)
            c = 'negate({})'.format(c1),
        elif dat == 'eq':
            c1 = 'countProp({},{},{})'.format(p[2],p[3],p[1]+1)
            c2 = 'countProp({},{},{})'.format(p[2],p[3],p[1])
            c3 = 'negate({})'.format(c1)
            constraint_store.add(c1)
            constraint_store.add(c2)
            constraint_store.add(c3)
            c = 'and({},{})'.format(c2,c3)
        elif dat == 'gr': 
            c = 'countProp({},{},{})'.format(p[2],p[3],p[1]+1)
        else: # ls
            c1 = 'countProp({},{},{})'.format(p[2],p[3],p[1])
            constraint_store.add(c1)
            c = 'negate({})'.format(c1),
        constraint_store.add(c)
        return c

    def string(self, s):
        return "isString"

    def int(self, s):
        return "isInteger"

    def compare(self, ps):
        c = 'compare({},{})'.format(ps[0],ps[1])
        constraint_store.add(c)
        return c

    def equals(self, ks):
        c = 'equals({},{})'.format(ks[0],ks[1])
        constraint_store.add(c)
        return c

    def comparevalue(self, pk):
        c = 'compareValue({},{},{},{})'.format(pk[0],pk[1],pk[2],pk[3])
        constraint_store.add(c)
        return c

    # Edge Target

    def edgetarget(self, items):
        return items[0]

    def eid(self, n):
        return 'edge({})'.format(n[0])

    # Edge Constraint

    def edgeconstraint_basic(self, items):
        return self.nodeconstraint_basic(items)

    def edgeconstraint_and(self, items):
        return self.nodeconstraint_and(items)

    def edgeconstraint_or(self, items):
        return self.nodeconstraint_or(items)

    def reid(self, e):
        c = 'edgeID({})'.format(e[0])
        constraint_store.add(c)
        return c

    def left(self, nc):
        c = 'left({})'.format(nc[0])
        constraint_store.add(c)
        return c

    def right(self, nc):
        c = 'right({})'.format(nc[0])
        constraint_store.add(c)
        return c

    # Basic

    def shapes(self, shs):
        return '\n'.join(shs)

    def label(self, word):
        return 'label({})'.format(word[0])
    
    def property(self, word):
        return word[0]
    
    def labelref(self, word):
        return word[0]

    def shape(self, items):
        return items[0]

    def WORD(self, word):
        return str(word)

    def NUMBER(self, nr):
        return int(nr)

def print_constraints():
    for c in constraint_store:
        print('constraint({}).'.format(c))


def main(argv):
    infile=''
    usage = "Usage: shapeTranslator.py -i <inputfile>"
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

    grammar = ''
    with open('src/grammar.ebnf', 'r') as file:
        grammar = file.read()

    shapes = ''
    with open(infile, 'r') as file:
        shapes = file.read()

    shape_parser = Lark(grammar, start='shapes')

    tree = shape_parser.parse(shapes)
    transformed = ShapeTransformer().transform(tree)
    print_constraints()
    print(transformed)

if __name__ == '__main__':
   main(sys.argv[1:])