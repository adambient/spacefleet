  10 INK 4
  20 PAPER 0
  30 BORDER 0
  40 CLS 
  50 PRINT "Initialising SPACE FLEET please wait...";
  60 REM support print at 22+ via stream
  70 DEF FN s(x)=(1+(x<22))
  80 DEF FN x(x)=(x-(22*(x>21)))
  90 REM the map
 100 DIM l(8, 12)
 110 REM attack vectors: 1:dx,2:dy,3:damage
 120 DIM a(30, 3)
 130 REM movement vectors: 1:dx,2:dy,3:dir (+- clockwise)
 140 DIM m(15, 3)
 150 REM names
 160 DIM n$(4, 5)
 170 REM shield names
 180 DIM s$(4, 5)
 190 REM player data: 1:x,2:y,3:dir(0:u,1:r,2:d,3:l),4:front,5:right,6:back,7:left,8:hull,9:manoeuvre,10:attack,11:effects
 200 DIM d(4, 11)
 210 REM player UIs: 1:ship,2:planet,3:planet-x,4:planet-y,5:shield-x,6:shield-y,7
 220 DIM u(4, 6)
 230 REM planet position cache: 1:planet-x,2:planet-y
 240 DIM c(4, 2)
 250 REM movement ai behaviours
 260 DIM v(6, 5)
 270 REM load attack vectors
 280 RESTORE 6160
 290 FOR x = 1 TO 30 STEP 1
 300 FOR y = 1 TO 3 STEP 1
 310 READ a(x, y)
 320 NEXT y
 330 NEXT x
 340 REM load movement vectors
 350 RESTORE 6270
 360 FOR x = 1 TO 15 STEP 1
 370 FOR y = 1 TO 3 STEP 1
 380 READ m(x, y)
 390 NEXT y
 400 NEXT x
 410 REM load player UIs, names and shields
 420 RESTORE 6330
 430 FOR x = 1 TO 4 STEP 1
 440 FOR y = 1 TO 6 STEP 1
 450 READ u(x, y)
 460 NEXT y
 470 NEXT x
 480 RESTORE 6380
 490 FOR x = 1 TO 4 STEP 1
 500 READ n$(x)
 510 NEXT x
 520 RESTORE 6720
 530 FOR x = 1 TO 4 STEP 1
 540 READ s$(x)
 550 NEXT x
 560 REM load movement ai behaviours
 570 RESTORE 6650
 580 FOR x = 1 TO 6 STEP 1
 590 FOR y = 1 TO 5 STEP 1
 600 READ v(x, y)
 610 NEXT y
 620 NEXT x
 630 REM load UDGs
 640 LET i = USR "a"
 650 LET t = i+8*19-1
 660 RESTORE 6450
 670 FOR x = i TO t STEP 1
 680 READ y
 690 POKE x, y
 700 NEXT x
 710 LET k$ = ""
 720 GO SUB 1150
 730 GO SUB 1690
 740 IF k$ <>"Y" THEN GO TO 720
 750 REM main game loop
 760 FOR p = 1 TO t STEP 1
 770 REM movement phase
 780 IF d(p, 1) = 0 THEN GO TO 870 : REM dead
 790 IF p > (t - u) THEN GO SUB 4910 : GO TO 860 : REM AI
 800 LET k$ = ""
 810 GO SUB 2220
 820 GO SUB 3060
 830 GO SUB 1780
 840 GO SUB 1690
 850 IF k$ <>"Y" THEN GO TO 800
 860 IF d(p, 11) = 1 THEN LET d(p, 11) = 0
 870 NEXT p
 880 REM apply movement
 890 GO SUB 3370
 900 GO SUB 3740
 910 GO SUB 4200
 920 GO SUB 5400
 930 REM combat phase
 940 FOR p = 1 TO t STEP 1
 950 IF d(p, 8) < 1 THEN GO TO 1040 : REM dead
 960 IF p > (t - u) THEN GO SUB 5040 : GO TO 1040 : REM AI
 970 LET k$ = ""
 980 GO SUB 2220
 990 GO SUB 3060
