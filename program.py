#! /usr/bin/python

"""Class representing a BASIC program.
This is a list of statements, ordered by
line number.

"""

from basictoken import BASICToken as Token
from basicparser import BASICParser
from sys import stderr


class Program:

    def __init__(self):
        # Dictionary to represent program
        # statements, keyed by line number
        self.__program = {}

        self.__parser = BASICParser()

        # Program counter
        self.__next_stmt = 0

    def list(self):
        """Lists the program"""
        line_numbers = self.line_numbers()

        for line_number in line_numbers:
            print(line_number, end=' ')

            statement = self.__program[line_number]
            for token in statement:
                # Add in quotes for strings
                if token.category == Token.STRING:
                    print('"' + token.lexeme + '"', end=' ')

                else:
                    print(token.lexeme, end=' ')

            print(flush=True)

    def add_stmt(self, tokenlist):
        """
        Adds the supplied token list
        to the program. The first token should
        be the line number. If a token list with the
        same line number already exists, this is
        replaced.

        :param tokenlist: List of BTokens representing a
        numbered program statement

        """
        try:
            line_number = int(tokenlist[0].lexeme)
            self.__program[line_number] = tokenlist[1:]

        except TypeError as err:
            print("Invalid line number - " + str(err),
                  file=stderr)
            print(flush=True)

    def line_numbers(self):
        """Returns a list of all the
        line numbers for the program,
        sorted

        :return: A sorted list of
        program line numbers
        """
        line_numbers = list(self.__program.keys())
        line_numbers.sort()

        return line_numbers

    def __execute(self, line_number):
        """Execute the statement with the
        specified line number

        :param line_number: The line number

        """
        statement = self.__program[line_number]

        try:
            self.__parser.parse(statement)

        except RuntimeError as err:
            print(err, 'in line', str(line_number),
                  file=stderr)
            print(flush=True)

    def execute(self):
        """Execute the program"""
        line_numbers = self.line_numbers()
        self.set_next_stmt(line_numbers[0])

        for line_number in line_numbers:
            self.__execute(line_number)

    def get_next_stmt(self):
        """
        Returns the line number of the next statement
        to be executed

        :return: The line number

        """

        return self.__next_stmt

    def set_next_stmt(self, line_number):
        """
        Sets the line number of the next
        statement to be executed

        :param line_number: The new line number
        """
        self.__next_stmt = line_number
