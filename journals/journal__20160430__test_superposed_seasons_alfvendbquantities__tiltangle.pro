PRO JOURNAL__20160430__TEST_SUPERPOSED_SEASONS_ALFVENDBQUANTITIES__TILTANGLE

  @journal__20160429__plot_defaults.pro

  ;;what location?
  ;;1=day 2=night
  do_these_plots        = [0,1]

  ;;OMNI quants?
  OMNI_quantities_to_plot = ['tiltAngle']
  ;; OMNI_quantity_ranges    = [-20,20]

  only_OMNI_plots         = 0

  ;;which plot type?
  probOccurrence_sea    = 1
  histoRange = [0,0.05]

  nEventHists           = 0

  ;;Other params
  n_years           = 4
  start_year        = 1996

  ;; window_sum        = running_logAvg          ;use the values that all the other plots do
  ;; window_sum        = 10                      ; ... or don't
  binSize_days                  = 10
  histoBinsize                  = LONG64(binSize_days)*24

  hemi              = 'NORTH'
  ;; hemi              = 'SOUTH'

  do_despun         = 1

  ;; restrict_altRange = [0000,1000]
  ;; restrict_altRange = [1000,2000]
  ;; restrict_altRange = [2000,3000]
  ;; restrict_altRange = [3000,4175]
  ;; restrict_altRange = [4000,4175]
  ;; restrict_altRange = [0340,2000] & histoRange = [0,0.065]
  ;; restrict_altRange = [2000,4175] & histoRange = [0,0.065]
  restrict_altRange = [0000,4175]

  ;;manual mod this
  IF do_despun THEN BEGIN
     plotSuff       = '--' + STRUPCASE(hemi) + '_hemi--despun_db.png'
  ENDIF ELSE BEGIN
     plotSuff       = '--' + STRUPCASE(hemi) + '_hemi.png'
  ENDELSE

  probOccPref       = pref + '--TILTANGLE' + $
                      STRING(FORMAT='("--altRange_",I0,"-",I0)',restrict_altRange[0],restrict_altRange[1])

  ptPref            = ''

  FOR j=0,N_ELEMENTS(do_these_plots)-1 DO BEGIN
     i                 = do_these_plots[j]

     savePlotPref      = STRING(FORMAT='(A0,"--",I0,"-hr_bins")', $
                                probOccPref, $
                                histoBinsize)
                                ;; window_sum)
     spn               = savePlotPref+plotSuff
     pT                = 'Seasonal SEA ' + STRING(FORMAT='("(Altitude Range: [",I0,", ",I0,"] km)")',restrict_altRange[0],restrict_altRange[1])

  SUPERPOSE_SEASONS_ALFVENDBQUANTITIES, $
     N_YEARS=n_years, $
     START_YEAR=start_year, $
     RESTRICT_ALTRANGE=restrict_altRange, $
     RESTRICT_CHARERANGE=restrict_charERange, $
     DO_DESPUNDB=do_despunDB, $
     USE_SYMH=use_symh,USE_AE=use_AE, $
     OMNI_QUANTITIES_TO_PLOT=OMNI_quantities_to_plot, $
     OMNI_QUANTITY_RANGES=OMNI_quantity_ranges, $
     LOG_OMNI_QUANTITIES=log_omni_quantities, $
     SMOOTHWINDOW=smoothWindow, $
     NEVENTHISTS=nEventHists, $
     HISTOBINSIZE=histoBinSize, $
     HISTORANGE=histoRange, $
     TITLE__HISTO_PLOT=pT, $
     XLABEL_HISTO_PLOT__SUPPRESS=xLabel_histo_plot__suppress, $
     SYMCOLOR__HISTO_PLOT=symColor[i], $
     /MAKE_LEGEND__HISTO_PLOT, $
     NAME__HISTO_PLOT=ptRegion[i], $
     N__HISTO_PLOTS=2, $
     /ACCUMULATE__HISTO_PLOTS, $
     PROBOCCURRENCE_SEA=probOccurrence_sea, $
     LOG_PROBOCCURRENCE=log_probOccurrence, $
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
     ;; RUNNING_AVERAGE=running_average, $
     ;; RUNNING_MEDIAN=running_median, $
     ;; RUNNING_BIN_SPACING=running_bin_spacing, $
     ;; RUNNING_SMOOTH_NPOINTS=running_smooth_nPoints, $
     ;; RUNNING_BIN_OFFSET=bin_offset, $
     ;; RUNNING_BIN_L_EDGES=bin_l_edges, $
     ;; RUNNING_BIN_R_EDGES=bin_r_edges, $
     ;; WINDOW_SUM=window_sum, $
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
     LOG_DBQUANTITY=log_DBQuantity, $
     YLOGSCALE_MAXIND=yLogScale_maxInd, $
     /XLABEL_MAXIND__SUPPRESS, $
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
     NOGEOMAGPLOTS=(i GT 0), $
     ONLY_OMNI_PLOTS=only_OMNI_plots, $
     NOAVGPLOTS=noAvgPlots, $
     USING_HEAVIES=using_heavies, $
     SAVEFILE=saveFile, $
     /OVERPLOT_HIST, $
     /NOMAXPLOTS, $
     SAVEPNAME=spn, $
     SAVEPLOT=(i EQ 1), $
     SAVEMAXPLOT=saveMaxPlot, $
     SAVEMPNAME=saveMPName, $
     DO_SCATTERPLOTS=do_scatterPlots, $
     EPOCHPLOT_COLORNAMES=epochPlot_colorNames, $
     SCATTEROUTPREFIX=scatterOutPrefix, $
     MINMLT=minM[i], $
     MAXMLT=maxM[i], $
     BINM=binM, $
     MINILAT=minI, $
     MAXILAT=maxI, $
     BINI=binI, $
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


  ENDFOR
END
