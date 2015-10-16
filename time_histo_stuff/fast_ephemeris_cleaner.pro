;+
; NAME:                  FAST_EPHEMERIS_CLEANER
;
; PURPOSE:               Get rid of all those nasty NaNs and huge values in various quanitities.
;                        The other issue is that without this, we have no idea which fields modes are acceptable
;                        
;
; CALLING SEQUENCE:      good_indices = fast_ephemeris_cleaner(maximus)
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

FUNCTION FAST_EPHEMERIS_CLEANER,fastLoc,LUN=lun

  COMPILE_OPT idl2

  ;;If not lun, just send to stdout
  IF NOT KEYWORD_SET(lun) THEN lun = -1

  ;;First make sure fastLoc is present
  IF N_ELEMENTS(fastLoc) EQ 0 THEN BEGIN
     printf,lun,"No such structure as fastLoc! Can't clean up FAST ephemeris DB."
     printf,lun,"Returning..."
     ;; RETURN, !NULL
     RETURN, !NULL
  ENDIF

  ;;These were pulled from the fields mode sheets, located at http://sprg.ssl.berkeley.edu/fast/scienceops/modes/fmodes.htm
  ;;We require the fluxgate magnetometer to be sampling at 128 S/s
  valid_fields_modes = [ ]

  @alfven_db_cleaner_defaults.pro

  ;**********
  ;   NaNs  *
  ;**********

  ;;number of events in total
  n_events = n_elements(fastLoc.orbit)
     
     
  printf,lun,""
  printf,lun,"****From fast_ephemeris_cleaner.pro****"

  mlt_hcutoff = 24.0
  mlt_lcutoff = 0.0

  ilat_hcutoff = 90.0
  ilat_lcutoff = -90.0

  orbit_hcutoff = 16361
  orbit_lcutoff = 500

  fieldsmode_lcutoff = 0


  good_i = WHERE(fastLoc.ILAT LE ilat_hcutoff AND fastLoc.ILAT GE ilat_lcutoff)
  good_i = cgsetintersection(good_i,WHERE(fastLoc.MLT LE mlt_hcutoff AND fastLoc.MLT GE 0.0))
  good_i = cgsetintersection(good_i,WHERE(fastLoc.MLT LE mlt_hcutoff AND fastLoc.MLT GE 0.0))
  good_i = cgsetintersection(good_i,WHERE(fastLoc.ORBIT LE orbit_hcutoff AND fastLoc.ORBIT GE orbit_lcutoff))

  nlost = n_events-n_elements(good_i)
  printf,lun,FORMAT='("N lost to NaNs, infinities    :",T35,I0)',nlost
  n_events -=nlost
  
  ;******************
  ;   Other limits  *
  ;******************
  
     
  ;; Now sample_t stuff
  good_i = cgsetintersection(good_i,where(fastLoc.sample_t LE sample_t_hcutoff,/NULL))
  
  nlost = n_events-n_elements(good_i)
  printf,lun,FORMAT='("N lost to user-defined cutoffs:",T35,I0)', nlost

  printf,lun,"****END fast_ephemeris_cleaner.pro****"
  printf,lun,""

  RETURN, good_i

END
