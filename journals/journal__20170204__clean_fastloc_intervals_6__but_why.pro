;;02/04/17
;;Why should this have to be cleaned??
PRO JOURNAL__20170204__CLEAN_FASTLOC_INTERVALS_6__BUT_WHY

  COMPILE_OPT IDL2

  DefDBDir      = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals6/'
  defDBFile     = 'fastLoc_intervals6--20170204--500-24507--Je_times.sav'
  defDB_tFile   = 'fastLoc_intervals6--20170204--500-24507--Je_times--time_and_delta_t.sav'

  RESTORE,defDBDir+defDBFile
  RESTORE,defDBDir+defDB_tFile

  uniq_i = UNIQ(fastLoc_times,SORT(fastLoc_times))

  nElem     = N_ELEMENTS(fastLoc_times)
  tag_names = TAG_NAMES(fastLoc)

  FOR k=0,N_ELEMENTS(tag_names)-1 DO BEGIN
     IF N_ELEMENTS(fastLoc.(k)) EQ nElem THEN BEGIN
        PRINT,"Replacing " + tag_names[k] + ' ...'
        STR_ELEMENT,fastLoc,tag_names[k],(fastLoc.(k))[uniq_i],/ADD_REPLACE
     ENDIF
  ENDFOR

  fastLoc_delta_t = fastLoc_delta_t[uniq_i]
  fastLoc_times   = fastLoc_times[uniq_i]

  STOP

  PRINT,"Saving things ..."
  SAVE,fastLoc,FILENAME=defDBDir+defDBFile
  SAVE,fastLoc_delta_t,fastLoc_times,FILENAME=defDBDir+defDB_tFile

END
