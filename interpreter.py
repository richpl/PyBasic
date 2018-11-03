#! /usr/bin/python

"""
This class implements a BASIC interpreter that
presents a prompt to the user. The user may input
program statements, list them and run the program.
"""

from token import Token
from lexer import Lexer

# Dictionary that maps line numbers to tokenlists
program = {}

# Symbol table to hold variable names mapped
# to values
symbol_table = {}

def main():

    lexer = Lexer()

    # Continuously accept user input and act on it until
    # the user enters 'EXIT'
    while True:

        stmt = input('> ').upper()

        tokenlist = lexer.tokenize(stmt)

        if tokenlist[0].category == Token.EXIT:
            break

        else:
            for token in tokenlist:
                token.pretty_print()


if __name__ == "__main__":
    main()
