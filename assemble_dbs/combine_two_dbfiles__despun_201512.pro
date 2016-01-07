PRO COMBINE_TWO_DBFILES__DESPUN_201512,maximus,cdbTime, $
                                       DBFILE1=dbFile1, $
                                       DB_TFILE1=db_tFile1, $
                                       DBFILE2=dbFile2, $
                                       DB_TFILE2=db_tFile2, $
                                       SAVE_COMBINED_FILE=save_combined_file, $
                                       OUTFILE=outFile, $
                                       OUT_TFILE=out_tFile
  ;2015/06/09
  ;This will take two separate maximus saves and smash them together, ordered by time

  date                 = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  
  defDBDir1            = '/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  defDBFile1           = 'Dartdb_20160108--502-3619--maximus.sav'
  defDB_tFile1         = 'Dartdb_20160108--502-3619--cdbtime.sav'

  defDBDir2            = '/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  defDBFile2           = 'Dartdb_20160108--3621-10168--maximus.sav'
  defDB_tFile2         = 'Dartdb_20160108--3621-10168--cdbtime.sav'

  IF KEYWORD_SET(save_combined_file) THEN BEGIN
     suff = date + '--500-16361_despun--'
     outDir='/SPENCEdata/Research/Cusp/database/dartdb/saves/'
     IF ~KEYWORD_SET(outFile) THEN outFile=outDir+'Dartdb_' + suff + 'maximus.sav'
     IF ~KEYWORD_SET(out_tFile) THEN out_tFile=outDir+'Dartdb_' + suff + 'cdbtime.sav'
  ENDIF

  ;first DB file
  IF ~KEYWORD_SET(dbFile1) THEN dbFile1=defDBDir1+defDBFile1
  IF ~KEYWORD_SET(db_tFile1) THEN db_tFile1=defDBDir1+defDB_tFile1
  restore,dbFile1
  restore,db_tFile1

  print,"DB File 1: " + dbFile1
  maximus1=maximus
  cdbTime1=cdbTime

  ;second DB file
  IF ~KEYWORD_SET(dbFile2) THEN dbFile2=defDBDir2+defDBFile2
  IF ~KEYWORD_SET(db_tFile2) THEN db_tFile2=defDBDir2+defDB_tFile2
  restore,dbFile2
  restore,db_tFile2

  print,"DB File 2: " + dbFile2
  maximus2=maximus
  cdbTime2=cdbTime

  ;sort 'em
  sort_i = SORT([cdbTime1,cdbTime2])

  ;save 'em
  cdbTime=([cdbTime1,cdbTime2])(sort_i)

  maximus={orbit:([maximus1.orbit,maximus2.orbit])(sort_i),$
           alfvenic:([maximus1.alfvenic,maximus2.alfvenic])(sort_i),$
           TIME:([maximus1.time,maximus2.time])(sort_i),$
           ALT:([maximus1.alt,maximus2.alt])(sort_i),$
           MLT:([maximus1.mlt,maximus2.mlt])(sort_i),$
           ILAT:([maximus1.ilat,maximus2.ilat])(sort_i),$
           MAG_CURRENT:([maximus1.MAG_CURRENT,maximus2.MAG_CURRENT])(sort_i),$
           ESA_CURRENT:([maximus1.ESA_CURRENT,maximus2.ESA_CURRENT])(sort_i),$
           ELEC_ENERGY_FLUX:([maximus1.ELEC_ENERGY_FLUX,maximus2.ELEC_ENERGY_FLUX])(sort_i),$
           INTEG_ELEC_ENERGY_FLUX:([maximus1.INTEG_ELEC_ENERGY_FLUX,maximus2.INTEG_ELEC_ENERGY_FLUX])(sort_i),$
           EFLUX_LOSSCONE_INTEG:([maximus1.EFLUX_LOSSCONE_INTEG,maximus2.EFLUX_LOSSCONE_INTEG])(sort_i),$
           total_eflux_integ:([maximus1.total_eflux_integ,maximus2.total_eflux_integ])(sort_i),$
           max_chare_losscone:([maximus1.max_chare_losscone,maximus2.max_chare_losscone])(sort_i),$
           max_chare_total:([maximus1.max_chare_total,maximus2.max_chare_total])(sort_i),$
           ION_ENERGY_FLUX:([maximus1.ION_ENERGY_FLUX,maximus2.ION_ENERGY_FLUX])(sort_i),$
           ION_FLUX:([maximus1.ION_FLUX,maximus2.ION_FLUX])(sort_i),$
           ION_FLUX_UP:([maximus1.ION_FLUX_UP,maximus2.ION_FLUX_UP])(sort_i),$
           INTEG_ION_FLUX:([maximus1.INTEG_ION_FLUX,maximus2.INTEG_ION_FLUX])(sort_i),$
           INTEG_ION_FLUX_UP:([maximus1.INTEG_ION_FLUX_UP,maximus2.INTEG_ION_FLUX_UP])(sort_i),$
           CHAR_ION_ENERGY:([maximus1.CHAR_ION_ENERGY,maximus2.CHAR_ION_ENERGY])(sort_i),$
           WIDTH_TIME:([maximus1.WIDTH_TIME,maximus2.WIDTH_TIME])(sort_i),$
           WIDTH_X:([maximus1.WIDTH_X,maximus2.WIDTH_X])(sort_i),$
           DELTA_B:([maximus1.DELTA_B,maximus2.DELTA_B])(sort_i),$
           DELTA_E:([maximus1.DELTA_E,maximus2.DELTA_E])(sort_i),$
           SAMPLE_T:([maximus1.SAMPLE_T,maximus2.SAMPLE_T])(sort_i),$
           MODE:([maximus1.MODE,maximus2.MODE])(sort_i),$
           PROTON_FLUX_UP:([maximus1.PROTON_FLUX_UP,maximus2.PROTON_FLUX_UP])(sort_i),$
           PROTON_CHAR_ENERGY:([maximus1.PROTON_CHAR_ENERGY,maximus2.PROTON_CHAR_ENERGY])(sort_i),$
           OXY_FLUX_UP:([maximus1.OXY_FLUX_UP,maximus2.OXY_FLUX_UP])(sort_i),$
           OXY_CHAR_ENERGY:([maximus1.OXY_CHAR_ENERGY,maximus2.OXY_CHAR_ENERGY])(sort_i),$
           HELIUM_FLUX_UP:([maximus1.HELIUM_FLUX_UP,maximus2.HELIUM_FLUX_UP])(sort_i),$
           HELIUM_CHAR_ENERGY:([maximus1.HELIUM_CHAR_ENERGY,maximus2.HELIUM_CHAR_ENERGY])(sort_i),$
           SC_POT:([maximus1.SC_POT,maximus2.SC_POT])(sort_i),$
           L_PROBE:([maximus1.L_PROBE,maximus2.L_PROBE])(sort_i),$
           MAX_L_PROBE:([maximus1.MAX_L_PROBE,maximus2.MAX_L_PROBE])(sort_i),$
           MIN_L_PROBE:([maximus1.MIN_L_PROBE,maximus2.MIN_L_PROBE])(sort_i),$
           MEDIAN_L_PROBE:([maximus1.MEDIAN_L_PROBE,maximus2.MEDIAN_L_PROBE])(sort_i),$
           START_TIME:([maximus1.START_TIME,maximus2.START_TIME])(sort_i),$
           STOP_TIME:([maximus1.STOP_TIME,maximus2.STOP_TIME])(sort_i),$
           TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE:([maximus1.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE,maximus2.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE])(sort_i),$
           TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT:([maximus1.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT,maximus2.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT])(sort_i),$
           TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX:([maximus1.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX,maximus2.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX])(sort_i),$
           TOTAL_ION_OUTFLOW_SINGLE:([maximus1.TOTAL_ION_OUTFLOW_SINGLE,maximus2.TOTAL_ION_OUTFLOW_SINGLE])(sort_i),$
           TOTAL_ION_OUTFLOW_MULTIPLE_TOT:([maximus1.TOTAL_ION_OUTFLOW_MULTIPLE_TOT,maximus2.TOTAL_ION_OUTFLOW_MULTIPLE_TOT])(sort_i),$
           TOTAL_ALFVEN_ION_OUTFLOW:([maximus1.TOTAL_ALFVEN_ION_OUTFLOW,maximus2.TOTAL_ALFVEN_ION_OUTFLOW])(sort_i),$
           TOTAL_UPWARD_ION_OUTFLOW_SINGLE:([maximus1.TOTAL_UPWARD_ION_OUTFLOW_SINGLE,maximus2.TOTAL_UPWARD_ION_OUTFLOW_SINGLE])(sort_i),$
           TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT:([maximus1.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT,maximus2.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT])(sort_i),$
           TOTAL_ALFVEN_UPWARD_ION_OUTFLOW:([maximus1.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW,maximus2.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW])(sort_i)}

  ;check 'em
  IF ARRAY_EQUAL(sort(cdbTime),indgen(n_elements(cdbTime),/L64)) THEN PRINT, "They're equal!"

  IF KEYWORD_SET(save_combined_file) THEN BEGIN
     PRINT,'Saving...'
     PRINT,'OUTFILE: ' + outFile
     PRINT,'OUT_TFILE: ' + out_tFile

     save,maximus,filename=outFile
     save,cdbTime,filename=out_tFile

  ENDIF

  return

end
