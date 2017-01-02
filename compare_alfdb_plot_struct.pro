;;12/07/16
PRO COMPARE_ALFDB_PLOT_STRUCT,alfDB_plot_struct1, $
                              alfDB_plot_struct2, $
                              INDS_RESET=inds_reset, $
                              DBS_RESET=DBs_reset

  COMPILE_OPT IDL2

  inds_reset  = 0B
  DBs_reset   = 0B
  plots_reset = 0B

  except_list = ["dont_blackball_fastLoc"            , $
                 "dont_blackball_maximus"            , $
                 "for_ion_DBs"                       , $
                 "ion__downgoing"                    , $
                 "for_eSpec_DBs"                     , $
                 "eSpec__all_fluxes"                 , $
                 "eSpec__upgoing"                    , $
                 "eSpec__Newell_2009_interp"         , $
                 "disregard_sample_t"                , $
                 "maskMin"                           , $
                 "tHist_mask_bins_below_thresh"      , $
                 "nPlots"                            , $
                 "ePlots"                            , $
                 "eFluxPlotType"                     , $
                 "eNumFlPlots"                       , $
                 "eNumFlPlotType"                    , $
                 "pPlots"                            , $
                 "ionPlots"                          , $
                 "ifluxPlotType"                     , $
                 "charEPlots"                        , $
                 "charEType"                         , $
                 "chariEPlots"                       , $
                 "magCPlots"                         , $
                 "autoscale_fluxPlots"               , $
                 "do_timeAvg_fluxQuantities"         , $
                 "do_logAvg_the_timeAvg"             , $
                 "t_ProbOccurrence"                  , $
                 "orbContribPlot"                    , $
                 "orbTotPlot"                        , $
                 "orbFreqPlot"                       , $
                 "nEventPerOrbPlot"                  , $
                 "nEventPerMinPlot"                  , $
                 "probOccurrencePlot"                , $
                 "tHistDenominatorPlot"              , $
                 "nOrbsWithEventsPerContribOrbsPlot" , $
                 "squarePlot"                        , $
                 "polarContour"                      , $
                 "wholeCap"                          , $
                 "medianPlot"                        , $
                 "logAvgPlot"                        , $
                 "plotMedOrAvg"                      , $
                 "dataDir"                           , $
                 "no_burstData"                      , $
                 "writeASCII"                        , $
                 "writeHDF5"                         , $
                 "writeProcessedH2d"                 , $
                 "saveRaw"                           , $
                 "saveDir"                           , $
                 "showPlotsNoSave"                   , $
                 "medHistOutData"                    , $
                 "medHistOutTxt"                     , $
                 "outputPlotSummary"                 , $
                 "del_PS"                            , $
                 "keepMe"                            , $
                 "paramStrPrefix"                    , $
                 "paramStrSuffix"                    , $
                 "EA_binning"                        , $
                 "plotH2D_contour"                   , $
                 "plotH2D__kernel_density_unmask"    , $
                 "executing_multiples"               , $
                 "multiple_IMF_clockAngles"          , $
                 "hoyDia"                            ]

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

  IF alfDB_plot_struct1.disregard_sample_t NE alfDB_plot_struct2.disregard_sample_t THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"disregard_sample_t", $
           alfDB_plot_struct1.disregard_sample_t,alfDB_plot_struct2.disregard_sample_t
     DBs_reset += 1B
  ENDIF
  
  IF alfDB_plot_struct1.dont_blackball_maximus NE alfDB_plot_struct2.dont_blackball_maximus THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"dont_blackball_maximus", $
           alfDB_plot_struct1.dont_blackball_maximus,alfDB_plot_struct2.dont_blackball_maximus
     inds_reset += 1B
  ENDIF

  IF alfDB_plot_struct1.dont_blackball_fastLoc NE alfDB_plot_struct2.dont_blackball_fastLoc THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"dont_blackball_fastLoc", $
           alfDB_plot_struct1.dont_blackball_fastLoc,alfDB_plot_struct2.dont_blackball_fastLoc
     inds_reset += 1B
  ENDIF

  IF alfDB_plot_struct1.for_ion_DBs NE alfDB_plot_struct2.for_ion_DBs THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"for_ion_DBs", $
           alfDB_plot_struct1.for_ion_DBs,alfDB_plot_struct2.for_ion_DBs
     DBs_reset  += 1B
  ENDIF

  IF alfDB_plot_struct1.ion__downgoing NE alfDB_plot_struct2.ion__downgoing THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"ion__downgoing", $
           alfDB_plot_struct1.ion__downgoing,alfDB_plot_struct2.ion__downgoing
     inds_reset += 1B
     DBs_reset  += 1B
     plots_reset += 1B
  ENDIF

  IF alfDB_plot_struct1.for_eSpec_DBs NE alfDB_plot_struct2.for_eSpec_DBs THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"for_eSpec_DBs", $
           alfDB_plot_struct1.for_eSpec_DBs,alfDB_plot_struct2.for_eSpec_DBs
     DBs_reset  += 1B
  ENDIF

  IF alfDB_plot_struct1.eSpec__all_fluxes NE alfDB_plot_struct2.eSpec__all_fluxes THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"eSpec__all_fluxes", $
           alfDB_plot_struct1.eSpec__all_fluxes,alfDB_plot_struct2.eSpec__all_fluxes
     inds_reset += 1B
  ENDIF

  IF alfDB_plot_struct1.eSpec__upgoing NE alfDB_plot_struct2.eSpec__upgoing THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"eSpec__upgoing", $
           alfDB_plot_struct1.eSpec__upgoing,alfDB_plot_struct2.eSpec__upgoing
     inds_reset += 1B
     DBs_reset  += 1B
     plots_reset += 1B
  ENDIF

  IF alfDB_plot_struct1.eSpec__Newell_2009_interp NE alfDB_plot_struct2.eSpec__Newell_2009_interp THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"eSpec__Newell_2009_interp", $
           alfDB_plot_struct1.eSpec__Newell_2009_interp,alfDB_plot_struct2.eSpec__Newell_2009_interp
     DBs_reset  += 1B
  ENDIF

  IF alfDB_plot_struct1.despunDB NE alfDB_plot_struct2.despunDB THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"despunDB", $
           alfDB_plot_struct1.despunDB,alfDB_plot_struct2.despunDB
     DBs_reset  += 1B
  ENDIF

  IF alfDB_plot_struct1.multiple_IMF_clockAngles NE alfDB_plot_struct2.multiple_IMF_clockAngles THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"multiple_IMF_clockAngles", $
           alfDB_plot_struct1.multiple_IMF_clockAngles,alfDB_plot_struct2.multiple_IMF_clockAngles
     inds_reset  += 1B
     plots_reset += 1B
  ENDIF

  ;; inds_reset = (COMPARE_STRUCT(alfDB_plot_struct1,alfDB_plot_struct2,/RECUR_A,/RECUR_B,EXCEPT=except_list)).nDiff GT 0
  comp = COMPARE_STRUCT(alfDB_plot_struct1,alfDB_plot_struct2,/RECUR_A,/RECUR_B,EXCEPT=except_list)

  matchArr = !NULL
  FOR k=0,N_ELEMENTS(comp)-1 DO BEGIN
     tmpComp  = comp[k]

     dontstop = 0
     IF tmpComp.nDiff GT 0 THEN BEGIN

        IF STRMATCH(tmpComp.field,STRUPCASE('*multiples*')) THEN BEGIN
           inds_reset     += 1
           dontstop        = 1
           tmpComp.nDiff  -= N_ELEMENTS(alfDB_plot_struct1.multiples)
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*use_mostrecent_dst*')) THEN BEGIN
           ;; inds_reset      = 0
           dontstop        = 1
           tmpComp.nDiff  -= N_ELEMENTS(alfDB_plot_struct1.multiples)
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*altituderange*')) THEN BEGIN
           inds_reset     += 1
           dontstop        = 1
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*orbrange*')) THEN BEGIN
           inds_reset     += 1
           dontstop        = 1
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*charerange*')) THEN BEGIN
           inds_reset     += 1
           dontstop        = 1
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*chare__newell_the_cusp*')) THEN BEGIN
           inds_reset     += 1
           dontstop        = 1
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*poyntrange*')) THEN BEGIN
           inds_reset     += 1
           dontstop        = 1
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*dstcutoff*')) THEN BEGIN
           inds_reset     += 1
           dontstop        = 1
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*multistring*')) THEN BEGIN
           ;; inds_reset     += 1
           dontstop        = 1
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*paramstring*')) THEN BEGIN
           ;; inds_reset     += 1
           dontstop        = 1
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*Newell_analyze_eFlux*')) THEN BEGIN
           ;; inds_reset     += 1
           dontstop        = 1
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*use_storm_stuff*')) THEN BEGIN
           inds_reset     += 1
           dontstop        = 1
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*justData*')) THEN BEGIN
           ;; inds_reset     += 0
           dontstop        = 1
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*justInds*')) THEN BEGIN
           ;; inds_reset     += 0
           dontstop        = 1
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*include_32Hz*')) THEN BEGIN
           DBs_reset      += 1B
           inds_reset     += 1B
           dontstop        = 1
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*all_storm_phases*')) THEN BEGIN
           ;; DBs_reset      += 0B
           inds_reset     += 1B
           dontstop        = 1
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF STRMATCH(tmpComp.field,STRUPCASE('*show_integrals*')) THEN BEGIN
           ;; DBs_reset      += 0B
           ;; inds_reset     += 0B
           dontstop        = 1
           matchArr        = [matchArr,tmpComp.field]
        ENDIF

        IF KEYWORD_SET(dontStop) THEN BEGIN
           ;; PRINT,'Not stopping!'
        ENDIF ELSE BEGIN
           HELP,tmpComp
           PRINT,'alfDB_plot_struct1 : ',alfDB_plot_struct1.(tmpComp.tag_num_A)
           PRINT,'alfDB_plot_struct2 : ',alfDB_plot_struct2.(tmpComp.tag_num_B)
           STOP
        ENDELSE

     ENDIF

  ENDFOR

  IF N_ELEMENTS(matchArr) GT 0 THEN BEGIN
     PRINT,FORMAT='("PASIS diffs :",10(A0,:,", "))',matchArr
  ENDIF


END
