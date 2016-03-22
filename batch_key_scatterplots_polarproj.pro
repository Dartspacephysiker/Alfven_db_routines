;2015/03/29
; Do some sweet n_events plots

PRO BATCH_KEY_SCATTERPLOTS_POLARPROJ,plot_i_list, $
                                     NPLOTCOLUMNS=nPlotColumns, $
                                     NPLOTROWS=nPlotRows, $
                                     ADD_ORBIT_LEGEND=add_orbit_legend, $
                                     _EXTRA = e

  ;; ind_files=['PLOT_INDICES_North_dawnward--0stable--OMNI_GSM_Mar_30_15.sav', $
  ;;            'PLOT_INDICES_North_duskward--0stable--OMNI_GSM_Mar_30_15.sav']

  ;; ind_files=['PLOT_INDICES_North_dawnward--0stable--OMNI_GSM_plusminus30degclockAngle--Mar_30_15.sav', $
  ;;            'PLOT_INDICES_North_duskward--0stable--OMNI_GSM_plusminus30degclockAngle--Mar_30_15.sav']

  ;; ind_files = 'PLOT_INDICES_North_all_IMF--1stable--5min_IMFsmooth--OMNI_GSM_Mar_31_15.sav'

  FOR i=0,N_ELEMENTS(plot_i_list)-1 DO BEGIN

     KEY_SCATTERPLOTS_POLAPROJ, $
        DAYSIDE=dayside,NIGHTSIDE=nightside, $
        NORTH=north,SOUTH=south, $
        CHARESCR=chareScr,ABSMAGCSCR=absMagcScr, $
        OVERLAYAURZONE=overlayAurZone, $
        ADD_ORBIT_LEGEND=add_orbit_legend, $
        OVERPLOT=overplot, $
        CURRENT=current, $
        LAYOUT=layout, $
        PLOTPOSITION=plotPosition, $
        OUT_PLOT=out_plot, $
        OUT_WINDOW=out_window, $
        PLOTSUFF=plotSuff, $
        DBFILE=dbFile, $
        OUTFILE=outFile, $
        PLOT_I_FILE=plot_i_file, $
        PLOT_I_DIR=plot_i_dir, $
        JUST_PLOT_I=just_plot_i, $
        PLOT_I_LIST=plot_i_list, $
        COLOR_LIST=color_list, $
        STRANS=sTrans, $
        PLOTTITLE=plotTitle, $
        _EXTRA = e

  ENDFOR

END