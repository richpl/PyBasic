10 DATA "this is line 10 data" 
20 READ A$ 
30 PRINT A$ 
40 DATA 1 , 2 , 3 
50 DATA 4 , 5 , 6 
55 DATA 1.2 , 3 , "alpha" 
60 FOR I = 1 TO 3 
70 READ J , K 
80 PRINT J , K 
90 NEXT I 
100 RESTORE 40 
110 READ I , J , K 
120 PRINT "the next line should print 123" 
130 PRINT I , J , K 
140 RESTORE 10 
150 READ A$ 
160 PRINT A$ 
170 RESTORE 55 
180 READ A , B , C$ 
190 PRINT "Float: " , A , " Int: " , B , " String: " , C$ 
200 RESTORE 40 
210 READ I , J , K , L 
220 PRINT "the next line should print 1234:" 
230 PRINT I , J , K , L 
