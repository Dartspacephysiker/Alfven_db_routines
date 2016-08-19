PRO LOAD_ALF_NEWELL_ESPEC_DB,eSpec,alf_i__good_eSpec,good_eSpec_i, $
                             FAILCODES=failCodes, $
                             NEWELLDBDIR=NewellDBDir, $
                             NEWELLDBFILE=NewellDBFile, $
                             FORCE_LOAD_DB=force_load_db, $
                             DESPUN_ALF_DB=despun_alf_db, $
                             DONT_LOAD_IN_MEMORY=nonMem, $
                             LUN=lun

  COMPILE_OPT idl2

  ;;This common block is defined ONLY here, GET_ESPEC_ION_DB_IND, and in GET_H2D_NEWELLS__EACH_TYPE
  IF ~KEYWORD_SET(nonMem) THEN BEGIN
  @common__newell_alf.pro
     ;; COMMON NWLL_ALF, $
     ;;    NWLL_ALF__eSpec, $
     ;;    NWLL_ALF__HAVE_GOOD_I, $
     ;;    NWLL_ALF__good_eSpec_i, $
     ;;    NWLL_ALF__good_alf_i, $
     ;;    NWLL_ALF__failCodes, $
     ;;    NWLL_ALF__despun, $
     ;;    NWLL_ALF__charERange, $
     ;;    NWLL_ALF__dbFile, $
     ;;    NWLL_ALF__dbDir, $
     ;;    NWLL_ALF__RECALCULATE
  ENDIF

  defNewellDBDir         = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/fully_parsed/'
  ;; defNewellDBFile        = 'alf_eSpec_20151222_db--TOTAL_ESPECS_FAILCODES__Orbs_500-16361--20160603.sav'
  ;; defNewellDespunDBFile  = 'alf_eSpec_20160508_db--despun--TOTAL_ESPECS_FAILCODES__Orbs_502-16361--20160603.sav'

  ;;The files with failcodes
  defNewellDBFile        = 'alf_eSpec_20151222_db--TOTAL_ESPECS_FAILCODES__Orbs_500-16361--20160609.sav'
  defNewellDespunDBFile  = 'alf_eSpec_20160508_db--despun--TOTAL_ESPECS_FAILCODES__Orbs_502-16361--20160609.sav'

  IF N_ELEMENTS(lun) EQ 0 THEN BEGIN
     lun                 = -1
  ENDIF

  IF ~KEYWORD_SET(nonMem) THEN BEGIN
     IF N_ELEMENTS(NWLL_ALF__eSpec) NE 0 AND ~KEYWORD_SET(force_load_db) THEN BEGIN
        PRINT,'Restoring eSpec DB already in memory...'
        eSpec               = NWLL_ALF__eSpec
        alf_i__good_eSpec   = NWLL_ALF__good_alf_i
        good_eSpec_i        = NWLL_ALF__good_eSpec_i
        failCodes           = NWLL_ALF__failCodes
        NewellDBDir         = NWLL_ALF__dbDir
        NewellDBFile        = NWLL_ALF__dbFile
        RETURN
     ENDIF
  ENDIF

  IF N_ELEMENTS(NewellDBDir) EQ 0 THEN BEGIN
     ;; IF KEYWORD_SET(load_culled_eSpec_db) THEN BEGIN
     ;;    NewellDBDir   = defCulledNewellDBDir
     ;; ENDIF ELSE BEGIN
        NewellDBDir      = defNewellDBDir
     ;; ENDELSE
  ENDIF
  IF ~KEYWORD_SET(nonMem) THEN BEGIN
     NWLL_ALF__dbDir          = NewellDBDir
  ENDIF

  IF N_ELEMENTS(NewellDBFile) EQ 0 THEN BEGIN
     ;; IF KEYWORD_SET(load_culled_eSpec_db) THEN BEGIN
     ;;    NewellDBFile  = defCulledNewellDBFile
     ;; ENDIF ELSE BEGIN
     IF KEYWORD_SET(despun_alf_db) THEN BEGIN
        PRINT,"eSpecs for despun Alfvén wave database..."

        NewellDBFile     = defNewellDespunDBFile
        IF ~KEYWORD_SET(nonMem) THEN BEGIN
           NWLL_ALF__despun   = 1
        ENDIF
     ENDIF ELSE BEGIN
        NewellDBFile     = defNewellDBFile
        IF ~KEYWORD_SET(nonMem) THEN BEGIN
           NWLL_ALF__despun   = 0
        ENDIF
     ENDELSE
        ;; ENDELSE
  ENDIF
  IF ~KEYWORD_SET(nonMem) THEN BEGIN
     NWLL_ALF__dbFile         = NewellDBFile
  ENDIF

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
        RESTORE,NewellDBDir+NewellDBFile

        PRINT,"Converting Alfvén eSpec DB to strict Newell interpretation ..."
        CONVERT_ESPEC_TO_STRICT_NEWELL_INTERPRETATION,eSpec,eSpec,/HUGE_STRUCTURE,/VERBOSE
     ;; ENDELSE
  ENDIF ELSE BEGIN
     PRINTF,lun,'eSpec DB already loaded! Not restoring ' + NewellDBFile + '...'
  ENDELSE

  IF ~KEYWORD_SET(nonMem) THEN BEGIN

     NWLL_ALF__eSpec          = eSpec
     NWLL_ALF__good_alf_i     = alf_i__good_eSpec
     NWLL_ALF__good_eSpec_i   = good_eSpec_i
     IF N_ELEMENTS(failCodes) NE 0 THEN BEGIN
        NWLL_ALF__failCodes   = failCodes
     ENDIF ELSE BEGIN
        NWLL_ALF__failCodes   = !NULL
        PRINT,'This Newell DB file doesn''t have fail codes!'
     ENDELSE
  ENDIF

  IF KEYWORD_SET(nonMem) THEN BEGIN
     CLEAR_ALF_NEWELL_COMMON_VARS
  ENDIF

  RETURN

END