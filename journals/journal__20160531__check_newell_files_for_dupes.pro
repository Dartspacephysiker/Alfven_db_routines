;;05/31/16
;;OK, by both the CHECK_DUPES messerd and the other, more exhaustive method (find the minimum between values for every single point),
;;it appears there are no duplicates in the Newell files. That's just what we want to hear.
PRO JOURNAL__20160531__CHECK_NEWELL_FILES_FOR_DUPES

  COMPILE_OPT IDL2,STRICTARRSUBS

  firstOrb                = 500
  lastOrb                 = 13680

  eps                     = 0.0005

  ;;Get cdbTime and the DB directory
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,DBDir=dbDir

  orbFile                 = 'Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--orbits.sav'
  RESTORE,dbDir + orbFile

  Newell_DB_dir    = '/SPENCEdata/software/sdt/batch_jobs/Alfven_study/20160520--get_Newell_identification_for_Alfven_events--NOT_despun/Newell_batch_output/'
  Newell_filePref  = 'Newell_et_al_identification_of_electron_spectra--ions_included--Orbit_'

  dupeFile         = '~/Desktop/Dupes_for_jerk_orbs--CHECK_DUPES_messerd.txt'

  nTime            = N_ELEMENTS(cdbTime)
  n_orbArr         = N_ELEMENTS(orbArr)


  OPENW,lun,dupeFile,/GET_LUN

  CHECK_NEWELL_FILES_FOR_DUPES,cdbTime,orbArr,firstOrb,lastOrb,missingOrbArr, $
                               Newell_DB_dir,Newell_filePref, $
                               OUT_ORBS_WITH_DUPES_ARR=outOrbArr, $
                               EPSILON=eps, $
                               LUN=lun


  CLOSE,lun
  FREE_LUN,lun

END
