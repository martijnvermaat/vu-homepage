"""DSInterpret

http://www.cs.vu.nl/~mvermaat/things/vu/ds2003.xhtml

DSInterpret is a small interpreter for a simple mathematical language.
The language provides elements and collections datatypes and some basic
operations on collections.

This is tokens.py, a file with token definitions needed by ds_interpret.py.

"""


# List of tokens
tokens = (
    'IDENTIFIER', 'NUMBER', 'COMMENT',
    'UNION', 'DIFFERENCE', 'INTERSECTION', 'SYMDIFFERENCE', 'COMMA',
    'ASSIGN', 'PRINT', 'LPAREN', 'RPAREN', 'LBRACE', 'RBRACE'
)

# Simple tokens
t_UNION         = r'\+'
t_DIFFERENCE    = r'-'
t_INTERSECTION  = r'\*'
t_SYMDIFFERENCE = r'\|'
t_COMMA         = r','
t_ASSIGN        = r'='
t_PRINT         = r'\?'
t_LPAREN        = r'\('
t_RPAREN        = r'\)'
t_LBRACE        = r'{'
t_RBRACE        = r'}'
t_IDENTIFIER    = r'[a-zA-Z][a-zA-Z0-9]*'
t_COMMENT       = r"/[^\n]*"
t_NUMBER        = r'\d+'

# Ignore whitespace
t_ignore = " \t"

# Increment line counter at newline
def t_newline(t):
    r'\n+'
    t.lineno += t.value.count("\n")

# Print errormessage and skip illegal character
def t_error(t):
    print "Illegal character '%s'" % t.value[0]
    t.skip(1)
