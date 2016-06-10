PRO LOAD_ALF_NEWELL_ION_DB, $ ;iSpec, $
   alf_i__good_iSpec, $
   good_iSpec_i, $
   NEWELLDBDIR=NewellDBDir, $
   NEWELLDBFILE=NewellDBFile, $
   FORCE_LOAD_DB=force_load_db, $
   DESPUN_ALF_DB=despun_alf_db, $
   DONT_LOAD_IN_MEMORY=nonMem, $
   LUN=lun

  COMPILE_OPT idl2

  ;;This common block is defined ONLY here and in GET_H2D_NEWELLS__EACH_TYPE
  IF ~KEYWORD_SET(nonMem) THEN BEGIN
     COMMON NWLL_ALF_I, $ ;NWLL_ALF_I__iSpec, $
        NWLL_ALF_I__good_iSpec_i, $
        NWLL_ALF_I__good_alf_i, $
        NWLL_ALF_I__despun, $
        NWLL_ALF_I__cleaned_i, $
        NWLL_ALF_I__dbFile,NWLL_ALF_I__dbDir, $
        NEWELL_I__charIERange, $
        NWLL_ALF_I__RECALCULATE
  ENDIF

  defNewellDBDir         = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'
  defNewellDBFile        = 'alf_iSpec_20151222_db--TIME_SERIES_AND_ORBITS_ALIGNED_WITH_DB--WINNOWED--Orbs_500-16361--20160607.sav'
  defNewellDespunDBFile  = 'alf_iSpec_20160508_db--despun--TIME_SERIES_AND_ORBITS_ALIGNED_WITH_DB--WINNOWED--Orbs_502-16361--20160607.sav'

  IF N_ELEMENTS(lun) EQ 0 THEN BEGIN
     lun                 = -1
  ENDIF

  IF ~KEYWORD_SET(nonMem) THEN BEGIN
     IF N_ELEMENTS(NWLL_ALF_I__iSpec) NE 0 AND ~KEYWORD_SET(force_load_db) THEN BEGIN
        PRINT,'Restoring iSpec DB already in memory...'
        ;; iSpec               = NWLL_ALF_I__iSpec
        alf_i__good_iSpec   = NWLL_ALF_I__good_alf_i
        good_iSpec_i        = NWLL_ALF_I__good_iSpec_i
        NewellDBDir         = NWLL_ALF_I__dbDir
        NewellDBFile        = NWLL_ALF_I__dbFile
        RETURN
     ENDIF
  ENDIF

  IF N_ELEMENTS(NewellDBDir) EQ 0 THEN BEGIN
     ;; IF KEYWORD_SET(load_culled_iSpec_db) THEN BEGIN
     ;;    NewellDBDir   = defCulledNewellDBDir
     ;; ENDIF ELSE BEGIN
        NewellDBDir      = defNewellDBDir
     ;; ENDELSE
  ENDIF
  IF ~KEYWORD_SET(nonMem) THEN BEGIN
     NWLL_ALF_I__dbDir          = NewellDBDir
  ENDIF

  IF N_ELEMENTS(NewellDBFile) EQ 0 THEN BEGIN
     ;; IF KEYWORD_SET(load_culled_iSpec_db) THEN BEGIN
     ;;    NewellDBFile  = defCulledNewellDBFile
     ;; ENDIF ELSE BEGIN
     IF KEYWORD_SET(despun_alf_db) THEN BEGIN
        PRINT,"iSpecs for despun Alfvén wave database..."

        NewellDBFile     = defNewellDespunDBFile
        IF ~KEYWORD_SET(nonMem) THEN BEGIN
           NWLL_ALF_I__despun   = 1
        ENDIF
     ENDIF ELSE BEGIN
        NewellDBFile     = defNewellDBFile
        IF ~KEYWORD_SET(nonMem) THEN BEGIN
           NWLL_ALF_I__despun   = 0
        ENDIF
     ENDELSE
        ;; ENDELSE
  ENDIF
  IF ~KEYWORD_SET(nonMem) THEN BEGIN
     NWLL_ALF_I__dbFile         = NewellDBFile
  ENDIF

  IF N_ELEMENTS(iSpec) EQ 0 OR KEYWORD_SET(force_load_db) THEN BEGIN
     IF KEYWORD_SET(force_load_db) THEN BEGIN
        PRINTF,lun,"Forced loading of iSpec database ..."
     ENDIF
     ;; IF KEYWORD_SET(load_culled_iSpec_db) THEN BEGIN
     ;;    PRINTF,lun,'Loading culled ISPEC DB: ' + NewellDBDir+NewellDBFile + '...'
     ;;    restore,NewellDBDir+NewellDBFile
     ;;    iSpec         = iSpec_culled
     ;; ENDIF ELSE BEGIN
        PRINTF,lun,'Loading iSpec DB: ' + NewellDBDir+NewellDBFile + '...'
        restore,NewellDBDir+NewellDBFile
     ;; ENDELSE
  ENDIF ELSE BEGIN
     PRINTF,lun,'iSpec DB already loaded! Not restoring ' + NewellDBFile + '...'
  ENDELSE

  IF ~KEYWORD_SET(nonMem) THEN BEGIN

     ;; NWLL_ALF_I__iSpec          = iSpec
     NWLL_ALF_I__good_alf_i     = alf_i__good_iSpec
     NWLL_ALF_I__good_iSpec_i   = good_iSpec_i
  ENDIF

  RETURN

END