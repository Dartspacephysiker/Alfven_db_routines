;2016/01/15 EPS Output keyword added 
;2016/01/19
PRO PLOT_ALFVENDB_2DHISTOS,H2DSTRARR=h2dStrArr,DATANAMEARR=dataNameArr,TEMPFILE=tempFile, $
                           H2DMASKARR=h2dMaskArr, $
                           SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ 
                           SHOWPLOTSNOSAVE=showPlotsNoSave, $
                           PLOTDIR=plotDir, PLOTMEDORAVG=plotMedOrAvg, $
                           PARAMSTR=paramStr, DEL_PS=del_PS, $
                           HEMI=hemi, $
                           CLOCKSTR=clockStr, $
                           NO_COLORBAR=no_colorbar, $
                           SUPPRESS_GRIDLABELS=suppress_gridLabels, $
                           LABELS_FOR_PRESENTATION=labels_for_presentation, $
                           TILE_IMAGES=tile_images, $
                           N_TILE_ROWS=n_tile_rows, $
                           N_TILE_COLUMNS=n_tile_columns, $
                           TILING_ORDER=tiling_order, $
                           TILEPLOTSUFF=tilePlotSuff, $
                           TILEPLOTTITLE=tilePlotTitle, $
                           TILE__FAVOR_ROWS=tile__favor_rows, $
                           ;; BLANK_TILE_POSITIONS=blank_tile_positions, $
                           LUN=lun, $
                           EPS_OUTPUT=eps_output, $
                           _EXTRA = e
  
  defXSize                        = 5
  defYSize                        = 5

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  ;;if not saving plots and plots not turned off, do some stuff  ;; otherwise, make output
  IF KEYWORD_SET(showPlotsNoSave) THEN BEGIN 
     IF KEYWORD_SET(squarePlot) THEN BEGIN
        cgWindow, 'interp_contplotmulti_str', $
                  h2dStrArr,$
                  BACKGROUND='White', $
                  WTITLE='Flux plots for '+hemi+'ern Hemisphere, ' + $
                  (KEYWORD_SET(clockStr) ? clockStr+' IMF, ' : '') + strmid(plotMedOrAvg,1)
     ENDIF ELSE BEGIN
        FOR i=0, N_ELEMENTS(h2dStrArr) - 2 DO BEGIN
           cgWindow,'interp_polar2dhist', $
                    h2dStrArr[i],tempFile, $
                    _EXTRA=e,$
                    BACKGROUND="White", $
                    WXSIZE=800, $
                    WYSIZE=600, $
                    WTITLE='Polar plot_'+dataNameArr[i]+','+hemi+'ern Hemisphere, ' + $
                    (KEYWORD_SET(clockStr) ? clockStr+' IMF, ' : '') + strmid(plotMedOrAvg,1)
        ENDFOR
     ENDELSE
  ENDIF ELSE BEGIN 

     IF KEYWORD_SET(squarePlot) THEN BEGIN 

        CD, CURRENT=c ;; & PRINTF,LUN, "Current directory is " + c + "/" + plotDir 

        PRINTF,LUN, "Creating output files..." 

        ;;Create a PostScript file.
        cgPS_Open, plotDir + 'fluxplots_'+paramStr+'.ps', $
                   /NOMATCH, $
                   XSIZE=1000, $
                   YSIZE=1000

        interp_contplotmulti_str,h2dStrArr 

        cgPS_Close 

        ;;Create a PNG file with a width of 800 pixels.
        cgPS2Raster, plotDir + 'fluxplots_'+paramStr+'.ps', $
                     /PNG, $
                     WIDTH=800, $
                     DELETE_PS=del_PS
     
     ENDIF ELSE BEGIN
        CD, CURRENT=c & PRINTF,LUN, "Current directory is " + c + "/" + plotDir 
        PRINTF,LUN, "Creating output files..." 
        
        IF KEYWORD_SET(polarContour) THEN BEGIN
           ;; The NAME field of the !D system variable contains the name of the
           ;; current plotting device.
           mydevice = !D.NAME
           
           ;; Set plotting to PostScript:
           SET_PLOT, 'PS'
           
           FOR i=0, N_ELEMENTS(h2dStrArr) - 2 DO BEGIN  
              
              ;; Use DEVICE to set some PostScript device options:
              DEVICE, FILENAME='myfile.ps', $
                      /LANDSCAPE
              
              ;; Make a simple plot to the PostScript file:
              interp_polar2dcontour,h2dStrArr[i], $
                                    dataNameArr[i], $
                                    tempFile, $
                                    FNAME=plotDir + paramStr+'--'+dataNameArr[i]+'.png', $
                                    _EXTRA=e
              
              ;; Close the PostScript file:
              DEVICE, /CLOSE
           ENDFOR
           ;; Return plotting to the original device:
           SET_PLOT, mydevice
        ENDIF ELSE BEGIN
           ;;Create a PostScript file.

           defMapPos              = [0.125, 0.05, 0.875, 0.8]
           defCBPos               = [0.10, 0.90, 0.90, 0.92]

           ;;But if you want a title...
           defXWTitleSize         = 5
           defYWTitleSize         = 6

           IF KEYWORD_SET(tile_images) THEN BEGIN
              nPlots            = N_ELEMENTS(h2dStrArr)
              IF ~KEYWORD_SET(h2dMaskArr) THEN nPlots-- ;take one away, because h2dMask must be at the end of h2dStrArr itself

              IF ~KEYWORD_SET(n_tile_columns) THEN n_tile_columns = FLOOR(SQRT(nPlots))
              ;; IF ~KEYWORD_SET(n_tile_rows)    THEN n_tile_rows    = CEIL(nPlots/2.)
              IF ~KEYWORD_SET(n_tile_rows)    THEN n_tile_rows    = ROUND(DOUBLE(nPlots)/n_tile_columns)

              ;Determine where blanks are
              IF KEYWORD_SET(tiling_order) THEN BEGIN
                 blankLocs = WHERE(tiling_order LT 0,nBlanks)
              ENDIF ELSE BEGIN
                 nBlanks   = 0
              ENDELSE
              ;; IF KEYWORD_SET(blank_tile_positions) THEN BEGIN
              ;;    nBlanks = N_ELEMENTS(blank_tile_positions)
                 
              ;;    ;;Pad tiling order if need be
              ;;    IF KEYWORD_SET(tiling_order) THEN BEGIN
              ;;       padVal       = 0   ;Need this because we're changing indices
              ;;       FOR iBlank=0,N_ELEMENTS(blank_tile_positions)-1 DO BEGIN
              ;;          CASE blank_tile_positions[iBlank] OF
              ;;             0: BEGIN
              ;;                tiling_order = [-9,tiling_order]
              ;;             END
              ;;             nPlots-1: BEGIN

              ;;             END
              ;;             ELSE: BEGIN

              ;;             END                          
              ;;          ENDCASE
              ;;       ENDFOR
              ;;    ENDIF
              ;; ENDIF ELSE BEGIN
              ;;    nBlanks = 0
              ;; ENDELSE

              nPlotsAndBlanks     = nPlots + nBlanks

              WHILE (n_tile_columns*n_tile_rows) LT nPlotsAndBlanks DO BEGIN
                 IF KEYWORD_SET(tile__favor_rows) THEN BEGIN
                    IF n_tile_rows LE n_tile_columns THEN BEGIN
                       n_tile_rows++
                       IF (n_tile_columns*n_tile_rows) GE nPlotsAndBlanks THEN BREAK ELSE BEGIN
                          IF n_tile_columns GE n_tile_rows THEN n_tile_rows++ ELSE n_tile_columns++
                       ENDELSE
                    ENDIF ELSE BEGIN
                       n_tile_columns++
                       IF (n_tile_columns*n_tile_rows) GE nPlotsAndBlanks THEN BREAK ELSE BEGIN
                          IF n_tile_columns GE n_tile_rows THEN n_tile_rows++ ELSE n_tile_columns++
                       ENDELSE
                    ENDELSE
                 ENDIF ELSE BEGIN
                    IF n_tile_columns LE n_tile_rows THEN BEGIN
                       n_tile_columns++
                       IF (n_tile_columns*n_tile_rows) GE nPlotsAndBlanks THEN BREAK ELSE BEGIN
                          IF n_tile_rows GE n_tile_columns THEN n_tile_columns++ ELSE n_tile_rows++
                       ENDELSE
                    ENDIF ELSE BEGIN
                       n_tile_rows++
                       IF (n_tile_columns*n_tile_rows) GE nPlotsAndBlanks THEN BREAK ELSE BEGIN
                          IF n_tile_rows GE n_tile_columns THEN n_tile_columns++ ELSE n_tile_rows++
                       ENDELSE
                    ENDELSE
                 ENDELSE
              ENDWHILE

              IF KEYWORD_SET(tilePlotTitle) THEN BEGIN
                 xSize              = defXWTitleSize*n_tile_columns
                 ySize              = defYWTitleSize*n_tile_rows

                 xRatio             = FLOAT(defXSize)/FLOAT(defXWTitleSize)
                 yRatio             = FLOAT(defYSize)/FLOAT(defYWTitleSize)
                 
                 ;; defMapWTitlePos  = [0.125, 0.05, 0.875, 0.8]
                 ;; defCBWTitlePos   = [0.10, 0.90, 0.90, 0.92]

                 defMapPos[0]       = defMapPos[0]*xRatio + (1.-xRatio)/2.
                 defMapPos[2]       = defMapPos[2]*xRatio + (1.-xRatio)/2.
                 defCBPos[0]        = defCBPos[0]*xRatio + (1.-xRatio)/2.
                 defCBPos[2]        = defCBPos[2]*xRatio + (1.-xRatio)/2.

                 ;; defMapPos[1] = defMapPos[1]*yRatio + (1.-yRatio)/2.
                 ;; defMapPos[3] = defMapPos[3]*yRatio + (1.-yRatio)/2.
                 ;; defCBPos[1]  = defCBPos[1]*yRatio + (1.-yRatio)/2.
                 ;; defCBPos[3]  = defCBPos[3]*yRatio + (1.-yRatio)/2.
                 defMapPos[1]       = defMapPos[1]*yRatio
                 defMapPos[3]       = defMapPos[3]*yRatio
                 defCBPos[1]        = defCBPos[1]*yRatio
                 defCBPos[3]        = defCBPos[3]*yRatio

              ENDIF ELSE BEGIN
                 xSize              = defXSize*n_tile_columns
                 ySize              = defYSize*n_tile_rows
              
              ENDELSE
              ;; normMapWidth        = defMapPos[2]-defMapPos[0]
              ;; normMapHeight       = defMapPos[3]-defMapPos[1]


              IF ~KEYWORD_SET(tilePlotSuff) THEN BEGIN
                 tPSuff = ''
                 ;; FOR k=0,N_ELEMENTS(h2dStrArr)-2 DO BEGIN
                 ;;    tPSuff += '--' + dataNameArr[k]
                 ;; ENDFOR
                 tPSuff = '--' + STRCOMPRESS(nPlots,/REMOVE_ALL) + '_tiled_plots'
              ENDIF ELSE BEGIN
                 tPSuff = tilePlotSuff
              ENDELSE

              CGPS_Open, plotDir + paramStr+tPSuff+'.ps', $
                         /NOMATCH, $
                         XSIZE=xSize, $
                         YSIZE=ySize, $
                         LANDSCAPE=1, $
                         ENCAPSULATED=eps_output

              ;; !P.MULTI = [0, n_tile_rows, n_tile_columns]

              CGDISPLAY,xSize*100,ySize*100,COLOR="black", $
                        ;; XSIZE=KEYWORD_SET(xSize) ? xSize : def_H2D_xSize, $
                        ;; YSIZE=KEYWORD_SET(ySize) ? ySize : def_H2D_ySize, $
                        ;; XSIZE=xSize, $
                        ;; YSIZE=ySize, $
                        ;; /MATCH, $
                        /LANDSCAPE_FORCE

              ;; iPos = 0
              FOR i=0, nPlotsAndBlanks-1 DO BEGIN  

                 IF KEYWORD_SET(tiling_order) THEN j = tiling_order[i] ELSE j = i
                 IF nBlanks GT 0 THEN BEGIN ;is it blankety blank?
                    WHILE j LT 0 DO BEGIN
                       i++
                       j = tiling_order[i]
                    ENDWHILE
                 ENDIF

                 position         = CALC_PLOT_POSITION(i+1,n_tile_columns,n_tile_rows)

                 ;;handle map position
                 map_position     = position
                 map_position[0]  = (position[2]-position[0])*defMapPos[0]+position[0]
                 map_position[1]  = (position[3]-position[1])*defMapPos[1]+position[1]
                 map_position[2]  = (position[2]-position[0])*defMapPos[2]+position[0]
                 map_position[3]  = (position[3]-position[1])*defMapPos[3]+position[1]

                 ;;handle map position
                 cb_position      = position
                 cb_position[0]   = (position[2]-position[0])*defCBPos[0]+position[0]
                 cb_position[1]   = (position[3]-position[1])*defCBPos[1]+position[1]
                 cb_position[2]   = (position[2]-position[0])*defCBPos[2]+position[0]
                 cb_position[3]   = (position[3]-position[1])*defCBPos[3]+position[1]


                 CASE N_ELEMENTS(h2dMaskArr) OF
                    1: h2dMask    = h2dMaskarr
                    N_ELEMENTS(h2dStrArr): BEGIN
                       h2dMask    = h2dMaskArr[j]
                    END
                    ELSE: BEGIN
                    END
                 ENDCASE
                 
                 PLOTH2D_STEREOGRAPHIC,h2dStrArr[j],tempFile, $
                                       H2DMASK=h2dMask, $
                                       NO_COLORBAR=no_colorbar, $
                                       WINDOW_XSIZE=xSize, $
                                       WINDOW_YSIZE=ySize, $
                                       MAP_POSITION=map_position, $
                                       CB_POSITION=cb_position, $
                                       /NO_DISPLAY, $
                                       SUPPRESS_GRIDLABELS=suppress_gridLabels, $
                                       LABELS_FOR_PRESENTATION=labels_for_presentation, $
                                       MIRROR=STRUPCASE(hemi) EQ 'SOUTH', $
                                       _EXTRA=e 
              ENDFOR

              IF KEYWORD_SET(tilePlotTitle) THEN BEGIN
                 ;; tilePlotText = TEXT(0.5, $
                 ;;                     yRatio + (1.-yRatio)/2., $
                 ;;                     tilePlotTitle, $
                 ;;                     /NORMAL, $
                 ;;                     ALIGNMENT=0.5, $
                 ;;                     FONT_SIZE=18)
                 CGTEXT,0.5, $
                        yRatio + (1.-yRatio)/2., $
                        tilePlotTitle, $
                        /NORMAL, $
                        ALIGNMENT=0.5, $
                        CHARSIZE=2
              ENDIF

              CGPS_Close 
              ;;Create a PNG file with a width of 800 pixels.
              IF ~KEYWORD_SET(eps_output) THEN BEGIN
                 CGPS2RASTER, plotDir + paramStr+tPSuff+'.ps', $
                              /PNG, $
                              WIDTH=800*n_tile_columns, $
                              DELETE_PS=del_PS
              ENDIF
                 
              !P.MULTI = 0

           ENDIF ELSE BEGIN

              xSize    = 5
              ySize    = 5

              FOR i=0, N_ELEMENTS(h2dStrArr) - 2 DO BEGIN  
                 
                 CGPS_Open, plotDir + paramStr+'--'+dataNameArr[i]+'.ps', $
                            /NOMATCH, $
                            XSIZE=5, $
                            YSIZE=5, $
                            LANDSCAPE=1, $
                            ENCAPSULATED=eps_output
                 
                 
                 CGDISPLAY,xSize*100,ySize*100,COLOR="black", $
                           ;; YSIZE=KEYWORD_SET(ySize) ? ySize : def_H2D_ySize, $
                           ;; XSIZE=xSize, $
                           ;; YSIZE=ySize, $
                           ;; /MATCH, $
                           /LANDSCAPE_FORCE
                 
                 PLOTH2D_STEREOGRAPHIC,h2dStrArr[i],tempFile, $
                                       NO_COLORBAR=no_colorbar, $
                                       WINDOW_XSIZE=xSize, $
                                       WINDOW_YSIZE=ySize, $
                                       MAP_POSITION=map_position, $
                                       /NO_DISPLAY, $
                                       CB_POSITION=cb_position, $
                                       SUPPRESS_GRIDLABELS=suppress_gridLabels, $
                                       LABELS_FOR_PRESENTATION=labels_for_presentation, $
                                       MIRROR=STRUPCASE(hemi) EQ 'SOUTH', $
                                       _EXTRA=e 
                 CGPS_Close 
                 ;;Create a PNG file with a width of 800 pixels.
                 IF ~KEYWORD_SET(eps_output) THEN BEGIN
                    CGPS2RASTER, plotDir + paramStr+'--'+dataNameArr[i]+'.ps', $
                                 /PNG, $
                                 WIDTH=800, $
                                 DELETE_PS=del_PS
                 ENDIF
              ENDFOR

           ENDELSE

        ENDELSE
           
     ENDELSE
  ENDELSE

END