;;2016/04/16 It's a nuisance to maintain this in like 50 different routines
FUNCTION SHIFT_MLTS_FOR_H2D,dbStruct,dbStruct_inds,shiftM, $
                            IN_MLTS=in_mlts

  IF shiftM GT 0. AND N_ELEMENTS(in_mlts) EQ 0 THEN BEGIN
     IS_STRUCT_ALFVENDB_OR_FASTLOC,dbStruct,is_maximus
     IF is_maximus THEN BEGIN
        dbString       = 'maximus'
     ENDIF ELSE BEGIN
        dbString       = 'fastLoc'
        PRINT,'Shifting ' + dbString + ' MLTs by ' + STRCOMPRESS(shiftM,/REMOVE_ALL) + '...'
     ENDELSE
  ENDIF

  IF KEYWORD_SET(in_mlts) THEN BEGIN
     dbStructMLTs            = in_mlts
  ENDIF ELSE BEGIN
     dbStructMLTs            = dbStruct.mlt[dbStruct_inds]-shiftM 
  ENDELSE
  fixMe                      = WHERE(dbStructMLTs LT 0.)
  IF fixMe[0] NE -1 THEN BEGIN
     dbStructMLTs[fixMe]     = dbStructMLTs[fixMe] + 24.
  ENDIF
  
  RETURN, dbStructMLTs
  
END