;2016/04/29 They seem so freaking difficult to get right
PRO JOURNAL__20160429__WHY_ARE_SEASONS_PLOTS_SO_HARD

  IF ~KEYWORD_SET(n_years) THEN n_years = 2
  IF ~KEYWORD_SET(start_year) THEN start_year = 1997
  years                = LINDGEN(n_years)+start_year
  yearStr              = STRING(FORMAT='(I0,"-01-01/00:00:00")',years)
  yearUTC              = DOUBLE(STR_TO_TIME(yearStr))

  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,/GET_GOOD_I,good_i=good_i

  the_1997_i           = WHERE(cdbTime GE yearUTC[0] AND cdbTime LE yearUTC[1] AND maximus.ilat GE 0)
  the_good_1997_i      = CGSETINTERSECTION(good_i,the_1997_i)

  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY
  xTickValues                   = GET_MONTH_TIMES__SEC_SINCE_YEAR_BEGINNING(OUT_MONTHNAMES=monthNames)/3600.
  xTickName                     = monthNames

  cghistoplot,(cdbtime[the_good_1997_i]-yearUTC[0])/60./60., $
              XTITLE='Hours since ' + yearStr[0], $
              XTICKNAMES=xTickName, $
              XTICKVALUES=xTickValues, $
              MAXINPUT=LONG(365*24), $
              OUTPUT=plotDir+'event_histo_for_1997.png'

END