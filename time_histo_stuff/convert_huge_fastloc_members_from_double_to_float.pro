PRO CONVERT_HUGE_FASTLOC_MEMBERS_FROM_DOUBLE_TO_FLOAT

  COMPILE_OPT idl2

  LOAD_FASTLOC_AND_FASTLOC_TIMES

  DefDBDir                          = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/'
  DefESpecDBFile                    = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes.sav'
  DefESpecDB_tFile                  = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--times.sav'
  smallFile                         = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--smaller_datatypes--no_interval_startstop.sav'

  RESTORE,DefDBDir+DefESpecDBFile

  fastLoc                           = {TIME:fastLoc.time, $
                                       ORBIT:fastLoc.orbit, $
                                       ALT:FLOAT(fastLoc.alt), $
                                       MLT:FLOAT(fastLoc.mlt), $
                                       ILAT:FLOAT(fastLoc.ilat), $
                                       FIELDS_MODE:FIX(fastLoc.fields_mode), $
                                       SAMPLE_T:FLOAT(fastLoc.sample_t), $
                                       INTERVAL:fastLoc.interval};, $
                                       ;; INTERVAL_START:fastLoc.interval_start, $
                                       ;; INTERVAL_STOP:fastLoc.interval_stop}


  SAVE,fastLoc,FILENAME=defdbdir+smallFile

END