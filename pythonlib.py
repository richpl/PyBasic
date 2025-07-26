from lexer import Lexer
from program import Program
from sys import stderr

# Assuming Token class is accessible
from token_definitions import Token  # replace with actual token file if needed

class Interpreter:
    def __init__(self):
        self.lexer = Lexer()
        self.program = Program()

    def process_command(self, stmt: str) -> str:
        try:
            tokens = self.lexer.tokenize(stmt)
            if not tokens:
                return "No input provided."

            first_token = tokens[0]

            match first_token.category:
                case Token.EXIT:
                    return "Exiting interpreter."

                case Token.UNSIGNEDINT:
                    if len(tokens) == 1:
                        # Delete statement by line number
                        self.program.delete_statement(int(first_token.lexeme))
                        return f"Statement deleted: {stmt}"
                    else:
                        # Add statement
                        self.program.add_stmt(tokens)
                        return f"Statement added: {stmt}"

                case Token.RUN:
                    try:
                        self.program.execute()
                        return "Program executed."
                    except KeyboardInterrupt:
                        return "Program terminated by user."

                case Token.LIST:
                    output = self.program.list()
                    return f"Program listing:\n{output}"

                case Token.SAVE:
                    if len(tokens) > 1:
                        filename = tokens[1].lexeme
                        self.program.save(filename)
                        return f"Program saved to {filename}"
                    return "Error: No filename provided."

                case Token.LOAD:
                    if len(tokens) > 1:
                        filename = tokens[1].lexeme
                        self.program.load(filename)
                        return f"Program loaded from {filename}"
                    return "Error: No filename provided."

                case Token.NEW:
                    self.program.delete()
                    return "Program cleared."

                case _:
                    return "Unrecognized input."

        except Exception as e:
            return f"Error: {e}"

# Example usage
if __name__ == "__main__":
    interpreter = Interpreter()
    print(interpreter.process_command('10 PRINT "Hello world"'))
    print(interpreter.process_command("RUN"))
