FUNCTION GET_ALTITUDE_INDS,dbStruct,minAlt,maxAlt,LUN=lun

  COMPILE_OPT idl2,strictarrsubs

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  alt_i = WHERE(dbStruct.alt GE minAlt AND dbStruct.alt LE maxAlt, $
                NCOMPLEMENT=n_alt_outside_range)
  
  PRINTF,lun,FORMAT='("N lost to altitude restr.      :",T35,I0)',n_alt_outside_range
  PRINTF,lun,''

  RETURN,alt_i

END