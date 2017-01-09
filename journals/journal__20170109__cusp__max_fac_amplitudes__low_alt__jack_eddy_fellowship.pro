;;2017/01/09
PRO JOURNAL__20170109__CUSP__MAX_FAC_AMPLITUDES__LOW_ALT__JACK_EDDY_FELLOWSHIP

  COMPILE_OPT IDL2

  @common__maximus_vars.pro

  outFName  = 'AW_maxFAC_vs_width_v1.png'
  plotDir   = '/home/spencerh/Desktop/Spence_paper_drafts/2017/Active--not_paper/Jack_Eddy/Application_matière/Figs/'

  noMapping = 0

  ;;Histogram properties/lims
  PS        = 0

  frequency = 1
  freqYLim  = 0.2
  IF ~KEYWORD_SET(noMapping) THEN BEGIN
     freqYLim = 0.08
  ENDIF
  magCXLim  = 20
  magCYLim  = KEYWORD_SET(frequency) ? freqYLim : 1000
  binSize   = 2
  absMagC   = 1

  minMC     = 1
  maxNegMC  = -1

  force_load_maximus = 1

  IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 OR $
     KEYWORD_SET(force_load_maximus) $
  THEN BEGIN
     LOAD_MAXIMUS_AND_CDBTIME,DO_NOT_MAP_ANYTHING=noMapping, $
                              FORCE_LOAD_BOTH=force_load_maximus
  ENDIF

  hemi = 'BOTH'
  minM = 11.5
  maxM = 12.5
  minI = 72
  maxI = 86
  
  altRange = [ $
             [300,700] $
             ;; [700,1700], $
             ;; [1700,2700], $
             ;; [2700,3700], $
             ;; [300,4300] $ ;Leave me alone! I am not counted in the plots
             ]

  ;; dstCutoff            = -30
  ;; nonStorm             = 1
  do_not_consider_IMF  = 1
  
  use_prev_plot_i      = 1
  remake_prev_plot_i   = 1
  justInds             = 1

  nIter                = N_ELEMENTS(altRange[0,*])

  i_final              = LIST()
  FOR k=0,nIter-1 DO BEGIN

     altitudeRange = altRange[*,k]

     PLOT_ALFVEN_STATS__SETUP, $
        MINILAT=minI, $
        MAXILAT=maxI, $
        MINMLT=minM, $
        MAXMLT=maxM, $
        MIN_MAGCURRENT=minMC, $
        MAX_NEGMAGCURRENT=maxNegMC, $
        HEMI=hemi, $
        ALTITUDERANGE=altitudeRange, $
        DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
        DSTCUTOFF=dstCutoff, $
        NONSTORM=nonStorm, $
        JUSTINDS_THENQUIT=justInds, $
        DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
        ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
        MIMC_STRUCT=MIMC_struct, $
        IMF_STRUCT=IMF_struct, $
        ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct
     
     PLOT_ALFVEN_STATS_IMF_SCREENING, $
        ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
        MIMC_STRUCT=MIMC_struct, $
        IMF_STRUCT=IMF_struct, $
        ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
        USE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=use_prev_plot_i, $
        REMAKE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=remake_prev_plot_i, $
        OUT_PLOT_I_LIST=plot_i_list

     PRINT,FORMAT='("Got ",I0," inds for altitude range [",I0,",",I0,"]")', $
           N_ELEMENTS(plot_i_list[0]), $
           altitudeRange
     
     i_final.Add,plot_i_list[0]

  ENDFOR

  ;;FAC spectrum
  logwidth  = ALOG10(MAXIMUS__maximus.width_x[i_final[0]])
  fac       = ABS(MAXIMUS__maximus.mag_current[i_final[0]])

  logstep = 0.2
  meanFAC = !NULL
  medFAC  = !NULL
  maxFAC  = !NULL
  wCenter = !NULL
  curWid  = MIN(logWidth)
  maxWid  = MAX(logWidth)
  WHILE curWid LT maxWid DO BEGIN
     wCenter = [wCenter,curWid+logstep/2.]
     tmpInds = WHERE(logWidth GE curWid AND logWidth LT (curWid+logstep))

     meanFAC = [meanFAC,MEAN(fac[tmpInds])]
     medFAC  = [medFAC,MEDIAN(fac[tmpInds])]
     maxFAC  = [maxFAC,MAX(fac[tmpInds])]

     curWid += logstep
  ENDWHILE
     
  !P.MULTI=[0,3,1,0,0]
  xSize = 1200
  ySize = 400

  WINDOW,0,XSIZE=xSize,YSIZE=ySize
  
  plotMax = PLOT(10.^(wCenter)/1000.,maxFAC, $
                 /XLOG, $
                 ;; XTITLE='FAC width (km)', $
                 XTITLE='Width (km)', $
                 ;; YTITLE='Max FAC Amplitude  ($\mu$A/m!U2!N)', $
                 YTITLE='Amplitude ($\mu$A/m!U2!N)', $
                 FONT_SIZE=20)

  plotMax.Save,plotDir + outFName


  STOP

END

