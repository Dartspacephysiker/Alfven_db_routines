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
                       DEBUG=debug,_EXTRA=e

  print,'biz'
  @ploth2d_stereographic_defaults.pro

  restore,ancillaryData

  ;Subtract one since last array is the mask
  nPlots=N_ELEMENTS(h2dStrArr)-1

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
  
  IF N_ELEMENTS(wholeCap) EQ 0 THEN BEGIN
     position = [0.1, 0.075, 0.9, 0.75] 
     lim=[(mirror) ? -maxI : minI,minM*15,(mirror) ? -minI : maxI,maxM*15]
  ENDIF ELSE BEGIN
     position = [0.05, 0.05, 0.85, 0.85] 
     lim=[(mirror) ? -maxI : minI, 0 ,(mirror) ? -minI : maxI,360] ; lim = [minimum lat, minimum long, maximum lat, maximum long]
  ENDELSE

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

  ;;Select color table
  IF temp.is_fluxData AND ~temp.is_logged THEN BEGIN
     ;;This is the one for doing sweet flux plots that include negative values 
     cgLoadCT, ctIndex, BREWER=ctBrewer, REVERSE=ctReverse, NCOLORS=nLevels

  ENDIF ELSE BEGIN
     ;;This one is the one we use for nEvent- and orbit-type plots (plots w/ all positive values)
     cgLoadCT, ctIndex_allPosData, BREWER=ctBrewer_allPosData, REVERSE=ctReverse_allPosData, NCOLORS=nLevels

     IF chrisPosScheme THEN BEGIN
        ;;make last color dark red
        TVLCT,r,g,b,/GET   
        r[nLevels-1]             = 150
        g[nLevels-1]             = 0
        b[nLevels-1]             = 0
        TVLCT,r,g,b
     ENDIF
  ENDELSE

  ; Set up the contour levels.
  ;   levels = cgScaleVector(Indgen(nlevels), 0,255)      
  
  nXlines=(maxM-minM)/binM + 1
  mlts=indgen(nXlines)*binM+minM

  IF KEYWORD_SET(do_lShell) THEN BEGIN
     nYlines =(maxL-minL)/binL + 1
     lShells = INDGEN(nYlines)*binL + minL
     ;; ilats   = LSHELL_TO_ILAT(INDGEN(nYlines)*binL + minL)
     ilats   = LSHELL_TO_ILAT_PARABOLA_FIT(lShells,MINL=minL,MAXL=maxL,MINI=minI,MAXI=maxI)
     ;; ilats   = ROUND(ilats)
     ilats   = DOUBLE(ROUND(ilats*4))/4

     ;; gridLats      = LSHELL_TO_ILAT_PARABOLA_FIT(defGridLshells,MINL=minL,MAXL=maxL,MINI=minI,MAXI=maxI)
     ;; gridLatNames  = defGridLshells
     gridLats      = LSHELL_TO_ILAT_PARABOLA_FIT(lShells[0:-1:3],MINL=minL,MAXL=maxL,MINI=minI,MAXI=maxI)
     gridLatNames  = lShells[0:-1:3]

     IF KEYWORD_SET(reverse_lShell) THEN BEGIN
        temp.data = SHIFT(REVERSE(temp.data,2),0,-1)
        gridLatNames = REVERSE(gridLatNames)
     ENDIF
  ENDIF ELSE BEGIN
     nYlines=(maxI-minI)/binI + 1
     ilats=indgen(nYlines)*binI + minI

     gridLats      = defGridLats
     gridLatNames  = defGridLats
  ENDELSE


  IF mirror THEN BEGIN
     ilats = -1.0 * ilats 
  ENDIF

  ;;binary matrix to tell us where masked values are
  masked=(h2dStrArr[nPlots].data GT 250.0)
  IF KEYWORD_SET(reverse_lShell) THEN BEGIN
     masked[*,1:-1] = REVERSE(masked[*,1:-1],2)
     masked         = SHIFT(masked,0,-1)
  ENDIF
  notMasked=WHERE(~masked)

  h2descl=MAKE_ARRAY(SIZE(temp.data,/DIMENSIONS),VALUE=0)

  ;;Scale this stuff
  ;;The reason for all the trickery is that we want to know what values are out of bounds,
  ;; and bytscl doesn't do things quite the way we need them done.
  is_OOBHigh = 0
  is_OOBLow = 0
  OOB_HIGH_i = where(temp.data GT temp.lim[1] AND ~masked)
  OOB_LOW_i = where(temp.data LT temp.lim[0] AND ~masked)
  IF OOB_HIGH_i[0] NE -1 THEN is_OOBHigh = 1
  IF OOB_LOW_i[0] NE -1 THEN is_OOBLow = 1
  
  h2descl(notMasked)= bytscl( temp.data(notMasked),top=nLevels-1-is_OOBHigh-is_OOBLow,MAX=temp.lim[1],MIN=temp.lim[0] ) + is_OOBLow
  IF OOB_HIGH_i[0] NE -1 THEN h2descl(OOB_HIGH_i) = BYTE(nLevels-1)
  IF OOB_LOW_i[0] NE -1 THEN h2descl(OOB_LOW_i) = 0B

  ;;******************************
  ;;PLOT STUFF
  ;;******************************
  ;;Get polyfill vertices
  lonsLats = GET_H2D_STEREOGRAPHIC_POLYFILL_VERTICES(mlts,ilats, $
                                                     BINSIZE_LON=binM,BINSIZE_LAT=(KEYWORD_SET(do_lShell) ? binL : binI), $
                                                     /CONVERT_MLT_TO_LON,COUNTERCLOCKWISE=KEYWORD_SET(reverse_lShell))

  ;;Fill up dat plot
  H2D_STEREOGRAPHIC_EXECUTE_POLYFILL,lonsLats,h2descl, $
                                     H2D_MASKED=masked,MASKCOLOR=maskColor
  ;;Calc an integral?
  IF temp.do_plotIntegral THEN BEGIN
     H2D_STEREOGRAPHIC_INTEGRAL,temp,lonsLats, $
                                H2D_MASKED=masked, $
                                INTEGRAL=integral,ABSINTEGRAL=absIntegral, $
                                DAWNINTEGRAL=dawnIntegral,DUSKINTEGRAL=duskIntegral
  ENDIF

  ;;******************************
  ;;Grid stuffs
  ;;******************************
  ;;add thicker grid to a few latitude lines
  cgMap_Grid, Clip_Text=1, /NoClip, thick=(!D.Name EQ 'PS') ? defGridBoldLineThick_PS : defGridBoldLineThick,$
              LINESTYLE=defBoldGridLineStyle,COLOR=defGridColor, $
              LATDELTA=(KEYWORD_SET(do_lShell) ? !NULL : defBoldLatDelta),LONDELTA=defBoldLonDelta, $
              LATS=(KEYWORD_SET(do_lShell) ? gridLats : !NULL)
              

  ;; Add map grid. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword. 
  cgMap_Grid, CLIP_TEXT=1, /NOCLIP, LINESTYLE=0, THICK=(!D.Name EQ 'PS') ? defGridLineThick_PS : defGridLineThick_PS,$
              COLOR=defGridColor,LONDELTA=binM*15, $
              LATDELTA=(KEYWORD_SET(do_lShell) ? !NULL : binI ), $  ;latdelta=(KEYWORD_SET(do_lShell) ? binL : binI )
              LATS=(KEYWORD_SET(do_lShell) ? ilats : !NULL)

  ; Now text. Set the Clip_Text keyword to enable the NO_CLIP graphics keyword. 
  IF KEYWORD_SET(do_lShell) THEN BEGIN
     ;; lonLabel=(minL GT 0 ? minL : maxL)
     lonLabel=(minI GT 0 ? minI : maxI)
     IF mirror THEN lonLabel = -1.0 * lonLabel ;mirror dat
  ENDIF ELSE BEGIN
     lonLabel=(minI GT 0 ? minI : maxI)
     IF mirror THEN lonLabel = -1.0 * lonLabel ;mirror dat
  ENDELSE 

  IF N_ELEMENTS(wholeCap) GT 0 THEN BEGIN
     factor=6.0
     mltSites=(INDGEN((maxM-minM)/factor)*factor+minM)
     lonNames=[string(minM,format=lonLabelFormat)+" MLT",STRING(mltSites[1:-1],format=lonLabelFormat)]

     IF mirror THEN BEGIN
        ;;    ;;IF N_ELEMENTS(wholeCap) NE 0 THEN lonNames = [lonNames[0],REVERSE(lonNames[1:*])]
        gridLats = -1.0 * gridLats
        gridLatNames = -1.0 * gridLatNames
     ENDIF 
     
     gridLatNames=STRING(gridLatNames,format=latLabelFormat)
     gridLatNames[mirror ? -1 : 0] = gridLatNames[mirror ? -1 : 0] + ( KEYWORD_SET(DO_lShell) ? " L-shell" : " ILAT" )

     cgMap_Grid, Clip_Text=1, /NoClip, /LABEL, /NO_GRID, linestyle=0, thick=3, color=defGridTextColor, $
