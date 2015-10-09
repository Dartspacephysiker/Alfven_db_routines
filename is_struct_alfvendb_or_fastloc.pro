PRO IS_STRUCT_ALFVENDB_OR_FASTLOC,dbStruct,is_maximus

  IF TAG_EXIST(dbStruct,'mag_current') THEN BEGIN
     PRINTF,lun,"This is a FAST Alfvén wave database..."
     is_maximus = 1
  ENDIF ELSE BEGIN
     PRINTF,lun,"This is a FAST ephemeris database..."
     is_maximus = 0
  ENDELSE

END