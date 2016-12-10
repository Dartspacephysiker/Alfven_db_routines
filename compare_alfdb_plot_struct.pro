;;12/07/16
PRO COMPARE_ALFDB_PLOT_STRUCT,alfDB_plot_struct1, $
                              alfDB_plot_struct2, $
                              INDS_RESET=inds_reset

  COMPILE_OPT IDL2

  inds_reset  = 0B

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
                 "saveDir"                        , $
                 "showPlotsNoSave"                , $
                 "medHistOutData"                 , $
                 "medHistOutTxt"                  , $
                 "outputPlotSummary"              , $
                 "del_PS"                         , $
                 "keepMe"                         , $
                 "paramStrPrefix"                 , $
                 "paramStrSuffix"                 , $
                 "EA_binning"                     , $
                 "plotH2D_contour"                , $
                 "plotH2D__kernel_density_unmask" , $
                 "executing_multiples"            , $
                 "hoyDia"                         ]

  ;; dbs__except_list = [

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
  ;;                "SAVEDIR", $
  ;;                "PARAMSTRPREFIX", $
  ;;                "PARAMSTRSUFFIX", $
  ;;                "HOYDIA"]

  ;; inds_reset = (COMPARE_STRUCT(alfDB_plot_struct1,alfDB_plot_struct2,/RECUR_A,/RECUR_B,EXCEPT=except_list)).nDiff GT 0
  comp = COMPARE_STRUCT(alfDB_plot_struct1,alfDB_plot_struct2,/RECUR_A,/RECUR_B,EXCEPT=except_list)

  FOR k=0,N_ELEMENTS(comp)-1 DO BEGIN
     tmpComp  = comp[k]

     dontstop = 0
     IF tmpComp.nDiff GT 0 THEN BEGIN

        IF STRMATCH(tmpComp.field,STRUPCASE('*multiples*')) THEN BEGIN
           inds_reset     += 1
           dontstop        = 1
           tmpComp.nDiff  -= N_ELEMENTS(alfDB_plot_struct1.multiples)
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*use_mostrecent_dst*')) THEN BEGIN
           ;; inds_reset      = 0
           dontstop        = 1
           tmpComp.nDiff  -= N_ELEMENTS(alfDB_plot_struct1.multiples)
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*altituderange*')) THEN BEGIN
           inds_reset     += 1
           dontstop        = 1
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*orbrange*')) THEN BEGIN
           inds_reset     += 1
           dontstop        = 1
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*charerange*')) THEN BEGIN
           inds_reset     += 1
           dontstop        = 1
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*chare__newell_the_cusp*')) THEN BEGIN
           inds_reset     += 1
           dontstop        = 1
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*poyntrange*')) THEN BEGIN
           inds_reset     += 1
           dontstop        = 1
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*dstcutoff*')) THEN BEGIN
           inds_reset     += 1
           dontstop        = 1
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*multistring*')) THEN BEGIN
           ;; inds_reset     += 1
           dontstop        = 1
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*paramstring*')) THEN BEGIN
           ;; inds_reset     += 1
           dontstop        = 1
        ENDIF

        IF KEYWORD_SET(dontStop) THEN BEGIN
           PRINT,'Not stopping!'
        ENDIF ELSE BEGIN
           HELP,tmpComp
           PRINT,'alfDB_plot_struct1 : ',alfDB_plot_struct1.(tmpComp.tag_num_A)
           PRINT,'alfDB_plot_struct2 : ',alfDB_plot_struct2.(tmpComp.tag_num_B)
           STOP
        ENDELSE

     ENDIF

  ENDFOR


END
