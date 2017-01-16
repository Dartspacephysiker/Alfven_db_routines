FUNCTION GET_ORBRANGE_INDS,dbStruct,minOrb,maxOrb,LUN=lun, $
                           DBTIMES=DBTimes, $ ;in case we'd like to trash some time ranges
                           DONT_TRASH_BAD_ORBITS=keepJunk

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF minOrb GT maxOrb THEN BEGIN
     PRINTF,lun,"minOrb is greater than maxOrb!"
     STOP
  ENDIF

  ind_orbs = WHERE(dbStruct.orbit GE minOrb AND dbStruct.orbit LE maxOrb,n_orb, $
                   NCOMPLEMENT=n_not_orb)

  PRINTF,lun,FORMAT='("N inside  orb range",T30,":",T35,I0)',n_orb
  PRINTF,lun,FORMAT='("N outside orb range",T30,":",T35,I0)',n_not_orb

  IF ~KEYWORD_SET(keepJunk) THEN BEGIN
     ind_orbs = TRASH_BAD_FAST_ORBITS(dbStruct,ind_orbs)
  ENDIF ELSE BEGIN

     customKillRanges   = [ $
                          [1028,1056], $ ;;Believe me, these orbits are bad for everyone
                          ;; [7804,7837], $ ;;Try to fix these one by one below. So far have fixed 7804, 7807
                          [7805,7806], $ ;;No data??
                          [7808,7812]  $ ;;The entire stretch is either garbage data or nothing at all for these orbits
                          ;; [7808,7837], $ 
                          ;; [11993,12001] $
                          ] 

     customTKillStrings = [ $
                          ['1996-12-08/' + ['08:44:20','08:46:10']], $
                          ['1999-02-17/' + ['20:58:30','20:59:30']], $ ;orb 9860 badness
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

     customKill         = [1002, $
                           7833, $ ;;Just junk it
                           ;; 8276, $ ;;This guy is bad for IMF stuff, but good for storms
                           9585, $
                           12278,12297,12471, $
                           13214,13785, $
                           14297]
     ;; customKill         = [1002]

     ind_orbs = TRASH_BAD_FAST_ORBITS(dbStruct,ind_orbs, $
                                      DBTIMES=DBTimes, $
                                      CUSTOM_ORBS_TO_KILL=customKill, $
                                      CUSTOM_ORBRANGES_TO_KILL=customKillRanges, $
                                      CUSTOM_TSTRINGS_TO_KILL=customTKillStrings, $
                                      CUSTOM_TRANGES_TO_KILL=customTKillRanges)

     ;;Why? Because check out Alfven_db_routines/info_on_FAST_database/orbits_to_omit_from_IMF_stats.txt
  ENDELSE

  ;; nBef        = N_ELEMENTS(ind_orbs)
  ;; ind_orbs    = CGSETDIFFERENCE(ind_orbs,WHERE(dbStruct.orbit EQ 9792),COUNT=nAft)
  ;; PRINT,'Removing anything to do with orbit 9792: lost ',nBef-nAft," inds"

  RETURN,ind_orbs

END