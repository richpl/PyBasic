# SPDX-License-Identifier: GPL-3.0-or-later
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

"""This class implements a BASIC interpreter that
presents a prompt to the user. The user may input
program statements, list them and run the program.
The program may also be saved to disk and loaded
again.

"""

from .basictoken import BASICToken as Token
from .lexer import Lexer
from .program import Program
from sys import stderr


class Interpreter:
    """
    Implements an interactive interpreter which
    feeds commands to a PyBasic program object
    and allows running the program and listing
    lines
    """

    def __init__(self, terminal=None):
        self.lexer = Lexer()
        if not terminal:
            from .term import SimpleTerm
            self.__terminal = SimpleTerm()
        else:
            self.__terminal = terminal

    def main(self):
        """
        Primary entry point for the interpretation
        loop. Can be overloaded in subclassing to
        implement custom startup behavior
        """

        banner = """
            PPPP   Y   Y  BBBB    AAA    SSSS    I     CCC
            P   P   Y Y   B   B  A   A  S        I    C   
            P   P   Y Y   B   B  A   A  S        I    C
            PPPP     Y    BBBB   AAAAA  SSSS     I    C
            P        Y    B   B  A   A      S    I    C
            P        Y    B   B  A   A      S    I    C
            P        Y    BBBB   A   A  SSSS     I     CCC
            """

        self.__terminal.print(banner)
        self.__interpreter()

    def __list(self, start_line=None, end_line=None):
        """
        Handles textual listing of a program to the screen.
        can be overwritten to implement pagination or other
        hardware or use case specific behavior
        """
        line_numbers = self.program.line_numbers()
        if len(line_numbers) == 0:
            return

        if not start_line:
            start_line = int(line_numbers[0])

        if not end_line:
            end_line = int(line_numbers[-1])

        for line_number in line_numbers:
            if int(line_number) >= start_line and int(line_number) <= end_line:
                self.__terminal.write(self.program.str_statement(line_number))

    def __interpreter(self, prompt="> "):
        self.program = Program(self.__terminal)

        # Continuously accept user input and act on it until
        # the user enters 'EXIT'
        while True:
            self.__terminal.write(prompt)
            stmt = self.__terminal.input()

            try:
                tokenlist = self.lexer.tokenize(stmt)

                # Execute commands directly, otherwise
                # add program statements to the stored
                # BASIC program

                if len(tokenlist) > 0:

                    # Exit the interpreter
                    if tokenlist[0].category == Token.EXIT:
                        break

                    # Add a new program statement, beginning
                    # a line number
                    elif (
                        tokenlist[0].category == Token.UNSIGNEDINT
                        and len(tokenlist) > 1
                    ):
                        self.program.add_stmt(tokenlist)

                    # Delete a statement from the program
                    elif (
                        tokenlist[0].category == Token.UNSIGNEDINT
                        and len(tokenlist) == 1
                    ):
                        self.program.delete_statement(int(tokenlist[0].lexeme))

                    # Execute the program
                    elif tokenlist[0].category == Token.RUN:
                        try:
                            self.program.execute()

                        except KeyboardInterrupt:
                            self.__terminal.print("Program terminated")

                    # List the program
                    elif tokenlist[0].category == Token.LIST:
                        if len(tokenlist) == 2:
                            self.__list(
                                int(tokenlist[1].lexeme), int(tokenlist[1].lexeme)
                            )
                        elif len(tokenlist) == 3:
                            # if we have 3 tokens, it might be LIST x y for a range
                            # or LIST -y or list x- for a start to y, or x to end
                            if tokenlist[1].lexeme == "-":
                                self.__list(None, int(tokenlist[2].lexeme))
                            elif tokenlist[2].lexeme == "-":
                                self.__list(int(tokenlist[1].lexeme), None)
                            else:
                                self.__list(
                                    int(tokenlist[1].lexeme), int(tokenlist[2].lexeme)
                                )
                        elif len(tokenlist) == 4:
                            # if we have 4, assume LIST x-y or some other
                            # delimiter for a range
                            self.__list(
                                int(tokenlist[1].lexeme), int(tokenlist[3].lexeme)
                            )
                        else:
                            self.__list()

                    # Save the program to disk
                    elif tokenlist[0].category == Token.SAVE:
                        self.program.save(tokenlist[1].lexeme)
                        self.__terminal.print("Program written to file")

                    # Load the program from disk
                    elif tokenlist[0].category == Token.LOAD:
                        self.program.load(tokenlist[1].lexeme)
                        self.__terminal.print("Program read from file")

                    # Delete the program from memory
                    elif tokenlist[0].category == Token.NEW:
                        self.program.delete()
                        self.program = None
                        # Opportunity for GC here
                        self.program = Program(self.__terminal)

                    elif tokenlist[0].category == Token.CLEAR:
                        self.__terminal.clear()

                    # Unrecognised input
                    else:
                        self.__terminal.print("Unrecognised input")
                        for token in tokenlist:
                            self.__terminal.print(str(token))

            # Trap all exceptions so that interpreter
            # keeps running
            except Exception as e:
                self.__terminal.print(str(e))
