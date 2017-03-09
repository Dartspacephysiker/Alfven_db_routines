PRO ALFDB_SWITCH_COORDS,dbStruct,coordStr,coordName,SUCCESS=success

  COMPILE_OPT idl2,strictarrsubs


  success = 0B

  ;;Make sure it's not already a done deal
  STR_ELEMENT,dbStruct.info,'COORDS',VALUE=coordVal,INDEX=coordInd
  IF coordInd GT 0 THEN BEGIN
     IF STRPOS(STRUPCASE(dbStruct.info.(coordInd)),STRUPCASE(coordName)) GE 0 THEN BEGIN
        PRINT,'Already using ' + coordName + ' coords. Returning ...'
        success = 1B
        RETURN
     ENDIF ELSE BEGIN
        PRINT,"Switching to " + coordName + ' coords ...'
     ENDELSE
  ENDIF

  dbName        = STRUPCASE(['ALT','MLT','ILAT','LNG','LNG'])
  coordStrName  = STRUPCASE(['ALT','MLT', 'LAT','LNG','LON'])
  nPoss         = N_ELEMENTS(dbName)

  dbTags        = STRUPCASE(TAG_NAMES(dbStruct))
  coordTags     = STRUPCASE(TAG_NAMES(coordStr))

  coordString   = coordName
  FOR k=0,nPoss-1 DO BEGIN
     tempI      = WHERE(dbTags    EQ dbName[k])
     coordI     = WHERE(coordTags EQ coordStrName[k])

     CASE 1 OF
        tempI[0] NE -1 AND coordI[0] NE -1: BEGIN

           IF N_ELEMENTS(dbStruct.(tempI)) NE N_ELEMENTS(coordStr.(coordI)) THEN BEGIN
              PRINT,'Mismatching numbers of elements! I don''t think this coordinate conversion is valid ...'
              STOP
           ENDIF

           dbStruct.(tempI) = coordStr.(coordI)
           
           coordString += '_' + dbName[k]
           
        END
        coordI[0] NE -1: BEGIN

           PRINT,"Adding " + coordStrName[k] + " to DB ..."

           IF N_ELEMENTS(dbStruct.(0)) NE N_ELEMENTS(coordStr.(coordI)) THEN BEGIN
              PRINT,'Mismatching numbers of elements! I don''t think adding ' + $
                    coordStrName[k] + ' is valid ...'
              STOP
           ENDIF

           tmpInfo = dbStruct.info
           STR_ELEMENT,dbStruct,'info',/DELETE
           STR_ELEMENT,dbStruct,dbName[k],coordStr.(coordI),/ADD_REPLACE
           STR_ELEMENT,dbStruct,'info',tmpInfo,/ADD_REPLACE
           ;; dbStruct.(tempI) = coordStr.(coordI)
           coordString += '_' + dbName[k]
           
        END
        ELSE: BEGIN
           PRINT,"Couldn't find " + coordStrName[k] + " in coordStr ..."
        END
     ENDCASE

  ENDFOR

  IF TAG_EXIST(dbStruct,'info') THEN BEGIN
     dbStruct.info.coords = coordString
  ENDIF ELSE BEGIN
     ;; IF TAG_EXIST(dbStruct,'coords') THEN BEGIN
     ;;    dbStruct.coords = coordString
     ;; ENDIF ELSE BEGIN
     ;;    dbStruct        = CREATE_STRUCT(dbStruct,'COORDS',coordString)
     ;; ENDELSE
     PRINT,'FIX'
     STOP
  ENDELSE

  success = 1B

END