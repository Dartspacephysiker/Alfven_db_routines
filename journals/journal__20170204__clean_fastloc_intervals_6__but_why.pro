;;02/04/17
;;Why should this have to be cleaned??
PRO JOURNAL__20170204__CLEAN_FASTLOC_INTERVALS_6__BUT_WHY

  COMPILE_OPT IDL2,STRICTARRSUBS

  DefDBDir      = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals6/'
  defDBFile     = 'fastLoc_intervals6--20170204--500-24507--Je_times.sav'
  defDB_tFile   = 'fastLoc_intervals6--20170204--500-24507--Je_times--time_and_delta_t.sav'

  coordDir      = defDBDir + 'alternate_coords/'
  coordFilArr   = ['fastLoc_intervals6--20170204--500-24507--Je_times-GEI.sav', $
                   'fastLoc_intervals6--20170204--500-24507--Je_times-GEO.sav', $
                   'fastLoc_intervals6--20170204--500-24507--Je_times-MAG.sav', $
                   'fastLoc_intervals6--20170204--500-24507--Je_times-SDT.sav']
  coordStrName  = ['GEI','GEO','MAG','SDT']

  uniqSavFile   = 'fastLoc_intervals6--20170204--500-24507--Je_times--uniq_inds_for_shrinking_DB--20170207.sav'

  mapRatDir     = defDBDir
  mapRatFile    = 'fastLoc_intervals6--20170204--500-24507--Je_times--mapRatio.sav'

  RESTORE,defDBDir+defDBFile
  RESTORE,defDBDir+defDB_tFile

  IF FILE_TEST(defDBDir+uniqSavFile) THEN BEGIN
     PRINT,"Restoring fastLoc_intervals6 uniq inds file ..."
     RESTORE,defDBDir+uniqSavFile
     
     IF (N_ELEMENTS(uniq_i  ) EQ 0) OR $
        (N_ELEMENTS(nUniq   ) EQ 0) OR $
        (N_ELEMENTS(nElem   ) EQ 0) OR $
        (N_ELEMENTS(tagNames) EQ 0)    $
     THEN BEGIN
        PRINT,"Whoa! so what exactly was saved here?"
        STOP
     ENDIF

  ENDIF ELSE BEGIN

     PRINT,"Getting uniq inds for fastLoc_intervals6 ..."

     uniq_i = UNIQ(fastLoc.x,SORT(fastLoc.x))

     nUniq     = N_ELEMENTS(uniq_i)
     nElem     = N_ELEMENTS(fastLoc.x)
     tagNames = TAG_NAMES(fastLoc)

     PRINT,"Saving fastLoc_intervals6 uniq inds to " + uniqSavFile + ' ...'
     SAVE,uniq_i,nUniq,nElem,tagNames,FILENAME=defDBDir+uniqSavFile

  ENDELSE

  alreadyFixed = !NULL
  fastLoc_is_updated = 0B
  ;; IF nElem NE nUniq THEN BEGIN
  FOR k=0,N_ELEMENTS(tagNames)-1 DO BEGIN
     IF N_ELEMENTS(fastLoc.(k)) EQ nElem THEN BEGIN
        IF nElem EQ nUniq THEN BEGIN
           alreadyFixed = [alreadyFixed,'fastLoc.'+tagNames[k]]
        ENDIF ELSE BEGIN
           PRINT,"Replacing " + tagNames[k] + ' ...'
           STR_ELEMENT,fastLoc,tagNames[k],(fastLoc.(k))[uniq_i],/ADD_REPLACE
           fastLoc_is_updated++
        ENDELSE
     ENDIF
  ENDFOR

  ;; ENDIF ELSE BEGIN
  ;;    ;; PRINT,'By all accounts, fastLoc has already been fixed.'
  ;;    PRINT,'By all accounts, fastLoc has already been fixed.'
  ;; ENDELSE

  fastLoc_dt_AND_times_are_updated = 0B
  CASE 1 OF
     N_ELEMENTS(fastLoc_delta_t) EQ nUniq: BEGIN
        alreadyFixed = [alreadyFixed,'fastLoc_delta_t']
     END
     ELSE: BEGIN
        PRINT,"Fixing fastLoc_delta_t ..."
        fastLoc_delta_t = fastLoc_delta_t[uniq_i]
        fastLoc_dt_and_times_are_updated += 1B
     END
  ENDCASE

  IF N_ELEMENTS(fastLoc_times) GT 0 THEN BEGIN
     CASE 1 OF
        (N_ELEMENTS(fastLoc_times) EQ nUniq): BEGIN
           alreadyFixed = [alreadyFixed,'fastLoc_times']
        END
        ELSE: BEGIN
           PRINT,"Fixing fastLoc_times ..."
           fastLoc_times   = fastLoc_times[uniq_i]
           fastLoc_dt_and_times_are_updated += 1B
        END
     ENDCASE
  ENDIF

  STOP

  IF fastLoc_is_updated THEN BEGIN
     PRINT,"Saving fastLoc ..."
     SAVE,fastLoc,FILENAME=defDBDir+defDBFile
  ENDIF ELSE BEGIN
     PRINT,"Nothing to update for fastLoc!"
  ENDELSE

  IF fastLoc_dt_and_times_are_updated THEN BEGIN
     SAVE,fastLoc_delta_t,fastLoc_times,FILENAME=defDBDir+defDB_tFile
  ENDIF ELSE BEGIN
     PRINT,"Nothing to update with fastLoc_delta_t or fastLoc_times!"
  ENDELSE

  STOP

  ;;Now the coordinate files
  nCoordFiles = N_ELEMENTS(coordFilArr)
  coordStr_is_updated = MAKE_ARRAY(nCoordFiles,VALUE=0,/INTEGER)
  FOR k=0,nCoordFiles-1 DO BEGIN
     PRINT,"Doing " + coordStrName[k] + ' coords ...'

     RESTORE,coordDir+coordFilArr[k]
     execStr = 'coordStr = TEMPORARY('+coordStrName[k]+')'
     IF ~EXECUTE(execStr) THEN STOP
     
     tagNames = TAG_NAMES(coordStr)
     nTags    = N_ELEMENTS(tagNames)
     FOR j=0,nTags-1 DO BEGIN
        ;; IF N_ELEMENTS(coordStr.(k)) EQ nElem THEN BEGIN
        IF N_ELEMENTS(coordStr.(j)) EQ nUniq THEN BEGIN
           alreadyFixed = [alreadyFixed,coordStrName+'.'+tagNames[j]]
        ENDIF ELSE BEGIN
           PRINT,"Replacing " + tagNames[j] + ' ...'
           STR_ELEMENT,coordStr,tagNames[j],(coordStr.(j))[uniq_i],/ADD_REPLACE
           coordStr_is_updated[k] += 1
        ENDELSE

        ;; ENDIF
     ENDFOR

     IF ~EXECUTE(coordStrName[k] + ' = TEMPORARY(coordStr)') THEN STOP

     PRINT,"Finished updating " + coordStrName[k] + '!'
     PRINT,"Have a look: "
     IF ~EXECUTE('HELP,'+coordStrName[k]) THEN STOP

     STOP

     IF coordStr_is_updated[k] THEN BEGIN
        PRINT,"Saving updated " + coordStrName[k] + ' coords to ' + coordFilArr[k] + ' ...'
        IF ~EXECUTE('SAVE,'+coordStrName[k]+',FILENAME="' + coordDir + coordFileArr[k] + '"') THEN STOP
     ENDIF

     IF ~EXECUTE(coordStrName[k] + ' = !NULL') THEN STOP

  ENDFOR

  ;;Now mapRatio
  RESTORE,mapRatDir+mapRatFile
  IF N_ELEMENTS(mapRatio) NE nUniq THEN BEGIN
     PRINT,"Updating mapRatio DB ..."
     mapRatio = mapRatio[uniq_i]

     STOP

     SAVE,mapRatio,FILENAME=mapRatDir+mapRatFile
  ENDIF
     
END
