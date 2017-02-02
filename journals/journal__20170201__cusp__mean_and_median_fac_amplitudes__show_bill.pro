;;2017/02/01
;;K, now we're going to overlay mean and median FAC amplitudes
PRO JOURNAL__20170201__CUSP__MEAN_AND_MEDIAN_FAC_AMPLITUDES__SHOW_BILL,I_FINAL=i_final

  COMPILE_OPT IDL2

  pMeanFAC = [1,0,0,0]
  pMedFAC  = [0,1,0,0]
  pMaxFAC  = [0,0,0,0]
  pMinFAC  = [0,0,0,0]
  ;; pMaxFAC  = 1
  ;; pMinFAC  = 1

  ;; maxMember = 'mag_current'
  ;; maxMember = 'delta_e'
  ;; maxMember = 'delta_b'
  maxMember = 'width_time'

  IF (N_ELEMENTS(pMeanFAC) NE N_ELEMENTS(pMedFAC)) OR $
     (N_ELEMENTS(pMeanFAC) NE N_ELEMENTS(pMaxFAC)) OR $
     (N_ELEMENTS(pMeanFAC) NE N_ELEMENTS(pMinFAC)) OR $
     (N_ELEMENTS(pMedFAC ) NE N_ELEMENTS(pMaxFAC)) OR $
     (N_ELEMENTS(pMedFAC ) NE N_ELEMENTS(pMinFAC)) OR $
     (N_ELEMENTS(pMaxFAC ) NE N_ELEMENTS(pMinFAC))    $
  THEN BEGIN
     STOP
  ENDIF

  @common__maximus_vars.pro

  outFPref  = 'IAW'
  outFSuff  = '_vs_width.png'
  plotExt   = '.png'
  ;; plotDir   = '/home/spencerh/Desktop/Spence_paper_drafts/2017/Active--not_paper/Jack_Eddy/Application_matière/Figs/'
  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY
  
  noMapping = 0

  ;;Histogram properties/lims
  save_png  = 1
  PS        = 0

  frequency = 0
  freqYLim  = 0.2

  yTitleSuff = KEYWORD_SET(noMapping) ? ' at s/c alt' : ' mapped to 100 km'
  CASE STRUPCASE(maxMember) OF
     'MAG_CURRENT': BEGIN
        yTitle    = 'IAW FAC Amplitude ($\mu$A/m!U2!N)' + yTitleSuff
        name      = 'FAC_' 
     END
     'DELTA_E': BEGIN
        yTitle    = '$\Delta$E (mV/m!U2!N)' + yTitleSuff
        name      = 'deltaE_' 
     END
     'DELTA_B': BEGIN
        yTitle    = '$\Delta$B (nT)' + yTitleSuff
        name      = 'deltaB_' 
     END
     'WIDTH_TIME': BEGIN
        yTitle    = 'Width (s)' + yTitleSuff
        name      = 'widthT_' 
        yLog      = 1
     END
     ELSE: BEGIN
     END
  ENDCASE
  outFSuff = name + outFSuff

  IF ~KEYWORD_SET(noMapping) THEN BEGIN
     freqYLim = 0.08
  ENDIF
  magCXLim  = 20
  magCYLim  = KEYWORD_SET(frequency) ? freqYLim : 1000
  binSize   = 2
  absMagC   = 1

  minMC     = 1
  maxNegMC  = -1

  ;; hemi = 'BOTH'
  ;; minM = 11.5
  ;; maxM = 12.5
  ;; minI = 72
  ;; maxI = 86
  
  hemi = 'BOTH'
  ;; minM = 11.5
  ;; maxM = 13.5
  minM = 10.0
  maxM = 14.0
  minI = 58
  maxI = 90
  
  IF KEYWORD_SET(minM) OR KEYWORD_SET(maxM) THEN BEGIN
     mltStr  = STRING(FORMAT='("_",F0.1,"-",F0.1,"MLT")',minM,maxM)
     mltTStr = STRING(FORMAT='(F0.1,"-",F0.1," MLT")',minM,maxM)
  ENDIF ELSE BEGIN
     mltStr  = ''
     mltTStr = ''
  ENDELSE

  altRange = [ $
             ;; [300,700] $
             ;; [700,1700], $
             ;; [1700,2700], $
             ;; [2700,3700], $
             [ 300,1000], $ ;Leave me alone! I am not counted in the plots
             ;; [ 700,2000], $ ;Leave me alone! I am not counted in the plots
             [1000,4300]  $ ;Leave me alone! I am not counted in the plots
             ]
  colors    = ['black','blue','green','red']
  lineStyle = ['-','--','-.',':']
  ;; dstCutoff            = -30
  ;; nonStorm             = 1
  do_not_consider_IMF    = 1
  dont_blackball_maximus = 1
  

  force_load_maximus = 1
  IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 OR $
     KEYWORD_SET(force_load_maximus) $
  THEN BEGIN
     LOAD_MAXIMUS_AND_CDBTIME,DO_NOT_MAP_ANYTHING=noMapping, $
                              FORCE_LOAD_BOTH=force_load_maximus

     maxInd = WHERE(STRUPCASE(TAG_NAMES(MAXIMUS__maximus)) EQ STRUPCASE(maxMember))
     IF maxInd[0] EQ -1 THEN STOP

  ENDIF

  IF N_ELEMENTS(i_final) EQ 0 THEN BEGIN

     use_prev_plot_i    = 1
     remake_prev_plot_i = 1
     justInds           = 1

     i_final            = LIST()
     nIter              = N_ELEMENTS(altRange[0,*])
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


  ENDIF
  ;;Before looping, figure out how many 'dat we're going to get
  logwidth  = ALOG10( $
              MAXIMUS__maximus.width_x[LIST_TO_1DARRAY(i_final, $
                                                       /WARN, $
                                                       /SKIP_NEG1_ELEMENTS)])
  logStep = 0.5
  logIncr = 0.1
  minWid  = MIN(logWidth)
  maxWid  = MAX(logWidth)

  curWid  = minWid
  nPts    = 0
  wCenter = !NULL
  WHILE curWid LT maxWid DO BEGIN
     wCenter = [wCenter,curWid+logStep/2.]
     curWid += logIncr
     nPts++
  ENDWHILE

  ;; wCenterList  = LIST()
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
     logWidth  = ALOG10(MAXIMUS__maximus.width_x[i_final[k]])
     fac       = ABS(MAXIMUS__maximus.(maxInd)[i_final[k]])

     ;; maxFAC  = !NULL
     ;; minFAC  = !NULL
     ;; medFAC  = !NULL
     ;; meanFAC = !NULL
     ;; wCenter = !NULL
     maxFAC  = MAKE_ARRAY(nPts,VALUE=!VALUES.F_NaN,/FLOAT)
     minFAC  = MAKE_ARRAY(nPts,VALUE=!VALUES.F_NaN,/FLOAT)
     medFAC  = MAKE_ARRAY(nPts,VALUE=!VALUES.F_NaN,/FLOAT)
     meanFAC = MAKE_ARRAY(nPts,VALUE=!VALUES.F_NaN,/FLOAT)
     ;; wCenter = MAKE_ARRAY(nPts,VALUE=!VALUES.F_NaN,/FLOAT)
     curWid  = minWid
     maxWid  = MAX(logWidth)
     ptInd   = 0
     WHILE curWid LT maxWid DO BEGIN
        ;; wCenter = [wCenter,curWid+logStep/2.]
        tmpInds = WHERE(logWidth GE curWid AND logWidth LT (curWid+logStep))

        ;; maxFAC  = [maxFAC,MAX(fac[tmpInds])]
        ;; minFAC  = [maxFAC,MIN(fac[tmpInds])]
        ;; medFAC  = [medFAC,MEDIAN(fac[tmpInds])]
        ;; meanFAC = [meanFAC,MEAN(fac[tmpInds])]

        IF tmpInds[0] NE -1 THEN BEGIN
           maxFAC[ptInd]  = MAX(fac[tmpInds])
           minFAC[ptInd]  = MIN(fac[tmpInds])
           medFAC[ptInd]  = MEDIAN(fac[tmpInds])
           meanFAC[ptInd] = MEAN(fac[tmpInds])
        ENDIF
        
        ptInd++
        curWid += logIncr
     ENDWHILE
     
     ;; wCenterList.Add,wCenter
     maxFACList.Add,maxFAC
     minFACList.Add,minFAC
     medFACList.Add,medFAC
     meanFACList.Add,meanFAC
     altStringArr = [altStringArr,altString]

  ENDFOR

  whenMax  = WHERE(pMaxFAC EQ 1 ,nMax)
  whenMin  = WHERE(pMinFAC EQ 1 ,nMin)
  whenMed  = WHERE(pMedFAC EQ 1 ,nMed)
  whenMean = WHERE(pMeanFAC EQ 1,nMean)
  ;; nOrder = N_ELEMENTS(pMaxFAC) > N_ELEMENTS(pMinFAC) > N_ELEMENTS(pMedFAC) > N_ELEMENTS(pMeanFAC)
  nOrder   = MAX([whenMax,whenMin,whenMed,whenMean]) + 1
  IF nOrder LT 1 THEN STOP

  ;;Legend order
  legOrder = !NULL 
  FOR k=0,nLoop-1 DO legOrder = [legOrder,INDGEN(nLoop)*nOrder+k]
  
  ;; xRange   = (10.^([MIN(LIST_TO_1DARRAY(wCenterList)), $
  ;;                   MAX(LIST_TO_1DARRAY(wCenterList))]))/1000.

  repetez = 1
  WHILE repetez DO BEGIN

     nPlots   = nOrder * nLoop
     plotArr  = MAKE_ARRAY(nPlots,/OBJ)

     goAgain  = 0
     outFTyp  = ''
     WHILE goAgain LT nOrder DO BEGIN

        FOR k=0,nLoop-1 DO BEGIN

           CASE 1 OF
              KEYWORD_SET(pMaxFAC[goAgain]): BEGIN
                 plotFAC  = maxFACList[k]
                 nSuff    = " (Max)" 
                 IF k EQ 0 THEN outFTyp += '_max'
              END
              KEYWORD_SET(pMinFAC[goAgain]): BEGIN
                 plotFAC  = minFACList[k]
                 nSuff    = " (Min)" 
                 IF k EQ 0 THEN outFTyp += '_min'
              END
              KEYWORD_SET(pMedFAC[goAgain]): BEGIN
                 plotFAC  = medFACList[k]
                 nSuff    = " (Median)"
                 IF k EQ 0 THEN outFTyp += '_med'
              END
              KEYWORD_SET(pMeanFAC[goAgain]): BEGIN
                 plotFAC  = meanFACList[k]
                 nSuff    = " (Mean)"
                 IF k EQ 0 THEN outFTyp += '_mean'
              END
           ENDCASE

           ;; !P.MULTI=[0,3,1,0,0]
           ;; xSize = 1200
           ;; ySize = 400
           first = (goAgain EQ 0) AND (k EQ 0)

           IF first THEN BEGIN
              window = WINDOW(DIMENSIONS=[800,600])
           ENDIF
           ;; WINDOW,0,XSIZE=xSize,YSIZE=ySize
           
           CASE 1 OF
              KEYWORD_SET(first): BEGIN
                 plotArr[goAgain] = PLOT(10.^(wCenter)/1000.,plotFAC, $
                                         /XLOG, $
                                         YLOG=yLog, $
                                         TITLE=mltTStr, $
                                         NAME=(altStringArr[k]).REPLACE('_','')+nSuff, $
                                         ;; XTITLE='FAC width (km)', $
                                         XTITLE='Width (km) mapped to 100 km', $
                                         XRANGE=xRange, $
                                         ;; YRANGE=[MIN(plotFAC),magCYLim], $
                                         ;; YTITLE='Max FAC Amplitude  ($\mu$A/m!U2!N)', $
                                         COLOR=colors[goAgain], $
                                         LINESTYLE=lineStyle[k], $
                                         YTITLE=yTitle, $
                                         THICK=2.0, $
                                         FONT_SIZE=20, $
                                         CURRENT=window, $
                                         OVERPLOT=~first)
              END
              ELSE: BEGIN
                 plotArr[goAgain] = PLOT(10.^(wCenter)/1000.,plotFAC, $
                                         NAME=(altStringArr[k]).REPLACE('_','')+nSuff, $
                                         COLOR=colors[goAgain], $
                                         LINESTYLE=lineStyle[k], $
                                         THICK=2.0, $
                                         /CURRENT, $
                                         /OVERPLOT)

              END
           ENDCASE

        ENDFOR

        goAgain++

     ENDWHILE

     outFName = outFPref + outFTyp + outFSuff + mltStr + plotExt


     leg = LEGEND(TARGET=plotArr[legOrder], $
                  ;; POSITION=[-20.,((KEYWORD_SET(nEvRange) ? nEvRange : [0,7500])[1])]*0.45, $
                  ;; /DATA, $
                  POSITION=[0.8,0.8], $
                  /NORMAL, $
                  /AUTO_TEXT_COLOR, $
                  FONT_SIZE=14)

     IF KEYWORD_SET(save_png) THEN BEGIN
        PRINT,"Saving " + plotDir + outFName + ' ...'
        window.Save,plotDir + outFName
     ENDIF

     STOP

     repetez = 0

     PRINT,"Á la prochaine?"

  ENDWHILE

END
