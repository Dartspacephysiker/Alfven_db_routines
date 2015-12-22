;2015/12/21 Load this newfangled DB of mapping ratios that we've created
PRO LOAD_MAPPING_RATIO_DB,mapRatio, $
                          DBDir=DBDir, $
                          DBFile=DBFile, $
                          LUN=lun
  
  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1         ;stdout

  DefDBDir             = '/SPENCEdata/Research/Cusp/database/'
  DefDBFile            = 'mapratio_for_20151014_DB--up_to16361--20151221.dat'

  IF N_ELEMENTS(DBDir) EQ 0 THEN DBDir = DefDBDir
  IF N_ELEMENTS(DBFile) EQ 0 THEN DBFile = DefDBFile
  
  IF N_ELEMENTS(mapRatio) EQ 0 THEN BEGIN
     IF FILE_TEST(DBDir+DBFile) THEN RESTORE,DBDir+DBFile
     IF mapRatio EQ !NULL THEN BEGIN
        PRINT,"Couldn't load mapRatio!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     PRINTF,lun,"There is already a mapRatio struct loaded! Not loading " + DBFile
  ENDELSE

END