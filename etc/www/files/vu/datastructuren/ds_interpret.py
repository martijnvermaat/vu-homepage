#!/opt/local/bin/python

"""DSInterpret

http://www.cs.vu.nl/~mvermaat/things/vu/ds2003.xhtml

DSInterpret is a small interpreter for a simple mathematical language.
The language provides elements and collections datatypes and some basic
operations on collections.

Basic usage:
$ python ds_interpret

To interpret commands stored in a file, privide the location as argument:
$ python ds_interpret commands

Example:
$ python ds_interpret.py
DSInterpret version 0.1 (2003/10/24)
Martijn Vermaat (mvermaat@cs.vu.nl)
> a = {1, 2, 3}
> b = {3, 4, 5}
> ? a+b
 1 2 3 4
> 

DSInterpret uses PLY (Python Lex-Yacc), you can find these here:
http://systems.cs.uchicago.edu/ply/

You will also need tokens.py (token definitions for lex) and grammar.py
(BNF grammar definition for yacc).

Supported datatypes:
* Element                   : string of digits
* Collection of elements    : {element1, element2, ..., elementn}

Supported operations:
* Union                 : collection1 + collection2
* Intersection          : collection1 * collection2
* Difference            : collection1 - collection2
* Symmetric difference  : collectino1 | collection2

Supported statements:
* Assignment            : myvar = expression
* Print expression      : ? expression

Parentheses are supported to override standard precedence of operators.

"""

__version__ = '0.2'
__date__ = '2003/10/30'
__author__ = 'Martijn Vermaat (mvermaat@cs.vu.nl)'
__copyright__ = 'Copyright 2003, Martijn Vermaat'
__license__ = 'GPL'
__history__ = """
0.1 - 2003/10/24 - Initial release
0.2 - 2003/10/30 - DSInterpret does not accept empty lines from now
"""

import sys, lex, yacc

from tokens import *
from grammar import *


def print_no_space(x):
    """
    Use this method to work around the space Python prints
    after printing a string without a newline
    """
    sys.stdout.softspace = 0
    print x,

pns = print_no_space    # Easier to type


lex.lex()
yacc.yacc()

prompt = 1
input = sys.stdin

if sys.argv[1:]:
    try:
        input = open(sys.argv[1], 'r')
        prompt = 0
    except IOError:
        print "Could not find file: %s\n" % sys.argv[1], 'Using standard input'
        print

if prompt:
    print 'DSInterpret version %s (%s)' % (__version__, __date__)
    print '%s' % __author__
    print '> ',

s = input.readline()
while s:
    yacc.parse(s)
    if prompt: pns('> ')
    s = input.readline()
