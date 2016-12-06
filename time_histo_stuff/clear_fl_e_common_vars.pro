PRO CLEAR_FL_E_COMMON_VARS

  COMPILE_OPT idl2

  @common__fastloc_espec_vars.pro

  PRINT,'Clearing fastLoc (for eSpec) COMMON vars in memory ...'

  FL_eSpec__fastLoc       = !NULL
  FASTLOC_E__times        = !NULL
  FASTLOC_E__delta_t      = !NULL
  FASTLOC_E__good_i       = !NULL
  FASTLOC_E__cleaned_i    = !NULL
  FASTLOC_E__HAVE_GOOD_I  = !NULL
  FASTLOC_E__dbFile       = !NULL
  FASTLOC_E__dbTimesFile  = !NULL

END