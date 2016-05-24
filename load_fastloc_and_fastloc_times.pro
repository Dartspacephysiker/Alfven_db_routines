;2016/02/13 Added FORCE_LOAD keywords
PRO LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastloc_times,fastloc_delta_t, $
                                   DBDir=DBDir, $
                                   DBFile=DBFile, $
                                   DB_tFile=DB_tFile, $
                                   FORCE_LOAD_FASTLOC=force_load_fastLoc, $
                                   FORCE_LOAD_TIMES=force_load_times, $
                                   FORCE_LOAD=force_load, $
                                   LUN=lun

  ;; COMMON FL_VARS,fastLoc,FASTLOC__times,FASTLOC__delta_t, $
  ;;    FASTLOC__good_i,FASTLOC__cleaned_i,FASTLOC__HAVE_GOOD_I, $
  ;;    FASTLOC__dbFile,FASTLOC__dbTimesFile

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1         ;stdout

  IF KEYWORD_SET(force_load_both) THEN BEGIN
     PRINTF,lun,"Forcing load of fastLoc and times..."
     force_load_fastLoc = 1
     force_load_times = 1
  ENDIF


  ;; DefDBDir = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals2/'
  ;; DefDBFile = 'fastLoc_intervals2--500-16361_all--20150613.sav'
  ;; DefDBFile = 'fastLoc_intervals2--500-16361_all--w_lshell--20151015.sav'
  ;; DefDB_tFile = 'fastLoc_intervals2--500-16361_all--20150613--times.sav'

  ;; DefDBDir = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals3/'
  ;; DefDBFile = 'fastLoc_intervals3--500-16361--below_aur_oval--20151020.sav'
  ;; DefDB_tFile = 'fastLoc_intervals3--500-16361--below_aur_oval--20151020--times.sav'

  DefDBDir = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/'
  ;; DefDBFile = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205.sav'
  ;; DefDB_tFile = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205--times.sav'
  ;; DefDBFile = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205--sample_t_le_0.01.sav'
  ;; DefDB_tFile = 'fastLoc_intervals4--500-16361--below_aur_oval--20160205--times--sample_t_le_0.01.sav'
  ;; DefDBFile   = 'fastLoc_intervals4--500-16361--below_aur_oval--20160213--noDupes--sample_freq_le_0.01.sav'
  ;; DefDB_tFile = 'fastLoc_intervals4--500-16361--below_aur_oval--20160213--times--noDupes--sample_freq_le_0.01.sav'
  DefDBFile   = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05.sav'
  DefDB_tFile = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--times.sav'

  IF N_ELEMENTS(DBDir) EQ 0 THEN DBDir = DefDBDir
  IF N_ELEMENTS(DBFile) EQ 0 THEN DBFile = DefDBFile
  IF N_ELEMENTS(DB_tFile) EQ 0 THEN DB_tFile = DefDB_tFile
  
  IF N_ELEMENTS(fastLoc) EQ 0 OR KEYWORD_SET(force_load_fastLoc) THEN BEGIN
     IF KEYWORD_SET(force_load_fastLoc) THEN BEGIN
        PRINTF,lun,"Forcing load, whether or not we already have fastLoc..."
     ENDIF
     IF FILE_TEST(DBDir+DBFile) THEN RESTORE,DBDir+DBFile
     IF fastLoc EQ !NULL THEN BEGIN
        PRINT,"Couldn't load fastLoc!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"There is already a fastLoc struct loaded! Not loading " + DBFile
  ENDELSE

  IF N_ELEMENTS(fastloc_times) EQ 0 OR KEYWORD_SET(force_load_times) THEN BEGIN
     IF KEYWORD_SET(force_load_times) THEN BEGIN
        PRINTF,lun,"Forcing load, whether or not we already have times..."
     ENDIF
     IF FILE_TEST(DBDir+DB_tFile) THEN RESTORE,DBDir+DB_tFile
     IF fastloc_times EQ !NULL THEN BEGIN
        PRINT,"Couldn't load fastloc_times!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"There is already a fastloc_times struct loaded! Not loading " + DB_tFile
  ENDELSE

END