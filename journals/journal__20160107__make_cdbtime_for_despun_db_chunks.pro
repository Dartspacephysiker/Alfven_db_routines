;2016/01/07
PRO JOURNAL__20160107__MAKE_CDBTIME_FOR_DESPUN_DB_CHUNKS

  outDBDir             = '/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  outDBFile            = 'Dartdb_20160108--502-16361--despun--maximus.sav'
  outDB_tFile          = 'Dartdb_20160108--502-16361--despun--cdbtime.sav'

  defDBDir1            = '/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  defDBFile1           = 'Dartdb_20160108--502-3619--maximus.sav'
  defDB_tFile1         = 'Dartdb_20160108--502-3619--cdbtime.sav'

  defDBDir2            = '/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  defDBFile2           = 'Dartdb_20160108--3621-10168--maximus.sav'
  defDB_tFile2         = 'Dartdb_20160108--3621-10168--cdbtime.sav'

  defDBDir3            = '/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  defDBFile3           = 'Dartdb_20160108--10170-16361--maximus.sav'
  defDB_tFile3         = 'Dartdb_20160108--10170-16361--cdbtime.sav'

  PRINT,'Restoring DB1: ' + defDBFile1
  restore,defDBDir1+defDBFile1
  maximus1             = maximus
  cdbTime1             = STR_TO_TIME(maximus1.time)

  PRINT,'Restoring DB2: ' + defDBFile2
  restore,defDBDir2+defDBFile2
  maximus2             = maximus
  cdbTime2             = STR_TO_TIME(maximus2.time)

  PRINT,'Restoring DB3: ' + defDBFile3
  restore,defDBDir3+defDBFile3
  maximus3             = maximus
  cdbTime3             = STR_TO_TIME(maximus3.time)

  ;;combine and save mah'mus
  ;;it doesn't work, gotta do something like COMBINE_TWO_DBFILES__DESPUN_201512
  ;; maximus              = [maximus1,maximus2,maximus3]
  ;; save,maximus,filename=outDBDir + outDBFile

  ;;combine and save cdbTime
  ;; cdbTime              = [cdbTime1,cdbTime2,cdbTime3]
  ;; save,cdbTime,filename=outDBDir + outDB_tFile
  
  ;; cdbtime=cdbtime1
  ;; save,cdbtime,filename=defDBDir1+defDB_tFile1

  ;; cdbtime=cdbtime2
  ;; save,cdbtime,filename=defDBDir2+defDB_tFile2

  ;; cdbtime=cdbtime3
  ;; save,cdbtime,filename=defDBDir3+defDB_tFile3

END