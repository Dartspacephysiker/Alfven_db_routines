PRO JOURNAL__20160107__GET_ALFORBITS_AND_CDBTIME_FOR_MAPPING_PFLUX_SDTBATCHJOB

  dataDir        = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  inFile         = 'Dartdb_20160107--502-16361_despun--maximus--pflux--lshell--burst--noDupes.sav'
  in_tFile       = 'Dartdb_20160107--502-16361_despun--cdbtime--noDupes.sav'

  outDir         = '/home/spencerh/software/sdt/batch_jobs/map_Poyntingflux__20151217/'
  outFile        = 'alfTimes_and_alfOrbits--20160107_despun_DB.sav'

  restore,dataDir+inFile
  restore,dataDir+in_tFile

  alforbits      = maximus.orbit

  PRINT,'Saving ' + outDir + outFile + '...'
  save,alforbits,cdbtime,FILENAME=outDir+outFile

END