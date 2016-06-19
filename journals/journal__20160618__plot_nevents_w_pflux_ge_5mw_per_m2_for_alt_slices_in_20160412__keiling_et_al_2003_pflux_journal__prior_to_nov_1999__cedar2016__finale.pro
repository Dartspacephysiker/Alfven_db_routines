;2016/06/18 Now I've been a little more rigorous inspecting the Delta-E values, and it's evident that the E-field measurements get bad
;after Nov 3 1999, orbit 12670
PRO JOURNAL__20160618__PLOT_NEVENTS_W_PFLUX_GE_5MW_PER_M2_FOR_ALT_SLICES_IN_20160412__KEILING_ET_AL_2003_PFLUX_JOURNAL__PRIOR_TO_NOV_1999__CEDAR2016__FINALE

  pFluxMin                 = 5

  nPlots                   = 1
  ;; nEventsPlotNormalize     = 1  
  nEventsPlotAutoscale     = 1

  tHistDenominatorPlot     = 1
  ;; tHistDenomPlotNormalize  = 1
  tHistDenomPlotAutoscale  = 1
  tHistDenomPlot_noMask    = 1

  nEventPerMinPlot         = [1,1]
  nEventPerMinAutoscale    = [0,1]
  ;; nEventPerMinRange        = [1e-1,10]
  ;; logNEventPerMin          = 1
  nEventPerMinRange        = [[0,0.25], $
                              [0.0,0.0]]
  logNEventPerMin          = [0,0]

  tile_images              = 1
  tiling_order             = [3,0, $
                              1,2]
  n_tile_columns           = 2
  n_tile_rows              = 2
  ;; suppress_gridLabels      = [0,1, $
  ;;                             1,1]
  suppress_MLT_name        = [0,1, $
                              1,1]
  suppress_ILAT_name       = [0,1, $
                              1,1]
  suppress_titles          = [0,0, $
                              1,1]
  tilePlotSuff             = "--nEvents_tHistos__and_nEvPerMin--CEDAR2016"

  altRange                 = [[0,4180], $
                              [340,500], $
                              [500,1000], $
                              [1000,1500], $
                              [1500,2000], $
                              [2000,2500], $
                              [2500,3000], $
                              [3000,3500], $
                              [3500,3750], $
                              [3750,4000], $
                              [3500,4000], $
                              [3750,4000], $
                              [4000,4180]]

  ;; altRange                 = [[0,4180], $
  ;;                             [0340,0680], $
  ;;                             [0680,1180], $
  ;;                             [1180,1680], $
  ;;                             [1680,2180], $
  ;;                             [2180,2680], $
  ;;                             [2680,3180], $
  ;;                             [3180,3680], $
  ;;                             [3680,4180]]


  ;; altRange                 = [[340,1180], $
  ;;                             [1180,2180], $
  ;;                             [2180,3180], $
  ;;                             [3180,4180]]

  ;; altRange                 = [[0,4180]]

  altRange                 = [340,4180]

  ;; altRange                 = [4000,4180]

  orbRange                 = [500,12670]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minILAT                        = 62
  maxILAT                        = 86

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -86
  ;; maxILAT                        = -62

  ;; binILAT                        = 2.0
  binILAT                        = 3.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 1.0
  shiftMLT                       = 0.5

  ;;DB stuff
  do_despun                      = 1

  ;;Bonus
  maskMin                        = 1

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=do_despun

  restrict_with_these_i          = WHERE( (maximus.pFluxEst GE pFluxMin) ) ; AND $
  ;(maximus.orbit LT 11645) )

  FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN
     altitudeRange = altRange[*,i]
     altStr        = STRING(FORMAT='("--",I0,"-",I0,"_km--orbRange_",I0,"-",I0)', $
                            altitudeRange[0],altitudeRange[1], $
                            orbRange[0],orbRange[1]) + $
                            ;; 0,0) + $
                     '--'+'pFlux_GE_'+STRING(FORMAT='(G0.2)',pFluxMin)
     ;; tilePlotTitle = STRING(FORMAT='(I0,"-",I0," km, Poynting flux $\geq$ ",I0," mW m!U-2!N")',altitudeRange[0],altitudeRange[1],pFluxMin)
     ;; tilePlotTitle = STRING(FORMAT='(I0,"-",I0," km")',altitudeRange[0],altitudeRange[1])
     
     PLOT_ALFVEN_STATS_IMF_SCREENING, $
        RESTRICT_WITH_THESE_I=restrict_with_these_i, $
        ORBRANGE=orbRange, $
        ALTITUDERANGE=altitudeRange, $
        CHARERANGE=charERange, $
        POYNTRANGE=poyntRange, $
        NUMORBLIM=numOrbLim, $
        MINMLT=minMLT, $
        MAXMLT=maxMLT, $
        BINMLT=binMLT, $
        SHIFTMLT=shiftMLT, $
        MINILAT=minILAT, $
        MAXILAT=maxILAT, $
        BINILAT=binILAT, $
        HWMAUROVAL=HwMAurOval, $
        HWMKPIND=HwMKpInd, $
        ;; MIN_NEVENTS=min_nEvents, $
        MASKMIN=maskMin, $
        CLOCKSTR=clockStr, $
        DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
        ANGLELIM1=angleLim1, $
        ANGLELIM2=angleLim2, $
        BYMIN=byMin, $
        BZMIN=bzMin, $
        BYMAX=byMax, $
        BZMAX=bzMax, $
        DO_ABS_BYMIN=abs_byMin, $
        DO_ABS_BYMAX=abs_byMax, $
        DO_ABS_BZMIN=abs_bzMin, $
        DO_ABS_BZMAX=abs_bzMax, $
        SATELLITE=satellite, $
        OMNI_COORDS=omni_Coords, $
        HEMI=hemi, $
        DELAY=delay, $
        MULTIPLE_DELAYS=multiple_delays, $
        RESOLUTION_DELAY=delay_res, $
        BINOFFSET_DELAY=binOffset_delay, $
        STABLEIMF=stableIMF, $
        SMOOTHWINDOW=smoothWindow, $
        INCLUDENOCONSECDATA=includeNoConsecData, $
        /DO_NOT_CONSIDER_IMF, $
        NONSTORM=nonStorm, $
        RECOVERYPHASE=recoveryPhase, $
        MAINPHASE=mainPhase, $
        NPLOTS=nPlots, $
        EPLOTS=ePlots, $
        EPLOTRANGE=ePlotRange, $                                       
        EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
        ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, $
        ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, LOGENUMFLPLOT=logENumFlPlot, ABSENUMFL=absENumFl, $
        NONEGENUMFL=noNegENumFl, NOPOSENUMFL=noPosENumFl, ENUMFLPLOTRANGE=ENumFlPlotRange, $
        PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
        NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
        IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
        NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
        OXYPLOTS=oxyPlots, $
        OXYFLUXPLOTTYPE=oxyFluxPlotType, $
        LOGOXYFPLOT=logOxyfPlot, $
        ABSOXYFLUX=absOxyFlux, $
        NONEGOXYFLUX=noNegOxyFlux, $
        NOPOSOXYFLUX=noPosOxyFlux, $
        OXYPLOTRANGE=oxyPlotRange, $
        CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
        NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
        CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
        NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
        ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
        ORBCONTRIBRANGE=orbContribRange, ORBTOTRANGE=orbTotRange, ORBFREQRANGE=orbFreqRange, $
        NEVENTPERORBPLOT=nEventPerOrbPlot, LOGNEVENTPERORB=logNEventPerOrb, NEVENTPERORBRANGE=nEventPerOrbRange, $
        DIVNEVBYTOTAL=divNEvByTotal, $
        NEVENTPERMINPLOT=nEventPerMinPlot, $
        NEVENTPERMINRANGE=nEventPerMinRange, $
        NEVENTPERMINAUTOSCALE=nEventPerMinAutoscale, $
        LOGNEVENTPERMIN=logNEventPerMin, $
        NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
        NOWEPCO_RANGE=nowepco_range, $
        PROBOCCURRENCEPLOT=probOccurrencePlot, $
        PROBOCCURRENCERANGE=probOccurrenceRange, $
        LOGPROBOCCURRENCE=logProbOccurrence, $
        THISTDENOMINATORPLOT=tHistDenominatorPlot, $
        THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
        THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
        THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
        THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
        TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
        TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
        LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
        TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
        TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
        LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
        DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
        DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
        DIVIDE_BY_WIDTH_X=divide_by_width_x, $
        MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
        SUM_ELECTRON_AND_POYNTINGFLUX=sum_electron_and_poyntingflux, $
        MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
        ALL_LOGPLOTS=all_logPlots, $
        SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
        DBFILE=dbfile, $
        NO_BURSTDATA=no_burstData, $
        DATADIR=dataDir, $
        DO_CHASTDB=do_chastDB, $
        DO_DESPUNDB=do_despunDB, $
        NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
        NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
        NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
        WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
        SAVERAW=saveRaw, RAWDIR=rawDir, $
        JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
        PLOTDIR=plotDir, $
        PLOTPREFIX=plotPrefix, $
        PLOTSUFFIX=altStr, $
        MEDHISTOUTDATA=medHistOutData, $
        MEDHISTOUTTXT=medHistOutTxt, $
        OUTPUTPLOTSUMMARY=outputPlotSummary, $
        DEL_PS=del_PS, $
        EPS_OUTPUT=eps_output, $
        SUPPRESS_THICKGRID=suppress_thickGrid, $
        SUPPRESS_GRIDLABELS=suppress_gridLabels, $
        SUPPRESS_MLT_LABELS=suppress_MLT_labels, $
        SUPPRESS_ILAT_LABELS=suppress_ILAT_labels, $
        SUPPRESS_MLT_NAME=suppress_MLT_name, $
        SUPPRESS_ILAT_NAME=suppress_ILAT_name, $
        SUPPRESS_TITLES=suppress_titles, $
        OUT_TEMPFILE_LIST=out_tempFile_list, $
        OUT_DATANAMEARR_list=out_dataNameArr_list, $
        TILE_IMAGES=tile_images, $
        N_TILE_ROWS=n_tile_rows, $
        N_TILE_COLUMNS=n_tile_columns, $
        TILEPLOTSUFF=tilePlotSuff, $
        TILING_ORDER=tiling_order, $
        TILEPLOTTITLE=tilePlotTitle, $
        NO_COLORBAR=no_colorbar, $
        CB_FORCE_OOBHIGH=cb_force_oobHigh, $
        CB_FORCE_OOBLOW=cb_force_oobLow, $
        /MIDNIGHT, $
        FANCY_PLOTNAMES=fancy_plotNames, $
        _EXTRA = e
  
  ENDFOR
END

