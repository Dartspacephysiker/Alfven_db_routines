;+
; NAME:                      GET_CUSTOM_ALFVENDB_QUANTITY
;
;
;
; PURPOSE:                   Get whatever you want, however you want!
;
;
;
; CATEGORY:
;
;
;
; CALLING SEQUENCE:
;
;
;
; INPUTS:
;
;
;
; OPTIONAL INPUTS:
;
;
;
; KEYWORD PARAMETERS:
;
;
;
; OUTPUTS:
;
;
;
; OPTIONAL OUTPUTS:
;
;
;
; COMMON BLOCKS:
;
;
;
; SIDE EFFECTS:
;
;
;
; RESTRICTIONS:
;
;
;
; PROCEDURE:
;
;
;
; EXAMPLE:
;
;
;
; MODIFICATION HISTORY:
;
;-

FUNCTION GET_CUSTOM_ALFVENDB_QUANTITY,comingRightUp,MAXIMUS=maximus,OBS_INDS=obs_inds, $
                                      GET_OBS_INDS__STRING=get_obs_inds__string, $
                                      OUT_OBS_INDS=out_obs_inds, $
                                      VERBOSE=verbose, $
                                      PRINT_OPERATIONS=print_operations

  IF KEYWORD_SET(print_operations) THEN BEGIN
     ;; PRINT,'The variable passed as input to GET_CUSTOM_ALFVENDB_QUANTITY must be a LIST, structured as follows:'
     ;; PRINT,'(["UNITARY OPERATION",]Alfven_DB_index,"BINARY OPERATION",Alfven_DB_index,"BINARY OPERATION", ... ]'
     ;; PRINT,''
     ;; PRINT,'For example, custom = LIST("LOG",49,"DIV_BY","LOG",18,"TIMES","POW",0.5,"MAG_RATIO")'
     ;; PRINT,' would give ALOG10(Poynting flux)/ALOG10(integrated_upflowing_ion_flux)*(mapRatio

     PRINT,"Just type in exactly what you want, and I'll execute it. For example,"
     PRINT," custom_maxInd = ALOG10(maximus.(49)[obs_ind])/ALOG10(maximus.(18)[obs_ind]*(mapRatio.ratio[obs_ind])^(0.5)"
     PRINT," would give you some pretty awesome stuff."
     PRINT,"K?"
     PRINT,""
     RETURN,0
  ENDIF

  get_mapRatio_DB          = WHERE(STRMATCH(comingRightUp, '*mapratio*', /FOLD_CASE) EQ 1)
  IF get_mapRatio_DB[0] NE -1 THEN BEGIN
     LOAD_MAPPING_RATIO_DB,mapRatio,DO_DESPUNDB=maximus.despun
  ENDIF

  IF KEYWORD_SET(verbose) THEN PRINT,'Getting this quantity: ' + comingRightUp

  IF KEYWORD_SET(get_obs_inds__string) THEN BEGIN
     IF KEYWORD_SET(verbose) THEN PRINT, '... but getting these inds first: ' + get_obs_inds__string
     OK = EXECUTE("obs_inds = " + get_obs_inds__string)
     IF ~OK THEN BEGIN
        PRINT,"Houghff! Couldn't get obs_inds with that juvenile, malformed string you provided!"
        RETURN,-1
     ENDIF ELSE BEGIN
        out_obs_inds       = obs_inds
     ENDELSE
  ENDIF

  ;; custom_quantity          = EXECUTE(comingRightUp)
  OK = EXECUTE("custom_quantity = " + comingRightUp)

  IF OK THEN BEGIN
     RETURN,custom_quantity
  ENDIF ELSE BEGIN
     PRINT,"Couldn't get inds!!!"
     STOP
     RETURN,-1
  ENDELSE

END