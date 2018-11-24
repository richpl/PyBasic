#! /usr/bin/python

"""This class implements a BASIC interpreter that
presents a prompt to the user. The user may input
program statements, list them and run the program.
The program may also be saved to disk and loaded
again.

"""

from basictoken import BASICToken as Token
from lexer import Lexer
from basicparser import BASICParser
from program import Program
from sys import stderr
import pickle


def main():

    banner = (
    """
    PPPP   Y   Y  BBBB    AAA    SSSS    I     CCC
    P   P   Y Y   B   B  A   A  S        I    C   
    P   P   Y Y   B   B  A   A  S        I    C
    PPPP     Y    BBBB   AAAAA  SSSS     I    C
    P        Y    B   B  A   A      S    I    C
    P        Y    B   B  A   A      S    I    C
    P        Y    BBBB   A   A  SSSS     I     CCC
    """)

    print(banner)

    lexer = Lexer()
    program = Program()

    # Continuously accept user input and act on it until
    # the user enters 'EXIT'
    while True:

        stmt = input('> ').upper()

        try:
            tokenlist = lexer.tokenize(stmt)

            # Execute commands directly, otherwise
            # add program statements to the stored
            # BASIC program

            if len(tokenlist) > 0:

                # Exit the interpreter
                if tokenlist[0].category == Token.EXIT:
                    break

                # Add a new program statement, beginning
                # a line number
                elif tokenlist[0].category == Token.UNSIGNEDINT:
                    program.add_stmt(tokenlist)

                # Execute the program
                elif tokenlist[0].category == Token.RUN:
                    program.execute()

                # List the program
                elif tokenlist[0].category == Token.LIST:
                    program.list()

                # Save the program to disk
                elif tokenlist[0].category == Token.SAVE:
                    try:
                        file = open(tokenlist[1].lexeme, 'w')
                        pickle.dump(program, file)

                    except OSError:
                        raise OSError("Could not write to file")

                # Load the program from disk
                elif tokenlist[0].category == Token.LOAD:
                    try:
                        file = open(tokenlist[1].lexeme, 'r')
                        program = pickle.load(file)

                    except OSError:
                        raise OSError("Could not read file")

                # Unrecognised input
                else:
                    print("Unrecognised input", file=stderr)
                    for token in tokenlist:
                        token.print_lexeme()
                    print(flush=True)

        # Trap all exceptions so that interpreter
        # keeps running
        except Exception as e:
            print(e, file=stderr, flush=True)


if __name__ == "__main__":
    main()
