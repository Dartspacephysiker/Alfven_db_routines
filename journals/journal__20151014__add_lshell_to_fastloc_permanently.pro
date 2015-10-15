PRO JOURNAL__20151014__ADD_LSHELL_TO_FASTLOC_PERMANENTLY

  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastLoc_times,fastLoc_delta_t,DBDIR=dbDir,DBFILE=dbFile
  newDBFile='fastLoc_intervals2--500-16361_all--w_lshell--20151015.sav'

  ADD_LSHELL_TO_FASTLOC,fastLoc

  SAVE,fastLoc,filename=dbDir+newDBFile

END