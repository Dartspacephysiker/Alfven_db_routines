PRO JOURNAL__20160504__CAN_WE_LOOSEN_MAG_CURRENT_REQUIREMENT

  do_despun        = 0

  dateString       = '20160504'

  maxInput         = 2
  binsize          = 0.01

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=do_despun
  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY,ADD_SUFF='--mag_currents_variations_AND_sample_t_variations'

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
        inds             = WHERE(maximus.sample_t LE sample_t_lim AND ABS(maximus.mag_current) GE magC)

        title            = STRING(FORMAT='(" for T!Dsample!N LE ",F0.2," s, |J!Dmag!N| GE ",I0," microA/m!U2!N")', $
                                  sample_t_lim, $
                                  magC) + despunTitleString
        output           = plotDir+STRING(FORMAT='("maxHisto--WIDTH_TIME_for_SAMPLE_T_LT_",F0.2,"--ABS_magc_GE_",I0)',$
                                          sample_t_lim, $
                                          magC) +despunString+'--'+dateString+'.png'

        CGHISTOPLOT,maximus.width_time[inds], $
                    MAXINPUT=maxInput, $
                    BINSIZE=binsize, $
                    OUTPUT=output, $
                    TITLE=title
     ENDFOR
  ENDFOR
END