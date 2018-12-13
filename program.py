#! /usr/bin/python

"""Class representing a BASIC program.
This is a list of statements, ordered by
line number.

"""

from basictoken import BASICToken as Token
from basicparser import BASICParser
from jumptype import JumpType
import pickle


class Program:

    def __init__(self):
        # Dictionary to represent program
        # statements, keyed by line number
        self.__program = {}

        self.__parser = BASICParser()

        # Program counter
        self.__next_stmt = 0

        # Initialise return stack for subroutine returns
        # and loop returns
        self.__return_stack = []

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

    def save(self, file):
        """Save the program

        :param file: The name and path of the save file

        """
        try:
            with open(file, 'wb') as outfile:
                pickle.dump(self.__program, outfile)
                outfile.close()

        except OSError:
            raise OSError("Could not save to file")

    def load(self, file):
        """Load the program

        :param file: The name and path of the file to be loaded"""
        try:
            with open(file, 'rb') as infile:
                self.__program = pickle.load(infile)
                infile.close()

        except OSError:
            raise OSError("Could not read file")

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
            raise TypeError("Invalid line number: " +
                            str(err))

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

        :return: The JumpType to indicate to the program
        how to branch if necessary, None otherwise

        """
        if line_number not in self.__program.keys():
            raise RuntimeError("Line number " + line_number +
                               " does not exist")

        statement = self.__program[line_number]

        try:
            return self.__parser.parse(statement)

        except RuntimeError as err:
            raise RuntimeError(str(err) + ' in line ' +
                               str(line_number))

    def execute(self):
        """Execute the program"""

        line_numbers = self.line_numbers()

        if len(line_numbers) > 0:
            # Set up an index into the ordered list
            # of line numbers that can be used for
            # sequential statement execution. The index
            # will be incremented by one, unless modified by
            # a jump
            index = 0
            self.set_next_line_number(line_numbers[index])

            # Run through the program until the
            # has line number has been reached
            while True:
                jumptype = self.__execute(self.get_next_line_number())

                if jumptype:
                    if jumptype.jtype == JumpType.SIMPLE_JUMP:
                        # GOTO or conditional branch encountered
                        try:
                            index = line_numbers.index(jumptype.jtarget)

                        except ValueError:
                            raise RuntimeError("Invalid line number supplied in GOTO or conditional branch: "
                                               + str(jumptype.jtarget))

                        self.set_next_line_number(jumptype.jtarget)

                    elif jumptype.jtype == JumpType.GOSUB:
                        # Subroutine call encountered
                        # Add line number of next instruction to
                        # the return stack
                        if index + 1 < len(line_numbers):
                            self.__return_stack.append(line_numbers[index + 1])

                        else:
                            raise RuntimeError("GOSUB at end of program, nowhere to return")

                        # Set the index to be the subroutine start line
                        # number
                        try:
                            index = line_numbers.index(jumptype.jtarget)

                        except ValueError:
                            raise RuntimeError("Invalid line number supplied in subroutine call: "
                                               + str(jumptype.jtarget))

                        self.set_next_line_number(jumptype.jtarget)

                    elif jumptype.jtype == JumpType.RETURN:
                        # Subroutine return encountered
                        # Pop return address from the stack
                        try:
                            index = line_numbers.index(self.__return_stack.pop())

                        except ValueError:
                            raise RuntimeError("Invalid subroutine return in line " +
                                               str(self.get_next_line_number()))

                        except IndexError:
                            raise RuntimeError("RETURN encountered without corresponding " +
                                               "subroutine call in line " + str(self.get_next_line_number()))

                        self.set_next_line_number(line_numbers[index])

                    elif jumptype.jtype == JumpType.LOOP_BEGIN:
                        # Loop return encountered
                        j = 10 # Placeholder code

                else:
                    index = index + 1

                    if index < len(line_numbers):
                        self.set_next_line_number(line_numbers[index])

                    else:
                        # Reached end of program
                        break

        else:
            raise RuntimeError("No statements to execute")

    def delete(self):
        """Deletes the program by emptying the dictionary"""
        self.__program = {}

    def get_next_line_number(self):
        """Returns the line number of the next statement
        to be executed

        :return: The line number

        """

        return self.__next_stmt

    def set_next_line_number(self, line_number):
        """Sets the line number of the next
        statement to be executed

        :param line_number: The new line number

        """
        self.__next_stmt = line_number
