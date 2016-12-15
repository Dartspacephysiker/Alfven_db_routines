;2016/01/15 EPS Output keyword added 
;2016/01/19
PRO PLOT_ALFVENDB_2DHISTOS,H2DSTRARR=h2dStrArr, $
                           DATANAMEARR=dataNameArr, $
                           H2DMASKARR=h2dMaskArr, $
                           TEMPFILE=tempFile, $
                           EQUAL_AREA_BINNING=EA_binning, $
                           SQUAREPLOT=squarePlot, $
                           POLARCONTOUR=polarContour, $ 
                           SHOWPLOTSNOSAVE=showPlotsNoSave, $
                           PLOTDIR=plotDir, $
                           PLOTMEDORAVG=plotMedOrAvg, $
                           PARAMSTR=paramStr, $
                           ORG_PLOTS_BY_FOLDER=org_plots_by_folder, $
                           DEL_PS=del_PS, $
                           HEMI=hemi, $
                           CLOCKSTR=clockStr, $
                           NO_COLORBAR=no_colorbar, $
                           SUPPRESS_THICKGRID=suppress_thickGrid, $
                           SUPPRESS_GRIDLABELS=suppress_gridLabels, $
                           SUPPRESS_MLT_LABELS=suppress_MLT_labels, $
                           SUPPRESS_ILAT_LABELS=suppress_ILAT_labels, $
                           SUPPRESS_MLT_NAME=suppress_MLT_name, $
                           SUPPRESS_ILAT_NAME=suppress_ILAT_name, $
                           SUPPRESS_TITLES=suppress_titles, $
                           LABELS_FOR_PRESENTATION=labels_for_presentation, $
                           TILE_IMAGES=tile_images, $
                           N_TILE_ROWS=n_tile_rows, $
                           N_TILE_COLUMNS=n_tile_columns, $
                           TILING_ORDER=tiling_order, $
                           TILEPLOTSUFF=tilePlotSuff, $
                           TILEPLOTTITLE=tilePlotTitle, $
                           TILE__FAVOR_ROWS=tile__favor_rows, $
                           TILE__INCLUDE_IMF_ARROWS=tile__include_IMF_arrows, $
                           TILE__CB_IN_CENTER_PANEL=tile__cb_in_center_panel, $
                           TILE__NO_COLORBAR_ARRAY=tile__no_colorbar_array, $
                           ;; BLANK_TILE_POSITIONS=blank_tile_positions, $
                           PLOTH2D_CONTOUR=plotH2D_contour, $
                           CONTOUR__LEVELS=contour__levels, $
                           CONTOUR__PERCENT=contour__percent, $
                           PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kernel_density_unmask, $
                           OVERPLOTSTR=oplotStr, $
                           OVERPLOT_CONTOUR__LEVELS=op_contour__levels, $
                           OVERPLOT_CONTOUR__PERCENT=op_contour__percent, $
                           OVERPLOT_PLOTRANGE=op_plotRange, $
                           CENTERS_MLT=centersMLT, $
                           CENTERS_ILAT=centersILAT, $
                           SHOW_INTEGRALS=show_integrals, $
                           MAKE_INTEGRAL_TXTFILE=make_integral_txtfile, $
                           MAKE_INTEGRAL_SAVFILE=make_integral_savfile, $
                           INTEGRALSAVFILEPREF=integralSavFilePref, $
                           TXTOUTPUTDIR=txtOutputDir, $
                           LUN=lun, $
                           EPS_OUTPUT=eps_output, $
                           _EXTRA = e
  
  @common__overplot_vars.pro

  defXSize                        = 5
  defYSize                        = 5

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF KEYWORD_SET(org_plots_by_folder) THEN BEGIN

     IF N_ELEMENTS(dataNameArr) GT 1 THEN BEGIN
  
      onlyOneDir = (dataNameArr[0] EQ dataNameArr[1])
  
        FOR k=0,(onlyOneDir ? 0 : N_ELEMENTS(dataNameArr)-1) DO BEGIN
           plotDir_exists = FILE_TEST(plotDir + dataNameArr[k] + '/',/DIRECTORY)
           IF ~plotDir_exists THEN BEGIN
              ;; IF KEYWORD_SET(verbose) THEN PRINTF,lun,"SET_PLOT_DIR: Making directory " + plotDir
              SPAWN,'mkdir -p ' + plotDir + dataNameArr[k] + '/'
           ENDIF
           plotDir_exists = FILE_TEST(plotDir + dataNameArr[k] + '/',/DIRECTORY)
           IF ~plotDir_exists THEN BEGIN
              PRINTF,lun,'Failed to make directory: ' + plotDir + dataNameArr[k] + '/'
              STOP
           ENDIF
        ENDFOR

     ENDIF

  ENDIF

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
        cgPS_Open, plotDir + (KEYWORD_SET(org_plots_by_folder) ? dataNameArr[0] + '/' : '' ) + 'fluxplots_'+paramStr+'.ps', $
                   /NOMATCH, $
                   XSIZE=1000, $
                   YSIZE=1000

        interp_contplotmulti_str,h2dStrArr 

        CGPS_CLOSE 

        ;;Create a PNG file with a width of 800 pixels.
        CGPS2RASTER, plotDir + (KEYWORD_SET(org_plots_by_folder) ? dataNameArr[0] + '/' : '' ) + 'fluxplots_'+paramStr+'.ps', $
                     /PNG, $
                     WIDTH=800, $
                     DELETE_PS=del_PS
     
     ENDIF ELSE BEGIN
        ;; CD, CURRENT=c & PRINTF,LUN, "Current directory is " + c + "/" + plotDir + (KEYWORD_SET(org_plots_by_folder) ? dataNameArr[0] + '/' : '' )
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
              INTERP_POLAR2DCONTOUR,h2dStrArr[i], $
                                    dataNameArr[i], $
                                    tempFile, $
                                    FNAME=plotDir + (KEYWORD_SET(org_plots_by_folder) ? dataNameArr[i] + '/' : '' ) + paramStr+'--'+dataNameArr[i]+'.png', $
                                    _EXTRA=e
              
              ;; Close the PostScript file:
              DEVICE, /CLOSE
           ENDFOR
           ;; Return plotting to the original device:
           SET_PLOT, mydevice
        ENDIF ELSE BEGIN
           ;;Create a PostScript file.

           defMapPos              = [0.125, 0.05, 0.875, 0.8 ]
           defMapNoCBPos          = [0.04  , 0.04 , 0.96  , 0.96 ]
           defCBPos               = [0.10 , 0.90, 0.90 , 0.92]
           ;; vertCBPos              = [0.92 , 0.05, 0.95 , 0.95]
           vertCBPos              = [0.11 , 0.05, 0.14 , 0.95]
           oPltCBPos              = [0.86 , 0.05, 0.89 , 0.95]

           IF KEYWORD_SET(tile__cb_in_center_panel) THEN BEGIN
              ;; defIntegPos         = [0.07 , 0.93, 0.82 , 0.07]
              defIntegPos         = [0.03 , 0.03, 0.82 , 0.07]
           ENDIF ELSE BEGIN
              defIntegPos         = [0.11 , 0.78, 0.68 , 0.74]
           ENDELSE
           defIntegDelta          = 0.05


           ;;But if you want a title...
           defXWTitleSize         = 5
           defYWTitleSize         = 5.5

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

              ;; IF KEYWORD_SET(tilePlotTitle) OR KEYWORD_SET(tile__cb_in_center_panel) THEN BEGIN
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
                 defIntegPos[0]     = defIntegPos[0]*xRatio + (1.-xRatio)/2.
                 defIntegPos[2]     = defIntegPos[2]*xRatio + (1.-xRatio)/2.

                 defMapNoCBPos[0]   = defMapNoCBPos[0]*xRatio + (1.-xRatio)/2.
                 defMapNoCBPos[2]   = defMapNoCBPos[2]*xRatio + (1.-xRatio)/2.
                 vertCBPos[0]       = vertCBPos[0]*xRatio + (1.-xRatio)/2.
                 vertCBPos[2]       = vertCBPos[2]*xRatio + (1.-xRatio)/2.
                 oPltCBPos[0]       = oPltCBPos[0]*xRatio + (1.-xRatio)/2.
                 oPltCBPos[2]       = oPltCBPos[2]*xRatio + (1.-xRatio)/2.

                 ;; defMapPos[1] = defMapPos[1]*yRatio + (1.-yRatio)/2.
                 ;; defMapPos[3] = defMapPos[3]*yRatio + (1.-yRatio)/2.
                 ;; defCBPos[1]  = defCBPos[1]*yRatio + (1.-yRatio)/2.
                 ;; defCBPos[3]  = defCBPos[3]*yRatio + (1.-yRatio)/2.
                 defMapPos[1]       = defMapPos[1]*yRatio
                 defMapPos[3]       = defMapPos[3]*yRatio
                 defCBPos[1]        = defCBPos[1]*yRatio
                 defCBPos[3]        = defCBPos[3]*yRatio
                 defIntegPos[1]     = defIntegPos[1]*yRatio
                 defIntegPos[3]     = defIntegPos[3]*yRatio
                 defIntegDelta      = defIntegDelta*yRatio

                 defMapNoCBPos[1]   = defMapNoCBPos[1]*yRatio
                 defMapNoCBPos[3]   = defMapNoCBPos[3]*yRatio
                 vertCBPos[1]       = vertCBPos[1]*yRatio
                 vertCBPos[3]       = vertCBPos[3]*yRatio
                 oPltCBPos[1]       = oPltCBPos[1]*yRatio
                 oPltCBPos[3]       = oPltCBPos[3]*yRatio
              ENDIF ELSE BEGIN
                 xSize              = defXSize*n_tile_columns
                 ySize              = defYSize*n_tile_rows
              
                 xRatio             = 1
                 yRatio             = 1
              ENDELSE
              ;; normMapWidth        = defMapPos[2]-defMapPos[0]
              ;; normMapHeight       = defMapPos[3]-defMapPos[1]


              IF ~KEYWORD_SET(tilePlotSuff) THEN BEGIN
                 tPSuff = ''
                 ;; FOR k=0,N_ELEMENTS(h2dStrArr)-2 DO BEGIN
                 ;;    tPSuff += '--' + dataNameArr[k]
                 ;; ENDFOR
                 ;; tPSuff = '--' + STRCOMPRESS(nPlots,/REMOVE_ALL) + '_tiled'
              ENDIF ELSE BEGIN
                 tPSuff = tilePlotSuff
              ENDELSE

              CGPS_OPEN, plotDir + (KEYWORD_SET(org_plots_by_folder) ? dataNameArr[0] + '/' : '' ) + paramStr + tPSuff+'.ps', $
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

              IF KEYWORD_SET(make_integral_txtfile) THEN BEGIN
                 integralFile = txtOutputDir + paramStr + $
                                tPSuff + '--integrals.txt'
                 OPENW,intLun,integralFile,/GET_LUN,/APPEND

                 PRINTF,intLun,h2dStrArr[0].title
                 PRINTF,intLun,''
              ENDIF

              IF KEYWORD_SET(make_integral_savfile) THEN BEGIN
                 integralSavFile = txtOutputDir + (KEYWORD_SET(integralSavFilePref) ? integralSavFilePref : paramStr ) + $
                                   tPSuff + '--integrals.sav'
              ENDIF

              FOR i=0, nPlotsAndBlanks-1 DO BEGIN  

                 IF KEYWORD_SET(tiling_order) THEN j = tiling_order[i] ELSE j = i
                 IF nBlanks GT 0 THEN BEGIN ;is it blankety blank?
                    WHILE j LT 0 DO BEGIN
                       i++
                       j = tiling_order[i]
                    ENDWHILE
                 ENDIF

                 CASE N_ELEMENTS(tile__no_colorbar_array) OF
                    0:    no_cb = !NULL
                    1:    no_cb = tile__no_colorbar_array
                    ELSE: no_cb = tile__no_colorbar_array[j]
                 ENDCASE

                 position         = CALC_PLOT_POSITION(i+1,n_tile_columns,n_tile_rows)

                 CASE N_ELEMENTS(suppress_thickGrid) OF
                    0: 
                    1: suppress_tg = suppress_thickGrid
                    N_ELEMENTS(tiling_order): suppress_tg = suppress_thickGrid[i]
                 ENDCASE

                 CASE N_ELEMENTS(suppress_gridLabels) OF
                    0: 
                    1: suppress_gl = suppress_gridLabels
                    N_ELEMENTS(tiling_order): suppress_gl = suppress_gridLabels[i]
                 ENDCASE

                 CASE N_ELEMENTS(suppress_MLT_labels) OF
                    0: 
                    1: suppress_Ml = suppress_MLT_labels
                    N_ELEMENTS(tiling_order): suppress_Ml = suppress_MLT_labels[i]
                 ENDCASE

                 CASE N_ELEMENTS(suppress_ILAT_labels) OF
                    0: 
                    1: suppress_Il = suppress_ILAT_labels
                    N_ELEMENTS(tiling_order): suppress_Il = suppress_ILAT_labels[i]
                 ENDCASE

                 CASE N_ELEMENTS(suppress_MLT_name) OF
                    0: 
                    1: suppress_Mn = suppress_MLT_name
                    N_ELEMENTS(tiling_order): suppress_Mn = suppress_MLT_name[i]
                 ENDCASE

                 CASE N_ELEMENTS(suppress_ILAT_name) OF
                    0: 
                    1: suppress_In = suppress_ILAT_name
                    N_ELEMENTS(tiling_order): suppress_In = suppress_ILAT_name[i]
                 ENDCASE

                 CASE N_ELEMENTS(suppress_titles) OF
                    0: 
                    1: suppress_t = suppress_titles
                    N_ELEMENTS(tiling_order): suppress_t = suppress_titles[i]
                 ENDCASE

                 ;;handle map position
                 IF KEYWORD_SET(no_cb) AND (nBlanks GT 0) THEN BEGIN
                    map_position     = position
                    map_position[0]  = (position[2]-position[0])*defMapNoCBPos[0]+position[0]
                    map_position[1]  = (position[3]-position[1])*defMapNoCBPos[1]+position[1]
                    map_position[2]  = (position[2]-position[0])*defMapNoCBPos[2]+position[0]
                    map_position[3]  = (position[3]-position[1])*defMapNoCBPos[3]+position[1]
                 ENDIF ELSE BEGIN
                    map_position     = position
                    map_position[0]  = (position[2]-position[0])*defMapPos[0]+position[0]
                    map_position[1]  = (position[3]-position[1])*defMapPos[1]+position[1]
                    map_position[2]  = (position[2]-position[0])*defMapPos[2]+position[0]
                    map_position[3]  = (position[3]-position[1])*defMapPos[3]+position[1]
                 ENDELSE

                 ;;handle cb position
                 cb_position      = position
                 cb_position[0]   = (position[2]-position[0])*defCBPos[0]+position[0]
                 cb_position[1]   = (position[3]-position[1])*defCBPos[1]+position[1]
                 cb_position[2]   = (position[2]-position[0])*defCBPos[2]+position[0]
                 cb_position[3]   = (position[3]-position[1])*defCBPos[3]+position[1]

                 ;;handle integ position
                 IF KEYWORD_SET(show_integrals) THEN BEGIN
                    integ_position    = position
                    integ_position[0] = (position[2]-position[0])*defIntegPos[0]+position[0]
                    integ_position[1] = (position[3]-position[1])*defIntegPos[1]+position[1]
                    integ_position[2] = (position[2]-position[0])*defIntegPos[2]+position[0]
                    integ_position[3] = (position[3]-position[1])*defIntegPos[3]+position[1]
                    integ_delta       = (position[3]-position[1])*defIntegDelta
                 ENDIF

                 CASE N_ELEMENTS(h2dMaskArr) OF
                    1: h2dMask    = h2dMaskarr
                    N_ELEMENTS(h2dStrArr): BEGIN
                       h2dMask    = h2dMaskArr[j]
                    END
                    ELSE: BEGIN
                    END
                 ENDCASE
                 
                 IF KEYWORD_SET(make_integral_txtFile) THEN BEGIN
                    PRINTF,intLun,'************'
                    IF N_ELEMENTS(clockStr) GT 0 THEN BEGIN 
                       PRINTF,intLun,FORMAT='("clockString: ",A0)',clockStr[j]
                    ENDIF
                    PRINTF,intLun,FORMAT='("plotPos: ",I0)',j
                 ENDIF

                 PLOTH2D_STEREOGRAPHIC,h2dStrArr[j],tempFile, $
                                       EQUAL_AREA_BINNING=EA_binning, $
                                       H2DMASK=h2dMask, $
                                       NO_COLORBAR=no_cb, $
                                       WINDOW_XSIZE=xSize, $
                                       WINDOW_YSIZE=ySize, $
                                       MAP_POSITION=map_position, $
                                       CB_POSITION=cb_position, $
                                       CB_INFO=cb_info, $
                                       /NO_DISPLAY, $
                                       SUPPRESS_THICKGRID=suppress_tg, $
                                       SUPPRESS_GRIDLABELS=suppress_gl, $
                                       SUPPRESS_MLT_LABELS=suppress_Ml, $
                                       SUPPRESS_ILAT_LABELS=suppress_Il, $
                                       SUPPRESS_MLT_NAME=suppress_Mn, $
                                       SUPPRESS_ILAT_NAME=suppress_In, $
                                       SUPPRESS_TITLES=suppress_t, $
                                       LABELS_FOR_PRESENTATION=labels_for_presentation, $
                                       MIRROR=STRUPCASE(hemi) EQ 'SOUTH', $
                                       PLOTH2D_CONTOUR=plotH2D_contour, $
                                       CONTOUR__LEVELS=contour__levels, $
                                       CONTOUR__PERCENT=contour__percent, $
                                       PLOTRANGE=plotRange, $
                                       PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kernel_density_unmask, $
                                       CENTERS_MLT=centersMLT, $
                                       CENTERS_ILAT=centersILAT, $
                                       SHOW_INTEGRALS=show_integrals, $
                                       INTEG_POSITION=integ_position, $
                                       INTEG_DELTA=integ_delta, $
                                       DO_INTEGRAL_TXTFILE=KEYWORD_SET(make_integral_txtfile), $
                                       DO_INTEGRAL_SAVFILE=KEYWORD_SET(make_integral_savfile), $
                                       INTEGRALSAVFILE=integralSavFile, $
                                       INTLUN=intLun, $
                                       _EXTRA=e 

                 IF KEYWORD_SET(oplotStr) THEN BEGIN
                    ;; oplotStr.H2DStrArr[j].hasmask = 1
                    ;; oplotStr.H2DStrArr[j].mask     = oplotStr.H2DMaskArr[j].data
                    OP__H2DStrArr[j].hasmask  = 1
                    OP__H2DStrArr[j].mask     = OP__H2DMaskArr[j].data
                    PLOTH2D_STEREOGRAPHIC,OP__H2DStrArr[j],OP__overplot_file, $
                                          /OVERPLOT, $
                                          EQUAL_AREA_BINNING=EA_binning, $
                                          H2DMASK=h2dMask, $
                                          NO_COLORBAR=no_cb, $
                                          WINDOW_XSIZE=xSize, $
                                          WINDOW_YSIZE=ySize, $
                                          MAP_POSITION=map_position, $
                                          CB_POSITION=cb_position, $
                                          CB_INFO=op_cb_info, $
                                          /NO_DISPLAY, $
                                          SUPPRESS_THICKGRID=suppress_tg, $
                                          SUPPRESS_GRIDLABELS=suppress_gl, $
                                          SUPPRESS_MLT_LABELS=suppress_Ml, $
                                          SUPPRESS_ILAT_LABELS=suppress_Il, $
                                          SUPPRESS_MLT_NAME=suppress_Mn, $
                                          SUPPRESS_ILAT_NAME=suppress_In, $
                                          SUPPRESS_TITLES=suppress_t, $
                                          LABELS_FOR_PRESENTATION=labels_for_presentation, $
                                          MIRROR=STRUPCASE(hemi) EQ 'SOUTH', $
                                          ;; PLOTH2D_CONTOUR=plotH2D_contour, $
                                          ;; PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kernel_density_unmask, $
                                          /PLOTH2D_CONTOUR, $
                                          CONTOUR__LEVELS=op_contour__levels, $
                                          CONTOUR__PERCENT=op_contour__percent, $
                                          PLOTRANGE=op_plotRange, $
                                          /PLOTH2D__KERNEL_DENSITY_UNMASK, $
                                          CENTERS_MLT=centersMLT, $
                                          CENTERS_ILAT=centersILAT, $
                                          SHOW_INTEGRALS=show_integrals, $
                                          INTEG_POSITION=integ_position, $
                                          INTEG_DELTA=integ_delta, $
                                          DO_INTEGRAL_TXTFILE=KEYWORD_SET(make_integral_txtfile), $
                                          DO_INTEGRAL_SAVFILE=KEYWORD_SET(make_integral_savfile), $
                                          INTEGRALSAVFILE=integralSavFile, $
                                          INTLUN=intLun, $
                                          _EXTRA=e 
                    

                 ENDIF
              ENDFOR

              IF KEYWORD_SET(make_integral_txtfile) THEN BEGIN
                 CLOSE,intLun
                 FREE_LUN,intLun
              ENDIF

              ;; IF KEYWORD_SET(tile__cb_in_center_panel) THEN BEGIN
              ;;    tpTitle = h2dStrArr[0].title
              ;; ENDIF 

              IF KEYWORD_SET(tilePlotTitle) THEN BEGIN
                 tpTitle = tilePlotTitle
              ENDIF

              IF KEYWORD_SET(tpTitle) THEN BEGIN
                 ;; tilePlotText = TEXT(0.5, $
                 ;;                     yRatio + (1.-yRatio)/2., $
                 ;;                     tilePlotTitle, $
                 ;;                     /NORMAL, $
                 ;;                     ALIGNMENT=0.5, $
                 ;;                     FONT_SIZE=18)
                 CGTEXT,0.5, $
                        yRatio + (1.-yRatio)/1.5, $
                        tpTitle, $
                        /NORMAL, $
                        ALIGNMENT=0.5, $
                        CHARSIZE=1.7
              ENDIF

              ;;Find out where blank panels are if including IMF arrow/setting CB in center panel
              IF KEYWORD_SET(tile__include_IMF_arrows) OR KEYWORD_SET(tile__cb_in_center_panel) THEN BEGIN
                 jBlank       = WHERE(tiling_order LT 0)
                 IF jBlank[0] EQ -1 THEN BEGIN
                    PRINT,'No blank spot for me to put this thing!'
                    STOP
                 ENDIF
              ENDIF

              IF KEYWORD_SET(tile__cb_in_center_panel) THEN BEGIN

                 position         = CALC_PLOT_POSITION(jBlank+1,n_tile_columns,n_tile_rows)

                 ;;handle cb position
                 cb_position      = position
                 cb_position[0]   = (position[2]-position[0])*vertCBPos[0]+position[0]
                 cb_position[1]   = (position[3]-position[1])*vertCBPos[1]+position[1]
                 cb_position[2]   = (position[2]-position[0])*vertCBPos[2]+position[0]
                 cb_position[3]   = (position[3]-position[1])*vertCBPos[3]+position[1]


                 cb_info.vertical = 1
                 cb_info.position = cb_position
                 cb_info.charsize = 0.75

                 IF KEYWORD_SET(plotH2D_contour) THEN BEGIN
                    LOADCT, $
                       1, $
                       NCOLORS=cb_info.nColors+cb_info.bottom
                 ENDIF ELSE BEGIN
                    LOADCT, $
                       78, $
                       NCOLORS=cb_info.nColors+cb_info.bottom, $
                       FILE='~/idl/lib/hatch_idl_utils/colors/colorsHammer.tbl' ;Attempt to recreate (sort of) Bin's color bar
                 ENDELSE

                 CGCOLORBAR,NCOLORS=cb_info.nColors, $
                            XLOG=cb_info.XLOG, $
                            BOTTOM=cb_info.BOTTOM, $
                            OOB_LOW=TAG_EXIST(cb_info,'OOB_Low'  ) ? cb_info.OOB_Low  : !NULL, $
                            OOB_HIGH=TAG_EXIST(cb_info,'OOB_High') ? cb_info.OOB_High : !NULL, $
                            RANGE=cb_info.RANGE, $
                            TITLE=!NULL, $ ;cb_info.TITLE, $
                            DIVISIONS=(TAG_EXIST(cb_info,'cbNDivisions') ? cb_info.cbNDivisions : !NULL), $
                            TICKNAMES=(TAG_EXIST(cb_info,'cbTickNames') ? cb_info.cbTickNames : !NULL), $
                            TLOCATION=(TAG_EXIST(cb_info,'tLocation') ? cb_info.tLocation : !NULL), $
                            TCHARSIZE=cb_info.TCHARSIZE, $
                            POSITION=cb_info.POSITION, $
                            TEXTTHICK=cb_info.TEXTTHICK, $
                            VERTICAL=cb_info.VERTICAL, $
                            CHARSIZE=cb_info.CHARSIZE*1.3, $
                            TICKLEN=cb_info.TICKLEN

                 IF KEYWORD_SET(oplotStr) THEN BEGIN
                    ;;handle cb position
                    op_cb_position      = position
                    op_cb_position[0]   = (position[2]-position[0])*oPltCBPos[0]+position[0]
                    op_cb_position[1]   = (position[3]-position[1])*oPltCBPos[1]+position[1]
                    op_cb_position[2]   = (position[2]-position[0])*oPltCBPos[2]+position[0]
                    op_cb_position[3]   = (position[3]-position[1])*oPltCBPos[3]+position[1]

                    op_cb_info.vertical = 1
                    op_cb_info.position = op_cb_position
                    op_cb_info.charsize = 0.75

                    LOADCT, $
                       3, $
                       NCOLORS=op_cb_info.nColors+op_cb_info.bottom

                    CGCOLORBAR,NCOLORS=op_cb_info.nColors, $
                               XLOG=op_cb_info.XLOG, $
                               BOTTOM=op_cb_info.bottom, $
                               ;; BOTTOM=, $
                               OOB_LOW=TAG_EXIST(op_cb_info,'OOB_Low'  ) ? $
                               op_cb_info.OOB_Low  : !NULL, $ ;OOB_LOW=op_cb_info.OOB_Low EQ -9 ? !NULL : op_cb_info.OOB_Low, $   
                               OOB_HIGH=TAG_EXIST(op_cb_info,'OOB_High') ? $
                               op_cb_info.OOB_High : !NULL, $ ;OOB_HIGH=op_cb_info.OOB_High EQ -9 ? !NULL : op_cb_info.OOB_High, $
                               RANGE=op_cb_info.RANGE, $
                               TITLE=!NULL, $ ;op_cb_info.TITLE, $
                               DIVISIONS=op_cb_info.cbNDivisions, $
                               TICKNAMES=(TAG_EXIST(op_cb_info,'cbTickNames') ? op_cb_info.cbTickNames : !NULL), $
                               TLOCATION=(TAG_EXIST(op_cb_info,'tLocation') ? op_cb_info.tLocation : !NULL), $
                               POSITION=op_cb_info.POSITION, $
                               TEXTTHICK=op_cb_info.TEXTTHICK, $
                               VERTICAL=op_cb_info.VERTICAL, $
                               CHARSIZE=op_cb_info.CHARSIZE*1.3, $
                               TICKLEN=op_cb_info.TICKLEN

                 ENDIF
              ENDIF

              CGPS_Close 
              ;;Create a PNG file with a width of 800 pixels.
              IF ~KEYWORD_SET(eps_output) THEN BEGIN
                 CGPS2RASTER, plotDir + (KEYWORD_SET(org_plots_by_folder) ? dataNameArr[0] + '/' : '' ) + paramStr+tPSuff+'.ps', $
                              /PNG, $
                              WIDTH=800*n_tile_columns, $
                              DELETE_PS=del_PS

              ENDIF

              IF KEYWORD_SET(tile__include_IMF_arrows) THEN BEGIN

                 position         = CALC_PLOT_POSITION(jBlank+1,n_tile_columns,n_tile_rows)

                 arrowFile  = '/home/spencerh/Desktop/Spence_paper_drafts/2016/Alfvens_IMF/Figs/clockAngle_for_zhang_analog_v4.png'

                 ;; wDim       = [800*n_tile_columns,800*n_tile_rows]
                 ;; wDim       = [800*n_tile_columns*xRatio,800*n_tile_rows*yRatio]
                 wDim       = [800*n_tile_rows*yRatio,800*n_tile_columns*xRatio]

                 win        = WINDOW(DIMENSIONS=wDim, $
                                     /BUFFER)

                 im1        = IMAGE(plotDir + (KEYWORD_SET(org_plots_by_folder) ? dataNameArr[0] + '/' : '' ) + paramStr + tPSuff + '.png', $
                                    MARGIN=0, $
                                    /CURRENT, $
                                    ;; DIMENSIONS=[xSize*100,ySize*100], $
                                    DIMENSIONS=wDim, $
                                    IMAGE_DIMENSIONS=wDim) ;;, $
                 ;; IMAGE_DIMENSIONS=[800,800])
                 
                 imArrow    = IMAGE(arrowFile, $
                                    ;; LAYOUT=[n_tile_columns,n_tile_rows,jBlank+1], $
                                    POSITION=position, $
                                    MARGIN=0, $
                                    /CURRENT, $
                                    ;; DIMENSIONS=[xSize*100,ySize*100], $
                                    ;; DIMENSIONS=[800*n_tile_columns,800*n_tile_rows], $
                                    ;; DIMENSIONS=[800,800], $
                                    DIMENSIONS=wDim, $
                                    IMAGE_DIMENSIONS=[801,801])

                 win.SAVE,plotDir + (KEYWORD_SET(org_plots_by_folder) ? dataNameArr[0] + '/' : '' ) + paramStr + tPSuff + '.png'

                 win.CLOSE

                 win = !NULL

                 ;; blankPos   = CALC_PLOT_POSITION(j+1,n_tile_columns,n_tile_rows)

                 ;; arrowImage = READ_IMAGE(arrowFile,R,G,B)
                 ;; CGIMAGE,arrowImage,POSITION=blankPos,/INTERPOLATE,/SCALE
                 ;; redChannel = REFORM(arrowImage[0, *, *])
                 ;; TV,redChannel,blankpos[0],blankpos[1],XSIZE=xSize,YSIZE=ySize,/NORMAL

                 ;; DEVICE,DECOMPOSED=0
                 ;; TVLCT,R,G,B
                 ;; arrowImage = IMAGE(arrowFile, $
                 ;;                    AXIS_STYLE=0, $
                 ;;                    ;; DIMENSIONS=[xSize*100,ySize*100], $
                 ;;                    ;; IMAGE_LOCATION=blankPos[0:1], $
                 ;;                    /CURRENT)

                 ;; arrowImage.POSITION = blankPos

              ENDIF
                 
              !P.MULTI = 0

           ENDIF ELSE BEGIN

              xSize    = 5
              ySize    = 5

              integ_position = [0.11 , 0.78, 0.68 , 0.74]
              integ_delta    = 0.05

              FOR i=0, N_ELEMENTS(h2dStrArr) - 2 DO BEGIN  
                 
                 CASE N_ELEMENTS(no_colorbar) OF
                    0:    no_cb = !NULL
                    1:    no_cb = no_colorbar
                    ELSE: no_cb = no_colorbar[i]
                 ENDCASE

                 CGPS_Open, plotDir + (KEYWORD_SET(org_plots_by_folder) ? dataNameArr[i] + '/' : '' ) + paramStr+'--'+dataNameArr[i]+'.ps', $
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
                 
                 IF KEYWORD_SET(make_integral_txtfile) THEN BEGIN

                    integralFile = txtOutputDir + paramStr + '--' + $
                                   dataNameArr[i] + '--integrals.txt'

                    OPENW,intLun,integralFile,/GET_LUN,/APPEND

                    PRINTF,intLun,'************'
                    PRINTF,intLun,FORMAT='(A0)',h2dStrArr[i].title
                 ENDIF

                 IF KEYWORD_SET(make_integral_savfile) THEN BEGIN
                    integralSavFile = txtOutputDir + (KEYWORD_SET(integralSavFilePref) ? integralSavFilePref : paramStr ) + $
                                      dataNameArr[i] + '--integrals.sav'
                 ENDIF

                 PLOTH2D_STEREOGRAPHIC,h2dStrArr[i],tempFile, $
                                       EQUAL_AREA_BINNING=EA_binning, $
                                       NO_COLORBAR=no_cb, $
                                       WINDOW_XSIZE=xSize, $
                                       WINDOW_YSIZE=ySize, $
                                       MAP_POSITION=map_position, $
                                       /NO_DISPLAY, $
                                       CB_POSITION=cb_position, $
                                       SUPPRESS_THICKGRID=suppress_thickGrid, $
                                       SUPPRESS_GRIDLABELS=suppress_gridLabels, $
                                       SUPPRESS_MLT_LABELS=suppress_MLT_labels, $
                                       SUPPRESS_ILAT_LABELS=suppress_ILAT_labels, $
                                       SUPPRESS_TITLES=suppress_titles, $
                                       LABELS_FOR_PRESENTATION=labels_for_presentation, $
                                       MIRROR=STRUPCASE(hemi) EQ 'SOUTH', $
                                       PLOTH2D_CONTOUR=plotH2D_contour, $
                                       CONTOUR__LEVELS=contour__levels, $
                                       CONTOUR__PERCENT=contour__percent, $
                                       PLOTRANGE=plotRange, $
                                       PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kernel_density_unmask, $
                                       CENTERS_MLT=centersMLT, $
                                       CENTERS_ILAT=centersILAT, $
                                       SHOW_INTEGRALS=show_integrals, $
                                       INTEG_POSITION=integ_position, $
                                       INTEG_DELTA=integ_delta, $
                                       DO_INTEGRAL_TXTFILE=KEYWORD_SET(make_integral_txtfile), $
                                       DO_INTEGRAL_SAVFILE=KEYWORD_SET(make_integral_savfile), $
                                       INTEGRALSAVFILE=integralSavFile, $
                                       INTLUN=intLun, $
                                       _EXTRA=e 
                 CGPS_Close 
                 ;;Create a PNG file with a width of 800 pixels.
                 IF ~KEYWORD_SET(eps_output) THEN BEGIN
                    CGPS2RASTER, plotDir + (KEYWORD_SET(org_plots_by_folder) ? dataNameArr[i] + '/' : '' ) + paramStr+'--'+dataNameArr[i]+'.ps', $
                                 /PNG, $
                                 WIDTH=800, $
                                 DELETE_PS=del_PS
                 ENDIF

                 IF KEYWORD_SET(make_integral_txtFile) THEN BEGIN
                    CLOSE,intLun
                    FREE_LUN,intLun
                 ENDIF


              ENDFOR

           ENDELSE

        ENDELSE
           
     ENDELSE
  ENDELSE


END