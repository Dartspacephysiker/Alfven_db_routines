PRO COMBINE_TWO_DBFILES,maximus,cdbTime, $
                        DBFILE1=dbFile1, $
                        DB_TFILE1=db_tFile1, $
                        MAXIMUS1=maximus1, $
                        MAXIMUS2=maximus2, $
                        CDBTIME1=cdbTime1, $
                        CDBTIME2=cdbTime2, $
                        DBFILE2=dbFile2, $
                        DB_TFILE2=db_tFile2, $
                        ADD_PFLUX_AND_LSHELL=add_pflux_and_lshell, $
                        SAVE_COMBINED_FILE=save_combined_file, $
                        OUTFILE=outFile, $
                        OUT_TFILE=out_tFile
  ;2015/06/09
  ;This will take two separate maximus saves and smash them together, ordered by time

  ;; date         = '20150814'
  date         = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  
  defDBDir1    = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  ;; defDBFile1='Dartdb_20150609--500-10000_below_aur_oval--10001-14999_above--maximus_diff.sav'
  ;; defDB_tFile1='Dartdb_20150609--500-10000_below_aur_oval--10001-14999_above--cdbtime_diff.sav'

  ;; defDBFile1='Dartdb_20150611--15000-16361--maximus--below_aur_oval.sav'
  ;; defDB_tFile1='Dartdb_20150611--15000-16361--cdbtime--below_aur_oval.sav'

  defDBFile1   = 'Dartdb_20150611--500-16361_inc_lower_lats--maximus.sav'
  defDB_tFile1 = 'Dartdb_20150611--500-16361_inc_lower_lats--cdbtime.sav'

  defDBDir2    = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  ;; defDBFile2='Dartdb_20150611--10001-14999--maximus--only_below_aur_oval.sav'
  ;; defDB_tFile2='Dartdb_20150611--10001-14999--cdbtime--only_below_aur_oval.sav'
  defDBFile2   = 'tempmaximus.sav'
  defDB_tFile2 = 'tempcdbtime.sav'

  ;;now-unused lines?
  ;; Dartmouth_DB='/SPENCEdata/software/sdt/batch_jobs/Alfven_study/as5_14F/batch_output/'
  ;; contents_file='./orbits_contained_in_DartDBfile_' + date + '--startstops_included.txt'

  IF KEYWORD_SET(save_combined_file) THEN BEGIN
     outDir    = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  ENDIF

  ;first DB file
  IF ~KEYWORD_SET(dbFile1)   THEN dbFile1=defDBDir1+defDBFile1
  IF ~KEYWORD_SET(db_tFile1) THEN db_tFile1=defDBDir1+defDB_tFile1

  IF N_ELEMENTS(maximus1) EQ 0 OR N_ELEMENTS(cdbTime1) EQ 0 THEN BEGIN

     RESTORE,dbFile1
     RESTORE,db_tFile1
     
     PRINT,"DB File 1: " + dbFile1
     maximus1 = maximus
     cdbTime1 = cdbTime

  ENDIF

  ;second DB file
  IF ~KEYWORD_SET(dbFile2)   THEN dbFile2=defDBDir2+defDBFile2
  IF ~KEYWORD_SET(db_tFile2) THEN db_tFile2=defDBDir2+defDB_tFile2

  IF N_ELEMENTS(maximus2) EQ 0 OR N_ELEMENTS(cdbTime2) EQ 0 THEN BEGIN

     RESTORE,dbFile2
     RESTORE,db_tFile2

     PRINT,"DB File 2: " + dbFile2
     maximus2 = maximus
     cdbTime2 = cdbTime

  ENDIF

  ;sort 'em
  sort_i   = SORT([cdbTime1,cdbTime2])

  ;save 'em
  cdbTime  = ([cdbTime1,cdbTime2])[sort_i]

  maximus  = {ORBIT:([maximus1.orbit,maximus2.orbit])[sort_i],$
              ALFVENIC:([maximus1.alfvenic,maximus2.alfvenic])[sort_i],$
              TIME:([maximus1.time,maximus2.time])[sort_i],$
              ALT:([maximus1.alt,maximus2.alt])[sort_i],$
              MLT:([maximus1.mlt,maximus2.mlt])[sort_i],$
              ILAT:([maximus1.ilat,maximus2.ilat])[sort_i],$
              MAG_CURRENT:([maximus1.MAG_CURRENT,maximus2.MAG_CURRENT])[sort_i],$
              ESA_CURRENT:([maximus1.ESA_CURRENT,maximus2.ESA_CURRENT])[sort_i],$
              ELEC_ENERGY_FLUX:([maximus1.ELEC_ENERGY_FLUX,maximus2.ELEC_ENERGY_FLUX])[sort_i],$
              INTEG_ELEC_ENERGY_FLUX:([maximus1.INTEG_ELEC_ENERGY_FLUX,maximus2.INTEG_ELEC_ENERGY_FLUX])[sort_i],$
              EFLUX_LOSSCONE_INTEG:([maximus1.EFLUX_LOSSCONE_INTEG,maximus2.EFLUX_LOSSCONE_INTEG])[sort_i],$
              TOTAL_EFLUX_INTEG:([maximus1.total_eflux_integ,maximus2.total_eflux_integ])[sort_i],$
              MAX_CHARE_LOSSCONE:([maximus1.max_chare_losscone,maximus2.max_chare_losscone])[sort_i],$
              MAX_CHARE_TOTAL:([maximus1.max_chare_total,maximus2.max_chare_total])[sort_i],$
              ION_ENERGY_FLUX:([maximus1.ION_ENERGY_FLUX,maximus2.ION_ENERGY_FLUX])[sort_i],$
              ION_FLUX:([maximus1.ION_FLUX,maximus2.ION_FLUX])[sort_i],$
              ION_FLUX_UP:([maximus1.ION_FLUX_UP,maximus2.ION_FLUX_UP])[sort_i],$
              INTEG_ION_FLUX:([maximus1.INTEG_ION_FLUX,maximus2.INTEG_ION_FLUX])[sort_i],$
              INTEG_ION_FLUX_UP:([maximus1.INTEG_ION_FLUX_UP,maximus2.INTEG_ION_FLUX_UP])[sort_i],$
              CHAR_ION_ENERGY:([maximus1.CHAR_ION_ENERGY,maximus2.CHAR_ION_ENERGY])[sort_i],$
              WIDTH_TIME:([maximus1.WIDTH_TIME,maximus2.WIDTH_TIME])[sort_i],$
              WIDTH_X:([maximus1.WIDTH_X,maximus2.WIDTH_X])[sort_i],$
              DELTA_B:([maximus1.DELTA_B,maximus2.DELTA_B])[sort_i],$
              DELTA_E:([maximus1.DELTA_E,maximus2.DELTA_E])[sort_i],$
              SAMPLE_T:([maximus1.SAMPLE_T,maximus2.SAMPLE_T])[sort_i],$
              MODE:([maximus1.MODE,maximus2.MODE])[sort_i],$
              PROTON_FLUX_UP:([maximus1.PROTON_FLUX_UP,maximus2.PROTON_FLUX_UP])[sort_i],$
              PROTON_CHAR_ENERGY:([maximus1.PROTON_CHAR_ENERGY,maximus2.PROTON_CHAR_ENERGY])[sort_i],$
              OXY_FLUX_UP:([maximus1.OXY_FLUX_UP,maximus2.OXY_FLUX_UP])[sort_i],$
              OXY_CHAR_ENERGY:([maximus1.OXY_CHAR_ENERGY,maximus2.OXY_CHAR_ENERGY])[sort_i],$
              HELIUM_FLUX_UP:([maximus1.HELIUM_FLUX_UP,maximus2.HELIUM_FLUX_UP])[sort_i],$
              HELIUM_CHAR_ENERGY:([maximus1.HELIUM_CHAR_ENERGY,maximus2.HELIUM_CHAR_ENERGY])[sort_i],$
              SC_POT:([maximus1.SC_POT,maximus2.SC_POT])[sort_i],$
              L_PROBE:([maximus1.L_PROBE,maximus2.L_PROBE])[sort_i],$
              MAX_L_PROBE:([maximus1.MAX_L_PROBE,maximus2.MAX_L_PROBE])[sort_i],$
              MIN_L_PROBE:([maximus1.MIN_L_PROBE,maximus2.MIN_L_PROBE])[sort_i],$
              MEDIAN_L_PROBE:([maximus1.MEDIAN_L_PROBE,maximus2.MEDIAN_L_PROBE])[sort_i],$
              START_TIME:([maximus1.START_TIME,maximus2.START_TIME])[sort_i],$
              STOP_TIME:([maximus1.STOP_TIME,maximus2.STOP_TIME])[sort_i],$
              TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE:([maximus1.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE,maximus2.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE])[sort_i],$
              TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT:([maximus1.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT,maximus2.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT])[sort_i],$
              TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX:([maximus1.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX,maximus2.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX])[sort_i],$
              TOTAL_ION_OUTFLOW_SINGLE:([maximus1.TOTAL_ION_OUTFLOW_SINGLE,maximus2.TOTAL_ION_OUTFLOW_SINGLE])[sort_i],$
              TOTAL_ION_OUTFLOW_MULTIPLE_TOT:([maximus1.TOTAL_ION_OUTFLOW_MULTIPLE_TOT,maximus2.TOTAL_ION_OUTFLOW_MULTIPLE_TOT])[sort_i],$
              TOTAL_ALFVEN_ION_OUTFLOW:([maximus1.TOTAL_ALFVEN_ION_OUTFLOW,maximus2.TOTAL_ALFVEN_ION_OUTFLOW])[sort_i],$
              TOTAL_UPWARD_ION_OUTFLOW_SINGLE:([maximus1.TOTAL_UPWARD_ION_OUTFLOW_SINGLE,maximus2.TOTAL_UPWARD_ION_OUTFLOW_SINGLE])[sort_i],$
              TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT:([maximus1.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT,maximus2.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT])[sort_i],$
              TOTAL_ALFVEN_UPWARD_ION_OUTFLOW:([maximus1.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW,maximus2.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW])[sort_i]}
  

  IF KEYWORD_SET(add_pflux_and_lshell) THEN BEGIN
     PRINT,"Adding pFlux and lShell ..."
     ADD_PFLUX_AND_LSHELL_TO_MAXIMUS__BURST_IS_ZERO,maximus
  ENDIF

  ;;check 'em
  IF ARRAY_EQUAL(SORT(cdbTime),INDGEN(N_ELEMENTS(cdbTime),/L64)) THEN BEGIN
     PRINT, "They're equal!"
  ENDIF ELSE BEGIN
     PRINT,"Trouble in River City: cdbTime is not sorted."
     STOP
  ENDELSE
  
  ;; max_resize=resize_maximus(maximus,maximus_ind=1,min_for_ind=0.5,max_for_ind=2)
  
  IF KEYWORD_SET(save_combined_file) THEN BEGIN

     PRINT,'Saving...'
     PRINT,'OUTFILE: ' + outDir+outFile
     PRINT,'OUT_TFILE: ' + out_tFile
     
     SAVE,maximus,FILENAME=outDir+outFile
     SAVE,cdbTime,FILENAME=outDir+out_tFile

  ENDIF

  RETURN

end
