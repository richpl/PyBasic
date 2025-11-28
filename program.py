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

"""Class representing a BASIC program.
This is a list of statements, ordered by
line number.

"""

from basictoken import BASICToken as Token, BASICToken
from basicparser import BASICParser
from flowsignal import FlowSignal
from lexer import Lexer


class BASICData:

    def __init__(self):
        # array of line numbers to represent data statements
        self.__datastmts = {}

        # Data pointer
        self.__next_data = 0


    def delete(self):
        self.__datastmts.clear()
        self.__next_data = 0

    def delData(self,line_number):
        if self.__datastmts.get(line_number) != None:
            del self.__datastmts[line_number]

    def addData(self,line_number,tokenlist):
        """
        Adds the supplied token list
        to the program's DATA store. If a token list with the
        same line number already exists, this is
        replaced.

        line_number: Basic program line number of DATA statement

        """

        try:
            self.__datastmts[line_number] = tokenlist

        except TypeError as err:
            raise TypeError("Invalid line number: " + str(err))


    def getTokens(self,line_number):
        """
        returns the tokens from the program DATA statement

        line_number: Basic program line number of DATA statement

        """

        return self.__datastmts.get(line_number)

    def readData(self,read_line_number):

        if len(self.__datastmts) == 0:
            raise RuntimeError('No DATA statements available to READ ' +
                               'in line ' + str(read_line_number))

        data_values = []

        line_numbers = list(self.__datastmts.keys())
        line_numbers.sort()

        if self.__next_data == 0:
            self.__next_data = line_numbers[0]
        elif line_numbers.index(self.__next_data) < len(line_numbers)-1:
            self.__next_data = line_numbers[line_numbers.index(self.__next_data)+1]
        else:
            raise RuntimeError('No DATA statements available to READ ' +
                               'in line ' + str(read_line_number))

        tokenlist = self.__datastmts[self.__next_data]

        sign = 1
        for token in tokenlist[1:]:
            if token.category != Token.COMMA:
                #data_values.append(token.lexeme)

                if token.category == Token.STRING:
                    data_values.append(token.lexeme)
                elif token.category == Token.UNSIGNEDINT:
                    data_values.append(sign*int(token.lexeme))
                elif token.category == Token.UNSIGNEDFLOAT:
                    data_values.append(sign*eval(token.lexeme))
                elif token.category == Token.MINUS:
                    sign = -1
                #else:
                    #data_values.append(token.lexeme)
            else:
                sign = 1


        return data_values

    def restore(self,restoreLineNo):
        if restoreLineNo == 0 or restoreLineNo in self.__datastmts:

            if restoreLineNo == 0:
                self.__next_data = restoreLineNo
            else:

                line_numbers = list(self.__datastmts.keys())
                line_numbers.sort()

                indexln = line_numbers.index(restoreLineNo)

                if indexln == 0:
                    self.__next_data = 0
                else:
                    self.__next_data = line_numbers[indexln-1]
        else:
            raise RuntimeError('Attempt to RESTORE but no DATA ' +
                               'statement at line ' + str(restoreLineNo))


