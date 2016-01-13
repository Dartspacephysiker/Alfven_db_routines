;2016/01/13
;All right, now that we resolved the whole sign issue in JOURNAL__20160113__SUP_WITH_DESPUN_ION_DATA,
;let's check out these distributions!
PRO JOURNAL__20160113__DESPUN_HEAVIES_DISTRIBUTIONS

  hoyDia              = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  LOAD_MAXIMUS_AND_CDBTIME,maximus,/DO_DESPUNDB,/USING_HEAVIES

  north_i             = GET_CHASTON_IND(maximus,/NORTH,/USING_HEAVIES)
  south_i             = GET_CHASTON_IND(maximus,/SOUTH,/USING_HEAVIES)

  binsize=0.1

  ;;Histograms
  oxy_hist_n          = HISTOGRAM(ALOG10(ABS(maximus.oxy_flux_up[north_i])),BINSIZE=binsize,MIN=2.,MAX=8.,LOCATIONS=oxy_locs)
  oxy_hist_s          = HISTOGRAM(ALOG10(ABS(maximus.oxy_flux_up[south_i])),BINSIZE=binsize,MIN=2.,MAX=8.,LOCATIONS=oxy_locs)

  hel_hist_n          = HISTOGRAM(ALOG10(ABS(maximus.helium_flux_up[north_i])),BINSIZE=binsize,MIN=2.,MAX=8.,LOCATIONS=hel_locs)
  hel_hist_s          = HISTOGRAM(ALOG10(ABS(maximus.helium_flux_up[south_i])),BINSIZE=binsize,MIN=2.,MAX=8.,LOCATIONS=hel_locs)

  hyd_hist_n          = HISTOGRAM(ALOG10(ABS(maximus.proton_flux_up[north_i])),BINSIZE=binsize,MIN=2.,MAX=8.,LOCATIONS=hyd_locs)
  hyd_hist_s          = HISTOGRAM(ALOG10(ABS(maximus.proton_flux_up[south_i])),BINSIZE=binsize,MIN=2.,MAX=8.,LOCATIONS=hyd_locs)

  ;;Now plots
  dim                 = [800,600]
  legPos              = [0.35,0.75]

  ;;OXYGEN
  oxyWind             = WINDOW(WINDOW_TITLE='Oxygen', $
                               DIMENSIONS=dim)

  oxyPlot             = PLOT(oxy_locs,oxy_hist_n, $
                             NAME='O!U+!N, N Hemi', $
                             /HISTOGRAM, $
                             XRANGE=[2,8], $
                             XTITLE='Log Maximum Upward O!U+!N Flux', $
                             YTITLE='Count', $
                             THICK=2.5, $
                             COLOR='red', $
                             /CURRENT)

  oxyPlot_s           = PLOT(oxy_locs,oxy_hist_s, $
                             NAME='O!U+!N, S Hemi', $
                             /HISTOGRAM, $
                             XRANGE=[2,8], $
                             COLOR='blue', $
                             THICK=2.5, $
                             /OVERPLOT, $
                             /CURRENT)

  oxy_leg             = LEGEND(TARGET=[oxyPlot,oxyPlot_s], $
                               POSITION=legPos, $
                               /NORMAL)

  oxyWind.save,hoyDia+'--Oxygen_distribution--despun_DB.png'

  ;;HELIUM
  helWind             = WINDOW(WINDOW_TITLE='Helium', $
                               DIMENSIONS=dim)

  helPlot             = PLOT(hel_locs,hel_hist_n, $
                             NAME='He!U+!N, N Hemi', $
                             /HISTOGRAM, $
                             XRANGE=[2,8], $
                             XTITLE='Log Maximum Upward He!U+!N Flux', $
                             YTITLE='Count', $
                             THICK=2.5, $
                             COLOR='red', $
                             /CURRENT)

  helPlot_s           = PLOT(hel_locs,hel_hist_s, $
                             NAME='He!U+!N, S Hemi', $
                             /HISTOGRAM, $
                             XRANGE=[2,8], $
                             COLOR='blue', $
                             THICK=2.5, $
                             /OVERPLOT, $
                             /CURRENT)

  hel_leg             = LEGEND(TARGET=[helPlot,helPlot_s], $
                               POSITION=legPos, $
                               /NORMAL)

  helWind.save,hoyDia+'--Helium_distribution--despun_DB.png'

  ;;HYDROGEN
  hydWind             = WINDOW(WINDOW_TITLE='Hydrogen', $
                               DIMENSIONS=dim)

  hydPlot             = PLOT(hyd_locs,hyd_hist_n, $
                             NAME='H!U+!N, N Hemi', $
                             /HISTOGRAM, $
                             XRANGE=[2,8], $
                             XTITLE='Log Maximum Upward H!U+!N Flux', $
                             YTITLE='Count', $
                             THICK=2.5, $
                             COLOR='red', $
                             /CURRENT)

  hydPlot_s           = PLOT(hyd_locs,hyd_hist_s, $
                             NAME='H!U+!N, S Hemi', $
                             /HISTOGRAM, $
                             XRANGE=[2,8], $
                             COLOR='blue', $
                             THICK=2.5, $
                             /OVERPLOT, $
                             /CURRENT)

  hyd_leg             = LEGEND(TARGET=[hydPlot,hydPlot_s], $
                               POSITION=legPos, $
                               /NORMAL)

  hydWind.save,hoyDia+'--H_plus_distribution--despun_DB.png'



  cghistoplot,ALOG10(ABS(maximus.oxy_flux_up[north_i])),TITLE='Log upward oxygen flux, Northern Hemi'
  cghistoplot,ALOG10(ABS(maximus.oxy_flux_up[south_i])),TITLE='Log upward oxygen flux, Southern Hemi'

END