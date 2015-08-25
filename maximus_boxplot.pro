FUNCTION MAXIMUS_BOXPLOT,maxDat,INDS=inds,IND_NORTH=ind_north,IND_SOUTH=ind_south, $
                         MAXIMUS=maximus,MAXIND=maxInd,LOG=log, $
                         OUT_BPDATA=out_bpData, OUT_MEANS=out_means,OUT_OUTLIERS=out_outliers, $
                         SAVEPLOTNAME=savePlotName,PRINT_STATS=print_stats, $
                         PLOTTITLE=plotTitle,OVERPLOT=overPlot,CURRENTWINDOW=currentWindow

  IF KEYWORD_SET(currentWindow) THEN currentWindow.setCurrent

  fPre = 'MAXIMUS_BOXPLOT: '

  defRes = 300
  nPlots = 0

  IF N_ELEMENTS(maxDat) EQ 0 THEN BEGIN
     maxDat = maximus.(maxInd)
     titlePref = (TAG_NAMES(maximus))[maxInd] + ': '
     yTitle = (TAG_NAMES(maximus))[maxInd]

     PRINT,FPRE+'Boxplot quantity: ' + yTitle
  ENDIF ELSE BEGIN
     titlePref = ''
     yTitle = 'Maximus Quantity'
  ENDELSE

  IF KEYWORD_SET(log) THEN BEGIN
     PRINT,FPRE+'Logging data...'
     maxDat = ALOG10(maxDat)

     logStr = '(Log) '
     titlePref = logStr + titlePref
     yTitle = logStr + yTitle
  ENDIF

  IF N_ELEMENTS(inds) GT 0 THEN BEGIN
     bpData=CREATEBOXPLOTDATA(maxDat(inds),MEAN_VALUES=means,OUTLIER_VALUES=outliers)
     nPlots++
     title=titlePref+'Both hemispheres'
     out_means=means
     out_outliers=outliers

     IF KEYWORD_SET(print_stats) THEN PRINT_BPDATA,bpData,NAME=title
  ENDIF ELSE BEGIN
     PRINT,FPRE+'No inds provided! Doing the whole data product...'
     bpData=CREATEBOXPLOTDATA(maxDat,MEAN_VALUES=means,OUTLIER_VALUES=outliers)
     nPlots++
     title=titlePref+'Both hemispheres'
     out_means=means
     out_outliers=outliers

     IF KEYWORD_SET(print_stats) THEN PRINT_BPDATA,bpData,NAME=title
  ENDELSE

  IF KEYWORD_SET(IND_NORTH) THEN BEGIN
     PRINT,FPRE+'Doing data from northern hemi...'

     bpData_north=CREATEBOXPLOTDATA(maxDat(ind_north),MEAN_VALUES=means_n,OUTLIER_VALUES=outliers_n)
     nPlots++
     title_n = titlePref+'North'
     IF N_ELEMENTS(bpData) GT 0 THEN BEGIN
        bpData=[bpData,bpData_north]
        title=[title,title_n]
        out_means=[[out_means],[means_n]]
        out_outliers=[[out_outliers],[outliers_n]]
     ENDIF ELSE BEGIN
        bpData=bpData_north
        title=title_n
        out_means=means_n
        out_outliers=outliers_n
     ENDELSE

     IF KEYWORD_SET(print_stats) THEN PRINT_BPDATA,bpData_north,NAME=title_n
  ENDIF

  IF KEYWORD_SET(IND_SOUTH) THEN BEGIN
     PRINT,FPRE+'Doing data from southern hemi: ' + N_ELEMENTS(ind_south)
     
     bpData_south=CREATEBOXPLOTDATA(maxDat(ind_south),MEAN_VALUES=means_s,OUTLIER_VALUES=outliers_s)
     nPlots++
     title_s = titlePref+'South'
     IF N_ELEMENTS(bpData) GT 0 THEN BEGIN
        bpData=[bpData,bpData_south]
        title=[title,title_s]
        out_means=[[out_means],[means_s]]
        out_outliers=[[out_outliers],[outliers_s]]
     ENDIF ELSE BEGIN
        bpData=bpData_south
        title=title_s
        out_means=means_s
        out_outliers=outliers_s
     ENDELSE
     
     IF KEYWORD_SET(print_stats) THEN PRINT_BPDATA,bpData_south,NAME=title_s
  ENDIF
  
  boxes = BOXPLOT(bpData, $
                  YTITLE=KEYWORD_SET(overPlot) ? !NULL : yTitle, $
                  TITLE=KEYWORD_SET(overPlot) ? !NULL : plotTitle, $
                  CURRENT=(KEYWORD_SET(currentWindow) AND ~KEYWORD_SET(overPlot)) ? currentWindow : !NULL, $
                  THICK=KEYWORD_SET(overPlot) ? 1 : 3, $
                  AXIS_STYLE=KEYWORD_SET(overPlot) ? 4 : 2, $
                  TRANSPARENCY=KEYWORD_SET(overPlot) ? 60 : 100, $
                  BACKGROUND_TRANSPARENCY=KEYWORD_SET(overPlot) ? 100 : 0, $
                  COLOR=KEYWORD_SET(overPlot) ? 'blue' : 'black', $
                  OVERPLOT=KEYWORD_SET(overPlot))

  IF ~KEYWORD_SET(overPlot) THEN BEGIN
     IF KEYWORD_SET(inds) THEN iText = TEXT(0.15,0.13,title[0],TARGET=boxes,/NORMAL)
     IF KEYWORD_SET(ind_north) THEN iText_n = TEXT(0.15,0.15-0.03*(1+KEYWORD_SET(inds)),title[(KEYWORD_SET(inds))],TARGET=boxes,/NORMAL)
     IF KEYWORD_SET(ind_south) THEN iText_s = TEXT(0.15,0.15-0.03*nPlots,title[nPlots-1],TARGET=boxes,/NORMAL)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(plotTitle) THEN iText = TEXT(0.15,0.65,plotTitle,TARGET=boxes,/NORMAL)
  ENDELSE

  IF KEYWORD_SET(savePlotName) THEN boxes.save,savePlotName,RESOLUTION=defRes

  out_bpData=bpData

  RETURN,boxes

END
  