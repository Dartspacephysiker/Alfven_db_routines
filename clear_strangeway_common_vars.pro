;2017/05/22
PRO CLEAR_STRANGEWAY_COMMON_VARS

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__strangeway_bands.pro

  PRINT,'Clearing Strangeway COMMON vars ...'

  SWAY__DB              = !NULL ; SWAY__DB
  SWAY__DBFile          = !NULL ; SWAY__DBFile
  SWAY__DBEphemFile     = !NULL ; SWAY__DBEphemFile
  SWAY__DBEphemExtFile  = !NULL ; SWAY__DBEphemExtFile
  SWAY__DBDir           = !NULL ; SWAY__DBDir
  SWAY__HAVE_GOOD_I     = !NULL ; SWAY__HAVE_GOOD_I
  SWAY__RECALCULATE     = !NULL ; SWAY__RECALCULATE

END
