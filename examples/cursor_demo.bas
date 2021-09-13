10 rem Cursor Demo
20 print "Watch a ball bounce around a room!"
30 input "Enter the delay between frames"; delay
40 xsize = 30 : ysize = 15
50 clear
60 print "=" * xsize
70 for i = 2 to ysize - 1
80 cursor 1,i:print "|";:cursor xsize,i:print "|";
90 next i
100 cursor 1,ysize:print "=" * xsize
110 ballx = rndint(2,xsize - 1): speedx = rndint(-1,1)
120 bally = rndint(2,ysize - 1): speedy = rndint(-1,1)
200 REM Start ball mover
210 lastx = ballx : lasty = bally
220 ballx = ballx + speedx: bally = bally + speedy
230 if ballx > xsize - 1 then 400
240 if ballx < 2 then 410
250 if bally > ysize - 1 then 420
260 if bally < 2 then 430
270 cursor lastx,lasty:print " ";
280 cursor ballx,bally:print "*";
290 for i = 1 to delay
300 next i
310 goto 210
395 REM collision for walls
400 ballx = xsize - 1 : speedx=-1 : speedy=rndint(-1,1) : goto 240
410 ballx = 2 : speedx=1 : speedy=rndint(-1,1) : goto 250
420 bally = ysize - 1 : speedy=-1  : speedx=rndint(-1,1): goto 260
430 bally = 2 : speedy=1  : speedx=rndint(-1,1): goto 270
