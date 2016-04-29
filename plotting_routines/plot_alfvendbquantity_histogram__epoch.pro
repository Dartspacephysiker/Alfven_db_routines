PRO PLOT_ALFVENDBQUANTITY_HISTOGRAM__EPOCH,histTBins,histData,NAME=name, $
   XRANGE=xRange, $
   XHIDELABEL=xHideLabel, $
   HISTORANGE=histoRange, $
   YTITLE=yTitle, $
   LOGYPLOT=logYPlot, $
   YTICKFORMAT=yTickFormat, $
   HISTOGRAM=histogram, $
   MARGIN=margin, $
   PLOTTITLE=plotTitle, $
   OVERPLOT_HIST=overplot_hist, $
   COLOR=color, $
   CURRENT=current, $
   LAYOUT=layout, $
   HISTOPLOT=histoPlot, $
   BKGRND_HIST=bkgrnd_hist,BKGRNDHISTOPLOT=bkgrndHistoPlot, $
   OUTPLOT=outPlot,OUTBKGRNDPLOT=outBkgrndPlot, $
   YEAR_AND_SEASON_MODE=year_and_season_mode, $
   ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array

  @utcplot_defaults.pro

  IF KEYWORD_SET(plotTitle) THEN title = plotTitle ELSE title = ''
  IF KEYWORD_SET(xTitle) THEN xTit = xTitle ELSE xTit = ''
  IF KEYWORD_SET(yTitle) THEN yTit = yTitle ELSE yTit = ''
  xR                               = KEYWORD_SET(xRange)     ? xRange : [MIN(geomagEpochSeconds),MAX(geomagEpochSeconds)]
  yR                               = KEYWORD_SET(histoRange) ? histoRange : defNEvYRange


  IF N_ELEMENTS(histogram) EQ 0 THEN histogram = 1

  IF KEYWORD_SET(logYPlot) THEN BEGIN
     yLog          = KEYWORD_SET(logYPlot) ? 1 : 0

     safe_i        = WHERE(histData GT 0)
     histTBins     = histTBins[safe_i]
     histData      = histData[safe_i]
  ENDIF ELSE BEGIN
     yLog          = 0
  ENDELSE

  IF KEYWORD_SET(xHideLabel) THEN BEGIN
     xShowLabel    = 0
  ENDIF ELSE BEGIN
     xShowLabel    = 1
  ENDELSE

    IF KEYWORD_SET(year_and_season_mode) THEN BEGIN
     SETUP_YEAR_AND_SEASON_SEA_PLOT, $
        PLOTTITLE=plotTitle, $
        XMINOR=xMinor, $
        XRANGE=xR, $
        XSTYLE=xStyle, $
        XTICKVALUES=xTickValues,$
        XTICKNAME=xTickName, $
        XTITLE=xTit, $
        YTITLE=yTit
  ENDIF

  histoPlot=plot(histTBins,histData, $
                ;; /STAIRSTEP, $
                 HISTOGRAM=histogram, $
                 TITLE=plotTitle, $
                 YRANGE=yR, $
                 YLog=yLog, $
                 YTITLE=KEYWORD_SET(overplot_hist) ? !NULL : yTit, $
                 NAME=KEYWORD_SET(name) ? name : defHistoName, $
                 XMINOR=xMinor, $
                 XRANGE=xR, $
                 XSHOWTEXT=xShowLabel, $
                 AXIS_STYLE=(KEYWORD_SET(overplot_hist)) ? 0 : 1, $
                 COLOR=KEYWORD_SET(color) ? color : 'red', $
                 MARGIN=margin, $
                 LAYOUT=layout, $
                 THICK=defHistoThick, $ ;OVERPLOT=KEYWORD_SET(overplot_hist),$
                 CURRENT=KEYWORD_SET(current) OR KEYWORD_SET(overplot_hist))

  IF xShowLabel THEN BEGIN
     ax                = histoPlot.axes
     IF N_ELEMENTS(ax) GT 2 THEN BEGIN
        ax[2].showText = 0
     ENDIF
  ENDIF

  IF KEYWORD_SET(overplot_hist) THEN BEGIN
     yaxis = AXIS('Y', LOCATION='right', TARGET=histoPlot, $
                  TITLE=yTit, $
                  ;; MAJOR=nMajorTicks+1, $
                  ;; MINOR=nMinorTicks, $
                  TICKFONT_SIZE=defHistoYticksize, $
                  TICKFONT_STYLE=defHistoYtickfontstyle, $
                  ;; TICKFORMAT=KEYWORD_SET(yTickFormat) ? yTickFormat : defHistoTickFormat, $
                  TICKFORMAT=!NULL, $
                  TEXTPOS=1, $
                  ;; COLOR=KEYWORD_SET(color) ? color : defHistoColor)
                  COLOR='BLACK')
  ENDIF

  IF KEYWORD_SET(bkgrnd_hist) THEN BEGIN
     bkgrndHistoPlot=plot(histTBins,bkgrnd_hist, $
                      ;; /STAIRSTEP, $
                      /HISTOGRAM, $
                      XRANGE=xR, $
                      YRANGE=yR, $
                      NAME=defBkgrndHistoName, $
                      AXIS_STYLE=0, $
                      COLOR=defBkgrndHistoColor, $
                      MARGIN=margin, $
                      LAYOUT=layout, $
                      THICK=defHistoThick, $ ;OVERPLOT=KEYWORD_SET(overplot_hist),$
                      /CURRENT,TRANSPARENCY=defBkgrndTransp)

     leg = LEGEND(TARGET=[histoPlot,bkgrndHistoPlot], $
                  POSITION=[xR[1]-10.,((KEYWORD_SET(histoRange) ? histoRange : defHistoRange)[1])], /DATA, $
                  /AUTO_TEXT_COLOR)
  ENDIF

  IF KEYWORD_SET(add_plot_to_plot_array) THEN BEGIN
     IF N_ELEMENTS(outPlot) GT 0 THEN outPlot=[outPlot,histoPlot] ELSE outPlot = histoPlot
  ENDIF
     ;; IF N_ELEMENTS(outBkgrndPlot) GT 0 AND $
     ;;    N_ELEMENTS(bkgrndHistoPlot) GT 0 $
     ;; THEN outBkgrndPlot=[outBkgrndPlot,bkgrndHistoPlot] ELSE outBkgrndPlot = bkgrndHistoPlot
  ;; ENDIF ELSE BEGIN
  ;;    outPlot = histoPlot
     ;; IF N_ELEMENTS(bkgrndHistoPlot) GT 0 AND $
     ;;    N_ELEMENTS(bkgrndHistoPlot) GT 0 $
     ;; THEN outBkgrndPlot = bkgrndHistoPlot
  ;; ENDELSE

END