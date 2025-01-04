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

class Interpreter:
    def __init__(self):
        self.lexer = Lexer()
        self.program = Program()

    def process_command(self, stmt: str) -> str:
        try:
            tokenlist = self.lexer.tokenize(stmt)

            if len(tokenlist) > 0:
                # Exit the interpreter
                if tokenlist[0].category == Token.EXIT:
                    return "Exiting interpreter."

                # Add a new program statement
                elif tokenlist[0].category == Token.UNSIGNEDINT and len(tokenlist) > 1:
                    self.program.add_stmt(tokenlist)
                    return f"Statement added: {stmt}"

                # Delete a statement
                elif tokenlist[0].category == Token.UNSIGNEDINT and len(tokenlist) == 1:
                    self.program.delete_statement(int(tokenlist[0].lexeme))
                    return f"Statement deleted: {stmt}"

                # Execute the program
                elif tokenlist[0].category == Token.RUN:
                    try:
                        self.program.execute()
                        return "Program executed."
                    except KeyboardInterrupt:
                        return "Program terminated by user."

                # List the program
                elif tokenlist[0].category == Token.LIST:
                    output = self.program.list()
                    return f"Program listing:\n{output}"

                # Save the program to disk
                elif tokenlist[0].category == Token.SAVE:
                    filename = tokenlist[1].lexeme
                    self.program.save(filename)
                    return f"Program saved to {filename}"

                # Load a program from disk
                elif tokenlist[0].category == Token.LOAD:
                    filename = tokenlist[1].lexeme
                    self.program.load(filename)
                    return f"Program loaded from {filename}"

                # Delete the program from memory
                elif tokenlist[0].category == Token.NEW:
                    self.program.delete()
                    return "Program cleared."

                # Unrecognized input
                else:
                    return "Unrecognized input."
        except Exception as e:
            return f"Error: {e}"

# Example Usage
interpreter = Interpreter()
print(interpreter.process_command('10 PRINT "Hello world"'))
print(interpreter.process_command("RUN"))
