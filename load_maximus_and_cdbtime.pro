;2015/12/22 Added DO_NOT_MAP_PFLUX_keyword and FORCE_LOAD keywords
;2016/01/07 Added DO_DESPUNDB keyword
PRO LOAD_MAXIMUS_AND_CDBTIME,out_maximus,out_cdbTime, $
                             GOOD_I=good_i, $
                             INCLUDE_32HZ=include_32Hz, $
                             DBDir=DBDir, $
                             DBFile=DBFile, $
                             DB_TFILE=DB_tFile, $
                             CORRECT_FLUXES=correct_fluxes, $
                             DO_NOT_MAP_ESA_CURRENT=do_not_map_esa_current, $
                             DO_NOT_MAP_PFLUX=do_not_map_pflux, $
                             DO_NOT_MAP_IONFLUX=do_not_map_ionflux, $
                             DO_NOT_MAP_HEAVIES=do_not_map_heavies, $
                             DO_NOT_MAP_WIDTH_X=do_not_map_width_x, $
                             DO_NOT_MAP_ANYTHING=no_mapping, $
                             DO_CHASTDB=chastDB, $
                             DO_DESPUNDB=despunDB, $
                             COORDINATE_SYSTEM=coordinate_system, $
                             USE_AACGM_COORDS=use_aacgm, $
                             USE_GEO_COORDS=use_geo, $
                             USE_MAG_COORDS=use_mag, $
                             ;; GET_GOOD_I=get_good_i, $
                             HEMI__GOOD_I=hemi__good_i, $
                             USING_HEAVIES=using_heavies, $
                             FORCE_LOAD_MAXIMUS=force_load_maximus, $
                             FORCE_LOAD_CDBTIME=force_load_cdbTime, $
                             FORCE_LOAD_BOTH=force_load_BOTH, $
                             JUST_MAXIMUS=just_maximus, $
                             JUST_CDBTIME=just_cdbTime, $
                             CHECK_DB=check_DB, $
                             QUIET=quiet, $
                             NO_MEMORY_LOAD=noMem, $
                             LUN=lun

  COMPILE_OPT idl2

  ;;GET_CHASTON_IND is the other routine with this block!
  @common__maximus_vars.pro

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1         ;stdout

  IF N_ELEMENTS(correct_fluxes) EQ 0 THEN correct_fluxes = 1
  ;; correct_fluxes = 0

  IF KEYWORD_SET(force_load_both) THEN BEGIN
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,"Forcing load of maximus and cdbTime..."
     force_load_maximus = 1
     force_load_cdbtime = 1
  ENDIF

  DefDBDir             = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  defCoordDir          = DefDBDir + 'alternate_coords/'

  ;;DefDBFile            = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'
  ;; DefDBFile            = 'Dartdb_20151014--500-16361_inc_lower_lats--burst_1000-16361--w_Lshell--maximus.sav'

  ;;commented out 2016/01/07 while checking out the despun database
  DefDBFile            = 'Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--w_Lshell--correct_pFlux--maximus.sav'
  DefDB_tFile          = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav'

  ;; defDespunDBFile      = 'Dartdb_20160107--502-16361_despun--maximus--pflux--lshell--burst--noDupes.sav'
  ;; defDespunDB_tFile    = 'Dartdb_20160107--502-16361_despun--cdbtime--noDupes.sav'
  defDespunDBFile      = 'Dartdb_20160508--502-16361_despun--maximus--pflux_lshell--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'
  defDespunDB_tFile    = 'Dartdb_20160508--502-16361_despun--cdbtime--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'

  ;; AACGM_dir            = '/SPENCEdata/Research/database/FAST/ephemeris/'
  AACGM_file           = 'Dartdb_20151222--500-16361_inc_lower_lats--maximus--AACGM_coords.sav'
  GEO_file             = 'Dartdb_20151222--500-16361_inc_lower_lats--maximus--GEO_coords.sav'
  MAG_file             = 'Dartdb_20151222--500-16361_inc_lower_lats--maximus--MAG_coords.sav'

  AACGM_file__despun   = 'Dartdb_20160508--502-16361_despun--maximus--AACGM_coords--every_tstamp--20160824.sav'
  GEO_file__despun     = 'Dartdb_20160508--502-16361_despun--maximus--GEO_coords.sav'
  MAG_file__despun     = 'Dartdb_20160508--502-16361_despun--maximus--MAG_coords.sav'

  IF KEYWORD_SET(check_DB) THEN BEGIN
     out_maximus  = N_ELEMENTS(MAXIMUS__maximus)     GT 0 ? MAXIMUS__maximus     : !NULL
     out_cdbTime  = N_ELEMENTS(MAXIMUS__times)       GT 0 ? MAXIMUS__times       : !NULL
     good_i       = N_ELEMENTS(MAXIMUS__good_i)      GT 0 ? MAXIMUS__good_i      : !NULL
     DBFile       = N_ELEMENTS(MAXIMUS__dbFile)      GT 0 ? MAXIMUS__dbFile      : !NULL
     DB_tFile     = N_ELEMENTS(MAXIMUS__dbTimesFile) GT 0 ? MAXIMUS__dbTimesFile : !NULL
     DBDir        = N_ELEMENTS(MAXIMUS__dbDir)       GT 0 ? MAXIMUS__dbDir       : !NULL
     despunDB     = N_ELEMENTS(MAXIMUS__despun)      GT 0 ? MAXIMUS__despun      : !NULL
     chastDB      = N_ELEMENTS(MAXIMUS__is_chastDB)  GT 0 ? MAXIMUS__is_chastDB  : !NULL

     RETURN
  ENDIF

  ;;Make sure we're not switching between despun and not-despun
  IF  (  KEYWORD_SET(MAXIMUS__despun) AND ~KEYWORD_SET(despunDB) ) OR $
      ( ~KEYWORD_SET(MAXIMUS__despun) AND  KEYWORD_SET(despunDB) ) $
  THEN BEGIN
     IF N_ELEMENTS(MAXIMUS__maximus) NE 0 THEN BEGIN
        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'Swapping DBs!'
     ENDIF
     swap_DBs = 1
  ENDIF ELSE BEGIN
     swap_DBs = 0
  ENDELSE

  ;;Make sure we're not switching between despun and not-despun
  IF ~KEYWORD_SET(swap_DBs) THEN BEGIN
     IF  (  KEYWORD_SET(MAXIMUS__is_chastDB) AND ~KEYWORD_SET(chastDB) ) OR $
        ( ~KEYWORD_SET(MAXIMUS__is_chastDB) AND  KEYWORD_SET(chastDB) ) $
     THEN BEGIN
        IF N_ELEMENTS(MAXIMUS__maximus) NE 0 THEN BEGIN
           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'Swapping DBs!'
        ENDIF
        swap_DBs = 1
     ENDIF ELSE BEGIN
        swap_DBs = 0
     ENDELSE
  ENDIF

  IF KEYWORD_SET(chastDB) THEN BEGIN
     DBDir='/SPENCEdata/Research/database/FAST/Chaston_et_al_2007--current_db/'
     DBFile = "maximus.dat"
     DB_tFile = "cdbtime.sav"
     correct_fluxes = 1
     MAXIMUS__is_chastDB = 1
  ENDIF ELSE BEGIN
     MAXIMUS__is_chastDB = 0
     IF KEYWORD_SET(despunDB) THEN BEGIN
        DBDir = defDBDir
        DBFile = defDespunDBFile
        DB_tFile = defDespunDB_tFile
        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,"Doing despun DB!"
        MAXIMUS__despun = 1
     ENDIF ELSE BEGIN
        IF N_ELEMENTS(DBDir) EQ 0 THEN DBDir = DefDBDir
        IF N_ELEMENTS(DBFile) EQ 0 THEN DBFile = DefDBFile
        IF N_ELEMENTS(DB_tFile) EQ 0 THEN DB_tFile = DefDB_tFile
        MAXIMUS__despun = 0
     ENDELSE
  ENDELSE
  
  IF (N_ELEMENTS(MAXIMUS__maximus) EQ 0 OR $
      KEYWORD_SET(force_load_maximus)   OR $
      KEYWORD_SET(swap_DBs)) THEN BEGIN
     IF KEYWORD_SET(force_load_maximus) THEN BEGIN
        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,"Forcing load, whether or not we already have maximus..."
     ENDIF
     IF FILE_TEST(DBDir+DBFile) THEN BEGIN
        IF ~KEYWORD_SET(just_cdbTime) THEN BEGIN
           RESTORE,DBDir+DBFile
           MAXIMUS__maximus = maximus
           MAXIMUS__maximus = CREATE_STRUCT(MAXIMUS__maximus,'DESPUN',KEYWORD_SET(despunDB))     
           MAXIMUS__despun  = KEYWORD_SET(despunDB)
        ENDIF
        MAXIMUS__dbFile  = DBFile
        MAXIMUS__dbDir   = DBDir
     ENDIF
     IF maximus EQ !NULL AND ~KEYWORD_SET(just_cdbTime) THEN BEGIN
        PRINT,"Couldn't load maximus!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     IF ~KEYWORD_SET(quiet) THEN BEGIN
        PRINTF,lun,"There is already a maximus struct loaded! Not loading " + DBFile
     ENDIF

     DBFile    = N_ELEMENTS(MAXIMUS__dbFile)      GT 0 ? MAXIMUS__dbFile      : '(blank)'
     DB_tFile  = N_ELEMENTS(MAXIMUS__dbTimesFile) GT 0 ? MAXIMUS__dbTimesFile : '(blank)'
     despunDB = N_ELEMENTS(MAXIMUS__despun)       GT 0 ? MAXIMUS__despun      : !NULL
  ENDELSE

  IF N_ELEMENTS(MAXIMUS__times) EQ 0 OR $
     KEYWORD_SET(force_load_cdbTime) OR $
     KEYWORD_SET(swap_DBs) THEN BEGIN
     IF KEYWORD_SET(force_load_cdbTime) THEN BEGIN
        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,"Forcing load, whether or not we already have cdbTime..."
     ENDIF
     IF FILE_TEST(DBDir+DB_tFile) $
        AND ~KEYWORD_SET(just_maximus) $
     THEN BEGIN
        RESTORE,DBDir+DB_tFile
     ENDIF
     IF ( cdbTime EQ !NULL AND ~KEYWORD_SET(just_maximus) ) $         
     THEN BEGIN
        PRINT,"Couldn't load cdbTime!"
        STOP
     ENDIF
     MAXIMUS__times       = N_ELEMENTS(cdbTime)  GT 0 ? cdbTime  : !NULL
     MAXIMUS__dbTimesFile = N_ELEMENTS(DB_tFile) GT 0 ? DB_tFile : !NULL
  ENDIF ELSE BEGIN
     IF ~KEYWORD_SET(quiet) THEN BEGIN
        PRINTF,lun,"There is already a cdbTime struct loaded! Not loading " + DB_tFile
     ENDIF

     DB_tFile = MAXIMUS__dbTimesFile
  ENDELSE

  IF correct_fluxes AND ~KEYWORD_SET(just_cdbTime) THEN BEGIN
     CORRECT_ALFVENDB_FLUXES,MAXIMUS__maximus, $
                             MAP_ESA_CURRENT_TO_IONOS=~KEYWORD_SET(do_not_map_esa_current) $
                             AND ~KEYWORD_SET(no_mapping), $
                             MAP_PFLUX_TO_IONOS=~KEYWORD_SET(do_not_map_pflux) $
                             AND ~KEYWORD_SET(no_mapping), $
                             MAP_IONFLUX_TO_IONOS=~KEYWORD_SET(do_not_map_ionflux) $
                             AND ~KEYWORD_SET(no_mapping), $
                             MAP_HEAVIES_TO_IONOS=~KEYWORD_SET(do_not_map_heavies) $
                             AND ~KEYWORD_SET(no_mapping), $
                             ;; MAP_WIDTH_X_TO_IONOS=~KEYWORD_SET(do_not_map_width_x), $
                             DO_DESPUNDB=despunDB, $
                             DO_CHASTDB=chastDB, $
                             USING_HEAVIES=using_heavies, $
                             QUIET=quiet
  ENDIF ELSE BEGIN
     PRINTF,lun,"Not correcting fluxes in maximus ..."
  ENDELSE


  IF KEYWORD_SET(coordinate_system) THEN BEGIN
     CASE STRUPCASE(coordinate_system) OF
        'AACGM': BEGIN
           use_aacgm = 1
           use_geo   = 0
           use_mag   = 0
        END
        'GEO'  : BEGIN
           use_aacgm = 0
           use_geo   = 1
           use_mag   = 0
        END
        'MAG'  : BEGIN
           use_aacgm = 0
           use_geo   = 0
           use_mag   = 1
        END
     ENDCASE
  ENDIF

  IF KEYWORD_SET(use_aacgm) THEN BEGIN
     PRINT,'Using AACGM lat, MLT, and alt ...'

     IF KEYWORD_SET(despunDB) THEN BEGIN
        AACGM_file = AACGM_file__despun
     ENDIF;;  ELSE BEGIN
        
     ;; ENDELSE

     RESTORE,defCoordDir+AACGM_file

     ALFDB_SWITCH_COORDS,MAXIMUS__maximus,max_AACGM,'AACGM'

  ENDIF

  IF KEYWORD_SET(use_geo) THEN BEGIN
     PRINT,'Using GEO lat and alt ...'

     IF KEYWORD_SET(despunDB) THEN BEGIN
        GEO_file = GEO_file__despun
     ENDIF;;  ELSE BEGIN
        
     ;; ENDELSE

     RESTORE,defCoordDir+GEO_file

     ALFDB_SWITCH_COORDS,MAXIMUS__maximus,max_GEO,'GEO'

  ENDIF

  IF KEYWORD_SET(use_mag) THEN BEGIN
     PRINT,'Using MAG lat and alt ...'

     IF KEYWORD_SET(despunDB) THEN BEGIN
        MAG_file = MAG_file__despun
     ENDIF;;  ELSE BEGIN
        
     ;; ENDELSE

     RESTORE,defCoordDir+MAG_file

     ALFDB_SWITCH_COORDS,MAXIMUS__maximus,max_MAG,'MAG'

  ENDIF

  ;; IF KEYWORD_SET(get_good_i) THEN good_i = GET_CHASTON_IND(MAXIMUS__maximus,HEMI='BOTH')
  IF ARG_PRESENT(good_i) THEN good_i = GET_CHASTON_IND( $
                                       MAXIMUS__maximus, $
                                       INCLUDE_32HZ=include_32Hz, $
                                       HEMI=KEYWORD_SET(hemi__good_i) ? hemi__good_i : 'BOTH', $
                                       DESPUNDB=despunDB, $
                                       RESET_GOOD_INDS=KEYWORD_SET(swap_DBs))

  IF ~KEYWORD_SET(just_cdbTime) THEN out_maximus = MAXIMUS__maximus
  IF ~KEYWORD_SET(just_maximus) THEN out_cdbTime = MAXIMUS__times

  IF KEYWORD_SET(noMem) THEN BEGIN
     PRINT,"Unloading maximus & assoc. from memory ..." 

     UNLOAD_MAXIMUS_COMMON_VARS

  ENDIF
   
     
END