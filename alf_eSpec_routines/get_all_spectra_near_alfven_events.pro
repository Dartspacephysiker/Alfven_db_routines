;;06/04/16
PRO GET_ALL_SPECTRA_NEAR_ALFVEN_EVENTS

  COMPILE_OPT IDL2

  startStopDir  = 'SPENCEdata/Research/database/FAST/dartdb/saves/'
  startStopFile = 'alfven_startstop_maxJ_times--500-16361_inc_lower_lats--burst_1000-16361.sav'
  RESTORE,startStopDir+startStopFile

  LOAD_NEWELL_ESPEC_DB

END
