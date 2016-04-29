;2016/04/29
PRO JOURNAL__20160429__SUPERPOSED_SEASONS_PROBOCCURRENCE

  COMPILE_OPT idl2

  binSize_days                  = 5
  binSize                       = LONG64(binSize_days)*24*60*60

  separate_into_north_south     = 1

  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,/GET_GOOD_I,GOOD_I=good_i
  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastLoc_times,fastLoc_delta_t

  month_sec   = GET_MONTH_TIMES__SEC_SINCE_YEAR_BEGINNING(OUT_MONTHNAMES=monthNames)


  ;; Generate the histogram
  timeList                      = LIST()
  histList                      = LIST()
  IF KEYWORD_SET(separate_into_north_south) THEN BEGIN
     north_times                = SECONDS_SINCE_YEAR_BEGINNING__UTC(cdbTime[CGSETINTERSECTION(good_i,WHERE(maximus.ilat GT 0))])
     south_times                = SECONDS_SINCE_YEAR_BEGINNING__UTC(cdbTime[CGSETINTERSECTION(good_i,WHERE(maximus.ilat LT 0))])

     histList.add,HISTOGRAM(north_times,BINSIZE=binSize,/L64,LOCATIONS=histTimes_N)
     histList.add,HISTOGRAM(south_times,BINSIZE=binSize,/L64,LOCATIONS=histTimes_S)

     timeList.add,histTimes_N
     timeList.add,histTimes_S

     nameArr                    = ['North','South']
     plotColors                 = ['Red','Blue']
  ENDIF ELSE BEGIN
     times                      = SECONDS_SINCE_YEAR_BEGINNING__UTC(cdbTime[good_i])

     histList.add,HISTOGRAM(times,BINSIZE=binSize,/L64,LOCATIONS=histTimes)

     timeList.add,histTimes

     nameArr                    = 'Both hemispheres'
     plotColors                 = 'black'
  ENDELSE
  
  ;; Plot the data
  nPlots                        = N_ELEMENTS(histList)
  plotArr                       = MAKE_ARRAY(nPlots,/OBJ)
  xTitle                        = 'Month'
  yTitle                        = 'N Events'
  plotTitle                     = 'Alfven wave events by season, superposed'
  FOR i=0,nPlots-1 DO BEGIN
     plotArr[i]                 = PLOT(timeList[i], histList[i], $
                                       TITLE=plotTitle, $
                                       NAME=nameArr[i], $
                                       COLOR=plotColors[i], $
                                       ;; XTICKUNITS = ['Time'], $
                                       XTITLE=xTitle, $
                                       YTITLE=yTitle, $
                                       XTICKVALUES=month_sec,$
                                       XTICKNAME=monthNames, $
                                       /HISTOGRAM, $
                                       XSTYLE=1, $
                                       OVERPLOT=i GT 0)
  ENDFOR

  IF nPlots GT 1 THEN BEGIN
     legend                     = LEGEND(TARGET=plotArr[*], $
                                         /NORMAL, $
                                         POSITION=[0.7,0.85], $
                                         FONT_SIZE=18, $
                                         HORIZONTAL_ALIGNMENT=0.5, $
                                         VERTICAL_SPACING=0.01, $
                                         /AUTO_TEXT_COLOR)
  ENDIF
END