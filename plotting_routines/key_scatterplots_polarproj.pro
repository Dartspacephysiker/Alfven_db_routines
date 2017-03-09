;+
; NAME: KEY_SCATTERPLOTS_POLARPROJ
;
;
;
; PURPOSE: Get a sense for what's happening in a given database. Specifically, the key data products I'm picking here are
;          -> alt                  (altitude)
;          -> mag_current          (Yep, current derived from magnetometer)
;          -> elec_energy_flux     (electron energy flux)
;          -> delta_b              (peak-to-peak of the max magnetic field fluctuation)
;          -> delta_e              (peak-to-peak of the max electric field fluctuation)
;          -> max_chare_losscone   (Max characteristic energy in the losscone)
;          -> pfluxEst             (Poynting flux estimate)
;            
;          Could also mess around with
;          -> width_x              (width of filament along spacecraft trajectory)
;          -> width_time           (temporal width)
;
; CATEGORY: Are you serious? Everyone knows the answer to this.
;
;
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; PROCEDURE:
;
; EXAMPLE:
;
; MODIFICATION HISTORY: 2015/03/27      Birth
;                       2016/03/21      Added ADD_ORBIT_LEGEND, PLOTPOSITION, OUT_PLOT, OUT_WINDOW, OVERPLOT keywords. 
;                                       Lots of little edits otherwise.
;                                       
;                       
;-

