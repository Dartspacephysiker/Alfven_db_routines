;2015/10/22
PRO PLOT_ALFVENDBQUANTITY_AVERAGES_OR_SUMS__EPOCH, histData, histTBins, HISTOTYPE=histoType, $ 
                                 NEVHISTDATA=nEvHistData, $
                                 TAFTERSTORM=tafterstorm,TBEFORESTORM=tBeforeStorm, $
                                 HISTOBINSIZE=histoBinSize, $
                                 NONZERO_I=nz_i, $
                                 SYMCOLOR=symColor,SYMTRANSPARENCY=symTransparency,SYMBOL=symbol, $
                                 PLOTNAME=plotName, $
                                 PLOTTITLE=plotTitle, $
                                 XTITLE=xTitle,XRANGE=xRange, $
                                 YTITLE=yTitle,YRANGE=yRange,LOGYPLOT=logYPlot, $
                                 OVERPLOT=overPlot, $
                                 CURRENT=current, $
                                 MARGIN=margin, $
                                 LAYOUT=layout, $
                                 OUTPLOT=outPlot,ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array
  
  @utcplot_defaults.pro

  plot=plot(histTBins[nz_i],histData[nz_i], $
            NAME=KEYWORD_SET(plotName) ? plotName : defAvgPlotName, $
            TITLE=plotTitle, $
            XTITLE=KEYWORD_SET(xTitle) ? xTitle : defXTitle, $
            YTITLE=yTitle, $
            XRANGE=KEYWORD_SET(xRange) ? xRange : !NULL, $
            YRANGE=KEYWORD_SET(yRange) ? yRange : !NULL, $
            YLOG=KEYWORD_SET(logYPlot), $
            AXIS_STYLE=defAvgSymAxisStyle, $
            LINESTYLE=defAvgSymLinestyle, $
            COLOR=defAvgSymColor, $
            THICK=defAvgLineThick, $
            SYMBOL=defAvgSym, $
            SYM_SIZE=defAvgSymSize, $
            SYM_COLOR=defAvgSymColor, $ ;, $
            XTICKFONT_SIZE=max_xtickfont_size, $
            XTICKFONT_STYLE=max_xtickfont_style, $
            YTICKFONT_SIZE=max_ytickfont_size, $
            YTICKFONT_STYLE=max_ytickfont_style, $
            CURRENT=current, $
            OVERPLOT=overplot, $
            LAYOUT=layout, $
            MARGIN=KEYWORD_SET(margin) ? margin : defPlotMargin_max)
  
  
  IF KEYWORD_SET(add_plot_to_plot_array) THEN BEGIN
     IF N_ELEMENTS(outPlot) GT 0 THEN outPlot=[outPlot,plot] ELSE outPlot = plot
  ENDIF ELSE BEGIN
     outPlot = plot
  ENDELSE

  ;;ALL BAD STUFF! This has to be incorporated. Here's the tip: Make this guideline plotter general, and simply feed it the
  ;;appropriate order-of-magnitude values. Then you be happy, my man.
  STOP

  ;;DO YOU WANT THIS BACKGROUND THING? You definitely want the guideline stuff below
  IF KEYWORD_SET(bkgrnd_maxInd) AND ~noPlots THEN BEGIN
     
     ;;PLOT_GUIDELINE,guideline_vals, $
    ;;For plotting guidelines
     ;; guide_linestyle='__'
     ;; plot_bkgrnd_8=plot(tBins[safe_i]+0.5*min_NEVBINSIZE, $
     ;;                    MAKE_ARRAY(N_ELEMENTS(safe_i),VALUE=10.^8), $
     ;;                    XRANGE=xRange, $
     ;;                    YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
     ;;                    yRange_maxInd : [minDat,maxDat], $
     ;;                    YLOG=(log_DBQuantity) ? 1 : 0, $
     ;;                    AXIS_STYLE=0, $
     ;;                    LINESTYLE=guide_linestyle, $
     ;;                    ;; SYMBOL='', $
     ;;                    ;; SYM_SIZE=1.5, $
     ;;                    COLOR='black', $
     ;;                    THICK=1.5, $
     ;;                    MARGIN=plotMargin_max, $
     ;;                    /CURRENT)

     safe_i=(log_DBQuantity) ? WHERE(FINITE(bkgrnd_maxInd) AND bkgrnd_maxInd GT 0.) : WHERE(FINITE(bkGrnd_maxInd))
     
     y_offset = (log_DBQuantity) ? 1. : TOTAL(bkgrnd_maxind[safe_i])*0.1
     ;; y_offset = 0.
     IF N_ELEMENTS(tBins) EQ 0 THEN STOP
     plot_bkgrnd_max=plot(tBins[safe_i]+0.5*min_NEVBINSIZE, $
                          (log_DBQuantity) ? 10^(bkgrnd_maxInd[safe_i]-y_offset) : bkgrnd_maxInd[safe_i]-y_offset, $
                          XRANGE=xRange, $
                          YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                          yRange_maxInd : [minDat,maxDat], $
                          YLOG=(log_DBQuantity) ? 1 : 0, $
                          NAME='Background Alfvén activity', $
                          AXIS_STYLE=0, $
                          LINESTYLE='--', $
                          COLOR='blue', $
                          THICK=2.0, $
                          SYMBOL='d', $
                          SYM_SIZE=2.5, $
                          MARGIN=plotMargin_max, $
                          /CURRENT)
     
     legPosY=(KEYWORD_SET(yRange_maxInd) ? yRange_maxInd : [minDat,maxDat])
     IF (log_DBQuantity) THEN BEGIN
        ;; legPosY=10.^MEAN(ALOG10(legPosY))
        legPosY=10.^(ALOG10(legPosY[1])-ALOG10(5))
     ENDIF ELSE legPosY=MEAN(legPosY)
     
     leg = LEGEND(TARGET=[avgplot,plot_bkgrnd_max], $
                  POSITION=[-15.,legPosY], /DATA, $
                  /AUTO_TEXT_COLOR)
     
     
     ;;For plotting guidelines
     guide_linestyle='__'
     plot_bkgrnd_8=plot(tBins[safe_i]+0.5*min_NEVBINSIZE, $
                        MAKE_ARRAY(N_ELEMENTS(safe_i),VALUE=10.^8), $
                        XRANGE=xRange, $
                        YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                        yRange_maxInd : [minDat,maxDat], $
                        YLOG=(log_DBQuantity) ? 1 : 0, $
                        AXIS_STYLE=0, $
                        LINESTYLE=guide_linestyle, $
                        ;; SYMBOL='', $
                        ;; SYM_SIZE=1.5, $
                        COLOR='black', $
                        THICK=1.5, $
                        MARGIN=plotMargin_max, $
                        /CURRENT)
     plot_bkgrnd_7=plot(tBins[safe_i]+0.5*min_NEVBINSIZE, $
                        MAKE_ARRAY(N_ELEMENTS(safe_i),VALUE=10.^7), $
                        XRANGE=xRange, $
                        YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                        yRange_maxInd : [minDat,maxDat], $
                        YLOG=(log_DBQuantity) ? 1 : 0, $
                        AXIS_STYLE=0, $
                        LINESTYLE=guide_linestyle, $
                        ;; SYMBOL='', $
                        ;; SYM_SIZE=1.5, $
                        COLOR='black', $
                        THICK=1.5, $
                        MARGIN=plotMargin_max, $
                        /CURRENT)
     plot_bkgrnd_6=plot(tBins[safe_i]+0.5*min_NEVBINSIZE, $
                        MAKE_ARRAY(N_ELEMENTS(safe_i),VALUE=10.^6), $
                        XRANGE=xRange, $
                        YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                        yRange_maxInd : [minDat,maxDat], $
                        YLOG=(log_DBQuantity) ? 1 : 0, $
                        AXIS_STYLE=0, $
                        LINESTYLE=guide_linestyle, $
                        ;; SYMBOL='', $
                        ;; SYM_SIZE=1.5, $
                        COLOR='black', $
                        THICK=1.5, $
                        MARGIN=plotMargin_max, $
                        /CURRENT)
     
     out_maxPlotAll = plot_bkgrnd_max
     
  ENDIF

END