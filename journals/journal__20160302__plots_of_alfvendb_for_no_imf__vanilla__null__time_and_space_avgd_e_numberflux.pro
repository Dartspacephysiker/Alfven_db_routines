;2016/03/02 We need something to just show us NULL results, you know?
PRO JOURNAL__20160302__PLOTS_OF_ALFVENDB_FOR_NO_IMF__VANILLA__NULL__TIME_AND_SPACE_AVGD_E_NUMBERFLUX

  NONSTORM                       = 0

  ;; plotSuff                       = 'high-energy_e'


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 61
  maxILAT                        = 85
  binILAT                        = 2.0

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -85
  ;; maxILAT                        = -61
  ;; binILAT                        = 2.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 1.0

  ;;DB stuff
  do_despun                      = 1

  ;;Bonus
  maskMin                        = 10

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  ;; 10-EFLUX_LOSSCONE_INTEG
  ;; eNumFlPlotType                = 'ESA_Number_flux'
  eNumFlRange                   = [10.^(6.0),10.^(9.0)] ;for not-time-, space-averaged
  ;; eNumFlRange                   = [10.^(6.5),10.^(8.3)] ;for time-, space-averaged
  noNegeNumFl                   = 1

  ;; eNumFlRange                   = [10.^(1.0),10.^(6.0)] ;for no pos plot
  ;; maskMin                       = 5 ;just for you, noPos Plots!
  ;; noPoseNumFl                   = 1

  logENumFlPlot                 = 1

  PLOT_ALFVEN_STATS_IMF_SCREENING, $
     NONSTORM=nonstorm, $
     CHARERANGE=charERange, $
     MASKMIN=maskMin, $
     HEMI=hemi, $
     BINMLT=binMLT, $
     SHIFTMLT=shiftMLT, $
     MINILAT=minILAT, $
     MAXILAT=maxILAT, $
     BINILAT=binILAT, $
     /MIDNIGHT, $
     DO_DESPUNDB=do_despun, $
     /DO_NOT_CONSIDER_IMF, $
     SMOOTHWINDOW=smoothWindow, $
     /LOGAVGPLOT, $
     ;; /DO_TIMEAVG_FLUXQUANTITIES, $
     /ENUMFLPLOTS, $
     ENUMFLPLOTTYPE=eNumFlPlotType, $
     ENUMFLPLOTRANGE=eNumFlRange, $
     LOGENUMFLPLOT=logENumFlPlot, $
     NONEGENUMFL=noNegENumFl, $
     NOPOSENUMFL=noPosENumFl, $
     PLOTSUFFIX=plotSuff, $
     /CB_FORCE_OOBHIGH, $
     /CB_FORCE_OOBLOW, $
     /COMBINE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER
  
END