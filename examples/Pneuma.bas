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
85 PRINT "in your skull. In fact, you're no longer sure exactly where you are ... you seem to be" 
90 PRINT "suffering from some sort of amnesia ...": PRINT 
95 REM set up environment
100 GOSUB 2700
500 REM setup room descriptions 
510 GOSUB 3000
520 REM setup up interative descriptions
530 GOSUB 5000
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
1035 PRINT
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
1410 R$ = MID$(LOWER$(I$), 5) : REM R$ is the requested object
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
1720 R$ = MID$(LOWER$(I$), 6) : REM R$ is the requested object
1730 GOTO 1420 : REM use the same logic as the get command
2000 REM drop command 
2010 F=-1: R$=""
2020 R$ = MID$(LOWER$(I$), 6) : REM R$ is the requested object
2030 FOR I= 0 TO OC-1
2040 IF OB$(I) = R$ THEN F=I : REM object exists
2050 NEXT I
2060 REM can't find it?
2070 IF F=-1 THEN PRINT "You've never seen that" : PRINT: GOTO 1540
2080 IF OL(F) <> 0 THEN PRINT "You aren't carrying that" : PRINT: GOTO 2110
2090 OL(F) = PL : PRINT "You've dropped ";OB$(F): PRINT: REM add the item to the current room
2110 RETURN
2300 REM examine command 
2310 F=-1 : R$=""
2320 R$ = MID$(LOWER$(I$), 9) : REM R$ is the object to examine
2330 FOR I = 0 TO IC-1
2340 IF IO$(I) = R$ THEN F=I : REM object exists
2350 NEXT I
2360 REM can't find it?
2370 IF F=-1 THEN PRINT "You can't examine that" : PRINT : GOTO 2400
2380 IF IL(F) <> PL THEN PRINT "There isn't one of these here" : PRINT : GOTO 2400
2390 GOSUB 6000 : REM print result of examination
2400 RETURN 
2600 REM quit command 
2610 PRINT "Farewell spacefarer ..."
2620 STOP
2700 REM ========== set up environment =========== 
2705 RC = 18 : REM room count 
2710 DIM LO$ ( RC ) 
2715 INV = 0 : LO$ ( INV ) = "Inventory" 
2720 GAL = 1 : LO$ ( GAL ) = "Galley" 
2725 REC = 2 : LO$ ( REC ) = "Recreation/Dining Room" 
2730 ARM = 3 : LO$ ( ARM ) = "Armoury" 
2735 BDG = 4 : LO$ ( BDG ) = "Bridge" 
2740 SLP = 5 : LO$ ( SLP ) = "Sleeping Quarters" 
2745 MED = 6 : LO$ ( MED ) = "Medical Centre" 
2750 GYM = 7 : LO$ ( GYM ) = "Gymnasium" 
2755 LAC = 8 : LO$ ( LAC ) = "Lower Aft Corridor" 
2760 ENG = 9 : LO$ ( ENG ) = "Engine Room" 
2765 STO = 10 : LO$ ( STO ) = "Storeroom" 
2770 MEN = 11 : LO$ ( MEN ) = "Menagerie" 
2775 LAB = 12 : LO$ ( LAB ) = "Laboratory" 
2780 LFC = 13 : LO$ ( LFC ) = "Lower Forward Corridor" 
2785 POD = 14 : LO$ ( POD ) = "Pod Bay" 
2790 AMC = 15 : LO$ ( AMC ) = "Aft Main Corridor" 
2795 MMC = 16 : LO$ ( MMC ) = "Mid Main Corridor" 
2800 FMC = 17 : LO$ ( FMC ) = "Forward Main Corridor" 
2805 REM encoded room exits, two digits per direction f, a, p, s, u, d 
2810 DIM EX$ ( RC ) 
2815 EX$ ( GAL ) = "020000150008" 
2820 EX$ ( REC ) = "000100160000" 
2825 EX$ ( ARM ) = "000000170000" 
2830 EX$ ( BDG ) = "001700000000"
2835 EX$ ( SLP ) = "000015000000"
2840 EX$ ( MED ) = "070016000000"
2845 EX$ ( GYM ) = "000617000013"
2850 EX$ ( LAC ) = "100000090100"
2855 EX$ ( ENG ) = "000008000000"
2860 EX$ ( STO ) = "120800110000"
2865 EX$ ( MEN ) = "000010000000"
2870 EX$ ( LAB ) = "001000130000"
2875 EX$ ( LFC ) = "140012000700"
2880 EX$ ( POD ) = "001300000000"
2890 EX$ ( AMC ) = "160001050000"
2895 EX$ ( MMC ) = "171502060000"
2900 EX$ ( FMC ) = "041603070000"
2905 OC = 3 : REM object count 
2910 DIM OB$ ( OC ) 
2915 PULSE = 0 : OB$ ( PULSE ) = "pulse rifle" 
2920 SUIT = 1 : OB$ ( SUIT ) = "space suit" 
2925 FOOD = 2 : OB$ ( FOOD ) = "rotting food" 
2930 REM object locations 
2932 REM location 0 = player's inventory 
2934 DIM OL ( OC ) 
2936 OL ( PULSE ) = ARM 
2938 OL ( SUIT ) = POD 
2940 OL ( FOOD ) = GAL 
2942 IC = 4 : REM interactive object count
2944 DIM IO$ (IC)
2946 MEDLOG = 0 : IO$ ( MEDLOG ) = "medical log"
2948 PORTHOLE = 1 : IO$ (PORTHOLE) = "porthole"
2950 CONSOLE = 2 : IO$(CONSOLE) = "console"
2952 ENGINE = 3 :IO$(ENGINE)= "engine control"
2960 REM interative object locations
2962 DIM IL ( IC ) 
2964 IL ( MEDLOG) = MED
2966 IL (PORTHOLE) = POD
2968 IL (CONSOLE) = BDG
2970 IL (ENGINE) = ENG
2980 PL = 5 : REM initial player location
2990 RETURN
3000 REM ========== room descriptions ==========
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
3210 RD$ ( BDG, 4 ) = "There is a console directly in front of you, a pilot gripping the throttle."
3220 RD$ ( BDG, 5 ) = "An aft exit leads back into the main corridor."
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
3440 RD$ ( ENG, 2 ) = "barely being contained. There is an engine control in the far corner, festooned with"
3450 RD$ ( ENG, 3 ) = "switches and engine readouts. A single exit leads out into the corridor."
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
3700 RD$ ( POD, 4 ) = "into space. There is a porthole on the far wall. There is a single exit leading aft."
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
4010 REM ========== print room description ==========
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
4130 REM ========== print help ==========
4140 PRINT "For movement, try [go] a[ft], f[orward], p[ort], s[tarboard], u[p] or d[own]." 
4150 PRINT "For actions, try get, take, drop, examine, look, i[nventory], q[uit]." 
4155 PRINT "To examine, pick up or drop items, refer to them exactly as they are printed."
4160 RETURN
5000 REM ========== interactive item descriptions ==========
5010 DIM ID$(IC, 20)
5020 ID$( MEDLOG, 1 ) = "The last few entries of the medical log are still visible on the screen:"
5030 ID$( MEDLOG, 2 ) = " "
5040 ID$( MEDLOG, 3 ) = "'2142-6-13: Three days since chimpanzee Nova was innoculated with agent #53."
5050 ID$( MEDLOG, 4 ) = " However, subject Nova showing no signs of adaptation to planetary destination"
5060 ID$( MEDLOG, 5 ) = " atmosphere. In fact, she appears listless, though punctuated with periods of"
5070 ID$( MEDLOG, 6 ) = " extreme agression."
5080 ID$( MEDLOG, 7 ) = " "
5090 ID$( MEDLOG, 8 ) = " 2142-6-14: This morning, Dr Pearson was bitten by Nova. Very quickly he exhibited"
5100 ID$( MEDLOG, 9 ) = " signs of a high fever and is now resting in his quarters."
5110 ID$( MEDLOG, 10) = " "
5120 ID$( MEDLOG, 11) = " 2142-6-15: After a brief period of catatonia, Pearson got up on his own, returned"
5130 ID$( MEDLOG, 12) = " to the medical bay and began to compulsively prepare more agent #53 samples. He"
5140 ID$( MEDLOG, 13) = " is otherwise uncommunicative."
5150 ID$( MEDLOG, 14) = " "
5160 ID$( MEDLOG, 15) = " 2142-6-17: Pearson's compulsive behaviour continues unabated. We have a hypothesis"
5170 ID$( MEDLOG, 16) = " for what the virus, which we have now designated HO-1, does to the brain. However,"
5180 ID$( MEDLOG, 17) = " we are struggling to isolate Pearson and may have to seal the medical bay."
5190 ID$( MEDLOG, 18) = " "
5200 ID$ (MEDLOG, 19) = " 2142-6-17: Hollow (HO-1) confirmed as airborne, and other cases appearing around the ship."
5210 ID$ (MEDLOG, 20) = " Shipwide lockdown declared but crew cohesion and discipline already breaking down.'"
5220 ID$ (PORTHOLE, 1 ) = "Looking through the porthole, you seen a spacesuit clad figure floating outside."
5230 ID$ (PORTHOLE, 2 ) = "Although he is tethered to an anchor point on the ship's hull, he is otherwise floating"
5240 ID$ (PORTHOLE, 3 ) = "freely, his arms and legs splayed out to his sides."
5250 ID$ (PORTHOLE, 4 ) = " "
5260 ID$ (PORTHOLE, 5 ) = "Peering at the figure more closely, as he slowly rotates, a light from the ship"
5270 ID$ (PORTHOLE, 6 ) = "briefly illuminates his face. He's clearly dead, his oxygen ran out some time ago."
5280 ID$ (PORTHOLE, 7 ) = "His expression is frozen in a rictus of pain. He was screaming almost until the end ..."
5290 ID$ (PORTHOLE, 8 ) = ""
5300 ID$ (PORTHOLE, 9 ) = ""
5310 ID$ (PORTHOLE, 10 ) = ""
5320 ID$ (PORTHOLE, 11 ) = ""
5330 ID$ (PORTHOLE, 12 ) = ""
5340 ID$ (PORTHOLE, 13 ) = ""
5342 ID$ (PORTHOLE, 14 ) = ""
5344 ID$ (PORTHOLE, 15 ) = ""
5346 ID$ (PORTHOLE, 16 ) = ""
5348 ID$ (PORTHOLE, 17 ) = ""
5350 ID$ (PORTHOLE, 18 ) = ""
5352 ID$ (PORTHOLE, 19 ) = ""
5354 ID$ (PORTHOLE, 20 ) = ""
5356 ID$ (CONSOLE, 1 ) = "The console shows the state of the ship's engines. They are in overdrive. The pilot"
5358 ID$ (CONSOLE, 2 ) = "appears to have the throttle jammed wide open with his right arm. The muscles in his"
5360 ID$ (CONSOLE, 3 ) = "forearm are taught, there's no way he's going to release the throttle. He left hand"
5362 ID$ (CONSOLE, 4 ) = "works its way around the console switches. After a few moments you realise that he is"
5364 ID$ (CONSOLE, 5 ) = "executing the same sequence of switches over and over again."
5366 ID$ (CONSOLE, 6 ) = " "
5368 ID$ (CONSOLE, 7 ) = "You speak to the pilot but he is unresponsive. Mentally he is somewhere else. He is"
5370 ID$ (CONSOLE, 8 ) = "mumbling to himself but you cannot make out the words, although he appears to be"
5372 ID$ (CONSOLE, 9 ) = "reciting some sort of launch checklist."
5374 ID$ (CONSOLE, 10 ) = " "
5376 ID$ (CONSOLE, 11 ) = "One thing is certain, the ship is out of control, careering through space at maximum"
5378 ID$ (CONSOLE, 12 ) = "speed. Rescue will be impossible unless you can find a way to shut down the engines."
5380 ID$ (CONSOLE, 13 ) = ""
5382 ID$ (CONSOLE, 14 ) = ""
5384 ID$ (CONSOLE, 15 ) = ""
5386 ID$ (CONSOLE, 16 ) = ""
5388 ID$ (CONSOLE, 17 ) = ""
5390 ID$ (CONSOLE, 18 ) = ""
5392 ID$ (CONSOLE, 19 ) = ""
5394 ID$ (CONSOLE, 20 ) = ""
5296 ID$ (ENGINE, 1 ) = "The control panel is grubby, smeared with oil and grime. This is clearly"
5298 ID$ (ENGINE, 2 ) = "the engineering heart of the ship. Most of the readouts mean nothing to you,"
5300 ID$ (ENGINE, 3 ) = "whatever your duties were on this ship, you were clearly not a warp engineer."
5302 ID$ (ENGINE, 4 ) = " "
5304 ID$ (ENGINE, 5 ) = "Many of the lights on the front panel are flashing red. Not all is well with"
5306 ID$ (ENGINE, 6 ) = "the Pneuma. Even to your untrained eye, it's obvious that the ship's engines appear to"
5308 ID$ (ENGINE, 7 ) = "be on the point of burnout, having been run at full capacity for many hours."
5310 ID$ (ENGINE, 8 ) = " "
5312 ID$ (ENGINE, 9 ) = "To the top left of the panel, a screen reads:"
5314 ID$ (ENGINE, 11 ) = " "
5316 ID$ (ENGINE, 12 ) = "'WARNING: CORE BREACH IMMINENT'"
5318 ID$ (ENGINE, 13 ) = " "
5320 ID$ (ENGINE, 14 ) = "Just below the screen is a large red button, shielded by a cover that can be"
5322 ID$ (ENGINE, 15 ) = "flipped aside."
5324 ID$ (ENGINE, 16 ) = ""
5326 ID$ (ENGINE, 17 ) = ""
5328 ID$ (ENGINE, 18 ) = ""
5330 ID$ (ENGINE, 19 ) = ""
5332 ID$ (ENGINE, 20 ) = ""
5990 RETURN
6000 REM ========== print interative object description ==========
6010 FOR LINE = 1 TO 20
6020 IF ID$(F, LINE) <> "" THEN PRINT ID$(F, LINE)
6030 NEXT LINE
6035 PRINT
6040 RETURN