;;                 latdelta=(KEYWORD_SET(do_lShell) ? binL : binI )*4,$
                 LATS=gridLats, $
                 LATNAMES=gridLatNames, $
                 ;; LATLABEL=(mean([minM,maxM]))*15+15, $
                 LATLABEL=45, $
                 ;;latlabel=((maxM-minM)/2.0+minM)*15-binM*7.5,
                 LONS=mltSites*15, $
;;                 LONNAMES=[strtrim(minM,2)+" MLT",STRTRIM(INDGEN((maxM-minM)/1.0)+(minM+1),2)]
                 LONNAMES=lonNames, $
                 LONLABEL=lonLabel, $
                 CHARSIZE=defCharSize_grid
  ENDIF ELSE BEGIN
     lonNames=[STRTRIM(INDGEN(12),2)*2]

     cgMap_Grid, Clip_Text=1, /NoClip, /LABEL,linestyle=0, thick=3,color=defGridTextColor,latdelta=(KEYWORD_SET(do_lShell) ? binL : binI*4 ),$
                 /NO_GRID,$
                 LATLABEL=minM*15-5,LONLABEL=lonLabel,$ ;lonlabel=(minI GT 0) ? ((mirror) ? -maxI : minI) : ((mirror) ? -minI : maxI),$ 
                 ;;latlabel=((maxM-minM)/2.0+minM)*15-binM*7.5,
                 LONS=(1*INDGEN(12)*30),$
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

  IF temp.do_plotIntegral THEN BEGIN
     IF N_ELEMENTS(clockStr) NE 0 THEN cgText,lTexPos1,bTexPos1+clockStrOffset,"IMF " + clockStr,/NORMAL,CHARSIZE=defCharSize 
     
     IF NOT (temp.is_logged) THEN cgText,lTexPos1,bTexPos2,'|Integral|: ' + string(absIntegral,Format=integralLabelFormat),/NORMAL,CHARSIZE=defCharSize
     cgText,lTexPos1,bTexPos1,'Integral: ' + string(integral,Format=integralLabelFormat),/NORMAL,CHARSIZE=defCharSize 
     cgText,lTexPos2,bTexPos1,'Dawnward: ' + string(dawnIntegral,Format=integralLabelFormat),/NORMAL,CHARSIZE=defCharSize 
     cgText,lTexPos2,bTexPos2,'Duskward: ' + string(duskIntegral,Format=integralLabelFormat),/NORMAL,CHARSIZE=defCharSize 
  ENDIF


  ;;******************************
  ;;Colorbar stuffs
  ;;******************************

  ;;set up colorbal labels
  IF NOT KEYWORD_SET(temp.labelFormat) THEN temp.labelFormat=defLabelFormat
  lowerLab=(temp.is_logged AND temp.logLabels) ? 10.^(temp.lim[0]) : temp.lim[0]
  UpperLab=(temp.is_logged AND temp.logLabels) ? 10.^temp.lim[1] : temp.lim[1]

  IF temp.do_midCBLabel THEN BEGIN
     midLab = (temp.lim[1] + temp.lim[0])/2.0
     IF temp.logLabels THEN midLab = 10.^midLab
  ENDIF ELSE BEGIN
     midLab=''
  ENDELSE

  cbSpacingStr_low  = (nLevels-1)/2-is_OOBLow
  cbSpacingStr_high = (nLevels-1)/2-is_OOBHigh

  cbOOBLowVal       = (temp.lim[0] LE MIN(temp.data(notMasked))) ? !NULL : 0B
  cbOOBHighVal      = (temp.lim[1] GE MAX(temp.data(notMasked))) ? !NULL : BYTE(nLevels-1)
  cbRange           = temp.lim
  cbTitle           = plotTitle
  nCBColors         = nlevels-is_OOBHigh-is_OOBLow
  cbBottom          = BYTE(is_OOBLow)
  cbTickNames       = [String(lowerLab, Format=temp.labelFormat), $
                       REPLICATE(" ",cbSpacingStr_Low),$
                       (temp.DO_midCBLabel ? String(midLab, Format=temp.labelFormat) : " "), $
                       REPLICATE(" ",cbSpacingStr_High),$
                       String(upperLab, Format=temp.labelFormat)]

  cgColorbar, NCOLORS=nCBColors, DIVISIONS=nCBColors, BOTTOM=cbBottom, $
              OOB_Low=cbOOBLowVal, $
              OOB_High=cbOOBHighVal, $ 
              /Discrete, $
              RANGE=cbRange, $
              TITLE=cbTitle, $
              POSITION=cbPosition, TEXTTHICK=cbTextThick, VERTICAL=cbVertical, $
              TLOCATION=cbTLocation, TCHARSIZE=cbTCharSize,$
              CHARSIZE=cbTCharSize,$
              TICKNAMES=cbTickNames


END