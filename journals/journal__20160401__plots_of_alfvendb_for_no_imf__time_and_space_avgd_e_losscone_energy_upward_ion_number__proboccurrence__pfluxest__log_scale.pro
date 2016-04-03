;2016/04/01 Need something to compare with IMF By plots
PRO JOURNAL__20160401__PLOTS_OF_ALFVENDB_FOR_NO_IMF__TIME_AND_SPACE_AVGD_E_LOSSCONE_ENERGY_UPWARD_ION_NUMBER__PROBOCCURRENCE__PFLUXEST__LOG_SCALE

  nonstorm                       = 0
  altitudeRange                  = [1000,4175]
  
  ;; plotSuff                       = 'high-energy_e'


  divide_by_width_x              = 1 ;for ion plot and eflux plot

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 61
  maxILAT                        = 85

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -85
  ;; maxILAT                        = -61

  ;; binILAT                        = 2.0
  binILAT                        = 3.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 0.75
  shiftMLT                       = 0.375

  ;;DB stuff
  do_despun                      = 1

  ;;Bonus
  maskMin                        = 10

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  ;; ;;PROBOCCURRENCE
  probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1
  ;; probOccurrenceRange            = [0,0.05]
  ;; logProbOccurrence              = 0

  ;;49--pFluxEst
  ;; pPlotRange                     = [1e-2,1e0] ;for time-averaged
  ;; pPlotRange                     = [1e-2,5e-1] ;for time-averaged
  pPlotRange                     = [1e-2,5e-1] ;for time-averaged
  logPFPlot                      = 1
  ;; pPlotRange                     = [0,5e-1] ;for time-averaged
  ;; pPlotRange                     = [0,2.5e-1] ;for time-averaged
  ;; logPFPlot                      = 0

  ;; 10-EFLUX_LOSSCONE_INTEG
  eNumFlPlotType                = 'Eflux_Losscone_Integ'
  ;; eNumFlRange                   = [10.^(-3.0),10.^(-1.0)] ;for time-, space-averaged
  ;; eNumFlRange                   = [10.^(-2.0),10.^(0.0)] ;for time-, space-averaged
  eNumFlRange                   = [10.^(-2.0),5e-1] ;for time-, space-averaged
  logENumFlPlot                 = 1
  ;; eNumFlRange                   = [0,2.5e-1] ;for time-, space-averaged
  ;; logENumFlPlot                 = 0
  noNegeNumFl                   = 1

  ;;18--INTEG_ION_FLUX_UP
  iFluxPlotType                  = 'Integ_Up'
  ;; iPlotRange                     = [10^(3.5),10^(7.5)]  ;for time-averaged plot
  iPlotRange                     = [10.^(6.0),10.^(8.0)] ;for time-averaged plot
  logIFPlot                      = 1
  ;; iPlotRange                     = [0,2.5e7] ;for time-averaged plot
  ;; logIFPlot                      = 0

  PLOT_ALFVEN_STATS_IMF_SCREENING, $
     ALTITUDERANGE=altitudeRange, $
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
     ;; /LOGAVGPLOT, $
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