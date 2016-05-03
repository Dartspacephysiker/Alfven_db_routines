;;2016/05/03 NOTE, I have edited LOAD_MAXIMUS_AND_CDBTIME so that now these should be brought into correspondence.
PRO JOURNAL__20160503__THE_REAL_POYNTING_FLUX

  ;;The real factor for conversion, since delta_e is given in mV/m (1e-3) and delta_b is given in nT (1e-9)
  mu_0 = 4.0D * !PI * 1e-7
  ;;so pFlux = DOUBLE(( maximus.delta_e * 1e-3)*(maximus.delta_b * 1e-9)/(mu_0))

  ;;plot stuff
  maxVal     = 6700
  maxInput   = 3.5

  LOAD_MAXIMUS_AND_CDBTIME,maximus,/GET_GOOD_I,good_i=good_i,DO_DESPUNDB=0
  LOAD_MAPPING_RATIO_DB,mapRatio,DO_DESPUNDB=0
  pFlux_notDespun = DOUBLE(( maximus.delta_e[good_i] * 1e-3)*(maximus.delta_b[good_i] * 1e-9)/(mu_0))*mapRatio.ratio[good_i]

  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY

  cghistoplot,ALOG10(maximus.pfluxest[good_i]), $
              TITLE='Log Poynting flux estimates (NOT despun), 100km', $
              MAX_VALUE=maxVal, $
              MIN_VALUE=0, $
              MAXINPUT=maxInput, $
              OUTPUT=plotDir+'log_pfluxest_dist--good_i--NOT_despun--100km.png'

  cghistoplot,ALOG10(pFlux_notDespun), $
              TITLE='Log Poynting flux estimates (NOT despun, recalced), 100km', $
              MAX_VALUE=maxVal, $
              MIN_VALUE=0, $
              MAXINPUT=maxInput, $
              OUTPUT=plotDir+'log_pfluxest_dist--good_i--NOT_despun--recalced--100km.png'


  ;Now despun
  LOAD_MAXIMUS_AND_CDBTIME,maximus,/GET_GOOD_I,good_i=good_i,/FORCE_LOAD_MAXIMUS,DO_DESPUNDB=1 
  LOAD_MAPPING_RATIO_DB,mapRatio,DO_DESPUNDB=1
  good_i=GET_CHASTON_IND(maximus,/BOTH_HEMIS,/RESET_GOOD_INDS)

  pFlux_despun = DOUBLE(( maximus.delta_e[good_i] * 1e-3)*(maximus.delta_b[good_i] * 1e-9)/(mu_0))*mapRatio.ratio[good_i]

  cghistoplot,ALOG10(maximus.pfluxest[good_i]),OUTPUT=plotDir+'log_pfluxest_dist--good_i--despun--100km.png', $
              TITLE='Log Poynting flux estimates (despun), 100km', $
              MAX_VALUE=maxVal, $
              MIN_VALUE=0, $
              MAXINPUT=maxInput

  cghistoplot,ALOG10(pFlux_despun),OUTPUT=plotDir+'log_pfluxest_dist--good_i--despun--recalced--100km.png', $
              TITLE='Log Poynting flux estimates (despun, recalced), 100km', $
              MAX_VALUE=maxVal, $
              MIN_VALUE=0, $
              MAXINPUT=maxInput


END