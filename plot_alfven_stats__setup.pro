;;12/17/16
PRO PLOT_ALFVEN_STATS__SETUP, $
   FOR_ESPEC_DBS=for_eSpec_DBs, $
   FOR_ION_DBS=for_ion_DBs, $
   FOR_SWAY_DB=for_sway_DB, $
   NEED_FASTLOC_I=need_fastLoc_i, $
   USE_STORM_STUFF=use_storm_stuff, $
   AE_STUFF=ae_stuff, $    
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
   IMF_STRUCT=IMF_struct, $
   MIMC_STRUCT=MIMC_struct, $
   ORBRANGE=orbRange, $
   ALTITUDERANGE=altitudeRange, $
   CHARERANGE=charERange, $
   POYNTRANGE=poyntRange, $
   SAMPLE_T_RESTRICTION=sample_t_restriction, $
   INCLUDE_32HZ=include_32Hz, $
   DISREGARD_SAMPLE_T=disregard_sample_t, $
   DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
   DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
   DIV_FLUXPLOTS_BY_ORBTOT=div_fluxPlots_by_orbTot, $
   DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
   MINMLT=minM,MAXMLT=maxM, $
   BINMLT=binM, $
   SHIFTMLT=shiftM, $
   MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
   EQUAL_AREA_BINNING=EA_binning, $
   DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
   REVERSE_LSHELL=reverse_lShell, $
   MIN_MAGCURRENT=minMC, $
   MAX_NEGMAGCURRENT=maxNegMC, $
   HWMAUROVAL=HwMAurOval, $
   HWMKPIND=HwMKpInd, $
   MASKMIN=maskMin, $
   THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
   DESPUNDB=despunDB, $
   COORDINATE_SYSTEM=coordinate_system, $
   ;; USE_AACGM_COORDS=use_AACGM, $
   ;; USE_GEI_COORDS=use_GEI, $
   ;; USE_GEO_COORDS=use_GEO, $
   ;; USE_MAG_COORDS=use_MAG, $
   ;; USE_SDT_COORDS=use_SDT, $
   LOAD_DELTA_ILAT_FOR_WIDTH_TIME=load_dILAT, $
   LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=load_dAngle, $
   LOAD_DELTA_X_FOR_WIDTH_TIME=load_dx, $
   HEMI=hemi, $
   NORTH=north, $
   SOUTH=south, $
   BOTH_HEMIS=both_hemis, $
   DAYSIDE=dayside, $
   NIGHTSIDE=nightside, $
   NPLOTS=nPlots, $
   EPLOTS=ePlots, $
   EFLUXPLOTTYPE=eFluxPlotType, $
   ENUMFLPLOTS=eNumFlPlots, $
   ENUMFLPLOTTYPE=eNumFlPlotType, $
   PPLOTS=pPlots, $
   IONPLOTS=ionPlots, $
   IFLUXPLOTTYPE=ifluxPlotType, $
   CHAREPLOTS=charEPlots, $
   CHARETYPE=charEType, $
   CHARIEPLOTS=chariEPlots, $
   SWAY_PLOTTYPE=sway_plotType, $
   SWAY_USE_8HZ_DB=sWay_use_8Hz_DB, $
   MAGCPLOTS=magCPlots, $
   ABSCHARE=absCharE, $
   ABSCHARIE=absCharie, $
   ABSEFLUX=abseflux, $
   ABSENUMFL=absENumFl, $
   ABSIFLUX=absIflux, $
   ABSMAGC=absMagC, $
   ABSOXYFLUX=absOxyFlux, $
   ABSPFLUX=absPflux, $
   ABS_SWAY=abs_sWay, $
   NONEGCHARE=noNegCharE, $
   NONEGCHARIE=noNegCharie, $
   NONEGEFLUX=noNegEflux, $
   NONEGENUMFL=noNegENumFl, $
   NONEGIFLUX=noNegIflux, $
   NONEGMAGC=noNegMagC, $
   NONEGOXYFLUX=noNegOxyFlux, $
   NONEGPFLUX=noNegPflux, $
   NONEG_SWAY=noNeg_sWay, $
   NOPOSCHARE=noPosCharE, $
   NOPOSCHARIE=noPosCharie, $
   NOPOSEFLUX=noPosEFlux, $
   NOPOSENUMFL=noPosENumFl, $
   NOPOSIFLUX=noPosIflux, $
   NOPOSMAGC=noPosMagC, $
   NOPOSOXYFLUX=noPosOxyFlux, $
   NOPOSPFLUX=noPosPflux, $
   NOPOS_SWAY=noPos_sWay, $
   LOGCHAREPLOT=logCharEPlot, $
   LOGCHARIEPLOT=logChariePlot, $
   LOGEFPLOT=logEfPlot, $
   LOGENUMFLPLOT=logENumFlPlot, $
   LOGIFPLOT=logIfPlot, $
   LOGMAGCPLOT=logMagCPlot, $
   LOGNEVENTPERMIN=logNEventPerMin, $
   LOGNEVENTPERORB=logNEventPerOrb, $
   LOGNEVENTSPLOT=logNEventsPlot, $
   LOGORBCONTRIBPLOT=logOrbContribPlot, $
   LOGOXYFPLOT=logOxyfPlot, $
   LOGPFPLOT=logPFPlot, $
   LOGPROBOCCURRENCE=logProbOccurrence, $
   LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
   LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
   LOG_NEWELLPLOT=log_newellPlot, $
   LOG_NOWEPCOPLOT=log_nowepcoPlot, $
   LOG_SWAYPLOT=log_swayPlot, $
   ;; CALCVAR_EFLUX=calcVar_Eflux, $
   ;; CALCVAR_ENUMFL=calcVar_ENumFl, $
   ;; CALCVAR__SWAY=calcVar__sWay, $
   ;; CALCVAR_PFLUX=calcVar_Pflux, $
   ;; CALCVAR_IFLUX=calcVar_Iflux, $
   ;; CALCVAR_OXYFLUX=calcVar_OxyFlux, $
   ;; CALCVAR_CHARE=calcVar_CharE, $
   ;; CALCVAR_CHARIE=calcVar_Charie, $
   ;; CALCVAR_MAGC=calcVar_MagC, $
   FLUXPLOTS__REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
   FLUXPLOTS__REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
   FLUXPLOTS__ADD_SUSPECT_OUTLIERS=fluxPlots__add_suspect_outliers, $
   FLUXPLOTS__INVERT_NEWELL_THE_CUSP=fluxPlots__invert_Newell_the_cusp, $
   FLUXPLOTS__NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
   FLUXPLOTS__BROADBAND_EVERYWHAR=fluxPlots__broadband_everywhar, $
   FLUXPLOTS__DIFFUSE_EVERYWHAR=fluxPlots__diffuse_everywhar, $
   DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
   DO_LOGAVG_THE_TIMEAVG=do_logAvg_the_timeAvg, $
   ORBCONTRIBPLOT=orbContribPlot, $
   ORBTOTPLOT=orbTotPlot, $
   ORBFREQPLOT=orbFreqPlot, $
   NEVENTPERORBPLOT=nEventPerOrbPlot, $
   NEVENTPERMINPLOT=nEventPerMinPlot, $
   NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
   PROBOCCURRENCEPLOT=probOccurrencePlot, $
   THISTDENOMINATORPLOT=tHistDenominatorPlot, $
   SQUAREPLOT=squarePlot, $
   POLARCONTOUR=polarContour, $ 
   MEDIANPLOT=medianPlot, $
   MAXPLOT=maxPlot, $
   MINPLOT=minPlot, $
   LOGAVGPLOT=logAvgPlot, $
   PLOTMEDORAVG=plotMedOrAvg, $
   DATADIR=dataDir, $
   NO_BURSTDATA=no_burstData, $
   WRITEASCII=writeASCII, $
   WRITEHDF5=writeHDF5, $
   WRITEPROCESSEDH2D=writeProcessedH2D, $
   SAVERAW=saveRaw, $
   SAVEDIR=saveDir, $
   JUSTDATA=justData, $
   JUSTINDS_THENQUIT=justInds, $
   JUSTINDS_SAVETOFILE=justInds_saveToFile, $
   SHOWPLOTSNOSAVE=showPlotsNoSave, $
   MEDHISTOUTDATA=medHistOutData, $
   MEDHISTOUTTXT=medHistOutTxt, $
   OUTPUTPLOTSUMMARY=outputPlotSummary, $
   DEL_PS=del_PS, $
   KEEPME=keepMe, $
   PARAMSTRING=paramString, $
   PARAMSTRPREFIX=plotPrefix, $
   PARAMSTRSUFFIX=plotSuffix,$
   PLOTH2D_CONTOUR=plotH2D_contour, $
   PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kernel_density_unmask, $
   PLOTH2D__CONT__CTINDEX=plotH2D__cont__CTIndex, $
   ;; HOYDIA=hoyDia, $
   NEWELL_ANALYZE_EFLUX=Newell_analyze_eFlux, $
   ;; NEWELL__COMB_ACCELERATED=Newell__comb_accelerated, $
   ION__NO_MAXIMUS=ion__no_maximus, $
   ION__NOMAPTO100KM=ion__noMap, $
   ION__DOWNGOING=ion__downgoing, $
   ION_FLUX_PLOTS=ion_flux_plots, $
   ION__JUNK_ALFVEN_CANDIDATES=ion__junk_alfven_candidates, $
   ION__ALL_FLUXES=ion__all_fluxes, $
   ESPEC__NO_MAXIMUS=eSpec__no_maximus, $
   ESPEC__UPGOING=eSpec__upgoing, $
   ESPEC_FLUX_PLOTS=eSpec_flux_plots, $
   ESPEC__GIGANTE_DB=eSpec__gigante_DB, $
   ESPEC__JUNK_ALFVEN_CANDIDATES=eSpec__junk_alfven_candidates, $
   ESPEC__ALL_FLUXES=eSpec__all_fluxes, $
   ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
   ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
   ESPEC__NOMAPTO100KM=eSpec__noMap, $
   ESPEC__REMOVE_OUTLIERS=eSpec__remove_outliers, $
   ESPEC__NEWELLPLOT_PROBOCCURRENCE=eSpec__newellPlot_probOccurrence, $
   ESPEC__T_PROBOCCURRENCE=eSpec__t_probOccurrence, $
   NONSTORM=nonStorm, $
   RECOVERYPHASE=recoveryPhase, $
   MAINPHASE=mainPhase, $
   ALL_STORM_PHASES=all_storm_phases, $
   DSTCUTOFF=dstCutoff, $
   SMOOTH_DST=smooth_dst, $
   TRASH_SSC_INDS=trash_ssc_inds, $
   USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
   USE_KATUS_STORM_PHASES=use_katus_storm_phases, $
   USE_AE=use_ae, $
   USE_AU=use_au, $
   USE_AL=use_al, $
   USE_AO=use_ao, $
   AECUTOFF=AEcutoff, $
   SMOOTH_AE=smooth_AE, $
   AE_HIGH=AE_high, $
   AE_LOW=AE_low, $
   AE_BOTH=AE_both, $
   USE_MOSTRECENT_AE_FILES=use_mostRecent_AE_files, $
   CLOCKSTR=clockStr, $
   ANGLELIM1=angleLim1, $
   ANGLELIM2=angleLim2, $
   THETACONEMIN=tConeMin, $
   THETACONEMAX=tConeMax, $
   BYMIN=byMin, $
   BYMAX=byMax, $
   BZMIN=bzMin, $
   BZMAX=bzMax, $
   BTMIN=btMin, $
   BTMAX=btMax, $
   BXMIN=bxMin, $
   BXMAX=bxMax, $
   DO_ABS_BYMIN=abs_byMin, $
   DO_ABS_BYMAX=abs_byMax, $
   DO_ABS_BZMIN=abs_bzMin, $
   DO_ABS_BZMAX=abs_bzMax, $
   DO_ABS_BTMIN=abs_btMin, $
   DO_ABS_BTMAX=abs_btMax, $
   DO_ABS_BXMIN=abs_bxMin, $
   DO_ABS_BXMAX=abs_bxMax, $
   DO_ABS_N2007FUNCMIN=abs_N2007FuncMin, $
   DO_ABS_N2007FUNCMAX=abs_N2007FuncMax, $
   BX_OVER_BY_RATIO_MAX=bx_over_by_ratio_max, $
   BX_OVER_BY_RATIO_MIN=bx_over_by_ratio_min, $
   BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
   N2007FUNCMIN=N2007FuncMin, $
   N2007FUNCMAX=N2007FuncMax, $
   DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
   DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
   OMNIPARAMSTR=OMNIparamStr, $
   OMNI_PARAMSTR_LIST=OMNIparamStr_list, $
   SATELLITE=satellite, $
   OMNI_COORDS=omni_Coords, $
   DELAY=delay, $
   MULTIPLE_DELAYS=multiple_delays, $
   ;; ADD_NIGHT_DELAY=add_night_delay, $
   MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
   OUT_EXECUTING_MULTIPLES=executing_multiples, $
   OUT_MULTIPLES=multiples, $
   OUT_MULTISTRING=multiString, $
   RESOLUTION_DELAY=delay_res, $
   BINOFFSET_DELAY=binOffset_delay, $
   STABLEIMF=stableIMF, $
   IMF_ALLOWABLE_STREAK_DT=IMF_allowable_streak_dt, $
   SMOOTHWINDOW=smoothWindow, $
   INCLUDENOCONSECDATA=includeNoConsecData, $
   EARLIEST_UTC=earliest_UTC, $
   LATEST_UTC=latest_UTC, $
   EARLIEST_JULDAY=earliest_julDay, $
   LATEST_JULDAY=latest_julDay, $
   NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
   NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
   AUTOSCALE_ENUMFLPLOTS=autoscale_eNumFlplots, $
   AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
   SWAYPLOT_AUTOSCALE=swayPlot_autoScale, $
   ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
   ORBCONTRIB_NOMASK=orbContrib_noMask, $
   NEVENTPERORBAUTOSCALE=nEventPerOrbAutoscale, $
   NEVENTPERMINAUTOSCALE=nEventPerMinAutoscale, $
   NOWEPCO_AUTOSCALE=nowepco_autoscale, $
   PROBOCCURRENCEAUTOSCALE=probOccurrenceAutoscale, $
   THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
   THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
   THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
   NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
   NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
   ALL_LOGPLOTS=all_logPlots,$
   CHAREPLOTRANGE=charePlotRange, $
   CHARIEPLOTRANGE=chariEPlotRange, $
   EPLOTRANGE=EPlotRange, $
   ENUMFLPLOTRANGE=ENumFlPlotRange, $
   ESPEC__NEWELL_PLOTRANGE=eSpec__newell_plotRange, $
   ESPEC__T_PROBOCC_PLOTRANGE=eSpec__t_probOcc_plotRange, $
   IPLOTRANGE=IPlotRange, $
   MAGCPLOTRANGE=magCPlotRange, $
   NEVENTPERMINRANGE=nEventPerMinRange, $
   NEVENTPERORBRANGE=nEventPerOrbRange, $
   NEVENTSPLOTRANGE=nEventsPlotRange, $
   NEWELL_PLOTRANGE=newell_plotRange, $
   NOWEPCO_RANGE=nowepco_range, $
   ORBCONTRIBRANGE=orbContribRange, $
   ORBFREQRANGE=orbFreqRange, $
   ORBTOTRANGE=orbTotRange, $
   OXYPLOTRANGE=oxyPlotRange, $
   PPLOTRANGE=PPlotRange, $
   PROBOCCURRENCERANGE=probOccurrenceRange, $
   THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
   TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
   TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
   SWAYPLOTRANGE=swayPlotRange, $
   ;; CONTOUR__LEVELS=contour__levels, $
   ;; CONTOUR__PERCENT=contour__percent, $
   ;; OVERPLOT_FILE=overplot_file, $
   ;; OVERPLOT_ARR=overplot_arr, $
   ;; OVERPLOT_CONTOUR__LEVELS=op_contour__levels, $
   ;; OVERPLOT_CONTOUR__PERCENT=op_contour__percent, $
   ;; OVERPLOT_PLOTRANGE=op_plotRange, $        
   ;; VAR__EACH_BIN=var__each_bin, $
   ;; VAR__DISTTYPE=var__distType, $
   _REF_EXTRA=e, $
   RESET_STRUCT=reset, $
   LUN=lun
   

  COMPILE_OPT IDL2,STRICTARRSUBS

  need_fastLoc_i  = KEYWORD_SET(nEventPerMinPlot) $
                    OR KEYWORD_SET(probOccurrencePlot) $
                    OR KEYWORD_SET(do_timeAvg_fluxQuantities) $
                    OR KEYWORD_SET(nEventPerOrbPlot) $
                    OR KEYWORD_SET(tHistDenominatorPlot) $
                    OR KEYWORD_SET(nOrbsWithEventsPerContribOrbsPlot) $
                    OR KEYWORD_SET(div_fluxPlots_by_applicable_orbs) $
                    OR KEYWORD_SET(tHist_mask_bins_below_thresh) $
                    OR KEYWORD_SET(numOrbLim) $
                    OR KEYWORD_SET(eSpec__t_probOccurrence)

  no_maximus      = KEYWORD_SET(eSpec__no_maximus) OR KEYWORD_SET(ion__no_maximus) OR KEYWORD_SET(no_maximus)

  for_eSpec_DBs   = (KEYWORD_SET(eSpec_flux_plots    ) $
                     OR KEYWORD_SET(eSpec__newellPlot_probOccurrence) $
                     OR KEYWORD_SET(eSpec__t_probOccurrence         ) $
                     OR KEYWORD_SET(eSpec__no_maximus               ))

  for_ion_DBs     = (KEYWORD_SET(ion_flux_plots                     ) $ 
                     OR KEYWORD_SET(ion__t_probOccurrence           ) $
                     OR KEYWORD_SET(ion__no_maximus                 ))
  
  for_sway_DB     = (KEYWORD_SET(for_sway_DB                        ) $
                     OR KEYWORD_SET(sway_plotType                   ))

  use_storm_stuff = KEYWORD_SET(nonStorm        ) + $
                    KEYWORD_SET(mainPhase       ) + $
                    KEYWORD_SET(recoveryPhase   ) + $
                    KEYWORD_SET(all_storm_phases)

  ae_stuff        = KEYWORD_SET(use_AE) + $
                    KEYWORD_SET(use_AO) + $
                    KEYWORD_SET(use_AU) + $
                    KEYWORD_SET(use_AL)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;DEFAULTS, DEFAULT STRUCTS
  SET_ALFVENDB_PLOT_DEFAULTS, $
     ORBRANGE=orbRange, $
     ALTITUDERANGE=altitudeRange, $
     CHARERANGE=charERange, $
     POYNTRANGE=poyntRange, $
     SAMPLE_T_RESTRICTION=sample_t_restriction, $
     INCLUDE_32HZ=include_32Hz, $
     DISREGARD_SAMPLE_T=disregard_sample_t, $
     DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
     DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
     DIV_FLUXPLOTS_BY_ORBTOT=div_fluxPlots_by_orbTot, $
     DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
     MINMLT=minM,MAXMLT=maxM, $
     BINMLT=binM, $
     SHIFTMLT=shiftM, $
     MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
     HEMI=hemi, $
     NORTH=north, $
     SOUTH=south, $
     BOTH_HEMIS=both_hemis, $
     DAYSIDE=dayside, $
     NIGHTSIDE=nightside, $
     EQUAL_AREA_BINNING=EA_binning, $
     DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
     REVERSE_LSHELL=reverse_lShell, $
     MIN_MAGCURRENT=minMC, $
     MAX_NEGMAGCURRENT=maxNegMC, $
     HWMAUROVAL=HwMAurOval, $
     HWMKPIND=HwMKpInd, $
     MASKMIN=maskMin, $
     THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
     DESPUNDB=despunDB, $
     COORDINATE_SYSTEM=coordinate_system, $
     USE_AACGM_COORDS=use_AACGM, $
     USE_GEI_COORDS=use_GEI, $
     USE_GEO_COORDS=use_GEO, $
     USE_MAG_COORDS=use_MAG, $
     USE_SDT_COORDS=use_SDT, $
     LOAD_DELTA_ILAT_FOR_WIDTH_TIME=load_dILAT, $
     LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=load_dAngle, $
     LOAD_DELTA_X_FOR_WIDTH_TIME=load_dx, $
     NPLOTS=nPlots, $
     EPLOTS=ePlots, $
     EFLUXPLOTTYPE=eFluxPlotType, $
     ENUMFLPLOTS=eNumFlPlots, $
     ENUMFLPLOTTYPE=eNumFlPlotType, $
     PPLOTS=pPlots, $
     IONPLOTS=ionPlots, $
     IFLUXPLOTTYPE=ifluxPlotType, $
     CHAREPLOTS=charEPlots, $
     CHARETYPE=charEType, $
     CHARIEPLOTS=chariEPlots, $
     MAGCPLOTS=magCPlots, $
     ;; AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
     FLUXPLOTS__REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
     FLUXPLOTS__REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
     FLUXPLOTS__ADD_SUSPECT_OUTLIERS=fluxPlots__add_suspect_outliers, $
     FLUXPLOTS__INVERT_NEWELL_THE_CUSP=fluxPlots__invert_Newell_the_cusp, $
     FLUXPLOTS__NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
     FLUXPLOTS__BROADBAND_EVERYWHAR=fluxPlots__broadband_everywhar, $
     FLUXPLOTS__DIFFUSE_EVERYWHAR=fluxPlots__diffuse_everywhar, $
     DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
     DO_LOGAVG_THE_TIMEAVG=do_logAvg_the_timeAvg, $
     ORBCONTRIBPLOT=orbContribPlot, $
     ORBTOTPLOT=orbTotPlot, $
     ORBFREQPLOT=orbFreqPlot, $
     NEVENTPERORBPLOT=nEventPerOrbPlot, $
     NEVENTPERMINPLOT=nEventPerMinPlot, $
     NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
     PROBOCCURRENCEPLOT=probOccurrencePlot, $
     THISTDENOMINATORPLOT=tHistDenominatorPlot, $
     SQUAREPLOT=squarePlot, $
     POLARCONTOUR=polarContour, $ 
     MEDIANPLOT=medianPlot, $
     MAXPLOT=maxPlot, $
     MINPLOT=minPlot, $
     LOGAVGPLOT=logAvgPlot, $
     PLOTMEDORAVG=plotMedOrAvg, $
     DATADIR=dataDir, $
     NO_BURSTDATA=no_burstData, $
     WRITEASCII=writeASCII, $
     WRITEHDF5=writeHDF5, $
     WRITEPROCESSEDH2D=writeProcessedH2D, $
     SAVERAW=saveRaw, $
     SAVEDIR=saveDir, $
     JUSTDATA=justData, $
     JUSTINDS_THENQUIT=justInds, $
     JUSTINDS_SAVETOFILE=justInds_saveToFile, $
     SHOWPLOTSNOSAVE=showPlotsNoSave, $
     MEDHISTOUTDATA=medHistOutData, $
     MEDHISTOUTTXT=medHistOutTxt, $
     OUTPUTPLOTSUMMARY=outputPlotSummary, $
     DEL_PS=del_PS, $
     KEEPME=keepMe, $
     PARAMSTRING=paramString, $
     PARAMSTRPREFIX=plotPrefix, $
     PARAMSTRSUFFIX=plotSuffix,$
     PLOTH2D_CONTOUR=plotH2D_contour, $
     PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kernel_density_unmask, $
     PLOTH2D__CONT__CTINDEX=plotH2D__cont__CTIndex, $
     ;; HOYDIA=hoyDia, $
     LUN=lun, $
     NEWELL_ANALYZE_EFLUX=Newell_analyze_eFlux, $
     NEWELL__COMB_ACCELERATED=Newell__comb_accelerated, $
     FOR_ION_DBS=for_ion_DBs, $
     ION__NO_MAXIMUS=ion__no_maximus, $
     ION__NOMAPTO100KM=ion__noMap, $
     ION__DOWNGOING=ion__downgoing, $
     ION_FLUX_PLOTS=ion_flux_plots, $
     ION__JUNK_ALFVEN_CANDIDATES=ion__junk_alfven_candidates, $
     ION__ALL_FLUXES=ion__all_fluxes, $
     FOR_ESPEC_DBS=for_eSpec_DBs, $
     ESPEC__NO_MAXIMUS=eSpec__no_maximus, $
     ESPEC__UPGOING=eSpec__upgoing, $
     ESPEC_FLUX_PLOTS=eSpec_flux_plots, $
     ESPEC__GIGANTE_DB=eSpec__gigante_DB, $
     ESPEC__JUNK_ALFVEN_CANDIDATES=eSpec__junk_alfven_candidates, $
     ESPEC__ALL_FLUXES=eSpec__all_fluxes, $
     ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
     ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
     ESPEC__NOMAPTO100KM=eSpec__noMap, $
     ESPEC__REMOVE_OUTLIERS=eSpec__remove_outliers, $
     ESPEC__NEWELLPLOT_PROBOCCURRENCE=eSpec__newellPlot_probOccurrence, $
     ESPEC__T_PROBOCCURRENCE=eSpec__t_probOccurrence, $
     FOR_SWAY_DB=for_sway_DB, $
     SWAY_USE_8HZ_DB=sWay_use_8Hz_DB, $
     SWAY_MAXMAGFLAG=sWay_maxMagFlag, $
     SWAY_PLOTTYPE=sway_plotType, $
     USE_STORM_STUFF=use_storm_stuff, $
     NONSTORM=nonStorm, $
     RECOVERYPHASE=recoveryPhase, $
     MAINPHASE=mainPhase, $
     ALL_STORM_PHASES=all_storm_phases, $
     DSTCUTOFF=dstCutoff, $
     SMOOTH_DST=smooth_dst, $
     TRASH_SSC_INDS=trash_ssc_inds, $
     USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
     USE_KATUS_STORM_PHASES=use_katus_storm_phases, $
     AE_STUFF=ae_stuff, $
     USE_AE=use_ae, $
     USE_AU=use_au, $
     USE_AL=use_al, $
     USE_AO=use_ao, $
     AECUTOFF=AEcutoff, $
     SMOOTH_AE=smooth_AE, $
     AE_HIGH=AE_high, $
     AE_LOW=AE_low, $
     AE_BOTH=AE_both, $
     USE_MOSTRECENT_AE_FILES=use_mostRecent_AE_files, $
     ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
     MIMC_STRUCT=MIMC_struct, $
     ;; OVERPLOT_FILE=overplot_file, $ ;;Don't touch! They'll go where they need to be to make it happen!
     ;; OVERPLOT_ARR=overplot_arr, $
     ;; OVERPLOT_CONTOUR__LEVELS=op_contour__levels, $
     ;; OVERPLOT_CONTOUR__PERCENT=op_contour__percent, $
     ;; OVERPLOT_PLOTRANGE=op_plotRange, $        
     ;; VAR__EACH_BIN=var__each_bin, $
     ;; VAR__DISTTYPE=var__distType, $
     RESET_STRUCT=reset, $
     _EXTRA=e

  SET_IMF_PARAMS_AND_IND_DEFAULTS, $
     CLOCKSTR=clockStr, $
     ANGLELIM1=angleLim1, $
     ANGLELIM2=angleLim2, $
     THETACONEMIN=tConeMin, $
     THETACONEMAX=tConeMax, $
     BYMIN=byMin, $
     BYMAX=byMax, $
     BZMIN=bzMin, $
     BZMAX=bzMax, $
     BTMIN=btMin, $
     BTMAX=btMax, $
     BXMIN=bxMin, $
     BXMAX=bxMax, $
     DO_ABS_BYMIN=abs_byMin, $
     DO_ABS_BYMAX=abs_byMax, $
     DO_ABS_BZMIN=abs_bzMin, $
     DO_ABS_BZMAX=abs_bzMax, $
     DO_ABS_BTMIN=abs_btMin, $
     DO_ABS_BTMAX=abs_btMax, $
     DO_ABS_BXMIN=abs_bxMin, $
     DO_ABS_BXMAX=abs_bxMax, $
     DO_ABS_N2007FUNCMIN=abs_N2007FuncMin, $
     DO_ABS_N2007FUNCMAX=abs_N2007FuncMax, $
     BX_OVER_BY_RATIO_MAX=bx_over_by_ratio_max, $
     BX_OVER_BY_RATIO_MIN=bx_over_by_ratio_min, $
     BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
     N2007FUNCMIN=N2007FuncMin, $
     N2007FUNCMAX=N2007FuncMax, $
     DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
     DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
     SKIP_IMF_STRING=KEYWORD_SET(use_storm_stuff) OR KEYWORD_SET(AE_STUFF), $
     OMNIPARAMSTR=OMNIparamStr, $
     OMNI_PARAMSTR_LIST=OMNIparamStr_list, $
     SATELLITE=satellite, $
     OMNI_COORDS=omni_Coords, $
     DELAY=delay, $
     MULTIPLE_DELAYS=multiple_delays, $
     ADD_NIGHT_DELAY=add_night_delay, $
     FIXED_NIGHT_DELAY=fixed_night_delay, $
     MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
     OUT_EXECUTING_MULTIPLES=executing_multiples, $
     OUT_MULTIPLES=multiples, $
     OUT_MULTISTRING=multiString, $
     RESOLUTION_DELAY=delay_res, $
     BINOFFSET_DELAY=binOffset_delay, $
     STABLEIMF=stableIMF, $
     IMF_ALLOWABLE_STREAK_DT=IMF_allowable_streak_dt, $
     SMOOTHWINDOW=smoothWindow, $
     INCLUDENOCONSECDATA=includeNoConsecData, $
     EARLIEST_UTC=earliest_UTC, $
     LATEST_UTC=latest_UTC, $
     EARLIEST_JULDAY=earliest_julDay, $
     LATEST_JULDAY=latest_julDay, $
     IMF_STRUCT=IMF_struct, $
     ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
     RESET_STRUCT=reset, $
     _EXTRA=e, $
     LUN=lun


  ;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot lims
  SET_ALFVEN_STATS_PLOT_LIMS, $
     NEVENTSPLOTRANGE=nEventsPlotRange, $
     LOGNEVENTSPLOT=logNEventsPlot, $
     NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
     NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
     EPLOTRANGE=EPlotRange, $
     LOGEFPLOT=logEfPlot, $
     ENUMFLPLOTRANGE=ENumFlPlotRange, $
     LOGENUMFLPLOT=logENumFlPlot, $
     AUTOSCALE_ENUMFLPLOTS=autoscale_eNumFlplots, $
     LOGPFPLOT=logPFPlot, $
     PPLOTRANGE=PPlotRange, $
     LOGIFPLOT=logIfPlot, $
     IPLOTRANGE=IPlotRange, $
     LOGOXYFPLOT=logOxyfPlot, $
     OXYPLOTRANGE=oxyPlotRange, $
     LOGCHAREPLOT=logCharEPlot, $
     CHAREPLOTRANGE=charePlotRange, $
     LOGCHARIEPLOT=logChariePlot, $
     CHARIEPLOTRANGE=chariEPlotRange, $
     LOGMAGCPLOT=logMagCPlot, $
     MAGCPLOTRANGE=magCPlotRange, $
     ;; CBEFDIVFAC=cbEFDivFac, $
     ;; CBENUMFLDIVFAC=cbENumFlDivFac, $
     ;; CBPFDIVFAC=CBPFDivFac, $
     ;; CBIFDIVFAC=cbIFDivFac, $
     ;; CBCHAREDIVFAC=cbCharEDivFac, $
     ;; CBMAGCDIVFAC=CBMagCDivFac, $
     ABSCHARE=absCharE, $
     ABSCHARIE=absCharie, $
     ABSEFLUX=abseflux, $
     ABSENUMFL=absENumFl, $
     ABSIFLUX=absIflux, $
     ABSMAGC=absMagC, $
     ABSOXYFLUX=absOxyFlux, $
     ABSPFLUX=absPflux, $
     ABS_SWAY=abs_sWay, $
     NONEGCHARE=noNegCharE, $
     NONEGCHARIE=noNegCharie, $
     NONEGEFLUX=noNegEflux, $
     NONEGENUMFL=noNegENumFl, $
     NONEGIFLUX=noNegIflux, $
     NONEGMAGC=noNegMagC, $
     NONEGOXYFLUX=noNegOxyFlux, $
     NONEGPFLUX=noNegPflux, $
     NONEG_SWAY=noNeg_sWay, $
     NOPOSCHARE=noPosCharE, $
     NOPOSCHARIE=noPosCharie, $
     NOPOSEFLUX=noPosEFlux, $
     NOPOSENUMFL=noPosENumFl, $
     NOPOSIFLUX=noPosIflux, $
     NOPOSMAGC=noPosMagC, $
     NOPOSOXYFLUX=noPosOxyFlux, $
     NOPOSPFLUX=noPosPflux, $
     NOPOS_SWAY=noPos_sWay, $
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
     LOG_SWAYPLOT=log_swayPlot, $
     SWAYPLOT_AUTOSCALE=swayPlot_autoScale, $
     SWAYPLOTRANGE=swayPlotRange, $
     TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
     LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
     TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
     LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
     ALL_LOGPLOTS=all_logPlots,$
     ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
     _EXTRA=e

END
