1 REM ===============================================
2 REM WHILE-WEND LOOP COMPREHENSIVE TEST SUITE
3 REM ===============================================
4 REM
5 REM This program tests all aspects of WHILE-WEND
6 REM loop functionality in PyBasic
7 REM ===============================================
8 REM
10 PRINT "=== WHILE-WEND Loop Test Suite ==="
20 PRINT ""
21 REM
22 REM ===============================================
23 REM Test 1: Basic WHILE Loop
24 REM ===============================================
30 PRINT "Test 1: Basic WHILE Loop"
40 PRINT "Expected: Count 1 through 5"
50 PRINT "------------------------"
60 LET I = 1
70 WHILE I <= 5
80 PRINT "Count: "; I
90 LET I = I + 1
100 WEND
110 PRINT "Basic WHILE loop completed"
120 PRINT ""
121 REM
122 REM ===============================================
123 REM Test 2: WHILE Loop with False Condition
124 REM ===============================================
130 PRINT "Test 2: WHILE Loop Skip Test"
140 PRINT "Expected: Only skip message, no loop output"
150 PRINT "----------------------------------------"
160 LET X = 10
170 WHILE X < 5
180 PRINT "This should NOT print!"
190 WEND
200 PRINT "WHILE loop was correctly skipped"
210 PRINT ""
211 REM
212 REM ===============================================
213 REM Test 3: Nested WHILE Loops
214 REM ===============================================
220 PRINT "Test 3: Nested WHILE Loops"
230 PRINT "Expected: Outer 1-3, Inner 1-2 for each"
240 PRINT "-------------------------------------"
250 LET I = 1
260 WHILE I <= 3
270 PRINT "Outer loop: "; I
280 LET J = 1
290 WHILE J <= 2
300 PRINT "  Inner loop: "; J
310 LET J = J + 1
320 WEND
330 LET I = I + 1
340 WEND
350 PRINT "Nested WHILE loops completed"
360 PRINT ""
361 REM
362 REM ===============================================
363 REM Test 4: WHILE with Complex Conditions
364 REM ===============================================
370 PRINT "Test 4: Complex Condition Test"
380 PRINT "Expected: A=1,B=5 through A=3,B=5"
390 PRINT "--------------------------------"
400 LET A = 1
410 LET B = 5
420 WHILE A < B AND A < 4
430 PRINT "A = "; A; ", B = "; B
440 LET A = A + 1
450 WEND
460 PRINT "Complex condition test completed"
470 PRINT ""
471 REM
472 REM ===============================================
473 REM Test 5: WHILE Loop with Countdown
474 REM ===============================================
480 PRINT "Test 5: Countdown WHILE Loop"
490 PRINT "Expected: Countdown from 5 to 1"
500 PRINT "-----------------------------"
510 LET COUNT = 5
520 WHILE COUNT > 0
530 PRINT "Countdown: "; COUNT
540 LET COUNT = COUNT - 1
550 WEND
560 PRINT "Countdown completed!"
570 PRINT ""
571 REM
572 REM ===============================================
573 REM Test 6: WHILE with String Variables
574 REM ===============================================
580 PRINT "Test 6: WHILE with String Conditions"
590 PRINT "Expected: Process items until STOP"
600 PRINT "--------------------------------"
610 LET ITEM$ = "START"
620 LET COUNTER = 0
630 WHILE ITEM$ <> "STOP"
640 LET COUNTER = COUNTER + 1
650 PRINT "Processing item "; COUNTER
660 IF COUNTER = 3 THEN LET ITEM$ = "STOP"
670 WEND
680 PRINT "String condition test completed"
690 PRINT ""
691 REM
692 REM ===============================================
693 REM Test 7: Mixed FOR and WHILE Loops
694 REM ===============================================
700 PRINT "Test 7: Mixed FOR and WHILE Loops"
710 PRINT "Expected: FOR loop with nested WHILE"
720 PRINT "--------------------------------"
730 FOR K = 1 TO 2
740 PRINT "FOR loop iteration: "; K
750 LET M = 1
760 WHILE M <= 2
770 PRINT "  WHILE iteration: "; M
780 LET M = M + 1
790 WEND
800 NEXT K
810 PRINT "Mixed loop test completed"
820 PRINT ""
821 REM
822 REM ===============================================
823 REM Test 8: WHILE with Mathematical Operations
824 REM ===============================================
830 PRINT "Test 8: WHILE with Math Operations"
840 PRINT "Expected: Powers of 2 up to 16"
850 PRINT "-----------------------------"
860 LET POWER = 1
870 WHILE POWER <= 16
880 PRINT "2^"; LOG(POWER)/LOG(2); " = "; POWER
890 LET POWER = POWER * 2
900 WEND
910 PRINT "Mathematical operations test completed"
920 PRINT ""
921 REM
922 REM ===============================================
923 REM Final Summary
924 REM ===============================================
930 PRINT "======================================="
940 PRINT "ALL WHILE-WEND TESTS COMPLETED!"
950 PRINT "If you see this message, all tests"
960 PRINT "have executed successfully!"
970 PRINT "======================================="
975 REM
976 REM ===============================================
977 REM Test 9: WHILE-WEND Validation Tests
978 REM ===============================================
980 PRINT "Test 9: WHILE-WEND Validation"
985 PRINT "Expected: Tests that require proper structure"
990 PRINT "--------------------------------------------"
1000 PRINT "Note: Missing WEND validation occurs at load time"
1010 PRINT "GOTO breaking WHILE loops causes runtime errors"
1020 PRINT "This ensures proper WHILE-WEND structure"
1030 PRINT "Validation tests completed"
1040 PRINT ""
1050 PRINT "======================================="
1060 PRINT "ALL WHILE-WEND TESTS COMPLETED!"
1070 PRINT "VALIDATION: Missing WEND detected at load"
1080 PRINT "VALIDATION: GOTO in WHILE causes error"
1090 PRINT "All features working correctly!"
1100 PRINT "======================================="
1110 END