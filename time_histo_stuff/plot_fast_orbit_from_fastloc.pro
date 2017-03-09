PRO PLOT_FAST_ORBIT_FROM_FASTLOC,orbit, $
                                 HEMI=hemi, $
                                 ADD_LINE=add_line, $
                                 NO_SYMBOL=no_symbol, $
                                 ADD_ORBIT_LEGEND=add_orbit_legend, $
                                 STRANS=sTrans, $
                                 SAVEPLOT=savePlot, $
                                 SPNAME=scatterPlotName, $
                                 PLOTDIR=plotDir, $
                                 ;; /CLOSE_AFTER_SAVE, $
                                 IN_MAP=in_map, $
                                 OUTPUT_ORBIT_DETAILS=output_orbit_details, $
                                 OUT_ORBSTRARR_LIST=out_orbStrArr_list, $
                                 OUT_COLOR_LIST=out_color_list, $
                                 OUT_WINDOW=out_window, $
                                 OUT_MAP=out_map





  COMPILE_OPT idl2,strictarrsubs

  IF ~KEYWORD_SET(hemi)   THEN hemi = hemi

  IF ~KEYWORD_SET(sTrans) THEN sTrans = 10

  PRINT,'Plotting ephemeris stuff for the following orbits:'
  plot_i_list               = LIST()
  FOR i=0,N_ELEMENTS(orbit)-1 DO BEGIN
     PRINT,orbit[i]
     fastLoc_i              = GET_CHASTON_IND(fastLoc, $
                                              /GET_TIME_I_NOT_ALFVENDB_I, $
                                              ORBRANGE=orbit[i], $
                                              /RESET_GOOD_INDS, $
                                              OUT_FASTLOC=(i EQ N_ELEMENTS(orbit)-1) ? fastLoc : !NULL)
     plot_i_list.add,fastLoc_i
  ENDFOR

  color_list = KEYWORD_SET(color_list) ? color_list : GENERATE_LIST_OF_RANDOM_COLORS(N_ELEMENTS(orbit))

  KEY_SCATTERPLOTS_POLARPROJ,MAXIMUS=fastLoc, $
                             HEMI=hemi, $
                             /OVERLAYAURZONE, $
                             ADD_ORBIT_LEGEND=add_orbit_legend, $
                             CENTERLON=centerLon, $
                             OVERPLOT=overplot, $
                             LAYOUT=layout, $
                             PLOTPOSITION=plotPosition, $
                             OUT_PLOT=out_plot, $
                             ADD_LINE=add_line, $
                             NO_SYMBOL=no_symbol, $
                             CURRENT_WINDOW=window, $
                             PLOTSUFF=plotSuff, $
                             DBFILE=dbFile, $
                             PLOT_I_LIST=plot_i_list, $
                             COLOR_LIST=color_list, $
                             STRANS=sTrans, $
                             SAVEPLOT=savePlot, $
                             SPNAME=scatterPlotName, $
                             PLOTDIR=plotDir, $
                             ;; /CLOSE_AFTER_SAVE, $
                             OUTPUT_ORBIT_DETAILS=output_orbit_details, $
                             OUT_ORBSTRARR_LIST=out_orbStrArr_list, $
                             PLOTTITLE=plotTitle, $
                             IN_MAP=in_map, $
                             OUT_WINDOW=out_window, $
                             OUT_MAP=out_map, $
                             _EXTRA = e

  IF ARG_PRESENT(out_color_list) THEN out_color_list = color_list

END