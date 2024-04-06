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
 280 RESTORE 5420
 290 FOR x = 1 TO 30 STEP 1
 300 FOR y = 1 TO 3 STEP 1
 310 READ a(x, y)
 320 NEXT y
 330 NEXT x
 340 REM load movement vectors
 350 RESTORE 5530
 360 FOR x = 1 TO 15 STEP 1
 370 FOR y = 1 TO 3 STEP 1
 380 READ m(x, y)
 390 NEXT y
 400 NEXT x
 410 REM load player UIs, names and shields
 420 RESTORE 5590
 430 FOR x = 1 TO 4 STEP 1
 440 FOR y = 1 TO 6 STEP 1
 450 READ u(x, y)
 460 NEXT y
 470 NEXT x
 480 RESTORE 5640
 490 FOR x = 1 TO 4 STEP 1
 500 READ n$(x)
 510 NEXT x
 520 RESTORE 5980
 530 FOR x = 1 TO 4 STEP 1
 540 READ s$(x)
 550 NEXT x
 560 REM load movement ai behaviours
 570 RESTORE 5910
 580 FOR x = 1 TO 6 STEP 1
 590 FOR y = 1 TO 5 STEP 1
 600 READ v(x, y)
 610 NEXT y
 620 NEXT x
 630 REM load UDGs
 640 LET i = USR "a"
 650 LET t = i+8*19-1
 660 RESTORE 5710
 670 FOR x = i TO t STEP 1
 680 READ y
 690 POKE x, y
 700 NEXT x
 710 LET k$ = ""
 720 GO SUB 1180
 730 GO SUB 1720
 740 IF k$ <>"Y" THEN GO TO 720
 750 REM main game loop
 760 FOR p = 1 TO t STEP 1
 770 REM movement phase
 780 IF d(p, 1) = 0 THEN GO TO 870 : REM dead
 790 IF p > (t - u) THEN GO SUB 4940 : GO TO 860 : REM AI
 800 LET k$ = ""
 810 GO SUB 2250
 820 GO SUB 3090
 830 GO SUB 1810
 840 GO SUB 1720
 850 IF k$ <>"Y" THEN GO TO 800
 860 IF d(p, 11) = 1 THEN LET d(p, 11) = 0
 870 NEXT p
 880 REM apply movement
 890 GO SUB 3400
 900 GO SUB 3770
 910 GO SUB 4230
 920 REM combat phase
 930 FOR p = 1 TO t STEP 1
 940 IF d(p, 8) < 1 THEN GO TO 1030 : REM dead
 950 IF p > (t - u) THEN GO SUB 5070 : GO TO 1030 : REM AI
 960 LET k$ = ""
 970 GO SUB 2250
 980 GO SUB 3090
 990 IF i = 0 OR d(p, 11) = 2 THEN LET d(p, 11) = 2 : PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " cannot attack."; : GO TO 1030
