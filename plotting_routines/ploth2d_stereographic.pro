;;2015/12/02 Fixed the reverse_lshell thing so that radial bins get SHIFTed outward by one
;;           position. Without this fix, it appeared that FAST had data below L=2 (50
;;           deg ILAT), which FAST never did. Now all is well in Zion.
;;2015/10/21 Changed a ton of stuff. Look out. (Specifically, added a new defaults file for plot labels, removed dependence on string
;;checking to see if plot has logged data, and stuff así

;;03/07/2015
;; Added mirror keyword so that data in the Southern hemisphere have the same orientation as that of
;;data in the Northern hemisphere
;; Right now I think I need to do something with reversing tempMLTS or changing the way tempMLTS is
;; put together, but I can't be sure

PRO PLOTH2D_STEREOGRAPHIC,temp,ancillaryData, $
                          EQUAL_AREA_BINNING=EA_binning, $
                          H2DMASK=h2dMask, $
                          WHOLECAP=wholeCap, $
                          MIDNIGHT=midnight, $
                          PLOTTITLE=plotTitle, MIRROR=mirror, $
                          DEBUG=debug, $
                          NO_COLORBAR=no_colorbar, $
                          MAP_POSITION=map_position, $
                          CB_POSITION=cb_position, $
                          INTEG_POSITION=integ_position, $
                          INTEG_DELTA=integ_delta, $
                          WINDOW_XPOS=xPos, $
                          WINDOW_YPOS=yPos, $
                          WINDOW_XSIZE=xSize, $
                          WINDOW_YSIZE=ySize, $
                          NO_DISPLAY=no_display, $
                          SUPPRESS_THICKGRID=suppress_thickGrid, $
                          SUPPRESS_GRIDLABELS=suppress_gridLabels, $
                          SUPPRESS_MLT_LABELS=suppress_MLT_labels, $
                          SUPPRESS_ILAT_LABELS=suppress_ILAT_labels, $
                          SUPPRESS_MLT_NAME=suppress_MLT_name, $
                          SUPPRESS_ILAT_NAME=suppress_ILAT_name, $
                          SUPPRESS_TITLES=suppress_titles, $
                          LABELS_FOR_PRESENTATION=labels_for_presentation, $
                          CB_FORCE_OOBLOW=cb_force_ooblow, $
                          CB_FORCE_OOBHIGH=cb_force_oobhigh, $
                          CB_INFO=cb_info, $
                          EQ_SCALE_CT=eq_scale_ct, $
                          PLOTH2D_CONTOUR=plotH2D_contour, $
                          CENTERS_MLT=centersMLT, $
                          CENTERS_ILAT=centersILAT, $
                          SHOW_INTEGRALS=show_integrals, $
                          DO_INTEGRAL_TXTFILE=do_integral_txtfile, $
                          DO_INTEGRAL_SAVFILE=do_integral_savfile, $
                          INTEGRALSAVFILE=integralSavFile, $
                          INTLUN=intLun, $
                          _EXTRA=e

  COMPILE_OPT idl2

  IF KEYWORD_SET(EA_binning) THEN BEGIN

     LOAD_EQUAL_AREA_BINNING_STRUCT,EA

     ilats        = ABS(EA.maxI)
     mlts         = EA.maxM

  ENDIF

  RESTORE,ancillaryData

  IF N_ELEMENTS(wholeCap) EQ 0 THEN BEGIN
     IF ABS(minM - 0.00) LT 0.0001 AND ABS(maxM-24.00) LT 0.0001 THEN BEGIN
        wholeCap  = 1
     ENDIF
  ENDIF

  @ploth2d_stereographic_defaults.pro

  ;; Open a graphics window.
  IF ~KEYWORD_SET(no_display) THEN BEGIN
     CGDISPLAY,COLOR="black", $
               XSIZE=KEYWORD_SET(xSize) ? xSize : def_H2D_xSize, $
               YSIZE=KEYWORD_SET(ySize) ? ySize : def_H2D_ySize, $
               ;; /MATCH, $
               ;; XPOS=xPos, $
               ;; YPOS=yPos, $
               /LANDSCAPE_FORCE
  ENDIF

  IF KEYWORD_SET(mirror) THEN BEGIN
     IF mirror NE 0 THEN BEGIN
        mirror        = 1
     ENDIF ELSE BEGIN
        mirror        = 0
     ENDELSE
  ENDIF ELSE BEGIN
     mirror           = 0
  ENDELSE

  ;; IF KEYWORD_SET(wholeCap) THEN BEGIN
  ;;    IF wholeCap EQ 0 THEN wholeCap=!NULL
  ;; ENDIF
  IF N_ELEMENTS(midnight) EQ 0 THEN BEGIN
     midnight         = 1
  ENDIF
  ;;    IF midnight EQ 0 THEN midnight=!NULL
  ;; ENDIF

  ;; IF N_ELEMENTS(wholeCap) EQ 0 THEN BEGIN
  ;; IF ~KEYWORD_SET(wholeCap) THEN BEGIN
  ;; map_position     = [0.1, 0.075, 0.9, 0.75]
  IF ~KEYWORD_SET(map_position) THEN BEGIN
     map_position     = defH2DMapPosition
  ENDIF
  lim                 = [(mirror) ? -maxI : minI,minM*15,(mirror) ? -minI : maxI,maxM*15]
  ;; ENDIF ELSE BEGIN
  ;;    map_position  = [0.05, 0.05, 0.85, 0.85]
  ;;    lim=[(mirror) ? -maxI : minI, 0 ,(mirror) ? -minI : maxI,360] ;
  ;; ;; lim           = [minimum lat, minimum long, maximum lat, maximum long]
  ;; ENDELSE

  ;; xScale        = (defH2DMapPosition[2]-defH2DMapPosition[0])/(map_position[2]-map_position[0])
  ;; yScale        = (defH2DMapPosition[3]-defH2DMapPosition[1])/(map_position[3]-map_position[1])
  xScale           = (map_position[2]-map_position[0])/(defH2DMapPosition[2]-defH2DMapPosition[0])
  yScale           = (map_position[3]-map_position[1])/(defH2DMapPosition[3]-defH2DMapPosition[1])
  charScale        = (xScale*yScale)^(1./2.)
  gridScale        = (xScale*yScale)^(1./1.)

  IF mirror THEN BEGIN
     IF minI GT 0 THEN BEGIN
        centerLat  = -90
     ENDIF ELSE BEGIN
        centerLat  = 90
     ENDELSE
  ENDIF ELSE BEGIN
     IF minI GT 0 THEN BEGIN
        centerLat  = 90
     ENDIF ELSE BEGIN
        centerLat  = -90
     ENDELSE
  ENDELSE

  IF minI LT 0 AND NOT mirror THEN BEGIN
     IF midnight NE !NULL THEN BEGIN
        centerLon  = 180
     ENDIF ELSE BEGIN
        centerLon  = 0
     ENDELSE
  ENDIF ELSE BEGIN
     IF midnight NE !NULL THEN BEGIN
        centerLon  = 0
     ENDIF ELSE BEGIN
        centerLon  = 180
     ENDELSE
  ENDELSE

  CGMAP_SET,centerLat,centerLon,/STEREOGRAPHIC,/HORIZON, $
             /ISOTROPIC,/NOERASE,/NOBORDER, $
            POSITION=map_position,LIMIT=lim
  ;;Limit=[minI-5,maxM*15-360,maxI+5,minM*15],

  IF N_ELEMENTS(plotTitle) EQ 0 THEN BEGIN
     plotTitle     = temp.title
  ENDIF

  ;;Get longitudes for drawing boxes
  IF ~KEYWORD_SET(EA_binning) THEN BEGIN
     nXlines       = (maxM-minM)/binM + 1
     mlts          = indgen(nXlines)*binM+minM
  ENDIF
  ;; IF KEYWORD_SET(wholeCap) THEN BEGIN
  gridLons         = [0,90,180,270,360]
  ;; ENDIF

  IF KEYWORD_SET(do_lShell) THEN BEGIN
     IF KEYWORD_SET(EA_binning) THEN BEGIN
        PRINT,"Can't do l-shell stuff with equal-area binning"
        STOP
     ENDIF
     nYlines       = (maxL-minL)/binL + 1
     lShells       = INDGEN(nYlines)*binL + minL
     ilats         = LSHELL_TO_ILAT_PARABOLA_FIT(lShells, $
                                                 MINL=minL, $
                                                 MAXL=maxL, $
                                                 MINI=minI, $
                                                 MAXI=maxI)
     ;; ilats      = DOUBLE(ROUND(ilats*4))/4

     gridLats      = LSHELL_TO_ILAT_PARABOLA_FIT(lShells[0:-1:3], $
                                                 MINL=minL, $
                                                 MAXL=maxL, $
                                                 MINI=minI, $
                                                 MAXI=maxI)
     gridLatNames  = lShells[0:-1:3]

     IF KEYWORD_SET(reverse_lShell) THEN BEGIN
        temp.data     = SHIFT(REVERSE(temp.data,2),0,-1)
        gridLatNames  = REVERSE(gridLatNames)
     ENDIF
  ENDIF ELSE BEGIN

     IF maxI LT 0 THEN BEGIN
        tempMinI      = ABS(maxI)
        tempMaxI      = ABS(minI)
     ENDIF ELSE BEGIN
        tempMinI      = minI
        tempMaxI      = maxI
     ENDELSE

     ;;Don't erase these lines! You need them
     IF ~KEYWORD_SET(EA_binning) THEN BEGIN
        nYlines       = (tempMaxI-tempMinI)/binI + 1
        ilats         = indgen(nYlines)*binI + tempMinI
     ENDIF

     ;;;;;;;;;;
     ;;BEGIN OPTIONS
     ;;;;;;;;;;

     ;;Option #1: Calculate the gridlats
     ;; CASE 1 OF
     ;;    (tempmaxI-tempminI) LE 12: BEGIN
     ;;       minISpacing   = 6
     ;;    END
     ;;    (tempmaxI-tempminI) LE 20: BEGIN
     ;;       minISpacing   = 8
     ;;    END
     ;;    (tempmaxI-tempminI) LE 30: BEGIN
     ;;       minISpacing   = 10
     ;;    END
     ;;    (tempmaxI-tempminI) GT 30: BEGIN
     ;;       minISpacing   = 10
     ;;    END
     ;; ENDCASE

     ;; satisfied           = 0
     ;; gridIFactor         = 1
     ;; WHILE ~satisfied DO BEGIN
     ;;    gridISpacing     = binI * gridIFactor
     ;;    IF gridISpacing LT minISpacing THEN BEGIN
     ;;       gridIFactor++
     ;;    ENDIF ELSE BEGIN
     ;;       satisfied     = 1
     ;;    ENDELSE
     ;; ENDWHILE


     ;; gridLats            = INDGEN(10)*gridISpacing + tempMinI
     ;; calcILines          = (tempMaxI-tempMinI)/minISpacing
     ;; CASE 1 OF
     ;;    calcILines LE 3: BEGIN
     ;;       gridLats      = gridLats[WHERE(gridLats GE tempMinI AND gridLats LE tempMaxI)]
     ;;    END
     ;;    calcILines LE 4: BEGIN
     ;;       gridMinIDist  = MIN(ABS(gridLats-tempMinI))
     ;;       gridMaxIDist  = MIN(ABS(gridLats-tempMaxI))
     ;;       IF gridMinIDist LT gridMaxIDist THEN BEGIN
     ;;          gridLats   = gridLats[WHERE(gridLats GT tempMinI AND gridLats LE tempMaxI)]
     ;;       ENDIF ELSE BEGIN
     ;;          gridLats   = gridLats[WHERE(gridLats GE tempMinI AND gridLats LT tempMaxI)]
     ;;       ENDELSE
     ;;    END
     ;;    calcILines GT 4: BEGIN
     ;;       gridLats      = gridLats[WHERE(gridLats GT tempMinI AND gridLats LT tempMaxI)]
     ;;    END
     ;; ENDCASE

     ;;Option #2: Preset gridLats
     gridLats           = defGridLats
     ;; IF KEYWORD_SET(EA_binning) THEN BEGIN
     ;;    IF STRUPCASE(EA.hemi) EQ 'SOUTH' THEN BEGIN
     ;;       gridLats    *= -1.
     ;;    ENDIF
     ;; ENDIF
     ;;;;;;;;;;
     ;;END OPTIONS
     ;;;;;;;;;;

     ;;Make sure the thicker gridLats fall right on one of our ilats
     maxGridSep         = 0.25D
     FOR k=0,N_ELEMENTS(gridLats)-1 DO BEGIN
        IF MIN(ABS(gridLats[k]-ilats),tempI) GT maxGridSep THEN BEGIN
           gridLats[k]  = ilats[tempI]
        ENDIF
     ENDFOR

     ;;Don't erase these lines! They are the only thing keeping SH plots from being insane
     IF maxI LT 0 THEN BEGIN
        ilats           = -1.0*REVERSE(ilats)
        gridLats        = -1.0*REVERSE(gridLats)
     ENDIF

     gridLats           = FIX(gridLats)
     gridLatNames       = gridLats

  ENDELSE


  IF mirror THEN BEGIN
     ilats              = -1.0 * ilats
     gridLats           = -1   * FIX(gridLats)
     ;; gridLatNames    = -1.0 * gridLatNames
  ENDIF

  ;;binary matrix to tell us where masked values are
  CASE 1 OF
     temp.hasMask: BEGIN
        h2dMaskData  = temp.mask
     END
     KEYWORD_SET(h2dMask): BEGIN
        h2dMaskData  = h2dMask.data
     END
     ELSE: BEGIN
        nPlots       = N_ELEMENTS(h2dStrArr)-1 ;Subtract one since last array is the mask
        h2dMaskData  = h2dStrArr[nPlots].data
     END
  ENDCASE

  IF temp.dont_mask_me THEN BEGIN
     masked          = (h2dMaskData GT 260.0) ;mask NO ONE!
  ENDIF ELSE BEGIN
     masked          = (h2dMaskData GT 250.0)
  ENDELSE

  IF KEYWORD_SET(reverse_lShell) THEN BEGIN
     masked[*,1:-1]  = REVERSE(masked[*,1:-1],2)
     masked          = SHIFT(masked,0,-1)
  ENDIF
  notMasked          = WHERE(~masked)

  h2descl            = MAKE_ARRAY(SIZE(temp.data,/DIMENSIONS),VALUE=0)


  ;;5 bar things per decade
  ;; IF KEYWORD_SET(temp.is_logged) THEN BEGIN
  ;;    nLevels                   = CEIL(temp.lim[1]-temp.lim[0])*5
  ;; ENDIF

  ;;Select color table
  ;; IF temp.is_fluxData AND ~temp.is_logged THEN BEGIN
  IF ~temp.is_logged THEN BEGIN

     IF N_ELEMENTS(WHERE(temp.data[notMasked] LT 0,/NULL)) EQ 0 AND ~temp.do_posNeg_cb THEN BEGIN
        ;; RAINBOW_COLORS,N_COLORS=nLevels
        ;; LOADCT,76  ;Modded rainbow; drops purples at bottom
        ;; LOADCT,77 ;greenthing

        ;;This is the one for doing sweet flux plots that include negative values
        ;; cgLoadCT, ctIndex, BREWER=ctBrewer, REVERSE=ctReverse, NCOLORS=nLevels
     ENDIF ELSE BEGIN
        SUNSET_COLORS,N_COLORS=nLevels
     ENDELSE

  ENDIF ELSE BEGIN
     IF temp.do_posNeg_cb THEN BEGIN
        SUNSET_COLORS,N_COLORS=nLevels

        ;;This is the one for doing sweet flux plots that include negative values
        ;; cgLoadCT, ctIndex, BREWER=ctBrewer, REVERSE=ctReverse, NCOLORS=nLevels
     ENDIF ELSE BEGIN
        ;; This one is the one we use for nEvent- and orbit-type plots (plots w/ all positive values)
        ;; RAINBOW_COLORS,N_COLORS=nLevels
        ;; LOADCT,76  ;Modded rainbow; drops purples at bottom
        ;; LOADCT,77 ;greenthing
     ENDELSE

     ;; cgLoadCT, ctIndex_allPosData, BREWER=ctBrewer_allPosData, REVERSE=ctReverse_allPosData, NCOLORS=nLevels

     ;; IF chrisPosScheme THEN BEGIN
     ;;    ;;make last color dark red
     ;;    TVLCT,r,g,b,/GET
     ;;    r[nLevels-1]           = 180
     ;;    g[nLevels-1]           = 0
     ;;    b[nLevels-1]           = 0
     ;;    TVLCT,r,g,b
     ;; ENDIF

  ENDELSE

  ;; RAINBOW_COLORS,N_COLORS=nLevels
  ;; RAINBOW_COLORS,N_COLORS=nLevels
  ;; LOADCT,81  ;Modded rainbow; drops purples at bottom
  ;; LOADCT,84  ;Attempt to recreate (sort of) Bin's color bar
  LOADCT,78,FILE='~/idl/lib/hatch_idl_utils/colors/colorsHammer.tbl'  ;Attempt to recreate (sort of) Bin's color bar
  ;; LOADCT,33
  ;; LOADCT,77 ;greenthing
  ;; LOADCT2,39 ;FAST rainbow table

  eq_scale_ct = 0
  IF KEYWORD_SET(eq_scale_ct) THEN BEGIN
     TVLCT,r,g,b,/GET

     rScale = [r[0],EQUAL_SCALE_ARR(r[1:-1],/QUIET)]
     gScale = [g[0],EQUAL_SCALE_ARR(g[1:-1],/QUIET)]
     bScale = [b[0],EQUAL_SCALE_ARR(b[1:-1],/QUIET)]
     TVLCT,rScale,gScale,bScale

  ENDIF
  ;; Set up the contour levels.
  ;;   levels                     = cgScaleVector(Indgen(nlevels), 0,255)
  nLevels                         = 255

     ;; IF chrisPosScheme THEN BEGIN
     ;;    ;;make first color dark gray
     ;;    TVLCT,r,g,b,/GET
     ;;    r[0]           = 100
     ;;    g[0]           = 100
     ;;    b[0]           = 100
     ;;    TVLCT,r,g,b
     ;; ENDIF

  ;;Scale this stuff
  ;;The reason for all the trickery is that we want to know what values are out of bounds,
  ;; and bytscl doesn't do things quite the way we need them done.
  is_OOBHigh              = 0
  is_OOBLow               = 0
  OOB_HIGH_i              = WHERE(temp.data GT temp.lim[1] AND ~masked)
  OOB_LOW_i               = WHERE(temp.data LT temp.lim[0] AND ~masked)

  IF KEYWORD_SET(cb_force_oobHigh) THEN BEGIN
     temp.force_oobHigh   = 1
  ENDIF
  IF KEYWORD_SET(cb_force_oobLow) THEN BEGIN
     temp.force_oobLow    = 1
  ENDIF

  IF OOB_HIGH_i[0] NE -1 OR temp.force_oobHigh THEN BEGIN
     is_OOBHigh           = 1
  ENDIF

  IF OOB_LOW_i[0] NE -1 OR temp.force_oobLow THEN BEGIN
     is_OOBLow            = 1
  ENDIF

  h2descl[notMasked]      = BYTSCL(temp.data[notMasked], $
                                   TOP=nLevels-1-is_OOBHigh-is_OOBLow, $
                                   MAX=temp.lim[1], $
                                   MIN=temp.lim[0] ) + is_OOBLow

  IF OOB_HIGH_i[0] NE -1 THEN BEGIN
     h2descl[OOB_HIGH_i]  = BYTE(nLevels-1)
  ENDIF
  IF OOB_LOW_i[0] NE -1 THEN BEGIN
     h2descl[OOB_LOW_i]   = 0B
  ENDIF

  ;;******************************
  ;;PLOT STUFF
  ;;******************************
  ;;Get polyfill vertices
  CASE 1 OF
     KEYWORD_SET(plotH2D_contour): BEGIN

        h2dTmp =  DOUBLE(temp.data)

        CASE 1 OF
           KEYWORD_SET(EA_binning): BEGIN
              ;; tmpLons = (mlts+temp.shift1)*15.
              ;; tmpLats = ilats

              tmpLons = ( (ea.minM+ea.maxM)/2. + temp.shift1 )* 15.
              tmpLats = (ea.mini+ea.maxi)/2.

              ;; h2dTmp[WHERE(masked)] = 0.0D
              ;; this    = SORT(tmpLons)
              ;; tmpLons = tmpLons[this]
              ;; tmpLats = tmpLats[this]
              ;; h2dTmp  = h2dTmp[this]
           END
           ELSE: BEGIN
              ;; h2dTmp = h2dTmp[0:-2,*]
              ;; h2dTmp = h2dTmp[*,0:-2]
              ;; masked  = masked[0:-2,*]
              ;; masked  = masked[*,0:-2]

              tmpMasked = masked

              h2dTmp   [-1,*] = h2dTmp[0,*]
              tmpMasked[-1,*] = tmpMasked[0,*]
              tmpNotMasked    = WHERE(~tmpMasked)

              h2dTmp  = h2dTmp[0:-2,*   ]
              h2dTmp  = h2dTmp[   *,0:-2]
              tmpLons = centersMLT + binM/2.*15.
              tmpLats = centersILAT + binI/2

              tmpLons  = tmpLons[0:-2,*   ]
              tmpLons  = tmpLons[   *,0:-2]
              tmpLats  = tmpLats[0:-2,*   ]
              tmpLats  = tmpLats[   *,0:-2]
              ;; IF (WHERE(masked))[0] NE -1 THEN BEGIN
              ;;    h2dTmp[WHERE(masked)] = !VALUES.F_NaN
              ;; ENDIF

              ;; tmpLons = centersMLT
              ;; tmpLats = centersILAT
              ;; tmpLons = centersMLT [0:-2,*   ]
              ;; tmpLons = centersMLT [   *,0:-2]
              ;; tmpLats = centersILAT[0:-2,*   ]
              ;; tmpLats = centersILAT[   *,0:-2]

              ;; FOR k=0,N_ELEMENTS(mlts)  DO PRINT,tmpLats[k,0],tmpLons[k,0]
              ;; FOR k=0,N_ELEMENTS(ilats) DO PRINT,tmpLats[0,k],tmpLons[0,k]
           END
        ENDCASE

        lonDelta = 1.0
        latDelta = 1.0
        ;; nX       = (maxM-minM)/lonDelta*15.
        ;; ny       = (maxI-minI)/latDelta
        ;; outLons = FINDGEN(nX)            # REPLICATE(lonDelta,nY) + lonDelta/2.0
        ;; outLats = REPLICATE(latDelta,nX) # FINDGEN(nY) + minI + latDelta/2.0
        nX       = (maxM-minM)/lonDelta*15.+1
        ny       = (maxI-minI)/latDelta+1
        outLons = FINDGEN(nX)            # REPLICATE(lonDelta,nY)
        outLats = REPLICATE(latDelta,nX) # FINDGEN(nY) + minI

        ;; IF KEYWORD_SET(EA_binning) THEN BEGIN
        ;;    TRIANGULATE,tmpLons,tmpLats,FVALUE=h2dTmp,SPHERE=sph,/DEGREES
        ;;    bro = TRIGRID(h2dTmp,SPHERE=sph,[lonDelta,latDelta],[lim[1],lim[0],lim[3],lim[2]],/DEGREES)
        ;; ENDIF

        ;;temporarily flatten
        tmpDim = SIZE(h2dTmp,/DIM)
        h2dTmp = REFORM(h2dTmp,N_ELEMENTS(h2dTmp))
        tmpLons = REFORM(tmpLons,N_ELEMENTS(tmpLons))
        tmpLats = REFORM(tmpLats,N_ELEMENTS(tmpLats))
        newescl = MIN_CURVE_SURF(DOUBLE(h2dTmp), DOUBLE(tmpLons), DOUBLE(tmpLats), $
                                 /SPHERE, $
                                 ;; /TPS, $
                                 CONST=KEYWORD_SET(EA_binning), $
                                 XPOUT=outLons,YPOUT=outLats, $
                                 /DOUBLE)

        newescl      = BYTSCL(newescl, $
                              TOP=nLevels-1-is_OOBHigh-is_OOBLow, $
                              MAX=temp.lim[1], $
                              MIN=temp.lim[0] ) + is_OOBLow

        nCLevels = 9
        cLevels  = [0,ROUND((FINDGEN(nCLevels-1)+1)*nLevels/(nCLevels-1))]
        defgridcolor = 'black' 
        ;; CONTOUR,h2dTmp, $
        ;;         tmpLons, $
        ;;         tmpLats, $
        CONTOUR,newescl, $
                outLons, $
                outLats, $
                ;; /IRREGULAR, $
                LEVELS=cLevels, $
                /CELL_FILL, $
                C_COLORS=cLevels, $
                /OVERPLOT

        ;; lat = REPLICATE(10., 37) # FINDGEN(19) - 90.
        ;; lon = FINDGEN(37) # REPLICATE(10, 19)
        ;; Convert lat and lon to Cartesian coordinates:
        ;; X = COS(!DTOR * lon) * COS(!DTOR * lat)
        ;; Y = SIN(!DTOR * lon) * COS(!DTOR * lat)
        ;; Z = SIN(!DTOR * lat)
        ;; Create the function to be plotted, set it equal
        ;; to the distance squared from (1,1,1):
        ;; F = (X-1.)^2 + (Y-1.)^2 + (Z-1.)^2
        ;; CONTOUR, F, lon, lat, NLEVELS=7, $
        ;;          /OVERPLOT, /DOWNHILL, /FOLLOW
        ;; cgColorFill,tempLons,tempLats, $
        ;;             COLOR=(h2d_masked[j]) ? maskColor : h2dScaledData[j]

     END
     ELSE: BEGIN
        lonsLats  = GET_H2D_STEREOGRAPHIC_POLYFILL_VERTICES(mlts,ilats, $
                                                            EQUAL_AREA_BINNING=EA_binning, $
                                                            BINSIZE_LON=binM, $
                                                            SHIFT_LON=temp.shift1, $
                                                            BINSIZE_LAT=(KEYWORD_SET(do_lShell) ? binL : binI), $
                                                            /CONVERT_MLT_TO_LON, $
                                                            /MOREPOINTS, $
                                                            COUNTERCLOCKWISE=KEYWORD_SET(reverse_lShell))

        ;;Fill up dat plot
        H2D_STEREOGRAPHIC_EXECUTE_POLYFILL,lonsLats,h2descl, $
                                           EQUAL_AREA_BINNING=EA_binning, $
                                           H2D_MASKED=masked, $
                                           MASKCOLOR=maskColor

     END
  ENDCASE

  ;;Calc an integral?
  IF temp.do_plotIntegral OR $
     KEYWORD_SET(do_integral_txtfile) OR $
     KEYWORD_SET(do_integral_savfile) OR $
     KEYWORD_SET(show_integrals) THEN BEGIN
     H2D_STEREOGRAPHIC_INTEGRAL,temp,lonsLats, $
                                EQUAL_AREA_BINNING=EA_binning, $
                                H2D_MASKED=masked, $
                                INTEGRAL=integral, $
                                ABSINTEGRAL=absIntegral, $
                                DAWNINTEGRAL=dawnIntegral, $
                                DUSKINTEGRAL=duskIntegral, $
                                DAYINTEGRAL=dayIntegral, $
                                NIGHTINTEGRAL=nightIntegral, $
                                OUTPUT_INTEGRAL_TXTFILE=KEYWORD_SET(do_integral_txtfile), $
                                OUTPUT_INTEGRAL_SAVFILE=KEYWORD_SET(do_integral_savfile), $
                                INTEGSAVFILE=integralSavFile, $
                                INTLUN=intLun

  ENDIF

  ;;******************************
  ;;Grid stuffs
  ;;******************************
  ;; Add map grid. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword.
  IF KEYWORD_SET(temp.shift1) THEN BEGIN
     ;; shiftedMLTs               = ((maxM-minM)/binM+temp.shift1) * 15.
     shiftedMLTs                  = (indgen((maxM-minM)/binM+1)*binM+temp.shift1)*15.
     ;; gridLons                  = gridLons + temp.shift1*15
  ENDIF ELSE BEGIN
     shiftedMLTs                  = !NULL
  ENDELSE

  IF binI GT 3.0 THEN BEGIN
     CGMAP_GRID, CLIP_TEXT=1, $
                 /NOCLIP, $
                 LINESTYLE=0, $
                 THICK=((!D.Name EQ 'PS') ? defGridLineThick_PS : defGridLineThick_PS)*gridScale,$
                 COLOR=defGridColor, $
                 LONDELTA=binM*15, $
                 ;; LATDELTA=(KEYWORD_SET(do_lShell) ? !NULL : binI ), $
                 LONS=shiftedMLTs, $
                 ;;LATDELTA=(KEYWORD_SET(do_lShell) ? binL : binI )
                 LATS=ilats
     ;; LATS=(KEYWORD_SET(do_lShell) ? ilats : !NULL)
  ENDIF


  ;;add thicker grid to a few latitude lines
  ;; IF temp.shift1 LT 0.0001 THEN BEGIN
  IF ~KEYWORD_SET(suppress_thickGrid) THEN BEGIN
     CGMAP_GRID, CLIP_TEXT=1, $
                 /NOCLIP, $
                 THICK=((!D.Name EQ 'PS') ? defGridBoldLineThick_PS : defGridBoldLineThick)*gridScale,$
                 LINESTYLE=defBoldGridLineStyle, $
                 COLOR=defGridColor, $
                 ;; LATDELTA=(KEYWORD_SET(do_lShell) ? !NULL : defBoldLatDelta), $
                 LONDELTA=defBoldLonDelta, $
                 LONS=gridLons, $
                 LATS=gridLats
     ENDIF

                                ; Now text. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword.
  IF KEYWORD_SET(do_lShell) THEN BEGIN
     ;; lonLabel=(minL GT 0 ? minL : maxL)
     lonLabel=(minI GT 0 ? minI : maxI)
     IF mirror THEN lonLabel      = -1.0 * lonLabel ;mirror dat
  ENDIF ELSE BEGIN
     lonLabel=(minI GT 0 ? minI : maxI)
     IF mirror THEN lonLabel      = -1.0 * lonLabel ;mirror dat
  ENDELSE

  IF ~KEYWORD_SET(suppress_gridLabels) THEN BEGIN

     IF KEYWORD_SET(wholeCap) THEN BEGIN
        factor                    = 6.0
        mltSites                  = (INDGEN((maxM-minM)/factor)*factor+minM)
        mltName                   = KEYWORD_SET(suppress_MLT_name) ? '' : " MLT"
        lonNames                  = [string(minM,format=lonLabelFormat) + mltName, $
                                     STRING(mltSites[1:-1], $
                                            format=lonLabelFormat)]

        ;; IF mirror THEN BEGIN
        ;;    ;;    ;;IF N_ELEMENTS(wholeCap) NE 0 THEN BEGIN
        ;;   ;;   ;;    lonNames  = [lonNames[0],REVERSE(lonNames[1:*])]
        ;;   ;;   ;; ENDIF
        ;;    gridLats            = -1.0 * gridLats
        ;;    gridLatNames        = -1.0 * gridLatNames
        ;; ENDIF

        gridLatNames              = STRING(gridLatNames,format=latLabelFormat)
        tmpInd                    = mirror ? -1 : 0
        gridLatNames[tmpInd]      = gridLatNames[tmpInd] + $
                                    ( KEYWORD_SET(suppress_ILAT_name) ? '' : $
                                      ( KEYWORD_SET(DO_lShell) ? " L-shell" : " " ) )  ;" ILAT" ) )

        ;; cgMap_Grid, Clip_Text=1, $
        ;;             /NoClip, $
        ;;             ;; /LABEL, $
        ;;             /NO_GRID, $
        ;;             LINESTYLE=0, $
        ;;             THICK=3, $
        ;;             COLOR=defGridTextColor, $
        ;;             LATS=gridLats, $
        ;;             LATNAMES=gridLatNames, $
        ;;             ;; LATDELTA=(KEYWORD_SET(do_lShell) ? binL : binI )*4,$
        ;;             ;; LATLABEL=(mean([minM,maxM]))*15+15, $
        ;;             ;; LATLABEL=((maxM-minM)/2.0+minM)*15-binM*7.5,
        ;;             ;;LONNAMES=[strtrim(minM,2)+" MLT",STRTRIM(INDGEN((maxM-minM)/1.0)+(minM+1),2)]
        ;;             LATLABEL=45, $
        ;;             ;; LONS=mltSites*15, $
        ;;             ;; LONNAMES=lonNames, $
        ;;             LONLABEL=lonLabel, $
        ;;             CHARSIZE=defCharSize_grid


        ;; cgText, 0, minI-1, '0 MLT',ALIGNMENT=0.5, ORIENTATION=0, CHARSIZE=defCharSize
        ;; cgText, 180, minI, '12',ALIGNMENT=0.5, ORIENTATION=0.00, CHARSIZE=defCharSize
        ;; cgText, 90, minI-1, '6',ALIGNMENT=0.5,CHARSIZE=defCharSize
        ;; cgText, -90, minI-1, '18',ALIGNMENT=0.5,CHARSIZE=defCharSize

