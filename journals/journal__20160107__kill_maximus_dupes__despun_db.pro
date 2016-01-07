;;OH YEAH, FOOOOL!!!!!! WASSUP NOW!!!!
PRO JOURNAL__20160107__KILL_MAXIMUS_DUPES__DESPUN_DB

  dataDir    = '/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  DBFile     = 'Dartdb_20160107--502-16361_despun--maximus--pflux--lshell--burst.sav'
  DB_tFile   = 'Dartdb_20160107--502-16361_despun--cdbtime.sav'

  outFile    = 'Dartdb_20160107--502-16361_despun--maximus--pflux--lshell--burst--noDupes.sav'
  out_tFile  = 'Dartdb_20160107--502-16361_despun--cdbtime--noDupes.sav'

  print,'Restoring ' + DBFile + '...'
  restore,dataDir+DBFile

  print,'Restoring ' + DB_tFile + '...'
  restore,dataDir+DB_tFile
 
  check_dupes,cdbtime,OUT_DUPE_I=out_dupe_i,printdupes='n'

  UNIQ_II    = uniq(cdbtime[out_dupe_i])
  
  uniq_i     = uniq(cdbtime)

  maximus    = resize_maximus(maximus,CDBTIME=cdbTime,INDS=uniq_i)

  save,maximus,filename=dataDir+outFile
  save,cdbTime,filename=dataDir+out_tFile

END