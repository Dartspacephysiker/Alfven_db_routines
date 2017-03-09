;+
; NAME:                  FASTLOC_CLEANER
;
; PURPOSE:               Get rid of all those nasty NaNs and huge values in various quanitities.
;                        The other issue is that without this, we have no idea which fields modes are acceptable
;                        
;
; CALLING SEQUENCE:      good_indices = fastloc_cleaner(maximus)
;
; INPUTS:                fastLoc
;
; OUTPUTS:
;
; MODIFICATION HISTORY:  
; 2015/10/16    Born, inspired by ALFVEN_DB_CLEANER.
;                 

; 
; 
;-

FUNCTION FASTLOC_CLEANER,fastLoc, $
                         FOR_ESPEC_DBS=for_eSpec_DBs, $
                         SAMPLE_T_RESTRICTION=sample_t_restriction, $
                         INCLUDE_32Hz=include_32Hz, $
                         DISREGARD_SAMPLE_T=disregard_sample_t, $
                         LUN=lun

  COMPILE_OPT idl2,strictarrsubs

  ;;If not lun, just send to stdout
  IF NOT KEYWORD_SET(lun) THEN lun = -1

  ;;First make sure fastLoc is present
  IF N_ELEMENTS(fastLoc) EQ 0 THEN BEGIN
     PRINTF,lun,"No such structure as fastLoc! Can't clean up FAST ephemeris DB."
     PRINTF,lun,"Returning..."
     ;; RETURN, !NULL
     RETURN, !NULL
  ENDIF

  ;;These were pulled from the fields mode sheets, located at http://sprg.ssl.berkeley.edu/fast/scienceops/modes/fmodes.htm
  ;;We require the fluxgate magnetometer to be sampling at 128 S/s
  ;; valid_fields_modes = [ ]

  @alfven_db_cleaner_defaults.pro
  IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
     sample_t_hcutoff = 5.00
     PRINT,'Cleaning fastLoc version for eSpec DBs...'
  ENDIF 

  ;**********
  ;   NaNs  *
  ;**********

  ;;number of events in total
  n_events = N_ELEMENTS(fastLoc.orbit)
     
     
  PRINTF,lun,""
  PRINTF,lun,"****FASTLOC_CLEANER****"

  good_i = BASIC_DB_CLEANER(fastLoc,/CLEAN_NANS_AND_INFINITIES, $
                            SAMPLE_T_RESTRICTION=sample_t_restriction, $
                            INCLUDE_32Hz=include_32Hz, $
                            DISREGARD_SAMPLE_T=disregard_sample_t, $
                            FOR_ESPEC_DBS=for_eSpec_DBs)

  ;******************
  ;   Other limits  *
  ;******************
  
     
  ;; Now sample_t stuff
  ;; good_i = cgsetintersection(good_i,where(fastLoc.sample_t LE sample_t_hcutoff,/NULL))
  
  ;; nlost = n_events-n_elements(good_i)
  ;; printf,lun,FORMAT='("N lost to user-defined cutoffs:",T35,I0)', nlost

  PRINTF,lun,"****END FASTLOC_CLEANER****"
  PRINTF,lun,""

  RETURN, good_i

END
