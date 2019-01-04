#! /usr/bin/python

from basictoken import BASICToken as Token
from flowsignal import FlowSignal
import math
import random

"""Implements a BASIC array, which may have up
to three dimensions of fixed size.

"""
class BASICArray:

    def __init__(self, dimensions):
        """Initialises te object with the specified
        number of dimensions. Maximum number of
        dimensions is three

        :param dimensions: List of array dimensions and their
        corresponding sizes

        """
        if len(dimensions) == 0:
            raise SyntaxError("Zero dimensional array specified")

        if len(dimensions) == 1:
            self.data = [None for x in range(dimensions[0])]
            self.dims = 1

        if len(dimensions) == 2:
            self.data = [[None for x in range(dimensions[1])] for x in range(dimensions[0])]
            self.dims = 2

        if len(dimensions) > 2:
            self.data = [[[None for x in range(dimensions[2])] for x in range(dimensions[1])] for x in range(dimensions[0])]
            self.dims = 3

    def pretty_print(self):
        print(str(self.data))

"""Implements a BASIC parser that parses a single
statement when supplied.

"""
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

        # Set to keep track of extant loop variables
        self. __loop_vars = set()

    def parse(self, tokenlist, line_number):
        """Must be initialised with the list of
        BTokens to be processed. These tokens
        represent a BASIC statement without
        its corresponding line number.

        :param tokenlist: The tokenized program statement
        :param line_number: The line number of the statement

        :return: The FlowSignal to indicate to the program
        how to branch if necessary, None otherwise

        """
        self.__tokenlist = tokenlist
        self.__tokenindex = 0

        # Remember the line number to aid error reporting
        self.__line_number = line_number

        # Assign the first token
        self.__token = self.__tokenlist[self.__tokenindex]

        return self.__stmt()

    def __advance(self):
        """Advances to the next token

        """
        # Move to the next token
        self.__tokenindex += 1

        # Acquire the next token if there any left
        if not self.__tokenindex >= len(self.__tokenlist):
            self.__token = self.__tokenlist[self.__tokenindex]

    def __consume(self, expected_category):
        """Consumes a token from the list

        """
        if self.__token.category == expected_category:
            self.__advance()

        else:
            raise RuntimeError('Expecting ' + Token.catnames[expected_category] +
                               ' in line ' + str(self.__line_number))

    def __stmt(self):
        """Parses a program statement

        :return: The FlowSignal to indicate to the program
        how to branch if necessary, None otherwise

        """
        if self.__token.category in [Token.FOR, Token.IF, Token.NEXT,
                                     Token.ON]:
            return self.__compoundstmt()

        else:
            return self.__simplestmt()

    def __simplestmt(self):
        """Parses a non-compound program statement

        :return: The FlowSignal to indicate to the program
        how to branch if necessary, None otherwise

        """
        if self.__token.category == Token.NAME:
            self.__assignmentstmt()
            return None

        elif self.__token.category == Token.PRINT:
            self.__printstmt()
            return None

        elif self.__token.category == Token.LET:
            self.__letstmt()
            return None

        elif self.__token.category == Token.GOTO:
            return self.__gotostmt()

        elif self.__token.category == Token.GOSUB:
            return self.__gosubstmt()

        elif self.__token.category == Token.RETURN:
            return self.__returnstmt()

        elif self.__token.category == Token.STOP:
            return self.__stopstmt()

        elif self.__token.category == Token.INPUT:
            self.__inputstmt()
            return None

        elif self.__token.category == Token.DIM:
            self.__dimstmt()
            return None

        elif self.__token.category == Token.RANDOMIZE:
            self.__randomizestmt()
            return None

        else:
            # Ignore comments, but raise an error
            # for anything else
            if self.__token.category != Token.REM:
                raise RuntimeError('Expecting program statement in line '
                                   + str(self.__line_number))

    def __printstmt(self):
        """Parses a PRINT statement, causing
        the value that is on top of the
        operand stack to be printed on
        the screen.

        """
        self.__advance()   # Advance past PRINT token

        # Check there are items to print
        if not self.__tokenindex >= len(self.__tokenlist):
            self.__relexpr()
            print(self.__operand_stack.pop(), end='')

            while self.__token.category == Token.COMMA:
                self.__advance()
                self.__relexpr()
                print(self.__operand_stack.pop(), end='')

        # Final newline
        print()

    def __letstmt(self):
        """Parses a LET statement,
        consuming the LET keyword.
        """
        self.__advance()  # Advance past the LET token
        self.__assignmentstmt()

    def __gotostmt(self):
        """Parses a GOTO statement

        :return: A FlowSignal containing the target line number
        of the GOTO

        """
        self.__advance()  # Advance past GOTO token
        self.__expr()

        # Set up and return the flow signal
        return FlowSignal(ftarget=self.__operand_stack.pop())

    def __gosubstmt(self):
        """Parses a GOSUB statement

        :return: A FlowSignal containing the first line number
        of the subroutine

        """

        self.__advance()  # Advance past GOSUB token
        self.__expr()

        # Set up and return the flow signal
        return FlowSignal(ftarget=self.__operand_stack.pop(),
                          ftype=FlowSignal.GOSUB)

    def __returnstmt(self):
        """Parses a RETURN statement"""

        self.__advance()  # Advance past RETURN token

        # Set up and return the flow signal
        return FlowSignal(ftype=FlowSignal.RETURN)

    def __stopstmt(self):
        """Parses a STOP statement"""

        self.__advance()  # Advance past STOP token

        return FlowSignal(ftype=FlowSignal.STOP)

    def __assignmentstmt(self):
        """Parses an assignment statement,
        placing the corresponding
        variable and its value in the symbol
        table.

        """
        left = self.__token.lexeme  # Save lexeme of
                                    # the current token
        self.__advance()

        if self.__token.category == Token.LEFTPAREN:
            # We are assiging to an array
            self.__arrayassignmentstmt(left)

        else:
            # We are assigning to a simple variable
            self.__consume(Token.ASSIGNOP)
            self.__relexpr()

            # Check that we are using the right variable name format
            right = self.__operand_stack.pop()

            if left.endswith('$') and not isinstance(right, str):
                raise SyntaxError('Syntax error: Attempt to assign non string to string variable' +
                                  ' in line ' + str(self.__line_number))

            elif not left.endswith('$') and isinstance(right, str):
                raise SyntaxError('Syntax error: Attempt to assign string to numeric variable' +
                                  ' in line ' + str(self.__line_number))

            self.__symbol_table[left] = right

    def __dimstmt(self):
        """Parses  DIM statement and creates a symbol
        table entry for an array of the specified
        dimensions.

        """
        self.__advance()  # Advance past DIM keyword

        # Extract the array name, append a suffix so
        # that we can distinguish from simple variables
        # in the symbol table
        name = self.__token.lexeme + '_array'
        self.__advance()  # Advance past array name

        self.__consume(Token.LEFTPAREN)

        # Extract the dimensions
        dimensions = []
        if not self.__tokenindex >= len(self.__tokenlist):
            self.__expr()
            dimensions.append(self.__operand_stack.pop())

            while self.__token.category == Token.COMMA:
                self.__advance()  # Advance past comma
                self.__expr()
                dimensions.append(self.__operand_stack.pop())

        self.__consume(Token.RIGHTPAREN)

        if len(dimensions) > 3:
            raise SyntaxError("Maximum number of array dimensions is three " +
                              "in line " + str(self.__line_number))

        self.__symbol_table[name] = BASICArray(dimensions)

    def __arrayassignmentstmt(self, name):
        """Parses an assignment to an array variable

        :param name: Array name

        """
        self.__consume(Token.LEFTPAREN)

        # Capture the index variables
        # Extract the dimensions
        indexvars = []
        if not self.__tokenindex >= len(self.__tokenlist):
            self.__expr()
            indexvars.append(self.__operand_stack.pop())

            while self.__token.category == Token.COMMA:
                self.__advance()  # Advance past comma
                self.__expr()
                indexvars.append(self.__operand_stack.pop())

        try:
            BASICarray = self.__symbol_table[name + '_array']

        except KeyError:
            raise KeyError('Array could not be found in line ' +
                           str(self.__line_number))

        if BASICarray.dims != len(indexvars):
            raise IndexError('Incorrect number of indices applied to array ' +
                             'in line ' + str(self.__line_number))

        self.__consume(Token.RIGHTPAREN)
        self.__consume(Token.ASSIGNOP)

        self.__relexpr()

        # Check that we are using the right variable name format
        right = self.__operand_stack.pop()

        if name.endswith('$') and not isinstance(right, str):
            raise SyntaxError('Attempt to assign non string to string array' +
                              ' in line ' + str(self.__line_number))

        elif not name.endswith('$') and isinstance(right, str):
            raise SyntaxError('Attempt to assign string to numeric array' +
                              ' in line ' + str(self.__line_number))

        # Assign to the specified array index
        try:
            if len(indexvars) == 1:
                BASICarray.data[indexvars[0]] = right

            elif len(indexvars) == 2:
                BASICarray.data[indexvars[0]][indexvars[1]] = right

            elif len(indexvars) == 3:
                BASICarray.data[indexvars[0]][indexvars[1]][indexvars[2]] = right

        except IndexError:
            raise IndexError('Array index out of range in line ' +
                             str(self.__line_number))

    def __inputstmt(self):
        """Parses an input statement, extracts the input
        from the user and places the values into the
        symbol table

        """
        self.__advance()  # Advance past INPUT token

        prompt = '? '
        if self.__token.category == Token.STRING:
            # Acquire the input prompt
            self.__relexpr()
            prompt = self.__operand_stack.pop()
            self.__consume(Token.COLON)

        # Acquire the comma separated input variables
        variables = []
        if not self.__tokenindex >= len(self.__tokenlist):
            variables.append(self.__token.lexeme)
            self.__advance()  # Advance past variable

            while self.__token.category == Token.COMMA:
                self.__advance()  # Advance past comma
                variables.append(self.__token.lexeme)
                self.__advance()  # Advance past variable

        # Gather input from the user into the variables
        inputvals = input(prompt).split(',')

        for variable in variables:
            left = variable

            try:
                right = inputvals.pop(0)

                if left.endswith('$'):
                    # Python inserts quotes around input data
                    if not right.find('"') == 1 and \
                       not right.find('"', 2):
                        raise ValueError('Non-string input provided to a string variable ' +
                                         'in line ' + str(self.__line_number))

                    else:
                        # Strip the quotes from the stored string
                        stripped = right.strip()  # May be space before or after quotes
                        self.__symbol_table[left] = stripped.replace('"', '')

                elif not left.endswith('$'):
                    try:
                        self.__symbol_table[left] = int(right)

                    except ValueError:
                        raise ValueError('String input provided to a numeric variable ' +
                                         'in line ' + str(self.__line_number))

            except IndexError:
                # No more input to process
                pass

    def __expr(self):
        """Parses a numerical expression consisting
        of two terms being added or subtracted,
        leaving the result on the operand stack.

        """
        self.__term()  # Pushes value of left term
                       # onto top of stack

        while self.__token.category in [Token.PLUS, Token.MINUS]:
            savedcategory = self.__token.category
            self.__advance()
            self.__term()  # Pushes value of right term
                           # onto top of stack
            rightoperand = self.__operand_stack.pop()
            leftoperand = self.__operand_stack.pop()

            if savedcategory == Token.PLUS:
                self.__operand_stack.append(leftoperand + rightoperand)

            else:
                self.__operand_stack.append(leftoperand - rightoperand)

    def __term(self):
        """Parses a numerical expression consisting
        of two factors being multiplied together,
        leaving the result on the operand stack.

        """
        self.__sign = 1  # Initialise sign to keep track of unary
                         # minuses
        self.__factor()  # Leaves value of term on top of stack

        while self.__token.category in [Token.TIMES, Token.DIVIDE]:
            savedcategory = self.__token.category
            self.__advance()
            self.__sign = 1  # Initialise sign
            self.__factor()  # Leaves value of term on top of stack
            rightoperand = self.__operand_stack.pop()
            leftoperand = self.__operand_stack.pop()

            if savedcategory == Token.TIMES:
                self.__operand_stack.append(leftoperand * rightoperand)

            else:
                self.__operand_stack.append(leftoperand / rightoperand)

    def __factor(self):
        """Evaluates a numerical expression
        and leaves its value on top of the
        operand stack.

        """
        if self.__token.category == Token.PLUS:
            self.__advance()
            self.__factor()

        elif self.__token.category == Token.MINUS:
            self.__sign = -self.__sign
            self.__advance()
            self.__factor()

        elif self.__token.category == Token.UNSIGNEDINT:
            self.__operand_stack.append(self.__sign*int(self.__token.lexeme))
            self.__advance()

        elif self.__token.category == Token.UNSIGNEDFLOAT:
            self.__operand_stack.append(self.__sign*float(self.__token.lexeme))
            self.__advance()

        elif self.__token.category == Token.STRING:
            self.__operand_stack.append(self.__token.lexeme)
            self.__advance()

        elif self.__token.category == Token.NAME and \
             self.__token.category not in Token.functions:
            # Check if this is a simple or array variable
            if (self.__token.lexeme + '_array') in self.__symbol_table:
                # Capture the current lexeme
                arrayname = self.__token.lexeme + '_array'

                # Array must be processed
                # Capture the index variables
                self.__advance()  # Advance past the array name

                self.__consume(Token.LEFTPAREN)

                indexvars = []
                if not self.__tokenindex >= len(self.__tokenlist):
                    self.__expr()
                    indexvars.append(self.__operand_stack.pop())

                    while self.__token.category == Token.COMMA:
                        self.__advance()  # Advance past comma
                        self.__expr()
                        indexvars.append(self.__operand_stack.pop())

                BASICarray = self.__symbol_table[arrayname]
                arrayval = self.__get_array_val(BASICarray, indexvars)

                if arrayval:
                    self.__operand_stack.append(self.__sign*arrayval)

                else:
                    raise IndexError('Empty array value returned in line ' +
                                     str(self.__line_number))

            elif self.__token.lexeme in self.__symbol_table:
                # Simple variable must be processed
                self.__operand_stack.append(self.__sign*self.__symbol_table[self.__token.lexeme])

            else:
                raise RuntimeError('Name ' + self.__token.lexeme + ' is not defined' +
                                   ' in line ' + str(self.__line_number))

            self.__advance()

        elif self.__token.category == Token.LEFTPAREN:
            self.__advance()

            # Save sign because expr() calls term() which resets
            # sign to 1
            savesign = self.__sign
            self.__expr()  # Value of expr is pushed onto stack

            if savesign == -1:
                # Change sign of expression
                self.__operand_stack[-1] = -self.__operand_stack[-1]

            self.__consume(Token.RIGHTPAREN)

        elif self.__token.category in Token.functions:
            self.__operand_stack.append(self.__evaluate_function(self.__token.category))

        else:
            raise RuntimeError('Expecting factor in numeric expression' +
                               ' in line ' + str(self.__line_number))

    def __get_array_val(self, BASICarray, indexvars):
        """Extracts the value from the given BASICArray at the specified indexes

        :param BASICarray: The BASICArray
        :param indexvars: The list of indexes, one for each dimension

        :return: The value at the indexed position in the array

        """
        if BASICarray.dims != len(indexvars):
            raise IndexError('Incorrect number of indices applied to array ' +
                             'in line ' + str(self.__line_number))

        # Fetch the value from the array
        try:
            if len(indexvars) == 1:
                arrayval = BASICarray.data[indexvars[0]]

            elif len(indexvars) == 2:
                arrayval = BASICarray.data[indexvars[0]][indexvars[1]]

            elif len(indexvars) == 3:
                arrayval = BASICarray.data[indexvars[0]][indexvars[1]][indexvars[2]]

        except IndexError:
            raise IndexError('Array index out of range in line ' +
                             str(self.__line_number))

        return arrayval

    def __compoundstmt(self):
        """Parses compound statements,
        specifically if-then-else and
        loops

        :return: The FlowSignal to indicate to the program
        how to branch if necessary, None otherwise

        """
        if self.__token.category == Token.FOR:
            return self.__forstmt()

        elif self.__token.category == Token.NEXT:
            return self.__nextstmt()

        elif self.__token.category == Token.IF:
            return self.__ifstmt()

        elif self.__token.category == Token.ON:
            return self.__ongosubstmt()

    def __ifstmt(self):
        """Parses if-then-else
        statements

        :return: The FlowSignal to indicate to the program
        how to branch if necessary, None otherwise

        """

        self.__advance()  # Advance past IF token
        self.__relexpr()

        # Save result of expression
        saveval = self.__operand_stack.pop()

        # Process the THEN part and save the jump value
        self.__consume(Token.THEN)
        self.__expr()
        then_jump = self.__operand_stack.pop()

        # Jump if the expression evaluated to True
        if saveval:
            # Set up and return the flow signal
            return FlowSignal(ftarget=then_jump)

        # See if there is an ELSE part
        if self.__token.category == Token.ELSE:
            self.__advance()
            self.__expr()

            # Set up and return the flow signal
            return FlowSignal(ftarget=self.__operand_stack.pop())

        else:
            # No ELSE action
            return None

    def __forstmt(self):
        """Parses for loops

        :return: The FlowSignal to indicate that
        a loop start has been processed

        """

        # Set up default loop increment value
        step = 1

        self.__advance()  # Advance past FOR token

        # Process the loop variable initialisation
        loop_variable = self.__token.lexeme  # Save lexeme of
                                             # the current token

        if loop_variable.endswith('$'):
            raise SyntaxError('Syntax error: Loop variable is not numeric' +
                              ' in line ' + str(self.__line_number))

        self.__advance()  # Advance past loop variable
        self.__consume(Token.ASSIGNOP)
        self.__expr()

        # Check that we are using the right variable name format
        # for numeric variables
        start_val = self.__operand_stack.pop()

        # Advance past the 'TO' keyword
        self.__consume(Token.TO)

        # Process the terminating value
        self.__expr()
        end_val = self.__operand_stack.pop()

        # Check if there is a STEP value
        increment = True
        if not self.__tokenindex >= len(self.__tokenlist):
            self.__consume(Token.STEP)

            # Acquire the step value
            self.__expr()
            step = self.__operand_stack.pop()

            # Check whether we are decrementing or
            # incrementing
            if step == 0:
                raise IndexError('Zero step value supplied for loop' +
                                 ' in line ' + str(self.__line_number))

            elif step < 0:
                increment = False

        # Now determine the status of the loop

        # If the loop variable is not in the set of extant
        # variables, this is the first time we have entered the loop
        # Note that we cannot use the presence of the loop variable in
        # the symbol table for this test, as the same variable may already
        # have been instantiated elsewhere in the program
        if loop_variable not in self.__loop_vars:
            self.__symbol_table[loop_variable] = start_val

            # Also add loop variable to set of extant loop
            # variables
            self.__loop_vars.add(loop_variable)

        else:
            # We need to modify the loop variable
            # according to the STEP value
            self.__symbol_table[loop_variable] += step

        # If the loop variable has reached the end value,
        # remove it from the set of extant loop variables to signal that
        # this is the last loop iteration
        stop = False
        if increment and self.__symbol_table[loop_variable] > end_val:
            stop = True

        elif not increment and self.__symbol_table[loop_variable] < end_val:
            stop = True

        if stop:
            # Loop must terminate, so remove loop vriable from set of
            # extant loop variables and remove loop variable from
            # symbol table
            self.__loop_vars.remove(loop_variable)
            del self.__symbol_table[loop_variable]
            return FlowSignal(ftype=FlowSignal.LOOP_SKIP,
                              ftarget=loop_variable)
        else:
            # Set up and return the flow signal
            return FlowSignal(ftype=FlowSignal.LOOP_BEGIN)

    def __nextstmt(self):
        """Processes a NEXT statement that terminates
        a loop

        :return: A FlowSignal indicating that a loop
        has been processed

        """

        self.__advance()  # Advance past NEXT token

        return FlowSignal(ftype=FlowSignal.LOOP_REPEAT)

    def __ongosubstmt(self):
        """Process the ON-GOSUB statement

        :return: A FlowSignal indicating the subroutine line number
        if the condition is true, None otherwise

        """

        self.__advance()  # Advance past ON token
        self.__relexpr()

        # Save result of expression
        saveval = self.__operand_stack.pop()

        # Process the GOSUB part and save the jump value
        self.__consume(Token.GOSUB)
        self.__expr()
        line_number = self.__operand_stack.pop()

        if saveval:
            return FlowSignal(ftype=FlowSignal.GOSUB,
                              ftarget=line_number)

        else:
            return None

    def __relexpr(self):
        """Parses a relational expression
        """
        self.__expr()

        # Since BASIC uses same operator for both
        # assignment and equality, we need to check for this
        if self.__token.category == Token.ASSIGNOP:
            self.__token.category = Token.EQUAL

        if self.__token.category in [Token.LESSER, Token.LESSEQUAL,
                              Token.GREATER, Token.GREATEQUAL,
                              Token.EQUAL, Token.NOTEQUAL]:
            savecat = self.__token.category
            self.__advance()
            self.__expr()

            right = self.__operand_stack.pop()
            left = self.__operand_stack.pop()

            if savecat == Token.EQUAL:
                self.__operand_stack.append(left == right)  # Push True or False

            elif savecat == Token.NOTEQUAL:
                self.__operand_stack.append(left != right)  # Push True or False

            elif savecat == Token.LESSER:
                self.__operand_stack.append(left < right)  # Push True or False

            elif savecat == Token.GREATER:
                self.__operand_stack.append(left > right)  # Push True or False

            elif savecat == Token.LESSEQUAL:
                self.__operand_stack.append(left <= right)  # Push True or False

            elif savecat == Token.GREATEQUAL:
                self.__operand_stack.append(left >= right)  # Push True or False

    def __evaluate_function(self, category):
        """Evaluate the function in the statement
        and return the result.

        :return: The result of the function

        """

        self.__advance()  # Advance past function name

        # Process arguments according to function
        if category == Token.SQR:
            self.__consume(Token.LEFTPAREN)

            self.__expr()
            value = self.__operand_stack.pop()

            self.__consume(Token.RIGHTPAREN)

            try:
                return math.sqrt(value)

            except ValueError:
                raise ValueError("Invalid value supplied to SQR in line " +
                                 str(self.__line_number))

        elif category == Token.POW:
            self.__consume(Token.LEFTPAREN)

            self.__expr()
            base = self.__operand_stack.pop()

            self.__consume(Token.COMMA)

            self.__expr()
            exponent = self.__operand_stack.pop()

            try:
                return math.pow(base, exponent)

            except ValueError:
                raise ValueError("Invalid value supplied to POW in line " +
                                 str(self.__line_number))

        elif category == Token.ABS:
            self.__consume(Token.LEFTPAREN)

            self.__expr()
            value = self.__operand_stack.pop()

            self.__consume(Token.RIGHTPAREN)

            try:
                return abs(value)

            except ValueError:
                raise ValueError("Invalid value supplied to ABS in line " +
                                 str(self.__line_number))

        elif category == Token.RND:
            return random.random()

        else:
            raise SyntaxError("Unrecognised function in line " +
                              str(self.__line_number))


    def __randomizestmt(self):
        """Implements a function to seed the random
        number generator

        """
        self.__advance()  # Advance past RANDOMIZE token

        if not self.__tokenindex >= len(self.__tokenlist):
            self.__expr()  # Process the seed
            seed = self.__operand_stack.pop()

            random.seed(seed)

        else:
            random.seed()

