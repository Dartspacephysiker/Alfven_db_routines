;;06/11/16
PRO LOAD_ORBIT_INTERVAL_DB,intervalArr

  COMPILE_OPT IDL2,STRICTARRSUBS

  COMMON ORB_INTERVALS,OI__intervalArr

  as5_dir                                = '/SPENCEdata/software/sdt/batch_jobs/Alfven_study/20160520--get_Newell_identification_for_Alfven_events--NOT_despun/'
  intervalArrFile                        = "orb_and_num_intervals--0-16361.sav" ;;Use it to figure out which file to restore

  IF N_ELEMENTS(OI__intervalArr) EQ 0 THEN BEGIN
     PRINT,'Restoring orbit interval array ...'
     RESTORE,as5_dir+intervalArrFile
     OI__intervalArr                     = intervalArr
  ENDIF ELSE BEGIN
     intervalArr                         = OI__intervalArr
  ENDELSE

END
