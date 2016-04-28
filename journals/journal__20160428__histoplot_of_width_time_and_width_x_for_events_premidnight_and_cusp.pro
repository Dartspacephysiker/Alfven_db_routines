;2016/04/28 Been reading Lühr et al. [2004], and I'd like to see if we see bigger FAC widths in the cusp vs. outside
PRO JOURNAL__20160428__HISTOPLOT_OF_WIDTH_TIME_AND_WIDTH_X_FOR_EVENTS_PREMIDNIGHT_AND_CUSP

  close_after_save          = 1
  ;; pFluxMin                 = 5

  ;; altRange                 = [[0,4180], $
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

  altRange                 = [[340,1180], $
                              [1180,2180], $
                              [2180,3180], $
                              [3180,4180]]

  ;; altRange                 = [[3675,4175]]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff
  maxIndArr                = [20,21]
  xRangeArr                = ALOG10([[1.5e-2,2.5], $
                              [1e2,1e4]])
  xTitleArr                = ['Filament width (s)','Filament width (m)']
  yTitle                   = 'Relative frequency'
  ;; yRangeArr                = [[1e-2,2.5], $
  ;;                             [1e0,1e4]]
  binsizeArr               = [0.075,0.075]
  logArr                   = [1,1] ;log 'em both

  ;; yRange                   = [0,6000]
  normalize_maxInd_hist    = 1
  yRange                   = [0,0.35]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILAT stuff
  hemi                           = 'NORTH'
  minIArr                        = 60
  maxIArr                        = 84

  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -86
  ;; maxILAT                        = -61

  ;; binILAT                        = 2.0
  binILAT                        = 3.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLT stuff
  binMLT                         = 2.0
  minMArr                        = [10,20,02]
  maxMArr                        = [14,24,06]

  disregard_mlt_for_good_i_selection = 1
  ;; shiftMLT                       = 0.5

  ;;DB stuff
  do_despun                      = 1

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=do_despun

  ;; restrict_with_these_i          = WHERE(maximus.pFluxEst GE pFluxMin)

  ;; cusp_i                         = CGSETINTERSECTION(restrict_with_these_i, $
  ;;                                                    WHERE(maximus.mlt GE minMArr[0] AND maximus.mlt LE maxMArr[0]))
  ;; premidnight_i                      = CGSETINTERSECTION(restrict_with_these_i, $
  ;;                                                    WHERE(maximus.mlt GE minMArr[1] AND maximus.mlt LE maxMArr[1]))
  ;; predawn_i                     = CGSETINTERSECTION(restrict_with_these_i, $
  ;;                                                    WHERE(maximus.mlt GE minMArr[2] AND maximus.mlt LE maxMArr[2]))
  cusp_i                         = WHERE(maximus.mlt GE minMArr[0] AND maximus.mlt LE maxMArr[0])
  premidnight_i                  = WHERE(maximus.mlt GE minMArr[1] AND maximus.mlt LE maxMArr[1])
  predawn_i                     = WHERE(maximus.mlt GE minMArr[2] AND maximus.mlt LE maxMArr[2])
  
  indices_list                   = LIST(cusp_i,premidnight_i,predawn_i)
  ;; names_for_sets_of_inds         = ['Dayside','Nightside']
  ;; fancyNames_for_sets_of_inds    = ['Dayside','Nightside']
  names_for_sets_of_inds         = ['Cusp','pre-midnight','pre-dawn']
  fancyNames_for_sets_of_inds    = ['Cusp (10-14 MLT)','Pre-midnight (20-24 MLT)','Pre-dawn (2-6 MLT)']
  plotColor                      = ['red','black','blue']
  plotLinestyle                  = ['-','--','--']
  FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN
     altitudeRange = altRange[*,i]
     ;; altStr        = STRING(FORMAT='("--",I0,"-",I0,"km")',altitudeRange[0],altitudeRange[1]) + '--pFlux_GE_'+STRCOMPRESS(pFluxMin,/REMOVE_ALL)
     altStr        = STRING(FORMAT='("--",I0,"-",I0,"km")',altitudeRange[0],altitudeRange[1])+'--cusp_premidnight_predawn' $
                     + (KEYWORD_SET(normalize_maxInd_hist) ? '--normalized' : '')
     ;; tilePlotTitle = STRING(FORMAT='(I0,"-",I0," km, Poynting flux $\geq$ ",I0," mW m!U-2!N")',altitudeRange[0],altitudeRange[1],pFluxMin)
     plotTitle     = STRING(FORMAT='(I0,"-",I0," km")',altitudeRange[0],altitudeRange[1])

     FOR max_i=0,N_ELEMENTS(maxIndArr)-1 DO BEGIN
        maxInd     = maxIndArr[max_i]
        xRange     = xRangeArr[*,max_i]
        ;; yRange     = yRangeArr[*,max_i]
        xTitle     = xTitleArr[max_i]
        ;; yTitle     = yTitleArr[max_i]
        binsize    = binSizeArr[max_i]
        log_DBQuantity = logArr[max_i]
        minM       = minMArr[max_i]
        maxM       = maxMArr[max_i]
        ;; minI       = minIArr[max_i]
        ;; maxI       = maxIArr[max_i]
        minI       = minIArr
        maxI       = maxIArr

        HISTOPLOT_ALFVENDBQUANTITIES__INDICES__OVERLAID, $
           indices_list, $
           DAYSIDE=dayside,NIGHTSIDE=nightside, $
           HEMI=hemi, $
           LAYOUT=layout, $
           MAXIND=maxInd, $
           CUSTOM_MAXIND=custom_maxInd, $
           CUSTOM_MAXNAME=custom_maxName, $
           NORMALIZE_MAXIND_HIST=normalize_maxInd_hist, $
           HISTXRANGE_MAXIND=xRange, $
           HISTXTITLE_MAXIND=xTitle, $
           HISTYRANGE_MAXIND=yRange, $
           HISTYTITLE__ONLY_ONE=yTitle__only_one, $
           HISTBINSIZE_MAXIND=binsize, $
           DIVIDE_BY_WIDTH_X=divide_by_width_x, $
           MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
           ONLY_POS=only_pos, $
           ONLY_NEG=only_neg, $
           ABSVAL=absVal, $
           AVG_TYPE_MAXIND=avg_type_maxInd, $
           RESTRICT_ALTRANGE=altitudeRange, $
           RESTRICT_CHARERANGE=restrict_charERange, $
           LOG_DBQUANTITY=log_DBQuantity, $
           DO_UNLOGGED_STATISTICS=unlog_statistics, $
           DO_LOGGED_STATISTICS=log_statistics, $
           DO_BOOTSTRAP_MEDIAN=bootstrap_median, $
           TBINS=tBins, $
           DBFILE=dbFile,DB_TFILE=db_tFile, $
           USE_DARTDB_START_ENDDATE=use_dartdb_start_enddate, $
           DO_DESPUNDB=do_despundb, $
           SAVEFILE=saveFile, $
           SAVEDIR=saveDir, $
           PLOTTITLE=plotTitle, $
           /SAVEPLOT, $
           CLOSE_AFTER_SAVE=close_after_save, $
           ;; SAVEPNAME=savePName, $
           RANDOMTIMES=randomTimes, $
           MINMLT=minM, $
           MAXMLT=maxM, $
           BINM=binM, $
           MINILAT=minI, $
           MAXILAT=maxI, $
           BINI=binI, $
           DISREGARD_MLT_FOR_GOOD_I_SELECTION=disregard_mlt_for_good_i_selection, $
           DISREGARD_ILAT_FOR_GOOD_I_SELECTION=disregard_ilat_for_good_i_selection, $
           DISREGARD_REGION_FOR_GOOD_I_SELECTION=disregard_region_for_good_i_selection, $
           DO_LSHELL=do_lshell, $
           MINLSHELL=minL, $
           MAXLSHELL=maxL, $
           BINL=binL, $
           SUFF_DATANAME=altStr, $
           NAMES_FOR_SETS_OF_INDS=names_for_sets_of_inds, $
           FANCYNAMES_FOR_SETS_OF_INDS=fancyNames_for_sets_of_inds, $
           PLOTSUFFIX=altStr, $
           PLOTCOLOR=plotColor, $
           PLOTLINESTYLE=plotLinestyle, $
           OUTPLOTARR=outPlotArr, $
           ;; HISTOPLOT_PARAM_STRUCT=pHP, $
           /NO_STATISTICS_TEXT, $
           NO_LEGEND=no_legend, $
           ;; OVERPLOTARR=overplotArr, $
           ;; CURRENT_WINDOW=window, $
           FILL_BACKGROUND=fill_background, $
           FILL_TRANSPARENCY=fill_transparency, $
           FILL_COLOR=fill_color     

        
     ENDFOR
  ENDFOR
END

