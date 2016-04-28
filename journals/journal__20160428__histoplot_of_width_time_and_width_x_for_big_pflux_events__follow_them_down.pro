;2016/04/28 What happens if I focus on the big pFlux events?
PRO JOURNAL__20160428__HISTOPLOT_OF_WIDTH_TIME_AND_WIDTH_X_FOR_BIG_PFLUX_EVENTS__FOLLOW_THEM_DOWN

  close_after_save         = 1
  pFluxMin                 = 5

  altRange                 = [[3680,4180], $
                              [3180,3680], $
                              [2680,3180], $
                              [2180,2680], $
                              [1680,2180], $
                              [1180,1680], $
                              [ 680,1180], $
                              [ 340, 680]]

  ;; altRange                 = [[3180,4180], $
  ;;                             [2180,3180], $
  ;;                             [1180,2180], $
  ;;                             [340,1180]]

  ;; altRange                 = [[3675,4175]]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff
  maxIndArr                = [20,21]
  xRangeArr                = ALOG10([[1.5e-2,2.5], $
                              [1e2,1e4]])
  xTitleArr                = ['Filament width (s)','Filament width (m)'] ;,'Electron energy flux (mW/m!U2!N)']
  yTitle                   = 'Relative frequency'
  ;; yRangeArr                = [[1e-2,2.5], $
  ;;                             [1e0,1e4]]
  binsizeArr               = [0.075,0.075]
  logArr                   = [1,1] ;log 'em both

  yRange                   = [0,5000]
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
  topMLT                         = 12
  bottomMLT                      = 06
  ;; minMArr                        = [08,07,06,05,04,03,02]
  ;; maxMArr                        = [12,11,10,09,08,07,06]
  nAlts                          = N_ELEMENTS(altRange[0,*])
  maxMArr                        = REVERSE(INDGEN(nAlts)*(topMLT-bottomMLT)/FLOAT(nAlts-1))+bottomMLT
  minMArr                        = maxMArr-4

  disregard_mlt_for_good_i_selection = 1
  ;; shiftMLT                       = 0.5

  ;;DB stuff
  do_despun                      = 1

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=do_despun

  ;; restrict_with_these_i          = WHERE()

  indices_list                   = LIST(WHERE(maximus.mlt GE minMArr[0] AND maximus.MLT LE maxMArr[0] $
                                              AND maximus.pFluxEst GE pFluxMin $
                                              AND maximus.alt GE altRange[0,0] AND maximus.alt LE altRange[1,0]))
  FOR i=1,N_ELEMENTS(minMArr)-1 DO BEGIN
     indices_list.add,WHERE(maximus.mlt GE minMArr[i] AND maximus.MLT LE maxMArr[i] $
                            AND maximus.pFluxEst GE pFluxMin  $
                                              AND maximus.alt GE altRange[0,i] AND maximus.alt LE altRange[1,i])
  ENDFOR

  names_for_sets_of_inds         = STRCOMPRESS(altRange[0,*],/REMOVE_ALL)+'-'+STRCOMPRESS(altRange[1,*],/REMOVE_ALL) + 'km' $
                                   + '--'+STRING(FORMAT='(F0.2)',minMArr)+'-'+STRING(FORMAT='(F0.2)',maxMArr) + 'MLT'
                                   ;; + '--' + STRCOMPRESS(minMArr,/REMOVE_ALL)+'-'+STRCOMPRESS(maxMArr,/REMOVE_ALL) + 'MLT'
  fancyNames_for_sets_of_inds    = STRCOMPRESS(altRange[0,*],/REMOVE_ALL)+'-'+STRCOMPRESS(altRange[1,*],/REMOVE_ALL) + ' km, ' $
                                   + STRING(FORMAT='(F0.2)',minMArr)+'-'+STRING(FORMAT='(F0.2)',maxMArr) + ' MLT'
                                   ;; + STRCOMPRESS(minMArr,/REMOVE_ALL)+'-'+STRCOMPRESS(maxMArr,/REMOVE_ALL) + ' MLT'
  plotColor                      = nAlts GT 4 ? ['red','orange red','dark orange','gold','green yellow','lime green','blue','black'] $
                                              : ['red','purple','blue','black']
  ;; plotLinestyle                  = ['--','--','--','--']
  plotLinestyle                  = REPLICATE('-',nAlts)

  altStr        = STRING(FORMAT='("--",I0,"-",I0,"km")',altRange[0,-1],altRange[1,0]) $
                  + '--pFlux_GE_'+STRCOMPRESS(pFluxMin,/REMOVE_ALL) +'--follow_big_pflux_down' $
                  + (KEYWORD_SET(normalize_maxInd_hist) ? '--normalized' : '')
  plotTitle     = STRING(FORMAT='(I0,"-",I0," km")',altRange[0,-1],altRange[1,0])

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

END
