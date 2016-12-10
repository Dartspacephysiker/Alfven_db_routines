;2016/04/13 Kristina Lynch rightly pointed out that there could have been a dayside sampling bias for FAST, and maybe that's why
;we observe strange Poynting flux distributions. I highly doubt it, but let's see.
;;This journal wants to produce a file that is the most comparable to the Keiling et al. [2003] distribution of Poynting flux (i.e.,
;one at high altitudes)
PRO JOURNAL__20160413__PLOT_NEVENTS_AND_5_OTHER_MEASURES_W_PFLUX_GE_5MW_PER_M2_AT_HIGH_ALTITUDE_FOR_COMPARISON_WITH_KEILING_ET_AL_2003

  hemi                     = 'NORTH'
  ;; hemi                     = 'SOUTH'
  
  pFluxMin                 = 5

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;2016/04/13b For alt range 4000-4175
  altRange                 = [[4000,4175]]

  probOccurrencePlot       = 1
  probOccurrenceRange      = [1e-4,1e-2]
  logProbOccurrence        = 1
  ;; probOccurrenceRange      = [0,0.05]
  ;; logProbOccurrence        = 0

  nPlots                   = 1
  nEventsPlotRange         = [0,500]
  nEventsPlotNormalize     = 0  

  nOrbsWithEventsPerContribOrbsPlot = 1
  nowepco_range            = [0,0.25]

  orbContribPlot           = 1
  orbContribRange          = [20,270]
  orbContrib_noMask        = 1

  tHistDenominatorPlot     = 1
  tHistDenomPlotRange      = [0,470]
  ;; tHistDenomPlotNormalize  = 0
  tHistDenomPlot_noMask    = 1

  nEventPerMinPlot         = 1
  ;; nEventPerMinRange        = [,20]
  ;; logNEventPerMin          = 0
  nEventPerMinRange        = [1e-2,3]
  logNEventPerMin          = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;2016/04/13a For alt range 3675-4175
  ;; altRange                 = [[3675,4175]]

  ;; nPlots                   = 1
  ;; nEventsPlotRange           = [0,730]
  ;; nEventsPlotNormalize     = 0  

  ;; tHistDenominatorPlot     = 1
  ;; tHistDenomPlotRange      = [0,900]
  ;; ;; tHistDenomPlotNormalize  = 0
  ;; tHistDenomPlot_noMask    = 1

  ;; nEventPerMinPlot         = 1
  ;; ;; nEventPerMinRange        = [,20]
  ;; ;; logNEventPerMin          = 0
  ;; nEventPerMinRange        = [1e-2,2]
  ;; logNEventPerMin          = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  tile_images              = 1
  tiling_order             = [5,0,3,1,2,4]
  n_tile_columns           = 3
  n_tile_rows              = 2
  tilePlotSuff             = "--normed_nEvents_tHistos__nEvPerMin__bothProbOccurrences__and_contribOrbs"

  ;; altRange                 = [[0,4175], $
  ;;                             [340,500], $
  ;;                             [500,1000], $
  ;;                             [1000,1500], $
  ;;                             [1500,2000], $
  ;;                             [2000,2500], $
  ;;                             [2500,3000], $
  ;;                             [3000,3500], $
  ;;                             [3500,3750], $
  ;;                             [3750,4000], $
  ;;                             [4000,4175]]

  ;; altRange                 = [[340,1175], $
  ;;                             [1175,2175], $
  ;;                             [2175,3175], $
  ;;                             [3175,4175]]

  ;; altRange                 = [[3675,4175]]

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
  maskMin                        = 1

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=do_despun

  restrict_with_these_i          = WHERE(maximus.pFluxEst GE pFluxMin)

  FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN
     altitudeRange = altRange[*,i]
     altStr        = STRING(FORMAT='("--",I0,"-",I0,"km")',altitudeRange[0],altitudeRange[1]) + '--pFlux_GE_'+STRCOMPRESS(pFluxMin,/REMOVE_ALL)
     ;; tilePlotTitle = STRING(FORMAT='(I0,"-",I0," km, Poynting flux $\geq$ ",I0," mW m!U-2!N")',altitudeRange[0],altitudeRange[1],pFluxMin)
     tilePlotTitle = STRING(FORMAT='(I0,"-",I0," km")',altitudeRange[0],altitudeRange[1])
     
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
        ORBCONTRIB_NOMASK=orbContrib_noMask, $
        NEVENTPERORBPLOT=nEventPerOrbPlot, LOGNEVENTPERORB=logNEventPerOrb, NEVENTPERORBRANGE=nEventPerOrbRange, $
        DIVNEVBYTOTAL=divNEvByTotal, $
        NEVENTPERMINPLOT=nEventPerMinPlot, $
        NEVENTPERMINRANGE=nEventPerMinRange, LOGNEVENTPERMIN=logNEventPerMin, $
        NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
        NOWEPCO_RANGE=nowepco_range, $
        PROBOCCURRENCEPLOT=probOccurrencePlot, $
        PROBOCCURRENCERANGE=probOccurrenceRange, $
        LOGPROBOCCURRENCE=logProbOccurrence, $
        THISTDENOMINATORPLOT=tHistDenominatorPlot, $
        THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
        THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
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
        CHASTDB=chastDB, $
        DO_DESPUNDB=do_despunDB, $
        NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
        NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
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

