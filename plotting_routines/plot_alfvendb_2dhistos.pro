;2016/01/15 EPS Output keyword added 
;2016/01/19
PRO PLOT_ALFVENDB_2DHISTOS,H2DSTRARR=h2dStrArr,DATANAMEARR=dataNameArr,TEMPFILE=tempFile, $
                           SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ 
                           SHOWPLOTSNOSAVE=showPlotsNoSave, $
                           PLOTDIR=plotDir, PLOTMEDORAVG=plotMedOrAvg, $
                           PARAMSTR=paramStr, DEL_PS=del_PS, $
                           HEMI=hemi, $
                           CLOCKSTR=clockStr, $
                           NO_COLORBAR=no_colorbar, $
                           TILE_IMAGES=tile_images, $
                           N_TILE_ROWS=n_tile_rows, $
                           N_TILE_COLUMNS=n_tile_columns, $
                           LUN=lun, $
                           EPS_OUTPUT=eps_output, $
                           _EXTRA = e

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
        FOR i = 0, N_ELEMENTS(h2dStrArr) - 2 DO BEGIN
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
        
        FOR i = 0, N_ELEMENTS(h2dStrArr) - 2 DO BEGIN  
           
           IF KEYWORD_SET(polarContour) THEN BEGIN
              ;; The NAME field of the !D system variable contains the name of the
              ;; current plotting device.
              mydevice = !D.NAME
              
              ;; Set plotting to PostScript:
              SET_PLOT, 'PS'
              
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
              
              ;; Return plotting to the original device:
              SET_PLOT, mydevice
           ENDIF ELSE BEGIN
              ;;Create a PostScript file.
              CGPS_Open, plotDir + paramStr+'--'+dataNameArr[i]+'.ps', $
                         /NOMATCH, $
                         XSIZE=5, $
                         YSIZE=5, $
                         LANDSCAPE=0, $
                         ENCAPSULATED=eps_output


              PLOTH2D_STEREOGRAPHIC,h2dStrArr[i],tempFile, $
                                    NO_COLORBAR=no_colorbar, $
                                    POSITION=position, $
                                    MIRROR=STRUPCASE(hemi) EQ 'SOUTH', $
                                    _EXTRA=e 
              CGPS_Close 
              ;;Create a PNG file with a width of 800 pixels.
              IF ~KEYWORD_SET(eps_output) THEN BEGIN
                 CGPS2RASTER, plotDir + paramStr+'--'+dataNameArr[i]+'.ps', $
                              /PNG, $
                              WIDTH=400, $
                              DELETE_PS=del_PS
              ENDIF
           ENDELSE
           
        ENDFOR    

     ENDELSE
  ENDELSE

END