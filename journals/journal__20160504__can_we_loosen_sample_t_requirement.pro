PRO JOURNAL__20160504__CAN_WE_LOOSEN_SAMPLE_T_REQUIREMENT

  do_despun        = 1

  dateString       = '20160504'

  maxInput         = 2
  binsize          = 0.01

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=do_despun
  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY,ADD_SUFF='--sample_t_variations'

  sample_t_limArr  = [0.01,0.1,0.5]

  FOR i=0,N_ELEMENTS(sample_t_limArr)-1 DO BEGIN
     sample_t_lim     = sample_t_limArr[i]
     inds             = WHERE(maximus.sample_t LE sample_t_lim)
     CGHISTOPLOT,maximus.width_time[inds], $
                 MAXINPUT=maxInput, $
                 BINSIZE=binsize, $
                 OUTPUT=plotDir+'maxHisto--WIDTH_TIME_for_SAMPLE_T_LT_' + STRING(FORMAT='(F0.2)',sample_t_lim) + '--'+dateString+'.png', $
                 TITLE=STRING(FORMAT='("Temporal width of events with sample periods LE ",F0.2," s (GE ",F0.2," Hz)")',sample_t_lim,1./sample_t_lim)
  ENDFOR

END