class Program:

    def __init__(self):
        # Dictionary to represent program
        # statements, keyed by line number
        self.__program = {}

        # Program counter
        self.__next_stmt = 0

        # Initialise return stack for subroutine returns
        self.__return_stack = []

        # return dictionary for loop returns
        self.__return_loop = {}
        
        # WHILE loop tracking stack - separate from GOSUB return stack
        # Each entry contains the line number of the WHILE statement
        self.__while_stack = []

        # Setup DATA object
        self.__data = BASICData()

    def __str__(self):

        program_text = ""
        line_numbers = self.line_numbers()

        for line_number in line_numbers:
            program_text += self.str_statement(line_number)

        return program_text

    def str_statement(self, line_number):
        line_text = str(line_number) + " "

        statement = self.__program[line_number]
        if statement[0].category == Token.DATA:
            statement = self.__data.getTokens(line_number)
        for token in statement:
            # Add in quotes for strings
            if token.category == Token.STRING:
                line_text += '"' + token.lexeme + '" '

            else:
                line_text += token.lexeme + " "
        line_text += "\n"
        return line_text

    def list(self, start_line=None, end_line=None):
        """Lists the program"""
        line_numbers = self.line_numbers()
        if not start_line:
            start_line = int(line_numbers[0])

        if not end_line:
            end_line = int(line_numbers[-1])

        for line_number in line_numbers:
            if int(line_number) >= start_line and int(line_number) <= end_line:
                print(self.str_statement(line_number), end="")

    def save(self, file):
        """Save the program

        :param file: The name and path of the save file, .bas is
                     appended

        """
        if not file.lower().endswith(".bas"):
            file += ".bas"
        try:
            with open(file, "w") as outfile:
                outfile.write(str(self))
        except OSError:
            raise OSError("Could not save to file")

    def load(self, file):
        """Load the program

        :param file: The name and path of the file to be loaded, .bas is
                     appended

        """

        # New out the program
        self.delete()
        if not file.lower().endswith(".bas"):
            file += ".bas"
        try:
            lexer = Lexer()
            with open(file, "r") as infile:
                for line in infile:
                    line = line.replace("\r", "").replace("\n", "").strip()
                    tokenlist = lexer.tokenize(line)
                    self.add_stmt(tokenlist)

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
        if len(tokenlist) > 0:
            try:
                line_number = int(tokenlist[0].lexeme)
                if tokenlist[1].lexeme == "DATA":
                    self.__data.addData(line_number,tokenlist[1:])
                    self.__program[line_number] = [tokenlist[1],]
                else:
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

        :return: The FlowSignal to indicate to the program
        how to branch if necessary, None otherwise

        """
        if line_number not in self.__program.keys():
            raise RuntimeError("Line number " + line_number +
                               " does not exist")

        statement = self.__program[line_number]

        try:
            return self.__parser.parse(statement, line_number)

        except RuntimeError as err:
            raise RuntimeError(str(err))

    def __validate_while_wend(self):
        """Validate that all WHILE statements have matching WEND statements"""
        while_stack = []
        line_numbers = self.line_numbers()
        
        for line_num in line_numbers:
            statement = self.__program[line_num]
            if statement and len(statement) > 0:
                if statement[0].category == Token.WHILE:
                    while_stack.append(line_num)
                elif statement[0].category == Token.WEND:
                    if not while_stack:
                        raise RuntimeError(f"WEND without matching WHILE at line {line_num}")
                    while_stack.pop()
        
        if while_stack:
            raise RuntimeError(f"WHILE without matching WEND at line {while_stack[0]}")

    def __clear_while_stack_on_goto(self, current_line, target_line):
        """Clear WHILE loop stack when GOTO jumps out of loops"""
        # Simple solution: GOTO clears the WHILE stack completely
        # This prevents infinite loops caused by corrupted loop state
        # Traditional BASIC behavior - GOTO breaks loop structures
        self.__while_stack.clear()

    def execute(self):
        """Execute the program"""

        self.__parser = BASICParser(self.__data)
        self.__data.restore(0) # reset data pointer
        
        # Validate WHILE-WEND pairs before execution
        self.__validate_while_wend()

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
                flowsignal = self.__execute(self.get_next_line_number())
                self.__parser.last_flowsignal = flowsignal

                if flowsignal:
                    if flowsignal.ftype == FlowSignal.SIMPLE_JUMP:
                        # GOTO or conditional branch encountered
                        # Clear WHILE loop stack if we're jumping out of loops
                        target_line = flowsignal.ftarget
                        current_line = self.get_next_line_number()
                        self.__clear_while_stack_on_goto(current_line, target_line)
                        
                        try:
                            index = line_numbers.index(flowsignal.ftarget)

                        except ValueError:
                            raise RuntimeError("Invalid line number supplied in GOTO or conditional branch: "
                                               + str(flowsignal.ftarget))

                        self.set_next_line_number(flowsignal.ftarget)

                    elif flowsignal.ftype == FlowSignal.GOSUB:
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
                            index = line_numbers.index(flowsignal.ftarget)

                        except ValueError:
                            raise RuntimeError("Invalid line number supplied in subroutine call: "
                                               + str(flowsignal.ftarget))

                        self.set_next_line_number(flowsignal.ftarget)

                    elif flowsignal.ftype == FlowSignal.RETURN:
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

                    elif flowsignal.ftype == FlowSignal.STOP:
                        break

                    elif flowsignal.ftype == FlowSignal.LOOP_BEGIN:
                        # Loop start encountered
                        # Put loop line number on the stack so
                        # that it can be returned to when the loop
                        # repeats
                        self.__return_loop[flowsignal.floop_var] = line_numbers[index]

                        # Continue to the next statement in the loop
                        index = index + 1

                        if index < len(line_numbers):
                            self.set_next_line_number(line_numbers[index])

                        else:
                            # Reached end of program
                            raise RuntimeError("Program terminated within a loop")

                    elif flowsignal.ftype == FlowSignal.LOOP_SKIP:
                        # Loop variable has reached end value, so ignore
                        # all statements within loop and move past the corresponding
                        # NEXT statement
                        index = index + 1
                        while index < len(line_numbers):
                            next_line_number = line_numbers[index]
                            temp_tokenlist = self.__program[next_line_number]

                            if temp_tokenlist[0].category == Token.NEXT and \
                               len(temp_tokenlist) > 1:
                                # Check the loop variable to ensure we have not found
                                # the NEXT statement for a nested loop
                                if temp_tokenlist[1].lexeme == flowsignal.ftarget:
                                    # Move the statement after this NEXT, if there
                                    # is one
                                    index = index + 1
                                    if index < len(line_numbers):
                                        next_line_number = line_numbers[index]  # Statement after the NEXT
                                        self.set_next_line_number(next_line_number)
                                        break

                            index = index + 1

                        # Check we have not reached end of program
                        if index >= len(line_numbers):
                            # Terminate the program
                            break

                    elif flowsignal.ftype == FlowSignal.LOOP_REPEAT:
                        # Loop repeat encountered
                        # Pop the loop start address from the stack
                        try:
                            index = line_numbers.index(self.__return_loop.pop(flowsignal.floop_var))

                        except ValueError:
                            raise RuntimeError("Invalid loop exit in line " +
                                               str(self.get_next_line_number()))

                        except KeyError:
                            raise RuntimeError("NEXT encountered without corresponding " +
                                               "FOR loop in line " + str(self.get_next_line_number()))

                        self.set_next_line_number(line_numbers[index])

                    elif flowsignal.ftype == FlowSignal.WHILE_BEGIN:
                        # WHILE loop start encountered
                        # Put loop line number on the WHILE stack so
                        # that it can be returned to when the loop repeats
                        self.__while_stack.append(line_numbers[index])

                        # Continue to the next statement in the loop
                        index = index + 1

                        if index < len(line_numbers):
                            self.set_next_line_number(line_numbers[index])

                        else:
                            # Reached end of program
                            raise RuntimeError("Program terminated within a WHILE loop")

                    elif flowsignal.ftype == FlowSignal.WHILE_SKIP:
                        # WHILE condition is false, so skip
                        # all statements within loop and move past the corresponding
                        # WEND statement
                        index = index + 1
                        wend_count = 0
                        while index < len(line_numbers):
                            next_line_number = line_numbers[index]
                            temp_tokenlist = self.__program[next_line_number]

                            if temp_tokenlist[0].category == Token.WHILE:
                                # Found nested WHILE, increment counter
                                wend_count += 1
                            elif temp_tokenlist[0].category == Token.WEND:
                                if wend_count == 0:
                                    # Found matching WEND statement
                                    # Move to the statement after this WEND, if there is one
                                    index = index + 1
                                    if index < len(line_numbers):
                                        next_line_number = line_numbers[index]  # Statement after the WEND
                                        self.set_next_line_number(next_line_number)
                                        break
                                else:
                                    # This WEND belongs to a nested WHILE
                                    wend_count -= 1

                            index = index + 1

                        # Check we have not reached end of program
                        if index >= len(line_numbers):
                            # Terminate the program
                            break

                    elif flowsignal.ftype == FlowSignal.WHILE_REPEAT:
                        # WHILE repeat encountered (WEND statement)
                        # Pop the loop start address from the WHILE stack
                        try:
                            index = line_numbers.index(self.__while_stack.pop())

                        except ValueError:
                            raise RuntimeError("Invalid WHILE loop exit in line " +
                                               str(self.get_next_line_number()))

                        except IndexError:
                            raise RuntimeError("WEND encountered without corresponding " +
                                               "WHILE loop in line " + str(self.get_next_line_number()))

                        self.set_next_line_number(line_numbers[index])

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
        self.__program.clear()
        self.__data.delete()

    def delete_statement(self, line_number):
        """Deletes a statement from the program with
        the specified line number, if it exists

        :param line_number: The line number to be deleted

        """
        self.__data.delData(line_number)
        try:
            del self.__program[line_number]

        except KeyError:
            raise KeyError("Line number does not exist")

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

    def renumber(self, new_start=10, increment=10, old_start=None, old_end=None):
        """Renumber the program according to BASIC RENUMBER command specification
        
        :param new_start: First line number assigned during renumbering (default: 10)
        :param increment: Amount added to each successive line number (default: 10) 
        :param old_start: Lowest line number to renumber (default: first line)
        :param old_end: Highest line number to renumber (default: last line)
        """
        
        # Validate parameters
        if increment == 0:
            raise ValueError("Increment cannot be zero")
        if new_start < 1:
            raise ValueError("New start line number must be >= 1")
        if increment < 0:
            raise ValueError("Increment must be positive")
            
        line_numbers = self.line_numbers()
        if not line_numbers:
            return  # No program to renumber
            
        # Set defaults for old_start and old_end
        if old_start is None:
            old_start = line_numbers[0]
        if old_end is None:
            old_end = line_numbers[-1]
            
        # Find lines within the renumbering range
        lines_to_renumber = []
        for line_num in line_numbers:
            if old_start <= line_num <= old_end:
                lines_to_renumber.append(line_num)
                
        if not lines_to_renumber:
            return  # No lines in range to renumber
            
        # Step 1: Create mapping of old line numbers to new line numbers
        line_mapping = {}
        new_line_num = new_start
        
        for old_line_num in lines_to_renumber:
            line_mapping[old_line_num] = new_line_num
            new_line_num += increment
            
        # Check for overflow (basic line numbers typically max at 65535)
        if new_line_num - increment > 65535:
            raise ValueError("Line numbers would exceed maximum value (65535)")
            
        # Check for conflicts with existing line numbers outside the range
        for new_num in line_mapping.values():
            if new_num in line_numbers and new_num not in lines_to_renumber:
                # Find which old line this conflicts with
                for ln in line_numbers:
                    if ln == new_num and ln not in lines_to_renumber:
                        raise ValueError(f"New line number {new_num} conflicts with existing line {ln}")
        
        # Step 2: Update line number references in all program statements
        updated_program = {}
        updated_data = {}
        
        for line_num in line_numbers:
            statement = self.__program[line_num]
            
            # Update line number references within the statement
            updated_statement = self._update_line_references(statement, line_mapping)
            
            # Determine the new line number for this statement
            if line_num in line_mapping:
                new_line_num = line_mapping[line_num]
            else:
                new_line_num = line_num
                
            updated_program[new_line_num] = updated_statement
            
            # Handle DATA statements
            if statement and statement[0].category == Token.DATA:
                data_tokens = self.__data.getTokens(line_num)
                if data_tokens:
                    updated_data[new_line_num] = data_tokens
        
        # Step 3: Replace the program with the updated version
        self.__program = updated_program
        
        # Update DATA storage
        self.__data.delete()
        for line_num, data_tokens in updated_data.items():
            self.__data.addData(line_num, data_tokens)
    
    def _update_line_references(self, statement, line_mapping):
        """Update line number references within a statement
        
        :param statement: List of tokens representing the statement
        :param line_mapping: Dictionary mapping old line numbers to new ones
        :return: Updated statement with new line number references
        """
        if not statement:
            return statement
            
        updated_statement = []
        i = 0
        
        while i < len(statement):
            token = statement[i]
            
            # Skip string literals and comments - they should not be modified
            if token.category == Token.STRING:
                updated_statement.append(token)
                i += 1
                continue
                
            if token.category == Token.REM:
                # Everything after REM is a comment, copy rest as-is
                updated_statement.extend(statement[i:])
                break
                
            # Check for line number references in specific contexts
            if self._is_line_number_reference(statement, i):
                if token.category == Token.UNSIGNEDINT:
                    line_num = int(token.lexeme)
                    if line_num in line_mapping:
                        # Create new token with updated line number
                        new_token = BASICToken(token.column, token.category, str(line_mapping[line_num]))
                        updated_statement.append(new_token)
                    else:
                        updated_statement.append(token)
                else:
                    updated_statement.append(token)
            else:
                updated_statement.append(token)
                
            i += 1
            
        return updated_statement
    
    def _is_line_number_reference(self, statement, token_index):
        """Determine if the token at the given index is a line number reference
        
        :param statement: List of tokens representing the statement  
        :param token_index: Index of the token to check
        :return: True if this token is a line number reference
        """
        if token_index >= len(statement):
            return False
            
        token = statement[token_index]
        if token.category != Token.UNSIGNEDINT:
            return False
            
        # Check what comes before this number to determine context
        if token_index == 0:
            return False  # First token is the line number itself, not a reference
            
        prev_token = statement[token_index - 1]
        
        # Direct line number references
        if prev_token.category in [Token.GOTO, Token.GOSUB, Token.THEN, Token.RESTORE]:
            return True
            
        # ON...GOTO and ON...GOSUB constructs
        if prev_token.category == Token.COMMA:
            # Look backward to find ON...GOTO or ON...GOSUB
            for j in range(token_index - 2, -1, -1):
                if statement[j].category == Token.ON:
                    # Check if this is followed by GOTO or GOSUB
                    for k in range(j + 1, token_index):
                        if statement[k].category in [Token.GOTO, Token.GOSUB]:
                            return True
                    break
                elif statement[j].category not in [Token.UNSIGNEDINT, Token.COMMA, Token.NAME]:
                    break
        
        # Check for ON...GOTO/GOSUB patterns
        if token_index >= 2:
            # Look for pattern: ON <expr> GOTO/GOSUB <number>
            for j in range(token_index - 1, -1, -1):
                if statement[j].category == Token.ON:
                    # Found ON, now look for GOTO or GOSUB before our number
                    for k in range(j + 1, token_index):
                        if statement[k].category in [Token.GOTO, Token.GOSUB]:
                            return True
                    break
                    
        return False
