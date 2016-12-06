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
                                   USE_AACGM_COORDS=use_aacgm, $
                                   USE_GEO_COORDS=use_geo, $
                                   USE_MAG_COORDS=use_mag, $
                                   FOR_ESPEC_DBS=for_eSpec_DBs, $
                                   ;; CHECK_DB=check_DB, $
                                   JUST_FASTLOC=just_fastLoc, $
                                   JUST_TIMES=just_times, $
                                   DO_NOT_MAP_DELTA_T=do_not_map_delta_t, $
                                   NO_MEMORY_LOAD=noMem, $
                                   CLEAR_MEMORY=clear_memory, $
                                   LUN=lun

  ;;2016/11/21 As of right now there is no strong motivation to make this routine aware of the fastLoc common vars
  IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
     @common__fastloc_espec_vars.pro

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

  COMPILE_OPT idl2

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

     END
     KEYWORD_SET(for_eSpec_DBs): BEGIN
        DefDBFile     = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--smaller_datatypes--no_interval_startstop.sav'
        DefDB_tFile   = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--times.sav'
        DB_date       = '20160505'
        DB_version    = 'v0.0'
        DB_extras     = 'smaller_dataTypes/no_interval_startstop'
        defCoordDir   = defDBDir + 'alternate_coords/'
        is_128Hz      = 0
        is_noRestrict = 1

        ;;fastLoc 5--is it any better?
        DefDBDir      = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals5/'
        defDBFile     = 'fastLoc_intervals5--20161129--500-16361--Je_times.sav'
        DB_date       = '20161129'
        DB_version    = 'v0.0'
        DB_extras     = 'no_TIME_tag/no_interval_startstop'
        is_128Hz      = 0
        is_noRestrict = 1
        fastLoc_has_times = 1

        defDB_tFile  = 'fastLoc_intervals5--20161129--500-16361--Je_times--time_and_delta_t.sav'

        mapRatDir    = '/SPENCEdata/Research/database/FAST/dartdb/saves/mapratio_dbs/'
        mapRatFile   = 'mapratio_for_fastLoc_intervals5--20161129--500-16361--Je_times.sav'
     END
     ELSE: BEGIN
        DefDBFile    = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01.sav'
        DefDB_tFile  = 'fastLoc_intervals4--500-16361--below_aur_oval--20160213--times--noDupes--sample_freq_le_0.01.sav'
        DB_date      = '20160505'
        DB_version   = 'v0.0'
        DB_extras    = 'samp_t_le_0.01'
        is_128Hz     = 1

        AACGM_file   = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--AACGM_coords.sav'
        GEO_file     = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--GEO_coords.sav'
        MAG_file     = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--MAG_coords.sav'

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
  
  IF ~KEYWORD_SET(just_times) THEN BEGIN

     CASE 1 OF
        KEYWORD_SET(for_eSpec_DBs): BEGIN
           ;; IF ~KEYWORD_SET(noMem) THEN BEGIN
           IF N_ELEMENTS(FL_eSpec__fastLoc) NE 0 AND $
              N_ELEMENTS(FASTLOC_E__times)  NE 0 $
           THEN BEGIN

              IF KEYWORD_SET(noMem) THEN BEGIN
                 PRINT,"Moving fastLoc (for eSpec) structs in mem to outputted variables ..."
                 fastLoc          = TEMPORARY(FL_eSpec__fastLoc     )
                 fastLoc_times    = TEMPORARY(FASTLOC_E__times      )
                 fastloc_delta_t  = TEMPORARY(FASTLOC_E__delta_t    )
                 dbFile           = TEMPORARY(FASTLOC_E__dbFile     )
                 dbTimesFile      = TEMPORARY(FASTLOC_E__dbTimesFile)

                 RETURN
              ENDIF

              loadFL        = 0

           ENDIF ELSE BEGIN
              loadFL        = 1
           ENDELSE
           ;; ENDIF ELSE BEGIN
           ;;    loadFL           = 1
           ;; ENDELSE
        END
        ELSE: BEGIN
           IF N_ELEMENTS(FL__fastLoc) NE 0 AND $
              N_ELEMENTS(FASTLOC__times) NE 0 AND $
              N_ELEMENTS(FASTLOC__delta_t) NE 0 $
           THEN BEGIN
              IF KEYWORD_SET(noMem) THEN BEGIN
                 PRINT,"Moving fastLoc structures in mem to outputted variables ..."
                 fastLoc          = TEMPORARY(FL__fastLoc)
                 fastLoc_times    = TEMPORARY(FASTLOC__times)
                 fastloc_delta_t  = TEMPORARY(FASTLOC__delta_t)
                 dbFile           = TEMPORARY(FASTLOC__dbFile)
                 dbTimesFile      = TEMPORARY(FASTLOC__dbTimesFile)

                 RETURN
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
                                DB_DATE=DB_date, $
                                DB_VERSION=DB_version, $
                                DB_EXTRAS=DB_extras

        fastLoc.info.is_32Hz       = KEYWORD_SET(include_32Hz)
        fastLoc.info.is_128Hz      = KEYWORD_SET(is_128Hz)
        fastLoc.info.is_noRestrict = KEYWORD_SET(is_noRestrict)
        fastLoc.info.for_eSpecDB   = KEYWORD_SET(for_eSpec_DBs)

     ENDIF ELSE BEGIN
        PRINTF,lun,"There is already a fastLoc struct loaded! Not loading " + DBFile
     ENDELSE
     
  ENDIF

  IF ~KEYWORD_SET(just_fastLoc) AND KEYWORD_SET(loadFL) THEN BEGIN

     IF N_ELEMENTS(fastloc_times) EQ 0 OR KEYWORD_SET(force_load_times) THEN BEGIN
        IF KEYWORD_SET(force_load_times) THEN BEGIN
           PRINTF,lun,"Forcing load, whether or not we already have times..."
        ENDIF
        IF FILE_TEST(DBDir+DB_tFile) THEN RESTORE,DBDir+DB_tFile
        IF fastloc_times EQ !NULL THEN BEGIN
           IF KEYWORD_SET(fastLoc_has_times) THEN BEGIN
              fastLoc_times = fastLoc.x
           ENDIF ELSE BEGIN
              PRINT,"Couldn't load fastloc_times!"
              STOP
           ENDELSE
        ENDIF

        IF KEYWORD_SET(do_not_map_delta_t) THEN BEGIN
           PRINT,'Not mapping delta t for fastLoc ...'
        ENDIF ELSE BEGIN
           IF N_ELEMENTS(mapRatDir) GT 0 AND ~fastLoc.info.is_mapped THEN BEGIN
              PRINT,"Mapping fastLoc delta-ts to 100 km ..."
              RESTORE,mapRatDir+mapRatFile
              fastLoc_delta_t        = fastLoc_delta_t/SQRT((TEMPORARY(mapRatio)).ratio)
              fastLoc.info.is_mapped = 1B
           ENDIF ELSE BEGIN
              PRINT,"Can't map fastLoc delta-ts to 100 km! mapRatio DB doesn't exist .."
           ENDELSE
        ENDELSE
     ENDIF ELSE BEGIN
        PRINTF,lun,"There is already a fastloc_times struct loaded! Not loading " + DB_tFile
     ENDELSE

  ENDIF

  IF ~KEYWORD_SET(just_times) THEN BEGIN
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

     IF KEYWORD_SET(for_eSpec_DBs) AND $
        KEYWORD_SET(use_AACGM) OR KEYWORD_SET(use_GEO) OR KEYWORD_SET(use_MAG) $
     THEN BEGIN
        PRINT,'Not set up for this!!' 
        STOP
     ENDIF

     IF KEYWORD_SET(use_aacgm) THEN BEGIN
        PRINT,'Using AACGM coords ...'

        RESTORE,defCoordDir+AACGM_file

        ALFDB_SWITCH_COORDS, $
           (KEYWORD_SET(loadFL) ? fastLoc                     : $
            (KEYWORD_SET(for_eSpec_DBs) ? FL_eSpec__fastLoc : $
             FL__fastLoc       ) ), $
           FL_AACGM,'AACGM', $
           SUCCESS=success

        changedCoords = KEYWORD_SET(success)
     ENDIF

     IF KEYWORD_SET(use_GEO) THEN BEGIN
        PRINT,'Using GEO coords ...'

        RESTORE,defCoordDir+GEO_file

        ALFDB_SWITCH_COORDS, $
           (KEYWORD_SET(loadFL) ? fastLoc                     : $
            (KEYWORD_SET(for_eSpec_DBs) ? FL_eSpec__fastLoc : $
             FL__fastLoc       ) ), $
           FL_GEO, $
           'GEO', $
           SUCCESS=success

        changedCoords = KEYWORD_SET(success)
     ENDIF

     IF KEYWORD_SET(use_MAG) THEN BEGIN
        PRINT,'Using MAG coords ...'

        RESTORE,defCoordDir+MAG_file

        ALFDB_SWITCH_COORDS, $
           (KEYWORD_SET(loadFL) ? fastLoc                     : $
            (KEYWORD_SET(for_eSpec_DBs) ? FL_eSpec__fastLoc : $
             FL__fastLoc       ) ), $
           FL_MAG, $
           'MAG', $
           SUCCESS=success

        changedCoords = KEYWORD_SET(success)
     ENDIF


     IF KEYWORD_SET(changedCoords) THEN BEGIN
        LOAD_MAXIMUS_AND_CDBTIME,maximus,/CHECK_DB
        IF N_ELEMENTS(maximus) GT 0 THEN BEGIN
           CASE 1 OF
              TAG_EXIST(maximus,'coords'): BEGIN
                 IF STRLOWCASE(fastLoc.info.coords) NE STRLOWCASE(maximus.info.coords) THEN BEGIN
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
          KEYWORD_SET(just_times  )) AND $
        KEYWORD_SET(loadFL)              $
     THEN BEGIN
        FL_eSpec__fastLoc       = TEMPORARY(fastLoc        )
        FASTLOC_E__times        = TEMPORARY(fastLoc_times  )
        FASTLOC_E__delta_t      = TEMPORARY(fastloc_delta_t)
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
          KEYWORD_SET(just_times  )) AND $
        KEYWORD_SET(loadFL)              $
     THEN BEGIN
        FL__fastLoc             = TEMPORARY(fastLoc        )
        FASTLOC__times          = TEMPORARY(fastLoc_times  )
        FASTLOC__delta_t        = TEMPORARY(fastloc_delta_t)
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