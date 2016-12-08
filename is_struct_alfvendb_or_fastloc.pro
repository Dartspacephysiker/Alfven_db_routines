PRO IS_STRUCT_ALFVENDB_OR_FASTLOC,dbStruct, $
                                  is_maximus, $
                                  QUIET=quiet, $
                                  LUN=lun

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1   ;stdout

  IF TAG_EXIST(dbStruct,'mag_current') THEN BEGIN
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,"This is a FAST Alfvén wave database..."
     is_maximus = 1
  ENDIF ELSE BEGIN
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,"This is a FAST ephemeris database..."
     is_maximus = 0
  ENDELSE

END