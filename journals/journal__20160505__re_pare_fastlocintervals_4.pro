PRO JOURNAL__20160505__RE_PARE_FASTLOCINTERVALS_4

  do_resave_all_fastLoc_elements_separately = 0

  dir                            = '/SPENCEdata/Research/Cusp/database/FAST_ephemeris/fastLoc_intervals4/'
  file                           = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205.sav'
  tFile                          = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205--times.sav'

  out_dupe_and_unique_inds_file  = 'list_of_duplicate_indices_AND_unique_indices_for_fastLoc_intervals4--500-16361--below_aur_oval--20160205.sav'

  out_fastLoc_dupeless_tFile     = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--times.sav'
  out_fastLoc_dupeless_file      = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes.sav'

  restore,dir+tFile
  ;; restore,dir+file

  CHECK_SORTED,fastLoc_times,is_sorted,SORTED_I=sorted_i

  ;; IF ~is_sorted THEN BEGIN
     ;; PRINT,"fastLoc_times isn't sorted! Sorting..."

     ;; fastLoc_times               = fastLoc_times[sorted_i]
     ;; fastloc_delta_t             = fastLoc_delta_t[sorted_i]

     ;; fastLoc                  = { $
     ;;           ORBIT: fastLoc.ORBIT[sorted_i], $
     ;;           TIME: fastLoc.TIME[sorted_i], $
     ;;           ALT: fastLoc.ALT[sorted_i], $
     ;;           MLT: fastLoc.MLT[sorted_i], $
     ;;           ILAT: fastLoc.ILAT[sorted_i], $
     ;;           FIELDS_MODE: fastLoc.FIELDS_MODE[sorted_i], $
     ;;           SAMPLE_T: fastLoc.SAMPLE_T[sorted_i], $
     ;;           INTERVAL: fastLoc.INTERVAL[sorted_i], $
     ;;           INTERVAL_START: fastLoc.INTERVAL_START[sorted_i], $
     ;;           INTERVAL_STOP: fastLoc.INTERVAL_STOP[sorted_i] $
     ;;           }
     ;; PRINT,'Done!'
  ;; ENDIF

  IF ~FILE_TEST(dir+out_dupe_AND_unique_inds_file) THEN BEGIN

     PRINT,"Looks like we're taking it from the top. Sorting these little chocolatiers."
     STOP

     PRINT,'Now checking for duplicates...'
     CHECK_DUPES,fastLoc_times,HAS_DUPES=has_dupes,N_DUPES=n_dupes,OUT_DUPE_I=out_dupe_i

     ;;Sorted?
     check_sorted,out_dupe_i,dupe_is_sorted

     IF ~dupe_is_sorted THEN BEGIN
        PRINT,"Dupes aren't even sorted!!!! The world is over."
        STOP
     ENDIF

     ;;Keep 'em! A lot of work
     ;; SAVE,out_dupe_i,FILENAME=dir+'list_of_duplicate_indices_for_fastLoc_intervals4--500-16361--below_aur_oval--20160205.sav'

     IF (WHERE(out_dupe_i LT 0))[0] NE -1 THEN BEGIN
        PRINT,"WHAATT"
        stop
     ENDIF

     ;;the not-dupes
     not_dupe_i                  = CGSETDIFFERENCE(LINDGEN(N_ELEMENTS(fastLoc_times)),out_dupe_i)

     ;;the unique dupes
     uniq_dupes_ii               = UNIQ(fastLoc_times[out_dupe_i])
     uniq_dupes_i                = out_dupe_i[uniq_dupes_ii]

     ;;The good inds
     combined_noDupes_i          = CGSETUNION(not_dupe_i,uniq_dupes_i)

     CHECK_SORTED,combined_noDupes_i,is_fantastically_sorted

     IF is_fantastically_sorted THEN BEGIN
        PRINT,"Great! You're on your way to a clean ephemeris."
     ENDIF ELSE BEGIN
        PRINT,"WHAHSDLFJL"
        STOP
     END

     PRINT,'Saving dupe inds and unique inds to ' + out_dupe_and_unique_inds_file + '...'
     sorted_combined_noDupes_i           = sorted_i[combined_noDupes_i]
     README = 'Remember--combined_noDupes_i should be fed to SORTED_I in order to get unique indices!!'
     SAVE,out_dupe_i,combined_noDupes_i,uniq_dupes_i,uniq_dupes_ii,sorted_i,sorted_combined_noDupes_i,README,FILENAME=dir+out_dupe_and_unique_inds_file
     PRINT,"Did it!"
  ENDIF ELSE BEGIN
     PRINT,"I've already done all this sorting nonsense. Let's get down to business."
  ENDELSE

  PRINT,'Restoring dat...'
  RESTORE,dir+out_dupe_AND_unique_inds_file
  PRINT,'DONE!'

  fastLoc_times_test             = fastLoc_times[sorted_combined_noDupes_i]
  fastLoc_delta_t_test           = fastLoc_delta_t[sorted_combined_noDupes_i]


  CHECK_SORTED,fastLoc_times_test,is_sorted


  IF ~is_sorted THEN BEGIN
     PRINT,"fastLoc_times isn't sorted AGAIN! What have you done wrong now?"
     STOP
  ENDIF ELSE BEGIN
     PRINT,"You're in the clear, homey. Welcome to the top."

     ;; fastLoc_times            = fastLoc_times_test
     ;; fastLoc_delta_t          = fastLoc_delta_t_test

     ;; PRINT,'Saving dupeless fastLoc_times file: ' + out_fastLoc_dupeless_tFile + '...'
     ;; SAVE,fastLoc_times,fastLoc_delta_t,FILENAME=out_fastLoc_dupeless_tFile

     STOP

     orbitFile           = 'fastLoc_intervals4--500-16361--sorted--20160505--orbit.sav'
     timeFile            = 'fastLoc_intervals4--500-16361--sorted--20160505--time.sav'
     altFile             = 'fastLoc_intervals4--500-16361--sorted--20160505--alt.sav'
     mltFile             = 'fastLoc_intervals4--500-16361--sorted--20160505--mlt.sav'
     ilatFile            = 'fastLoc_intervals4--500-16361--sorted--20160505--ilat.sav'
     fieldsModeFile      = 'fastLoc_intervals4--500-16361--sorted--20160505--fields_mode.sav'
     sample_tFile        = 'fastLoc_intervals4--500-16361--sorted--20160505--sample_t.sav'
     intervalFile        = 'fastLoc_intervals4--500-16361--sorted--20160505--interval.sav'
     interval_startFile  = 'fastLoc_intervals4--500-16361--sorted--20160505--interval_start.sav'
     interval_stopFile   = 'fastLoc_intervals4--500-16361--sorted--20160505--interval_stop.sav'

     IF do_resave_all_fastLoc_elements_separately THEN BEGIN

        PRINT,'Now sorting the mother...'
        restore,dir+file

        orbit                       = fastLoc.orbit[sorted_combined_noDupes_i]
        PRINT,'Saving orbits...'
        save,orbit,FILENAME=dir+orbitFile
        PRINT,'DONE!'
        orbit                       = !NULL

        time                        = fastLoc.time[sorted_combined_noDupes_i]
        PRINT,'Saving times...'
        save,time,FILENAME=dir+timeFile
        PRINT,'DONE!'
        time                        = !NULL

        alt                         = fastLoc.alt[sorted_combined_noDupes_i]
        PRINT,'Saving alts...'
        save,alt,FILENAME=dir+altFile
        PRINT,'DONE!'
        alt                         = !NULL

        mlt                         = fastLoc.mlt[sorted_combined_noDupes_i]
        PRINT,'Saving mlts...'
        save,mlt,FILENAME=dir+mltFile
        PRINT,'DONE!'
        mlt                         = !NULL

        ilat                        = fastLoc.ilat[sorted_combined_noDupes_i]
        PRINT,'Saving ilats...'
        save,ilat,FILENAME=dir+ilatFile
        PRINT,'DONE!'
        ilat                        = !NULL

        fields_mode                 = fastLoc.fields_mode[sorted_combined_noDupes_i]
        PRINT,'Saving fields_modes...'
        save,fields_mode,FILENAME=dir+fieldsModeFile
        PRINT,'DONE!'
        fields_mode                 = !NULL

        sample_t                    = fastLoc.sample_t[sorted_combined_noDupes_i]
        PRINT,'Saving sample_ts...'
        save,sample_t,FILENAME=dir+sample_tFile
        PRINT,'DONE!'
        sample_t                    = !NULL

        interval                    = fastLoc.interval[sorted_combined_noDupes_i]
        PRINT,'Saving intervals...'
        SAVE,interval,FILENAME=dir+intervalFile
        PRINT,'DONE!'
        interval                    = !NULL
        
        interval_start              = fastLoc.interval_start[sorted_combined_noDupes_i]
        PRINT,'Saving interval_starts...'
        save,interval_start,FILENAME=dir+interval_startFile
        PRINT,'DONE!'
        interval_start              = !NULL


        interval_stop               = fastLoc.interval_stop[sorted_combined_noDupes_i]
        PRINT,'Saving interval_stops...'
        save,interval_stop,FILENAME=dir+interval_stopFile
        PRINT,'DONE!'
        interval_stop               = !NULL

        PRINT,"killing fastLoc, then restarting life brand new"
        fastLoc                     = !NULL

     ENDIF ELSE BEGIN
        PRINT,"Looks like I'm preloading existing files for each fastLoc element..."
     ENDELSE

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

     PRINT,"Now rebuilding fastLoc..."
     fastLoc                     = { $
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


     PRINT,"Saving new fastLoc..."
     SAVE,fastLoc,FILENAME=dir+out_fastLoc_dupeless_file
     PRINT,"DONE!"
  ENDELSE

END