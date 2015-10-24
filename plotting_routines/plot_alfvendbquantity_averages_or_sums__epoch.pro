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

END