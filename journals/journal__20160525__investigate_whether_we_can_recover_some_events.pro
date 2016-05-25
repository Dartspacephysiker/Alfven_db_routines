;;05/25/16 The conclusion is no; I took stock of everything I needed to way back when.
PRO JOURNAL__20160525__INVESTIGATE_WHETHER_WE_CAN_RECOVER_SOME_EVENTS 

  inDir      = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  inFile     = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus--HASDUPLICATES.sav'
  inTFile    = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime--HASDUPLICATES.sav'

  compFile   = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'
  compTFile  = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav'

  RESTORE,inDir+compTFile
  nCDBComp   = N_ELEMENTS(cdbTime)

  RESTORE,inDir+inFile
  RESTORE,inDir+inTFile

  ;;Check two ways
  CHECK_DUPES,maximus.time,HAS_DUPES=has_dupes,OUT_UNIQ_I=uniq_i,/NOPRINTDUPES
  CHECK_DUPES,cdbTime,HAS_DUPES=cdbTime_has_dupes,OUT_UNIQ_I=cdbTime_uniq_i,/NOPRINTDUPES

  nMax       = N_ELEMENTS(maximus.time)
  nUniqMax   = N_ELEMENTS(uniq_i)
  nCDB       = N_ELEMENTS(cdbTime)
  nUniqCDB   = N_ELEMENTS(cdbTime_uniq_i)
  ;; IF has_dupes THEN BEGIN
  PRINT,'N maximus elements: ' + STRCOMPRESS(nMax,/REMOVE_ALL)
  PRINT,'N unique          ; ' + STRCOMPRESS(nUniqMax,/REMOVE_ALL)
  ;; ENDIF
;  ;; IF cdbTime_has_dupes THEN BEGIN
  PRINT,'N cdbTime elements: ' + STRCOMPRESS(nCDB,/REMOVE_ALL)
  PRINT,'N unique cdbTime  : ' + STRCOMPRESS(nUniqCDB,/REMOVE_ALL)
  ;; ENDIF  
  PRINT,''

  good       = ARRAY_EQUAL(uniq_i,cdbTime_uniq_i)
  PRINT,'Uniq cdb and max inds match: ' + STRCOMPRESS(good,/REMOVE_ALL)

  

  PRINT,'N current CDB     : ' + STRCOMPRESS(nCDBComp,/REMOVE_ALL)
  diff       = nUniqCDB-nCDBComp
  IF diff GT 0 THEN BEGIN
     PRINT,'We stand to gain!'
  ENDIF ELSE BEGIN
     PRINT,'Huh?'
  ENDELSE
  PRINT,'Diff(curr/former) : ' + STRCOMPRESS(diff,/REMOVE_ALL)
  STOP

END
