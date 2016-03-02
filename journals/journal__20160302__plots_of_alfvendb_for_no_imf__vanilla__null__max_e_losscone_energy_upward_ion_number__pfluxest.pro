;2016/03/02 We need something to just show us NULL results, you know?
PRO JOURNAL__20160302__PLOTS_OF_ALFVENDB_FOR_NO_IMF__VANILLA__NULL__MAX_E_LOSSCONE_ENERGY_UPWARD_ION_NUMBER__PFLUXEST

  nonstorm                       = 0

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
  ;; shiftMLT                       = 0.25

  ;;IMF condition stuff
  ;; stableIMF                      = 20
  byMin                          = 4
  do_abs_bymin                   = 1
  bzMax                          = 1
  ;; bzMin                          = -4

  ;;DB stuff
  do_despun                      = 1

  ;;Bonus
  maskMin                        = 10

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  ;;49--PFLUXEST
  pPlotRange                     = [0.3,10.^(0.6)] ;for time-averaged
  ;; pPlotRange                     = [1e-2,1e0] ;for time-averaged
  logPFPlot                      = 1

  ;; EFLUX_MAX
  eFluxPlotType                 ='MAX'
  ;; ePlotRange                    = [10.^(-1.0),10.^(1.0)]
  ePlotRange                    = [0.2,10^(0.8)]
  logEFPlot                     = 1

  ;; 10-EFLUX_LOSSCONE_INTEG
  eNumFlPlotType                = 'eFlux_losscone_integ'
  eNumFlRange                   = [50,5000]
  logENumFlPlot                 = 1
  noNegeNumFl                   = 1

  ;;16--ION_FLUX_UP
  iFluxPlotType                  = 'MAX_UP'
  ;; iPlotRange                     = [10^(3.5),10^(7.5)]  ;for time-averaged plot
  iPlotRange                     = [10.^(6.0),10.^(9.0)] ;for time-averaged plot
  logIFPlot                      = 1

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
     /LOGAVGPLOT, $
     ;; DIVIDE_BY_WIDTH_X=divide_by_width_x, $
     /PPLOTS, $
     LOGPFPLOT=logPFPlot, $
     PPLOTRANGE=pPlotRange, $
     /EPLOTS, $
     EFLUXPLOTTYPE=eFluxPlotType, $
     EPLOTRANGE=ePlotRange, $
     LOGEFPLOT=logEFPlot, $
     /ENUMFLPLOTS, $
     ENUMFLPLOTTYPE=eNumFlPlotType, $
     ENUMFLPLOTRANGE=eNumFlRange, $
     LOGENUMFLPLOT=logENumFlPlot, $
     NONEGENUMFL=noNegENumFl, $
     /IONPLOTS, $
     IFLUXPLOTTYPE=iFluxPlotType, $
     IPLOTRANGE=iPlotRange, $
     LOGIFPLOT=logIFPlot, $
     PLOTSUFFIX=plotSuff, $
     /CB_FORCE_OOBHIGH, $
     /CB_FORCE_OOBLOW, $
     /COMBINE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER
  
END