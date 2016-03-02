;2016/03/02 We need something to just show us NULL results, you know?
PRO JOURNAL__20160302__PLOTS_OF_ALFVENDB_FOR_NO_IMF__VANILLA__NULL__TIME_AND_SPACE_AVGD_E_LOSSCONE_ENERGY_UPWARD_ION_NUMBER__PROBOCCURRENCE__PFLUXEST

  NONSTORM                       = 0

  ;; plotSuff                       = 'high-energy_e'


  divide_by_width_x              = 1 ;for ion plot and eflux plot

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  ;; hemi                           = 'NORTH'
  ;; minILAT                        = 61
  ;; maxILAT                        = 85
  ;; binILAT                        = 2.0

  hemi                           = 'SOUTH'
  minILAT                        = -85
  maxILAT                        = -61
  binILAT                        = 2.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 1.0

  ;;DB stuff
  do_despun                      = 1

  ;;Bonus
  maskMin                        = 10

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  ;; ;;PROBOCCURRENCE
  probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1

  ;;49--pFluxEst
  pPlotRange                     = [1e-3,5e-1] ;for time-averaged
  ;; pPlotRange                     = [1e-2,1e0] ;for time-averaged
  logPFPlot                      = 1

  ;; 10-EFLUX_LOSSCONE_INTEG
  eNumFlPlotType                = 'Eflux_Losscone_Integ'
  eNumFlRange                   = [10.^(-3.0),10.^(-1.0)] ;for time-, space-averaged
  logENumFlPlot                 = 1
  noNegeNumFl                   = 1

  ;;18--INTEG_ION_FLUX_UP
  iFluxPlotType                  = 'Integ_Up'
  ;; iPlotRange                     = [10^(3.5),10^(7.5)]  ;for time-averaged plot
  iPlotRange                     = [10.^(5.0),10.^(7.0)] ;for time-averaged plot
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
     SMOOTHWINDOW=smoothWindow, $
     /LOGAVGPLOT, $
     DIVIDE_BY_WIDTH_X=divide_by_width_x, $
     /DO_TIMEAVG_FLUXQUANTITIES, $
     /PROBOCCURRENCEPLOT, $
     LOGPROBOCCURRENCE=logProbOccurrence, $
     PROBOCCURRENCERANGE=probOccurrenceRange, $
     /PPLOTS, $
     LOGPFPLOT=logPFPlot, $
     PPLOTRANGE=pPlotRange, $
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