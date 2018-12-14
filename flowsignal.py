#! /usr/bin/python

"""This class defines an object that can be returned by the BASICParser to
indicate the need for a control flow branch. The information within the
object tells the Program the nature of the jump and therefore whether a
return address need to be added to the return stack.

>>> flowsignal = FlowSignal(ftype=FlowSignal.RETURN)
>>> print(flowsignal.ftarget)
-1
>>> flowsignal = FlowSignal(ftarget=100, ftype=FlowSignal.SIMPLE_JUMP)
>>> print(flowsignal.ftarget)
100
>>> print(flowsignal.ftype)
0
"""


class FlowSignal:

    # Jump categories
    SIMPLE_JUMP        = 0  # Indicates a simple jump as the result
                            # of a GOTO or conditional branch

    GOSUB              = 1  # Indicates a subroutine call where the
                            # return address must be the following instruction

    LOOP_BEGIN         = 2  # Indicates the start of a FOR loop

    LOOP_REPEAT        = 3  # Indicates that loop must repeat

    LOOP_END           = 4  # Indicates that loop must terminate

    RETURN             = 5  # Indicates a subroutine return where the return
                            # address is on the return stack

    STOP               = 6  # Indicates that execution should cease

    def __init__(self, ftarget=-1, ftype=SIMPLE_JUMP):
        """Creates a new FlowSignal for a branch. If the jump
        target is supplied, then the branch is assumed to be
        either a GOTO or conditional branch and the type is assigned as
        SIMPLE_JUMP. If no jump_target is supplied, then a jump_type must be
        supplied, which must either be GOSUB, RETURN, LOOP_BEGIN,
        LOOP_END or STOP. In the latter cases
        the jump target is assigned an arbitrary value of -1 (which is
        not a valid line number).

        :param ftarget: The target line number of the jump
        :param ftype: Either GOSUB, SIMPLE_JUMP, RETURN, LOOP_BEGIN
        or LOOP_END
        """

        if ftype not in [self.GOSUB, self.SIMPLE_JUMP, self.LOOP_BEGIN,
                         self.LOOP_REPEAT, self.LOOP_END, self.RETURN, self.STOP]:
            raise TypeError("Invalid flow signal type supplied: " + str(ftype))

        if ftarget == -1 and \
           ftype in [self.SIMPLE_JUMP, self.GOSUB]:
            raise TypeError("Invalid jump target supplied for jump type: " + str(ftarget))

        if ftarget != -1 and \
           ftype in [self.RETURN, self.LOOP_BEGIN, self.LOOP_REPEAT,
                     self.LOOP_END, self.STOP]:
            raise TypeError("Jump target wrongly supplied for flow signal " + str(ftype))

        self.ftype = ftype
        self.ftarget = ftarget

