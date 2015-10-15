PRO LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,DBDir=DBDir,DBFile=DBFile,DB_tFile=DB_tFile,DO_CHASTDB=chastDB,LUN=lun

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1         ;stdout

  DefDBDir = '/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  ;;DefDBFile = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'
  DefDBFile = 'Dartdb_20151014--500-16361_inc_lower_lats--burst_1000-16361--w_Lshell--maximus.sav'
  DefDB_tFile = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav'

  IF KEYWORD_SET(chastDB) THEN BEGIN
     DBDir='/SPENCEdata/Research/Cusp/database/processed/'
     DBFile = "maximus.dat"
     DB_tFile = "cdbtime.sav"
  ENDIF ELSE BEGIN
     IF N_ELEMENTS(DBDir) EQ 0 THEN DBDir = DefDBDir
     IF N_ELEMENTS(DBFile) EQ 0 THEN DBFile = DefDBFile
     IF N_ELEMENTS(DB_tFile) EQ 0 THEN DB_tFile = DefDB_tFile
  ENDELSE
  
  IF N_ELEMENTS(maximus) EQ 0 THEN BEGIN
     IF FILE_TEST(DBDir+DBFile) THEN RESTORE,DBDir+DBFile
     IF maximus EQ !NULL THEN BEGIN
        PRINT,"Couldn't load maximus!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"There is already a maximus struct loaded! Not loading " + DBFile
  ENDELSE

  IF N_ELEMENTS(cdbTime) EQ 0 THEN BEGIN
     IF FILE_TEST(DBDir+DB_tFile) THEN RESTORE,DBDir+DB_tFile
     IF cdbTime EQ !NULL THEN BEGIN
        PRINT,"Couldn't load cdbTime!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"There is already a cdbTime struct loaded! Not loading " + DB_tFile
  ENDELSE

END