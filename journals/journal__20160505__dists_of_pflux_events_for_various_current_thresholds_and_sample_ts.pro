;;2016/05/05 So what would happen if we let our hair down?
PRO JOURNAL__20160505__DISTS_OF_PFLUX_EVENTS_FOR_VARIOUS_CURRENT_THRESHOLDS_AND_SAMPLE_TS

  do_despun        = 0

  dateString       = '20160505'

  minInput         = -2
  maxInput         = 3
  binsize          = 0.01

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=do_despun
  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY,ADD_SUFF='--pflux_dists_for_various_mag_current_AND_sample_t_thresholds'

  despunTitleString      = ''
  despunString           = ''
  IF KEYWORD_SET(do_despun) THEN BEGIN
     despunTitleString   = ' (Despun)'
     despunString        = '--despun'
  ENDIF

  absMagCArr       = [1,5,10]
  sample_t_limArr  = [0.01,0.1,0.5]

  FOR mag_i=0,N_ELEMENTS(absMagCArr)-1 DO BEGIN
     FOR i=0,N_ELEMENTS(sample_t_limArr)-1 DO BEGIN
        magC             = absMagCArr[mag_i]
        sample_t_lim     = sample_t_limArr[i]
        inds             = WHERE(ABS(maximus.mag_current) GE magC)

        title            = STRING(FORMAT='(" Log Pflux (mW/m!U2!N) for T!Dsample!N LE ",F0.2," s, |J!Dmag!N| GE ",I0," microA/m!U2!N")', $
                                  sample_t_lim, $
                                  magC) + despunTitleString
        output           = plotDir+STRING(FORMAT='("maxHisto--PFLUXEST_for_SAMPLE_T_LT_",F0.2,"--ABS_magc_GE_",I0)',$
                                          sample_t_lim, $
                                          magC) +despunString+'--'+dateString+'.png'

        CGHISTOPLOT,ALOG10(maximus.pFluxEst[inds]), $
                    MININPUT=minInput, $
                    MAXINPUT=maxInput, $
                    BINSIZE=binsize, $
                    OUTPUT=output, $
                    TITLE=title
     ENDFOR
  ENDFOR

END
