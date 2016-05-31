;;05/31/16
PRO JOURNAL__20160531__EXTRACT_HUGE_TIMESERIES_FROM_NEWELL_FILES

  COMPILE_OPT IDL2

  firstOrb                = 500
  lastOrb                 = 14000

  outDir                  = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'
  outTimeSeriesFile       = STRING(FORMAT='("alf_eSpec_20151222_db--TIME_SERIES_AND_ORBITS--Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                   firstOrb, $
                                   lastOrb, $
                                   GET_TODAY_STRING(/DO_YYYYMMDD_FMT))


  Newell_DB_dir    = '/SPENCEdata/software/sdt/batch_jobs/Alfven_study/20160520--get_Newell_identification_for_Alfven_events--NOT_despun/Newell_batch_output/'
  Newell_filePref  = 'Newell_et_al_identification_of_electron_spectra--ions_included--Orbit_'

  EXTRACT_TIME_SERIES_FROM__NEWELL_FILES,firstOrb,lastOrb,missingOrbArr, $
                                         Newell_DB_dir,Newell_filePref, $
                                         OUT_TS=eSpec_times_final, $
                                         OUT_ORBARR=orbArr_final, $
                                         LUN=lun

  PRINT,'Saving these buggers to ' + outTimeSeriesFile + '...'
  SAVE,eSpec_times_final,orbArr_final,FILENAME=outDir+outTimeSeriesFile


END
