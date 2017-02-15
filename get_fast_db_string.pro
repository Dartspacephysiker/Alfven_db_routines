;;12/08/16
FUNCTION GET_FAST_DB_STRING,DBStruct, $
   FOR_ALFDB=alfDB, $
   FOR_FASTLOC_DB=fastLocDB, $
   FOR_ESPEC_DB=eSpecDB, $
   FOR_ION_DB=ionDB

  COMPILE_OPT IDL2

  IF KEYWORD_SET(eSpecDB) AND KEYWORD_SET(ionDB) THEN BEGIN
     IS_STRUCT_ION_OR_ESPEC,DBStruct,is_ion,/QUIET
     ionDB   = is_ion
     eSpecDB = ~is_ion
  ENDIF

  brokeBack = 1
  WHILE brokeBack DO BEGIN
     CASE 1 OF
        KEYWORD_SET(alfDB): BEGIN
           pref = 'alfDB-'
           brokeBack = 0
        END
        KEYWORD_SET(fastLocDB): BEGIN
           pref = 'fastLocDB-'
           brokeBack = 0
        END
        KEYWORD_SET(eSpecDB): BEGIN
           pref = 'eSpecDB_'
           brokeBack = 0
        END
        KEYWORD_SET(ionDB): BEGIN
           pref = 'ionDB_'
           brokeBack = 0
        END
        ELSE: BEGIN
           IS_STRUCT_ALFVENDB_OR_FASTLOC,DBStruct,is_maximus,/QUIET
           IF is_maximus THEN BEGIN
              alfDB = 1 
           ENDIF ELSE BEGIN
              IS_STRUCT_ION_OR_ESPEC,DBStruct,is_ion,/QUIET
              IF is_ion THEN BEGIN
                 ionDB = 1
              ENDIF ELSE BEGIN
                 IF TAG_EXIST(DBStruct,"mono") THEN BEGIN
                    eSpecDB = 1
                 ENDIF ELSE BEGIN
                    fastLocDB = STRMATCH(STRUPCASE(DBStruct.info.DB_dir),'*FASTLOC*')
                    IF ~fastLOCDB THEN STOP
                 ENDELSE
              ENDELSE
           ENDELSE
        END
     ENDCASE

  ENDWHILE

  DBString = pref + DBStruct.info.DB_DATE + '_' + $
             (DBStruct.info.DB_version).Replace('.','_') + '--' + $
             DBStruct.info.DB_extras.Replace('/','--')

  RETURN,DBString
END
