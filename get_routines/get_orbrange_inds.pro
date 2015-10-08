FUNCTION GET_ORBRANGE_INDS,maximus,minOrb,maxOrb,LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF minOrb GT maxOrb THEN BEGIN
     PRINTF,lun,"minOrb is greater than maxOrb!"
     STOP
  ENDIF

  ind_orbs=where(maximus.orbit GE orbRange[0] AND maximus.orbit LE orbRange[1])

  printf,lun,"Min orbit: " + strcompress(orbRange[0],/remove_all)
  printf,lun,"Max orbit: " + strcompress(orbRange[1],/remove_all)
  
  RETURN,ind_orbs

END