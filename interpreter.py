#! /usr/bin/python

"""
This class implements a BASIC interpreter that
presents a prompt to the user. The user may input
program statements, list them and run the program.

>>> 100 LET I = 10
>>> 200 PRINT I
>>> LIST
100 LET I = 10
200 PRINT I
"""

from btoken import BToken
from lexer import Lexer
from basicparser import BASICParser

# Dictionary that maps line numbers to tokenlists
program = {}


def main():

    lexer = Lexer()
    parser = BASICParser()

    # Continuously accept user input and act on it until
    # the user enters 'EXIT'
    while True:

        stmt = input('> ').upper()

        tokenlist = lexer.tokenize(stmt)

        # Execute commands directly, otherwise
        # add program statements to the stored
        # BASIC program

        # Exit the interpreter
        if tokenlist[0].category == BToken.EXIT:
            break

        # Add a new program statement, beginning
        # a line number
        elif tokenlist[0].category == BToken.NUMBER:
            line_number = int(tokenlist[0].lexeme)
            program[line_number] = tokenlist[1:]

        # Execute the program
        elif tokenlist[0].category == BToken.RUN:
            line_numbers = list(program.keys())
            line_numbers.sort()

            for line_number in line_numbers:
                statement = program[line_number]
                parser.parse(statement)

        # List the program
        elif tokenlist[0].category == BToken.LIST:
            line_numbers = list(program.keys())
            line_numbers.sort()

            for line_number in line_numbers:
                print(line_number, end=' ')

                statement = program[line_number]
                for token in statement:
                    print(token.lexeme, end=' ')

                print(flush=True)

        # Unrecognised input
        else:
            print("Unrecognised input")
            for token in tokenlist:
                token.pretty_print()


if __name__ == "__main__":
    main()
