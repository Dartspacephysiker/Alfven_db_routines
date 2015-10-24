PRO PLOT_ALFVENDBQUANTITY_HISTOGRAM__EPOCH,histTBins,histData,TSTAMPS=tStamps,NAME=name, $
   HISTORANGE=histoRange, $
   MARGIN=margin, $
   PLOTTITLE=plotTitle, $
   OVERPLOT_HIST=overplot_hist, $
   YTITLE=yTitle, $
   LAYOUT=layout, $
   WINDOW=window,HISTOPLOT=histoPlot, $
   BKGRND_HIST=bkgrnd_hist,BKGRNDHISTOPLOT=bkgrndHistoPlot, $
   OUTPLOT=outPlot,OUTBKGRNDPLOT=outBkgrndPlot, $
   ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array   

  @utcplot_defaults.pro

  histoPlot=plot(histTBins,histData, $
                ;; /STAIRSTEP, $
                 /HISTOGRAM, $
                 TITLE=plotTitle, $
                 YRANGE=KEYWORD_SET(histoRange) ? histoRange : defNEvYRange, $
                 YTITLE=KEYWORD_SET(overplot_hist) ? !NULL : yTitle, $
                 NAME=KEYWORD_SET(name) ? name : defHistoName, $
                 XRANGE=xRange, $
                 AXIS_STYLE=(KEYWORD_SET(overplot_hist)) ? 0 : 1, $
                 COLOR='red', $
                 MARGIN=margin, $
                 LAYOUT=layout, $
                 THICK=defHistoThick, $ ;OVERPLOT=KEYWORD_SET(overplot_hist),$
                 CURRENT=KEYWORD_SET(overplot_hist))
  
  IF KEYWORD_SET(overplot_hist) THEN BEGIN
     yaxis = AXIS('Y', LOCATION='right', TARGET=histoPlot, $
                  TITLE=yTitle, $
                  MAJOR=nMajorTicks, $
                  MINOR=nMinorTicks, $
                  TICKFONT_SIZE=defHistoYticksize, $
                  TICKFONT_STYLE=defHistoYtickfontstyle, $
                  TICKFORMAT=defHistoTickFormat, $
                  TEXTPOS=1, $
                  COLOR=defHistoColor)
  ENDIF

  IF KEYWORD_SET(bkgrnd_hist) THEN BEGIN
     bkgrndHistoPlot=plot(histTBins,bkgrnd_hist, $
                      ;; /STAIRSTEP, $
                      /HISTOGRAM, $
                      YRANGE=KEYWORD_SET(histoRange) ? histoRange : defHistoRange, $
                      NAME=defBkgrndHistoName, $
                      XRANGE=xRange, $
                      AXIS_STYLE=0, $
                      COLOR=defBkgrndHistoColor, $
                      MARGIN=margin, $
                      LAYOUT=layout, $
                      THICK=defHistoThick, $ ;OVERPLOT=KEYWORD_SET(overplot_hist),$
                      /CURRENT,TRANSPARENCY=defBkgrndTransp)
     
     leg = LEGEND(TARGET=[histoPlot,bkgrndHistoPlot], $
                  POSITION=[xRange[1]-10.,((KEYWORD_SET(histoRange) ? histoRange : defHistoRange)[1])], /DATA, $
                  /AUTO_TEXT_COLOR)
  ENDIF     

  IF KEYWORD_SET(add_plot_to_plot_array) THEN BEGIN
     IF N_ELEMENTS(outPlot) GT 0 THEN outPlot=[outPlot,histoPlot] ELSE outPlot = histoPlot
     IF N_ELEMENTS(outBkgrndPlot) GT 0 THEN outBkgrndPlot=[outBkgrndPlot,bkgrndHistoPlot] ELSE outBkgrndPlot = bkgrndHistoPlot
  ENDIF ELSE BEGIN
     outPlot = histoPlot
     outBkgrndPlot = bkgrndHistoPlot
  ENDELSE
  
END