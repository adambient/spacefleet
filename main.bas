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
 190 REM player data: 1:x,2:y,3:dir(0:u,1:r,2:d,3:l),4:front,5:right,6:back,7:left,8:hull,9:manoeuvre,10:attack
 200 DIM d(4, 10)
 210 REM player UIs: 1:ship,2:planet,3:planet-x,4:planet-y,5:shield-x,6:shield-y,7
 220 DIM u(4, 6)
 230 REM planet position cache: 1:planet-x,2:planet-y
 240 DIM c(4, 2)
 250 REM movement ai behaviours
 260 DIM v(6, 5)
 270 REM load attack vectors
 280 RESTORE 5130
 290 FOR x = 1 TO 30 STEP 1
 300 FOR y = 1 TO 3 STEP 1
 310 READ a(x, y)
 320 NEXT y
 330 NEXT x
 340 REM load movement vectors
 350 RESTORE 5240
 360 FOR x = 1 TO 15 STEP 1
 370 FOR y = 1 TO 3 STEP 1
 380 READ m(x, y)
 390 NEXT y
 400 NEXT x
 410 REM load player UIs, names and shields
 420 RESTORE 5300
 430 FOR x = 1 TO 4 STEP 1
 440 FOR y = 1 TO 6 STEP 1
 450 READ u(x, y)
 460 NEXT y
 470 NEXT x
 480 RESTORE 5350
 490 FOR x = 1 TO 4 STEP 1
 500 READ n$(x)
 510 NEXT x
 520 RESTORE 5690
 530 FOR x = 1 TO 4 STEP 1
 540 READ s$(x)
 550 NEXT x
 560 REM load movement ai behaviours
 570 RESTORE 5620
 580 FOR x = 1 TO 6 STEP 1
 590 FOR y = 1 TO 5 STEP 1
 600 READ v(x, y)
 610 NEXT y
 620 NEXT x
 630 REM load UDGs
 640 LET i = USR "a"
 650 LET t = i+8*19-1
 660 RESTORE 5420
 670 FOR x = i TO t STEP 1
 680 READ y
 690 POKE x, y
 700 NEXT x
 710 LET k$ = ""
 720 GO SUB 1170
 730 GO SUB 1710
 740 IF k$ <>"Y" THEN GO TO 720
 750 REM main game loop
 760 FOR p = 1 TO t STEP 1
 770 REM movement phase
 780 IF d(p, 1) = 0 THEN GO TO 860 : REM dead
 790 IF p > (t - u) THEN GO SUB 4740 : GO TO 860 : REM AI
 800 LET k$ = ""
 810 GO SUB 2240
 820 GO SUB 2910
 830 GO SUB 1800
 840 GO SUB 1710
 850 IF k$ <>"Y" THEN GO TO 800
 860 NEXT p
 870 REM apply movement
 880 GO SUB 3220
 890 GO SUB 3590
 900 GO SUB 4050
 910 REM combat phase
 920 FOR p = 1 TO t STEP 1
 930 IF d(p, 8) < 1 THEN GO TO 1020 : REM dead
 940 IF p > (t - u) THEN GO SUB 4860 : GO TO 1020 : REM AI
 950 LET k$ = ""
 960 GO SUB 2240
 970 GO SUB 2910
 980 IF i = 0 THEN LET d(p, 10) = 18 : PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " cannot attack.": GO TO 1020
 990 GO SUB 1990
