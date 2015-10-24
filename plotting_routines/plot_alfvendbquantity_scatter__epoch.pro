PRO PLOT_ALFVENDBQUANTITY_SCATTER__EPOCH,maxInd,mTags,NAME=name,AXIS_STYLE=axis_Style, $
                                         OVERPLOT=overPlot,CURRENT=current, $
                                         SYMCOLOR=symColor,SYMTRANSPARENCY=symTransparency,SYMBOL=symbol, $
                                         MARGIN=margin, $
                                         ALFDB=alfDB,ALFDBTIME=alfDBTime,PLOT_I=plot_i,CENTERTIME=centerTime,$
                                         ALF_T=alf_t,ALF_Y=alf_y, $
                                         PLOTTITLE=plotTitle, $
                                         XTITLE=xTitle,XRANGE=xRange, $
                                         YTITLE=yTitle,YRANGE=yRange,LOGYPLOT=logYPlot, $
                                         LAYOUT=layout, $
                                         OUTPLOT=outPlot,ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array
  
  @stormplot_defaults.pro

  IF N_ELEMENTS(alfDB) GT 0 AND N_ELEMENTS(plot_i) GT 0 AND N_ELEMENTS(alf_y) EQ 0 THEN BEGIN
     alf_y = alfDB.(maxInd)[plot_i]
  ENDIF

  IF N_ELEMENTS(alfDBTime) GT 0 AND N_ELEMENTS(plot_i) GT 0 AND N_ELEMENTS(centerTime) GT 0 $
     AND N_ELEMENTS(alf_t) EQ 0 THEN BEGIN
     alf_t = alfDBTime[plot_i]-centerTime
  ENDIF

  plot=plot(alf_t, $
            alf_y, $
            XTITLE=KEYWORD_SET(xTitle) ? xTitle : defXTitle, $
            YTITLE=yTitle, $
            XRANGE=KEYWORD_SET(xRange) ? xRange : [MIN(alf_t),MAX(alf_t)], $
            YRANGE=KEYWORD_SET(yRange) ? yRange : [MIN(alf_y),MAX(alf_y)], $
            YLOG=KEYWORD_SET(logYPlot) ? 1 : 0, $
            AXIS_STYLE=axis_Style, $
            LINESTYLE=' ', $
            SYMBOL=KEYWORD_SET(symbol) ? symbol: max_scatter_symbol, $
            SYM_COLOR=KEYWORD_SET(symColor) ? symColor : max_scatter_color, $
            XTICKFONT_SIZE=max_xtickfont_size, $
            XTICKFONT_STYLE=max_xtickfont_style, $
            YTICKFONT_SIZE=max_ytickfont_size, $
            YTICKFONT_STYLE=max_ytickfont_style, $
            MARGIN=KEYWORD_SET(margin) ? margin : defPlotMargin_max, $
            CURRENT=current, $
            OVERPLOT=overplot, $
            LAYOUT=layout, $
            SYM_TRANSPARENCY=KEYWORD_SET(symTransparency) ? symTransparency : defSymTransp)
  
  IF KEYWORD_SET(add_plot_to_plot_array) THEN BEGIN
     IF N_ELEMENTS(outPlot) GT 0 THEN outPlot=[outPlot,plot] ELSE outPlot = plot
  ENDIF ELSE BEGIN
     outPlot = plot
  ENDELSE

END