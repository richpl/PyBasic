10 REM A BASIC PROGRAM THAT CAN BE USED FOR REGRESSION TESTING
20 REM OF ALL INTERPRETER FUNCTIONALITY
30 PRINT "*** Testing basic arithmetic functions and multiple statements ***"
40 LET I = 100: LET J = 200
60 PRINT "Expecting the sum to be 300:"
70 PRINT I + J
80 PRINT "Expecting the product to be 20000:"
90 PRINT I * J
100 PRINT "Expecting the sum to be 20100:"
110 PRINT 100 + I * J
120 PRINT "Expecting sum to be 40000"
130 PRINT (100 + I) * J
140 IF I > J THEN 150 ELSE 180
150 PRINT "Should not print the smaller value of I which is "; I
160 PRINT I
170 GOTO 180
180 PRINT "Should print the larger value of J which is "; J
190 PRINT J
200 GOTO 220
210 PRINT "Should not print this line"
220 PRINT "*** Testing subroutine behaviour ***"
230 PRINT "Calling subroutine"
240 GOSUB 1630
250 PRINT "Exited subroutine"
260 PRINT "Now testing nested subroutines"
270 GOSUB 1660
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
400 PRINT I; J
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
510 PRINT A(0, 0); A(1, 1); A(2, 2)
520 PRINT "*** Testing file i/o ***"
530 OPEN "REGRESSION.TXT" FOR OUTPUT AS #1
540 PRINT #1,"0123456789Hello World!"
545 PRINT #1,"This is second line for testing"
550 CLOSE #1
560 OPEN "REGRESSION.TXT" FOR INPUT AS #2
570 PRINT "The next line should say 'Hello World!'"
580 FSEEK #2,10
590 INPUT #2,A$
600 PRINT A$
610 OPEN "NOFILE.X7Z" FOR INPUT AS #2 ELSE 620
615 PRINT "***This Message should NOT be Displayed***"
620 N = 0
630 I = 7
640 PRINT "This loop should count to 5 in increments of 1 twice:"
650 FOR I = 1 TO 10
660 PRINT I
670 IF I = 5 THEN GOTO 690
680 NEXT I
690 N = N + 1
700 IF N < 2 THEN GOTO 650
810 PRINT "The loop variable I should be equal to 5, I=";I
815 DATA "DATA Statement tests..." 
820 READ A$
825 PRINT "The next line should read: DATA Statement tests..." 
830 PRINT A$ 
840 DATA 1 , 2 , 3 
850 DATA 4 , 5 , 6 
855 DATA 1.5 , 2 , "test" 
858 PRINT "The next three lines should be: 12 34 56"
860 FOR I = 1 TO 3 
870 READ J , K 
880 PRINT J ; K 
890 NEXT I 
900 RESTORE 840 
910 READ I , J , K 
920 PRINT "the next line should print 123" 
930 PRINT I ; J ; K 
970 RESTORE 855 
980 READ A1 , B , C$ 
990 PRINT "Float: " ; A1 ; " Int: " ; B ; " String: " ; C$ 
1000 RESTORE 850 
1010 READ I , J , K , L 
1020 PRINT "the next line should print 4561.5:" 
1030 PRINT I; J ; K ; L 
1040 PRINT "The next lines should print: 'Hello World' and then 'AGAIN' under the word 'World'"
1050 PRINT "Hel" ; : PRINT "lo" ; TAB ( 7 ) ; "World" ; TAB ( 7 ) ; "AGAIN" 
1060 PRINT "This loop should count from 1 to 10"
1070 FOR I = 1 TO 10
1080 FOR J = 1 TO 3
1090 PRINT I
1100 GOTO 1130
1120 NEXT J
1130 NEXT I
1140 INPUT "Enter T for the THEN blocks to execute, E for the ELSE (T/E): " ; ANS$ 
1150 ANS$ = UPPER$ ( ANS$ ) 
1160 IF ANS$ = "T" THEN 1190 
1170 PRINT "1170: Did not enter T" 
1180 GOTO 1200 
1190 PRINT "1190: Entered T" 
1200 IF ANS$ = "T" THEN GOTO 1230 
1210 PRINT "1210: Did not enter T" 
1220 GOTO 1240 
1230 PRINT "1230: Entered T" 
1240 IF ANS$ = "T" THEN 1280 ELSE 1260 
1250 PRINT "ERROR - Should not be at line 1250" 
1260 PRINT "1260: Did not enter T" 
1270 GOTO 1290 
1280 PRINT "1280: Entered T" 
1290 IF ANS$ = "T" THEN GOTO 1330 ELSE GOTO 1310 
1300 PRINT "ERROR - Should not be at line 1300" 
1310 PRINT "1310: Did not enter T" 
1320 GOTO 1340 
1330 PRINT "1330: Entered T" 
1340 IF ANS$ = "T" THEN PRINT "1340: Entered T" 
1350 IF ANS$ <> "T" THEN PRINT "1350: Did not enter T" 
1360 IF ANS$ = "T" THEN PRINT "1360: Entered T" ELSE PRINT "1360: Did not enter T" 
1370 IF ANS$ = "T" THEN PRINT "1370: Entered T" : GOTO 1390 
1380 IF ANS$ <> "T" THEN PRINT "1380: Did not enter T" 
1390 IF ANS$ = "T" THEN PRINT "1390: Entered " ; : PRINT "T" ELSE PRINT "1390: Did " ; : PRINT "not enter T" 
1400 IF ANS$ = "T" THEN PRINT "1400: Entered T" ELSE PRINT "1400: Did " ; : PRINT "not enter T" 
1410 IF ANS$ = "T" THEN PRINT "1410: Entered " ; : PRINT "T" ELSE PRINT "1410: Did not enter T" 
1420 PRINT "Compound Stmt w/conditionals ";:IF ANS$ = "T" THEN PRINT "1420: Entered " ; : PRINT "T" ELSE PRINT "1420: Did " ; : PRINT "not enter T" 
1610 PRINT "*** Finished ***"
1620 STOP
1630 REM A SUBROUTINE TEST
1640 PRINT "Executing the subroutine"
1650 RETURN
1660 REM AN OUTER SUBROUTINE
1670 GOSUB 1700
1680 PRINT "This should be printed second"
1690 RETURN
1700 REM A NESTED SUBROUTINE
1710 PRINT "This should be printed first"
1720 RETURN
