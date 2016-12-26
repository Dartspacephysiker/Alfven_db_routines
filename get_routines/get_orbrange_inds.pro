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
                          [7804,7837], $
                          [11985,12001] $
                          ] 

     customTKillStrings = [ $
                          ['1996-12-08/' + ['08:44:20','08:46:10']], $
                          ['1999-02-17/' + ['20:58:30','20:59:30']], $ ;orb 9860 badness
                          ['1997-12-30/' + ['05:53:40','05:54:00']], $ ;orb 5363 badness
                          ['1998-11-13/' + ['02:54:32','02:54:35']]  $ ;orb 8809 badness 
                          ]

     customKill         = [1002, $
                           8276, $ ;;This guy is bad for IMF stuff, but good for storms
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