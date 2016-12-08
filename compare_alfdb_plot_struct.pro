;;12/07/16
PRO COMPARE_ALFDB_PLOT_STRUCT,alfDB_plot_struct1,alfDB_plot_struct2,RESET=reset

  COMPILE_OPT IDL2

  except_list = ["maskMin"                        , $
                 "tHist_mask_bins_below_thresh"   , $
                 "nPlots"                         , $
                 "ePlots"                         , $
                 "eFluxPlotType"                  , $
                 "eNumFlPlots"                    , $
                 "eNumFlPlotType"                 , $
                 "pPlots"                         , $
                 "ionPlots"                       , $
                 "ifluxPlotType"                  , $
                 "charEPlots"                     , $
                 "charEType"                      , $
                 "chariEPlots"                    , $
                 "autoscale_fluxPlots"            , $
                 "do_timeAvg_fluxQuantities"      , $
                 "do_logAvg_the_timeAvg"          , $
                 "t_ProbOccurrence"               , $
                 "orbContribPlot"                 , $
                 "orbTotPlot"                     , $
                 "orbFreqPlot"                    , $
                 "nEventPerOrbPlot"               , $
                 "nEventPerMinPlot"               , $
                 "probOccurrencePlot"             , $
                 "squarePlot"                     , $
                 "polarContour"                   , $
                 "wholeCap"                       , $
                 "medianPlot"                     , $
                 "logAvgPlot"                     , $
                 "plotMedOrAvg"                   , $
                 "dataDir"                        , $
                 "no_burstData"                   , $
                 "writeASCII"                     , $
                 "writeHDF5"                      , $
                 "writeProcessedH2d"              , $
                 "saveRaw"                        , $
                 "rawDir"                         , $
                 "showPlotsNoSave"                , $
                 "medHistOutData"                 , $
                 "medHistOutTxt"                  , $
                 "outputPlotSummary"              , $
                 "del_PS"                         , $
                 "keepMe"                         , $
                 "paramStrPrefix"                 , $
                 "paramStrSuffix"                 , $
                 "plotH2D_contour"                , $
                 "plotH2D__kernel_density_unmask" , $
                 "hoyDia"                         ]

  ;; except_list = ["NPLOTS", $
  ;;                "EPLOTS", $
  ;;                "ENUMFLPLOTS", $
  ;;                "PPLOTS", $
  ;;                "IONPLOTS", $
  ;;                "CHAREPLOTS", $
  ;;                "CHARIEPLOTS", $
  ;;                "AUTOSCALE_FLUXPLOTS", $
  ;;                "DO_TIMEAVG_FLUXQUANTITIES", $
  ;;                "DO_LOGAVG_THE_TIMEAVG", $
  ;;                "ESPEC__NEWELLPLOT_PROBOCCURRENCE", $
  ;;                "ESPEC__T_PROBOCCURRENCE", $
  ;;                "ORBCONTRIBPLOT", $
  ;;                "ORBTOTPLOT", $
  ;;                "ORBFREQPLOT", $
  ;;                "NEVENTPERORBPLOT", $
  ;;                "NEVENTPERMINPLOT", $
  ;;                "PROBOCCURRENCEPLOT", $
  ;;                "SQUAREPLOT", $
  ;;                "POLARCONTOUR", $
  ;;                "MEDIANPLOT", $
  ;;                "LOGAVGPLOT", $
  ;;                "PLOTMEDORAVG", $
  ;;                "WRITEASCII", $
  ;;                "WRITEHDF5", $
  ;;                "WRITEPROCESSEDH2D", $
  ;;                "SAVERAW", $
  ;;                "SHOWPLOTSNOSAVE", $
  ;;                "OUTPUTPLOTSUMMARY", $
  ;;                "DEL_PS", $
  ;;                "PLOTH2D_CONTOUR", $
  ;;                "PLOTH2D__KERNEL_DENSITY_UNMASK", $
  ;;                "THIST_MASK_BINS_BELOW_THRESH", $
  ;;                "MASKMIN", $
  ;;                "EFLUXPLOTTYPE", $
  ;;                "ENUMFLPLOTTYPE", $
  ;;                "IFLUXPLOTTYPE", $
  ;;                "CHARETYPE", $
  ;;                "DATADIR", $
  ;;                "RAWDIR", $
  ;;                "PARAMSTRPREFIX", $
  ;;                "PARAMSTRSUFFIX", $
  ;;                "HOYDIA"]

  reset = (COMPARE_STRUCT(alfDB_plot_struct1,alfDB_plot_struct2,/RECUR_A,/RECUR_B,EXCEPT=except_list)).nDiff GT 0

END
