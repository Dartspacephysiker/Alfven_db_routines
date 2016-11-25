PRO ALFDB_SWITCH_COORDS,dbStruct,coordStr,coordName

  COMPILE_OPT idl2


  possibilities = STRLOWCASE(['ALT','MLT','ILAT'])
  possPair      = STRLOWCASE(['ALT','MLT', 'LAT'])
  nPoss         = N_ELEMENTS(possibilities)

  dbTags        = STRLOWCASE(TAG_NAMES(dbStruct))
  coordTags     = STRLOWCASE(TAG_NAMES(coordStr))

  coordString   = coordName
  FOR k=0,nPoss-1 DO BEGIN
     tempI      = WHERE(dbTags    EQ possibilities[k])
     coordI     = WHERE(coordTags EQ possPair[k])

     IF tempI[0] NE -1 AND coordI[0] NE -1 THEN BEGIN

        IF N_ELEMENTS(dbStruct.(tempI)) NE N_ELEMENTS(coordStr.(coordI)) THEN BEGIN
           PRINT,'Mismatching numbers of elements! I don''t think this coordinate conversion is valid ...'
           STOP
        ENDIF

        dbStruct.(tempI) = coordStr.(coordI)
        
        coordString += '_' + possibilities[k]
        
     ENDIF

     IF TAG_EXIST(dbStruct,'info') THEN BEGIN
        dbStruct.info.coords = coordString
     ENDIF ELSE BEGIN
        IF TAG_EXIST(dbStruct,'coords') THEN BEGIN
           dbStruct.coords = coordString
        ENDIF ELSE BEGIN
           dbStruct        = CREATE_STRUCT(dbStruct,'COORDS',coordString)
        ENDELSE
     ENDELSE

  ENDFOR



END