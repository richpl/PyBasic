#! /usr/bin/python

"""Class to represent a token for the BASIC
programming language. A token consists of
three items:

column      Column in which token starts
category    Category of the token
lexeme      Token in string form

"""


class BASICToken:

        """BASICToken categories"""

        EOF             = 0   # End of file
        LET             = 1   # LET keyword
        LIST            = 2   # LIST command
        PRINT           = 3   # PRINT command
        RUN             = 4   # RUN command
        FOR             = 5   # FOR keyword
        NEXT            = 6   # NEXT keyword
        IF              = 7   # IF keyword
        THEN            = 8   # THEN keyword
        ELSE            = 9   # ELSE keyword
        ASSIGNOP        = 10  # '='
        LEFTPAREN       = 11  # '('
        RIGHTPAREN      = 12  # ')'
        PLUS            = 13  # '+'
        MINUS           = 14  # '-'
        TIMES           = 15  # '*'
        DIVIDE          = 16  # '/'
        NEWLINE         = 17  # End of line
        UNSIGNEDINT     = 18  # Integer
        NAME            = 19  # Identifier that is not a keyword
        EXIT            = 20  # Used to quit the interpreter
        DIM             = 21  # DIM keyword
        GREATER         = 22  # '>'
        LESSER          = 23  # '<'
        STEP            = 24  # STEP keyword
        GOTO            = 25  # GOTO keyword
        GOSUB           = 26  # GOSUB keyword
        INPUT           = 27  # INPUT keyword
        REM             = 28  # REM keyword
        RETURN          = 29  # RETURN keyword
        SAVE            = 30  # SAVE command
        LOAD            = 31  # LOAD command
        NOTEQUAL        = 32  # '<>'
        LESSEQUAL       = 33  # '<='
        GREATEQUAL      = 34  # '>='
        UNSIGNEDFLOAT   = 35  # Floating point number
        STRING          = 36  # String values
        TO              = 37  # TO keyword
        NEW             = 38  # NEW command
        EQUAL           = 39  # '='
        COMMA           = 40  # ','
        STOP            = 41  # STOP keyword
        COLON           = 42  # ':'
        ON              = 43  # ON keyword
        POW             = 44  # Power function
        SQR             = 45  # Square root function
        ABS             = 46  # Absolute value function

        # Displayable names for each token category
        catnames = ['EOF', 'LET', 'LIST', 'PRINT', 'RUN',
        'FOR', 'NEXT', 'IF', 'THEN', 'ELSE', 'ASSIGNOP',
        'LEFTPAREN', 'RIGHTPAREN', 'PLUS', 'MINUS', 'TIMES',
        'DIVIDE', 'NEWLINE', 'UNSIGNEDINT', 'NAME', 'EXIT',
        'DIM', 'GREATER', 'LESSER', 'STEP', 'GOTO', 'GOSUB',
        'INPUT', 'REM', 'RETURN', 'SAVE', 'LOAD',
        'NOTEQUAL', 'LESSEQUAL', 'GREATEQUAL',
        'UNSIGNEDFLOAT', 'STRING', 'TO', 'NEW', 'EQUAL',
        'COMMA', 'STOP', 'COLON', 'ON', 'POW', 'SQR', 'ABS']

        smalltokens = {'=': ASSIGNOP, '(': LEFTPAREN, ')': RIGHTPAREN,
                       '+': PLUS, '-': MINUS, '*': TIMES, '/': DIVIDE,
                       '\n': NEWLINE, '<': LESSER,
                       '>': GREATER, '<>': NOTEQUAL,
                       '<=': LESSEQUAL, '>=': GREATEQUAL, ',': COMMA,
                       ':': COLON}

        # Dictionary of BASIC reserved words
        keywords = {'LET': LET, 'LIST': LIST, 'PRINT': PRINT,
                    'FOR': FOR, 'RUN': RUN, 'NEXT': NEXT,
                    'IF': IF, 'THEN': THEN, 'ELSE': ELSE,
                    'EXIT': EXIT, 'DIM': DIM, 'STEP': STEP,
                    'GOTO': GOTO, 'GOSUB': GOSUB,
                    'INPUT': INPUT, 'REM': REM, 'RETURN': RETURN,
                    'SAVE': SAVE, 'LOAD': LOAD, 'NEW': NEW,
                    'STOP': STOP, 'TO': TO, 'ON':ON, 'POW': POW,
                    'SQR': SQR, 'ABS': ABS}

        # Functions
        functions = {POW, SQR, ABS}

        def __init__(self, column, category, lexeme):

            self.column = column      # Column in which token starts
            self.category = category  # Category of the token
            self.lexeme = lexeme      # Token in string form

        def pretty_print(self):
            """Pretty prints the token

            """
            print('Column:', self.column,
                  'Category:', self.catnames[self.category],
                  'Lexeme:', self.lexeme)

        def print_lexeme(self):
            print(self.lexeme, end=' ')

