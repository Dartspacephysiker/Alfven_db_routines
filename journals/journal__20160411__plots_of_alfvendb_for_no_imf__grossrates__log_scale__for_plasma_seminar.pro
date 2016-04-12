;2016/04/01 These plots are on the same scale and have the same binning as those I'll be showing Bin and Bill next Monday
PRO JOURNAL__20160411__PLOTS_OF_ALFVENDB_FOR_NO_IMF__GROSSRATES__LOG_SCALE__FOR_PLASMA_SEMINAR

  nonstorm                       = 0
  altitudeRange                  = [0000,4175]
  
  ;; plotSuff                       = 'high-energy_e'

  tile_images                    = 1
  tiling_order                   = [3,1,2,0]

  divide_by_width_x              = 1 ;for ion plot and eflux plot

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Which plots?
  do_timeAvg                     = 1
  do_grossRate_fluxQuantities    = 1
  probOccurrencePlot             = 1
  logAvgPlot                     = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 62
  maxILAT                        = 86

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
  probOccurrenceRange            = [1e-3,1e-1]
  logProbOccurrence              = 1

  ;;49--pFluxEst
  ;; pPlotRange                     = [1e-2,1e0] ;for time-averaged
  ;; pPlotRange                     = [1e-3,5e-1] ;for time-averaged
  ;; logPFPlot                      = 1
  ;; pPlotRange                     = [0,5e-1] ;for time-averaged
  pPlotRange                     = [1e6,1e8] ;for time-averaged
  logPFPlot                      = 1

  ;; 10-EFLUX_LOSSCONE_INTEG
  eNumFlPlotType                = 'Eflux_Losscone_Integ'
  ;; eNumFlRange                   = [10.^(-3.0),10.^(-1.0)] ;for time-, space-averaged
  ;; logENumFlPlot                 = 1
  eNumFlRange                   = [1e6,1e8] ;for time-, space-averaged
  logENumFlPlot                 = 1
  noNegeNumFl                   = 1

  ;;18--INTEG_ION_FLUX_UP
  iFluxPlotType                  = 'Integ_Up'
  ;; iPlotRange                     = [10^(3.5),10^(7.5)]  ;for time-averaged plot
  ;; iPlotRange                     = [10.^(5.0),10.^(7.0)] ;for time-averaged plot
  ;; logIFPlot                      = 1
  iPlotRange                     = [1e20,1e23] ;for time-averaged plot
  logIFPlot                      = 1

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
     LOGAVGPLOT=logAvgPlot, $
     DIVIDE_BY_WIDTH_X=divide_by_width_x, $
     DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg, $
     PROBOCCURRENCEPLOT=probOccurrencePlot, $
     LOGPROBOCCURRENCE=logProbOccurrence, $
     PROBOCCURRENCERANGE=probOccurrenceRange, $
     DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
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
     /NONEGIFLUX, $
     IPLOTRANGE=iPlotRange, $
     LOGIFPLOT=logIFPlot, $
     PLOTSUFFIX=plotSuff, $
     TILE_IMAGES=tile_images, $
     N_TILE_ROWS=n_tile_rows, $
     N_TILE_COLUMNS=n_tile_columns, $
     TILEPLOTSUFF=tilePlotSuff, $
     TILING_ORDER=tiling_order, $
     ;; /CB_FORCE_OOBHIGH, $
     ;; /CB_FORCE_OOBLOW, $
     /COMBINE_PLOTS, $
     /SAVE_COMBINED_WINDOW, $
     /COMBINED_TO_BUFFER
  
END
