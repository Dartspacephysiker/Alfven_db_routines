;2016/04/28 What orbits are involved?
PRO JOURNAL__20160428__PLOT_EVENT_VS_TIME_FOR_BIG_PFLUX_EVENTS__FOLLOW_THEM_DOWN

  ;;x axis
  do_orbits                = 1
  do_times                 = 0

  ;;y axis
  do_mlts                  = 1
  do_ilats                 = 0

  savePlot                 = 1

  symbol                   = 'o'
  sTransp                  = 95

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
  maxIArr                        = 90

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

  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbtime,/GET_GOOD_I,good_i=good_i,DO_DESPUNDB=do_despun

  ;; restrict_with_these_i          = WHERE()

  indices_list                   = LIST(CGSETINTERSECTION(good_i, $
                                                          WHERE(maximus.mlt GE minMArr[0] AND maximus.MLT LE maxMArr[0] $
                                                                AND maximus.pFluxEst GE pFluxMin $
                                                                AND maximus.alt GE altRange[0,0] AND maximus.alt LE altRange[1,0])))
  FOR i=1,N_ELEMENTS(minMArr)-1 DO BEGIN
     indices_list.add,CGSETINTERSECTION(good_i, $
                                        WHERE(maximus.mlt GE minMArr[i] AND maximus.MLT LE maxMArr[i] $
                                              AND maximus.pFluxEst GE pFluxMin  $
                                              AND maximus.alt GE altRange[0,i] AND maximus.alt LE altRange[1,i]))
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
  plotTitle     = STRING(FORMAT='("Big Poynting flux events (",I0,"-",I0," km)")',altRange[0,-1],altRange[1,0])

  nIndSets      = N_ELEMENTS(indices_list)
  plotArr       = MAKE_ARRAY(nIndSets,/OBJ)
  window        = WINDOW(WINDOW_TITLE=wTitle,DIMENSIONS=[1200,800])

  FOR i=0,nIndSets-1 DO BEGIN
     tempInds   = indices_list[i]

     CASE 1 OF
        KEYWORD_SET(do_orbits): BEGIN
           x          = maximus.orbit[indices_list[i]]
           xRange     = [500,16400]
           xTitle     = 'Orbit number'
           xString    = 'orbNum'
        END
        KEYWORD_SET(do_times): BEGIN
           x          = (cdbTime[tempInds]-cdbTime[0])/60./60./24./100.
           xRange     = [0,1200]
           xTitle     = 'Hundreds of days since ' + maximus.time[0]
           xString    = 'time'
        END
     ENDCASE

     CASE 1 OF
        KEYWORD_SET(do_mlts): BEGIN
           y          = maximus.mlt[tempInds]
           yTitle     = 'MLT'
           yRange     = [0,24]
           yString    = 'MLT'
        END
        KEYWORD_SET(DO_ilats): BEGIN
           y          = maximus.ilat[tempInds]
           yTitle     = 'ILAT'
           yRange     = [60,90]
           yString    = 'ILAT'
        END
     ENDCASE

     plotArr[i] = PLOT(x, $
                       y, $
                       NAME=fancyNames_for_sets_of_inds[i], $
                       TITLE=plotTitle, $
                       XRANGE=xRange, $
                       YRANGE=yRange, $
                       XTITLE=xTitle, $
                       YTITLE=yTitle, $
                       LINESTYLE='', $
                       FONT_SIZE=18, $
                       SYM_COLOR=plotColor[i], $
                       SYMBOL=symbol, $
                       SYM_TRANSPARENCY=sTransp, $
                       CURRENT=window, $
                       OVERPLOT=i GT 0)
                       
  ENDFOR

  legend         = LEGEND(TARGET=plotArr[*], $
                          POSITION=[0.8,0.8], $
                          ;; POSITION=[0.87/plotLayout[0],0.87], $
                          HORIZONTAL_ALIGNMENT=0.5, $
                          VERTICAL_SPACING=0.01, $
                          /NORMAL, $
                          /AUTO_TEXT_COLOR)


     
  IF KEYWORD_SET(savePlot) THEN BEGIN
     savePlotName = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + altStr + '--' + yString + '_vs_' + xString + '.png'
     PRINT,'saving ' + savePlotName + '...'
     window.save,savePlotName,RESOLUTION=300
  ENDIF
END

