10 rem ADVENTURE/3000 VERSION 3.2     27 FEB 1979 AT 5:30 PM
11 rem THIS PROGRAM IS RELATIVELY BUG-FREE, BUT ONE STILL MUST
12 rem realize that murphy 'S LAW STILL PREVAILS!
13 rem
14 rem ADVENTURE: PROGRAMMED IN HP/3000 BASIC BY BENJAMIN MOSER
15 rem JAMES MADISON HIGH SCHOOL, VIENNA, VIRGINIA.  THE BASIC LAYOUT OF THE
16 rem GAME WAS CONCEIVED BY DON WOODS & WILLIE CROWTHER, BOTH OF M.I.T.
17 rem
18 rem ADVENTURE WAS PORTED TO THE MACINTOSH PLUS BY THE ELIZABETH AND DAVID HUNTER
19 rem IN MARCH 1998 AND THEN TO PYBASIC FOR THE RASPBERRY RP2040 IN JUNE 2021
20 rem PRINT "Adventure 3.2 on ";date$;" at ";time$
21 PRINT "Adventure 3.2 for PyBASIC"
22 open "AMESSAGE" for INPUT as #3:open "AMOVING" for INPUT as #4
23 open "ADESCRIP" for INPUT as #1:open "AITEMS" for INPUT as #2
44 rem dirs is an array of possible room directions, it replaces file AMOVING
45 dim dirs(100,10)
46 dim indx(303)
47 dim fraindx(10)
50 dim s(99)
51 dim v(100)
52 dim k(200)
53 dim o(15)
70 PRINT:PRINT "Initializing.";
110 rem initialize
130 rem total rooms, items,and keywords
150 l1 = int(RND(1)*4)+1 : l2 = l1
160 g = 0 : b0 = 1 : sn = 1 : d1 = 1 : d2 = 0 : t = 1 : b1 = 0 : b2 = 0 : p1 = 0: dead = 0
161 l = 0 : c = 0 : d3 = 0 : b3 = 0 : d0 = 2 : t1 = 100 : t2 = 35 : t3 = 149 : r0 = 0 : c0 = 0: c$=""
162 KC = 1.02
170 for ii = 1 to 99
171  s(ii) = 0 : v(ii) = 0
172 next ii
175 PRINT ".";:v(100) = 0
182 indx(1) = -1:indx(2)=-1
190 rem   read in possible movement direction array
192 for z2 = 1 to 100
193  INPUT #4,dx1,dx2,dx3,dx4,dx5,dx6,dx7,dx8,dx9,dx0
194  dirs(z2,1)=dx1:dirs(z2,2)=dx2:dirs(z2,3)=dx3:dirs(z2,4)=dx4:dirs(z2,5)=dx5
195  dirs(z2,6)=dx6:dirs(z2,7)=dx7:dirs(z2,8)=dx8:dirs(z2,9)=dx9:dirs(z2,10)=dx0
196  PRINT ".";
197 next z2
198 close #4
200 restore 230
210 rem    read in locations of items
220 for z2 = 1 to T2 step 5
221 read dx1,dx2,dx3,dx4,dx5:s(z2)=dx1:s(z2+1)=dx2:s(z2+2)=dx3:s(z2+3)=dx4:s(z2+4)=dx5
222 PRINT ".";
228 next z2
230 data 18,25,23,24,21
231 data 52,0,71,74,58
232 data 59,69,66,82,100
233 data 7,49,7,7,7
234 data 7,12,13,40,38
235 data 69,0,46,0,0
236 data 15,60,82,22,250
240 for ii = 1 to 15 step 5 
241 read dx1,dx2,dx3,dx4,dx5:o(ii)=dx1:o(ii+1)=dx2:o(ii+2)=dx3:o(ii+3)=dx4:o(ii+4)=dx5
242 PRINT ".";
243 next ii
245 data 1,2,2,2,2
246 data 3,4,3,3,2
247 data 5,3,2,3,3
260 rem ASK IF HE WANTS DIRECTIONS
263 z59 = 301:gosub 7620
264 gosub 9860
266 if z0 then 267 else 320
267 z59 = 302:gosub 7620
280 rem    command INPUT routine
300 rem PRINT room, items
310 rem If it's dark don't let him see anything
320 if l1 < 13 or l1 = 58 then 350
321 if l = 1 and (s(18) = l1 or s(18) = -1) then 350
330 z59 = 45:gosub 7620
340 goto 400
350 on d0+1 gosub 6780,7990,8180
360 v(l1) = 1
370 gosub 6680
375 if dead = 1 then 9540
380 gosub 7800
390 rem INPUT LOOP --- MULTIPLE COMMAANDS, REMOVE JUNK CHARACTERS
400 if len(c$) > 0 then 500
410 INPUT ">";c$:c$=upper$(c$)
420 if c$ = "" then 410
425 PRINT:PRINT
430 c$ = upper$(c$)
449 rem    65-90 = A-Z               48-57 = 0-9         46 = . 44 = ,   
450 for x = 1 to len(c$)
460 z5 = asc(mid$(c$,x,1))
470 if (z5 > 64 and z5 < 91) or (z5 > 47 and z5 < 58) or z5 = 44 then 480 else 471
471 c$ = mid$(c$,1,x-1)+" "+mid$(c$,x+1)
480 next x
490 if mid$(c$,len(c$),1) = "," then 500
491 c$ = c$+","
500 z4 = instr(c$,",")
510 a$ = upper$(mid$(c$,1,z4-1)) : c$ = mid$(c$,z4+1)
550 a$ = " "+a$+" "
560 rem search a$ for keywords,puut kwd code into k(x)
570 rem items
580 data 1,"GOLD",1,"NUGGET",2,"BARS",2,"SILVER",3,"JEWELRY",4,"COINS"
590 data 5,"DIAMONDS",6,"MING",6,"VASE",7,"PEARL",8,"EGGS",8,"NEST"
600 data 9,"TRIDENT",10,"EMERALD",11,"PLATINUM",11,"PYRAMID",12,"CHAIN"
610 data 13,"SPICES",14,"PERSIAN",14,"RUG",15,"TREASURE",15,"CHEST"
620 data 16,"WATER",17,"OIL",18,"LAMP",18,"LANTERN",19,"KEYS",20,"FOOD",21,"BOTTLE"
630 data 22,"CAGE",23,"ROD",23,"WAND",24,"CLAM",25,"MAGAZINE",26,"BEAR"
640 data 27,"AXE",28,"VELVET",28,"PILLOW",29,"SHARDS",30,"OYSTER"
650 data 31,"BIRD",32,"TROLL",33,"DRAGON",34,"SNAKE",35,"DWARF"
660 data 36,"ROCK",36,"BOULDER",37,"STAIRS",38,"STEPS",39,"HOUSE",39,"BUILDING"
665 data 40,"GRATE",41,"STREAM",42,"ROOM",43,"BRIDGE",44,"PIT",45,"VOLCANO"
667 data 46,"ROAD",47,"ALL",47,"EVERYTHING"
670 rem DIRECTIONS
680 data 100,"N",100,"NORTH",101,"NE",101,"NORTHEAST",102,"E",102,"EAST"
682 data 103,"SE",103,"SOUTHEAST",104,"S",104,"SOUTH",105,"SW",105,"SOUTHWEST"
684 data 106,"W",106,"WEST",107,"NW",107,"NORTHWEST",108,"U",108,"UP",109,"D",109,"DOWN"
690 rem VERBS
700 data 110,"PLUGH",111,"XYZZY",112,"PLOVER",113,"CROSS",114,"CLIMB",115,"JUMP"
710 data 116,"FILL",117,"EMPTY",117,"POUR",118,"LOOK",118,"L",119,"LIGHT",119,"ON",120,"EXTINGUISH"
720 data 120,"OFF",121,"IN",121,"ENTER",122,"LEAVE",122,"OUT",123,"INVENTORY",123,"I"
730 data 124,"GET",124,"CATCH",124,"TAKE",125,"DROP",125,"DUMP",126,"THROW",127,"ATTACK"
740 data 127,"KILL",128,"FEED",129,"WATER",130,"LOCK",131,"UNLOCK"
750 data 132,"FREE",132,"RELEASE",133,"WAVE",134,"OPEN",135,"CLOSE"
760 data 136,"OIL",137,"EAT",138,"DRINK",139,"FEE FIE FOE FOO"
765 data 140,"SHORT",141,"LONG",142,"BRIEF",143,"QUIT",143,"STOP",143,"END"
770 data 144,"SCORE",145,"SAVE",146,"LOAD",147,"READ",147,"EXAMINE"
775 data 148,"YES",148,"Y",149,"BUG",150,"*"
780 restore 580
790 for i = 1 to 200
791 k(i) = 0
792 next i
800 z1 = 0 : z3 = 0
810 rem T3=TOTAL NUMBER OF KEYWORDS
820 if z1 > t3 then 900
830 read z1,b$
840 b$ = " "+b$+" "
850 rem IF KEYWORD WAS FOUND, NOTE THIS IN K(Z1)
860 if instr(a$,b$) = 0 then goto 820
861 k(z1) = 1
870 rem KEYWORDK #Z1 NOT FOUND
880 goto 820
890 rem EXOTIC WORDS
900 z0 = 36
910 for x = z0 to 46
920 if k(x) = 0 then 960
930 gosub 8390
940 print "What do you want to do with the ";d$;"?"
950 goto 410
960 next x
970 for x = 110 to t3
980 if k(x) = 1 then 1950
990 next x
1000 rem THEN IT'S A DIRECTION
1010 for d = 1 to 10
1020 if k(d+99) = 1 then 1070
1030 next d
1040 rem COMMAND NOT A DIRECTION
1050 goto 1950
1060 rem CAN HE MOVE THAT WAY?
1070 z2 = dirs(L1,d)
1130 if z2 = 255 then 1470
1140 if z2 < 1 or z2 > 254 then 1220
1150 rem NORMAL MOVING
1160 rem CHECK FOR SPECIAL MOVE CONDITIONS
1170 goto 1260
1180 l2 = l1 : l1 = z2
1190 if s(35) = l2 then 1191 else 1200
1191 s(35) = l1
1200 goto 9780
1220 z59 = 1
1221 gosub 7620
1230 goto 400
1240 rem SPECIAL ROOM DIRECTIONS
1250 rem GRATE
1260 if L1 = 10 and (d = 10 or d = 5) THEN 1280
1261 IF L1 = 11 and (d = 9 or d = 3) then 1280 else 1320
1270 rem IF GRATE IS OPEN (G=0) MOVE HIM
1280 if g = 1 then 1180
1290 z59 = 10:gosub 7620
1300 goto 400
1310 rem CAN'T TAKE NUGGET UPPSTAIRS
1320 if not (l1 = 17 and d = 9 and s(1) = -1) then 1360
1330 z59 = 38:gosub 7620
1340 goto 400
1350 rem CRYSTAL BRIDGE AND FISSURE
1360 if not (l1 = 19 and d = 7 or l1 = 20 and d = 3) then 1410
1370 if b2 then 1180
1380 z59 = 3:gosub 7620
1390 goto 400
1400 rem MT. KING & SNAKE
1410 if not (l1 = 22 and d <> 3 and d <> 9) then 1690
1420 if sn = 0 then 1180
1430 z59 = 50:gosub 7620
1440 goto 400
1460 rem bedquilt and random directiosn
1470 if l1 <> 44 then 1590
1480 if RND(1) > 0.5 then 1510
1490 z59 = 52:gosub 7620
1500 goto 400
1510 restore 1530
1520 rem ROOMS TO JU
1530 data 33,37,45,92,76
1540 for z3 = 1 to int(RND(1)*5)+1
1550  read z2
1560 next z3
1570 goto 1180
1580 rem WITT's END
1590 if l1 <> 39 then 1220
1600 rem SHOULD WE LET HIM OUT?
1610 if RND(1) < 0.15 then 1650
1620 rem NO
1630 z59 = 52:gosub 7620
1640 goto 400
1650 rem YES
1660 z2 = 38
1670 goto 1180
1680 rem Narrow Tunnel
1690 if not (l1 = 57 or l1 = 58) then 1780
1691 IF K(102)=0 AND K(106)=0 THEN 1780
1700 for z3 = 1 to t2
1710  if z3 = 10 then 1750
1720  if s(z3) <> -1 then 1750
1730  z59 = 53:gosub 7620
1740  goto 400
1750 next z3
1760 goto 1180
1770 rem TROLL
1780 IF L1=60 AND D=2 THEN 1790
1781 IF L1=61 AND D=6 THEN 1790 ELSE 1860
1790 on t+1 goto 1180,1800,1820,1840
1800 z59 = 55:gosub 7620
1810 goto 400
1820 z59 = 56:gosub 7620
1821 z59 = 55:gosub 7620
1830 T=1:goto 400
1840 t = 2
1850 goto 1180
1860 if not (l1 = 73 and d = 1 and d2 = 0) then 1890
1870 z59 = 57:gosub 7620
1880 goto 400
1890 if not (l1 = 82 and s(33) = l1 and d = 1) then 1180
1900 rem DRAGON
1910 z59 = 51:gosub 7620
1920 goto 400
1940 rem OTHER COMMANDS
1950 for z1 = 100 to t3
1960 if k(z1)=1 then 2090
1970 next z1
1980 rem ITEM BO NO VERB?
1990 restore 9961
2000 for x = 1 to 35
2010  read d$
2020  if k(x) = 1 then 940
2030 next x
2040 restore 2070
2050 for x = 1 to int(RND(1)*4)+1
2051  read b$
2052 next x
2060 PRINT b$
2070 data "What?","I don't understand.","I can't understand that.","I don't know that word."
2080 goto 400
2090 z1 = z1-109
2095 on z1 goto 2120,2220,2300,2390,2570,2640,2680,2860,2930,3000,3080,3130,3290,3450,3590,3920,4160,4430,4630,4800,4950,5060,5190,5410,5560,5750,5810,5920,6000,6090,6230,6270,6310,6350,6410,8970,9080,9220,4490,9330
2110 goto 2040
2120 REM *** PLUGH ***
2130 IF L1<>7 THEN 2170
2140 IF S(35)=L1 THEN S(35)=0
2150 Z2=26
2160 GOTO 1180
2170 IF L1<>26 THEN 2200
2180 Z2=7
2190 GOTO 1180
2200 z59 = 2:gosub 7620
2210 GOTO 400
2220 REM *** XYZZY ***
2230 IF L1<>7 THEN 2270
2240 IF S(35)=L1 THEN S(35)=0
2250 Z2=13
2260 GOTO 1180
2270 IF L1<>13 THEN 2200
2280 Z2=7
2290 GOTO 1180
2300 REM *** PLOVER *** (CAN'T BRING EMERALD WITH HIM)
2310 IF L1>26 THEN 2360
2320 IF S(35)<>L1 THEN 2330
2325 S(35) = 0
2330 IF S(10)<>-1 THEN 2340
2335 S(10) = L1
2340 Z2 = 58
2350 GOTO 1180
2360 IF L1<>58 THEN 2200
2370 Z2=26
2380 GOTO 1180
2390 REM *** CROSS ***
2400 IF L1<>19 THEN 2470
2410 IF B2<>0 THEN 2440
2420 z59 = 3:gosub 7620
2430 GOTO 400
2440 D=7
2450 REM JUST GIVE NEW DIRECTION, USE MOVE ROUTINE
2460 GOTO 1070
2470 IF L1<>20 THEN 2510
2480 IF B2=0 THEN 2420
2490 D=3
2500 GOTO 1070
2510 IF L1<>60 THEN 2540
2520 D=2
2530 GOTO 1070
2540 IF L1<>61 THEN 2200
2550 D=6
2560 GOTO 1070
2570 REM *** CLIMB ***
2580 IF L1<>50 THEN 2200
2590 REM CAN HE CLIMB BEANSTALK?
2600 IF P1<2 THEN 2200
2610 REM YES
2620 Z2=70
2630 GOTO 1180
2640 REM *** JUMP *** STRICTLY SUICIDAL
2650 IF L1<>16 AND L1<>19 AND L1<>20 AND L1<>27 THEN 2200
2660 z59 = 4:gosub 7620
2670 GOTO 9550
2680 REM FILL
2690 IF S(21)=-1 THEN 2730
2700 B$="bottle"
2710 PRINT "You don't have the ";b$
2720 goto 410
2730 IF B0=0 THEN 2760
2740 z59 = 5:gosub 7620
2750 GOTO 410
2760 IF L1<>7 AND L1<>8 AND L1<>9 AND L1<>35 AND L1<>74 AND L1<>81 THEN 2790
2770 B0=1:S(16)=-1
2780 GOTO 2840
2790 IF L1=49 THEN 2830
2800 B$="oil"
2810 PRINT "I see no ";B$;" here."
2820 GOTO 400
2830 B0=2:S(17)=-1
2840 PRINT "The bottle is now filled."
2850 GOTO 400
2860 REM *** EMPTY ***
2870 IF S(21)=-1 THEN 2890
2880 GOTO 2700
2890 REM EMPTY BOTTLE (ASSUMED FULL)
2900 S(B0+15)=0:B0=0
2910 PRINT "Emptied"
2920 GOTO 400
2930 rem *** LOOK ***
2940 if l1 < 13 or l1 = 58 then 2970
2941 if l = 1 and (s(18) = l1 or s(18) = -1) then 2970
2950 z59 = 45:gosub 7620
2960 goto 400
2970 gosub 8050
2980 gosub 6680
2990 goto 400
3000 rem *** LIGHT ***
3010 if s(18) = -1 then 3040
3020 b$ = "lamp"
3030 goto 2710
3040 l = 1
3050 b$ = "on"
3060 PRINT "The lamp is now ";b$
3070 goto 2940
3080 REM *** OFF (EXTINGUSIH) ***
3090 IF S(18)=-1 THEN 3110
3100 GOTO 3020
3110 L=0:B$="off"
3120 GOTO 3060
3130 REM *** ENTER ***
3140 IF L1<>6 THEN 3180
3150 REM TO HOUSE
3160 D=3
3170 GOTO 1070
3180 IF L1<>68 THEN 3240
3190 REM TO BARREN ROOM
3200 D=3
3210 GOTO 1070
3240 FOR D=10 TO 1 step -1
3250  Z2 = DIRS(L1,D)
3260  IF Z2>0 AND Z2<101 THEN 1150
3270 NEXT D
3280 GOTO 2200
3290 REM ** LEAVE ***
3300 IF L1<>7 THEN 3340
3310 REM LEAVE HOUSE
3320 D=7
3330 GOTO 1070
3340 IF L1<>69 THEN 3400
3350 REM LEAVE BARREN ROOM
3360 D = 7
3370 GOTO 1070
3400 FOR D = 1 TO 10
3410  Z2 = DIRS(L1,D)
3420  IF Z2>0 AND Z2<101 THEN 1150
3430 NEXT D
3440 GOTO 2200
3450 REM *** INVENTORY ***
3470 Z0=0
3480 PRINT "You are carrying:";
3490 FOR X=1 TO T2
3510  IF S(X)<>-1 THEN 3540
3511  restore 9960+x:read b$
3520  PRINT B$
3530  Z0 = Z0 + 1
3540 NEXT X
3550 IF Z0=0 THEN 3551 else 3560
3551 PRINT "nothing."
3560 PRINT
3570 GOTO 400
3590 rem *** GET ***
3630 if k(47) = 1 then 3680
3640 gosub 8280
3650 if z8 > 0 then 3680
3660 PRINT "Get what?"
3670 goto 2040
3680 for z3 = 1 to t2
3710 if k(47) = 1 then 3730
3720 if k(z3) = 0 then 3900
3730 if s(z3) <> l1 then 3750
3740 if s(z3) = l1 then 3790
3750 if k(47) = 1 then 3900
3760 restore 9960+z3:read a$:PRINT a$;" not here."
3770 goto 3900
3780 rem MUST CHECK NOW FOR LEGALITY OF TAKING ITEM
3790 z8 = 0
3800 for x = 1 to t2
3810 if s(x) <> -1 then 3820
3811 z8 = z8+1
3820 next x
3830 if z8 < 7 then 3870
3840 rem CARRYING TOO MUCH
3850 z59 = 54:gosub 7620
3860 goto 410
3870 goto 6880
3880 s(z3) = -1
3890 restore 9960+z3:read a$:PRINT a$;":taken."
3900 next z3
3910 goto 400
3920 REM *** DROP ***
3940 if k(47) = 1 then 4000
3950 gosub 8280
3960 IF Z8>0 THEN 4000
3970 PRINT "Drop what?"
3980 GOTO 2040
4000 FOR Z3=1 TO T2
4030  IF K(47)=1 THEN 4060
4040  IF K(Z3)<>1 THEN 4140
4050  IF S(Z3)=0 THEN 4140
4060  IF S(Z3)=-1 THEN 4100
4070  IF K(47)=1 THEN 4140
4080  restore 9960+z3:read b$:PRINT "You don't have the ";B$
4090  GOTO 4140
4100  REM STILL NEED TO ELABORATE ON DROP (BIRD IN CAGE, BOTTLE)
4110  GOTO 7380
4120  restore 9960+z3:read b$:PRINT B$;":dropped."
4130  S(Z3)=L1
4140 NEXT Z3
4150 GOTO 400
4160 REM *** THROW ***
4170 GOSUB 8280
4180 IF Z8>0 THEN 4210
4190 PRINT "Throw what?"
4200 GOTO 2040
4210 IF S(Z3)<>-1 THEN 2710
4220 IF NOT (Z3<16 AND S(32)=L1) THEN 4260
4230 REM THROW TREASURE TO TROLL
4240 z59 = 27:gosub 7620
4241 S(Z3)=0:T=3:GOTO 400
4260 IF NOT (Z3=27 AND S(32)=L1) THEN 4300
4270 REM TRYING TO BUTCHER TROLL?
4280 z59 = 26:gosub 7620
4281 S(27)=L1:GOTO 400
4300 IF NOT (Z3=27 AND S(35)=L1) THEN 4380
4310 REM TRYING TO KILL DWARF
4320 IF RND(1)>0.5 THEN 4360
4330 z59 = 29:gosub 7620
4340 GOSUB 8650
4350 GOTO 4410
4360 z59 = 30:gosub 7620
4361 S(35)=0:GOTO 4410
4380 REM NOTHING SPECIAL, JUST DROP ITEM
4390 IF S(35)<>L1 THEN 4400
4391 GOSUB 8550
4400 PRINT "Thrown."
4410 S(Z3) = L1
4415 if dead = 1 then 9540
4420 GOTO 400
4430 REM *** ATTACK ***
4440 GOSUB 8280
4450 IF NOT (Z3=33 AND S(Z3)=L1 AND L1=82) THEN 4520
4460 REM HE CAN KILL DRAGON
4470 z59 = 68:gosub 7620
4480 GOTO 410
4490 IF L1<>82 THEN 2040
4500 z59 = 69:gosub 7620
4501 S(33)=0:D1=0:GOTO 400
4520 IF S(32)<>L1 THEN 4560
4530 REM TRYING TO MUNGE TROLL
4540 Z9=FNA(25):GOTO 400
4560 IF NOT (Z3=26 OR Z3>30) THEN 4600
4570 REM DANGEROUS TO ATTACK THESE
4580 z59 = 70:gosub 7620
4590 GOTO 400
4600 REM NOTHING TO ATTACK
4610 z59 = 71:gosub 7620
4620 GOTO 400
4630 REM *** FEED ***
4640 GOSUB 8280
4650 IF Z3<>35 THEN 4690
4660 REM CAN'T FEED DWARF!
4670 z59 = 24:gosub 7620
4680 GOTO 400
4690 IF S(20) = -1 THEN 4720
4700 B$ = "FOOD":GOTO 2710
4720 IF L1=69 THEN 4760
4730 PRINT "I can't feed it."
4740 z59 = 23:gosub 7620
4750 GOTO 400
4760 IF S(20)=L1 THEN 7600
4770 B1=1:S(20)=0:z59 = 6:gosub 7620
4790 GOTO 400
4800 REM *** WATER ***
4810 IF S(16) = -1 THEN 4840
4820 B$ = "water":GOTO 2710
4840 IF L1<>50 THEN 2200
4850 REM GOTO P1+1 OF 4860,4890,4920
4851 IF P1 = 0 THEN 4860
4852 IF P1 = 1 THEN 4890
4853 IF P1 = 2 THEN 4920
4860 z59 = 7:gosub 7620
4870 P1=1:S(16)=0:B0=0:GOTO 400
4890 z59 = 8:gosub 7620
4900 P1=2:S(16)=0:B0=0:GOTO 400
4920 z59 = 9:gosub 7620
4930 P1=0:S(16)=0:B0=0:GOTO 400
4950 REM *** LOCK ***
4960 IF L1=10 OR L1=11 THEN 4990
4970 REM NOTHING LOCKABLE
4980 GOTO 2200
4990 IF S(19)=-1 THEN 5020
5000 B$="keys":goto 2710
5020 G=0:z59 = 10:gosub 7620
5040 GOTO 400
5060 REM *** UNLOCK ***
5070 IF S(19)<>-1 THEN 5000
5080 IF L1<>10 AND L1<>11 THEN 5120
5090 G=1:z59 = 11:gosub 7620
5110 GOTO 400
5120 IF L1<>69 THEN 2200
5130 IF B1>0 THEN 5160
5140 z59 = 12:gosub 7620
5150 goto 400
5160 IF C<>0 THEN 5170
5165 C=1:B1=2
5170 z59 = 13:gosub 7620
5180 GOTO 400
5190 REM *** FREE ***
5200 IF K(31) = 1 THEN 5240
5210 REM CAN'T FREE ANYTHING BUT BIRD
5220 z59 = 2:gosub 7620
5230 GOTO 410
5240 IF S(31)<>-1 THEN 5220
5250 S(31) = L1:B3=0
5260 PRINT "Freed."
5270 IF L1<>22 THEN 5350
5280 IF SN<>1 THEN 400
5290 B$="snake"
5300 PRINT "The little bird attacks the green ";B$;" and"
5310 IF L1=82 THEN 5380
5320 PRINT "drives it off"
5330 SN=0:S(34)=0:GOTO 400
5350 IF L1<>82 THEN 400
5360 B$="dragon":GOTO 5300
5380 PRINT "gets burned to a crisp"
5390 S(31)=0
5400 GOTO 400
5410 REM *** WAVE ***
5420 IF K(23) <> 1 THEN 2200
5430 IF S(23)=-1 THEN 5460
5440 B$="rod":GOTO 2710
5460 REM  IS HERE NEAR FISSURE
5470 IF L1<>19 AND L1<>20 THEN 2200
5480 REM yes
5490 REM GOTO B2+1 OF 5500,5530
5491 IF B2=0 THEN 5500
5492 IF B2=1 THEN 5530
5500 z59 = 14:gosub 7620
5510 B2=1:GOTO 400
5530 z59 = 15:gosub 7620
5540 B2=0:GOTO 400
5560 REM *** OPEN ***
5570 GOSUB 8280
5580 IF Z3>0 THEN 5610
5590 PRINT "Open ";:goto 2040
5610 IF Z3=40 THEN 5070
5620 IF S(Z3)=L1 THEN 5650
5630 PRINT "I see no ";b$;" here.":goto 400
5650 if z3=24 THEN 5680
5660 PRINT "I don't know how to open a ";B$:GOTO 400
5680 IF S(9)=-1 THEN 5710
5690 z59 = 16:gosub 7620
5700 GOTO 400
5710 IF S(Z3) = 0 THEN 2200
5720 REM HE'S OPENED CLAM, SO PRINT DESCRIPTION OF THIS
5730 REM PUT PEARL IN CUL-DE-SAC
5740 S(7)=43:S(24)=0:S(30)=L1:z59 = 17:gosub 7620
5750 GOTO 400
5760 REM *** CLOSE ***
5770 GOSUB 8280
5780 IF Z3=40 THEN 4960
5790 z59 = 18:gosub 7620
5800 GOTO 400
5810 REM OIL
5820 IF K(17)=0 THEN 2200
5830 IF S(17)=-1 THEN 5860
5840 B$="oil":GOTO 5630
5860 IF L1<>73 THEN 2200
5870 REM IS DOOR STILL RUSTED
5880 IF D2=1 THEN 2200
5890 D2=1:S(17)=0:B0=0:z59 = 19:gosub 7620
5900 GOTO 400
5910 REM *** EAT ***
5920 IF K(20) = 1 THEN 5950
5930 z59 = 20:gosub 7620
5940 GOTO 410
5950 Z3=20:GOSUB 8490
5970 IF Z5=0 THEN 410
5980 z59 = 73:gosub 7620
5381 S(20)=0:B0=0:GOTO 400
6000 REM *** DRINK ***
6010 IF K(16) =1 THEN 6040
6020 z59 = 21:gosub 7620
6030 GOTO 410
6040 Z3=16:GOSUB 8490
6060 IF Z5=0 THEN 410
6070 z59 = 22:gosub 7620
6071 S(17)=0:B0=0:GOTO 400
6090 REM *** FEE FIE FOE FOO ***
6100 IF L1=71 THEN 6130
6110 z59 = 2:gosub 7620
6120 GOTO 410
6130 IF S(8)<>L1 THEN 6180
6140 REM MAKE NEST VANISH
6150 z59 = 79:gosub 7620
6160 S(8)=0:GOTO 400
6180 REM IF S(8)=0 THEN 6110
6190 S(8)=L1
6200 rem MAKE NEST RE-APPEAR
6210 z59 = 81:gosub 7620
6220 GOTO 400
6230 REM *** SHORT ***
6240 PRINT "Short descriptions"
6250 D0=0:GOTO 400
6270 REM *** LONG ***
6280 PRINT "Long descriptions"
6290 D0=1:GOTO 400
6310 REM *** BRIEF ***
6320 PRINT "OK, I'll only describe the room in detail the first time."
6330 D0=2:GOTO 400
6350 REM *** QUIT ***
6360 PRINT "Save game";
6370 GOSUB 9860
6380 IF Z0=1 THEN 8970
6390 GOTO 9750
6400 REM SCORE ***
6410 GOSUB 6430
6420 GOTO 400
6430 REM PRINT OUT SCORE DATA
6440 GOSUB 6510
6450 PRINT "Your score is now ";S0
6451 PRINT "You have explored ";(Z9/T1)*T1;"% of the cave."
6460 RESTORE 6470
6470 DATA "beginner","novice","experienced","advanced","expert"
6480 Z9 = INT((S0-1)/100)
6481 IF Z9 <= 4 THEN 6483
6482 Z9=4
6483 FOR Z0=0 TO Z9
6484  READ D$
6485 NEXT Z0
6490 PRINT "That makes you a ";D$;" adventurer."
6500 RETURN
6510 REM COMPUTE CURRENT SCORE
6520 RESTORE 230
6530 Z9=0:S0=0
6540 FOR Z0=1 TO 15
6550  READ Z1
6560  IF Z1=0 THEN 6590
6570  IF V(Z1)<>1 THEN 6580
6575  S0=S0+4*O(Z0)
6580  IF S(Z0)<>7 THEN 6590
6585  S0=S0+4*O(Z0)
6590 NEXT Z0
6600 S0=(G=1)*10 + S0:S0=(SN=0)*20 + S0:S0=(D1=0)*30 + S0:S0=(T=0)*30 + S0:S0=(B1=2)*20 + S0
6605 S0=(B2=1)*20 + S0:S0=(P1=2)*20 + S0:S0=(D2=1)*20 + S0:S0=(C=1)*20 + S0
6610 FOR Z0 = 1 TO T1
6620  IF V(Z0)<>1 THEN 6630
6621  S0=S0+1:Z9=Z9+1
6630 NEXT Z0
6640 RETURN
6660 rem list items at location l1
6680 fseek #2,0
6690 for z1 = 1 to t2
6700  INPUT #2,a$
6710  if s(z1) <> l1 then 6720
6711  PRINT a$
6720 next z1
6721 IF S(26)<>-1 THEN 6730
6722 z59 = 67:gosub 7620
6730 rem CHECK FOR DWARF,PIRATE
6740 gosub 8560
6745 if dead = 1 then 6770
6750 gosub 8800
6760 PRINT
6770 return
6775 rem Print Short room description
6780 fseek #1,0
6820 for z1 = 1 to l1
6830  INPUT #1,a$
6840 next z1
6850 v(l1) = 1
6860 PRINT a$
6870 return
6880 rem SPECIAL GETS
6890 if not (z3 = 24 or z3 = 30 or z3 > 31) then 6930
6900 rem CAN'T GET THESE FOR SOME REASON
6910 z59 = 61:gosub 7620
6920 goto 400
6930 if not (z3 = 12 and c = 0) then 6970
6940 rem CHAIN
6950 z59 = 58:gosub 7620
6960 goto 3900
6970 rem BEAR IS HE FED? UNLOCKED?
6980 if not (z3 = 26 and b1 <> 2) then 7010
6990 z59 = 61:gosub 7620
7000 goto 3900
7010 if not (z3 = 14 and d1 = 1) then 7050
7020 rem DRAGON AND RUG
7030 z59 = 59:gosub 7620
7040 goto 3900
7050 if not (z3 = 16 or z3 = 17) then 7090
7060 rem OIL AND WATER DO SAME AS FILL
7070 PRINT "Why not say 'fill'?"
7080 goto 3900
7090 if not (z3 = 22 and b3) then 7140
7100 rem TAKE BIRD SINCE IT'S IN CAGE
7110 s(31) = -1:PRINT "Bird and ";:goto 3880
7140 if z3 <> 31 then 7310
7150 rem GETTING BIRD
7160 if b3 <> 1 then 7210
7170 rem TAKE CAGE, SINCE BIRD IS IN IT
7180 PRINT "Cage and ";:s(22) = -1:goto 3880
7210 if s(22) = -1 then 7240
7220 b$ = "cage":goto 2810
7240 if s(23) = -1 then 7280
7250 rem OK TO TAKE BIRD
7260 s(31) = -1 : b3 = 1:goto 3890
7280 rem ROD SCARES BIRD
7290 z59 = 37:gosub 7620
7300 goto 3900
7310 rem BOTTLE FULL? IF SO, GET CONTENTS
7320 if not (z3 = 21 and b0) then 7360
7330 PRINT "Contents and the ";
7340 s(b0+15) = -1
7360 goto 3880
7370 rem SPECIAL "DROP"
7380 IF Z3<>31 THEN 7440
7390 REM BIRD IN CAGE
7400 S(31)=L1:S(22)=L1:B3=1
7410 IF Z3<>31 THEN 7420
7415 PRINT "Cage and ";
7420 IF Z3=22 THEN 7430
7425 PRINT "Bird and ";
7430 goto 4120
7440 if z3=22 and b3=1 then 7400
7450 IF Z3<>21 THEN 7520
7460 REM BOTTLE
7470 IF B0=0 THEN 4120
7480 REM BOTTLE IS FULL, DO DROP CONTENTS TOO
7490 PRINT "Contents and ";
7500 S(15+B0)=L1:GOTO 4120
7520 IF NOT (Z3=16 OR Z3=17) THEN 7541
7530 PRINT "Try saying 'empty'":goto 4140
7541 IF Z3<>26 OR T<>1 OR (L1<>60 AND L1<>61) THEN 7550
7542 z59 = 28:gosub 7620
7543 T=0:S(26)=L1:S(32)=0:GOTO 400
7550 IF Z3<>6 THEN 4120
7560 IF S(28)=L1 THEN 7600
7570 REM GOODBYE, FRAGILE VASE!
7580 z59 = 43:gosub 7620
7581 S(6)=0:S(29)=L1:GOTO 400
7600 z59 = 60:gosub 7620
7610 GOTO 4120
7619 rem PRINT MESSAGE
7620 if indx(1) >= 0 then 7640
7630 gosub 12500
7640 z59 = int(z59):xtmp = indx(z59)
7645 if z59 <> 2 and z59 <> 61 then 7660
7650 xtmp = fraindx(xtmp+min(int(RND(1)*5),5))
7660 fseek #3,xtmp
7670 INPUT #3,b1$
7672 if len(b1$) = 0 then 7673 else 7690
7673 b1$ = " "
7690 if instr(b1$,"#") = 0 then 7670
7700 z4 = val(mid$(b1$,2))
7705 if int(z4) = z59 then 7720
7710 if int(z4) < z59 then 7670
7712 if int(z4) > z59 then 7760
7720 INPUT #3,b1$
7730 if mid$(b1$,1,1) = "#" then 7770
7740 PRINT b1$
7750 goto 7720
7760 PRINT "NO DESC. # ";z59;" IN FILE AMESSAGE"
7770 return
7800 rem
7810 rem SITUATION DESCRIPTIONS
7820 rem
7830 rem GRATE
7840 if l1 = 10 or l1 = 11 then 7842 else 7860
7842 z59 = (g+10):gosub 7620
7850 rem CRYSTAL BRIDGE
7860 if (l1 = 19 or l1 = 20) and b2 = 1 then 7861 else 7880
7861 z59 = 14:gosub 7620
7870 rem PLUGH NOISE
7880 if l1 = 26 and RND(1) > 0.3 then 7881 else 7900
7881 z59 = 41:gosub 7620
7890 rem IRON DOOR
7900 if l1 = 73 and d2 = 0 then 7901 else 7920
7901 z59 = 57:gosub 7620
7910 rem TROLL
7920 if (l1 = 60 or l1 = 61) and t = 1 then 7921 else 7940
7921 z59 = 63:gosub 7620
7930 rem BEAR
7940 if l1 = 69 and b1 = 0 then 7941 else 7950
7941 z59 = 64:gosub 7620
7950 if l1 = 69 and b1 = 1 then 7951 else 7970
7951 z59 = 66:gosub 7620
7960 rem PLANT IN PIT
7970 if l1 = 48 or l1 = 50 then 7971 else 7980
7971 z59 = 47+p1:gosub 7620
7980 return
7990 rem
8000 rem   PRINT long room description from "amessage" file
8010 rem   description is noormally l1+200 except for
8020 rem   maze or forest
8030 rem set v(l1)=1 so as not to repeat long desc(brief mode
8040 v(l1) = 1
8050 if l1 > 4 then 8080
8060 z59 = 200:gosub 7620
8070 goto 8130
8080 if not (l1 > 88 and l1 < 98 or l1 = 99) then 8110
8090 z59 = 288:gosub 7620
8100 goto 8130
8110 rem normal description
8120 z59 = 200+l1:gosub 7620
8130 return
8180 rem always give long description for forest and maze
8190 if l1 < 5 or (l1 > 88 and l1 < 98) or l1 = 99 then 8220
8200 if v(l1)=1 then 8201 else 8220
8201 gosub 6780
8202 goto 8235
8210 rem he hassn't seen this room, so give a long desc.
8220 v(l1) = 1
8230 gosub 7990
8235 return
8240 rem
8250 rem   fetch first item code in k(1 to t2)
8260 rem   z8=total # of items found in list
8270 rem   z3=item code first found
8280 z8 = 0 : z3 = 0: d$ = ""
8300 for z5 = 1 to 45
8320 if k(z5) = 0 then 8360
8330 z8 = z8+1
8340 restore 9960+z5:read b$:d$ = b$
8350 if k(z5)=1 and z8 = 1 then 8352 else 8360
8352 z3 = z5
8360 next z5
8370 b$ = d$
8380 return
8390 rem FIND FIRST ITEM AT ROOM
8400 x1 = 0
8410 FOR Z1=1 TO 47
8415  if x1=1 then 8440
8430  IF K(Z1) = 1 THEN 8431 else 8440
8431  restore 9960+z1:read d$:x1=1
8440 NEXT Z1
8450 RETURN
8460 REM 
8470 REM MAKE SURE HE'S CARRYING ITEM * Z3
8480 REM
8490 IF S(Z3)=-1 THEN 8530
8500 PRINT "You don't have the ";A$
8510 Z5=0
8520 RETURN
8530 Z5=1
8540 RETURN
8550  rem  *** DWARF ***
8560 if d3 <> 0 then 8640
8570 rem SHOULD DWARF GIVE AWAY AXE?
8580 if l1 < 13 then 8790
8590 if RND(1) > 0.05 then 8790
8600 rem GIVE AWAY AXE
8610 z59 = 80:gosub 7620
8620 s(27) = l1 : d3 = 1
8630 goto 8790
8640 rem SHOULD DWARF ATTACK?
8650 if L1 >= 13 then 8660
8652 s(35) = 0:goto 8790
8660 if s(35) <> L1 then 8770
8661 if (l1 <> 60 and l1 <> 61) or t <> 1 then 8670
8662 z59 = 299:gosub 7620
8663 s(35) = 0: goto 8790
8670 if RND(1) > 0.5 then 8790
8680 rem YES!
8690 z59 = 32:gosub 7620
8700 rem DOES THE KNIFE KILL THE PLAYER?
8705 KC = KC - 0.02
8706 IF KC >= 0.75 THEN 8710
8707 KC = 0.75
8710 if RND(1) <= KC then 8750
8720 rem YES
8730 PRINT "It gets you!"
8740 dead = 1 : goto 8790
8750 PRINT "It misses!"
8760 goto 8790
8770 rem SHOULD WE PUT A DWARF HERE?
8780 if RND(1) >= 0.05 then 8790
8781 if (l1 = 60 or l1 = 61) and t = 1 then 8790
8785 s(35) = l1
8786 z59=31:gosub 7620
8790 return
8800 rem *** PIRATE ***
8810 rem FIRST, DOES HE HAVE ANYTHING WORTH STEALING?
8820 z3 = 0
8830 if l1 < 13 then 8960
8840 for x = 1 to 15
8850  if s(x) <> -1 then 8860
8855  z3 = z3+1
8860 next x
8870 if z3 < int(RND(1)*4)+1 then 8960
8880 rem SHOULD WE RIP OFF HIS VALUABLES?
8890 if RND(1) < 0.05 then 8920
8900 z59 = 34:gosub 7620
8910 goto 8960
8920 z59 = 33:gosub 7620
8930 for x = 1 to 15
8940  if s(x) <> -1 then 8950
8945  s(x) = 100
8950 next x
8960 return
8970 REM *** SAVE GAME ***
8980 INPUT "What do you want to call the save file? ";A$
8990 OPEN A$ FOR OUTPUT AS #5 ELSE 9010
9000 GOTO 9030
9010 PRINT "File ";a$;" not created"
9020 GOTO 410
9030 PRINT #5,T1;",";T2;",";T3;",";L1;",";L2;",";G;",";B0;",";SN;",";D1;",";D2;",";D0;",";T;",";B1;",";B2;",";P1;",";L;",";C;",";D3;",";B3;",";R0;",";KC
9040 FOR X=1 TO 99
9041  PRINT #5,S(X);",";V(X)
9042 NEXT X
9043 PRINT #5,V(100)
9044 CLOSE #5
9050 PRINT "Game saved"
9051 C0 = 0
9060 if k(143) = 1 then 9750
9070 GOTO 410
9080 REM *** LOAD OLD GAME ***
9090 IF C0=0 THEN 9120
9100 PRINT "You already have a loaded game!"
9110 GOTO 410
9120 INPUT "Save file name? ";A$
9130 OPEN A$ FOR INPUT AS #5 ELSE 9150
9140 GOTO 9170
9150 PRINT "Unable to use file ";A$
9160 GOTO 410
9170 INPUT #5,T1,T2,T3,L1,L2,G,B0,SN,D1,D2,D0,T,B1,B2,P1,L,C,D3,B3,R0,KCX$
9171 kc = val(kcx$)
9180 FOR X=1 TO 99
9191  INPUT #5,SX,VX:s(x)=sx:v(x)=vx
9192 NEXT X
9193 INPUT #5,vx:v(100)=vx
9194 CLOSE #5
9200 C0=1
9210 GOTO 300
9220 rem *** READ THE MAGAZINE ***
9230 GOSUB 8280
9240 IF Z3=25 THEN 9270
9250 z59 = 74:gosub 7620
9260 GOTO 410
9270 IF S(25)=-1 THEN 9300
9280 B$="magazine"
9290 GOTO 2710
9300 REM OK, LET HIM READ IT
9310 z59 = 303:gosub 7620
9320 GOTO 400
9330 REM *** BUG ***
9340 A$ = "ADVBUGS.TXT"
9341 OPEN A$ FOR APPEND AS #5 ELSE 9150
9390 INPUT "Your name: ";A$
9400 A$=A$+" "+DATE$
9410 PRINT #5,A$
9420 PRINT "Enter your gripe in up to five lines (hit return to quit):"
9430 FOR Z0=1 TO 5
9440  PRINT Z0;
9450  INPUT A$
9460  IF A$="" THEN 9490
9470  PRINT #5,A$
9480 NEXT Z0
9490 PRINT "Message recorded. Thank you!"
9500 CLOSE #5
9510 GOTO 410
9540 REM REINCARNATE HIM
9550 R0=R0+1
9560 IF R0=1 THEN 9580
9561 IF R0=2 THEN 9610
9562 IF R0=3 THEN 9740
9570 REM ASK HIM IF HE WANTS TO BE REINCARNATED
9580 z59 = 75:gosub 7620
9590 GOSUB 9860
9600 GOTO 9630
9610 z59 = 77:gosub 7620
9620 GOTO 9580
9630 IF Z0=0 THEN 9750
9640 z59 = 76:gosub 7620
9650 REM PUT HIM BACK IN HOUSE, REARRANGE HIS STUFF
9660 S(18)=7:L=0:DEAD=0:KC=1.03
9670 FOR X=1 TO T2
9680  IF S(X)<>-1 THEN 9690
9685  S(X)=L1
9690 NEXT X
9700 REM WE'VE PUT THE LAMP IN HOUSE AND OTHER ITEMS WHERE HE DIED
9710 L1=INT(RND(1)*4)+1:L2=L1
9720 GOTO 320
9730 REM THIRD DEATH--END OF GAME
9740 z59 = 78:gosub 7620
9750 PRINT "Oh well..."
9760 GOSUB 6430
9762 close #1:close #2:close #3
9770 STOP
9780 rem *** PITS ***
9790 if l1 < 13 THEN 300
9791 IF l = 1 and (s(18) = -1 or s(18) = l1) then 300
9800 rem IS HE GOING TO FALL INTO A PIT?
9810 if l1 = 16 or l1 = 17 or l1 = 19 or l1 = 20 or l1 = 25 or l1 = 47 or l1 = 48 or l1 = 59 or l1 = 60 or l1 = 61 or l1 = 75 or l1 = 76 or l1 = 98 then 9840
9820 goto 300
9830 rem he fell into a pit
9840 z59 = 44:gosub 7620
9850 goto 9540
9860 rem *** SEEK A "YES" OR "NO"
9870 INPUT a$
9875 if len(a$) <> 0 then 9880
9877 a$ = " "
9880 a$ = LOWER$(mid$(a$,1,1))
9890 if a$ <> "y" and a$ <> "n" then 9930
9900 if a$ = "y" then 9901 else 9910
9901 z0 = 1
9910 if a$ = "n" then 9911 else 9920
9911 z0 = 0
9920 goto 9945
9930 PRINT "Yes or No-";
9940 goto 9870
9945 return
9950 rem   ---- SHORT NAMES FOR STUFF ----
9961 data "large gold nugget"
9962 data "bars of silver"
9963 data "precious jewelry"
9964 data "many coins"
9965 data "several diamonds"
9966 data "fragile ming vase"
9967 data "glistening pearl"
9968 data "nest of golden eggs"
9969 data "jewel-encrusted trident"
9970 data "egg-sized emerald"
9971 data "platinum pyramid"
9972 data "golden chain"
9973 data "rare spices"
9974 data "persian rug"
9975 data "treasure chest"
9976 data "water"
9977 data "oil"
9978 data "brass lamp"
9979 data "keys"
9980 data "food"
9981 data "bottle"
9982 data "wicker cage"
9983 data "3-foot black rod"
9984 data "clam"
9985 data "magazine"
9986 data "bear"
9987 data "axe"
9988 data "velvet pillow"
9989 data "shards of pottery"
9990 data "oyster"
9991 data "bird"
9992 data "troll"
9993 data "dragon"
9994 data "snake"
9995 data "dwarf"
9996 data "rock"
9997 data "stairs"
9998 data "steps"
9999 data "house"
10000 data "grate"
10001 data "stream"
10002 data "room"
10003 data "bridge"
10004 data "pit"
10005 data "volcano"
10006 data "road"
10007 data "everything"
12500 rem INITIALIZE MESSAGE INDEX
12501 open "AMESSAGE.IDX" for INPUT as #6 else 12505
12502 goto 12610
12504 rem Message indx file doesn't exist, create it
12505 OPEN "AMESSAGE.IDX" FOR OUTPUT AS #6
12506 fpos = -2:b$ = "":fracnt= 0:lastfra=-1:fseek #3,0
12520 fpos = fpos+len(b$)+2
12522 INPUT #3,b$
12530 if len(b$) = 0 then 12531 else 12540
12531 b$ = " " : fpos = fpos-1
12540 if b$="#" then 12591
12550 if instr(b$,"#") = 0 then 12520
12560 z4 = val(mid$(b$,2))
12570 if int(z4) = z4 then 12580
12571 fracnt = fracnt + 1
12572 if lastfra = int(z4) then 12574
12573 indx(int(z4)) = fracnt:lastfra = int(z4):PRINT #6,int(z4);",";FRACNT
12574 fraindx(fracnt) = fpos
12576 goto 12585
12580 indx(int(z4)) = fpos
12581 PRINT #6,int(z4);",";FPOS
12585 PRINT "*";
12590 goto 12520
12591 PRINT #6,-999;",";-999
12592 FOR I = 1 TO FRACNT
12593 PRINT #6,FRAINDX(I)
12594 NEXT I
12595 PRINT #6,-999
12596 close #3
12597 open "AMESSAGE" for INPUT as #3
12600 GOTO 12670
12604 REM READ AMESSAGE.IDX FILE INTO ARRAYS
12610 INPUT #6,II,I
12612 PRINT "*";
12615 IF I=-999 THEN 12630
12620 INDX(II)=I:GOTO 12610
12630 II = 0
12640 INPUT #6,I
12641 PRINT "*";
12650 IF I=-999 THEN 12670
12660 II = II +1:FRAINDX(II)=I:GOTO 12640
12670 CLOSE #6:PRINT:PRINT
12680 RETURN
