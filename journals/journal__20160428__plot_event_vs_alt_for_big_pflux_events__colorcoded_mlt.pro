;2016/04/28 What orbits are involved?
PRO JOURNAL__20160428__PLOT_EVENT_VS_ALT_FOR_BIG_PFLUX_EVENTS__COLORCODED_MLT

  ;;x axis
  do_orbits                = 1
  do_times                 = 0

  ;;y axis
  do_alts                  = 1
  do_ilats                 = 0

  savePlot                 = 0

  symbol                   = '.'
  sTransp                  = 98

  pFluxMin                 = 5
  pFluxMax                 = 10

  ;; altRange                 = [[3680,4180], $
  ;;                             [3180,3680], $
  ;;                             [2680,3180], $
  ;;                             [2180,2680], $
  ;;                             [1680,2180], $
  ;;                             [1180,1680], $
  ;;                             [ 680,1180], $
  ;;                             [ 340, 680]]

  ;; mltRange                 = [TRANSPOSE(INDGEN(8)*3),TRANSPOSE(INDGEN(8)*3+3)]
  mltRange                 = [TRANSPOSE(REVERSE(INDGEN(8)*3)),TRANSPOSE(REVERSE(INDGEN(8)*3+3))]
  mltRange                 = [TRANSPOSE(REVERSE(INDGEN(4)*6)),TRANSPOSE(REVERSE(INDGEN(4)*6+6))]


  ;; altRange                 = [[3180,4180], $
  ;;                             [2180,3180], $
  ;;                             [1180,2180], $
  ;;                             [340,1180]]

  ;; altRange                 = [[3675,4175]]

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
  nMlts                          = N_ELEMENTS(mltRange[0,*])

  ;;DB stuff
  do_despun                      = 1

  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbtime,/GET_GOOD_I,good_i=good_i,DO_DESPUNDB=do_despun

  restrict_with_these_i          = WHERE(maximus.pFluxEst GE pFluxMin AND maximus.pFluxEst LE pFluxMax)

  good_i                         = CGSETINTERSECTION(good_i,restrict_with_these_i)
  indices_list                   = LIST(CGSETINTERSECTION(good_i, $
                                                          WHERE(maximus.mlt GE mltRange[0,0] AND maximus.mlt LE mltRange[1,0])))
  FOR i=1,N_ELEMENTS(mltRange[0,*])-1 DO BEGIN
     indices_list.add,CGSETINTERSECTION(good_i, $
                                        WHERE(maximus.mlt GE mltRange[0,i] AND maximus.mlt LE mltRange[1,i]))
  ENDFOR

  names_for_sets_of_inds         = STRCOMPRESS(mltRange[0,*],/REMOVE_ALL)+'-'+STRCOMPRESS(mltRange[1,*],/REMOVE_ALL) + 'MLT'
                                   ;; + '--'+STRING(FORMAT='(F0.2)',minMArr)+'-'+STRING(FORMAT='(F0.2)',maxMArr) + 'MLT'
                                   ;; + '--' + STRCOMPRESS(minMArr,/REMOVE_ALL)+'-'+STRCOMPRESS(maxMArr,/REMOVE_ALL) + 'MLT'

  fancyNames_for_sets_of_inds    = STRCOMPRESS(mltRange[0,*],/REMOVE_ALL)+'-'+STRCOMPRESS(mltRange[1,*],/REMOVE_ALL) + ' MLT' 
                                   ;; + STRING(FORMAT='(F0.2)',minMArr)+'-'+STRING(FORMAT='(F0.2)',maxMArr) + ' MLT'
                                   ;; + STRCOMPRESS(minMArr,/REMOVE_ALL)+'-'+STRCOMPRESS(maxMArr,/REMOVE_ALL) + ' MLT'

  plotColor                      = nMlts GT 4 ? ['red','gold','green yellow','lime green','green','blue','purple','black'] $
                                              : ['red','purple','blue','black']
  ;; plotLinestyle                  = ['--','--','--','--']
  plotLinestyle                  = REPLICATE('-',nMlts)

  mltStr        = STRING(FORMAT='("--",I0,"-",I0,"km")',mltRange[0,-1],mltRange[1,0]) $
                  + '--pFlux_GE_'+STRCOMPRESS(pFluxMin,/REMOVE_ALL) +'--all_altitudes' $
                  + (KEYWORD_SET(normalize_maxInd_hist) ? '--normalized' : '')
  plotTitle     = STRING(FORMAT='("Events with Poynting flux GE ",F0.1," mW/m$^2$ (",I0,"-",I0," MLT)")',pFluxMin,mltRange[0,-1],mltRange[1,0])

  nIndSets      = N_ELEMENTS(indices_list)
  plotArr       = MAKE_ARRAY(nIndSets,/OBJ)
  window        = WINDOW(WINDOW_TITLE=wTitle,DIMENSIONS=[1200,800])

  FOR i=0,nIndSets-1 DO BEGIN
     tempInds   = indices_list[i]
     PRINT,'N events for mlt range ' + STRCOMPRESS(mltRange[0,i],/REMOVE_ALL) + '-' + STRCOMPRESS(mltRange[1,i],/REMOVE_ALL) + ': ' + STRCOMPRESS(N_ELEMENTS(tempInds),/REMOVE_ALL)

     CASE 1 OF
        KEYWORD_SET(do_orbits): BEGIN
           x          = maximus.orbit[indices_list[i]]
           xRange     = [500,16400]
           xTitle     = 'Orbit number'
           xString    = 'orbNum'
        END
        KEYWORD_SET(do_times): BEGIN
           x          = (cdbTime[tempInds]-cdbTime[0])/60./60./24./100.
           xRange     = [0,10]
           xTitle     = 'Hundreds of days since ' + maximus.time[0]
           xString    = 'time'
        END
     ENDCASE

     CASE 1 OF
        KEYWORD_SET(do_alts): BEGIN
           y          = maximus.alt[tempInds]/1000.
           yTitle     = 'Altitude (km)'
           yRange     = [0.34,4.2]
           yString    = 'altitude'
        END
        KEYWORD_SET(do_ilats): BEGIN
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
                       SYM_SIZE=3.0, $
                       SYM_THICK=1.5, $
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
     savePlotName = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + mltStr + '--' + yString + '_vs_' + xString + '.png'
     PRINT,'saving ' + savePlotName + '...'
     window.save,savePlotName,RESOLUTION=300
  ENDIF
END

