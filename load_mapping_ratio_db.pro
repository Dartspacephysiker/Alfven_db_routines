;2015/12/21 Load this newfangled DB of mapping ratios that we've created
PRO LOAD_MAPPING_RATIO_DB,mapRatio, $
                          DBDir=DBDir, $
                          DBFile=DBFile, $
                          DO_DESPUNDB=do_despunDB, $
                          LUN=lun
  
  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1         ;stdout

  defDBDir             = '/SPENCEdata/Research/Cusp/database/dartdb/saves/mapratio_dbs/'

  defDBFile            = 'mapratio_for_20151014_DB--up_to16361--20151221.dat'
  defDespunDBFile      = 'mapratio_for_20160107_despun_DB--up_to16361--20160109.dat'

  IF N_ELEMENTS(DBDir) EQ 0 THEN DBDir = DefDBDir

  IF N_ELEMENTS(DBFile) EQ 0 THEN BEGIN
     IF KEYWORD_SET(do_despunDB) THEN BEGIN
        DBFile         = defDespunDBFile
        PRINTF,lun,'Mapping Poynting fluxes using mapping ratios for despun DB ...'
     ENDIF ELSE BEGIN
        DBFile         = defDBFile
     ENDELSE
  ENDIF

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