PRO KEY_SCATTERPLOTS_POLARPROJ,MAXIMUS=maximus, $
                               DO_DESPUNDB=do_despunDB, $
                               DAYSIDE=dayside,NIGHTSIDE=nightside, $
                               HEMI=hemi, $
                               NORTH=north,SOUTH=south, $
                               CHARESCR=chareScr,ABSMAGCSCR=absMagcScr, $
                               OVERLAYAURZONE=overlayAurZone, $
                               CENTERLON=centerLon, $
                               OVERPLOT=overplot, $
                               LAYOUT=layout, $
                               PLOTPOSITION=plotPosition, $
                               OUT_PLOT=out_plot, $
                               CURRENT_WINDOW=window, $
                               PLOTSUFF=plotSuff, $
                               DBFILE=dbFile, $
                               PLOT_I_FILE=plot_i_file, PLOT_I_DIR=plot_i_dir, $
                               JUST_PLOT_I=just_plot_i, $
                               PLOT_I_LIST=plot_i_list, COLOR_LIST=color_list, $
                               IN_ORBSTRARR_LIST=in_orbStrArr_list, $
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
                               ADD_ORBIT_LEGEND=add_orbit_legend, $
                               OUTPUT_ORBIT_DETAILS=output_orbit_details, $
                               OUT_ORBSTRARR_LIST=out_orbStrArr_list, $
                               OUT_WINDOW=out_window, $
                               OUT_MAP=out_map, $
                               _EXTRA = e

  COMPILE_OPT idl2,strictarrsubs

  ;; Defaults
  defMinI = 60
  defMaxI = 86
  
  defMinM = 0
  defMaxM = 24

  defTSLat = 75                 ;true-scale latitude

  @utcplot_defaults.pro

  defOutPref = 'scatterplots_polarproj'
  defExt = '.png'

  defPlot_i_dir = 'plot_indices_saves/'

  defSTrans = 98                ;use for plotting entire db
  ;; defSTrans = 95                ;use for very narrowed plot_i

  IF KEYWORD_SET(hugePlotMode) THEN BEGIN
     PRINT,'Huge plot mode ...'
     plotPosition = [0.05,0.05,0.95,0.95]
  ENDIF

  IF N_ELEMENTS(sTrans) EQ 0 THEN sTrans = defSTrans

  ;; IF ~KEYWORD_SET(outDir) THEN SET_PLOT_DIR,outDir,/FOR_ALFVENDB, $
  ;;                                           FOR_STORMS=for_storms, $
  ;;                                           FOR_SW_IMF=for_sw_imf, $
  ;;                                           /ADD_TODAY, $
  ;;                                           /VERBOSE

  IF NOT KEYWORD_SET(plotSuff) THEN plotSuff = "" ; ELSE plotSuff
  ;; IF SIZE(outFile,/TYPE) NE 0 AND SIZE(outFile,/TYPE) NE 7 AND NOT KEYWORD_SET(plot_i_file) THEN $
  ;;    outFile = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--' + defOutPref + plotSuff + defExt ;otherwise handled by plot_i_file
  ;; plotSuff = "--Dayside--6-18MLT--60-84ILAT--4-250CHARE"

  IF NOT KEYWORD_SET(plot_i_dir) THEN plot_i_dir = defPlot_i_dir

  IF minM EQ !NULL THEN minM = defMinM
  IF maxM EQ !NULL THEN maxM = defMaxM
  ;; minM = 0
  ;; maxM = 24

  IF NOT KEYWORD_SET(north) AND NOT KEYWORD_SET(south) THEN BEGIN
     IF KEYWORD_SET(hemi) THEN BEGIN
        CASE 1 OF
           STRUPCASE(hemi) EQ 'NORTH': BEGIN
              north = 1
              south = 0
           END
           ;; STRUPCASE(hemi) EQ 'SOUTH': BEGIN
           ;;    north = 0
           ;;    south = 1
           ;; END
           STRUPCASE(hemi) EQ 'SOUTH': BEGIN
              north = 1
              south = 0
              mirror_south = 1
           END
           STRUPCASE(hemi) EQ 'BOTH': BEGIN
              north = 1
              south = 0
              mirror_south = 1
           END
           ;; STRUPCASE(hemi) EQ 'SOUTH_MIRROR': BEGIN
           ;;    north = 1
           ;;    south = 0
           ;;    mirror_south = 1
           ;; END
        ENDCASE
     ENDIF ELSE BEGIN
        PRINT,'No hemisphere provided! Assuming north...'
        north = 1               ;default to northern hemi
     ENDELSE
  ENDIF

  IF ~KEYWORD_SET(centerLon) THEN BEGIN
     centerLon=KEYWORD_SET(south) ? 180 : 0
  ENDIF

  lun=-1

  ;; Deal with map stuff
  IF KEYWORD_SET(north) THEN BEGIN
     maxI=defMaxI
     minI=defMinI
     tsLat=defTSLat
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(south) THEN BEGIN
        maxI=-defMinI
        minI=-defMaxI
        tsLat=-defTSLat
     ENDIF ELSE BEGIN
        PRINT,"Gotta select a hemisphere, bro"
        WAIT,0.5
        RETURN
     ENDELSE
  ENDELSE

  IF KEYWORD_SET(mirror) THEN BEGIN
     IF mirror NE 0 THEN mirror = 1 ELSE mirror = 0
  ENDIF ELSE mirror = 0

  IF KEYWORD_SET(wholeCap) THEN BEGIN
     IF wholeCap EQ 0 THEN wholeCap=!NULL
  ENDIF
  IF KEYWORD_SET(midnight) THEN BEGIN
     IF midnight EQ 0 THEN midnight=!NULL
  ENDIF
  
  IF wholeCap NE !NULL THEN BEGIN
     lim=[ minI, 0, maxI, 360]  ; lim = [minimum lat, minimum long, maximum lat, maximum long]
  ENDIF ELSE BEGIN
     lim=[minI, minM*15, maxI, maxM*15]
  ENDELSE

  ;;****************************************
  ;; Now the rest of the stuff

  IF N_ELEMENTS(maximus) EQ 0 THEN BEGIN
     LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime, $
                              DB_TFILE=DB_tFile, $
                              DBDIR=DBDir, $
                              DBFILE=DBFile, $
                              DO_DESPUNDB=do_despunDB, $
                              USING_HEAVIES=using_heavies
  ENDIF

  IF KEYWORD_SET(plot_i_file) THEN BEGIN
     restore,plot_i_dir+plot_i_file
     printf,lun,""
     printf,lun,"**********DATA SUMMARY**********"
     print,lun,"DBFile: " + dbFile
     printf,lun,satellite+" satellite data delay: " + strtrim(delay,2) + " seconds"
     printf,lun,"IMF stability requirement: " + strtrim(stableIMF,2) + " minutes"
     ;; printf,lun,"Events per bin requirement: >= " +strtrim(maskMin,2)+" events"
     printf,lun,"Screening parameters: [Min] [Max]"
     printf,lun,"Mag current: " + strtrim(maxNEGMC,2) + " " + strtrim(minMC,2)
     printf,lun,"MLT: " + strtrim(minM,2) + " " + strtrim(maxM,2)
     printf,lun,"ILAT: " + strtrim(minI,2) + " " + strtrim(maxI,2)
     printf,lun,"Hemisphere: " + hemStr
     printf,lun,"IMF Predominance: " + clockStr
     printf,lun,"Angle lim 1: " + strtrim(angleLim1,2)
     printf,lun,"Angle lim 2: " + strtrim(angleLim2,2)
     printf,lun,"Number of orbits used: " + strtrim(N_ELEMENTS(uniqueOrbs_ii),2)
     printf,lun,"Total number of events used: " + strtrim(N_ELEMENTS(plot_i),2)
     printf,lun,"Percentage of current DB used: " + $
            strtrim((N_ELEMENTS(plot_i))/FLOAT(n_elements(maximus.orbit))*100.0,2) + "%"
                                ;NOTE, sometimes percentage of current DB will be discrepant between
                                ;key_scatterplots_polarproj and get_inds_from_db because
                                ;key_scatterplots_polarproj actually resizes maximus
     ;; maximus = resize_maximus(maximus,INDS=plot_i)

     ;; IF SIZE(outFile,/TYPE) NE 0 AND SIZE(outFile,/TYPE) NE 7 THEN outFile=defOutPref+'--'+paramStr+plotSuff+defExt

  ENDIF ELSE BEGIN
     IF KEYWORD_SET(just_plot_i) THEN BEGIN
        print,"User-supplied inds using 'just_plot_i' keyword..."
        ;; maximus=resize_maximus(maximus,INDS=just_plot_i)
        plot_i_list    = LIST(just_plot_i)
        ;; IF SIZE(outFile,/TYPE) NE 0 AND SIZE(outFile,/TYPE) NE 7 THEN outFile = defOutPref + '--user-supplied' +defExt
     ENDIF
     IF KEYWORD_SET(plot_i_list) THEN BEGIN
        print,"User-supplied inds using 'plot_i_list' keyword..."
        ;; temp_plot_i=plot_i_list(0)
        ;; IF N_ELEMENTS(plot_i_list) GT 1 THEN BEGIN
        ;;    FOR i=1,N_ELEMENTS(plot_i_list)-1 DO temp_plot_i=[temp_plot_i,plot_i_list(i)]
        ;; ENDIF
        ;; maximus=resize_maximus(maximus,INDS=temp_plot_i)
        ;; IF SIZE(outFile,/TYPE) NE 0 AND SIZE(outFile,/TYPE) NE 7 THEN outFile = defOutPref + '--user-supplied' +defExt
     ENDIF
  ENDELSE
  
  ;;HEMI stuff--clean it up
  IF KEYWORD_SET(north) OR KEYWORD_SET(south) THEN BEGIN
     IF KEYWORD_SET(plot_i_list) THEN BEGIN
        modPlot_i_list = plot_i_list[*]
        IF KEYWORD_SET(north) THEN BEGIN
           IF KEYWORD_SET(mirror_south) THEN BEGIN
              FOR i=0,N_ELEMENTS(modPlot_i_list)-1 DO BEGIN
                 modPlot_i_list[i]=CGSETINTERSECTION(modPlot_i_list[i], $
                                                     WHERE(ABS(maximus.ILAT) GT minI AND ABS(maximus.ILAT) LT maxI))
              ENDFOR
           ENDIF ELSE BEGIN
              FOR i=0,N_ELEMENTS(modPlot_i_list)-1 DO BEGIN
                 modPlot_i_list[i]=CGSETINTERSECTION(modPlot_i_list[i], $
                                                     WHERE(maximus.ILAT GT minI AND maximus.ILAT LT maxI))
              ENDFOR
           ENDELSE
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(SOUTH) THEN BEGIN
              FOR i=0,N_ELEMENTS(modPlot_i_list)-1 DO BEGIN
                 modPlot_i_list[i]=CGSETINTERSECTION(modPlot_i_list[i], $
                                                     WHERE(maximus.ILAT GT minI AND maximus.ILAT LT maxI))
              ENDFOR
           ENDIF ELSE BEGIN
              FOR i=0,N_ELEMENTS(modPlot_i_list)-1 DO BEGIN
                 modPlot_i_list[i]=CGSETINTERSECTION(modPlot_i_list[i], $
                                                     WHERE(ABS(maximus.ILAT) GT minI AND ABS(maximus.ILAT) LT maxI))
              ENDFOR
           ENDELSE
        ENDELSE
     ENDIF ELSE BEGIN
        ;; maximus               = resize_maximus(maximus,MAXIMUS_IND=5,MIN_FOR_IND=minI,MAX_FOR_IND=maxI)
     ENDELSE
  ENDIF

  ;;Get rid of -1 stuffs
  junk_i                         = !NULL
  FOR i=0,N_ELEMENTS(modPlot_i_list)-1 DO BEGIN
     IF (modPlot_i_list[i])[0] EQ -1 THEN BEGIN
        junk_i                   = [junk_i,i] 
     ENDIF
  ENDFOR
  IF N_ELEMENTS(junk_i) GE 1 THEN BEGIN
     PRINT,'Some bad indices here! Going to remove them...'
     ;; STOP
     modPlot_i_list.REMOVE,junk_i
  ENDIF


  ;;Are we going to go with each orbit, then?
  IF KEYWORD_SET(add_orbit_legend) OR KEYWORD_SET(output_orbit_details) THEN BEGIN
     ;;This will give back a list of arrays of orbit structures (mmhmm)
     modPlot_i_list              = KEYWORD_SET(in_orbStrArr_list) ? LIST(in_orbStrArr_list) : SPLIT_IND_LIST_INTO_ORB_STRUCTARR_LIST(modPlot_i_list,maximus)
  ENDIF
  
  IF ~ISA(window) THEN BEGIN
     window                      = WINDOW(DIMENSIONS=[900,900])
  ENDIF ELSE BEGIN
     window.setCurrent
  ENDELSE


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Set up a map
  ;;Polar Stereographic
  ;;SEMIMAJOR_AXIS, SEMIMINOR_AXIS, CENTER_LONGITUDE, TRUE_SCALE_LATITUDE, FALSE_EASTING, FALSE_NORTHING
  IF N_ELEMENTS(map) EQ 0 THEN BEGIN
     map                         = MAP('Polar Stereographic', $
                                       CENTER_LONGITUDE=centerLon, $
                                       TRUE_SCALE_LATITUDE=tsLat, $
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
     ;; grid.grid_longitude         = 45
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
           ;; STRMATCH(mlons[i].name,'*5*') $
           ;; STRMATCH(mlons[i].name,'*15*') OR $
           ;; STRMATCH(mlons[i].name,'*21*')) $
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
        ;; aurPlot               = plot([MLTS,MLTs,MLTS[0]]*15,[bndry_eqWard,bndry_poleWard,bndry_poleWard[0]],LINESTYLE='-', THICK=4,/overplot)
        aurEqWardPlot            = PLOT([MLTS,MLTs[0]]*15,[bndry_eqWard,bndry_eqWard[0]],LINESTYLE='-', THICK=2.5,/overplot)
        aurPoleWardPlot          = PLOT([MLTS,MLTs[0]]*15,[bndry_poleWard,bndry_poleWard[0]],LINESTYLE='-', THICK=2.5,/overplot)
        
     ENDIF
  ENDIF

  ;;****************************************
  ;; Plotting

  IF KEYWORD_SET(modPlot_i_list) THEN BEGIN
     FOR i=0,N_ELEMENTS(modPlot_i_list)-1 DO BEGIN
        IF KEYWORD_SET(add_orbit_legend) OR KEYWORD_SET(output_orbit_details) THEN BEGIN

           curPlotArr = !NULL
           FOR j = 0,N_ELEMENTS(modPlot_i_list[i])-1 DO BEGIN
              tmp_i   = modPlot_i_list[i,j].plot_i_list[0]

              lats    = maximus.ilat[tmp_i]
              IF KEYWORD_SET(mirror_south) THEN lats = ABS(lats)

              lons    = maximus.mlt[tmp_i]*15
              color   = KEYWORD_SET(color_list) ? color_list[j] : modPlot_i_list[i,j].color
              name    = STRING(FORMAT='(I5,T8,"(",I0,")")',modPlot_i_list[i,j].orbit,modPlot_i_list[i,j].N)
              CASE 1 OF
                 (KEYWORD_SET(no_symbol) OR KEYWORD_SET(add_line)): BEGIN
                    curPlot = PLOT(lons,lats, $
                                   NAME=name, $
                                   SYM_SIZE=KEYWORD_SET(no_symbol) ? !NULL : 1.0, $
                                   SYMBOL=KEYWORD_SET(no_symbol) ? !NULL : 'o', $
                                   /OVERPLOT, $
                                   ;; SYM_TRANSPARENCY=(i EQ 2) ? 60 : sTrans, $ ;this line is for making events on plot #3 stand out
                                   LINESTYLE=lineStyle, $
                                   THICK=2.0, $
                                   SYM_TRANSPARENCY=sTrans, $ 
                                   SYM_THICK=1.5, $
                                   SYM_COLOR=(N_ELEMENTS(color_list) GT 0) ? color_list[j] : color_list, $
                                   COLOR=(N_ELEMENTS(color_list) GT 0) ? color_list[j] : color_list, $
                                   CURRENT=window, $
                                   POSITION=plotPosition, $
                                   LAYOUT=layout)
                 END
                 ELSE: BEGIN
                    curPlot = SCATTERPLOT(lons,lats, $
                                          NAME=name, $
                                          SYM_SIZE=1.0, $
                                          SYMBOL='o', $
                                          /OVERPLOT, $
                                          SYM_TRANSPARENCY=sTrans, $ 
                                          SYM_THICK=1.5, $
                                          SYM_COLOR=(N_ELEMENTS(color_list) GT 0) ? color_list[j] : color, $
                                          CURRENT=window, $
                                          POSITION=plotPosition, $
                                          LAYOUT=layout)
                 END
              ENDCASE

              curPlotArr = [curPlotArr,curPlot]
           ENDFOR

           IF KEYWORD_SET(add_orbit_legend) THEN BEGIN
              ephemLegend                    = LEGEND(/NORMAL, $
                                                      POSITION=[0.95,0.9], $
                                                      TARGET=curPlotArr, $
                                                      /AUTO_TEXT_COLOR)
              curPlot       = curPlotArr
           ENDIF

        ENDIF ELSE BEGIN
           
           lats = maximus.ilat[modPlot_i_list[i]]
           IF KEYWORD_SET(mirror_south) THEN lats = ABS(lats)

           lons = maximus.mlt[modPlot_i_list[i]]*15

           ;; lats=[65,65,65,65]
           ;; lons=[0,90,180,270]
           
           CASE 1 OF
              (KEYWORD_SET(no_symbol) OR KEYWORD_SET(add_line)): BEGIN
                 curPlot = PLOT(lons,lats, $
                                SYM_SIZE=KEYWORD_SET(no_symbol) ? !NULL : 1.0, $
                                SYMBOL=KEYWORD_SET(no_symbol) ? !NULL : 'o', $
                                /OVERPLOT, $
                                ;; SYM_TRANSPARENCY=(i EQ 2) ? 60 : sTrans, $ ;this line is for making events on plot #3 stand out
                                LINESTYLE=lineStyle, $
                                THICK=2.0, $
                                SYM_TRANSPARENCY=sTrans, $ 
                                SYM_THICK=1.5, $
                                SYM_COLOR=(N_ELEMENTS(color_list) GT 0) ? color_list[i] : color_list, $
                                COLOR=(N_ELEMENTS(color_list) GT 0) ? color_list[i] : color_list, $
                                ;; TITLE=plotTitle, $ ;,$;SYM_SIZE=0.5, $ ;There is such a high density of points that we need tranparency
                                ;; OVERPLOT=overplot, $
                                ;; WINDOW=out_window, $
                                CURRENT=window, $
                                POSITION=plotPosition, $
                                LAYOUT=layout)
              END
              ELSE: BEGIN
                 curPlot = SCATTERPLOT(lons,lats, $
                                       SYM_SIZE=1.0, $
                                       SYMBOL=KEYWORD_SET(no_symbol) ? !NULL : 'o', $
                                       /OVERPLOT, $
                                       ;; SYM_TRANSPARENCY=(i EQ 2) ? 60 : sTrans, $ ;this line is for making events on plot #3 stand out
                                       SYM_TRANSPARENCY=sTrans, $ 
                                       SYM_THICK=1.5, $
                                       SYM_COLOR=(N_ELEMENTS(color_list) GT 0) ? color_list[i] : color_list, $
                                       ;; TITLE=plotTitle, $ ;,$;SYM_SIZE=0.5, $ ;There is such a high density of points that we need tranparency
                                       ;; OVERPLOT=overplot, $
                                       ;; WINDOW=out_window, $
                                       CURRENT=MAP, $
                                       ;; POSITION=plotPosition, $
                                       LAYOUT=layout)
              END
           ENDCASE
        ENDELSE
     ENDFOR
     
  ENDIF ELSE BEGIN

     PRINT,'No plot_i provided for polarProj_scatterplots! What to do?'
     WAIT,1
  ENDELSE     
  
  IF KEYWORD_SET(plotTitle) THEN BEGIN
     plotTitleText      = TEXT(0.5,0.9,plotTitle, $
                               /NORMAL, $
                               FONT_SIZE=KEYWORD_SET(hugePlotMode) ? 28 : 18, $
                               ALIGNMENT=0.5)
  ENDIF

  ;; IF KEYWORD_SET(plotTitle) AND ~KEYWORD_SET(hugePlotMode) THEN BEGIN
  ;;    plotTitleText      = TEXT(0.5,0.9,plotTitle,/NORMAL,FONT_SIZE=18,ALIGNMENT=0.5)
  ;; ENDIF

  IF KEYWORD_SET(savePlot) THEN BEGIN
     IF ~KEYWORD_SET(sPName) THEN sPName = 'scatterplot_polarProj.png'

     IF ~KEYWORD_SET(plotDir) THEN SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY
     outFileName            = plotDir + sPName
     PRINT,'Saving scatterplot to ' + outFileName + '...'
     window.save,plotDir + sPName,RESOLUTION=defRes

     IF KEYWORD_SET(close_after_save) THEN BEGIN
        window.close
        window = !NULL
     ENDIF
  ENDIF

  IF KEYWORD_SET(output_orbit_details) THEN BEGIN
     out_orbStrArr_list    = modPlot_i_list
  ENDIF

  IF ISA(curPlot)    THEN out_plot        = curPlot
  IF ISA(out_window) THEN out_window      = window
  IF ISA(out_map)    THEN out_map         = map

END