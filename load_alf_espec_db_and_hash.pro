;2015/12/22 Added DO_NOT_MAP_PFLUX_keyword and FORCE_LOAD keywords
;2016/01/07 Added DO_DESPUNDB keyword
PRO LOAD_ALF_ESPEC_DB_AND_HASH,out_alf_eSpec_stats,out_alf_specIdent_hash, $
                             DBDir=DBDir, $
                             DBFile=DBFile, $
                             DO_DESPUNDB=despunDB, $
                             FORCE_LOAD_ALF_ESPEC_STATS_AND_HASH=force_load, $
                             QUIET=quiet, $
                             LUN=lun

  COMMON ALF_ESPEC_VARS,ALF_ESPEC__stats,ALF_ESPEC__hash, $
     ALF_ESPEC__dbFile,ALF_ESPEC__dbTimesFile, $
     ALF_ESPEC__RECALCULATE

  COMPILE_OPT idl2,strictarrsubs

  IF N_ELEMENTS(lun) EQ 0 THEN lun           = -1         ;stdout

  IF KEYWORD_SET(force_load) THEN BEGIN
     PRINTF,lun,"Forcing load of alf_eSpec_stats_and_hash and cdbTime..."
     force_load_alf_eSpec_stats_and_hash     = 1
  ENDIF

  DefDBDir                                   = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'

  DefDBFile                                  = 'Alfven_eSpec--NOT_despun--Newell_et_al_2009--orbits_500-5451.sav'
  ;; defDespunDBFile                         = 'Dartdb_20160508--502-16361_despun--maximus--pflux_lshell--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'


  IF KEYWORD_SET(despunDB) THEN BEGIN
     DBDir                                   = defDBDir
     DBFile                                  = defDespunDBFile
     PRINTF,lun,"Doing despun DB!"
  ENDIF ELSE BEGIN
     IF N_ELEMENTS(DBDir) EQ 0 THEN DBDir    = DefDBDir
     IF N_ELEMENTS(DBFile) EQ 0 THEN DBFile  = DefDBFile
  ENDELSE
  
  IF N_ELEMENTS(ALF_ESPEC__stats) EQ 0 OR KEYWORD_SET(force_load) THEN BEGIN
     IF KEYWORD_SET(force_load) THEN BEGIN
        PRINTF,lun,"Forcing load, whether or not we already have alf_eSpec..."
     ENDIF
     IF FILE_TEST(DBDir+DBFile) THEN BEGIN
        RESTORE,DBDir+DBFile
        IF  alf_eSpec_stats EQ !NULL THEN BEGIN
           PRINT,"Couldn't load alf_eSpec stuff!"
           STOP
        ENDIF        
        ALF_ESPEC__stats                     = alf_eSpec_stats
        ALF_ESPEC__hash                      = alf_specIdent_hash
        ALF_ESPEC__DBDir                     = DBDir
        ALF_ESPEC__DBFile                    = DBFile
     ENDIF

  ENDIF ELSE BEGIN
     PRINTF,lun,"There is already alf_eSpec stuff loaded! Not loading " + DBFile
     DBFile                                  = ALF_ESPEC__DBFile
  ENDELSE

  out_alf_eSpec_stats                        = ALF_ESPEC__stats
  out_alf_specIdent_hash                     = ALF_ESPEC__hash
END