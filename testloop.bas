5 N = 0 
6 I = 7 
10 PRINT "hello world" 
20 PRINT "before loop i: " , I 
100 FOR I = 1 TO 10 
110 PRINT I 
115 IF I = 5 THEN GOTO 130 
120 NEXT I 
130 N = N + 1 
140 IF N < 2 THEN GOTO 10 
150 PRINT "i: " , I , " n: " , N 