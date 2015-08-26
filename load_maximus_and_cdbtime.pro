PRO LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime

  DBDir = '/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  DBFile = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--maximus.sav'
  DB_tFile = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav'

  RESTORE,DBDir+DBFile
  RESTORE,DBDir+DB_tFile

END