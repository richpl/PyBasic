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


"""
This file implements a basic terminal class compatible with
PyBasic.  A terminal object needs to be provided to the
program class to enable BASIC print/input and other character
based IO operations.

The SimpleTerm class uses stdio and does not handle cursor
manipulation

The CursesTerm class uses curses to enable more sophisitcated
operation
"""

import curses

class SimpleTerm:
    def __init__(self):
        return

    def print(self, to_print):
        """
        Print send the provided string to the terminal
        followed by a CR/LF
        """
        print(to_print)

    def write(self, to_write):
        """
        write sends the provided string to the terminal
        but does not include any other control chars
        """
        print(to_write, end="")


    def enter(self):
        """
        Move down one line, and all the wya to the left.
        Equivilent of CR/LF combo
        """
        print()

    def clear(self):
        """
        Clears the screen.
        Not Implemented here
        """
        raise Exception("Not Implemented by terminal")

    def home(self):
        """
        Returns the cursor to home position
        Not implemented here
        """
        raise Exception("Not Implemented by terminal")

    def cursor(self, x, y):
        """
        Moves the cursor to the specified x (column)
        and y (row) position on screen
        Not implemented here
        """
        raise Exception("Not Implemented by terminal")

    def input(self):
        """
        Retrieves a string terminated by CR from the termnial
        This will echo to the screen
        """
        return input()

    def get_char(self):
        """
        Retrieves a single character from the terminal
        and returns it ASCII code as integer.  This is
        to allow for various special codes/characters for
        buttons/arrows.

        Block until recieved, does not echo

        Not implemented well here as it requires more
        OS specific code or curses
        """
        return ord(input()[0])

    def poll_char(self):
        """
        Checks keyboard state.  Returns zero if no key is pressed
        or integer representing the key (ASCII code for most keys).
        This allows special keys/buttons to be returned above or
        below normal ASCII code range

        Not implemnted here as it requires more OS specific
        business
        """
        return 0


class CursesTerm:
    def __init__(self, stdscr):
        self.__stdscr = stdscr

        # Turn off echo
        curses.noecho()

        # Don't wait for cr to process input
        curses.cbreak()

        # accept arrows and other special chars
        self.__stdscr.keypad(True)
        self.__stdscr.scrollok(True)

    def print(self, to_print):
        """
        Print send the provided string to the terminal
        followed by a CR/LF
        """
        self.__stdscr.addstr(str(to_print) + "\n")


    def write(self, to_write):
        """
        write sends the provided string to the terminal
        but does not include any other control chars
        """
        self.__stdscr.addstr(str(to_write))


    def enter(self):
        """
        Move down one line, and all the wya to the left.
        Equivilent of CR/LF combo
        """
        self.__stdscr.addstr("\n")

    def clear(self):
        """
        Clears the screen.
        Not Implemented here
        """
        self.__stdscr.clear()

    def home(self):
        """
        Returns the cursor to home position
        Not implemented here
        """
        raise Exception("Not Implemented by terminal")

    def cursor(self, x, y):
        """
        Moves the cursor to the specified x (column)
        and y (row) position on screen
        Not implemented here
        """
        raise Exception("Not Implemented by terminal")

    def input(self):
        """
        Retrieves a string terminated by CR from the termnial
        This will echo to the screen
        """
        curses.echo()
        instr = self.__stdscr.getstr()
        curses.noecho()
        return instr.decode()

    def get_char(self):
        """
        Retrieves a single character from the terminal
        and returns it ASCII code as integer.  This is
        to allow for various special codes/characters for
        buttons/arrows.

        Block until recieved, does not echo

        Not implemented well here as it requires more
        OS specific code or curses
        """
        return ord(input()[0])

    def poll_char(self):
        """
        Checks keyboard state.  Returns zero if no key is pressed
        or integer representing the key (ASCII code for most keys).
        This allows special keys/buttons to be returned above or
        below normal ASCII code range

        Not implemnted here as it requires more OS specific
        business
        """
        return 0

