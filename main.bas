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
 280 FOR x = 1 TO 30 STEP 1
 290 FOR y = 1 TO 3 STEP 1
 300 READ a(x, y)
 310 NEXT y
 320 NEXT x
 330 REM load movement vectors
 340 FOR x = 1 TO 15 STEP 1
 350 FOR y = 1 TO 3 STEP 1
 360 READ m(x, y)
 370 NEXT y
 380 NEXT x
 390 REM load player UIs and names
 400 FOR x = 1 TO 4 STEP 1
 410 FOR y = 1 TO 6 STEP 1
 420 READ u(x, y)
 430 NEXT y
 440 NEXT x
 450 FOR x = 1 TO 4 STEP 1
 460 READ n$(x)
 470 NEXT x
 480 REM load UDGs
 490 LET i = USR "a"
 500 LET t = i+8*19-1
 510 FOR x = i TO t STEP 1
 520 READ y
 530 POKE x, y
 540 NEXT x
 550 REM load movement ai behaviours
 560 FOR x = 1 TO 6 STEP 1
 570 FOR y = 1 TO 5 STEP 1
 580 READ v(x, y)
 590 NEXT y
 600 NEXT x
 610 REM load shield names
 620 FOR x = 1 TO 4 STEP 1
 630 READ s$(x)
 640 NEXT x
 650 LET k$ = ""
 660 GO SUB 1110
 670 GO SUB 1650
 680 IF k$ <>"Y" THEN GO TO 660
 690 REM main game loop
 700 FOR p = 1 TO t STEP 1
 710 REM movement phase
 720 IF d(p, 1) = 0 THEN GO TO 810 : REM dead
 730 IF p > (t - u) THEN GO SUB 4870 : GO TO 800 : REM AI
 740 LET k$ = ""
 750 GO SUB 2180
 760 GO SUB 3020
 770 GO SUB 1740
 780 GO SUB 1650
 790 IF k$ <>"Y" THEN GO TO 740
 800 IF d(p, 11) = 1 THEN LET d(p, 11) = 0
 810 NEXT p
 820 REM apply movement
 830 GO SUB 3330
 840 GO SUB 3700
 850 GO SUB 4160
 860 GO SUB 5360
 870 REM combat phase
 880 FOR p = 1 TO t STEP 1
 890 IF d(p, 8) < 1 THEN GO TO 980 : REM dead
 900 IF p > (t - u) THEN GO SUB 5000 : GO TO 980 : REM AI
 910 LET k$ = ""
 920 GO SUB 2180
 930 GO SUB 3020
 940 IF i = 0 OR d(p, 11) = 2 THEN LET d(p, 11) = 2 : PRINT AT 17, 11; INK 2; "<Combat>"; AT 18, 11; INK u(p, 1); n$(p); INK 4; " cannot attack."; : GO TO 980
 950 GO SUB 1930
 960 GO SUB 1650
 970 IF k$ <>"Y" THEN GO TO 920
 980 IF d(p, 11) = 2 THEN LET d(p, 10) = 18 : LET d(p, 11) = 0 
 990 NEXT p
