;;2017/02/01
;;Bill pointed out to me yesterday that what I showed in the Jack Eddy proposal is actually the opposite of what Rother et al. [2007]
;;were showing. In their plot, the average FAC amplitude starts to drop off dramatiskt at whatever frequency corresponds to ~1-km
;;scales. The question is, what exactly did my plot show? I worry that it may have simply been an artifact of the IAW algorithm, since
;;we don't allow any FACs with width_t ≥ 2.5 s to be considered Alfvénic.
PRO JOURNAL__20170201__CUSP__MAX_FAC_AMPLITUDES__HIGH_ALT__SHOW_BILL

  COMPILE_OPT IDL2

  pMaxFAC  = 1
  pMeanFAC = 1
  pMedFAC  = 1
  pMinFAC  = 1

  @common__maximus_vars.pro

  outFPref  = 'IAW_'
  outFSuff  = 'FAC_vs_width_v1.png'
  ;; plotDir   = '/home/spencerh/Desktop/Spence_paper_drafts/2017/Active--not_paper/Jack_Eddy/Application_matière/Figs/'
  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY
  
  noMapping = 0

  ;;Histogram properties/lims
  save_png  = 0
  PS        = 0

  frequency = 1
  freqYLim  = 0.2
  yTitleSuff = 'IAW FAC Amplitude ($\mu$A/m!U2!N)'
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

  ;; hemi = 'BOTH'
  ;; minM = 11.5
  ;; maxM = 12.5
  ;; minI = 72
  ;; maxI = 86
  
  hemi = 'BOTH'
  minM = 9.5
  maxM = 14.5
  minI = 58
  maxI = 90
  
  IF KEYWORD_SET(minM) OR KEYWORD_SET(maxM) THEN BEGIN
     mltStr  = STRING(FORMAT='("_",I0,"-",I0,"MLT")',minM,maxM)
     mltTStr = STRING(FORMAT='(I0,"-",I0," MLT")',minM,maxM)
  ENDIF ELSE BEGIN
     mltStr  = ''
     mltTStr = ''
  ENDELSE

  altRange = [ $
             ;; [300,700] $
             ;; [700,1700], $
             ;; [1700,2700], $
             ;; [2700,3700], $
             [300,1000], $ ;Leave me alone! I am not counted in the plots
             [1000,4300] $ ;Leave me alone! I am not counted in the plots
             ]
  colors    = ['black','blue']
  lineStyle = ['-','--']
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

  wCenterList  = LIST()
  maxFACList   = LIST()
  minFACList   = LIST()
  medFACList   = LIST()
  meanFACList  = LIST()
  altStringArr = !NULL
  nLoop        = N_ELEMENTS(i_final)
  FOR k=0,nLoop-1 DO BEGIN

     altitudeRange = altRange[*,k]
     ;;alt string
     altString = STRING(FORMAT='("_",I0,"-",I0,"km")',altitudeRange)
     ;; title     = STRING(FORMAT='(I0,"-",I0," km")',altitudeRange)

     ;;FAC spectrum
     logwidth  = ALOG10(MAXIMUS__maximus.width_x[i_final[k]])
     fac       = ABS(MAXIMUS__maximus.mag_current[i_final[k]])

     logStep = 0.5
     logIncr = 0.1
     maxFAC  = !NULL
     minFAC  = !NULL
     medFAC  = !NULL
     meanFAC = !NULL
     wCenter = !NULL
     curWid  = MIN(logWidth)
     maxWid  = MAX(logWidth)
     WHILE curWid LT maxWid DO BEGIN
        wCenter = [wCenter,curWid+logStep/2.]
        tmpInds = WHERE(logWidth GE curWid AND logWidth LT (curWid+logStep))

        maxFAC  = [maxFAC,MAX(fac[tmpInds])]
        minFAC  = [maxFAC,MIN(fac[tmpInds])]
        medFAC  = [medFAC,MEDIAN(fac[tmpInds])]
        meanFAC = [meanFAC,MEAN(fac[tmpInds])]

        curWid += logIncr
     ENDWHILE
     
     wCenterList.Add,wCenter
     maxFACList.Add,maxFAC
     minFACList.Add,minFAC
     medFACList.Add,medFAC
     meanFACList.Add,meanFAC
     altStringArr = [altStringArr,altString]

  ENDFOR

  goAgain = KEYWORD_SET(pMaxFAC) + $
            KEYWORD_SET(pMinFAC) + $
            KEYWORD_SET(pMedFAC) + $
            KEYWORD_SET(pMeanFAC)

  WHILE goAgain GT 0 DO BEGIN

     plotArr = MAKE_ARRAY(nLoop,/OBJ)

     FOR k=0,nLoop-1 DO BEGIN

        CASE 1 OF
           KEYWORD_SET(pMaxFAC): BEGIN
              plotFAC = maxFACList[k]
              yTitle  = "Max " + yTitleSuff
              outFTyp = 'max'
           END
           KEYWORD_SET(pMinFAC): BEGIN
              plotFAC = minFACList[k]
              yTitle  = "Min " + yTitleSuff
              outFTyp = 'min'
           END
           KEYWORD_SET(pMedFAC): BEGIN
              plotFAC = medFACList[k]
              yTitle  = "Median " + yTitleSuff
              outFTyp = 'med'
           END
           KEYWORD_SET(pMeanFAC): BEGIN
              plotFAC = meanFACList[k]
              yTitle  = "Mean " + yTitleSuff
              outFTyp = 'mean'
           END
        ENDCASE
        outFName = outFPref + outFTyp + mltStr + outFSuff

        ;; !P.MULTI=[0,3,1,0,0]
        ;; xSize = 1200
        ;; ySize = 400

        IF k EQ 0 THEN BEGIN
           window = WINDOW(DIMENSIONS=[800,600])
        ENDIF
        ;; WINDOW,0,XSIZE=xSize,YSIZE=ySize
        
        plotArr[k] = PLOT(10.^(wCenter)/1000.,plotFAC, $
                          /XLOG, $
                          TITLE=mltTStr, $
                          NAME=(altStringArr[k]).REPLACE('_',''), $
                          ;; XTITLE='FAC width (km)', $
                          XTITLE='Width (km)', $
                          ;; YTITLE='Max FAC Amplitude  ($\mu$A/m!U2!N)', $
                          COLOR=colors[k], $
                          LINESTYLE=lineStyle[k], $
                          THICK=2.0, $
                          YTITLE=yTitle, $
                          FONT_SIZE=20, $
                          CURRENT=window, $
                          OVERPLOT=k GT 0)

        IF KEYWORD_SET(save_png) THEN BEGIN
           window.Save,plotDir + outFName
        ENDIF

     ENDFOR

     leg = LEGEND(TARGET=plotArr, $
                  ;; POSITION=[-20.,((KEYWORD_SET(nEvRange) ? nEvRange : [0,7500])[1])]*0.45, $
                  ;; /DATA, $
                  /AUTO_TEXT_COLOR, $
                  FONT_SIZE=18)

     CASE 1 OF
        KEYWORD_SET(pMaxFAC): BEGIN
           pMaxFac  = 0
        END
        KEYWORD_SET(pMinFAC): BEGIN
           pMinFac  = 0
        END
        KEYWORD_SET(pMedFAC): BEGIN
           pMedFac  = 0
        END
        KEYWORD_SET(pMeanFAC): BEGIN
           pMeanFac = 0
        END
     ENDCASE

     goAgain = KEYWORD_SET(pMaxFAC) + $
               KEYWORD_SET(pMinFAC) + $
               KEYWORD_SET(pMedFAC) + $
               KEYWORD_SET(pMeanFAC)

  ENDWHILE

END

