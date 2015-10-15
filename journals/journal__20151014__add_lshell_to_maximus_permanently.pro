PRO JOURNAL__20151014__ADD_LSHELL_TO_MAXIMUS_PERMANENTLY

  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbtime,DBDIR=dbDir,DBFILE=dbFile

  newDBFile='Dartdb_20151014--500-16361_inc_lower_lats--burst_1000-16361--w_Lshell--maximus.sav'

  ADD_LSHELL_TO_MAXIMUS,maximus

  ;; SAVE,maximus,filename=dbDir+newDBFile

END