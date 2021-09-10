520 REM
530 REM
540 REM ****       **** STAR TREK ****       ****
550 REM ****  Simulation of a mission of the starship ENTERPRISE
560 REM ****  as seen on the Star Trek tv show
570 REM ****  Original program in Creative Computing
580 REM ****  Basic Computer Games by Dave Ahl
590 REM ****  Modifications by Bob Fritz and Sharon Fritz
600 REM **** for the IBM Personal Computer, October-November 1981
610 REM **** Bob Fritz, 9915 Caninito Cuadro, San Diego, Ca., 92129
620 REM ****  (714) 484-2955
630 REM ****
640 for i = 1 to 10
644 print
648 next i
650 E1$= "                ,-----------------,       _"
660 E2$= "                `----------   ----',-----/ \----,"
670 E3$= "                           | |     '-  --------'"
680 E4$= "                        ,--' '------/ /--,"
690 E5$= "                       '-----------------'"
691 PRINT
700 E6$= "                   THE USS ENTERPRISE --- NCC-1701"
710 rem E8$=CHR$(15)
720 PRINT E1$
730 PRINT E2$
740 PRINT E3$
750 PRINT E4$
760 PRINT E5$
770 PRINT
780 PRINT E6$
790 for i = 1 to 7
794 print
798 next i
800 rem CLEAR 600
810 rem RANDOMIZE 120*(VAL(RIGHT$(TIME$,2)) + VAL(MID$(TIME$,3,5)) )
811 RANDOMIZE
820 REM Z$="                         "
830 GOSUB 840
831 GOTO 960
840 REM  ------- set function keys  for game -------
850 rem KEY 1,"NAV"+CHR$(13)
860 rem KEY 2,"SRS"+CHR$(13)
870 rem KEY 3,"LRS"+CHR$(13)
880 rem KEY 4,"PHASERS"+CHR$(13)
890 rem KEY 5,"TORPEDO"+CHR$(13)
900 rem KEY 6,"SHIELDS"+CHR$(13)
910 rem KEY 7,"DAMAGE REPORT"+CHR$(13)
920 rem KEY 8,"COMPUTER"+CHR$(13)
930 rem KEY 9,"RESIGN"+CHR$(13)
940 rem KEY 10,""
950 RETURN
960 dim D(9)
961 dim C(10,3)
962 dim K(4,4)
963 dim N(4)
965 DIM G(9,9)
966 DIM Z(9,9)
970 T=INT(RND(1)*20+20)*100
971 T0=T
972 T9=25+INT(RND(1)*10)
973 D0=0
974 E=3000
975 E0=E
980 P=10
981 P0=P
982 S9=200
983 S=0
984 B9=0
985 K9=0
986 X$=""
987 X0$=" is "
990 rem DEF FND(D)=SQR((K(I,1)-S1)^2+(K(I,2)-S2)^2)
1000 rem DEF FNR(R)=INT(RND(R)*7.98+1.01)
1010 REM initialize enterprise's position
1020 Q1=INT(RND(1)*7.98+1.01)
1021 Q2=INT(RND(1)*7.98+1.01)
1022 S1=INT(RND(1)*7.98+1.01)
1023 S2=INT(RND(1)*7.98+1.01)
1030 FOR I=1 TO 9
1031 C(I,1)=0
1032 C(I,2)=0
1033 NEXT I
1040 C(3,1)=-1
1041 C(2,1)=-1
1042 C(4,1)=-1
1043 C(4,2)=-1
1044 C(5,2)=-1
1045 C(6,2)=-1
1050 C(1,2)=1
1051 C(2,2)=1
1052 C(6,1)=1
1053 C(7,1)=1
1054 C(8,1)=1
1055 C(8,2)=1
1056 C(9,2)=1
1060 FOR I=1 TO 8
1061 D(I)=0
1062 NEXT I
1070 A1$="NAVSRSLRSPHATORSHIDAMCOMRES"
1080 REM set up what exists in galaxy
1090 REM k3=#klingons  b3=#starbases  s3=#stars
1100 FOR I=1 TO 8
1101 FOR J=1 TO 8
1102 K3=0
1103 Z(I,J)=0
1104 R1=RND(1)
1110 IF R1<=0.9799999 THEN goto 1120
1111 K3=3
1112 K9=K9+3
1113 GOTO 1140
1120 IF R1<=0.95 THEN goto 1130
1121 K3=2
1122 K9=K9+2
1123 GOTO 1140
1130 IF R1<=0.8 THEN goto 1140
1131 K3=1
1132 K9=K9+1
1140 B3=0
1141 IF RND(1)<=0.96 THEN goto 1150
1142 B3=1
1143 B9=B9+1
1150 G(I,J)=K3*100+B3*10+INT(RND(1)*7.98+1.01)
1151 NEXT J
1152 NEXT I
1153 IF K9<=T9 THEN goto 1160
1154 T9=K9+1
1160 IF B9<>0 THEN 1190
1170 IF G(Q1,Q2)>=200 THEN 1180
1171 G(Q1,Q2)=G(Q1,Q2)+100
1172 K9=K9+1
1180 B9=1
1181 G(Q1,Q2)=G(Q1,Q2)+10
1182 Q1=INT(RND(1)*7.98+1.01)
1183 Q2=INT(RND(1)*7.98+1.01)
1190 K7=K9
1191 IF B9=1 THEN 1200
1192 X$="s"
1193 X0$=" are "
1200 PRINT"      Your orders are as follows: "
1210 PRINT"      Destroy the ",K9," Klingon warships which have invaded"
1220 PRINT"    the galaxy before they can attack Federation headquarters"
1230 PRINT"    on stardate ",T0+T9,". This gives you ",T9," days.  there",X0$
1240 PRINT"  ",B9," starbase",X$," in the galaxy for resupplying your ship"
1250 rem PRINT PRINT  "hit any key except return when ready to accept command"
1260 rem I=RND(1) IF INP(1)=13 THEN 1260
1261 PRINT
1262 input "hit return when ready to accept command";i$
1270 REM here any time new quadrant entered
1280 Z4=Q1
1281 Z5=Q2
1282 K3=0
1283 B3=0
1284 S3=0
1285 G5=0
1286 D4=0.5*RND(1)
1287 Z(Q1,Q2)=G(Q1,Q2)
1290 IF Q1<1 OR Q1>8 OR Q2<1 OR Q2>8 THEN 1410
1300 GOSUB 5040
1301 PRINT
1302 IF T0 <>T THEN 1330
1310 PRINT"Your mission begins with your starship located"
1320 PRINT"in the galactic quadrant, '";G2$;"'."
1321 GOTO 1340
1330 PRINT"Now entering ";G2$;" quadrant. . ."
1340 PRINT
1341 K3=INT(G(Q1,Q2)*0.01)
1342 B3=INT(G(Q1,Q2)*0.1)-10*K3
1350 S3=G(Q1,Q2)-100*K3-10*B3
1351 IF K3=0 THEN 1400
1360 PRINT "COMBAT AREA!! Condition RED"
1370 rem PRINT " RED ":
1371 rem PRINT
1380 GOSUB 5290
1381 IF S>200 THEN 1400
1390 PRINT"    SHIELDS DANGEROUSLY LOW"
1391 rem print
1392 rem PRINT SPC(53)
1400 FOR I=1 TO 3
1401 K(I,1)=0
1402 K(I,2)=0
1403 NEXT I
1410 FOR I=1 TO 3
1411 K(I,3)=0
1412 NEXT I
1413 Q$=" "*192
1420 REM position enterprise in quadrant, then place "k3" klingons,&
1430 REM "b3" starbases & "s3" stars elsewhere.
1440 A$="\e/"
1441 Z1=S1
1442 Z2=S2
1443 GOSUB 4830
1445 IF K3<1 THEN 1470
1450 FOR I=1 TO K3
1451 GOSUB 4800
1452 A$=chr$(187)+"K"+chr$(171)
1453 Z1=R1
1454 Z2=R2
1460 GOSUB 4830
1461 K(I,1)=R1
1462 K(I,2)=R2
1463 K(I,3)=S9*(0.5+RND(1))
1464 NEXT I
1470 IF B3<1 THEN 1500
1480 GOSUB 4800
1481 A$="("+chr$(174)+")"
1482 Z1=R1
1483 B4=R1
1484 Z2=R2
1485 B5=R2
1490 GOSUB 4830
1500 FOR I=1 TO S3
1502 GOSUB 4800
1503 A$=" * "
1504 Z1=R1
1505 Z2=R2
1506 GOSUB 4830
1507 NEXT I
1510 GOSUB 3720
1520 IF S+E<=10 THEN 1530
1521 IF E>10 OR D(7)>=0 THEN 1580
1530 PRINT"*** FATAL ERROR ***"
1531 GOSUB 5290
1540 PRINT"You've just stranded your ship in space"
1551 PRINT"You have insufficient maneuvering energy, and shield control"
1561 PRINT"is presently incapable of cross-circuiting to engine room!!"
1571 GOTO 3480
1580 INPUT"command ";A$
1590 FOR I=1 TO 9
1591 IF mid$(A$,0,3)<> MID$(A1$,3*I-3,3*I) THEN 1610
1600 ON I GOTO 1720,1510,2440,2530,2750,3090,3180,3980,3510
1610 NEXT I
1611 PRINT"Enter one of the following:"
1620 PRINT"  NAV   (to set course)"
1630 PRINT"  SRS   (for short range sensor scan)"
1640 PRINT"  LRS   (for long range sensor scan)"
1650 PRINT"  PHA   (to fire phasers)"
1660 PRINT"  TOR   (to fire photon torpedoes)"
1670 PRINT"  SHI   (to raise or lower shields)"
1680 PRINT"  DAM   (for damage control reports)"
1690 PRINT"  COM   (to call on library-computer)"
1700 PRINT"  RES   (to resign your command)"
1702 PRINT
1703 GOTO 1520
1710 REM course control begins here
1720 INPUT"Course (1-9) ";C2$
1721 C1=VAL(C2$)
1723 IF C1<>9 THEN 1730
1724 C1=1
1730 IF C1>=1 AND C1<9 THEN 1750
1740 PRINT"   Lt. Sulu reports,  'Incorrect course data, sir!'"
1741 GOTO 1520
1750 X$="8"
1751 IF D(1)>=0 THEN 1760
1752 X$="0.2"
1760 PRINT"Warp factor(0-";X$;") "
1761 INPUT C2$
1762 W1=VAL(C2$)
1763 IF D(1)<0 AND W1>0.2 THEN 1810
1770 IF W1>0 AND W1<8 THEN 1820
1780 IF W1=0 THEN 1520
1790 PRINT"   Chief Engineer Scott reports 'The engines won't take warp ";W1;"!"
1801 GOTO 1520
1810 PRINT"Warp engines are damaged.  Maximum speed = warp 0.2"
1811 GOTO 1520
1820 N1=INT(W1*8+0.5)
1821 IF E-N1>=0 THEN 1900
1830 PRINT"Engineering reports   'Insufficient energy available"
1840 PRINT"                       for maneuvering at warp ";W1;"!'"
1850 IF S<N1-E OR D(7)<0 THEN 1520
1860 PRINT"Deflector control room acknowledges ";S;" units of energy"
1870 PRINT"                         presently deployed to shields."
1880 GOTO 1520
1890 REM klingons move/fire on moving starship . . .
1900 FOR I=1 TO K3
1901 IF K(I,3)=0 THEN 1930
1910 A$="   "
1911 Z1=K(I,1)
1912 Z2=K(I,2)
1913 GOSUB 4830
1914 GOSUB 4800
1920 K(I,1)=Z1
1921 K(I,2)=Z2
1922 A$=chr$(187)+"K"+chr$(171)
1923 GOSUB 4830
1930 NEXT I
1931 REM GOSUB 4810
1932 D1=0
1933 D6=W1
1934 IF W1<1 THEN 1940
1935 D6=1
1940 FOR I=1 TO 8
1941 IF D(I)>=0 THEN 1990
1950 D(I)=min(0,D(I)+D6)
1951 IF D(I)<=-0.1  or D(I)>=0 THEN 1960
1952 D(I)=-0.1
1953 GOTO  1990
1960 IF D(I)<0 THEN 1990
1970 IF D1=1 THEN 1980
1971 D1=1
1972 PRINT"DAMAGE CONTROL REPORT:   "
1980 PRINT TAB(8)
1981 R1=I
1982 GOSUB 4890
1983 PRINT G2$;" Repair completed."
1990 NEXT I
1991 IF RND(1)>0.2 THEN 2070
2000 R1=INT(RND(1)*7.98+1.01)
2001 IF RND(1)>=0.6 THEN 2040
2010 IF K3=0 THEN 2070
2020 D(R1)=D(R1)-(RND(1)*5+1)
2021 PRINT"DAMAGE CONTROL REPORT:   "
2030 GOSUB 4890
2031 PRINT G2$;" damaged"
2032 PRINT
2033 GOTO 2070
2040 D(R1)=min(0,D(R1)+RND(1)*3+1)
2041 PRINT"DAMAGE CONTROL REPORT:   "
2050 GOSUB 4890
2051 PRINT G2$;" State of repair improved"
2052 PRINT
2060 REM begin moving starship
2070 A$="   "
2071 Z1=INT(S1)
2072 Z2=INT(S2)
2073 GOSUB 4830
2078 Z1=INT(C1)
2079 C1=C1-Z1
2080 X1=C(Z1,1)+(C(Z1+1,1)-C(Z1,1))*C1
2081 X=S1
2082 Y=S2
2090 X2=C(Z1,2)+(C(Z1+1,2)-C(Z1,2))*C1
2091 Q4=Q1
2092 Q5=Q2
2100 FOR I=1 TO N1
2101 S1=S1+X1
2102 S2=S2+X2
2103 IF S1<1 OR S1>=9 OR S2<1 OR S2>=9 THEN 2220
2110 S8=INT(S1)*24+INT(S2)*3-26
2111 IF MID$(Q$,S8,S8+2)="  " THEN 2140
2120 S1=INT(S1-X1)
2121 S2=INT(S2-X2)
2122 PRINT"Warp engines shut down at sector ";S1;",";S2;" due to bad navigation."
2131 GOTO 2150
2140 NEXT I
2141 S1=INT(S1)
2142 S2=INT(S2)
2150 A$="\e/"
2160 Z1=INT(S1)
2161 Z2=INT(S2)
2162 GOSUB 4830
2163 GOSUB 2390
2164 T8=1
2170 IF W1>=1 THEN 2180
2171 T8=0.1*INT(10*W1)
2180 T=T+T8
2181 IF T>T0+T9 THEN 3480
2190 REM see if docked then get command
2200 GOTO 1510
2210 REM exceeded quadrant limits
2220 X=8*Q1+X+N1*X1
2221 Y=8*Q2+Y+N1*X2
2222 Q1=INT(X/8)
2223 Q2=INT(Y/8)
2224 S1=INT(X-Q1*8)
2230 S2=INT(Y-Q2*8)
2231 IF S1<>0 THEN 2240
2232 Q1=Q1-1
2233 S1=8
2240 IF S2<>0 THEN 2249
2241 Q2=Q2-1
2242 S2=8
2249 X5=0
2250 IF Q1>=1 THEN 2260
2251 X5=1
2252 Q1=1
2253 S1=1
2260 IF Q1<=8 THEN 2270
2261 X5=1
2262 Q1=8
2263 S1=8
2270 IF Q2>=1 THEN 2280
2271 X5=1
2272 Q2=1
2273 S2=1
2280 IF Q2<=8 THEN 2290
2281 X5=1
2282 Q2=8
2283 S2=8
2290 IF X5=0 THEN 2360
2300 PRINT"Lt. Uhura reports message from Starfleet Command:"
2310 PRINT"  'Permission to attempt crossing of galactic perimeter"
2320 PRINT"  is hereby *DENIED*.  Shut down your engines.'"
2330 PRINT"Chief Engineer Scott reports 'Warp engines shut down"
2340 PRINT"  at sector ";S1;",";S2;" of quadrant ";Q1;",";Q2".'"
2350 IF T>T0 THEN 3480
2360 IF 8*Q1+Q2=8*Q4+Q5 THEN 2150
2370 T=T+1
2371 GOSUB 2390
2372 GOTO 1280
2380 REM maneuver energy s/r **
2390 E=E-N1-10
2391 IF E<=0 THEN 2400
2392 RETURN
2400 PRINT"Shield control supplies energy to complete the maneuver."
2410 S=S+E
2411 E=0
2412 IF S<=0 THEN 2420
2413 S=0
2420 RETURN
2430 REM long range sensor scan code
2440 IF D(3)>=0 THEN 2450
2441 PRINT"Long Range Sensors are inoperable"
2442 GOTO 1520
2450 PRINT"Long Range Scan for quadrant ";Q1;",";Q2
2460 PRINT "-"*19
2461 LINE$ = ""
2470 FOR I=Q1-1 TO Q1+1
2471 N(1)=-1
2472 N(2)=-2
2473 N(3)=-3
2474 FOR J=Q2-1 TO Q2+1
2480 IF I<=0 or I>=9 or J<=0 or J>=9 THEN 2490
2481 N(J-Q2+2)=G(I,J)
2482 REM added so long range sensor scans are added to computer database
2483 z(i,j)=g(i,j)
2490 NEXT J
2491 FOR L=1 TO 3
2492 REM PRINT"| "
2493 LINE$ = LINE$ + "| "
2494 IF N(L)>=0 THEN 2500
2495 REM PRINT"*** "
2496 LINE$ = LINE$ + "*** "
2497 GOTO 2510
2500 REM PRINT mid$(STR$(N(L)+1000),1,4)," "
2501 LINE$ = LINE$ + mid$(STR$(N(L)+1000),1,4) + " "
2510 NEXT L
2511 PRINT LINE$ + "|"
2512 PRINT "-"*19
2513 LINE$ = ""
2514 NEXT I
2515 GOTO 1520
2520 REM phaser control code begins here
2530 IF D(4)>=0 THEN 2540
2531 PRINT"Phasers Inoperative"
2532 GOTO 1520
2540 IF K3>0 THEN 2570
2550 PRINT"Science Officer Spock reports  'Sensors show no enemy ships"
2560 PRINT"                                in this quadrant'"
2561 GOTO 1520
2570 IF D(8)>=0 THEN 2580
2571 PRINT"Computer failure hampers accuracy"
2580 PRINT"Phasers locked on target "
2590 PRINT"Energy available = ";E;" units"
2600 INPUT"Numbers of units to fire ";X
2601 IF X<=0 THEN 1520
2610 IF E-X<0 THEN 2590
2620 E=E-X
2621 GOSUB 5420
2622 IF D(7)<0 THEN 2630
2623 X=X*RND(1)
2624 rem print "Energy * Rnd: ",x
2630 H1=INT(X/K3)
2631 FOR I=1 TO 3
2632 IF K(I,3)<=0 THEN 2730
2640 KSQ1 = (K(I,1)-S1)*(K(I,1)-S1)
2641 KSQ2 = (K(I,2)-S2)*(K(I,2)-S2)
2642 H= SQR( KSQ1 + KSQ2 )
2643 rem print "distance to enemy #",i,": ",H
2646 H = H1 / H
2647 H = INT(H * (rnd+2))
2648 IF H>0.15*K(I,3) THEN 2660
2650 PRINT"Sensors show no damage to enemy at ";K(I,1);",";K(I,2)
2651 GOTO 2730
2660 K(I,3)=K(I,3)-H
2661 PRINT H,"Unit hit on Klingon at sector ";K(I,1);","
2670 PRINT K(I,2)
2671 IF K(I,3)> 0 THEN GOTO 2700
2680 PRINT "**** KLINGON DESTROYED ****"
2690 GOTO 2710
2700 PRINT"   (Sensors show ";K(I,3);" units remaining)"
2701 GOTO 2730
2710 K3=K3-1
2711 K9=K9-1
2712 Z1=K(I,1)
2713 Z2=K(I,2)
2714 A$="   "
2715 GOSUB 4830
2720 K(I,3)=0
2721 G(Q1,Q2)=G(Q1,Q2)-100
2722 Z(Q1,Q2)=G(Q1,Q2)
2723 IF K9<=0 THEN 3680
2730 NEXT I
2731 GOSUB 3350
2732 GOTO 1520
2740 REM photon torpedo code begins here
2750 IF P>0 THEN 2760
2751 PRINT"All photon torpedoes expended"
2752 GOTO 1520
2760 IF D(5)>=0 THEN 2770
2761 PRINT"Photon tubes are not operational"
2762 GOTO 1520
2770 INPUT"Photon torpedo course (1-9) ";C2$
2771 C1=VAL(C2$)
2772 IF C1<>9 THEN 2780
2773 C1=1
2780 IF C1>=1 AND C1<9 THEN 2810
2790 PRINT"Ensign Chekov reports,  'Incorrect course data, sir!'"
2800 GOTO 1520
2810 Z1=INT(C1)
2811 C1=C1-Z1
2812 X1=C(Z1,1)+(C(Z1+1,1)-C(Z1,1))*C1
2813 E=E-2
2814 P=P-1
2820 X2=C(Z1,2)+(C(Z1+1,2)-C(Z1,2))*C1
2821 X=S1
2822 Y=S2
2823 GOSUB 5360
2830 PRINT"Torpedo track:"
2840 X=X+X1
2841 Y=Y+X2
2842 X3=INT(X+0.5)
2843 Y3=INT(Y+0.5)
2850 IF X3<1 OR X3>8 OR Y3<1 OR Y3>8 THEN 3070
2860 PRINT"              ";X3;",";Y3
2861 A$="   "
2862 Z1=X
2863 Z2=Y
2864 GOSUB 4990
2870 IF Z3<>0 THEN 2840
2880 A$=chr$(187)+"K"+chr$(171)
2881 Z1=X
2882 Z2=Y
2883 GOSUB 4990
2884 IF Z3=0 THEN 2940
2890 PRINT"**** KLINGON DESTROYED ****"
2900 K3=K3-1
2901 K9=K9-1
2902 IF K9<=0 THEN 3680
2910 FOR I=1 TO 3
2911 IF X3=K(I,1) AND Y3=K(I,2) THEN 2930
2920 NEXT I
2921 I=3
2930 K(I,3)=0
2931 GOTO 3050
2940 A$=" * "
2941 Z1=X
2942 Z2=Y
2943 GOSUB 4990
2944 IF Z3=0 THEN 2960
2950 PRINT"Star at ";X3;",";Y3;" absorbed torpedo energy."
2951 GOSUB 3350
2952 GOTO 1520
2960 A$="("+chr$(174)+")"
2961 Z1=X
2962 Z2=Y
2963 GOSUB 4990
2964 IF Z3<>0 THEN 2970
2965 PRINT "Torpedo absorbed by unknown object at ";x3;",";y3
2966 goto 1520
2970 PRINT"*** STARBASE DESTROYED ***"
2980 B3=B3-1 
2981  B9=B9-1
2990 IF B9>0 OR K9>T-T0-T9 THEN 3030
3000 PRINT"THAT DOES IT, CAPTAIN!!  You are hereby relieved of command"
3010 PRINT"and sentenced to 99 stardates of hard labor on CYGNUS 12!!"
3020 GOTO 3510
3030 PRINT"Starfleet reviewing your record to consider"
3040 PRINT"court martial!"
3041 D0=0
3050 Z1=X
3051 Z2=Y
3052 A$="   "
3053 GOSUB 4830
3060 G(Q1,Q2)=K3*100+B3*10+S3
3061 Z(Q1,Q2)=G(Q1,Q2)
3062 GOSUB 3350
3063 GOTO 1520
3070 PRINT"Torpedo missed"
3071 GOSUB 3350
3072 GOTO 1520
3080 REM shield control
3090 IF D(7)>=0 THEN 3100
3091 PRINT"Shield control inoperable"
3092 GOTO 1520
3100 PRINT"Energy available = ";E+S
3101 INPUT "Number of units to shields? ";X
3110 IF X>=0 and S<>X THEN 3120
3111 PRINT"<shields unchanged>"
3112 GOTO 1520
3120 IF X<E+S THEN 3150
3130 PRINT"Shield Control reports:  This is not the federation treasury."
3140 PRINT"<shields unchanged>"
3141 goto 1990
3150 E=E+S-X
3151 S=X
3152 PRINT "Deflector Control Room report"
3160 PRINT"  'Shields now at ";INT(S);" units per your command.'"
3161 GOTO 1520
3170 REM damage control
3180 IF D(6)>=0 THEN 3290
3190 PRINT"Damage control report not available"
3191 IF D0=0 THEN 1520
3200 D3=0
3201 FOR I=1 TO 8
3202 IF D(I)>=0 THEN 3210
3203 D3=D3+1
3210 NEXT I
3211 IF D3=0 THEN 1520
3220 PRINT
3221 D3=D3+D4
3222 IF D3<1 THEN 3230
3223 D3=0.9
3230 PRINT"Technicians standing by to effect repairs to your ship:"
3240 PRINT"estimated time to repair: ";0.01*INT(100*D3);" stardates"
3250 INPUT"Will you authorize the repair order (Y/N)? ";A$
3260 IF A$<>"y" AND A$<> "Y" THEN 1520
3270 FOR I=1 TO 8
3271 IF D(I)>=0 THEN 3280
3272 D(I)=0
3280 NEXT I
3281 T=T+D3+0.1
3290 PRINT
3291 PRINT"Device            state of repair"
3292 FOR R1=1 TO 8
3300 GOSUB 4890
3301 PRINT G2$
3310 GG2=INT(D(R1)*100)*0.01
3311 PRINT GG2
3320 NEXT R1
3321 PRINT
3322 IF D0<>0 THEN 3200
3330 GOTO 1520
3340 REM klingons shooting
3350 IF K3>0 THEN 3360
3351 RETURN
3360 IF D0=0 THEN 3370
3361 PRINT"Starbase shields protect the ENTERPRISE"
3362 RETURN
3370 FOR I=1 TO 3
3371 IF K(I,3)<=0 THEN 3460
3380 ksq1 = (K(I,1)-S1)*(K(I,1)-S1)
3381 ksq2 = (K(I,2)-S2)*(K(I,2)-S2)
3382 H=( K(I,3) / SQR(  ksq1 + ksq2 ) )*(2+RND(1))
3383 h = int(h)
3384 S=S-H
3385 K(I,3)=K(I,3)/(3+RND(1))
3390 PRINT "ENTERPRISE HIT!"
3400 GOSUB 5480
3401 PRINT H," Unit hit on ENTERPRISE from sector ";K(I,1);",";K(I,2)
3410 IF S<=0 THEN 3490
3420 PRINT"      <shields down to ";S;" units>"
3421 IF H<20 THEN 3460
3430 IF RND(1)>0.6 OR H/S<=0.02 THEN 3460
3440 R1=INT(RND(1)*7.98+1.01)
3441 D(R1)=D(R1)-H/S-0.5*RND(1)
3442 GOSUB 4890
3450 PRINT"Damage control reports  '";G2$;" damaged by the hit'"
3460 NEXT I
3461 RETURN
3470 REM end of game
3480 PRINT"It is stardate";T
3481 GOTO 3510
3490 PRINT
3491 PRINT"the ENTERPRISE has been destroyed.  The Federation will be conquered"
3501 GOTO 3480
3510 PRINT"There were ";K9;" Klingon battle cruisers left at"
3520 PRINT"the end of your mission"
3530 PRINT
3531 PRINT
3532 IF B9=0 THEN 3670
3540 PRINT"The Federation is in need of a new starship commander"
3550 PRINT"for a similar mission -- if there is a volunteer,"
3560 INPUT"let him or her step forward and enter 'AYE' ";X$
3561 IF X$="AYE" THEN 520
3570 rem KEY 1,"LIST "
3580 rem KEY 2,"RUN"+CHR$(13)
3590 rem KEY 3,"LOAD"+CHR$(34)
3600 rem KEY 4, "SAVE"+CHR$(34)
3610 rem KEY 5, "CONT"+CHR$(13)
3620 rem KEY 6,","+CHR$(34)+"LPT1:"+CHR$(34)+CHR$(13)
3630 rem KEY 7, "TRON"+CHR$(13)
3640 rem KEY 8, "TROFF"+CHR$(13)
3650 rem KEY 9, "KEY "
3660 rem KEY 10,"SCREEN 0,0,0"+CHR$(13)
3670 END
3680 PRINT"Congratulations, Captain! the last Klingon battle cruiser"
3690 PRINT"menacing the Federation has been destroyed."
3691 PRINT
3700 cc1 = k7/(t-t0)
3701 PRINT"Your efficiency rating is ";1000*cc1*cc1
3703 GOTO 3530
3710 REM short range sensor scan & startup subroutine
3720 A$="("+chr$(174)+")"
3721 Z3=0
3722 FOR I=S1-1 TO S1+1
3723 FOR J=S2-1 TO S2+1
3730 IF INT(I+0.5)<1 OR INT(I+0.5)>8 OR INT(J+0.5)<1 OR INT(J+0.5)>8 or Z3=1 THEN 3760
3750 Z1=I
3751 Z2=J
3752 GOSUB 4990
3760 NEXT J
3761 NEXT I
3762 IF Z3=1 THEN 3770
3763 D0=0
3764 GOTO 3790
3770 D0=1
3771 CC$="docked"
3772 E=E0
3773 P=P0
3780 PRINT"Shields dropped for docking purposes"
3781 S=0
3782 GOTO 3810
3790 IF K3<=0 THEN 3800
3791 C$="*red*"
3792 GOTO 3810
3800 C$="GREEN"
3801 IF E>=E0*0.1 THEN 3810
3802 C$="YELLOW"
3810 IF D(2)>=0 THEN 3830
3820 PRINT
3821 PRINT"*** Short Range Sensors are out ***"
3822 PRINT
3823 RETURN
3830 PRINT "-"*33
3831 LINE$ = ""
3832 FOR I=1 TO 8
3840 FOR J=(I-1)*24 TO (I-1)*24+21 STEP 3
3850 IF MID$(Q$,J,J+3)<>"   " THEN 3860
3851 REM PRINT "  . "
3852 LINE$ = LINE$ + "  . "
3853 GOTO 3862
3860 REM PRINT " ";MID$(Q$,J,J+3)
3861 LINE$ = LINE$ + " " + MID$(Q$,J,J+3)
3862 NEXT J
3870 ON I GOTO 3880,3900,3910,3920,3930,3940,3950,3960
3880 REM PRINT"        Stardate           "
3881 LINE$ = LINE$ + "        Stardate           "
3890 TT= T*10 
3891  TT=INT(TT)*0.1
3892 PRINT LINE$;TT
3894 GOTO 3970
3900 PRINT LINE$ + "        Condition          ";C$
3901 GOTO 3970
3910 PRINT LINE$+"        Quadrant           ";Q1;",";Q2
3911 GOTO 3970
3920 PRINT LINE$+"        Sector             ";S1;",";S2
3921 GOTO 3970
3930 PRINT LINE$+"        Photon torpedoes   ";INT(P)
3931 GOTO 3970
3940 PRINT LINE$+"        Total energy       ";INT(E+S)
3941 GOTO 3970
3950 PRINT LINE$+"        Shields            ";INT(S)
3951 GOTO 3970
3960 PRINT LINE$+"        Klingons remaining ";INT(K9)
3970 LINE$ = ""
3971 NEXT I
3972 PRINT "-"*33
3973 RETURN
3980 REM library computer code
3990 CM1$="GALSTATORBASDIRREG"
4000 IF D(8)>=0 THEN 4010
4001 PRINT"Computer Disabled"
4002 GOTO 1520
4010 rem KEY 1, "GAL RCD"+CHR$(13)
4020 rem KEY 2, "STATUS"+CHR$(13)
4030 rem KEY 3, "TOR DATA"+CHR$(13)
4040 rem KEY 4, "BASE NAV"+CHR$(13)
4050 rem KEY 5, "DIR/DIST"+CHR$(13)
4060 rem KEY 6, "REG MAP"+CHR$(13)
4070 rem KEY 7,CHR$(13):KEY 8,CHR$(13):KEY 9,CHR$(13):KEY 10,CHR$(13)
4074 gosub 4130
4080 INPUT"Computer active and awaiting command ";CM$
4081 H8=1
4090 FOR K1= 1 TO 6
4100 IF mid$(CM$,0,3)<>MID$(CM1$,3*K1-3,3*K1) THEN 4120
4110 rem   ON K1 GOTO 4230,4400,4490,4750,4550,4210
4111   if k1=1 then 4230
4112   if k1=2 then 4400
4113   if k1=3 then 4490
4114   if k1=4 then 4750
4115   if k1=5 then 4550
4116   if k1=6 then 4210
4120 NEXT K1
4121 gosub 4130
4122 goto 4080
4130 PRINT"Functions available from library-computer:"
4140 PRINT"   GAL = Cumulative galactic record"
4150 PRINT"   STA = Status report"
4160 PRINT"   TOR = Photon torpedo data"
4170 PRINT"   BAS = Starbase nav data"
4180 PRINT"   DIR = Direction/distance calculator"
4190 PRINT"   REG = Galaxy 'region name' map"
4191 PRINT
4192 return
4200 REM setup to change cum gal record to galaxy map
4210 GOSUB 840
4211 H8=0
4212 G5=1
4213 PRINT"                        the galaxy"
4214 GOTO 4290
4220 REM cum galactic record
4230 rem 'INPUT"Do you want a hardcopy? Is the TTY on (Y/N) ":A$
4240 rem 'IF A$="y" THEN POKE 1229,2 POKE 1237,3 NULL 1
4250 GOSUB 840
4260 PRINT
4261 PRINT"            "
4270 PRINT "Computer record of galaxy for quadrant ";Q1;",";Q2
4280 PRINT
4290 PRINT"       1     2     3     4     5     6    7      8"
4300 O1$="     ----- ----- ----- ----- ----- ----- ----- -----"
4310 PRINT O1$
4312 LINE$ = ""
4313 FOR I=1 TO 8
4314 REM PRINT I;"  "
4315 LINE$ = LINE$ + STR$(I)+ "  "
4316 IF H8=0 THEN 4350
4320 FOR J=1 TO 8
4321 REM PRINT"   "
4322 LINE$ = LINE$ + "   "
4323 IF Z(I,J)<>0 THEN 4330
4324 REM PRINT"***"
4325 LINE$ = LINE$ + "***"
4326 GOTO 4340
4330 ZLEN = len(str$(z(i,j)+1000)
4331 REM PRINT mid$(STR$(Z(I,J)+1000),zlen-3,zlen)
4332 LINE$ = LINE$ + mid$(STR$(Z(I,J)+1000),zlen-3,zlen)
4340 NEXT J
4341 GOTO 4370
4350 Z4=I
4351 Z5=1
4352 GOSUB 5040
4353 J0=INT(15-0.5*LEN(G2$))
4354 PRINT G2$
4360 Z5=5
4361 GOSUB 5040
4362 J0=INT(40-0.5*LEN(G2$))
4363 PRINT G2$
4370 PRINT LINE$
4371 LINE$ = ""
4372 PRINT O1$
4373 NEXT I
4374 PRINT
4375 rem 'POKE 1229,0 POKE 1237,1
4380 GOTO 1520
4390 REM status report
4400 GOSUB 840
4401 PRINT"   Status Report"
4402 X$=""
4403 IF K9<=1 THEN 4410
4404 X$="s"
4410 PRINT"Klingon";X$;" left: ";K9
4420 PRINT"Mission must be completed in ";0.1*INT((T0+T9-T)*10);" stardates"
4430 X$="s"
4431 IF B9>=2 THEN 4440
4432 X$=""
4433 IF B9<1 THEN 4460
4440 PRINT"The federation is maintaining ";B9;" starbase";X$;" in the galaxy"
4450 GOTO 3180
4460 PRINT"Your stupidity has left you on your own in"
4470 PRINT"    the galaxy -- you have no starbases left!"
4471 GOTO 3180
4480 REM torpedo, base nav, d/d calculator
4490 GOSUB 840
4491 IF K3<=0 THEN 2550
4500 X$=""
4501 IF K3<=1 THEN 4510
4502 X$="s"
4510 PRINT"From ENTERPRISE to Klingon battle cruiser";X$
4520 H8=0
4521 FOR I=1 TO 3
4522 IF K(I,3)<=0 THEN 4740
4530 W1=K(I,1)
4531 X=K(I,2)
4540 C1=S1
4541 A=S2
4542 GOTO 4590
4550 GOSUB 840
4551 PRINT"Direction/Distance Calculator:"
4560 PRINT"You are at quadrant ";Q1;",";Q2;" sector ";S1;",";S2
4570 PRINT"Please enter "
4571 INPUT" initial coordinates (x,y) ";C1,A
4580 INPUT" Final coordinates (x,y) ";W1,X
4590 X=X-A
4591 A=C1-W1
4592 aa=abs(a)
4593 ax=abs(x)
4594 IF X<0 THEN 4670
4600 IF A<0 THEN 4690
4610 IF X>0 THEN 4630
4620 IF A<>0 THEN 4630
4621 C1=5
4622 GOTO 4640
4630 C1=1
4640 IF AA<=AX THEN 4660
4650 PRINT"Direction1 = "
4651 cc1=(AA-AX+AA)/AA
4652 print c1+cc1
4653 GOTO 4730
4660 PRINT"Direction2 = "
4661 cc1=C1+(AA/AX)
4662 print cc1
4663 GOTO 4730
4670 IF A<=0 THEN 4680
4671 C1=3
4672 GOTO 4700
4680 IF X=0 THEN 4690
4681 C1=5
4682 GOTO 4640
4690 C1=7
4700 IF AA>=AX THEN 4720
4710 PRINT"Direction3 = "
4711 cc1=(AX-AA+AX)/AX
4712 print c1+cc1
4713 GOTO 4730
4720 PRINT"Direction4 = "
4721 CC1=C1+(AX/AA)
4722 PRINT CC1
4730 PRINT"Distance = "
4731 cc1=SQR(x*X+A*A)
4732 print cc1
4733 IF H8=1 THEN 1520
4740 NEXT I
4741 GOTO 1520
4750 GOSUB 840
4751 IF B3=0 THEN 4770
4752 PRINT "From ENTERPRISE to Starbase"
4754 W1=B4
4755 X=B5
4760 GOTO 4540
4770 PRINT"Mr. Spock reports, 'Sensors show no starbases in this"
4780 PRINT"quadrant.'"
4781 GOTO 1520
4790 REM find empty place in quadrant (for things)
4800 R1=INT(RND(1)*7.98+1.01)
4801 R2=INT(RND(1)*7.98+1.01)
4802 A$="   "
4803 Z1=R1
4804 Z2=R2
4805 GOSUB 4990
4807 IF Z3=0 THEN 4800
4810 RETURN
4820 REM insert in string array for quadrant
4830 S8=INT(Z2-0.5)*3+INT(Z1-0.5)*24+1
4840 IF LEN(A$)=3 THEN 4850
4841 PRINT"ERROR"
4842 STOP
4850 IF S8<>1 THEN 4860
4851 Q$=A$+mid$(Q$,3,192)
4852 RETURN
4860 IF S8<>190 THEN 4870
4861 Q$=mid$(Q$,0,189)+A$
4862 RETURN
4870 Q$=mid$(Q$,0,S8-1)+A$+mid$(Q$,s8+2,192)
4871 RETURN
4880 REM prints device name
4890 ON R1 GOTO 4900,4910,4920,4930,4940,4950,4960,4970
4900 G2$="Warp Engines"
4901 RETURN
4910 G2$="Short Range Sensors"
4911 RETURN
4920 G2$="Long Range Sensors"
4921 RETURN
4930 G2$="Phaser Control"
4931 RETURN
4940 G2$="Photon Tubes"
4941 RETURN
4950 G2$="Damage Control"
4951 RETURN
4960 G2$="Shield Control"
4961 RETURN
4970 G2$="Library-Computer"
4971 RETURN
4980 REM string comparison in quadrant array
4990 Z1=INT(Z1+0.5)
4991 Z2=INT(Z2+0.5)
4992 S8=(Z2-1)*3+(Z1-1)*24
4993 Z3=0
5000 IF MID$(Q$,S8,s8+3)=A$ THEN 5010
5001 RETURN
5010 Z3=1
5011 RETURN
5020 REM quadrant name in g2$ from z4,z5 (=q1,q2)
5030 REM call with g5=1 to get region name only
5040 IF Z5<=4 THEN 5140
5041 ON Z4 GOTO 5060,5070,5080,5090,5100,5110,5120,5130
5050 GOTO 5140
5060 G2$="Antares"
5061 GOTO 5230
5070 G2$="Rigel"
5071 GOTO 5230
5080 G2$="Procyon"
5081 GOTO 5230
5090 G2$="Vega"
5091 GOTO 5230
5100 G2$="Canopus"
5101 GOTO 5230
5110 G2$="Altair"
5111 GOTO 5230
5120 G2$="Sagittarius"
5121 GOTO 5230
5130 G2$="Pollux"
5131 GOTO 5230
5140 ON Z4 GOTO 5150,5160,5170,5180,5180,5200,5210,5220
5150 G2$="Sirius"
5151 GOTO 5230
5160 G2$="Deneb"
5161 GOTO 5230
5170 G2$="Capella"
5171 GOTO 5230
5180 G2$="Betelgeuse"
5181 GOTO 5230
5190 G2$="Aldebaran"
5191 GOTO 5230
5200 G2$="Regulus"
5201 GOTO 5230
5210 G2$="Arcturus"
5211 GOTO 5230
5220 G2$="Spica"
5230 IF G5=1 THEN 5240
5231 ON Z5 GOTO 5250,5260,5270,5280,5250,5260,5270,5280
5240 RETURN
5250 G2$=G2$+" i"
5251 RETURN
5260 G2$=G2$+" ii"
5261 RETURN
5270 G2$=G2$+" iii"
5271 RETURN
5280 G2$=G2$+" iv"
5281 RETURN
5290 rem    red alert sound
5291 return
5300 FOR J= 1 TO 4
5310   FOR K=1000 TO 2000 STEP 20
5320 rem      SOUND K,0.01*18.2
5330   NEXT K
5340 NEXT J
5350 RETURN
5360 rem   torpedo sound
5361 return
5370 FOR J = 1500 TO 100 STEP -20
5380 rem    SOUND J,0.01*18.2
5390 rem   SOUND 3600-J,.01*18.2
5400 NEXT J
5410 RETURN
5420 rem    phaser sound
5421 return
5430 FOR J= 1 TO 40
5440 rem  SOUND 800,.01*18.2
5450 rem  SOUND 2500,.008*18.2
5460 NEXT J
5470 RETURN
5480 rem           alarm sound
5481 return
5490 FOR SI = 1 TO 3
5500  FOR J=  800 TO 1500 STEP 20
5510 rem   SOUND J,.01 *18.2
5520  NEXT J
5530  FOR K = 1500 TO 800 STEP -20
5540 rem   SOUND K, .01 *18.2
5550  NEXT K
5560 NEXT SI
5570 RETURN
