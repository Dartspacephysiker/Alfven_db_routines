;2016/02/12 There are dupes, so we'd better junk 'em
PRO JOURNAL__20160212__REMOVE_DUPES_IN_FASTLOC_INTERVALS4

  inDir               = '/SPENCEdata/Research/Cusp/Alfven_db_routines/journals/../../database/FAST_ephemeris/fastLoc_intervals4/'
  inFile              = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205.sav'
  inFileTimes         = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205--times.sav'
  inFileRaw           = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205--times.sav_raw'


  outDir              = '/SPENCEdata/Research/Cusp/Alfven_db_routines/journals/../../database/FAST_ephemeris/fastLoc_intervals4/'
  outFile             = 'fastLoc_intervals4--500-16361--below_aur_oval--20160211--noDupes--sample_freq_lt_0.01.sav'
  outFileTimes        = 'fastLoc_intervals4--500-16361--below_aur_oval--20160211--times--noDupes--sample_freq_lt_0.01.sav'


  RESTORE,inDir+inFile

  sort_uniq_i         = UNIQ(fastLoc_times[SORT(fastLoc_times,/L64)])

  fastLoc             = {ORBIT:fastLoc.ORBIT[sort_uniq_i], $
                         TIME:fastLoc.TIME[sort_uniq_i], $
                         ALT:fastLoc.ALT[sort_uniq_i], $
                         MLT:fastLoc.MLT[sort_uniq_i], $
                         ILAT:fastLoc.ILAT[sort_uniq_i], $
                         FIELDS_MODE:fastLoc.FIELDS_MODE[sort_uniq_i], $
                         SAMPLE_T:fastLoc.SAMPLE_T[sort_uniq_i], $
                         INTERVAL:fastLoc.INTERVAL[sort_uniq_i], $
                         INTERVAL_START:fastLoc.INTERVAL_START[sort_uniq_i], $
                         INTERVAL_STOP:fastLoc.INTERVAL_STOP[sort_uniq_i]}
END