FUNCTION GET_ORBRANGE_INDS,dbStruct,minOrb,maxOrb,LUN=lun, $
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
  ENDIF;;  ELSE BEGIN
  ;;    ind_orbs = TRASH_BAD_FAST_ORBITS(dbStruct,ind_orbs,CUSTOM_ORBS_TO_KILL=8276)
  ;; ENDELSE

  ;; nBef        = N_ELEMENTS(ind_orbs)
  ;; ind_orbs    = CGSETDIFFERENCE(ind_orbs,WHERE(dbStruct.orbit EQ 9792),COUNT=nAft)
  ;; PRINT,'Removing anything to do with orbit 9792: lost ',nBef-nAft," inds"

  RETURN,ind_orbs

END