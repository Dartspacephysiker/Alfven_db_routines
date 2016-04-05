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

PRO PLOTH2D_STEREOGRAPHIC,temp,ancillaryData,WHOLECAP=wholeCap,MIDNIGHT=midnight, $
                          PLOTTITLE=plotTitle, MIRROR=mirror, $
                          DEBUG=debug, $
                          NO_COLORBAR=no_colorbar, $
                          CB_FORCE_OOBLOW=cb_force_ooblow, $
                          CB_FORCE_OOBHIGH=cb_force_oobhigh, $
                          _EXTRA=e

  restore,ancillaryData
  IF N_ELEMENTS(wholeCap) EQ 0 THEN BEGIN
     IF ABS(minM - 0.00) LT 0.0001 AND ABS(maxM-24.00) LT 0.0001 THEN wholeCap = 1
  ENDIF

  @ploth2d_stereographic_defaults.pro

  ; Open a graphics window.
  cgDisplay,color="black"

  IF KEYWORD_SET(mirror) THEN BEGIN
     IF mirror NE 0 THEN mirror = 1 ELSE mirror = 0
  ENDIF ELSE mirror = 0

  ;; IF KEYWORD_SET(wholeCap) THEN BEGIN
  ;;    IF wholeCap EQ 0 THEN wholeCap=!NULL
  ;; ENDIF
  IF KEYWORD_SET(midnight) THEN BEGIN
     IF midnight EQ 0 THEN midnight=!NULL
  ENDIF
  
  ;; IF N_ELEMENTS(wholeCap) EQ 0 THEN BEGIN
  ;; IF ~KEYWORD_SET(wholeCap) THEN BEGIN
     position = [0.1, 0.075, 0.9, 0.75] 
     lim=[(mirror) ? -maxI : minI,minM*15,(mirror) ? -minI : maxI,maxM*15]
  ;; ENDIF ELSE BEGIN
  ;;    position = [0.05, 0.05, 0.85, 0.85] 
  ;;    lim=[(mirror) ? -maxI : minI, 0 ,(mirror) ? -minI : maxI,360] ; lim = [minimum lat, minimum long, maximum lat, maximum long]
  ;; ENDELSE

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
                ;;Limit=[minI-5,maxM*15-360,maxI+5,minM*15],
                
  IF N_ELEMENTS(plotTitle) EQ 0 THEN BEGIN
     plotTitle = temp.title
  ENDIF

  ;;5 bar things per decade
  ;; IF KEYWORD_SET(temp.is_logged) THEN BEGIN
  ;;    nLevels = CEIL(temp.lim[1]-temp.lim[0])*5
  ;; ENDIF

  ;;Select color table
  ;; IF temp.is_fluxData AND ~temp.is_logged THEN BEGIN
  IF ~temp.is_logged THEN BEGIN

     IF N_ELEMENTS(WHERE(temp.data) LT 0) GT 0 THEN BEGIN
        RAINBOW_COLORS,N_COLORS=nLevels

        ;;This is the one for doing sweet flux plots that include negative values 
        ;; cgLoadCT, ctIndex, BREWER=ctBrewer, REVERSE=ctReverse, NCOLORS=nLevels
     ENDIF ELSE BEGIN
        SUNSET_COLORS,N_COLORS=nLevels
     ENDELSE

  ENDIF ELSE BEGIN
     ;; This one is the one we use for nEvent- and orbit-type plots (plots w/ all positive values)
     RAINBOW_COLORS,N_COLORS=nLevels
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

  ; Set up the contour levels.
  ;   levels = cgScaleVector(Indgen(nlevels), 0,255)      
  

  ;;Get longitudes for drawing boxes
  nXlines                   = (maxM-minM)/binM + 1
  mlts                      = indgen(nXlines)*binM+minM
  ;; IF KEYWORD_SET(wholeCap) THEN BEGIN
     gridLons               = [0,90,180,270,360]
  ;; ENDIF


  IF KEYWORD_SET(do_lShell) THEN BEGIN
     nYlines                = (maxL-minL)/binL + 1
     lShells                = INDGEN(nYlines)*binL + minL
     ilats                  = LSHELL_TO_ILAT_PARABOLA_FIT(lShells, $
                                                          MINL=minL, $
                                                          MAXL=maxL, $
                                                          MINI=minI, $
                                                          MAXI=maxI)
     ;; ilats                  = DOUBLE(ROUND(ilats*4))/4

     gridLats               = LSHELL_TO_ILAT_PARABOLA_FIT(lShells[0:-1:3], $
                                                          MINL=minL, $
                                                          MAXL=maxL, $
                                                          MINI=minI, $
                                                          MAXI=maxI)
     gridLatNames           = lShells[0:-1:3]

     IF KEYWORD_SET(reverse_lShell) THEN BEGIN
        temp.data           = SHIFT(REVERSE(temp.data,2),0,-1)
        gridLatNames        = REVERSE(gridLatNames)
     ENDIF
  ENDIF ELSE BEGIN
     nYlines                = (maxI-minI)/binI + 1
     ilats                  = indgen(nYlines)*binI + minI

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

     gridLats               = defGridLats * (ABS(minI)/minI) ;IF WHERE((INDGEN(10)*binI + minI 
     gridLatNames           = defGridLats * (ABS(minI)/minI)
  ENDELSE


  IF mirror THEN BEGIN
     ilats                        = -1.0 * ilats 
     gridLats                     = -1.0 * gridLats
     ;; gridLatNames                 = -1.0 * gridLatNames
  ENDIF

  ;;binary matrix to tell us where masked values are
  nPlots                          = N_ELEMENTS(h2dStrArr)-1   ;Subtract one since last array is the mask
  masked                          = (h2dStrArr[nPlots].data GT 250.0)
  IF KEYWORD_SET(reverse_lShell) THEN BEGIN
     masked[*,1:-1]               = REVERSE(masked[*,1:-1],2)
     masked                       = SHIFT(masked,0,-1)
  ENDIF
  notMasked                       = WHERE(~masked)

  h2descl                         = MAKE_ARRAY(SIZE(temp.data,/DIMENSIONS),VALUE=0)

  ;;Scale this stuff
  ;;The reason for all the trickery is that we want to know what values are out of bounds,
  ;; and bytscl doesn't do things quite the way we need them done.
  is_OOBHigh                = 0
  is_OOBLow                 = 0
  OOB_HIGH_i                = WHERE(temp.data GT temp.lim[1] AND ~masked)
  OOB_LOW_i                 = WHERE(temp.data LT temp.lim[0] AND ~masked)

  IF KEYWORD_SET(cb_force_oobHigh) THEN BEGIN
     temp.force_oobHigh     = 1
  ENDIF
  IF KEYWORD_SET(cb_force_oobLow) THEN BEGIN
     temp.force_oobLow      = 1
  ENDIF

  IF OOB_HIGH_i[0] NE -1 OR temp.force_oobHigh THEN BEGIN
     is_OOBHigh             = 1
  ENDIF

  IF OOB_LOW_i[0] NE -1 OR temp.force_oobLow THEN BEGIN
     is_OOBLow              = 1
  ENDIF
  
  h2descl[notMasked]        = BYTSCL(temp.data(notMasked), $
                                     top=nLevels-1-is_OOBHigh-is_OOBLow, $
                                     MAX=temp.lim[1], $
                                     MIN=temp.lim[0] ) + is_OOBLow

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
                                                                      SHIFT_LON=temp.shift1, $
                                                                      BINSIZE_LAT=(KEYWORD_SET(do_lShell) ? binL : binI), $
                                                                      /CONVERT_MLT_TO_LON, $
                                                                      COUNTERCLOCKWISE=KEYWORD_SET(reverse_lShell))

  ;;Fill up dat plot
  H2D_STEREOGRAPHIC_EXECUTE_POLYFILL,lonsLats,h2descl, $
                                     H2D_MASKED=masked, $
                                     MASKCOLOR=maskColor
  ;;Calc an integral?
  IF temp.do_plotIntegral THEN BEGIN
     H2D_STEREOGRAPHIC_INTEGRAL,temp,lonsLats, $
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
  IF KEYWORD_SET(temp.shift1) THEN BEGIN
     ;; shiftedMLTs                     = ((maxM-minM)/binM+temp.shift1) * 15.
     shiftedMLTs                     = (indgen((maxm-minm)/binm)*binm+temp.shift1)*15.
     ;; gridLons                        = gridLons + temp.shift1*15
  ENDIF ELSE BEGIN
     shiftedMLTs                     = !NULL
  ENDELSE
  cgMap_Grid, CLIP_TEXT=1, $
              /NOCLIP, $
              LINESTYLE=0, $
              THICK=(!D.Name EQ 'PS') ? defGridLineThick_PS : defGridLineThick_PS,$
              COLOR=defGridColor, $
              LONDELTA=binM*15, $
              ;; LATDELTA=(KEYWORD_SET(do_lShell) ? !NULL : binI ), $  
              LONS=shiftedMLTs, $
              ;;LATDELTA=(KEYWORD_SET(do_lShell) ? binL : binI )
              LATS=ilats
              ;; LATS=(KEYWORD_SET(do_lShell) ? ilats : !NULL)


  ;;add thicker grid to a few latitude lines
  cgMap_Grid, Clip_Text=1, $
              /NoClip, $
              thick=(!D.Name EQ 'PS') ? defGridBoldLineThick_PS : defGridBoldLineThick,$
              LINESTYLE=defBoldGridLineStyle, $
              COLOR=defGridColor, $
              ;; LATDELTA=(KEYWORD_SET(do_lShell) ? !NULL : defBoldLatDelta), $
              LONDELTA=defBoldLonDelta, $
              LONS=gridLons, $
              LATS=gridLats


  ; Now text. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword. 
  IF KEYWORD_SET(do_lShell) THEN BEGIN
     ;; lonLabel=(minL GT 0 ? minL : maxL)
     lonLabel=(minI GT 0 ? minI : maxI)
     IF mirror THEN lonLabel = -1.0 * lonLabel ;mirror dat
  ENDIF ELSE BEGIN
     lonLabel=(minI GT 0 ? minI : maxI)
     IF mirror THEN lonLabel = -1.0 * lonLabel ;mirror dat
  ENDELSE 

  IF KEYWORD_SET(wholeCap) THEN BEGIN
     factor                          = 6.0
     mltSites                        = (INDGEN((maxM-minM)/factor)*factor+minM)
     lonNames                        = [string(minM,format=lonLabelFormat) + " MLT", $
                                        STRING(mltSites[1:-1], $
                                               format=lonLabelFormat)]

     ;; IF mirror THEN BEGIN
     ;;    ;;    ;;IF N_ELEMENTS(wholeCap) NE 0 THEN lonNames = [lonNames[0],REVERSE(lonNames[1:*])]
     ;;    gridLats                     = -1.0 * gridLats
     ;;    gridLatNames                 = -1.0 * gridLatNames
     ;; ENDIF 
     
     gridLatNames                    = STRING(gridLatNames,format=latLabelFormat)
     gridLatNames[mirror ? -1 : 0]   = gridLatNames[mirror ? -1 : 0] + $
                                       ( KEYWORD_SET(DO_lShell) ? " L-shell" : " ILAT" )

     cgMap_Grid, Clip_Text=1, $
                 /NoClip, $
                 /LABEL, $
                 /NO_GRID, $
                 LINESTYLE=0, $
                 THICK=3, $
                 COLOR=defGridTextColor, $
                 LATS=gridLats, $
                 LATNAMES=gridLatNames, $
                 ;; LATDELTA=(KEYWORD_SET(do_lShell) ? binL : binI )*4,$
                 ;; LATLABEL=(mean([minM,maxM]))*15+15, $
                 ;; LATLABEL=((maxM-minM)/2.0+minM)*15-binM*7.5,
                 ;;LONNAMES=[strtrim(minM,2)+" MLT",STRTRIM(INDGEN((maxM-minM)/1.0)+(minM+1),2)]
                 LATLABEL=45, $
                 LONS=mltSites*15, $
                 LONNAMES=lonNames, $
                 LONLABEL=lonLabel, $
                 CHARSIZE=defCharSize_grid
  ENDIF ELSE BEGIN

     ;;Longitudes
     lonNames                       = STRING(FORMAT='(I2)',(INDGEN(24/(binm*2))*(2*binm)))
     nLons                          = N_ELEMENTS(lonNames)

     ;; lats                           = INDGEN((maxI-minI)/(binI*2))*(2*binI)+minI
     ;; latNames                       = STRING(FORMAT='(I2)',lats)
     ;; nLats                          = N_ELEMENTS(latNames)

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
                 ;; lonlabel=(minI GT 0) ? ((mirror) ? -maxI : minI) : ((mirror) ? -minI : maxI),$ 
                 ;; latlabel=((maxM-minM)/2.0+minM)*15-binM*7.5,
                 ;; LONS=(1*INDGEN(12)*30),$
                 LONS=(1*INDGEN(nLons)*360/nLons),$
                 LONNAMES=lonNames, $
                 CHARSIZE=defCharSize_grid
  ENDELSE

  ;defCharSize = cgDefCharSize()*0.75
  ;cgText, 0, minI-1, '0', Alignment=0.5, Orientation=0, Charsize=defCharSize      
  ;cgText, 180, minI, '12', Alignment=0.5, Orientation=0.00, Charsize=defCharSize   
  ;cgText, 90, minI-1, '6 MLT',Alignment=0.5,Charsize=defCharSize
  ;cgText, -90, minI-1, '18',Alignment=0.5,Charsize=defCharSize
  
  ;cgText, 0, minI-5, 'midnight', Alignment=0.5, Orientation=0, Charsize=defCharSize      
  ;cgText, 180, minI-5, 'noon', Alignment=0.5, Orientation=0.00, Charsize=defCharSize   
  ;cgText, 90, minI-5, 'dawnward',Alignment=0.5,Charsize=defCharSize
  ;cgText, -90, minI-5, 'duskward',Alignment=0.5,Charsize=defCharSize  
  
  ;; IF N_ELEMENTS(clockStr) NE 0 THEN BEGIN
  ;;    cgText,lTexPos1, $
  ;;           bTexPos1+clockStrOffset, $
  ;;           "IMF " + clockStr, $
  ;;           /NORMAL, $
  ;;           CHARSIZE=defCharSize 
  ;; ENDIF

  IF temp.do_plotIntegral THEN BEGIN
     
     ;; IF NOT (temp.is_logged) THEN BEGIN
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
     ;; ENDIF

  ENDIF

  ;;******************************
  ;;Colorbar stuffs
  ;;******************************

  IF ~KEYWORD_SET(no_colorBar) THEN BEGIN
     ;;set up colorbal labels
     IF NOT KEYWORD_SET(temp.labelFormat) THEN BEGIN
        temp.labelFormat            = defLabelFormat
     ENDIF
     lowerLab                       =(temp.is_logged AND temp.logLabels) ? $
                                     10.^(temp.lim[0]) : temp.lim[0]
     UpperLab                       =(temp.is_logged AND temp.logLabels) ? $
                                     10.^temp.lim[1] : temp.lim[1]
     
     IF temp.do_midCBLabel THEN BEGIN
        midLab                      = (temp.lim[1] + temp.lim[0])/2.0
        IF temp.logLabels THEN BEGIN
           midLab                   = 10.^midLab
        ENDIF
     ENDIF ELSE BEGIN
        midLab                      = ''
     ENDELSE
     
     cbSpacingStr_low  = (nLevels-1)/2-is_OOBLow
     cbSpacingStr_high = (nLevels-1)/2-is_OOBHigh
     
     cbOOBLowVal       = (MIN(temp.data(notMasked)) LT temp.lim[0] OR temp.force_oobLow) ? $
                         0B : !NULL
     cbOOBHighVal      = (MAX(temp.data(notMasked)) GT temp.lim[1] OR temp.force_oobHigh) ? $
                         BYTE(nLevels-1) : !NULL
     cbRange           = (temp.is_logged AND temp.logLabels) ? 10.^(ROUND(temp.lim*100.)/100.) : temp.lim
     cbTitle           = plotTitle
     nCBColors         = nlevels-is_OOBHigh-is_OOBLow
     cbBottom          = BYTE(is_OOBLow)
     ;; cbTickNames       = [String(lowerLab, Format=temp.labelFormat), $
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
     
     cgColorbar, NCOLORS=nCBColors, $
                 ;; DIVISIONS=nCBColors, $
                 XLOG=(temp.is_logged AND temp.logLabels), $
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
                 ;; TICKINTERVAL=(temp.is_logged AND temp.logLabels) ? 0.25 : !NULL, $
                 TICKNAMES=cbTickNames

  ENDIF
END