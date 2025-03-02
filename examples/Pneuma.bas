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
540 REM setup dialogue
550 GOSUB 7000
700 REM ========== main loop ==========
701 IF WPL <> 99 THEN GOSUB 8400 : REM wraith-hound movement
702 REM show room details 
703 PRINT "You are in the " ; LO$ ( PL ) : PRINT 
705 GOSUB 4010 : REM print room description
706 GOSUB 8000 : REM tracker info if carried
707 IF WPL <> 99 THEN GOSUB 8200 : REM wraith-hound proximity check
709 IF WPL = PL THEN GOSUB 11000 : REM fight wraith-hound 
710 INPUT "What now? " ; I$ 
715 PRINT 
716 MOVE = 1 
720 IF LEFT$ ( LOWER$ ( I$ ) , 4 ) = "get " THEN MOVE = 0 : GOSUB 1400 
730 IF LEFT$ ( LOWER$ ( I$ ) , 5 ) = "take " THEN MOVE = 0 : GOSUB 1700 
740 IF LEFT$ ( LOWER$ ( I$ ) , 5 ) = "drop " THEN MOVE = 0 : GOSUB 2000 
750 IF LEFT$ ( LOWER$ ( I$ ) , 8 ) = "examine " THEN MOVE = 0 : GOSUB 2300 
760 IF LEFT$ ( LOWER$ ( I$ ) , 4 ) = "look" THEN MOVE = 0 : GOSUB 4010 
765 IF LEFT$ ( LOWER$ ( I$ ) , 4 ) = "help" THEN MOVE = 0 : GOSUB 4130
767 IF LEFT$ ( LOWER$ ( I$ ) , 4 ) = "use " THEN MOVE = 0 : GOSUB 9000
770 IF LOWER$ ( I$ ) = "i" OR LOWER$ ( I$ ) = "inventory" THEN MOVE = 0 : GOSUB 1000 
775 IF LEFT$ ( LOWER$ ( I$ ) , 8 ) = "talk to " THEN MOVE = 0 : GOSUB 2630
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
1470 IF F=-1 THEN PRINT "You can't take that." : PRINT : RETURN
1480 IF OL(F) <> PL THEN PRINT "That item doesn't appear to be around here." : PRINT : RETURN
1490 IF OL(F)=0 THEN PRINT "You already have that item." : PRINT: RETURN 
1520 OL(F)=0 : REM add the item to the inventory
1530 PRINT "You've picked up ";OB$(F); "." : PRINT
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
2070 IF F=-1 THEN PRINT "You don't have that." : PRINT: RETURN
2080 IF OL(F) <> 0 THEN PRINT "You aren't carrying that." : PRINT: RETURN
2090 OL(F) = PL : PRINT "You've dropped ";OB$(F); ".": PRINT: REM add the item to the current room
2095 IF F = SUIT THEN SUIT_WORN = 0
2110 RETURN
2300 REM examine command 
2310 F=-1 : R$=""
2320 R$ = MID$(LOWER$(I$), 9) : REM R$ is the object to examine
2330 FOR I = 0 TO IC-1
2340 IF IO$(I) = R$ THEN F=I : REM object exists
2350 NEXT I
2360 REM can't find it?
2370 IF F=-1 THEN PRINT "You can't examine that." : PRINT : RETURN
2380 IF IL(F) <> PL THEN PRINT "There isn't one of these here." : PRINT : RETURN
2390 GOSUB 6000 : REM print result of examination
2400 RETURN 
2600 REM quit command 
2610 PRINT "Farewell spacefarer ..."
2620 STOP
2630 REM talk to command
2635 F=-1 : R$ = ""
2640 R$ = MID$(LOWER$(I$), 9) : REM R$ is the person to talk to
2645 FOR I = 0 TO PC-1
2650 IF P$(I) = R$ THEN F=I : REM person exists
2655 NEXT I
2660 REM can't find them?
2665 IF F=-1 THEN PRINT "You've not met them." : PRINT : RETURN
2670 IF PLOC(F) <> PL THEN PRINT "They aren't here." : PRINT : RETURN
2675 GOSUB 7500 : REM print dialogue
2695 RETURN
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
2905 OC = 5 : REM object count 
2910 DIM OB$ ( OC ) 
2915 PULSE = 0 : OB$ ( PULSE ) = "pulse rifle" 
2920 SUIT = 1 : OB$ ( SUIT ) = "space suit" 
2922 KNIFE = 2 : OB$ ( KNIFE ) = "knife" 
2924 TRACKER = 3 : OB$ ( TRACKER ) = "tracker"
2926 SYRINGE = 4 : OB$ ( SYRINGE ) = "syringe"
2930 REM object locations 
2932 REM location 0 = player's inventory 
2934 DIM OL ( OC )  
2936 OL ( PULSE ) = ARM 
2937 OL ( SUIT ) = POD 
2939 OL ( KNIFE ) = GAL 
2940 OL ( TRACKER ) = GYM
2941 OL ( SYRINGE ) = MED
2942 IC = 5 : REM interactive object count
2944 DIM IO$ (IC)
2946 MEDLOG = 0 : IO$ ( MEDLOG ) = "medical log"
2948 PORTHOLE = 1 : IO$ (PORTHOLE) = "porthole"
2950 CONSOLE = 2 : IO$(CONSOLE) = "console"
2952 ENGINE = 3 : IO$(ENGINE)= "engine control"
2954 TERMINAL = 4 : IO$(TERMINAL) = "library terminal"
2960 REM interative object locations
2962 DIM IL ( IC ) 
2964 IL ( MEDLOG) = MED
2966 IL (PORTHOLE) = POD
2968 IL (CONSOLE) = BDG
2970 IL (ENGINE) = ENG
2971 IL (TERMINAL) = REC
2972 PC = 3 : REM person count
2974 DIM P$ ( PC )
2976 CHEF = 0 : P$ ( CHEF ) = "chef"
2978 RUNNER = 1 : P$ ( RUNNER ) = "runner"
2980 PILOT = 2 : P$ ( PILOT ) = "pilot"
2981 REM person locations
2983 DIM PLOC ( PC )
2985 PLOC ( CHEF ) = GAL
2987 PLOC ( RUNNER ) = GYM
2989 PLOC ( PILOT ) = BDG
2990 PL = SLP : REM initial player location
2992 WPL = MEN : REM wraith-hound initial location
2994 SUIT_WORN = 0 : REM is space suit worn?
2995 SHUTDOWN = 0 : REM are engines shut down?
2999 RETURN
3000 REM ========== room descriptions ==========
3010 DIM RD$ ( RC, 5 )
3015 REM inventory
3020 DATA "", "", "", "", "" 
3025 REM galley
3030 DATA "The galley contains gleaming, stainless steel cupboards along the aft wall. A food"
3040 DATA "preparation surface is on the port wall, currently covered in rotting food. A chef"
3050 DATA "stands at the work surface, methodically chopping food even though everything has"
3060 DATA "already been thoroughly diced. There are doors in the starboard and forward walls and"
3070 DATA "a stairway leads downwards in the far corner." 
3075 REM recreation room
3080 DATA "Space is clearly at a premium in this ship. The room doubles as both a dining and"
3090 DATA "recreation area. Long tables for dining are located on the port side, while couches"
3100 DATA "and low tables are scattered around the remaining space. A library terminal is switched"
3105 DATA "on in the corner. There are doors in the aft and starboard walls.", ""
3120 REM armoury
3130 DATA "Locked cabinets line the starboard wall. Each cabinet has a prominently displayed"
3140 DATA "notice on its door reading 'Weapons to be removed only when authorised by the Chief"
3150 DATA "Security Officer'. However, the door to one cupboard has been prized open, it is"
3160 DATA "warped and bent. This cupboard appears to be empty. The only exit is a starboard door.", ""
3170 REM bridge
3180 DATA "The bridge is the heart of the ship. A vast array of glowing screens and switches fill"
3190 DATA "every surface. On the screens are complex graphics providing detailed information about"
3200 DATA "the status of every system on the ship. Many of them are showing red warning symbols."
3210 DATA "There is a console directly in front of you, a pilot gripping the throttle."
3220 DATA "An aft exit leads back into the main corridor."
3225 REM sleeping quarters
3230 DATA "The sleeping quarters is filled with bunks, one up, one down. Several of the bunks"
3240 DATA "contain sleeping forms, some gently shoring. The room has a partition to separate"
3250 DATA "male and female bunks. Against the forward wall are two corresponding sets of heads."
3260 DATA "The room is messy, with discarded personal items everywhere ... on bunks, on the floor."
3270 DATA "There is a door in the port wall."
3275 REM medical centre
3280 DATA "The medical centre looks relatively normal, but there is evidence of discarded items"
3290 DATA "lying around the room. Blood filled syringes are scattered on a workbench, as well as"
3300 DATA "some bloodied bandanges. The words 'I'm losing myself' are scrawled messily in blood on"
3310 DATA "one wall. In the corner you can see a terminal. On the terminal screen is a portion"
3320 DATA "of the medical log. Exits lead port and forward."
3325 REM gymnasium
3330 DATA "The gymnasium is full of exercise equipment. A female runner is sprinting furiously on a"
3340 DATA "treadmill. She looks exhausted and emaciated, but she keeps running at top speed, almost at"
3350 DATA "a sprint. Her eyes remain fixed on the treadmill console. There are aft and port exits,"
3360 DATA "as well as a stairwell leading to the lower deck in the far corner.", ""
3370 REM lower aft corridor
3380 DATA "This is a featureless, utilitarian corridor. A stairwell leads upwards. There are also"
3390 DATA "exits leading starboard and forward.", "", "", ""
3400 REM engine room
3430 DATA "The engine room is characterised by a continual rumble, as though incredible energies are"
3440 DATA "barely being contained. There is an engine control in the far corner, festooned with"
3450 DATA "switches and engine readouts. A single exit leads out into the corridor.", "", ""
3460 REM storeroom
3480 DATA  "The storeroom is full of crates, most neatly stacked, but with some scattered across the"
3490 DATA  "floor, their contents spilling out. Along the port wall is a door marked 'Test specimens'."
3500 DATA  "From behind the door, strange animal noises are audible ... snuffling sounds and the"
3510 DATA  "occasional primate shriek. A dead man wearing a scuffed and torn lab coat is lying face down"
3520 DATA  "in front of the specimen door. Two other exits lead forward and aft."
3525 REM menagerie
3530 DATA "The room is a hellhole. Cages stand open, while various animals roam about: chimpanzees,"
3540 DATA "dogs, and rats. Some of the rats are dead, having been savaged and eviscerated. The floor"
3550 DATA "and walls are smeared with animal faeces, and the smell is almost overpowering. A capsule,"
3552 DATA "its door ajar, is marked 'BIOWEAPON CONTAINMENT'. The capsule is empty."
3555 DATA "A single door to port leads back into the storeroom."
3560 REM laboratory 
3570 DATA "The laboratory is full of scientific equipment, chemical glassware, electronic analysers,"
3580 DATA "fume cupboards, and two couches. The place looks disorded, like the rest of the ship, the"
3590 DATA "result of frenetic activity. A number of experiments seem to be in progress, with logbooks"
3600 DATA "and tablets covered in dense calculations and notes. Whatever has been happening in here,"
3610 DATA "it has been done with extreme urgency. Exits lead aft and to starboard."
3615 REM lower forward corridor
3620 DATA "This is a featureless, utilitarian corridor. A stairwell leads upwards. There are also"
3630 DATA "doors leading to port and forward.", "", "", ""
3660 REM pod bay
3670 DATA "You are in a large room, with a row of spacesuits hanging on the port wall. At the forward"
3680 DATA "end of the room is a small, two seater vehicle, capable of operating in space outside the"
3690 DATA "main ship for limited periods. In front of the small ship is the pod bay door, leading out"
3700 DATA "into space. There is a porthole on the far wall. There is a single exit leading aft.", ""
3710 REM aft main corridor
3720 DATA "The main corridor stretches away from you towards the front of the ship. It is featureless"
3730 DATA "and utilitarian. The lighting is dim. You can see doors either side of you, to port and"
3740 DATA "to starboard.", "", ""
3760 REM mid main corridor
3770 DATA "The main corridor stretches away from you both forward and aft. It is featureless"
3780 DATA "and utilitarian. The lighting is dim. You can see doors either side of you, to port and"
3790 DATA "to starboard.", "", ""
3810 REM forward main corridor
3820 DATA "The main corridor stretches away from you towards the rear of the ship. It is featureless"
3830 DATA "and utilitarian. The lighting is dim. You can see doors either side of you, to port and"
3840 DATA "to starboard, as well as a third door leading forward.", "", ""
3860 REM assign to room descriptions
3870 FOR ROOM = 0 to RC-1
3880 FOR I = 0 TO 4
3885 READ DESC$ : RD$ (ROOM, I) = DESC$
3890 NEXT I
3900 NEXT ROOM
4000 RETURN
4010 REM ========== print room description ==========
4020 FOR LINE = 0 TO 4
4030 IF RD$(PL, LINE) <> "" THEN PRINT RD$(PL, LINE)
4040 NEXT LINE
4055 GOSUB 4070
4060 RETURN
4070 REM print objects
4080 FOR I = 0 TO OC-1
4090 IF OL ( I ) = PL THEN PRINT : PRINT "You can see: ";OB$ ( I ); "."
4100 NEXT I 
4110 PRINT
4115 IF PL = LAB THEN GOSUB 9700
4120 RETURN 
4130 REM ========== print help ==========
4140 PRINT "For movement, try [go] a[ft], f[orward], p[ort], s[tarboard], u[p] or d[own]." 
4150 PRINT "For actions, try get, take, drop, examine, look, use, i[nventory], q[uit]." 
4155 PRINT "To examine, pick up, use or drop items, refer to them exactly as they are described."
4157 PRINT
4160 RETURN
5000 REM ========== interactive item descriptions ==========
5010 DIM ID$(IC, 20)
5020 REM medical log
5030 DATA "The last few entries of the medical log are still visible on the screen:", " "
5040 DATA "'2142-6-13: Three days since chimpanzee Nova was innoculated with agent #53."
5050 DATA " However, subject Nova showing no signs of adaptation to planetary destination"
5060 DATA " atmosphere. In fact, she appears listless, though punctuated with periods of"
5070 DATA " extreme agression.", " "
5090 DATA " 2142-6-14: This morning, Dr Pearson was bitten by Nova. Very quickly he exhibited"
5100 DATA " signs of a high fever and is now resting in his quarters.", " "
5120 DATA " 2142-6-15: After a brief period of catatonia, Pearson got up on his own, returned"
5130 DATA " to the medical bay and began to compulsively prepare more agent #53 samples. He"
5140 DATA " is otherwise uncommunicative.", " "
5160 DATA " 2142-6-17: Pearson's compulsive behaviour continues unabated. We have a hypothesis"
5170 DATA " for what the virus, which we have now designated HO-1, does to the brain. However,"
5180 DATA " we are struggling to isolate Pearson and may have to seal the medical bay.", " "
5200 DATA " 2142-6-17: Hollow (HO-1) confirmed as airborne, and other cases appearing around the ship."
5210 DATA " Shipwide lockdown declared but crew cohesion and discipline already breaking down.'"
5215 REM porthole
5220 DATA "Looking through the porthole, you seen a spacesuit clad figure floating outside."
5230 DATA "Although he is tethered to an anchor point on the ship's hull, he is otherwise floating"
5240 DATA "freely, his arms and legs splayed out to his sides.", " "
5260 DATA "Peering at the figure more closely, as he slowly rotates, a light from the ship"
5270 DATA "briefly illuminates his face. He's clearly dead, his oxygen ran out some time ago."
5280 DATA "His expression is frozen in a rictus of pain. He was screaming almost until the end ..."
5290 DATA "", "", "", "", "", "", "", "", "", "", "", "", ""
5300 REM console
5310 DATA "The console shows the state of the ship's engines. The pilot"
5320 DATA "appears to have the throttle jammed wide open with his right arm. The muscles in his"
5340 DATA "forearm are taught, there's no way he's going to release the throttle. He left hand"
5350 DATA "works its way around the console switches. After a few moments you realise that he is"
5360 DATA "executing the same sequence of switches over and over again.", " "
5370 DATA "His eyes are glazed, mentally he is somewhere else. He is"
5380 DATA "mumbling to himself but you cannot make out the words, although he appears to be"
5390 DATA "reciting some sort of launch checklist.", " "
5392 DATA "One screen shows the mission parameters:"
5394 DATA " 1. Explore potentially habitable worlds"
5396 DATA " 2. Conduct research to develop gene therapies to aid adaptation to planetary conditions"
5398 DATA " 3. Conduct research to develop custom biologic weapons systems, to protect colonists", " "
5400 DATA "If the engines are online, the ship will be careering through space at maximum"
5410 DATA "speed. Rescue will be impossible unless the engines are offline."
5420 DATA "", "", ""
5430 REM engine control
5440 DATA "The control panel is grubby, smeared with oil and grime. This is clearly"
5450 DATA "the engineering heart of the ship. Most of the readouts mean nothing to you,"
5460 DATA "whatever your duties were on this ship, you were clearly not a warp engineer.", " "
5470 DATA "Many of the lights on the front panel are flashing red. Not all is well with"
5480 DATA "the Pneuma. Even to your untrained eye, it's obvious that the ship's engines appear to"
5490 DATA "be on the point of burnout, having been run at full capacity for many hours.", " "
5500 DATA "To the top left of the panel, a screen reads:", " "
5510 DATA "'WARNING: CORE BREACH IMMINENT'", " "
5520 DATA "Just below the screen is a large red button, shielded by a cover that can be"
5530 DATA "flipped aside.", "", "", "", "", "", ""
5540 REM library terminal
5550 DATA "A ancient text is open in the terminal: 'The Origin of Consciousness in the Breakdown"
5560 DATA "of the Bicameral Mind by Julian Jaynes, 1976.'", "", "", "", "", "", "", "", "", ""
5570 DATA "", "", "", "", "", "", "", "", ""
5940 FOR OBJECT = 0 TO IC-1
5950 FOR I = 0 TO 19
5960 READ DESC$ : ID$ (OBJECT, I) = DESC$
5970 NEXT I
5980 NEXT OBJECT
5990 RETURN
6000 REM ========== print interative object description ==========
6010 FOR LINE = 0 TO 19
6020 IF ID$(F, LINE) <> "" THEN PRINT ID$(F, LINE)
6030 NEXT LINE
6035 PRINT
6040 RETURN
7000 REM ========== character speech ==========
7010 REM chef
7015 DIM PD$(PC, 4)
7020 DATA "Carrots, potatoes, I'm going to make a nice beef stew."
7030 DATA "This stew is going to be delicious."
7060 REM runner
7070 DATA "24:50, that's my new personal best. Not much further to go!"
7080 DATA "24:50, that's my new personal best. Not much further to go!"
7110 REM pilot
7120 DATA "Main engines online, supercruise on my mark."
7130 DATA "Five ... four ... three ... two ... one ... mark!"
7140 FOR PERSON = 0 TO PC-1
7150 FOR I = 0 TO 1
7160 READ DESC$ : PD$ (PERSON, I) = DESC$
7170 NEXT I
7180 PD$(PERSON, 2) = PD$(PERSON, 0)
7190 PD$(PERSON, 3) = PD$(PERSON, 1)
7200 NEXT PERSON
7210 RETURN
7500 REM ========== print character speech ==========
7510 FOR LINE = 0 TO 4
7520 PRINT PD$(F, LINE)
7530 NEXT LINE
7535 PRINT
7550 RETURN
8000 REM ========== wraith-hound tracking ==========
8010 IF OL ( TRACKER ) <> INV THEN RETURN
8015 IF WPL = 99 THEN PRINT "Tracking: Wraith-hound terminated." : GOTO 8030
8020 PRINT "Tracking: Wraith-hound current location is the "; LO$ ( WPL )
8030 PRINT
8040 RETURN
8200 REM ========== wraith-hound proximity check ==========
8210 DIR$ = ""
8220 IF VAL ( MID$ ( EX$ ( PL ) , 1 , 2 ) ) = WPL THEN DIR$ = "forward of you"
8230 IF VAL ( MID$ ( EX$ ( PL ) , 3 , 2 ) ) = WPL THEN DIR$ = "aft of you"
8240 IF VAL ( MID$ ( EX$ ( PL ) , 5 , 2 ) ) = WPL THEN DIR$ = "to port"
8250 IF VAL ( MID$ ( EX$ ( PL ) , 7 , 2 ) ) = WPL THEN DIR$ = "to starboard"
8260 IF VAL ( MID$ ( EX$ ( PL ) , 9 , 2 ) ) = WPL THEN DIR$ = "above you"
8270 IF VAL ( MID$ ( EX$ ( PL ) , 11 , 2 ) ) = WPL THEN DIR$ = "below you"
8280 IF DIR$ <> "" THEN PRINT "You hear a snarling, spitting noise "; DIR$; ". The tracker is pinging ..."
8285 PRINT
8290 RETURN
8400 REM ========== wraith-hound movement ==========
8410 REM decide to move one third of the time
8420 MOVE = RNDINT(1, 3)
8430 IF MOVE <> 1 THEN RETURN
8440 REM randomly determine direction
8450 DIR = RNDINT(1, 6)
8460 IF DIR = 1 THEN INDEX = 1
8470 IF DIR = 2 THEN INDEX = 3
8480 IF DIR = 3 THEN INDEX = 5
8490 IF DIR = 4 THEN INDEX = 7
8500 IF DIR = 5 THEN INDEX = 9
8510 IF DIR = 6 THEN INDEX = 11
8520 NWPL = VAL ( MID$ ( EX$ ( WPL ) , INDEX , 2 ) ) : REM potential next location
8530 IF NWPL = 0 THEN GOTO 8450 : REM can't go that way
8540 WPL = NWPL
8550 RETURN
9000 REM ========== use an item ==========
9010 F=-1: R$=""
9020 R$ = MID$(LOWER$(I$), 5) : REM R$ is the requested object
9025 IF R$ <> "red button" THEN GOTO 9030
9027 GOSUB 9500
9028 RETURN
9030 REM get the object ID
9040 FOR I= 0 TO OC-1
9050 IF OB$(I) = R$ THEN F=I : REM object exists
9060 NEXT I
9070 REM can't find the item?
9080 IF F=-1 THEN PRINT "You haven't seen that item." : PRINT : RETURN
9090 IF OL(F) <> 0 THEN PRINT "You haven't picked up that item." : PRINT : RETURN
9100 REM item exists and is in inventory
9110 IF F <> SYRINGE THEN GOTO 9140
9112 IF OB$( SYRINGE ) = "blood filled syringe" THEN PRINT "The syringe is full." : PRINT : RETURN
9115 IF SUIT_WORN = 1 THEN PRINT "You can't puncture a spacesuit with a syringe!" : PRINT : RETURN
9120 OB$( SYRINGE ) = "blood filled syringe"
9130 PRINT "You use the syringe to take a blood sample from your arm." : PRINT : RETURN
9140 IF F <> TRACKER THEN GOTO 9160
9150 PRINT "The tracker is always on." : PRINT
9160 IF F <> SUIT THEN GOTO 9200
9170 IF OL(F) <> 0 THEN PRINT "You don't have a space suit." : PRINT : RETURN
9175 IF SUIT_WORN = 1 THEN PRINT "You're already wearing the space suit." : PRINT : RETURN
9180 SUIT_WORN = 1
9190 PRINT "You put on the space suit." : PRINT
9400 RETURN
9500 REM special button routine
9510 IF PL <> ENG THEN PRINT "There is no red button here." : PRINT : RETURN
9520 IF SHUTDOWN = 0 THEN GOTO 9540
9525 SHUTDOWN = 0
9530 PRINT "Engine restart initiated ... engines online." : PRINT
9535 ID$ (ENGINE, 10) = "'WARNING: CORE BREACH IMMINENT'" : RETURN
9540 SHUTDOWN = 1
9550 PRINT "Engine shutdown initiated ... engines offline." : PRINT 
9555 ID$ (ENGINE, 10) = "'ENGINES OFFLINE'"
9560 RETURN
9700 REM ========== laboratory conversation ==========
9710 PRINT "Dr Lascoe is stood in the laboratory. He is armed. He speaks to you." : PRINT
9720 PRINT "'It's you! You were infected with HO-1, but you seem to be normal."
9730 PRINT " Hollow destroys consciousness, it shuts down all self awareness in the brain."
9740 PRINT " The patient still functions to a degree, but they're an automaton, endlessly"
9750 PRINT " running the same mental subroutines like a piece of clockwork until the body"
9760 PRINT " breaks down.'" : PRINT
9770 PRINT "'I've been hiding in here to avoid contagion. Someone released the wraith-hound"
9780 PRINT " from containment, but I've been able to keep it away with this weapon."
9790 PRINT " But if you're immune, I can develop a vaccine from your blood.'" : PRINT
9800 IF OL(SYRINGE) = 0 AND OB$(SYRINGE) = "blood filled syringe" THEN GOTO 9820
9810 PRINT "'You need to get me a sample of your blood.'" : PRINT : RETURN
9820 PRINT "'Ah, I see you have a blood sample, excellent.'" : PRINT
9830 IF SUIT_WORN = 1 THEN GOTO 9855
9840 PRINT " I still don't want to take the risk that you are contagious. Put on a space"
9850 PRINT " suit and then I'll let you approach me.'" : PRINT: RETURN
9855 PRINT "'Good, you're wearing a suit to avoid contaminating me.'" : PRINT
9860 IF SHUTDOWN = 1 THEN GOTO 9885
9870 PRINT "'Rescue will be impossible while the engines are running out of control."
9880 PRINT " You'll need to take them offline.'": PRINT : RETURN
9885 PRINT "'Good job on taking the engines offline, you've saved us both!"
9890 PRINT " I'll work up the serum and we can wait for rescue.'" : PRINT
9900 GOSUB 10000
9910 RETURN
10000 REM ========== finale ==========
10010 PRINT "Congratulations, you have save Pneuma and helped Dr Lascoe develop"
10020 PRINT "vaccine against HO-1, the Hollow virus."
10030 PRINT : PRINT "                 THE END" : PRINT
10040 STOP
11000 REM ========== fight ==========
11010 PRINT "The wraith-hound arrives. It is an abomination! A weapon system that"
11020 PRINT "nature would never have created unaided. Everything about it is just"
11030 PRINT "plain wrong on so many levels. One thing is clear, it is designed"
11035 PRINT "purely for hunting and killing." : PRINT
11040 INPUT "Do you r[un] or f[ight]?"; I$
11050 PRINT
11060 IF LOWER$ ( I$ ) = "f" OR LOWER$ ( I$ ) = "fight" THEN GOTO 11190
11065 IF LOWER$ ( I$ ) = "r" OR LOWER$ ( I$ ) = "run" THEN GOTO 11070
11067 PRINT "Command unrecognised, you must fight!" : PRINT : GOTO 11190
11070 REM run away to a random adjoining room
11080 DIR = RNDINT(1, 6)
11090 IF DIR = 1 THEN INDEX = 1
11100 IF DIR = 2 THEN INDEX = 3
11110 IF DIR = 3 THEN INDEX = 5
11120 IF DIR = 4 THEN INDEX = 7
11130 IF DIR = 5 THEN INDEX = 9
11140 IF DIR = 6 THEN INDEX = 11
11150 NPL = VAL ( MID$ ( EX$ ( PL ) , INDEX , 2 ) ) : REM potential next location
11160 IF NPL = 0 THEN GOTO 11080 : REM can't go that way
11170 PL = NPL : PRINT "You are in the " ; LO$ ( PL ) : PRINT 
11175 GOSUB 4010
11180 RETURN
11190 REM fight
11200 FEROCITY = 60 : REM ferocity factor for wraith-hound 
11205 STAMINA = 50 : REM your stamina
11210 IF OL(PULSE) <> INV AND OL(KNIFE) <> INV THEN PRINT "You have no weapons, and must fight bare handed." : PRINT : GOTO 11280
11220 IF OL(PULSE) = INV AND OL(KNIFE) <> INV THEN PRINT "Luckily, you have a pulse rifle." : PRINT: FEROCITY=50 : GOTO 11280
11230 IF OL(PULSE) <> INV AND OL(KNIFE) = INV THEN PRINT "You only have a knife with which to fight." : PRINT : FEROCITY = 55 : GOTO 11280
11240 INPUT "Which weapon do you choose? 1 - Pulse rifle, 2 - Knife: "; WPN
11245 PRINT
11250 IF WPN<1 OR WPN>2 THEN GOTO 11240
11260 IF WPN=1 THEN FEROCITY = 50
11270 IF WPN=2 THEN FEROCITY = 55
11280 REM the battle
11290 IF RND(1)>0.5 THEN PRINT "The wraith-hound attacks!" ELSE PRINT "You attack!"
11300 PRINT
11305 GOSUB 11430
11310 IF RND(1)>0.5 THEN PRINT "You wound the creature." : PRINT: FEROCITY = FEROCITY-5 : GOTO 11330
11320 PRINT "The wraith-hound wounds you." : PRINT : STAMINA = STAMINA-5
11330 GOSUB 11430
11340 IF FEROCITY > 0 THEN GOTO 11390
11350 PRINT "You slayed the wraith-hound!" : PRINT
11360 REM remove creature from the game
11370 WPL = 99 : REM inaccessible location 
11380 RETURN
11390 IF STAMINA > 0 THEN GOTO 11420
11400 PRINT "You were slayed by the wraith-hound! You have failed to save the Pneuma." : PRINT
11410 STOP
11420 GOTO 11280 : REM next round of the battle
11430 REM ========== delay loop ==========
11440 FOR T = 1 TO 80000
11450 NEXT T
11460 RETURN








