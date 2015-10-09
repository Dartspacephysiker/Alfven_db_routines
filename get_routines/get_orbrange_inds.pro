FUNCTION GET_ORBRANGE_INDS,dbStruct,minOrb,maxOrb,LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF minOrb GT maxOrb THEN BEGIN
     PRINTF,lun,"minOrb is greater than maxOrb!"
     STOP
  ENDIF

  ind_orbs=where(dbStruct.orbit GE minOrb AND dbStruct.orbit LE maxOrb)

  RETURN,ind_orbs

END