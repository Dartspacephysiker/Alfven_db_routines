;;2016/04/05 I just want to take a glance at 2D histos sometimes, K?
;;2016/04/05 Commented out all reference to L-shell (nearly)
PRO SIMPLE_H2DPLOTTER_STEREOGRAPHIC,h2dStr, $
                                    H2DMASK=h2dMask, $
                                    INDATA=inData, $
                                    IN_MLTS=in_mlts, $
                                    IN_ILATS=in_ilats, $
                                    PLOT_I=plot_i, $
                                    TMPLT_H2DSTR=tmplt_h2dStr, $
                                    IN_H2DMASK=in_h2dMask, $
                                    MASKMIN=maskMin, $
                                    MASKCOLOR=in_maskColor, $
                                    PLOT_ON_LOGSCALE=logScale, $
                                    UNLOG_LABELS=unlog_labels, $
                                    LABELFORMAT=labelFormat, $
                                    DO_MIDCB_LABEL=do_midCB_label, $
                                    MINMLT=minM,MAXMLT=maxM,BINM=binM, $
                                    SHIFTMLT=shiftM, $
                                    MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $                                    
                                    WHOLECAP=wholeCap,MIDNIGHT=midnight, $
                                    PLOTTITLE=plotTitle, MIRROR=mirror, $
                                    SHOW_PLOT_INTEGRAL=show_plotIntegral, $
                                    GRIDCOLOR=gridColor, $
                                    DEBUG=debug, $
                                    LOGAVGPLOT=logAvgPlot, $
                                    MEDIANPLOT=medianPlot, $
                                    CURRENT=current, $
                                    POSITION=position, $
                                    WINDOW_XPOS=xPos, $
                                    WINDOW_YPOS=yPos, $
                                    NO_DISPLAY=no_display, $
                                    NO_COLORBAR=no_colorbar, $
                                    CB_LIMITS=cb_limits, $
                                    CB_FORCE_OOBLOW=cb_force_ooblow, $
                                    CB_FORCE_OOBHIGH=cb_force_oobhigh, $
                                    OUT_H2D_DATA=h2dData, $
                                    _EXTRA=e

  COMPILE_OPT idl2,strictarrsubs

  @ploth2d_stereographic_defaults.pro

  SET_DEFAULT_MLT_ILAT_AND_MAGC,MINMLT=minM,MAXMLT=maxM, $
                                BINM=binM, $
                                SHIFTMLT=shiftM, $
                                MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                ;; MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                                HEMI=hemi, $
                                NORTH=north, $
                                SOUTH=south, $
                                BOTH_HEMIS=both_hemis, $
                                LUN=lun  
  
  IF ~KEYWORD_SET(no_display) THEN BEGIN
     ;; CGDISPLAY;; ,COLOR="black", $
     ;; XSIZE=KEYWORD_SET(postScript) ? 5 : !NULL, $
     ;; YSIZE=KEYWORD_SET(postScript) ? 5 : !NULL, $
               ;; XSIZE=KEYWORD_SET(xSize) ? xSize : def_H2D_xSize, $
               ;; YSIZE=KEYWORD_SET(ySize) ? ySize : def_H2D_ySize, $
              ;;  ;; /MATCH, $
              ;;  ;; XPOS=xPos, $
              ;;  ;; YPOS=yPos, $
              ;;  /LANDSCAPE_FORCE
  ENDIF

  IF KEYWORD_SET(in_h2dMask) THEN h2dMask = in_h2dMask
  IF KEYWORD_SET(in_maskColor) THEN maskColor = in_maskColor ELSE maskColor = 'GRAY'
  ;; IF N_ELEMENTS(gridColor) EQ 0 THEN gridColor = defGridColor
  IF N_ELEMENTS(gridColor) EQ 0 THEN gridColor = 'BLACK'

  IF KEYWORD_SET(plot_i) THEN BEGIN
     PRINT,"Using plot_i to get MLTs and ILATs"
     LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime
     in_mlts           = maximus.mlt[plot_i]
     in_ilats          = maximus.ilat[plot_i]
  ENDIF

  nDim = SIZE(inData, /N_DIMENSIONS)
  IF nDim NE 2 THEN BEGIN
     CASE nDim OF
        0: BEGIN
           PRINT,"No data provided! Try again, sucker."
        END
        1: BEGIN
           IF KEYWORD_SET(in_mlts) AND KEYWORD_SET(in_ilats) THEN BEGIN
              PRINT,"Making 2D histo from provided elements..."

              ;;First, histo to show where events are
              GET_H2D_NEVENTS_AND_MASK,maximus,plot_i, $
                                       IN_MLTS=in_mlts, $
                                       IN_ILATS=in_ilats, $
                                       MINM=minM, $
                                       MAXM=maxM, $
                                       BINM=binM, $
                                       SHIFTM=shiftM, $
                                       MINI=minI, $
                                       MAXI=maxI, $
                                       BINI=binI, $
                                       ;; DO_LSHELL=do_lshell, $
                                       ;; MINL=minL, $
                                       ;; MAXL=maxL, $
                                       ;; BINL=binL, $
                                       NEVENTSPLOTRANGE=nEventsPlotRange, $
                                       TMPLT_H2DSTR=tmplt_h2dStr, $
                                       H2DSTR=h2dStr, $
                                       H2DMASKSTR=h2dMaskStr, $
                                       H2DFLUXN=h2dFluxN, $
                                       H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                                       MASKMIN=maskMin, $
                                       DATANAME=dataName, $
                                       DATARAWPTR=dataRawPtr

              IF ~KEYWORD_SET(h2dMask) THEN h2dMask = h2dMaskStr.data

              CASE 1 OF
                 KEYWORD_SET(medianPlot): BEGIN 

                    IF KEYWORD_SET(medHistOutData) THEN BEGIN
                       medHistDatFile      = medHistDataDir + dataName+"medhist_data.sav"
                    ENDIF
                    
                    h2dData=median_hist(in_mlts,in_ilats,inData, $
                                            MIN1=MINM,MIN2=MINI,$
                                            MAX1=MAXM,MAX2=MAXI,$
                                            BINSIZE1=binM,BINSIZE2=binI,$
                                            OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT,$
                                            ABSMED=absFlux,OUTFILE=medHistDatFile,PLOT_I=plot_i) 
                    
                    IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + dataName + "medhist.txt"
                 END
                 ELSE: BEGIN
                    h2dData=hist2d(in_mlts,in_ilats,(KEYWORD_SET(logAvgPlot) ? ALOG10(inData) : inData),$
                                       MIN1=MINM,MIN2=MINI,$
                                       MAX1=MAXM,MAX2=MAXI,$
                                       BINSIZE1=binM,BINSIZE2=binI,$
                                       OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
                    h2dData[h2d_nonzero_nEv_i]=h2dData[h2d_nonzero_nEv_i]/h2dFluxN[h2d_nonzero_nEv_i] 
                    
                    IF KEYWORD_SET(logAvgPlot) THEN h2dData[where(h2dFluxN NE 0,/NULL)] = 10^(h2dData[where(h2dFluxN NE 0,/NULL)])
                    
                 END
              ENDCASE              
           ENDIF ELSE BEGIN
              PRINT,"Can't make a histo unless you provide the goods! Need MLTs and ILATs."
              RETURN
           ENDELSE
        END
        ELSE: BEGIN
           PRINT,"What on earth are you trying to feed me? I need either a vector or a 2d array, children"
           RETURN
        END
     ENDCASE

  ENDIF ELSE BEGIN
     h2dData = inData
  ENDELSE

  IF N_ELEMENTS(wholeCap) EQ 0 THEN BEGIN
     IF ABS(minM - 0.00) LT 0.0001 AND ABS(maxM-24.00) LT 0.0001 THEN wholeCap = 1
  ENDIF

  ; Open a graphics window.
  IF N_ELEMENTS(current) GT 1 THEN current.set_current ELSE BEGIN
     CGDISPLAY,COLOR="white", $
     XSIZE=KEYWORD_SET(postScript) ? 5 : !NULL, $
     YSIZE=KEYWORD_SET(postScript) ? 5 : !NULL, $
     XPOS=xPos, $
     YPOS=yPos, $
     /LANDSCAPE_FORCE

  END

  IF KEYWORD_SET(mirror) THEN BEGIN
     IF mirror NE 0 THEN mirror = 1 ELSE mirror = 0
  ENDIF ELSE mirror = 0

  IF KEYWORD_SET(midnight) THEN BEGIN
     IF midnight EQ 0 THEN midnight=!NULL
  ENDIF
  
  position = KEYWORD_SET(position) ? position : defH2DMapPosition
  lim      = [(mirror) ? -maxI : minI,minM*15,(mirror) ? -minI : maxI,maxM*15]
  
  IF mirror THEN BEGIN
     IF minI GT 0 THEN centerLat = -90 ELSE centerLat = 90
  ENDIF ELSE BEGIN
     IF minI GT 0 THEN centerLat = 90 ELSE centerLat = -90
  ENDELSE

  IF minI LT 0 AND NOT mirror THEN BEGIN
     IF midnight NE !NULL THEN centerLon = 180 ELSE centerLon = 0
  ENDIF ELSE BEGIN
     IF midnight NE !NULL THEN centerLon = 0 ELSE centerLon = 180
  ENDELSE

  cgMap_Set, centerLat, centerLon,/STEREOGRAPHIC, /HORIZON, $
             /ISOTROPIC, /NOERASE, /NOBORDER, POSITION=position,LIMIT=lim
                
  IF N_ELEMENTS(plotTitle) EQ 0 THEN BEGIN
     plotTitle = "SIMPLE H2D PLOTTER"
  ENDIF

  ;;Select color table
  IF ~KEYWORD_SET(logScale) THEN BEGIN

     IF N_ELEMENTS(WHERE(h2dData) LT 0) GT 0 THEN BEGIN
        ;; RAINBOW_COLORS,N_COLORS=nLevels

        ;;This is the one for doing sweet flux plots that include negative values 
        ;; cgLoadCT, ctIndex, BREWER=ctBrewer, REVERSE=ctReverse, NCOLORS=nLevels
     ENDIF ELSE BEGIN
        ;; SUNSET_COLORS,N_COLORS=nLevels
     ENDELSE

  ENDIF ELSE BEGIN
     ;; This one is the one we use for nEvent- and orbit-type plots (plots w/ all positive values)
     ;; RAINBOW_COLORS,N_COLORS=nLevels
     ;; cgLoadCT, ctIndex_allPosData, BREWER=ctBrewer_allPosData, REVERSE=ctReverse_allPosData, NCOLORS=nLevels

     ;; IF chrisPosScheme THEN BEGIN
     ;;    ;;make last color dark red
     ;;    TVLCT,r,g,b,/GET   
     ;;    r[nLevels-1]             = 180
     ;;    g[nLevels-1]             = 0
     ;;    b[nLevels-1]             = 0
     ;;    TVLCT,r,g,b
     ;; ENDIF

  ENDELSE
  LOADCT,78,FILE='~/idl/lib/hatch_idl_utils/colors/colorsHammer.tbl'  ;Attempt to recreate (sort of) Bin's color bar


  ; Set up the contour levels.
  ;   levels = cgScaleVector(Indgen(nlevels), 0,255)      
  

  ;;Get longitudes for drawing boxes
  nXlines                   = (maxM-minM)/binM + 1
  mlts                      = indgen(nXlines)*binM+minM
  gridLons                  = [0,90,180,270,360]


  ;; IF KEYWORD_SET(do_lShell) THEN BEGIN
  ;;    nYlines                = (maxL-minL)/binL + 1
  ;;    lShells                = INDGEN(nYlines)*binL + minL
  ;;    ilats                  = LSHELL_TO_ILAT_PARABOLA_FIT(lShells, $
  ;;                                                         MINL=minL, $
  ;;                                                         MAXL=maxL, $
  ;;                                                         MINI=minI, $
  ;;                                                         MAXI=maxI)
  ;;    ;; ilats                  = DOUBLE(ROUND(ilats*4))/4

  ;;    gridLats               = LSHELL_TO_ILAT_PARABOLA_FIT(lShells[0:-1:3], $
  ;;                                                         MINL=minL, $
  ;;                                                         MAXL=maxL, $
  ;;                                                         MINI=minI, $
  ;;                                                         MAXI=maxI)
  ;;    gridLatNames           = lShells[0:-1:3]

  ;;    IF KEYWORD_SET(reverse_lShell) THEN BEGIN
  ;;       h2dData           = SHIFT(REVERSE(h2dData,2),0,-1)
  ;;       gridLatNames        = REVERSE(gridLatNames)
  ;;    ENDIF
  ;; ENDIF ELSE BEGIN

     ;;Don't erase these lines! You need them

     nYlines                = (maxI-minI)/binI + 1
     ilats                  = indgen(nYlines)*binI + minI

     ;;Option #1: Calculate the gridlats
     ;; CASE 1 OF
     ;;    (maxI-minI) LE 12: BEGIN
     ;;       minISpacing      = 6
     ;;    END
     ;;    (maxI-minI) LE 20: BEGIN
     ;;       minISpacing      = 8
     ;;    END
     ;;    (maxI-minI) LE 30: BEGIN
     ;;       minISpacing      = 10
     ;;    END
     ;;    (maxI-minI) GT 30: BEGIN
     ;;       minISpacing      = 10
     ;;    END
     ;; ENDCASE

     ;; satisfied              = 0
     ;; gridIFactor            = 1
     ;; WHILE ~satisfied DO BEGIN
     ;;    gridISpacing        = binI * gridIFactor
     ;;    IF gridISpacing LT minISpacing THEN BEGIN
     ;;       gridIFactor++
     ;;    ENDIF ELSE BEGIN
     ;;       satisfied        = 1
     ;;    ENDELSE
     ;; ENDWHILE

     ;; gridLats               = INDGEN(10)*gridISpacing + minI
     ;; calcILines             = (maxI-minI)/minISpacing 
     ;; CASE 1 OF 
     ;;    calcILines LE 3: BEGIN
     ;;       gridLats               = gridLats[WHERE(gridLats GE minI AND gridLats LE maxI)]
     ;;    END
     ;;    calcILines LE 4: BEGIN
     ;;       gridMinIDist           = MIN(ABS(gridLats-minI))
     ;;       gridMaxIDist           = MIN(ABS(gridLats-maxI))
     ;;       IF gridMinIDist LT gridMaxIDist THEN BEGIN
     ;;          gridLats               = gridLats[WHERE(gridLats GT minI AND gridLats LE maxI)]
     ;;       ENDIF ELSE BEGIN
     ;;          gridLats               = gridLats[WHERE(gridLats GE minI AND gridLats LT maxI)]
     ;;       ENDELSE
     ;;    END
     ;;    calcILines GT 4: BEGIN
     ;;       gridLats               = gridLats[WHERE(gridLats GT minI AND gridLats LT maxI)]
     ;;    END
     ;; ENDCASE
     ;; gridLats               = FIX(gridLats)
     ;; gridLatNames           = gridLats

     ;;Option #2: Preset gridLats
     gridLats               = defGridLats * (ABS(minI)/minI) ;IF WHERE((INDGEN(10)*binI + minI 
     gridLatNames           = defGridLats * (ABS(minI)/minI)
     ;; ENDELSE

     ;;Make sure the thicker gridLats fall right on one of our ilats
     maxGridSep = 0.25D
     FOR k=0,N_ELEMENTS(gridLats)-1 DO BEGIN
        IF MIN(ABS(gridLats[k]-ilats),tempI) GT maxGridSep THEN BEGIN
           gridLats[k] = ilats[tempI]
        ENDIF
     ENDFOR

     ;;Don't erase these lines! They are the only thing keeping SH plots from being insane
     IF maxI LT 0 THEN BEGIN
        ilats                     = -1.0*REVERSE(ilats)
        gridLats                  = -1.0*REVERSE(gridLats)
     ENDIF

     gridLats                     = FIX(gridLats)
     gridLatNames                 = gridLats


     IF mirror THEN BEGIN
        ilats                        = -1.0 * ilats 
        gridLats                     = -1.0 * gridLats
        ;; gridLatNames                 = -1.0 * gridLatNames
     ENDIF

     ;;binary matrix to tell us where masked values are
     IF N_ELEMENTS(h2dStr) GT 0 THEN BEGIN
        CASE 1 OF
           h2dStr.hasMask: BEGIN
              h2dMaskData               = h2dStr.mask
           END
           KEYWORD_SET(h2dMask): BEGIN
              h2dMaskData               = h2dMask.data
           END
           ELSE: BEGIN
              nPlots                    = 1
              h2dMaskData               = h2dStrArr[nPlots].data
           END
        ENDCASE
        
        IF h2dStr.dont_mask_me THEN BEGIN
           masked                       = (h2dMaskData GT 260.0) ;mask NO ONE!
        ENDIF ELSE BEGIN
           masked                       = (h2dMaskData GT 250.0)
        ENDELSE

     ENDIF ELSE BEGIN
        IF N_ELEMENTS(h2dMask) GT 0 THEN BEGIN
           masked                       = (h2dMask.data GT 250.0)
        ENDIF ELSE BEGIN
           masked                       = FIX(h2dData)
           masked[*,*]                  = 0
        ENDELSE   
     ENDELSE


  ;; IF KEYWORD_SET(reverse_lShell) THEN BEGIN
  ;;    masked[*,1:-1]               = REVERSE(masked[*,1:-1],2)
  ;;    masked                       = SHIFT(masked,0,-1)
  ;; ENDIF
  notMasked_i                       = WHERE(~masked)

  CASE 1 OF
     KEYWORD_SET(h2dStr): BEGIN
        cb_limits = h2dStr.lim
     END
     ELSE: BEGIN
        IF ~KEYWORD_SET(cb_limits) THEN BEGIN
           cb_limits               = [MIN(h2dData[notMasked_i]),MAX(h2dData[notMasked_i])]
        ENDIF
     END
  ENDCASE


  h2descl                         = MAKE_ARRAY(SIZE(h2dData,/DIMENSIONS),VALUE=0)

  ;;Scale this stuff
  ;;The reason for all the trickery is that we want to know what values are out of bounds,
  ;; and bytscl doesn't do things quite the way we need them done.
  is_OOBHigh                = 0
  is_OOBLow                 = 0
  OOB_HIGH_i                = WHERE(h2dData GT cb_limits[1] AND ~masked)
  OOB_LOW_i                 = WHERE(h2dData LT cb_limits[0] AND ~masked)

  IF ~KEYWORD_SET(cb_force_oobHigh) THEN BEGIN
     cb_force_oobHigh       = 0
  ENDIF
  IF KEYWORD_SET(cb_force_oobLow) THEN BEGIN
     cb_force_oobLow        = 0
  ENDIF

  IF OOB_HIGH_i[0] NE -1 OR KEYWORD_SET(cb_force_oobhigh) THEN BEGIN
     is_OOBHigh             = 1
  ENDIF

  IF OOB_LOW_i[0] NE -1 OR KEYWORD_SET(cb_force_ooblow) THEN BEGIN
     is_OOBLow              = 1
  ENDIF
  
  h2descl[notMasked_i]      = BYTSCL(h2dData[notMasked_i], $
                                     TOP=nLevels-1-is_OOBHigh-is_OOBLow, $
                                     MAX=cb_limits[1], $
                                     MIN=cb_limits[0] ) + is_OOBLow

  IF OOB_HIGH_i[0] NE -1 THEN BEGIN
     h2descl[OOB_HIGH_i]    = BYTE(nLevels-1)
  ENDIF
  IF OOB_LOW_i[0] NE -1 THEN BEGIN
     h2descl[OOB_LOW_i]     = 0B
  ENDIF

  ;;******************************
  ;;PLOT STUFF
  ;;******************************
  ;;Get polyfill vertices
  lonsLats                  = GET_H2D_STEREOGRAPHIC_POLYFILL_VERTICES(mlts,ilats, $
                                                                      BINSIZE_LON=binM, $
                                                                      SHIFT_LON=shiftM, $
                                                                      ;; BINSIZE_LAT=(KEYWORD_SET(do_lShell) ? binL : binI), $
                                                                      /MOREPOINTS, $
                                                                      BINSIZE_LAT=binI, $
                                                                      /CONVERT_MLT_TO_LON, $
                                                                      COUNTERCLOCKWISE=KEYWORD_SET(reverse_lShell))

  ;;Fill up dat plot
  H2D_STEREOGRAPHIC_EXECUTE_POLYFILL,lonsLats,h2descl, $
                                     H2D_MASKED=masked, $
                                     MASKCOLOR=maskColor
  ;;Calc an integral?
  IF KEYWORD_SET(show_plotIntegral) THEN BEGIN
     H2D_STEREOGRAPHIC_INTEGRAL,h2dStr,lonsLats, $
                                H2D_MASKED=masked, $
                                INTEGRAL=integral, $
                                ABSINTEGRAL=absIntegral, $
                                DAWNINTEGRAL=dawnIntegral, $
                                DUSKINTEGRAL=duskIntegral
  ENDIF

  ;;******************************
  ;;Grid stuffs
  ;;******************************
  ;; Add map grid. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword. 
  IF KEYWORD_SET(shiftM) THEN BEGIN
     shiftedMLTs                     = (indgen((maxM-minm)/binM+1)*binM+shiftM)*15.
  ENDIF ELSE BEGIN
     shiftedMLTs                     = !NULL
  ENDELSE
  cgMap_Grid, CLIP_TEXT=1, $
              /NOCLIP, $
              LINESTYLE=0, $
              THICK=(!D.Name EQ 'PS') ? defGridLineThick_PS : defGridLineThick,$
              COLOR=gridColor, $
              LONDELTA=binM*15, $
              LONS=shiftedMLTs, $
              LATS=ilats


  ;;add thicker grid to a few latitude lines
  cgMap_Grid, Clip_Text=1, $
              /NoClip, $
              thick=(!D.Name EQ 'PS') ? defGridBoldLineThick_PS : defGridBoldLineThick,$
              LINESTYLE=defBoldGridLineStyle, $
              COLOR=gridColor, $
              LONDELTA=defBoldLonDelta, $
              LONS=gridLons, $
              LATS=gridLats


  ; Now text. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword. 
  ;; IF KEYWORD_SET(do_lShell) THEN BEGIN
  ;;    lonLabel=(minI GT 0 ? minI : maxI)
  ;;    IF mirror THEN lonLabel = -1.0 * lonLabel ;mirror dat
  ;; ENDIF ELSE BEGIN
     lonLabel=(minI GT 0 ? minI : maxI)
     IF mirror THEN lonLabel = -1.0 * lonLabel ;mirror dat
  ;; ENDELSE 

  IF KEYWORD_SET(wholeCap) THEN BEGIN
     factor                          = 6.0
     mltSites                        = (INDGEN((maxM-minM)/factor)*factor+minM)
     lonNames                        = [string(minM,format=lonLabelFormat) + " MLT", $
                                        STRING(mltSites[1:-1], $
                                               format=lonLabelFormat)]

     gridLatNames                    = STRING(gridLatNames,format=latLabelFormat)
     gridLatNames[mirror ? -1 : 0]   = gridLatNames[mirror ? -1 : 0] + $
                                       ( KEYWORD_SET(DO_lShell) ? " L-shell" : " ILAT" )

     ;; cgMap_Grid, Clip_Text=1, $
     ;;             /NoClip, $
     ;;             /LABEL, $
     ;;             /NO_GRID, $
     ;;             LINESTYLE=0, $
     ;;             THICK=3, $
     ;;             COLOR=defGridTextColor, $
     ;;             LATS=gridLats, $
     ;;             LATNAMES=gridLatNames, $
     ;;             LATLABEL=45, $
     ;;             LONS=mltSites*15, $
     ;;             LONNAMES=lonNames, $
     ;;             LONLABEL=lonLabel, $
     ;;             CHARSIZE=defCharSize_grid

     ;;MLTs
     cgText,MEAN([position[2],position[0]]), position[1]-0.035,'0 MLT',/NORMAL, $
            COLOR=defGridTextColor,ALIGNMENT=0.5,CHARSIZE=defCharSize_grid      
     cgText,MEAN([position[2],position[0]]), position[3]+0.005,'12',/NORMAL, $
            COLOR=defGridTextColor,ALIGNMENT=0.5,CHARSIZE=defCharSize_grid   
     cgText,position[2]+0.02, MEAN([position[3],position[1]])-0.015,'6',/NORMAL, $
            COLOR=defGridTextColor,ALIGNMENT=0.5,CHARSIZE=defCharSize_grid
     cgText,position[0]-0.03, MEAN([position[3],position[1]])-0.015,'18',/NORMAL, $
            COLOR=defGridTextColor,ALIGNMENT=0.5,CHARSIZE=defCharSize_grid

     ;;ILATs
     FOR ilat_i=0,N_ELEMENTS(gridLats)-1 DO BEGIN
        cgText, 45, gridLats[ilat_i], STRCOMPRESS(gridLats[ilat_i],/REMOVE_ALL), $
                ALIGNMENT=0.5,ORIENTATION=0,COLOR=defGridTextColor,CHARSIZE=defCharSize_grid      
     ENDFOR

  ENDIF ELSE BEGIN

     ;;Longitudes
     lonNames                       = STRING(FORMAT='(I2)',(INDGEN(24/(binM*2))*(2*binM)))
     nLons                          = N_ELEMENTS(lonNames)

     ;;Latitudes
     IF mirror THEN BEGIN
        minLatLabel                    = CEIL(-maxI/10.)*10
        maxLatLabel                    = FLOOR(-minI/10.)*10
     ENDIF ELSE BEGIN
        minLatLabel                    = CEIL(minI/10.)*10
        maxLatLabel                    = FLOOR(maxI/10.)*10
     ENDELSE
     nLats                          = (maxLatLabel-minLatLabel)/10+1

     lats                           = !NULL
     FOR l=0,nLats-1 DO lats        = [lats,minLatLabel+l*10]
     IF minI GT 0 THEN $
        latNames                    = STRING(FORMAT='(I2)',lats) $
     ELSE $
        latNames                    = STRING(FORMAT='(I3)',KEYWORD_SET(mirror) ? -lats : lats)

     cgMap_Grid, Clip_Text=1, $
                 /NOCLIP, $
                 /NO_GRID,$
                 /LABEL, $
                 LINESTYLE=0, $
                 THICK=3, $
                 COLOR=defGridTextColor, $
                 ;; LATDELTA=(KEYWORD_SET(do_lShell) ? binL : binI*4 ),$
                 LATDELTA=(KEYWORD_SET(do_lShell) ? binL : !NULL ),$
                 LATS=(KEYWORD_SET(do_lShell) ? !NULL : lats), $
                 LATNAMES=latNames, $
                 LATLABEL=minM*15-10, $
                 LONLABEL=lonLabel,$ 
                 LONS=(1*INDGEN(nLons)*360/nLons),$
                 LONNAMES=lonNames, $
                 CHARSIZE=defCharSize_grid
  ENDELSE

  IF KEYWORD_SET(show_plotIntegral) THEN BEGIN
     

     cgText, lTexPos1, $
             bTexPos2, $
             '|Integral|: ' + string(absIntegral,FORMAT=integralLabelFormat), $
             /NORMAL, $
             CHARSIZE=defCharSize
     cgText,lTexPos1, $
            bTexPos1, $
            'Integral: ' + string(integral,Format=integralLabelFormat), $
            /NORMAL, $
            CHARSIZE=defCharSize 
     cgText,lTexPos2, $
            bTexPos1, $
            'Dawnward: ' + string(dawnIntegral,Format=integralLabelFormat), $
            /NORMAL, $
            CHARSIZE=defCharSize 
     cgText,lTexPos2, $
            bTexPos2, $
            'Duskward: ' + string(duskIntegral,Format=integralLabelFormat), $
            /NORMAL, $
            CHARSIZE=defCharSize 


  ENDIF

  ;;******************************
  ;;Colorbar stuffs
  ;;******************************

  IF ~KEYWORD_SET(no_colorBar) THEN BEGIN
     ;;set up colorbal labels
     IF NOT KEYWORD_SET(labelFormat) THEN BEGIN
        labelFormat                 = defLabelFormat
     ENDIF
     lowerLab                       =(KEYWORD_SET(logScale) AND KEYWORD_SET(unlog_labels)) ? $
                                     10.^(cb_limits[0]) : cb_limits[0]
     UpperLab                       =(KEYWORD_SET(logScale) AND KEYWORD_SET(unlog_labels)) ? $
                                     10.^cb_limits[1] : cb_limits[1]
     
     IF KEYWORD_SET(do_midCB_label) THEN BEGIN
        midLab                      = (cb_limits[1] + cb_limits[0])/2.0
        IF KEYWORD_SET(unlog_labels) THEN BEGIN
           midLab                   = 10.^midLab
        ENDIF
     ENDIF ELSE BEGIN
        midLab                      = ''
     ENDELSE
     
     cbSpacingStr_low  = (nLevels-1)/2-is_OOBLow
     cbSpacingStr_high = (nLevels-1)/2-is_OOBHigh
     
     cbOOBLowVal       = (MIN(h2dData[notMasked_i]) LT cb_limits[0] OR KEYWORD_SET(cb_force_ooblow)) ? $
                         0B : !NULL
     cbOOBHighVal      = (MAX(h2dData[notMasked_i]) GT cb_limits[1] OR KEYWORD_SET(cb_force_oobhigh)) ? $
                         BYTE(nLevels-1) : !NULL
     cbRange           = (KEYWORD_SET(logScale) AND KEYWORD_SET(unlog_labels)) ? 10.^(ROUND(cb_limits*100.)/100.) : cb_limits
     cbTitle           = plotTitle
     nCBColors         = nlevels-is_OOBHigh-is_OOBLow
     cbBottom          = BYTE(is_OOBLow)

     cgColorbar, NCOLORS=nCBColors, $
                 ;; DIVISIONS=nCBColors, $
                 XLOG=(KEYWORD_SET(logScale) AND KEYWORD_SET(unlog_labels)), $
                 BOTTOM=cbBottom, $
                 OOB_Low=cbOOBLowVal, $
                 OOB_High=cbOOBHighVal, $ 
                 ;; /Discrete, $
                 RANGE=cbRange, $
                 TITLE=cbTitle, $
                 POSITION=cbPosition, TEXTTHICK=cbTextThick, VERTICAL=cbVertical, $
                 TLOCATION=cbTLocation, TCHARSIZE=cbTCharSize,$
                 CHARSIZE=cbTCharSize,$
                 TICKLEN=0.5, $
                 ;; TICKINTERVAL=(KEYWORD_SET(logScale) AND KEYWORD_SET(unlog_labels)) ? 0.25 : !NULL, $
                 TICKNAMES=cbTickNames

  ENDIF
END