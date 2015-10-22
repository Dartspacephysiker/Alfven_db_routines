FUNCTION LSHELL_TO_ILAT,lShells

  ilats = 180/!PI*ACOS(SQRT(1.0/lShells))

  RETURN,ilats

END