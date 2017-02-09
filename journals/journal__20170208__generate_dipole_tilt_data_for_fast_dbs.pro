;;02/08/17
PRO JOURNAL__20170208__GENERATE_DIPOLE_TILT_DATA_FOR_FAST_DBS

  COMPILE_OPT IDL2

  
  create_timeStamps   = 0
  get_dipoleTilt_data = 0
  stitch_files        = 1

  OMNIDir         = '/SPENCEdata/Research/database/OMNI/'
  OMNIdata        = 'sw_data.dat'
  
  ;; OMNI_tStringsF  = 'SW_data--199608_through_200412-TIME.sav'

  outFile_pref    = 'sw_data--GEOPACK'

  RESTORE,OMNIDir+OMNIdata

  check_if_exists   = 1
  dry_run           = 0

  ;; nCPUsToRun     = 7
  ;; startCPU       = 2
  ;; stopCPU        = 3

  diag              = 0 ;diagnostic mode

  ;; test_single    = 0

  ;;Less-important options
  orig_routineName  = 'JOURNAL__20170208__GENERATE_DIPOLE_TILT_DATA_FOR_FAST_DBS'


  ;;times in a way that is proper for time_to_str
  t_to_1970         = 62167219200000.0000D
  times             = ((TEMPORARY(sw_data)).epoch.dat-t_to_1970)/1000.0D

  FASTDB_COORDINATE_CONVERSION__PARALLEL, $
     times, $
     NCPUSTORUN=nCPUsToRun, $
     STARTCPU=startCPU, $
     STOPCPU=stopCPU, $
     CREATE_TIMESTAMPS=create_timeStamps, $
     GET_GEI_COORDS=get_GEI_coords, $
     DO_GEO_MAG_CONVERSIONS=do_GEO_MAG_conversions, $
     DO_AACGM_CONVERSIONS=do_AACGM_conversions, $
     GET_DIPOLETILT_DATA=get_dipoleTilt_data, $
     STITCH_FILES=stitch_files, $
     ORIG_ROUTINENAME=orig_routineName, $
     COORDDIR=OMNIDir, $
     OUTFILE_PREF=outFile_pref, $
     DRY_RUN=dry_run, $
     CHECK_IF_EXISTS=check_if_exists, $
     DIAGNOSTIC=diag, $
     OK__CONTINUE_WITH_ONLY_FEW_CPUS=OK__low_CPU_number



END
