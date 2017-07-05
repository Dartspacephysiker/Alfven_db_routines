;2017/07/03
PRO JOURNAL__20170703__TEST_H2DVARIANCE_ROUTINE

  COMPILE_OPT IDL2,STRICTARRSUBS

  MIMC_struct = {minI : 60., $
                 minM : 0., $
                 maxI : 90., $
                 maxM : 24., $
                 binI : 2.5, $
                 binM : 1.5}

  nElemPerBin = 1000
  mltArr      = [12.5,15.5,0.5]
  ilatArr     = [60.5,70.5,80.5]
  means       = [10,100,1000]
  vars        = [5,50,500]
  mlts        = [REPLICATE(mltArr[0],nElemPerBin),REPLICATE(mltArr[1],nElemPerBin),REPLICATE(mltArr[2],nElemPerBin)]
  ilats       = [REPLICATE(ilatArr[0],nElemPerBin),REPLICATE(ilatArr[1],nElemPerBin),REPLICATE(ilatArr[2],nElemPerBin)]
  inData      = [RANDOMU(seed,nElemPerBin,/NORMAL)*vars[0]+means[0], $
                 RANDOMU(seed,nElemPerBin,/NORMAL)*vars[1]+means[1], $
                 RANDOMU(seed,nElemPerBin,/NORMAL)*vars[2]+means[2]]

  h2dDat      = HIST2D(mlts, $
                       ilats,$
                       (KEYWORD_SET(logAvgPlot) OR KEYWORD_SET(tmpLogAvg) ? ALOG10(DOUBLE(inData)) : DOUBLE(inData)),$
                       MIN1=(MIMC_struct.minM), $
                       MIN2=(MIMC_struct.minI),$
                       MAX1=(MIMC_struct.maxM), $
                       MAX2=(MIMC_struct.maxI),$
                       BINSIZE1=(MIMC_struct.binM), $
                       BINSIZE2=(MIMC_struct.binI),$
                       OBIN1=outH2DBinsMLT, $
                       OBIN2=outH2DBinsILAT, $
                       DENSITY=density, $
                       /CALCVARIANCE, $
                       OUT_VARIANCE=calcVars) 

  nz_i = WHERE(density GT 0,nNZ)
  IF nNZ GT 0 THEN BEGIN
     h2dDat[nz_i] /= density[nz_i]
  ENDIF

  ;; STOP

  ;; vars        = HIST2D_VARIANCE(mlts, $
  ;;                               ilats,$
  ;;                               (KEYWORD_SET(logAvgPlot) OR KEYWORD_SET(tmpLogAvg) ? ALOG10(DOUBLE(inData)) : DOUBLE(inData)),$
  ;;                               means,$
  ;;                               MIN1=(MIMC_struct.minM), $
  ;;                               MIN2=(MIMC_struct.minI),$
  ;;                               MAX1=(MIMC_struct.maxM), $
  ;;                               MAX2=(MIMC_struct.maxI),$
  ;;                               BINSIZE1=(MIMC_struct.binM), $
  ;;                               BINSIZE2=(MIMC_struct.binI),$
  ;;                               OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT)

  
  PRINT,"Actual/Calculated Means"
  FOREACH nz,nz_i,k DO BEGIN
     PRINT,FORMAT='(F10.2,"/",F10.2)',means[k],h2dDat[nz]
     ENDFOREACH
    
  PRINT,""
  PRINT,"Actual/Calculated Std. Devs"
  FOREACH nz,nz_i,k DO BEGIN
     PRINT,FORMAT='(F10.2,"/",F10.2)',vars[k],SQRT(calcVars[nz])
  ENDFOREACH


  STOP

END
