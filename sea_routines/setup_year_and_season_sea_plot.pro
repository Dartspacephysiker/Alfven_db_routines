;2016/04/29
PRO SETUP_YEAR_AND_SEASON_SEA_PLOT, $
   PLOTTITLE=plotTitle, $
   XMINOR=xMinor, $
   XRANGE=xRange, $
   XSTYLE=xStyle, $
   XTICKVALUES=xTickValues,$
   XTICKNAME=xTickName, $
   XTITLE=xTitle, $
   YTITLE=yTitle ;, $
   ;; OUT_PLOTTITLE=out_plotTitle

   
  month_sec                     = GET_MONTH_TIMES__SEC_SINCE_YEAR_BEGINNING(OUT_MONTHNAMES=monthNames)

  xMinor                        = 0
  xRange                        = [0,365*24]
  xStyle                        = 1
  xTickName                     = monthNames
  xTickValues                   = month_sec/3600.
  ;; xTitle                        = 'Month'

  ;; seasonSuff                    = '(Season, superposed)'
  ;; plotTitle                     = KEYWORD_SET(plotTitle) ? plotTitle + ' ' + seasonSuff : seasonSuff

END