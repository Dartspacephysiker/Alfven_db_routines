PRO SET_ALFVEN_STATS_PLOT_LIMS, $
   NEVENTSPLOTRANGE=nEventsPlotRange, $
   LOGNEVENTSPLOT=logNEventsPlot, $
   NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
   NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
   EPLOTRANGE=EPlotRange, $
   LOGEFPLOT=logEfPlot, $
   ENUMFLPLOTRANGE=ENumFlPlotRange, $
   LOGENUMFLPLOT=logENumFlPlot, $
   AUTOSCALE_ENUMFLPLOTS=autoscale_eNumFlplots, $
   PPLOTRANGE=PPlotRange, $
   LOGIFPLOT=logIfPlot, $
   IPLOTRANGE=IPlotRange, $
   LOGOXYFPLOT=logOxyfPlot, $
   OXYPLOTRANGE=oxyPlotRange, $
   LOGCHAREPLOT=logCharEPlot, $
   CHAREPLOTRANGE=charEPlotRange, $
   LOGCHARIEPLOT=logChariePlot, $
   CHARIEPLOTRANGE=chariEPlotRange, $
   LOGMAGCPLOT=logMagCPlot, $
   MAGCPLOTRANGE=magCPlotRange, $
   ABSCHARE=absCharE, $
   ABSCHARIE=absCharie, $
   ABSEFLUX=abseflux, $
   ABSENUMFL=absENumFl, $
   ABSIFLUX=absIflux, $
   ABSMAGC=absMagC, $
   ABSOXYFLUX=absOxyFlux, $
   ABSPFLUX=absPflux, $
   NONEGCHARE=noNegCharE, $
   NONEGCHARIE=noNegCharie, $
   NONEGEFLUX=noNegEflux, $
   NONEGENUMFL=noNegENumFl, $
   NONEGIFLUX=noNegIflux, $
   NONEGMAGC=noNegMagC, $
   NONEGOXYFLUX=noNegOxyFlux, $
   NONEGPFLUX=noNegPflux, $
   NOPOSCHARE=noPosCharE, $
   NOPOSCHARIE=noPosCharie, $
   NOPOSEFLUX=noPosEFlux, $
   NOPOSENUMFL=noPosENumFl, $
   NOPOSIFLUX=noPosIflux, $
   NOPOSMAGC=noPosMagC, $
   NOPOSOXYFLUX=noPosOxyFlux, $
   NOPOSPFLUX=noPosPflux, $
   AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
   ORBCONTRIBRANGE=orbContribRange, $
   ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
   LOGORBCONTRIBPLOT=logOrbContribPlot, $
   ORBCONTRIB_NOMASK=orbContrib_noMask, $
   ORBTOTRANGE=orbTotRange, $
   ORBFREQRANGE=orbFreqRange, $
   LOGNEVENTPERORB=logNEventPerOrb, $
   NEVENTPERORBRANGE=nEventPerOrbRange, $
   NEVENTPERORBAUTOSCALE=nEventPerOrbAutoscale, $
   NEVENTPERMINRANGE=nEventPerMinRange, $
   LOGNEVENTPERMIN=logNEventPerMin, $
   NEVENTPERMINAUTOSCALE=nEventPerMinAutoscale, $
   NOWEPCO_RANGE=nowepco_range, $
   NOWEPCO_AUTOSCALE=nowepco_autoscale, $
   LOG_NOWEPCOPLOT=log_nowepcoPlot, $
   PROBOCCURRENCEAUTOSCALE=probOccurrenceAutoscale, $
   PROBOCCURRENCERANGE=probOccurrenceRange, $
   LOGPROBOCCURRENCE=logProbOccurrence, $
   THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
   THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
   THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
   THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
   NEWELL_PLOTRANGE=newell_plotRange, $
   LOG_NEWELLPLOT=log_newellPlot, $
   NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
   NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
   ESPEC__NEWELL_PLOTRANGE=eSpec__newell_plotRange, $
   ESPEC__T_PROBOCC_PLOTRANGE=eSpec__t_probOcc_plotRange, $
   TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
   LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
   TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
   LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
   ALL_LOGPLOTS=all_logPlots,$
   ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
   _EXTRA=e, $
   RESET_STRUCT=reset

  COMPILE_OPT idl2

  ;; defENumFlPlotRange        = [1e5,1e9]

  ;; defEPlotRange             = [0.01,100]

  ;; defPPlotRange             = [1e-4,1e0]

  ;; defChariEPlotRange        = [1e-2,1e1]

  ;; defNEventPerMinRange      = [0,25]


  ;; defNEventPerOrbRange      = [0.01,7]

  ;; defProbOccurrenceRange    = [1e-4,1.0]

  ;; defTHistDenomPlotRange    = [0,60.]

  ;; defNOWEPCORange           = [0,1]

  ;; IF N_ELEMENTS(ENumFlPlotRange) EQ 0 THEN BEGIN   ;;For linear or log e- number flux plotrange

  ;;    ENumFlPlotRange = defENumFlPlotRange
  ;; ENDIF

  ;; IF N_ELEMENTS(EPlotRange) EQ 0 THEN BEGIN   ;;For linear or log e- energy Flux plotrange

  ;;    EPlotRange = defEPlotRange
  ;; ENDIF

  ;; ;;For linear or log PFlux plotrange
  ;; IF N_ELEMENTS(PPlotRange) EQ 0 THEN BEGIN

  ;;    PPlotRange=defPPlotRange
  ;; ENDIF

  ;; IF N_ELEMENTS(charEPlotRange) EQ 0 THEN BEGIN   ;;For linear or log charE plotrange
  ;;    charEPlotRange=charERange
  ;; ENDIF


  ;; IF N_ELEMENTS(chariEPlotRange) EQ 0 THEN BEGIN   ;;For linear or log charE plotrange
  ;;    chariEPlotRange=defChariEPlotRange
  ;; ENDIF

  ;; IF N_ELEMENTS(nEventPerMinRange) EQ 0 OR $
  ;;    (N_ELEMENTS(nEventPerMinRange) MOD 2) NE 0 THEN BEGIN
  ;;    nEventPerMinRange = defNEventPerMinRange
  ;; ENDIF
  
  ;; IF N_ELEMENTS(nEventPerOrbRange) EQ 0 OR N_ELEMENTS(nEventPerOrbRange) NE 2 THEN BEGIN
  ;;    nEventPerOrbRange = defNEventPerOrbRange
  ;; ENDIF
  
  ;; IF N_ELEMENTS(probOccurrenceRange) EQ 0 OR N_ELEMENTS(probOccurrenceRange) NE 2 THEN BEGIN
  ;;    probOccurrenceRange = defProbOccurrenceRange
  ;; ENDIF
  
  ;; IF N_ELEMENTS(tHistDenomPlotRange) EQ 0 OR N_ELEMENTS(tHistDenomPlotRange) NE 2 THEN BEGIN
  ;;    tHistDenomPlotRange = defTHistDenomPlotRange
  ;; ENDIF

  ;; IF N_ELEMENTS(nowepco_range) EQ 0 OR N_ELEMENTS(nowepco_range) NE 2 THEN BEGIN
  ;;    nowepco_range       = defNOWEPCORange
  ;; ENDIF

  ;; IF ARG_PRESENT(alfDB_plotLim_struct) THEN BEGIN

  defENumFlPlotRange             = [0,1e9   ]
  defEPlotRange                  = [0,1.0   ]
  defIPlotRange                  = [0,1e8   ]
  defPPlotRange                  = [0,1.0   ]
  defcharePlotRange              = [0,3e4   ]
  defchariEPlotRange             = [0,3e3   ]
  defmagCPlotRange               = [-20,20  ]
  defeSpec__newell_plotRange     = [0,1.0   ]
  defeSpec__t_probOcc_plotRange  = [0,1.0   ]
  defnEventPerMinRange           = [ 0,100  ]
  defnEventPerOrbRange           = [ 0,100  ]
  defnEventsPlotRange            = [ 0,1000 ]
  defnewell_plotRange            = [ 0,1000 ]
  defnowepco_range               = [ 0,50   ]	     
  deforbContribRange             = [0,100   ]
  deforbFreqRange		 = [0,1.0   ]
  deforbTotRange		 = [0,400   ]
  defoxyPlotRange		 = [0,1e8   ]
  defprobOccurrenceRange	 = [0,1.0   ]
  deftHistDenomPlotRange	 = [0,100   ]
  deftimeAvgd_eFluxMaxRange      = [0,1.0   ]
  deftimeAvgd_pFluxRange         = [0,1.0   ]


  deflogNEventsPlot	      = 0B
  defnEventsPlotAutoscale     = 0B
  defnEventsPlotNormalize     = 0B
  deflogEfPlot                = 0B
  deflogENumFlPlot	      = 0B
  defautoscale_eNumFlplots    = 0B
  deflogIfPlot                = 0B
  deflogOxyfPlot	      = 0B
  deflogCharEPlot	      = 0B
  deflogChariePlot	      = 0B
  deflogMagCPlot              = 0B
  defautoscale_fluxPlots      = 0B
  deforbContribAutoscale      = 0B
  deflogOrbContribPlot        = 0B
  deforbContrib_noMask        = 0B
  deflogNEventPerOrb	      = 0B
  defnEventPerOrbAutoscale    = 0B
  deflogNEventPerMin	      = 0B
  defnEventPerMinAutoscale    = 0B
  defnowepco_autoscale        = 0B
  deflog_nowepcoPlot	      = 0B
  defprobOccurrenceAutoscale  = 0B
  deflogProbOccurrence        = 0B
  deftHistDenomPlotAutoscale  = 0B
  deftHistDenomPlotNormalize  = 0B
  deftHistDenomPlot_noMask    = 0B
  deflog_newellPlot	      = 0B
  defnewellPlot_autoscale     = 0B
  defnewellPlot_normalize     = 0B
  deflogTimeAvgd_PFlux        = 0B
  deflogTimeAvgd_EFluxMax     = 0B
  defall_logPlots	      = 0B

  alfDB_plotLim_struct = { $
                         ENumFlPlotRange             : defENumFlPlotRange            , $
                         EPlotRange                  : defEPlotRange                 , $
                         IPlotRange                  : defIPlotRange                 , $
                         PPlotRange                  : defPPlotRange                 , $
                         charePlotRange              : defcharePlotRange             , $
                         chariEPlotRange	     : defchariEPlotRange            , $
                         magCPlotRange               : defMagCPlotRange              , $
                         eSpec__newell_plotRange     : defeSpec__newell_plotRange    , $   
                         eSpec__t_probOcc_plotRange  : defeSpec__t_probOcc_plotRange , $
                         nEventPerMinRange           : defnEventPerMinRange          , $
                         nEventPerOrbRange           : defnEventPerOrbRange          , $
                         nEventsPlotRange            : defnEventsPlotRange           , $
                         newell_plotRange            : defnewell_plotRange           , $
                         nowepco_range               : defnowepco_range              , $
                         orbContribRange	     : deforbContribRange            , $
                         orbFreqRange                : deforbFreqRange               , $
                         orbTotRange                 : deforbTotRange                , $
                         oxyPlotRange                : defoxyPlotRange               , $
                         probOccurrenceRange         : defprobOccurrenceRange        , $
                         tHistDenomPlotRange         : deftHistDenomPlotRange        , $
                         timeAvgd_eFluxMaxRange      : deftimeAvgd_eFluxMaxRange     , $
                         timeAvgd_pFluxRange         : deftimeAvgd_pFluxRange        , $
                         logNEventsPlot              : deflogNEventsPlot	     , $
                         nEventsPlotAutoscale        : defnEventsPlotAutoscale       , $
                         nEventsPlotNormalize        : defnEventsPlotNormalize       , $
                         logEfPlot                   : deflogEfPlot		     , $
                         logENumFlPlot               : deflogENumFlPlot              , $
                         autoscale_eNumFlplots       : defautoscale_eNumFlplots      , $
                         logIfPlot                   : deflogIfPlot		     , $
                         logOxyfPlot                 : deflogOxyfPlot                , $
                         logCharEPlot                : deflogCharEPlot               , $
                         logChariePlot               : deflogChariePlot              , $
                         logMagCPlot                 : deflogMagCPlot                , $
                         autoscale_fluxPlots         : defautoscale_fluxPlots        , $
                         orbContribAutoscale         : deforbContribAutoscale        , $
                         logOrbContribPlot           : deflogOrbContribPlot	     , $
                         orbContrib_noMask           : deforbContrib_noMask	     , $
                         logNEventPerOrb	     : deflogNEventPerOrb	     , $
                         nEventPerOrbAutoscale       : defnEventPerOrbAutoscale      , $
                         logNEventPerMin	     : deflogNEventPerMin	     , $
                         nEventPerMinAutoscale       : defnEventPerMinAutoscale      , $
                         nowepco_autoscale           : defnowepco_autoscale	     , $
                         log_nowepcoPlot	     : deflog_nowepcoPlot	     , $
                         probOccurrenceAutoscale     : defprobOccurrenceAutoscale    , $
                         logProbOccurrence           : deflogProbOccurrence	     , $
                         tHistDenomPlotAutoscale     : deftHistDenomPlotAutoscale    , $
                         tHistDenomPlotNormalize     : deftHistDenomPlotNormalize    , $
                         tHistDenomPlot_noMask       : deftHistDenomPlot_noMask      , $
                         log_newellPlot              : deflog_newellPlot	     , $
                         newellPlot_autoscale        : defnewellPlot_autoscale       , $
                         newellPlot_normalize        : defnewellPlot_normalize       , $
                         logTimeAvgd_PFlux           : deflogTimeAvgd_PFlux	     , $
                         logTimeAvgd_EFluxMax        : deflogTimeAvgd_EFluxMax       , $
                         all_logPlots                : defall_logPlots               , $ 
                         absCharE                    : 0B                            , $
                         absCharie                   : 0B                            , $
                         abseflux                    : 0B                            , $
                         absENumFl                   : 0B                            , $
                         absIflux                    : 0B                            , $
                         absMagC                    : 0B                            , $
                         absOxyFlux                  : 0B                            , $
                         absPflux                    : 0B                            , $
                         noNegCharE                  : 0B                            , $
                         noNegCharie                 : 0B                            , $
                         noNegEflux                  : 0B                            , $
                         noNegENumFl                 : 0B                            , $
                         noNegIflux                  : 0B                            , $
                         noNegMagC                  : 0B                            , $
                         noNegOxyFlux                : 0B                            , $
                         noNegPflux                  : 0B                            , $
                         noPosCharE                  : 0B                            , $
                         noPosCharie                 : 0B                            , $
                         noPosEFlux                  : 0B                            , $
                         noPosENumFl                 : 0B                            , $
                         noPosIflux                  : 0B                            , $
                         noPosMagC                  : 0B                            , $
                         noPosOxyFlux                : 0B                            , $
                         noPosPflux                  : 0B                            }

  ;; IF N_ELEMENTS(alfDB_plotLim_struct) GT 0 AND ~KEYWORD_SET(reset) THEN BEGIN
  ;;    PRINT,"Already have an alfDB_plotLim_struct! Returning ..."
  ;;    RETURN
  ;; ENDIF

  IF KEYWORD_SET(ENumFlPlotRange) THEN BEGIN
     STR_ELEMENT,AlfDB_PlotLim_Struct, $
                 'ENumFlPlotRange', $
                 ENumFlPlotRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(EPlotRange) THEN BEGIN
     STR_ELEMENT,AlfDB_PlotLim_Struct, $
                 'EPlotRange', $
                 EPlotRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(IPlotRange) THEN BEGIN
     STR_ELEMENT,AlfDB_PlotLim_Struct, $
                 'IPlotRange', $
                 IPlotRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(PPlotRange) THEN BEGIN
     STR_ELEMENT,AlfDB_PlotLim_Struct, $
                 'PPlotRange', $
                 PPlotRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(charEPlotRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'charEPlotRange', $
                 charEPlotRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(chariEPlotRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'chariEPlotRange', $
                 chariEPlotRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(magCPlotRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'magCPlotRange', $
                 magCPlotRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(eSpec__newell_plotRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'eSpec__newell_plotRange', $
                 eSpec__newell_plotRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(eSpec__t_probOcc_plotRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'eSpec__t_probOcc_plotRange', $
                 eSpec__t_probOcc_plotRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(nEventPerMinRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'nEventPerMinRange', $
                 nEventPerMinRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(nEventPerOrbRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'nEventPerOrbRange', $
                 nEventPerOrbRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(nEventsPlotRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'nEventsPlotRange', $
                 nEventsPlotRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(newell_plotRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'newell_plotRange', $
                 newell_plotRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(nowepco_range) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'nowepco_range', $
                 nowepco_range, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(orbContribRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'orbContribRange', $
                 orbContribRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(orbFreqRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'orbFreqRange', $
                 orbFreqRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(orbTotRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'orbTotRange', $
                 orbTotRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(oxyPlotRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'oxyPlotRange', $
                 oxyPlotRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(probOccurrenceRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'probOccurrenceRange', $
                 probOccurrenceRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(tHistDenomPlotRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'tHistDenomPlotRange', $
                 tHistDenomPlotRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(timeAvgd_eFluxMaxRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'timeAvgd_eFluxMaxRange', $
                 timeAvgd_eFluxMaxRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF KEYWORD_SET(timeAvgd_pFluxRange) THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'timeAvgd_pFluxRange', $
                 timeAvgd_pFluxRange, $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(logNEventsPlot) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'logNEventsPlot', $
                 BYTE(logNEventsPlot), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(nEventsPlotAutoscale) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'nEventsPlotAutoscale', $
                 BYTE(nEventsPlotAutoscale), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(nEventsPlotNormalize) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'nEventsPlotNormalize', $
                 BYTE(nEventsPlotNormalize), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(logEfPlot) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'logEfPlot', $
                 BYTE(logEfPlot), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(logENumFlPlot) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'logENumFlPlot', $
                 BYTE(logENumFlPlot), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(autoscale_eNumFlplots) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'autoscale_eNumFlplots', $
                 BYTE(autoscale_eNumFlplots), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(logIfPlot) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'logIfPlot', $
                 BYTE(logIfPlot), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(logOxyfPlot) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'logOxyfPlot', $
                 BYTE(logOxyfPlot), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(logCharEPlot) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'logCharEPlot', $
                 BYTE(logCharEPlot), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(logChariePlot) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'logChariePlot', $
                 BYTE(logChariePlot), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(logMagCPlot) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'logMagCPlot', $
                 BYTE(logMagCPlot), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(autoscale_fluxPlots) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'autoscale_fluxPlots', $
                 BYTE(autoscale_fluxPlots), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(orbContribAutoscale) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'orbContribAutoscale', $
                 BYTE(orbContribAutoscale), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(logOrbContribPlot) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'logOrbContribPlot', $
                 BYTE(logOrbContribPlot), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(orbContrib_noMask) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'orbContrib_noMask', $
                 BYTE(orbContrib_noMask), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(logNEventPerOrb) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'logNEventPerOrb', $
                 BYTE(logNEventPerOrb), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(nEventPerOrbAutoscale) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'nEventPerOrbAutoscale', $
                 BYTE(nEventPerOrbAutoscale), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(logNEventPerMin) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'logNEventPerMin', $
                 BYTE(logNEventPerMin), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(nEventPerMinAutoscale) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'nEventPerMinAutoscale', $
                 BYTE(nEventPerMinAutoscale), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(nowepco_autoscale) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'nowepco_autoscale', $
                 BYTE(nowepco_autoscale), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(log_nowepcoPlot) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'log_nowepcoPlot', $
                 BYTE(log_nowepcoPlot), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(probOccurrenceAutoscale) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'probOccurrenceAutoscale', $
                 BYTE(probOccurrenceAutoscale), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(logProbOccurrence) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'logProbOccurrence', $
                 BYTE(logProbOccurrence), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(tHistDenomPlotAutoscale) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'tHistDenomPlotAutoscale', $
                 BYTE(tHistDenomPlotAutoscale), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(tHistDenomPlotNormalize) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'tHistDenomPlotNormalize', $
                 BYTE(tHistDenomPlotNormalize), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(tHistDenomPlot_noMask) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'tHistDenomPlot_noMask', $
                 BYTE(tHistDenomPlot_noMask), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(log_newellPlot) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'log_newellPlot', $
                 BYTE(log_newellPlot), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(newellPlot_autoscale) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'newellPlot_autoscale', $
                 BYTE(newellPlot_autoscale), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(newellPlot_normalize) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'newellPlot_normalize', $
                 BYTE(newellPlot_normalize), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(logTimeAvgd_PFlux) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'logTimeAvgd_PFlux', $
                 BYTE(logTimeAvgd_PFlux), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(logTimeAvgd_EFluxMax) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'logTimeAvgd_EFluxMax', $
                 BYTE(logTimeAvgd_EFluxMax), $
                 /ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(all_logPlots) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'all_logPlots', $
                 BYTE(all_logPlots), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(absCharE) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'absCharE', $
                 BYTE(absCharE), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(absCharie) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'absCharie', $
                 BYTE(absCharie), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(abseflux) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'abseflux', $
                 BYTE(abseflux), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(absENumFl) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'absENumFl', $
                 BYTE(absENumFl), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(absIflux) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'absIflux', $
                 BYTE(absIflux), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(absMagC) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'absMagC', $
                 BYTE(absMagC), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(absOxyFlux) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'absOxyFlux', $
                 BYTE(absOxyFlux), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(absPflux) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'absPflux', $
                 BYTE(absPflux), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noNegCharE) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noNegCharE', $
                 BYTE(noNegCharE), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noNegCharie) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noNegCharie', $
                 BYTE(noNegCharie), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noNegEflux) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noNegEflux', $
                 BYTE(noNegEflux), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noNegENumFl) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noNegENumFl', $
                 BYTE(noNegENumFl), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noNegIflux) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noNegIflux', $
                 BYTE(noNegIflux), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noNegMagC) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noNegMagC', $
                 BYTE(noNegMagC), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noNegOxyFlux) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noNegOxyFlux', $
                 BYTE(noNegOxyFlux), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noNegPflux) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noNegPflux', $
                 BYTE(noNegPflux), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noPosCharE) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noPosCharE', $
                 BYTE(noPosCharE), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noPosCharie) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noPosCharie', $
                 BYTE(noPosCharie), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noPosEFlux) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noPosEFlux', $
                 BYTE(noPosEFlux), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noPosENumFl) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noPosENumFl', $
                 BYTE(noPosENumFl), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noPosIflux) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noPosIflux', $
                 BYTE(noPosIflux), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noPosMagC) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noPosMagC', $
                 BYTE(noPosMagC), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noPosOxyFlux) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noPosOxyFlux', $
                 BYTE(noPosOxyFlux), $
                 /ADD_REPLACE
  ENDIF

  IF N_ELEMENTS(noPosPflux) GT 0 THEN BEGIN
     STR_ELEMENT,alfDB_plotLim_struct, $
                 'noPosPflux', $
                 BYTE(noPosPflux), $
                 /ADD_REPLACE
  ENDIF


  
END