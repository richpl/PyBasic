10 REM A BASIC PROGRAM THAT CAN BE USED FOR REGRESSION TESTING
20 REM OF ALL INTERPRETER FUNCTIONALITY
30 PRINT "*** Testing basic arithmetic functions ***"
40 LET I = 100
50 LET J = 200
60 PRINT "Expecting the sum to be 300:"
70 PRINT I + J
80 PRINT "Expecting the product to be 20000:"
90 PRINT I * J
100 PRINT "Expecting the sum to be 20100:"
110 PRINT 100 + I * J
120 PRINT "Expecting sum to be 40000"
130 PRINT (100 + I) * J
140 IF I > J THEN 150 ELSE 180
150 PRINT "Should not print the smaller value of I which is ", I
160 PRINT I
170 GOTO 180
180 PRINT "Should print the larger value of J which is ", J
190 PRINT J
200 GOTO 220
210 PRINT "Should not print this line"
220 PRINT "*** Testing subroutine behaviour ***"
230 PRINT "Calling subroutine"
240 GOSUB 630
250 PRINT "Exited subroutine"
260 PRINT "Now testing nested subroutines"
270 GOSUB 660
280 PRINT "*** Testing loops ***"
290 PRINT "This loop should count to 5 in increments of 1:"
300 FOR I = 1 TO 5
310 PRINT I
320 NEXT I
330 PRINT "This loop should count back from 10 to 1 in decrements of 2:"
340 FOR I = 10 TO 1 STEP -2
350 PRINT I
360 NEXT I
370 PRINT "These nested loops should print 11, 12, 13, 21, 22, 23:"
380 FOR I = 1 TO 2
390 FOR J = 1 TO 3
400 PRINT I, J
410 NEXT J
420 NEXT I
430 PRINT "*** Testing arrays ***"
440 DIM A(3, 3)
450 FOR I = 0 TO 2
460 FOR J = 0 TO 2
470 LET A(I, J) = 5
480 NEXT J
490 NEXT I
500 PRINT "This should print 555"
510 PRINT A(0, 0), A(1, 1), A(2, 2)
520 PRINT "*** Testing file i/o ***"
530 OPEN "REGRESSION.TXT" FOR OUTPUT AS #1
540 PRINT #1,"0123456789Hello World!"
550 CLOSE #1
560 OPEN "REGRESSION.TXT" FOR INPUT AS #2
570 PRINT "The next line should say 'Hello World!'"
580 FSEEK #2,10
590 INPUT #2,A$
600 PRINT A$
610 PRINT "*** Finished ***"
620 STOP
630 REM A SUBROUTINE TEST
640 PRINT "Executing the subroutine"
650 RETURN
660 REM AN OUTER SUBROUTINE
670 GOSUB 700
680 PRINT "This should be printed second"
690 RETURN
700 REM A NESTED SUBROUTINE
710 PRINT "This should be printed first"
720 RETURN
