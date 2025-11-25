#! /usr/bin/python

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

from basictoken import BASICToken as Token
from lexer import Lexer
from program import Program
from sys import stderr


def main():

    banner = (r"""
        ._____________    ___________.       ___        ___________    ______ 
        |   _   .__   \  /   ___   _  \     /   \      /           |  /      |
        |  |_)  |  \   \/   /  |  |_)  |   /  ^  \    |   (----`|  | |  ,----'
        |   ___/    \_    _/   |   _  <   /  /_\  \    \   \    |  | |  |     
        |  |          |  |     |  |_)   \/  _____  \----)   |   |  | |  `----.
        | _|          |__|     |___________/     \_________/    |____________|
        """)

    print(banner)

    lexer = Lexer()
    program = Program()

    # Continuously accept user input and act on it until
    # the user enters 'EXIT'
    while True:

        stmt = input('> ')

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
                elif tokenlist[0].category == Token.UNSIGNEDINT\
                     and len(tokenlist) > 1:
                    program.add_stmt(tokenlist)

                # Delete a statement from the program
                elif tokenlist[0].category == Token.UNSIGNEDINT \
                        and len(tokenlist) == 1:
                    program.delete_statement(int(tokenlist[0].lexeme))

                # Execute the program
                elif tokenlist[0].category == Token.RUN:
                    try:
                        program.execute()

                    except KeyboardInterrupt:
                        print("Program terminated")

                # List the program
                elif tokenlist[0].category == Token.LIST:
                     if len(tokenlist) == 2:
                         program.list(int(tokenlist[1].lexeme),int(tokenlist[1].lexeme))
                     elif len(tokenlist) == 3:
                         # if we have 3 tokens, it might be LIST x y for a range
                         # or LIST -y or list x- for a start to y, or x to end
                         if tokenlist[1].lexeme == "-":
                             program.list(None, int(tokenlist[2].lexeme))
                         elif tokenlist[2].lexeme == "-":
                             program.list(int(tokenlist[1].lexeme), None)
                         else:
                             program.list(int(tokenlist[1].lexeme),int(tokenlist[2].lexeme))
                     elif len(tokenlist) == 4:
                         # if we have 4, assume LIST x-y or some other
                         # delimiter for a range
                         program.list(int(tokenlist[1].lexeme),int(tokenlist[3].lexeme))
                     else:
                         program.list()

                # Save the program to disk
                elif tokenlist[0].category == Token.SAVE:
                    program.save(tokenlist[1].lexeme)
                    print("Program written to file")

                # Load the program from disk
                elif tokenlist[0].category == Token.LOAD:
                    program.load(tokenlist[1].lexeme)
                    print("Program read from file")

                # Delete the program from memory
                elif tokenlist[0].category == Token.NEW:
                    program.delete()

                # Renumber the program
                elif tokenlist[0].category == Token.RENUMBER:
                    try:
                        if len(tokenlist) == 1:
                            # RENUMBER with no arguments
                            program.renumber()
                        else:
                            # Parse comma-separated arguments, handling blank parameters
                            args = []
                            current_arg = ""
                            
                            for i in range(1, len(tokenlist)):
                                if tokenlist[i].category == Token.COMMA:
                                    # Process the accumulated argument
                                    if current_arg.strip():
                                        args.append(int(current_arg.strip()))
                                    else:
                                        args.append(None)  # Blank parameter
                                    current_arg = ""
                                elif tokenlist[i].category == Token.UNSIGNEDINT:
                                    current_arg += tokenlist[i].lexeme
                            
                            # Process the final argument if any
                            if current_arg.strip():
                                args.append(int(current_arg.strip()))
                            elif len(tokenlist) > 1 and tokenlist[-1].category == Token.COMMA:
                                args.append(None)  # Trailing comma means blank parameter
                            
                            # Convert args list to proper parameters for renumber()
                            # RENUMBER [newStart][,increment][,oldStart][,oldEnd]
                            new_start = args[0] if len(args) > 0 and args[0] is not None else 10
                            increment = args[1] if len(args) > 1 and args[1] is not None else 10
                            old_start = args[2] if len(args) > 2 and args[2] is not None else None
                            old_end = args[3] if len(args) > 3 and args[3] is not None else None
                            
                            program.renumber(new_start, increment, old_start, old_end)
                        print("Program renumbered")
                    except Exception as e:
                        print(f"RENUMBER error: {e}", file=stderr)

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
