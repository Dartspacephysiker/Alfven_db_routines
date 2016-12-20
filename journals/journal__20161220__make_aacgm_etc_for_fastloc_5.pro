;;12/20/16
PRO JOURNAL__20161220__MAKE_AACGM_ETC_FOR_FASTLOC_5

  COMPILE_OPT IDL2

  outFile_pref            = 'fastLoc_intervals5'
  dry_run                 = 1

  create_timeStamps       = 1
  get_GEI_coords          = 0
  do_GEO_MAG_conversions  = 0
  do_AACGM_conversions    = 0

  ;;Less-important options
  DBDir                   = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals5/'
  coordDir                = DBDir + 'alternate_coords/'
  orig_routineName        = 'JOURNAL__20161220__MAKE_AACGM_ETC_FOR_FASTLOC_5'

  LOAD_FASTLOC_AND_FASTLOC_TIMES,!NULL,times, $
                                 /FOR_ESPEC_DBS, $
                                 /NO_MEMORY_LOAD, $
                                 /JUST_TIMES

  COORDINATE_CONVERSION__PARALLEL,times, $
                                  CREATE_TIMESTAMPS=create_timeStamps, $
                                  GET_GEI_COORDS=get_GEI_coords, $
                                  DO_GEO_MAG_CONVERSIONS=do_GEO_MAG_conversions, $
                                  DO_AACGM_CONVERSIONS=do_AACGM_conversions, $
                                  ORIG_ROUTINENAME=orig_routineName, $
                                  COORDDIR=coordDir, $
                                  OUTFILE_PREF=outFile_pref, $
                                  DRY_RUN=dry_run, $
                                  CHECK_IF_EXISTS=check_if_exists




END
