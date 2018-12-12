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
240 GOSUB 500
250 PRINT "Exited subroutine"
260 PRINT "*** Testing loops ***"
270 PRINT "*** Finished ***"
500 REM A SUBROUTINE TEST
510 PRINT "Executing the subroutine"
520 RETURN
