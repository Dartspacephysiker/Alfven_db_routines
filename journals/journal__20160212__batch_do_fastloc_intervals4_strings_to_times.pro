PRO JOURNAL__20160212__BATCH_DO_FASTLOC_INTERVALS4_STRINGS_TO_TIMES

  RESTORE,'/SPENCEdata/Research/Cusp/Alfven_db_routines/fl_i4__timestrings.temp'

  sizeIter   = 100000L
  nIter      = LONG(N_ELEMENTS(times)/sizeIter)

  ;; FOR i=0,nIter-2 DO BEGIN
  FOR i=45,nIter-2 DO BEGIN
     PRINT,i*sizeIter,(i+1)*sizeIter-1
     
     conv_and_save_times,times[i*sizeIter:(i+1)*sizeIter-1],'fl_i4_times--iter_'+STRCOMPRESS(i,/REMOVE_ALL)+'.sav'
  ENDFOR
END