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
280 RESTORE 5100
290 FOR x = 1  TO 30  STEP 1
300 FOR y = 1  TO 3  STEP 1
310 READ a(x, y)
320 NEXT y
330 NEXT x
340 REM load movement vectors
350 RESTORE 5210
360 FOR x = 1  TO 15  STEP 1
370 FOR y = 1  TO 3  STEP 1
380 READ m(x, y)
390 NEXT y
400 NEXT x
410 REM load player UIs, names and shields
420 RESTORE 5270
430 FOR x = 1  TO 4  STEP 1
440 FOR y = 1  TO 6  STEP 1
450 READ u(x, y)
460 NEXT y
470 NEXT x
480 RESTORE 5320
490 FOR x = 1  TO 4  STEP 1
500 READ n$(x)
510 NEXT x
520 RESTORE 5660
530 FOR x = 1  TO 4  STEP 1
540 READ s$(x)
550 NEXT x
560 REM load movement ai behaviours
570 RESTORE 5590
580 FOR x = 1  TO 6  STEP 1
590 FOR y = 1  TO 5  STEP 1
600 READ v(x, y)
610 NEXT y
620 NEXT x
630 REM load UDGs
640 LET i = USR "a"
650 LET t = i+8*19-1
660 RESTORE 5390
670 FOR x = i  TO t  STEP 1
680 READ y
690 POKE x, y
700 NEXT x
710 LET k$ = ""
720 CLS 
730 GO SUB 1310
740 GO SUB 1830
750 GO SUB 1210
760 IF k$ <>"Y" THEN GO TO 720
770 REM main game loop
780 FOR p = 1  TO t  STEP 1
790 REM movement phase
800 IF d(p, 1) = 0  THEN GO TO 880 :REM dead
810 IF p > (t - u)  THEN GO SUB 4810 :GO TO 880 :REM AI
820 LET k$ = ""
830 GO SUB 2320
840 GO SUB 2990
850 GO SUB 1920
860 GO SUB 1830
870 IF k$ <>"Y" THEN GO TO 820
880 NEXT p
890 REM apply movement
900 GO SUB 3120
910 GO SUB 3530
920 GO SUB 4050
930 GO SUB 1210
940 REM combat phase
950 FOR p = 1  TO t  STEP 1
960 IF d(p, 8) < 1  THEN GO TO 1050 :REM dead
970 IF p > (t - u)  THEN GO SUB 4930 :GO TO 1050 :REM AI
980 LET k$ = ""
990 GO SUB 2320
1000 GO SUB 2990
1010 IF i = 0  THEN LET d(p, 10) = 18 :PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " cannot attack.":GO TO 1050
1020 GO SUB 2090
1030 GO SUB 1830
1040 IF k$ <>"Y" THEN GO TO 990
1050 REM next attack input     
1060 NEXT p
1070 REM apply combat
1080 FOR p = 1  TO t  STEP 1
1090 REM if ship on map
1100 IF d(p, 1) > 0  THEN GO SUB 2320 :GO SUB 2990 :GO SUB 4150
1110 NEXT p 
1120 REM move killed ships off map
1130 FOR p = 1  TO t  STEP 1
1140 REM if ship on map and 0 hull move off map
1150 IF d(p, 1) > 0  AND d(p, 8) < 1  THEN LET l(d(p, 1), d(p, 2)) = 0 :LET d(p, 1) = 0
1160 NEXT p
1170 GO SUB 4630
1180 GO SUB 1210
1190 IF t > 0  THEN GO TO 780
1200 GO TO 720
1210 REM debug draw map
1220 IF d = 0  THEN RETURN 
1230 FOR x = 1  TO 8  STEP 1
1240 FOR y = 1  TO 12  STEP 1
1250 LET tx = (x - 1) * 2
1260 LET ty = ((y - 1) * 2) + 8
1270 PRINT AT tx, ty; l(x, y);
1280 NEXT Y
1290 NEXT x
1300 RETURN 
1310 REM initialise game
1320 LET p = 1
1330 LET t = 0
1340 GO SUB 2320
1350 PRINT AT 17, 11; INK 5; "<SPACE FLEET>";
1360 PRINT AT 19, 11; "Enter players 2-4? "; FLASH 1; CHR$ (143);
1370 PAUSE 0
1380 LET k$ = INKEY$ 
1390 IF CODE (k$) < 50  OR CODE (k$) > 52  THEN GO TO 1370
1400 PRINT AT 19, 30; k$;
1410 LET t = VAL (k$)
1420 PRINT AT 20, 11; "AI players 0-"; t-1; "? "; FLASH 1; CHR$ (143);
1430 PAUSE 0
1440 LET k$ = INKEY$ 
1450 IF CODE (k$) < 48  OR CODE (k$) > 48+t-1  THEN GO TO 1430
1460 PRINT AT 20, 27; k$;
1470 LET u = VAL (k$)
1480 PRINT AT 21, 11; "Loading map...";
1490 REM clear map
1500 FOR y = 1  TO 12  STEP 1
1510 FOR x = 1  TO 8
1520 LET l(x, y) = 0
1530 NEXT x
1540 NEXT y 
1550 REM load player data
1560 RESTORE 5340
1570 FOR x = 1  TO t  STEP 1
1580 FOR y = 1  TO 10  STEP 1
1590 READ d(x, y)
1600 NEXT y
1610 LET l(d(x, 1), d(x, 2)) = x :REM 1-4=player
1620 NEXT x
1630 REM generate planet locations
1640 RANDOMIZE 0
1650 FOR p = 1  TO 4 
1660 REM randomise planet locations
1670 LET x = INT (RND * 4) + u(p, 3)
1680 LET y = INT (RND * 4) + u(p, 4)
1690 REM avoid edges
1700 IF x < 2  OR x > 7  OR y < 2  OR y > 11  THEN GO TO 1660
1710 REM update map and draw planet
1720 LET l(x, y) = 5 :REM 5=planet
1730 LET tx = (x - 1) * 2
1740 LET ty = ((y - 1) * 2) + 8
1750 PRINT AT tx, ty; INK u(p, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
1760 NEXT p
1770 REM draw players
1780 FOR p = 1  TO t  STEP 1
1790 GO SUB 2790
1800 GO SUB 2850
1810 NEXT p
1820 RETURN 
1830 REM console confirm
1840 PRINT #1; AT 1, 11; INK 6; "Confirm Y/N? "; FLASH 1; CHR$ (143);
1850 PAUSE 0
1860 LET k$ = INKEY$ 
1870 IF k$ = "y" OR k$ = "Y" THEN LET k$ = "Y":GO TO 1900
1880 IF k$ = "n" OR k$ = "N" THEN LET k$ = "N":GO TO 1900
1890 GO TO 1850
1900 PRINT #1; AT 1, 24; INK 6; k$;
1910 RETURN 
1920 REM console movement
1930 PRINT AT 17, 11; INK 5; "<Helm Computer>";
1940 PRINT AT 19, 11; "Speed A/B/C? "; FLASH 1; CHR$ (143);
1950 LET d(p, 9) = 1
1960 PAUSE 0 
1970 IF INKEY$ = "A" OR INKEY$ = "a" THEN LET d(p, 9) = 0 :LET k$ = "A":GO TO 2000
1980 IF INKEY$ = "B" OR INKEY$ = "b" THEN LET d(p, 9) = 5 :LET k$ = "B":GO TO 2000
1990 IF INKEY$ = "C" OR INKEY$ = "c" THEN LET d(p, 9) = 10 :LET k$ = "C"
2000 IF d(p, 9) = 1  THEN GO TO 1960
2010 PRINT AT 19, 24; k$;
2020 PRINT AT 20, 11; "Movement 1-5? "; FLASH 1; CHR$ (143);
2030 PAUSE 0
2040 LET k$ = INKEY$ 
2050 IF CODE (k$) < 49  OR CODE (k$) > 53  THEN GO TO 2030
2060 PRINT AT 20, 25; k$;
2070 LET d(p, 9) = d(p, 9) + VAL (k$) 
2080 RETURN 
2090 REM console attack
2100 PRINT AT 17, 11; INK 5; "<Combat Display>";
2110 PRINT AT 19, 11; "Distance A-F? "; FLASH 1; CHR$ (143); 
2120 LET d(p, 10) = 1
2130 PAUSE 0 
2140 IF INKEY$ = "A" OR INKEY$ = "a" THEN LET d(p, 10) = 0 :LET k$ = "A":GO TO 2200
2150 IF INKEY$ = "B" OR INKEY$ = "b" THEN LET d(p, 10) = 5 :LET k$ = "B":GO TO 2200
2160 IF INKEY$ = "C" OR INKEY$ = "c" THEN LET d(p, 10) = 10 :LET k$ = "C":GO TO 2200
2170 IF INKEY$ = "D" OR INKEY$ = "d" THEN LET d(p, 10) = 15 :LET k$ = "D":GO TO 2200
2180 IF INKEY$ = "E" OR INKEY$ = "e" THEN LET d(p, 10) = 20 :LET k$ = "E":GO TO 2200
2190 IF INKEY$ = "F" OR INKEY$ = "f" THEN LET d(p, 10) = 25 :LET k$ = "F"
2200 IF d(p, 10) = 1  THEN GO TO 2130
2210 PRINT AT 19, 25; k$;
2220 PRINT AT 20, 11; "Arc 1-5? "; FLASH 1; CHR$ (143);
2230 LET k$ = ""
2240 PAUSE 0
2250 LET k$ = INKEY$ 
2260 IF CODE (k$) < 49  OR CODE (k$) > 53  THEN GO TO 2240
2270 PRINT AT 20, 20; k$;
2280 LET d(p, 10) = d(p, 10) + VAL (k$) 
2290 RETURN 
2300 REM console any key
2310 PRINT #1; AT 1, 11; INK 6; "Press any key."; :PAUSE 0 :RETURN 
2320 REM draw common controls
2330 PRINT AT 0, 0; INK 5; "Combat";
2340 PRINT AT 1, 0; INK 5; "Display";
2350 PRINT AT 2, 1; "12345";
2360 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4";
2370 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2";
2380 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1";
2390 PRINT AT 6, 0; "D"; PAPER 6; "  "; AT 6, 4; PAPER 6; "  ";
2400 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  ";
2410 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " ";
2420 PRINT AT 9, 4; INK 6; "31";
2430 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
2440 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
2450 PRINT AT 18, 1; " "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
2460 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
2470 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
2480 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
2490 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
2500 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
2510 REM draw player controls and clear console
2520 INK u(p, 1)
2530 PRINT AT 0, 6; CHR$ (133); CHR$ (161);
2540 PRINT AT 1, 7; CHR$ (161);
2550 PRINT AT 2, 0; CHR$ (138); AT 2, 6; CHR$ (133); CHR$ (161);
2560 PRINT AT 3, 7; CHR$ (161);
2570 PRINT AT 4, 7; CHR$ (161);
2580 PRINT AT 5, 7; CHR$ (161);
2590 PRINT AT 6, 3; CHR$ (161); AT 6, 6; CHR$ (133); CHR$ (161);
2600 PRINT AT 7, 6; CHR$ (133); CHR$ (161);
2610 PRINT AT 8, 6; CHR$ (133); CHR$ (161);
2620 PRINT AT 9, 0; CHR$ (142); CHR$ (140); CHR$ (140); CHR$ (140); AT 9, 6; CHR$ (141); CHR$ (161);
2630 PRINT AT 10, 6; CHR$ (133); CHR$ (161);
2640 PRINT AT 11, 6; CHR$ (133); CHR$ (161);
2650 PRINT AT 12, 6; CHR$ (133); CHR$ (161);
2660 PRINT AT 13, 6; CHR$ (133); CHR$ (161);
2670 PRINT AT 14, 6; CHR$ (133); CHR$ (161);
2680 PRINT AT 15, 6; CHR$ (133); CHR$ (161);
2690 PRINT AT 16, 4; CHR$ (140); AT 16, 13; CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); INK 7; PAPER 0; "SPACE"; INK u(p, 1); CHR$ (140); INK 7; n$(p);
2700 PRINT AT 17, 10; CHR$ (138); "                     ";
2710 PRINT AT 18, 10; CHR$ (138); "                     ";
2720 PRINT AT 19, 10; CHR$ (138); "                     ";
2730 PRINT AT 20, 10; CHR$ (138); "                     ";
2740 PRINT AT 21, 10; CHR$ (138); "                     ";
2750 PRINT #1; AT 0, 10; INK u(p, 1); CHR$ (138); "                     ";
2760 PRINT #1; AT 1, 10; INK u(p, 1); CHR$ (138); "                     ";
2770 INK 4
2780 RETURN 
2790 REM draw player shields
2800 IF d(p, 8) < 1  THEN PRINT AT 10 + u(p, 5), 1 + u(p, 6); " "; AT 11 + u(p, 5), u(p, 6); "   "; AT 12 + u(p, 5), 1 + u(p, 6); " "; :RETURN 
2810 PRINT AT 10 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 4);
2820 PRINT AT 11 + u(p, 5), u(p, 6); INK u(p, 1); d(p, 7); INK 0; PAPER u(p, 1); d(p, 8); INK u(p, 1); PAPER 0; d(p, 5);
2830 PRINT AT 12 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 6);
2840 RETURN 
2850 REM draw player ship
2860 LET tx = (d(p, 1) - 1) * 2
2870 LET ty = ((d(p, 2) - 1) * 2) + 8
2880 IF d(p, 8) = 0  THEN PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; :RETURN 
2890 IF d(p, 3) = 0  THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (152); CHR$ (153); AT tx + 1, ty; CHR$ (150); CHR$ (151); :RETURN 
2900 IF d(p, 3) = 1  THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (156); AT tx + 1, ty; CHR$ (150); CHR$ (157); :RETURN 
2910 IF d(p, 3) = 2  THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (149); AT tx + 1, ty; CHR$ (154); CHR$ (155); :RETURN 
2920 PRINT AT tx, ty; INK u(p, 1); CHR$ (158); CHR$ (149); AT tx + 1, ty; CHR$ (159); CHR$ (151);
2930 RETURN 
2940 REM draw target explosion
2950 LET tx = (d(q, 1) - 1) * 2
2960 LET ty = ((d(q, 2) - 1) * 2) + 8
2970 PRINT AT tx, ty; INK 6; PAPER 2; FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
2980 RETURN 
2990 REM overlay and count targets
3000 LET i = 0 
3010 FOR q = 1  TO t  STEP 1
3020 IF q = p  OR d(q, 1) < 1  THEN GO TO 3100
3030 GO SUB 5030 :REM load tx, ty
3040 LET tx = tx + 4 :LET ty = ty + 3
3050 IF tx < 1  OR tx > 6  OR ty < 1  OR ty > 5  THEN GO TO 3100
3060 LET s = d(p, 3) + d(q, 3)
3070 IF s = 1  OR s = 3  OR s = 5  THEN PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (160); :GO TO 3090
3080 PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (161);
3090 IF a(((tx - 1) * 5) + ty, 3) > 0  THEN LET i = i + 1
3100 NEXT q
3110 RETURN 
3120 REM apply movement
3130 FOR p = 1  TO t  STEP 1
3140 IF d(p, 1) < 1  THEN GO TO 3290
3150 IF d(p, 3) = 0  THEN LET x = d(p, 1) + m(d(p, 9), 1) :LET y = d(p, 2) + m(d(p, 9), 2) :GO TO 3190
3160 IF d(p, 3) = 1  THEN LET x = d(p, 1) + m(d(p, 9), 2) :LET y = d(p, 2) - m(d(p, 9), 1) :GO TO 3190
3170 IF d(p, 3) = 2  THEN LET x = d(p, 1) - m(d(p, 9), 1) :LET y = d(p, 2) - m(d(p, 9), 2) :GO TO 3190
3180 LET x = d(p, 1) - m(d(p, 9), 2) :LET y = d(p, 2) + m(d(p, 9), 1)
3190 IF x < 1  OR x > 8  OR y < 1  OR y > 12  THEN LET x = 0 :GO TO 3210
3200 GO SUB 3310
3210 LET l(d(p, 1), d(p, 2)) = 0 :REM clear map
3220 LET tx = (d(p, 1) - 1) * 2 :LET ty = ((d(p, 2) - 1) * 2) + 8 :REM clear screen pos 1
3230 LET d(p, 1) = x :LET d(p, 2) = y :REM update player
3240 LET d(p, 3) = d(p, 3) + m(d(p, 9), 3) :REM update dir
3250 IF d(p, 3) > 3  THEN LET d(p, 3) = d(p, 3) - 4 :GO TO 3270
3260 IF d(p, 3) < 0  THEN LET d(p, 3) = d(p, 3) + 4
3270 PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; :REM clear screen pos 2
3280 IF x > 0  THEN LET l(x, y) = p :GO SUB 2850
3290 NEXT p
3300 RETURN 
3310 REM planet collision check
3320 IF l(x, y) <>5  THEN RETURN 
3330 GO SUB 2320
3340 GO SUB 2990
3350 PRINT AT 17, 11; INK 2; "<Movement>";
3360 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " ram planet! x4";
3370 LET tx = 19
3380 FOR i = 1  TO 4  STEP 1
3390 IF RND * 9 < 5  THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; :GO TO 3430
3400 IF d(p, 4) > 0  THEN LET d(p, 4) = d(p, 4) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! "; s$(1); " shields -1"; :GO TO 3430
3410 IF d(p, 8) > 1  THEN LET d(p, 8) = d(p, 8) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! Hull -1"; :GO TO 3430
3420 IF d(p, 8) = 1  THEN LET d(p, 8) = 0 :LET x = 0 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "REM! Ship destroyed!"; :LET q = p :GO SUB 2940 :GO TO 3490
3430 LET tx = tx + 1
3440 NEXT i
3450 IF d(p, 3) = 0  THEN LET x = x + 1 :GO TO 3490
3460 IF d(p, 3) = 1  THEN LET y = y - 1 :GO TO 3490
3470 IF d(p, 3) = 2  THEN LET x = x - 1 :GO TO 3490
3480 LET y = y + 1
3490 GO SUB 2790
3500 GO SUB 2300
3510 IF x > 0  THEN GO SUB 3310
3520 RETURN 
3530 REM player collision check
3540 FOR p = 1  TO t  STEP 1
3550 IF d(p, 1) < 1  THEN GO TO 3860
3560 GO SUB 2850
3570 FOR q = 1  TO t  STEP 1
3580 IF p = q  OR d(q, 1) < 1  OR d(p, 1) <>d(q, 1)  OR d(p, 2) <>d(q, 2)  THEN GO TO 3850
3590 REM collision!
3600 GO SUB 2320
3610 LET tx = 19
3620 PRINT AT 17, 11; INK 2; "<Movement>";
3630 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " ram "; INK u(q, 1); n$(q); INK 4; " x4";
3640 LET s = d(p, 3) - d(q, 3) + 6
3650 IF s > 7  THEN LET s = s - 4 :GO TO 3670
3660 IF s < 4  THEN LET s = s + 4
3670 FOR i = 1  TO 4  STEP 1
3680 IF RND * 9 < 5  THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; :GO TO 3720
3690 IF d(q, s) > 0  THEN LET d(q, s) = d(q, s) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! "; s$(s - 3); " shields -1"; :GO TO 3720
3700 IF d(q, 8) > 1  THEN LET d(q, 8) = d(q, 8) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! Hull -1"; :GO TO 3720
3710 IF d(q, 8) = 1  THEN LET d(q, 8) = 0 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! Ship destroyed!"; :GO TO 3740
3720 LET tx = tx + 1
3730 NEXT i
3740 LET tx = (d(p, 1) - 1) * 2
3750 LET ty = ((d(p, 2) - 1) * 2) + 8
3760 PRINT AT tx, ty; INK u(p, 1); PAPER u(q, 1); FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
3770 GO SUB 2300
3780 LET i = p
3790 LET p = q
3800 GO SUB 2790
3810 IF d(i, 8) = 0  THEN GO SUB 2850
3820 LET p = i
3830 IF d(q, 8) = 0  THEN GO SUB 2850
3840 IF d(p, 8) > 0  AND d(q, 8) > 0  AND p > q  THEN GO SUB 3880
3850 NEXT q
3860 NEXT p
3870 RETURN 
3880 REM move one player
3890 GO SUB 2510
3900 LET x = d(i, 1)
3910 LET y = d(i, 2)
3920 LET tx = d(i, 1) - 1 + INT (RND * 2)
3930 LET ty = d(i, 2) - 1 + INT (RND * 2)
3940 IF tx < 1  OR tx > 8  OR ty < 1  OR ty > 12  THEN GO TO 3920
3950 IF l(tx, ty) > 0  THEN GO TO 3920
3960 REM choose winner
3970 IF INT RND * 3 > 2  THEN LET i = p :LET s = q :GO TO 4000
3980 LET i = q :LET s = p
3990 REM move player and update map
4000 LET d(i, 1) = tx :LET d(i, 2) = ty :LET l(tx, ty) = i :LET l(x, y) = s
4010 PRINT AT 17, 11; INK 2; "<Movement>";
4020 PRINT AT 18, 11; INK u(s, 1); n$(s); INK 4; " moves "; INK u(i, 1); n$(i) ; INK 4; "!";
4030 LET i = p :LET p = q :GO SUB 2850 :LET p = i :GO SUB 2850
4040 RETURN 
4050 REM off map check
4060 FOR p = 1  TO t  STEP 1
4070 IF d(p, 8) < 1  OR d(p, 1) > 0  THEN GO TO 4130
4080 GO SUB 2320
4090 GO SUB 2990
4100 PRINT AT 17, 11; INK 2; "<Movement>";
4110 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " fall into the "; AT 19, 11; "void and are eaten"; AT 20, 11; "by a passing cosmic"; AT 21, 11; "horror.";
4120 LET d(p, 8) = 0 :GO SUB 2300
4130 NEXT p
4140 RETURN 
4150 REM player attack
4160 IF a(d(p, 10), 3) = 0  THEN LET s = 0 :GO TO 4610
4170 IF d(p, 3) = 0  THEN LET x = d(p, 1) + a(d(p, 10), 1) :LET y = d(p, 2) + a(d(p, 10), 2) :GO TO 4210
4180 IF d(p, 3) = 1  THEN LET x = d(p, 1) + a(d(p, 10), 2) :LET y = d(p, 2) - a(d(p, 10), 1) :GO TO 4210
4190 IF d(p, 3) = 2  THEN LET x = d(p, 1) - a(d(p, 10), 1) :LET y = d(p, 2) - a(d(p, 10), 2) :GO TO 4210
4200 LET x = d(p, 1) - a(d(p, 10), 2) :LET y = d(p, 2) + a(d(p, 10), 1) 
4210 LET s = 0
4220 PRINT AT 17, 11; INK 2; "<Combat>";
4230 FOR q = 1  TO t  STEP 1
4240 IF d(q, 1) <>x  OR d(q, 2) <>y  THEN GO TO 4600
4250 INK u(p, 1) :GO SUB 2710 :INK 4
4260 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " attack "; INK u(q, 1); n$(q); INK 4; " x"; a(d(p, 10), 3); 
4270 PAPER u(p, 1) 
4280 LET s = p
4290 LET p = q
4300 GO SUB 2850
4310 LET q = p
4320 LET p = s
4330 PAPER 0 
4340 REM resolve shield based on relative positions and q dir
4350 LET tx = d(p, 1) - d(q, 1)
4360 LET ty = d(p, 2) - d(q, 2)
4370 IF ABS tx > ABS ty  AND tx > 0  THEN LET s = 6 :GO TO 4410
4380 IF ABS tx > ABS ty  THEN LET s = 4 :GO TO 4410
4390 IF ty > 0  THEN LET s = 5 :GO TO 4410
4400 LET s = 7
4410 LET s = s - d(q, 3)
4420 IF s > 7  THEN LET s = s - 4 :GO TO 4440
4430 IF s < 4  THEN LET s = s + 4
4440 LET tx = 19
4450 FOR i = 1  TO a(d(p, 10), 3)  STEP 1
4460 IF d(q, 8) < 1  THEN GO TO 4510
4470 IF RND * 9 < 5  THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; :GO TO 4510
4480 IF d(q, s) > 0  THEN LET d(q, s) = d(q, s) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! "; s$(s - 3); " shields -1"; :GO TO 4510
4490 IF d(q, 8) > 1  THEN LET d(q, 8) = d(q, 8) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Hull -1"; :GO TO 4510
4500 IF d(q, 8) = 1  THEN LET d(q, 8) = 0 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Ship destroyed!"; :GO SUB 2940 :GO SUB 2300
4510 LET tx = tx + 1
4520 NEXT i
4530 REM refresh attacked ship
4540 LET i = p
4550 LET p = q
4560 GO SUB 2790
4570 GO SUB 2300
4580 GO SUB 2850
4590 LET p = i
4600 NEXT q
4610 IF s = 0  THEN PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " do not attack.";
4620 RETURN 
4630 REM end game check
4640 LET i = 0
4650 LET q = 1
4660 FOR p = 1  TO t  STEP 1
4670 IF d(p, 1) > 0  THEN LET q = p :LET i = i + 1
4680 NEXT p 
4690 REM still at least 2 players
4700 IF i > 1  THEN RETURN 
4710 REM ends game
4720 LET t = 0
4730 REM 1st player or winner colours
4740 LET p = q
4750 GO SUB 2320
4760 PRINT AT 17, 11; INK 2; "<GAME OVER>";
4770 IF i = 0  THEN PRINT AT 18, 11; "Everybody is dead."; :GO TO 4790
4780 PRINT AT 18, 11; INK u(p, 1); "SPACE "; n$(p); INK 4; " have won.";
4790 GO SUB 2300
4800 RETURN 
4810 REM resolve AI movement
4820 LET d(p, 9) = 0
4830 FOR q = 1  TO t  STEP 1
4840 IF q = p  OR d(q, 1) < 1  THEN GO TO 4880
4850 GO SUB 5030 :REM load tx, ty
4860 LET tx = tx + 4 :LET ty = ty + 3
4870 IF tx > 0  AND tx < 7  AND ty > 0  AND ty < 6  THEN LET d(p, 9) = v(tx, ty) :RETURN 
4880 NEXT q
4890 IF ty > -11  AND ty < 0  THEN LET d(p, 9) = 1 :RETURN 
4900 IF tx > 5  AND tx < 16  THEN LET d(p, 9) = 5 :RETURN 
4910 LET d(p, 9) = 3
4920 RETURN 
4930 REM resolve AI attack
4940 LET d(p, 10) = 0
4950 FOR q = 1  TO t  STEP 1
4960 IF q = p  OR d(q, 1) < 1  THEN GO TO 5000
4970 GO SUB 5030 :REM load tx, ty
4980 LET tx = tx + 4 :LET ty = ty + 3
4990 IF tx > 0  AND tx < 7  AND ty > 0  AND ty < 6  THEN LET d(p, 10) = ((tx - 1) * 5) + ty :RETURN 
5000 NEXT q
5010 IF d(p, 10) = 0  THEN LET d(p, 10) = 19
5020 RETURN 
5030 REM load tx, ty with target relative position
5040 IF d(p, 3) = 0  THEN LET tx = d(q, 1) - d(p, 1) :LET ty = d(q, 2) - d(p, 2) :RETURN 
5050 IF d(p, 3) = 1  THEN LET tx = d(p, 2) - d(q, 2) :LET ty = d(q, 1) - d(p, 1) :RETURN 
5060 IF d(p, 3) = 2  THEN LET tx = d(p, 1) - d(q, 1) :LET ty = d(p, 2) - d(q, 2) :RETURN 
5070 LET tx = d(q, 2) - d(p, 2) :LET ty = d(p, 1) - d(q, 1)
5080 RETURN 
5090 REM attack vectors data
5100 DATA -3, -2, 4, -3, -1, 4, -3, 0, 4
5110 DATA -3, 1, 4, -3, 2, 4, -2, -2, 1
5120 DATA -2, -1, 2, -2, 0, 2, -2, 1, 2
5130 DATA -2, 2, 1, -1, -2, 1, -1, -1, 3
5140 DATA -1, 0, 1, -1, 1, 3, -1, 2, 1
5150 DATA 0, -2, 1, 0, -1, 3, 0, 0, 0
5160 DATA 0, 1, 3, 0, 2, 1, 1, -2, 1
5170 DATA 1, -1, 3, 1, 0, 0, 1, 1, 3
5180 DATA 1, 2, 1, 2, -2, 1, 2, -1, 0
5190 DATA 2, 0, 0, 2, 1, 0, 2, 2, 1
5200 REM movement vectors data
5210 DATA -2, -1, -1, -2, -1, 0, -2, 0, 0
5220 DATA -2, 1, 0, -2, 1, 1, -1, -1, -1
5230 DATA -1, -1, 0, -1, 0, 0, -1, 1, 0
5240 DATA -1, 1, 1, 0, 0, 0, 0, 0, -1
5250 DATA 0, 0, 0, 0, 0, 1, 0, 0, 0
5260 REM player UIs data
5270 DATA 1, 5, 1, 1, 0, 0
5280 DATA 2, 4, 5, 9, 3, 3
5290 DATA 3, 2, 1, 9, 0, 3
5300 DATA 6, 3, 5, 1, 3, 0
5310 REM player names data
5320 DATA "FLEET", "ELVES", "CHAOS", "HORDE"
5330 REM player data
5340 DATA 1, 1, 2, 3, 3, 3, 3, 4, 0, 0
5350 DATA 8, 12, 0, 3, 3, 3, 3, 4, 0, 0
5360 DATA 1, 12, 2, 3, 3, 3, 3, 4, 0, 0
5370 DATA 8, 1, 0, 3, 3, 3, 3, 4, 0, 0
5380 REM UDGs data
5390 DATA 0, 3, 15, 31, 63, 63, 127, 127
5400 DATA 0, 192, 240, 248, 252, 252, 254, 254 
5410 DATA 127, 127, 63, 63, 31, 15, 3, 0 
5420 DATA 254, 254, 252, 252, 248, 240, 192, 0
5430 DATA 0, 0, 0, 0, 1, 7, 7, 15
5440 DATA 0, 0, 0, 0, 128, 224, 224, 240 
5450 DATA 15, 7, 7, 1, 0, 0, 0, 0
5460 DATA 240, 224, 224, 128, 0, 0, 0, 0
5470 DATA 0, 0, 0, 5, 15, 7, 15, 7
5480 DATA 0, 0, 0, 160, 240, 224, 240, 224
5490 DATA 7, 15, 7, 15, 5, 0, 0, 0 
5500 DATA 224, 240, 224, 240, 160, 0, 0, 0 
5510 DATA 0, 0, 0, 0, 80, 248, 240, 248 
5520 DATA 248, 240, 248, 80, 0, 0, 0, 0 
5530 DATA 0, 0, 0, 0, 10, 31, 15, 31 
5540 DATA 31, 15, 31, 10, 0, 0, 0, 0 
5550 DATA 0, 0, 0, 60, 60, 0, 0, 0 
5560 DATA 0, 0, 24, 24, 24, 24, 0, 0 
5570 DATA 0, 0, 0, 0, 24, 0, 0, 0
5580 REM movement ai behaviour data
5590 DATA 1, 2, 3, 4, 5
5600 DATA 6, 7, 8, 9, 10
5610 DATA 12, 12, 13, 14, 14
5620 DATA 12, 12, 13, 14, 14
5630 DATA 12, 12, 13, 14, 14
5640 DATA 12, 12, 13, 14, 14
5650 REM shields
5660 DATA "Front", "Right", " Rear", " Left"
