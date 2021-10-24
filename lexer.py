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

"""This class implements a lexical analyser capable
of consuming BASIC statements and commands and returning
a corresponding list of tokens.

>>> lexer = Lexer()
>>> tokenlist = lexer.tokenize('100 LET I = 10')
>>> tokenlist[0].pretty_print()
Column: 0 Category: UNSIGNEDINT Lexeme: 100
>>> tokenlist = lexer.tokenize('100 IF I <> 10')
>>> tokenlist[3].pretty_print()
Column: 9 Category: NOTEQUAL Lexeme: <>
>>> tokenlist = lexer.tokenize('100 LET I = 3.45')
>>> tokenlist[4].pretty_print()
Column: 12 Category: UNSIGNEDFLOAT Lexeme: 3.45
>>> tokenlist = lexer.tokenize('100 LET I = "HELLO"')
>>> tokenlist[4].pretty_print()
Column: 12 Category: STRING Lexeme: HELLO
"""

from basictoken import BASICToken as Token


class Lexer:

    def __init__(self):

        self.__column = 0  # Current column number
        self.__stmt = ''   # Statement string being processed

    def tokenize(self, stmt):
        """Returns a list of tokens obtained by
        lexical analysis of the specified
        statement.

        """
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
            token = Token(self.__column - 1, None, '')

            # Process strings
            if c == '"':
                token.category = Token.STRING

                # Consume all of the characters
                # until we reach the terminating
                # quote. Do not store the quotes
                # in the lexeme
                c = self.__get_next_char()  # Advance past opening quote

                # We explicitly support empty strings
                if c == '"':
                    # String is empty, leave lexeme as ''
                    # and advance past terminating quote
                    c = self.__get_next_char()

                else:
                    while True:
                        token.lexeme += c  # Append the current char to the lexeme
                        c = self.__get_next_char()

                        if c == '':
                            raise SyntaxError("Mismatched quotes")

                        if c == '"':
                            c = self.__get_next_char()  # Advance past terminating quote
                            break

            # Process numbers
            elif c.isdigit():
                token.category = Token.UNSIGNEDINT
                found_point = False

                # Consume all of the digits, including any decimal point
                while True:
                    token.lexeme += c  # Append the current char to the lexeme
                    c = self.__get_next_char()

                    # Break if next character is not a digit
                    # and this is not the first decimal point
                    if not c.isdigit():
                        if c == '.':
                            if not found_point:
                                found_point = True
                                token.category = Token.UNSIGNEDFLOAT

                            else:
                                # Another decimal point found
                                break

                        else:
                            break

            # Process keywords and names
            elif c.isalpha():
                # Consume all of the letters
                while True:
                    token.lexeme += c  # append the current char to the lexeme
                    c = self.__get_next_char()

                    # Break if not a letter or a dollar symbol
                    # (the latter is used for string variable names)
                    if not ((c.isalpha() or c.isdigit()) or c == '_' or c == '$'):
                        break

                # Normalise keywords and names to upper case
                token.lexeme = token.lexeme.upper()

                # Determine if the lexeme is a variable name or a
                # reserved word
                if token.lexeme in Token.keywords:
                    token.category = Token.keywords[token.lexeme]

                else:
                    token.category = Token.NAME

                # Remark Statements - process rest of statement without checks
                if token.lexeme == "REM":
                    while c!= '':
                        token.lexeme += c  # Append the current char to the lexeme
                        c = self.__get_next_char()

            # Process operator symbols
            elif c in Token.smalltokens:
                save = c
                c = self.__get_next_char()  # c might be '' (end of stmt)
                twochar = save + c

                if twochar in Token.smalltokens:
                    token.category = Token.smalltokens[twochar]
                    token.lexeme = twochar
                    c = self.__get_next_char() # Move past end of token

                else:
                    # One char token
                    token.category = Token.smalltokens[save]
                    token.lexeme = save

            # We do not recognise this token
            elif c != '':
                raise SyntaxError('Syntax error')

            # Append the new token to the list
            tokenlist.append(token)

        return tokenlist

    def __get_next_char(self):
        """Returns the next character in the
        statement, unless the last character has already
        been processed, in which case, the empty string is
        returned.

        """
        if self.__column < len(self.__stmt):
            next_char = self.__stmt[self.__column]
            self.__column = self.__column + 1

            return next_char

        else:
            return ''


if __name__ == "__main__":
    import doctest
    doctest.testmod()