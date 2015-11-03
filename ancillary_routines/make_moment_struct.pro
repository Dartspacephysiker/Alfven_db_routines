;2015/11/03
FUNCTION MAKE_MOMENT_STRUCT,inputData, $
                            LUN=lun
   ;; MEAN=mean, $
   ;; VARIANCE=variance, $
   ;; SKEWNESS=skewness, $
   ;; KURTOSIS=kurtosis, $
   
  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  ;;define struct
  tmplt   = {tmplt_momentStr, $
             MEAN               : DOUBLE(0), $
             VARIANCE           : DOUBLE(0), $
             SKEWNESS           : DOUBLE(0), $
             KURTOSIS           : DOUBLE(0)}
  
  ;;get moments
  IF N_ELEMENTS(inputData) GT 0 THEN BEGIN
     moments = MOMENT(inputData)  
     
     tmplt.mean     = moments[0]
     tmplt.variance = moments[1]
     tmplt.skewness = moments[2]
     tmplt.kurtosis = moments[3]
  ENDIF

  RETURN,tmplt

END