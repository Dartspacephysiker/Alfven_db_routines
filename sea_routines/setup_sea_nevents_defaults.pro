PRO SETUP_SEA_NEVENTS_DEFAULTS,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch,$
                                ;; SWDBDIR=swDBDir,SWDBFILE=swDBFile, $
                                ;; EPOCHDIR=epochDir,EPOCHFILE=epochFile, $
                                ;; DST_AEDIR=DST_AEDir,DST_AEFILE=DST_AEFile, $
                                ;; DBDIR=dbDir,DBFILE=dbFile,DB_TFILE=db_tFile, $
                                DAYSIDE=dayside,NIGHTSIDE=nightside, $
                                RESTRICT_CHARERANGE=restrict_charERange,RESTRICT_ALTRANGE=restrict_altRange, $
                                MAXIND=maxInd,AVG_TYPE_MAXIND=avg_type_maxInd,LOG_DBQUANTITY=log_DBQuantity, $
                                USING_HEAVIES=using_heavies, $
                                YLOGSCALE_MAXIND=yLogScale_maxInd, $
                                YTITLE_MAXIND=yTitle_maxInd, YRANGE_MAXIND=yRange_maxInd, $
                                NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                                LAYOUT=layout, $
                                POS_LAYOUT=pos_layout, $
                                NEG_LAYOUT=neg_layout, $
                                USE_SYMH=use_SYMH,USE_AE=use_AE, $
                                OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity,USE_DATA_MINMAX=use_data_minMax, $
                                HISTOBINSIZE=histoBinSize, HISTORANGE=histoRange, $
                                PROBOCCURRENCE_SEA=probOccurrence_sea, $
                               THIST_SEA=tHist_sea, $
                               THIST_NORMALIZE=tHist_normalize, $
                               THIST_AUTOSCALE=tHist_autoScale, $
                                TIMEAVGD_MAXIND_SEA=timeAvgd_maxInd_sea, $
                                TIMEAVGD_PFLUX_SEA=timeAvgd_pFlux_sea, $
                                TIMEAVGD_EFLUXMAX_SEA=timeAvgd_eFluxMax_sea, $
                                SAVEPNAME=savePName, $
                                SAVEMPNAME=saveMPName, $
                                SAVEFILE=saveFile,SAVESTR=saveStr, $
                                PLOTTITLE=plotTitle, $
                                NOPLOTS=noPlots, $
                                NOGEOMAGPLOTS=noGeomagPlots, $
                                NOMAXPLOTS=noMaxPlots, $
                                NOAVGPLOTS=noAvgPlots, $
                                DO_SCATTERPLOTS=do_scatterPlots,epochPlot_colorNames=scPlot_colorList,SCATTEROUTPREFIX=scatterOutPrefix, $
                                RANDOMTIMES=randomTimes, $
                                SHOW_DATA_AVAILABILITY=show_data_availability, $
                                EPS_OUTPUT=eps_output, $
                                PDF_OUTPUT=pdf_output, $
                                LUN=lun
  

  defTBeforeEpoch               = 10.0D                                 ;in hours
  defTAfterEpoch                = 10.0D                                 ;in hours
                                
  defUse_SYMH                   = 0
  defUse_AE                     = 0
                                
  defOmni_Quantity              = 0
  defLog_omni_quantity          = 0
  defUse_data_minmax            = 0
                                
  defRestrict_altRange          = 0
  defRestrict_charERange        = 0
                                
  defMaxInd                     = !NULL
  defavg_type_maxInd            = 0
  defLog_DBQuantity             = 0
  defYLogScale_maxInd           = 0
                                
  defNeg_and_pos_separ          = 0
  defLayout                     = [1,1,1]
  defPos_layout                 = [1,1,1]
  defNeg_layout                 = [1,1,1]
                                
  defSaveFile                   = 0
                                
  defhistoBinSize               = 2.5 ;in hours
                                
  defNoPlots                    = 0 
  defNoGeomagPlots              = 0
  defNoMaxPlots                 = 0
  defNoAvgPlots                 = 0
                                
  defTHistPref                  = 'tHist' 
  defTHistHistoRange            = [1e0,1e3]

  defProbOccurrencePref         = 'probOccurrence' 
  defProbOccurrenceHistoRange   = [1e-4,1e0]

  defTimeAvgd_MaxIndPref        = 'timeAvgd_' 
  defTimeAvgd_MaxIndHistoRange  = [1e-4,1e0]

  defTimeAvgd_PFluxPref         = 'timeAvgd_pFlux' 
  defTimeAvgd_PFluxHistoRange   = [1e-4,1e0]

  defTimeAvgd_eFluxMaxPref         = 'timeAvgd_eFluxMax' 
  defTimeAvgd_eFluxMaxHistoRange   = [1e-4,1e0]

  defDo_scatterPlots            = 0
  defScatterOutPrefix           = 'stackplots_seas_nevents--scatterplot'
  ;; defepochPlot_colorNames = ''

  defRandomTimes                = 0

  defShow_data_availability     = 0

  ;;set defaults
  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  IF N_ELEMENTS(tBeforeEpoch) EQ 0 THEN tBeforeEpoch = defTBeforeEpoch
  IF N_ELEMENTS(tAfterEpoch) EQ 0 THEN tAfterEpoch = defTAfterEpoch

  IF KEYWORD_SET(dayside) THEN print,"Only considering dayside stuff!"
  IF KEYWORD_SET(nightside) THEN print,"Only considering nightside stuff!"

  IF N_ELEMENTS(restrict_charERange) EQ 0 THEN restrict_charERange = defRestrict_charERange
  IF N_ELEMENTS(restrict_altRange) EQ 0 THEN restrict_altRange = defRestrict_altRange

  IF N_ELEMENTS(maxInd) EQ 0 THEN maxInd = defMaxInd

  IF N_ELEMENTS(using_heavies) EQ 0 THEN BEGIN
     IF N_ELEMENTS(maxInd) GT 0 THEN BEGIN
        IF maxInd GE 26 AND maxInd LE 31 THEN BEGIN
           using_heavies = 1
           PRINT,"Using TEAMS data for heavy ions!"
        ENDIF ELSE BEGIN 
           using_heavies = 0
        ENDELSE
     ENDIF ELSE BEGIN
        using_heavies = 0
     ENDELSE
  ENDIF

  IF N_ELEMENTS(avg_type_maxInd) EQ 0 THEN avg_type_maxInd=defAvg_type_maxInd

  IF N_ELEMENTS(log_DBQuantity) EQ 0 THEN log_DBQuantity=defLog_DBQuantity
  IF N_ELEMENTS(yLogScale_maxInd) EQ 0 THEN yLogScale_maxInd = defYLogScale_maxInd

  IF N_ELEMENTS(neg_and_pos_separ) EQ 0 THEN neg_and_pos_separ=defNeg_and_pos_separ
  IF N_ELEMENTS(layout)            EQ 0 THEN layout = deflayout
  IF N_ELEMENTS(pos_layout) EQ 0 THEN pos_layout=defPos_layout
  IF N_ELEMENTS(neg_layout) EQ 0 THEN neg_layout=defNeg_layout

  IF N_ELEMENTS(use_SYMH) EQ 0 THEN use_SYMH = defUse_SYMH
  IF N_ELEMENTS(use_AE)   EQ 0 THEN use_AE = defUse_AE

  IF N_ELEMENTS(omni_quantity) EQ 0 THEN omni_quantity = defOmni_quantity
  IF N_ELEMENTS(log_omni_quantity) EQ 0 THEN log_omni_quantity = defOmni_quantity
  IF N_ELEMENTS(use_data_minmax) EQ 0 THEN use_data_minmax = defUse_data_minmax

  IF N_ELEMENTS(histoBinSize) EQ 0 THEN histoBinSize=defhistoBinSize

  IF N_ELEMENTS(saveFile) EQ 0 THEN saveFile=defSaveFile

  IF N_ELEMENTS(noPlots) EQ 0 THEN noPlots=defNoPlots
  IF N_ELEMENTS(noGeomagPlots) EQ 0 THEN noGeomagPlots=defNoGeomagPlots
  IF N_ELEMENTS(noMaxPlots) EQ 0 THEN noMaxPlots=defNoMaxPlots
  IF N_ELEMENTS(noAvgPlots) EQ 0 THEN noAvgPlots=defNoAvgPlots

  IF N_ELEMENTS(do_scatterPlots) EQ 0 THEN do_scatterPlots = defdo_scatterPlots
  ;; IF N_ELEMENTS(epochPlot_colorNames) EQ 0 THEN scPlot_colorList = defscPlot_colorList

  IF KEYWORD_SET(do_scatterPlots) THEN BEGIN
     IF SIZE(scatterOutPrefix,/TYPE) NE 7 THEN scatterOutPrefix=defScatterOutPrefix
  ENDIF

  IF N_ELEMENTS(randomTimes) EQ 0 THEN randomTimes = defRandomTimes

  IF N_ELEMENTS(show_data_availability) EQ 0 THEN show_data_availability = defShow_data_availability

  IF KEYWORD_SET(tHist_sea) THEN BEGIN
     IF ~KEYWORD_SET(yTitle_maxInd) THEN yTitle_maxInd = "FAST ephemeris (min)"
     IF ~KEYWORD_SET(histoRange) THEN histoRange = defTHistHistoRange
     IF KEYWORD_SET(tHist_normalize) OR KEYWORD_SET(tHist_autoscale) THEN histoRange = [0.0,1.0]
  ENDIF

  IF KEYWORD_SET(probOccurrence_sea) THEN BEGIN
     ;; IF ~KEYWORD_SET(yTitle_maxInd) THEN yTitle_maxInd = "Probability of Occurrence"
     IF ~KEYWORD_SET(yTitle_maxInd) THEN yTitle_maxInd = "Probability of Alfvén wave observation"
     ;; plotTitle = KEYWORD_SET(plotTitle) ? plotTitle : "Prob Occurrence" ;defProbOccurrencePref + '--' + saveMaxPlotName : defProbOccurrencePref + '.png'
     IF ~KEYWORD_SET(histoRange) THEN histoRange = defProbOccurrenceHistoRange
  ENDIF

  IF KEYWORD_SET(timeAvgd_pFlux_sea) THEN BEGIN
     ;; IF ~KEYWORD_SET(yTitle_maxInd) THEN yTitle_maxInd = "Probability of Occurrence"
     IF ~KEYWORD_SET(yTitle_maxInd) THEN yTitle_maxInd = "Time-averaged Poynting flux (mW/m^2)"
     ;; plotTitle = KEYWORD_SET(plotTitle) ? plotTitle : "Prob Occurrence" ;defTimeAvgd_PFluxPref + '--' + saveMaxPlotName : defTimeAvgd_PFluxPref + '.png'
     IF ~KEYWORD_SET(histoRange) THEN histoRange = defTimeAvgd_PFluxHistoRange
  ENDIF

  IF KEYWORD_SET(timeAvgd_eFluxMax_sea) THEN BEGIN
     ;; IF ~KEYWORD_SET(yTitle_maxInd) THEN yTitle_maxInd = "Probability of Occurrence"
     IF ~KEYWORD_SET(yTitle_maxInd) THEN yTitle_maxInd = "Time-averaged e- flux (mW/m^2)"
     ;; plotTitle = KEYWORD_SET(plotTitle) ? plotTitle : "Prob Occurrence" ;defTimeAvgd_eFluxMaxPref + '--' + saveMaxPlotName : defTimeAvgd_eFluxMaxPref + '.png'
     IF ~KEYWORD_SET(histoRange) THEN histoRange = defTimeAvgd_eFluxMaxHistoRange
  ENDIF

  IF saveFile THEN BEGIN 
     saveStr='save' 
     IF SIZE(saveFile,/TYPE) NE 7 THEN saveFile='superpose_seas_alfven_db_quantities.dat'
  ENDIF ELSE saveStr=''

  IF KEYWORD_SET(savePName) THEN BEGIN
     IF SIZE(savePName,/TYPE) NE 7 THEN BEGIN
        savePName=GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + "--superpose_seas_plot_output.png"
        PRINT,'savePName set without providing a name! Set to ' + savePName
     ENDIF
  ENDIF ELSE BEGIN
     savePName = !NULL
  ENDELSE

  IF KEYWORD_SET(saveMPName) THEN BEGIN
     IF SIZE(saveMPName,/TYPE) NE 7 THEN BEGIN
        saveMPName=GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + "--superpose_seas_maxplot_output.png"
        PRINT,'saveMPName set without providing a name! Set to ' + saveMPName
     ENDIF
  ENDIF ELSE BEGIN
     saveMPName = !NULL
  ENDELSE

  IF ( KEYWORD_SET(eps_output) OR KEYWORD_SET(pdf_output) ) AND (KEYWORD_SET(savePName) OR KEYWORD_SET(saveMPName)) THEN BEGIN
     IF KEYWORD_SET(saveMPName) AND KEYWORD_SET(savePName) THEN BEGIN
        PRINT,"Can't do both maxPlot and a regular plot at the same time! Stopping ..."
        STOP
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(saveMPName) THEN BEGIN
           fName = saveMPName
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(savePName) THEN BEGIN
              fName = savePName
           ENDIF
        ENDELSE
     ENDELSE
  ENDIF

  IF KEYWORD_SET(eps_output) THEN BEGIN
     ;; SETUP_EPS_OUTPUT,FILENAME=fName
     CGPS_OPEN,fName,/ENCAPSULATED
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(pdf_output) THEN BEGIN
        IF STRMATCH(fName,'*.png',/FOLD_CASE) THEN BEGIN
           fName = fName.replace('.png','.tiff',/FOLD_CASE)
           PRINT,FORMAT='("Swapped ending to make .pdf   :",A0)',fName
        ENDIF
        IF KEYWORD_SET(saveMPName) THEN saveMPName = fName ELSE BEGIN
           IF KEYWORD_SET(savePName) THEN savePName = fName
        ENDELSE
     ENDIF
  ENDELSE

END