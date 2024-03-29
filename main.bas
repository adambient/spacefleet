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
210 REM player UIs: 1:ship,2:planet,3:planet-x,4:planet-y;5:shield-x;6:shield-y
220 DIM u(4, 6)
230 REM movement ai behaviours
240 DIM v(6, 5)
250 REM debug 1 or 0 TODO remember to remove
260 LET d = 0
270 REM load attack vectors
280 RESTORE 4880
290 FOR x = 1  TO 30  STEP 1
300 FOR y = 1  TO 3  STEP 1
310 READ a(x, y)
320 NEXT y
330 NEXT x
340 REM load movement vectors
350 RESTORE 4990
360 FOR x = 1  TO 15  STEP 1
370 FOR y = 1  TO 3  STEP 1
380 READ m(x, y)
390 NEXT y
400 NEXT x
410 REM load player UIs, names and shields
420 RESTORE 5050
430 FOR x = 1  TO 4  STEP 1
440 FOR y = 1  TO 6  STEP 1
450 READ u(x, y)
460 NEXT y
470 NEXT x
480 RESTORE 5100
490 FOR x = 1  TO 4  STEP 1
500 READ n$(x)
510 NEXT x
520 RESTORE 5440
530 FOR x = 1  TO 4  STEP 1
540 READ s$(x)
550 NEXT x
560 REM load movement ai behaviours
570 RESTORE 5370
580 FOR x = 1  TO 6  STEP 1
590 FOR y = 1  TO 5  STEP 1
600 READ v(x, y)
610 NEXT y
620 NEXT x
630 REM load UDGs
640 LET i = USR "a"
650 LET t = i+8*19-1
660 RESTORE 5170
670 FOR x = i  TO t  STEP 1
680 READ y
690 POKE x, y
700 NEXT x
710 LET k$ = ""
720 CLS 
730 GO SUB 1280
740 GO SUB 1800 :GO SUB 1180
750 IF k$ <>"Y" THEN GO TO 720
760 REM main game loop
770 FOR p = 1  TO t  STEP 1
780 REM movement phase
790 IF d(p, 1) = 0  THEN GO TO 860 :REM dead
800 IF p > (t - u)  THEN GO SUB 4590 :GO TO 860 :REM AI
810 LET k$ = ""
820 GO SUB 2290 :GO SUB 2960
830 GO SUB 1890
840 GO SUB 1800
850 IF k$ <>"Y" THEN GO TO 810
860 NEXT p
870 REM apply movement
880 GO SUB 3090
890 GO SUB 3490
900 GO SUB 3830 :GO SUB 1180
910 REM combat phase
920 FOR p = 1  TO t  STEP 1
930 IF d(p, 8) < 1  THEN GO TO 1020 :REM dead
940 IF p > (t - u)  THEN GO SUB 4710 :GO TO 1020 :REM AI
950 LET k$ = ""
960 GO SUB 2290
970 GO SUB 2960
980 IF i = 0  THEN LET d(p, 10) = 18 :GO TO 1020 :REM cannot attack
990 GO SUB 2060
1000 GO SUB 1800
1010 IF k$ <>"Y" THEN GO TO 960
1020 REM next attack input     
1030 NEXT p
1040 REM apply combat
1050 FOR p = 1  TO t  STEP 1
1060 REM if ship on map
1070 IF d(p, 1) > 0  THEN GO SUB 2290 :GO SUB 2960 :GO SUB 3930
1080 NEXT p 
1090 REM move killed ships off map
1100 FOR p = 1  TO t  STEP 1
1110 REM if ship on map and 0 hull move off map
1120 IF d(p, 1) > 0  AND d(p, 8) < 1  THEN LET l(d(p, 1), d(p, 2)) = 0 :LET d(p, 1) = 0
1130 NEXT p
1140 GO SUB 4410
1150 GO SUB 1180
1160 IF t > 0  THEN GO TO 770
1170 GO TO 720
1180 REM debug draw map
1190 IF d = 0  THEN RETURN 
1200 FOR x = 1  TO 8  STEP 1
1210 FOR y = 1  TO 12  STEP 1
1220 LET tx = (x - 1) * 2
1230 LET ty = ((y - 1) * 2) + 8
1240 PRINT AT tx, ty; l(x, y);
1250 NEXT Y
1260 NEXT x
1270 RETURN 
1280 REM initialise game
1290 LET p = 1
1300 LET t = 0
1310 GO SUB 2290
1320 PRINT AT 17, 11; INK 5; "<SPACE FLEET>";
1330 PRINT AT 19, 11; "Enter players 2-4? "; FLASH 1; CHR$ (143);
1340 PAUSE 0
1350 LET k$ = INKEY$ 
1360 IF CODE (k$) < 50  OR CODE (k$) > 52  THEN GO TO 1340
1370 PRINT AT 19, 30; k$;
1380 LET t = VAL (k$)
1390 PRINT AT 20, 11; "AI players 0-"; t-1; "? "; FLASH 1; CHR$ (143);
1400 PAUSE 0
1410 LET k$ = INKEY$ 
1420 IF CODE (k$) < 48  OR CODE (k$) > 48+t-1  THEN GO TO 1400
1430 PRINT AT 20, 27; k$;
1440 LET u = VAL (k$)
1450 PRINT AT 21, 11; "Loading map...";
1460 REM clear map
1470 FOR y = 1  TO 12  STEP 1
1480 FOR x = 1  TO 8
1490 LET l(x, y) = 0
1500 NEXT x
1510 NEXT y 
1520 REM load player data
1530 RESTORE 5120
1540 FOR x = 1  TO t  STEP 1
1550 FOR y = 1  TO 10  STEP 1
1560 READ d(x, y)
1570 NEXT y
1580 LET l(d(x, 1), d(x, 2)) = x :REM 1-4=player
1590 NEXT x
1600 REM generate planet locations
1610 RANDOMIZE 0
1620 FOR p = 1  TO 4 
1630 REM randomise planet locations
1640 LET x = INT (RND * 4) + u(p, 3)
1650 LET y = INT (RND * 4) + u(p, 4)
1660 REM avoid edges
1670 IF x < 2  OR x > 7  OR y < 2  OR y > 11  THEN GO TO 1630
1680 REM update map and draw planet
1690 LET l(x, y) = 5 :REM 5=planet
1700 LET tx = (x - 1) * 2
1710 LET ty = ((y - 1) * 2) + 8
1720 PRINT AT tx, ty; INK u(p, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
1730 NEXT p
1740 REM draw players
1750 FOR p = 1  TO t  STEP 1
1760 GO SUB 2760
1770 GO SUB 2820
1780 NEXT p
1790 RETURN 
1800 REM console confirm
1810 PRINT #1; AT 1, 11; INK 6; "Confirm Y/N? "; FLASH 1; CHR$ (143);
1820 PAUSE 0
1830 LET k$ = INKEY$ 
1840 IF k$ = "y" OR k$ = "Y" THEN LET k$ = "Y":GO TO 1870
1850 IF k$ = "n" OR k$ = "N" THEN LET k$ = "N":GO TO 1870
1860 GO TO 1820
1870 PRINT #1; AT 1, 24; INK 6; k$;
1880 RETURN 
1890 REM console movement
1900 PRINT AT 17, 11; INK 5; "<Helm Computer>";
1910 PRINT AT 19, 11; "Speed A/B/C? "; FLASH 1; CHR$ (143);
1920 LET d(p, 9) = 1
1930 PAUSE 0 
1940 IF INKEY$ = "A" OR INKEY$ = "a" THEN LET d(p, 9) = 0 :LET k$ = "A":GO TO 1970
1950 IF INKEY$ = "B" OR INKEY$ = "b" THEN LET d(p, 9) = 5 :LET k$ = "B":GO TO 1970
1960 IF INKEY$ = "C" OR INKEY$ = "c" THEN LET d(p, 9) = 10 :LET k$ = "C"
1970 IF d(p, 9) = 1  THEN GO TO 1930
1980 PRINT AT 19, 24; k$;
1990 PRINT AT 20, 11; "Movement 1-5? "; FLASH 1; CHR$ (143);
2000 PAUSE 0
2010 LET k$ = INKEY$ 
2020 IF CODE (k$) < 49  OR CODE (k$) > 53  THEN GO TO 2000
2030 PRINT AT 20, 25; k$;
2040 LET d(p, 9) = d(p, 9) + VAL (k$) 
2050 RETURN 
2060 REM console attack
2070 PRINT AT 17, 11; INK 5; "<Combat Display>";
2080 PRINT AT 19, 11; "Distance A-F? "; FLASH 1; CHR$ (143); 
2090 LET d(p, 10) = 1
2100 PAUSE 0 
2110 IF INKEY$ = "A" OR INKEY$ = "a" THEN LET d(p, 10) = 0 :LET k$ = "A":GO TO 2170
2120 IF INKEY$ = "B" OR INKEY$ = "b" THEN LET d(p, 10) = 5 :LET k$ = "B":GO TO 2170
2130 IF INKEY$ = "C" OR INKEY$ = "c" THEN LET d(p, 10) = 10 :LET k$ = "C":GO TO 2170
2140 IF INKEY$ = "D" OR INKEY$ = "d" THEN LET d(p, 10) = 15 :LET k$ = "D":GO TO 2170
2150 IF INKEY$ = "E" OR INKEY$ = "e" THEN LET d(p, 10) = 20 :LET k$ = "E":GO TO 2170
2160 IF INKEY$ = "F" OR INKEY$ = "f" THEN LET d(p, 10) = 25 :LET k$ = "F"
2170 IF d(p, 10) = 1  THEN GO TO 2100
2180 PRINT AT 19, 25; k$;
2190 PRINT AT 20, 11; "Arc 1-5? "; FLASH 1; CHR$ (143);
2200 LET k$ = ""
2210 PAUSE 0
2220 LET k$ = INKEY$ 
2230 IF CODE (k$) < 49  OR CODE (k$) > 53  THEN GO TO 2210
2240 PRINT AT 20, 20; k$;
2250 LET d(p, 10) = d(p, 10) + VAL (k$) 
2260 RETURN 
2270 REM console any key
2280 PRINT #1; AT 1, 11; INK 6; "Press any key."; :PAUSE 0 :RETURN 
2290 REM draw common controls
2300 PRINT AT 0, 0; INK 5; "Combat";
2310 PRINT AT 1, 0; INK 5; "Display";
2320 PRINT AT 2, 1; "12345";
2330 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4";
2340 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2";
2350 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1";
2360 PRINT AT 6, 0; "D"; PAPER 6; "  "; AT 6, 4; PAPER 6; "  ";
2370 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  ";
2380 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " ";
2390 PRINT AT 9, 4; INK 6; "31";
2400 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
2410 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
2420 PRINT AT 18, 1; " "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
2430 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
2440 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
2450 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
2460 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
2470 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
2480 REM draw player controls and clear console
2490 INK u(p, 1)
2500 PRINT AT 0, 6; CHR$ (133); CHR$ (161);
2510 PRINT AT 1, 7; CHR$ (161);
2520 PRINT AT 2, 0; CHR$ (138); AT 2, 6; CHR$ (133); CHR$ (161);
2530 PRINT AT 3, 7; CHR$ (161);
2540 PRINT AT 4, 7; CHR$ (161);
2550 PRINT AT 5, 7; CHR$ (161);
2560 PRINT AT 6, 3; CHR$ (161); AT 6, 6; CHR$ (133); CHR$ (161);
2570 PRINT AT 7, 6; CHR$ (133); CHR$ (161);
2580 PRINT AT 8, 6; CHR$ (133); CHR$ (161);
2590 PRINT AT 9, 0; CHR$ (142); CHR$ (140); CHR$ (140); CHR$ (140); AT 9, 6; CHR$ (141); CHR$ (161);
2600 PRINT AT 10, 6; CHR$ (133); CHR$ (161);
2610 PRINT AT 11, 6; CHR$ (133); CHR$ (161);
2620 PRINT AT 12, 6; CHR$ (133); CHR$ (161);
2630 PRINT AT 13, 6; CHR$ (133); CHR$ (161);
2640 PRINT AT 14, 6; CHR$ (133); CHR$ (161);
2650 PRINT AT 15, 6; CHR$ (133); CHR$ (161);
2660 PRINT AT 16, 4; CHR$ (140); AT 16, 13; CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); INK 7; PAPER 0; "SPACE"; INK u(p, 1); CHR$ (140); INK 7; n$(p);
2670 PRINT AT 17, 10; CHR$ (138); "                     ";
2680 PRINT AT 18, 10; CHR$ (138); "                     ";
2690 PRINT AT 19, 10; CHR$ (138); "                     ";
2700 PRINT AT 20, 10; CHR$ (138); "                     ";
2710 PRINT AT 21, 10; CHR$ (138); "                     ";
2720 PRINT #1; AT 0, 10; INK u(p, 1); CHR$ (138); "                     ";
2730 PRINT #1; AT 1, 10; INK u(p, 1); CHR$ (138); "                     ";
2740 INK 4
2750 RETURN 
2760 REM draw player shields
2770 IF d(p, 8) < 1  THEN PRINT AT 10 + u(p, 5), 1 + u(p, 6); " "; AT 11 + u(p, 5), u(p, 6); "   "; AT 12 + u(p, 5), 1 + u(p, 6); " "; :RETURN 
2780 PRINT AT 10 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 4);
2790 PRINT AT 11 + u(p, 5), u(p, 6); INK u(p, 1); d(p, 7); INK 0; PAPER u(p, 1); d(p, 8); INK u(p, 1); PAPER 0; d(p, 5);
2800 PRINT AT 12 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 6);
2810 RETURN 
2820 REM draw player ship
2830 LET tx = (d(p, 1) - 1) * 2
2840 LET ty = ((d(p, 2) - 1) * 2) + 8
2850 IF d(p, 8) = 0  THEN PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; :RETURN 
2860 IF d(p, 3) = 0  THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (152); CHR$ (153); AT tx + 1, ty; CHR$ (150); CHR$ (151); :RETURN 
2870 IF d(p, 3) = 1  THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (156); AT tx + 1, ty; CHR$ (150); CHR$ (157); :RETURN 
2880 IF d(p, 3) = 2  THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (149); AT tx + 1, ty; CHR$ (154); CHR$ (155); :RETURN 
2890 PRINT AT tx, ty; INK u(p, 1); CHR$ (158); CHR$ (149); AT tx + 1, ty; CHR$ (159); CHR$ (151);
2900 RETURN 
2910 REM draw target explosion
2920 LET tx = (d(q, 1) - 1) * 2
2930 LET ty = ((d(q, 2) - 1) * 2) + 8
2940 PRINT AT tx, ty; INK 6; PAPER 2; FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
2950 RETURN 
2960 REM overlay and count targets
2970 LET i = 0 
2980 FOR q = 1  TO t  STEP 1
2990 IF q = p  OR d(q, 1) < 1  THEN GO TO 3070
3000 GO SUB 4810 :REM load tx, ty
3010 LET tx = tx + 4 :LET ty = ty + 3
3020 IF tx < 1  OR tx > 6  OR ty < 1  OR ty > 5  THEN GO TO 3070
3030 LET s = d(p, 3) + d(q, 3)
3040 IF s = 1  OR s = 3  OR s = 5  THEN PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (160); :GO TO 3060
3050 PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (161);
3060 IF a(((tx - 1) * 5) + ty, 3) > 0  THEN LET i = i + 1
3070 NEXT q
3080 RETURN 
3090 REM apply movement
3100 FOR p = 1  TO t  STEP 1
3110 IF d(p, 1) < 1  THEN GO TO 3260
3120 IF d(p, 3) = 0  THEN LET x = d(p, 1) + m(d(p, 9), 1) :LET y = d(p, 2) + m(d(p, 9), 2) :GO TO 3160
3130 IF d(p, 3) = 1  THEN LET x = d(p, 1) + m(d(p, 9), 2) :LET y = d(p, 2) - m(d(p, 9), 1) :GO TO 3160
3140 IF d(p, 3) = 2  THEN LET x = d(p, 1) - m(d(p, 9), 1) :LET y = d(p, 2) - m(d(p, 9), 2) :GO TO 3160
3150 LET x = d(p, 1) - m(d(p, 9), 2) :LET y = d(p, 2) + m(d(p, 9), 1)
3160 IF x < 1  OR x > 8  OR y < 1  OR y > 12  THEN LET x = 0 :GO TO 3180
3170 GO SUB 3280
3180 LET l(d(p, 1), d(p, 2)) = 0 :REM clear map
3190 LET tx = (d(p, 1) - 1) * 2 :LET ty = ((d(p, 2) - 1) * 2) + 8 :REM clear screen pos 1
3200 LET d(p, 1) = x :LET d(p, 2) = y :REM update player
3210 LET d(p, 3) = d(p, 3) + m(d(p, 9), 3) :REM update dir
3220 IF d(p, 3) > 3  THEN LET d(p, 3) = d(p, 3) - 4 :GO TO 3240
3230 IF d(p, 3) < 0  THEN LET d(p, 3) = d(p, 3) + 4
3240 PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; :REM clear screen pos 2
3250 IF x > 0  THEN LET l(x, y) = p :GO SUB 2820
3260 NEXT p
3270 RETURN 
3280 REM planet collision check
3290 IF l(x, y) <>5  THEN RETURN 
3300 GO SUB 2290
3310 GO SUB 2960
3320 PRINT AT 17, 11; INK 2; "<Movement>";
3330 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " ram planet! x4";
3340 LET tx = 19
3350 FOR i = 1  TO 4  STEP 1
3360 IF RND * 9 < 5  THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; :GO TO 3400
3370 IF d(p, 4) > 0  THEN LET d(p, 4) = d(p, 4) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! "; s$(1); " shields -1"; :GO TO 3400
3380 IF d(p, 8) > 1  THEN LET d(p, 8) = d(p, 8) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! Hull -1"; :GO TO 3400
3390 IF d(p, 8) = 1  THEN LET d(p, 8) = 0 :LET x = 0 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "REM! Ship destroyed!"; :LET q = p :GO SUB 2910 :GO TO 3460
3400 LET tx = tx + 1
3410 NEXT i
3420 IF d(p, 3) = 0  THEN LET x = x + 1 :GO TO 3460
3430 IF d(p, 3) = 1  THEN LET y = y - 1 :GO TO 3460
3440 IF d(p, 3) = 2  THEN LET x = x - 1 :GO TO 3460
3450 LET y = y + 1
3460 GO SUB 2760 :GO SUB 2270
3470 IF x > 0  THEN GO SUB 3280
3480 RETURN 
3490 REM player collision check
3500 FOR p = 1  TO t  STEP 1
3510 IF d(p, 1) < 1  THEN GO TO 3810
3520 GO SUB 2820
3530 FOR q = 1  TO t  STEP 1
3540 IF p = q  OR d(q, 1) < 1  OR d(p, 1) <>d(q, 1)  OR d(p, 2) <>d(q, 2)  THEN GO TO 3800
3550 REM collision!
3560 GO SUB 2290
3570 LET tx = 19
3580 PRINT AT 17, 11; INK 2; "<Movement>";
3590 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " ram "; INK u(q, 1); n$(q); INK 4; " x4";
3600 LET s = d(p, 3) - d(q, 3) + 6
3610 IF s > 7  THEN LET s = s - 4 :GO TO 3630
3620 IF s < 4  THEN LET s = s + 4
3630 FOR i = 1  TO 4  STEP 1
3640 IF RND * 9 < 5  THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; :GO TO 3680
3650 IF d(q, s) > 0  THEN LET d(q, s) = d(q, s) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! "; s$(s - 3); " shields -1"; :GO TO 3680
3660 IF d(q, 8) > 1  THEN LET d(q, 8) = d(q, 8) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! Hull -1"; :GO TO 3680
3670 IF d(q, 8) = 1  THEN LET d(q, 8) = 0 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! Ship destroyed!"; :GO TO 3700
3680 LET tx = tx + 1
3690 NEXT i
3700 LET tx = (d(p, 1) - 1) * 2
3710 LET ty = ((d(p, 2) - 1) * 2) + 8
3720 PRINT AT tx, ty; INK u(p, 1); PAPER u(q, 1); FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
3730 GO SUB 2270
3740 LET i = p
3750 LET p = q
3760 GO SUB 2760
3770 IF d(i, 8) = 0  THEN GO SUB 2820
3780 LET p = i
3790 IF d(q, 8) = 0  THEN GO SUB 2820
3800 NEXT q
3810 NEXT p
3820 RETURN 
3830 REM off map check
3840 FOR p = 1  TO t  STEP 1
3850 IF d(p, 8) < 1  OR d(p, 1) > 0  THEN GO TO 3910
3860 GO SUB 2290
3870 GO SUB 2960
3880 PRINT AT 17, 11; INK 2; "<Movement>";
3890 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " fall into the "; AT 19, 11; "void and are eaten"; AT 20, 11; "by a passing cosmic"; AT 21, 11; "horror.";
3900 LET d(p, 8) = 0 :GO SUB 2270
3910 NEXT p
3920 RETURN 
3930 REM player attack
3940 IF a(d(p, 10), 3) = 0  THEN LET s = 0 :GO TO 4390
3950 IF d(p, 3) = 0  THEN LET x = d(p, 1) + a(d(p, 10), 1) :LET y = d(p, 2) + a(d(p, 10), 2) :GO TO 3990
3960 IF d(p, 3) = 1  THEN LET x = d(p, 1) + a(d(p, 10), 2) :LET y = d(p, 2) - a(d(p, 10), 1) :GO TO 3990
3970 IF d(p, 3) = 2  THEN LET x = d(p, 1) - a(d(p, 10), 1) :LET y = d(p, 2) - a(d(p, 10), 2) :GO TO 3990
3980 LET x = d(p, 1) - a(d(p, 10), 2) :LET y = d(p, 2) + a(d(p, 10), 1) 
3990 LET s = 0
4000 PRINT AT 17, 11; INK 2; "<Combat>";
4010 FOR q = 1  TO t  STEP 1
4020 IF d(q, 1) <>x  OR d(q, 2) <>y  THEN GO TO 4380
4030 INK u(p, 1) :GO SUB 2680 :INK 4
4040 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " attack "; INK u(q, 1); n$(q); INK 4; " x"; a(d(p, 10), 3); 
4050 PAPER u(p, 1) 
4060 LET s = p
4070 LET p = q
4080 GO SUB 2820
4090 LET q = p
4100 LET p = s
4110 PAPER 0 
4120 REM resolve shield based on relative positions and q dir
4130 LET tx = d(p, 1) - d(q, 1)
4140 LET ty = d(p, 2) - d(q, 2)
4150 IF ABS tx > ABS ty  AND tx > 0  THEN LET s = 6 :GO TO 4190
4160 IF ABS tx > ABS ty  THEN LET s = 4 :GO TO 4190
4170 IF ty > 0  THEN LET s = 5 :GO TO 4190
4180 LET s = 7
4190 LET s = s - d(q, 3)
4200 IF s > 7  THEN LET s = s - 4 :GO TO 4220
4210 IF s < 4  THEN LET s = s + 4
4220 LET tx = 19
4230 FOR i = 1  TO a(d(p, 10), 3)  STEP 1
4240 IF d(q, 8) < 1  THEN GO TO 4290
4250 IF RND * 9 < 5  THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; :GO TO 4290
4260 IF d(q, s) > 0  THEN LET d(q, s) = d(q, s) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! "; s$(s - 3); " shields -1"; :GO TO 4290
4270 IF d(q, 8) > 1  THEN LET d(q, 8) = d(q, 8) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Hull -1"; :GO TO 4290
4280 IF d(q, 8) = 1  THEN LET d(q, 8) = 0 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Ship destroyed!"; :GO SUB 2910 :GO SUB 2270
4290 LET tx = tx + 1
4300 NEXT i
4310 REM refresh attacked ship
4320 LET i = p
4330 LET p = q
4340 GO SUB 2760
4350 GO SUB 2270
4360 GO SUB 2820
4370 LET p = i
4380 NEXT q
4390 IF s = 0  THEN PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " do not attack.";
4400 RETURN 
4410 REM end game check
4420 LET i = 0
4430 LET q = 1
4440 FOR p = 1  TO t  STEP 1
4450 IF d(p, 1) > 0  THEN LET q = p :LET i = i + 1
4460 NEXT p 
4470 REM still at least 2 players
4480 IF i > 1  THEN RETURN 
4490 REM ends game
4500 LET t = 0
4510 REM 1st player or winner colours
4520 LET p = q
4530 GO SUB 2290
4540 PRINT AT 17, 11; INK 2; "<GAME OVER>";
4550 IF i = 0  THEN PRINT AT 18, 11; "Everybody is dead."; :GO TO 4570
4560 PRINT AT 18, 11; INK u(p, 1); "SPACE "; n$(p); INK 4; " have won.";
4570 GO SUB 2270
4580 RETURN 
4590 REM resolve AI movement
4600 LET d(p, 9) = 0
4610 FOR q = 1  TO t  STEP 1
4620 IF q = p  OR d(q, 1) < 1  THEN GO TO 4660
4630 GO SUB 4810 :REM load tx, ty
4640 LET tx = tx + 4 :LET ty = ty + 3
4650 IF tx > 0  AND tx < 7  AND ty > 0  AND ty < 6  THEN LET d(p, 9) = v(tx, ty) :RETURN 
4660 NEXT q
4670 IF ty > -11  AND ty < 0  THEN LET d(p, 9) = 1 :RETURN 
4680 IF tx > 5  AND tx < 16  THEN LET d(p, 9) = 5 :RETURN 
4690 LET d(p, 9) = 3
4700 RETURN 
4710 REM resolve AI attack
4720 LET d(p, 10) = 0
4730 FOR q = 1  TO t  STEP 1
4740 IF q = p  OR d(q, 1) < 1  THEN GO TO 4780
4750 GO SUB 4810 :REM load tx, ty
4760 LET tx = tx + 4 :LET ty = ty + 3
4770 IF tx > 0  AND tx < 7  AND ty > 0  AND ty < 6  THEN LET d(p, 10) = ((tx - 1) * 5) + ty :RETURN 
4780 NEXT q
4790 IF d(p, 10) = 0  THEN LET d(p, 10) = 19
4800 RETURN 
4810 REM load tx, ty with target relative position
4820 IF d(p, 3) = 0  THEN LET tx = d(q, 1) - d(p, 1) :LET ty = d(q, 2) - d(p, 2) :RETURN 
4830 IF d(p, 3) = 1  THEN LET tx = d(p, 2) - d(q, 2) :LET ty = d(q, 1) - d(p, 1) :RETURN 
4840 IF d(p, 3) = 2  THEN LET tx = d(p, 1) - d(q, 1) :LET ty = d(p, 2) - d(q, 2) :RETURN 
4850 LET tx = d(q, 2) - d(p, 2) :LET ty = d(p, 1) - d(q, 1)
4860 RETURN 
4870 REM attack vectors data
4880 DATA -3, -2, 4, -3, -1, 4, -3, 0, 4
4890 DATA -3, 1, 4, -3, 2, 4, -2, -2, 1
4900 DATA -2, -1, 2, -2, 0, 2, -2, 1, 2
4910 DATA -2, 2, 1, -1, -2, 1, -1, -1, 3
4920 DATA -1, 0, 1, -1, 1, 3, -1, 2, 1
4930 DATA 0, -2, 1, 0, -1, 3, 0, 0, 0
4940 DATA 0, 1, 3, 0, 2, 1, 1, -2, 1
4950 DATA 1, -1, 3, 1, 0, 0, 1, 1, 3
4960 DATA 1, 2, 1, 2, -2, 1, 2, -1, 0
4970 DATA 2, 0, 0, 2, 1, 0, 2, 2, 1
4980 REM movement vectors data
4990 DATA -2, -1, -1, -2, -1, 0, -2, 0, 0
5000 DATA -2, 1, 0, -2, 1, 1, -1, -1, -1
5010 DATA -1, -1, 0, -1, 0, 0, -1, 1, 0
5020 DATA -1, 1, 1, 0, 0, 0, 0, 0, -1
5030 DATA 0, 0, 0, 0, 0, 1, 0, 0, 0
5040 REM player UIs data
5050 DATA 1, 5, 1, 1, 0, 0
5060 DATA 2, 4, 5, 9, 3, 3
5070 DATA 3, 2, 1, 9, 0, 3
5080 DATA 6, 3, 5, 1, 3, 0
5090 REM player names data
5100 DATA "FLEET", "ELVES", "CHAOS", "HORDE"
5110 REM player data
5120 DATA 1, 1, 2, 3, 3, 3, 3, 4, 0, 0
5130 DATA 8, 12, 0, 3, 3, 3, 3, 4, 0, 0
5140 DATA 1, 12, 2, 3, 3, 3, 3, 4, 0, 0
5150 DATA 8, 1, 0, 3, 3, 3, 3, 4, 0, 0
5160 REM UDGs data
5170 DATA 0, 3, 15, 31, 63, 63, 127, 127
5180 DATA 0, 192, 240, 248, 252, 252, 254, 254 
5190 DATA 127, 127, 63, 63, 31, 15, 3, 0 
5200 DATA 254, 254, 252, 252, 248, 240, 192, 0
5210 DATA 0, 0, 0, 0, 1, 7, 7, 15
5220 DATA 0, 0, 0, 0, 128, 224, 224, 240 
5230 DATA 15, 7, 7, 1, 0, 0, 0, 0
5240 DATA 240, 224, 224, 128, 0, 0, 0, 0
5250 DATA 0, 0, 0, 5, 15, 7, 15, 7
5260 DATA 0, 0, 0, 160, 240, 224, 240, 224
5270 DATA 7, 15, 7, 15, 5, 0, 0, 0 
5280 DATA 224, 240, 224, 240, 160, 0, 0, 0 
5290 DATA 0, 0, 0, 0, 80, 248, 240, 248 
5300 DATA 248, 240, 248, 80, 0, 0, 0, 0 
5310 DATA 0, 0, 0, 0, 10, 31, 15, 31 
5320 DATA 31, 15, 31, 10, 0, 0, 0, 0 
5330 DATA 0, 0, 0, 60, 60, 0, 0, 0 
5340 DATA 0, 0, 24, 24, 24, 24, 0, 0 
5350 DATA 0, 0, 0, 0, 24, 0, 0, 0
5360 REM movement ai behaviour data
5370 DATA 1, 2, 3, 4, 5
5380 DATA 6, 7, 8, 9, 10
5390 DATA 12, 12, 13, 14, 14
5400 DATA 12, 12, 13, 14, 14
5410 DATA 12, 12, 13, 14, 14
5420 DATA 12, 12, 13, 14, 14
5430 REM shields
5440 DATA "Front", "Right", " Rear", " Left"
