from basictoken import BASICToken as Token

class BASICData:

    def __init__(self):
        # array of line numbers to represent data statements
        self.__data = {}

        # Data pointer
        self.__next_data = 0


    def delete(self):
        self.__data.clear()
        self.__next_data = 0

    def delData(self,line_number):
        if self.__data.get(line_number) != None:
            del self.__data[line_number]

    def addData(self,line_number,tokenlist):
        """
        Adds the supplied token list
        to the program's DATA store. If a token list with the
        same line number already exists, this is
        replaced.

        line_number: Basic program line number of DATA statement

        """

        try:
            self.__data[line_number] = tokenlist

        except TypeError as err:
            raise TypeError("Invalid line number: " + str(err))


    def getTokens(self,line_number):
        """
        returns the tokens from the program DATA statement

        line_number: Basic program line number of DATA statement

        """

        return self.__data.get(line_number)

    def readData(self,read_line_number):

        if len(self.__data) == 0:
            raise RuntimeError('No DATA statements available to READ ' +
                               'in line ' + str(read_line_number))

        data_values = []

        line_numbers = list(self.__data.keys())
        line_numbers.sort()

        if self.__next_data == 0:
            self.__next_data = line_numbers[0]
        elif line_numbers.index(self.__next_data) < len(line_numbers)-1:
            self.__next_data = line_numbers[line_numbers.index(self.__next_data)+1]
        else:
            raise RuntimeError('No DATA statements available to READ ' +
                               'in line ' + str(read_line_number))

        tokenlist = self.__data[self.__next_data]

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
        if restoreLineNo == 0 or restoreLineNo in self.__data:

            if restoreLineNo == 0:
                self.__next_data = restoreLineNo
            else:

                line_numbers = list(self.__data.keys())
                line_numbers.sort()

                indexln = line_numbers.index(restoreLineNo)

                if indexln == 0:
                    self.__next_data = 0
                else:
                    self.__next_data = line_numbers[indexln-1]
        else:
            raise RuntimeError('Attempt to RESTORE but no DATA ' +
                               'statement at line ' + str(restoreLineNo))