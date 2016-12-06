PRO CLEAR_FL_COMMON_VARS

  COMPILE_OPT idl2

  @common__fastloc_vars.pro
  ;; COMMON FL_VARS

  PRINT,'Clearing fastLoc COMMON vars in memory ...'

  FL__fastLoc           = !NULL
  FASTLOC__times        = !NULL
  FASTLOC__delta_t      = !NULL
  FASTLOC__good_i       = !NULL
  FASTLOC__cleaned_i    = !NULL
  FASTLOC__HAVE_GOOD_I  = !NULL
  FASTLOC__dbFile       = !NULL
  FASTLOC__dbTimesFile  = !NULL



END