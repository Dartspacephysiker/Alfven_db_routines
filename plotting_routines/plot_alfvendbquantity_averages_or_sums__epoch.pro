;2015/10/22
PRO PLOT_ALFVENDBQUANTITY_AVERAGES_OR_SUMS__EPOCH, histData, histTBins, $ 
   ;; NEVHISTDATA=nEvHistData, $
   TAFTEREPOCH=tafterEpoch,TBEFOREEPOCH=tBeforeEpoch, $
   HISTOBINSIZE=histoBinSize, $
   HISTOGRAM=histogram, $
   NONZERO_I=nz_i, $
   SYMCOLOR=symColor, $
   SYMTRANSPARENCY=symTransparency, $
   SYMBOL=symbol, $
   LINESTYLE=lineStyle, $
   LINETHICKNESS=lineThickness, $
   NO_AVG_SYMBOL=no_avg_symbol, $
   PLOTNAME=plotName, $
   PLOTTITLE=plotTitle, $
   ERROR_PLOT=error_plot, $
   ERROR_BARS=error_bars, $
   ERRORBAR_CAPSIZE=eb_capsize, $
   ERRORBAR_COLOR=eb_color, $ 
   ERRORBAR_LINESTYLE=eb_linestyle, $
   ERRORBAR_THICK=eb_thick, $
   DO_SECONDARY_AXIS=do_secondary_axis, $
   DIFFCOLOR_SECONDARY_AXIS=diffColor_secondary_axis, $
   DO_TWO_PANELS=do_two_panels, $
   MAKE_SECOND_PANEL=make_second_panel, $
   SECOND_PANEL__PREP_FOR_SECONDARY_AXIS=second_panel__prep_for_secondary_axis, $
   XTITLE=xTitle,XRANGE=xRange, $
   XHIDELABEL=xHideLabel, $
   YTITLE=yTitle,YRANGE=yRange,LOGYPLOT=logYPlot, $
   OVERPLOT=overPlot, $
   CURRENT=current, $
   MARGIN=margin, $
   LAYOUT=layout, $
   OUTPLOT=outPlot, $
   ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array, $
   LUN=lun
  
  COMPILE_OPT idl2

  @utcplot_defaults.pro

  IF ~KEYWORD_SET(lun) THEN lun = -1 ;stdout

  name                    = KEYWORD_SET(plotName) ? plotName : defAvgPlotName
  title                   = plotTitle
  xTitle                  = KEYWORD_SET(xTitle) ? xTitle : defXTitle
  yString                 = KEYWORD_SET(do_two_panels) ? !NULL : yTitle
  xRange                  = KEYWORD_SET(xRange) ? xRange : !NULL
  yRange                  = KEYWORD_SET(yRange) ? yRange : !NULL
  yLog                    = KEYWORD_SET(logYPlot)
  IF N_ELEMENTS(outPlot) GT 0 THEN BEGIN
     IF KEYWORD_SET(make_second_panel) THEN BEGIN
        IF KEYWORD_SET(do_secondary_axis) THEN BEGIN
           axis_style     = 0
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(second_panel__prep_for_secondary_axis) THEN BEGIN
              axis_style  = 1
              ytextColor  = KEYWORD_SET(symColor) AND KEYWORD_SET(diffColor_secondary_axis) ? symColor : !NULL
              yString      = !NULL
           ENDIF ELSE BEGIN
              axis_style  = defAvgSymAxisStyle
           ENDELSE
        ENDELSE

        yTickFont_size    = defSecondaryYTickSize

     ENDIF ELSE BEGIN
        axis_style        = 0
     yTickFont_size       = max_ytickfont_size
     ENDELSE
  ENDIF ELSE BEGIN
     axis_style           = defAvgSymAxisStyle
     yTickFont_size       = max_ytickfont_size
  ENDELSE
  ;; IF N_ELEMENTS(outPlot) GT 0 AND ~KEYWORD_SET(make_second_panel) THEN BEGIN
  ;;    axis_style           = 0
  ;; ENDIF ELSE BEGIN
  ;;    axis_style           =  KEYWORD_SET(do_secondary_axis) ? 0 : defAvgSymAxisStyle
  ;; ENDELSE
  ;; axis_style              = N_ELEMENTS(outPlot) GT 0 AND ~KEYWORD_SET(make_second_panel) ? 0 : defAvgSymAxisStyle
  lineStyle               = N_ELEMENTS(lineStyle) GT 0 ? lineStyle : defAvgSymLinestyle
  color                   = KEYWORD_SET(symColor) ? symColor : defAvgSymColor
  thick                   = KEYWORD_SET(lineThickness) ? lineThickness : defAvgLineThick
  symbol                  = KEYWORD_SET(no_avg_symbol) ? !NULL : defAvgSym
  sym_size                = KEYWORD_SET(no_avg_symbol) ? !NULL : defAvgSymSize
  sym_color               = KEYWORD_SET(symColor) ? symColor : defAvgSymColor
  sym_thick               = KEYWORD_SET(no_avg_symbol) ? !NULL : defAvgSymThick
  xTickFont_size          = max_xtickfont_size
  xTickFont_style         = max_xtickfont_style
  yTickFont_style         = max_ytickfont_style
  ;; CURRENT=current
  ;; OVERPLOT=overplot
  ;; LAYOUT=layout
  IF KEYWORD_SET(do_two_panels) THEN BEGIN
     margin               = !NULL
     IF KEYWORD_SET(make_second_panel) THEN BEGIN
        position          = position_secondPan
     ENDIF ELSE BEGIN
        position          = position_firstPan
     ENDELSE
  ENDIF ELSE BEGIN
     margin               = KEYWORD_SET(margin) ? margin : defPlotMargin_max
     position             = !NULL
  ENDELSE

  ;;errorbar stuff
  ;; errorBar_capsize=KEYWORD_SET(eb_capsize) ? eb_capsize : defEb_capsize
  ;; errorBar_color=KEYWORD_SET(eb_color) ? eb_color : defEb_color
  ;; errorBar_lineStyle=KEYWORD_SET(eb_linestyle) ? eb_linestyle : defEb_linestyle
  ;; errorBar_thick=KEYWORD_SET(eb_thick) ? eb_thick : defEb_thick
  errorBar_color          = KEYWORD_SET(symColor) ? symColor : defEb_color
  errorBar_lineStyle      = KEYWORD_SET(lineStyle) ? lineStyle : defEb_linestyle
  errorBar_thick          = KEYWORD_SET(lineThickness) ? lineThickness : defEb_thick


  IF KEYWORD_SET(xHideLabel) OR (KEYWORD_SET(do_two_panels) AND KEYWORD_SET(make_second_panel)) THEN BEGIN
     xShowLabel = 0
  ENDIF ELSE BEGIN
     xShowLabel = 1
  ENDELSE


  IF KEYWORD_SET(error_plot) THEN BEGIN

     IF N_ELEMENTS(error_bars) EQ 0 OR $
        N_ELEMENTS(error_bars[0,*]) NE N_ELEMENTS(histData) THEN BEGIN
        PRINTF,lun,"N error bars doesn't match N hist elements! Bogus!"
     ENDIF

     plot=ERRORPLOT(histTBins[nz_i],histData[nz_i],error_bars[*,nz_i], $
               NAME=name, $
               TITLE=title, $
               XTITLE=xTitle, $
               YTITLE=yString, $
               XRANGE=xRange, $
               XSHOWTEXT=KEYWORD_SET(overplot) ? !NULL : xShowLabel, $
               YRANGE=yRange, $
               YLOG=yLog, $
               AXIS_STYLE=axis_style, $
               LINESTYLE=lineStyle, $
               COLOR=color, $
               THICK=thick, $
               SYMBOL=symbol, $
               SYM_SIZE=sym_size, $
               SYM_COLOR=sym_color, $ ;, $
               SYM_THICK=sym_thick, $
               FONT_SIZE=xTickFont_size, $
               XTICKFONT_SIZE=xTickFont_size, $
               XTICKFONT_STYLE=xTickFont_style, $
               YTICKFONT_SIZE=yTickFont_size, $
               YTICKFONT_STYLE=yTickFont_style, $
               CURRENT=current, $
               OVERPLOT=overplot, $
               LAYOUT=layout, $
               MARGIN=margin, $
               ERRORBAR_COLOR=errorBar_color, $
               ERRORBAR_LINESTYLE=errorBar_lineStyle, $
               ERRORBAR_THICK=errorBar_thick)

  ENDIF ELSE BEGIN

     plot=plot(histTBins[nz_i],histData[nz_i], $
               NAME=name, $
               TITLE=title, $
               XTITLE=xTitle, $
               XRANGE=xRange, $
               XSHOWTEXT=KEYWORD_SET(overplot) OR (KEYWORD_SET(do_two_panels) AND ~KEYWORD_SET(make_second_panel)) ? 0 : xShowLabel, $
               ;; YTITLE=yString, $
               ;; AXIS_STYLE=axis_style, $
               ;; YTITLE=KEYWORD_SET(make_second_panel) ? !NULL : yString, $
               ;; AXIS_STYLE=(KEYWORD_SET(make_second_panel)) ? 0 : axis_style, $
               YTITLE=KEYWORD_SET(make_second_panel) ? "" : yString, $
               AXIS_STYLE=(KEYWORD_SET(do_two_panels) AND ~KEYWORD_SET(make_second_panel)) ? !NULL : axis_style, $
               YTEXT_COLOR=yTextColor, $
               YCOLOR=yTextColor, $
               HISTOGRAM=histogram, $
               YRANGE=yRange, $
               YLOG=yLog, $
               LINESTYLE=lineStyle, $
               COLOR=color, $
               THICK=thick, $
               SYMBOL=symbol, $
               SYM_SIZE=sym_size, $
               SYM_COLOR=sym_color, $ ;, $
               SYM_THICK=sym_thick, $
               XTICKFONT_SIZE=xTickFont_size, $
               XTICKFONT_STYLE=xTickFont_style, $
               YTICKFONT_SIZE=yTickFont_size, $
               YTICKFONT_STYLE=yTickFont_style, $
               CURRENT=KEYWORD_SET(do_two_panels)? 1 : current, $
               OVERPLOT=KEYWORD_SET(do_two_panels) ? !NULL : overplot, $
               LAYOUT=layout, $
               MARGIN=margin, $
               POSITION=position)
  ENDELSE
  
  IF xShowLabel THEN BEGIN
     ax                = plot.axes
     IF N_ELEMENTS(ax) GT 2 THEN BEGIN
        ax[2].showText = 0
     ENDIF
  ENDIF
  
  IF KEYWORD_SET(second_panel__prep_for_secondary_axis) THEN BEGIN
     topX  = AXIS('X',LOCATION='top', TARGET=plot, $
                  SHOWTEXT=0)

     yText = TEXT(0.03,0.5,yTitle, $
                  /NORMAL, $
                  ALIGNMENT=0.5, $
                  ORIENTATION=90, $
                  FONT_SIZE=max_ytickfont_size, $
                  FONT_STYLE=defHistoYtickfontstyle)
  ENDIF

  IF KEYWORD_SET(do_secondary_axis) THEN BEGIN
     yaxis = AXIS('Y', LOCATION='right', TARGET=plot, $
                  ;; TITLE=yTitle, $
                  ;; MAJOR=nMajorTicks+1, $
                  ;; MINOR=nMinorTicks, $
                  TICKFONT_SIZE=yTickFont_size, $
                  TICKFONT_STYLE=defHistoYtickfontstyle, $
                  ;; TICKFORMAT=KEYWORD_SET(yTickFormat) ? yTickFormat : defHistoTickFormat, $
                  TICKFORMAT=!NULL, $
                  TEXTPOS=1, $
                  ;; COLOR=KEYWORD_SET(color) ? color : defHistoColor)
                  COLOR=KEYWORD_SET(make_second_panel) ? color : "BLACK")

  ENDIF

  ;; IF KEYWORD_SET(make_second_panel) THEN BEGIN
  ;;    yaxis = AXIS('Y', LOCATION='right', TARGET=plot, $
  ;;                 TITLE=yTitle, $
  ;;                 ;; MAJOR=nMajorTicks+1, $
  ;;                 ;; MINOR=nMinorTicks, $
  ;;                 TICKFONT_SIZE=defHistoYticksize, $
  ;;                 TICKFONT_STYLE=defHistoYtickfontstyle, $
  ;;                 ;; TICKFORMAT=KEYWORD_SET(yTickFormat) ? yTickFormat : defHistoTickFormat, $
  ;;                 TICKFORMAT=!NULL, $
  ;;                 TEXTPOS=1, $
  ;;                 ;; COLOR=KEYWORD_SET(color) ? color : defHistoColor)
  ;;                 COLOR='BLACK')
  ;; ENDIF

  IF KEYWORD_SET(add_plot_to_plot_array) THEN BEGIN
     IF N_ELEMENTS(outPlot) GT 0 THEN outPlot=[outPlot,plot] ELSE outPlot = plot
  ENDIF ELSE BEGIN
     outPlot = plot
  ENDELSE

  ;;ALL BAD STUFF! This has to be incorporated. Here's the tip: Make this guideline plotter general, and simply feed it the
  ;;appropriate order-of-magnitude values. Then you be happy, my man.
  ;; STOP

  ;;DO YOU WANT THIS BACKGROUND THING? You definitely want the guideline stuff below
  IF KEYWORD_SET(bkgrnd_maxInd) THEN BEGIN
     
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