PRO TRIM_FASTLOC_MEMBERS,fastLoc


  date    = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  outFile = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01.sav'


  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc, $
                                 DBFILE=dbfile, $
                                 DBDIR=dbdir

  fastLoc = {ORBIT:fastLoc.orbit, $         
             TIME:fastLoc.time, $          
             ALT:FLOAT(fastLoc.alt), $           
             MLT:FLOAT(fastLoc.mlt), $           
             ILAT:FLOAT(fastLoc.ilat), $          
             ;; FIELDS_MODE:fastLoc.fields_mode, $   
             SAMPLE_T:FLOAT(fastLoc.sample_t)}
  

  PRINT,'Saving trimmed fastLoc to ' + outFile + ' ...'
  SAVE,fastLoc,FILENAME=dbDir+outFile

END