1000 GO SUB 1710
1010 IF k$ <>"Y" THEN GO TO 960
1020 REM next attack input     
1030 NEXT p
1040 REM apply combat
1050 FOR p = 1 TO t STEP 1
1060 REM if ship on map
1070 IF d(p, 1) > 0 THEN GO SUB 2240 : GO SUB 2910 : GO SUB 4150
1080 NEXT p 
1090 REM move killed ships off map
1100 FOR p = 1 TO t STEP 1
1110 REM if ship on map and 0 hull move off map
1120 IF d(p, 1) > 0 AND d(p, 8) < 1 THEN LET l(d(p, 1), d(p, 2)) = 0 : LET d(p, 1) = 0
1130 NEXT p
1140 GO SUB 4560
1150 IF t > 0 THEN GO TO 760
1160 GO TO 720
1170 REM initialise game
1180 LET p = 1 : LET t = 0
1190 GO SUB 6120
1200 GO SUB 2240
1210 PRINT AT 17, 11; INK 5; "<SPACE FLEET>";
1220 PRINT AT 19, 11; "Enter players 2-4? "; FLASH 1; CHR$ (143);
1230 PAUSE 0
1240 LET k$ = INKEY$
1250 IF CODE (k$) < 50 OR CODE (k$) > 52 THEN GO TO 1230
1260 PRINT AT 19, 30; k$;
1270 LET t = VAL (k$)
1280 PRINT AT 20, 11; "AI players 0-"; t-1; "? "; FLASH 1; CHR$ (143);
1290 PAUSE 0
1300 LET k$ = INKEY$
1310 IF CODE (k$) < 48 OR CODE (k$) > 48+t-1 THEN GO TO 1290
1320 PRINT AT 20, 27; k$;
1330 LET u = VAL (k$)
1340 PRINT AT 21, 11; "Loading map...";
1350 REM clear map
1360 FOR y = 1 TO 12 STEP 1
1370 FOR x = 1 TO 8
1380 LET l(x, y) = 0
1390 NEXT x
1400 NEXT y 
1410 REM load player data
1420 RESTORE 5370
1430 FOR x = 1 TO t STEP 1
1440 FOR y = 1 TO 10 STEP 1
1450 READ d(x, y)
1460 NEXT y
1470 LET l(d(x, 1), d(x, 2)) = x : REM 1-4=player
1480 NEXT x
1490 REM generate planet locations
1500 RANDOMIZE 0
1510 FOR p = 1 TO 4 
1520 REM randomise planet locations
1530 LET x = INT (RND* 4) + u(p, 3)
1540 LET y = INT (RND* 4) + u(p, 4)
1550 REM avoid edges
1560 IF x < 2 OR x > 7 OR y < 2 OR y > 11 THEN GO TO 1520
1570 REM update map and draw planet
1580 LET l(x, y) = 4 + p : REM 5+=planet
1590 LET tx = (x - 1) * 2
1600 LET ty = ((y - 1) * 2) + 8
1610 LET c(p, 1) = tx
1620 LET c(p, 2) = ty
1630 PRINT AT tx, ty; INK u(p, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
1640 NEXT p
1650 REM draw players
1660 FOR p = 1 TO t STEP 1
1670 GO SUB 2710
1680 GO SUB 2770
1690 NEXT p
1700 RETURN 
1710 REM console confirm
1720 PRINT #1; AT 1, 11; INK 6; "Confirm Y/N? "; FLASH 1; CHR$ (143);
1730 PAUSE 0
1740 LET k$ = INKEY$
1750 IF k$ = "y" OR k$ = "Y" THEN LET k$ = "Y": GO TO 1780
1760 IF k$ = "n" OR k$ = "N" THEN LET k$ = "N": GO TO 1780
1770 GO TO 1730
1780 PRINT #1; AT 1, 24; INK 6; k$;
1790 RETURN 
1800 REM console movement
1810 PRINT AT 17, 11; INK 5; "<Helm Computer>";
1820 PRINT AT 19, 11; "Speed A/B/C? "; FLASH 1; CHR$ (143);
1830 PRINT AT 20, 11; "[i] for instructions.";
1840 LET d(p, 9) = 1
1850 PAUSE 0 
1860 IF INKEY$= "A" OR INKEY$= "a" THEN LET d(p, 9) = 0 : LET k$ = "A": GO TO 1900
1870 IF INKEY$= "B" OR INKEY$= "b" THEN LET d(p, 9) = 5 : LET k$ = "B": GO TO 1900
1880 IF INKEY$= "C" OR INKEY$= "c" THEN LET d(p, 9) = 10 : LET k$ = "C": GO TO 1900
1890 IF INKEY$= "I" OR INKEY$= "i" THEN GO SUB 5700 : GO TO 1810
1900 IF d(p, 9) = 1 THEN GO TO 1850
1910 PRINT AT 19, 24; k$;
1920 PRINT AT 20, 11; "Movement 1-5? "; FLASH 1; CHR$ (143); FLASH 0; "      ";
1930 PAUSE 0
1940 LET k$ = INKEY$
1950 IF CODE (k$) < 49 OR CODE (k$) > 53 THEN GO TO 1930
1960 PRINT AT 20, 25; k$;
1970 LET d(p, 9) = d(p, 9) + VAL (k$) 
1980 RETURN 
1990 REM console attack
2000 PRINT AT 17, 11; INK 5; "<Combat Display>";
2010 PRINT AT 19, 11; "Distance A-F? "; FLASH 1; CHR$ (143); 
2020 PRINT AT 20, 11; "[i] for instructions.";
2030 LET d(p, 10) = 1
2040 PAUSE 0 
2050 IF INKEY$= "A" OR INKEY$= "a" THEN LET d(p, 10) = 0 : LET k$ = "A": GO TO 2120
2060 IF INKEY$= "B" OR INKEY$= "b" THEN LET d(p, 10) = 5 : LET k$ = "B": GO TO 2120
2070 IF INKEY$= "C" OR INKEY$= "c" THEN LET d(p, 10) = 10 : LET k$ = "C": GO TO 2120
2080 IF INKEY$= "D" OR INKEY$= "d" THEN LET d(p, 10) = 15 : LET k$ = "D": GO TO 2120
2090 IF INKEY$= "E" OR INKEY$= "e" THEN LET d(p, 10) = 20 : LET k$ = "E": GO TO 2120
2100 IF INKEY$= "F" OR INKEY$= "f" THEN LET d(p, 10) = 25 : LET k$ = "F": GO TO 2120
2110 IF INKEY$= "I" OR INKEY$= "i" THEN GO SUB 5900 : GO TO 2000
2120 IF d(p, 10) = 1 THEN GO TO 2040
2130 PRINT AT 19, 25; k$;
2140 PRINT AT 20, 11; "Arc 1-5? "; FLASH 1; CHR$ (143); FLASH 0; "           ";
2150 LET k$ = ""
2160 PAUSE 0
2170 LET k$ = INKEY$
2180 IF CODE (k$) < 49 OR CODE (k$) > 53 THEN GO TO 2160
2190 PRINT AT 20, 20; k$;
2200 LET d(p, 10) = d(p, 10) + VAL (k$) 
2210 RETURN 
2220 REM console any key
2230 PRINT #1; AT 1, 11; INK 6; "Press any key."; : PAUSE 0 : RETURN 
2240 REM draw common controls
2250 PRINT AT 0, 0; INK 5; "Combat";
2260 PRINT AT 1, 0; INK 5; "Display";
2270 PRINT AT 2, 1; "12345";
2280 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4";
2290 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2";
2300 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1";
2310 PRINT AT 6, 0; "D"; PAPER 6; "  "; AT 6, 4; PAPER 6; "  ";
2320 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  ";
2330 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " ";
2340 PRINT AT 9, 4; INK 6; "31";
2350 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
2360 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
2370 PRINT AT 18, 1; " "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
2380 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
2390 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
2400 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
2410 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
2420 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
2430 REM draw player controls and clear console
2440 INK u(p, 1)
2450 PRINT AT 0, 6; CHR$ (133); CHR$ (161);
2460 PRINT AT 1, 7; CHR$ (161);
2470 PRINT AT 2, 0; CHR$ (138); AT 2, 6; CHR$ (133); CHR$ (161);
2480 PRINT AT 3, 7; CHR$ (161);
2490 PRINT AT 4, 7; CHR$ (161);
2500 PRINT AT 5, 7; CHR$ (161);
2510 PRINT AT 6, 3; CHR$ (161); AT 6, 6; CHR$ (133); CHR$ (161);
2520 PRINT AT 7, 6; CHR$ (133); CHR$ (161);
2530 PRINT AT 8, 6; CHR$ (133); CHR$ (161);
2540 PRINT AT 9, 0; CHR$ (142); CHR$ (140); CHR$ (140); CHR$ (140); AT 9, 6; CHR$ (141); CHR$ (161);
2550 PRINT AT 10, 6; CHR$ (133); CHR$ (161);
2560 PRINT AT 11, 6; CHR$ (133); CHR$ (161);
2570 PRINT AT 12, 6; CHR$ (133); CHR$ (161);
2580 PRINT AT 13, 6; CHR$ (133); CHR$ (161);
2590 PRINT AT 14, 6; CHR$ (133); CHR$ (161);
2600 PRINT AT 15, 6; CHR$ (133); CHR$ (161);
2610 PRINT AT 16, 4; CHR$ (140); AT 16, 13; CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); INK 7; PAPER 0; "SPACE"; INK u(p, 1); CHR$ (140); INK 7; n$(p);
2620 PRINT AT 17, 10; CHR$ (138); "                     ";
2630 PRINT AT 18, 10; CHR$ (138); "                     ";
2640 PRINT AT 19, 10; CHR$ (138); "                     ";
2650 PRINT AT 20, 10; CHR$ (138); "                     ";
2660 PRINT AT 21, 10; CHR$ (138); "                     ";
2670 PRINT #1; AT 0, 10; INK u(p, 1); CHR$ (138); "                     ";
2680 PRINT #1; AT 1, 10; INK u(p, 1); CHR$ (138); "                     ";
2690 INK 4
2700 RETURN 
2710 REM draw player shields
2720 IF d(p, 8) < 1 THEN PRINT AT 10 + u(p, 5), 1 + u(p, 6); " "; AT 11 + u(p, 5), u(p, 6); "   "; AT 12 + u(p, 5), 1 + u(p, 6); " "; : RETURN 
2730 PRINT AT 10 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 4);
2740 PRINT AT 11 + u(p, 5), u(p, 6); INK u(p, 1); d(p, 7); INK 0; PAPER u(p, 1); d(p, 8); INK u(p, 1); PAPER 0; d(p, 5);
2750 PRINT AT 12 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 6);
2760 RETURN 
2770 REM draw player ship
2780 LET tx = (d(p, 1) - 1) * 2
2790 LET ty = ((d(p, 2) - 1) * 2) + 8
2800 IF d(p, 8) = 0 THEN PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; : RETURN 
2810 IF d(p, 3) = 0 THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (152); CHR$ (153); AT tx + 1, ty; CHR$ (150); CHR$ (151); : RETURN 
2820 IF d(p, 3) = 1 THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (156); AT tx + 1, ty; CHR$ (150); CHR$ (157); : RETURN 
2830 IF d(p, 3) = 2 THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (149); AT tx + 1, ty; CHR$ (154); CHR$ (155); : RETURN 
2840 PRINT AT tx, ty; INK u(p, 1); CHR$ (158); CHR$ (149); AT tx + 1, ty; CHR$ (159); CHR$ (151);
2850 RETURN 
2860 REM draw target explosion
2870 LET tx = (d(q, 1) - 1) * 2
2880 LET ty = ((d(q, 2) - 1) * 2) + 8
2890 PRINT AT tx, ty; INK 6; PAPER 2; FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
2900 RETURN 
2910 REM overlay and count targets
2920 LET i = 0 
2930 FOR q = 1 TO t STEP 1
2940 IF q = p OR d(q, 1) < 1 THEN GO TO 3020
2950 GO SUB 4960 : REM load tx, ty
2960 LET tx = tx + 4 : LET ty = ty + 3
2970 IF tx < 1 OR tx > 6 OR ty < 1 OR ty > 5 THEN GO TO 3020
2980 LET s = d(p, 3) + d(q, 3)
2990 IF s = 1 OR s = 3 OR s = 5 THEN PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (160); : GO TO 3010
3000 PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (161);
3010 IF a(((tx - 1) * 5) + ty, 3) > 0 THEN LET i = i + 1
3020 NEXT q
3030 RETURN 
3040 REM redraw screen
3050 CLS 
3060 GO SUB 2240
3070 LET q = p
3080 FOR i = 1 TO t STEP 1
3090 LET p = i
3100 IF d(p, 8) = 0 OR d(p, 1) < 1 THEN GO TO 3130
3110 GO SUB 2710
3120 GO SUB 2770
3130 NEXT i
3140 LET p = q
3150 GO SUB 2910
3160 FOR i = 1 TO 4 STEP 1
3170 LET tx = c(i, 1)
3180 LET ty = c(i, 2)
3190 PRINT AT tx, ty; INK u(i, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
3200 NEXT i
3210 RETURN 
3220 REM apply movement
3230 FOR p = 1 TO t STEP 1
3240 IF d(p, 1) < 1 THEN GO TO 3390
3250 IF d(p, 3) = 0 THEN LET x = d(p, 1) + m(d(p, 9), 1) : LET y = d(p, 2) + m(d(p, 9), 2) : GO TO 3290
3260 IF d(p, 3) = 1 THEN LET x = d(p, 1) + m(d(p, 9), 2) : LET y = d(p, 2) - m(d(p, 9), 1) : GO TO 3290
3270 IF d(p, 3) = 2 THEN LET x = d(p, 1) - m(d(p, 9), 1) : LET y = d(p, 2) - m(d(p, 9), 2) : GO TO 3290
3280 LET x = d(p, 1) - m(d(p, 9), 2) : LET y = d(p, 2) + m(d(p, 9), 1)
3290 IF x < 1 OR x > 8 OR y < 1 OR y > 12 THEN LET x = 0 : GO TO 3310
3300 GO SUB 3410
3310 LET l(d(p, 1), d(p, 2)) = 0 : REM clear map
3320 LET tx = (d(p, 1) - 1) * 2 : LET ty = ((d(p, 2) - 1) * 2) + 8 : REM clear screen pos 1
3330 LET d(p, 1) = x : LET d(p, 2) = y : REM update player
3340 LET d(p, 3) = d(p, 3) + m(d(p, 9), 3) : REM update dir
3350 IF d(p, 3) > 3 THEN LET d(p, 3) = d(p, 3) - 4 : GO TO 3370
3360 IF d(p, 3) < 0 THEN LET d(p, 3) = d(p, 3) + 4
3370 PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; : REM clear screen pos 2
3380 IF x > 0 THEN LET l(x, y) = p : GO SUB 2770
3390 NEXT p
3400 RETURN 
3410 REM planet collision check
3420 IF l(x, y) < 5 THEN RETURN 
3430 GO SUB 2240
3440 GO SUB 2910
3450 PRINT AT 17, 11; INK 2; "<Movement>";
3460 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " ram planet! x4";
3470 LET b = 4
3480 LET s = 4
3490 LET q = p
3500 GO SUB 5020
3510 IF d(p, 3) = 0 THEN LET x = x + 1 : GO TO 3550
3520 IF d(p, 3) = 1 THEN LET y = y - 1 : GO TO 3550
3530 IF d(p, 3) = 2 THEN LET x = x - 1 : GO TO 3550
3540 LET y = y + 1
3550 GO SUB 2710
3560 GO SUB 2220
3570 IF x > 0 THEN GO SUB 3410
3580 RETURN 
3590 REM player collision check
3600 FOR p = 1 TO t STEP 1
3610 IF d(p, 1) < 1 THEN GO TO 3860
3620 GO SUB 2770
3630 FOR q = 1 TO t STEP 1
3640 IF p = q OR d(q, 1) < 1 OR d(p, 1) <>d(q, 1) OR d(p, 2) <>d(q, 2) THEN GO TO 3850
3650 REM collision!
3660 GO SUB 2240
3670 PRINT AT 17, 11; INK 2; "<Movement>";
3680 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " ram "; INK u(q, 1); n$(q); INK 4; " x4";
3690 LET s = d(p, 3) - d(q, 3) + 6
3700 IF s > 7 THEN LET s = s - 4 : GO TO 3720
3710 IF s < 4 THEN LET s = s + 4
3720 LET b = 4
3730 GO SUB 5020
3740 LET tx = (d(p, 1) - 1) * 2
3750 LET ty = ((d(p, 2) - 1) * 2) + 8
3760 PRINT AT tx, ty; INK u(p, 1); PAPER u(q, 1); FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
3770 GO SUB 2220
3780 LET i = p
3790 LET p = q
3800 GO SUB 2710
3810 IF d(i, 8) = 0 THEN GO SUB 2770
3820 LET p = i
3830 IF d(q, 8) = 0 THEN GO SUB 2770
3840 IF d(p, 8) > 0 AND d(q, 8) > 0 AND p > q THEN GO SUB 3880
3850 NEXT q
3860 NEXT p
3870 RETURN 
3880 REM move one player
3890 GO SUB 2430
3900 LET x = d(i, 1)
3910 LET y = d(i, 2)
3920 LET tx = d(i, 1) - 1 + INT (RND* 2)
3930 LET ty = d(i, 2) - 1 + INT (RND* 2)
3940 IF tx < 1 OR tx > 8 OR ty < 1 OR ty > 12 THEN GO TO 3920
3950 IF l(tx, ty) > 0 THEN GO TO 3920
3960 REM choose winner
3970 IF INT RND* 3 > 2 THEN LET i = p : LET s = q : GO TO 4000
3980 LET i = q : LET s = p
3990 REM move player and update map
4000 LET d(i, 1) = tx : LET d(i, 2) = ty : LET l(tx, ty) = i : LET l(x, y) = s
4010 PRINT AT 17, 11; INK 2; "<Movement>";
4020 PRINT AT 18, 11; INK u(s, 1); n$(s); INK 4; " moves "; INK u(i, 1); n$(i) ; INK 4; "!";
4030 LET i = p : LET p = q : GO SUB 2770 : LET p = i : GO SUB 2770
4040 RETURN 
4050 REM off map check
4060 FOR p = 1 TO t STEP 1
4070 IF d(p, 8) < 1 OR d(p, 1) > 0 THEN GO TO 4130
4080 GO SUB 2240
4090 GO SUB 2910
4100 PRINT AT 17, 11; INK 2; "<Movement>";
4110 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " fall into the "; AT 19, 11; "void and are eaten"; AT 20, 11; "by a passing cosmic"; AT 21, 11; "horror.";
4120 LET d(p, 8) = 0 : GO SUB 2220
4130 NEXT p
4140 RETURN 
4150 REM player attack
4160 IF a(d(p, 10), 3) = 0 THEN LET s = 0 : GO TO 4540
4170 IF d(p, 3) = 0 THEN LET x = d(p, 1) + a(d(p, 10), 1) : LET y = d(p, 2) + a(d(p, 10), 2) : GO TO 4210
4180 IF d(p, 3) = 1 THEN LET x = d(p, 1) + a(d(p, 10), 2) : LET y = d(p, 2) - a(d(p, 10), 1) : GO TO 4210
4190 IF d(p, 3) = 2 THEN LET x = d(p, 1) - a(d(p, 10), 1) : LET y = d(p, 2) - a(d(p, 10), 2) : GO TO 4210
4200 LET x = d(p, 1) - a(d(p, 10), 2) : LET y = d(p, 2) + a(d(p, 10), 1) 
4210 LET s = 0
4220 PRINT AT 17, 11; INK 2; "<Combat>";
4230 FOR q = 1 TO t STEP 1
4240 IF d(q, 1) <>x OR d(q, 2) <>y OR d(q, 8) < 1 THEN GO TO 4530
4250 INK u(p, 1) : GO SUB 2630 : INK 4
4260 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " attack "; INK u(q, 1); n$(q); INK 4; " x"; a(d(p, 10), 3); 
4270 PAPER u(p, 1) 
4280 LET s = p
4290 LET p = q
4300 GO SUB 2770
4310 LET q = p
4320 LET p = s
4330 PAPER 0 
4340 REM resolve shield based on relative positions and q dir
4350 LET tx = d(p, 1) - d(q, 1)
4360 LET ty = d(p, 2) - d(q, 2)
4370 IF ABS tx > ABS ty AND tx > 0 THEN LET s = 6 : GO TO 4410
4380 IF ABS tx > ABS ty THEN LET s = 4 : GO TO 4410
4390 IF ty > 0 THEN LET s = 5 : GO TO 4410
4400 LET s = 7
4410 LET s = s - d(q, 3)
4420 IF s > 7 THEN LET s = s - 4 : GO TO 4440
4430 IF s < 4 THEN LET s = s + 4
4440 LET b = a(d(p, 10), 3)
4450 GO SUB 5020
4460 REM refresh attacked ship
4470 LET i = p
4480 LET p = q
4490 GO SUB 2710
4500 GO SUB 2220
4510 GO SUB 2770
4520 LET p = i
4530 NEXT q
4540 IF s = 0 THEN PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " do not attack.";
4550 RETURN 
4560 REM end game check
4570 LET i = 0
4580 LET q = 1
4590 FOR p = 1 TO t STEP 1
4600 IF d(p, 1) > 0 THEN LET q = p : LET i = i + 1
4610 NEXT p 
4620 REM still at least 2 players
4630 IF i > 1 THEN RETURN 
4640 REM ends game
4650 LET t = 0
4660 REM 1st player or winner colours
4670 LET p = q
4680 GO SUB 2240
4690 PRINT AT 17, 11; INK 2; "<GAME OVER>";
4700 IF i = 0 THEN PRINT AT 18, 11; "Everybody is dead."; : GO TO 4720
4710 PRINT AT 18, 11; INK u(p, 1); "SPACE "; n$(p); INK 4; " have won.";
4720 GO SUB 2220
4730 RETURN 
4740 REM resolve AI movement
4750 LET d(p, 9) = 0
4760 FOR q = 1 TO t STEP 1
4770 IF q = p OR d(q, 1) < 1 THEN GO TO 4810
4780 GO SUB 4960 : REM load tx, ty
4790 LET tx = tx + 4 : LET ty = ty + 3
4800 IF tx > 0 AND tx < 7 AND ty > 0 AND ty < 6 THEN LET d(p, 9) = v(tx, ty) : RETURN 
4810 NEXT q
4820 IF ty > -11 AND ty < 0 THEN LET d(p, 9) = 1 : RETURN 
4830 IF tx > 5 AND tx < 16 THEN LET d(p, 9) = 5 : RETURN 
4840 LET d(p, 9) = 3
4850 RETURN 
4860 REM resolve AI attack
4870 LET d(p, 10) = 0
4880 FOR q = 1 TO t STEP 1
4890 IF q = p OR d(q, 1) < 1 THEN GO TO 4930
4900 GO SUB 4960 : REM load tx, ty
4910 LET tx = tx + 4 : LET ty = ty + 3
4920 IF tx > 0 AND tx < 7 AND ty > 0 AND ty < 6 THEN LET d(p, 10) = ((tx - 1) * 5) + ty : RETURN 
4930 NEXT q
4940 IF d(p, 10) = 0 THEN LET d(p, 10) = 19
4950 RETURN 
4960 REM load tx, ty with target relative position
4970 IF d(p, 3) = 0 THEN LET tx = d(q, 1) - d(p, 1) : LET ty = d(q, 2) - d(p, 2) : RETURN 
4980 IF d(p, 3) = 1 THEN LET tx = d(p, 2) - d(q, 2) : LET ty = d(q, 1) - d(p, 1) : RETURN 
4990 IF d(p, 3) = 2 THEN LET tx = d(p, 1) - d(q, 1) : LET ty = d(p, 2) - d(q, 2) : RETURN 
5000 LET tx = d(q, 2) - d(p, 2) : LET ty = d(p, 1) - d(q, 1)
5010 RETURN 
5020 REM attack ship q *b
5030 LET tx = 19
5040 FOR i = 1 TO b STEP 1
5050 IF RND* 9 < 4 THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; : GO TO 5090
5060 IF d(q, s) > 0 THEN LET d(q, s) = d(q, s) - 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! "; s$(s - 3); " shields -1"; : GO TO 5090
5070 IF d(q, 8) > 1 THEN LET d(q, 8) = d(q, 8) - 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Hull -1"; : GO TO 5090
5080 IF d(q, 8) = 1 THEN LET d(q, 8) = 0 : PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Ship destroyed!"; : GO SUB 2860 : RETURN 
5090 LET tx = tx + 1
5100 NEXT i
5110 RETURN 
5120 REM attack vectors data
5130 DATA -3, -2, 4, -3, -1, 4, -3, 0, 4
5140 DATA -3, 1, 4, -3, 2, 4, -2, -2, 1
5150 DATA -2, -1, 2, -2, 0, 2, -2, 1, 2
5160 DATA -2, 2, 1, -1, -2, 1, -1, -1, 3
5170 DATA -1, 0, 1, -1, 1, 3, -1, 2, 1
5180 DATA 0, -2, 1, 0, -1, 3, 0, 0, 0
5190 DATA 0, 1, 3, 0, 2, 1, 1, -2, 1
5200 DATA 1, -1, 3, 1, 0, 0, 1, 1, 3
5210 DATA 1, 2, 1, 2, -2, 1, 2, -1, 0
5220 DATA 2, 0, 0, 2, 1, 0, 2, 2, 1
5230 REM movement vectors data
5240 DATA -2, -1, -1, -2, -1, 0, -2, 0, 0
5250 DATA -2, 1, 0, -2, 1, 1, -1, -1, -1
5260 DATA -1, -1, 0, -1, 0, 0, -1, 1, 0
5270 DATA -1, 1, 1, 0, 0, 0, 0, 0, -1
5280 DATA 0, 0, 0, 0, 0, 1, 0, 0, 0
5290 REM player UIs data
5300 DATA 1, 5, 1, 1, 0, 0
5310 DATA 2, 4, 5, 9, 3, 3
5320 DATA 3, 2, 1, 9, 0, 3
5330 DATA 6, 3, 5, 1, 3, 0
5340 REM player names data
5350 DATA "FLEET", "ELVES", "CHAOS", "HORDE"
5360 REM player data
5370 DATA 1, 1, 2, 3, 3, 3, 3, 4, 0, 0
5380 DATA 8, 12, 0, 3, 3, 3, 3, 4, 0, 0
5390 DATA 1, 12, 2, 3, 3, 3, 3, 4, 0, 0
5400 DATA 8, 1, 0, 3, 3, 3, 3, 4, 0, 0
5410 REM UDGs data
5420 DATA 0, 3, 15, 31, 63, 63, 127, 127
5430 DATA 0, 192, 240, 248, 252, 252, 254, 254 
5440 DATA 127, 127, 63, 63, 31, 15, 3, 0 
5450 DATA 254, 254, 252, 252, 248, 240, 192, 0
5460 DATA 0, 0, 0, 0, 1, 7, 7, 15
5470 DATA 0, 0, 0, 0, 128, 224, 224, 240 
5480 DATA 15, 7, 7, 1, 0, 0, 0, 0
5490 DATA 240, 224, 224, 128, 0, 0, 0, 0
5500 DATA 0, 0, 0, 5, 15, 7, 15, 7
5510 DATA 0, 0, 0, 160, 240, 224, 240, 224
5520 DATA 7, 15, 7, 15, 5, 0, 0, 0 
5530 DATA 224, 240, 224, 240, 160, 0, 0, 0 
5540 DATA 0, 0, 0, 0, 80, 248, 240, 248 
5550 DATA 248, 240, 248, 80, 0, 0, 0, 0 
5560 DATA 0, 0, 0, 0, 10, 31, 15, 31 
5570 DATA 31, 15, 31, 10, 0, 0, 0, 0 
5580 DATA 0, 0, 0, 60, 60, 0, 0, 0 
5590 DATA 0, 0, 24, 24, 24, 24, 0, 0 
5600 DATA 0, 0, 0, 0, 24, 0, 0, 0
5610 REM movement ai behaviour data
5620 DATA 1, 2, 3, 4, 5
5630 DATA 6, 7, 8, 9, 10
5640 DATA 12, 12, 14, 14, 14
5650 DATA 12, 12, 12, 14, 14
5660 DATA 12, 12, 14, 14, 14
5670 DATA 12, 12, 12, 14, 14
5680 REM shields
5690 DATA "Front", "Right", " Rear", " Left"
5700 REM helm computer instructions
5710 CLS 
5720 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE "; n$(p);"           ";
5730 PRINT AT 2, 0; "Note the direction of your ship and consult the "; INK 5; "Helm Computer"; INK 4; ".  You must select a speed A-C and a manoeuvre 1-5."
5740 PRINT AT 7, 0; "Example - A5 performs this move:"
5750 PRINT AT 9, 2; INK u(p, 1); CHR$ (148); CHR$ (156); AT 10, 2; CHR$ (150); CHR$ (157); INK 4; " Also...";
5760 PRINT AT 11, 5; "- Stay within map or die.";
5770 PRINT AT 12, 5; "- Avoid planets."
5780 PRINT AT 13, 0; INK u(p, 1); CHR$ (152); CHR$ (153); INK 4; "   - Optionally ram opponents."; AT 14, 0; INK u(p, 1); CHR$ (150); CHR$ (151);
5790 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
5800 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
5810 PRINT AT 18, 1; " "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
5820 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
5830 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
5840 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
5850 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
5860 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
5870 GO SUB 2220
5880 GO SUB 3040
5890 RETURN 
5900 REM combat display instructions
5910 CLS 
5920 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE "; n$(p);"           ";
5930 PRINT AT 2, 1; "12345  The "; INK 5; "Combat Display"; INK 4; " shows";
5940 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4"; INK 4; " enemies within range and";
5950 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2"; INK 4; " the A-F/1-5 combination";
5960 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1"; INK 4; " to attack. The number of";
5970 PRINT AT 6, 0; "D"; PAPER 6; "  "; INK u(p, 1); PAPER 0; CHR$ (161); AT 6, 4; PAPER 6; "  "; INK 4; PAPER 0; "  attacks correspond to";
5980 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  "; INK 4; PAPER 0; "  the "; INK 2; "red "; INK 4; "and "; INK 6; "yellow";
5990 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " "; INK 4; PAPER 0; "  numbers.";
6000 PRINT AT 9, 4; INK 6; "31";
6010 PRINT AT 11, 8; "A player has 4 shields";
6020 PRINT AT 12, 8; "and a hull. The "; INK 5; "Combat ";
6030 PRINT AT 13, 8; INK 5; "Display"; INK 4; " can be used to";
6040 PRINT AT 14, 8; "see which shield will be";
6050 PRINT AT 15, 8; "hit.";
6060 PRINT AT 17, 0; "The hull is damaged if there areno shields on the attacked side.When the hull reaches 0 the shipis destroyed.";
6070 GO SUB 2710
6080 GO SUB 2910
6090 GO SUB 2220
6100 GO SUB 3040
6110 RETURN 
6120 REM about SPACE FLEET
6130 CLS 
6140 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE FLEET           ";
6150 PRINT AT 1, 0; "       ";
6160 PRINT AT 2, 0; "In the grim darkness of the far future, there is only war.";
6170 PRINT AT 5, 0; "Select 2-4 human or AI players, and do turn-based battle using  the "; INK 5; "<Helm Computer>"; INK 4; " for movementand "; INK 5; "<Combat Display>"; INK 4; " to attack.";
6180 PRINT AT 10, 0; "Each are accessed via a console,through which further help is   available by entering [i]."
6190 PRINT AT 14, 0; INK 6; "Press any key to begin."
6200 PRINT #1; AT 0, 0; INK 1; CHR$ (152); CHR$ (153);
6210 PRINT #1; AT 0, 3; INK 2; CHR$ (148); CHR$ (156);
6220 PRINT #1; AT 0, 6; INK 3; CHR$ (148); CHR$ (149);
6230 PRINT #1; AT 0, 9; INK 6; CHR$ (158); CHR$ (149);
6240 PRINT #1; AT 0, 12; INK 5; CHR$ (144); CHR$ (145);
6250 PRINT #1; AT 0, 15; INK 4; CHR$ (144); CHR$ (145);
6260 PRINT #1; AT 0, 18; INK 2; CHR$ (144); CHR$ (145);
6270 PRINT #1; AT 0, 21; INK 3; CHR$ (144); CHR$ (145);
6280 PRINT #1; AT 1, 0; INK 1; CHR$ (150); CHR$ (151);
6290 PRINT #1; AT 1, 3; INK 2; CHR$ (150); CHR$ (157);
6300 PRINT #1; AT 1, 6; INK 3; CHR$ (154); CHR$ (155);
6310 PRINT #1; AT 1, 9; INK 6; CHR$ (159); CHR$ (151);
6320 PRINT #1; AT 1, 12; INK 5; CHR$ (146); CHR$ (147);
6330 PRINT #1; AT 1, 15; INK 4; CHR$ (146); CHR$ (147);
6340 PRINT #1; AT 1, 18; INK 2; CHR$ (146); CHR$ (147);
6350 PRINT #1; AT 1, 21; INK 3; CHR$ (146); CHR$ (147);
6360 PAUSE 0
6370 CLS 
6380 RETURN 