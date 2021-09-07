from basictoken import BASICToken as Token

class BASICData:

    def __init__(self):
        # array of line numbers to represent data statements
        self.__data = []

        # Data pointer
        self.__next_data = 0


    def delete(self):
        self.__data.clear()
        self.__next_data = 0

    def delData(self,line_number):
        if line_number in self.__data:
            self.__data.pop(self.__data.index(line_number))

    def addData(self,line_number):
        """
        Adds the supplied line_number to the list of program
        DATA statements. The first token should
        be the line number.

        line_number: Basic program line number of DATA statement

        """

        if line_number not in self.__data:
            self.__data.append(line_number)
            self.__data.sort()

    def readData(self,read_line_number,pgmStatements):

        if len(self.__data) == 0:
            raise RuntimeError('No DATA statements available to READ ' +
                               'in line ' + str(read_line_number))

        data_values = []

        if self.__next_data == 0:
            self.__next_data = self.__data[0]
        elif self.__data.index(self.__next_data) < len(self.__data)-1:
            self.__next_data = self.__data[self.__data.index(self.__next_data)+1]
        else:
            raise RuntimeError('No DATA statements available to READ ' +
                               'in line ' + str(read_line_number))

        tokenlist = pgmStatements[self.__data[self.__data.index(self.__next_data)]]

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
                indexln = self.__data.index(restoreLineNo)

                if indexln == 0:
                    self.__next_data = 0
                else:
                    self.__next_data = self.__data[indexln-1]
        else:
            raise RuntimeError('Attempt to RESTORE but no DATA ' +
                               'statement at line ' + str(restoreLineNo))