;+
; NAME:                           SUPERPOSE_SEA_TIMES_ALFVENDBQUANTITIES
;
; PURPOSE:                        TAKE A LIST OF SEA TIMES, SUPERPOSE THE SEA TIMES AS WELL AS THE RELEVANT DB QUANTITIES
;
; CATEGORY:
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:          TBEFOREEPOCH              : Amount of time (hours) to plot before a given DST min
;                              TAFTEREPOCH               : Amount of time (hours) to plot after a given DST min
;                              STARTDATE                 : Include seas starting with this time (in seconds since Jan 1, 1970)
;                              STOPDATE                  : Include seas up to this time (in seconds since Jan 1, 1970)
;                              SEA_CENTERTIMES_UTC       : Times (in UTC) of SEAs
;                              REMOVE_DUPES              : Remove all duplicate epochs falling within [tBeforeEpoch,tAfterEpoch]
;                              USE_SYMH                  : Use SYM-H geomagnetic index instead of DST for plots of sea epoch.
;                              NEVENTHISTS               : Create histogram of number of Alfvén events relative to sea epoch
;                              HISTOBINSIZE              : Size of histogram bins in hours
;                              NEG_AND_POS_SEPAR         : Do plots of negative and positive log numbers separately
;                              MAXIND                    : Index into maximus structure; plot corresponding quantity as a function of time
;                                                            since sea commencement (e.g., MAXIND=6 corresponds to mag current).
;                              AVG_TYPE_MAXIND           : Type of averaging to perform for events in a particular time bin.
;                                                            0: standard averaging; 1: log averaging (if /LOG_DBQUANTITY is set)
;                              RUNNING_AVG               : Length of running avg window in hours (automatically calculated for every binsize increment)
;                              LOG_DBQUANTITY            : Plot the quantity from the Alfven wave database on a log scale
;                              NO_SUPERPOSE              : Don't superpose Alfven wave DB quantities over Dst/SYM-H 
;                              NOPLOTS                   : Do not plot anything.
;                              NOMAXPLOTS                : Do not plot output from Alfven wave/Chaston DB.
;                              NEG_AND_POS_LAYOUT        : Set to array of plot layout for pos_and_neg_plots
;                              PRINT_MAXIND_SEA_STATS    : Print some pre-sea, sea-time, and recovery stats on the quantity of interest.
;                              PLOTTITLE                 : Title of superposed plot
;                              SAVEPNAME                 : Name of outputted file
;
; OUTPUTS:                     
;
; OPTIONAL OUTPUTS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:   2016/04/07 Forked from SUPERPOSE_STORMS_ALFVENDBQUANTITIES
;-
PRO SUPERPOSE_SEA_TIMES_ALFVENDBQUANTITIES, $
   TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
   STARTDATE=startDate, STOPDATE=stopDate, $
   DAYSIDE=dayside,NIGHTSIDE=nightside, $
   ;; EPOCHINDS=epochInds, $
   SEA_CENTERTIMES_UTC=sea_centerTimes_UTC, $
   REMOVE_DUPES=remove_dupes, $
   HOURS_AFT_FOR_NO_DUPES=hours_aft_for_no_dupes, $
   REVERSE_REMOVE_DUPES=remove_dupes__reverse, $
   HOURS_BEF_FOR_NO_DUPES=hours_bef_for_no_dupes, $
   USE_SYMH=use_symh,USE_AE=use_AE, $
   OMNI_QUANTITIES_TO_PLOT=OMNI_quantities_to_plot, $
   OMNI_QUANTITY_RANGES=OMNI_quantity_ranges, $
   LOG_OMNI_QUANTITIES=log_omni_quantities, $
   SMOOTHWINDOW=smoothWindow, $
   NEVENTHISTS=nEventHists, $
   HISTOBINSIZE=histoBinSize, HISTORANGE=histoRange, $
   TITLE__HISTO_PLOT=title__histo_plot, $
   XLABEL_HISTO_PLOT__SUPPRESS=xLabel_histo_plot__suppress, $
   SYMCOLOR__HISTO_PLOT=symColor__histo_plot, $
   MAKE_LEGEND__HISTO_PLOT=make_legend__histo_plot, $
   NAME__HISTO_PLOT=name__histo_plot, $
   N__HISTO_PLOTS=n__histo_plots, $
   ACCUMULATE__HISTO_PLOTS=accumulate__histo_plots, $
   PROBOCCURRENCE_SEA=probOccurrence_sea, $
   LOG_PROBOCCURRENCE=log_probOccurrence, $
   HIST_MAXIND_SEA=hist_maxInd_sea, $
   TIMEAVGD_MAXIND_SEA=timeAvgd_maxInd_sea, $
   LOG_TIMEAVGD_MAXIND=log_timeAvgd_maxInd, $
   ;; TIMEAVGD_PFLUX_SEA=timeAvgd_pFlux_sea, $
   ;; LOG_TIMEAVGD_PFLUX=log_timeAvgd_pFlux, $
   ;; TIMEAVGD_EFLUXMAX_SEA=timeAvgd_eFluxMax_sea, $
   ;; LOG_TIMEAVGD_EFLUXMAX=log_timeAvgd_eFluxMax, $
   DIVIDE_BY_WIDTH_X=divide_by_width_x, $
   MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
   ONLY_POS=only_pos, $
   ONLY_NEG=only_neg, $
   NEG_AND_POS_SEPAR=neg_and_pos_separ, $
   LAYOUT=layout, $
   POS_LAYOUT=pos_layout, $
   NEG_LAYOUT=neg_layout, $
   CUSTOM_MAXIND=custom_maxInd, $
   MAXIND=maxInd, $
   AVG_TYPE_MAXIND=avg_type_maxInd, $
   RUNNING_AVERAGE=running_average, $
   RUNNING_MEDIAN=running_median, $
   RUNNING_BIN_SPACING=running_bin_spacing, $
   RUNNING_SMOOTH_NPOINTS=running_smooth_nPoints, $
   ;; RUNNING_BIN_L_OFFSET=bin_l_offset, $
   ;; RUNNING_BIN_R_OFFSET=bin_r_offset, $
   RUNNING_BIN_OFFSET=bin_offset, $
   RUNNING_BIN_L_EDGES=bin_l_edges, $
   RUNNING_BIN_R_EDGES=bin_r_edges, $
   WINDOW_SUM=window_sum, $
   DO_TWO_PANELS=do_two_panels, $
   SECOND_PANEL__PREP_FOR_SECONDARY_AXIS=second_panel__prep_for_secondary_axis, $
   OVERPLOT_TOTAL_EPOCH_VARIATION=overplot_total_epoch_variation, $
   YRANGE_TOTALVAR=yRange_totalVar, $
   YLOGSCALE_TOTALVAR=yLogScale_totalVar, $
   TITLE__EPOCHVAR_PLOT=title__epochVar_plot, $
   NAME__EPOCHVAR_PLOT=name__epochVar_plot, $
   TOTAL_EPOCH__DO_HISTOPLOT=total_epoch__do_histoPlot, $
   SYMCOLOR__TOTAL_EPOCH_VAR=symColor__totalVar_plot, $
   SYMCOLOR__MAX_PLOT=symColor__max_plot, $
   TITLE__AVG_PLOT=title__avg_plot, $
   SYMCOLOR__AVG_PLOT=symColor__avg_plot, $
   SECONDARY_AXIS__TOTALVAR_PLOT=secondary_axis__totalVar_plot, $
   DIFFCOLOR_SECONDARY_AXIS=diffColor_secondary_axis, $
   MAKE_LEGEND__AVG_PLOT=make_legend__avg_plot, $
   MAKE_ERROR_BARS__AVG_PLOT=make_error_bars__avg_plot, $
   ERROR_BAR_NBOOT=error_bar_nBoot, $
   ERROR_BAR_CONFLIMIT=error_bar_confLimit, $
   NAME__AVG_PLOT=name__avg_plot, $
   N__AVG_PLOTS=n__avg_plots, $
   ACCUMULATE__AVG_PLOTS=accumulate__avg_plots, $
   RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
   LOG_DBQUANTITY=log_DBQuantity, $
   YLOGSCALE_MAXIND=yLogScale_maxInd, $
   XLABEL_MAXIND__SUPPRESS=xLabel_maxInd__suppress, $
   YTITLE_MAXIND=yTitle_maxInd, $
   YRANGE_MAXIND=yRange_maxInd, $
   SYMTRANSP_MAXIND=symTransp_maxInd, $
   YMINOR_MAXIND=yMinor_maxInd, $
   PRINT_MAXIND_SEA_STATS=print_maxInd_sea_stats, $
   ;; LEGEND_MAXIND__SUPPRESS=legend_maxInd__suppress, $
   BKGRND_HIST=bkgrnd_hist, BKGRND_MAXIND=bkgrnd_maxInd, $
   TBINS=tBins, $
   DBFILE=dbFile,DB_TFILE=db_tFile, $
   NO_SUPERPOSE=no_superpose, $
   WINDOW_GEOMAG=geomagWindow, $
   WINDOW_MAXIMUS=maximusWindow, $
   NOPLOTS=noPlots, $
   NOGEOMAGPLOTS=noGeomagPlots, $
   ONLY_OMNI_PLOTS=only_OMNI_plots, $
   NOMAXPLOTS=noMaxPlots, $
   NOAVGPLOTS=noAvgPlots, $
   USE_DARTDB_START_ENDDATE=use_dartdb_start_enddate, $
   DO_DESPUNDB=do_despunDB, $
   USING_HEAVIES=using_heavies, $
   SAVEFILE=saveFile, $
   OVERPLOT_HIST=overplot_hist, $
   PLOTTITLE=plotTitle, $
   SAVEPNAME=savePName, $
   SAVEPLOT=savePlot, $
   SAVEMAXPLOT=saveMaxPlot, $
   SAVEMPNAME=saveMPName, $
   DO_SCATTERPLOTS=do_scatterPlots, $
   EPOCHPLOT_COLORNAMES=epochPlot_colorNames, $
   SCATTEROUTPREFIX=scatterOutPrefix, $
   RANDOMTIMES=randomTimes, $
   MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
   DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
   BOTH_HEMIS=both_hemis, $
   NORTH=north, $
   SOUTH=south, $
   HEMI=hemi, $
   RESET_GOOD_INDS=reset_good_inds, $
   OUT_BKGRND_HIST=out_bkgrnd_hist, $
   OUT_BKGRND_MAXIND=out_bkgrnd_maxind, $
   OUT_TBINS=out_tBins, $
   OUT_MAXPLOT=out_maxPlot, $
   OUT_GEOMAG_PLOT=out_geomag_plot, $
   OUT_HISTO_PLOT=out_histo_plot, $
   OUT_AVG_PLOT=out_avg_plot, $
   EPS_OUTPUT=eps_output, $
   YEAR_AND_SEASON_MODE=year_and_season_mode, $
   PDF_OUTPUT=pdf_output
  
  
  COMPILE_OPT idl2

  dataDir='/SPENCEdata/Research/Cusp/database/'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;defaults
  SETUP_SEA_NEVENTS_DEFAULTS,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch,$
                             DAYSIDE=dayside,NIGHTSIDE=nightside, $
                             RESTRICT_CHARERANGE=restrict_charERange,RESTRICT_ALTRANGE=restrict_altRange, $
                             MAXIND=maxInd,AVG_TYPE_MAXIND=avg_type_maxInd,LOG_DBQUANTITY=log_DBQuantity, $
                             USING_HEAVIES=using_heavies, $
                             YLOGSCALE_MAXIND=yLogScale_maxInd, $
                             YTITLE_MAXIND=yTitle_maxInd, YRANGE_MAXIND=yRange_maxInd, $
                             NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                             LAYOUT=layout, $
                             POS_LAYOUT=pos_layout, $
                             NEG_LAYOUT=neg_layout, $
                             USE_SYMH=use_SYMH,USE_AE=use_AE, $
                             OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantities,USE_DATA_MINMAX=use_data_minMax, $
                             HISTOBINSIZE=histoBinSize, HISTORANGE=histoRange, $
                             PROBOCCURRENCE_SEA=probOccurrence_sea, $
                             TIMEAVGD_MAXIND_SEA=timeAvgd_maxInd_sea, $
                             ;; TIMEAVGD_PFLUX_SEA=timeAvgd_pFlux_sea, $
                             ;; TIMEAVGD_EFLUXMAX_SEA=timeAvgd_eFluxMax_sea, $
                             SAVEPNAME=savePName, $
                             SAVEMPNAME=saveMPName, $
                             SAVEFILE=saveFile,SAVESTR=saveStr, $
                             PLOTTITLE=plotTitle, $
                             NOPLOTS=noPlots, $
                             NOGEOMAGPLOTS=noGeomagPlots, $
                             ;; ONLY_OMNI_PLOTS=only_OMNI_plots, $
                             NOMAXPLOTS=noMaxPlots, $
                             NOAVGPLOTS=noAvgPlots, $
                             DO_SCATTERPLOTS=do_scatterPlots,epochPlot_colorNames=scPlot_colorList,SCATTEROUTPREFIX=scatterOutPrefix, $
                             RANDOMTIMES=randomTimes, $
                             SHOW_DATA_AVAILABILITY=show_data_availability, $
                             EPS_OUTPUT=eps_output, $
                             PDF_OUTPUT=pdf_output, $
                             LUN=lun
  @utcplot_defaults.pro

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Now restore 'em
  ;; LOAD_NOAA_AND_BRETT_DBS_AND_QI,stormStruct,DB_BRETT=stormFile,DBDIR=stormDir
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime, $
                           DB_TFILE=DB_tFile, $
                           DBDIR=DBDir, $
                           DBFILE=DBFile, $
                           DO_DESPUNDB=do_despunDB, $
                           USING_HEAVIES=using_heavies

  IF ~use_SYMH AND ~use_AE AND ~omni_Quantity AND N_ELEMENTS(OMNI_quantities_to_plot) EQ 0 THEN BEGIN
     LOAD_DST_AE_DBS,dst,ae,DST_AE_DIR=DST_AEDir,DST_AE_FILE=DST_AEFile
     do_DST = 1 
  ENDIF ELSE BEGIN
     IF N_ELEMENTS(omni_quantities_to_plot) EQ 0 THEN omni_quantities_to_plot = !NULL
     IF use_SYMH THEN omni_quantities_to_plot = [omni_quantities_to_plot,'sym_h']
     IF use_AE   THEN omni_quantities_to_plot = [omni_quantities_to_plot,'ae_index']
     do_DST = 0                 ;Use DST for plots, not SYM-H
     PRINT,'OMNI Quantity: ' + omni_quantity
  ENDELSE

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Get all seas occuring within specified date range, if an array of times hasn't been provided
  

  SETUP_SEA_TIMEARRAY_UTC,sea_timeArray_UTC,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
                          NEPOCHS=nEpochs, $
                          EPOCHINDS=epochInds, $
                          SEAFILE=seaFile, $
                          MAXIMUS=maximus, $
                          ;; SEASTRUCTURE=seaStruct, $
                          USE_DARTDB_START_ENDDATE=use_dartDB_start_endDate, $ ;DBs
                          SEATYPE=seaType, $
                          STARTDATE=startDate, $
                          STOPDATE=stopDate, $
                          SEA_CENTERTIMES_UTC=sea_centerTimes_UTC, $ ;extra info
                          CENTERTIME=centerTime, $
                          DATSTARTSTOP=datStartStop, $
                          TSTAMPS=tStamps, $
                          SEASTRING=seaString, $
                          ;; SEASTRUCT_INDS=seaStruct_inds, $ ; outs
                          RANDOMTIMES=randomTimes, $
                          SAVEFILE=saveFile,SAVESTR=saveString

  IF KEYWORD_SET(remove_dupes) THEN BEGIN
     REMOVE_EPOCH_DUPES,NEPOCHS=nEpochs, $
                        CENTERTIME=centerTime, $
                        TSTAMPS=tStamps,$
                        DATSTARTSTOP=datStartStop, $
                        HOURS_AFT_FOR_NO_DUPES=hours_aft_for_no_dupes, $
                        TAFTEREPOCH=tAfterEpoch
  ENDIF

  IF KEYWORD_SET(remove_dupes__reverse) THEN BEGIN
     REMOVE_EPOCH_DUPES__REVERSE,NEPOCHS=nEpochs, $
                                 CENTERTIME=centerTime, $
                                 TSTAMPS=tStamps,$
                                 DATSTARTSTOP=datStartStop, $
                                 HOURS_BEF_FOR_NO_DUPES=hours_bef_for_no_dupes, $
                                 TBEFOREEPOCH=tBeforeEpoch
  ENDIF

  ;**************************************************
  ;generate geomag and stuff

  IF do_DST THEN BEGIN
     quantitiesToPlot              = !NULL
     nQuantitiesToPlot             = 1
  ENDIF ELSE BEGIN
     quantitiesToPlot              = KEYWORD_SET(OMNI_quantities_to_plot) ? STRSPLIT(OMNI_quantities_to_plot,',',/EXTRACT) : !NULL
     nQuantitiesToPlot             = N_ELEMENTS(quantitiesToPlot)
  ENDELSE
                                   
  geomag_dat_list_of_lists         = LIST()
  geomag_time_list_of_lists        = LIST()
  geomag_plot_i_list_of_lists      = LIST()
  geomag_min_list                  = LIST()
  geomag_max_list                  = LIST()
  geomag_title_list                = LIST()
  FOR iQuant=0,nQuantitiesToPlot-1 DO BEGIN

     IF KEYWORD_SET(OMNI_quantities_to_plot) THEN BEGIN
        omni_quantity              = quantitiesToPlot[iQuant]
     ENDIF

     IF KEYWORD_SET(log_omni_quantities) THEN BEGIN
        CASE N_ELEMENTS(log_omni_quantities) OF
           1: BEGIN
              log_omni_quantity    = log_omni_quantities
           END
           nQuantitiesToPlot: BEGIN
              log_omni_quantity    = log_omni_quantities[iQuant]
           END
           ELSE: BEGIN
              PRINT,"Bad number of log_omni_quantities provided! Either give scalar, or vector that is size of n OMNI quantities being plotted."
              STOP
           END
        ENDCASE
     ENDIF

     IF KEYWORD_SET(omni_quantity_ranges) THEN BEGIN
        CASE N_ELEMENTS(omni_quantity_ranges) OF
           2: BEGIN
              geomag_min = omni_quantity_ranges[0]
              geomag_max = omni_quantity_ranges[1]
              yRange     = omni_quantity_ranges
           END
           nQuantitiesToPlot*2: BEGIN
              geomag_min = omni_quantity_ranges[0,iQuant]
              geomag_max = omni_quantity_ranges[1,iQuant]
              yRange     = omni_quantity_ranges[*,iQuant]
           END
           ELSE: BEGIN
              PRINT,"Bad number of omni_quantity_ranges provided! Either give two-elem array, or two-by-N that is size of N OMNI quantities being plotted."
              STOP
           END
        ENDCASE
     ENDIF

     GENERATE_GEOMAG_QUANTITIES,DATSTARTSTOP=datStartStop,NEPOCHS=nEpochs,SW_DATA=sw_data, $
                                USE_SYMH=use_SYMH,USE_AE=use_AE,DST=dst, $
                                OMNI_QUANTITY=omni_quantity,LOG_OMNI_QUANTITY=log_omni_quantity, $
                                SMOOTHWINDOW=smoothWindow, $
                                GEOMAG_PLOT_I_LIST=geomag_plot_i_list, $
                                GEOMAG_DAT_LIST=geomag_dat_list, $
                                GEOMAG_TIME_LIST=geomag_time_list, $
                                GEOMAG_MIN=geomag_min, $
                                GEOMAG_MAX=geomag_max, $
                                DO_DST=do_Dst, $
                                YRANGE=yRange, $
                                ;; /SET_YRANGE, $
                                USE_DATA_MINMAX=use_data_minMax, $
                                DATATITLE=geomagTitle
     geomag_dat_list_of_lists.add,geomag_dat_list
     geomag_time_list_of_lists.add,geomag_time_list
     geomag_plot_i_list_of_lists.add,geomag_plot_i_list
     geomag_min_list.add,geomag_min
     geomag_max_list.add,geomag_max
     geomag_title_list.add,geomagTitle
  ENDFOR


  ;; Get ranges for plots
  IF    KEYWORD_SET(nEventHists) OR (avg_type_maxInd GT 0) $
     OR KEYWORD_SET(maxInd)      OR KEYWORD_SET(probOccurrence_sea) $
     OR KEYWORD_SET(timeAvgd_maxInd_sea) $
     ;; OR KEYWORD_SET(timeAvgd_pFlux_sea) OR KEYWORD_SET(timeAvgd_eFluxMax_sea) $
  THEN BEGIN                    ;Histos of Alfvén events relative to sea epoch
     ;; ;Get nearest events in Chaston DB
     GET_EPOCH_T_AND_INDS_FOR_ALFVENDB,maximus,cdbTime,NEPOCHS=nEpochs,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
                                       CENTERTIME=centerTime, $
                                       DATSTARTSTOP=datStartStop,TSTAMPS=tStamps,GOOD_I=good_i, $
                                       NALFEPOCHS=nAlfEpochs,ALF_EPOCH_T=alf_epoch_t,ALF_EPOCH_I=alf_epoch_i, $
                                       ALF_CENTERTIME=alf_centerTime,ALF_TSTAMPS=alf_tStamps, $
                                       RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
                                       MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                       DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                       BOTH_HEMIS=both_hemis, $
                                       NORTH=north, $
                                       SOUTH=south, $
                                       HEMI=hemi, $
                                       RESET_GOOD_INDS=reset_good_inds, $
                                       DAYSIDE=dayside,NIGHTSIDE=nightside, $
                                       SAVEFILE=saveFile,SAVESTR=saveStr
     

     IF KEYWORD_SET(maxInd) THEN BEGIN
        GET_DATA_FOR_ALFVENDB_EPOCH_PLOTS,MAXIMUS=maximus,CDBTIME=cdbTime, $
                                          CUSTOM_MAXIND=custom_maxInd, $
                                          MAXIND=maxInd, $
                                          DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                                          MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                                          GOOD_I=good_i, $
                                          ALF_EPOCH_I=alf_epoch_i,ALF_IND_LIST=alf_ind_list, $
                                          MINMAXDAT=minMaxDat, NALFEPOCHS=nAlfEpochs,NEPOCHS=nEpochs, $
                                          LOG_DBQUANTITY=log_DBQuantity, $
                                          CENTERTIME=alf_centerTime, $
                                          TSTAMPS=alf_tStamps, $
                                          TAFTEREPOCH=tAfterEpoch, $
                                          TBEFOREEPOCH=tBeforeEpoch, $
                                          NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                                          ONLY_POS=only_pos, $
                                          ONLY_NEG=only_neg, $
                                          TOT_PLOT_I_POS_LIST=tot_plot_i_pos_list, $
                                          TOT_ALF_T_POS_LIST=tot_alf_t_pos_list, $
                                          TOT_ALF_Y_POS_LIST=tot_alf_y_pos_list, $
                                          TOT_PLOT_I_NEG_LIST=tot_plot_i_neg_list, $
                                          TOT_ALF_T_NEG_LIST=tot_alf_t_neg_list, $
                                          TOT_ALF_Y_NEG_LIST=tot_alf_y_neg_list, $
                                          TOT_PLOT_I_LIST=tot_plot_i_list, $
                                          TOT_ALF_T_LIST=tot_alf_t_list, $
                                          TOT_ALF_Y_LIST=tot_alf_y_list, $
                                          NEVTOT=nEvTot, $
                                          SAVEFILE=saveFile,SAVESTR=saveStr
                                          
        IF KEYWORD_SET(timeAvgd_maxInd_sea) THEN BEGIN
           ;;use maxInd = 20 here to get current width
           GET_DATA_FOR_ALFVENDB_EPOCH_PLOTS,MAXIMUS=maximus,CDBTIME=cdbTime, $
                                             MAXIND=20, $
                                             ;;Don't want to average width_time in distance
                                             ;; DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                                             GOOD_I=good_i, $
                                             ALF_EPOCH_I=alf_epoch_i,ALF_IND_LIST=alf_ind_list, $
                                             MINMAXDAT=minMaxDat, NALFEPOCHS=nAlfEpochs,NEPOCHS=nEpochs, $
                                             LOG_DBQUANTITY=log_DBQuantity, $
                                             CENTERTIME=alf_centerTime,TSTAMPS=alf_tStamps, $
                                             TAFTEREPOCH=tAfterEpoch,TBEFOREEPOCH=tBeforeEpoch, $
                                             NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                                             TOT_PLOT_I_POS_LIST=tot_plot_i_pos_list, $
                                             TOT_ALF_T_POS_LIST=tot_widthT_t_pos_list, $
                                             TOT_ALF_Y_POS_LIST=tot_widthT_y_pos_list, $
                                             TOT_PLOT_I_NEG_LIST=tot_plot_i_neg_list, $
                                             TOT_ALF_T_NEG_LIST=tot_widthT_t_neg_list, $
                                             TOT_ALF_Y_NEG_LIST=tot_widthT_y_neg_list, $
                                             TOT_PLOT_I_LIST=tot_plot_i_list, $
                                             TOT_ALF_T_LIST=tot_widthT_t_list, $
                                             TOT_ALF_Y_LIST=tot_widthT_y_list, $
                                             NEVTOT=nEvTot
        ENDIF
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(probOccurrence_sea) OR KEYWORD_SET(nEventHists) THEN BEGIN
           ;;use maxInd = 20 here to get current width
           GET_DATA_FOR_ALFVENDB_EPOCH_PLOTS,MAXIMUS=maximus, $
                                             CDBTIME=cdbTime, $
                                             MAXIND=20, $
                                             ;;Don't want to average width_time in distance
                                             ;; DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                                             GOOD_I=good_i, $
                                             ALF_EPOCH_I=alf_epoch_i,ALF_IND_LIST=alf_ind_list, $
                                             MINMAXDAT=minMaxDat, NALFEPOCHS=nAlfEpochs,NEPOCHS=nEpochs, $
                                             LOG_DBQUANTITY=log_DBQuantity, $
                                             CENTERTIME=alf_centerTime,TSTAMPS=alf_tStamps, $
                                             TAFTEREPOCH=tAfterEpoch,TBEFOREEPOCH=tBeforeEpoch, $
                                             NEG_AND_POS_SEPAR=neg_and_pos_separ, $
                                             TOT_PLOT_I_POS_LIST=tot_plot_i_pos_list, $
                                             TOT_ALF_T_POS_LIST=tot_widthT_t_pos_list, $
                                             TOT_ALF_Y_POS_LIST=tot_widthT_y_pos_list, $
                                             TOT_PLOT_I_NEG_LIST=tot_plot_i_neg_list, $
                                             TOT_ALF_T_NEG_LIST=tot_widthT_t_neg_list, $
                                             TOT_ALF_Y_NEG_LIST=tot_widthT_y_neg_list, $
                                             TOT_PLOT_I_LIST=tot_plot_i_list, $
                                             TOT_ALF_T_LIST=tot_widthT_t_list, $
                                             TOT_ALF_Y_LIST=tot_widthT_y_list, $
                                             NEVTOT=nEvTot
        ENDIF

     ENDELSE
     
     IF KEYWORD_SET(neg_and_pos_separ) THEN BEGIN
        ;;First pos
        tot_alf_t_pos = LIST_TO_1DARRAY(tot_alf_t_pos_list,/WARN,/SKIP_NEG1_ELEMENTS)
        tot_alf_y_pos = LIST_TO_1DARRAY(tot_alf_y_pos_list,/WARN,/SKIP_NEG1_ELEMENTS)
        tot_alf_t_neg = LIST_TO_1DARRAY(tot_alf_t_neg_list,/WARN,/SKIP_NEG1_ELEMENTS)
        tot_alf_y_neg = LIST_TO_1DARRAY(tot_alf_y_neg_list,/WARN,/SKIP_NEG1_ELEMENTS)

        IF N_ELEMENTS(avg_type_maxInd) GT 0 THEN histoType = avg_type_maxind

        GET_ALFVENDBQUANTITY_HISTOGRAM__EPOCH_ARRAY,tot_alf_t_pos,tot_alf_y_pos,HISTOTYPE=histoType, $
           HISTDATA=histData_pos, $
           HISTTBINS=histTBins_pos, $
           RUNNING_AVERAGE=running_average, $
           RA_T=ra_t_pos, $
           RA_Y=ra_y_pos, $
           RA_NONZERO_I=ra_nz_i_pos, $
           RA_ZERO_I=ra_z_i_pos, $
           RUNNING_BIN_SPACING=running_bin_spacing, $
           RUNNING_SMOOTH_NPOINTS=running_smooth_nPoints, $
           RUNNING_BIN_OFFSET=bin_offset, $
           ;; RUNNING_BIN_L_OFFSET=bin_l_offset, $
           ;; RUNNING_BIN_R_OFFSET=bin_r_offset, $
           RUNNING_BIN_L_EDGES=bin_l_edges, $
           RUNNING_BIN_R_EDGES=bin_r_edges, $
           NEVHISTDATA=nEvHistData_pos, $
           TAFTEREPOCH=tafterepoch,TBEFOREEPOCH=tBeforeEpoch, $
           HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot_pos, $
           NONZERO_I=nz_i_pos
        ;;Now neg
        GET_ALFVENDBQUANTITY_HISTOGRAM__EPOCH_ARRAY,tot_alf_t_neg,tot_alf_y_neg,HISTOTYPE=histoType, $
           HISTDATA=histData_neg, $
           HISTTBINS=histTBins_neg, $
           RUNNING_AVERAGE=running_average, $
           RA_T=ra_t_neg, $
           RA_Y=ra_y_neg, $
           RA_NONZERO_I=ra_nz_i_neg, $
           RA_ZERO_I=ra_z_i_neg, $
           RUNNING_BIN_SPACING=running_bin_spacing, $
           RUNNING_SMOOTH_NPOINTS=running_smooth_nPoints, $
           RUNNING_BIN_OFFSET=bin_offset, $
           ;; RUNNING_BIN_L_OFFSET=bin_l_offset, $
           ;; RUNNING_BIN_R_OFFSET=bin_r_offset, $
           RUNNING_BIN_L_EDGES=bin_l_edges, $
           RUNNING_BIN_R_EDGES=bin_r_edges, $
           NEVHISTDATA=nEvHistData_neg, $
           TAFTEREPOCH=tafterepoch,TBEFOREEPOCH=tBeforeEpoch, $
           HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot_neg, $
           NONZERO_I=nz_i_neg
     ENDIF ELSE BEGIN
        CASE 1 OF
           KEYWORD_SET(probOccurrence_sea): BEGIN
              PRINT,'Prob Occurrence SEA ...'
              tot_alf_t = LIST_TO_1DARRAY(tot_widthT_t_list,/WARN,/SKIP_NEG1_ELEMENTS)
              tot_alf_y = LIST_TO_1DARRAY(tot_widthT_y_list,/WARN,/SKIP_NEG1_ELEMENTS)
           END
           KEYWORD_SET(nEventHists): BEGIN
              PRINT,'N Events SEA ...'
              tot_alf_t = LIST_TO_1DARRAY(tot_widthT_t_list,/WARN,/SKIP_NEG1_ELEMENTS)
              tot_alf_y = LIST_TO_1DARRAY(tot_widthT_y_list,/WARN,/SKIP_NEG1_ELEMENTS)
           END
           KEYWORD_SET(timeAvgd_maxInd_sea): BEGIN
              PRINT,'Doing time-averaged maxInd SEA ...'
              tot_alf_t = LIST_TO_1DARRAY(tot_alf_t_list,/WARN,/SKIP_NEG1_ELEMENTS)
              tot_alf_y = LIST_TO_1DARRAY(tot_alf_y_list,/WARN,/SKIP_NEG1_ELEMENTS)
              
              tot_widthT_t = LIST_TO_1DARRAY(tot_widthT_t_list,/WARN,/SKIP_NEG1_ELEMENTS)
              tot_widthT_y = LIST_TO_1DARRAY(tot_widthT_y_list,/WARN,/SKIP_NEG1_ELEMENTS)
              
              IF ARRAY_EQUAL(tot_widthT_t,tot_alf_t) THEN BEGIN
                 tot_alf_y = tot_widthT_y*tot_alf_y
              ENDIF ELSE BEGIN
                 PRINT,"maxInd time array isn't the same as width_data array! Better check it out..."
                 STOP
              ENDELSE
           END
           ELSE: BEGIN
              tot_alf_t = LIST_TO_1DARRAY(tot_alf_t_list,/WARN,/SKIP_NEG1_ELEMENTS)
              tot_alf_y = LIST_TO_1DARRAY(tot_alf_y_list,/WARN,/SKIP_NEG1_ELEMENTS)
           END
        ENDCASE

        IF N_ELEMENTS(avg_type_maxInd) GT 0 THEN BEGIN
           IF KEYWORD_SET(window_sum) THEN BEGIN
              histoType = 0
           ENDIF ELSE BEGIN
              histoType = avg_type_maxind
           ENDELSE
        ENDIF

        GET_ALFVENDBQUANTITY_HISTOGRAM__EPOCH_ARRAY,tot_alf_t,tot_alf_y, $
           HISTOTYPE=histoType, $
           HISTDATA=histData, $
           HISTTBINS=histTBins, $
           RUNNING_AVERAGE=running_average, $
           RA_T=ra_t, $
           RA_Y=ra_y, $
           RA_NONZERO_I=ra_nz_i, $
           RA_ZERO_I=ra_z_i, $
           RUNNING_MEDIAN=running_median, $
           RM_T=rm_t, $
           RM_Y=rm_y, $
           RM_NONZERO_I=rm_nz_i, $
           RM_ZERO_I=rm_z_i, $
           RUNNING_BIN_SPACING=running_bin_spacing, $
           RUNNING_SMOOTH_NPOINTS=running_smooth_nPoints, $
           RUNNING_BIN_OFFSET=bin_offset, $
           ;; RUNNING_BIN_L_OFFSET=bin_l_offset, $
           ;; RUNNING_BIN_R_OFFSET=bin_r_offset, $
           RUNNING_BIN_L_EDGES=bin_l_edges, $
           RUNNING_BIN_R_EDGES=bin_r_edges, $
           WINDOW_SUM=window_sum, $
           MAKE_ERROR_BARS=make_error_bars__avg_plot, $
           ERROR_BAR_NBOOT=error_bar_nBoot, $
           ERROR_BAR_CONFLIMIT=error_bar_confLimit, $
           OUT_ERROR_BARS=out_error_bars, $
           NEVHISTDATA=nEvHistData, $
           TAFTEREPOCH=tafterepoch,TBEFOREEPOCH=tBeforeEpoch, $
           HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot, $
           NONZERO_I=nz_i, $
           PRINT_MAXIND_SEA_STATS=print_maxInd_sea_stats, $
           LUN=lun

        IF KEYWORD_SET(probOccurrence_sea) OR KEYWORD_SET(timeAvgd_maxInd_sea) $
           ;; OR KEYWORD_SET(timeAvgd_pFlux_sea) OR KEYWORD_SET(timeAvgd_eFluxMax_sea)  $
        THEN BEGIN

           GET_FASTLOC_HISTOGRAM__EPOCH_ARRAY, $
              T1_ARR=datStartStop[*,0], $
              T2_ARR=datStartStop[*,1], $
              CENTERTIME=centerTime, $
              RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
              MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
              DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
              ;; BOTH_HEMIS=both_hemis, $
              ;; NORTH=north, $
              ;; SOUTH=south, $
              HEMI=hemi, $      ;'BOTH', $
              RESET_GOOD_INDS=reset_good_inds, $
              NEPOCHS=nEpochs, $
              OUTINDSPREFIX=savePlotMaxName, $
              HISTDATA=fastLocHistData, $
              HISTTBINS=fastLocBins, $
              NEVHISTDATA=fastLoc_nEvHistData, $
              TAFTEREPOCH=tAfterEpoch,TBEFOREEPOCH=tBeforeEpoch, $
              HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot_fastLocHist, $
              WINDOW_SUM=window_sum, $
              RUNNING_BIN_SPACING=running_bin_spacing, $
              RUNNING_BIN_OFFSET=bin_offset, $
              ;; RUNNING_BIN_L_OFFSET=bin_l_offset, $
              ;; RUNNING_BIN_R_OFFSET=bin_r_offset, $
              FASTLOC_I_LIST=fastLoc_i_list,FASTLOC_T_LIST=fastLoc_t_list,FASTLOC_DT_LIST=fastLoc_dt_list, $
              NONZERO_I=nz_i_fastLoc, $
              PRINT_MAXIND_SEA_STATS=print_maxInd_sea_stats, $
              LUN=lun
           ;; FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_times,FASTLOC_DELTA_T=fastLoc_delta_t
           
           IF N_ELEMENTS(nz_i_fastLoc) LT N_ELEMENTS(nz_i) THEN BEGIN
              PRINT,"How does the ephemeris have fewer histo bins than actual data?"
              STOP
           ENDIF
           nz_i_po = CGSETINTERSECTION(nz_i,nz_i_fastLoc)
           histData[nz_i_po] = histData[nz_i_po]/fastLocHistData[nz_i_po]
           IF KEYWORD_SET(running_smooth_nPoints) AND KEYWORD_SET(window_sum) THEN BEGIN
              histData       = SMOOTH(histData,running_smooth_nPoints,/EDGpE_TRUNCATE)
              
           ENDIF 
        ENDIF


        IF KEYWORD_SET(overplot_total_epoch_variation) THEN BEGIN

           GET_FASTLOC_HISTOGRAM__EPOCH_ARRAY, $
              T1_ARR=datStartStop[*,0], $
              T2_ARR=datStartStop[*,1], $
              CENTERTIME=centerTime, $
              RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
              MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
              DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
              ;; BOTH_HEMIS=both_hemis, $
              ;; NORTH=north, $
              ;; SOUTH=south, $
              HEMI=hemi, $;'BOTH', $
              RESET_GOOD_INDS=reset_good_inds, $
              NEPOCHS=nEpochs, $
              OUTINDSPREFIX=savePlotMaxName, $
              HISTDATA=fastLocHistData, $
              HISTTBINS=fastLocBins, $
              NEVHISTDATA=fastLoc_nEvHistData, $
              TAFTEREPOCH=tAfterEpoch,TBEFOREEPOCH=tBeforeEpoch, $
              HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot_fastLocHist, $
              FASTLOC_I_LIST=fastLoc_i_list,FASTLOC_T_LIST=fastLoc_t_list,FASTLOC_DT_LIST=fastLoc_dt_list, $
              NONZERO_I=nz_i_fastLoc, $
              PRINT_MAXIND_SEA_STATS=print_maxInd_sea_stats, $
              LUN=lun
              ;; FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_times,FASTLOC_DELTA_T=fastLoc_delta_t
           

           PRINT,'Getting sums of measurements in each bin for total epoch variation ...'
           ;; Just get the sum of measurements in each bin; histoType = 0 to make this happen
           total_epoch_histoType = 0
           GET_ALFVENDBQUANTITY_HISTOGRAM__EPOCH_ARRAY,tot_alf_t,tot_alf_y, $
              HISTOTYPE=total_epoch_histoType, $
              HISTDATA=total_epoch_histData, $
              HISTTBINS=total_epoch_histTBins, $
              TAFTEREPOCH=tafterepoch,TBEFOREEPOCH=tBeforeEpoch, $
              HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot, $
              NONZERO_I=nz_i_totalEpoch, $
              PRINT_MAXIND_SEA_STATS=print_maxInd_sea_stats, $
              LUN=lun

           
           IF N_ELEMENTS(nz_i_fastLoc) LT N_ELEMENTS(nz_i_totalEpoch) THEN BEGIN
              PRINT,"How does the ephemeris have fewer histo bins than totalVar data?"
              STOP
           ENDIF
              nz_i_totalEpoch_po = CGSETINTERSECTION(nz_i_totalEpoch,nz_i_fastLoc)
              total_epoch_histData[nz_i_totalEpoch_po] = total_epoch_histData[nz_i_totalEpoch_po]/fastLocHistData[nz_i_totalEpoch_po] 
              total_epoch_histData = total_epoch_histData*(histoBinsize*3600.)/fastLocHistData
        ENDIF
     ENDELSE
  ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;now the plots
  xTitle=KEYWORD_SET(xTitle) ? xTitle : 'Hours since epoch'
  xRange=[-tBeforeEpoch,tAfterEpoch]

  ;; Need a window?
  IF KEYWORD_SET(savePlot) OR KEYWORD_SET(nEventHists) OR KEYWORD_SET(only_OMNI_plots) $
     OR KEYWORD_SET(probOccurrence_sea) OR KEYWORD_SET(timeAvgd_maxInd_sea) $
     OR KEYWORD_SET(hist_maxInd_sea) $
     ;; OR KEYWORD_SET(timeAvgd_pFlux_sea) OR KEYWORD_SET(timeAvgd_eFluxMax_sea) $
     AND ~KEYWORD_SET(noPlots) AND ~KEYWORD_SET(noGeomagPlots) THEN BEGIN
     IF N_ELEMENTS(geomagWindow) EQ 0 THEN BEGIN
        makeGeomag          = 1
     ENDIF ELSE BEGIN
        IF ISA(geomagWindow) THEN BEGIN
           makeGeomag       = 0
        ENDIF ELSE BEGIN
           makeGeomag       = 1
        ENDELSE
     ENDELSE

     IF makeGeomag THEN BEGIN
        IF KEYWORD_SET(only_OMNI_plots) THEN BEGIN
           WINDOW_CUSTOM_SETUP,NPLOTCOLUMNS=1, $
                               NPLOTROWS=nQuantitiesToPlot, $
                               ROW_NAMES=LIST_TO_1DARRAY(geomag_title_list), $
                               SPACE_VERT_BETWEEN_ROWS=0.08, $
                               SPACE_FOR_ROW_NAMES=0.08, $
                               SPACE__XTITLE=0.09, $
                               ;; SPACE_FOR_COLUMN_NAMES=0.1, $
                               WINDOW_TITLE=winTitle, $
                               ;; XTITLE='Delay (min)', $
                               XTITLE=xTitle, $
                               ;; YTITLE=yTitle, $
                               CURRENT_WINDOW=geomagWindow,/MAKE_NEW
           window_custom        = 1
        ENDIF ELSE BEGIN
           geomagWindow=WINDOW(WINDOW_TITLE="SEA plots for " + STRCOMPRESS(nEpochs,/REMOVE_ALL) + " seas: "+ $
                               tStamps[0] + " - " + $
                               tStamps[-1], $
                               DIMENSIONS=[1200,800])
           window_custom        = 0
        ENDELSE
     ENDIF ELSE BEGIN
        geomagWindow.setCurrent
     ENDELSE
  ENDIF
  
  IF ~noPlots AND ~noGeomagPlots THEN BEGIN
     
     FOR iQuant=0,nQuantitiesToPlot-1 DO BEGIN
        geomag_time_list         = geomag_time_list_of_lists[iQuant]
        geomag_dat_list          = geomag_dat_list_of_lists[iQuant]
        FOR i=0,nEpochs-1 DO BEGIN
           IF N_ELEMENTS(geomag_time_list[i]) GT 1 AND ~noPlots AND ~noGeomagPlots THEN BEGIN
              geomagEpochSeconds = geomag_time_list[i]-centerTime[i]
              geomagEpochDat = geomag_dat_list[i]

              IF window_custom THEN BEGIN
                 nextPos = WINDOW_CUSTOM_NEXT_POS(NEXT_ROW=(i EQ nEpochs-1),HOLD_POSITION=(i LT nEpochs-1))
                 margin  = !NULL
              ENDIF ELSE BEGIN
                 margin  = margin__avg_plot
                 nextPos = !NULL
              ENDELSE

              PLOT_SW_OR_GEOMAGQUANTITY_TRACE__EPOCH,geomagEpochSeconds,geomagEpochDat, $
                                                     NAME=omni_quantity, $
                                                     AXIS_STYLE=1, $
                                                     PLOTTITLE=plotTitle, $
                                                     ;; XTITLE=xTitle, $
                                                     XRANGE=xRange, $
                                                     YTITLE=yTitle, $
                                                     YRANGE=yRange, $
                                                     LOGYPLOT=logYPlot, $
                                                     LINETHICK=lineThick,LINETRANSP=lineTransp, $
                                                     OVERPLOT=(i EQ 0) ? 0 : 1, $
                                                     CURRENT=1, $
                                                     ;; MARGIN=margin__max_plot, $
                                                     MARGIN=margin, $
                                                     POSITION=nextPos, $
                                                     ;; CLIP=0, $
                                                     YEAR_AND_SEASON_MODE=year_and_season_mode, $
                                                     OUTPLOT=geomagPlot, $
                                                     ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array
              
              ;; out_geomagPlots[i] = geomagPlot
              
           ENDIF ELSE PRINT,'Losing epoch #' + STRCOMPRESS(i,/REMOVE_ALL) + ' on the list! Only one elem...'
        ENDFOR
        axes=geomagPlot.axes
        axes[1].MINOR=nMinorTicks+1
     ENDFOR
  ENDIF
  
  IF ~noPlots AND ~KEYWORD_SET(only_OMNI_plots) THEN BEGIN
     IF KEYWORD_SET(nEventHists) THEN BEGIN
        
        IF KEYWORD_SET(neg_AND_pos_separ) THEN BEGIN
           PRINT,"Nevhists not implemented for neg and pos yet..."
           WAIT,5
        ENDIF ELSE BEGIN
           PLOT_ALFVENDBQUANTITY_HISTOGRAM__EPOCH,histTBins,nEvhistData, $
                                                  NAME=name__histo_plot, $
                                                  XRANGE=xRange, $
                                                  XHIDELABEL=xLabel_histo_plot__suppress, $
                                                  HISTORANGE=histoRange, $
                                                  YTITLE='N events', $
                                                  MARGIN=plotMargin, $
                                                  PLOTTITLE=title__histo_plot, $
                                                  OVERPLOT_HIST=KEYWORD_SET(overplot_hist) OR N_ELEMENTS(out_histo_plot) GT 0, $
                                                  COLOR=symColor__histo_plot, $
                                                  CURRENT=current, $
                                                  LAYOUT=layout, $
                                                  HISTOPLOT=histoPlot, $
                                                  BKGRND_HIST=bkgrnd_hist, $
                                                  BKGRNDHISTOPLOT=bkgrndHistoPlot, $
                                                  OUTPLOT=out_histo_plot, $
                                                  YEAR_AND_SEASON_MODE=year_and_season_mode, $
                                                  OUTBKGRNDPLOT=outBkgrndPlot, $
                                                  ADD_PLOT_TO_PLOT_ARRAY=KEYWORD_SET(accumulate__histo_plots)
        ENDELSE
        
     ENDIF ELSE BEGIN                      ;end IF nEventHists

        ;;Doing one of the time plot things
        CASE 1 OF 
           KEYWORD_SET(probOccurrence_sea): BEGIN
              PLOT_ALFVENDBQUANTITY_HISTOGRAM__EPOCH,histTBins- $
                                                     (KEYWORD_SET(window_sum) ? window_sum/2. : 0), $
                                                     histData, $
                                                     NAME=name__histo_plot, $
                                                     XRANGE=xRange, $
                                                     HISTORANGE=histoRange, $
                                                     YTITLE=KEYWORD_SET(yTitle_maxInd) ? yTitle_maxInd : yTitle, $
                                                     LOGYPLOT=log_probOccurrence, $
                                                     ;; YTICKFORMAT=, $
                                                     ;; MARGIN=plotMargin, $
                                                     ;; MARGIN=margin__max_plot, $
                                                     HISTOGRAM=1, $
                                                     MARGIN=margin__avg_plot, $
                                                     PLOTTITLE=title__histo_plot, $
                                                     OVERPLOT_HIST=KEYWORD_SET(overplot_hist) OR N_ELEMENTS(out_histo_plot) GT 0, $
                                                     COLOR=symColor__histo_plot, $
                                                     CURRENT=1, $
                                                     LAYOUT=layout, $
                                                     HISTOPLOT=histoPlot, $
                                                     BKGRND_HIST=bkgrnd_hist, $
                                                     BKGRNDHISTOPLOT=bkgrndHistoPlot, $
                                                     OUTPLOT=out_histo_plot, $
                                                     YEAR_AND_SEASON_MODE=year_and_season_mode, $
                                                     OUTBKGRNDPLOT=outBkgrndPlot, $
                                                     ADD_PLOT_TO_PLOT_ARRAY=KEYWORD_SET(accumulate__histo_plots)

           END
           KEYWORD_SET(timeAvgd_maxInd_sea): BEGIN

              PREPARE_ALFVENDB_EPOCHPLOTS,MINMAXDAT=minMaxDat,MAXDAT=maxDat,MINDAT=minDat, $
                                          ALF_IND_LIST=alf_ind_list, $
                                          LOG_DBQUANTITY=log_DBQuantity,NEG_AND_POS_SEPAR=neg_and_pos_separ
              


              PLOT_ALFVENDBQUANTITY_HISTOGRAM__EPOCH,histTBins- $
                                                     (KEYWORD_SET(window_sum) ? window_sum/2. : 0), $
                                                     histData, $
                                                     NAME=name__histo_plot, $
                                                     XRANGE=xRange, $
                                                     HISTORANGE=KEYWORD_SET(yRange_maxInd) ? yRange_maxInd : [minDat,maxDat], $
                                                     YTITLE=KEYWORD_SET(yTitle_maxInd) ? yTitle_maxInd : yTitle, $
                                                     LOGYPLOT=yLogScale_maxInd, $
                                                     ;; YTICKFORMAT=, $
                                                     ;; MARGIN=plotMargin, $
                                                     ;; MARGIN=margin__max_plot, $
                                                     HISTOGRAM=1, $
                                                     MARGIN=margin__avg_plot, $
                                                     PLOTTITLE=title__histo_plot, $
                                                     OVERPLOT_HIST=KEYWORD_SET(overplot_hist) OR N_ELEMENTS(out_histo_plot) GT 0, $
                                                     COLOR=symColor__histo_plot, $
                                                     CURRENT=1, $
                                                     LAYOUT=layout, $
                                                     HISTOPLOT=histoPlot, $
                                                     BKGRND_HIST=bkgrnd_hist, $
                                                     BKGRNDHISTOPLOT=bkgrndHistoPlot, $
                                                     OUTPLOT=out_histo_plot, $
                                                     OUTBKGRNDPLOT=outBkgrndPlot, $
                                                     YEAR_AND_SEASON_MODE=year_and_season_mode, $
                                                     ADD_PLOT_TO_PLOT_ARRAY=KEYWORD_SET(accumulate__histo_plots)

           END
           KEYWORD_SET(hist_maxInd_sea): BEGIN

              PREPARE_ALFVENDB_EPOCHPLOTS,MINMAXDAT=minMaxDat,MAXDAT=maxDat,MINDAT=minDat, $
                                          ALF_IND_LIST=alf_ind_list, $
                                          LOG_DBQUANTITY=log_DBQuantity,NEG_AND_POS_SEPAR=neg_and_pos_separ
              


              PLOT_ALFVENDBQUANTITY_HISTOGRAM__EPOCH,histTBins- $
                                                     (KEYWORD_SET(window_sum) ? window_sum/2. : 0), $
                                                     histData, $
                                                     NAME=name__histo_plot, $
                                                     XRANGE=xRange, $
                                                     HISTORANGE=KEYWORD_SET(yRange_maxInd) ? yRange_maxInd : [minDat,maxDat], $
                                                     YTITLE=KEYWORD_SET(yTitle_maxInd) ? yTitle_maxInd : yTitle, $
                                                     LOGYPLOT=yLogScale_maxInd, $
                                                     ;; YTICKFORMAT=, $
                                                     ;; MARGIN=plotMargin, $
                                                     ;; MARGIN=margin__max_plot, $
                                                     HISTOGRAM=1, $
                                                     MARGIN=margin__avg_plot, $
                                                     PLOTTITLE=title__histo_plot, $
                                                     OVERPLOT_HIST=KEYWORD_SET(overplot_hist) OR N_ELEMENTS(out_histo_plot) GT 0, $
                                                     COLOR=symColor__histo_plot, $
                                                     CURRENT=1, $
                                                     LAYOUT=layout, $
                                                     HISTOPLOT=histoPlot, $
                                                     BKGRND_HIST=bkgrnd_hist, $
                                                     BKGRNDHISTOPLOT=bkgrndHistoPlot, $
                                                     OUTPLOT=out_histo_plot, $
                                                     OUTBKGRNDPLOT=outBkgrndPlot, $
                                                     YEAR_AND_SEASON_MODE=year_and_season_mode, $
                                                     ADD_PLOT_TO_PLOT_ARRAY=KEYWORD_SET(accumulate__histo_plots)

           END
           ELSE: PRINT,""
        ENDCASE
     ENDELSE
  ENDIF

  IF KEYWORD_SET(make_legend__histo_plot) THEN BEGIN
     IF N_ELEMENTS(out_histo_plot) EQ n__histo_plots THEN BEGIN
        legend = LEGEND(TARGET=out_histo_plot[0:n__histo_plots-1], $
                        /NORMAL, $
                        POSITION=[0.29,0.85], $
                        FONT_SIZE=18, $
                        HORIZONTAL_ALIGNMENT=0.5, $
                        VERTICAL_SPACING=defHPlot_legend__vSpace, $
                        /AUTO_TEXT_COLOR)
        
     ENDIF
  ENDIF

  IF KEYWORD_SET(savePlot) THEN BEGIN
     SET_PLOT_DIR,plotDir,/FOR_SW_IMF,/VERBOSE,/ADD_TODAY
     PRINT,"Saving plot to file: " + plotDir + savePName
     geomagWindow.save,plotDir + savePName,RESOLUTION=defRes,CMYK=KEYWORD_SET(eps_output)

     IF KEYWORD_SET(eps_output) THEN BEGIN
        ;; SETUP_EPS_OUTPUT,/CLOSE
        CGPS_CLOSE
     ENDIF
  ENDIF

  IF KEYWORD_SET(maxInd) AND ~KEYWORD_SET(proOccurrence_sea) AND ~KEYWORD_SET(timeAvgd_maxInd_sea) $
     AND ~KEYWORD_SET(hist_maxInd_sea) $
     ;; AND ~KEYWORD_SET(timeAvgd_pFlux_sea) AND ~KEYWORD_SET(timeAvgd_eFluxMax_sea) $
  THEN BEGIN

     mTags=TAG_NAMES(maximus)
     yTitle = (KEYWORD_SET(yTitle_maxInd) ? yTitle_maxInd : mTags[maxInd])
     IF ~(noPlots OR (noMaxPlots AND noAvgPlots)) THEN BEGIN
        IF N_ELEMENTS(maximusWindow) EQ 0 THEN BEGIN
           maximusWindow=WINDOW(WINDOW_TITLE="Maximus plots", $
                                DIMENSIONS=[1200,800])
        ENDIF ELSE BEGIN
           maximusWindow.setCurrent
        ENDELSE
     ENDIF

     PREPARE_ALFVENDB_EPOCHPLOTS,MINMAXDAT=minMaxDat,MAXDAT=maxDat,MINDAT=minDat, $
                                 ALF_IND_LIST=alf_ind_list, $
                                 LOG_DBQUANTITY=log_DBQuantity,NEG_AND_POS_SEPAR=neg_and_pos_separ
     
     ;; FOR i=0,nEpochs-1 DO BEGIN
        IF KEYWORD_SET(neg_and_pos_separ) THEN BEGIN
           posneg_colors = MAKE_ARRAY(2,/STRING)
           IF KEYWORD_SET(pos_color) THEN posneg_colors[0] = pos_color ELSE posneg_colors[0] = defPosColor
           IF KEYWORD_SET(neg_color) THEN posneg_colors[1] = pos_color ELSE posneg_colors[1] = defNegColor
           FOR j = 0,1 DO BEGIN
              IF j EQ 0 THEN BEGIN
                 ;; plot_i    = (N_ELEMENTS(tot_plot_i_pos_list) GT 0 ? tot_plot_i_pos_list[i] : !NULL )
                 ;; alf_t     = (N_ELEMENTS(tot_alf_t_pos_list) GT 0 ? tot_alf_t_pos_list[i] : !NULL )
                 ;; alf_y     = (N_ELEMENTS(tot_alf_y_pos_list) GT 0 ? tot_alf_y_pos_list[i] : !NULL )
                 alf_t     = tot_alf_t_pos
                 alf_y     = tot_alf_y_pos
                 IF KEYWORD_SET(pos_layout) THEN pn_layout = pos_layout ELSE pn_layout = [1,1,1]
              ENDIF ELSE BEGIN
                 ;; plot_i    = (N_ELEMENTS(tot_plot_i_neg_list) GT 0 ? tot_plot_i_neg_list[i] : !NULL )
                 ;; alf_t     = (N_ELEMENTS(tot_alf_t_neg_list) GT 0 ? tot_alf_t_neg_list[i] : !NULL )
                 ;; alf_y     = (N_ELEMENTS(tot_alf_y_neg_list) GT 0 ? tot_alf_y_neg_list[i] : !NULL )
                 alf_t     = tot_alf_t_neg
                 alf_y     = tot_alf_y_neg
                 IF N_ELEMENTS(neg_layout) GT 0 THEN pn_layout = [[pn_layout],[neg_layout]] ELSE pn_layout = [[pn_layout],[1,1,1]]
                 
              ENDELSE
              IF N_ELEMENTS(alf_t) GT 0 AND ~(KEYWORD_SET(noPlots) OR KEYWORD_SET(noMaxPlots)) THEN BEGIN
                 IF KEYWORD_SET(log_DBQuantity) THEN alf_y =  10.0^(alf_y)
                 PLOT_ALFVENDBQUANTITY_SCATTER__EPOCH,maxInd,mTags,NAME=name,AXIS_STYLE=axis_Style, $
                                                      SYMCOLOR=posneg_colors[j], $
                                                      SYMTRANSPARENCY=symTransp_maxInd, $
                                                      SYMBOL=symbol, $
                                                      ;; ALFDBSTRUCT=maximus,ALFDBTIME=cdbTime,PLOT_I=plot_i,CENTERTIME=centerTime,$
                                                      ALF_T=alf_t,ALF_Y=alf_y, $
                                                      ;; PLOTTITLE=plotTitle, $
                                                      XTITLE=xTitle, $
                                                      XRANGE=xRange, $
                                                      YTITLE=yTitle, $
                                                      YRANGE=KEYWORD_SET(yRange_maxInd) ? yRange_maxInd : [minDat[j],maxDat[j]], $
                                                      LOGYPLOT=yLogScale_maxInd, $
                                                      DO_SECONDARY_AXIS=secondary_axis__totalVar_plot, $
                                                      DO_TWO_PANELS=do_two_panels, $
                                                      OVERPLOT_ALFVENDBQUANTITY=(j EQ 0) ? 0 : 1, $
                                                      CURRENT=N_ELEMENTS(maximusWindow) GT 0, $
                                                      MARGIN=margin__avg_plot, $
                                                      ;; MARGIN=margin__max_plot, $
                                                      YMINOR=yMinor_maxInd, $
                                                      LAYOUT=pn_layout[*,j], $
                                                      CLIP=0, $
                                                      YEAR_AND_SEASON_MODE=year_and_season_mode, $
                                                      OUTPLOT=(j EQ 0) ? out_maxPlotPos : out_maxPlotNeg, $
                                                      ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array ;; Add the legend, if neg_and_pos_separ
              ENDIF
           ENDFOR
        ENDIF ELSE BEGIN
           alf_t     = tot_alf_t
           alf_y     = tot_alf_y
           symColor = N_ELEMENTS(epochPlot_colorNames) GT 0 ? epochPlot_colorNames[0] : symColor
           IF N_ELEMENTS(alf_t) GT 0 AND ~(KEYWORD_SET(noPlots) OR KEYWORD_SET(noMaxPlots)) THEN BEGIN
              IF KEYWORD_SET(log_DBQuantity) THEN alf_y =  10.0^(alf_y)
              PLOT_ALFVENDBQUANTITY_SCATTER__EPOCH,maxInd,mTags,NAME=name,AXIS_STYLE=axis_Style, $
                                                   SYMCOLOR=KEYWORD_SET(symColor__max_plot) ? symColor__max_plot : symColor, $
                                                   SYMTRANSPARENCY=symTransp_maxInd, $
                                                   SYMBOL=symbol, $
                                                   ALF_T=alf_t, $
                                                   ALF_Y=alf_y, $
                                                   ;; PLOTTITLE=plotTitle, $
                                                   XTITLE=xTitle, $
                                                   XRANGE=xRange, $
                                                   XHIDELABEL=xLabel_maxInd__suppress, $
                                                   YTITLE=yTitle, $
                                                   YRANGE=KEYWORD_SET(yRange_maxInd) ? yRange_maxInd : [minDat,maxDat], $
                                                   LOGYPLOT=yLogScale_maxInd, $
                                                   ;; OVERPLOT_ALFVENDBQUANTITY=(i EQ 0) ? 0 : 1, $
                                                   DO_SECONDARY_AXIS=secondary_axis__totalVar_plot, $
                                                   DO_TWO_PANELS=do_two_panels, $
                                                   OVERPLOT_ALFVENDBQUANTITY=0, $
                                                   CURRENT=N_ELEMENTS(maximusWindow) GT 0, $
                                                   MARGIN=margin__avg_plot, $
                                                   ;; MARGIN=margin__max_plot, $
                                                   LAYOUT=layout, $
                                                   ;; CLIP=0, $
                                                   OUTPLOT=out_maxPlotAll, $
                                                   YEAR_AND_SEASON_MODE=year_and_season_mode, $
                                                   ADD_PLOT_TO_PLOT_ARRAY=add_plot_to_plot_array ;; Add the legend, if neg_and_pos_separ
           ENDIF
        ENDELSE
        ;; Add the legend, if neg_and_pos_separ
        IF neg_and_pos_separ THEN BEGIN
           IF N_ELEMENTS(out_maxPlotPos) GT 0 AND N_ELEMENTS(out_maxPlotNeg) GT 0 THEN BEGIN
              leg = LEGEND(TARGET=[plot_nEv,plot_bkgrnd], $
                           POSITION=[-20.,((KEYWORD_SET(histoRange) ? histoRange : [0,7500])[1])]*0.45, /DATA, $
                           FONT_SIZE=18, $
                           HORIZONTAL_ALIGNMENT=0.5, $
                           VERTICAL_SPACING=defHPlot_legend__vSpace, $
                           /AUTO_TEXT_COLOR)
           ENDIF
        ENDIF
     ;; ENDFOR
     
        IF avg_type_maxInd GT 0 THEN BEGIN
           IF ~(noPlots OR noAvgPlots) THEN BEGIN
              IF KEYWORD_SET(running_average) OR KEYWORD_SET(running_median) THEN BEGIN
                 IF KEYWORD_SET(running_average) THEN BEGIN
                    r_y        = ra_y
                    r_t        = ra_t
                    r_nz_i     = ra_nz_i
                    rBinsize   = running_average
                    rTitleSuff = ' (Running average'
                 ENDIF ELSE BEGIN
                    r_y        = rm_y
                    r_t        = rm_t
                    r_nz_i     = rm_nz_i
                    rBinsize   = running_median
                    rTitleSuff = ' (Running median'
                 ENDELSE
                 IF running_smooth_nPoints GT 1 THEN BEGIN
                    rTitleSuff += STRING(FORMAT='(", ",I0,"-hour smoothing)")', $
                                         running_smooth_nPoints)
                 ENDIF ELSE BEGIN
                    rTitleSuff += ')'
                 ENDELSE

                 PLOT_ALFVENDBQUANTITY_AVERAGES_OR_SUMS__EPOCH,r_y,r_t,$
                    TAFTEREPOCH=tAfterEpoch, $
                    TBEFOREEPOCH=tBeforeEpoch, $
                    HISTOBINSIZE=rBinsize, $
                    NONZERO_I=r_nz_i, $
                    /NO_AVG_SYMBOL, $
                    LINESTYLE='-', $
                    LINETHICKNESS=4.0, $
                    ;; SYMBOL=symbol, $
                    SYMCOLOR=KEYWORD_SET(symColor__avg_plot) ? symColor__avg_plot : symColor, $
                    ;; SYMTRANSPARENCY=symTransparency, $
                    PLOTNAME=name__avg_plot, $
                    PLOTTITLE=KEYWORD_SET(title__avg_plot) ? $
                              title__avg_plot+rTitleSuff : !NULL, $
                    ERROR_PLOT=KEYWORD_SET(make_error_bars__avg_plot), $
                    ERROR_BARS=out_error_bars, $
                    ERRORBAR_CAPSIZE=errorbar_capsize, $
                    ERRORBAR_COLOR=errorbar_color, $ 
                    ERRORBAR_LINESTYLE=errorbar_linestyle, $
                    ERRORBAR_THICK=errorbar_thick, $
                    ;; DO_SECONDARY_AXIS=secondary_axis__totalVar_plot, $
                    DO_TWO_PANELS=do_two_panels, $
                    XTITLE=xTitle, $
                    XRANGE=xRange, $
                    XHIDELABEL=xLabel_maxInd__suppress, $
                    YTITLE=yTitle, $
                    YRANGE=KEYWORD_SET(yRange_maxInd) ? yRange_maxInd : [minDat,maxDat], $
                    LOGYPLOT=yLogScale_maxInd, $
                    OVERPLOT=KEYWORD_SET(overPlot) OR N_ELEMENTS(out_avg_plot) GT 0, $
                    CURRENT=1, $
                    MARGIN=margin__avg_plot, $
                    ;; MARGIN=margin__max_plot, $
                    LAYOUT=layout, $
                    OUTPLOT=out_avg_plot, $
                    YEAR_AND_SEASON_MODE=year_and_season_mode, $
                    ADD_PLOT_TO_PLOT_ARRAY=KEYWORD_SET(accumulate__avg_plots)
                 
              ENDIF ELSE BEGIN
                 IF KEYWORD_SET(window_sum) THEN BEGIN
                    hist_t  = histTBins
                 ENDIF ELSE BEGIN
                    hist_t = histTBins+histoBinsize*0.5
                 ENDELSE

                 PLOT_ALFVENDBQUANTITY_AVERAGES_OR_SUMS__EPOCH, $
                    histData, $
                    hist_t,$
                    TAFTEREPOCH=tAfterEpoch,TBEFOREEPOCH=tBeforeEpoch, $
                    HISTOBINSIZE=histoBinSize, $
                    NONZERO_I=nz_i, $
                    SYMBOL=symbol, $
                    SYMCOLOR=KEYWORD_SET(symColor__avg_plot) ? symColor__avg_plot : symColor, $
                    ;; SYMTRANSPARENCY=symTransparency, $
                    PLOTNAME=name__avg_plot, $
                    PLOTTITLE=KEYWORD_SET(title__avg_plot) ? $
                              title__avg_plot : !NULL, $
                    ERROR_PLOT=KEYWORD_SET(make_error_bars__avg_plot), $
                    ERROR_BARS=out_error_bars, $
                    ERRORBAR_CAPSIZE=errorbar_capsize, $
                    ERRORBAR_COLOR=errorbar_color, $ 
                    ERRORBAR_LINESTYLE=errorbar_linestyle, $
                    ERRORBAR_THICK=errorbar_thick, $
                    ;; DO_SECONDARY_AXIS=secondary_axis__totalVar_plot, $
                    DO_TWO_PANELS=do_two_panels, $
                    XTITLE=xTitle, $
                    XRANGE=xRange, $
                    XHIDELABEL=xLabel_maxInd__suppress, $
                    YTITLE=yTitle, $
                    YRANGE=KEYWORD_SET(yRange_maxInd) ? yRange_maxInd : [minDat,maxDat], $
                    LOGYPLOT=yLogScale_maxInd, $
                    OVERPLOT=KEYWORD_SET(overPlot) OR N_ELEMENTS(out_avg_plot) GT 0, $
                    CURRENT=1, $
                    MARGIN=margin__avg_plot, $
                    ;; MARGIN=margin__max_plot, $
                    LAYOUT=layout, $
                    OUTPLOT=out_avg_plot, $
                    YEAR_AND_SEASON_MODE=year_and_season_mode, $
                    ADD_PLOT_TO_PLOT_ARRAY=KEYWORD_SET(accumulate__avg_plots)
              ENDELSE
           ENDIF
        ENDIF

        IF KEYWORD_SET(overplot_total_epoch_variation) AND ~noPlots THEN BEGIN


                 PLOT_ALFVENDBQUANTITY_AVERAGES_OR_SUMS__EPOCH, $
                    total_epoch_histData, $
                    total_epoch_histTBins,$
                    TAFTEREPOCH=tAfterEpoch,TBEFOREEPOCH=tBeforeEpoch, $
                    HISTOBINSIZE=histoBinSize, $
                    HISTOGRAM=total_epoch__do_histoPlot, $
                    NONZERO_I=nz_i_totalEpoch_po, $
                    LINESTYLE=0, $
                    LINETHICKNESS=4.0, $
                    /NO_AVG_SYMBOL, $
                    SYMCOLOR=KEYWORD_SET(symColor__totalVar_plot) ? symColor__totalVar_plot : symColor, $
                    ;; SYMTRANSPARENCY=symTransparency, $
                    PLOTNAME=name__epochVar_plot, $
                    PLOTTITLE=KEYWORD_SET(title__epochVar_plot) ? $
                              title__epochVar_plot : !NULL, $
                    ;; ERROR_PLOT=KEYWORD_SET(make_error_bars__avg_plot), $
                    ;; ERROR_BARS=out_error_bars, $
                    ;; ERRORBAR_CAPSIZE=errorbar_capsize, $
                    ;; ERRORBAR_COLOR=errorbar_color, $ 
                    ;; ERRORBAR_LINESTYLE=errorbar_linestyle, $
                    ;; ERRORBAR_THICK=errorbar_thick, $
                    DO_TWO_PANELS=do_two_panels, $
                    MAKE_SECOND_PANEL=1, $
                    SECOND_PANEL__PREP_FOR_SECONDARY_AXIS=second_panel__prep_for_secondary_axis, $
                    DO_SECONDARY_AXIS=secondary_axis__totalVar_plot, $
                    DIFFCOLOR_SECONDARY_AXIS=diffColor_secondary_axis, $
                    XTITLE=xTitle, $
                    XRANGE=xRange, $
                    XHIDELABEL=xLabel_maxInd__suppress, $
                    YTITLE=yTitle, $
                    YRANGE=KEYWORD_SET(yRange_totalVar) ? yRange_totalVar : [minDat,maxDat], $
                    LOGYPLOT=yLogScale_totalVar, $
                    OVERPLOT=KEYWORD_SET(overPlot) OR (~KEYWORD_SET(DO_two_panels) AND N_ELEMENTS(out_avg_plot) GT 0), $
                    CURRENT=1, $
                    MARGIN=margin__avg_plot, $
                    ;; MARGIN=margin__max_plot, $
                    LAYOUT=layout, $
                    OUTPLOT=out_avg_plot, $
                    YEAR_AND_SEASON_MODE=year_and_season_mode, $
                    ADD_PLOT_TO_PLOT_ARRAY=KEYWORD_SET(accumulate__avg_plots)

                 PRINT,FORMAT='("epochvar [max,min]: ",G13.4,TR8,G13.4)',MAX(total_epoch_histData),MIN(total_epoch_histData)
        ENDIF

        IF KEYWORD_SET(make_legend__avg_plot) THEN BEGIN
           IF N_ELEMENTS(out_avg_plot) EQ n__avg_plots THEN BEGIN
              legend = LEGEND(TARGET=out_avg_plot[0:n__avg_plots-1], $
                              POSITION=[0.73,0.32], $
                              FONT_SIZE=18, $
                              HORIZONTAL_ALIGNMENT=0.5, $
                              VERTICAL_SPACING=defHPlot_legend__vSpace, $
                              /NORMAL, $
                              /AUTO_TEXT_COLOR)
              
           ENDIF
        ENDIF

        IF KEYWORD_SET(bkgrnd_maxInd) AND ~noPlots THEN BEGIN

           safe_i=(log_DBQuantity) ? WHERE(FINITE(bkgrnd_maxInd) AND bkgrnd_maxInd GT 0.) : WHERE(FINITE(bkGrnd_maxInd))
           
           y_offset = (log_DBQuantity) ? 1. : TOTAL(bkgrnd_maxind[safe_i])*0.1
           ;; y_offset = 0.
           IF N_ELEMENTS(tBins) EQ 0 THEN STOP
           plot_bkgrnd_max=plot(tBins[safe_i]+0.5*histoBinSize, $
                                (log_DBQuantity) ? 10^(bkgrnd_maxInd[safe_i]-y_offset) : bkgrnd_maxInd[safe_i]-y_offset, $
                                XRANGE=xRange, $
                                YRANGE=(KEYWORD_SET(yRange_maxInd)) ? $
                                yRange_maxInd : [minDat,maxDat], $
                                YLOG=(yLogScale_maxInd) ? 1 : 0, $
                                NAME='Background Alfvén activity', $
                                AXIS_STYLE=0, $
                                LINESTYLE='--', $
                                COLOR='blue', $
                                THICK=2.0, $
                                SYMBOL='d', $
                                SYM_SIZE=2.5, $
                                MARGIN=plotMargin_max, $
                                /CURRENT)
           
           legPosY=(KEYWORD_SET(yRange_maxInd) ? yRange_maxInd : [minDat,maxDat])
           IF (log_DBQuantity) THEN BEGIN
              ;; legPosY=10.^MEAN(ALOG10(legPosY))
              legPosY=10.^(ALOG10(legPosY[1])-ALOG10(5))
           ENDIF ELSE legPosY=MEAN(legPosY)
           
           leg = LEGEND(TARGET=[avgplot,plot_bkgrnd_max], $
                        POSITION=[-15.,legPosY], /DATA, $
                     /AUTO_TEXT_COLOR)


     ENDIF
     
     IF KEYWORD_SET(saveMaxPlot) AND ~(noPlots OR (noMaxPlots AND noAvgPlots)) THEN BEGIN
        SET_PLOT_DIR,plotDir,/FOR_SEAS,/VERBOSE,/ADD_TODAY
        PRINT,"Saving maxplot to file: " + plotDir + saveMPName
        maximuswindow.save,plotDir + saveMPName,RESOLUTION=defRes,CMYK=KEYWORD_SET(eps_output)

        IF KEYWORD_SET(eps_output) THEN BEGIN
           ;; SETUP_EPS_OUTPUT,/CLOSE
           CGPS_CLOSE
        ENDIF
     ENDIF

  ENDIF
  
  IF do_ScatterPlots THEN BEGIN
     KEY_SCATTERPLOTS_POLARPROJ,MAXIMUS=maximus,$
                                /OVERLAYAURZONE,PLOT_I_LIST=tot_plot_i_list,STRANS=98, $
                                OUTFILE=N_ELEMENTS(scatterOutPrefix) GT 0 ? scatterOutPrefix+'--north.png' : !NULL

     KEY_SCATTERPLOTS_POLARPROJ,MAXIMUS=maximus,/SOUTH, $
                                /OVERLAYAURZONE,PLOT_I_LIST=tot_plot_i_list,STRANS=98, $
                                OUTFILE=N_ELEMENTS(scatterOutPrefix) GT 0 ? scatterOutPrefix+'--south.png' : !NULL
  ENDIF

  IF saveFile THEN BEGIN
     saveStr+=',filename='+'"'+saveFile+'"'
     PRINT,"Saving output to " + saveFile
     PRINT,"SaveStr: ",saveStr
     biz = EXECUTE(saveStr)
  ENDIF

END