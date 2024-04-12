  10 REM SPACE FLEET by ambientcoder 2024
  20 INK 4
  30 PAPER 0
  40 BORDER 0
  50 CLS 
  60 PRINT "Initialising SPACE FLEET please wait...";
  70 REM support print at 22+ via stream
  80 DEF FN s(x)=(1+(x<22))
  90 DEF FN x(x)=(x-(22*(x>21)))
 100 REM the map
 110 DIM l(8, 12)
 120 REM attack vectors: 1:dx,2:dy,3:damage
 130 DIM a(30, 3)
 140 REM movement vectors: 1:dx,2:dy,3:dir (+- clockwise)
 150 DIM m(15, 3)
 160 REM names
 170 DIM n$(4, 5)
 180 REM shield names
 190 DIM s$(4, 5)
 200 REM player data: 1:x,2:y,3:dir(0:u,1:r,2:d,3:l),4:front,5:right,6:back,7:left,8:hull,9:manoeuvre,10:attack,11:effects
 210 DIM d(4, 11)
 220 REM player UIs: 1:ship,2:planet,3:planet-x,4:planet-y,5:shield-x,6:shield-y,7
 230 DIM u(4, 6)
 240 REM planet position cache: 1:planet-x,2:planet-y
 250 DIM c(4, 2)
 260 REM movement ai behaviours
 270 DIM v(6, 5)
 280 REM load attack vectors
 290 FOR x = 1 TO 30 STEP 1
 300 FOR y = 1 TO 3 STEP 1
 310 READ a(x, y)
 320 NEXT y
 330 NEXT x
 340 REM load movement vectors
 350 FOR x = 1 TO 15 STEP 1
 360 FOR y = 1 TO 3 STEP 1
 370 READ m(x, y)
 380 NEXT y
 390 NEXT x
 400 REM load player UIs and names
 410 FOR x = 1 TO 4 STEP 1
 420 FOR y = 1 TO 6 STEP 1
 430 READ u(x, y)
 440 NEXT y
 450 NEXT x
 460 FOR x = 1 TO 4 STEP 1
 470 READ n$(x)
 480 NEXT x
 490 REM load UDGs
 500 LET i = USR "a"
 510 LET t = i+8*19-1
 520 FOR x = i TO t STEP 1
 530 READ y
 540 POKE x, y
 550 NEXT x
 560 REM load movement ai behaviours
 570 FOR x = 1 TO 6 STEP 1
 580 FOR y = 1 TO 5 STEP 1
 590 READ v(x, y)
 600 NEXT y
 610 NEXT x
 620 REM load shield names
 630 FOR x = 1 TO 4 STEP 1
 640 READ s$(x)
 650 NEXT x
 660 LET k$ = ""
 670 GO SUB 1100 : REM init game
 680 GO SUB 1630 : REM console confirm
 690 IF k$ <>"Y" THEN GO TO 670
 700 REM main game loop
 710 FOR p = 1 TO t STEP 1
 720 REM movement phase
 730 IF d(p, 1) = 0 THEN GO TO 820 : REM off map
 740 IF p > (t - u) THEN GO SUB 4850 : GO TO 810 : REM AI
 750 LET k$ = ""
 760 GO SUB 2160 : REM draw controls
 770 GO SUB 3000 : REM overlay targets
 780 GO SUB 1720 : REM input movement
 790 GO SUB 1630 : REM confirm
 800 IF k$ <>"Y" THEN GO TO 750
 810 IF d(p, 11) = 1 THEN LET d(p, 11) = 0
 820 NEXT p
 830 GO SUB 3310 : REM apply movement
 840 GO SUB 3680 : REM collision check
 850 GO SUB 4140 : REM off map check
 860 GO SUB 5340 : REM move dead ships off map
 870 REM combat phase
 880 FOR p = 1 TO t STEP 1
 890 IF d(p, 1) = 0 THEN GO TO 980 : REM off map
 900 IF p > (t - u) THEN GO SUB 4980 : GO TO 980 : REM AI
 910 LET k$ = ""
 920 GO SUB 2160 : REM draw controls
 930 GO SUB 3000 : REM overlay targets
 940 IF i = 0 OR d(p, 11) = 2 THEN LET d(p, 11) = 2 : PRINT AT 17, 11; INK 2; "<Combat>"; AT 18, 11; INK u(p, 1); n$(p); INK 4; " cannot attack."; : GO TO 980
 950 GO SUB 1910 : REM input attack
 960 GO SUB 1630 : REM confirm
 970 IF k$ <>"Y" THEN GO TO 920
 980 IF d(p, 11) = 2 THEN LET d(p, 10) = 18 : LET d(p, 11) = 0 
 990 NEXT p
