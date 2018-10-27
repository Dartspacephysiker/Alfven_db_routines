;2016/02/13 Added FORCE_LOAD keywords
PRO LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastloc_times,fastloc_delta_t, $
                                   DBDIR=DBDir, $
                                   DBFILE=DBFile, $
                                   DB_TFILE=DB_tFile, $
                                   FORCE_LOAD_FASTLOC=force_load_fastLoc, $
                                   FORCE_LOAD_TIMES=force_load_times, $
                                   FORCE_LOAD_ALL=force_load_all, $
                                   INCLUDE_32Hz=include_32Hz, $
                                   COORDINATE_SYSTEM=coordinate_system, $
                                   USE_LNG=use_lng, $
                                   USE_AACGM_COORDS=use_AACGM, $
                                   USE_GEI_COORDS=use_GEI, $
                                   USE_GEO_COORDS=use_GEO, $
                                   USE_MAG_COORDS=use_MAG, $
                                   USE_SDT_COORDS=use_SDT, $
                                   FOR_ESPEC_DBS=for_eSpec_DBs, $
                                   FOR_ESPEC__GIGANTE=for_eSpec__gigante, $
                                   FOR_ESPEC__FINAL_DB=for_eSpec__final_DB, $
                                   ;; CHECK_DB=check_DB, $
                                   JUST_FASTLOC=just_fastLoc, $
                                   JUST_TIMES=just_times, $
                                   LOAD_DELTA_ILAT_NOT_DELTA_T=load_dILAT, $
                                   LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=load_dAngle, $
                                   LOAD_DELTA_X_FOR_WIDTH_TIME=load_dx, $
                                   DO_NOT_MAP_DELTA_T=do_not_map_delta_t, $
                                   NO_MEMORY_LOAD=noMem, $
                                   CLEAR_MEMORY=clear_memory, $
                                   LUN=lun

  ;;2016/11/21 As of right now there is no strong motivation to make this routine aware of the fastLoc common vars
  IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
     @common__fastloc_espec_vars.pro

     @common__newell_espec.pro
     ;;As of 2016/12/01, these are they:
     ;; COMMON FL_ESPEC_VARS,FL_eSpec__fastLoc,FASTLOC_E__times,FASTLOC_E__delta_t, $
     ;;    FASTLOC_E__good_i,FASTLOC_E__cleaned_i,FASTLOC_E__HAVE_GOOD_I, $
     ;;    FASTLOC_E__dbFile,FASTLOC_E__dbTimesFile

  ENDIF ELSE BEGIN
     @common__fastloc_vars.pro

     ;;As of 2016/12/01, these are they:
     ;; COMMON FL_VARS, $
     ;;    FL__fastLoc, $
     ;;    FASTLOC__times, $
     ;;    FASTLOC__delta_t, $
     ;;    FASTLOC__good_i, $
     ;;    FASTLOC__cleaned_i, $
     ;;    FASTLOC__HAVE_GOOD_I, $
     ;;    FASTLOC__dbFile, $
     ;;    FASTLOC__dbTimesFile

  ENDELSE

  COMPILE_OPT idl2,strictarrsubs

  IF N_ELEMENTS(lun) EQ 0 THEN lun  = -1         ;stdout

  IF KEYWORD_SET(force_load_all) THEN BEGIN
     PRINTF,lun,"Forcing load of fastLoc and times..."
     force_load_fastLoc  = 1
     force_load_times    = 1
  ENDIF

  IF KEYWORD_SET(clear_memory) THEN BEGIN
     PRINT,'Clearing all fastLoc vars in memory ...'
     CLEAR_FL_COMMON_VARS
     CLEAR_FL_E_COMMON_VARS     
     RETURN
  ENDIF

  ;; DefDBDir        = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals2/'
  ;; DefDBFile       = 'fastLoc_intervals2--500-16361_all--20150613.sav'
  ;; DefDBFile       = 'fastLoc_intervals2--500-16361_all--w_lshell--20151015.sav'
  ;; DefDB_tFile     = 'fastLoc_intervals2--500-16361_all--20150613--times.sav'

  ;; DefDBDir        = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals3/'
  ;; DefDBFile       = 'fastLoc_intervals3--500-16361--below_aur_oval--20151020.sav'
  ;; DefDB_tFile     = 'fastLoc_intervals3--500-16361--below_aur_oval--20151020--times.sav'

  DefDBDir           = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/'
  ;; DefDBFile       = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205.sav'
  ;; DefDB_tFile     = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205--times.sav'
  ;; DefDBFile       = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205--sample_t_le_0.01.sav'
  ;; DefDB_tFile     = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205--times--sample_t_le_0.01.sav'

  ;; DefDBFile       = 'fastLoc_intervals4--500-16361--below_aur_oval--20160213--noDupes--sample_freq_le_0.01.sav'

  defCoordDir        = defDBDir + 'alternate_coords/'
  CASE 1 OF
     KEYWORD_SET(include_32Hz): BEGIN
        DefDBFile    = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05.sav'
        DefDB_tFile  = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--times.sav'
        DB_date      = '20160505'
        DB_version   = 'v0.0'
        DB_extras    = 'samp_t_le_0.05'

        AACGM_file   = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--AACGM_coords.sav'
        GEO_file     = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--GEO_coords.sav'
        MAG_file     = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--MAG_coords.sav'
        SDT_file     = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--SDT_coords.sav'

        mapRatDir    = '/SPENCEdata/Research/database/FAST/dartdb/saves/mapratio_dbs/'
        mapRatFile   = 'mapratio_for_fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05.dat'

     END
     KEYWORD_SET(for_eSpec_DBs): BEGIN
        ;; DefDBFile     = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--smaller_datatypes--no_interval_startstop.sav'
        ;; DefDB_tFile   = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--times.sav'
        ;; DB_date       = '20160505'
        ;; DB_version    = 'v0.0'
        ;; DB_extras     = 'smaller_dataTypes/no_interval_startstop'
        ;; is_128Hz      = 0
        ;; is_noRestrict = 1

        CASE 1 OF
           KEYWORD_SET(for_eSpec__gigante): BEGIN

              ;;fastLoc 6--is it any better?
              DefDBDir      = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals6/'
              defDBFile     = 'fastLoc_intervals6--20170208--500-25007--Je_times.sav'
              defDB_tFile   = 'fastLoc_intervals6--20170208--500-25007--Je_times--time_and_delta_t.sav'
              DB_date       = '20170208'
              DB_version    = 'v0.0'
              DB_extras     = 'no_TIME_tag/no_interval_startstop/gigante'
              is_128Hz      = 0
              is_noRestrict = 1
              is_gigante    = 1
              fastLoc_has_times = 1

              GEI_file      = 'fastLocDB-20170208_v0_0--no_TIME_tag--no_interval_startstop--gigante-GEI.sav'
              GEO_file      = 'fastLocDB-20170208_v0_0--no_TIME_tag--no_interval_startstop--gigante-GEO.sav'
              MAG_file      = 'fastLocDB-20170208_v0_0--no_TIME_tag--no_interval_startstop--gigante-MAG.sav'
              SDT_file      = 'fastLocDB-20170208_v0_0--no_TIME_tag--no_interval_startstop--gigante-SDT.sav'

              mapRatDir     = defDBDir
              mapRatFile    = 'fastLoc_intervals6--20170208--500-25007--Je_times--mapRatio.sav'

           END
           KEYWORD_SET(for_eSpec__final_DB): BEGIN
              PRINT,"Using eSpec__final_DB sin allerede eksisterende info!"

              fastLoc = { $
                        orbit     : NEWELL__eSpec.orbit , $   
                        x         : NEWELL__eSpec.x     , $    
                        alt       : NEWELL__eSpec.alt   , $     
                        mlt       : NEWELL__eSpec.mlt   , $     
                        ilat      : NEWELL__eSpec.ilat  , $    
                        sample_t  : NEWELL__delta_t     }

              is_final      = 1

              do_not_map_delta_t = NEWELL__eSpec.info.dt_is_mapped

              DefDBDir      = NEWELL__eSpec.info.DB_dir
              defDBFile     = 'NEWELL__eSpec'
              defDB_tFile   = 'NEWELL__eSpec'
              DB_date       = NEWELL__eSpec.info.DB_date
              DB_version    = NEWELL__eSpec.info.DB_version
              DB_extras     = NEWELL__eSpec.info.DB_extras
              is_128Hz      = 0
              is_noRestrict = 1
              fastLoc_has_times = 1

              AACGM_file    = "BLAH"
              AACGM_file    = "BLAH"
              GEI_file      = "BLAH"
              GEO_file      = "BLAH"
              MAG_file      = "BLAH"
              SDT_file      = "BLAH"

              mapRatDir     = 'NEWELL__eSpec'
              mapRatFile    = 'NEWELL__eSpec'

           END
           ELSE: BEGIN
              ;;fastLoc 5--is it any better?
              DefDBDir      = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals5/'
              defDBFile     = 'fastLoc_intervals5--20161129--500-16361--Je_times.sav'
              defDB_tFile   = 'fastLoc_intervals5--20161129--500-16361--Je_times--time_and_delta_t.sav'
              DB_date       = '20161129'
              DB_version    = 'v0.0'
              DB_extras     = 'no_TIME_tag/no_interval_startstop'
              is_128Hz      = 0
              is_noRestrict = 1
              fastLoc_has_times = 1

              AACGM_file    = 'fastLoc_intervals5--20161129--500-16361--Je_times--AACGM_coords.sav'
              AACGM_file    = 'fastLoc_intervals5-AACGM.sav'
              GEI_file      = 'fastLoc_intervals5--20161129--500-16361--Je_times-GEI.sav'
              GEO_file      = 'fastLoc_intervals5--20161129--500-16361--Je_times-GEO.sav'
              MAG_file      = 'fastLoc_intervals5--20161129--500-16361--Je_times-MAG.sav'
              SDT_file      = 'fastLoc_intervals5--20161129--500-16361--Je_times-SDT.sav'

              mapRatDir     = '/SPENCEdata/Research/database/FAST/dartdb/saves/mapratio_dbs/'
              mapRatFile    = 'mapratio_for_fastLoc_intervals5--20161129--500-16361--Je_times.sav'
           END
        ENDCASE

        defCoordDir   = defDBDir + 'alternate_coords/'

     END
     ELSE: BEGIN
        DefDBFile    = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01.sav'
        DefDB_tFile  = 'fastLoc_intervals4--500-16361--below_aur_oval--20160213--times--noDupes--sample_freq_le_0.01.sav'
        DB_date      = '20160505'
        DB_version   = 'v0.0'
        DB_extras    = 'samp_t_le_0.01'
        is_128Hz     = 1

        ;;someday, this is the corresponding string: 'fastLocDB-20160505_v0_0--samp_t_le_0.01'
        ;; AACGM_file   = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--AACGM_coords.sav'
        ;; GEO_file     = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--GEO_coords.sav'
        ;; MAG_file     = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--MAG_coords.sav'
        AACGM_file   = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--AACGM_coords.sav'
        GEI_file     = 'fastLocDB-20160505_v0_0--samp_t_le_0.01-GEI.sav'
        GEO_file     = 'fastLocDB-20160505_v0_0--samp_t_le_0.01-GEO.sav'
        MAG_file     = 'fastLocDB-20160505_v0_0--samp_t_le_0.01-MAG.sav'
        SDT_file     = 'fastLocDB-20160505_v0_0--samp_t_le_0.01-SDT.sav'
        mapRatDir    = '/SPENCEdata/Research/database/FAST/dartdb/saves/mapratio_dbs/'
        mapRatFile   = 'mapratio_for_fastLoc_intervals4--500-16361--below_aur_oval--20160213--times--noDupes--sample_freq_le_0.01.dat'
     END
  ENDCASE

  ;; IF KEYWORD_SET(check_DB) THEN BEGIN
  ;;    out_maximus  = N_ELEMENTS(MAXIMUS__maximus)     GT 0 ? MAXIMUS__maximus     : !NULL
  ;;    out_cdbTime  = N_ELEMENTS(MAXIMUS__times)       GT 0 ? MAXIMUS__times       : !NULL
  ;;    good_i       = N_ELEMENTS(MAXIMUS__good_i)      GT 0 ? MAXIMUS__good_i      : !NULL
  ;;    DBFile       = N_ELEMENTS(MAXIMUS__dbFile)      GT 0 ? MAXIMUS__dbFile      : !NULL
  ;;    DB_tFile     = N_ELEMENTS(MAXIMUS__dbTimesFile) GT 0 ? MAXIMUS__dbTimesFile : !NULL
  ;;    DBDir        = N_ELEMENTS(MAXIMUS__dbDir)       GT 0 ? MAXIMUS__dbDir       : !NULL
  ;;    despunDB     = N_ELEMENTS(MAXIMUS__despun)      GT 0 ? MAXIMUS__despun      : !NULL
  ;;    chastDB      = N_ELEMENTS(MAXIMUS__is_chastDB)  GT 0 ? MAXIMUS__is_chastDB  : !NULL

  ;;    RETURN
  ;; ENDIF

  IF N_ELEMENTS(DBDir) EQ 0 THEN BEGIN
     DBDir     = DefDBDir
  ENDIF

  IF N_ELEMENTS(DBFile) EQ 0 THEN BEGIN
     DBFile    = DefDBFile
  ENDIF

  IF N_ELEMENTS(DB_tFile) EQ 0 THEN BEGIN
     DB_tFile  = DefDB_tFile
  ENDIF
  
  CASE 1 OF
     KEYWORD_SET(for_eSpec_DBs): BEGIN
        ;; IF ~KEYWORD_SET(noMem) THEN BEGIN
        IF N_ELEMENTS(FL_eSpec__fastLoc)  NE 0 AND $
           N_ELEMENTS(FASTLOC_E__times)   NE 0 AND $
           N_ELEMENTS(FASTLOC_E__delta_t) NE 0 AND $
           ~KEYWORD_SET(force_load_fastLoc)        $
        THEN BEGIN

           IF KEYWORD_SET(noMem) THEN BEGIN
              PRINT,"Moving fastLoc (for eSpec) structs in mem to outputted variables ..."
              IF ~KEYWORD_SET(just_times) THEN fastLoc = TEMPORARY(FL_eSpec__fastLoc     )
              fastLoc_times    = TEMPORARY(FASTLOC_E__times      )
              fastloc_delta_t  = TEMPORARY(FASTLOC_E__delta_t    )
              dbFile           = TEMPORARY(FASTLOC_E__dbFile     )
              dbTimesFile      = TEMPORARY(FASTLOC_E__dbTimesFile)

              RETURN
           ENDIF

           IF ~KEYWORD_SET(just_times) THEN BEGIN
              pDBStruct        = PTR_NEW(FL_eSpec__fastLoc)
              pDB__delta_t     = PTR_NEW(FASTLOC_E__delta_t)
           ENDIF

           loadFL              = 0

        ENDIF ELSE BEGIN
           loadFL              = 1
        ENDELSE
     END
     ELSE: BEGIN
        IF N_ELEMENTS(FL__fastLoc) NE 0 AND      $
           N_ELEMENTS(FASTLOC__times) NE 0 AND   $
           N_ELEMENTS(FASTLOC__delta_t) NE 0 AND $
           ~KEYWORD_SET(force_load_fastLoc)      $
        THEN BEGIN
           IF KEYWORD_SET(noMem) THEN BEGIN
              PRINT,"Moving fastLoc structures in mem to outputted variables ..."
              IF ~KEYWORD_SET(just_times) THEN fastLoc = TEMPORARY(FL__fastLoc)
              fastLoc_times    = TEMPORARY(FASTLOC__times)
              fastloc_delta_t  = TEMPORARY(FASTLOC__delta_t)
              dbFile           = TEMPORARY(FASTLOC__dbFile)
              dbTimesFile      = TEMPORARY(FASTLOC__dbTimesFile)

              RETURN
           ENDIF

           IF ~KEYWORD_SET(just_times) THEN BEGIN
              pDBStruct     = PTR_NEW(FL__fastLoc)
              pDB__delta_t  = PTR_NEW(FASTLOC__delta_t)
           ENDIF

           loadFL           = 0

        ENDIF ELSE BEGIN
           loadFL           = 1
        ENDELSE
     END
  ENDCASE

  ;; IF N_ELEMENTS(fastLoc) EQ 0 OR KEYWORD_SET(force_load_fastLoc) THEN BEGIN
  IF KEYWORD_SET(loadFL) OR KEYWORD_SET(force_load_fastLoc) THEN BEGIN
     IF KEYWORD_SET(force_load_fastLoc) THEN BEGIN
        PRINTF,lun,"Forcing load, whether or not we already have fastLoc..."
     ENDIF
     IF FILE_TEST(DBDir+DBFile) THEN RESTORE,DBDir+DBFile
     IF fastLoc EQ !NULL THEN BEGIN
        PRINT,"Couldn't load fastLoc!"
        STOP
     ENDIF

     FASTDB__ADD_INFO_STRUCT,fastLoc, $
                             /FOR_FASTLOC, $
                             DB_DIR=DBDir, $
                             DB_DATE=DB_date, $
                             DB_VERSION=DB_version, $
                             DB_EXTRAS=DB_extras

     fastLoc.info.is_32Hz       = KEYWORD_SET(include_32Hz)
     fastLoc.info.is_128Hz      = KEYWORD_SET(is_128Hz)
     fastLoc.info.is_noRestrict = KEYWORD_SET(is_noRestrict)
     fastLoc.info.is_gigante    = KEYWORD_SET(is_gigante)
     fastLoc.info.is_espec_final= KEYWORD_SET(is_final)
     fastLoc.info.for_eSpecDB   = KEYWORD_SET(for_eSpec_DBs)

     IF KEYWORD_SET(is_final) THEN BEGIN
        fastLoc.info.is_mapped = NEWELL__eSpec.info.dt_is_mapped
     ENDIF

     pDBStruct                  = PTR_NEW(fastLoc)

  ENDIF ELSE BEGIN
     PRINTF,lun,"There is already a fastLoc struct loaded! Not loading " + DBFile
  ENDELSE

  IF ~KEYWORD_SET(just_fastLoc) AND KEYWORD_SET(loadFL) THEN BEGIN

     IF N_ELEMENTS(fastloc_times) EQ 0 OR KEYWORD_SET(force_load_times) THEN BEGIN

        IF KEYWORD_SET(force_load_times) THEN BEGIN
           PRINTF,lun,"Forcing load, whether or not we already have times..."
        ENDIF

        IF FILE_TEST(DBDir+DB_tFile) THEN RESTORE,DBDir+DB_tFile

        IF fastloc_times EQ !NULL THEN BEGIN
           IF KEYWORD_SET(fastLoc_has_times) THEN BEGIN
              fastLoc_times = (*pDBStruct).x
           ENDIF ELSE BEGIN
              PRINT,"Couldn't load fastloc_times!"
              STOP
           ENDELSE

        ENDIF

        CASE 1 OF
           KEYWORD_SET(is_final): BEGIN
              pDB__delta_t = PTR_NEW(NEWELL__eSpec.tDiffs)
           END
           ELSE: BEGIN
              pDB__delta_t = PTR_NEW(fastLoc_delta_t)
           END
        ENDCASE

        FASTDBS__DELTA_SWITCHER,dbStruct, $
                                OUT_WIDTH_MEASURE=width_measure, $
                                DBDIR=DBDir, $
                                LOAD_DELTA_T=load_delta_t, $
                                LOAD_DELTA_ILAT_NOT_DELTA_T=load_dILAT, $
                                LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=load_dAngle, $
                                LOAD_DELTA_X_FOR_WIDTH_TIME=load_dx, $
                                DO_NOT_MAP_DELTA_T=do_not_map_delta_t, $
                                DILAT_FILE=dILAT_file, $
                                ;; FOR_ALFDB=alfDB, $
                                /FOR_FASTLOC_DB
                                ;; FOR_ESPEC_DB=eSpecDB, $
                                ;; FOR_ION_DB=ionDB


        IF N_ELEMENTS(width_measure) GT 0 THEN BEGIN
           pDB__delta_t = PTR_NEW(TEMPORARY(ABS(width_measure)))
        ENDIF

        ;; delta_stuff = KEYWORD_SET(load_dILAT) + KEYWORD_SET(load_dx) + KEYWORD_SET(load_dAngle)
        ;; CASE delta_stuff OF
        ;;    0:
        ;;    1: BEGIN
        ;;       dILAT_file = GET_FAST_DB_STRING((*pDBStruct),/FOR_FASTLOC_DB) + '-delta_ilats.sav'
        ;;       RESTORE,DBDir+dILAT_file
        ;;    END
        ;;    ELSE: BEGIN
        ;;       PRINT,"Can't have it all."
        ;;       STOP
        ;;    END
        ;; ENDCASE

        ;; IF KEYWORD_SET(load_dILAT) THEN BEGIN
        ;;    PRINT,"Replacing fastLoc_delta_t with dILAT ..."

        ;;    ;; fastLoc_delta_t           = TEMPORARY(ABS(FLOAT(width_ILAT)))
        ;;    pDB__delta_t              = PTR_NEW(TEMPORARY(ABS(FLOAT(width_ILAT))))
        ;;    do_not_map_delta_t        = 1
        ;;    fastLoc.info.dILAT_not_dt = 1
        ;; ENDIF

        ;; IF KEYWORD_SET(load_dAngle) THEN BEGIN
        ;;    PRINT,"Replacing fastLoc_delta_t with dAngle ..."

        ;;    ;; fastLoc_delta_t            = TEMPORARY(ABS(FLOAT(width_angle)))
        ;;    pDB__delta_t               = PTR_NEW(TEMPORARY(ABS(FLOAT(width_angle))))
        ;;    do_not_map_delta_t         = 1
        ;;    fastLoc.info.dAngle_not_dt = 1
        ;; ENDIF

        ;; IF KEYWORD_SET(load_dx) THEN BEGIN
        ;;    PRINT,"Replacing fastLoc_delta_t with dx ..."

        ;;    ;; fastLoc_delta_t           = TEMPORARY(ABS(FLOAT(width_x)))
        ;;    pDB__delta_t              = PTR_NEW(TEMPORARY(ABS(FLOAT(width_x))))
        ;;    ;; do_not_map_delta_t        = 0
        ;;    fastLoc.info.dx_not_dt    = 1
        ;; ENDIF


        IF KEYWORD_SET(do_not_map_delta_t) THEN BEGIN
           PRINT,'Not mapping delta t for fastLoc ...'
        ENDIF ELSE BEGIN

           IF ~(*pDBStruct).info.is_mapped THEN BEGIN

              IF FILE_TEST(mapRatDir+mapRatFile) THEN BEGIN
                 PRINT,"Mapping fastLoc delta-ts to 100 km ..."
                 RESTORE,mapRatDir+mapRatFile
              ENDIF ELSE IF KEYWORD_SET(is_final) THEN BEGIN
                 mapRatio = NEWELL__eSpec.mapFactor
              ENDIF ELSE BEGIN
                 PRINT,"Can't map fastLoc delta-ts to 100 km! mapRatio DB doesn't exist .."
                 STOP
              ENDELSE
              
              ;; fastLoc_delta_t        = fastLoc_delta_t/SQRT((TEMPORARY(mapRatio)).ratio)
              CASE 1 OF
                 LONG(fastloc.info.db_date) GE 20170204: BEGIN
                    IF N_ELEMENTS(mapRatio) NE N_ELEMENTS(*pDB__delta_t) THEN STOP
                    (*pDB__delta_t)  = (*pDB__delta_t)/SQRT(TEMPORARY(mapRatio))
                 END
                 ELSE: BEGIN
                    (*pDB__delta_t)  = (*pDB__delta_t)/SQRT((TEMPORARY(mapRatio)).ratio)
                 END
              ENDCASE
              (*pDBStruct).info.is_mapped = 1B

           ENDIF ELSE BEGIN
              PRINT,"fastLoc delta-ts are already mapped to 100 km ..."
           ENDELSE
        ENDELSE
     ENDIF ELSE BEGIN
        PRINTF,lun,"There is already a fastloc_times struct loaded! Not loading " + DB_tFile
     ENDELSE

  ENDIF

  IF ~KEYWORD_SET(just_times) THEN BEGIN

     FASTDBS__COORDINATE_SWITCHER, $
        (*pDBStruct), $
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
        NO_MEMORY_LOAD=noMem, $
        CHANGEDCOORDS=changedCoords

     ;; IF KEYWORD_SET(coordinate_system) THEN BEGIN
     ;;    CASE STRUPCASE(coordinate_system) OF
     ;;       'AACGM': BEGIN
     ;;          use_AACGM = 1
     ;;          use_GEI   = 0
     ;;          use_GEO   = 0
     ;;          use_MAG   = 0
     ;;          use_SDT   = 0
     ;;       END
     ;;       'GEI'  : BEGIN
     ;;          use_AACGM = 0
     ;;          use_GEI   = 1
     ;;          use_GEO   = 0
     ;;          use_MAG   = 0
     ;;          use_SDT   = 0
     ;;       END
     ;;       'GEO'  : BEGIN
     ;;          use_AACGM = 0
     ;;          use_GEI   = 0
     ;;          use_GEO   = 1
     ;;          use_MAG   = 0
     ;;          use_SDT   = 0
     ;;       END
     ;;       'MAG'  : BEGIN
     ;;          use_AACGM = 0
     ;;          use_GEI   = 0
     ;;          use_GEO   = 0
     ;;          use_MAG   = 1
     ;;          use_SDT   = 0
     ;;       END
     ;;       'SDT'  : BEGIN
     ;;          use_AACGM = 0
     ;;          use_GEI   = 0
     ;;          use_GEO   = 0
     ;;          use_MAG   = 0
     ;;          use_SDT   = 1
     ;;       END
     ;;    ENDCASE
     ;; ENDIF

     ;; IF KEYWORD_SET(for_eSpec_DBs) AND KEYWORD_SET(use_AACGM) $
     ;; THEN BEGIN
     ;;    PRINT,'Not set up for this!!' 
     ;;    STOP
     ;; ENDIF


     ;; changeCoords = 0B

     ;; IF KEYWORD_SET(use_AACGM) THEN BEGIN

     ;;    RESTORE,defCoordDir+AACGM_file

     ;;    coordName = 'AACGM'
     ;;    coordStr  = TEMPORARY(AACGM)

     ;;    changeCoords = 1B
     ;; ENDIF

     ;; IF KEYWORD_SET(use_GEI) THEN BEGIN

     ;;    RESTORE,defCoordDir+GEI_file

     ;;    coordStr  = TEMPORARY(GEI)
     ;;    coordName = 'GEI'

     ;;    changeCoords = 1B
     ;; ENDIF

     ;; IF KEYWORD_SET(use_GEO) THEN BEGIN

     ;;    RESTORE,defCoordDir+GEO_file

     ;;    coordStr  = TEMPORARY(GEO)
     ;;    coordName = 'GEO'

     ;;    changeCoords = 1B
     ;; ENDIF

     ;; IF KEYWORD_SET(use_MAG) THEN BEGIN

     ;;    RESTORE,defCoordDir+MAG_file

     ;;    coordName = 'MAG'
     ;;    coordStr  = TEMPORARY(MAG)

     ;;    changeCoords = 1B
     ;; ENDIF

     ;; ;;Make sure we have SDT coords loaded if nothing else has been requested
     ;; IF ~(KEYWORD_SET(use_AACGM) OR KEYWORD_SET(use_MAG) OR KEYWORD_SET(use_GEO)) THEN BEGIN
     ;;    IF STRUPCASE((*pDBStruct).info.coords) NE 'SDT' THEN BEGIN
     ;;       use_SDT = 1
     ;;    ENDIF 
     ;; ENDIF

     ;; IF KEYWORD_SET(use_SDT) THEN BEGIN

     ;;    RESTORE,defCoordDir+SDT_file

     ;;    coordName = 'SDT'
     ;;    coordStr  = TEMPORARY(SDT)

     ;;    changeCoords = 1B
     ;; ENDIF

     ;; IF changeCoords THEN BEGIN
     ;;    ALFDB_SWITCH_COORDS, $
     ;;       (*pDBStruct), $
     ;;       coordStr,coordName, $
     ;;       SUCCESS=success

     ;;    changedCoords = KEYWORD_SET(success)
     ;; ENDIF

     ;; IF KEYWORD_SET(use_lng) THEN BEGIN
     ;;    index = -1
     ;;    STR_ELEMENT,(*pDBStruct),'lng',INDEX=index
     ;;    IF index NE -1 THEN BEGIN
     ;;       flip = WHERE((*pDBStruct).lng LT 0.)
     ;;       IF flip[0] NE -1 THEN BEGIN
     ;;          (*pDBStruct).lng[flip] += 360.
     ;;       ENDIF
     ;;    ENDIF
     ;; ENDIF

     ;; IF KEYWORD_SET(changeCoords) AND ~KEYWORD_SET(changedCoords) THEN STOP

     IF KEYWORD_SET(changedCoords) THEN BEGIN
        ;; LOAD_MAXIMUS_AND_CDBTIME,maximus,/CHECK_DB
        @common__maximus_vars.pro
        IF N_ELEMENTS(MAXIMUS__maximus) GT 0 THEN BEGIN
           CASE 1 OF
              TAG_EXIST(MAXIMUS__maximus,'coords'): BEGIN

                 ;;Get coords from the proper DB
                 flCoords = (*pDBStruct).info.coords

                 IF STRLOWCASE(flCoords) NE $
                    STRLOWCASE(MAXIMUS__maximus.info.coords) $
                 THEN BEGIN
                    PRINT,'Mismatched coordinate systems!'
                    STOP
                 ENDIF 
              END
              ELSE: BEGIN
                 PRINT,'Maximus coordinates have not been changed!'
                 STOP
              END
           ENDCASE
        ENDIF 
     ENDIF

  ENDIF
  
  ;;Now put 'em in
  IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
     ;; IF ~KEYWORD_SET(noMem) THEN BEGIN
     IF ~(KEYWORD_SET(noMem       )  OR  $
          KEYWORD_SET(just_fastLoc)  OR  $
          KEYWORD_SET(just_times  ))     $ ;AND $
        ;; KEYWORD_SET(loadFL)              $
     THEN BEGIN
        FL_eSpec__fastLoc       = TEMPORARY(*pDBStruct     )
        FASTLOC_E__times        = TEMPORARY(fastLoc_times  )
        FASTLOC_E__delta_t      = TEMPORARY(*pDB__delta_t  )
        FASTLOC_E__dbFile       = TEMPORARY(dbFile         )
        FASTLOC_E__dbTimesFile  = TEMPORARY(dbTimesFile    )

        ;; FL_eSpec__fastLoc       = fastLoc
        ;; FASTLOC_E__times        = fastLoc_times
        ;; FASTLOC_E__delta_t      = fastloc_delta_t
        ;; FASTLOC_E__dbFile       = dbFile
        ;; FASTLOC_E__dbTimesFile  = dbTimesFile
     ENDIF
  ENDIF ELSE BEGIN
     IF ~(KEYWORD_SET(noMem       )  OR  $
          KEYWORD_SET(just_fastLoc)  OR  $
          KEYWORD_SET(just_times  ))     $
     THEN BEGIN
        FL__fastLoc             = TEMPORARY(*pDBStruct     )
        FASTLOC__times          = TEMPORARY(fastLoc_times  )
        FASTLOC__delta_t        = TEMPORARY(*pDB__delta_t  )
        FASTLOC__dbFile         = TEMPORARY(dbFile         )
        FASTLOC__dbTimesFile    = TEMPORARY(dbTimesFile    )

        ;; FL__fastLoc             = fastLoc
        ;; FASTLOC__times          = fastLoc_times
        ;; FASTLOC__delta_t        = fastloc_delta_t
        ;; FASTLOC__dbFile         = dbFile
        ;; FASTLOC__dbTimesFile    = dbTimesFile
     ENDIF
  ENDELSE

  ;;Not presently used ...
  ;; IF KEYWORD_SET(noMem) THEN BEGIN
  ;;    PRINT,"Unloading fastLoc & assoc. from memory ..." 

  ;;    CLEAR_FL_COMMON_VARS

  ;; ENDIF


END
