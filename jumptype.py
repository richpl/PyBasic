#! /usr/bin/python

"""This class defines an object that can be returned by the BASICParser to
indicate the need for a control flow branch. The information within the
object tells the Program the nature of the jump and therefore whether a
return address need to be added to the return stack.

>>> jumptype = JumpType(jtype=JumpType.GOSUB)
>>> print(jumptype.jtarget)
-1
>>> jumptype = JumpType(jtarget=100)
>>> print(jumptype.jtarget)
100
>>> print(jumptype.jtype)
0
"""


class JumpType:

    # Jump categories
    JUMP        = 0  # Indicates a simple jump as the result
                     # of a GOTO or conditional branch
    GOSUB       = 1  # Indicates a subroutine call where the
                     # return address must be the following instruction
    LOOP        = 2  # Indicates a jump back to the start of a loop

    def __init__(self, jtarget=-1, jtype=JUMP):
        """Creates a new JumpType for a branch. If the jump
        target is supplied, then the branch is assumed to be
        either a GOTO or conditional branch and the type is assigned as
        JUMP. If no jump_target is supplied, then a jump_type must be
        supplied, which must either be GOSUB or LOOP. In the latter cases
        the jump target is assigned an arbitrary value of -1 (which is
        not a valid line number).

        :param jtarget: The target line number of the jump
        :param jtype: Either GOSUB, JUMP or LOOP
        """

        if jtype not in [self.GOSUB, self.JUMP, self.LOOP]:
            raise TypeError("Invalid jump type supplied: " + str(jtype))

        if jtarget == -1 and \
           jtype == self.JUMP:
            raise TypeError("Invalid jump target supplied for JUMP type: " + str(jtarget))

        if jtarget != -1 and \
           jtype in [self.GOSUB, self.LOOP]:
            raise TypeError("Jump target wrongly supplied for jump type " + str(jtype))

        self.jtype = jtype
        self.jtarget = jtarget

