;2016/04/12 Now we're doing it the Chaston et al. [2007] ["How important are dispersive ..."] way
PRO JOURNAL__20160412__PLOTS_CHASTONETAL_2007_STYLE_PROBOCCURRENCE

  nonstorm                       = 0
  altitudeRange                  = [0000,4175]
  
  ;; tile_images                    = 0
  ;; tiling_order                   = [0,1,2,3]

  divide_by_width_x              = 1 ;for ion plot and eflux plot

  orbRange                       = [1000,10000]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Which plots?
  probOccurrencePlot             = 1
  norbsWeventsPerOrbContribPlot  = 1
  nowepco_range                  = [0,0.5]

  logAvgPlot                     = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 60
  maxILAT                        = 84

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -86
  ;; maxILAT                        = -61

  ;; binILAT                        = 2.0
  binILAT                        = 3.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 2.0
  ;; shiftMLT                       = 0.5

  ;;DB stuff
  do_despun                      = 1

  ;;Bonus
  maskMin                        = 10

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  ;; ;;PROBOCCURRENCE
  ;; probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1
  probOccurrenceRange            = [0,0.05]
  logProbOccurrence              = 0

  ;;49--pFluxEst
  ;; pPlotRange                     = [1e-2,1e0] ;for time-averaged
  ;; pPlotRange                     = [1e-3,5e-1] ;for time-averaged
  ;; logPFPlot                      = 1
  ;; pPlotRange                     = [0,5e-1] ;for time-averaged
  pPlotRange                     = [0,1e8] ;for time-averaged
  logPFPlot                      = 0

  ;; 10-EFLUX_LOSSCONE_INTEG
  eNumFlPlotType                = 'Eflux_Losscone_Integ'
  ;; eNumFlRange                   = [10.^(-3.0),10.^(-1.0)] ;for time-, space-averaged
  ;; logENumFlPlot                 = 1
  eNumFlRange                   = [0,1e8] ;for time-, space-averaged
  logENumFlPlot                 = 0
  noNegeNumFl                   = 1

  ;;18--INTEG_ION_FLUX_UP
  iFluxPlotType                  = 'Integ_Up'
  ;; iPlotRange                     = [10^(3.5),10^(7.5)]  ;for time-averaged plot
  ;; iPlotRange                     = [10.^(5.0),10.^(7.0)] ;for time-averaged plot
  ;; logIFPlot                      = 1
  iPlotRange                     = [0,1e23] ;for time-averaged plot
  logIFPlot                      = 0

  PLOT_ALFVEN_STATS_IMF_SCREENING, $
     ALTITUDERANGE=altitudeRange, $
     NONSTORM=nonstorm, $
     CHARERANGE=charERange, $
     ORBRANGE=orbRange, $
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
     LOGAVGPLOT=logAvgPlot, $
     DIVIDE_BY_WIDTH_X=divide_by_width_x, $
     DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg, $
     PROBOCCURRENCEPLOT=probOccurrencePlot, $
     LOGPROBOCCURRENCE=logProbOccurrence, $
     PROBOCCURRENCERANGE=probOccurrenceRange, $
     NORBSWITHEVENTSPERCONTRIBORBSPLOT=norbsWeventsPerOrbContribPlot, $
     NOWEPCO_RANGE=nowepco_range, $
     PLOTSUFFIX=plotSuff, $
     TILE_IMAGES=tile_images, $
     N_TILE_ROWS=n_tile_rows, $
     N_TILE_COLUMNS=n_tile_columns, $
     TILEPLOTSUFF=tilePlotSuff, $
     TILING_ORDER=tiling_order, $
     CB_FORCE_OOBHIGH=cb_force_oobHigh
  
END
