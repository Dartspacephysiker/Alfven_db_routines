;2019/01/22
PRO JOURNAL__20190122__GET_AND_SAVE_GOOD_I

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__maximus_vars.pro

  LOAD_MAXIMUS_AND_CDBTIME

  outDir = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  outFile = 'Dartdb_20151222--500-16361_inc_lower_lats--good_inds__20190122.sav'

  ;; nonstorm                           = 1
  ;; DSTcutoff                          = -25
  ;; smooth_dst                         = 0
  ;; use_mostRecent_Dst_files           = 1

  @journal__20161202__plotpref_for_journals_with_dst_restriction.pro

  minMC                              = 1
  maxNegMC                           = -1

  ;; do_timeAvg_fluxQuantities          = 1
  ;; logAvgPlot                         = 0
  ;; medianPlot                         = 0
  ;; divide_by_width_x                  = 1
  ;; org_plots_by_folder                = 1

  dont_blackball_maximus             = 1
  dont_blackball_fastloc             = 1

  ;;DB stuff
  ;; do_despun                          = 0
  ;; use_MAG                            = 0

  ;; autoscale_fluxPlots                = 0
  ;; fluxPlots__remove_outliers         = 0
  ;; fluxPlots__remove_log_outliers     = 0

  ;; show_integrals                     = 0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Tiled plot options

  ;; reset_good_inds                = 1

  altitudeRange                  = [[300,4300]]

  orbRange                       = [500,12670]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;IMF condition stuff--run the ring!
  do_not_consider_IMF       = 1
  dont_consider_clockAngles = 1
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minI                           = 60
  maxI                           = 90

  hemi                           = 'BOTH'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff



  PLOT_ALFVEN_STATS__SETUP, $
     ;; FOR_ESPEC_DBS=for_eSpec_DBs, $
     NEED_FASTLOC_I=need_fastLoc_i, $
     ;; USE_STORM_STUFF=use_storm_stuff, $
     ;; AE_STUFF=ae_stuff, $    
     ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
     ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
     IMF_STRUCT=IMF_struct, $
     MIMC_STRUCT=MIMC_struct, $
     ORBRANGE=orbRange, $
     ALTITUDERANGE=altitudeRange, $
     ;; CHARERANGE=charERange, $
     ;; POYNTRANGE=poyntRange, $
     ;; SAMPLE_T_RESTRICTION=sample_t_restriction, $
     ;; INCLUDE_32HZ=include_32Hz, $
     ;; DISREGARD_SAMPLE_T=disregard_sample_t, $
     DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
     DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
     ;; MINMLT=minM,MAXMLT=maxM, $
     ;; BINMLT=binM, $
     ;; SHIFTMLT=shiftM, $
     MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
     ;; EQUAL_AREA_BINNING=EA_binning, $
     ;; DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
     ;; REVERSE_LSHELL=reverse_lShell, $
     MIN_MAGCURRENT=minMC, $
     MAX_NEGMAGCURRENT=maxNegMC, $
     ;; HWMAUROVAL=HwMAurOval, $
     ;; HWMKPIND=HwMKpInd, $
     ;; MASKMIN=maskMin, $
     ;; THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
     DESPUNDB=despunDB, $
     COORDINATE_SYSTEM=coordinate_system, $
     ;; USE_AACGM_COORDS=use_AACGM, $
     ;; USE_MAG_COORDS=use_MAG, $
     ;; LOAD_DELTA_ILAT_FOR_WIDTH_TIME=load_dILAT, $
     ;; LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=load_dAngle, $
     ;; LOAD_DELTA_X_FOR_WIDTH_TIME=load_dx, $
     HEMI=hemi, $
     NORTH=north, $
     SOUTH=south, $
     BOTH_HEMIS=both_hemis, $
     DAYSIDE=dayside, $
     NIGHTSIDE=nightside, $
     ;; VAROPT=varOpt, $
     ;; AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
     ;; FLUXPLOTS__REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
     ;; FLUXPLOTS__REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
     ;; FLUXPLOTS__ADD_SUSPECT_OUTLIERS=fluxPlots__add_suspect_outliers, $
     ;; FLUXPLOTS__INVERT_NEWELL_THE_CUSP=fluxPlots__invert_Newell_the_cusp, $
     ;; FLUXPLOTS__NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
     ;; FLUXPLOTS__BROADBAND_EVERYWHAR=fluxPlots__broadband_everywhar, $
     ;; FLUXPLOTS__DIFFUSE_EVERYWHAR=fluxPlots__diffuse_everywhar, $
     ;; DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
     ;; DO_LOGAVG_THE_TIMEAVG=do_logAvg_the_timeAvg, $
     ;; ORBCONTRIBPLOT=orbContribPlot, $
     ;; ORBTOTPLOT=orbTotPlot, $
     ;; ORBFREQPLOT=orbFreqPlot, $
     ;; NEVENTPERORBPLOT=nEventPerOrbPlot, $
     ;; NEVENTPERMINPLOT=nEventPerMinPlot, $
     ;; PROBOCCURRENCEPLOT=probOccurrencePlot, $
     ;; SQUAREPLOT=squarePlot, $
     ;; POLARCONTOUR=polarContour, $ 
     ;; MEDIANPLOT=medianPlot, $
     ;; LOGAVGPLOT=logAvgPlot, $
     ;; PLOTMEDORAVG=plotMedOrAvg, $
     ;; DATADIR=dataDir, $
     ;; NO_BURSTDATA=no_burstData, $
     ;; WRITEASCII=writeASCII, $
     ;; WRITEHDF5=writeHDF5, $
     ;; WRITEPROCESSEDH2D=writeProcessedH2D, $
     ;; SAVERAW=saveRaw, $
     ;; SAVEDIR=saveDir, $
     ;; JUSTDATA=justData, $
     ;; JUSTINDS_THENQUIT=justInds, $
     ;; JUSTINDS_SAVETOFILE=justInds_saveToFile, $
     ;; SHOWPLOTSNOSAVE=showPlotsNoSave, $
     ;; MEDHISTOUTDATA=medHistOutData, $
     ;; MEDHISTOUTTXT=medHistOutTxt, $
     ;; OUTPUTPLOTSUMMARY=outputPlotSummary, $
     ;; DEL_PS=del_PS, $
     KEEPME=keepMe, $
     PARAMSTRING=paramString, $
     PARAMSTRPREFIX=plotPrefix, $
     PARAMSTRSUFFIX=plotSuffix,$
     ;; PLOTH2D_CONTOUR=plotH2D_contour, $
     ;; CUSTOM_INTEGRAL_STRUCT=custom_integral_struct, $
     ;; CONTOUR__LEVELS=contour__levels, $
     ;; CONTOUR__PERCENT=contour__percent, $
     ;; PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kde, $
     HOYDIA=hoyDia, $
     LUN=lun, $
     ;; NEWELL_ANALYZE_EFLUX=Newell_analyze_eFlux, $
     ;; ESPEC__NO_MAXIMUS=no_maximus, $
     ;; ESPEC_FLUX_PLOTS=eSpec_flux_plots, $
     ;; ESPEC__JUNK_ALFVEN_CANDIDATES=eSpec__junk_alfven_candidates, $
     ;; ESPEC__ALL_FLUXES=eSpec__all_fluxes, $
     ;; ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
     ;; ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
     ;; ESPEC__NOMAPTO100KM=eSpec__noMap, $
     ;; ESPEC__REMOVE_OUTLIERS=eSpec__remove_outliers, $
     ;; ESPEC__NEWELLPLOT_PROBOCCURRENCE=eSpec__newellPlot_probOccurrence, $
     ;; ESPEC__T_PROBOCCURRENCE=eSpec__t_probOccurrence, $
     ;; NONSTORM=nonStorm, $
     ;; RECOVERYPHASE=recoveryPhase, $
     ;; MAINPHASE=mainPhase, $
     ;; ALL_STORM_PHASES=all_storm_phases, $
     ;; DSTCUTOFF=dstCutoff, $
     ;; SMOOTH_DST=smooth_dst, $
     ;; USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
     ;; USE_AE=use_ae, $
     ;; USE_AU=use_au, $
     ;; USE_AL=use_al, $
     ;; USE_AO=use_ao, $
     ;; AECUTOFF=AEcutoff, $
     ;; SMOOTH_AE=smooth_AE, $
     ;; AE_HIGH=AE_high, $
     ;; AE_LOW=AE_low, $
     ;; AE_BOTH=AE_both, $
     ;; USE_MOSTRECENT_AE_FILES=use_mostRecent_AE_files, $
     ;; CLOCKSTR=clockStrings, $
     ;; ANGLELIM1=angleLim1, $
     ;; ANGLELIM2=angleLim2, $
     ;; BYMIN=byMin, $
     ;; BYMAX=byMax, $
     ;; BZMIN=bzMin, $
     ;; BZMAX=bzMax, $
     ;; BTMIN=btMin, $
     ;; BTMAX=btMax, $
     ;; BXMIN=bxMin, $
     ;; BXMAX=bxMax, $
     ;; DO_ABS_BYMIN=abs_byMin, $
     ;; DO_ABS_BYMAX=abs_byMax, $
     ;; DO_ABS_BZMIN=abs_bzMin, $
     ;; DO_ABS_BZMAX=abs_bzMax, $
     ;; DO_ABS_BTMIN=abs_btMin, $
     ;; DO_ABS_BTMAX=abs_btMax, $
     ;; DO_ABS_BXMIN=abs_bxMin, $
     ;; DO_ABS_BXMAX=abs_bxMax, $
     ;; BX_OVER_BY_RATIO_MAX=bx_over_by_ratio_max, $
     ;; BX_OVER_BY_RATIO_MIN=bx_over_by_ratio_min, $
     ;; BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
     DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
     DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
     OMNIPARAMSTR=OMNIparamStr, $
     OMNI_PARAMSTR_LIST=OMNIparamStr_list, $
     SATELLITE=satellite, $
     OMNI_COORDS=omni_Coords, $
     ;; DELAY=delay, $
     ;; ADD_NIGHT_DELAY=add_night_delay, $
     ;; MULTIPLE_DELAYS=multiple_delays, $
     MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
     OUT_EXECUTING_MULTIPLES=executing_multiples, $
     OUT_MULTIPLES=multiples, $
     OUT_MULTISTRING=multiString, $
     ;; RESOLUTION_DELAY=delayDeltaSec, $
     ;; BINOFFSET_DELAY=binOffset_delay, $
     ;; STABLEIMF=stableIMF, $
     ;; IMF_ALLOWABLE_STREAK_DT=IMF_allowable_streak_dt, $
     ;; SMOOTHWINDOW=smoothWindow, $
     INCLUDENOCONSECDATA=includeNoConsecData, $
     EARLIEST_UTC=earliest_UTC, $
     LATEST_UTC=latest_UTC, $
     EARLIEST_JULDAY=earliest_julDay, $
     LATEST_JULDAY=latest_julDay, $
     ;; SHOW_INTEGRALS=show_integrals, $
     ;; NPLOTS=nPlots, $
     ;; EPLOTS=ePlots, $
     ;; EFLUXPLOTTYPE=eFluxPlotType, $
     ;; ENUMFLPLOTS=eNumFlPlots, $
     ;; ENUMFLPLOTTYPE=eNumFlPlotType, $
     ;; PPLOTS=pPlots, $
     ;; IONPLOTS=ionPlots, $
     ;; IFLUXPLOTTYPE=ifluxPlotType, $
     ;; CHAREPLOTS=charEPlots, $
     ;; CHARETYPE=charEType, $
     ;; CHARIEPLOTS=chariEPlots, $
     ;; MAGCPLOTS=magCPlots, $
     ;; ABSCHARE=absCharE, $
     ;; ABSCHARIE=absCharie, $
     ;; ABSEFLUX=abseflux, $
     ;; ABSENUMFL=absENumFl, $
     ;; ABSIFLUX=absIflux, $
     ;; ABSMAGC=absMagC, $
     ;; ABSOXYFLUX=absOxyFlux, $
     ;; ABSPFLUX=absPflux, $
     ;; NONEGCHARE=noNegCharE, $
     ;; NONEGCHARIE=noNegCharie, $
     ;; NONEGEFLUX=noNegEflux, $
     ;; NONEGENUMFL=noNegENumFl, $
     ;; NONEGIFLUX=noNegIflux, $
     ;; NONEGMAGC=noNegMagC, $
     ;; NONEGOXYFLUX=noNegOxyFlux, $
     ;; NONEGPFLUX=noNegPflux, $
     ;; NOPOSCHARE=noPosCharE, $
     ;; NOPOSCHARIE=noPosCharie, $
     ;; NOPOSEFLUX=noPosEFlux, $
     ;; NOPOSENUMFL=noPosENumFl, $
     ;; NOPOSIFLUX=noPosIflux, $
     ;; NOPOSMAGC=noPosMagC, $
     ;; NOPOSOXYFLUX=noPosOxyFlux, $
     ;; NOPOSPFLUX=noPosPflux, $
     ;; LOGCHAREPLOT=logCharEPlot, $
     ;; LOGCHARIEPLOT=logChariePlot, $
     ;; LOGEFPLOT=logEfPlot, $
     ;; LOGENUMFLPLOT=logENumFlPlot, $
     ;; LOGIFPLOT=logIfPlot, $
     ;; LOGMAGCPLOT=logMagCPlot, $
     ;; LOGNEVENTPERMIN=logNEventPerMin, $
     ;; LOGNEVENTPERORB=logNEventPerOrb, $
     ;; LOGNEVENTSPLOT=logNEventsPlot, $
     ;; LOGORBCONTRIBPLOT=logOrbContribPlot, $
     ;; LOGOXYFPLOT=logOxyfPlot, $
     ;; LOGPFPLOT=logPFPlot, $
     ;; LOGPROBOCCURRENCE=logProbOccurrence, $
     ;; LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
     ;; LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
     ;; LOG_NEWELLPLOT=log_newellPlot, $
     ;; LOG_NOWEPCOPLOT=log_nowepcoPlot, $
     ;; CHAREPLOTRANGE=charePlotRange, $
     ;; CHARIEPLOTRANGE=chariEPlotRange, $
     ;; EPLOTRANGE=EPlotRange, $
     ;; ENUMFLPLOTRANGE=ENumFlPlotRange, $
     ;; ESPEC__NEWELL_PLOTRANGE=eSpec__newell_plotRange, $
     ;; ESPEC__T_PROBOCC_PLOTRANGE=eSpec__t_probOcc_plotRange, $
     ;; IPLOTRANGE=IPlotRange, $
     ;; MAGCPLOTRANGE=magCPlotRange, $
     ;; NEVENTPERMINRANGE=nEventPerMinRange, $
     ;; NEVENTPERORBRANGE=nEventPerOrbRange, $
     ;; NEVENTSPLOTRANGE=nEventsPlotRange, $
     ;; NEWELL_PLOTRANGE=newell_plotRange, $
     ;; NOWEPCO_RANGE=nowepco_range, $
     ;; ORBCONTRIBRANGE=orbContribRange, $
     ;; ORBFREQRANGE=orbFreqRange, $
     ;; ORBTOTRANGE=orbTotRange, $
     ;; OXYPLOTRANGE=oxyPlotRange, $
     ;; PPLOTRANGE=PPlotRange, $
     ;; PROBOCCURRENCERANGE=probOccurrenceRange, $
     ;; THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
     RESET_STRUCT=reset

  STOP


  good_i =   GET_RESTRICTED_AND_INTERPED_DB_INDICES( $
             MAXIMUS__maximus, $
             LUN=lun, $
             DBTIMES=MAXIMUS__times, $
             DBFILE=dbfile, $
             CHARIERANGE=charIERange, $ ;Only for non-Alfvén ions
             MIMC_STRUCT=MIMC_struct, $
             ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
             IMF_STRUCT=IMF_struct, $
             RESET_OMNI_INDS=reset_omni_inds, $
             OUT_OMNI_PARAMSTR=out_omni_paramStr, $
             PRINT_AVG_IMF_COMPONENTS=print_avg_imf_components, $
             PRINT_MASTER_OMNI_FILE=print_master_OMNI_file, $
             PRINT_OMNI_COVARIANCES=print_OMNI_covariances, $
             SAVE_MASTER_OMNI_INDS=save_master_OMNI_inds, $
             MAKE_OMNI_STATS_SAVFILE=make_OMNI_stats_savFile, $
             OMNI_STATSSAVFILEPREF=OMNI_statsSavFilePref, $ 
             CALC_KL_SW_COUPLING_FUNC=calc_KL_sw_coupling_func, $
             RESET_GOOD_INDS=reset_good_inds, $
             NO_BURSTDATA=no_burstData, $
             GET_TIME_I_NOT_ALFVENDB_I=get_time_i_not_alfvendb_i, $
             FOR_ESPEC_OR_ION_DB=for_eSpec_or_ion_db, $
             FOR_SWAY_DB=for_sWay_DB, $
             RESTRICT_WITH_THESE_I=restrict_with_these_i, $
             RESTRICT_OMNI_WITH_THESE_I=restrict_OMNI_with_these_i, $
             DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
             GET_TIME_FOR_ESPEC_DBS=for_eSpec_DBs, $ ;NOTE: DON'T CONFUSE THIS WITH FOR_ESPEC_OR_ION_DB
             DONT_LOAD_IN_MEMORY=nonMem, $
             TXTOUTPUTDIR=txtOutputDir)


  good_i = good_i[0]

  PRINT,"Saving goodInds to " + outFile + ' ...'
  SAVE,good_i,FILENAME=outDir+outFile

  ;; good_i = GET_CHASTON

END
