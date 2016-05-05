;;2016/05/05 So what would happen if we let our hair down?
PRO JOURNAL__20160505__DISTS_OF_PFLUX_EVENTS_FOR_VARIOUS_CURRENT_THRESHOLDS

  do_despun        = 1

  dateString       = '20160505'

  minInput         = -2
  maxInput         = 3
  binsize          = 0.01

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=do_despun
  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY,ADD_SUFF='--pflux_dists_for_various_mag_current_thresholds'

  despunTitleString      = ''
  despunString           = ''
  IF KEYWORD_SET(do_despun) THEN BEGIN
     despunTitleString   = ' (Despun)'
     despunString        = '--despun'
  ENDIF

  absMagCArr       = [1,5,10]
  ;; sample_t_limArr  = [0.01,0.1,0.5]

  FOR mag_i=0,N_ELEMENTS(absMagCArr)-1 DO BEGIN
     ;; FOR i=0,N_ELEMENTS(sample_t_limArr)-1 DO BEGIN
        magC             = absMagCArr[mag_i]
        ;; sample_t_lim     = sample_t_limArr[i]
        inds             = WHERE(ABS(maximus.mag_current) GE magC)

        title            = STRING(FORMAT='(" Log Pflux (mW/m!U2!N) for |J!Dmag!N| GE ",I0," microA/m!U2!N")', $
                                  magC) + despunTitleString
        output           = plotDir+STRING(FORMAT='("maxHisto--PFLUXEST_for_ABS_magc_GE_",I0)',$
                                          magC) +despunString+'--'+dateString+'.png'

        CGHISTOPLOT,ALOG10(maximus.pFluxEst[inds]), $
                    MININPUT=minInput, $
                    MAXINPUT=maxInput, $
                    BINSIZE=binsize, $
                    OUTPUT=output, $
                    TITLE=title
     ;; ENDFOR
  ENDFOR

END