;; [0.125, 0.05, 0.875, 0.8]

        ;;MLTs
        IF ~KEYWORD_SET(suppress_MLT_labels) THEN BEGIN
           zeroMLTName                   = KEYWORD_SET(suppress_MLT_name) ? '0' : '0 MLT'

           MLTColor                      = 'black'
           CGTEXT,MEAN([map_position[2],map_position[0]]), map_position[1]-0.035*yScale,zeroMLTName,/NORMAL, $
                  COLOR=MLTColor,ALIGNMENT=0.5,CHARSIZE=defCharSize_grid*charScale
           CGTEXT,MEAN([map_position[2],map_position[0]]), map_position[3]+0.005*yScale,'12',/NORMAL, $
                  COLOR=MLTColor,ALIGNMENT=0.5,CHARSIZE=defCharSize_grid*charScale
           CGTEXT,map_position[2]+0.02*xScale, MEAN([map_position[3],map_position[1]])-0.015*yScale,'6',/NORMAL, $
                  COLOR=MLTColor,ALIGNMENT=0.5,CHARSIZE=defCharSize_grid*charScale
           CGTEXT,map_position[0]-0.03*xScale, MEAN([map_position[3],map_position[1]])-0.015*yScale,'18',/NORMAL, $
                  COLOR=MLTColor,ALIGNMENT=0.5,CHARSIZE=defCharSize_grid*charScale
        ENDIF

        ;;ILATs
        IF ~KEYWORD_SET(suppress_ILAT_labels) THEN BEGIN
           ILATColor              = defGridTextColor
           ILAT_longitude         = 45
           ILAT_longitude         = 80
           ;; ILATColor              =
           FOR ilat_i=0,N_ELEMENTS(gridLats)-1 DO BEGIN
              CGTEXT, ILAT_longitude, $
                      gridLats[ilat_i], $
                      gridLatNames[ilat_i], $
                      ALIGNMENT=1.0, $
                      ORIENTATION=0, $
                      COLOR=defGridTextColor, $
                      CHARSIZE=defCharSize_grid*charScale
           ENDFOR
        ENDIF
     ENDIF ELSE BEGIN

        ;;Longitudes
        lonNames                  = STRING(FORMAT='(I2)',(INDGEN(24/(binm*2))*(2*binm)))
        nLons                     = N_ELEMENTS(lonNames)

        ;; lats                   = INDGEN((maxI-minI)/(binI*2))*(2*binI)+minI
        ;; latNames               = STRING(FORMAT='(I2)',lats)
        ;; nLats                  = N_ELEMENTS(latNames)

        ;;Latitudes
        IF mirror THEN BEGIN
           minLatLabel            = CEIL(-maxI/10.)*10
           maxLatLabel            = FLOOR(-minI/10.)*10
        ENDIF ELSE BEGIN
           minLatLabel            = CEIL(minI/10.)*10
           maxLatLabel            = FLOOR(maxI/10.)*10
        ENDELSE
        nLats                     = (maxLatLabel-minLatLabel)/10+1

        lats                      = !NULL
        FOR l=0,nLats-1 DO lats   = [lats,minLatLabel+l*10]
        IF minI GT 0 THEN $
           latNames               = STRING(FORMAT='(I2)',lats) $
        ELSE $
           latNames               = STRING(FORMAT='(I3)',KEYWORD_SET(mirror) ? -lats : lats)

        CGMAP_GRID, CLIP_TEXT=1, $
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
                    ;; lonlabel=(minI GT 0) ? ((mirror) ? -maxI : minI) : ((mirror) ? -minI : maxI),$
                    ;; latlabel=((maxM-minM)/2.0+minM)*15-binM*7.5,
                    ;; LONS=(1*INDGEN(12)*30),$
                    LONS=(1*INDGEN(nLons)*360/nLons),$
                    LONNAMES=lonNames, $
                    CHARSIZE=defCharSize_grid*charScale
     ENDELSE
  ENDIF

  ;;defCharSize                   = cgDefCharSize()*0.75
  ;;cgText, 0, minI-1, '0', Alignment=0.5, Orientation=0, Charsize=defCharSize
  ;;cgText, 180, minI, '12', Alignment=0.5, Orientation=0.00, Charsize=defCharSize
  ;;cgText, 90, minI-1, '6 MLT',Alignment=0.5,Charsize=defCharSize
  ;;cgText, -90, minI-1, '18',Alignment=0.5,Charsize=defCharSize

  ;;cgText, 0, minI-5, 'midnight', Alignment=0.5, Orientation=0, Charsize=defCharSize
  ;;cgText, 180, minI-5, 'noon', Alignment=0.5, Orientation=0.00, Charsize=defCharSize
  ;;cgText, 90, minI-5, 'dawnward',Alignment=0.5,Charsize=defCharSize
  ;;cgText, -90, minI-5, 'duskward',Alignment=0.5,Charsize=defCharSize

  ;; IF N_ELEMENTS(clockStr) NE 0 THEN BEGIN
  ;;    cgText,lTexPos1, $
  ;;           bTexPos1+clockStrOffset, $
  ;;           "IMF " + clockStr, $
  ;;           /NORMAL, $
  ;;           CHARSIZE=defCharSize
  ;; ENDIF

  IF temp.do_plotIntegral OR $
     (KEYWORD_SET(show_integrals) AND temp.is_fluxData) $
  THEN BEGIN

     temp.grossIntegrals.total /= temp.grossFac
     temp.grossIntegrals.day   /= temp.grossFac
     temp.grossIntegrals.night /= temp.grossFac

     ;; IF NOT (temp.is_logged) THEN BEGIN
     ;; cgText, lTexPos1, $
     ;;         bTexPos2, $
     ;;         '|Integral|: ' + string(absIntegral,FORMAT=integralLabelFormat), $
     ;;         /NORMAL, $
     ;;         CHARSIZE=defCharSize_grid*charScale
     ;; CGTEXT,lTexPos1, $
     ;;        bTexPos1, $
     CGTEXT, $
        integ_position[0], $
        integ_position[1], $
        ;; 'Integral: ' + string(integral,Format=fullIntegLabelFormat), $
        ;; STRING(integral,FORMAT=fullIntegLabelFormat), $
        STRING(temp.grossIntegrals.total,FORMAT=fullIntegLabelFormat)+temp.gUnits, $
        /NORMAL, $
        CHARSIZE=defCharSize_grid*charScale

     CGTEXT, $
        ;; integ_position[0], $
        ;; integ_position[1]-integ_delta, $
        integ_position[2], $
        integ_position[1], $
        ;; 'Integral: ' + string(integral,Format=dayNightIntegLabelFormat), $
        ;; STRING(integral,FORMAT=dayNightIntegLabelFormat), $
        STRING(temp.grossIntegrals.day,FORMAT=dayNightIntegLabelFormat)+temp.gUnits, $
        COLOR='RED', $
        /NORMAL, $
        CHARSIZE=defCharSize_grid*charScale

     CGTEXT, $
        ;; integ_position[0], $
        ;; integ_position[1]-integ_delta*2, $
        integ_position[2], $
        integ_position[3], $
        ;; 'Integral: ' + string(integral,Format=dayNightIntegLabelFormat), $
        ;; STRING(integral,FORMAT=dayNightIntegLabelFormat), $
        STRING(temp.grossIntegrals.night,FORMAT=dayNightIntegLabelFormat)+temp.gUnits, $
        COLOR='BLUE', $
        /NORMAL, $
        CHARSIZE=defCharSize_grid*charScale

     IF KEYWORD_SET(show_daynight_integrals) THEN BEGIN
        CGTEXT,lTexPos2, $
               bTexPos1, $
               'Dawnward: ' + STRING(dawnIntegral,FORMAT=integralLabelFormat), $
               /NORMAL, $
               CHARSIZE=defCharSize_grid*charScale
        CGTEXT,lTexPos2, $
               bTexPos2, $
               'Duskward: ' + STRING(duskIntegral,FORMAT=integralLabelFormat), $
               /NORMAL, $
               CHARSIZE=defCharSize_grid*charScale
        ;; ENDIF
     ENDIF

  ENDIF

  ;;******************************
  ;;Colorbar stuffs
  ;;******************************

  ;;set up colorbal labels
  IF NOT KEYWORD_SET(temp.labelFormat) THEN BEGIN
     temp.labelFormat             = defLabelFormat
  ENDIF
  lowerLab                       =(temp.is_logged AND temp.logLabels) ? $
                                  10.^(temp.lim[0]) : temp.lim[0]
  UpperLab                       =(temp.is_logged AND temp.logLabels) ? $
                                  10.^temp.lim[1] : temp.lim[1]

  IF temp.do_midCBLabel THEN BEGIN
     midLab                       = (temp.lim[1] + temp.lim[0])/2.0
     IF temp.logLabels THEN BEGIN
        midLab                    = 10.^midLab
     ENDIF
  ENDIF ELSE BEGIN
     midLab                       = ''
  ENDELSE

  cbSpacingStr_low                = (nLevels-1)/2-is_OOBLow
  cbSpacingStr_high               = (nLevels-1)/2-is_OOBHigh

  cbOOBLowVal                     = (MIN(temp.data[notMasked]) LT temp.lim[0] OR temp.force_oobLow) ? $
                                    0B : !NULL
  cbOOBHighVal                    = (MAX(temp.data[notMasked]) GT temp.lim[1] OR temp.force_oobHigh) ? $
                                    BYTE(nLevels-1) : !NULL
  cbRange                         = (temp.is_logged AND temp.logLabels) ? 10.^(ROUND(temp.lim*100.)/100.) : temp.lim
  cbTitle                         = KEYWORD_SET(suppress_titles) ? !NULL : plotTitle
  nCBColors                       = nlevels-is_OOBHigh-is_OOBLow
  cbBottom                        = BYTE(is_OOBLow)

  ;; cbTickNames                  = [String(lowerLab, Format=temp.labelFormat), $
  ;;                      REPLICATE("",cbSpacingStr_Low),$
  ;;                      (temp.DO_midCBLabel ? String(midLab, Format=temp.labelFormat) : " "), $
  ;;                      REPLICATE("",cbSpacingStr_High),$
  ;;                      String(upperLab, Format=temp.labelFormat)]

  ;; cgColorbar, NCOLORS=nCBColors, DIVISIONS=nCBColors, BOTTOM=cbBottom, $
  ;;             OOB_Low=cbOOBLowVal, $
  ;;             OOB_High=cbOOBHighVal, $
  ;;             /Discrete, $
  ;;             RANGE=cbRange, $
  ;;             TITLE=cbTitle, $
  ;;             POSITION=cbPosition, TEXTTHICK=cbTextThick, VERTICAL=cbVertical, $
  ;;             TLOCATION=cbTLocation, TCHARSIZE=cbTCharSize,$
  ;;             CHARSIZE=cbTCharSize,$
  ;;             TICKNAMES=cbTickNames

  ;;Want this in any case
  CB_Info                         = {NCOLORS:nCBColors, $
                                     XLOG:(temp.is_logged AND temp.logLabels), $
                                     BOTTOM:cbBottom, $
                                     OOB_Low:KEYWORD_SET(cbOOBLowVal) ? cbOOBLowVal : -9, $
                                     OOB_High:KEYWORD_SET(cbOOBHighVal) ? cbOOBHighVal : -9, $
                                     RANGE:cbRange, $
                                     TITLE:N_ELEMENTS(cbTitle) GT 0 ? cbTitle : '', $
                                     TLOCATION:cbTLocation, $
                                     TCHARSIZE:KEYWORD_SET(labels_for_presentation) ? charSize_plotTitle_pres : cbTCharSize*charScale,$
                                     POSITION:KEYWORD_SET(cb_position) ? cb_position : $
                                     (KEYWORD_SET(labels_for_presentation) ? cbPosition_pres : cbPosition), $
                                     TEXTTHICK:cbTextThick, $
                                     VERTICAL:cbVertical, $
                                     CHARSIZE:KEYWORD_SET(labels_for_presentation) ? charSize_cbLabel_pres : cbTCharSize*charScale,$
                                     TICKLEN:0.5}

  IF ~KEYWORD_SET(no_colorBar) THEN BEGIN
     cgColorbar, NCOLORS=nCBColors, $
                 ;; DIVISIONS=nCBColors, $
                 XLOG=(temp.is_logged AND temp.logLabels), $
                 BOTTOM=cbBottom, $
                 OOB_Low=cbOOBLowVal, $
                 OOB_High=cbOOBHighVal, $
                 ;; /Discrete, $
                 RANGE=cbRange, $
                 TITLE=cbTitle, $
                 TLOCATION=cbTLocation, $
                 TCHARSIZE=KEYWORD_SET(labels_for_presentation) ? charSize_plotTitle_pres : cbTCharSize*charScale,$
                 POSITION=KEYWORD_SET(cb_position) ? cb_position : (KEYWORD_SET(labels_for_presentation) ? cbPosition_pres : cbPosition), $
                 TEXTTHICK=cbTextThick, VERTICAL=cbVertical, $
                 CHARSIZE=KEYWORD_SET(labels_for_presentation) ? charSize_cbLabel_pres : cbTCharSize*charScale,$
                 TICKLEN=0.5, $
                 ;; TICKINTERVAL=(temp.is_logged AND temp.logLabels) ? 0.25 : !NULL, $
                 TICKNAMES=cbTickNames

  ENDIF

END