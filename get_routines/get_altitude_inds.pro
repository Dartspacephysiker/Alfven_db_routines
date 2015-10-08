FUNCTION GET_ALTITUDE_INDS,minAlt,maxAlt,LUN=lun

  alt_i=where(maximus.alt GE altitudeRange[0] AND maximus.alt LE altitudeRange[1])
  
  printf,lun,"Min altitude: " + strcompress(altitudeRange[0],/remove_all)
  printf,lun,"Max altitude: " + strcompress(altitudeRange[1],/remove_all)
  
  RETURN,alt_i

END