"""DSInterpret

http://www.cs.vu.nl/~mvermaat/things/vu/ds2003.xhtml

DSInterpret is a small interpreter for a simple mathematical language.
The language provides elements and collections datatypes and some basic
operations on collections.

This is grammar.py, a file with a BNF grammar definition needed by
ds_interpret.py.

"""


# All operators are left associative, * has highest precedence
precedence = (
    ('left',    'UNION', 'SYMDIFFERENCE', 'DIFFERENCE'),
    ('left',    'INTERSECTION')
)

# Struct of identifiers
identifiers = {}


# Grammar rules are below

def p_statement(t):
    """statement    : assignment
                    | print_s
                    | COMMENT"""

def p_assignment(t):
    """assignment   : IDENTIFIER ASSIGN expression"""
    identifiers[t[1]] = t[3]

def p_print_s(t):
    """print_s      : PRINT expression"""
    for e in t[2]: print e,
    print

def p_expression_binop(t):
    """expression   : expression UNION expression
                    | expression DIFFERENCE expression
                    | expression SYMDIFFERENCE expression
                    | expression INTERSECTION expression"""
    if t[2] == '+':
        t[0] = t[1] + filter(lambda x: x not in t[1], t[3])
    elif t[2] == '-':
        t[0] = filter(lambda x: x not in t[3], t[1])
    elif t[2] == '|':
        symdifference = lambda x: \
            (x in t[1] and x not in t[3]) \
            or (x in t[3] and x not in t[1])
        t[0] = filter(symdifference, t[1] + t[3])
    elif t[2] == '*':
        t[0] = filter(lambda x: x in t[1], t[3])

def p_expression_group(t):
    """expression   : LPAREN expression RPAREN"""
    t[0] = t[2]

def p_expression_collection(t):
    """expression   : LBRACE numbers RBRACE
                    | LBRACE RBRACE"""
    if t[2] == '}':
        t[0] = ()
    else:
        t[0] = t[2]

def p_expression_identifier(t):
    """expression   : IDENTIFIER"""
    try:
        t[0] = identifiers[t[1]]
    except LookupError:
        print "Undefined collection '%s'" % t[1]
        t[0] = ()

def p_numbers(t):
    """numbers      : NUMBER
                    | NUMBER COMMA numbers"""
    try:
        t[0] = t[3]
        if t[1] not in t[3]:
            t[0] = (t[1],) + t[3]
    except:
        t[0] = (t[1],)

def p_error(t):
    try:
        print "Syntax error at '%s'" % t.value
    except:
        print 'Syntax error at first character'
