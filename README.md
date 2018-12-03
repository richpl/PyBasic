# PyBasic - Program like it's 1979!

## Introduction

A simple interactive BASIC interpreter written in Python. It is based heavily on material in the excellent book *Writing Interpreters and Compilers for the Raspberry Pi Using Python* by Anthony J. Dos Reis. However, I have had to adapt the Python interpreter presented in the book, both to work with the BASIC programming language and to produce an interactive command line interface. The interpreter therefore adopts the key techniques for interpreter and compiler writing, the use of a lexical analysis stage followed by a parser which implements the context free grammar representing the target programming language.

The interpreter is a homage to the home computers of the early 1980s, and when executed, presents an interactive prompt ('>') typical of such a home computer. Commands to run, list, save and load BASIC programs can be entered at the prompt as well as program statements themselves. 

The BASIC dialect that has been implemented is slightly simplified, and naturally avoids machine specific instructions, such as those concerned with sound and graphics for example. It allows a limited range of arithmetic expressions composed of multiplication, division, addition and subtraction (including parenthesised subterms). Variable types follow the typical BASIC convention: they can either be strings or numbers (the latter may be integers or floating point numbers).

The interpreter can be invoked as follows:

```
$ python interpreter.py
```

*This project is still a work in progress and under active development*

## To do list

* Distinguish string variables from number variables (dollar suffix)
* Printing strings and multiple items broken
* GOSUB
* Array types
* Deletion of individual program statements
* FOR loops

## Commands

Programs may be listed using the LIST command:

```
> LIST
10 LET I = 10
20 PRINT I
```

A program is executed using the RUN command:

```
> RUN
10
```

A program may be saved to disk using the SAVE command. Not that the full path must be specified within double quotes:

```
> SAVE "C:\path\to\my\file"
Program written to file
>
```

Saving is achieved by pickling the Python object that represents the BASIC program, i.e. the saved file is *not* a textual copy of the program statements.

The program may be re-loaded (i.e. unpickled) from disk using the LOAD command, again specifying the full path using double quotes:

```
> LOAD "C:\path\to\my\file"
Program read from file
>
```

The program may be erased from memory using the NEW command:

```
> 10 LET I = 10
> LIST
10 LET I = 10
> NEW
> LIST
>
```

Finally, it is possible to terminate the interpreter by issuing the EXIT command:

```
> EXIT
c:\
```

## Programming language constructs

### Statement structure

As per usual in old school BASIC, all program statements must be prefixed with a line number which indicates the order in which the statements may be executed. There is no renumber command to allow all line numbers to be modified. A statement may be modified or replaced by re-entering a statement with the same line number:

```
> 10 LET I = 10
> LIST
10 LET I = 10
> 10 LET I = 200
> LIST
10 LET I = 200
```

Note that all statements, including variable names are case insensitive (in fact, all lower case characters are converted to upper case internally by the lexical analyser).

Arrays - TODO

### Comments

The REM statement is used to indicate a comment, and occupies an entire statement. It has no effect on execution:

```
> 10 REM THIS IS A COMMENT
```

### Assignment

Assignment may be made to number variables (which can contain either integers or floating point numbers) and string variables (string variables are distinguished by their dollar suffix). The interpreter will enforce this division between the two types:

```
> 10 LET I = 10
> 20 LET I$ = "HELLO"
```

Note that 'I' and 'I$' are considered to be separate variables. Note that string literals must always be enclosed within double quotes (not single quotes). Using no quotes will result in a syntax error.

The LET keyword is also optional:

```
> 10 I = 10
```

### Printing to standard output

The PRINT statement is used to print to the screen:

```
> 10 PRINT 2 * 4
> RUN
8
> 10 PRINT "HELLO"
> RUN
HELLO
```

### Unconditional branching

Like it or loath it, the GOTO statement is an integral part of BASIC, and is used to transfer control to the statement with the specified line number:

```
> 10 PRINT "HELLO"
> 20 GOTO 10
> RUN
HELLO
HELLO
HELLO
...
```

### Subroutine calls

TBD

### Loops

TBD

### Conditional branching

Conditional branches are implemented using the IF-THEN-ELSE statement. The expression is evaluated and the appropriate jump
made depending upon the result of the evaluation.

```
> 10 REM Print the greatest number
> 20 LET I = 10
> 30 LET J = 20
> 40 IF I > J THEN 50 ELSE 70
> 50 PRINT I
> 60 GOTO 80
> 70 PRINT J
> 80 REM Finished
> RUN
20
```

Note that the ELSE clause is optional and may be omitted. In this case, the THEN branch is taken if the
expression evaluates to true, otherwise the following statement is executed.

Allowable relational operators are:

* = (equal, note that in BASIC the same operator is used for assignment)
* < (less than)
* > (greater than)
* <= (less than or equal)
* >= (greater than or equal)
* <> (not equal)

## Architecture

The interpreter is implemented using the following Python classes:

* basictoken.py - This implements the tokens that are produced by the lexical analyser. The class mostly defines token categories
and provides a simple token pretty printing method.
* lexer.py - This class implements the lexical analyser. Lexical analysis is performed on one statement at a time, as each statement is
entered into the interpreter.
* basicparser.py - This class implements a parser for individual BASIC statements. Since the parser is oriented to the processing of individual statements, it uses a
signalling mechanism to its caller indicate when program level actions are required, such as recording the return address
following a subroutine jump. However, thr parser does maintain a symbol table (implemented as a dictionary) in order to record
the value of variables as they are assigned.
* program.py - This class implements an actual basic program, which is represented as a dictionary. Dictionary keys are
statement line numbers and the corresponding value is the list of tokens that make up the statement with that line number.
Statements are executed by calling the parser to parse one statement at a time. This class
maintains a program counter, an indication of which line number should be executed next. The program counter is incremented to the next line
number in sequence, unless executed a statement has resulted in a branch. The parser indicates this by signalling to the program object that
calls it.
* interpreter.py - This class provides the interface to the user. It allows the user to both input program statements and to execute
the resulting program. It also allows the user to run commands, for example to save and load programs, or to list them.

## Open issues

Currently there is no way to terminate an infinite loop in a BASIC program without terminating the intepreter itself (e.g. using Ctrl-C).
