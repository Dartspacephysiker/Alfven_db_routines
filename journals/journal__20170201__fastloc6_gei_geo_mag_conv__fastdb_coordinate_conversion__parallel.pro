;;2017/02/04
PRO JOURNAL__20170201__FASTLOC6_GEI_GEO_MAG_CONV__FASTDB_COORDINATE_CONVERSION__PARALLEL

  COMPILE_OPT IDL2

  check_if_exists         = 1

  for_eSpec_DBs           = 1
  CASE 1 OF
     KEYWORD_SET(for_eSpec_DBs): BEGIN
        ;; outFile_pref      = 'fastLoc_intervals6--20170208--500-25007--Je_times'
        outFile_pref      = 'fastLocDB-20170208_v0_0--no_TIME_tag--no_interval_startstop'
        DBDir             = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals6/'
     END
     ELSE: BEGIN
        outFile_pref      = 'fastLocDB-20160505_v0_0--samp_t_le_0.01'
        DBDir             = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/'
     END
  ENDCASE
  dry_run                 = 0

  ;; nCPUsToRun              = 7
  ;; startCPU                = 2
  ;; stopCPU                 = 3

  diag                    = 0 ;diagnostic mode

  create_timeStampsArr      = [1,0,0,0]
  get_GEI_coordsArr         = [0,1,0,0]
  do_GEO_MAG_conversionsArr = [0,0,1,0]
  do_AACGM_conversionsArr   = [0,0,0,0]
  stitch_filesArr           = [0,0,0,1]

  ;; test_single             = 0

  ;;Less-important options
  coordDir                = DBDir + 'alternate_coords/'
  orig_routineName        = 'JOURNAL__20170201__FASTLOC6_GEI_GEO_MAG_CONV__FASTDB_COORDINATE_CONVERSION__PARALLEL'

  LOAD_FASTLOC_AND_FASTLOC_TIMES,!NULL,times, $
                                 FOR_ESPEC_DBS=for_eSpec_DBs, $
                                 /NO_MEMORY_LOAD, $
                                 /JUST_TIMES, $
                                 /DO_NOT_MAP_DELTA_T

  nThang = N_ELEMENTS(create_timeStampsArr)
  FOR k=0,nThang-1 DO BEGIN

     ;;set 'er up
     create_timeStamps       = create_timeStampsArr[k]
     get_GEI_coords          = get_GEI_coordsArr[k]
     do_GEO_MAG_conversions  = do_GEO_MAG_conversionsArr[k]
     do_AACGM_conversions    = do_AACGM_conversionsArr[k]
     stitch_files            = stitch_filesArr[k]

     PRINT,""
     PRINT,"ITERATION ",k
     PRINT,'create_timeStamps     ',create_timeStamps
     PRINT,'get_GEI_coords        ',get_GEI_coords
     PRINT,'do_GEO_MAG_conversions',do_GEO_MAG_conversions
     PRINT,'do_AACGM_conversions  ',do_AACGM_conversions
     PRINT,'stitch_files          ',stitch_files

     FASTDB_COORDINATE_CONVERSION__PARALLEL, $
        times, $
        NCPUSTORUN=nCPUsToRun, $
        STARTCPU=startCPU, $
        STOPCPU=stopCPU, $
        CREATE_TIMESTAMPS=create_timeStamps, $
        GET_GEI_COORDS=get_GEI_coords, $
        DO_GEO_MAG_CONVERSIONS=do_GEO_MAG_conversions, $
        DO_AACGM_CONVERSIONS=do_AACGM_conversions, $
        STITCH_FILES=stitch_files, $
        ORIG_ROUTINENAME=orig_routineName, $
        COORDDIR=coordDir, $
        OUTFILE_PREF=outFile_pref, $
        DRY_RUN=dry_run, $
        CHECK_IF_EXISTS=check_if_exists, $
        DIAGNOSTIC=diag, $
        OK__CONTINUE_WITH_ONLY_FEW_CPUS=OK__low_CPU_number

  ENDFOR


END
