;2016/02/12 There are dupes, so we'd better junk 'em
PRO JOURNAL__20160212__REMOVE_DUPES_IN_FASTLOC_INTERVALS4

  inDir               = '/SPENCEdata/Research/Cusp/database/FAST_ephemeris/fastLoc_intervals4/'
  inFile              = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205.sav'
  inFileTimes         = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205--times.sav'
  inFileRaw           = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205--times.sav_raw'


  outDir              = '/SPENCEdata/Research/Cusp/database/FAST_ephemeris/fastLoc_intervals4/'
  outFile             = 'fastLoc_intervals4--500-16361--below_aur_oval--20160213--noDupes--sample_freq_le_0.01.sav'
  outFileTimes        = 'fastLoc_intervals4--500-16361--below_aur_oval--20160213--times--noDupes--sample_freq_le_0.01.sav'

  RESTORE,inDir+inFileTimes
  RESTORE,inDir+inFile

  ;;Get appropriate sample freq. first
  sample_i            = WHERE(fastLoc.sample_t LT 0.01 AND fastLoc.sample_t GT 0.)

  fastLoc             = {ORBIT:fastLoc.ORBIT[sample_i], $
                         TIME:fastLoc.TIME[sample_i], $
                         ALT:fastLoc.ALT[sample_i], $
                         MLT:fastLoc.MLT[sample_i], $
                         ILAT:fastLoc.ILAT[sample_i], $
                         FIELDS_MODE:fastLoc.FIELDS_MODE[sample_i], $
                         SAMPLE_T:fastLoc.SAMPLE_T[sample_i], $
                         INTERVAL:fastLoc.INTERVAL[sample_i], $
                         INTERVAL_START:fastLoc.INTERVAL_START[sample_i], $
                         INTERVAL_STOP:fastLoc.INTERVAL_STOP[sample_i]}

  fastLoc_times       = fastLoc_times[sample_i]
  fastLoc_delta_t     = fastLoc_delta_t[sample_i]

  ;;Now sort
  sort_uniq_i         = [UNIQ(fastLoc_times,SORT(fastLoc_times,/L64))]
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
  fastLoc_times       = fastLoc_times[sort_uniq_i]
  fastLoc_delta_t     = fastLoc_delta_t[sort_uniq_i]

END