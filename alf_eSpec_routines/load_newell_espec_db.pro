PRO LOAD_NEWELL_ESPEC_DB,eSpec,alf_i__good_eSpec,good_eSpec_i, $
                         FAILCODES=failCodes, $
                         NEWELLDBDIR=NewellDBDir, $
                         NEWELLDBFILE=NewellDBFile, $
                         FORCE_LOAD_DB=force_load_db, $
                         DESPUN_ALF_DB=despun_alf_db, $
                         LUN=lun

  COMPILE_OPT idl2

  COMMON NEWELL,NEWELL__eSpec, $
     NEWELL__good_eSpec_i, $
     NEWELL__good_alf_i, $
     NEWELL_failCodes, $
     NEWELL__dbFile,NEWELL__dbDir

  IF KEYWORD_SET(despun_alf_db) THEN BEGIN
     PRINT,'Despun is not supported!'
     STOP
  ENDIF

  IF N_ELEMENTS(lun) EQ 0 THEN BEGIN
     lun                 = -1
  ENDIF

  defNewellDBDir         = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/fully_parsed/'
  defNewellDBFile        = 'alf_eSpec_20151222_db--TOTAL_ESPECS_FAILCODES__Orbs_500-16361--20160602.sav'

  IF N_ELEMENTS(NEWELL__eSpec) NE 0 AND ~KEYWORD_SET(force_load_db) THEN BEGIN
     PRINT,'Restoring eSpec DB already in memory...'
     eSpec               = NEWELL__eSpec
     alf_i__good_eSpec   = NEWELL__good_alf_i
     good_eSpec_i        = NEWELL__good_eSpec_i
     failCodes           = NEWELL__failCodes
     NewellDBDir         = NEWELL__dbDir
     NewellDBFile        = NEWELL__dbFile
     RETURN
  ENDIF

  IF N_ELEMENTS(NewellDBDir) EQ 0 THEN BEGIN
     ;; IF KEYWORD_SET(load_culled_eSpec_db) THEN BEGIN
     ;;    NewellDBDir   = defCulledNewellDBDir
     ;; ENDIF ELSE BEGIN
        NewellDBDir      = defNewellDBDir
     ;; ENDELSE
  ENDIF
  NEWELL__dbDir          = NewellDBDir

  IF N_ELEMENTS(NewellDBFile) EQ 0 THEN BEGIN
     ;; IF KEYWORD_SET(load_culled_eSpec_db) THEN BEGIN
     ;;    NewellDBFile  = defCulledNewellDBFile
     ;; ENDIF ELSE BEGIN
        NewellDBFile     = defNewellDBFile
        ;; ENDELSE
  ENDIF
  NEWELL__dbFile         = NewellDBFile

  IF N_ELEMENTS(eSpec) EQ 0 OR KEYWORD_SET(force_load_db) THEN BEGIN
     IF KEYWORD_SET(force_load_db) THEN BEGIN
        PRINTF,lun,"Forced loading of eSpec database ..."
     ENDIF
     ;; IF KEYWORD_SET(load_culled_eSpec_db) THEN BEGIN
     ;;    PRINTF,lun,'Loading culled ESPEC DB: ' + NewellDBDir+NewellDBFile + '...'
     ;;    restore,NewellDBDir+NewellDBFile
     ;;    eSpec         = eSpec_culled
     ;; ENDIF ELSE BEGIN
        PRINTF,lun,'Loading eSpec DB: ' + NewellDBDir+NewellDBFile + '...'
        restore,NewellDBDir+NewellDBFile
     ;; ENDELSE
  ENDIF ELSE BEGIN
     PRINTF,lun,'eSpec DB already loaded! Not restoring ' + NewellDBFile + '...'
  ENDELSE
  NEWELL__eSpec          = eSpec
  NEWELL__good_alf_i     = alf_i__good_eSpec
  NEWELL__good_eSpec_i   = good_eSpec_i

  IF N_ELEMENTS(failCodes) NE 0 THEN BEGIN
     NEWELL__failCodes   = failCodes
  ENDIF ELSE BEGIN
     NEWELL__failCodes   = !NULL
     PRINT,'This Newell DB file doesn''t have fail codes!'
  ENDELSE

  RETURN

END