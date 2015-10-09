FUNCTION GET_ALTITUDE_INDS,dbStruct,minAlt,maxAlt,LUN=lun

  alt_i=where(dbStruct.alt GE minAlt AND dbStruct.alt LE maxAlt)
  
  printf,lun,"Min altitude: " + strcompress(minAlt,/remove_all)
  printf,lun,"Max altitude: " + strcompress(maxAlt,/remove_all)
  
  RETURN,alt_i

END