;;12/20/16
PRO JOURNAL__20161220__MAKE_AACGM_ETC_FOR_FASTLOC_5

  COMPILE_OPT IDL2

  outFile_pref            = 'fastLoc_intervals5'
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

  LOAD_FASTLOC_AND_FASTLOC_TIMES,!NULL,times, $
                                 /FOR_ESPEC_DBS, $
                                 /NO_MEMORY_LOAD, $
                                 /JUST_TIMES


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

  ;; IF KEYWORD_SET(test_single) THEN BEGIN

  ;;    tmpInds     = [0:1980335]
  ;;    tmpFile     = "TMP_fastLoc_intervals5-0--0-1980335"
  ;;    outFile     = "fastLoc_intervals5-AACGM-0--0-1980335"
  ;;    timeFile    = "fastLoc_intervals5-TIME_STRINGS-0--0-1980335"
  ;;    GEI_File    = "fastLoc_intervals5-GEI-0--0-1980335"
  ;;    GEO_MAGFile = "fastLoc_intervals5-GEO_MAG-0--0-1980335"

  ;;    FASTDB_COORDINATE_CONVERSION__SINGLE,times[tmpInds], $
  ;;                                        CREATE_TIMESTAMPS=create_timeStamps, $
  ;;                                        GET_GEI_COORDS=get_GEI_coords, $
  ;;                                        DO_GEO_MAG_CONVERSIONS=do_GEO_MAG_conversions, $
  ;;                                        DO_AACGM_CONVERSIONS=do_AACGM_conversions, $
  ;;                                        ORIG_ROUTINENAME=orig_routineName, $
  ;;                                        COORDFILE=GEO_MAGFile, $
  ;;                                        GEI_COORD_FILENAME=GEI_file, $
  ;;                                        COORDDIR=coordDir, $
  ;;                                        TIMEFILE=timeFile, $
  ;;                                        EPHEMFILEINDARR=ephemFileIndArr, $
  ;;                                        TMPFILE=tmpFile, $
  ;;                                        OUTFILE=outFile, $
  ;;                                        R_E=R_E, $
  ;;                                        ALTITUDE_MAX=altitude_max, $
  ;;                                        ALLOW_FL_TRACE=allow_FL_trace, $
  ;;                                        CHECK_IF_EXISTS=check_if_exists, $
  ;;                                        CREATE_NOTALTITUDE_FILE=create_notAltitude_file, $
  ;;                                        NOTALTITUDE_SUFF=notAltitude_suff, $
  ;;                                        CONVERT_VARNAMES_AND_RESAVE_OUTFILES=convert_varNames_and_resave_outFiles, $
  ;;                                        FORCE_NEWCHECKITVL=force_newCheckItvl, $
  ;;                                        USER__RESTRICT_II=user__restrict_i, $
  ;;                                        IN_NAMES=in_names, $
  ;;                                        DEFNAMES=defNames

  ;; ENDIF ELSE BEGIN

  ;;    FASTDB_COORDINATE_CONVERSION__PARALLEL, $
  ;;       times, $
  ;;       NCPUSTORUN=nCPUsToRun, $
  ;;       STARTCPU=startCPU, $
  ;;       CREATE_TIMESTAMPS=create_timeStamps, $
  ;;       GET_GEI_COORDS=get_GEI_coords, $
  ;;       DO_GEO_MAG_CONVERSIONS=do_GEO_MAG_conversions, $
  ;;       DO_AACGM_CONVERSIONS=do_AACGM_conversions, $
  ;;       ORIG_ROUTINENAME=orig_routineName, $
  ;;       COORDDIR=coordDir, $
  ;;       OUTFILE_PREF=outFile_pref, $
  ;;       DRY_RUN=dry_run, $
  ;;       CHECK_IF_EXISTS=check_if_exists
  ;; ENDELSE

