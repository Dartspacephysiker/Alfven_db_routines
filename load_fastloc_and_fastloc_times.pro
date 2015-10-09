PRO LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastloc_times,DBDir=DBDir,DBFile=DBFile,DB_tFile=DB_tFile,DO_CHASTDB=chastDB,LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1         ;stdout

  DefDBDir = '/SPENCEdata/Research/Cusp/database/time_histos/'
  DefDBFile = 'fastLoc_intervals2--500-16361_all--20150613.sav'
  DefDB_tFile = 'fastLoc_intervals2--500-16361_all--20150613--times.sav'

  IF KEYWORD_SET(chastDB) THEN BEGIN
     DBDir='/SPENCEdata/Research/Cusp/database/processed/'
     DBFile = "maximus.dat"
     DB_tFile = "cdbtime.sav"
  ENDIF ELSE BEGIN
     IF N_ELEMENTS(DBDir) EQ 0 THEN DBDir = DefDBDir
     IF N_ELEMENTS(DBFile) EQ 0 THEN DBFile = DefDBFile
     IF N_ELEMENTS(DB_tFile) EQ 0 THEN DB_tFile = DefDB_tFile
  ENDELSE
  
  IF N_ELEMENTS(fastLoc) EQ 0 THEN BEGIN
     IF FILE_TEST(DBDir+DBFile) THEN RESTORE,DBDir+DBFile
     IF fastLoc EQ !NULL THEN BEGIN
        PRINT,"Couldn't load fastLoc!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"There is already a fastLoc struct loaded! Not loading " + DBFile
  ENDELSE

  IF N_ELEMENTS(fastloc_times) EQ 0 THEN BEGIN
     IF FILE_TEST(DBDir+DB_tFile) THEN RESTORE,DBDir+DB_tFile
     IF fastloc_times EQ !NULL THEN BEGIN
        PRINT,"Couldn't load fastloc_times!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"There is already a fastloc_times struct loaded! Not loading " + DB_tFile
  ENDELSE

END