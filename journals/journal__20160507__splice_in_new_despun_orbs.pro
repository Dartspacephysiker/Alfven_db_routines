;2016/05/07
PRO JOURNAL__20160507__SPLICE_IN_NEW_DESPUN_ORBS

  save_combined_file = 1

  outDir             = '/SPENCEdata/Research/database/FAST/dartdb/saves/'

  ;;The heavyweight champion
  max1File           = 'Dartdb_20160107--502-16361_despun--maximus--pflux--lshell--burst--noDupes.sav'
  cdbT1File          = 'Dartdb_20160107--502-16361_despun--cdbtime--noDupes.sav'

  ;;The contender
  max2File           = 'Dartdb_20160508--2500-3599_plus_bonus__and_10220-16361_despun--maximus--pflux--lshell--burst--noDupes.sav'
  cdbT2File          = 'Dartdb_20160508--2500-3599_plus_bonus__and_10220-16361_despun--cdbtime--noDupes.sav'

  ;;Output
  outDate            = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  maxOutFile         = 'Dartdb_'+outDate+'--502-16361_despun--maximus--pflux_lshell--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'
  cdbTOutFile        = 'Dartdb_'+outDate+'--502-16361_despun--cdbtime--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'

  ;;Trim the heavyweight
  RESTORE,outDir+max1File
  RESTORE,outDir+cdbT1File

  not_detritus_i     = WHERE((maximus.orbit GE 500 AND maximus.orbit LE 2499) $
                             OR (maximus.orbit GE 3600 AND maximus.orbit LE 10209))


  maximus1           = RESIZE_MAXIMUS__BEFORE_ADDING_CORRECTED_FLUXES_DESPUN_ETC(maximus,INDS=not_detritus_i,CDBTIME=cdbTime)
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

END