1000 IF i = 0 OR d(p, 11) = 2 THEN LET d(p, 11) = 2 : PRINT AT 17, 11; INK 2; "<Combat>"; AT 18, 11; INK u(p, 1); n$(p); INK 4; " cannot attack."; : GO TO 1040
1010 GO SUB 1970
1020 GO SUB 1690
1030 IF k$ <>"Y" THEN GO TO 980
1040 IF d(p, 11) = 2 THEN LET d(p, 10) = 18 : LET d(p, 11) = 0 
1050 NEXT p
1060 REM apply combat
1070 FOR p = 1 TO t STEP 1
1080 REM if ship on map
1090 IF d(p, 1) > 0 THEN GO SUB 2220 : GO SUB 3060 : GO SUB 4320
1100 NEXT p 
1110 GO SUB 5400
1120 GO SUB 4730
1130 IF t > 0 THEN GO TO 760
1140 GO TO 720
1150 REM initialise game
1160 LET p = 1 : LET t = 0
1170 GO SUB 5880
1180 GO SUB 2220
1190 PRINT AT 17, 11; INK 5; "<SPACE FLEET>";
1200 PRINT AT 19, 11; "Enter players 2-4? "; FLASH 1; CHR$ (143);
1210 PAUSE 0
1220 LET k$ = INKEY$
1230 IF CODE (k$) < 50 OR CODE (k$) > 52 THEN GO TO 1210
1240 PRINT AT 19, 30; k$;
1250 LET t = VAL (k$)
1260 PRINT AT 20, 11; "AI players 0-"; t-1; "? "; FLASH 1; CHR$ (143);
1270 PAUSE 0
1280 LET k$ = INKEY$
1290 IF CODE (k$) < 48 OR CODE (k$) > 48+t-1 THEN GO TO 1270
1300 PRINT AT 20, 27; k$;
1310 LET u = VAL (k$)
1320 PRINT AT 21, 11; "Loading map...";
1330 REM clear map
1340 FOR y = 1 TO 12 STEP 1
1350 FOR x = 1 TO 8
1360 LET l(x, y) = 0
1370 NEXT x
1380 NEXT y 
1390 REM load player data
1400 RESTORE 6400
1410 FOR x = 1 TO t STEP 1
1420 FOR y = 1 TO 11 STEP 1
1430 READ d(x, y)
1440 NEXT y
1450 LET l(d(x, 1), d(x, 2)) = x : REM 1-4=player
1460 NEXT x
1470 REM generate planet locations
1480 RANDOMIZE 0
1490 FOR p = 1 TO 4 
1500 REM randomise planet locations
1510 LET x = INT (RND* 4) + u(p, 3)
1520 LET y = INT (RND* 4) + u(p, 4)
1530 REM avoid edges
1540 IF x < 2 OR x > 7 OR y < 2 OR y > 11 THEN GO TO 1500
1550 REM update map and draw planet
1560 LET l(x, y) = 4 + p : REM 5+=planet
1570 LET tx = (x - 1) * 2
1580 LET ty = ((y - 1) * 2) + 8
1590 LET c(p, 1) = tx
1600 LET c(p, 2) = ty
1610 PRINT AT tx, ty; INK u(p, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
1620 NEXT p
1630 REM draw players
1640 FOR p = 1 TO t STEP 1
1650 GO SUB 2860
1660 GO SUB 2920
1670 NEXT p
1680 RETURN 
1690 REM console confirm
1700 PRINT #1; AT 1, 11; INK 6; "Confirm Y/N? "; FLASH 1; CHR$ (143);
1710 PAUSE 0
1720 LET k$ = INKEY$
1730 IF k$ = "y" OR k$ = "Y" THEN LET k$ = "Y": GO TO 1760
1740 IF k$ = "n" OR k$ = "N" THEN LET k$ = "N": GO TO 1760
1750 GO TO 1710
1760 PRINT #1; AT 1, 24; INK 6; k$;
1770 RETURN 
1780 REM console movement
1790 PRINT AT 17, 11; INK 5; "<Helm Computer>";
1800 PRINT AT 19, 11; "Speed A/B/C? "; FLASH 1; CHR$ (143);
1810 PRINT AT 20, 11; "[i] for instructions.";
1820 LET d(p, 9) = 1
1830 PAUSE 0
1840 IF INKEY$= "I" OR INKEY$= "i" THEN GO SUB 5460 : GO TO 1790
1850 IF INKEY$= "C" OR INKEY$= "c" OR d(p, 11) = 1 THEN LET d(p, 9) = 10 : LET k$ = "C": GO TO 1880
1860 IF INKEY$= "B" OR INKEY$= "b" THEN LET d(p, 9) = 5 : LET k$ = "B": GO TO 1880
1870 IF INKEY$= "A" OR INKEY$= "a" THEN LET d(p, 9) = 0 : LET k$ = "A": GO TO 1880
1880 IF d(p, 9) = 1 THEN GO TO 1830
1890 PRINT AT 19, 24; k$;
1900 PRINT AT 20, 11; "Movement 1-5? "; FLASH 1; CHR$ (143); FLASH 0; "      ";
1910 PAUSE 0
1920 LET k$ = INKEY$
1930 IF CODE (k$) < 49 OR CODE (k$) > 53 THEN GO TO 1910
1940 PRINT AT 20, 25; k$;
1950 LET d(p, 9) = d(p, 9) + VAL (k$) 
1960 RETURN 
1970 REM console attack
1980 PRINT AT 17, 11; INK 5; "<Combat Display>";
1990 PRINT AT 19, 11; "Distance A-F? "; FLASH 1; CHR$ (143); 
2000 PRINT AT 20, 11; "[i] for instructions.";
2010 LET d(p, 10) = 1
2020 PAUSE 0 
2030 IF INKEY$= "A" OR INKEY$= "a" THEN LET d(p, 10) = 0 : LET k$ = "A": GO TO 2100
2040 IF INKEY$= "B" OR INKEY$= "b" THEN LET d(p, 10) = 5 : LET k$ = "B": GO TO 2100
2050 IF INKEY$= "C" OR INKEY$= "c" THEN LET d(p, 10) = 10 : LET k$ = "C": GO TO 2100
2060 IF INKEY$= "D" OR INKEY$= "d" THEN LET d(p, 10) = 15 : LET k$ = "D": GO TO 2100
2070 IF INKEY$= "E" OR INKEY$= "e" THEN LET d(p, 10) = 20 : LET k$ = "E": GO TO 2100
2080 IF INKEY$= "F" OR INKEY$= "f" THEN LET d(p, 10) = 25 : LET k$ = "F": GO TO 2100
2090 IF INKEY$= "I" OR INKEY$= "i" THEN GO SUB 5660 : GO TO 1980
2100 IF d(p, 10) = 1 THEN GO TO 2020
2110 PRINT AT 19, 25; k$;
2120 PRINT AT 20, 11; "Arc 1-5? "; FLASH 1; CHR$ (143); FLASH 0; "           ";
2130 LET k$ = ""
2140 PAUSE 0
2150 LET k$ = INKEY$
2160 IF CODE (k$) < 49 OR CODE (k$) > 53 THEN GO TO 2140
2170 PRINT AT 20, 20; k$;
2180 LET d(p, 10) = d(p, 10) + VAL (k$) 
2190 RETURN 
2200 REM console any key
2210 PRINT #1; AT 1, 11; INK 6; "Press any key."; : PAUSE 0 : RETURN 
2220 REM draw common controls
2230 PRINT AT 0, 0; INK 5; "Combat";
2240 PRINT AT 1, 0; INK 5; "Display";
2250 PRINT AT 2, 1; "12345";
2260 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4";
2270 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2";
2280 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1";
2290 PRINT AT 6, 0; "D"; PAPER 6; "  "; AT 6, 4; PAPER 6; "  ";
2300 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  ";
2310 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " ";
2320 PRINT AT 9, 4; INK 6; "31";
2330 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
2340 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
2350 PRINT AT 18, 0; "  "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
2360 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
2370 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
2380 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
2390 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
2400 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
2410 REM draw player controls and clear console
2420 INK u(p, 1)
2430 PRINT AT 0, 6; CHR$ (133); CHR$ (161);
2440 PRINT AT 1, 7; CHR$ (161);
2450 PRINT AT 2, 0; CHR$ (138); AT 2, 6; CHR$ (133); CHR$ (161);
2460 PRINT AT 3, 7; CHR$ (161);
2470 PRINT AT 4, 7; CHR$ (161);
2480 PRINT AT 5, 7; CHR$ (161);
2490 PRINT AT 6, 3; CHR$ (161); AT 6, 6; CHR$ (133); CHR$ (161);
2500 PRINT AT 7, 6; CHR$ (133); CHR$ (161);
2510 PRINT AT 8, 6; CHR$ (133); CHR$ (161);
2520 PRINT AT 9, 0; CHR$ (142); CHR$ (140); CHR$ (140); CHR$ (140); AT 9, 6; CHR$ (141); CHR$ (161);
2530 PRINT AT 10, 6; CHR$ (133); CHR$ (161);
2540 PRINT AT 11, 6; CHR$ (133); CHR$ (161);
2550 PRINT AT 12, 6; CHR$ (133); CHR$ (161);
2560 PRINT AT 13, 6; CHR$ (133); CHR$ (161);
2570 PRINT AT 14, 6; CHR$ (133); CHR$ (161);
2580 PRINT AT 15, 6; CHR$ (133); CHR$ (161);
2590 PRINT AT 16, 4; CHR$ (140); AT 16, 13; CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); INK 7; PAPER 0; "SPACE"; INK u(p, 1); CHR$ (140); INK 7; n$(p);
2600 PRINT AT 17, 10; CHR$ (138); "                     ";
2610 PRINT AT 18, 10; CHR$ (138); "                     ";
2620 PRINT AT 19, 10; CHR$ (138); "                     ";
2630 PRINT AT 20, 10; CHR$ (138); "                     ";
2640 PRINT AT 21, 10; CHR$ (138); "                     ";
2650 PRINT #1; AT 0, 10; INK u(p, 1); CHR$ (138); "                     ";
2660 PRINT #1; AT 1, 10; INK u(p, 1); CHR$ (138); "                     ";
2670 INK 4
2680 IF d(p, 11) = 1 THEN GO SUB 2710
2690 IF d(p, 11) = 2 THEN GO SUB 2780
2700 RETURN 
2710 REM engines damaged
2720 PRINT AT 17, 0; "          ";
2730 PRINT AT 18, 0; INK 2; "<WARNING> ";
2740 PRINT AT 19, 0; " ENGINES  ";
2750 PRINT AT 20, 0; " DAMAGED  ";
2760 PRINT AT 21, 0; "          ";
2770 RETURN 
2780 REM weapons damaged
2790 PRINT AT 3, 1; "     ";
2800 PRINT AT 4, 1; "     ";
2810 PRINT AT 5, 1; "     ";
2820 PRINT AT 6, 1; "  "; AT 6, 4; "  ";
2830 PRINT AT 7, 1; "     ";
2840 PRINT AT 8, 1; "     ";
2850 RETURN 
2860 REM draw player shields
2870 IF d(p, 8) < 1 THEN PRINT AT 10 + u(p, 5), 1 + u(p, 6); " "; AT 11 + u(p, 5), u(p, 6); "   "; AT 12 + u(p, 5), 1 + u(p, 6); " "; : RETURN 
2880 PRINT AT 10 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 4);
2890 PRINT AT 11 + u(p, 5), u(p, 6); INK u(p, 1); d(p, 7); INK 0; PAPER u(p, 1); d(p, 8); INK u(p, 1); PAPER 0; d(p, 5);
2900 PRINT AT 12 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 6);
2910 RETURN 
2920 REM draw player ship
2930 LET tx = (d(p, 1) - 1) * 2
2940 LET ty = ((d(p, 2) - 1) * 2) + 8
2950 IF d(p, 8) = 0 THEN PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; : RETURN 
2960 IF d(p, 3) = 0 THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (152); CHR$ (153); AT tx + 1, ty; CHR$ (150); CHR$ (151); : RETURN 
2970 IF d(p, 3) = 1 THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (156); AT tx + 1, ty; CHR$ (150); CHR$ (157); : RETURN 
2980 IF d(p, 3) = 2 THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (149); AT tx + 1, ty; CHR$ (154); CHR$ (155); : RETURN 
2990 PRINT AT tx, ty; INK u(p, 1); CHR$ (158); CHR$ (149); AT tx + 1, ty; CHR$ (159); CHR$ (151);
3000 RETURN 
3010 REM draw target explosion
3020 LET tx = (d(q, 1) - 1) * 2
3030 LET ty = ((d(q, 2) - 1) * 2) + 8
3040 PRINT AT tx, ty; INK 6; PAPER 2; FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
3050 RETURN 
3060 REM overlay and count targets
3070 LET i = 0 
3080 FOR q = 1 TO t STEP 1
3090 IF q = p OR d(q, 1) < 1 OR d(q, 8) < 1 THEN GO TO 3170
3100 GO SUB 5160 : REM load tx, ty
3110 LET tx = tx + 4 : LET ty = ty + 3
3120 IF tx < 1 OR tx > 6 OR ty < 1 OR ty > 5 THEN GO TO 3170
3130 LET s = d(p, 3) + d(q, 3)
3140 IF s = 1 OR s = 3 OR s = 5 THEN PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (160); : GO TO 3160
3150 PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (161);
3160 IF a(((tx - 1) * 5) + ty, 3) > 0 THEN LET i = i + 1
3170 NEXT q
3180 RETURN 
3190 REM redraw screen
3200 CLS 
3210 GO SUB 2220
3220 LET q = p
3230 FOR i = 1 TO t STEP 1
3240 LET p = i
3250 IF d(p, 8) = 0 OR d(p, 1) < 1 THEN GO TO 3280
3260 GO SUB 2860
3270 GO SUB 2920
3280 NEXT i
3290 LET p = q
3300 GO SUB 3060
3310 FOR i = 1 TO 4 STEP 1
3320 LET tx = c(i, 1)
3330 LET ty = c(i, 2)
3340 PRINT AT tx, ty; INK u(i, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
3350 NEXT i
3360 RETURN 
3370 REM apply movement
3380 FOR p = 1 TO t STEP 1
3390 IF d(p, 1) < 1 THEN GO TO 3540
3400 IF d(p, 3) = 0 THEN LET x = d(p, 1) + m(d(p, 9), 1) : LET y = d(p, 2) + m(d(p, 9), 2) : GO TO 3440
3410 IF d(p, 3) = 1 THEN LET x = d(p, 1) + m(d(p, 9), 2) : LET y = d(p, 2) - m(d(p, 9), 1) : GO TO 3440
3420 IF d(p, 3) = 2 THEN LET x = d(p, 1) - m(d(p, 9), 1) : LET y = d(p, 2) - m(d(p, 9), 2) : GO TO 3440
3430 LET x = d(p, 1) - m(d(p, 9), 2) : LET y = d(p, 2) + m(d(p, 9), 1)
3440 IF x < 1 OR x > 8 OR y < 1 OR y > 12 THEN LET x = 0 : GO TO 3460
3450 GO SUB 3560
3460 LET l(d(p, 1), d(p, 2)) = 0 : REM clear map
3470 LET tx = (d(p, 1) - 1) * 2 : LET ty = ((d(p, 2) - 1) * 2) + 8 : REM clear screen pos 1
3480 LET d(p, 1) = x : LET d(p, 2) = y : REM update player
3490 LET d(p, 3) = d(p, 3) + m(d(p, 9), 3) : REM update dir
3500 IF d(p, 3) > 3 THEN LET d(p, 3) = d(p, 3) - 4 : GO TO 3520
3510 IF d(p, 3) < 0 THEN LET d(p, 3) = d(p, 3) + 4
3520 PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; : REM clear screen pos 2
3530 IF x > 0 THEN LET l(x, y) = p : GO SUB 2920
3540 NEXT p
3550 RETURN 
3560 REM planet collision check
3570 IF l(x, y) < 5 THEN RETURN 
3580 GO SUB 2220
3590 GO SUB 3060
3600 PRINT AT 17, 11; INK 2; "<Movement>";
3610 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " ram planet! x4";
3620 LET b = 4
3630 LET s = 4
3640 LET q = p
3650 GO SUB 5220
3660 IF d(p, 3) = 0 THEN LET x = x + 1 : GO TO 3700
3670 IF d(p, 3) = 1 THEN LET y = y - 1 : GO TO 3700
3680 IF d(p, 3) = 2 THEN LET x = x - 1 : GO TO 3700
3690 LET y = y + 1
3700 GO SUB 2860
3710 GO SUB 2200
3720 IF x > 0 THEN GO SUB 3560
3730 RETURN 
3740 REM player collision check
3750 FOR p = 1 TO t STEP 1
3760 IF d(p, 1) < 1 THEN GO TO 4010
3770 GO SUB 2920
3780 FOR q = 1 TO t STEP 1
3790 IF p = q OR d(q, 1) < 1 OR d(p, 1) <>d(q, 1) OR d(p, 2) <>d(q, 2) THEN GO TO 4000
3800 REM collision!
3810 GO SUB 2220
3820 PRINT AT 17, 11; INK 2; "<Movement>";
3830 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " ram "; INK u(q, 1); n$(q); INK 4; " x4";
3840 LET s = d(p, 3) - d(q, 3) + 6
3850 IF s > 7 THEN LET s = s - 4 : GO TO 3870
3860 IF s < 4 THEN LET s = s + 4
3870 LET b = 4
3880 GO SUB 5220
3890 LET tx = (d(p, 1) - 1) * 2
3900 LET ty = ((d(p, 2) - 1) * 2) + 8
3910 PRINT AT tx, ty; INK u(p, 1); PAPER u(q, 1); FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
3920 GO SUB 2200
3930 LET i = p
3940 LET p = q
3950 GO SUB 2860
3960 IF d(i, 8) = 0 THEN GO SUB 2920
3970 LET p = i
3980 IF d(q, 8) = 0 THEN GO SUB 2920
3990 IF d(p, 8) > 0 AND d(q, 8) > 0 AND p > q THEN GO SUB 4030
4000 NEXT q
4010 NEXT p
4020 RETURN 
4030 REM move one player
4040 GO SUB 2410
4050 LET x = d(i, 1)
4060 LET y = d(i, 2)
4070 LET tx = d(i, 1) - 1 + INT (RND* 2)
4080 LET ty = d(i, 2) - 1 + INT (RND* 2)
4090 IF tx < 1 OR tx > 8 OR ty < 1 OR ty > 12 THEN GO TO 4070
4100 IF l(tx, ty) > 0 THEN GO TO 4070
4110 REM choose winner
4120 IF INT RND* 3 > 2 THEN LET i = p : LET s = q : GO TO 4150
4130 LET i = q : LET s = p
4140 REM move player and update map
4150 LET d(i, 1) = tx : LET d(i, 2) = ty : LET l(tx, ty) = i : LET l(x, y) = s
4160 PRINT AT 17, 11; INK 2; "<Movement>";
4170 PRINT AT 18, 11; INK u(s, 1); n$(s); INK 4; " moves "; INK u(i, 1); n$(i) ; INK 4; "!";
4180 LET i = p : LET p = q : GO SUB 2920 : LET p = i : GO SUB 2920
4190 RETURN 
4200 REM off map check
4210 FOR p = 1 TO t STEP 1
4220 IF d(p, 8) < 1 OR d(p, 1) > 0 THEN GO TO 4300
4230 GO SUB 2220
4240 GO SUB 3060
4250 PRINT AT 17, 11; INK 2; "<Movement>";
4260 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " fall into the "; AT 19, 11; "void and are eaten"; AT 20, 11; "by a passing cosmic"; AT 21, 11; "horror.";
4270 LET d(p, 8) = 0
4280 GO SUB 2860
4290 GO SUB 2200
4300 NEXT p
4310 RETURN 
4320 REM player attack
4330 PRINT AT 17, 11; INK 2; "<Combat>";
4340 IF a(d(p, 10), 3) = 0 THEN LET s = 0 : GO TO 4710
4350 IF d(p, 3) = 0 THEN LET x = d(p, 1) + a(d(p, 10), 1) : LET y = d(p, 2) + a(d(p, 10), 2) : GO TO 4390
4360 IF d(p, 3) = 1 THEN LET x = d(p, 1) + a(d(p, 10), 2) : LET y = d(p, 2) - a(d(p, 10), 1) : GO TO 4390
4370 IF d(p, 3) = 2 THEN LET x = d(p, 1) - a(d(p, 10), 1) : LET y = d(p, 2) - a(d(p, 10), 2) : GO TO 4390
4380 LET x = d(p, 1) - a(d(p, 10), 2) : LET y = d(p, 2) + a(d(p, 10), 1) 
4390 LET s = 0
4400 FOR q = 1 TO t STEP 1
4410 IF d(q, 1) <>x OR d(q, 2) <>y OR d(q, 8) < 1 THEN GO TO 4700
4420 INK u(p, 1) : GO SUB 2610 : INK 4
4430 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " attack "; INK u(q, 1); n$(q); INK 4; " x"; a(d(p, 10), 3); 
4440 PAPER u(p, 1) 
4450 LET s = p
4460 LET p = q
4470 GO SUB 2920
4480 LET q = p
4490 LET p = s
4500 PAPER 0 
4510 REM resolve shield based on relative positions and q dir
4520 LET tx = d(p, 1) - d(q, 1)
4530 LET ty = d(p, 2) - d(q, 2)
4540 IF ABS tx > ABS ty AND tx > 0 THEN LET s = 6 : GO TO 4580
4550 IF ABS tx > ABS ty THEN LET s = 4 : GO TO 4580
4560 IF ty > 0 THEN LET s = 5 : GO TO 4580
4570 LET s = 7
4580 LET s = s - d(q, 3)
4590 IF s > 7 THEN LET s = s - 4 : GO TO 4610
4600 IF s < 4 THEN LET s = s + 4
4610 LET b = a(d(p, 10), 3)
4620 GO SUB 5220
4630 REM refresh attacked ship
4640 LET i = p
4650 LET p = q
4660 GO SUB 2860
4670 GO SUB 2200
4680 GO SUB 2920
4690 LET p = i
4700 NEXT q
4710 IF s = 0 THEN PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " do not attack.";
4720 RETURN 
4730 REM end game check
4740 LET i = 0
4750 LET q = 1
4760 FOR p = 1 TO t STEP 1
4770 IF d(p, 1) > 0 THEN LET q = p : LET i = i + 1
4780 NEXT p 
4790 REM still at least 2 players
4800 IF i > 1 THEN RETURN 
4810 REM ends game
4820 LET t = 0
4830 REM 1st player or winner colours
4840 LET p = q
4850 GO SUB 2220
4860 PRINT AT 17, 11; INK 2; "<GAME OVER>";
4870 IF i = 0 THEN PRINT AT 18, 11; "Everybody is dead."; : GO TO 4890
4880 PRINT AT 18, 11; INK u(p, 1); "SPACE "; n$(p); INK 4; " have won.";
4890 GO SUB 2200
4900 RETURN 
4910 REM resolve AI movement
4920 LET d(p, 9) = 13
4930 IF d(p, 11) = 1 THEN RETURN 
4940 FOR q = 1 TO t STEP 1
4950 IF q = p OR d(q, 1) < 1 THEN GO TO 4990
4960 GO SUB 5160 : REM load tx, ty
4970 LET tx = tx + 4 : LET ty = ty + 3
4980 IF tx > 0 AND tx < 7 AND ty > 0 AND ty < 6 THEN LET d(p, 9) = v(tx, ty) : RETURN 
4990 NEXT q
5000 IF ty > -11 AND ty < 0 THEN LET d(p, 9) = 1 : RETURN 
5010 IF tx > 5 AND tx < 16 THEN LET d(p, 9) = 5 : RETURN 
5020 LET d(p, 9) = 3
5030 RETURN 
5040 REM resolve AI attack
5050 LET b = 18
5060 LET d(p, 10) = 18
5070 FOR q = 1 TO t STEP 1
5080 IF q = p OR d(q, 1) < 1 THEN GO TO 5140
5090 GO SUB 5160 : REM load tx, ty
5100 LET tx = tx + 4
5110 LET ty = ty + 3
5120 IF tx > 0 AND tx < 7 AND ty > 0 AND ty < 6 THEN LET b = ((tx - 1) * 5) + ty
5130 IF a(b, 3) > a(d(p, 10), 3) THEN LET d(p, 10) = b
5140 NEXT q
5150 RETURN 
5160 REM load tx, ty with target relative position
5170 IF d(p, 3) = 0 THEN LET tx = d(q, 1) - d(p, 1) : LET ty = d(q, 2) - d(p, 2) : RETURN 
5180 IF d(p, 3) = 1 THEN LET tx = d(p, 2) - d(q, 2) : LET ty = d(q, 1) - d(p, 1) : RETURN 
5190 IF d(p, 3) = 2 THEN LET tx = d(p, 1) - d(q, 1) : LET ty = d(p, 2) - d(q, 2) : RETURN 
5200 LET tx = d(q, 2) - d(p, 2) : LET ty = d(p, 1) - d(q, 1)
5210 RETURN 
5220 REM attack ship q *b
5230 LET tx = 19
5240 FOR i = 1 TO b STEP 1
5250 IF RND* 9 < 4 THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; : GO TO 5370
5260 IF d(q, 8) = 1 OR RND* 6 > 1 THEN GO TO 5340
5270 IF d(q, s) > 1 AND RND* 6 > 5 THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT! "; INK 4; s$(s - 3); " shields -"; d(q, s); : LET d(q, s) = 0 : GO TO 5360
5280 IF d(q, s) > 0 AND RND* 6 > 5 THEN LET d(q, 8) = d(q, 8) - 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT!"; INK 4; " Hull -1"; : GO TO 5360
5290 IF d(q, 11) > 0 THEN GO TO 5340
5300 IF d(q, s) > 0 THEN LET d(q, s) = d(q, s) - 1 : GO TO 5320
5310 LET d(q, 8) = d(q, 8) - 1
5320 IF RND* 6 > 3 THEN LET d(q, 11) = 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT!"; INK 4; " Engines damaged."; : GO TO 5360
5330 LET d(q, 11) = 2 : PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT!"; INK 4; " Weapons damaged."; : GO TO 5360
5340 IF d(q, s) > 0 THEN LET d(q, s) = d(q, s) - 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! "; s$(s - 3); " shields -1"; : GO TO 5360
5350 IF d(q, 8) > 0 THEN LET d(q, 8) = d(q, 8) - 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Hull -1"; : GO TO 5360
5360 IF d(q, 8) = 0 THEN PRINT #FN s(tx); AT FN x(tx), 16; INK 4; "Ship destroyed!"; : GO SUB 3010 : RETURN 
5370 LET tx = tx + 1
5380 NEXT i
5390 RETURN 
5400 REM move destroyed ships off map
5410 FOR p = 1 TO t STEP 1
5420 REM if ship on map and 0 hull move off map
5430 IF d(p, 1) > 0 AND d(p, 8) < 1 THEN LET l(d(p, 1), d(p, 2)) = 0 : LET d(p, 1) = 0
5440 NEXT p
5450 RETURN 
5460 REM helm computer instructions
5470 CLS 
5480 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE "; n$(p);"           ";
5490 PRINT AT 2, 0; "Note the direction of your ship and consult the "; INK 5; "Helm Computer"; INK 4; ".  You must select a speed A-C and a manoeuvre 1-5."
5500 PRINT AT 7, 0; "Example - A5 performs this move:"
5510 PRINT AT 9, 2; INK u(p, 1); CHR$ (148); CHR$ (156); AT 10, 2; CHR$ (150); CHR$ (157); INK 4; " Also...";
5520 PRINT AT 11, 5; "- Stay within map or die.";
5530 PRINT AT 12, 5; "- Avoid planets."
5540 PRINT AT 13, 0; INK u(p, 1); CHR$ (152); CHR$ (153); INK 4; "   - Optionally ram opponents."; AT 14, 0; INK u(p, 1); CHR$ (150); CHR$ (151);
5550 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
5560 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
5570 PRINT AT 18, 1; " "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
5580 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
5590 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
5600 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
5610 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
5620 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
5630 GO SUB 2200
5640 GO SUB 3190
5650 RETURN 
5660 REM combat display instructions
5670 CLS 
5680 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE "; n$(p);"           ";
5690 PRINT AT 2, 1; "12345  The "; INK 5; "Combat Display"; INK 4; " shows";
5700 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4"; INK 4; " enemies within range and";
5710 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2"; INK 4; " the A-F/1-5 combination";
5720 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1"; INK 4; " to attack. The number of";
5730 PRINT AT 6, 0; "D"; PAPER 6; "  "; INK u(p, 1); PAPER 0; CHR$ (161); AT 6, 4; PAPER 6; "  "; INK 4; PAPER 0; "  attacks correspond to";
5740 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  "; INK 4; PAPER 0; "  the "; INK 2; "red "; INK 4; "and "; INK 6; "yellow";
5750 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " "; INK 4; PAPER 0; "  numbers.";
5760 PRINT AT 9, 4; INK 6; "31";
5770 PRINT AT 11, 8; "A player has 4 shields";
5780 PRINT AT 12, 8; "and a hull. The "; INK 5; "Combat ";
5790 PRINT AT 13, 8; INK 5; "Display"; INK 4; " can be used to";
5800 PRINT AT 14, 8; "see which shield will be";
5810 PRINT AT 15, 8; "hit.";
5820 PRINT AT 17, 0; "The hull is damaged if there areno shields on the attacked side.When the hull reaches 0 the shipis destroyed.";
5830 GO SUB 2860
5840 GO SUB 3060
5850 GO SUB 2200
5860 GO SUB 3190
5870 RETURN 
5880 REM about SPACE FLEET
5890 CLS 
5900 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE FLEET           ";
5910 PRINT AT 1, 0; "       ";
5920 PRINT AT 2, 0; "In the grim darkness of the far future, there is only war.";
5930 PRINT AT 5, 0; "Select 2-4 human or AI players, and do turn-based battle using  the "; INK 5; "<Helm Computer>"; INK 4; " for movementand "; INK 5; "<Combat Display>"; INK 4; " to attack.";
5940 PRINT AT 10, 0; "Each are accessed via a console,through which further help is   available by entering [i]."
5950 PRINT AT 14, 0; INK 6; "Press any key to begin."
5960 PRINT #1; AT 0, 0; INK 1; CHR$ (152); CHR$ (153);
5970 PRINT #1; AT 0, 3; INK 2; CHR$ (148); CHR$ (156);
5980 PRINT #1; AT 0, 6; INK 3; CHR$ (148); CHR$ (149);
5990 PRINT #1; AT 0, 9; INK 6; CHR$ (158); CHR$ (149);
6000 PRINT #1; AT 0, 12; INK 5; CHR$ (144); CHR$ (145);
6010 PRINT #1; AT 0, 15; INK 4; CHR$ (144); CHR$ (145);
6020 PRINT #1; AT 0, 18; INK 2; CHR$ (144); CHR$ (145);
6030 PRINT #1; AT 0, 21; INK 3; CHR$ (144); CHR$ (145);
6040 PRINT #1; AT 1, 0; INK 1; CHR$ (150); CHR$ (151);
6050 PRINT #1; AT 1, 3; INK 2; CHR$ (150); CHR$ (157);
6060 PRINT #1; AT 1, 6; INK 3; CHR$ (154); CHR$ (155);
6070 PRINT #1; AT 1, 9; INK 6; CHR$ (159); CHR$ (151);
6080 PRINT #1; AT 1, 12; INK 5; CHR$ (146); CHR$ (147);
6090 PRINT #1; AT 1, 15; INK 4; CHR$ (146); CHR$ (147);
6100 PRINT #1; AT 1, 18; INK 2; CHR$ (146); CHR$ (147);
6110 PRINT #1; AT 1, 21; INK 3; CHR$ (146); CHR$ (147);
6120 PAUSE 0
6130 CLS 
6140 RETURN 
6150 REM attack vectors data
6160 DATA -3, -2, 4, -3, -1, 4, -3, 0, 4
6170 DATA -3, 1, 4, -3, 2, 4, -2, -2, 1
6180 DATA -2, -1, 2, -2, 0, 2, -2, 1, 2
6190 DATA -2, 2, 1, -1, -2, 1, -1, -1, 3
6200 DATA -1, 0, 1, -1, 1, 3, -1, 2, 1
6210 DATA 0, -2, 1, 0, -1, 3, 0, 0, 0
6220 DATA 0, 1, 3, 0, 2, 1, 1, -2, 1
6230 DATA 1, -1, 3, 1, 0, 0, 1, 1, 3
6240 DATA 1, 2, 1, 2, -2, 1, 2, -1, 0
6250 DATA 2, 0, 0, 2, 1, 0, 2, 2, 1
6260 REM movement vectors data
6270 DATA -2, -1, -1, -2, -1, 0, -2, 0, 0
6280 DATA -2, 1, 0, -2, 1, 1, -1, -1, -1
6290 DATA -1, -1, 0, -1, 0, 0, -1, 1, 0
6300 DATA -1, 1, 1, 0, 0, 0, 0, 0, -1
6310 DATA 0, 0, 0, 0, 0, 1, 0, 0, 0
6320 REM player UIs data
6330 DATA 1, 5, 1, 1, 0, 0
6340 DATA 2, 4, 5, 9, 3, 3
6350 DATA 3, 2, 1, 9, 0, 3
6360 DATA 6, 3, 5, 1, 3, 0
6370 REM player names data
6380 DATA "FLEET", "ELVES", "CHAOS", "HORDE"
6390 REM player data
6400 DATA 1, 1, 2, 3, 3, 3, 3, 4, 0, 0, 0
6410 DATA 8, 12, 0, 3, 3, 3, 3, 4, 0, 0, 0
6420 DATA 1, 12, 2, 3, 3, 3, 3, 4, 0, 0, 0
6430 DATA 8, 1, 0, 3, 3, 3, 3, 4, 0, 0, 0
6440 REM UDGs data
6450 DATA 0, 3, 15, 31, 63, 63, 127, 127
6460 DATA 0, 192, 240, 248, 252, 252, 254, 254 
6470 DATA 127, 127, 63, 63, 31, 15, 3, 0 
6480 DATA 254, 254, 252, 252, 248, 240, 192, 0
6490 DATA 0, 0, 0, 0, 1, 7, 7, 15
6500 DATA 0, 0, 0, 0, 128, 224, 224, 240 
6510 DATA 15, 7, 7, 1, 0, 0, 0, 0
6520 DATA 240, 224, 224, 128, 0, 0, 0, 0
6530 DATA 0, 0, 0, 5, 15, 7, 15, 7
6540 DATA 0, 0, 0, 160, 240, 224, 240, 224
6550 DATA 7, 15, 7, 15, 5, 0, 0, 0 
6560 DATA 224, 240, 224, 240, 160, 0, 0, 0 
6570 DATA 0, 0, 0, 0, 80, 248, 240, 248 
6580 DATA 248, 240, 248, 80, 0, 0, 0, 0 
6590 DATA 0, 0, 0, 0, 10, 31, 15, 31 
6600 DATA 31, 15, 31, 10, 0, 0, 0, 0 
6610 DATA 0, 0, 0, 60, 60, 0, 0, 0 
6620 DATA 0, 0, 24, 24, 24, 24, 0, 0 
6630 DATA 0, 0, 0, 0, 24, 0, 0, 0
6640 REM movement ai behaviour data
6650 DATA 1, 2, 3, 4, 5
6660 DATA 6, 7, 8, 9, 10
6670 DATA 12, 12, 14, 14, 14
6680 DATA 12, 12, 12, 14, 14
6690 DATA 12, 12, 14, 14, 14
6700 DATA 12, 12, 12, 14, 14
6710 REM shields
6720 DATA "Front", "Right", " Rear", " Left"
