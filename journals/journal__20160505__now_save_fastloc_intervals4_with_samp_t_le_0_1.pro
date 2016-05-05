PRO JOURNAL__20160505__NOW_SAVE_FASTLOC_INTERVALS4_WITH_SAMP_T_LE_0_1


  dir                     = '/SPENCEdata/Research/Cusp/database/FAST_ephemeris/fastLoc_intervals4/'
  fastLoc_pref            = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes'
  fastLoc_dupeless_tFile  = fastLoc_pref + '--times.sav'

  fastLoc_newFile         = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05.sav'
  fastLoc_newtFile        = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--times.sav'

  orbitFile               = 'fastLoc_intervals4--500-16361--sorted--20160505--orbit.sav'
  timeFile                = 'fastLoc_intervals4--500-16361--sorted--20160505--time.sav'
  altFile                 = 'fastLoc_intervals4--500-16361--sorted--20160505--alt.sav'
  mltFile                 = 'fastLoc_intervals4--500-16361--sorted--20160505--mlt.sav'
  ilatFile                = 'fastLoc_intervals4--500-16361--sorted--20160505--ilat.sav'
  fieldsModeFile          = 'fastLoc_intervals4--500-16361--sorted--20160505--fields_mode.sav'
  sample_tFile            = 'fastLoc_intervals4--500-16361--sorted--20160505--sample_t.sav'
  intervalFile            = 'fastLoc_intervals4--500-16361--sorted--20160505--interval.sav'
  interval_startFile      = 'fastLoc_intervals4--500-16361--sorted--20160505--interval_start.sav'
  interval_stopFile       = 'fastLoc_intervals4--500-16361--sorted--20160505--interval_stop.sav'


  PRINT,'Restoring orbitFile...'
  RESTORE,dir+orbitFile

  PRINT,'Restoring timeFile...'
  RESTORE,dir+timeFile

  PRINT,'Restoring altFile...'
  RESTORE,dir+altFile

  PRINT,'Restoring mltFile...'
  RESTORE,dir+mltFile

  PRINT,'Restoring ilatFile...'
  RESTORE,dir+ilatFile

  PRINT,'Restoring fieldsModeFile...'
  RESTORE,dir+fieldsModeFile

  PRINT,'Restoring sample_tFile...'
  RESTORE,dir+sample_tFile

  PRINT,'Restoring intervalFile...'
  RESTORE,dir+intervalFile

  PRINT,'Restoring interval_startFile...'
  RESTORE,dir+interval_startFile

  PRINT,'Restoring interval_stopFile...'
  RESTORE,dir+interval_stopFile

  ;;This includes sample times of 0.03125 and 0.0078125
  PRINT,"Getting the GOOD inds"
  good_samp_t_inds           = WHERE(ABS(sample_t) LT 0.05)


  PRINT,"Resizing everybody with good samp_t_inds"
  orbit                   = orbit[good_samp_t_inds]         
  time                    = time[good_samp_t_inds]          
  alt                     = alt[good_samp_t_inds]           
  mlt                     = mlt[good_samp_t_inds]           
  ilat                    = ilat[good_samp_t_inds]          
  fields_Mode             = fields_Mode[good_samp_t_inds]    
  sample_t                = sample_t[good_samp_t_inds]      
  interval                = interval[good_samp_t_inds]      
  interval_start          = interval_start[good_samp_t_inds]
  interval_stop           = interval_stop[good_samp_t_inds] 

  PRINT,"Now rebuilding fastLoc..."
  fastLoc                 = { $
                                ORBIT: TEMPORARY(orbit), $
                                TIME: TEMPORARY(time), $
                                ALT: TEMPORARY(alt), $
                                MLT: TEMPORARY(mlt), $
                                ILAT: TEMPORARY(ilat), $
                                FIELDS_MODE: TEMPORARY(fields_mode), $
                                SAMPLE_T: TEMPORARY(sample_t), $
                                INTERVAL: TEMPORARY(interval), $
                                INTERVAL_START: TEMPORARY(interval_start), $
                                INTERVAL_STOP: TEMPORARY(interval_stop) $
                                }


  PRINT,'Saving new fastLoc without those nasty sample times'
  STOP
  SAVE,fastLoc,FILENAME=dir+fastLoc_newFile

  ;;Get 'em back
  PRINT,'Fixing up time file members...'
  RESTORE,dir+fastLoc_dupeless_tFile
  fastLoc_times           = fastLoc_times[good_samp_t_inds]
  fastLoc_delta_t         = fastLoc_delta_t[good_samp_t_inds]

  CHECK_SORTED,fastLoc_times,is_sorted

  IF ~is_sorted THEN BEGIN
     PRINT,";asd;fl kja;lkj"
     STOP
  ENDIF

  PRINT,"saving 'em..."
  STOP
  ;; SAVE,fastLoc_times,fastLoc_delta_t,FILENAME=dir+fastLoc_newtFile
  PRINT,'DONE!'

END