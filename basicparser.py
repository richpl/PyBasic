#! /usr/bin/python

from btoken import BToken


class BASICParser:

    # Symbol table to hold variable names mapped
    # to values
    __symbol_table = {}

    # Stack on which to store operands
    # when evaluating expressions
    __operand_stack = []

    __tokenlist = []
    __tokenindex = 0

    """
    Must be initialised with the list of 
    BTokens to be processed
    """
    def parse(self, tokenlist):
        self.__tokenlist = tokenlist
        self.__tokenindex = 0
        self.__stmt()

    """
    Advances to the next token
    """
    def __advance(self):
        # Move to the next token
        self.__tokenindex += 1

        if self.__tokenindex >= len(self.__tokenlist):
            raise RuntimeError('Unexpected end of statement')

        self.__token = self.__tokenlist[self.__tokenindex]

    """
    Consumes a token from the list
    """
    def __consume(self, expected_category):
        if self.__token.category == expected_category:
            self.__advance()

        else:
            raise RuntimeError('Expecting ' + expected_category)

    """
    Parse a program statement
    """
    def __stmt(self):
        # Assign the first token
        self.__token == self.__tokenlist[0]

        self.__simplestmt()

    """
    Parse a non-compund program statement
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
    Parse a PRINT statement
    """
    def __printstmt(self):
        self.__advance()   # Advance past PRINT token
        self.__consume(BToken.LEFTPAREN)
        self.__expr()
        print(self.__operand_stack.pop())
        self.consume(BToken.RIGHTPAREN)

    """
    Parse a LET statement
    """
    def __letstmt(self):
        self.__advance()  # Advance past the LET token
        self.__assignmentstmt()

    """
    Parse an assignment statement
    """
    def __assignmentstmt(self):
        left = self.__token.lexeme  # Save lexeme of
                                    # the current token
        self.advance()
        self.__consume(BToken.ASSIGNOP)
        self.__expr()
        self.__symbol_table[left] = self.__operand_stack.pop()

    """
    Parse a numerical expression consisting
    of two terms being added together
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
    Parse a numerical expression consisting
    of two factors being multiplied together
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

