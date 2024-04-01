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
270 REM debug 1 or 0 TODO remember to remove
280 LET d = 0
290 REM load attack vectors
300 RESTORE 5360
310 FOR x = 1  TO 30  STEP 1
320 FOR y = 1  TO 3  STEP 1
330 READ a(x, y)
340 NEXT y
350 NEXT x
360 REM load movement vectors
370 RESTORE 5470
380 FOR x = 1  TO 15  STEP 1
390 FOR y = 1  TO 3  STEP 1
400 READ m(x, y)
410 NEXT y
420 NEXT x
430 REM load player UIs, names and shields
440 RESTORE 5530
450 FOR x = 1  TO 4  STEP 1
460 FOR y = 1  TO 6  STEP 1
470 READ u(x, y)
480 NEXT y
490 NEXT x
500 RESTORE 5580
510 FOR x = 1  TO 4  STEP 1
520 READ n$(x)
530 NEXT x
540 RESTORE 5920
550 FOR x = 1  TO 4  STEP 1
560 READ s$(x)
570 NEXT x
580 REM load movement ai behaviours
590 RESTORE 5850
600 FOR x = 1  TO 6  STEP 1
610 FOR y = 1  TO 5  STEP 1
620 READ v(x, y)
630 NEXT y
640 NEXT x
650 REM load UDGs
660 LET i = USR "a"
670 LET t = i+8*19-1
680 RESTORE 5650
690 FOR x = i  TO t  STEP 1
700 READ y
710 POKE x, y
720 NEXT x
730 LET k$ = ""
740 CLS 
750 GO SUB 1330
760 GO SUB 1870
770 GO SUB 1230
780 IF k$ <>"Y" THEN GO TO 740
790 REM main game loop
800 FOR p = 1  TO t  STEP 1
810 REM movement phase
820 IF d(p, 1) = 0  THEN GO TO 900 :REM dead
830 IF p > (t - u)  THEN GO SUB 5070 :GO TO 900 :REM AI
840 LET k$ = ""
850 GO SUB 2400
860 GO SUB 3070
870 GO SUB 1960
880 GO SUB 1870
890 IF k$ <>"Y" THEN GO TO 840
900 NEXT p
910 REM apply movement
920 GO SUB 3380
930 GO SUB 3790
940 GO SUB 4310
950 GO SUB 1230
960 REM combat phase
970 FOR p = 1  TO t  STEP 1
980 IF d(p, 8) < 1  THEN GO TO 1070 :REM dead
990 IF p > (t - u)  THEN GO SUB 5190 :GO TO 1070 :REM AI
1000 LET k$ = ""
1010 GO SUB 2400
1020 GO SUB 3070
1030 IF i = 0  THEN LET d(p, 10) = 18 :PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " cannot attack.":GO TO 1070
1040 GO SUB 2150
1050 GO SUB 1870
1060 IF k$ <>"Y" THEN GO TO 1010
1070 REM next attack input     
1080 NEXT p
1090 REM apply combat
1100 FOR p = 1  TO t  STEP 1
1110 REM if ship on map
1120 IF d(p, 1) > 0  THEN GO SUB 2400 :GO SUB 3070 :GO SUB 4410
1130 NEXT p 
1140 REM move killed ships off map
1150 FOR p = 1  TO t  STEP 1
1160 REM if ship on map and 0 hull move off map
1170 IF d(p, 1) > 0  AND d(p, 8) < 1  THEN LET l(d(p, 1), d(p, 2)) = 0 :LET d(p, 1) = 0
1180 NEXT p
1190 GO SUB 4890
1200 GO SUB 1230
1210 IF t > 0  THEN GO TO 800
1220 GO TO 740
1230 REM debug draw map
1240 IF d = 0  THEN RETURN 
1250 FOR x = 1  TO 8  STEP 1
1260 FOR y = 1  TO 12  STEP 1
1270 LET tx = (x - 1) * 2
1280 LET ty = ((y - 1) * 2) + 8
1290 PRINT AT tx, ty; l(x, y);
1300 NEXT Y
1310 NEXT x
1320 RETURN 
1330 REM initialise game
1340 LET p = 1
1350 LET t = 0
1360 GO SUB 2400
1370 PRINT AT 17, 11; INK 5; "<SPACE FLEET>";
1380 PRINT AT 19, 11; "Enter players 2-4? "; FLASH 1; CHR$ (143);
1390 PAUSE 0
1400 LET k$ = INKEY$ 
1410 IF CODE (k$) < 50  OR CODE (k$) > 52  THEN GO TO 1390
1420 PRINT AT 19, 30; k$;
1430 LET t = VAL (k$)
1440 PRINT AT 20, 11; "AI players 0-"; t-1; "? "; FLASH 1; CHR$ (143);
1450 PAUSE 0
1460 LET k$ = INKEY$ 
1470 IF CODE (k$) < 48  OR CODE (k$) > 48+t-1  THEN GO TO 1450
1480 PRINT AT 20, 27; k$;
1490 LET u = VAL (k$)
1500 PRINT AT 21, 11; "Loading map...";
1510 REM clear map
1520 FOR y = 1  TO 12  STEP 1
1530 FOR x = 1  TO 8
1540 LET l(x, y) = 0
1550 NEXT x
1560 NEXT y 
1570 REM load player data
1580 RESTORE 5600
1590 FOR x = 1  TO t  STEP 1
1600 FOR y = 1  TO 10  STEP 1
1610 READ d(x, y)
1620 NEXT y
1630 LET l(d(x, 1), d(x, 2)) = x :REM 1-4=player
1640 NEXT x
1650 REM generate planet locations
1660 RANDOMIZE 0
1670 FOR p = 1  TO 4 
1680 REM randomise planet locations
1690 LET x = INT (RND * 4) + u(p, 3)
1700 LET y = INT (RND * 4) + u(p, 4)
1710 REM avoid edges
1720 IF x < 2  OR x > 7  OR y < 2  OR y > 11  THEN GO TO 1680
1730 REM update map and draw planet
1740 LET l(x, y) = 4 + p :REM 5+=planet
1750 LET tx = (x - 1) * 2
1760 LET ty = ((y - 1) * 2) + 8
1770 LET c(p, 1) = tx
1780 LET c(p, 2) = ty
1790 PRINT AT tx, ty; INK u(p, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
1800 NEXT p
1810 REM draw players
1820 FOR p = 1  TO t  STEP 1
1830 GO SUB 2870
1840 GO SUB 2930
1850 NEXT p
1860 RETURN 
1870 REM console confirm
1880 PRINT #1; AT 1, 11; INK 6; "Confirm Y/N? "; FLASH 1; CHR$ (143);
1890 PAUSE 0
1900 LET k$ = INKEY$ 
1910 IF k$ = "y" OR k$ = "Y" THEN LET k$ = "Y":GO TO 1940
1920 IF k$ = "n" OR k$ = "N" THEN LET k$ = "N":GO TO 1940
1930 GO TO 1890
1940 PRINT #1; AT 1, 24; INK 6; k$;
1950 RETURN 
1960 REM console movement
1970 PRINT AT 17, 11; INK 5; "<Helm Computer>";
1980 PRINT AT 19, 11; "Speed A/B/C? "; FLASH 1; CHR$ (143);
1990 PRINT AT 20, 11; "[i] for instructions.";
2000 LET d(p, 9) = 1
2010 PAUSE 0 
2020 IF INKEY$ = "A" OR INKEY$ = "a" THEN LET d(p, 9) = 0 :LET k$ = "A":GO TO 2060
2030 IF INKEY$ = "B" OR INKEY$ = "b" THEN LET d(p, 9) = 5 :LET k$ = "B":GO TO 2060
2040 IF INKEY$ = "C" OR INKEY$ = "c" THEN LET d(p, 9) = 10 :LET k$ = "C":GO TO 2060
2050 IF INKEY$ = "I" OR INKEY$ = "i" THEN GO SUB 5930 :GO TO 1970
2060 IF d(p, 9) = 1  THEN GO TO 2010
2070 PRINT AT 19, 24; k$;
2080 PRINT AT 20, 11; "Movement 1-5? "; FLASH 1; CHR$ (143); FLASH 0; "      ";
2090 PAUSE 0
2100 LET k$ = INKEY$ 
2110 IF CODE (k$) < 49  OR CODE (k$) > 53  THEN GO TO 2090
2120 PRINT AT 20, 25; k$;
2130 LET d(p, 9) = d(p, 9) + VAL (k$) 
2140 RETURN 
2150 REM console attack
2160 PRINT AT 17, 11; INK 5; "<Combat Display>";
2170 PRINT AT 19, 11; "Distance A-F? "; FLASH 1; CHR$ (143); 
2180 PRINT AT 20, 11; "[i] for instructions.";
2190 LET d(p, 10) = 1
2200 PAUSE 0 
2210 IF INKEY$ = "A" OR INKEY$ = "a" THEN LET d(p, 10) = 0 :LET k$ = "A":GO TO 2280
2220 IF INKEY$ = "B" OR INKEY$ = "b" THEN LET d(p, 10) = 5 :LET k$ = "B":GO TO 2280
2230 IF INKEY$ = "C" OR INKEY$ = "c" THEN LET d(p, 10) = 10 :LET k$ = "C":GO TO 2280
2240 IF INKEY$ = "D" OR INKEY$ = "d" THEN LET d(p, 10) = 15 :LET k$ = "D":GO TO 2280
2250 IF INKEY$ = "E" OR INKEY$ = "e" THEN LET d(p, 10) = 20 :LET k$ = "E":GO TO 2280
2260 IF INKEY$ = "F" OR INKEY$ = "f" THEN LET d(p, 10) = 25 :LET k$ = "F":GO TO 2280
2270 IF INKEY$ = "I" OR INKEY$ = "i" THEN GO SUB 6060 :GO TO 2160
2280 IF d(p, 10) = 1  THEN GO TO 2200
2290 PRINT AT 19, 25; k$;
2300 PRINT AT 20, 11; "Arc 1-5? "; FLASH 1; CHR$ (143); FLASH 0; "           ";
2310 LET k$ = ""
2320 PAUSE 0
2330 LET k$ = INKEY$ 
2340 IF CODE (k$) < 49  OR CODE (k$) > 53  THEN GO TO 2320
2350 PRINT AT 20, 20; k$;
2360 LET d(p, 10) = d(p, 10) + VAL (k$) 
2370 RETURN 
2380 REM console any key
2390 PRINT #1; AT 1, 11; INK 6; "Press any key."; :PAUSE 0 :RETURN 
2400 REM draw common controls
2410 PRINT AT 0, 0; INK 5; "Combat";
2420 PRINT AT 1, 0; INK 5; "Display";
2430 PRINT AT 2, 1; "12345";
2440 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4";
2450 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2";
2460 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1";
2470 PRINT AT 6, 0; "D"; PAPER 6; "  "; AT 6, 4; PAPER 6; "  ";
2480 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  ";
2490 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " ";
2500 PRINT AT 9, 4; INK 6; "31";
2510 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
2520 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
2530 PRINT AT 18, 1; " "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
2540 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
2550 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
2560 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
2570 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
2580 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
2590 REM draw player controls and clear console
2600 INK u(p, 1)
2610 PRINT AT 0, 6; CHR$ (133); CHR$ (161);
2620 PRINT AT 1, 7; CHR$ (161);
2630 PRINT AT 2, 0; CHR$ (138); AT 2, 6; CHR$ (133); CHR$ (161);
2640 PRINT AT 3, 7; CHR$ (161);
2650 PRINT AT 4, 7; CHR$ (161);
2660 PRINT AT 5, 7; CHR$ (161);
2670 PRINT AT 6, 3; CHR$ (161); AT 6, 6; CHR$ (133); CHR$ (161);
2680 PRINT AT 7, 6; CHR$ (133); CHR$ (161);
2690 PRINT AT 8, 6; CHR$ (133); CHR$ (161);
2700 PRINT AT 9, 0; CHR$ (142); CHR$ (140); CHR$ (140); CHR$ (140); AT 9, 6; CHR$ (141); CHR$ (161);
2710 PRINT AT 10, 6; CHR$ (133); CHR$ (161);
2720 PRINT AT 11, 6; CHR$ (133); CHR$ (161);
2730 PRINT AT 12, 6; CHR$ (133); CHR$ (161);
2740 PRINT AT 13, 6; CHR$ (133); CHR$ (161);
2750 PRINT AT 14, 6; CHR$ (133); CHR$ (161);
2760 PRINT AT 15, 6; CHR$ (133); CHR$ (161);
2770 PRINT AT 16, 4; CHR$ (140); AT 16, 13; CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); INK 7; PAPER 0; "SPACE"; INK u(p, 1); CHR$ (140); INK 7; n$(p);
2780 PRINT AT 17, 10; CHR$ (138); "                     ";
2790 PRINT AT 18, 10; CHR$ (138); "                     ";
2800 PRINT AT 19, 10; CHR$ (138); "                     ";
2810 PRINT AT 20, 10; CHR$ (138); "                     ";
2820 PRINT AT 21, 10; CHR$ (138); "                     ";
2830 PRINT #1; AT 0, 10; INK u(p, 1); CHR$ (138); "                     ";
2840 PRINT #1; AT 1, 10; INK u(p, 1); CHR$ (138); "                     ";
2850 INK 4
2860 RETURN 
2870 REM draw player shields
2880 IF d(p, 8) < 1  THEN PRINT AT 10 + u(p, 5), 1 + u(p, 6); " "; AT 11 + u(p, 5), u(p, 6); "   "; AT 12 + u(p, 5), 1 + u(p, 6); " "; :RETURN 
2890 PRINT AT 10 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 4);
2900 PRINT AT 11 + u(p, 5), u(p, 6); INK u(p, 1); d(p, 7); INK 0; PAPER u(p, 1); d(p, 8); INK u(p, 1); PAPER 0; d(p, 5);
2910 PRINT AT 12 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 6);
2920 RETURN 
2930 REM draw player ship
2940 LET tx = (d(p, 1) - 1) * 2
2950 LET ty = ((d(p, 2) - 1) * 2) + 8
2960 IF d(p, 8) = 0  THEN PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; :RETURN 
2970 IF d(p, 3) = 0  THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (152); CHR$ (153); AT tx + 1, ty; CHR$ (150); CHR$ (151); :RETURN 
2980 IF d(p, 3) = 1  THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (156); AT tx + 1, ty; CHR$ (150); CHR$ (157); :RETURN 
2990 IF d(p, 3) = 2  THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (149); AT tx + 1, ty; CHR$ (154); CHR$ (155); :RETURN 
3000 PRINT AT tx, ty; INK u(p, 1); CHR$ (158); CHR$ (149); AT tx + 1, ty; CHR$ (159); CHR$ (151);
3010 RETURN 
3020 REM draw target explosion
3030 LET tx = (d(q, 1) - 1) * 2
3040 LET ty = ((d(q, 2) - 1) * 2) + 8
3050 PRINT AT tx, ty; INK 6; PAPER 2; FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
3060 RETURN 
3070 REM overlay and count targets
3080 LET i = 0 
3090 FOR q = 1  TO t  STEP 1
3100 IF q = p  OR d(q, 1) < 1  THEN GO TO 3180
3110 GO SUB 5290 :REM load tx, ty
3120 LET tx = tx + 4 :LET ty = ty + 3
3130 IF tx < 1  OR tx > 6  OR ty < 1  OR ty > 5  THEN GO TO 3180
3140 LET s = d(p, 3) + d(q, 3)
3150 IF s = 1  OR s = 3  OR s = 5  THEN PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (160); :GO TO 3170
3160 PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (161);
3170 IF a(((tx - 1) * 5) + ty, 3) > 0  THEN LET i = i + 1
3180 NEXT q
3190 RETURN 
3200 REM redraw screen
3210 CLS 
3220 GO SUB 2400
3230 LET q = p
3240 FOR i = 1  TO t  STEP 1
3250 LET p = i
3260 IF d(p, 8) = 0  OR d(p, 1) < 1  THEN GO TO 3290
3270 GO SUB 2870
3280 GO SUB 2930
3290 NEXT i
3300 LET p = q
3310 GO SUB 3070
3320 FOR i = 1  TO 4  STEP 1
3330 LET tx = c(i, 1)
3340 LET ty = c(i, 2)
3350 PRINT AT tx, ty; INK u(i, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
3360 NEXT i
3370 RETURN 
3380 REM apply movement
3390 FOR p = 1  TO t  STEP 1
3400 IF d(p, 1) < 1  THEN GO TO 3550
3410 IF d(p, 3) = 0  THEN LET x = d(p, 1) + m(d(p, 9), 1) :LET y = d(p, 2) + m(d(p, 9), 2) :GO TO 3450
3420 IF d(p, 3) = 1  THEN LET x = d(p, 1) + m(d(p, 9), 2) :LET y = d(p, 2) - m(d(p, 9), 1) :GO TO 3450
3430 IF d(p, 3) = 2  THEN LET x = d(p, 1) - m(d(p, 9), 1) :LET y = d(p, 2) - m(d(p, 9), 2) :GO TO 3450
3440 LET x = d(p, 1) - m(d(p, 9), 2) :LET y = d(p, 2) + m(d(p, 9), 1)
3450 IF x < 1  OR x > 8  OR y < 1  OR y > 12  THEN LET x = 0 :GO TO 3470
3460 GO SUB 3570
3470 LET l(d(p, 1), d(p, 2)) = 0 :REM clear map
3480 LET tx = (d(p, 1) - 1) * 2 :LET ty = ((d(p, 2) - 1) * 2) + 8 :REM clear screen pos 1
3490 LET d(p, 1) = x :LET d(p, 2) = y :REM update player
3500 LET d(p, 3) = d(p, 3) + m(d(p, 9), 3) :REM update dir
3510 IF d(p, 3) > 3  THEN LET d(p, 3) = d(p, 3) - 4 :GO TO 3530
3520 IF d(p, 3) < 0  THEN LET d(p, 3) = d(p, 3) + 4
3530 PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; :REM clear screen pos 2
3540 IF x > 0  THEN LET l(x, y) = p :GO SUB 2930
3550 NEXT p
3560 RETURN 
3570 REM planet collision check
3580 IF l(x, y) < 5  THEN RETURN 
3590 GO SUB 2400
3600 GO SUB 3070
3610 PRINT AT 17, 11; INK 2; "<Movement>";
3620 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " ram planet! x4";
3630 LET tx = 19
3640 FOR i = 1  TO 4  STEP 1
3650 IF RND * 9 < 5  THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; :GO TO 3690
3660 IF d(p, 4) > 0  THEN LET d(p, 4) = d(p, 4) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! "; s$(1); " shields -1"; :GO TO 3690
3670 IF d(p, 8) > 1  THEN LET d(p, 8) = d(p, 8) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! Hull -1"; :GO TO 3690
3680 IF d(p, 8) = 1  THEN LET d(p, 8) = 0 :LET x = 0 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "REM! Ship destroyed!"; :LET q = p :GO SUB 3020 :GO TO 3750
3690 LET tx = tx + 1
3700 NEXT i
3710 IF d(p, 3) = 0  THEN LET x = x + 1 :GO TO 3750
3720 IF d(p, 3) = 1  THEN LET y = y - 1 :GO TO 3750
3730 IF d(p, 3) = 2  THEN LET x = x - 1 :GO TO 3750
3740 LET y = y + 1
3750 GO SUB 2870
3760 GO SUB 2380
3770 IF x > 0  THEN GO SUB 3570
3780 RETURN 
3790 REM player collision check
3800 FOR p = 1  TO t  STEP 1
3810 IF d(p, 1) < 1  THEN GO TO 4120
3820 GO SUB 2930
3830 FOR q = 1  TO t  STEP 1
3840 IF p = q  OR d(q, 1) < 1  OR d(p, 1) <>d(q, 1)  OR d(p, 2) <>d(q, 2)  THEN GO TO 4110
3850 REM collision!
3860 GO SUB 2400
3870 LET tx = 19
3880 PRINT AT 17, 11; INK 2; "<Movement>";
3890 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " ram "; INK u(q, 1); n$(q); INK 4; " x4";
3900 LET s = d(p, 3) - d(q, 3) + 6
3910 IF s > 7  THEN LET s = s - 4 :GO TO 3930
3920 IF s < 4  THEN LET s = s + 4
3930 FOR i = 1  TO 4  STEP 1
3940 IF RND * 9 < 5  THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; :GO TO 3980
3950 IF d(q, s) > 0  THEN LET d(q, s) = d(q, s) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! "; s$(s - 3); " shields -1"; :GO TO 3980
3960 IF d(q, 8) > 1  THEN LET d(q, 8) = d(q, 8) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! Hull -1"; :GO TO 3980
3970 IF d(q, 8) = 1  THEN LET d(q, 8) = 0 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! Ship destroyed!"; :GO TO 4000
3980 LET tx = tx + 1
3990 NEXT i
4000 LET tx = (d(p, 1) - 1) * 2
4010 LET ty = ((d(p, 2) - 1) * 2) + 8
4020 PRINT AT tx, ty; INK u(p, 1); PAPER u(q, 1); FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
4030 GO SUB 2380
4040 LET i = p
4050 LET p = q
4060 GO SUB 2870
4070 IF d(i, 8) = 0  THEN GO SUB 2930
4080 LET p = i
4090 IF d(q, 8) = 0  THEN GO SUB 2930
4100 IF d(p, 8) > 0  AND d(q, 8) > 0  AND p > q  THEN GO SUB 4140
4110 NEXT q
4120 NEXT p
4130 RETURN 
4140 REM move one player
4150 GO SUB 2590
4160 LET x = d(i, 1)
4170 LET y = d(i, 2)
4180 LET tx = d(i, 1) - 1 + INT (RND * 2)
4190 LET ty = d(i, 2) - 1 + INT (RND * 2)
4200 IF tx < 1  OR tx > 8  OR ty < 1  OR ty > 12  THEN GO TO 4180
4210 IF l(tx, ty) > 0  THEN GO TO 4180
4220 REM choose winner
4230 IF INT RND * 3 > 2  THEN LET i = p :LET s = q :GO TO 4260
4240 LET i = q :LET s = p
4250 REM move player and update map
4260 LET d(i, 1) = tx :LET d(i, 2) = ty :LET l(tx, ty) = i :LET l(x, y) = s
4270 PRINT AT 17, 11; INK 2; "<Movement>";
4280 PRINT AT 18, 11; INK u(s, 1); n$(s); INK 4; " moves "; INK u(i, 1); n$(i) ; INK 4; "!";
4290 LET i = p :LET p = q :GO SUB 2930 :LET p = i :GO SUB 2930
4300 RETURN 
4310 REM off map check
4320 FOR p = 1  TO t  STEP 1
4330 IF d(p, 8) < 1  OR d(p, 1) > 0  THEN GO TO 4390
4340 GO SUB 2400
4350 GO SUB 3070
4360 PRINT AT 17, 11; INK 2; "<Movement>";
4370 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " fall into the "; AT 19, 11; "void and are eaten"; AT 20, 11; "by a passing cosmic"; AT 21, 11; "horror.";
4380 LET d(p, 8) = 0 :GO SUB 2380
4390 NEXT p
4400 RETURN 
4410 REM player attack
4420 IF a(d(p, 10), 3) = 0  THEN LET s = 0 :GO TO 4870
4430 IF d(p, 3) = 0  THEN LET x = d(p, 1) + a(d(p, 10), 1) :LET y = d(p, 2) + a(d(p, 10), 2) :GO TO 4470
4440 IF d(p, 3) = 1  THEN LET x = d(p, 1) + a(d(p, 10), 2) :LET y = d(p, 2) - a(d(p, 10), 1) :GO TO 4470
4450 IF d(p, 3) = 2  THEN LET x = d(p, 1) - a(d(p, 10), 1) :LET y = d(p, 2) - a(d(p, 10), 2) :GO TO 4470
4460 LET x = d(p, 1) - a(d(p, 10), 2) :LET y = d(p, 2) + a(d(p, 10), 1) 
4470 LET s = 0
4480 PRINT AT 17, 11; INK 2; "<Combat>";
4490 FOR q = 1  TO t  STEP 1
4500 IF d(q, 1) <>x  OR d(q, 2) <>y  THEN GO TO 4860
4510 INK u(p, 1) :GO SUB 2790 :INK 4
4520 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " attack "; INK u(q, 1); n$(q); INK 4; " x"; a(d(p, 10), 3); 
4530 PAPER u(p, 1) 
4540 LET s = p
4550 LET p = q
4560 GO SUB 2930
4570 LET q = p
4580 LET p = s
4590 PAPER 0 
4600 REM resolve shield based on relative positions and q dir
4610 LET tx = d(p, 1) - d(q, 1)
4620 LET ty = d(p, 2) - d(q, 2)
4630 IF ABS tx > ABS ty  AND tx > 0  THEN LET s = 6 :GO TO 4670
4640 IF ABS tx > ABS ty  THEN LET s = 4 :GO TO 4670
4650 IF ty > 0  THEN LET s = 5 :GO TO 4670
4660 LET s = 7
4670 LET s = s - d(q, 3)
4680 IF s > 7  THEN LET s = s - 4 :GO TO 4700
4690 IF s < 4  THEN LET s = s + 4
4700 LET tx = 19
4710 FOR i = 1  TO a(d(p, 10), 3)  STEP 1
4720 IF d(q, 8) < 1  THEN GO TO 4770
4730 IF RND * 9 < 5  THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; :GO TO 4770
4740 IF d(q, s) > 0  THEN LET d(q, s) = d(q, s) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! "; s$(s - 3); " shields -1"; :GO TO 4770
4750 IF d(q, 8) > 1  THEN LET d(q, 8) = d(q, 8) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Hull -1"; :GO TO 4770
4760 IF d(q, 8) = 1  THEN LET d(q, 8) = 0 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Ship destroyed!"; :GO SUB 3020 :GO SUB 2380
4770 LET tx = tx + 1
4780 NEXT i
4790 REM refresh attacked ship
4800 LET i = p
4810 LET p = q
4820 GO SUB 2870
4830 GO SUB 2380
4840 GO SUB 2930
4850 LET p = i
4860 NEXT q
4870 IF s = 0  THEN PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " do not attack.";
4880 RETURN 
4890 REM end game check
4900 LET i = 0
4910 LET q = 1
4920 FOR p = 1  TO t  STEP 1
4930 IF d(p, 1) > 0  THEN LET q = p :LET i = i + 1
4940 NEXT p 
4950 REM still at least 2 players
4960 IF i > 1  THEN RETURN 
4970 REM ends game
4980 LET t = 0
4990 REM 1st player or winner colours
5000 LET p = q
5010 GO SUB 2400
5020 PRINT AT 17, 11; INK 2; "<GAME OVER>";
5030 IF i = 0  THEN PRINT AT 18, 11; "Everybody is dead."; :GO TO 5050
5040 PRINT AT 18, 11; INK u(p, 1); "SPACE "; n$(p); INK 4; " have won.";
5050 GO SUB 2380
5060 RETURN 
5070 REM resolve AI movement
5080 LET d(p, 9) = 0
5090 FOR q = 1  TO t  STEP 1
5100 IF q = p  OR d(q, 1) < 1  THEN GO TO 5140
5110 GO SUB 5290 :REM load tx, ty
5120 LET tx = tx + 4 :LET ty = ty + 3
5130 IF tx > 0  AND tx < 7  AND ty > 0  AND ty < 6  THEN LET d(p, 9) = v(tx, ty) :RETURN 
5140 NEXT q
5150 IF ty > -11  AND ty < 0  THEN LET d(p, 9) = 1 :RETURN 
5160 IF tx > 5  AND tx < 16  THEN LET d(p, 9) = 5 :RETURN 
5170 LET d(p, 9) = 3
5180 RETURN 
5190 REM resolve AI attack
5200 LET d(p, 10) = 0
5210 FOR q = 1  TO t  STEP 1
5220 IF q = p  OR d(q, 1) < 1  THEN GO TO 5260
5230 GO SUB 5290 :REM load tx, ty
5240 LET tx = tx + 4 :LET ty = ty + 3
5250 IF tx > 0  AND tx < 7  AND ty > 0  AND ty < 6  THEN LET d(p, 10) = ((tx - 1) * 5) + ty :RETURN 
5260 NEXT q
5270 IF d(p, 10) = 0  THEN LET d(p, 10) = 19
5280 RETURN 
5290 REM load tx, ty with target relative position
5300 IF d(p, 3) = 0  THEN LET tx = d(q, 1) - d(p, 1) :LET ty = d(q, 2) - d(p, 2) :RETURN 
5310 IF d(p, 3) = 1  THEN LET tx = d(p, 2) - d(q, 2) :LET ty = d(q, 1) - d(p, 1) :RETURN 
5320 IF d(p, 3) = 2  THEN LET tx = d(p, 1) - d(q, 1) :LET ty = d(p, 2) - d(q, 2) :RETURN 
5330 LET tx = d(q, 2) - d(p, 2) :LET ty = d(p, 1) - d(q, 1)
5340 RETURN 
5350 REM attack vectors data
5360 DATA -3, -2, 4, -3, -1, 4, -3, 0, 4
5370 DATA -3, 1, 4, -3, 2, 4, -2, -2, 1
5380 DATA -2, -1, 2, -2, 0, 2, -2, 1, 2
5390 DATA -2, 2, 1, -1, -2, 1, -1, -1, 3
5400 DATA -1, 0, 1, -1, 1, 3, -1, 2, 1
5410 DATA 0, -2, 1, 0, -1, 3, 0, 0, 0
5420 DATA 0, 1, 3, 0, 2, 1, 1, -2, 1
5430 DATA 1, -1, 3, 1, 0, 0, 1, 1, 3
5440 DATA 1, 2, 1, 2, -2, 1, 2, -1, 0
5450 DATA 2, 0, 0, 2, 1, 0, 2, 2, 1
5460 REM movement vectors data
5470 DATA -2, -1, -1, -2, -1, 0, -2, 0, 0
5480 DATA -2, 1, 0, -2, 1, 1, -1, -1, -1
5490 DATA -1, -1, 0, -1, 0, 0, -1, 1, 0
5500 DATA -1, 1, 1, 0, 0, 0, 0, 0, -1
5510 DATA 0, 0, 0, 0, 0, 1, 0, 0, 0
5520 REM player UIs data
5530 DATA 1, 5, 1, 1, 0, 0
5540 DATA 2, 4, 5, 9, 3, 3
5550 DATA 3, 2, 1, 9, 0, 3
5560 DATA 6, 3, 5, 1, 3, 0
5570 REM player names data
5580 DATA "FLEET", "ELVES", "CHAOS", "HORDE"
5590 REM player data
5600 DATA 1, 1, 2, 3, 3, 3, 3, 4, 0, 0
5610 DATA 8, 12, 0, 3, 3, 3, 3, 4, 0, 0
5620 DATA 1, 12, 2, 3, 3, 3, 3, 4, 0, 0
5630 DATA 8, 1, 0, 3, 3, 3, 3, 4, 0, 0
5640 REM UDGs data
5650 DATA 0, 3, 15, 31, 63, 63, 127, 127
5660 DATA 0, 192, 240, 248, 252, 252, 254, 254 
5670 DATA 127, 127, 63, 63, 31, 15, 3, 0 
5680 DATA 254, 254, 252, 252, 248, 240, 192, 0
5690 DATA 0, 0, 0, 0, 1, 7, 7, 15
5700 DATA 0, 0, 0, 0, 128, 224, 224, 240 
5710 DATA 15, 7, 7, 1, 0, 0, 0, 0
5720 DATA 240, 224, 224, 128, 0, 0, 0, 0
5730 DATA 0, 0, 0, 5, 15, 7, 15, 7
5740 DATA 0, 0, 0, 160, 240, 224, 240, 224
5750 DATA 7, 15, 7, 15, 5, 0, 0, 0 
5760 DATA 224, 240, 224, 240, 160, 0, 0, 0 
5770 DATA 0, 0, 0, 0, 80, 248, 240, 248 
5780 DATA 248, 240, 248, 80, 0, 0, 0, 0 
5790 DATA 0, 0, 0, 0, 10, 31, 15, 31 
5800 DATA 31, 15, 31, 10, 0, 0, 0, 0 
5810 DATA 0, 0, 0, 60, 60, 0, 0, 0 
5820 DATA 0, 0, 24, 24, 24, 24, 0, 0 
5830 DATA 0, 0, 0, 0, 24, 0, 0, 0
5840 REM movement ai behaviour data
5850 DATA 1, 2, 3, 4, 5
5860 DATA 6, 7, 8, 9, 10
5870 DATA 12, 12, 13, 14, 14
5880 DATA 12, 12, 13, 14, 14
5890 DATA 12, 12, 13, 14, 14
5900 DATA 12, 12, 13, 14, 14
5910 REM shields
5920 DATA "Front", "Right", " Rear", " Left"
5930 REM helm computer instructions
5940 CLS 
5950 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
5960 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
5970 PRINT AT 18, 1; " "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
5980 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
5990 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
6000 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
6010 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
6020 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
6030 GO SUB 2380
6040 GO SUB 3200
6050 RETURN 
6060 REM combat display instructions
6070 CLS 
6080 PRINT AT 0, 0; INK 5; "Combat";
6090 PRINT AT 1, 0; INK 5; "Display";
6100 PRINT AT 2, 1; "12345";
6110 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4";
6120 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2";
6130 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1";
6140 PRINT AT 6, 0; "D"; PAPER 6; "  "; AT 6, 4; PAPER 6; "  ";
6150 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  ";
6160 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " ";
6170 PRINT AT 9, 4; INK 6; "31";
6180 GO SUB 2380
6190 GO SUB 3200
6200 RETURN 
