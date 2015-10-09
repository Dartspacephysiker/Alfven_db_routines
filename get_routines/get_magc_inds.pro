FUNCTION GET_MAGC_INDS,maximus,minMC,maxNegMC,N_OUTSIDE_MAGC=n_magc_outside_range,MAGC_I_GE_MINMC=magc_i_ge_minMC,MAGC_I_LE_NEGMC=magc_i_le_NegMC,MAGC_I_IN_RANGE=magc_i_in_range,LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  magc_i_ge_minMC=where(maximus.mag_current GE minMC)
  magc_i_le_NegMC=where(maximus.mag_current LE maxNegMC)
  magc_i=where(maximus.mag_current LE maxNegMC OR maximus.mag_current GE minMC,NCOMPLEMENT=n_magc_outside_range)

  PRINTF,lun,'Min magCurrent: ' + STRCOMPRESS(minMC,/REMOVE_ALL)
  PRINTF,lun,'Max Neg magCurrent: ' + STRCOMPRESS(maxNegMC,/REMOVE_ALL)
  PRINTF,lun,'N lost due to magCurrent restriction: ' + STRCOMPRESS(n_magc_outside_range,/REMOVE_ALL)
  PRINTF,lun,''

  RETURN,magc_i

END