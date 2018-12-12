#! /usr/bin/python

"""This class defines an object that can be returned by the BASICParser to
indicate the need for a control flow branch. The information within the
object tells the Program the nature of the jump and therefore whether a
return address need to be added to the return stack.

>>> jumptype = JumpType(jtype=JumpType.RETURN)
>>> print(jumptype.jtarget)
-1
>>> jumptype = JumpType(jtarget=100, jtype=JumpType.SIMPLE_JUMP)
>>> print(jumptype.jtarget)
100
>>> print(jumptype.jtype)
0
"""


class JumpType:

    # Jump categories
    SIMPLE_JUMP        = 0  # Indicates a simple jump as the result
                     # of a GOTO or conditional branch

    GOSUB       = 1  # Indicates a subroutine call where the
                     # return address must be the following instruction

    LOOP_BEGIN  = 2  # Indicates the start of a FOR loop

    LOOP_END    = 3  # Indicates a NEXT jump back to the start of a loop

    RETURN      = 4  # Indicates a subroutine return where the return
                     # address is on the return stack

    def __init__(self, jtarget=-1, jtype=SIMPLE_JUMP):
        """Creates a new JumpType for a branch. If the jump
        target is supplied, then the branch is assumed to be
        either a GOTO or conditional branch and the type is assigned as
        SIMPLE_JUMP. If no jump_target is supplied, then a jump_type must be
        supplied, which must either be GOSUB, RETURN, LOOP_BEGIN
        or LOOP_END. In the latter cases
        the jump target is assigned an arbitrary value of -1 (which is
        not a valid line number).

        :param jtarget: The target line number of the jump
        :param jtype: Either GOSUB, SIMPLE_JUMP, RETURN, LOOP_BEGIN
        or LOOP_END
        """

        if jtype not in [self.GOSUB, self.SIMPLE_JUMP, self.LOOP_BEGIN,
                         self.LOOP_END, self.RETURN]:
            raise TypeError("Invalid jump type supplied: " + str(jtype))

        if jtarget == -1 and \
           jtype in [self.SIMPLE_JUMP, self.GOSUB]:
            raise TypeError("Invalid jump target supplied for JUMP type: " + str(jtarget))

        if jtarget != -1 and \
           jtype in [self.RETURN, self.LOOP_BEGIN, self.LOOP_END]:
            raise TypeError("Jump target wrongly supplied for jump type " + str(jtype))

        self.jtype = jtype
        self.jtarget = jtarget

