#! /usr/bin/python

"""
Class to represent a token for the BASIC
programming language. A token consists of
three items:

column      Column in which token starts
category    Category of the token
lexeme      Token in string form
"""


class BToken:

        """
        BToken categories
        """
        EOF         = 0   # End of file
        LET         = 1   # LET keyword
        LIST        = 2   # LIST command
        PRINT       = 3   # PRINT command
        RUN         = 4   # RUN command
        FOR         = 5   # FOR keyword
        NEXT        = 6   # NEXT keyword
        IF          = 7   # IF keyword
        THEN        = 8   # THEN keyword
        ELSE        = 9   # ELSE keyword
        ASSIGNOP    = 10  # '='
        LEFTPAREN   = 11  # '('
        RIGHTPAREN  = 12  # ')'
        PLUS        = 13  # '+'
        MINUS       = 14  # '-'
        TIMES       = 15  # '*'
        DIVIDE      = 16  # '/'
        NEWLINE     = 17  # End of line
        NUMBER      = 18  # Real or integer, may be signed
        NAME        = 19  # Identifier that is not a keyword
        EXIT        = 20  # Used to quit the interpreter
        DIM         = 21  # DIM keyword
        GREATER     = 22  # '>'
        LESSER      = 23  # '<'
        STEP        = 24  # STEP keyword
        GOTO        = 25  # GOTO keyword
        GOSUB       = 26  # GOSUB keyword
        INPUT       = 27  # INPUT keyword
        REM         = 28  # REM keyword
        RETURN      = 29  # RETURN keyword
        SAVE        = 30  # SAVE command
        LOAD        = 31  # LOAD command
        ERROR       = 99  # None of the above

        #category_names = {0: 'EOF', 1: 'LET'}

        smalltokens = {'=': ASSIGNOP, '(': LEFTPAREN, ')': RIGHTPAREN,
                       '+': PLUS, '-': MINUS, '*': TIMES, '/': DIVIDE,
                       '\n': NEWLINE, '': EOF, '<': LESSER,
                       '>': GREATER}

        # Dictionary of BASIC reserved words
        keywords = {'LET': LET, 'LIST': LIST, 'PRINT': PRINT,
                    'FOR': FOR, 'RUN': RUN, 'NEXT': NEXT,
                    'IF': IF, 'THEN': THEN, 'ELSE': ELSE,
                    'EXIT': EXIT, 'DIM': DIM, 'STEP': STEP,
                    'GOTO': GOTO, 'GOSUB': GOSUB,
                    'INPUT': INPUT, 'REM': REM, 'RETURN': RETURN,
                    'SAVE': SAVE, 'LOAD': LOAD}

        def __init__(self, column, category, lexeme):

            self.column = column      # Column in which token starts
            self.category = category  # Category of the token
            self.lexeme = lexeme      # Token in string form

        """
        Pretty prints the token
        """
        def pretty_print(self):
            print('Column:', self.column,
                  'Category:', self.category,
                  'Lexeme:', self.lexeme)

        def print_lexeme(self):
            print(self.lexeme, end=' ')

