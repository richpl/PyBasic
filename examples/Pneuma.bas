10 REM Pneuma - A space adventure 
20 REM ========== backstory and instructions ========== 
30 PRINT "********************************" : PRINT
35 PRINT "   Pneuma - A space adventure" : PRINT
40 PRINT "********************************": PRINT 
45 PRINT "To get instructions, type 'help'" 
50 PRINT 
60 PRINT "You wake up in your bunk, in the sleeping quarters of the starship Pneuma. You can't" 
65 PRINT "remember much. You went to bed feeling sick and after a feverish few hours tossing and" 
70 PRINT "turning, feeling like you were burning up, you eventually fell asleep." : PRINT 
75 PRINT "Now, your sheets and night clothes are damp with sweat, and you have a raging thirst." 
80 PRINT "You have a sore throat and the mother of all headaches, like your brain has been boiling" 
85 PRINT "in your skull." : PRINT 
95 REM ========== set up environment =========== 
100 RC = 18 : REM room count 
110 DIM LO$ ( RC ) 
120 INV = 0 : LO$ ( INV ) = "Inventory" 
130 GAL = 1 : LO$ ( GAL ) = "Galley" 
140 REC = 2 : LO$ ( REC ) = "Recreation/Dining Room" 
150 ARM = 3 : LO$ ( ARM ) = "Armoury" 
160 BDG = 4 : LO$ ( BDG ) = "Bridge" 
170 SLP = 5 : LO$ ( SLP ) = "Sleeping Quarters" 
180 MED = 6 : LO$ ( MED ) = "Medical Centre" 
190 GYM = 7 : LO$ ( GYM ) = "Gymnasium" 
200 LAC = 8 : LO$ ( LAC ) = "Lower Aft Corridor" 
210 ENG = 9 : LO$ ( ENG ) = "Engine Room" 
220 STO = 10 : LO$ ( STO ) = "Storeroom" 
230 MEN = 11 : LO$ ( MEN ) = "Menagerie" 
240 LAB = 12 : LO$ ( LAB ) = "Laboratory" 
250 LFC = 13 : LO$ ( LFC ) = "Lower Forward Corridor" 
260 POD = 14 : LO$ ( POD ) = "Pod Bay" 
270 AMC = 15 : LO$ ( AMC ) = "Aft Main Corridor" 
271 MMC = 16 : LO$ ( MMC ) = "Mid Main Corridor" 
272 FMC = 17 : LO$ ( FMC ) = "Forward Main Corridor" 
275 REM encoded room exits, two digits per direction f, a, p, s, u, d 
280 DIM EX$ ( RC ) 
281 EX$ ( GAL ) = "020000150008" 
282 EX$ ( REC ) = "000100160000" 
283 EX$ ( ARM ) = "000000170000" 
284 EX$ ( BDG ) = "001700000000"
285 EX$ ( SLP ) = "000015000000"
286 EX$ ( MED ) = "070016000000"
287 EX$ ( GYM ) = "000617000013"
288 EX$ ( LAC ) = "100000090100"
289 EX$ ( ENG ) = "000008000000"
290 EX$ ( STO ) = "120800110000"
291 EX$ ( MEN ) = "000010000000"
292 EX$ ( LAB ) = "001000130000"
293 EX$ ( LFC ) = "140012000700"
294 EX$ ( POD ) = "001300000000"
295 EX$ ( AMC ) = "160001050000"
296 EX$ ( MMC ) = "171502060000"
297 EX$ ( FMC ) = "041603070000"
300 OC = 3 : REM object count 
310 DIM OB$ ( OC ) 
320 PULSE = 0 : OB$ ( PULSE ) = "pulse rifle" 
330 SUIT = 1 : OB$ ( SUIT ) = "space suit" 
340 FOOD = 2 : OB$ ( FOOD ) = "rotting food" 
400 REM object locations 
410 REM location 0 = player's inventory 
420 DIM OL ( OC ) 
430 OL ( PULSE ) = ARM 
440 OL ( SUIT ) = POD 
450 OL ( FOOD ) = GAL 
500 REM setup room descriptions 
510 GOSUB 3000
650 PL = 5 : REM initial player location 
700 REM ========== main loop ==========
701 REM show room details 
703 PRINT "You are in the " ; LO$ ( PL ) : PRINT 
705 GOSUB 4010 : REM print room description
710 INPUT "What now? " ; I$ 
715 PRINT 
716 MOVE = 1 
720 IF LEFT$ ( LOWER$ ( I$ ) , 4 ) = "get " THEN MOVE = 0 : GOSUB 1400 
730 IF LEFT$ ( LOWER$ ( I$ ) , 5 ) = "take " THEN MOVE = 0 : GOSUB 1700 
740 IF LEFT$ ( LOWER$ ( I$ ) , 5 ) = "drop " THEN MOVE = 0 : GOSUB 2000 
750 IF LEFT$ ( LOWER$ ( I$ ) , 8 ) = "examine " THEN MOVE = 0 : GOSUB 2300 
760 IF LEFT$ ( LOWER$ ( I$ ) , 4 ) = "look" THEN MOVE = 0 : GOSUB 4010 
765 IF LEFT$ ( LOWER$ ( I$ ) , 4 ) = "help" THEN MOVE = 0 : GOSUB 4130
770 IF LOWER$ ( I$ ) = "i" OR LOWER$ ( I$ ) = "inventory" THEN MOVE = 0 : GOSUB 1000 
780 IF LEFT$ ( LOWER$ ( I$ ) , 1 ) = "q" THEN GOSUB 2600 
785 IF LEFT$ ( LOWER$ ( I$ ) , 3 ) = "go " THEN GOSUB 1100 
790 IF LOWER$ ( I$ ) = "f" OR LOWER$ ( I$ ) = "forward" THEN GOSUB 1200 
800 IF LOWER$ ( I$ ) = "a" OR LOWER$ ( I$ ) = "aft" THEN GOSUB 1200 
810 IF LOWER$ ( I$ ) = "p" OR LOWER$ ( I$ ) = "port" THEN GOSUB 1200 
820 IF LOWER$ ( I$ ) = "s" OR LOWER$ ( I$ ) = "starboard" THEN GOSUB 1200 
830 IF LOWER$ ( I$ ) = "u" OR LOWER$ ( I$ ) = "up" THEN GOSUB 1200 
840 IF LOWER$ ( I$ ) = "d" OR LOWER$ ( I$ ) = "down" THEN GOSUB 1200 
895 IF MOVE = 1 THEN GOTO 700 ELSE GOTO 710 
900 STOP 
995 REM ========== actions ========== 
1000 REM list the player's inventory 
1005 PRINT "You have the following items:" : PRINT 
1010 FOR I = 0 TO OC - 1 
1020 IF OL ( I ) = 0 THEN PRINT OB$ ( I ) 
1030 NEXT I 
1040 RETURN 
1100 REM fully written out move (e.g. 'go aft') 
1110 D$ = MID$ ( LOWER$(I$) , 4 , 1 ) 
1120 GOSUB 1300 
1130 RETURN 
1200 REM abbreviated move (e.g. 'a' or 'aft') 
1210 D$ = LOWER$( I$ ) 
1220 GOSUB 1300 
1230 RETURN 
1300 REM go to the player's new location (PL) 
1310 IF D$ = "f" THEN NPL = VAL ( MID$ ( EX$ ( PL ) , 1 , 2 ) )
1320 IF D$ = "a" THEN NPL = VAL ( MID$ ( EX$ ( PL ) , 3 , 2 ) )
1330 IF D$ = "p" THEN NPL = VAL ( MID$ ( EX$ ( PL ) , 5 , 2 ) )
1340 IF D$ = "s" THEN NPL = VAL ( MID$ ( EX$ ( PL ) , 7 , 2 ) )
1345 IF D$ = "u" THEN NPL = VAL ( MID$ ( EX$ ( PL ) , 9 , 2 ) )
1350 IF D$ = "d" THEN NPL = VAL ( MID$ ( EX$ ( PL ) , 11 , 2 ) )
1355 IF NPL = 0 THEN PRINT "You can't go that way." : PRINT ELSE PL = NPL
1360 RETURN 
1400 REM get command 
1405 F=-1: R$=""
1410 R$ = MID$(I$, 5) : REM R$ is the requested object
1420 REM get the object ID
1430 FOR I= 0 TO OC-1
1440 IF OB$(I) = R$ THEN F=I : REM object exists
1450 NEXT I
1460 REM can't find the item?
1470 IF F=-1 THEN PRINT "Can't see that item here" : PRINT : GOTO 1540
1480 IF OL(F) <> PL THEN PRINT "That item doesn't appear to be around here" : PRINT : GOTO 1540
1490 IF OL(F)=0 THEN PRINT "You already have that item" : PRINT: GOTO 1540 
1520 OL(F)=0 : REM add the item to the inventory
1530 PRINT "You've picked up ";OB$(F) : PRINT
1540 RETURN
1700 REM take command 
1710 F=-1: R$=""
1720 R$ = MID$(I$, 6) : REM R$ is the requested object
1730 GOTO 1420 : REM use the same logic as the get command
2000 REM drop command 
2010 F=-1: R$=""
2020 R$ = MID$(I$, 6) : REM R$ is the requested object
2030 FOR I= 0 TO OC-1
2040 IF OB$(I) = R$ THEN F=I : REM object exists
2050 NEXT I
2060 REM can't find it?
2070 IF F=-1 THEN PRINT "You've never seen that" : PRINT: GOTO 1540
2080 IF OL(F) <> 0 THEN PRINT "You aren't carrying that" : PRINT: GOTO 2110
2090 OL(F) = PL : PRINT "You've dropped ";OB$(F): PRINT: REM add the item to the current room
2110 RETURN
2300 REM examine command 
2600 REM quit command 
2610 PRINT "Farewell spacefarer ..."
2620 STOP
3000 REM room descriptions
3010 DIM RD$ ( RC, 5 ) 
3020 RD$ ( INV, 1 ) = "" 
3021 RD$ ( INV, 2 ) = ""
3022 RD$ ( INV, 3 ) = ""
3023 RD$ ( INV, 4 ) = ""
3024 RD$ ( INV, 5 ) = ""
3030 RD$ ( GAL, 1 ) = "The galley contains gleaming, stainless steel cupboards along the aft wall. A food"
3040 RD$ ( GAL, 2 ) = "preparation surface is on the port wall, currently covered in rotting food. A chef"
3050 RD$ ( GAL, 3 ) = "stands at the work surface, methodically chopping food even though everything has"
3060 RD$ ( GAL, 4 ) = "already been thoroughly diced. There are doors in the starboard and forward walls and"
3070 RD$ ( GAL, 5 ) = "a stairway leads downwards in the far corner." 
3080 RD$ ( REC, 1 ) = "Space is clearly at a premium in this ship. The room doubles as both a dining and"
3090 RD$ ( REC, 2 ) = "recreation area. Long tables for dining are located on the port side, while couches"
3100 RD$ ( REC, 3 ) = "and low tables are scattered around the remaining space. There are doors in the aft"
3110 RD$ ( REC, 4 ) = "and starboard walls."
3120 RD$ ( REC, 5 ) = ""
3130 RD$ ( ARM, 1 ) = "Locked cabinets line the starboard wall. Each cabinet has a prominently displayed"
3140 RD$ ( ARM, 2 ) = "notice on its door reading 'Weapons to be removed only when authorised by the Chief"
3150 RD$ ( ARM, 3 ) = "Security Officer'. However, the door to one cupboard has been prized open, it is"
3160 RD$ ( ARM, 4 ) = "warped and bent. This cupboard appears to be empty. The only exit is a starboard door."
3170 RD$ ( ARM, 5 ) = "" 
3180 RD$ ( BDG, 1 ) = "The bridge is the heart of the ship. A vast array of glowing screens and switches fill"
3190 RD$ ( BDG, 2 ) = "every surface. On the screens are complex graphics providing detailed information about"
3200 RD$ ( BDG, 3 ) = "the status of every system on the ship. Many of them are showing red warning symbols."
3210 RD$ ( BDG, 4 ) = "An aft exit leads back into the main corridor."
3220 RD$ ( BDG, 5 ) = ""
3230 RD$ ( SLP, 1 ) = "The sleeping quarters is filled with bunks, one up, one down. Several of the bunks"
3240 RD$ ( SLP, 2 ) = "contain sleeping forms, some gently shoring. The room has a partition to separate"
3250 RD$ ( SLP, 3 ) = "male and female bunks. Against the forward wall are two corresponding sets of heads."
3260 RD$ ( SLP, 4 ) = "The room is messy, with discarded personal items everywhere ... on bunks, on the floor."
3270 RD$ ( SLP, 5 ) = "There is a door in the port wall."
3280 RD$ ( MED, 1 ) = "The medical centre looks relatively normal, but there is evidence of discarded items"
3290 RD$ ( MED, 2 ) = "lying around the room. Blood filled syringes are scattered on a workbench, as well as"
3300 RD$ ( MED, 3 ) = "some bloodied bandanges. The words 'I'm losing myself' are scrawled messily in blood on"
3310 RD$ ( MED, 4 ) = "one wall. In the corner you can see a medical scanner and next to it, a terminal. On the"
3320 RD$ ( MED, 5 ) = "terminal screen are the words 'Medical Log'. Exits lead port and forward."
3330 RD$ ( GYM, 1 ) = "The gymnasium is full of exercise equipment. A woman is running furiously on a treadmill."
3340 RD$ ( GYM, 2 ) = "She looks exhausted and emaciated, but she keeps running at top speed, almost at a sprint."
3350 RD$ ( GYM, 3 ) = "Her eyes remain fixed on the treadmill console. There are aft and port exists, as well as"
3360 RD$ ( GYM, 4 ) = "a stairwell leading to the lower deck in the far corner."
3370 RD$ ( GYM, 5 ) = ""
3380 RD$ ( LAC, 1 ) = "This is a featureless, utilitarian corridor. A stairwell leads upwards. There are also"
3390 RD$ ( LAC, 2 ) = "exits leading starboard and forward."
3400 RD$ ( LAC, 3 ) = ""
3410 RD$ ( LAC, 4 ) = ""
3420 RD$ ( LAC, 5 ) = ""
3430 RD$ ( ENG, 1 ) = "The engine room is characterised by a continual rumble, as though incredible energies are"
3440 RD$ ( ENG, 2 ) = "barely being contained. There is a console in the far corner, festooned with controls and"
3450 RD$ ( ENG, 3 ) = "engine readouts. A single exit leads out into the corridor."
3460 RD$ ( ENG, 4 ) = ""
3470 RD$ ( ENG, 5 ) = ""
3480 RD$ ( STO, 1 ) = "The storeroom is full of crates, most neatly stacked, but with some scattered across the"
3490 RD$ ( STO, 2 ) = "floor, their contents spilling out. Along the port wall is a door marked 'Test specimens'."
3500 RD$ ( STO, 3 ) = "From behind the door, strange animal noises are audible ... snuffling sounds and the"
3510 RD$ ( STO, 4 ) = "occasional primate shriek. A dead man wearing a scuffed and torn lab coat is lying face down"
3520 RD$ ( STO, 5 ) = "in front of the specimen door. Two other exists lead forward and aft."
3530 RD$ ( MEN, 1 ) = "The room is a hellhole. Cages stand open, while various animals roam about: chimpanzees,"
3540 RD$ ( MEN, 2 ) = "dogs, and rats. Some of the rats are dead, having been savaged and eviscerated. The floor"
3550 RD$ ( MEN, 3 ) = "and walls are smeared with animal faeces, and the smell is almost overpowering. A single"
3555 RD$ ( MEN, 4 ) = "port door leads back into the storeroom."
3560 RD$ ( MEN, 5 ) = ""  
3570 RD$ ( LAB, 1 ) = "The laboratory is full of scientific equipment, chemical glassware, electronic analysers,"
3580 RD$ ( LAB, 2 ) = "fume cupboards, and two couches. The place looks disorded, like the rest of the ship, the"
3590 RD$ ( LAB, 3 ) = "result of frenetic activity. A number of experiments seem to be in progress, with logbooks"
3600 RD$ ( LAB, 4 ) = "and tablets covered in dense calculations and notes. Whatever has been happening in here,"
3610 RD$ ( LAB, 5 ) = "it has been done with extreme urgency. Exits lead aft and to starboard."
3620 RD$ ( LFC, 1 ) = "This is a featureless, utilitarian corridor. A stairwell leads upwards. There are also"
3630 RD$ ( LFC, 2 ) = "doors leading to port and forward."
3640 RD$ ( LFC, 3 ) = ""
3650 RD$ ( LFC, 4 ) = ""
3660 RD$ ( LFC, 5 ) = ""
3670 RD$ ( POD, 1 ) = "You are in a large room, with a row of spacesuits hanging on the port wall. At the forward"
3680 RD$ ( POD, 2 ) = "end of the room is a small, two seater vehicle, capable of operating in space outside the"
3690 RD$ ( POD, 3 ) = "main ship for limited periods. In front of the small ship is the pod bay door, leading out"
3700 RD$ ( POD, 4 ) = "into space. There is a single exit leading aft."
3710 RD$ ( POD, 5 ) = ""
3720 RD$ ( AMC, 1 ) = "The main corridor stretches away from you towards the front of the ship. It is featureless"
3730 RD$ ( AMC, 2 ) = "and utilitarian. The lighting is dim. You can see doors either side of you, to port and"
3740 RD$ ( AMC, 3 ) = "to starboard."
3750 RD$ ( AMC, 4 ) = ""
3760 RD$ ( AMC, 5 ) = ""
3770 RD$ ( MMC, 1 ) = "The main corridor stretches away from you both forward and aft. It is featureless"
3780 RD$ ( MMC, 2 ) = "and utilitarian. The lighting is dim. You can see doors either side of you, to port and"
3790 RD$ ( MMC, 3 ) = "to starboard."
3800 RD$ ( MMC, 4 ) = ""
3810 RD$ ( MMC, 5 ) = ""
3820 RD$ ( FMC, 1 ) = "The main corridor stretches away from you towards the rear of the ship. It is featureless"
3830 RD$ ( FMC, 2 ) = "and utilitarian. The lighting is dim. You can see doors either side of you, to port and"
3840 RD$ ( FMC, 3 ) = "to starboard, as well as a third door leading forward."
3850 RD$ ( FMC, 4 ) = ""
3860 RD$ ( FMC, 5 ) = ""
4000 RETURN
4010 REM print room description
4020 FOR LINE = 1 TO 5
4030 IF RD$(PL, LINE) <> "" THEN PRINT RD$(PL, LINE)
4040 NEXT LINE
4055 GOSUB 4070
4060 RETURN
4070 REM print objects
4080 FOR I = 0 TO OC-1
4090 IF OL ( I ) = PL THEN PRINT : PRINT "You can see: ";OB$ ( I )
4100 NEXT I 
4110 PRINT
4120 RETURN 
4130 REM print help
4140 PRINT "For movement, try [go] a[ft], f[orward], p[ort], s[tarboard], u[p] or d[own]" 
4150 PRINT "For actions, try get, take, drop, examine, look, i[nventory], q[uit]" 
4160 RETURN
