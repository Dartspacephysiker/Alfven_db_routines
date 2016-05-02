PRO PLOT_ALFVENDB_DATA_AVAILABILITY__EPOCH,tRanges_orbs,centerTime, $
   XRANGE=xRange, $
   BOTTOM_YRANGE=bottom_yRange, $
   LAYOUT=layout, $
   CURRENT=current, $
   MARGIN=margin, $
   SYM_COLOR=sym_color, $
   DATAAVAILPLOT=dataAvailPlot, $
   YEAR_AND_SEASON_MODE=year_and_season_mode

  
  @utcplot_defaults.pro

  IF NOT KEYWORD_SET(bottom_yRange) THEN BEGIN
     PRINT,"Gonna lose the data availability triangles; plotting them at y=0..."
     WAIT,1
  ENDIF

  nOrbs=N_ELEMENTS(tRanges_orbs[*,0])
  tVals=MAKE_ARRAY(nOrbs,/DOUBLE)
  FOR j=0,nOrbs-1 DO BEGIN
     tVals[j] = (MEAN(tRanges_orbs[j,*])-centerTime)/3600.
  ENDFOR

  yVal  = KEYWORD_SET(bottom_yRange) ? bottom_yRange : 0
  yVals = MAKE_ARRAY(nOrbs,VALUE=yVal)

  ;;Now plot where we had data, and for what length of time (maybe)
  dataAvailPlot=plot(tVals, $
                     yVals, $
                     ;; (log_DBquantity) ? ALOG10(cdb_y) : cdb_y, $
                     XTITLE=defXTitle, $
                     ;; YTITLE=(KEYWORD_SET(yTitle_maxInd) ? $
                     ;;         yTitle_maxInd : $
                     ;;         mTags(maxInd)), $
                     XRANGE=xRange, $
                     ;; YRANGE=(KEYWORD_SET(bottom_yRange)) ? $
                     ;; bottom_yRange : [minDat,maxDat], $
                     ;; YLOG=(log_DBQuantity) ? 1 : 0, $
                     AXIS_STYLE=0, $
                     LINESTYLE=' ', $
                     SYMBOL=defShowSymbol, $
                     ;; SYM_SIZE=defShowSymSize, $
                     SYM_SIZE=KEYWORD_SET(year_and_season_mode) ? defShowSymSize_YSEASMODE : defShowSymSize, $
                     XTICKFONT_SIZE=max_xtickfont_size, $
                     XTICKFONT_STYLE=max_xtickfont_style, $
                     YTICKFONT_SIZE=max_ytickfont_size, $
                     YTICKFONT_STYLE=max_ytickfont_style, $
                     LAYOUT=layout, $
                     MARGIN=margin, $
                     CURRENT=current, $
                     CLIP=0, $
                     SYM_COLOR=N_ELEMENTS(sym_color) GT 0 ? sym_color :  !NULL, $
                     ;; SYM_TRANSPARENCY=(i EQ 2) ? 60 : defSymTransp) ;this line is for making events on plot #3 stand out
                     ;; SYM_TRANSPARENCY=0)
                     SYM_TRANSPARENCY=KEYWORD_SET(year_and_season_mode) ? 95 : 50)

  dataAvailPlot.SYM_FILLED = 1
  
  ;; ENDIF  ;; end show_data_avail
  
END