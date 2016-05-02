;+
; NAME:                           SUPERPOSE_SEASONS_ALFVENDBQUANTITIES
;
; PURPOSE:                        Look at seasonal variations, 'course!
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
; MODIFICATION HISTORY:   2016/04/29 Wrapping SUPERPOSE_SEA_TIMES_ALFVENDBQUANTITIES to look at seasonal variations
;-
PRO SUPERPOSE_SEASONS_ALFVENDBQUANTITIES, $
   N_YEARS=n_years, $
   START_YEAR=start_year, $
   ;; TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
   STARTDATE=startDate, STOPDATE=stopDate, $
   DAYSIDE=dayside,NIGHTSIDE=nightside, $
   ;; SEA_CENTERTIMES_UTC=sea_centerTimes_UTC, $
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
   THIST_SEA=tHist_sea, $
   THIST_NORMALIZE=tHist_normalize, $
   THIST_AUTOSCALE=tHist_autoScale, $
   HIST_MAXIND_SEA=hist_maxInd_sea, $
   TIMEAVGD_MAXIND_SEA=timeAvgd_maxInd_sea, $
   LOG_TIMEAVGD_MAXIND=log_timeAvgd_maxInd, $
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
   PDF_OUTPUT=pdf_output
  
  
  dataDir='/SPENCEdata/Research/Cusp/database/'

  ;;In this case, the centertimes are each year, and we want to go the full year!
  year_and_season_mode = 1
  IF ~KEYWORD_SET(n_years) THEN n_years = 1
  IF ~KEYWORD_SET(start_year) THEN start_year = 1996
  years                = LINDGEN(n_years)+start_year
  yearStr              = STRING(FORMAT='(I0,"-01-01/00:00:00")',years)
  yearUTC              = DOUBLE(STR_TO_TIME(yearStr))

  ;;Now DO IT
  SUPERPOSE_SEA_TIMES_ALFVENDBQUANTITIES, $
     TBEFOREEPOCH=0, $
     TAFTEREPOCH=LONG64(365)*24, $
     STARTDATE=yearUTC[0], STOPDATE=yearUTC[-1], $
     DAYSIDE=dayside,NIGHTSIDE=nightside, $
     SEA_CENTERTIMES_UTC=yearUTC, $
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
     THIST_SEA=tHist_sea, $
     THIST_NORMALIZE=tHist_normalize, $
     THIST_AUTOSCALE=tHist_autoScale, $
     HIST_MAXIND_SEA=hist_maxInd_sea, $
     TIMEAVGD_MAXIND_SEA=timeAvgd_maxInd_sea, $
     LOG_TIMEAVGD_MAXIND=log_timeAvgd_maxInd, $
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
     YEAR_AND_SEASON_MODE=year_and_season_mode, $
     EPS_OUTPUT=eps_output, $
     PDF_OUTPUT=pdf_output

END