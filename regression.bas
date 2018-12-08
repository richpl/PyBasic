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
120 IF I > J THEN 130 ELSE 160
130 PRINT "Should not print the smaller value of I which is ", I
140 PRINT I
150 GOTO 180
160 PRINT "Should print the larger value of J which is ", J
170 PRINT J
180 PRINT "*** Testing subroutine behaviour ***"
190 PRINT "*** Testing loops ***"
200 PRINT "*** Finished ***"
