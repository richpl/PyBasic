#! /usr/bin/python
"""
Implements a BASIC parser that parses a single
statement when supplied.
"""

from btoken import BToken


class BASICParser:

    def __init__(self):
        # Symbol table to hold variable names mapped
        # to values
        self.__symbol_table = {}

        # Stack on which to store operands
        # when evaluating expressions
        self.__operand_stack = []

        # These values will be
        # initialised on a per
        # statement basis
        self.__tokenlist = []
        self.__tokenindex = None

    """
    Must be initialised with the list of 
    BTokens to be processed. These tokens
    represent a BASIC statement without
    its corresponding line number.
    """
    def parse(self, tokenlist):
        self.__tokenlist = tokenlist
        self.__tokenindex = 0

        # Assign the first token
        self.__token = self.__tokenlist[self.__tokenindex]

        self.__stmt()

    """
    Advances to the next token
    """
    def __advance(self):
        # Move to the next token
        self.__tokenindex += 1

        # Acquire the next token if there any left
        if not self.__tokenindex >= len(self.__tokenlist):
            self.__token = self.__tokenlist[self.__tokenindex]

    """
    Consumes a token from the list
    """
    def __consume(self, expected_category):
        if self.__token.category == expected_category:
            self.__advance()

        else:
            raise RuntimeError('Expecting ' + BToken.category_name(expected_category))

    """
    Parses a program statement
    """
    def __stmt(self):
        self.__simplestmt()

    """
    Parses a non-compound program statement
    """
    def __simplestmt(self):
        if self.__token.category == BToken.NAME:
            self.__assignmentstmt()

        elif self.__token.category == BToken.PRINT:
            self.__printstmt()

        elif self.__token.category == BToken.LET:
            self.__letstmt()

        else:
            raise RuntimeError('Expecting program statement')

    """
    Parses a PRINT statement, causing
    the value that is on top of the
    operand stack to be printed on
    the screen.
    """
    def __printstmt(self):
        self.__advance()   # Advance past PRINT token
        self.__expr()
        print(self.__operand_stack.pop())

    """
    Parses a LET statement,
    consuming the LET keyword.
    """
    def __letstmt(self):
        self.__advance()  # Advance past the LET token
        self.__assignmentstmt()

    """
    Parses an assignment statement, 
    placing the corresponding
    variable and its value in the symbol
    table
    """
    def __assignmentstmt(self):
        left = self.__token.lexeme  # Save lexeme of
                                    # the current token
        self.__advance()
        self.__consume(BToken.ASSIGNOP)
        self.__expr()
        self.__symbol_table[left] = self.__operand_stack.pop()

    """
    Parses a numerical expression consisting
    of two terms being added together,
    leaving the result on the operand stack.
    """
    def __expr(self):
        self.__term()  # Pushes value of left term
                       # onto top of stack

        while self.__token.category == BToken.PLUS:
            self.__advance()
            self.__term()  # Pushes value of right term
                           # onto top of stack
            rightoperand = self.__operand_stack.pop()
            leftoperand = self.__operand_stack.pop()
            self.__operand_stack.append(leftoperand + rightoperand)

    """
    Parses a numerical expression consisting
    of two factors being multiplied together,
    leaving the result on the operand stack.
    """
    def __term(self):
        self.__sign = 1  # Initialise sign to keep track of unary
                         # minuses
        self.__factor()  # Leaves value of term on top of stack

        while self.__token.category == BToken.TIMES:
            self.__advance()
            self.__sign = 1  # Initialise sign
            self.__factor()  # Leaves value of term on top of stack
            rightoperand = self.__operand_stack.pop()
            leftoperand = self.__operand_stack.pop()
            self.__operand_stack.append(leftoperand * rightoperand)

    """
    Evaluates a numerical expression 
    and leaves its value on top of the 
    operand stack.
    """
    def __factor(self):
        if self.__token.category == BToken.PLUS:
            self.__advance()
            self.__factor()

        elif self.__token.category == BToken.MINUS:
            self.__sign = -self.__sign
            self.__advance()
            self.__factor()

        elif self.__token.category == BToken.NUMBER:
            self.__operand_stack.append(self.__sign*int(self.__token.lexeme))
            self.__advance()

        elif self.__token.category == BToken.NAME:
            if self.__token.lexeme in self.__symbol_table:
                self.__operand_stack.append(self.__sign*self.__symbol_table[self.__token.lexeme])

            else:
                raise RuntimeError('Name ' + self.__token.lexeme + ' is not defined')

            self.__advance()

        elif self.__token.category == BToken.LEFTPAREN:
            self.__advance()

            # Save sign because expr() calls term() which resets
            # sign to 1
            savesign = self.__sign
            self.__expr()  # Value of expr is pushed onto stack

            if savesign == -1:
                # Change sign of expression
                self.__operand_stack[-1] = -self.__operand_stack[-1]

            self.__consume(BToken.RIGHTPAREN)

        else:
            raise RuntimeError('Expecting factor in numeric expression')

