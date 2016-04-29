PRO PLOT_ALFVENDBQUANTITY_SCATTER__EPOCH,maxInd,mTags,NAME=name,AXIS_STYLE=axis_Style, $
                                         SYMCOLOR=symColor,SYMTRANSPARENCY=symTransparency,SYMBOL=symbol, $
                                         ;; ALFDBSTRUCT=alfDB,ALFDBTIME=alfDBTime,PLOT_I=plot_i,CENTERTIME=centerTime,$
                                         ALF_T=alf_t,ALF_Y=alf_y, $
                                         PLOTTITLE=plotTitle, $
                                         XTITLE=xTitle, $
                                         XRANGE=xRange, $
                                         XHIDELABEL=xHideLabel, $
                                         YTITLE=yTitle, $
                                         YRANGE=yRange, $
                                         LOGYPLOT=logYPlot, $
                                         DO_SECONDARY_AXIS=do_secondary_axis, $
                                         DO_TWO_PANELS=do_two_panels, $
                                         MAKE_SECOND_PANEL=make_second_panel, $
                                         OVERPLOT_ALFVENDBQUANTITY=overplot_alfvendbquantity, $
                                         CURRENT=current, $
                                         MARGIN=margin, $
                                         YMINOR=yMinor, $
                                         LAYOUT=layout, $
                                         CLIP=clip, $
                                         YEAR_AND_SEASON_MODE=year_and_season_mode, $
                                         OUTPLOT=outPlot,ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array
  
  @utcplot_defaults.pro

  ;; IF N_ELEMENTS(alfDB) GT 0 AND N_ELEMENTS(plot_i) GT 0 AND N_ELEMENTS(alf_y) EQ 0 THEN BEGIN
  ;;    alf_y = alfDB.(maxInd)[plot_i]
  ;; ENDIF

  ;; IF N_ELEMENTS(alfDBTime) GT 1 AND N_ELEMENTS(plot_i) GT 1 AND N_ELEMENTS(centerTime) GT 0 $
  ;;    AND N_ELEMENTS(alf_t) EQ 0 THEN BEGIN
  ;;    alf_t = alfDBTime[plot_i]-centerTime
  ;; ENDIF

    IF KEYWORD_SET(year_and_season_mode) THEN BEGIN
     SETUP_YEAR_AND_SEASON_SEA_PLOT, $
        XTITLE=xTitle, $
        YTITLE=yTitle, $
        XSTYLE=xStyle, $
        PLOTTITLE=plotTitle, $
        XTICKVALUES=xTickValues,$
        XTICKNAME=xTickName
  ENDIF

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

  ;; IF KEYWORD_SET(xHideLabel) OR (KEYWORD_SET(do_two_panels) AND ~KEYWORD_SET(make_second_panel)) THEN BEGIN
  IF KEYWORD_SET(xHideLabel) OR (KEYWORD_SET(do_two_panels) AND KEYWORD_SET(make_second_panel)) THEN BEGIN
     xShowLabel = 0
  ENDIF ELSE BEGIN
     xShowLabel = 1
  ENDELSE

  ;; IF KEYWORD_SET(xHideLabel) THEN BEGIN
  ;;    xShowLabel = 0
  ;; ENDIF ELSE BEGIN
  ;;    xShowLabel = 1
  ;; ENDELSE

  IF N_ELEMENTS(alf_t) GT 1 THEN BEGIN
     plot=plot(alf_t, $
               alf_y, $
               XTITLE=KEYWORD_SET(xTitle) ? xTitle : defXTitle, $
               YTITLE=KEYWORD_SET(overplot_alfvendbquantity) ? !NULL : (KEYWORD_SET(DO_two_panels) ? !NULL: yTitle), $
               XRANGE=KEYWORD_SET(xRange) ? xRange : [MIN(alf_t),MAX(alf_t)], $
               XSHOWTEXT=KEYWORD_SET(overplot_alfvendbquantity) ? !NULL : xShowLabel, $
               YRANGE=KEYWORD_SET(yRange) ? yRange : [MIN(alf_y),MAX(alf_y)], $
               YLOG=KEYWORD_SET(logYPlot) ? 1 : 0, $
               AXIS_STYLE=(KEYWORD_SET(overplot_alfvendbquantity)) ? 0 : 1, $
               LINESTYLE=' ', $
               SYMBOL=KEYWORD_SET(symbol) ? symbol : max_scatter_symbol, $
               SYM_COLOR=KEYWORD_SET(symColor) ? symColor : max_scatter_color, $
               XTICKVALUES=xTickValues,$
               XTICKNAME=xTickName, $
               XSTYLE=xStyle, $
               XTICKFONT_SIZE=max_xtickfont_size, $
               XTICKFONT_STYLE=max_xtickfont_style, $
               YTICKFONT_SIZE=max_ytickfont_size, $
               YTICKFONT_STYLE=max_ytickfont_style, $
               YMINOR=yMinor, $
               MARGIN=margin, $
               POSITION=position, $
               CURRENT=KEYWORD_SET(CURRENT) OR KEYWORD_SET(overplot_alfvendbquantity) OR KEYWORD_SET(do_two_panels), $ ;current, $
               ;; OVERPLOT=overplot_alfvendbquantity, $
               LAYOUT=layout, $
               CLIP=clip, $
               SYM_TRANSPARENCY=KEYWORD_SET(symTransparency) ? symTransparency : defSymTransp)
     
     IF KEYWORD_SET(overplot_alfvendbquantity) THEN BEGIN
        yaxis = AXIS('Y', LOCATION='right', TARGET=plot, $
                     TITLE=yTitle, $
                     MAJOR=nMajorTicks, $
                     MINOR=KEYWORD_SET(yMinor) ? yMinor : nMinorTicks, $
                     ;; TICKNAME=['60','70','80'], $  ;;temp for journal__20160104__stormthing
                     ;; TICKVALUES=[60,70,80], $
                     TICKFONT_SIZE=max_ytickfont_size, $
                     ;; TICKFONT_STYLE=defHistoYtickfontstyle, $
                  ;; TICKFORMAT=defHistoTickFormat, $
                     TEXTPOS=1, $
                     COLOR=KEYWORD_SET(symColor) ? symColor : max_scatter_color)
     ENDIF
     
     IF xShowLabel THEN BEGIN
        ax                = plot.axes
        IF N_ELEMENTS(ax) GT 2 THEN BEGIN
           ax[2].showText = 0
        ENDIF
     ENDIF

     IF KEYWORD_SET(add_plot_to_plot_array) THEN BEGIN
        IF N_ELEMENTS(outPlot) GT 0 THEN outPlot=[outPlot,plot] ELSE outPlot = plot
     ENDIF ELSE BEGIN
        outPlot = plot
     ENDELSE
  ENDIF
END