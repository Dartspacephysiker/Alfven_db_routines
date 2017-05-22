;;02/15/17
PRO FASTDBS__DELTA_SWITCHER, $
   dbStruct, $
   OUT_WIDTH_MEASURE=width_measure, $
   DBDIR=DBDir, $
   LOAD_DELTA_T=load_delta_t, $
   LOAD_DELTA_ILAT_NOT_DELTA_T=load_dILAT, $
   LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=load_dAngle, $
   LOAD_DELTA_X_FOR_WIDTH_TIME=load_dx, $
   DO_NOT_MAP_DELTA_T=do_not_map_delta_t, $
   MAP_SQRT_FLUXES=map_sqrt_fluxes, $
   DILAT_FILE=dILAT_file, $
   FOR_ALFDB=alfDB, $
   FOR_SWAY_DB=swayDB, $
   FOR_FASTLOC_DB=fastLocDB, $
   FOR_ESPEC_DB=eSpecDB, $
   FOR_ION_DB=ionDB, $
   DELTA_STUFF=delta_stuff


  COMPILE_OPT IDL2,STRICTARRSUBS

  fileSuff = '-delta_ilats.sav'

  bigDB = BYTE(KEYWORD_SET(eSpecDB) OR KEYWORD_SET(ionDB))

  CASE 1 OF
     KEYWORD_SET(alfDB): BEGIN
        DBNavn = 'alfDB'
     END
     KEYWORD_SET(swayDB): BEGIN
        DBNavn = 'swayDB'
     END
     KEYWORD_SET(fastLocDB): BEGIN
        DBNavn = 'fastLocDB'
     END
     KEYWORD_SET(eSpecDB): BEGIN
        DBNavn = 'eSpecDB'
     END
     KEYWORD_SET(ionDB): BEGIN
        DBNavn = 'ionDB'
     END
  ENDCASE

  delta_stuff = KEYWORD_SET(load_delta_t) + KEYWORD_SET(load_dILAT) + KEYWORD_SET(load_dx) + KEYWORD_SET(load_dAngle)

  CASE delta_stuff OF
     0:
     1: BEGIN

        IF KEYWORD_SET(alfDB) THEN BEGIN
           IF DBStruct.info.corrected_fluxes THEN BEGIN
              PRINT,"You need to reset corrected fluxes. Otherwise you're going to get junk."
              PRINT,"However you got here, make sure that FORCE_LOAD_ALL gets called instead of cruising through."
              STOP
           ENDIF

        ENDIF

        IF ~KEYWORD_SET(load_delta_t) THEN BEGIN
           dILAT_file             = GET_FAST_DB_STRING( $
                                    DBStruct,FOR_ALFDB=alfDB, $
                                    FOR_FASTLOC_DB=fastLocDB, $
                                    FOR_ESPEC_DB=eSpecDB, $
                                    FOR_ION_DB=ionDB) + fileSuff
           RESTORE,DBDir+dILAT_file
        ENDIF
     END
     ELSE: BEGIN
        PRINT,"Can't have it all."
        STOP
     END
  ENDCASE

  IF KEYWORD_SET(load_delta_t) AND bigDB THEN BEGIN
     PRINT,"Loading " + DBNavn + " delta_ts ..."
     width_measure                = GET_ESPEC_ION_DELTA_T(DBStruct, $
                                                          DBNAME=DBNavn)
  ENDIF

  IF KEYWORD_SET(load_dILAT) THEN BEGIN
     PRINT,"Loading dILAT in place of " + dbNavn + $
           " delta_t, and not mapping ..."
     
     do_not_map_delta_t           = 1
     map_sqrt_fluxes              = KEYWORD_SET(alfDB) ? 1B : !NULL

     width_measure                = TEMPORARY(ABS(FLOAT(width_ILAT)))
     DBStruct.info.dILAT_not_dt   = 1B
  ENDIF

  IF KEYWORD_SET(load_dAngle) THEN BEGIN
     PRINT,"Loading dAngle in place of " + DBNavn + " delta_t, and not mapping ..."
     
     do_not_map_delta_t           = 1
     map_sqrt_fluxes              = KEYWORD_SET(alfDB) ? 1B : !NULL

     width_measure                = TEMPORARY(ABS(FLOAT(width_angle)))
     DBStruct.info.dAngle_not_dt  = 1B
  ENDIF

  IF KEYWORD_SET(load_dx) THEN BEGIN
     PRINT,"Loading dx in place of " + DBNavn + " delta_t, and not mapping ..."
     
     do_not_map_delta_t           = 1
     map_sqrt_fluxes              = KEYWORD_SET(alfDB) ? 1B : !NULL

     width_measure                = TEMPORARY(ABS(FLOAT(width_x)))
     DBStruct.info.dx_not_dt      = 1B
  ENDIF

END
