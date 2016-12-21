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
                                   USE_SDT_COORDS=use_sdt, $
                                   FOR_ESPEC_DBS=for_eSpec_DBs, $
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
        SDT_file     = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--SDT_coords.sav'

        mapRatDir    = '/SPENCEdata/Research/database/FAST/dartdb/saves/mapratio_dbs/'
        mapRatFile   = 'mapratio_for_fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05.dat'

     END
     KEYWORD_SET(for_eSpec_DBs): BEGIN
        DefDBFile     = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--smaller_datatypes--no_interval_startstop.sav'
        DefDB_tFile   = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--times.sav'
        DB_date       = '20160505'
        DB_version    = 'v0.0'
        DB_extras     = 'smaller_dataTypes/no_interval_startstop'
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

        defCoordDir  = defDBDir + 'alternate_coords/'

        SDT_file     = 'fastLoc_intervals5--20161129--500-16361--Je_times--SDT_coords.sav'

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
        SDT_file     = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--SDT_coords.sav'
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
                                DB_DATE=DB_date, $
                                DB_VERSION=DB_version, $
                                DB_EXTRAS=DB_extras

        fastLoc.info.is_32Hz       = KEYWORD_SET(include_32Hz)
        fastLoc.info.is_128Hz      = KEYWORD_SET(is_128Hz)
        fastLoc.info.is_noRestrict = KEYWORD_SET(is_noRestrict)
        fastLoc.info.for_eSpecDB   = KEYWORD_SET(for_eSpec_DBs)

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
              fastLoc_times = fastLoc.x
           ENDIF ELSE BEGIN
              PRINT,"Couldn't load fastloc_times!"
              STOP
           ENDELSE

        ENDIF

        pDB__delta_t = PTR_NEW(fastLoc_delta_t)


        delta_stuff = KEYWORD_SET(load_dILAT) + KEYWORD_SET(load_dx) + KEYWORD_SET(load_dAngle)
        CASE delta_stuff OF
           0:
           1: BEGIN
              dILAT_file = GET_FAST_DB_STRING((*pDBStruct),/FOR_FASTLOC_DB) + '-delta_ilats.sav'
              RESTORE,DBDir+dILAT_file
           END
           ELSE: BEGIN
              PRINT,"Can't have it all."
              STOP
           END
        ENDCASE

        IF KEYWORD_SET(load_dILAT) THEN BEGIN
           PRINT,"Replacing fastLoc_delta_t with dILAT ..."

           ;; fastLoc_delta_t           = TEMPORARY(ABS(FLOAT(width_ILAT)))
           pDB__delta_t              = PTR_NEW(TEMPORARY(ABS(FLOAT(width_ILAT))))
           do_not_map_delta_t        = 1
           fastLoc.info.dILAT_not_dt = 1
        ENDIF

        IF KEYWORD_SET(load_dAngle) THEN BEGIN
           PRINT,"Replacing fastLoc_delta_t with dAngle ..."

           ;; fastLoc_delta_t            = TEMPORARY(ABS(FLOAT(width_angle)))
           pDB__delta_t               = PTR_NEW(TEMPORARY(ABS(FLOAT(width_angle))))
           do_not_map_delta_t         = 1
           fastLoc.info.dAngle_not_dt = 1
        ENDIF

        IF KEYWORD_SET(load_dx) THEN BEGIN
           PRINT,"Replacing fastLoc_delta_t with dx ..."

           fastLoc_delta_t           = TEMPORARY(ABS(FLOAT(width_x)))
           pDB__delta_t              = PTR_NEW(TEMPORARY(ABS(FLOAT(width_x))))
           ;; do_not_map_delta_t        = 0
           fastLoc.info.dx_not_dt    = 1
        ENDIF

        IF KEYWORD_SET(do_not_map_delta_t) THEN BEGIN
           PRINT,'Not mapping delta t for fastLoc ...'
        ENDIF ELSE BEGIN
           IF ~fastLoc.info.is_mapped THEN BEGIN
              IF FILE_TEST(mapRatDir+mapRatFile) THEN BEGIN
                 PRINT,"Mapping fastLoc delta-ts to 100 km ..."
                 RESTORE,mapRatDir+mapRatFile
                 ;; fastLoc_delta_t        = fastLoc_delta_t/SQRT((TEMPORARY(mapRatio)).ratio)
                 (*pDB__delta_t)        = (*pDB__delta_t)/SQRT((TEMPORARY(mapRatio)).ratio)
                 fastLoc.info.is_mapped = 1B
              ENDIF ELSE BEGIN
                 PRINT,"Can't map fastLoc delta-ts to 100 km! mapRatio DB doesn't exist .."
                 STOP
              ENDELSE
           ENDIF ELSE BEGIN
              PRINT,"fastLoc delta-ts are already mapped to 100 km ..."
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
              use_SDT   = 0
           END
           'GEO'  : BEGIN
              use_aacgm = 0
              use_geo   = 1
              use_mag   = 0
              use_SDT   = 0
           END
           'MAG'  : BEGIN
              use_aacgm = 0
              use_geo   = 0
              use_mag   = 1
              use_SDT   = 0
           END
           'SDT'  : BEGIN
              use_aacgm = 0
              use_geo   = 0
              use_mag   = 0
              use_SDT   = 1
           END
        ENDCASE
     ENDIF

     IF KEYWORD_SET(for_eSpec_DBs) AND $
        (KEYWORD_SET(use_AACGM) OR KEYWORD_SET(use_GEO) OR KEYWORD_SET(use_MAG)) $
     THEN BEGIN
        PRINT,'Not set up for this!!' 
        STOP
     ENDIF

     changeCoords = 0B

     IF KEYWORD_SET(use_aacgm) THEN BEGIN

        RESTORE,defCoordDir+AACGM_file

        coordName = 'AACGM'
        coordStr  = TEMPORARY(FL_AACGM)

        changeCoords = 1B
     ENDIF

     IF KEYWORD_SET(use_GEO) THEN BEGIN

        RESTORE,defCoordDir+GEO_file

        coordStr  = TEMPORARY(FL_GEO)
        coordName = 'GEO'

        changeCoords = 1B
     ENDIF

     IF KEYWORD_SET(use_MAG) THEN BEGIN

        RESTORE,defCoordDir+MAG_file

        coordName = 'MAG'
        coordStr  = TEMPORARY(FL_MAG)

        changeCoords = 1B
     ENDIF

     ;;Make sure we have SDT coords loaded if nothing else has been requested
     IF ~(KEYWORD_SET(use_AACGM) OR KEYWORD_SET(use_MAG) OR KEYWORD_SET(use_GEO)) THEN BEGIN
        IF STRUPCASE((*pDBStruct).info.coords) NE 'SDT' THEN BEGIN
           use_SDT = 1
        ENDIF 
     ENDIF

     IF KEYWORD_SET(use_SDT) THEN BEGIN

        RESTORE,defCoordDir+SDT_file

        coordName = 'SDT'
        coordStr  = TEMPORARY(FL_SDT)

        changeCoords = 1B
     ENDIF

     IF changeCoords THEN BEGIN
        ALFDB_SWITCH_COORDS, $
           (*pDBStruct), $
           coordStr,coordName, $
           SUCCESS=success

        changedCoords = KEYWORD_SET(success)
     ENDIF

     IF KEYWORD_SET(changeCoords) AND ~KEYWORD_SET(changedCoords) THEN STOP

     IF KEYWORD_SET(changedCoords) THEN BEGIN
        ;; LOAD_MAXIMUS_AND_CDBTIME,maximus,/CHECK_DB
        @common__maximus_vars.pro
        IF N_ELEMENTS(MAXIMUS__maximus) GT 0 THEN BEGIN
           CASE 1 OF
              TAG_EXIST(MAXIMUS__maximus,'coords'): BEGIN

                 ;;Get coords from the proper DB
                 ;; IF KEYWORD_SET(loadFL) THEN BEGIN
                 ;;    flCoords    = fastLoc.info.coords
                 ;; ENDIF ELSE BEGIN
                 ;;    IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
                 ;;       flCoords = FL_eSpec__fastLoc.info.coords
                 ;;    ENDIF ELSE BEGIN
                 ;;       flCoords = FL__fastLoc.info.coords
                 ;;    ENDELSE
                 ;; ENDELSE
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
        FL_eSpec__fastLoc       = TEMPORARY(*pDBStruct    )
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