1000 FOR p = 1 TO t STEP 1
1010 IF d(p, 1) = 0 THEN GO TO 1050 : REM dead
1020 GO SUB 2160 : REM draw controls
1030 GO SUB 3000 : REM overlay targets
1040 GO SUB 4260 : REM apply attack
1050 NEXT p 
1060 GO SUB 5340 : REM move dead ships off map
1070 GO SUB 4670 : REM end game check
1080 IF t > 0 THEN GO TO 710
1090 GO TO 670
1100 REM init game
1110 LET p = 1 : LET t = 0
1120 GO SUB 5820 : REM about SPACE FLEET
1130 GO SUB 2160 : REM draw controls
1140 PRINT AT 17, 11; INK 5; "<SPACE FLEET>";
1150 PRINT AT 19, 11; "Enter players 2-4? "; FLASH 1; CHR$ (143);
1160 PAUSE 0
1170 LET k$ = INKEY$
1180 IF CODE (k$) < 50 OR CODE (k$) > 52 THEN GO TO 1160
1190 PRINT AT 19, 30; k$;
1200 LET t = VAL (k$)
1210 PRINT AT 20, 11; "AI players 0-"; t-1; "? "; FLASH 1; CHR$ (143);
1220 PAUSE 0
1230 LET k$ = INKEY$
1240 IF CODE (k$) < 48 OR CODE (k$) > 48+t-1 THEN GO TO 1220
1250 PRINT AT 20, 27; k$;
1260 LET u = VAL (k$)
1270 PRINT AT 21, 11; "Loading map...";
1280 REM clear map
1290 FOR y = 1 TO 12 STEP 1
1300 FOR x = 1 TO 8
1310 LET l(x, y) = 0
1320 NEXT x
1330 NEXT y 
1340 REM load player data
1350 RESTORE 6630
1360 FOR x = 1 TO t STEP 1
1370 FOR y = 1 TO 11 STEP 1
1380 READ d(x, y)
1390 NEXT y
1400 LET l(d(x, 1), d(x, 2)) = x : REM 1-4=player
1410 NEXT x
1420 REM randomise planet locations
1430 RANDOMIZE 0
1440 FOR p = 1 TO 4 
1450 LET x = INT (RND* 4) + u(p, 3)
1460 LET y = INT (RND* 4) + u(p, 4)
1470 REM avoid edges
1480 IF x < 2 OR x > 7 OR y < 2 OR y > 11 THEN GO TO 1450
1490 REM update map and draw planet
1500 LET l(x, y) = 4 + p : REM 5+=planet
1510 LET tx = (x - 1) * 2
1520 LET ty = ((y - 1) * 2) + 8
1530 LET c(p, 1) = tx
1540 LET c(p, 2) = ty
1550 PRINT AT tx, ty; INK u(p, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
1560 NEXT p
1570 REM draw players
1580 FOR p = 1 TO t STEP 1
1590 GO SUB 2800 : REM draw shields
1600 GO SUB 2860 : REM draw ship
1610 NEXT p
1620 RETURN 
1630 REM console confirm
1640 PRINT #1; AT 1, 11; INK 6; "Confirm Y/N? "; FLASH 1; CHR$ (143);
1650 PAUSE 0
1660 LET k$ = INKEY$
1670 IF k$ = "y" OR k$ = "Y" THEN LET k$ = "Y": GO TO 1700
1680 IF k$ = "n" OR k$ = "N" THEN LET k$ = "N": GO TO 1700
1690 GO TO 1650
1700 PRINT #1; AT 1, 24; INK 6; k$;
1710 RETURN 
1720 REM console movement
1730 PRINT AT 17, 11; INK 5; "<Helm Computer>";
1740 PRINT AT 19, 11; "Speed A/B/C? "; FLASH 1; CHR$ (143);
1750 PRINT AT 20, 11; "[i] for instructions.";
1760 LET d(p, 9) = 1
1770 PAUSE 0
1780 IF INKEY$= "I" OR INKEY$= "i" THEN GO SUB 5400 : GO TO 1730
1790 IF INKEY$= "C" OR INKEY$= "c" OR d(p, 11) = 1 THEN LET d(p, 9) = 10 : LET k$ = "C": GO TO 1820
1800 IF INKEY$= "B" OR INKEY$= "b" THEN LET d(p, 9) = 5 : LET k$ = "B": GO TO 1820
1810 IF INKEY$= "A" OR INKEY$= "a" THEN LET d(p, 9) = 0 : LET k$ = "A": GO TO 1820
1820 IF d(p, 9) = 1 THEN GO TO 1770
1830 PRINT AT 19, 24; k$;
1840 PRINT AT 20, 11; "Movement 1-5? "; FLASH 1; CHR$ (143); FLASH 0; "      ";
1850 PAUSE 0
1860 LET k$ = INKEY$
1870 IF CODE (k$) < 49 OR CODE (k$) > 53 THEN GO TO 1850
1880 PRINT AT 20, 25; k$;
1890 LET d(p, 9) = d(p, 9) + VAL (k$) 
1900 RETURN 
1910 REM console attack
1920 PRINT AT 17, 11; INK 5; "<Combat Display>";
1930 PRINT AT 19, 11; "Distance A-F? "; FLASH 1; CHR$ (143); 
1940 PRINT AT 20, 11; "[i] for instructions.";
1950 LET d(p, 10) = 1
1960 PAUSE 0 
1970 IF INKEY$= "A" OR INKEY$= "a" THEN LET d(p, 10) = 0 : LET k$ = "A": GO TO 2040
1980 IF INKEY$= "B" OR INKEY$= "b" THEN LET d(p, 10) = 5 : LET k$ = "B": GO TO 2040
1990 IF INKEY$= "C" OR INKEY$= "c" THEN LET d(p, 10) = 10 : LET k$ = "C": GO TO 2040
2000 IF INKEY$= "D" OR INKEY$= "d" THEN LET d(p, 10) = 15 : LET k$ = "D": GO TO 2040
2010 IF INKEY$= "E" OR INKEY$= "e" THEN LET d(p, 10) = 20 : LET k$ = "E": GO TO 2040
2020 IF INKEY$= "F" OR INKEY$= "f" THEN LET d(p, 10) = 25 : LET k$ = "F": GO TO 2040
2030 IF INKEY$= "I" OR INKEY$= "i" THEN GO SUB 5600 : GO TO 1920
2040 IF d(p, 10) = 1 THEN GO TO 1960
2050 PRINT AT 19, 25; k$;
2060 PRINT AT 20, 11; "Arc 1-5? "; FLASH 1; CHR$ (143); FLASH 0; "           ";
2070 LET k$ = ""
2080 PAUSE 0
2090 LET k$ = INKEY$
2100 IF CODE (k$) < 49 OR CODE (k$) > 53 THEN GO TO 2080
2110 PRINT AT 20, 20; k$;
2120 LET d(p, 10) = d(p, 10) + VAL (k$) 
2130 RETURN 
2140 REM console any key
2150 PRINT #1; AT 1, 11; INK 6; "Press any key."; : PAUSE 0 : RETURN 
2160 REM draw common controls
2170 PRINT AT 0, 0; INK 5; "Combat";
2180 PRINT AT 1, 0; INK 5; "Display";
2190 PRINT AT 2, 1; "12345";
2200 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4";
2210 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2";
2220 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1";
2230 PRINT AT 6, 0; "D"; PAPER 6; "  "; AT 6, 4; PAPER 6; "  ";
2240 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  ";
2250 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " ";
2260 PRINT AT 9, 4; INK 6; "31";
2270 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
2280 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
2290 PRINT AT 18, 0; "  "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
2300 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
2310 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
2320 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
2330 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
2340 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
2350 REM draw player controls and clear console
2360 INK u(p, 1)
2370 PRINT AT 0, 6; CHR$ (133); CHR$ (161);
2380 PRINT AT 1, 7; CHR$ (161);
2390 PRINT AT 2, 0; CHR$ (138); AT 2, 6; CHR$ (133); CHR$ (161);
2400 PRINT AT 3, 7; CHR$ (161);
2410 PRINT AT 4, 7; CHR$ (161);
2420 PRINT AT 5, 7; CHR$ (161);
2430 PRINT AT 6, 3; CHR$ (161); AT 6, 6; CHR$ (133); CHR$ (161);
2440 PRINT AT 7, 6; CHR$ (133); CHR$ (161);
2450 PRINT AT 8, 6; CHR$ (133); CHR$ (161);
2460 PRINT AT 9, 0; CHR$ (142); CHR$ (140); CHR$ (140); CHR$ (140); AT 9, 6; CHR$ (141); CHR$ (161);
2470 PRINT AT 10, 6; CHR$ (133); CHR$ (161);
2480 PRINT AT 11, 6; CHR$ (133); CHR$ (161);
2490 PRINT AT 12, 6; CHR$ (133); CHR$ (161);
2500 PRINT AT 13, 6; CHR$ (133); CHR$ (161);
2510 PRINT AT 14, 6; CHR$ (133); CHR$ (161);
2520 PRINT AT 15, 6; CHR$ (133); CHR$ (161);
2530 PRINT AT 16, 4; CHR$ (140); AT 16, 13; CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); INK 7; PAPER 0; "SPACE"; INK u(p, 1); CHR$ (140); INK 7; n$(p);
2540 PRINT AT 17, 10; CHR$ (138); "                     ";
2550 PRINT AT 18, 10; CHR$ (138); "                     ";
2560 PRINT AT 19, 10; CHR$ (138); "                     ";
2570 PRINT AT 20, 10; CHR$ (138); "                     ";
2580 PRINT AT 21, 10; CHR$ (138); "                     ";
2590 PRINT #1; AT 0, 10; INK u(p, 1); CHR$ (138); "                     ";
2600 PRINT #1; AT 1, 10; INK u(p, 1); CHR$ (138); "                     ";
2610 INK 4
2620 IF d(p, 11) = 1 THEN GO SUB 2650 : REM engines damaged
2630 IF d(p, 11) = 2 THEN GO SUB 2720 : REM weapons damaged
2640 RETURN 
2650 REM engines damaged
2660 PRINT AT 17, 0; "          ";
2670 PRINT AT 18, 0; INK 2; "<WARNING> ";
2680 PRINT AT 19, 0; " ENGINES  ";
2690 PRINT AT 20, 0; " DAMAGED  ";
2700 PRINT AT 21, 0; "          ";
2710 RETURN 
2720 REM weapons damaged
2730 PRINT AT 3, 1; "     ";
2740 PRINT AT 4, 1; "     ";
2750 PRINT AT 5, 1; "     ";
2760 PRINT AT 6, 1; "  "; AT 6, 4; "  ";
2770 PRINT AT 7, 1; "     ";
2780 PRINT AT 8, 1; "     ";
2790 RETURN 
2800 REM draw player shields
2810 IF d(p, 8) < 1 THEN PRINT AT 10 + u(p, 5), 1 + u(p, 6); " "; AT 11 + u(p, 5), u(p, 6); "   "; AT 12 + u(p, 5), 1 + u(p, 6); " "; : RETURN 
2820 PRINT AT 10 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 4);
2830 PRINT AT 11 + u(p, 5), u(p, 6); INK u(p, 1); d(p, 7); INK 0; PAPER u(p, 1); d(p, 8); INK u(p, 1); PAPER 0; d(p, 5);
2840 PRINT AT 12 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 6);
2850 RETURN 
2860 REM draw player ship
2870 LET tx = (d(p, 1) - 1) * 2
2880 LET ty = ((d(p, 2) - 1) * 2) + 8
2890 IF d(p, 8) = 0 THEN PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; : RETURN 
2900 IF d(p, 3) = 0 THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (152); CHR$ (153); AT tx + 1, ty; CHR$ (150); CHR$ (151); : RETURN 
2910 IF d(p, 3) = 1 THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (156); AT tx + 1, ty; CHR$ (150); CHR$ (157); : RETURN 
2920 IF d(p, 3) = 2 THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (149); AT tx + 1, ty; CHR$ (154); CHR$ (155); : RETURN 
2930 PRINT AT tx, ty; INK u(p, 1); CHR$ (158); CHR$ (149); AT tx + 1, ty; CHR$ (159); CHR$ (151);
2940 RETURN 
2950 REM draw target explosion
2960 LET tx = (d(q, 1) - 1) * 2
2970 LET ty = ((d(q, 2) - 1) * 2) + 8
2980 PRINT AT tx, ty; INK 6; PAPER 2; FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
2990 RETURN 
3000 REM overlay and count targets
3010 LET i = 0 
3020 FOR q = 1 TO t STEP 1
3030 IF q = p OR d(q, 1) < 1 OR d(q, 8) < 1 THEN GO TO 3110
3040 GO SUB 5100 : REM load tx, ty
3050 LET tx = tx + 4 : LET ty = ty + 3
3060 IF tx < 1 OR tx > 6 OR ty < 1 OR ty > 5 THEN GO TO 3110
3070 LET s = d(p, 3) + d(q, 3)
3080 IF s = 1 OR s = 3 OR s = 5 THEN PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (160); : GO TO 3100
3090 PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (161);
3100 IF a(((tx - 1) * 5) + ty, 3) > 0 THEN LET i = i + 1
3110 NEXT q
3120 RETURN 
3130 REM redraw screen
3140 CLS 
3150 GO SUB 2160 : REM draw controls
3160 LET q = p
3170 FOR i = 1 TO t STEP 1
3180 LET p = i
3190 IF d(p, 8) = 0 OR d(p, 1) = 0 THEN GO TO 3220
3200 GO SUB 2800 : REM draw shields
3210 GO SUB 2860 : REM draw ship
3220 NEXT i
3230 LET p = q
3240 GO SUB 3000 : REM overlay targets
3250 FOR i = 1 TO 4 STEP 1
3260 LET tx = c(i, 1)
3270 LET ty = c(i, 2)
3280 PRINT AT tx, ty; INK u(i, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
3290 NEXT i
3300 RETURN 
3310 REM apply movement
3320 FOR p = 1 TO t STEP 1
3330 IF d(p, 1) = 0 THEN GO TO 3480
3340 IF d(p, 3) = 0 THEN LET x = d(p, 1) + m(d(p, 9), 1) : LET y = d(p, 2) + m(d(p, 9), 2) : GO TO 3380
3350 IF d(p, 3) = 1 THEN LET x = d(p, 1) + m(d(p, 9), 2) : LET y = d(p, 2) - m(d(p, 9), 1) : GO TO 3380
3360 IF d(p, 3) = 2 THEN LET x = d(p, 1) - m(d(p, 9), 1) : LET y = d(p, 2) - m(d(p, 9), 2) : GO TO 3380
3370 LET x = d(p, 1) - m(d(p, 9), 2) : LET y = d(p, 2) + m(d(p, 9), 1)
3380 IF x < 1 OR x > 8 OR y < 1 OR y > 12 THEN LET x = 0 : GO TO 3400
3390 GO SUB 3500 : REM planet collision check
3400 LET l(d(p, 1), d(p, 2)) = 0 : REM clear map
3410 LET tx = (d(p, 1) - 1) * 2 : LET ty = ((d(p, 2) - 1) * 2) + 8 : REM clear screen pos 1
3420 LET d(p, 1) = x : LET d(p, 2) = y : REM update player
3430 LET d(p, 3) = d(p, 3) + m(d(p, 9), 3) : REM update dir
3440 IF d(p, 3) > 3 THEN LET d(p, 3) = d(p, 3) - 4 : GO TO 3460
3450 IF d(p, 3) < 0 THEN LET d(p, 3) = d(p, 3) + 4
3460 PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; : REM clear screen pos 2
3470 IF x > 0 THEN LET l(x, y) = p : GO SUB 2860
3480 NEXT p
3490 RETURN 
3500 REM planet collision check
3510 IF l(x, y) < 5 THEN RETURN 
3520 GO SUB 2160 : REM draw controls
3530 GO SUB 3000 : REM overlay targets
3540 PRINT AT 17, 11; INK 2; "<Movement>";
3550 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " ram planet! x4";
3560 LET b = 4
3570 LET s = 4
3580 LET q = p
3590 GO SUB 5160 : REM attack ship q*b
3600 IF d(p, 3) = 0 THEN LET x = x + 1 : GO TO 3640
3610 IF d(p, 3) = 1 THEN LET y = y - 1 : GO TO 3640
3620 IF d(p, 3) = 2 THEN LET x = x - 1 : GO TO 3640
3630 LET y = y + 1
3640 GO SUB 2800 : REM draw shields
3650 GO SUB 2140 : REM any key
3660 IF x > 0 THEN GO SUB 3500
3670 RETURN 
3680 REM player collision check
3690 FOR p = 1 TO t STEP 1
3700 IF d(p, 1) = 0 THEN GO TO 3950
3710 GO SUB 2860
3720 FOR q = 1 TO t STEP 1
3730 IF p = q OR d(q, 1) = 0 OR d(p, 1) <>d(q, 1) OR d(p, 2) <>d(q, 2) THEN GO TO 3940
3740 REM collision!
3750 GO SUB 2160 : REM draw ship
3760 PRINT AT 17, 11; INK 2; "<Movement>";
3770 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " ram "; INK u(q, 1); n$(q); INK 4; " x4";
3780 LET s = d(p, 3) - d(q, 3) + 6
3790 IF s > 7 THEN LET s = s - 4 : GO TO 3810
3800 IF s < 4 THEN LET s = s + 4
3810 LET b = 4
3820 GO SUB 5160 : REM attack ship q*b
3830 LET tx = (d(p, 1) - 1) * 2
3840 LET ty = ((d(p, 2) - 1) * 2) + 8
3850 PRINT AT tx, ty; INK u(p, 1); PAPER u(q, 1); FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
3860 GO SUB 2140 : REM any key
3870 LET i = p
3880 LET p = q
3890 GO SUB 2800 : REM draw shields
3900 IF d(i, 8) = 0 THEN GO SUB 2860 : REM draw ship
3910 LET p = i
3920 IF d(q, 8) = 0 THEN GO SUB 2860 : REM draw ship
3930 IF d(p, 8) > 0 AND d(q, 8) > 0 AND p > q THEN GO SUB 3970 : REM move one player
3940 NEXT q
3950 NEXT p
3960 RETURN 
3970 REM move one player
3980 GO SUB 2350 : REM draw controls
3990 LET x = d(i, 1)
4000 LET y = d(i, 2)
4010 LET tx = d(i, 1) - 1 + INT (RND* 2)
4020 LET ty = d(i, 2) - 1 + INT (RND* 2)
4030 IF tx < 1 OR tx > 8 OR ty < 1 OR ty > 12 THEN GO TO 4010
4040 IF l(tx, ty) > 0 THEN GO TO 4010
4050 REM choose winner
4060 IF INT RND* 3 > 2 THEN LET i = p : LET s = q : GO TO 4090
4070 LET i = q : LET s = p
4080 REM move player and update map
4090 LET d(i, 1) = tx : LET d(i, 2) = ty : LET l(tx, ty) = i : LET l(x, y) = s
4100 PRINT AT 17, 11; INK 2; "<Movement>";
4110 PRINT AT 18, 11; INK u(s, 1); n$(s); INK 4; " moves "; INK u(i, 1); n$(i) ; INK 4; "!";
4120 LET i = p : LET p = q : GO SUB 2860 : LET p = i : GO SUB 2860 : REM draw ships
4130 RETURN 
4140 REM off map check
4150 FOR p = 1 TO t STEP 1
4160 IF d(p, 8) < 1 OR d(p, 1) > 0 THEN GO TO 4240
4170 GO SUB 2160 : REM draw controls
4180 GO SUB 3000 : REM overlay targets
4190 PRINT AT 17, 11; INK 2; "<Movement>";
4200 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " fall into the "; AT 19, 11; "void and are eaten"; AT 20, 11; "by a passing cosmic"; AT 21, 11; "horror.";
4210 LET d(p, 8) = 0
4220 GO SUB 2800 : REM draw shields
4230 GO SUB 2140 : REM any key
4240 NEXT p
4250 RETURN 
4260 REM player attack
4270 PRINT AT 17, 11; INK 2; "<Combat>";
4280 IF a(d(p, 10), 3) = 0 THEN LET s = 0 : GO TO 4650
4290 IF d(p, 3) = 0 THEN LET x = d(p, 1) + a(d(p, 10), 1) : LET y = d(p, 2) + a(d(p, 10), 2) : GO TO 4330
4300 IF d(p, 3) = 1 THEN LET x = d(p, 1) + a(d(p, 10), 2) : LET y = d(p, 2) - a(d(p, 10), 1) : GO TO 4330
4310 IF d(p, 3) = 2 THEN LET x = d(p, 1) - a(d(p, 10), 1) : LET y = d(p, 2) - a(d(p, 10), 2) : GO TO 4330
4320 LET x = d(p, 1) - a(d(p, 10), 2) : LET y = d(p, 2) + a(d(p, 10), 1) 
4330 LET s = 0
4340 FOR q = 1 TO t STEP 1
4350 IF d(q, 1) <>x OR d(q, 2) <>y OR d(q, 8) < 1 THEN GO TO 4640
4360 INK u(p, 1) : GO SUB 2550 : INK 4 : REM clear console
4370 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " attack "; INK u(q, 1); n$(q); INK 4; " x"; a(d(p, 10), 3); 
4380 PAPER u(p, 1) 
4390 LET s = p
4400 LET p = q
4410 GO SUB 2860 : REM draw ship
4420 LET q = p
4430 LET p = s
4440 PAPER 0 
4450 REM resolve shield based on relative positions and q dir
4460 LET tx = d(p, 1) - d(q, 1)
4470 LET ty = d(p, 2) - d(q, 2)
4480 IF ABS tx > ABS ty AND tx > 0 THEN LET s = 6 : GO TO 4520
4490 IF ABS tx > ABS ty THEN LET s = 4 : GO TO 4520
4500 IF ty > 0 THEN LET s = 5 : GO TO 4520
4510 LET s = 7
4520 LET s = s - d(q, 3)
4530 IF s > 7 THEN LET s = s - 4 : GO TO 4550
4540 IF s < 4 THEN LET s = s + 4
4550 LET b = a(d(p, 10), 3)
4560 GO SUB 5160 : REM attack ship q*b
4570 REM refresh attacked ship
4580 LET i = p
4590 LET p = q
4600 GO SUB 2800 : REM draw shields
4610 GO SUB 2140 : REM any key
4620 GO SUB 2860 : REM draw ship
4630 LET p = i
4640 NEXT q
4650 IF s = 0 THEN PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " do not attack.";
4660 RETURN 
4670 REM end game check
4680 LET i = 0
4690 LET q = 1
4700 FOR p = 1 TO t STEP 1
4710 IF d(p, 1) > 0 THEN LET q = p : LET i = i + 1
4720 NEXT p 
4730 REM still at least 2 players
4740 IF i > 1 THEN RETURN 
4750 REM ends game
4760 LET t = 0
4770 REM 1st player or winner colours
4780 LET p = q
4790 GO SUB 2160 : REM draw controls
4800 PRINT AT 17, 11; INK 2; "<GAME OVER>";
4810 IF i = 0 THEN PRINT AT 18, 11; "Everybody is dead."; : GO TO 4830
4820 PRINT AT 18, 11; INK u(p, 1); "SPACE "; n$(p); INK 4; " have won.";
4830 GO SUB 2140 : REM any key
4840 RETURN 
4850 REM resolve AI movement
4860 LET d(p, 9) = 13
4870 IF d(p, 11) = 1 THEN RETURN 
4880 FOR q = 1 TO t STEP 1
4890 IF q = p OR d(q, 1) < 1 THEN GO TO 4930
4900 GO SUB 5100 : REM load tx, ty
4910 LET tx = tx + 4 : LET ty = ty + 3
4920 IF tx > 0 AND tx < 7 AND ty > 0 AND ty < 6 THEN LET d(p, 9) = v(tx, ty) : RETURN 
4930 NEXT q
4940 IF ty > -11 AND ty < 0 THEN LET d(p, 9) = 1 : RETURN 
4950 IF tx > 5 AND tx < 16 THEN LET d(p, 9) = 5 : RETURN 
4960 LET d(p, 9) = 3
4970 RETURN 
4980 REM resolve AI attack
4990 LET b = 18
5000 LET d(p, 10) = 18
5010 FOR q = 1 TO t STEP 1
5020 IF q = p OR d(q, 1) < 1 THEN GO TO 5080
5030 GO SUB 5100 : REM load tx, ty
5040 LET tx = tx + 4
5050 LET ty = ty + 3
5060 IF tx > 0 AND tx < 7 AND ty > 0 AND ty < 6 THEN LET b = ((tx - 1) * 5) + ty
5070 IF a(b, 3) > a(d(p, 10), 3) THEN LET d(p, 10) = b
5080 NEXT q
5090 RETURN 
5100 REM load tx, ty with target relative position
5110 IF d(p, 3) = 0 THEN LET tx = d(q, 1) - d(p, 1) : LET ty = d(q, 2) - d(p, 2) : RETURN 
5120 IF d(p, 3) = 1 THEN LET tx = d(p, 2) - d(q, 2) : LET ty = d(q, 1) - d(p, 1) : RETURN 
5130 IF d(p, 3) = 2 THEN LET tx = d(p, 1) - d(q, 1) : LET ty = d(p, 2) - d(q, 2) : RETURN 
5140 LET tx = d(q, 2) - d(p, 2) : LET ty = d(p, 1) - d(q, 1)
5150 RETURN 
5160 REM attack ship q * b
5170 LET tx = 19
5180 FOR i = 1 TO b STEP 1
5190 IF RND* 9 < 4 THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; : GO TO 5310
5200 IF d(q, 8) = 1 OR RND* 6 > 1 THEN GO TO 5280
5210 IF d(q, s) > 1 AND RND* 6 > 5 THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT! "; INK 4; s$(s - 3); " shields -"; d(q, s); : LET d(q, s) = 0 : GO TO 5300
5220 IF d(q, s) > 0 AND RND* 6 > 5 THEN LET d(q, 8) = d(q, 8) - 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT!"; INK 4; " Hull -1"; : GO TO 5300
5230 IF d(q, 11) > 0 THEN GO TO 5280
5240 IF d(q, s) > 0 THEN LET d(q, s) = d(q, s) - 1 : GO TO 5260
5250 LET d(q, 8) = d(q, 8) - 1
5260 IF RND* 6 > 3 THEN LET d(q, 11) = 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT!"; INK 4; " Engines damaged."; : GO TO 5300
5270 LET d(q, 11) = 2 : PRINT #FN s(tx); AT FN x(tx), 11; INK 2; "HIT!"; INK 4; " Weapons damaged."; : GO TO 5300
5280 IF d(q, s) > 0 THEN LET d(q, s) = d(q, s) - 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! "; s$(s - 3); " shields -1"; : GO TO 5300
5290 IF d(q, 8) > 0 THEN LET d(q, 8) = d(q, 8) - 1 : PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Hull -1"; : GO TO 5300
5300 IF d(q, 8) = 0 THEN PRINT #FN s(tx); AT FN x(tx), 16; INK 4; "Ship destroyed!"; : GO SUB 2950 : RETURN : REM draw target explosion
5310 LET tx = tx + 1
5320 NEXT i
5330 RETURN 
5340 REM move destroyed ships off map
5350 FOR p = 1 TO t STEP 1
5360 REM if ship on map and 0 hull move off map
5370 IF d(p, 1) > 0 AND d(p, 8) < 1 THEN LET l(d(p, 1), d(p, 2)) = 0 : LET d(p, 1) = 0
5380 NEXT p
5390 RETURN 
5400 REM helm computer instructions
5410 CLS 
5420 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE "; n$(p);"           ";
5430 PRINT AT 2, 0; "Note the direction of your ship and consult the "; INK 5; "Helm Computer"; INK 4; ".  You must select a speed A-C and a manoeuvre 1-5."
5440 PRINT AT 7, 0; "Example - A5 performs this move:"
5450 PRINT AT 9, 2; INK u(p, 1); CHR$ (148); CHR$ (156); AT 10, 2; CHR$ (150); CHR$ (157); INK 4; " Also...";
5460 PRINT AT 11, 5; "- Stay within map or die.";
5470 PRINT AT 12, 5; "- Avoid planets."
5480 PRINT AT 13, 0; INK u(p, 1); CHR$ (152); CHR$ (153); INK 4; "   - Optionally ram opponents."; AT 14, 0; INK u(p, 1); CHR$ (150); CHR$ (151);
5490 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
5500 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
5510 PRINT AT 18, 1; " "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
5520 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
5530 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
5540 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
5550 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
5560 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
5570 GO SUB 2140 : REM any key
5580 GO SUB 3130 : REM redraw screen
5590 RETURN 
5600 REM combat display instructions
5610 CLS 
5620 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE "; n$(p);"           ";
5630 PRINT AT 2, 1; "12345  The "; INK 5; "Combat Display"; INK 4; " shows";
5640 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4"; INK 4; " enemies within range and";
5650 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2"; INK 4; " the A-F/1-5 combination";
5660 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1"; INK 4; " to attack. The number of";
5670 PRINT AT 6, 0; "D"; PAPER 6; "  "; INK u(p, 1); PAPER 0; CHR$ (161); AT 6, 4; PAPER 6; "  "; INK 4; PAPER 0; "  attacks correspond to";
5680 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  "; INK 4; PAPER 0; "  the "; INK 2; "red "; INK 4; "and "; INK 6; "yellow";
5690 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " "; INK 4; PAPER 0; "  numbers.";
5700 PRINT AT 9, 4; INK 6; "31";
5710 PRINT AT 11, 8; "A player has 4 shields";
5720 PRINT AT 12, 8; "and a hull. The "; INK 5; "Combat ";
5730 PRINT AT 13, 8; INK 5; "Display"; INK 4; " can be used to";
5740 PRINT AT 14, 8; "see which shield will be";
5750 PRINT AT 15, 8; "hit.";
5760 PRINT AT 17, 0; "The hull is damaged if there areno shields on the attacked side.When the hull reaches 0 the shipis destroyed.";
5770 GO SUB 2800 : REM draw shields
5780 GO SUB 3000 : REM overlay targets
5790 GO SUB 2140 : REM any key
5800 GO SUB 3130 : REM redraw screen
5810 RETURN 
5820 REM about SPACE FLEET
5830 CLS 
5840 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE FLEET           ";
5850 PRINT AT 1, 0; "       ";
5860 PRINT AT 2, 0; "In the grim darkness of the far future, there is only war.";
5870 PRINT AT 5, 0; "Select 2-4 human or AI players, and do turn-based battle using  the "; INK 5; "<Helm Computer>"; INK 4; " for movementand "; INK 5; "<Combat Display>"; INK 4; " to attack.";
5880 PRINT AT 10, 0; "Each are accessed via a console,through which further help is   available by entering [i]."
5890 PRINT AT 14, 0; INK 6; "Press any key to begin."
5900 PRINT #1; AT 0, 0; INK 1; CHR$ (152); CHR$ (153);
5910 PRINT #1; AT 0, 3; INK 2; CHR$ (148); CHR$ (156);
5920 PRINT #1; AT 0, 6; INK 3; CHR$ (148); CHR$ (149);
5930 PRINT #1; AT 0, 9; INK 6; CHR$ (158); CHR$ (149);
5940 PRINT #1; AT 0, 12; INK 5; CHR$ (144); CHR$ (145);
5950 PRINT #1; AT 0, 15; INK 4; CHR$ (144); CHR$ (145);
5960 PRINT #1; AT 0, 18; INK 2; CHR$ (144); CHR$ (145);
5970 PRINT #1; AT 0, 21; INK 3; CHR$ (144); CHR$ (145);
5980 PRINT #1; AT 1, 0; INK 1; CHR$ (150); CHR$ (151);
5990 PRINT #1; AT 1, 3; INK 2; CHR$ (150); CHR$ (157);
6000 PRINT #1; AT 1, 6; INK 3; CHR$ (154); CHR$ (155);
6010 PRINT #1; AT 1, 9; INK 6; CHR$ (159); CHR$ (151);
6020 PRINT #1; AT 1, 12; INK 5; CHR$ (146); CHR$ (147);
6030 PRINT #1; AT 1, 15; INK 4; CHR$ (146); CHR$ (147);
6040 PRINT #1; AT 1, 18; INK 2; CHR$ (146); CHR$ (147);
6050 PRINT #1; AT 1, 21; INK 3; CHR$ (146); CHR$ (147);
6060 PAUSE 0
6070 CLS 
6080 RETURN 
6090 REM attack vectors
6100 DATA -3, -2, 4, -3, -1, 4, -3, 0, 4
6110 DATA -3, 1, 4, -3, 2, 4, -2, -2, 1
6120 DATA -2, -1, 2, -2, 0, 2, -2, 1, 2
6130 DATA -2, 2, 1, -1, -2, 1, -1, -1, 3
6140 DATA -1, 0, 1, -1, 1, 3, -1, 2, 1
6150 DATA 0, -2, 1, 0, -1, 3, 0, 0, 0
6160 DATA 0, 1, 3, 0, 2, 1, 1, -2, 1
6170 DATA 1, -1, 3, 1, 0, 0, 1, 1, 3
6180 DATA 1, 2, 1, 2, -2, 1, 2, -1, 0
6190 DATA 2, 0, 0, 2, 1, 0, 2, 2, 1
6200 REM movement vectors
6210 DATA -2, -1, -1, -2, -1, 0, -2, 0, 0
6220 DATA -2, 1, 0, -2, 1, 1, -1, -1, -1
6230 DATA -1, -1, 0, -1, 0, 0, -1, 1, 0
6240 DATA -1, 1, 1, 0, 0, 0, 0, 0, -1
6250 DATA 0, 0, 0, 0, 0, 1, 0, 0, 0
6260 REM player UIs
6270 DATA 1, 5, 1, 1, 0, 0
6280 DATA 2, 4, 5, 9, 3, 3
6290 DATA 3, 2, 1, 9, 0, 3
6300 DATA 6, 3, 5, 1, 3, 0
6310 REM player names
6320 DATA "FLEET", "ELVES", "CHAOS", "HORDE"
6330 REM UDGs
6340 DATA 0, 3, 15, 31, 63, 63, 127, 127
6350 DATA 0, 192, 240, 248, 252, 252, 254, 254 
6360 DATA 127, 127, 63, 63, 31, 15, 3, 0 
6370 DATA 254, 254, 252, 252, 248, 240, 192, 0
6380 DATA 0, 0, 0, 0, 1, 7, 7, 15
6390 DATA 0, 0, 0, 0, 128, 224, 224, 240 
6400 DATA 15, 7, 7, 1, 0, 0, 0, 0
6410 DATA 240, 224, 224, 128, 0, 0, 0, 0
6420 DATA 0, 0, 0, 5, 15, 7, 15, 7
6430 DATA 0, 0, 0, 160, 240, 224, 240, 224
6440 DATA 7, 15, 7, 15, 5, 0, 0, 0 
6450 DATA 224, 240, 224, 240, 160, 0, 0, 0 
6460 DATA 0, 0, 0, 0, 80, 248, 240, 248 
6470 DATA 248, 240, 248, 80, 0, 0, 0, 0 
6480 DATA 0, 0, 0, 0, 10, 31, 15, 31 
6490 DATA 31, 15, 31, 10, 0, 0, 0, 0 
6500 DATA 0, 0, 0, 60, 60, 0, 0, 0 
6510 DATA 0, 0, 24, 24, 24, 24, 0, 0 
6520 DATA 0, 0, 0, 0, 24, 0, 0, 0
6530 REM movement ai behaviour
6540 DATA 1, 2, 3, 4, 5
6550 DATA 6, 7, 8, 9, 10
6560 DATA 12, 12, 14, 14, 14
6570 DATA 12, 12, 12, 14, 14
6580 DATA 12, 12, 14, 14, 14
6590 DATA 12, 12, 12, 14, 14
6600 REM shield names
6610 DATA "Front", "Right", " Rear", " Left"
6620 REM player data
6630 DATA 1, 1, 2, 3, 3, 3, 3, 4, 0, 0, 0
6640 DATA 8, 12, 0, 3, 3, 3, 3, 4, 0, 0, 0
6650 DATA 1, 12, 2, 3, 3, 3, 3, 4, 0, 0, 0
6660 DATA 8, 1, 0, 3, 3, 3, 3, 4, 0, 0, 0