1000 GO SUB 2000
1010 GO SUB 1720
1020 IF k$ <>"Y" THEN GO TO 970
1030 IF d(p, 11) = 2 THEN LET d(p, 10) = 18 : LET d(p, 11) = 0 
1040 NEXT p
1050 REM apply combat
1060 FOR p = 1 TO t STEP 1
1070 REM if ship on map
1080 IF d(p, 1) > 0 THEN GO SUB 2250 : GO SUB 3090 : GO SUB 4350
1090 NEXT p 
1100 REM move killed ships off map
1110 FOR p = 1 TO t STEP 1
1120 REM if ship on map and 0 hull move off map
1130 IF d(p, 1) > 0 AND d(p, 8) < 1 THEN LET l(d(p, 1), d(p, 2)) = 0 : LET d(p, 1) = 0
1140 NEXT p
1150 GO SUB 4760
1160 IF t > 0 THEN GO TO 760
1170 GO TO 720
1180 REM initialise game
1190 LET p = 1 : LET t = 0
1200 GO SUB 6410
1210 GO SUB 2250
1220 PRINT AT 17, 11; INK 5; "<SPACE FLEET>";
1230 PRINT AT 19, 11; "Enter players 2-4? "; FLASH 1; CHR$ (143);
1240 PAUSE 0
1250 LET k$ = INKEY$
1260 IF CODE (k$) < 50 OR CODE (k$) > 52 THEN GO TO 1240
1270 PRINT AT 19, 30; k$;
1280 LET t = VAL (k$)
1290 PRINT AT 20, 11; "AI players 0-"; t-1; "? "; FLASH 1; CHR$ (143);
1300 PAUSE 0
1310 LET k$ = INKEY$
1320 IF CODE (k$) < 48 OR CODE (k$) > 48+t-1 THEN GO TO 1300
1330 PRINT AT 20, 27; k$;
1340 LET u = VAL (k$)
1350 PRINT AT 21, 11; "Loading map...";
1360 REM clear map
1370 FOR y = 1 TO 12 STEP 1
1380 FOR x = 1 TO 8
1390 LET l(x, y) = 0
1400 NEXT x
1410 NEXT y 
1420 REM load player data
1430 RESTORE 5660
1440 FOR x = 1 TO t STEP 1
1450 FOR y = 1 TO 11 STEP 1
1460 READ d(x, y)
1470 NEXT y
1480 LET l(d(x, 1), d(x, 2)) = x : REM 1-4=player
1490 NEXT x
1500 REM generate planet locations
1510 RANDOMIZE 0
1520 FOR p = 1 TO 4 
1530 REM randomise planet locations
1540 LET x = INT (RND* 4) + u(p, 3)
1550 LET y = INT (RND* 4) + u(p, 4)
1560 REM avoid edges
1570 IF x < 2 OR x > 7 OR y < 2 OR y > 11 THEN GO TO 1530
1580 REM update map and draw planet
1590 LET l(x, y) = 4 + p : REM 5+=planet
1600 LET tx = (x - 1) * 2
1610 LET ty = ((y - 1) * 2) + 8
1620 LET c(p, 1) = tx
1630 LET c(p, 2) = ty
1640 PRINT AT tx, ty; INK u(p, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
1650 NEXT p
1660 REM draw players
1670 FOR p = 1 TO t STEP 1
1680 GO SUB 2890
1690 GO SUB 2950
1700 NEXT p
1710 RETURN 
1720 REM console confirm
1730 PRINT #1; AT 1, 11; INK 6; "Confirm Y/N? "; FLASH 1; CHR$ (143);
1740 PAUSE 0
1750 LET k$ = INKEY$
1760 IF k$ = "y" OR k$ = "Y" THEN LET k$ = "Y": GO TO 1790
1770 IF k$ = "n" OR k$ = "N" THEN LET k$ = "N": GO TO 1790
1780 GO TO 1740
1790 PRINT #1; AT 1, 24; INK 6; k$;
1800 RETURN 
1810 REM console movement
1820 PRINT AT 17, 11; INK 5; "<Helm Computer>";
1830 PRINT AT 19, 11; "Speed A/B/C? "; FLASH 1; CHR$ (143);
1840 PRINT AT 20, 11; "[i] for instructions.";
1850 LET d(p, 9) = 1
1860 PAUSE 0
1870 IF INKEY$= "I" OR INKEY$= "i" THEN GO SUB 5990 : GO TO 1820
1880 IF INKEY$= "C" OR INKEY$= "c" OR d(p, 11) = 1 THEN LET d(p, 9) = 10 : LET k$ = "C": GO TO 1910
1890 IF INKEY$= "B" OR INKEY$= "b" THEN LET d(p, 9) = 5 : LET k$ = "B": GO TO 1910
1900 IF INKEY$= "A" OR INKEY$= "a" THEN LET d(p, 9) = 0 : LET k$ = "A": GO TO 1910
1910 IF d(p, 9) = 1 THEN GO TO 1860
1920 PRINT AT 19, 24; k$;
1930 PRINT AT 20, 11; "Movement 1-5? "; FLASH 1; CHR$ (143); FLASH 0; "      ";
1940 PAUSE 0
1950 LET k$ = INKEY$
1960 IF CODE (k$) < 49 OR CODE (k$) > 53 THEN GO TO 1940
1970 PRINT AT 20, 25; k$;
1980 LET d(p, 9) = d(p, 9) + VAL (k$) 
1990 RETURN 
2000 REM console attack
2010 PRINT AT 17, 11; INK 5; "<Combat Display>";
2020 PRINT AT 19, 11; "Distance A-F? "; FLASH 1; CHR$ (143); 
2030 PRINT AT 20, 11; "[i] for instructions.";
2040 LET d(p, 10) = 1
2050 PAUSE 0 
2060 IF INKEY$= "A" OR INKEY$= "a" THEN LET d(p, 10) = 0 : LET k$ = "A": GO TO 2130
2070 IF INKEY$= "B" OR INKEY$= "b" THEN LET d(p, 10) = 5 : LET k$ = "B": GO TO 2130
2080 IF INKEY$= "C" OR INKEY$= "c" THEN LET d(p, 10) = 10 : LET k$ = "C": GO TO 2130
2090 IF INKEY$= "D" OR INKEY$= "d" THEN LET d(p, 10) = 15 : LET k$ = "D": GO TO 2130
2100 IF INKEY$= "E" OR INKEY$= "e" THEN LET d(p, 10) = 20 : LET k$ = "E": GO TO 2130
2110 IF INKEY$= "F" OR INKEY$= "f" THEN LET d(p, 10) = 25 : LET k$ = "F": GO TO 2130
2120 IF INKEY$= "I" OR INKEY$= "i" THEN GO SUB 6190 : GO TO 2010
2130 IF d(p, 10) = 1 THEN GO TO 2050
2140 PRINT AT 19, 25; k$;
2150 PRINT AT 20, 11; "Arc 1-5? "; FLASH 1; CHR$ (143); FLASH 0; "           ";
2160 LET k$ = ""
2170 PAUSE 0
2180 LET k$ = INKEY$
2190 IF CODE (k$) < 49 OR CODE (k$) > 53 THEN GO TO 2170
2200 PRINT AT 20, 20; k$;
2210 LET d(p, 10) = d(p, 10) + VAL (k$) 
2220 RETURN 
2230 REM console any key
2240 PRINT #1; AT 1, 11; INK 6; "Press any key."; : PAUSE 0 : RETURN 
2250 REM draw common controls
2260 PRINT AT 0, 0; INK 5; "Combat";
2270 PRINT AT 1, 0; INK 5; "Display";
2280 PRINT AT 2, 1; "12345";
2290 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4";
2300 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2";
2310 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1";
2320 PRINT AT 6, 0; "D"; PAPER 6; "  "; AT 6, 4; PAPER 6; "  ";
2330 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  ";
2340 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " ";
2350 PRINT AT 9, 4; INK 6; "31";
2360 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
2370 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
2380 PRINT AT 18, 0; "  "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
2390 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
2400 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
2410 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
2420 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
2430 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
2440 REM draw player controls and clear console
2450 INK u(p, 1)
2460 PRINT AT 0, 6; CHR$ (133); CHR$ (161);
2470 PRINT AT 1, 7; CHR$ (161);
2480 PRINT AT 2, 0; CHR$ (138); AT 2, 6; CHR$ (133); CHR$ (161);
2490 PRINT AT 3, 7; CHR$ (161);
2500 PRINT AT 4, 7; CHR$ (161);
2510 PRINT AT 5, 7; CHR$ (161);
2520 PRINT AT 6, 3; CHR$ (161); AT 6, 6; CHR$ (133); CHR$ (161);
2530 PRINT AT 7, 6; CHR$ (133); CHR$ (161);
2540 PRINT AT 8, 6; CHR$ (133); CHR$ (161);
2550 PRINT AT 9, 0; CHR$ (142); CHR$ (140); CHR$ (140); CHR$ (140); AT 9, 6; CHR$ (141); CHR$ (161);
2560 PRINT AT 10, 6; CHR$ (133); CHR$ (161);
2570 PRINT AT 11, 6; CHR$ (133); CHR$ (161);
2580 PRINT AT 12, 6; CHR$ (133); CHR$ (161);
2590 PRINT AT 13, 6; CHR$ (133); CHR$ (161);
2600 PRINT AT 14, 6; CHR$ (133); CHR$ (161);
2610 PRINT AT 15, 6; CHR$ (133); CHR$ (161);
2620 PRINT AT 16, 4; CHR$ (140); AT 16, 13; CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); INK 7; PAPER 0; "SPACE"; INK u(p, 1); CHR$ (140); INK 7; n$(p);
2630 PRINT AT 17, 10; CHR$ (138); "                     ";
2640 PRINT AT 18, 10; CHR$ (138); "                     ";
2650 PRINT AT 19, 10; CHR$ (138); "                     ";
2660 PRINT AT 20, 10; CHR$ (138); "                     ";
2670 PRINT AT 21, 10; CHR$ (138); "                     ";
2680 PRINT #1; AT 0, 10; INK u(p, 1); CHR$ (138); "                     ";
2690 PRINT #1; AT 1, 10; INK u(p, 1); CHR$ (138); "                     ";
2700 INK 4
2710 IF d(p, 11) = 1 THEN GO SUB 2740
2720 IF d(p, 11) = 2 THEN GO SUB 2810
2730 RETURN 
2740 REM engines damaged
2750 PRINT AT 17, 0; "          ";
2760 PRINT AT 18, 0; INK 2; "<WARNING> ";
2770 PRINT AT 19, 0; " ENGINES  ";
2780 PRINT AT 20, 0; " DAMAGED  ";
2790 PRINT AT 21, 0; "          ";
2800 RETURN 
2810 REM weapons damaged
2820 PRINT AT 3, 1; "     ";
2830 PRINT AT 4, 1; "     ";
2840 PRINT AT 5, 1; "     ";
2850 PRINT AT 6, 1; "  "; AT 6, 4; "  ";
2860 PRINT AT 7, 1; "     ";
2870 PRINT AT 8, 1; "     ";
2880 RETURN 
2890 REM draw player shields
2900 IF d(p, 8) < 1 THEN PRINT AT 10 + u(p, 5), 1 + u(p, 6); " "; AT 11 + u(p, 5), u(p, 6); "   "; AT 12 + u(p, 5), 1 + u(p, 6); " "; : RETURN 
2910 PRINT AT 10 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 4);
2920 PRINT AT 11 + u(p, 5), u(p, 6); INK u(p, 1); d(p, 7); INK 0; PAPER u(p, 1); d(p, 8); INK u(p, 1); PAPER 0; d(p, 5);
2930 PRINT AT 12 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 6);
2940 RETURN 
2950 REM draw player ship
2960 LET tx = (d(p, 1) - 1) * 2
2970 LET ty = ((d(p, 2) - 1) * 2) + 8
2980 IF d(p, 8) = 0 THEN PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; : RETURN 
2990 IF d(p, 3) = 0 THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (152); CHR$ (153); AT tx + 1, ty; CHR$ (150); CHR$ (151); : RETURN 
3000 IF d(p, 3) = 1 THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (156); AT tx + 1, ty; CHR$ (150); CHR$ (157); : RETURN 
3010 IF d(p, 3) = 2 THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (149); AT tx + 1, ty; CHR$ (154); CHR$ (155); : RETURN 
3020 PRINT AT tx, ty; INK u(p, 1); CHR$ (158); CHR$ (149); AT tx + 1, ty; CHR$ (159); CHR$ (151);
3030 RETURN 
3040 REM draw target explosion
3050 LET tx = (d(q, 1) - 1) * 2
3060 LET ty = ((d(q, 2) - 1) * 2) + 8
3070 PRINT AT tx, ty; INK 6; PAPER 2; FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
3080 RETURN 
3090 REM overlay and count targets
3100 LET i = 0 
3110 FOR q = 1 TO t STEP 1
3120 IF q = p OR d(q, 1) < 1 THEN GO TO 3200
3130 GO SUB 5170 : REM load tx, ty
3140 LET tx = tx + 4 : LET ty = ty + 3
3150 IF tx < 1 OR tx > 6 OR ty < 1 OR ty > 5 THEN GO TO 3200
3160 LET s = d(p, 3) + d(q, 3)
3170 IF s = 1 OR s = 3 OR s = 5 THEN PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (160); : GO TO 3190
3180 PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (161);
3190 IF a(((tx - 1) * 5) + ty, 3) > 0 THEN LET i = i + 1
3200 NEXT q
3210 RETURN 
3220 REM redraw screen
3230 CLS 
3240 GO SUB 2250
3250 LET q = p
3260 FOR i = 1 TO t STEP 1
3270 LET p = i
3280 IF d(p, 8) = 0 OR d(p, 1) < 1 THEN GO TO 3310
3290 GO SUB 2890
3300 GO SUB 2950
3310 NEXT i
3320 LET p = q
3330 GO SUB 3090
3340 FOR i = 1 TO 4 STEP 1
3350 LET tx = c(i, 1)
3360 LET ty = c(i, 2)
3370 PRINT AT tx, ty; INK u(i, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
3380 NEXT i
3390 RETURN 
3400 REM apply movement
3410 FOR p = 1 TO t STEP 1
3420 IF d(p, 1) < 1 THEN GO TO 3570
3430 IF d(p, 3) = 0 THEN LET x = d(p, 1) + m(d(p, 9), 1) : LET y = d(p, 2) + m(d(p, 9), 2) : GO TO 3470
3440 IF d(p, 3) = 1 THEN LET x = d(p, 1) + m(d(p, 9), 2) : LET y = d(p, 2) - m(d(p, 9), 1) : GO TO 3470
3450 IF d(p, 3) = 2 THEN LET x = d(p, 1) - m(d(p, 9), 1) : LET y = d(p, 2) - m(d(p, 9), 2) : GO TO 3470
3460 LET x = d(p, 1) - m(d(p, 9), 2) : LET y = d(p, 2) + m(d(p, 9), 1)
3470 IF x < 1 OR x > 8 OR y < 1 OR y > 12 THEN LET x = 0 : GO TO 3490
3480 GO SUB 3590
3490 LET l(d(p, 1), d(p, 2)) = 0 : REM clear map
3500 LET tx = (d(p, 1) - 1) * 2 : LET ty = ((d(p, 2) - 1) * 2) + 8 : REM clear screen pos 1
3510 LET d(p, 1) = x : LET d(p, 2) = y : REM update player
3520 LET d(p, 3) = d(p, 3) + m(d(p, 9), 3) : REM update dir
3530 IF d(p, 3) > 3 THEN LET d(p, 3) = d(p, 3) - 4 : GO TO 3550
3540 IF d(p, 3) < 0 THEN LET d(p, 3) = d(p, 3) + 4
3550 PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; : REM clear screen pos 2
3560 IF x > 0 THEN LET l(x, y) = p : GO SUB 2950
3570 NEXT p
3580 RETURN 
3590 REM planet collision check
3600 IF l(x, y) < 5 THEN RETURN 
3610 GO SUB 2250
3620 GO SUB 3090
3630 PRINT AT 17, 11; INK 2; "<Movement>";
3640 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " ram planet! x4";
3650 LET b = 4
3660 LET s = 4
3670 LET q = p
3680 GO SUB 5230
3690 IF d(p, 3) = 0 THEN LET x = x + 1 : GO TO 3730
3700 IF d(p, 3) = 1 THEN LET y = y - 1 : GO TO 3730
3710 IF d(p, 3) = 2 THEN LET x = x - 1 : GO TO 3730
3720 LET y = y + 1
3730 GO SUB 2890
3740 GO SUB 2230
3750 IF x > 0 THEN GO SUB 3590
3760 RETURN 
3770 REM player collision check
3780 FOR p = 1 TO t STEP 1
3790 IF d(p, 1) < 1 THEN GO TO 4040
3800 GO SUB 2950
3810 FOR q = 1 TO t STEP 1
3820 IF p = q OR d(q, 1) < 1 OR d(p, 1) <>d(q, 1) OR d(p, 2) <>d(q, 2) THEN GO TO 4030
3830 REM collision!
3840 GO SUB 2250
3850 PRINT AT 17, 11; INK 2; "<Movement>";
3860 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " ram "; INK u(q, 1); n$(q); INK 4; " x4";
3870 LET s = d(p, 3) - d(q, 3) + 6
3880 IF s > 7 THEN LET s = s - 4 : GO TO 3900
3890 IF s < 4 THEN LET s = s + 4
3900 LET b = 4
3910 GO SUB 5230
3920 LET tx = (d(p, 1) - 1) * 2
3930 LET ty = ((d(p, 2) - 1) * 2) + 8
3940 PRINT AT tx, ty; INK u(p, 1); PAPER u(q, 1); FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
3950 GO SUB 2230
3960 LET i = p
3970 LET p = q
3980 GO SUB 2890
3990 IF d(i, 8) = 0 THEN GO SUB 2950
4000 LET p = i
4010 IF d(q, 8) = 0 THEN GO SUB 2950
4020 IF d(p, 8) > 0 AND d(q, 8) > 0 AND p > q THEN GO SUB 4060
4030 NEXT q
4040 NEXT p
4050 RETURN 
4060 REM move one player
4070 GO SUB 2440
4080 LET x = d(i, 1)
4090 LET y = d(i, 2)
4100 LET tx = d(i, 1) - 1 + INT (RND* 2)
4110 LET ty = d(i, 2) - 1 + INT (RND* 2)
4120 IF tx < 1 OR tx > 8 OR ty < 1 OR ty > 12 THEN GO TO 4100
4130 IF l(tx, ty) > 0 THEN GO TO 4100
4140 REM choose winner
4150 IF INT RND* 3 > 2 THEN LET i = p : LET s = q : GO TO 4180
4160 LET i = q : LET s = p
4170 REM move player and update map
4180 LET d(i, 1) = tx : LET d(i, 2) = ty : LET l(tx, ty) = i : LET l(x, y) = s
4190 PRINT AT 17, 11; INK 2; "<Movement>";
4200 PRINT AT 18, 11; INK u(s, 1); n$(s); INK 4; " moves "; INK u(i, 1); n$(i) ; INK 4; "!";
4210 LET i = p : LET p = q : GO SUB 2950 : LET p = i : GO SUB 2950
4220 RETURN 
4230 REM off map check
4240 FOR p = 1 TO t STEP 1
4250 IF d(p, 8) < 1 OR d(p, 1) > 0 THEN GO TO 4330
4260 GO SUB 2250
4270 GO SUB 3090
4280 PRINT AT 17, 11; INK 2; "<Movement>";
4290 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " fall into the "; AT 19, 11; "void and are eaten"; AT 20, 11; "by a passing cosmic"; AT 21, 11; "horror.";
4300 LET d(p, 8) = 0
4310 GO SUB 2890
4320 GO SUB 2230
4330 NEXT p
4340 RETURN 
4350 REM player attack
4360 IF a(d(p, 10), 3) = 0 THEN LET s = 0 : GO TO 4740
4370 IF d(p, 3) = 0 THEN LET x = d(p, 1) + a(d(p, 10), 1) : LET y = d(p, 2) + a(d(p, 10), 2) : GO TO 4410
4380 IF d(p, 3) = 1 THEN LET x = d(p, 1) + a(d(p, 10), 2) : LET y = d(p, 2) - a(d(p, 10), 1) : GO TO 4410
4390 IF d(p, 3) = 2 THEN LET x = d(p, 1) - a(d(p, 10), 1) : LET y = d(p, 2) - a(d(p, 10), 2) : GO TO 4410
4400 LET x = d(p, 1) - a(d(p, 10), 2) : LET y = d(p, 2) + a(d(p, 10), 1) 
4410 LET s = 0
4420 PRINT AT 17, 11; INK 2; "<Combat>";
4430 FOR q = 1 TO t STEP 1
4440 IF d(q, 1) <>x OR d(q, 2) <>y OR d(q, 8) < 1 THEN GO TO 4730
4450 INK u(p, 1) : GO SUB 2640 : INK 4
4460 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " attack "; INK u(q, 1); n$(q); INK 4; " x"; a(d(p, 10), 3); 
4470 PAPER u(p, 1) 
4480 LET s = p
4490 LET p = q
4500 GO SUB 2950
4510 LET q = p
4520 LET p = s
4530 PAPER 0 
4540 REM resolve shield based on relative positions and q dir
4550 LET tx = d(p, 1) - d(q, 1)
4560 LET ty = d(p, 2) - d(q, 2)
4570 IF ABS tx > ABS ty AND tx > 0 THEN LET s = 6 : GO TO 4610
4580 IF ABS tx > ABS ty THEN LET s = 4 : GO TO 4610
4590 IF ty > 0 THEN LET s = 5 : GO TO 4610
4600 LET s = 7
4610 LET s = s - d(q, 3)
4620 IF s > 7 THEN LET s = s - 4 : GO TO 4640
4630 IF s < 4 THEN LET s = s + 4
4640 LET b = a(d(p, 10), 3)
4650 GO SUB 5230
4660 REM refresh attacked ship
4670 LET i = p
4680 LET p = q
4690 GO SUB 2890
4700 GO SUB 2230
4710 GO SUB 2950
4720 LET p = i
4730 NEXT q
4740 IF s = 0 THEN PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " do not attack.";
4750 RETURN 
4760 REM end game check
4770 LET i = 0
4780 LET q = 1
4790 FOR p = 1 TO t STEP 1
4800 IF d(p, 1) > 0 THEN LET q = p : LET i = i + 1
4810 NEXT p 
4820 REM still at least 2 players
4830 IF i > 1 THEN RETURN 
4840 REM ends game
4850 LET t = 0
4860 REM 1st player or winner colours
4870 LET p = q
4880 GO SUB 2250
4890 PRINT AT 17, 11; INK 2; "<GAME OVER>";
4900 IF i = 0 THEN PRINT AT 18, 11; "Everybody is dead."; : GO TO 4920
4910 PRINT AT 18, 11; INK u(p, 1); "SPACE "; n$(p); INK 4; " have won.";
4920 GO SUB 2230
4930 RETURN 
4940 REM resolve AI movement
4950 LET d(p, 9) = 13
4960 IF d(p, 11) = 1 THEN RETURN 
4970 FOR q = 1 TO t STEP 1
4980 IF q = p OR d(q, 1) < 1 THEN GO TO 5020
4990 GO SUB 5170 : REM load tx, ty
5000 LET tx = tx + 4 : LET ty = ty + 3
5010 IF tx > 0 AND tx < 7 AND ty > 0 AND ty < 6 THEN LET d(p, 9) = v(tx, ty) : RETURN 
5020 NEXT q
5030 IF ty > -11 AND ty < 0 THEN LET d(p, 9) = 1 : RETURN 
5040 IF tx > 5 AND tx < 16 THEN LET d(p, 9) = 5 : RETURN 
5050 LET d(p, 9) = 3
5060 RETURN 
5070 REM resolve AI attack
5080 LET d(p, 10) = 0
5090 FOR q = 1 TO t STEP 1
5100 IF q = p OR d(q, 1) < 1 THEN GO TO 5140
5110 GO SUB 5170 : REM load tx, ty
5120 LET tx = tx + 4 : LET ty = ty + 3
5130 IF tx > 0 AND tx < 7 AND ty > 0 AND ty < 6 THEN LET d(p, 10) = ((tx - 1) * 5) + ty : RETURN 
5140 NEXT q
5150 IF d(p, 10) = 0 THEN LET d(p, 10) = 19
5160 RETURN 
5170 REM load tx, ty with target relative position
5180 IF d(p, 3) = 0 THEN LET tx = d(q, 1) - d(p, 1) : LET ty = d(q, 2) - d(p, 2) : RETURN 
5190 IF d(p, 3) = 1 THEN LET tx = d(p, 2) - d(q, 2) : LET ty = d(q, 1) - d(p, 1) : RETURN 
5200 IF d(p, 3) = 2 THEN LET tx = d(p, 1) - d(q, 1) : LET ty = d(p, 2) - d(q, 2) : RETURN 
5210 LET tx = d(q, 2) - d(p, 2) : LET ty = d(p, 1) - d(q, 1)
5220 RETURN 
5230 REM attack ship q *b
5240 LET tx = 19
5250 FOR i = 1 TO b STEP 1
5260 IF RND* 9 < 4 THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; : GO TO 5380
5270 IF d(q, 8) = 1 OR RND* 6 > 1 THEN GO TO 5350
5280 IF d(q, s) > 1 AND RND* 6 > 5 THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT! "; INK 4; s$(s - 3); " shields -"; d(q, s); : LET d(q, s) = 0 : GO TO 5370
5290 IF d(q, s) > 0 AND RND* 6 > 5 THEN LET d(q, 8) = d(q, 8) - 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT!"; INK 4; " Hull -1"; : GO TO 5370
5300 IF d(q, 11) > 0 THEN GO TO 5350
5310 IF d(q, s) > 0 THEN LET d(q, s) = d(q, s) - 1 : GO TO 5330
5320 LET d(q, 8) = d(q, 8) - 1
5330 IF RND* 6 > 3 THEN LET d(q, 11) = 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT!"; INK 4; " Engines damaged."; : GO TO 5370
5340 LET d(q, 11) = 2 : PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT!"; INK 4; " Weapons damaged."; : GO TO 5370
5350 IF d(q, s) > 0 THEN LET d(q, s) = d(q, s) - 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! "; s$(s - 3); " shields -1"; : GO TO 5370
5360 IF d(q, 8) > 0 THEN LET d(q, 8) = d(q, 8) - 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Hull -1"; : GO TO 5370
5370 IF d(q, 8) = 0 THEN PRINT #FN s(tx); AT FN x(tx), 16; INK 4; "Ship destroyed!"; : GO SUB 3040 : RETURN 
5380 LET tx = tx + 1
5390 NEXT i
5400 RETURN 
5410 REM attack vectors data
5420 DATA -3, -2, 4, -3, -1, 4, -3, 0, 4
5430 DATA -3, 1, 4, -3, 2, 4, -2, -2, 1
5440 DATA -2, -1, 2, -2, 0, 2, -2, 1, 2
5450 DATA -2, 2, 1, -1, -2, 1, -1, -1, 3
5460 DATA -1, 0, 1, -1, 1, 3, -1, 2, 1
5470 DATA 0, -2, 1, 0, -1, 3, 0, 0, 0
5480 DATA 0, 1, 3, 0, 2, 1, 1, -2, 1
5490 DATA 1, -1, 3, 1, 0, 0, 1, 1, 3
5500 DATA 1, 2, 1, 2, -2, 1, 2, -1, 0
5510 DATA 2, 0, 0, 2, 1, 0, 2, 2, 1
5520 REM movement vectors data
5530 DATA -2, -1, -1, -2, -1, 0, -2, 0, 0
5540 DATA -2, 1, 0, -2, 1, 1, -1, -1, -1
5550 DATA -1, -1, 0, -1, 0, 0, -1, 1, 0
5560 DATA -1, 1, 1, 0, 0, 0, 0, 0, -1
5570 DATA 0, 0, 0, 0, 0, 1, 0, 0, 0
5580 REM player UIs data
5590 DATA 1, 5, 1, 1, 0, 0
5600 DATA 2, 4, 5, 9, 3, 3
5610 DATA 3, 2, 1, 9, 0, 3
5620 DATA 6, 3, 5, 1, 3, 0
5630 REM player names data
5640 DATA "FLEET", "ELVES", "CHAOS", "HORDE"
5650 REM player data
5660 DATA 1, 1, 2, 3, 3, 3, 3, 4, 0, 0, 0
5670 DATA 8, 12, 0, 3, 3, 3, 3, 4, 0, 0, 0
5680 DATA 1, 12, 2, 3, 3, 3, 3, 4, 0, 0, 0
5690 DATA 8, 1, 0, 3, 3, 3, 3, 4, 0, 0, 0
5700 REM UDGs data
5710 DATA 0, 3, 15, 31, 63, 63, 127, 127
5720 DATA 0, 192, 240, 248, 252, 252, 254, 254 
5730 DATA 127, 127, 63, 63, 31, 15, 3, 0 
5740 DATA 254, 254, 252, 252, 248, 240, 192, 0
5750 DATA 0, 0, 0, 0, 1, 7, 7, 15
5760 DATA 0, 0, 0, 0, 128, 224, 224, 240 
5770 DATA 15, 7, 7, 1, 0, 0, 0, 0
5780 DATA 240, 224, 224, 128, 0, 0, 0, 0
5790 DATA 0, 0, 0, 5, 15, 7, 15, 7
5800 DATA 0, 0, 0, 160, 240, 224, 240, 224
5810 DATA 7, 15, 7, 15, 5, 0, 0, 0 
5820 DATA 224, 240, 224, 240, 160, 0, 0, 0 
5830 DATA 0, 0, 0, 0, 80, 248, 240, 248 
5840 DATA 248, 240, 248, 80, 0, 0, 0, 0 
5850 DATA 0, 0, 0, 0, 10, 31, 15, 31 
5860 DATA 31, 15, 31, 10, 0, 0, 0, 0 
5870 DATA 0, 0, 0, 60, 60, 0, 0, 0 
5880 DATA 0, 0, 24, 24, 24, 24, 0, 0 
5890 DATA 0, 0, 0, 0, 24, 0, 0, 0
5900 REM movement ai behaviour data
5910 DATA 1, 2, 3, 4, 5
5920 DATA 6, 7, 8, 9, 10
5930 DATA 12, 12, 14, 14, 14
5940 DATA 12, 12, 12, 14, 14
5950 DATA 12, 12, 14, 14, 14
5960 DATA 12, 12, 12, 14, 14
5970 REM shields
5980 DATA "Front", "Right", " Rear", " Left"
5990 REM helm computer instructions
6000 CLS 
6010 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE "; n$(p);"           ";
6020 PRINT AT 2, 0; "Note the direction of your ship and consult the "; INK 5; "Helm Computer"; INK 4; ".  You must select a speed A-C and a manoeuvre 1-5."
6030 PRINT AT 7, 0; "Example - A5 performs this move:"
6040 PRINT AT 9, 2; INK u(p, 1); CHR$ (148); CHR$ (156); AT 10, 2; CHR$ (150); CHR$ (157); INK 4; " Also...";
6050 PRINT AT 11, 5; "- Stay within map or die.";
6060 PRINT AT 12, 5; "- Avoid planets."
6070 PRINT AT 13, 0; INK u(p, 1); CHR$ (152); CHR$ (153); INK 4; "   - Optionally ram opponents."; AT 14, 0; INK u(p, 1); CHR$ (150); CHR$ (151);
6080 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
6090 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
6100 PRINT AT 18, 1; " "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
6110 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
6120 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
6130 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
6140 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
6150 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
6160 GO SUB 2230
6170 GO SUB 3220
6180 RETURN 
6190 REM combat display instructions
6200 CLS 
6210 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE "; n$(p);"           ";
6220 PRINT AT 2, 1; "12345  The "; INK 5; "Combat Display"; INK 4; " shows";
6230 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4"; INK 4; " enemies within range and";
6240 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2"; INK 4; " the A-F/1-5 combination";
6250 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1"; INK 4; " to attack. The number of";
6260 PRINT AT 6, 0; "D"; PAPER 6; "  "; INK u(p, 1); PAPER 0; CHR$ (161); AT 6, 4; PAPER 6; "  "; INK 4; PAPER 0; "  attacks correspond to";
6270 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  "; INK 4; PAPER 0; "  the "; INK 2; "red "; INK 4; "and "; INK 6; "yellow";
6280 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " "; INK 4; PAPER 0; "  numbers.";
6290 PRINT AT 9, 4; INK 6; "31";
6300 PRINT AT 11, 8; "A player has 4 shields";
6310 PRINT AT 12, 8; "and a hull. The "; INK 5; "Combat ";
6320 PRINT AT 13, 8; INK 5; "Display"; INK 4; " can be used to";
6330 PRINT AT 14, 8; "see which shield will be";
6340 PRINT AT 15, 8; "hit.";
6350 PRINT AT 17, 0; "The hull is damaged if there areno shields on the attacked side.When the hull reaches 0 the shipis destroyed.";
6360 GO SUB 2890
6370 GO SUB 3090
6380 GO SUB 2230
6390 GO SUB 3220
6400 RETURN 
6410 REM about SPACE FLEET
6420 CLS 
6430 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE FLEET           ";
6440 PRINT AT 1, 0; "       ";
6450 PRINT AT 2, 0; "In the grim darkness of the far future, there is only war.";
6460 PRINT AT 5, 0; "Select 2-4 human or AI players, and do turn-based battle using  the "; INK 5; "<Helm Computer>"; INK 4; " for movementand "; INK 5; "<Combat Display>"; INK 4; " to attack.";
6470 PRINT AT 10, 0; "Each are accessed via a console,through which further help is   available by entering [i]."
6480 PRINT AT 14, 0; INK 6; "Press any key to begin."
6490 PRINT #1; AT 0, 0; INK 1; CHR$ (152); CHR$ (153);
6500 PRINT #1; AT 0, 3; INK 2; CHR$ (148); CHR$ (156);
6510 PRINT #1; AT 0, 6; INK 3; CHR$ (148); CHR$ (149);
6520 PRINT #1; AT 0, 9; INK 6; CHR$ (158); CHR$ (149);
6530 PRINT #1; AT 0, 12; INK 5; CHR$ (144); CHR$ (145);
6540 PRINT #1; AT 0, 15; INK 4; CHR$ (144); CHR$ (145);
6550 PRINT #1; AT 0, 18; INK 2; CHR$ (144); CHR$ (145);
6560 PRINT #1; AT 0, 21; INK 3; CHR$ (144); CHR$ (145);
6570 PRINT #1; AT 1, 0; INK 1; CHR$ (150); CHR$ (151);
6580 PRINT #1; AT 1, 3; INK 2; CHR$ (150); CHR$ (157);
6590 PRINT #1; AT 1, 6; INK 3; CHR$ (154); CHR$ (155);
6600 PRINT #1; AT 1, 9; INK 6; CHR$ (159); CHR$ (151);
6610 PRINT #1; AT 1, 12; INK 5; CHR$ (146); CHR$ (147);
6620 PRINT #1; AT 1, 15; INK 4; CHR$ (146); CHR$ (147);
6630 PRINT #1; AT 1, 18; INK 2; CHR$ (146); CHR$ (147);
6640 PRINT #1; AT 1, 21; INK 3; CHR$ (146); CHR$ (147);
6650 PAUSE 0
6660 CLS 
6670 RETURN 
