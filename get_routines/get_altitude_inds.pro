FUNCTION GET_ALTITUDE_INDS,dbStruct,minAlt,maxAlt,LUN=lun

  COMPILE_OPT idl2

  alt_i=where(dbStruct.alt GE minAlt AND dbStruct.alt LE maxAlt)
  
  RETURN,alt_i

END