;2017/05/22
PRO CLEAR_STRANGEWAY_COMMON_VARS

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__strangeway_bands.pro

  PRINT,'Clearing Strangeway COMMON vars ...'

  SWAY__DB              = !NULL
  SWAY__DBFile          = !NULL
  SWAY__DBEphemFile     = !NULL
  SWAY__DBEphemExtFile  = !NULL
  SWAY__DBDir           = !NULL
  SWAY__good_i          = !NULL
  SWAY__HAVE_GOOD_I     = !NULL
  SWAY__cleaned_i       = !NULL
  SWAY__8Hz_varsToLoad  = !NULL
  SWAY__8Hz_varsLoaded  = !NULL
  SWAY__8Hz_NVarsToLoad = !NULL
  SWAY__8Hz_NVarsLoaded = !NULL
  SWAY__8Hz_dB          = !NULL
  SWAY__8Hz_eField      = !NULL
  SWAY__8Hz_magFlags    = !NULL
  SWAY__8Hz_pFlux       = !NULL
  ;; SWAY__8Hz_ephem       = !NULL
  SWAY__RECALCULATE     = !NULL

END
