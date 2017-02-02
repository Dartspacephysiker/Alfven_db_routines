;;02/01/17
PRO JOURNAL__20170201__ESPEC_GEI_GEO_MAG_CONV__FASTDB_COORDINATE_CONVERSION__PARALLEL

  COMPILE_OPT IDL2
  
  PRINT,"WAIT, You have to run JOURNAL__20170102__FASTLOC6_USING_ELECTRON_STARTSTOP_TIMES first! And before you do that, you have to clean up all the Je_times inds for orbits 16362–50000, you know"
  STOP

  outFile_pref            = 'eSpec_DB_2017??'
  dry_run                 = 0

  ;; nCPUsToRun              = 7
  ;; startCPU                = 0

  diag                    = 0 ;diagnostic mode

  check_if_exists         = 1

  create_timeStamps       = 0
  get_GEI_coords          = 0
  do_GEO_MAG_conversions  = 0
  do_AACGM_conversions    = 0
  stitch_files            = 1

  ;; test_single             = 0

  ;;Less-important options
  DBDir                   = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'
  coordDir                = DBDir + 'alternate_coords/'
  orig_routineName        = 'JOURNAL__20170201__ESPEC_GEI_GEO_MAG_CONV__FASTDB_COORDINATE_CONVERSION__PARALLEL'

  LOAD_NEWELL_ESPEC_DB,eSpec,/NO_MEMORY_LOAD,/DONT_CONVERT_TO_STRICT_NEWELL,/DONT_MAP_TO_100KM,/DONT_PERFORM_CORRECTION

  times = (TEMPORARY(eSpec)).x

  FASTDB_COORDINATE_CONVERSION__PARALLEL, $
     times, $
     NCPUSTORUN=nCPUsToRun, $
     STARTCPU=startCPU, $
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



END
JOURNAL__20170201__FASTLOC6_GEI_GEO_MAG_CONV__FASTDB_COORDINATE_CONVERSION__PARALLEL