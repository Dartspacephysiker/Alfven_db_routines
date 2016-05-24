;2016/05/07
PRO JOURNAL__20160507__SPLICE_TOGETHER_ORBS_FROM_201605_RUNS

  save_combined_file = 1

  outDir             = '/SPENCEdata/Research/database/FAST/dartdb/saves/'

  ;;The little brother
  max1File           = 'Dartdb_20160507--2500-3599_and_bonus_despun--maximus--pflux--lshell--noDupes.sav'
  cdbT1File          = 'Dartdb_20160507--2500-3599_and_bonus_despun--cdbtime--noDupes.sav'

  ;;The contender
  max2File           = 'Dartdb_20160507--10220-16361_despun--maximus--pflux--lshell--noDupes.sav'
  cdbT2File          = 'Dartdb_20160507--10220-16361_despun--cdbtime--noDupes.sav'

  ;;Output
  outDate            = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  maxOutFile         = 'Dartdb_'+outDate+'--2500-3599_plus_bonus__and_10220-16361_despun--maximus--pflux--lshell--burst--noDupes.sav'
  cdbTOutFile        = 'Dartdb_'+outDate+'--2500-3599_plus_bonus__and_10220-16361_despun--cdbtime--noDupes.sav'

  ;;Trim the heavyweight
  RESTORE,outDir+max1File
  RESTORE,outDir+cdbT1File

  maximus1           = TEMPORARY(maximus)
  cdbTime1           = TEMPORARY(cdbTime)

  ;;Saddle up the second database
  RESTORE,outDir+max2File
  RESTORE,outDir+cdbT2File

  maximus2           = TEMPORARY(maximus)
  cdbTime2           = TEMPORARY(cdbTime)

  COMBINE_TWO_DBFILES,maximus,cdbTime, $
                      DBFILE1=dbFile1, $
                      DB_TFILE1=db_tFile1, $
                      MAXIMUS1=maximus1, $
                      MAXIMUS2=maximus2, $
                      CDBTIME1=cdbTime1, $
                      CDBTIME2=cdbTime2, $
                      DBFILE2=dbFile2, $
                      DB_TFILE2=db_tFile2, $
                      SAVE_COMBINED_FILE=save_combined_file, $
                      /ADD_PFLUX_AND_LSHELL, $
                      OUTFILE=maxOutFile, $
                      OUT_TFILE=cdbTOutFile


  CHECK_DUPES,cdbtime,is_sorted

  IF is_sorted THEN BEGIN
     PRINT,'DONE!'
  ENDIF ELSE BEGIN
     PRINT,"So these aren't sorted. You know that?"
     STOP
  ENDELSE

END