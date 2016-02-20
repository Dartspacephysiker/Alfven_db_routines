;2015/12/22 Added DO_NOT_MAP_PFLUX_keyword and FORCE_LOAD keywords
;2016/01/07 Added DO_DESPUNDB keyword
PRO LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime, $
                             DBDir=DBDir, $
                             DBFile=DBFile, $
                             DB_TFILE=DB_tFile, $
                             CORRECT_FLUXES=correct_fluxes, $
                             DO_NOT_MAP_PFLUX=do_not_map_pflux, $
                             DO_NOT_MAP_IONFLUX=do_not_map_ionflux, $
                             DO_NOT_MAP_HEAVIES=do_not_map_heavies, $
                             DO_CHASTDB=chastDB, $
                             DO_DESPUNDB=despunDB, $
                             USING_HEAVIES=using_heavies, $
                             FORCE_LOAD_MAXIMUS=force_load_maximus, $
                             FORCE_LOAD_CDBTIME=force_load_cdbTime, $
                             FORCE_LOAD_BOTH=force_load_BOTH, $
                             LUN=lun

  ;; COMMON M_VARS,MAXIMUS,MAXIMUS__HAVE_GOOD_I,MAXIMUS__times, $
  ;;    MAXIMUS__good_i,MAXIMUS__cleaned_i, $
  ;;    MAXIMUS__dbFile,MAXIMUS__dbTimesFile

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1         ;stdout

  IF N_ELEMENTS(correct_fluxes) EQ 0 THEN correct_fluxes = 1

  IF KEYWORD_SET(force_load_both) THEN BEGIN
     PRINTF,lun,"Forcing load of maximus and cdbTime..."
     force_load_maximus = 1
     force_load_cdbtime = 1
  ENDIF

  DefDBDir             = '/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  ;;DefDBFile            = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'
  ;; DefDBFile            = 'Dartdb_20151014--500-16361_inc_lower_lats--burst_1000-16361--w_Lshell--maximus.sav'

  ;;commented out 2016/01/07 while checking out the despun database
  DefDBFile            = 'Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--w_Lshell--correct_pFlux--maximus.sav'
  DefDB_tFile          = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav'

  defDespunDBFile      = 'Dartdb_20160107--502-16361_despun--maximus--pflux--lshell--burst--noDupes.sav'
  defDespunDB_tFile    = 'Dartdb_20160107--502-16361_despun--cdbtime--noDupes.sav'


  IF KEYWORD_SET(chastDB) THEN BEGIN
     DBDir='/SPENCEdata/Research/Cusp/database/processed/'
     DBFile = "maximus.dat"
     DB_tFile = "cdbtime.sav"
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(despunDB) THEN BEGIN
        DBDir = defDBDir
        DBFile = defDespunDBFile
        DB_tFile = defDespunDB_tFile
        PRINTF,lun,"Doing despun DB!"
     ENDIF ELSE BEGIN
        IF N_ELEMENTS(DBDir) EQ 0 THEN DBDir = DefDBDir
        IF N_ELEMENTS(DBFile) EQ 0 THEN DBFile = DefDBFile
        IF N_ELEMENTS(DB_tFile) EQ 0 THEN DB_tFile = DefDB_tFile
     ENDELSE
  ENDELSE
  
  IF N_ELEMENTS(maximus) EQ 0 OR KEYWORD_SET(force_load_maximus) THEN BEGIN
     IF KEYWORD_SET(force_load_maximus) THEN BEGIN
        PRINTF,lun,"Forcing load, whether or not we already have maximus..."
     ENDIF
     IF FILE_TEST(DBDir+DBFile) THEN RESTORE,DBDir+DBFile
     IF maximus EQ !NULL THEN BEGIN
        PRINT,"Couldn't load maximus!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"There is already a maximus struct loaded! Not loading " + DBFile
     DBFile = 'Previously loaded maximus struct'
  ENDELSE

  IF N_ELEMENTS(cdbTime) EQ 0 OR KEYWORD_SET(force_load_cdbTime) THEN BEGIN
     IF KEYWORD_SET(force_load_cdbTime) THEN BEGIN
        PRINTF,lun,"Forcing load, whether or not we already have cdbTime..."
     ENDIF
     IF FILE_TEST(DBDir+DB_tFile) THEN RESTORE,DBDir+DB_tFile
     IF cdbTime EQ !NULL THEN BEGIN
        PRINT,"Couldn't load cdbTime!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"There is already a cdbTime struct loaded! Not loading " + DB_tFile
     DBFile = 'Previously loaded cdbTime array'
  ENDELSE

  IF correct_fluxes THEN BEGIN
     ;; IF KEYWORD_SET(despunDB) THEN BEGIN
     ;;    PRINTF,lun,'Not mapping to the ionosphere because we have no mapping database for the new despun data set!'
     ;; ENDIF
     ;; CORRECT_ALFVENDB_FLUXES,maximus,MAP_PFLUX_TO_IONOS=~(KEYWORD_SET(do_not_map_pflux) OR KEYWORD_SET(despunDB))
     CORRECT_ALFVENDB_FLUXES,maximus, $
                             MAP_PFLUX_TO_IONOS=~KEYWORD_SET(do_not_map_pflux), $
                             MAP_IONFLUX_TO_IONOS=~KEYWORD_SET(do_not_map_ionflux), $
                             MAP_HEAVIES_TO_IONOS=~KEYWORD_SET(do_not_map_heavies), $
                             DO_DESPUNDB=do_despunDB, $
                             USING_HEAVIES=using_heavies

  ENDIF


END