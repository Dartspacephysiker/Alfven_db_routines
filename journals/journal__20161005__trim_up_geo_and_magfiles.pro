;;10/05/16
PRO JOURNAL__20161005__TRIM_UP_GEO_AND_MAGFILES

  COMPILE_OPT IDL2

  balderdash = '/SPENCEdata/Research/database/FAST/ephemeris/'
  geomagfile = 'Dartdb_20151222--500-16361_inc_lower_lats--maximus--GEO_and_MAG_coords.sav'
  AACGMfile  = 'Dartdb_20151222--500-16361_inc_lower_lats--maximus--AACGM_coords.sav'

  ;;Out files
  outDir       = '/SPENCEdata/Research/database/FAST/dartdb/saves/alternate_coords/'
  outGEOFile   = 'Dartdb_20151222--500-16361_inc_lower_lats--maximus--GEO_coords.sav'
  outMAGFile   = 'Dartdb_20151222--500-16361_inc_lower_lats--maximus--MAG_coords.sav'
  outAACGMFile = 'Dartdb_20151222--500-16361_inc_lower_lats--maximus--AACGM_coords.sav'
  
  RESTORE,balderdash+AACGMfile

  IF ~FILE_TEST(outDir+outAACGMFile) THEN BEGIN
     PRINT,"Saving AACGM file ..."
     SAVE,max_AACGM,FILENAME=outDir+outAACGMFile
  ENDIF

  RESTORE,balderdash+geomagfile


  IF ~FILE_TEST(outDir+outGEOFile) THEN BEGIN
     PRINT,"Saving GEO file ..."
     SAVE,max_GEO,FILENAME=outDir+outGEOFile
  ENDIF

  IF ~FILE_TEST(outDir+outMAGFile) THEN BEGIN
     PRINT,"Saving MAG file ..."
     SAVE,max_MAG,FILENAME=outDir+outMAGFile
  ENDIF

END
