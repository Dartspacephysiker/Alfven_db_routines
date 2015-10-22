FUNCTION ILAT_TO_LSHELL,ilats
  
  lShells = (cos(ilats*!PI/180.))^(-2)

  RETURN,lShells

END