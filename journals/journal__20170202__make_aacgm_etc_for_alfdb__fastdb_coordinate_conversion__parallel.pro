;;2017/02/02
PRO JOURNAL__20170202__MAKE_AACGM_ETC_FOR_ALFDB__FASTDB_COORDINATE_CONVERSION__PARALLEL

  COMPILE_OPT IDL2

  outFile_pref            = '--20161129--500-16361--Je_times'
  dry_run                 = 0

  ;; nCPUsToRun              = 7
  ;; startCPU                = 0

  diag                    = 0 ;diagnostic mode

  create_timeStamps       = 0
  get_GEI_coords          = 0
  do_GEO_MAG_conversions  = 0
  do_AACGM_conversions    = 0
  stitch_files            = 1

  ;; test_single             = 0

  ;;Less-important options
  DBDir                   = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals5/'
  coordDir                = DBDir + 'alternate_coords/'
  orig_routineName        = 'JOURNAL__20161220__MAKE_AACGM_ETC_FOR_FASTLOC_5'

  LOAD_MAXI,!NULL,times, $
                                 /FOR_ESPEC_DBS, $
                                 /NO_MEMORY_LOAD, $
                                 /JUST_TIMES, $
                                 /DO_NOT_MAP_DELTA_T


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

