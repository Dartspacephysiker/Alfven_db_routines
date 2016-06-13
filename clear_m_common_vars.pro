PRO CLEAR_M_COMMON_VARS

  COMPILE_OPT idl2

  COMMON M_VARS

  PRINT,'Clearing maximus COMMON vars ...'

  MAXIMUS__maximus      = !NULL
  MAXIMUS__HAVE_GOOD_I  = !NULL
  MAXIMUS__times        = !NULL
  MAXIMUS__good_i       = !NULL
  MAXIMUS__cleaned_i    = !NULL
  MAXIMUS__dbFile       = !NULL
  MAXIMUS__dbTimesFile  = !NULL
  MAXIMUS__dbDir        = !NULL
  MAXIMUS__despun       = !NULL
  MAXIMUS__is_chastDB   = !NULL
  MAXIMUS__RECALCULATE  = !NULL

END