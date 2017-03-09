;;06/11/16
;;Oh my goodness, the whole DB I've put together is garbage because I was using the S/C potential incorrectly (or actually not
;;using it at all). So I need to see if things are salvageable.
PRO JOURNAL__20160611__SEE_IF_ESPECS_ARE_SALVAGEABLE_DESPITE_SC_POT_DEBACLE

  COMPILE_OPT IDL2,STRICTARRSUBS

  orbit          = 500
  orbStr         = STRCOMPRESS(orbit,/REMOVE_ALL)

  LOAD_ORBIT_INTERVAL_DB,intervalArr
  

  n_intvls       = GET_ORBIT_N_INTERVALS(orbit) 

  IF n_intvls EQ 0 THEN BEGIN
     PRINT,'Sorry, no intervals for this orbit'
     PRINT,'Returning...'
     RETURN
  ENDIF 

  inDir          = '/SPENCEdata/software/sdt/batch_jobs/Alfven_study/20160520--get_Newell_identification_for_Alfven_events--NOT_despun/Newell_batch_output/'
  inFile_pref    = 'Newell_et_al_identification_of_electron_spectra--ions_included--Orbit_'

  inFile         = STRING(FORMAT=
  
  RESTORE,

END
