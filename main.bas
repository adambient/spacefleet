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
300 RESTORE 5350
310 FOR x = 1  TO 30  STEP 1
320 FOR y = 1  TO 3  STEP 1
330 READ a(x, y)
340 NEXT y
350 NEXT x
360 REM load movement vectors
370 RESTORE 5460
380 FOR x = 1  TO 15  STEP 1
390 FOR y = 1  TO 3  STEP 1
400 READ m(x, y)
410 NEXT y
420 NEXT x
430 REM load player UIs, names and shields
440 RESTORE 5520
450 FOR x = 1  TO 4  STEP 1
460 FOR y = 1  TO 6  STEP 1
470 READ u(x, y)
480 NEXT y
490 NEXT x
500 RESTORE 5570
510 FOR x = 1  TO 4  STEP 1
520 READ n$(x)
530 NEXT x
540 RESTORE 5910
550 FOR x = 1  TO 4  STEP 1
560 READ s$(x)
570 NEXT x
580 REM load movement ai behaviours
590 RESTORE 5840
600 FOR x = 1  TO 6  STEP 1
610 FOR y = 1  TO 5  STEP 1
620 READ v(x, y)
630 NEXT y
640 NEXT x
650 REM load UDGs
660 LET i = USR "a"
670 LET t = i+8*19-1
680 RESTORE 5640
690 FOR x = i  TO t  STEP 1
700 READ y
710 POKE x, y
720 NEXT x
730 LET k$ = ""
740 GO SUB 1320
750 GO SUB 1860
760 GO SUB 1220
770 IF k$ <>"Y" THEN GO TO 740
780 REM main game loop
790 FOR p = 1  TO t  STEP 1
800 REM movement phase
810 IF d(p, 1) = 0  THEN GO TO 890 :REM dead
820 IF p > (t - u)  THEN GO SUB 5060 :GO TO 890 :REM AI
830 LET k$ = ""
840 GO SUB 2390
850 GO SUB 3060
860 GO SUB 1950
870 GO SUB 1860
880 IF k$ <>"Y" THEN GO TO 830
890 NEXT p
900 REM apply movement
910 GO SUB 3370
920 GO SUB 3780
930 GO SUB 4300
940 GO SUB 1220
950 REM combat phase
960 FOR p = 1  TO t  STEP 1
970 IF d(p, 8) < 1  THEN GO TO 1060 :REM dead
980 IF p > (t - u)  THEN GO SUB 5180 :GO TO 1060 :REM AI
990 LET k$ = ""
1000 GO SUB 2390
1010 GO SUB 3060
1020 IF i = 0  THEN LET d(p, 10) = 18 :PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " cannot attack.":GO TO 1060
1030 GO SUB 2140
1040 GO SUB 1860
1050 IF k$ <>"Y" THEN GO TO 1000
1060 REM next attack input     
1070 NEXT p
1080 REM apply combat
1090 FOR p = 1  TO t  STEP 1
1100 REM if ship on map
1110 IF d(p, 1) > 0  THEN GO SUB 2390 :GO SUB 3060 :GO SUB 4400
1120 NEXT p 
1130 REM move killed ships off map
1140 FOR p = 1  TO t  STEP 1
1150 REM if ship on map and 0 hull move off map
1160 IF d(p, 1) > 0  AND d(p, 8) < 1  THEN LET l(d(p, 1), d(p, 2)) = 0 :LET d(p, 1) = 0
1170 NEXT p
1180 GO SUB 4880
1190 GO SUB 1220
1200 IF t > 0  THEN GO TO 790
1210 GO TO 740
1220 REM debug draw map
1230 IF d = 0  THEN RETURN 
1240 FOR x = 1  TO 8  STEP 1
1250 FOR y = 1  TO 12  STEP 1
1260 LET tx = (x - 1) * 2
1270 LET ty = ((y - 1) * 2) + 8
1280 PRINT AT tx, ty; l(x, y);
1290 NEXT Y
1300 NEXT x
1310 RETURN 
1320 REM initialise game
1330 LET p = 1 :LET t = 0
1340 GO SUB 6340
1350 GO SUB 2390
1360 PRINT AT 17, 11; INK 5; "<SPACE FLEET>";
1370 PRINT AT 19, 11; "Enter players 2-4? "; FLASH 1; CHR$ (143);
1380 PAUSE 0
1390 LET k$ = INKEY$ 
1400 IF CODE (k$) < 50  OR CODE (k$) > 52  THEN GO TO 1380
1410 PRINT AT 19, 30; k$;
1420 LET t = VAL (k$)
1430 PRINT AT 20, 11; "AI players 0-"; t-1; "? "; FLASH 1; CHR$ (143);
1440 PAUSE 0
1450 LET k$ = INKEY$ 
1460 IF CODE (k$) < 48  OR CODE (k$) > 48+t-1  THEN GO TO 1440
1470 PRINT AT 20, 27; k$;
1480 LET u = VAL (k$)
1490 PRINT AT 21, 11; "Loading map...";
1500 REM clear map
1510 FOR y = 1  TO 12  STEP 1
1520 FOR x = 1  TO 8
1530 LET l(x, y) = 0
1540 NEXT x
1550 NEXT y 
1560 REM load player data
1570 RESTORE 5590
1580 FOR x = 1  TO t  STEP 1
1590 FOR y = 1  TO 10  STEP 1
1600 READ d(x, y)
1610 NEXT y
1620 LET l(d(x, 1), d(x, 2)) = x :REM 1-4=player
1630 NEXT x
1640 REM generate planet locations
1650 RANDOMIZE 0
1660 FOR p = 1  TO 4 
1670 REM randomise planet locations
1680 LET x = INT (RND * 4) + u(p, 3)
1690 LET y = INT (RND * 4) + u(p, 4)
1700 REM avoid edges
1710 IF x < 2  OR x > 7  OR y < 2  OR y > 11  THEN GO TO 1670
1720 REM update map and draw planet
1730 LET l(x, y) = 4 + p :REM 5+=planet
1740 LET tx = (x - 1) * 2
1750 LET ty = ((y - 1) * 2) + 8
1760 LET c(p, 1) = tx
1770 LET c(p, 2) = ty
1780 PRINT AT tx, ty; INK u(p, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
1790 NEXT p
1800 REM draw players
1810 FOR p = 1  TO t  STEP 1
1820 GO SUB 2860
1830 GO SUB 2920
1840 NEXT p
1850 RETURN 
1860 REM console confirm
1870 PRINT #1; AT 1, 11; INK 6; "Confirm Y/N? "; FLASH 1; CHR$ (143);
1880 PAUSE 0
1890 LET k$ = INKEY$ 
1900 IF k$ = "y" OR k$ = "Y" THEN LET k$ = "Y":GO TO 1930
1910 IF k$ = "n" OR k$ = "N" THEN LET k$ = "N":GO TO 1930
1920 GO TO 1880
1930 PRINT #1; AT 1, 24; INK 6; k$;
1940 RETURN 
1950 REM console movement
1960 PRINT AT 17, 11; INK 5; "<Helm Computer>";
1970 PRINT AT 19, 11; "Speed A/B/C? "; FLASH 1; CHR$ (143);
1980 PRINT AT 20, 11; "[i] for instructions.";
1990 LET d(p, 9) = 1
2000 PAUSE 0 
2010 IF INKEY$ = "A" OR INKEY$ = "a" THEN LET d(p, 9) = 0 :LET k$ = "A":GO TO 2050
2020 IF INKEY$ = "B" OR INKEY$ = "b" THEN LET d(p, 9) = 5 :LET k$ = "B":GO TO 2050
2030 IF INKEY$ = "C" OR INKEY$ = "c" THEN LET d(p, 9) = 10 :LET k$ = "C":GO TO 2050
2040 IF INKEY$ = "I" OR INKEY$ = "i" THEN GO SUB 5920 :GO TO 1960
2050 IF d(p, 9) = 1  THEN GO TO 2000
2060 PRINT AT 19, 24; k$;
2070 PRINT AT 20, 11; "Movement 1-5? "; FLASH 1; CHR$ (143); FLASH 0; "      ";
2080 PAUSE 0
2090 LET k$ = INKEY$ 
2100 IF CODE (k$) < 49  OR CODE (k$) > 53  THEN GO TO 2080
2110 PRINT AT 20, 25; k$;
2120 LET d(p, 9) = d(p, 9) + VAL (k$) 
2130 RETURN 
2140 REM console attack
2150 PRINT AT 17, 11; INK 5; "<Combat Display>";
2160 PRINT AT 19, 11; "Distance A-F? "; FLASH 1; CHR$ (143); 
2170 PRINT AT 20, 11; "[i] for instructions.";
2180 LET d(p, 10) = 1
2190 PAUSE 0 
2200 IF INKEY$ = "A" OR INKEY$ = "a" THEN LET d(p, 10) = 0 :LET k$ = "A":GO TO 2270
2210 IF INKEY$ = "B" OR INKEY$ = "b" THEN LET d(p, 10) = 5 :LET k$ = "B":GO TO 2270
2220 IF INKEY$ = "C" OR INKEY$ = "c" THEN LET d(p, 10) = 10 :LET k$ = "C":GO TO 2270
2230 IF INKEY$ = "D" OR INKEY$ = "d" THEN LET d(p, 10) = 15 :LET k$ = "D":GO TO 2270
2240 IF INKEY$ = "E" OR INKEY$ = "e" THEN LET d(p, 10) = 20 :LET k$ = "E":GO TO 2270
2250 IF INKEY$ = "F" OR INKEY$ = "f" THEN LET d(p, 10) = 25 :LET k$ = "F":GO TO 2270
2260 IF INKEY$ = "I" OR INKEY$ = "i" THEN GO SUB 6120 :GO TO 2150
2270 IF d(p, 10) = 1  THEN GO TO 2190
2280 PRINT AT 19, 25; k$;
2290 PRINT AT 20, 11; "Arc 1-5? "; FLASH 1; CHR$ (143); FLASH 0; "           ";
2300 LET k$ = ""
2310 PAUSE 0
2320 LET k$ = INKEY$ 
2330 IF CODE (k$) < 49  OR CODE (k$) > 53  THEN GO TO 2310
2340 PRINT AT 20, 20; k$;
2350 LET d(p, 10) = d(p, 10) + VAL (k$) 
2360 RETURN 
2370 REM console any key
2380 PRINT #1; AT 1, 11; INK 6; "Press any key."; :PAUSE 0 :RETURN 
2390 REM draw common controls
2400 PRINT AT 0, 0; INK 5; "Combat";
2410 PRINT AT 1, 0; INK 5; "Display";
2420 PRINT AT 2, 1; "12345";
2430 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4";
2440 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2";
2450 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1";
2460 PRINT AT 6, 0; "D"; PAPER 6; "  "; AT 6, 4; PAPER 6; "  ";
2470 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  ";
2480 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " ";
2490 PRINT AT 9, 4; INK 6; "31";
2500 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
2510 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
2520 PRINT AT 18, 1; " "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
2530 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
2540 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
2550 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
2560 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
2570 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
2580 REM draw player controls and clear console
2590 INK u(p, 1)
2600 PRINT AT 0, 6; CHR$ (133); CHR$ (161);
2610 PRINT AT 1, 7; CHR$ (161);
2620 PRINT AT 2, 0; CHR$ (138); AT 2, 6; CHR$ (133); CHR$ (161);
2630 PRINT AT 3, 7; CHR$ (161);
2640 PRINT AT 4, 7; CHR$ (161);
2650 PRINT AT 5, 7; CHR$ (161);
2660 PRINT AT 6, 3; CHR$ (161); AT 6, 6; CHR$ (133); CHR$ (161);
2670 PRINT AT 7, 6; CHR$ (133); CHR$ (161);
2680 PRINT AT 8, 6; CHR$ (133); CHR$ (161);
2690 PRINT AT 9, 0; CHR$ (142); CHR$ (140); CHR$ (140); CHR$ (140); AT 9, 6; CHR$ (141); CHR$ (161);
2700 PRINT AT 10, 6; CHR$ (133); CHR$ (161);
2710 PRINT AT 11, 6; CHR$ (133); CHR$ (161);
2720 PRINT AT 12, 6; CHR$ (133); CHR$ (161);
2730 PRINT AT 13, 6; CHR$ (133); CHR$ (161);
2740 PRINT AT 14, 6; CHR$ (133); CHR$ (161);
2750 PRINT AT 15, 6; CHR$ (133); CHR$ (161);
2760 PRINT AT 16, 4; CHR$ (140); AT 16, 13; CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); CHR$ (140); INK 7; PAPER 0; "SPACE"; INK u(p, 1); CHR$ (140); INK 7; n$(p);
2770 PRINT AT 17, 10; CHR$ (138); "                     ";
2780 PRINT AT 18, 10; CHR$ (138); "                     ";
2790 PRINT AT 19, 10; CHR$ (138); "                     ";
2800 PRINT AT 20, 10; CHR$ (138); "                     ";
2810 PRINT AT 21, 10; CHR$ (138); "                     ";
2820 PRINT #1; AT 0, 10; INK u(p, 1); CHR$ (138); "                     ";
2830 PRINT #1; AT 1, 10; INK u(p, 1); CHR$ (138); "                     ";
2840 INK 4
2850 RETURN 
2860 REM draw player shields
2870 IF d(p, 8) < 1  THEN PRINT AT 10 + u(p, 5), 1 + u(p, 6); " "; AT 11 + u(p, 5), u(p, 6); "   "; AT 12 + u(p, 5), 1 + u(p, 6); " "; :RETURN 
2880 PRINT AT 10 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 4);
2890 PRINT AT 11 + u(p, 5), u(p, 6); INK u(p, 1); d(p, 7); INK 0; PAPER u(p, 1); d(p, 8); INK u(p, 1); PAPER 0; d(p, 5);
2900 PRINT AT 12 + u(p, 5), 1 + u(p, 6); INK u(p, 1); d(p, 6);
2910 RETURN 
2920 REM draw player ship
2930 LET tx = (d(p, 1) - 1) * 2
2940 LET ty = ((d(p, 2) - 1) * 2) + 8
2950 IF d(p, 8) = 0  THEN PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; :RETURN 
2960 IF d(p, 3) = 0  THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (152); CHR$ (153); AT tx + 1, ty; CHR$ (150); CHR$ (151); :RETURN 
2970 IF d(p, 3) = 1  THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (156); AT tx + 1, ty; CHR$ (150); CHR$ (157); :RETURN 
2980 IF d(p, 3) = 2  THEN PRINT AT tx, ty; INK u(p, 1); CHR$ (148); CHR$ (149); AT tx + 1, ty; CHR$ (154); CHR$ (155); :RETURN 
2990 PRINT AT tx, ty; INK u(p, 1); CHR$ (158); CHR$ (149); AT tx + 1, ty; CHR$ (159); CHR$ (151);
3000 RETURN 
3010 REM draw target explosion
3020 LET tx = (d(q, 1) - 1) * 2
3030 LET ty = ((d(q, 2) - 1) * 2) + 8
3040 PRINT AT tx, ty; INK 6; PAPER 2; FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
3050 RETURN 
3060 REM overlay and count targets
3070 LET i = 0 
3080 FOR q = 1  TO t  STEP 1
3090 IF q = p  OR d(q, 1) < 1  THEN GO TO 3170
3100 GO SUB 5280 :REM load tx, ty
3110 LET tx = tx + 4 :LET ty = ty + 3
3120 IF tx < 1  OR tx > 6  OR ty < 1  OR ty > 5  THEN GO TO 3170
3130 LET s = d(p, 3) + d(q, 3)
3140 IF s = 1  OR s = 3  OR s = 5  THEN PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (160); :GO TO 3160
3150 PRINT AT tx + 2, ty; INK u(q, 1); CHR$ (161);
3160 IF a(((tx - 1) * 5) + ty, 3) > 0  THEN LET i = i + 1
3170 NEXT q
3180 RETURN 
3190 REM redraw screen
3200 CLS 
3210 GO SUB 2390
3220 LET q = p
3230 FOR i = 1  TO t  STEP 1
3240 LET p = i
3250 IF d(p, 8) = 0  OR d(p, 1) < 1  THEN GO TO 3280
3260 GO SUB 2860
3270 GO SUB 2920
3280 NEXT i
3290 LET p = q
3300 GO SUB 3060
3310 FOR i = 1  TO 4  STEP 1
3320 LET tx = c(i, 1)
3330 LET ty = c(i, 2)
3340 PRINT AT tx, ty; INK u(i, 2); PAPER 0; CHR$ (144); CHR$ (145); AT tx + 1, ty; CHR$ (146); CHR$ (147);
3350 NEXT i
3360 RETURN 
3370 REM apply movement
3380 FOR p = 1  TO t  STEP 1
3390 IF d(p, 1) < 1  THEN GO TO 3540
3400 IF d(p, 3) = 0  THEN LET x = d(p, 1) + m(d(p, 9), 1) :LET y = d(p, 2) + m(d(p, 9), 2) :GO TO 3440
3410 IF d(p, 3) = 1  THEN LET x = d(p, 1) + m(d(p, 9), 2) :LET y = d(p, 2) - m(d(p, 9), 1) :GO TO 3440
3420 IF d(p, 3) = 2  THEN LET x = d(p, 1) - m(d(p, 9), 1) :LET y = d(p, 2) - m(d(p, 9), 2) :GO TO 3440
3430 LET x = d(p, 1) - m(d(p, 9), 2) :LET y = d(p, 2) + m(d(p, 9), 1)
3440 IF x < 1  OR x > 8  OR y < 1  OR y > 12  THEN LET x = 0 :GO TO 3460
3450 GO SUB 3560
3460 LET l(d(p, 1), d(p, 2)) = 0 :REM clear map
3470 LET tx = (d(p, 1) - 1) * 2 :LET ty = ((d(p, 2) - 1) * 2) + 8 :REM clear screen pos 1
3480 LET d(p, 1) = x :LET d(p, 2) = y :REM update player
3490 LET d(p, 3) = d(p, 3) + m(d(p, 9), 3) :REM update dir
3500 IF d(p, 3) > 3  THEN LET d(p, 3) = d(p, 3) - 4 :GO TO 3520
3510 IF d(p, 3) < 0  THEN LET d(p, 3) = d(p, 3) + 4
3520 PRINT AT tx, ty; "  "; AT tx + 1, ty; "  "; :REM clear screen pos 2
3530 IF x > 0  THEN LET l(x, y) = p :GO SUB 2920
3540 NEXT p
3550 RETURN 
3560 REM planet collision check
3570 IF l(x, y) < 5  THEN RETURN 
3580 GO SUB 2390
3590 GO SUB 3060
3600 PRINT AT 17, 11; INK 2; "<Movement>";
3610 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " ram planet! x4";
3620 LET tx = 19
3630 FOR i = 1  TO 4  STEP 1
3640 IF RND * 9 < 4  THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; :GO TO 3680
3650 IF d(p, 4) > 0  THEN LET d(p, 4) = d(p, 4) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! "; s$(1); " shields -1"; :GO TO 3680
3660 IF d(p, 8) > 1  THEN LET d(p, 8) = d(p, 8) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! Hull -1"; :GO TO 3680
3670 IF d(p, 8) = 1  THEN LET d(p, 8) = 0 :LET x = 0 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "REM! Ship destroyed!"; :LET q = p :GO SUB 3010 :GO TO 3740
3680 LET tx = tx + 1
3690 NEXT i
3700 IF d(p, 3) = 0  THEN LET x = x + 1 :GO TO 3740
3710 IF d(p, 3) = 1  THEN LET y = y - 1 :GO TO 3740
3720 IF d(p, 3) = 2  THEN LET x = x - 1 :GO TO 3740
3730 LET y = y + 1
3740 GO SUB 2860
3750 GO SUB 2370
3760 IF x > 0  THEN GO SUB 3560
3770 RETURN 
3780 REM player collision check
3790 FOR p = 1  TO t  STEP 1
3800 IF d(p, 1) < 1  THEN GO TO 4110
3810 GO SUB 2920
3820 FOR q = 1  TO t  STEP 1
3830 IF p = q  OR d(q, 1) < 1  OR d(p, 1) <>d(q, 1)  OR d(p, 2) <>d(q, 2)  THEN GO TO 4100
3840 REM collision!
3850 GO SUB 2390
3860 LET tx = 19
3870 PRINT AT 17, 11; INK 2; "<Movement>";
3880 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " ram "; INK u(q, 1); n$(q); INK 4; " x4";
3890 LET s = d(p, 3) - d(q, 3) + 6
3900 IF s > 7  THEN LET s = s - 4 :GO TO 3920
3910 IF s < 4  THEN LET s = s + 4
3920 FOR i = 1  TO 4  STEP 1
3930 IF RND * 9 < 4  THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; :GO TO 3970
3940 IF d(q, s) > 0  THEN LET d(q, s) = d(q, s) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! "; s$(s - 3); " shields -1"; :GO TO 3970
3950 IF d(q, 8) > 1  THEN LET d(q, 8) = d(q, 8) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! Hull -1"; :GO TO 3970
3960 IF d(q, 8) = 1  THEN LET d(q, 8) = 0 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "RAM! Ship destroyed!"; :GO TO 3990
3970 LET tx = tx + 1
3980 NEXT i
3990 LET tx = (d(p, 1) - 1) * 2
4000 LET ty = ((d(p, 2) - 1) * 2) + 8
4010 PRINT AT tx, ty; INK u(p, 1); PAPER u(q, 1); FLASH 1; CHR$ (139); CHR$ (135); AT tx + 1, ty; CHR$ (142); CHR$ (141);
4020 GO SUB 2370
4030 LET i = p
4040 LET p = q
4050 GO SUB 2860
4060 IF d(i, 8) = 0  THEN GO SUB 2920
4070 LET p = i
4080 IF d(q, 8) = 0  THEN GO SUB 2920
4090 IF d(p, 8) > 0  AND d(q, 8) > 0  AND p > q  THEN GO SUB 4130
4100 NEXT q
4110 NEXT p
4120 RETURN 
4130 REM move one player
4140 GO SUB 2580
4150 LET x = d(i, 1)
4160 LET y = d(i, 2)
4170 LET tx = d(i, 1) - 1 + INT (RND * 2)
4180 LET ty = d(i, 2) - 1 + INT (RND * 2)
4190 IF tx < 1  OR tx > 8  OR ty < 1  OR ty > 12  THEN GO TO 4170
4200 IF l(tx, ty) > 0  THEN GO TO 4170
4210 REM choose winner
4220 IF INT RND * 3 > 2  THEN LET i = p :LET s = q :GO TO 4250
4230 LET i = q :LET s = p
4240 REM move player and update map
4250 LET d(i, 1) = tx :LET d(i, 2) = ty :LET l(tx, ty) = i :LET l(x, y) = s
4260 PRINT AT 17, 11; INK 2; "<Movement>";
4270 PRINT AT 18, 11; INK u(s, 1); n$(s); INK 4; " moves "; INK u(i, 1); n$(i) ; INK 4; "!";
4280 LET i = p :LET p = q :GO SUB 2920 :LET p = i :GO SUB 2920
4290 RETURN 
4300 REM off map check
4310 FOR p = 1  TO t  STEP 1
4320 IF d(p, 8) < 1  OR d(p, 1) > 0  THEN GO TO 4380
4330 GO SUB 2390
4340 GO SUB 3060
4350 PRINT AT 17, 11; INK 2; "<Movement>";
4360 PRINT AT 18, 11; INK u(p, 1); n$(p) ; INK 4; " fall into the "; AT 19, 11; "void and are eaten"; AT 20, 11; "by a passing cosmic"; AT 21, 11; "horror.";
4370 LET d(p, 8) = 0 :GO SUB 2370
4380 NEXT p
4390 RETURN 
4400 REM player attack
4410 IF a(d(p, 10), 3) = 0  THEN LET s = 0 :GO TO 4860
4420 IF d(p, 3) = 0  THEN LET x = d(p, 1) + a(d(p, 10), 1) :LET y = d(p, 2) + a(d(p, 10), 2) :GO TO 4460
4430 IF d(p, 3) = 1  THEN LET x = d(p, 1) + a(d(p, 10), 2) :LET y = d(p, 2) - a(d(p, 10), 1) :GO TO 4460
4440 IF d(p, 3) = 2  THEN LET x = d(p, 1) - a(d(p, 10), 1) :LET y = d(p, 2) - a(d(p, 10), 2) :GO TO 4460
4450 LET x = d(p, 1) - a(d(p, 10), 2) :LET y = d(p, 2) + a(d(p, 10), 1) 
4460 LET s = 0
4470 PRINT AT 17, 11; INK 2; "<Combat>";
4480 FOR q = 1  TO t  STEP 1
4490 IF d(q, 1) <>x  OR d(q, 2) <>y  THEN GO TO 4850
4500 INK u(p, 1) :GO SUB 2780 :INK 4
4510 PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " attack "; INK u(q, 1); n$(q); INK 4; " x"; a(d(p, 10), 3); 
4520 PAPER u(p, 1) 
4530 LET s = p
4540 LET p = q
4550 GO SUB 2920
4560 LET q = p
4570 LET p = s
4580 PAPER 0 
4590 REM resolve shield based on relative positions and q dir
4600 LET tx = d(p, 1) - d(q, 1)
4610 LET ty = d(p, 2) - d(q, 2)
4620 IF ABS tx > ABS ty  AND tx > 0  THEN LET s = 6 :GO TO 4660
4630 IF ABS tx > ABS ty  THEN LET s = 4 :GO TO 4660
4640 IF ty > 0  THEN LET s = 5 :GO TO 4660
4650 LET s = 7
4660 LET s = s - d(q, 3)
4670 IF s > 7  THEN LET s = s - 4 :GO TO 4690
4680 IF s < 4  THEN LET s = s + 4
4690 LET tx = 19
4700 FOR i = 1  TO a(d(p, 10), 3)  STEP 1
4710 IF d(q, 8) < 1  THEN GO TO 4760
4720 IF RND * 9 < 4  THEN PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "MISS!"; :GO TO 4760
4730 IF d(q, s) > 0  THEN LET d(q, s) = d(q, s) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! "; s$(s - 3); " shields -1"; :GO TO 4760
4740 IF d(q, 8) > 1  THEN LET d(q, 8) = d(q, 8) - 1 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Hull -1"; :GO TO 4760
4750 IF d(q, 8) = 1  THEN LET d(q, 8) = 0 :PRINT #FN s(tx); AT FN x(tx), 11; INK 4; "HIT! Ship destroyed!"; :GO SUB 3010
4760 LET tx = tx + 1
4770 NEXT i
4780 REM refresh attacked ship
4790 LET i = p
4800 LET p = q
4810 GO SUB 2860
4820 GO SUB 2370
4830 GO SUB 2920
4840 LET p = i
4850 NEXT q
4860 IF s = 0  THEN PRINT AT 18, 11; INK u(p, 1); n$(p); INK 4; " do not attack.";
4870 RETURN 
4880 REM end game check
4890 LET i = 0
4900 LET q = 1
4910 FOR p = 1  TO t  STEP 1
4920 IF d(p, 1) > 0  THEN LET q = p :LET i = i + 1
4930 NEXT p 
4940 REM still at least 2 players
4950 IF i > 1  THEN RETURN 
4960 REM ends game
4970 LET t = 0
4980 REM 1st player or winner colours
4990 LET p = q
5000 GO SUB 2390
5010 PRINT AT 17, 11; INK 2; "<GAME OVER>";
5020 IF i = 0  THEN PRINT AT 18, 11; "Everybody is dead."; :GO TO 5040
5030 PRINT AT 18, 11; INK u(p, 1); "SPACE "; n$(p); INK 4; " have won.";
5040 GO SUB 2370
5050 RETURN 
5060 REM resolve AI movement
5070 LET d(p, 9) = 0
5080 FOR q = 1  TO t  STEP 1
5090 IF q = p  OR d(q, 1) < 1  THEN GO TO 5130
5100 GO SUB 5280 :REM load tx, ty
5110 LET tx = tx + 4 :LET ty = ty + 3
5120 IF tx > 0  AND tx < 7  AND ty > 0  AND ty < 6  THEN LET d(p, 9) = v(tx, ty) :RETURN 
5130 NEXT q
5140 IF ty > -11  AND ty < 0  THEN LET d(p, 9) = 1 :RETURN 
5150 IF tx > 5  AND tx < 16  THEN LET d(p, 9) = 5 :RETURN 
5160 LET d(p, 9) = 3
5170 RETURN 
5180 REM resolve AI attack
5190 LET d(p, 10) = 0
5200 FOR q = 1  TO t  STEP 1
5210 IF q = p  OR d(q, 1) < 1  THEN GO TO 5250
5220 GO SUB 5280 :REM load tx, ty
5230 LET tx = tx + 4 :LET ty = ty + 3
5240 IF tx > 0  AND tx < 7  AND ty > 0  AND ty < 6  THEN LET d(p, 10) = ((tx - 1) * 5) + ty :RETURN 
5250 NEXT q
5260 IF d(p, 10) = 0  THEN LET d(p, 10) = 19
5270 RETURN 
5280 REM load tx, ty with target relative position
5290 IF d(p, 3) = 0  THEN LET tx = d(q, 1) - d(p, 1) :LET ty = d(q, 2) - d(p, 2) :RETURN 
5300 IF d(p, 3) = 1  THEN LET tx = d(p, 2) - d(q, 2) :LET ty = d(q, 1) - d(p, 1) :RETURN 
5310 IF d(p, 3) = 2  THEN LET tx = d(p, 1) - d(q, 1) :LET ty = d(p, 2) - d(q, 2) :RETURN 
5320 LET tx = d(q, 2) - d(p, 2) :LET ty = d(p, 1) - d(q, 1)
5330 RETURN 
5340 REM attack vectors data
5350 DATA -3, -2, 4, -3, -1, 4, -3, 0, 4
5360 DATA -3, 1, 4, -3, 2, 4, -2, -2, 1
5370 DATA -2, -1, 2, -2, 0, 2, -2, 1, 2
5380 DATA -2, 2, 1, -1, -2, 1, -1, -1, 3
5390 DATA -1, 0, 1, -1, 1, 3, -1, 2, 1
5400 DATA 0, -2, 1, 0, -1, 3, 0, 0, 0
5410 DATA 0, 1, 3, 0, 2, 1, 1, -2, 1
5420 DATA 1, -1, 3, 1, 0, 0, 1, 1, 3
5430 DATA 1, 2, 1, 2, -2, 1, 2, -1, 0
5440 DATA 2, 0, 0, 2, 1, 0, 2, 2, 1
5450 REM movement vectors data
5460 DATA -2, -1, -1, -2, -1, 0, -2, 0, 0
5470 DATA -2, 1, 0, -2, 1, 1, -1, -1, -1
5480 DATA -1, -1, 0, -1, 0, 0, -1, 1, 0
5490 DATA -1, 1, 1, 0, 0, 0, 0, 0, -1
5500 DATA 0, 0, 0, 0, 0, 1, 0, 0, 0
5510 REM player UIs data
5520 DATA 1, 5, 1, 1, 0, 0
5530 DATA 2, 4, 5, 9, 3, 3
5540 DATA 3, 2, 1, 9, 0, 3
5550 DATA 6, 3, 5, 1, 3, 0
5560 REM player names data
5570 DATA "FLEET", "ELVES", "CHAOS", "HORDE"
5580 REM player data
5590 DATA 1, 1, 2, 3, 3, 3, 3, 4, 0, 0
5600 DATA 8, 12, 0, 3, 3, 3, 3, 4, 0, 0
5610 DATA 1, 12, 2, 3, 3, 3, 3, 4, 0, 0
5620 DATA 8, 1, 0, 3, 3, 3, 3, 4, 0, 0
5630 REM UDGs data
5640 DATA 0, 3, 15, 31, 63, 63, 127, 127
5650 DATA 0, 192, 240, 248, 252, 252, 254, 254 
5660 DATA 127, 127, 63, 63, 31, 15, 3, 0 
5670 DATA 254, 254, 252, 252, 248, 240, 192, 0
5680 DATA 0, 0, 0, 0, 1, 7, 7, 15
5690 DATA 0, 0, 0, 0, 128, 224, 224, 240 
5700 DATA 15, 7, 7, 1, 0, 0, 0, 0
5710 DATA 240, 224, 224, 128, 0, 0, 0, 0
5720 DATA 0, 0, 0, 5, 15, 7, 15, 7
5730 DATA 0, 0, 0, 160, 240, 224, 240, 224
5740 DATA 7, 15, 7, 15, 5, 0, 0, 0 
5750 DATA 224, 240, 224, 240, 160, 0, 0, 0 
5760 DATA 0, 0, 0, 0, 80, 248, 240, 248 
5770 DATA 248, 240, 248, 80, 0, 0, 0, 0 
5780 DATA 0, 0, 0, 0, 10, 31, 15, 31 
5790 DATA 31, 15, 31, 10, 0, 0, 0, 0 
5800 DATA 0, 0, 0, 60, 60, 0, 0, 0 
5810 DATA 0, 0, 24, 24, 24, 24, 0, 0 
5820 DATA 0, 0, 0, 0, 24, 0, 0, 0
5830 REM movement ai behaviour data
5840 DATA 1, 2, 3, 4, 5
5850 DATA 6, 7, 8, 9, 10
5860 DATA 12, 12, 14, 14, 14
5870 DATA 12, 12, 12, 14, 14
5880 DATA 12, 12, 14, 14, 14
5890 DATA 12, 12, 12, 14, 14
5900 REM shields
5910 DATA "Front", "Right", " Rear", " Left"
5920 REM helm computer instructions
5930 CLS 
5940 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE "; n$(p);"           ";
5950 PRINT AT 2, 0; "Note the direction of your ship and consult the "; INK 5; "Helm Computer"; INK 4; ".  You must select a speed A-C and a manoeuvre 1-5."
5960 PRINT AT 7, 0; "Example - A5 performs this move:"
5970 PRINT AT 9, 2; INK u(p, 1); CHR$ (148); CHR$ (156); AT 10, 2; CHR$ (150); CHR$ (157); INK 4; " Also...";
5980 PRINT AT 11, 5; "- Stay within map or die.";
5990 PRINT AT 12, 5; "- Avoid planets."
6000 PRINT AT 13, 0; INK u(p, 1); CHR$ (152); CHR$ (153); INK 4; "   - Optionally ram opponents."; AT 14, 0; INK u(p, 1); CHR$ (150); CHR$ (151);
6010 PRINT AT 16, 0; INK 5; "Helm"; AT 16, 5; "Computer";
6020 PRINT AT 17, 0; "A"; PAPER 0; CHR$ (160); CHR$ (162); INK 0; PAPER 4; CHR$ (161); CHR$ (162); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (160);
6030 PRINT AT 18, 1; " "; CHR$ (162); INK 0; PAPER 4; " "; CHR$ (162); INK 4; PAPER 0; CHR$ (162); INK 0; PAPER 4; CHR$ (162); " "; INK 4; PAPER 0; CHR$ (162); " ";
6040 PRINT AT 19, 1; " "; CHR$ (161); INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (161); " "; INK 4; PAPER 0; CHR$ (161); " ";
6050 PRINT AT 20, 0; "B"; INK 0; PAPER 4; CHR$ (160); CHR$ (162); INK 4; PAPER 0; CHR$ (161); CHR$ (162); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (162); CHR$ (161); INK 0; PAPER 4; CHR$ (162); CHR$ (160);
6060 PRINT AT 21, 1; INK 0; PAPER 4; " "; CHR$ (161); INK 4; PAPER 0; " "; CHR$ (161); INK 0; PAPER 4; CHR$ (161); INK 4; PAPER 0; CHR$ (161); " "; INK 0; PAPER 4; CHR$ (161); " ";
6070 PRINT #1; AT 0, 0; INK 4; "C   "; INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; CHR$ (161); INK 0; PAPER 4; CHR$ (160); INK 4; PAPER 0; "   ";
6080 PRINT #1; AT 1, 2; INK 4; "1 234 5 ";
6090 GO SUB 2370
6100 GO SUB 3190
6110 RETURN 
6120 REM combat display instructions
6130 CLS 
6140 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE "; n$(p);"           ";
6150 PRINT AT 2, 1; "12345  The "; INK 5; "Combat Display"; INK 4; " shows";
6160 PRINT AT 3, 0; "A"; PAPER 2; "     "; INK 2; PAPER 0; "4"; INK 4; " enemies within range and";
6170 PRINT AT 4, 0; "B"; PAPER 6; " "; PAPER 2; "   "; PAPER 6; " "; INK 2; PAPER 0; "2"; INK 4; " the A-F/1-5 combination";
6180 PRINT AT 5, 0; "C"; PAPER 6; "  "; PAPER 2; " "; PAPER 6; "  "; INK 2; PAPER 0; "1"; INK 4; " to attack. The number of";
6190 PRINT AT 6, 0; "D"; PAPER 6; "  "; INK u(p, 1); PAPER 0; CHR$ (161); AT 6, 4; PAPER 6; "  "; INK 4; PAPER 0; "  attacks correspond to";
6200 PRINT AT 7, 0; "E"; PAPER 6; "  "; PAPER 0; " "; PAPER 6; "  "; INK 4; PAPER 0; "  the "; INK 2; "red "; INK 4; "and "; INK 6; "yellow";
6210 PRINT AT 8, 0; "F"; PAPER 6; " "; PAPER 0; "   "; PAPER 6; " "; INK 4; PAPER 0; "  numbers.";
6220 PRINT AT 9, 4; INK 6; "31";
6230 PRINT AT 11, 8; "A player has 4 shields";
6240 PRINT AT 12, 8; "and a hull. The "; INK 5; "Combat ";
6250 PRINT AT 13, 8; INK 5; "Display"; INK 4; " can be used to";
6260 PRINT AT 14, 8; "see which shield will be";
6270 PRINT AT 15, 8; "hit.";
6280 PRINT AT 17, 0; "The hull is damaged if there areno shields on the attacked side.When the hull reaches 0 the shipis destroyed.";
6290 GO SUB 2860
6300 GO SUB 3060
6310 GO SUB 2370
6320 GO SUB 3190
6330 RETURN 
6340 REM about SPACE FLEET
6350 CLS 
6360 PRINT AT 0, 0; INK 0; PAPER 5; "          SPACE FLEET           ";
6370 PRINT AT 1, 0; "       ";
6380 PRINT AT 2, 0; "In the grim darkness of the far future, there is only war.";
6390 PRINT AT 5, 0; "Select 2-4 human or AI players, and do turn-based battle using  the "; INK 5; "<Helm Computer>"; INK 4; " for movementand "; INK 5; "<Combat Display>"; INK 4; " to attack.";
6400 PRINT AT 10, 0; "Each are accessed via a console,through which further help is   available by entering [i]."
6410 PRINT AT 14, 0; INK 6; "Press any key to begin."
6420 PRINT #1; AT 0, 0; INK 1; CHR$ (152); CHR$ (153);
6430 PRINT #1; AT 0, 3; INK 2; CHR$ (148); CHR$ (156);
6440 PRINT #1; AT 0, 6; INK 3; CHR$ (148); CHR$ (149);
6450 PRINT #1; AT 0, 9; INK 6; CHR$ (158); CHR$ (149);
6460 PRINT #1; AT 0, 12; INK 5; CHR$ (144); CHR$ (145);
6470 PRINT #1; AT 0, 15; INK 4; CHR$ (144); CHR$ (145);
6480 PRINT #1; AT 0, 18; INK 2; CHR$ (144); CHR$ (145);
6490 PRINT #1; AT 0, 21; INK 3; CHR$ (144); CHR$ (145);
6500 PRINT #1; AT 1, 0; INK 1; CHR$ (150); CHR$ (151);
6510 PRINT #1; AT 1, 3; INK 2; CHR$ (150); CHR$ (157);
6520 PRINT #1; AT 1, 6; INK 3; CHR$ (154); CHR$ (155);
6530 PRINT #1; AT 1, 9; INK 6; CHR$ (159); CHR$ (151);
6540 PRINT #1; AT 1, 12; INK 5; CHR$ (146); CHR$ (147);
6550 PRINT #1; AT 1, 15; INK 4; CHR$ (146); CHR$ (147);
6560 PRINT #1; AT 1, 18; INK 2; CHR$ (146); CHR$ (147);
6570 PRINT #1; AT 1, 21; INK 3; CHR$ (146); CHR$ (147);
6580 PAUSE 0
6590 CLS 
6600 RETURN 