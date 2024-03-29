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
170 REM player data: 1:x,2:y,3:dir(0:u,1:r,2:d,3:l),4:front,5:right,6:back,7:left,8:hull,9:manoeuvre,10:attack
180 DIM d(4, 10)
190 REM player UIs: 1:ship,2:planet,3:planet-x,4:planet-y;5:shield-x;6:shield-y
200 DIM u(4, 6)
210 REM movement ai behaviours
220 DIM v(6, 5)
230 REM debug 1 or 0 TODO remember to remove
240 LET d = 0
250 REM load attack vectors
260 RESTORE 4790
270 FOR x = 1  TO 30  STEP 1
280 FOR y = 1  TO 3  STEP 1
290 READ a(x, y)
300 NEXT y
310 NEXT x
320 REM load movement vectors
330 RESTORE 4900
340 FOR x = 1  TO 15  STEP 1
350 FOR y = 1  TO 3  STEP 1
360 READ m(x, y)
370 NEXT y
380 NEXT x
390 REM load player UIs and name
400 RESTORE 4960
410 FOR x = 1  TO 4  STEP 1
420 FOR y = 1  TO 6  STEP 1
430 READ u(x, y)
440 NEXT y
450 NEXT x
460 RESTORE 5010
470 FOR x = 1  TO 4  STEP 1
480 READ n$(x)
490 NEXT x
500 REM load movement ai behaviours
510 RESTORE 5280
520 FOR x = 1  TO 6  STEP 1
530 FOR y = 1  TO 5  STEP 1
540 READ v(x, y)
550 NEXT y
560 NEXT x
570 REM load UDGs
580 LET i = USR "a"
590 LET t = i+8*19-1
600 RESTORE 5080
610 FOR x = i  TO t  STEP 1
620 READ y
630 POKE x, y
640 NEXT x
650 LET k$ = ""
660 CLS 
670 GO SUB 1220
680 GO SUB 1740 :GO SUB 1120
690 IF k$ <>"Y" THEN GO TO 660
700 REM main game loop
710 FOR p = 1  TO t  STEP 1
720 REM movement phase
730 IF d(p, 1) = 0  THEN GO TO 800 :REM dead
740 IF p > (t - u)  THEN GO SUB 4500 :GO TO 800 :REM AI
750 LET k$ = ""
760 GO SUB 2230 :GO SUB 2900
770 GO SUB 1830
780 GO SUB 1740
790 IF k$ <>"Y" THEN GO TO 750
800 NEXT p
810 REM apply movement
820 GO SUB 3030
830 GO SUB 3430
840 GO SUB 3740 :GO SUB 1120
850 REM combat phase
860 FOR p = 1  TO t  STEP 1
870 IF d(p, 8) < 1  THEN GO TO 960 :REM dead
880 IF p > (t - u)  THEN GO SUB 4620 :GO TO 960 :REM AI
890 LET k$ = ""
900 GO SUB 2230
910 GO SUB 2900
920 IF i = 0  THEN LET d(p, 10) = 18 :GO TO 960 :REM cannot attack
930 GO SUB 2000
940 GO SUB 1740
950 IF k$ <>"Y" THEN GO TO 900
960 REM next attack input     
970 NEXT p
980 REM apply combat
990 FOR p = 1  TO t  STEP 1
1000 REM if ship on map
1010 IF d(p, 1) > 0  THEN GO SUB 2230 :GO SUB 2900 :GO SUB 3840
1020 NEXT p 
1030 REM move killed ships off map
1040 FOR p = 1  TO t  STEP 1
1050 REM if ship on map and 0 hull move off map
1060 IF d(p, 1) > 0  AND d(p, 8) < 1  THEN LET l(d(p, 1), d(p, 2)) = 0 :LET d(p, 1) = 0
1070 NEXT p
1080 GO SUB 4320
1090 GO SUB 1120
1100 IF t > 0  THEN GO TO 710
1110 GO TO 660
1120 REM debug draw map
1130 IF d = 0  THEN RETURN 
1140 FOR x = 1  TO 8  STEP 1
1150 FOR y = 1  TO 12  STEP 1
1160 LET tx = (x - 1) * 2
1170 LET ty = ((y - 1) * 2) + 8
1180 PRINT AT tx, ty; l(x, y);
1190 NEXT Y
1200 NEXT x
1210 RETURN 
1220 REM initialise game
1230 LET p = 1
1240 LET t = 0
1250 GO SUB 2230
1260 PRINT AT 17, 11; INK 5; "<SPACE FLEET>";
1270 PRINT AT 19, 11; "Enter players 2-4? "; FLASH 1; CHR$ (143);
1280 PAUSE 0
1290 LET k$ = INKEY$ 
1300 IF CODE (k$) < 50  OR CODE (k$) > 52  THEN GO TO 1280
1310 PRINT AT 19, 30; k$;
1320 LET t = VAL (k$)
1330 PRINT AT 20, 11; "AI players 0-"; t-1; "? "; FLASH 1; CHR$ (143);
1340 PAUSE 0
1350 LET k$ = INKEY$ 
1360 IF CODE (k$) < 48  OR CODE (k$) > 48+t-1  THEN GO TO 1340
1370 PRINT AT 20, 27; k$;
1380 LET u = VAL (k$)
1390 PRINT AT 21, 11; "Loading map...";
1400 REM clear map
1410 FOR y = 1  TO 12  STEP 1
1420 FOR x = 1  TO 8
1430 LET l(x, y) = 0
1440 NEXT x
1450 NEXT y 
1460 REM load player data
1470 RESTORE 5030
1480 FOR x = 1  TO t  STEP 1
1490 FOR y = 1  TO 10  STEP 1
1500 READ d(x, y)
1510 NEXT y
1520 LET l(d(x, 1), d(x, 2)) = x :REM 1-4=player
1530 NEXT x
1540 REM generate planet locations
1550 RANDOMIZE 0
1560 FOR p = 1  TO 4 
1570 REM randomise planet locations
1580 LET x = INT (RND * 4) + u(p, 3)
1590 LET y = INT (RND * 4) + u(p, 4)
1600 REM avoid edges
1610 IF x < 2  OR x > 7  OR y < 2  OR y > 11  THEN GO TO 1570
1620 REM update map and draw planet
1630 LET l(x, y) = 5 :REM 5=planet
1640 LET tx = (x - 1) * 2
1650 LET ty = ((y - 1) * 2) + 8
1660 PRINT AT tx, ty; INK u(p, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
1670 NEXT p
1680 REM draw players
1690 FOR p = 1  TO t  STEP 1
1700 GO SUB 2700
1710 GO SUB 2760
1720 NEXT p
1730 RETURN 
1740 REM console confirm
1750 PRINT #1; AT 1, 11; INK 6; "Confirm Y/N? "; FLASH 1; CHR$ (143);
1760 PAUSE 0
1770 LET k$ = INKEY$ 
1780 IF k$ = "y" OR k$ = "Y" THEN LET k$ = "Y":GO TO 1810
1790 IF k$ = "n" OR k$ = "N" THEN LET k$ = "N":GO TO 1810
1800 GO TO 1760
1810 PRINT #1; AT 1, 24; INK 6; k$;
1820 RETURN 
1830 REM console movement
1840 PRINT AT 17, 11; INK 5; "<Helm Computer>";
1850 PRINT AT 19, 11; "Speed A/B/C? "; FLASH 1; CHR$ (143);
1860 LET d(p, 9) = 1
1870 PAUSE 0 
1880 IF INKEY$ = "A" OR INKEY$ = "a" THEN LET d(p, 9) = 0 :LET k$ = "A":GO TO 1910
1890 IF INKEY$ = "B" OR INKEY$ = "b" THEN LET d(p, 9) = 5 :LET k$ = "B":GO TO 1910
1900 IF INKEY$ = "C" OR INKEY$ = "c" THEN LET d(p, 9) = 10 :LET k$ = "C"
1910 IF d(p, 9) = 1  THEN GO TO 1870
1920 PRINT AT 19, 24; k$;
1930 PRINT AT 20, 11; "Movement 1-5? "; FLASH 1; CHR$ (143);
1940 PAUSE 0
1950 LET k$ = INKEY$ 
1960 IF CODE (k$) < 49  OR CODE (k$) > 53  THEN GO TO 1940
1970 PRINT AT 20, 25; k$;
1980 LET d(p, 9) = d(p, 9) + VAL (k$) 
1990 RETURN 
2000 REM console attack
2010 PRINT AT 17, 11; INK 5; "<Combat Display>";
2020 PRINT AT 19, 11; "Distance A-F? "; FLASH 1; CHR$ (143); 
2030 LET d(p, 10) = 1
2040 PAUSE 0 
2050 IF INKEY$ = "A" OR INKEY$ = "a" THEN LET d(p, 10) = 0 :LET k$ = "A":GO TO 2110
2060 IF INKEY$ = "B" OR INKEY$ = "b" THEN LET d(p, 10) = 5 :LET k$ = "B":GO TO 2110
2070 IF INKEY$ = "C" OR INKEY$ = "c" THEN LET d(p, 10) = 10 :LET k$ = "C":GO TO 2110
2080 IF INKEY$ = "D" OR INKEY$ = "d" THEN LET d(p, 10) = 15 :LET k$ = "D":GO TO 2110
2090 IF INKEY$ = "E" OR INKEY$ = "e" THEN LET d(p, 10) = 20 :LET k$ = "E":GO TO 2110
2100 IF INKEY$ = "F" OR INKEY$ = "f" THEN LET d(p, 10) = 25 :LET k$ = "F"
2110 IF d(p, 10) = 1  THEN GO TO 2040
2120 PRINT AT 19, 25; k$;
2130 PRINT AT 20, 11; "Arc 1-5? "; FLASH 1; CHR$ (143);
2140 LET k$ = ""
2150 PAUSE 0
2160 LET k$ = INKEY$ 
2170 IF CODE (k$) < 49  OR CODE (k$) > 53  THEN GO TO 2150
2180 PRINT AT 20, 20; k$;
2190 LET d(p, 10) = d(p, 10) + VAL (k$) 
2200 RETURN 
2210 REM console any key
2220 PRINT #1; AT 1, 11; INK 6; "Press any key."; :PAUSE 0 :RETURN 
2230 REM draw common controls
2240 PRINT AT 0, 0; INK 5; "Combat";
2250 PRINT AT 1, 0; INK 5; "Display";
2260 PRINT AT 2, 1; "12345";
2270 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4";
2280 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2";
2290 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1";
2300 PRINT AT 6, 0; "D"; PAPER 6; "  "; AT 6, 4; PAPER 6; "  ";
2310 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  ";
2320 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " ";
2330 PRINT AT 9, 4; INK 6; "31";
2340 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
2350 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
2360 PRINT AT 18, 1; " "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
2370 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
2380 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
2390 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
2400 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
2410 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
2420 REM draw player controls and clear console
2430 INK u(p, 1)
2440 PRINT AT 0, 6; CHR$ (133); CHR$ (161);
2450 PRINT AT 1, 7; CHR$ (161);
2460 PRINT AT 2, 0; CHR$ (138); AT 2, 6; CHR$ (133); CHR$ (161);
2470 PRINT AT 3, 7; CHR$ (161);
2480 PRINT AT 4, 7; CHR$ (161);
2490 PRINT AT 5, 7; CHR$ (161);
2500 PRINT AT 6, 3; CHR$ (161); AT 6, 6; CHR$ (133); CHR$ (161);
2510 PRINT AT 7, 6; CHR$ (133); CHR$ (161);
2520 PRINT AT 8, 6; CHR$ (133); CHR$ (161);
2530 PRINT AT 9, 0; CHR$ (142); CHR$ (140); CHR$ (140); CHR$ (140); AT 9, 6; CHR$ (141); CHR$ (161);
2540 PRINT AT 10, 6; CHR$ (133); CHR$ (161);
2550 PRINT AT 11, 6; CHR$ (133); CHR$ (161);
2560 PRINT AT 12, 6; CHR$ (133); CHR$ (161);
2570 PRINT AT 13, 6; CHR$ (133); CHR$ (161);
2580 PRINT AT 14, 6; CHR$ (133); CHR$ (161);
2590 PRINT AT 15, 6; CHR$ (133); CHR$ (161);
2600 PRINT AT 16, 4; CHR$ (140); AT 16, 13; CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); INK 7; PAPER 0; "SPACE"; INK u(p, 1); CHR$ (140); INK 7; n$(p);
2610 PRINT AT 17, 10; CHR$ (138); "                     ";
2620 PRINT AT 18, 10; CHR$ (138); "                     ";
2630 PRINT AT 19, 10; CHR$ (138); "                     ";
2640 PRINT AT 20, 10; CHR$ (138); "                     ";
2650 PRINT AT 21, 10; CHR$ (138); "                     ";
2660 PRINT #1; AT 0, 10; INK u(p, 1); CHR$ (138); "                     ";
2670 PRINT #1; AT 1, 10; INK u(p, 1); CHR$ (138); "                     ";
2680 INK 4
2690 RETURN 
2700 REM draw player shields
2710 IF d(p, 8) < 1  THEN PRINT AT 10 + u(p, 5), 1 + u(p, 6); " "; AT 11 + u(p, 5), u(p, 6); "   "; AT 12 + u(p, 5), 1 + u(p, 6); " "; :RETURN 
2720 PRINT AT 10 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 4);
2730 PRINT AT 11 + u(p, 5), u(p, 6); INK u(p, 1); d(p, 7); INK 0; PAPER u(p, 1); d(p, 8); INK u(p, 1); PAPER 0; d(p, 5);
2740 PRINT AT 12 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 6);
2750 RETURN 
2760 REM draw player ship
2770 LET tx = (d(p, 1) - 1) * 2
2780 LET ty = ((d(p, 2) - 1) * 2) + 8
2790 IF d(p, 8) = 0  THEN PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; :RETURN 
2800 IF d(p, 3) = 0  THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (152); CHR$ (153); AT tx + 1, ty; CHR$ (150); CHR$ (151); :RETURN 
2810 IF d(p, 3) = 1  THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (156); AT tx + 1, ty; CHR$ (150); CHR$ (157); :RETURN 
2820 IF d(p, 3) = 2  THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (149); AT tx + 1, ty; CHR$ (154); CHR$ (155); :RETURN 
2830 PRINT AT tx, ty; INK u(p, 1); CHR$ (158); CHR$ (149); AT tx + 1, ty; CHR$ (159); CHR$ (151);
2840 RETURN 
2850 REM draw target explosion
2860 LET tx = (d(q, 1) - 1) * 2
2870 LET ty = ((d(q, 2) - 1) * 2) + 8
2880 PRINT AT tx, ty; INK 6; PAPER 2; FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
2890 RETURN 
2900 REM overlay and count targets
2910 LET i = 0 
2920 FOR q = 1  TO t  STEP 1
2930 IF q = p  OR d(q, 1) < 1  THEN GO TO 3010
2940 GO SUB 4720 :REM load tx, ty
2950 LET tx = tx + 4 :LET ty = ty + 3
2960 IF tx < 1  OR tx > 6  OR ty < 1  OR ty > 5  THEN GO TO 3010
2970 LET s = d(p, 3) + d(q, 3)
2980 IF s = 1  OR s = 3  OR s = 5  THEN PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (160); :GO TO 3000
2990 PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (161);
3000 IF a(((tx - 1) * 5) + ty, 3) > 0  THEN LET i = i + 1
3010 NEXT q
3020 RETURN 
3030 REM apply movement
3040 FOR p = 1  TO t  STEP 1
3050 IF d(p, 1) < 1  THEN GO TO 3200
3060 IF d(p, 3) = 0  THEN LET x = d(p, 1) + m(d(p, 9), 1) :LET y = d(p, 2) + m(d(p, 9), 2) :GO TO 3100
3070 IF d(p, 3) = 1  THEN LET x = d(p, 1) + m(d(p, 9), 2) :LET y = d(p, 2) - m(d(p, 9), 1) :GO TO 3100
3080 IF d(p, 3) = 2  THEN LET x = d(p, 1) - m(d(p, 9), 1) :LET y = d(p, 2) - m(d(p, 9), 2) :GO TO 3100
3090 LET x = d(p, 1) - m(d(p, 9), 2) :LET y = d(p, 2) + m(d(p, 9), 1)
3100 IF x < 1  OR x > 8  OR y < 1  OR y > 12  THEN LET x = 0 :GO TO 3120
3110 GO SUB 3220
3120 LET l(d(p, 1), d(p, 2)) = 0 :REM clear map
3130 LET tx = (d(p, 1) - 1) * 2 :LET ty = ((d(p, 2) - 1) * 2) + 8 :REM clear screen pos 1
3140 LET d(p, 1) = x :LET d(p, 2) = y :REM update player
3150 LET d(p, 3) = d(p, 3) + m(d(p, 9), 3) :REM update dir
3160 IF d(p, 3) > 3  THEN LET d(p, 3) = d(p, 3) - 4 :GO TO 3180
3170 IF d(p, 3) < 0  THEN LET d(p, 3) = d(p, 3) + 4
3180 PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; :REM clear screen pos 2
3190 IF x > 0  THEN LET l(x, y) = p :GO SUB 2760
3200 NEXT p
3210 RETURN 
3220 REM planet collision check
3230 IF l(x, y) <>5  THEN RETURN 
3240 GO SUB 2230
3250 GO SUB 2900
3260 PRINT AT 17, 11; INK 2; "<Movement>";
3270 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " crash land! x4";
3280 LET tx = 19
3290 FOR i = 1  TO 4  STEP 1
3300 IF RND * 9 < 5  THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "AVOID!"; :GO TO 3340
3310 IF d(p, 4) > 0  THEN LET d(p, 4) = d(p, 4) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "CRASH! Shields -1."; :GO TO 3340
3320 IF d(p, 8) > 1  THEN LET d(p, 8) = d(p, 8) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "CRASH! Hull -1."; :GO TO 3340
3330 IF d(p, 8) = 1  THEN LET d(p, 8) = 0 :LET x = 0 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "CRASH! Ship wrecked!"; :LET q = p :GO SUB 2850 :GO TO 3400
3340 LET tx = tx + 1
3350 NEXT i
3360 IF d(p, 3) = 0  THEN LET x = x + 1 :GO TO 3400
3370 IF d(p, 3) = 1  THEN LET y = y - 1 :GO TO 3400
3380 IF d(p, 3) = 2  THEN LET x = x - 1 :GO TO 3400
3390 LET y = y + 1
3400 GO SUB 2700 :GO SUB 2210
3410 IF x > 0  THEN GO SUB 3220
3420 RETURN 
3430 REM player collision check
3440 FOR p = 1  TO t  STEP 1
3450 IF d(p, 1) < 1  THEN GO TO 3720
3460 GO SUB 2760
3470 FOR q = 1  TO t  STEP 1
3480 IF p = q  OR d(q, 1) < 1  OR d(p, 1) <>d(q, 1)  OR d(p, 2) <>d(q, 2)  THEN GO TO 3710
3490 REM collision!
3500 GO SUB 2230
3510 LET tx = 19
3520 PRINT AT 17, 11; INK 2; "<Movement>";
3530 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " ram "; INK u(q, 1); n$(q); INK 4; " x4";
3540 FOR i = 1  TO 4  STEP 1
3550 IF RND * 9 < 5  THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; :GO TO 3590
3560 IF d(q, 4) > 0  THEN LET d(q, 4) = d(q, 4) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! Shields damaged."; :GO TO 3590
3570 IF d(q, 8) > 1  THEN LET d(q, 8) = d(q, 8) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! Hull damaged."; :GO TO 3590
3580 IF d(q, 8) = 1  THEN LET d(q, 8) = 0 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! Ship destroyed!"; :GO TO 3610
3590 LET tx = tx + 1
3600 NEXT i
3610 LET tx = (d(p, 1) - 1) * 2
3620 LET ty = ((d(p, 2) - 1) * 2) + 8
3630 PRINT AT tx, ty; INK u(p, 1); PAPER u(q, 1); FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
3640 GO SUB 2210
3650 LET i = p
3660 LET p = q
3670 GO SUB 2700
3680 IF d(i, 8) = 0 THEN GO SUB 2760
3690 LET p = i
3700 IF d(q, 8) = 0 THEN GO SUB 2760
3710 NEXT q
3720 NEXT p
3730 RETURN 
3740 REM off map check
3750 FOR p = 1  TO t  STEP 1
3760 IF d(p, 8) < 1  OR d(p, 1) > 0  THEN GO TO 3820
3770 GO SUB 2230
3780 GO SUB 2900
3790 PRINT AT 17, 11; INK 2; "<Movement>";
3800 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " fall into the "; AT 19, 11; "void and are eaten"; AT 20, 11; "by a passing cosmic"; AT 21, 11; "horror.";
3810 LET d(p, 8) = 0 :GO SUB 2210
3820 NEXT p
3830 RETURN 
3840 REM player attack
3850 IF a(d(p, 10), 3) = 0  THEN LET s = 0 :GO TO 4300
3860 IF d(p, 3) = 0  THEN LET x = d(p, 1) + a(d(p, 10), 1) :LET y = d(p, 2) + a(d(p, 10), 2) :GO TO 3900
3870 IF d(p, 3) = 1  THEN LET x = d(p, 1) + a(d(p, 10), 2) :LET y = d(p, 2) - a(d(p, 10), 1) :GO TO 3900
3880 IF d(p, 3) = 2  THEN LET x = d(p, 1) - a(d(p, 10), 1) :LET y = d(p, 2) - a(d(p, 10), 2) :GO TO 3900
3890 LET x = d(p, 1) - a(d(p, 10), 2) :LET y = d(p, 2) + a(d(p, 10), 1) 
3900 LET s = 0
3910 PRINT AT 17, 11; INK 2; "<Combat>";
3920 FOR q = 1  TO t  STEP 1
3930 IF d(q, 1) <>x  OR d(q, 2) <>y  THEN GO TO 4290
3940 INK u(p, 1) :GO SUB 2620 :INK 4
3950 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " attack "; INK u(q, 1); n$(q); INK 4; " x"; a(d(p, 10), 3); 
3960 PAPER u(p, 1) 
3970 LET s = p
3980 LET p = q
3990 GO SUB 2760
4000 LET q = p
4010 LET p = s
4020 PAPER 0 
4030 REM resolve shield based on relative positions and q dir
4040 LET tx = d(p, 1) - d(q, 1)
4050 LET ty = d(p, 2) - d(q, 2)
4060 IF ABS tx > ABS ty  AND tx > 0  THEN LET s = 6 :GO TO 4100
4070 IF ABS tx > ABS ty  THEN LET s = 4 :GO TO 4100
4080 IF ty > 0  THEN LET s = 5 :GO TO 4100
4090 LET s = 7
4100 LET s = s - d(q, 3)
4110 IF s > 7  THEN LET s = s - 4 :GO TO 4130
4120 IF s < 4  THEN LET s = s + 4
4130 LET tx = 19
4140 FOR i = 1  TO a(d(p, 10), 3)  STEP 1
4150 IF d(q, 8) < 1  THEN GO TO 4200
4160 IF RND * 9 < 5  THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; :GO TO 4200
4170 IF d(q, s) > 0  THEN LET d(q, s) = d(q, s) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Shields damaged."; :GO TO 4200
4180 IF d(q, 8) > 1  THEN LET d(q, 8) = d(q, 8) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Hull damaged."; :GO TO 4200
4190 IF d(q, 8) = 1  THEN LET d(q, 8) = 0 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Ship destroyed!"; :GO SUB 2850 :GO SUB 2210
4200 LET tx = tx + 1
4210 NEXT i
4220 REM refresh attacked ship
4230 LET i = p
4240 LET p = q
4250 GO SUB 2700
4260 GO SUB 2210
4270 GO SUB 2760
4280 LET p = i
4290 NEXT q
4300 IF s = 0  THEN PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " do not attack.";
4310 RETURN 
4320 REM end game check
4330 LET i = 0
4340 LET q = 1
4350 FOR p = 1  TO t  STEP 1
4360 IF d(p, 1) > 0  THEN LET q = p :LET i = i + 1
4370 NEXT p 
4380 REM still at least 2 players
4390 IF i > 1  THEN RETURN 
4400 REM ends game
4410 LET t = 0
4420 REM 1st player or winner colours
4430 LET p = q
4440 GO SUB 2230
4450 PRINT AT 17, 11; INK 2; "<GAME OVER>";
4460 IF i = 0  THEN PRINT AT 18, 11; "Everybody is dead."; :GO TO 4480
4470 PRINT AT 18, 11; INK u(p, 1); "SPACE "; n$(p); INK 4; " have won.";
4480 GO SUB 2210
4490 RETURN 
4500 REM resolve AI movement
4510 LET d(p, 9) = 0
4520 FOR q = 1  TO t  STEP 1
4530 IF q = p  OR d(q, 1) < 1  THEN GO TO 4570
4540 GO SUB 4720 :REM load tx, ty
4550 LET tx = tx + 4 :LET ty = ty + 3
4560 IF tx > 0  AND tx < 7  AND ty > 0  AND ty < 6  THEN LET d(p, 9) = v(tx, ty) :RETURN 
4570 NEXT q
4580 IF ty > -11  AND ty < 0  THEN LET d(p, 9) = 1 :RETURN 
4590 IF tx > 5  AND tx < 16  THEN LET d(p, 9) = 5 :RETURN 
4600 LET d(p, 9) = 3
4610 RETURN 
4620 REM resolve AI attack
4630 LET d(p, 10) = 0
4640 FOR q = 1  TO t  STEP 1
4650 IF q = p  OR d(q, 1) < 1  THEN GO TO 4690
4660 GO SUB 4720 :REM load tx, ty
4670 LET tx = tx + 4 :LET ty = ty + 3
4680 IF tx > 0  AND tx < 7  AND ty > 0  AND ty < 6  THEN LET d(p, 10) = ((tx - 1) * 5) + ty :RETURN 
4690 NEXT q
4700 IF d(p, 10) = 0  THEN LET d(p, 10) = 19
4710 RETURN 
4720 REM load tx, ty with target relative position
4730 IF d(p, 3) = 0  THEN LET tx = d(q, 1) - d(p, 1) :LET ty = d(q, 2) - d(p, 2) :RETURN 
4740 IF d(p, 3) = 1  THEN LET tx = d(p, 2) - d(q, 2) :LET ty = d(q, 1) - d(p, 1) :RETURN 
4750 IF d(p, 3) = 2  THEN LET tx = d(p, 1) - d(q, 1) :LET ty = d(p, 2) - d(q, 2) :RETURN 
4760 LET tx = d(q, 2) - d(p, 2) :LET ty = d(p, 1) - d(q, 1)
4770 RETURN 
4780 REM attack vectors data
4790 DATA -3, -2, 4, -3, -1, 4, -3, 0, 4
4800 DATA -3, 1, 4, -3, 2, 4, -2, -2, 1
4810 DATA -2, -1, 2, -2, 0, 2, -2, 1, 2
4820 DATA -2, 2, 1, -1, -2, 1, -1, -1, 3
4830 DATA -1, 0, 1, -1, 1, 3, -1, 2, 1
4840 DATA 0, -2, 1, 0, -1, 3, 0, 0, 0
4850 DATA 0, 1, 3, 0, 2, 1, 1, -2, 1
4860 DATA 1, -1, 3, 1, 0, 0, 1, 1, 3
4870 DATA 1, 2, 1, 2, -2, 1, 2, -1, 0
4880 DATA 2, 0, 0, 2, 1, 0, 2, 2, 1
4890 REM movement vectors data
4900 DATA -2, -1, -1, -2, -1, 0, -2, 0, 0
4910 DATA -2, 1, 0, -2, 1, 1, -1, -1, -1
4920 DATA -1, -1, 0, -1, 0, 0, -1, 1, 0
4930 DATA -1, 1, 1, 0, 0, 0, 0, 0, -1
4940 DATA 0, 0, 0, 0, 0, 1, 0, 0, 0
4950 REM player UIs data
4960 DATA 1, 5, 1, 1, 0, 0
4970 DATA 2, 4, 5, 9, 3, 3
4980 DATA 3, 2, 1, 9, 0, 3
4990 DATA 6, 3, 5, 1, 3, 0
5000 REM player names data
5010 DATA "FLEET", "ELVES", "CHAOS", "HORDE"
5020 REM player data
5030 DATA 1, 1, 2, 3, 3, 3, 3, 4, 0, 0
5040 DATA 8, 12, 0, 3, 3, 3, 3, 4, 0, 0
5050 DATA 1, 12, 2, 3, 3, 3, 3, 4, 0, 0
5060 DATA 8, 1, 0, 3, 3, 3, 3, 4, 0, 0
5070 REM UDGs data
5080 DATA 0, 3, 15, 31, 63, 63, 127, 127
5090 DATA 0, 192, 240, 248, 252, 252, 254, 254 
5100 DATA 127, 127, 63, 63, 31, 15, 3, 0 
5110 DATA 254, 254, 252, 252, 248, 240, 192, 0
5120 DATA 0, 0, 0, 0, 1, 7, 7, 15
5130 DATA 0, 0, 0, 0, 128, 224, 224, 240 
5140 DATA 15, 7, 7, 1, 0, 0, 0, 0
5150 DATA 240, 224, 224, 128, 0, 0, 0, 0
5160 DATA 0, 0, 0, 5, 15, 7, 15, 7
5170 DATA 0, 0, 0, 160, 240, 224, 240, 224
5180 DATA 7, 15, 7, 15, 5, 0, 0, 0 
5190 DATA 224, 240, 224, 240, 160, 0, 0, 0 
5200 DATA 0, 0, 0, 0, 80, 248, 240, 248 
5210 DATA 248, 240, 248, 80, 0, 0, 0, 0 
5220 DATA 0, 0, 0, 0, 10, 31, 15, 31 
5230 DATA 31, 15, 31, 10, 0, 0, 0, 0 
5240 DATA 0, 0, 0, 60, 60, 0, 0, 0 
5250 DATA 0, 0, 24, 24, 24, 24, 0, 0 
5260 DATA 0, 0, 0, 0, 24, 0, 0, 0
5270 REM movement ai behaviour data
5280 DATA 1, 2, 3, 4, 5
5290 DATA 6, 7, 8, 9, 10
5300 DATA 12, 12, 13, 14, 14
5310 DATA 12, 12, 13, 14, 14
5320 DATA 12, 12, 13, 14, 14
5330 DATA 12, 12, 13, 14, 14
