PRO SIMPLE_STEREOGRAPHIC_SCATTERPLOT,lons,lats, $
                                     HEMI=hemi, $
                                     PLOTNAME=plotName, $
                                     COLOR_LIST=color_list, $
                                     OVERLAYAURZONE=overlayAurZone, $
                                     CENTERLON=centerLon, $
                                     OVERPLOT=overplot, $
                                     LAYOUT=layout, $
                                     PLOTPOSITION=plotPosition, $
                                     OUT_PLOT=out_plot, $
                                     OUTPLOTARR=outPlotArr, $
                                     ADD_LEGEND=add_legend, $
                                     CURRENT_WINDOW=window, $
                                     PLOTSUFF=plotSuff, $
                                     IN_MAP=map, $
                                     SAVEPLOT=savePlot, $
                                     SPNAME=sPName, $
                                     PLOTDIR=plotDir, $
                                     CLOSE_AFTER_SAVE=close_after_save, $
                                     HUGEPLOTMODE=hugePlotMode, $
                                     STRANS=sTrans, $
                                     PLOTTITLE=plotTitle, $
                                     ADD_LINE=add_line, $
                                     LINESTYLE=lineStyle, $
                                     NO_SYMBOL=no_symbol, $
                                     OUTPUT_ORBIT_DETAILS=output_orbit_details, $
                                     OUT_ORBSTRARR_LIST=out_orbStrArr_list, $
                                     OUT_WINDOW=out_window, $
                                     OUT_MAP=out_map, $
                                     _EXTRA=e

  COMPILE_OPT idl2

  ;; Defaults
  lun             = -1

  defMinI         = 68
  defMaxI         = 90
  
  defMinM         = 0
  defMaxM         = 24

  defTSLat        = 75 ;true-scale latitude

  @utcplot_defaults.pro

  defOutPref      = 'SIMPLE_STEREOGRAPHIC_SCATTERPLOT'
  defExt          = '.png'

  defPlot_i_dir   = 'plot_indices_saves/'

  defSTrans       = 50 ;use for plotting entire db
  defSym          = '*'
  defSymSize      = 1.0
  legendPosition  = [0.35,0.85]

  IF KEYWORD_SET(hugePlotMode) THEN BEGIN
     PRINT,'Huge plot mode ...'
     plotPosition  = [0.05,0.05,0.95,0.95]
  ENDIF

  IF N_ELEMENTS(sTrans) EQ 0 THEN BEGIN
     sTrans        = defSTrans
  ENDIF

  IF NOT KEYWORD_SET(plotSuff) THEN BEGIN
     plotSuff      = ""             ; ELSE plotSuff
  ENDIF

  IF NOT KEYWORD_SET(plot_i_dir) THEN BEGIN
     plot_i_dir    = defPlot_i_dir
  ENDIF

  IF minM EQ !NULL THEN BEGIN
     minM   = defMinM
  ENDIF
  IF maxM EQ !NULL THEN BEGIN
     maxM   = defMaxM
  ENDIF


  IF NOT KEYWORD_SET(north) AND NOT KEYWORD_SET(south) THEN BEGIN
     IF KEYWORD_SET(hemi) THEN BEGIN
        CASE 1 OF
           STRUPCASE(hemi) EQ 'NORTH': BEGIN
              north            = 1
              south            = 0
           END
           STRUPCASE(hemi) EQ 'SOUTH': BEGIN
              north            = 1
              south            = 0
              mirror_south     = 1
           END
           STRUPCASE(hemi) EQ 'BOTH': BEGIN
              north            = 1
              south            = 0
              mirror_south     = 1
           END
           ;; STRUPCASE(hemi) EQ 'SOUTH_MIRROR': BEGIN
           ;;    north         = 1
           ;;    south         = 0
           ;;    mirror_south  = 1
           ;; END
        ENDCASE
     ENDIF ELSE BEGIN
        PRINT,'No hemisphere provided! Assuming north...'
        hemi                   = 'NORTH'
        ;; north               = 1 ;default to northern hemi
     ENDELSE
  ENDIF

  IF ~KEYWORD_SET(centerLon) THEN BEGIN
     centerLon                 = (STRUPCASE(hemi) EQ 'SOUTH') ? 180 : 0
  ENDIF

  ;; Deal with map stuff
  CASE 1 OF
     KEYWORD_SET(north): BEGIN
        maxI       = defMaxI > MAX(lats[WHERE(lats GT 0)])
        minI       = defMinI < MIN(lats[WHERE(lats GT 0)])
        tsLat      = defTSLat
     END
     KEYWORD_SET(south): BEGIN
        maxI    = -defMinI > MAX(lats[WHERE(lats LT 0)])
        minI    = -defMaxI < MIN(lats[WHERE(lats LT 0)])
        tsLat   = -defTSLat
     END
     ELSE: BEGIN
        PRINT,"Gotta select a hemisphere, bro. I don't have time for this."
        WAIT,0.5
        RETURN
     END
  ENDCASE

  IF KEYWORD_SET(mirror) THEN BEGIN
     IF mirror NE 0 THEN BEGIN
        mirror  = 1 
     ENDIF ELSE BEGIN
        mirror  = 0
     ENDELSE
  ENDIF ELSE BEGIN
     mirror     = 0
  ENDELSE

  IF N_ELEMENTS(wholeCap) EQ 0 THEN BEGIN
     wholeCap   = 0
  ENDIF
  
  IF wholeCap THEN BEGIN
     lim = [ minI, 0, maxI, 360]  
  ENDIF ELSE BEGIN
     lim = [minI, minM*15, maxI, maxM*15]
  ENDELSE

  ;;****************************************
  ;; Now the rest of the stuff
  ;;HEMI stuff--clean it up
  ;; IF KEYWORD_SET(north) OR KEYWORD_SET(south) THEN BEGIN
  ;;    IF KEYWORD_SET(plot_i_list) THEN BEGIN
  ;;       modPlot_i_list                            = plot_i_list[*]
  ;;       IF KEYWORD_SET(north) THEN BEGIN
  ;;          IF KEYWORD_SET(mirror_south) THEN BEGIN
  ;;             FOR i=0,N_ELEMENTS(modPlot_i_list)-1 DO BEGIN
  ;;                modPlot_i_list[i]=CGSETINTERSECTION(modPlot_i_list[i], $
  ;;                                                    WHERE(ABS(maximus.ILAT) GT minI AND ABS(maximus.ILAT) LT maxI))
  ;;             ENDFOR
  ;;          ENDIF ELSE BEGIN
  ;;             FOR i=0,N_ELEMENTS(modPlot_i_list)-1 DO BEGIN
  ;;                modPlot_i_list[i]=CGSETINTERSECTION(modPlot_i_list[i], $
  ;;                                                    WHERE(maximus.ILAT GT minI AND maximus.ILAT LT maxI))
  ;;             ENDFOR
  ;;          ENDELSE
  ;;       ENDIF ELSE BEGIN
  ;;          IF KEYWORD_SET(SOUTH) THEN BEGIN
  ;;             FOR i=0,N_ELEMENTS(modPlot_i_list)-1 DO BEGIN
  ;;                modPlot_i_list[i]=CGSETINTERSECTION(modPlot_i_list[i], $
  ;;                                                    WHERE(maximus.ILAT GT minI AND maximus.ILAT LT maxI))
  ;;             ENDFOR
  ;;          ENDIF ELSE BEGIN
  ;;             FOR i=0,N_ELEMENTS(modPlot_i_list)-1 DO BEGIN
  ;;                modPlot_i_list[i]=CGSETINTERSECTION(modPlot_i_list[i], $
  ;;                                                    WHERE(ABS(maximus.ILAT) GT minI AND ABS(maximus.ILAT) LT maxI))
  ;;             ENDFOR
  ;;          ENDELSE
  ;;       ENDELSE
  ;;    ENDIF ELSE BEGIN
  ;;    ENDELSE
  ;; ENDIF

  ;;Get rid of -1 stuffs
  ;; junk_i                                          = !NULL
  ;; FOR i=0,N_ELEMENTS(modPlot_i_list)-1 DO BEGIN
  ;;    IF (modPlot_i_list[i])[0] EQ -1 THEN BEGIN
  ;;       junk_i                                    = [junk_i,i] 
  ;;    ENDIF
  ;; ENDFOR
  ;; IF N_ELEMENTS(junk_i) GE 1 THEN BEGIN
  ;;    PRINT,'Some bad indices here! Going to remove them...'
  ;;    ;; STOP
  ;;    modPlot_i_list.REMOVE,junk_i
  ;; ENDIF


  IF ~ISA(window) THEN BEGIN
     window                                       = WINDOW(DIMENSIONS=[900,900])
  ENDIF ELSE BEGIN
     window.setCurrent
  ENDELSE

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Set up a map
  ;;Polar Stereographic
  ;;SEMIMAJOR_AXIS, SEMIMINOR_AXIS, CENTER_LONGITUDE, TRUE_SCALE_LATITUDE, FALSE_EASTING, FALSE_NORTHING
  IF N_ELEMENTS(map) EQ 0 THEN BEGIN
     map         = MAP('Polar Stereographic', $
                       CENTER_LONGITUDE=centerLon, $
                       TRUE_SCALE_LATITUDE=tsLat, $
                       LIMIT=lim, $
                       LABEL_FORMAT='polar_maplabels', $
                       FILL_COLOR="white", $
                       DIMENSIONS=KEYWORD_SET(plotPosition) ? !NULL : [100,100], $
                       OVERPLOT=overplot, $
                       
                       ;; WINDOW=window, $
                       CURRENT=window, $
                       POSITION=plotPosition, $
                       LAYOUT=layout)
     
     ;; Change some grid properties.
     grid                        = map.MAPGRID
     IF KEYWORD_SET(north) THEN BEGIN
        grid.LATITUDE_MIN        = minI
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(south) THEN BEGIN
           grid.LATITUDE_MAX     = maxI
        ENDIF
     ENDELSE
     grid.TRANSPARENCY           = 0
     grid.color                  = "black"
     grid.linestyle              = 0
     grid.thick                  = 2.0
     grid.label_angle            = 0
     grid.font_size              = KEYWORD_SET(hugePlotMode) ? 24 : 16
     
     ;;Grid line spacing
     grid.grid_longitude         = 90
     grid.grid_latitude          = 10

     mlats                       = grid.latitudes
     FOR i=0,n_elements(mlats)-1 DO BEGIN
        mlats[i].label_position  = 0.55
        mlats[i].label_valign    = 1.0
     ENDFOR
     
     mlons                       = grid.longitudes

     FOR i=0,n_elements(mlons)-1 DO BEGIN
        mlons[i].label_position  = KEYWORD_SET(south) ? 1.0 : 0.02
        IF STRMATCH(mlons[i].name,'*5*') $ ;Kill lines at 3,9,15,21
        THEN BEGIN
           mlons[i].label_show   = 0
        ENDIF
        
     ENDFOR
     
     ;; Add auroral zone to plot?
     IF KEYWORD_SET(overlayAurZone) THEN BEGIN
        
        ;;get boundaries
        nMLTs                    = 96
        activity_level           = 7
        MLTs                     = INDGEN(nMLTs,/FLOAT)*(maxM-minM)/nMLTs+minM
        bndry_eqWard             = GET_AURORAL_ZONE(nMLTs,minM,maxM,BNDRY_POLEWARD=bndry_poleWard,ACTIVITY_LEVEL=activity_level,SOUTH=south)
        aurEqWardPlot            = PLOT([MLTS,MLTs[0]]*15,[bndry_eqWard,bndry_eqWard[0]],LINESTYLE='-', THICK=2.5,/overplot)
        aurPoleWardPlot          = PLOT([MLTS,MLTs[0]]*15,[bndry_poleWard,bndry_poleWard[0]],LINESTYLE='-', THICK=2.5,/overplot)
        
     ENDIF
  ENDIF

  IF KEYWORD_SET(hemi) THEN BEGIN
     north_i        = WHERE(lats GE 0,nNorth,COMPLEMENT=south_i,NCOMPLEMENT=nSouth)
     CASE STRUPCASE(hemi) OF
        'NORTH': BEGIN
           IF nNorth GT 0 THEN BEGIN
              plotLons = lons[north_i]
              plotLats = lats[north_i]
           ENDIF ELSE BEGIN
              PRINT,"No NORTH inds! Out." 
              RETURN
           ENDELSE
        END
        'SOUTH': BEGIN
           IF nSouth GT 0 THEN BEGIN
              plotLons = lons[south_i]
              plotLats = lats[south_i]
           ENDIF ELSE BEGIN
              PRINT,"No SOUTH inds! Out." 
              RETURN
           ENDELSE
        END
        'BOTH': BEGIN
           IF nNorth GT 0 AND nSouth GT 0 THEN BEGIN
              plotLons = lons
              plotLats = lats
              plotLats[south_i] = ABS(plotLats[south_i])
           ENDIF ELSE BEGIN
              CASE 1 OF
                 nNorth GT 0: BEGIN
                    plotLons = lons[north_i]
                    plotLats = lats[north_i]
                 END
                 nSouth GT 0: BEGIN
                    plotLons = lons[south_i]
                    plotLats = lats[south_i]
                 END
              ENDCASE
           ENDELSE
        END
     ENDCASE
  ENDIF

  CASE 1 OF
     (KEYWORD_SET(no_symbol) OR KEYWORD_SET(add_line)): BEGIN
        curPlot = PLOT(plotLons,plotLats, $
                       NAME=plotName, $
                       SYM_SIZE=KEYWORD_SET(no_symbol) ? !NULL : defSymSize, $
                       SYMBOL=KEYWORD_SET(no_symbol) ? !NULL : defSym, $
                       /OVERPLOT, $
                       LINESTYLE=lineStyle, $
                       THICK=2.0, $
                       SYM_TRANSPARENCY=sTrans, $ 
                       SYM_THICK=1.5, $
                       SYM_COLOR=(N_ELEMENTS(color_list) GT 0) ? color_list[0] : color_list, $
                       COLOR=(N_ELEMENTS(color_list) GT 0) ? color_list[0] : color_list, $
                       CURRENT=window, $
                       POSITION=plotPosition, $
                       LAYOUT=layout)
     END
     ELSE: BEGIN
        curPlot = SCATTERPLOT(plotLons,plotLats, $
                              NAME=plotName, $
                              SYM_SIZE=defSymSize, $
                              SYMBOL=KEYWORD_SET(no_symbol) ? !NULL : defSym, $
                              /OVERPLOT, $
                              SYM_TRANSPARENCY=sTrans, $ 
                              SYM_THICK=1.5, $
                              SYM_COLOR=(N_ELEMENTS(color_list) GT 0) ? $
                              color_list[0] : color_list, $
                              CURRENT=MAP, $
                              LAYOUT=layout)
     END
  ENDCASE


  IF KEYWORD_SET(plotTitle) THEN BEGIN
     plotTitleText      = TEXT(0.5,0.9,plotTitle, $
                               /NORMAL, $
                               FONT_SIZE=KEYWORD_SET(hugePlotMode) ? 28 : 18, $
                               ALIGNMENT=0.5)
  ENDIF

  outPlotArr            = N_ELEMENTS(outPlotArr) GT 0 ? [outPlotArr,curPlot] : curPlot

  IF KEYWORD_SET(add_legend) THEN BEGIN
     legend = LEGEND(TARGET=outPlotArr[*], $
                     /NORMAL, $
                     POSITION=legendPosition, $
                     /AUTO_TEXT_COLOR)

  ENDIF

  IF KEYWORD_SET(savePlot) THEN BEGIN
     IF ~KEYWORD_SET(sPName) THEN sPName = 'scatterplot_polarProj.png'

     IF ~KEYWORD_SET(plotDir) THEN SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY
     outFileName            = plotDir + sPName
     PRINT,'Saving scatterplot to ' + outFileName + '...'
     window.save,plotDir + sPName,RESOLUTION=defRes

     IF KEYWORD_SET(close_after_save) THEN BEGIN
        window.Close
        window = !NULL
     ENDIF
  ENDIF

  ;; IF ISA(curPlot) THEN out_plot        = curPlot
  IF ISA(window ) THEN out_window  = window
  IF ISA(map    ) THEN out_map     = map

END