;2015/12/21 Load this newfangled DB of mapping ratios that we've created
PRO LOAD_MAPPING_RATIO_DB,mapRatio, $
                          DBDir=DBDir, $
                          DBFile=DBFile, $
                          DESPUNDB=despunDB, $
                          CHASTDB=chastDB, $
                          QUIET=quiet, $
                          LUN=lun
  
  COMPILE_OPT idl2,strictarrsubs

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1         ;stdout

  defDBDir             = '/SPENCEdata/Research/database/FAST/dartdb/saves/mapratio_dbs/'

  defDBFile            = 'mapratio_for_20151014_DB--up_to16361--20151221.dat'
  ;; defDespunDBFile      = 'mapratio_for_20160107_despun_DB--up_to16361--20160109.dat'
  defDespunDBFile      = 'mapratio_for_20160508_despun_DB--up_to16361--20160613.dat'
  defChastDBFile       = 'mapratio_for_chastDB--20160802.dat'

  IF N_ELEMENTS(DBDir) EQ 0 THEN DBDir = DefDBDir

  IF N_ELEMENTS(DBFile) EQ 0 THEN BEGIN
     CASE 1 OF
        KEYWORD_SET(despunDB): BEGIN
           DBFile      = defDespunDBFile
           dbName      = 'despun'
        END
        KEYWORD_SET(chastDB): BEGIN
           DBFile      = defChastDBFile
           dbName      = 'Chast'
        END
        ELSE: BEGIN
           DBFile      = defDBFile
           dbName      = 'regulièr'
        END
     ENDCASE

     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'Mapping Poynting fluxes using mapping ratios for ' + dbName + ' DB ...'
  ENDIF

  IF N_ELEMENTS(mapRatio) EQ 0 THEN BEGIN
     IF FILE_TEST(DBDir+DBFile) THEN RESTORE,DBDir+DBFile
     IF mapRatio EQ !NULL THEN BEGIN
        PRINT,"Couldn't load mapRatio!"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,"There is already a mapRatio struct loaded! Not loading " + DBFile
  ENDELSE

END