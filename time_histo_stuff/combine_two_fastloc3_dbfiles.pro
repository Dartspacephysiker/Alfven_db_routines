PRO combine_two_fastloc3_dbfiles,fastLoc,fastLoc_times,DBFILE1=dbFile1,DB_TFILE1=db_tFile1,DBFILE2=dbFile2,DB_TFILE2=db_tFile2
  ;2015/10/20
  ;This smashes together two fastloc3 DB files, ordered by time

  outDir='/SPENCEdata/Research/Cusp/database/time_histos/'

  date1='20151020'
  defDBDir1 ='/SPENCEdata/Research/Cusp/database/time_histos/'
  dbSuffix1='500-12500--below_aur_oval'
  DBSansFExt1 = 'fastLoc_intervals3--'+dbSuffix1+'--'+date1
  defDBFile1 = DBSansFExt1+'.sav'
  defDB_tFile1 = DBSansFExt1+'--times.sav'
  defDB_tRawFile1 = DBSansFExt1+'--times.sav_raw'

  date2='20151021'
  defDBDir2 ='/SPENCEdata/Research/Cusp/database/time_histos/'
  dbSuffix2='12501-16361--below_aur_oval'
  DBSansFExt2 = 'fastLoc_intervals3--'+dbSuffix2+'--'+date2
  defDBFile2 = DBSansFExt2+'.sav'
  defDB_tFile2 = DBSansFExt2+'--times.sav'
  defDB_tRawFile2 = DBSansFExt2+'--times.sav_raw'

  outDir='/SPENCEdata/Research/Cusp/database/time_histos/'
  outSuffix='500-16361_all'
  outFileSansPref = 'fastLoc_intervals3--'+outSuffix+'--'+date
  outFile = outDir+outFileSansPref+'.sav'
  outTimeFile = outDir+outFileSansPref+'--times.sav'
  outTimeFile_raw = outDir+outFileSansPref+'--times.sav_raw'

  ;first DB file
  IF ~KEYWORD_SET(dbFile1) THEN dbFile1=defDBDir1+defDBFile1
  IF ~KEYWORD_SET(db_tFile1) THEN db_tFile1=defDBDir1+defDB_tFile1
  IF ~KEYWORD_SET(db_tRawFile1) THEN db_tRawFile1=defDBDir1+defDB_tRawFile1
  restore,dbFile1
  restore,db_tFile1

  print,"DB File 1: " + dbFile1
  fastLoc1=fastLoc
  fastLoc_times1=fastLoc_times
  fastLoc_delta_t1=fastLoc_delta_t

  ;second DB file
  IF ~KEYWORD_SET(dbFile2) THEN dbFile2=defDBDir2+defDBFile2
  IF ~KEYWORD_SET(db_tFile2) THEN db_tFile2=defDBDir2+defDB_tFile2
  IF ~KEYWORD_SET(db_tRawFile2) THEN db_tRawFile2=defDBDir2+defDB_tRawFile2
  restore,dbFile2
  restore,db_tFile2

  print,"DB File 2: " + dbFile2
  fastLoc2=fastLoc
  fastLoc_times2=fastLoc_times
  fastLoc_delta_t2=fastLoc_delta_t

  ;raw time files
  restore,db_tRawFile1
  fastLoc_timesRaw1=fastLoc_times
  fastLoc_delta_tRaw1=fastLoc_delta_t
  
  restore,db_tRawFile2
  fastLoc_timesRaw2=fastLoc_times
  fastLoc_delta_tRaw2=fastLoc_delta_t

  ;sort 'em
  sort_i = SORT([fastLoc_times1,fastLoc_times2])
  
  ;combine 'em
  fastLoc_times=([fastLoc_times1,fastLoc_times2])[sort_i]
  fastLoc_delta_t=([fastLoc_delta_t1,fastLoc_delta_t2])[sort_i]

  fastLoc_timesRaw=([fastLoc_timesRaw1,fastLoc_timesRaw2])[sort_i]
  fastLoc_delta_tRaw=([fastLoc_delta_tRaw1,fastLoc_delta_tRaw2])[sort_i]

  fastLoc={ORBIT:([fastLoc1.orbit,fastLoc2.orbit])[sort_i],$
           TIME:([fastLoc1.time,fastLoc2.time])[sort_i],$
           ALT:([fastLoc1.alt,fastLoc2.alt])[sort_i],$
           MLT:([fastLoc1.mlt,fastLoc2.mlt])[sort_i],$
           ILAT:([fastLoc1.ilat,fastLoc2.ilat])[sort_i],$
           FIELDS_MODE:([fastLoc1.FIELDS_MODE,fastLoc2.FIELDS_MODE])[sort_i],$
           SAMPLE_T:([fastLoc1.SAMPLE_T,fastLoc2.SAMPLE_T])[sort_i],$
           INTERVAL:([fastLoc1.INTERVAL,fastLoc2.INTERVAL])[sort_i],$
           INTERVAL_START:([fastLoc1.INTERVAL_START,fastLoc2.INTERVAL_START])[sort_i],$
           INTERVAL_STOP:([fastLoc1.INTERVAL_STOP,fastLoc2.INTERVAL_STOP])[sort_i],$
           LSHELL:([fastLoc1.LSHELL,fastLoc2.LSHELL])[sort_i]}

  
  save,fastLoc,filename=outFile
  
  ;do fastloctimes
  ;; fastLoc_times = str_to_time(fastLoc.time)
  ;; fastLoc_delta_t = shift(fastLoc_Times,-1)-fastLoc_Times
  save,fastLoc_TimesRaw,fastLoc_delta_tRaw,FILENAME=outTimeFile_raw
  ;; fastLoc_delta_t[-1] = 10.0                                ;treat last element specially, since otherwise it is a huge negative number
  ;; fastLoc_delta_t = ROUND(fastLoc_delta_t*4.0)/4.0          ;round to nearest quarter of a second
  ;; fastLoc_delta_t(WHERE(fastLoc_delta_t GT 10.0)) = 10.0    ;many events with a large delta_t correspond to ends of intervals/orbits
  save,fastLoc_times,fastLoc_delta_t,filename=outTimeFile

  ;check 'em
  IF ARRAY_EQUAL(sort(fastLoc_times),indgen(n_elements(fastLoc_times),/L64)) THEN PRINT, "They're equal!"

  RETURN

END
