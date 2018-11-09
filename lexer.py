#! /usr/bin/python

"""
This class implements a lexical analyser capable
of consuming BASIC statements and commands and returning
a corresponding list of tokens.

>>> lexer = Lexer()
>>> tokenlist = lexer.tokenize("100 LET I = 10")
>>> tokenlist[0].pretty_print()
Column: 0 Category: 18 Lexeme: 100
"""

from btoken import BToken


class Lexer:

    def __init__(self):

        self.__column = 0  # Current column number
        self.__stmt = ''   # Statement string being processed

    """
    Returns a list of tokens obtained by
    lexical analysis of the specified
    statement.
    """
    def tokenize(self, stmt):

        self.__stmt = stmt
        self.__column = 0

        # Establish a list of tokens to be
        # derived from the statement
        tokenlist = []

        # Process every character until we
        # reach the end of the statement string
        c = self.__get_next_char()
        while c != '':

            # Skip any preceding whitespace
            while c.isspace():
                c = self.__get_next_char()

            # Construct a token, column count already
            # incremented
            token = BToken(self.__column - 1, None, '')

            # Process numbers
            if c.isdigit() or c == '.':  # Cater for integers and reals
                token.category = BToken.NUMBER

                # Consume all of the digits
                while True:
                    token.lexeme += c  # append the current char to the lexeme
                    c = self.__get_next_char()

                    # Break if next character is not a digit
                    if not c.isdigit():
                        break

            # Process keywords and names
            elif c.isalpha():
                # Consume all of the letters
                while True:
                    token.lexeme += c  # append the current char to the lexeme
                    c = self.__get_next_char()

                    # Break if not a letter or a dollar symbol
                    # (the latter is used for string variable names)
                    if not (c.isalpha() or c == '$'):
                        break

                # Determine if the lexeme is a variable name or a
                # reserved word
                if token.lexeme in BToken.keywords:
                    token.category = BToken.keywords[token.lexeme]

                else:
                    token.category = BToken.NAME

            # Process operator symbols
            elif c in BToken.smalltokens:
                token.category = BToken.smalltokens[c]
                token.lexeme = c
                c = self.__get_next_char()

            # We do not recognise this token
            else:
                raise SyntaxError('Syntax error')

            # Append the new token to the list
            tokenlist.append(token)

        return tokenlist

    """
    Returns the next character in the 
    statement, unless the last character has already
    been processed, in which case, the empty string is
    returned.
    """
    def __get_next_char(self):

        if self.__column < len(self.__stmt):
            next_char = self.__stmt[self.__column]
            self.__column = self.__column + 1

            return next_char

        else:
            return ''


if __name__ == "__main__":
    import doctest
    doctest.testmod()
