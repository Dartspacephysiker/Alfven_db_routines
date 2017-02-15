;;2017/02/15
PRO FASTDBS__COORDINATE_SWITCHER, $
   dbStruct, $
   COORDINATE_SYSTEM=coordinate_system, $
   USE_LNG=use_lng, $
   USE_AACGM_COORDS=use_AACGM, $
   USE_GEI_COORDS=use_GEI, $
   USE_GEO_COORDS=use_GEO, $
   USE_MAG_COORDS=use_MAG, $
   USE_SDT_COORDS=use_SDT, $
   DEFCOORDDIR=defCoordDir, $
   AACGM_FILE=AACGM_file, $
   GEI_FILE=GEI_file, $
   GEO_FILE=GEO_file, $
   MAG_FILE=MAG_file, $
   SDT_FILE=SDT_file, $
   FOR_ALFDB=alfDB, $
   FOR_FASTLOC_DB=fastLocDB, $
   FOR_ESPEC_DB=eSpecDB, $
   FOR_ION_DB=ionDB, $
   NO_MEMORY_LOAD=noMem, $
   CHANGEDCOORDS=changedCoords
  
  COMPILE_OPT IDL2

  IF KEYWORD_SET(coordinate_system) THEN BEGIN
     CASE STRUPCASE(coordinate_system) OF
        'AACGM': BEGIN
           use_AACGM = 1
           use_GEI   = 0
           use_GEO   = 0
           use_MAG   = 0
           use_SDT   = 0
        END
        'GEI'  : BEGIN
           use_AACGM = 0
           use_GEI   = 1
           use_GEO   = 0
           use_MAG   = 0
           use_SDT   = 0
        END
        'GEO'  : BEGIN
           use_AACGM = 0
           use_GEI   = 0
           use_GEO   = 1
           use_MAG   = 0
           use_SDT   = 0
        END
        'MAG'  : BEGIN
           use_AACGM = 0
           use_GEI   = 0
           use_GEO   = 0
           use_MAG   = 1
           use_SDT   = 0
        END
        'SDT'  : BEGIN
           use_AACGM = 0
           use_GEI   = 0
           use_GEO   = 0
           use_MAG   = 0
           use_SDT   = 1
        END
     ENDCASE
  ENDIF

  changeCoords = 0B

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  PRINT,"UNDER CONSTRUCTION"
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  IF KEYWORD_SET(use_AACGM) THEN BEGIN
     PRINT,"I know. I already did."

     ;; PRINT,'Using AACGM lat, MLT, and alt ...'

     coordStr  = TEMPORARY(AACGM)
     coordName = 'AACGM'

     changeCoords = 1B
  ENDIF

  IF KEYWORD_SET(use_GEI) THEN BEGIN
     PRINT,'Using GEI lat and alt ...'

     RESTORE,defCoordDir+GEI_file

     coordStr  = TEMPORARY(GEI)
     coordName = 'GEI'

  ENDIF

  IF KEYWORD_SET(use_GEO) THEN BEGIN
     PRINT,'Using GEO lat and alt ...'

     RESTORE,defCoordDir+GEO_file

     coordStr  = TEMPORARY(GEO)
     coordName = 'GEO'

     changeCoords = 1B

  ENDIF

  IF KEYWORD_SET(use_MAG) THEN BEGIN
     PRINT,'Using MAG lat and alt ...'

     RESTORE,defCoordDir+MAG_file

     coordStr  = TEMPORARY(MAG)
     coordName = 'MAG'

     changeCoords = 1B

  ENDIF

  IF ~KEYWORD_SET(noMem) THEN BEGIN
     IF ~(KEYWORD_SET(use_AACGM) OR KEYWORD_SET(use_MAG) OR KEYWORD_SET(use_GEO)) THEN BEGIN
        IF STRUPCASE(dbStruct.info.coords) NE 'SDT' THEN BEGIN
           use_SDT = 1
        ENDIF 
     ENDIF
  ENDIF

  IF KEYWORD_SET(use_SDT) THEN BEGIN

     RESTORE,defCoordDir+SDT_file

     coordName = 'SDT'
     coordStr  = TEMPORARY(SDT)

     changeCoords = 1B
  ENDIF

  IF changeCoords THEN BEGIN
     ALFDB_SWITCH_COORDS, $
        dbStruct, $
        coordStr, $
        coordName, $
        SUCCESS=success

     changedCoords = KEYWORD_SET(success)

     IF ~changedCoords THEN BEGIN
        MESSAGE,"Failed to change coords!"
        STOP
     ENDIF
  ENDIF


  IF KEYWORD_SET(use_lng) THEN BEGIN
     index = -1
     STR_ELEMENT,dbStruct,'lng',INDEX=index
     IF index NE -1 THEN BEGIN
        flip = WHERE(dbStruct.lng LT 0.)
        IF flip[0] NE -1 THEN BEGIN
           dbStruct.lng[flip] += 360.
        ENDIF
     ENDIF
  ENDIF

END
