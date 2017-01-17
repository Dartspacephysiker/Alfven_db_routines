;;11/24/16
;;The text file with your info:
;;/Research/Satellites/FAST/espec_identification/txt_log_etc/Blacklisted_orbits.txt
FUNCTION TRASH_BAD_FAST_ORBITS,dbStruct,good_i, $
                               DBTIMES=DBTimes, $
                               CUSTOM_ORBS_TO_KILL=customKill, $
                               CUSTOM_ORBRANGES_TO_KILL=customKillRanges, $
                               CUSTOM_TSTRINGS_TO_KILL=customTKillStrings, $
                               CUSTOM_TRANGES_TO_KILL=customTKillRanges

  COMPILE_OPT IDL2

  PRINT,"Trashing terrible orbits"
  nGStart = N_ELEMENTS(good_i)
  nBTot   = 0

  IF KEYWORD_SET(customKill) THEN BEGIN
     individual_blackballOrbs = customKill
     blackballOrb_ranges      = N_ELEMENTS(customKillRanges) GT 0 ? customKillRanges : !NULL
  ENDIF ELSE BEGIN
     
     ;;Mayhem posse
     blackballOrb_ranges      = [[1031,1054]] ;;Original
     blackballOrb_ranges      = [[1028,1055]] ;;After round two in JOURNAL__20161124__POKE_AROUND_SOME_OF_THESE_DAYSIDE_ORBITS_WHERE_BROADBAND_FLUXES_ARE_CRAZY_HUGE, I realized more need to go
     blackballOrb_ranges      = [[1028,1055],[1443,1444],[1465,1466],[1477,1478],[1487,1488],[1496,1499], $
                                 [1506,1522],[7804,7837],[11985,12001]] ;Resulting from Round 3

     blackballOrb_ranges      = [[1028,1056],[1443,1444],[1465,1466],[1477,1478],[1487,1488],[1496,1499], $
                                 [1506,1522],[1533,1534],[1556,1557],[1564,1565],[1788,1789],[2681,2682], $
                                 [3091,3092],[4247,4248],[7804,7837],[11985,12001]] ;Resulting from Round 3

     blackballOrb_ranges      = [[1028,1056],[1443,1444],[1465,1466],[1477,1478],[1487,1488],[1496,1499], $
                                 [1506,1522],[1533,1534],[1556,1557],[1564,1565],[1788,1789],[2681,2682], $
                                 [3091,3092],[4247,4248]] ;Resulting from Round 4, 2017/01/17
                                ;Removed 7804-7837 and 11985-12001, since I corrected these by hånd

     ;;And individual rogues
     individual_blackballOrbs = [1002,3461,7822,7836,7891,7925] 
     individual_blackballOrbs = [1002,3461,7822,7836,7891,7925,8756] ;Round 3 resultant

     ;; individual_blackballOrbs = [749, $
     ;;                             1002,1179,1200,1543,1733,1775,1879,1915,1947,2660,2793,2985, $
     ;;                             3015,3025,3054,3059,3123,3135,3296,3345,3360,3372,3461,3489,3680,3868, $
     ;;                             4149,4204,4226,4480,4497,4603,4632,4641,4678,4962, $
     ;;                             5154,5243,5390,5476,5494,5585,5608,5636,5771,5837, $
     ;;                             6232, $
     ;;                             7012,7683,7744,7758,7836,7857,7891,7925,7926, $
     ;;                             8162,8540,8756,8768, $
     ;;                             9401,9406,9596,9830,9980,9990, $
     ;;                             10014,10072,10080,10083,10094,10131,10314, $
     ;;                             12278,12297,12471, $
     ;;                             13214,13785, $
     ;;                             14297] ;Round 4 resultant

     ;;1002: TOTAL LOSS (nothing even close to sensible, all red
     ;;1179: Bunch of little screwups throughout the survey ESA data
     ;;1543 Can be salvaged, I'm too lazy
     individual_blackballOrbs = [749, $
                                 1002,1543,1733,1775,1879,1915,1947,2660,2793,2985, $
                                 3015,3025,3054,3059,3123,3135,3296,3345,3360,3372,3461,3489,3680,3868, $
                                 4149,4204,4226,4480,4497,4603,4632,4641,4678,4962, $
                                 5154,5243,5390,5476,5494,5585,5608,5636,5771,5837, $
                                 6232, $
                                 7012,7683,7744,7758,7836,7857,7891,7925,7926, $
                                 8162,8540,8756,8768, $
                                 9401,9406,9596,9830,9980,9990, $
                                 10014,10072,10080,10083,10094,10131,10314, $
                                 12278,12297,12471, $
                                 13214,13785, $
                                 14297] ;Round 5 resultant, 2017/01/17

     ;; customTKillStrings = [ $
     ;;                      ['1996-12-08/' + ['08:44:20','08:46:10']], $
     ;;                      ['1999-02-17/' + ['20:58:30','20:59:30']], $ ;orb 9860 badness
     ;;                      ['1997-12-30/' + ['05:53:40','05:54:00']], $ ;orb 5363 badness
     ;;                      ['1998-11-13/' + ['02:54:32','02:54:35']]  $ ;orb 8809 badness 
     ;;                      ]

     ;;Round 4 resultant
     customTKillStrings = [ $
                          ['1996-12-08/' + ['08:44:20','08:46:10']], $
                          ['1996-12-08/' + ['10:40:10','10:41:14']], $ ;orb 1197 badness (some good in between, but too lazy)
                          ['1996-12-08/' + ['10:44:19','10:44:40']], $ ;orb 1197 badness (some good in between, but too lazy)
                          ['1996-12-08/' + ['10:46:03','10:46:11']], $ ;orb 1197 badness (some good in between, but too lazy)
                          ['1996-12-08/' + ['10:53:40','10:53:49']], $ ;orb 1197 badness (some good in between, but too lazy)
                          ['1996-12-08/' + ['10:54:47','10:54:54']], $ ;orb 1197 badness (some good in between, but too lazy)
                          ['1996-12-08/' + ['10:59:07','10:59:16']], $ ;orb 1197 badness (some good in between, but too lazy)
                          ['1996-12-10/' + ['09:16:53','09:19:05']], $ ;orb 1200 badness (but good burst data)
                          ['1996-12-10/' + ['09:30:58','09:31:07']], $ ;orb 1200 badness (but good burst data)
                          ['1996-12-10/' + ['09:37:31','09:37:39']], $ ;orb 1200 badness (but good burst data)
                          ['1997-01-11/' + ['02:37:08','02:41:41']], $ ;orb 1543 badness
                          ['1997-01-11/' + ['02:47:03','02:47:11']], $ ;orb 1543 badness
                          ['1997-01-11/' + ['02:49:22','02:49:35']], $ ;orb 1543 badness
                          ['1997-12-30/' + ['05:53:40','05:54:00']], $ ;orb 5363 badness
                          ['1998-08-12/' + ['12:00:18','12:01:42']], $ ;orb 7804 badness (but good burst data)
                          ['1998-08-12/' + ['18:29:15','18:30:55']], $ ;orb 7807 badness (but good burst data)
                          ['1998-08-13/' + ['10:00:05','10:01:35']], $ ;orb 7814 badness (but good burst data)
                          ['1998-08-13/' + ['12:15:50','12:17:18']], $ ;orb 7815 badness (but good burst data)
                          ['1998-08-13/' + ['14:28:48','14:30:14']], $ ;orb 7816 badness (but good burst data)
                          ['1998-08-13/' + ['16:46:32','16:49:03']], $ ;orb 7817 badness (no good burst data, apparently)
                          ['1998-08-13/' + ['18:57:40','18:59:36']], $ ;orb 7818 badness (but good burst data)
                          ['1998-08-13/' + ['20:54:11','20:56:17']], $ ;orb 7819 badness (and BAD burst data)
                          ['1998-08-13/' + ['21:08:13','21:10:17']], $ ;orb 7819 badness (and no burst data)
                          ['1998-08-13/' + ['23:06:53','23:07:37']], $ ;orb 7820 badness (and possibly good burst data)
                          ['1998-08-13/' + ['23:18:29','23:19:59']], $ ;orb 7820 badness (and good burst data)
                          ['1998-08-14/' + ['01:29:53','01:31:19']], $ ;orb 7821 badness (and seemingly good burst data)
                          ['1998-08-14/' + ['01:29:53','01:31:19']], $ ;orb 7821 badness (and seemingly good burst data)
                          ['1998-08-14/' + ['03:38:08','03:42:58']], $ ;orb 7822 badness (and no burst data)
                          ['1998-08-14/' + ['05:58:14','05:59:40']], $ ;orb 7823 badness (and good burst data)
                          ['1998-08-14/' + ['06:16:44','06:18:11']], $ ;orb 7823 badness (and no burst data)
                          ['1998-08-14/' + ['08:29:32','08:31:00']], $ ;orb 7824 badness (and no burst data)
                          ['1998-08-14/' + ['10:39:17','10:41:03']], $ ;orb 7825 badness (and possibly good burst data)
                          ['1998-08-14/' + ['12:45:29','12:49:33']], $ ;orb 7826 badness (and possibly good burst data)
                          ['1998-08-14/' + ['14:55:20','15:00:08']], $ ;orb 7827 badness (and some good burst data)
                          ['1998-08-14/' + ['16:59:57','17:01:25']], $ ;orb 7828 badness (and some good burst data)
                          ['1998-08-14/' + ['19:13:17','19:23:26']], $ ;orb 7829 badness (and some good burst data)
                          ['1998-08-14/' + ['21:38:07','21:39:35']], $ ;orb 7830 badness (and some good burst data)
                          ['1998-08-14/' + ['22:44:13','22:45:41']], $ ;orb 7831 badness (and some good burst data)
                          ['1998-08-15/' + ['01:52:23','01:53:49']], $ ;orb 7832 badness (and no burst data)
                          ['1998-08-15/' + ['01:52:23','01:53:49']], $ ;orb 7832 badness (and no burst data)
                          ['1998-08-15/' + ['06:33:45','06:35:16']], $ ;orb 7834 badness (and no burst data)
                          ['1998-08-15/' + ['08:50:21','08:51:48']], $ ;orb 7835 badness (and no burst data)
                          ['1998-08-15/' + ['11:03:54','11:05:22']], $ ;orb 7836 badness (and no burst data)
                          ['1998-08-15/' + ['13:10:48','13:12:18']], $ ;orb 7837 badness (and no burst data)
                          ['1998-11-13/' + ['02:54:32','02:54:35']], $ ;orb 8809 badness 
                          ['1999-02-17/' + ['20:58:30','20:59:30']], $ ;orb 9860 badness
                          ['1999-09-01/' + ['06:59:11','07:01:35']], $ ;orb 11985 badness
                          ['1999-09-01/' + ['07:51:15','07:55:11']], $ ;orb 11986 badness
                          ['1999-09-01/' + ['09:48:43','09:58:09']], $ ;orb 11987 badness
                          ['1999-09-01/' + ['11:28:46','11:30:02']], $ ;orb 11987 badness (and possibly good burst data)
                          ['1999-09-01/' + ['13:22:52','13:26:52']], $ ;orb 11988 badness (and no burst data)
                          ['1999-09-01/' + ['13:22:52','13:26:52']], $ ;orb 11988 badness (and no burst data)
                          ['1999-09-01/' + ['14:27:53','14:29:08']], $ ;orb 11989 badness (and no burst data)
                          ['1999-09-01/' + ['18:03:40','18:04:27']], $ ;orb 11990 badness (and no burst data)
                          ['1999-09-01/' + ['18:41:52','18:43:24']], $ ;orb 11991 badness (and no burst data)
                          ['1999-09-01/' + ['20:07:28','20:08:44']], $ ;orb 11991 badness (and no burst data)
                          ['1999-09-01/' + ['21:03:54','21:05:23']], $ ;orb 11992 badness (and no burst data)
                          ['1999-09-01/' + ['22:21:59','22:23:14']], $ ;orb 11992 badness (and no burst data)
                          ['1999-09-01/' + ['23:18:55','23:23:40']], $ ;orb 11993 badness (and no burst data)
                          ['1999-09-02/' + ['00:39:48','00:41:03']], $ ;orb 11993 badness (and no burst data)
                          ['1999-09-02/' + ['02:41:54','02:43:42']], $ ;orb 11994 badness (and no burst data)
                          ['1999-09-02/' + ['02:41:54','02:43:42']], $ ;orb 11994 badness (and no burst data)
                          ['1999-09-02/' + ['04:45:12','04:48:10']], $ ;orb 11995 badness (and no burst data)
                          ['1999-09-02/' + ['05:50:57','05:52:12']], $ ;orb 11996 badness
                          ['1999-09-02/' + ['07:18:00','07:18:55']], $ ;orb 11996 badness
                          ['1999-09-02/' + ['07:48:35','07:50:00']], $ ;orb 11997 badness
                          ['1999-09-02/' + ['09:13:48','09:15:04']], $ ;orb 11997 badness
                          ['1999-09-02/' + ['12:12:14','12:32:29']], $ ;orb 11999 badness
                          ['1999-09-02/' + ['14:30:48','14:32:04']], $ ;orb 12000 badness
                          ['1999-09-02/' + ['15:59:20','16:09:35']]  $ ;orb 12000 badness (good burst data)
                          ]



  ENDELSE

  IF N_ELEMENTS(blackballOrb_ranges) GT 0 THEN BEGIN
     FOR k=0,N_ELEMENTS(blackballOrb_ranges[0,*])-1 DO BEGIN
        opener = STRING(FORMAT='("Blacked orbits ",I0,"–",I0,T30," : ")',blackballOrb_ranges[0,k],blackballOrb_ranges[1,k])

        blackBall_ii = WHERE(dbStruct.orbit[good_i] GE blackballOrb_ranges[0,k] AND dbStruct.orbit[good_i] LE blackballOrb_ranges[1,k], $
                             nBlackBall, $
                             COMPLEMENT=keeper_ii, $
                             NCOMPLEMENT=nKeeper)

        IF nBlackBall GT 0 THEN BEGIN
           nGood   = N_ELEMENTS(good_i)
           nBTot  += nBlackBall

           good_i  = good_i[keeper_ii]
           ;; good_i  = CGSETDIFFERENCE(good_i,blackBall_i,NORESULT=-1,COUNT=count)
           IF good_i[0] EQ -1 THEN BEGIN
              PRINT,opener+"We've killed every orbit!"
              broken = 1
              BREAK
           ENDIF
           PRINT,opener+'Junked ' + STRCOMPRESS(nGood-nKeeper,/REMOVE_ALL) + ' blackballed events ...'
        ENDIF ELSE BEGIN
           PRINT,opener+"No baddies found in this case ..."
        ENDELSE
     ENDFOR

     IF KEYWORD_SET(broken) THEN STOP

  ENDIF

  FOR k=0,N_ELEMENTS(individual_blackballOrbs)-1 DO BEGIN
     opener = STRING(FORMAT='("Blackball orbit ",I0,T30," : ")',individual_blackballOrbs[k])

     ;; blackBall_i = WHERE(dbStruct.orbit EQ individual_blackballOrbs[k],nBlackBall)
     blackBall_ii = WHERE(dbStruct.orbit[good_i] EQ individual_blackballOrbs[k],nBlackBall, $
                          COMPLEMENT=keeper_ii, $
                          NCOMPLEMENT=nKeeper)

     IF nBlackBall GT 0 THEN BEGIN
        nGood   = N_ELEMENTS(good_i)
        nBTot  += nBlackBall

        ;; good_i  = CGSETDIFFERENCE(good_i,blackBall_i,NORESULT=-1,COUNT=count)
        good_i  = good_i[keeper_ii]
        IF good_i[0] EQ -1 THEN BEGIN
           PRINT,opener+"We've killed every orbit!"
           broken = 1
           BREAK
        ENDIF
        PRINT,opener+'Junked ' + STRCOMPRESS(nGood-nKeeper,/REMOVE_ALL) + ' blackballed events ...'
     ENDIF ELSE BEGIN
        PRINT,opener+"No baddies found in this case ..."
     ENDELSE
  ENDFOR  

  IF KEYWORD_SET(broken) THEN STOP

  PRINT,"Junked " + STRCOMPRESS(nBTot,/REMOVE_ALL) + " events associated with blackballed orbits"

  IF (KEYWORD_SET(customTKillRanges) OR KEYWORD_SET(customTKillStrings)) AND (KEYWORD_SET(DBTimes) OR TAG_EXIST(DBStruct,'x')) THEN BEGIN

     use_x = TAG_EXIST(dbStruct,'x')

     IF N_ELEMENTS(customTKillRanges) GT 0 THEN BEGIN
        customTimes = customTKillRanges
     ENDIF ELSE BEGIN
        customTimes = !NULL
     ENDELSE

     IF N_ELEMENTS(customTKillStrings) GT 0 THEN BEGIN
        tmpTimes    = REFORM(STR_TO_TIME(customTKillStrings), $
                             SIZE(customTKillStrings,/DIMENSIONS))
        customTimes = [customTimes,TEMPORARY(tmpTimes)]
     ENDIF ELSE BEGIN
        customTimes = !NULL
     ENDELSE

     FOR k=0,N_ELEMENTS(customTimes[0,*])-1 DO BEGIN

        opener       = STRING(FORMAT='("Blackball tRange ",A-23,"-",A-23," : ")', $
                              TIME_TO_STR(customTimes[0,k],/MS), $
                              TIME_TO_STR(customTimes[1,k],/MS))

        blackBall_ii = WHERE(((use_x ? DBStruct.x : DBTimes)[good_i] GE customTimes[0,k]) AND $
                             ((use_x ? DBStruct.x : DBTimes)[good_i] LE customTimes[1,k]), $
                             nBlackBall, $
                             COMPLEMENT=keeper_ii, $
                             NCOMPLEMENT=nKeeper)

        IF nBlackBall GT 0 THEN BEGIN
           nGood     = N_ELEMENTS(good_i)
           nBTot    += nBlackBall

           good_i    = good_i[keeper_ii]
           IF good_i[0] EQ -1 THEN BEGIN
              PRINT,opener+"We've killed everything!"
              broken = 1
              BREAK
           ENDIF
           PRINT,opener+'Junked ' + STRCOMPRESS(nGood-nKeeper,/REMOVE_ALL) + ' blackballed events ...'
        ENDIF ELSE BEGIN
           PRINT,opener+"No baddies found in this case ..."
        ENDELSE
        
     ENDFOR
  ENDIF

  IF KEYWORD_SET(broken) THEN STOP

  RETURN,good_i
END
