;;11/24/16
;;The text file with your info:
;;/Research/Satellites/FAST/espec_identification/txt_log_etc/Blacklisted_orbits.txt
FUNCTION TRASH_BAD_FAST_ORBITS,dbStruct,good_i, $
                               DBTIMES=DBTimes, $
                               CUSTOM_ORBS_TO_KILL=customKill, $
                               CUSTOM_ORBRANGES_TO_KILL=customKillRanges, $
                               CUSTOM_TSTRINGS_TO_KILL=customTKillStrings, $
                               CUSTOM_TRANGES_TO_KILL=customTKillRanges, $
                               REMAKE_TRASHORB_FILES=remake_trashOrb_files, $
                               KEEP_ON_TAP=keep_on_tap

  COMPILE_OPT IDL2,STRICTARRSUBS

  COMMON ORBTRASHER,notTrash_i

  dirForAlle = '/SPENCEdata/Research/database/temps/'

  PRINT,"Trashing terrible orbits"
  nGStart = N_ELEMENTS(good_i)
  nBTot   = 0

  needToRecalc = 1
  IF KEYWORD_SET(keep_on_tap) THEN BEGIN
     IF N_ELEMENTS(notTrash_i) EQ 0 THEN BEGIN

        notTrash_i   = LINDGEN(N_ELEMENTS(dbStruct.orbit))

     ENDIF ELSE BEGIN

        PRINT,"Using on-tap notTrash_i to junk bad orbit stuff ..."
        nGood  = N_ELEMENTS(good_i)
        good_i = CGSETINTERSECTION(good_i,notTrash_i,COUNT=nKeeper)

        PRINT,'Junked ' + STRCOMPRESS(nGood-nKeeper,/REMOVE_ALL) + ' blackballers ...'

        needToRecalc = 0

     ENDELSE

  ENDIF ELSE needToRecalc = 1

  IF needToRecalc THEN BEGIN

  ;; remake_trashOrb_files       = N_ELEMENTS(remake_trashOrb_files) GT 0 ? remake_trashOrb_files : 1

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

     ;; blackballOrb_ranges      = [[1028,1056],[1443,1444],[1465,1466],[1477,1478],[1487,1488],[1496,1499], $
     ;;                             [1506,1522],[1533,1534],[1556,1557],[1564,1565],[1788,1789],[2681,2682], $
     ;;                             [3091,3092],[4247,4248]] ;Resulting from Round 4, 2017/01/17
                                ;Removed 7804-7837 and 11985-12001, since I corrected these by hånd

     blackballOrb_ranges      = [ $
                                [744,751], $ ;2017/01/21 These orbits are piping-hot garbage. They are red-hot, featureless wastes of disk space
                                [753,756], $ ;2017/01/21 These orbits are piping-hot garbage. They are red-hot, featureless wastes of disk space
                                [1031,1035], $
                                [1038,1040], $
                                [1042,1045], $
                                [1053,1056], $
                                [1465,1466], $
                                [1477,1478], $
                                [1487,1488], $
                                [1496,1499], $
                                [1506,1522], $
                                [1533,1534], $
                                [1556,1557], $
                                [1564,1565], $
                                [1788,1789], $
                                [2681,2682], $
                                [3091,3092], $
                                [4247,4248], $
                               [17193,17195]] ;Resulting from Round 4, 2017/01/17, and Round 5, 2017/01/21
                                ;Re-added several from 1028-1056 range based on this new
                                ;JOURNAL__20170120__PLOT_JE_JEE_CHARE_WITH_GAPS_REMOVED that shows it all
                                ;Not sure why I can't pull EESA data for orbs 17193–17195, since I was evidently able to at one point.
                                ;The issue is that 17193–17195 are present in the eSpec DB, but I can't get ephemeris data for them
                             


     ;;And individual rogues
     ;; individual_blackballOrbs = [1002,3461,7822,7836,7891,7925] 
     ;; individual_blackballOrbs = [1002,3461,7822,7836,7891,7925,8756] ;Round 3 resultant

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
     individual_blackballOrbs = [ $
                                 ;; 592, $ ;2017/01/21 Give the boy a try
                                 ;; 651, $ ;2017/01/21 Give the boy a try
                                 ;; 665, $ ;2017/01/21 Give the boy a try
                                1002, $ ;2017/01/21 It is actually trash, nothing but red-hot noise
                                ;; 1543, $ ;2017/01/21 Give the boy a try
                                ;; 1733, $ ;2017/01/21 Give the boy a try
                                ;; 1775, $ ;2017/01/21 Give the boy a try
                                ;; 1879, $ ;2017/01/21 Give the boy a try
                                ;; 1915, $ ;2017/01/21 Give the boy a try
                                ;; 1947, $ ;2017/01/21 Give the boy a try
                                ;; 2660, $ ;2017/01/21 Give the boy a try
                                ;; 2793, $ ;2017/01/21 SUSPICIOUS, but give the boy a try
                                ;; 2985, $ ;2017/01/21 Give the boy a try
                                ;; 1327, $ ;2017/01/21 Give the boy a try
                                ;; 1392, $ ;2017/01/21 Give the boy a try
                                ;; 1470, $ ;2017/01/21 Give the boy a try
                                1533, $ ;2017/01/21 Could be salvaged, but kind of a mess
                                1534, $ ;2017/01/21 Could be salvaged, but kind of a mess
                                1544, $ ;2017/01/21 A crap orbit--the whole thing
                                ;; 1710, $ ;2017/01/21 Give the boy a try
                                ;; 1788, $ ;2017/01/21 Give the boy a try
                                ;; 1789, $ ;2017/01/21 Give the boy a try
                                ;; 2713, $ ;2017/01/21 Give the boy a try
                                ;; 3482, $ ;2017/01/21 A real troublemaker, but I'm salvaging
                                ;; 3557, $ ;2017/01/21 A real troublemaker, but I'm salvaging
                                ;; 3591, $ ;2017/01/21 A real troublemaker, but I'm salvaging
                                ;; 3623, $ ;2017/01/21 Give the boy a try
                                ;; 3737, $ ;2017/01/21 Give the boy a try
                                ;; 3769, $ ;BONUS FROM JOURNAL__20170117__EXPLORE_TSERIES_FOR_BAD_ORBITS__AUTOMATE_BADDY_IDENTIFICATION
                                ;; 3015, $ ;2017/01/21 It is a crazy orbit, but the data look real
                                ;; 3025, $
                                ;; 3054, $ ;2017/01/21 A real troublemaker, but I'm salvaging
                                ;; 3059, $ ;2017/01/21 Give the boy a try
                                ;; 3123, $ ;2017/01/21 A real troublemaker, but I'm salvaging
                                ;; 3135, $ ;2017/01/21 Give the boy a try
                                3296,3345,3360,3372,3461,3489,3680,3868, $
                                4258, $ ;BONUS FROM JOURNAL__20170117__EXPLORE_TSERIES_FOR_BAD_ORBITS__AUTOMATE_BADDY_IDENTIFICATION
                                4149,4204,4226,4480,4497,4603,4632,4641,4678,4962, $
                                5073, $ ;BONUS FROM JOURNAL__20170117__EXPLORE_TSERIES_FOR_BAD_ORBITS__AUTOMATE_BADDY_IDENTIFICATION
                                 5154,5243,5390,5476,5494,5585,5608,5636,5771,5837, $
                                ;; 6126, $ ;2017/01/21 Give the boy a try
                                ;; 6127, $ ;2017/01/21 Give the boy a try
                                6232, $
                                7684,7783,7894, $ ;BONUS FROM JOURNAL__20170117__EXPLORE_TSERIES_FOR_BAD_ORBITS__AUTOMATE_BADDY_IDENTIFICATION
                                7012,7683,7744,7758,7857,7891,7925,7926, $
                                8334,8414,8538,8556, $ ;BONUS FROM JOURNAL__20170117__EXPLORE_TSERIES_FOR_BAD_ORBITS__AUTOMATE_BADDY_IDENTIFICATION
                                8162,8540,8756,8768, $
                                9555,9596, $ ;BONUS FROM JOURNAL__20170117__EXPLORE_TSERIES_FOR_BAD_ORBITS__AUTOMATE_BADDY_IDENTIFICATION
                                9401,9406,9596,9830,9980,9990, $
                                10014,10072,10080,10083,10094,10131,10314, $
                                10118,10131,10314,10636, $ ;BONUS FROM JOURNAL__20170117__EXPLORE_TSERIES_FOR_BAD_ORBITS__AUTOMATE_BADDY_IDENTIFICATION
                                11563, $                   ;BONUS FROM JOURNAL__20170117__EXPLORE_TSERIES_FOR_BAD_ORBITS__AUTOMATE_BADDY_IDENTIFICATION
                                12350,12539,12746, $       ;BONUS FROM JOURNAL__20170117__EXPLORE_TSERIES_FOR_BAD_ORBITS__AUTOMATE_BADDY_IDENTIFICATION
                                 ;; 12471, $ ;2017/01/21 Give the boy a try
                                 ;; 13214,13785, $ ;2017/01/21 Give the boy a try
                                 ;; 14076,14732,14867, $ ;2017/01/21 Give the boy a try
                                 ;; 14297, $
                                15054,15463 $ ;BONUS FROM JOURNAL__20170117__EXPLORE_TSERIES_FOR_BAD_ORBITS__AUTOMATE_BADDY_IDENTIFICATION
                                ]                     ;Round 5 resultant, 2017/01/17



     ;; customTKillStrings = [ $
     ;;                      ['1996-12-08/' + ['08:44:20','08:46:10']], $
     ;;                      ['1999-02-17/' + ['20:58:30','20:59:30']], $ ;orb 9860 badness
     ;;                      ['1997-12-30/' + ['05:53:40','05:54:00']], $ ;orb 5363 badness
     ;;                      ['1998-11-13/' + ['02:54:32','02:54:35']]  $ ;orb 8809 badness 
     ;;                      ]

     ;;Round 4 resultant
     customTKillStrings = [ $
                          ['1996-12-08/' + ['01:52:20','01:52:40']], $ ;orb 1175 REAL badness (not picked up by transitions) 2017/01/21 
                          ['1996-12-08/' + ['08:44:20','08:46:10']], $ ;orb 1178 badness?
                          ['1996-12-08/' + ['10:40:10','10:41:14']], $ ;orb 1197 badness (some good in between, but too lazy)
                          ['1996-12-08/' + ['10:44:19','10:44:40']], $ ;orb 1197 badness (some good in between, but too lazy)
                          ['1996-12-08/' + ['10:46:03','10:46:11']], $ ;orb 1197 badness (some good in between, but too lazy)
                          ['1996-12-08/' + ['10:53:40','10:53:49']], $ ;orb 1197 badness (some good in between, but too lazy)
                          ['1996-12-08/' + ['10:54:47','10:54:54']], $ ;orb 1197 badness (some good in between, but too lazy)
                          ['1996-12-08/' + ['10:59:07','10:59:16']], $ ;orb 1197 badness (some good in between, but too lazy)
                          ['1996-12-10/' + ['09:16:53','09:19:05']], $ ;orb 1200 badness (but good burst data)
                          ['1996-12-10/' + ['09:30:58','09:31:07']], $ ;orb 1200 badness (but good burst data)
                          ['1996-12-10/' + ['09:37:31','09:37:39']], $ ;orb 1200 badness (but good burst data)
                          ['1997-01-01/' + ['21:00:00','21:12:30']], $ ;orb 1443 REAL badness (not picked up by transitions) 2017/01/21 
                          ['1997-01-01/' + ['23:14:00','23:21:00']], $ ;orb 1444 REAL badness (not picked up by transitions) 2017/01/21 
                          ['1997-01-11/' + ['02:37:08','02:41:41']], $ ;orb 1543 badness
                          ['1997-01-11/' + ['02:47:03','02:47:11']], $ ;orb 1543 badness
                          ['1997-01-11/' + ['02:49:22','02:49:35']], $ ;orb 1543 badness
                          ['1997-05-28/' + ['04:00:00','04:06:00']], $ ;orb 3025 REAL badness (not picked up by transitions) 2017/01/21 
                          ['1997-05-30/' + ['20:12:07','20:12:13']], $ ;orb 3054 REAL badness (not picked up by transitions) 2017/01/21 
                          ['1997-06-06/' + ['05:21:22','05:21:30']], $ ;orb 3123 REAL badness (not picked up by transitions) 2017/01/21 
                          ['1997-06-06/' + ['14:08:58','14:09:07']], $ ;orb 3127 badness: weird jitters while changing samp rate (no burst data)
                          ['1997-07-07/' + ['21:25:27','21:25:31']], $ ;orb 3465 badness
                          ['1997-07-09/' + ['09:53:40','09:53:45']], $ ;orb 3482 REAL badness not picked up by trans 2017/01/21
                          ['1997-07-09/' + ['09:54:08','09:54:15']], $ ;orb 3482 REAL badness not picked up by trans 2017/01/21
                          ['1997-07-16/' + ['08:23:30','08:23:39']], $ ;orb 3557 REAL badness not picked up by trans 2017/01/21
                          ['1997-07-19/' + ['11:38:08','11:38:14']], $ ;orb 3591 REAL badness not picked up by trans 2017/01/21
                          ['1997-08-04/' + ['22:54:18','22:54:28']], $ ;orb 3769 REAL badness not picked up by trans 2017/01/21
                          ['1997-08-11/' + ['07:45:48','07:52:51']], $ ;orb 3838:The spectrum is good, but the energies are way wrong! (but good burst data) 2017/01/21
                          ['1997-12-30/' + ['05:53:40','05:54:00']], $ ;orb 5363 badness
                          ['1998-01-30/' + ['12:00:56','12:01:07']], $ ;orb 5701 REAL badness not picked up by trans 2017/01/21
                          ['1998-05-05/' + ['13:51:21','13:51:30']], $ ;orb 6731 REAL badness not picked up by trans 2017/01/21
                          ['1998-08-06/' + ['05:36:28','05:38:20']], $ ;orb 7736 REAL badness not picked up by trans 2017/01/21
                          ['1998-08-06/' + ['18:52:23','18:52:32']], $ ;orb 7742 badness
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
                          ['1998-09-29/' + ['06:15:12','06:15:28']], $ ;orb 8322 REAL badness not picked up by transtimes 2017/01/21
                          ['1998-09-29/' + ['06:21:50','06:23:50']], $ ;orb 8322 REAL badness not picked up by transtimes 2017/01/21
                          ['1998-11-13/' + ['02:54:32','02:54:35']], $ ;orb 8809 badness 
                          ['1999-01-23/' + ['14:49:43','14:49:49']], $ ;orb 9585 REAL badness not picked up by transtimes 2017/01/21
                          ['1999-01-23/' + ['14:53:45','14:53:55']], $ ;orb 9585 REAL badness not picked up by transtimes 2017/01/21
                          ['1999-01-23/' + ['14:54:13','14:54:20']], $ ;orb 9585 REAL badness not picked up by transtimes 2017/01/21
                          ['1999-01-23/' + ['15:02:40','15:02:50']], $ ;orb 9585 REAL badness not picked up by transtimes 2017/01/21
                          ['1999-02-17/' + ['20:58:30','20:59:30']], $ ;orb 9860 badness
                          ['1999-06-26/' + ['04:56:24','04:56:34']], $ ;orb 11255 badness
                          ['1999-06-28/' + ['05:25:22','05:25:38']], $ ;orb 11277 badness
                          ['1999-08-30/' + ['08:43:42','08:43:51']], $ ;orb 11964 badness
                          ['1999-08-30/' + ['12:57:48','12:57:57']], $ ;orb 11966 badness
                          ['1999-08-30/' + ['17:39:25','17:39:29']], $ ;orb 11968 badness
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
                          ['1999-09-02/' + ['15:59:20','16:09:35']], $ ;orb 12000 badness (good burst data)
                          ['1999-09-29/' + ['20:58:52','20:59:02']]  $ ;orb 12297 REAL badness 2017/01/21 (no burst data)
                          ]
  ENDELSE

  IF N_ELEMENTS(blackballOrb_ranges) GT 0 THEN BEGIN

     ;;See if we have somesing first
     blackballFile = dirForAlle + GET_FAST_DB_STRING(dbStruct) + '-blackballOrbRanges.sav'

     goAhead = 1
     IF FILE_TEST(blackballFile) AND ~KEYWORD_SET(remake_trashOrb_files) THEN BEGIN
        PRINT,'Restoring blackballFile: ' + blackballFile + ' ...'
        RESTORE,blackballFile
        IF ARRAY_EQUAL(blackballOrb_ranges,RblackballOrb_ranges) THEN BEGIN
           ;; blackBall_ii        = TEMPORARY(rblackBall_ii       )
           ;; keeper_ii           = TEMPORARY(rkeeper_ii          )
           blackBall_i         = TEMPORARY(rblackBall_i        )
           keeper_i            = TEMPORARY(rkeeper_i           )
           nKeeper             = TEMPORARY(rNKeeper            )
           nBlackball          = TEMPORARY(rNBlackball         )

           goAhead             = 0

        ENDIF
     ENDIF

     IF goAhead OR KEYWORD_SET(remake_trashOrb_files) THEN BEGIN

        sort_i              = SORT(REFORM(blackballOrb_ranges[0,*]))
        blackballOrb_ranges = [blackballOrb_ranges[0,sort_i],blackballOrb_ranges[1,sort_i]]

        ;; firstInd = VALUE_LOCATE(blackballOrb_ranges[0,*],dbStruct.orbit[good_i])
        firstInd = VALUE_LOCATE(blackballOrb_ranges[0,*],dbStruct.orbit)
        ;; firstInd = firstInd[WHERE(firstInd GE 0)]
        firstInd = firstInd > 0
        orbGaps  = REFORM(blackballOrb_ranges[1,*]-blackballOrb_ranges[0,*])

        ;; blackBall_ii = WHERE(( (REFORM(blackballOrb_ranges[0,*]))[firstInd] LE dbStruct.orbit[good_i]                      ) AND $
        ;;                      ( (dbStruct.orbit[good_i] - (REFORM(blackballOrb_ranges[0,*]))[firstInd]) LE (REFORM(orbGaps))[firstInd]), $
        blackBall_i = WHERE(( (REFORM(blackballOrb_ranges[0,*]))[firstInd] LE dbStruct.orbit                      ) AND $
                             ( (dbStruct.orbit - (REFORM(blackballOrb_ranges[0,*]))[firstInd]) LE (REFORM(orbGaps))[firstInd]), $
                             nBlackball, $
                             COMPLEMENT=keeper_i, $
                             NCOMPLEMENT=nKeeper)
        blackBall_i2 = WHERE( ( ( (REFORM(blackballOrb_ranges[0,*]))[firstInd] - dbStruct.orbit) LE 0 ) AND $
                             ( ( (REFORM(blackballOrb_ranges[1,*]))[firstInd] - dbStruct.orbit) GE 0 ), $
                             nBlackball2, $
                             COMPLEMENT=keeper_i2, $
                             NCOMPLEMENT=nKeeper2)

        ;; rblackBall_ii        = TEMPORARY(blackBall_ii       )
        ;; rkeeper_ii           = keeper_ii
        ;; rblackBall_i         = TEMPORARY(blackBall_i       )
        rblackBall_i         = blackBall_i
        rkeeper_i            = keeper_i
        rNKeeper             = nKeeper
        rNBlackball          = nBlackball
        rblackballOrb_ranges = blackballOrb_ranges
        PRINT,"Saving blackballOrbRange stuff to " + blackballFile + ' ...'
        ;; SAVE,rblackBall_ii,rkeeper_ii,rNKeeper,rNBlackball,rblackballOrb_ranges,FILENAME=blackballFile
        SAVE,rblackBall_i,rkeeper_i,rNKeeper,rNBlackball,rblackballOrb_ranges,FILENAME=blackballFile
        ;; rkeeper_ii           = !NULL
        rblackBall_i         = !NULL
        rkeeper_i            = !NULL
        rNKeeper             = !NULL
        rNBlackball          = !NULL
     ENDIF

     IF nBlackball GT 0 THEN BEGIN
        nGood   = N_ELEMENTS(good_i)
        ;; nBTot  += nBlackball

        ;; good_i  = good_i[keeper_ii]
        good_i  = CGSETINTERSECTION(good_i,keeper_i,COUNT=nKeeper,NORESULT=-1)
        ;; good_i  = CGSETDIFFERENCE(good_i,blackball_i,COUNT=nKeeper,NORESULT=-1)
        nBTot  += nBlackball

        IF KEYWORD_SET(keep_on_tap) THEN BEGIN
           notTrash_i = CGSETINTERSECTION(notTrash_i,keeper_i,COUNT=nNotTrash)
        ENDIF


        ;;If we enter this bit of code, the files were just remade and we should see if life is sane
        ;; IF goAhead OR KEYWORD_SET(remake_trashOrb_files) THEN BEGIN

        ;;    death   = 0
        ;;    FOR k=0,N_ELEMENTS(blackballOrb_ranges[0,*])-1 DO BEGIN

        ;;       howMany   = N_ELEMENTS(WHERE(dbStruct.orbit[good_i] GE blackballOrb_ranges[0,k] AND $
        ;;                                    dbStruct.orbit[good_i] LE blackballOrb_ranges[1,k], $
        ;;                                    /NULL))
        ;;       letEmKnow = STRING(FORMAT='("Blacked orbits ",I0,"–",I0,T30," : ")', $
        ;;                          blackballOrb_ranges[0,k], $
        ;;                          blackballOrb_ranges[1,k])
        ;;       ;; IF howMany GT 0 THEN BEGIN
        ;;       PRINT,FORMAT='(A0,I0)',letEmKnow,howMany
        ;;       ;; ENDIF ELSE BEGIN
        ;;       death += howMany GT 0
        ;;    ENDFOR
        ;;    IF death GT 0 THEN STOP

        ;; ENDIF

        ;; good_i  = CGSETDIFFERENCE(good_i,blackBall_i,NORESULT=-1,COUNT=count)
        IF good_i[0] EQ -1 THEN BEGIN
           PRINT,opener+"We've killed every orbit!"
           broken = 1
           ;; BREAK
        ENDIF
        opener = ''
        PRINT,opener+'Junked ' + STRCOMPRESS(nGood-nKeeper,/REMOVE_ALL) + ' blackballed events ...'
     ENDIF ELSE BEGIN
        PRINT,opener+"No baddies found in this case ..."
     ENDELSE

        ;; FOR k=0,N_ELEMENTS(blackballOrb_ranges[0,*])-1 DO BEGIN
        ;;    opener = STRING(FORMAT='("Blacked orbits ",I0,"–",I0,T30," : ")',blackballOrb_ranges[0,k],blackballOrb_ranges[1,k])

        ;;    blackBall_ii = WHERE(dbStruct.orbit[good_i] GE blackballOrb_ranges[0,k] AND dbStruct.orbit[good_i] LE blackballOrb_ranges[1,k], $
        ;;                         nBlackball, $
        ;;                         COMPLEMENT=keeper_ii, $
        ;;                         NCOMPLEMENT=nKeeper)

        ;;    IF nBlackball GT 0 THEN BEGIN
        ;;       nGood   = N_ELEMENTS(good_i)
        ;;       nBTot  += nBlackball

        ;;       good_i  = good_i[keeper_ii]
        ;;       ;; good_i  = CGSETDIFFERENCE(good_i,blackBall_i,NORESULT=-1,COUNT=count)
        ;;       IF good_i[0] EQ -1 THEN BEGIN
        ;;          PRINT,opener+"We've killed every orbit!"
        ;;          broken = 1
        ;;          BREAK
        ;;       ENDIF
        ;;       PRINT,opener+'Junked ' + STRCOMPRESS(nGood-nKeeper,/REMOVE_ALL) + ' blackballed events ...'
        ;;    ENDIF ELSE BEGIN
        ;;       PRINT,opener+"No baddies found in this case ..."
        ;;    ENDELSE
        ;; ENDFOR

     IF KEYWORD_SET(broken) THEN STOP

  ENDIF

  IF N_ELEMENTS(individual_blackballOrbs) GT 0 THEN BEGIN

     ;;See if we have somesing first
     blackballFile = dirForAlle + GET_FAST_DB_STRING(dbStruct) + '-individualBlackballOrbs.sav'

     goAhead = 1
     IF FILE_TEST(blackballFile) AND ~KEYWORD_SET(remake_trashOrb_files) THEN BEGIN
        PRINT,'Restoring blackballFile: ' + blackballFile + ' ...'
        RESTORE,blackballFile
        IF ARRAY_EQUAL(individual_blackballOrbs,rindividual_blackballOrbs) THEN BEGIN
           ;; blackBall_ii        = TEMPORARY(rblackBall_ii       )
           ;; keeper_ii           = TEMPORARY(rkeeper_ii          )
           blackBall_i         = TEMPORARY(rblackBall_i        )
           keeper_i            = TEMPORARY(rkeeper_i           )
           nKeeper             = TEMPORARY(rNKeeper            )
           nBlackball          = TEMPORARY(rNBlackball         )

           goAhead             = 0

        ENDIF
     ENDIF

     IF goAhead OR KEYWORD_SET(remake_trashOrb_files) THEN BEGIN

        individual_blackballOrbs = individual_blackballOrbs[SORT(individual_blackballOrbs)]
        ;; firstInd = VALUE_LOCATE(individual_blackballOrbs,dbStruct.orbit[good_i])
        firstInd = VALUE_LOCATE(individual_blackballOrbs,dbStruct.orbit)
        ;; firstInd = firstInd[WHERE(firstInd GE 0)] ;;BADDD line
        firstInd = firstInd > 0

        ;; blackBall_ii = WHERE((individual_blackballOrbs[firstInd]-dbStruct.orbit[good_i]) EQ 0, $
        blackBall_i  = WHERE((individual_blackballOrbs[firstInd]-dbStruct.orbit) EQ 0, $
                             nBlackball, $
                             ;; COMPLEMENT=keeper_ii, $
                             COMPLEMENT=keeper_i, $
                             NCOMPLEMENT=nKeeper)

        ;; rblackBall_ii             = TEMPORARY(blackBall_ii            )
        ;; rblackBall_i              = TEMPORARY(blackBall_i             )
        ;; rkeeper_ii                = keeper_ii
        rblackBall_i              = blackBall_i
        rkeeper_i                 = keeper_i
        rNKeeper                  = nKeeper
        rNBlackball               = nBlackball
        rindividual_blackballOrbs = TEMPORARY(individual_blackballOrbs)
        PRINT,"Saving individualBlackballOrb stuff to " + blackballFile + ' ...'
        ;; SAVE,rblackBall_ii,rkeeper_ii,rNKeeper,rNBlackball,rindividual_blackballOrbs,FILENAME=blackballFile
        SAVE,rblackBall_i,rkeeper_i,rNKeeper,rNBlackball,rindividual_blackballOrbs,FILENAME=blackballFile
        ;; rkeeper_ii           = !NULL
        rblackBall_i              = !NULL
        rkeeper_i                 = !NULL
        rNKeeper                  = !NULL
        rNBlackball               = !NULL

     ENDIF

     IF nBlackball GT 0 THEN BEGIN
        nGood   = N_ELEMENTS(good_i)
        nBTot  += nBlackball

        ;; good_i  = CGSETDIFFERENCE(good_i,blackBall_i,NORESULT=-1,COUNT=count)
        ;; good_i  = good_i[keeper_ii]
        ;; good_i  = CGSETINTERSECTION(good_i,keeper_i,COUNT=nKeeper,NORESULT=-1)
        good_i  = CGSETDIFFERENCE(good_i,blackball_i,COUNT=nKeeper,NORESULT=-1)
        IF good_i[0] EQ -1 THEN BEGIN
           PRINT,opener+"We've killed every orbit!"
           broken = 1
           ;; BREAK
        ENDIF
        PRINT,opener+'Junked ' + STRCOMPRESS(nGood-nKeeper,/REMOVE_ALL) + ' blackballed events ...'

        IF KEYWORD_SET(keep_on_tap) THEN BEGIN
           notTrash_i = CGSETDIFFERENCE(notTrash_i,blackball_i,COUNT=nNotTrash)
        ENDIF

     ENDIF ELSE BEGIN
        PRINT,opener+"No baddies found in this case ..."
     ENDELSE

     ;; FOR k=0,N_ELEMENTS(individual_blackballOrbs)-1 DO BEGIN


     ;;    opener = STRING(FORMAT='("Blackball orbit ",I0,T30," : ")',individual_blackballOrbs[k])

     ;;    ;; blackBall_i = WHERE(dbStruct.orbit EQ individual_blackballOrbs[k],nBlackball)
     ;;    blackBall_ii = WHERE(dbStruct.orbit[good_i] EQ individual_blackballOrbs[k],nBlackball, $
     ;;                         COMPLEMENT=keeper_ii, $
     ;;                         NCOMPLEMENT=nKeeper)

     ;;    IF nBlackball GT 0 THEN BEGIN
     ;;       nGood   = N_ELEMENTS(good_i)
     ;;       nBTot  += nBlackball

     ;;       ;; good_i  = CGSETDIFFERENCE(good_i,blackBall_i,NORESULT=-1,COUNT=count)
     ;;       good_i  = good_i[keeper_ii]
     ;;       IF good_i[0] EQ -1 THEN BEGIN
     ;;          PRINT,opener+"We've killed every orbit!"
     ;;          broken = 1
     ;;          BREAK
     ;;       ENDIF
     ;;       PRINT,opener+'Junked ' + STRCOMPRESS(nGood-nKeeper,/REMOVE_ALL) + ' blackballed events ...'
     ;;    ENDIF ELSE BEGIN
     ;;       PRINT,opener+"No baddies found in this case ..."
     ;;    ENDELSE

     ;; ENDFOR
     

  ENDIF

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

     ;;Do we have stuff?
     ;;See if we have somesing first
     blackballFile = dirForAlle + GET_FAST_DB_STRING(dbStruct) + '-blackballCustomTimes.sav'

     goAhead = 1
     IF FILE_TEST(blackballFile) AND ~KEYWORD_SET(remake_trashOrb_files) THEN BEGIN
        PRINT,'Restoring blackballFile: ' + blackballFile + ' ...'
        RESTORE,blackballFile
        IF ARRAY_EQUAL(customTimes,rCustomTimes) THEN BEGIN
           ;; blackBall_ii        = TEMPORARY(rblackBall_ii       )
           ;; keeper_ii           = TEMPORARY(rkeeper_ii          )
           blackBall_i         = TEMPORARY(rblackBall_i        )
           keeper_i            = TEMPORARY(rkeeper_i           )
           nKeeper             = TEMPORARY(rNKeeper            )
           nBlackball          = TEMPORARY(rNBlackball         )

           goAhead             = 0

        ENDIF
     ENDIF

     IF goAhead OR KEYWORD_SET(remake_trashOrb_files) THEN BEGIN

        sort_i       = SORT(REFORM(customTimes[0,*]))
        customTimes  = [customTimes[0,sort_i],customTimes[1,sort_i]]

        ;; firstInd     = VALUE_LOCATE(customTimes[0,*],(use_x ? DBStruct.x : DBTimes)[good_i])
        firstInd     = VALUE_LOCATE(customTimes[0,*],(use_x ? DBStruct.x : DBTimes))
        ;; firstInd     = firstInd[WHERE(firstInd GE 0)] ;NO!!!
        firstInd     = firstInd > 0
        tGaps        = REFORM(customTimes[1,*]-customTimes[0,*])
        ;; blackBall_ii = WHERE(( (REFORM(customTimes[0,*]))[firstInd] LE (use_x ? DBStruct.x : DBTimes)[good_i]                      ) AND $
        ;;                      ( ( (use_x ? DBStruct.x : DBTimes)[good_i] - (REFORM(customTimes[0,*]))[firstInd]) LE tGaps[firstInd]), $
        blackBall_i  = WHERE(( (REFORM(customTimes[0,*]))[firstInd] LE (use_x ? DBStruct.x : DBTimes)                      ) AND $
                             ( ( (use_x ? DBStruct.x : DBTimes) - (REFORM(customTimes[0,*]))[firstInd]) LE tGaps[firstInd]), $
                             nBlackball, $
                             ;; COMPLEMENT=keeper_ii, $
                             COMPLEMENT=keeper_i, $
                             NCOMPLEMENT=nKeeper)

           ;; blackBall_ii = WHERE(((use_x ? DBStruct.x : DBTimes)[good_i] GE customTimes[0,k]) AND $
           ;;                      ((use_x ? DBStruct.x : DBTimes)[good_i] LE customTimes[1,k]), $
           ;;                      nBlackball, $
           ;;                      COMPLEMENT=keeper_ii, $
           ;;                      NCOMPLEMENT=nKeeper)
           

        ;; FOR k=0,N_ELEMENTS(customTimes[0,*])-1 DO BEGIN

        ;;    opener       = STRING(FORMAT='("Blackball tRange ",A-23,"-",A-23," : ")', $
        ;;                          TIME_TO_STR(customTimes[0,k],/MS), $
        ;;                          TIME_TO_STR(customTimes[1,k],/MS))

        ;;    blackBall_ii = WHERE(((use_x ? DBStruct.x : DBTimes)[good_i] GE customTimes[0,k]) AND $
        ;;                         ((use_x ? DBStruct.x : DBTimes)[good_i] LE customTimes[1,k]), $
        ;;                         nBlackball, $
        ;;                         COMPLEMENT=keeper_ii, $
        ;;                         NCOMPLEMENT=nKeeper)
           
        ;; ENDFOR

        ;; rblackBall_ii             = TEMPORARY(blackBall_ii)
        ;; rkeeper_ii                = keeper_ii
        ;; rblackBall_i              = TEMPORARY(blackBall_i)
        rblackBall_i              = blackBall_i
        rkeeper_i                 = keeper_i
        rNKeeper                  = nKeeper
        rNBlackball               = nBlackball
        rCustomTimes              = TEMPORARY(customTimes)
        PRINT,"Saving customTimeBlackballStuff stuff to " + blackballFile + ' ...'
        ;; SAVE,rblackBall_ii,rkeeper_ii,rNKeeper,rNBlackball,rCustomTimes,FILENAME=blackballFile
        ;; rkeeper_ii           = !NULL
        SAVE,rblackBall_i,rkeeper_i,rNKeeper,rNBlackball,rCustomTimes,FILENAME=blackballFile
        rkeeper_i            = !NULL
        rNKeeper             = !NULL
        rNBlackball          = !NULL

     ENDIF

     IF nBlackball GT 0 THEN BEGIN
        nGood     = N_ELEMENTS(good_i)
        nBTot    += nBlackball

        ;; good_i    = good_i[keeper_ii]
        good_i  = CGSETINTERSECTION(good_i,keeper_i,COUNT=nKeeper,NORESULT=-1)
        ;; good_i    = good_i[keeper_ii]
        IF good_i[0] EQ -1 THEN BEGIN
           PRINT,opener+"We've killed everything!"
           broken = 1
           ;; BREAK
        ENDIF
        PRINT,opener+'Junked ' + STRCOMPRESS(nGood-nKeeper,/REMOVE_ALL) + ' blackballed events ...'

        IF KEYWORD_SET(keep_on_tap) THEN BEGIN
           notTrash_i = CGSETINTERSECTION(notTrash_i,keeper_i,COUNT=nNotTrash)
        ENDIF

     ENDIF ELSE BEGIN
        PRINT,opener+"No baddies found in this case ..."
     ENDELSE

  ENDIF

  IF KEYWORD_SET(remake_trashOrb_files) THEN BEGIN
     PRINT,"Switching off REMAKE_TRASHORB_FILES ..."
     remake_trashOrb_files = 0
  ENDIF

  ENDIF

  IF KEYWORD_SET(broken) THEN STOP

  RETURN,good_i
END