1000 REM apply combat
1010 FOR p = 1 TO t STEP 1
1020 IF d(p, 1) = 0 THEN GO TO 1060 : REM dead
1030 GO SUB 2180
1040 GO SUB 3020
1050 GO SUB 4280
1060 NEXT p 
1070 GO SUB 5360
1080 GO SUB 4690
1090 IF t > 0 THEN GO TO 700
1100 GO TO 660
1110 REM initialise game
1120 LET p = 1 : LET t = 0
1130 GO SUB 5840
1140 GO SUB 2180
1150 PRINT AT 17, 11; INK 5; "<SPACE FLEET>";
1160 PRINT AT 19, 11; "Enter players 2-4? "; FLASH 1; CHR$ (143);
1170 PAUSE 0
1180 LET k$ = INKEY$
1190 IF CODE (k$) < 50 OR CODE (k$) > 52 THEN GO TO 1170
1200 PRINT AT 19, 30; k$;
1210 LET t = VAL (k$)
1220 PRINT AT 20, 11; "AI players 0-"; t-1; "? "; FLASH 1; CHR$ (143);
1230 PAUSE 0
1240 LET k$ = INKEY$
1250 IF CODE (k$) < 48 OR CODE (k$) > 48+t-1 THEN GO TO 1230
1260 PRINT AT 20, 27; k$;
1270 LET u = VAL (k$)
1280 PRINT AT 21, 11; "Loading map...";
1290 REM clear map
1300 FOR y = 1 TO 12 STEP 1
1310 FOR x = 1 TO 8
1320 LET l(x, y) = 0
1330 NEXT x
1340 NEXT y 
1350 REM load player data
1360 RESTORE 6650
1370 FOR x = 1 TO t STEP 1
1380 FOR y = 1 TO 11 STEP 1
1390 READ d(x, y)
1400 NEXT y
1410 LET l(d(x, 1), d(x, 2)) = x : REM 1-4=player
1420 NEXT x
1430 REM generate planet locations
1440 RANDOMIZE 0
1450 FOR p = 1 TO 4 
1460 REM randomise planet locations
1470 LET x = INT (RND* 4) + u(p, 3)
1480 LET y = INT (RND* 4) + u(p, 4)
1490 REM avoid edges
1500 IF x < 2 OR x > 7 OR y < 2 OR y > 11 THEN GO TO 1460
1510 REM update map and draw planet
1520 LET l(x, y) = 4 + p : REM 5+=planet
1530 LET tx = (x - 1) * 2
1540 LET ty = ((y - 1) * 2) + 8
1550 LET c(p, 1) = tx
1560 LET c(p, 2) = ty
1570 PRINT AT tx, ty; INK u(p, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
1580 NEXT p
1590 REM draw players
1600 FOR p = 1 TO t STEP 1
1610 GO SUB 2820
1620 GO SUB 2880
1630 NEXT p
1640 RETURN 
1650 REM console confirm
1660 PRINT #1; AT 1, 11; INK 6; "Confirm Y/N? "; FLASH 1; CHR$ (143);
1670 PAUSE 0
1680 LET k$ = INKEY$
1690 IF k$ = "y" OR k$ = "Y" THEN LET k$ = "Y": GO TO 1720
1700 IF k$ = "n" OR k$ = "N" THEN LET k$ = "N": GO TO 1720
1710 GO TO 1670
1720 PRINT #1; AT 1, 24; INK 6; k$;
1730 RETURN 
1740 REM console movement
1750 PRINT AT 17, 11; INK 5; "<Helm Computer>";
1760 PRINT AT 19, 11; "Speed A/B/C? "; FLASH 1; CHR$ (143);
1770 PRINT AT 20, 11; "[i] for instructions.";
1780 LET d(p, 9) = 1
1790 PAUSE 0
1800 IF INKEY$= "I" OR INKEY$= "i" THEN GO SUB 5420 : GO TO 1750
1810 IF INKEY$= "C" OR INKEY$= "c" OR d(p, 11) = 1 THEN LET d(p, 9) = 10 : LET k$ = "C": GO TO 1840
1820 IF INKEY$= "B" OR INKEY$= "b" THEN LET d(p, 9) = 5 : LET k$ = "B": GO TO 1840
1830 IF INKEY$= "A" OR INKEY$= "a" THEN LET d(p, 9) = 0 : LET k$ = "A": GO TO 1840
1840 IF d(p, 9) = 1 THEN GO TO 1790
1850 PRINT AT 19, 24; k$;
1860 PRINT AT 20, 11; "Movement 1-5? "; FLASH 1; CHR$ (143); FLASH 0; "      ";
1870 PAUSE 0
1880 LET k$ = INKEY$
1890 IF CODE (k$) < 49 OR CODE (k$) > 53 THEN GO TO 1870
1900 PRINT AT 20, 25; k$;
1910 LET d(p, 9) = d(p, 9) + VAL (k$) 
1920 RETURN 
1930 REM console attack
1940 PRINT AT 17, 11; INK 5; "<Combat Display>";
1950 PRINT AT 19, 11; "Distance A-F? "; FLASH 1; CHR$ (143); 
1960 PRINT AT 20, 11; "[i] for instructions.";
1970 LET d(p, 10) = 1
1980 PAUSE 0 
1990 IF INKEY$= "A" OR INKEY$= "a" THEN LET d(p, 10) = 0 : LET k$ = "A": GO TO 2060
2000 IF INKEY$= "B" OR INKEY$= "b" THEN LET d(p, 10) = 5 : LET k$ = "B": GO TO 2060
2010 IF INKEY$= "C" OR INKEY$= "c" THEN LET d(p, 10) = 10 : LET k$ = "C": GO TO 2060
2020 IF INKEY$= "D" OR INKEY$= "d" THEN LET d(p, 10) = 15 : LET k$ = "D": GO TO 2060
2030 IF INKEY$= "E" OR INKEY$= "e" THEN LET d(p, 10) = 20 : LET k$ = "E": GO TO 2060
2040 IF INKEY$= "F" OR INKEY$= "f" THEN LET d(p, 10) = 25 : LET k$ = "F": GO TO 2060
2050 IF INKEY$= "I" OR INKEY$= "i" THEN GO SUB 5620 : GO TO 1940
2060 IF d(p, 10) = 1 THEN GO TO 1980
2070 PRINT AT 19, 25; k$;
2080 PRINT AT 20, 11; "Arc 1-5? "; FLASH 1; CHR$ (143); FLASH 0; "           ";
2090 LET k$ = ""
2100 PAUSE 0
2110 LET k$ = INKEY$
2120 IF CODE (k$) < 49 OR CODE (k$) > 53 THEN GO TO 2100
2130 PRINT AT 20, 20; k$;
2140 LET d(p, 10) = d(p, 10) + VAL (k$) 
2150 RETURN 
2160 REM console any key
2170 PRINT #1; AT 1, 11; INK 6; "Press any key."; : PAUSE 0 : RETURN 
2180 REM draw common controls
2190 PRINT AT 0, 0; INK 5; "Combat";
2200 PRINT AT 1, 0; INK 5; "Display";
2210 PRINT AT 2, 1; "12345";
2220 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4";
2230 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2";
2240 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1";
2250 PRINT AT 6, 0; "D"; PAPER 6; "  "; AT 6, 4; PAPER 6; "  ";
2260 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  ";
2270 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " ";
2280 PRINT AT 9, 4; INK 6; "31";
2290 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
2300 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
2310 PRINT AT 18, 0; "  "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
2320 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
2330 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
2340 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
2350 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
2360 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
2370 REM draw player controls and clear console
2380 INK u(p, 1)
2390 PRINT AT 0, 6; CHR$ (133); CHR$ (161);
2400 PRINT AT 1, 7; CHR$ (161);
2410 PRINT AT 2, 0; CHR$ (138); AT 2, 6; CHR$ (133); CHR$ (161);
2420 PRINT AT 3, 7; CHR$ (161);
2430 PRINT AT 4, 7; CHR$ (161);
2440 PRINT AT 5, 7; CHR$ (161);
2450 PRINT AT 6, 3; CHR$ (161); AT 6, 6; CHR$ (133); CHR$ (161);
2460 PRINT AT 7, 6; CHR$ (133); CHR$ (161);
2470 PRINT AT 8, 6; CHR$ (133); CHR$ (161);
2480 PRINT AT 9, 0; CHR$ (142); CHR$ (140); CHR$ (140); CHR$ (140); AT 9, 6; CHR$ (141); CHR$ (161);
2490 PRINT AT 10, 6; CHR$ (133); CHR$ (161);
2500 PRINT AT 11, 6; CHR$ (133); CHR$ (161);
2510 PRINT AT 12, 6; CHR$ (133); CHR$ (161);
2520 PRINT AT 13, 6; CHR$ (133); CHR$ (161);
2530 PRINT AT 14, 6; CHR$ (133); CHR$ (161);
2540 PRINT AT 15, 6; CHR$ (133); CHR$ (161);
2550 PRINT AT 16, 4; CHR$ (140); AT 16, 13; CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); INK 7; PAPER 0; "SPACE"; INK u(p, 1); CHR$ (140); INK 7; n$(p);
2560 PRINT AT 17, 10; CHR$ (138); "                     ";
2570 PRINT AT 18, 10; CHR$ (138); "                     ";
2580 PRINT AT 19, 10; CHR$ (138); "                     ";
2590 PRINT AT 20, 10; CHR$ (138); "                     ";
2600 PRINT AT 21, 10; CHR$ (138); "                     ";
2610 PRINT #1; AT 0, 10; INK u(p, 1); CHR$ (138); "                     ";
2620 PRINT #1; AT 1, 10; INK u(p, 1); CHR$ (138); "                     ";
2630 INK 4
2640 IF d(p, 11) = 1 THEN GO SUB 2670
2650 IF d(p, 11) = 2 THEN GO SUB 2740
2660 RETURN 
2670 REM engines damaged
2680 PRINT AT 17, 0; "          ";
2690 PRINT AT 18, 0; INK 2; "<WARNING> ";
2700 PRINT AT 19, 0; " ENGINES  ";
2710 PRINT AT 20, 0; " DAMAGED  ";
2720 PRINT AT 21, 0; "          ";
2730 RETURN 
2740 REM weapons damaged
2750 PRINT AT 3, 1; "     ";
2760 PRINT AT 4, 1; "     ";
2770 PRINT AT 5, 1; "     ";
2780 PRINT AT 6, 1; "  "; AT 6, 4; "  ";
2790 PRINT AT 7, 1; "     ";
2800 PRINT AT 8, 1; "     ";
2810 RETURN 
2820 REM draw player shields
2830 IF d(p, 8) < 1 THEN PRINT AT 10 + u(p, 5), 1 + u(p, 6); " "; AT 11 + u(p, 5), u(p, 6); "   "; AT 12 + u(p, 5), 1 + u(p, 6); " "; : RETURN 
2840 PRINT AT 10 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 4);
2850 PRINT AT 11 + u(p, 5), u(p, 6); INK u(p, 1); d(p, 7); INK 0; PAPER u(p, 1); d(p, 8); INK u(p, 1); PAPER 0; d(p, 5);
2860 PRINT AT 12 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 6);
2870 RETURN 
2880 REM draw player ship
2890 LET tx = (d(p, 1) - 1) * 2
2900 LET ty = ((d(p, 2) - 1) * 2) + 8
2910 IF d(p, 8) = 0 THEN PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; : RETURN 
2920 IF d(p, 3) = 0 THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (152); CHR$ (153); AT tx + 1, ty; CHR$ (150); CHR$ (151); : RETURN 
2930 IF d(p, 3) = 1 THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (156); AT tx + 1, ty; CHR$ (150); CHR$ (157); : RETURN 
2940 IF d(p, 3) = 2 THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (149); AT tx + 1, ty; CHR$ (154); CHR$ (155); : RETURN 
2950 PRINT AT tx, ty; INK u(p, 1); CHR$ (158); CHR$ (149); AT tx + 1, ty; CHR$ (159); CHR$ (151);
2960 RETURN 
2970 REM draw target explosion
2980 LET tx = (d(q, 1) - 1) * 2
2990 LET ty = ((d(q, 2) - 1) * 2) + 8
3000 PRINT AT tx, ty; INK 6; PAPER 2; FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
3010 RETURN 
3020 REM overlay and count targets
3030 LET i = 0 
3040 FOR q = 1 TO t STEP 1
3050 IF q = p OR d(q, 1) < 1 OR d(q, 8) < 1 THEN GO TO 3130
3060 GO SUB 5120 : REM load tx, ty
3070 LET tx = tx + 4 : LET ty = ty + 3
3080 IF tx < 1 OR tx > 6 OR ty < 1 OR ty > 5 THEN GO TO 3130
3090 LET s = d(p, 3) + d(q, 3)
3100 IF s = 1 OR s = 3 OR s = 5 THEN PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (160); : GO TO 3120
3110 PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (161);
3120 IF a(((tx - 1) * 5) + ty, 3) > 0 THEN LET i = i + 1
3130 NEXT q
3140 RETURN 
3150 REM redraw screen
3160 CLS 
3170 GO SUB 2180
3180 LET q = p
3190 FOR i = 1 TO t STEP 1
3200 LET p = i
3210 IF d(p, 8) = 0 OR d(p, 1) = 0 THEN GO TO 3240
3220 GO SUB 2820
3230 GO SUB 2880
3240 NEXT i
3250 LET p = q
3260 GO SUB 3020
3270 FOR i = 1 TO 4 STEP 1
3280 LET tx = c(i, 1)
3290 LET ty = c(i, 2)
3300 PRINT AT tx, ty; INK u(i, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
3310 NEXT i
3320 RETURN 
3330 REM apply movement
3340 FOR p = 1 TO t STEP 1
3350 IF d(p, 1) = 0 THEN GO TO 3500
3360 IF d(p, 3) = 0 THEN LET x = d(p, 1) + m(d(p, 9), 1) : LET y = d(p, 2) + m(d(p, 9), 2) : GO TO 3400
3370 IF d(p, 3) = 1 THEN LET x = d(p, 1) + m(d(p, 9), 2) : LET y = d(p, 2) - m(d(p, 9), 1) : GO TO 3400
3380 IF d(p, 3) = 2 THEN LET x = d(p, 1) - m(d(p, 9), 1) : LET y = d(p, 2) - m(d(p, 9), 2) : GO TO 3400
3390 LET x = d(p, 1) - m(d(p, 9), 2) : LET y = d(p, 2) + m(d(p, 9), 1)
3400 IF x < 1 OR x > 8 OR y < 1 OR y > 12 THEN LET x = 0 : GO TO 3420
3410 GO SUB 3520
3420 LET l(d(p, 1), d(p, 2)) = 0 : REM clear map
3430 LET tx = (d(p, 1) - 1) * 2 : LET ty = ((d(p, 2) - 1) * 2) + 8 : REM clear screen pos 1
3440 LET d(p, 1) = x : LET d(p, 2) = y : REM update player
3450 LET d(p, 3) = d(p, 3) + m(d(p, 9), 3) : REM update dir
3460 IF d(p, 3) > 3 THEN LET d(p, 3) = d(p, 3) - 4 : GO TO 3480
3470 IF d(p, 3) < 0 THEN LET d(p, 3) = d(p, 3) + 4
3480 PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; : REM clear screen pos 2
3490 IF x > 0 THEN LET l(x, y) = p : GO SUB 2880
3500 NEXT p
3510 RETURN 
3520 REM planet collision check
3530 IF l(x, y) < 5 THEN RETURN 
3540 GO SUB 2180
3550 GO SUB 3020
3560 PRINT AT 17, 11; INK 2; "<Movement>";
3570 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " ram planet! x4";
3580 LET b = 4
3590 LET s = 4
3600 LET q = p
3610 GO SUB 5180
3620 IF d(p, 3) = 0 THEN LET x = x + 1 : GO TO 3660
3630 IF d(p, 3) = 1 THEN LET y = y - 1 : GO TO 3660
3640 IF d(p, 3) = 2 THEN LET x = x - 1 : GO TO 3660
3650 LET y = y + 1
3660 GO SUB 2820
3670 GO SUB 2160
3680 IF x > 0 THEN GO SUB 3520
3690 RETURN 
3700 REM player collision check
3710 FOR p = 1 TO t STEP 1
3720 IF d(p, 1) = 0 THEN GO TO 3970
3730 GO SUB 2880
3740 FOR q = 1 TO t STEP 1
3750 IF p = q OR d(q, 1) = 0 OR d(p, 1) <>d(q, 1) OR d(p, 2) <>d(q, 2) THEN GO TO 3960
3760 REM collision!
3770 GO SUB 2180
3780 PRINT AT 17, 11; INK 2; "<Movement>";
3790 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " ram "; INK u(q, 1); n$(q); INK 4; " x4";
3800 LET s = d(p, 3) - d(q, 3) + 6
3810 IF s > 7 THEN LET s = s - 4 : GO TO 3830
3820 IF s < 4 THEN LET s = s + 4
3830 LET b = 4
3840 GO SUB 5180
3850 LET tx = (d(p, 1) - 1) * 2
3860 LET ty = ((d(p, 2) - 1) * 2) + 8
3870 PRINT AT tx, ty; INK u(p, 1); PAPER u(q, 1); FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
3880 GO SUB 2160
3890 LET i = p
3900 LET p = q
3910 GO SUB 2820
3920 IF d(i, 8) = 0 THEN GO SUB 2880
3930 LET p = i
3940 IF d(q, 8) = 0 THEN GO SUB 2880
3950 IF d(p, 8) > 0 AND d(q, 8) > 0 AND p > q THEN GO SUB 3990
3960 NEXT q
3970 NEXT p
3980 RETURN 
3990 REM move one player
4000 GO SUB 2370
4010 LET x = d(i, 1)
4020 LET y = d(i, 2)
4030 LET tx = d(i, 1) - 1 + INT (RND* 2)
4040 LET ty = d(i, 2) - 1 + INT (RND* 2)
4050 IF tx < 1 OR tx > 8 OR ty < 1 OR ty > 12 THEN GO TO 4030
4060 IF l(tx, ty) > 0 THEN GO TO 4030
4070 REM choose winner
4080 IF INT RND* 3 > 2 THEN LET i = p : LET s = q : GO TO 4110
4090 LET i = q : LET s = p
4100 REM move player and update map
4110 LET d(i, 1) = tx : LET d(i, 2) = ty : LET l(tx, ty) = i : LET l(x, y) = s
4120 PRINT AT 17, 11; INK 2; "<Movement>";
4130 PRINT AT 18, 11; INK u(s, 1); n$(s); INK 4; " moves "; INK u(i, 1); n$(i) ; INK 4; "!";
4140 LET i = p : LET p = q : GO SUB 2880 : LET p = i : GO SUB 2880
4150 RETURN 
4160 REM off map check
4170 FOR p = 1 TO t STEP 1
4180 IF d(p, 8) < 1 OR d(p, 1) > 0 THEN GO TO 4260
4190 GO SUB 2180
4200 GO SUB 3020
4210 PRINT AT 17, 11; INK 2; "<Movement>";
4220 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " fall into the "; AT 19, 11; "void and are eaten"; AT 20, 11; "by a passing cosmic"; AT 21, 11; "horror.";
4230 LET d(p, 8) = 0
4240 GO SUB 2820
4250 GO SUB 2160
4260 NEXT p
4270 RETURN 
4280 REM player attack
4290 PRINT AT 17, 11; INK 2; "<Combat>";
4300 IF a(d(p, 10), 3) = 0 THEN LET s = 0 : GO TO 4670
4310 IF d(p, 3) = 0 THEN LET x = d(p, 1) + a(d(p, 10), 1) : LET y = d(p, 2) + a(d(p, 10), 2) : GO TO 4350
4320 IF d(p, 3) = 1 THEN LET x = d(p, 1) + a(d(p, 10), 2) : LET y = d(p, 2) - a(d(p, 10), 1) : GO TO 4350
4330 IF d(p, 3) = 2 THEN LET x = d(p, 1) - a(d(p, 10), 1) : LET y = d(p, 2) - a(d(p, 10), 2) : GO TO 4350
4340 LET x = d(p, 1) - a(d(p, 10), 2) : LET y = d(p, 2) + a(d(p, 10), 1) 
4350 LET s = 0
4360 FOR q = 1 TO t STEP 1
4370 IF d(q, 1) <>x OR d(q, 2) <>y OR d(q, 8) < 1 THEN GO TO 4660
4380 INK u(p, 1) : GO SUB 2570 : INK 4
4390 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " attack "; INK u(q, 1); n$(q); INK 4; " x"; a(d(p, 10), 3); 
4400 PAPER u(p, 1) 
4410 LET s = p
4420 LET p = q
4430 GO SUB 2880
4440 LET q = p
4450 LET p = s
4460 PAPER 0 
4470 REM resolve shield based on relative positions and q dir
4480 LET tx = d(p, 1) - d(q, 1)
4490 LET ty = d(p, 2) - d(q, 2)
4500 IF ABS tx > ABS ty AND tx > 0 THEN LET s = 6 : GO TO 4540
4510 IF ABS tx > ABS ty THEN LET s = 4 : GO TO 4540
4520 IF ty > 0 THEN LET s = 5 : GO TO 4540
4530 LET s = 7
4540 LET s = s - d(q, 3)
4550 IF s > 7 THEN LET s = s - 4 : GO TO 4570
4560 IF s < 4 THEN LET s = s + 4
4570 LET b = a(d(p, 10), 3)
4580 GO SUB 5180
4590 REM refresh attacked ship
4600 LET i = p
4610 LET p = q
4620 GO SUB 2820
4630 GO SUB 2160
4640 GO SUB 2880
4650 LET p = i
4660 NEXT q
4670 IF s = 0 THEN PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " do not attack.";
4680 RETURN 
4690 REM end game check
4700 LET i = 0
4710 LET q = 1
4720 FOR p = 1 TO t STEP 1
4730 IF d(p, 1) > 0 THEN LET q = p : LET i = i + 1
4740 NEXT p 
4750 REM still at least 2 players
4760 IF i > 1 THEN RETURN 
4770 REM ends game
4780 LET t = 0
4790 REM 1st player or winner colours
4800 LET p = q
4810 GO SUB 2180
4820 PRINT AT 17, 11; INK 2; "<GAME OVER>";
4830 IF i = 0 THEN PRINT AT 18, 11; "Everybody is dead."; : GO TO 4850
4840 PRINT AT 18, 11; INK u(p, 1); "SPACE "; n$(p); INK 4; " have won.";
4850 GO SUB 2160
4860 RETURN 
4870 REM resolve AI movement
4880 LET d(p, 9) = 13
4890 IF d(p, 11) = 1 THEN RETURN 
4900 FOR q = 1 TO t STEP 1
4910 IF q = p OR d(q, 1) < 1 THEN GO TO 4950
4920 GO SUB 5120 : REM load tx, ty
4930 LET tx = tx + 4 : LET ty = ty + 3
4940 IF tx > 0 AND tx < 7 AND ty > 0 AND ty < 6 THEN LET d(p, 9) = v(tx, ty) : RETURN 
4950 NEXT q
4960 IF ty > -11 AND ty < 0 THEN LET d(p, 9) = 1 : RETURN 
4970 IF tx > 5 AND tx < 16 THEN LET d(p, 9) = 5 : RETURN 
4980 LET d(p, 9) = 3
4990 RETURN 
5000 REM resolve AI attack
5010 LET b = 18
5020 LET d(p, 10) = 18
5030 FOR q = 1 TO t STEP 1
5040 IF q = p OR d(q, 1) < 1 THEN GO TO 5100
5050 GO SUB 5120 : REM load tx, ty
5060 LET tx = tx + 4
5070 LET ty = ty + 3
5080 IF tx > 0 AND tx < 7 AND ty > 0 AND ty < 6 THEN LET b = ((tx - 1) * 5) + ty
5090 IF a(b, 3) > a(d(p, 10), 3) THEN LET d(p, 10) = b
5100 NEXT q
5110 RETURN 
5120 REM load tx, ty with target relative position
5130 IF d(p, 3) = 0 THEN LET tx = d(q, 1) - d(p, 1) : LET ty = d(q, 2) - d(p, 2) : RETURN 
5140 IF d(p, 3) = 1 THEN LET tx = d(p, 2) - d(q, 2) : LET ty = d(q, 1) - d(p, 1) : RETURN 
5150 IF d(p, 3) = 2 THEN LET tx = d(p, 1) - d(q, 1) : LET ty = d(p, 2) - d(q, 2) : RETURN 
5160 LET tx = d(q, 2) - d(p, 2) : LET ty = d(p, 1) - d(q, 1)
5170 RETURN 
5180 REM attack ship q *b
5190 LET tx = 19
5200 FOR i = 1 TO b STEP 1
5210 IF RND* 9 < 4 THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; : GO TO 5330
5220 IF d(q, 8) = 1 OR RND* 6 > 1 THEN GO TO 5300
5230 IF d(q, s) > 1 AND RND* 6 > 5 THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT! "; INK 4; s$(s - 3); " shields -"; d(q, s); : LET d(q, s) = 0 : GO TO 5320
5240 IF d(q, s) > 0 AND RND* 6 > 5 THEN LET d(q, 8) = d(q, 8) - 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT!"; INK 4; " Hull -1"; : GO TO 5320
5250 IF d(q, 11) > 0 THEN GO TO 5300
5260 IF d(q, s) > 0 THEN LET d(q, s) = d(q, s) - 1 : GO TO 5280
5270 LET d(q, 8) = d(q, 8) - 1
5280 IF RND* 6 > 3 THEN LET d(q, 11) = 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT!"; INK 4; " Engines damaged."; : GO TO 5320
5290 LET d(q, 11) = 2 : PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT!"; INK 4; " Weapons damaged."; : GO TO 5320
5300 IF d(q, s) > 0 THEN LET d(q, s) = d(q, s) - 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! "; s$(s - 3); " shields -1"; : GO TO 5320
5310 IF d(q, 8) > 0 THEN LET d(q, 8) = d(q, 8) - 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Hull -1"; : GO TO 5320
5320 IF d(q, 8) = 0 THEN PRINT #FN s(tx); AT FN x(tx), 16; INK 4; "Ship destroyed!"; : GO SUB 2970 : RETURN 
5330 LET tx = tx + 1
5340 NEXT i
5350 RETURN 
5360 REM move destroyed ships off map
5370 FOR p = 1 TO t STEP 1
5380 REM if ship on map and 0 hull move off map
5390 IF d(p, 1) > 0 AND d(p, 8) < 1 THEN LET l(d(p, 1), d(p, 2)) = 0 : LET d(p, 1) = 0
5400 NEXT p
5410 RETURN 
5420 REM helm computer instructions
5430 CLS 
5440 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE "; n$(p);"           ";
5450 PRINT AT 2, 0; "Note the direction of your ship and consult the "; INK 5; "Helm Computer"; INK 4; ".  You must select a speed A-C and a manoeuvre 1-5."
5460 PRINT AT 7, 0; "Example - A5 performs this move:"
5470 PRINT AT 9, 2; INK u(p, 1); CHR$ (148); CHR$ (156); AT 10, 2; CHR$ (150); CHR$ (157); INK 4; " Also...";
5480 PRINT AT 11, 5; "- Stay within map or die.";
5490 PRINT AT 12, 5; "- Avoid planets."
5500 PRINT AT 13, 0; INK u(p, 1); CHR$ (152); CHR$ (153); INK 4; "   - Optionally ram opponents."; AT 14, 0; INK u(p, 1); CHR$ (150); CHR$ (151);
5510 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
5520 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
5530 PRINT AT 18, 1; " "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
5540 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
5550 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
5560 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
5570 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
5580 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
5590 GO SUB 2160
5600 GO SUB 3150
5610 RETURN 
5620 REM combat display instructions
5630 CLS 
5640 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE "; n$(p);"           ";
5650 PRINT AT 2, 1; "12345  The "; INK 5; "Combat Display"; INK 4; " shows";
5660 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4"; INK 4; " enemies within range and";
5670 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2"; INK 4; " the A-F/1-5 combination";
5680 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1"; INK 4; " to attack. The number of";
5690 PRINT AT 6, 0; "D"; PAPER 6; "  "; INK u(p, 1); PAPER 0; CHR$ (161); AT 6, 4; PAPER 6; "  "; INK 4; PAPER 0; "  attacks correspond to";
5700 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  "; INK 4; PAPER 0; "  the "; INK 2; "red "; INK 4; "and "; INK 6; "yellow";
5710 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " "; INK 4; PAPER 0; "  numbers.";
5720 PRINT AT 9, 4; INK 6; "31";
5730 PRINT AT 11, 8; "A player has 4 shields";
5740 PRINT AT 12, 8; "and a hull. The "; INK 5; "Combat ";
5750 PRINT AT 13, 8; INK 5; "Display"; INK 4; " can be used to";
5760 PRINT AT 14, 8; "see which shield will be";
5770 PRINT AT 15, 8; "hit.";
5780 PRINT AT 17, 0; "The hull is damaged if there areno shields on the attacked side.When the hull reaches 0 the shipis destroyed.";
5790 GO SUB 2820
5800 GO SUB 3020
5810 GO SUB 2160
5820 GO SUB 3150
5830 RETURN 
5840 REM about SPACE FLEET
5850 CLS 
5860 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE FLEET           ";
5870 PRINT AT 1, 0; "       ";
5880 PRINT AT 2, 0; "In the grim darkness of the far future, there is only war.";
5890 PRINT AT 5, 0; "Select 2-4 human or AI players, and do turn-based battle using  the "; INK 5; "<Helm Computer>"; INK 4; " for movementand "; INK 5; "<Combat Display>"; INK 4; " to attack.";
5900 PRINT AT 10, 0; "Each are accessed via a console,through which further help is   available by entering [i]."
5910 PRINT AT 14, 0; INK 6; "Press any key to begin."
5920 PRINT #1; AT 0, 0; INK 1; CHR$ (152); CHR$ (153);
5930 PRINT #1; AT 0, 3; INK 2; CHR$ (148); CHR$ (156);
5940 PRINT #1; AT 0, 6; INK 3; CHR$ (148); CHR$ (149);
5950 PRINT #1; AT 0, 9; INK 6; CHR$ (158); CHR$ (149);
5960 PRINT #1; AT 0, 12; INK 5; CHR$ (144); CHR$ (145);
5970 PRINT #1; AT 0, 15; INK 4; CHR$ (144); CHR$ (145);
5980 PRINT #1; AT 0, 18; INK 2; CHR$ (144); CHR$ (145);
5990 PRINT #1; AT 0, 21; INK 3; CHR$ (144); CHR$ (145);
6000 PRINT #1; AT 1, 0; INK 1; CHR$ (150); CHR$ (151);
6010 PRINT #1; AT 1, 3; INK 2; CHR$ (150); CHR$ (157);
6020 PRINT #1; AT 1, 6; INK 3; CHR$ (154); CHR$ (155);
6030 PRINT #1; AT 1, 9; INK 6; CHR$ (159); CHR$ (151);
6040 PRINT #1; AT 1, 12; INK 5; CHR$ (146); CHR$ (147);
6050 PRINT #1; AT 1, 15; INK 4; CHR$ (146); CHR$ (147);
6060 PRINT #1; AT 1, 18; INK 2; CHR$ (146); CHR$ (147);
6070 PRINT #1; AT 1, 21; INK 3; CHR$ (146); CHR$ (147);
6080 PAUSE 0
6090 CLS 
6100 RETURN 
6110 REM attack vectors data
6120 DATA -3, -2, 4, -3, -1, 4, -3, 0, 4
6130 DATA -3, 1, 4, -3, 2, 4, -2, -2, 1
6140 DATA -2, -1, 2, -2, 0, 2, -2, 1, 2
6150 DATA -2, 2, 1, -1, -2, 1, -1, -1, 3
6160 DATA -1, 0, 1, -1, 1, 3, -1, 2, 1
6170 DATA 0, -2, 1, 0, -1, 3, 0, 0, 0
6180 DATA 0, 1, 3, 0, 2, 1, 1, -2, 1
6190 DATA 1, -1, 3, 1, 0, 0, 1, 1, 3
6200 DATA 1, 2, 1, 2, -2, 1, 2, -1, 0
6210 DATA 2, 0, 0, 2, 1, 0, 2, 2, 1
6220 REM movement vectors data
6230 DATA -2, -1, -1, -2, -1, 0, -2, 0, 0
6240 DATA -2, 1, 0, -2, 1, 1, -1, -1, -1
6250 DATA -1, -1, 0, -1, 0, 0, -1, 1, 0
6260 DATA -1, 1, 1, 0, 0, 0, 0, 0, -1
6270 DATA 0, 0, 0, 0, 0, 1, 0, 0, 0
6280 REM player UIs data
6290 DATA 1, 5, 1, 1, 0, 0
6300 DATA 2, 4, 5, 9, 3, 3
6310 DATA 3, 2, 1, 9, 0, 3
6320 DATA 6, 3, 5, 1, 3, 0
6330 REM player names data
6340 DATA "FLEET", "ELVES", "CHAOS", "HORDE"
6350 REM UDGs data
6360 DATA 0, 3, 15, 31, 63, 63, 127, 127
6370 DATA 0, 192, 240, 248, 252, 252, 254, 254 
6380 DATA 127, 127, 63, 63, 31, 15, 3, 0 
6390 DATA 254, 254, 252, 252, 248, 240, 192, 0
6400 DATA 0, 0, 0, 0, 1, 7, 7, 15
6410 DATA 0, 0, 0, 0, 128, 224, 224, 240 
6420 DATA 15, 7, 7, 1, 0, 0, 0, 0
6430 DATA 240, 224, 224, 128, 0, 0, 0, 0
6440 DATA 0, 0, 0, 5, 15, 7, 15, 7
6450 DATA 0, 0, 0, 160, 240, 224, 240, 224
6460 DATA 7, 15, 7, 15, 5, 0, 0, 0 
6470 DATA 224, 240, 224, 240, 160, 0, 0, 0 
6480 DATA 0, 0, 0, 0, 80, 248, 240, 248 
6490 DATA 248, 240, 248, 80, 0, 0, 0, 0 
6500 DATA 0, 0, 0, 0, 10, 31, 15, 31 
6510 DATA 31, 15, 31, 10, 0, 0, 0, 0 
6520 DATA 0, 0, 0, 60, 60, 0, 0, 0 
6530 DATA 0, 0, 24, 24, 24, 24, 0, 0 
6540 DATA 0, 0, 0, 0, 24, 0, 0, 0
6550 REM movement ai behaviour data
6560 DATA 1, 2, 3, 4, 5
6570 DATA 6, 7, 8, 9, 10
6580 DATA 12, 12, 14, 14, 14
6590 DATA 12, 12, 12, 14, 14
6600 DATA 12, 12, 14, 14, 14
6610 DATA 12, 12, 12, 14, 14
6620 REM shields
6630 DATA "Front", "Right", " Rear", " Left"
6640 REM player data
6650 DATA 1, 1, 2, 3, 3, 3, 3, 4, 0, 0, 0
6660 DATA 8, 12, 0, 3, 3, 3, 3, 4, 0, 0, 0
6670 DATA 1, 12, 2, 3, 3, 3, 3, 4, 0, 0, 0
6680 DATA 8, 1, 0, 3, 3, 3, 3, 4, 0, 0, 0
