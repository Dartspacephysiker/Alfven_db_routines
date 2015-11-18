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
             KURTOSIS           : DOUBLE(0), $
             BS_MEDIAN          : MAKE_ARRAY(3,/DOUBLE)}
  
  ;;get moments
  IF N_ELEMENTS(inputData) GT 0 THEN BEGIN
     moments           = MOMENT(inputData)  

     nData = N_ELEMENTS(inputData)

     ;be judicious about nBoot
     CASE 1 OF
        (nData GT 0) AND (nData LT 1000)     : nBoot = 1000
        (nData GE 1000) AND (nData LT 5000)  : nBoot = 100
        (nData GE 5000) AND (nData LT 10000) : nBoot = 50
        (nData GE 10000) AND (nData LT 100000) : nBoot = 10
        (nData GE 100000) : BEGIN
           PRINT,"More than 100000 elements being provided to BOOTSTRAP_MEDIAN! Setting nBoot = 2..."
           nBoot = 2
        END
        ELSE : BEGIN
           PRINT,"Empty data array provided to make_moment struct!"
           WAIT,1
        END
     ENDCASE

     bs_median         = BOOTSTRAP_MEDIAN(inputData,NBOOT=nBoot)
     tmplt.mean        = moments[0]
     tmplt.variance    = moments[1]
     tmplt.skewness    = moments[2]
     tmplt.kurtosis    = moments[3]
     tmplt.bs_median   = bs_median
  ENDIF

  RETURN,tmplt

END