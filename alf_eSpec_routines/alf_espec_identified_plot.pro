;2016/05/25
;;   X               DOUBLE    Array[25828]
;;   MLT             FLOAT     Array[25828]
;;   ILAT            FLOAT     Array[25828]
;;   MONO            BYTE      Array[25828]
;;   BROAD           BYTE      Array[25828]
;;   DIFFUSE         BYTE      Array[25828]
;;   JE              FLOAT     Array[25828]
;;   JEE             FLOAT     Array[25828]
;;   NBAD_ESPEC      BYTE      Array[25828]
;;   ALF_INDICES     LONG      Array[25828]
;;
FUNCTION ALF_ESPEC_IDENTIFIED_PLOT,eSpec, $
                                   YLOG=yLog, $
                                   NEWELL_ESPEC_INTERPRETED=eSpec_interpreted, $
                                   CURRENT=window, $
                                   SAVEPLOT=savePlot, $
                                   SPNAME=sPName, $
                                   PLOTDIR=plotDir, $
                                   CLOSE_WINDOW_AFTER_SAVE=close_window_after_save

  COMPILE_OPT idl2


  names              = ['Mono','Broad','Diffuse']

  colors             = ['blue','red'] ;not-strict and strict
  bottom_color       = 'white'

  locations          = [1,2,3]

  monoTemp           = WHERE(eSpec.mono EQ 1,mono)
  monoSTemp          = WHERE(eSpec.mono EQ 2,monoS)
  broadTemp          = WHERE(eSpec.broad EQ 1,broad)
  broadSTemp         = WHERE(eSpec.broad EQ 2,broadS)
  diffuseTemp        = WHERE(eSpec.diffuse,diffuse)

  notStrict          = [mono,   broad,diffuse]
  strict             = [monoS, broadS,      0] + notStrict

  IF KEYWORD_SET(eSpec_interpreted) THEN BEGIN
     nPlots          = 4
     nBars           = 2
     indexArr        = [0,1]

     IF SIZE(eSpec_interpreted,/TYPE) NE 8 THEN $
        CONVERT_ESPEC_TO_STRICT_NEWELL_INTERPRETATION,eSpec,eSpec_interpreted

     monoTemp_N      = WHERE(eSpec_interpreted.mono EQ 1,mono_N)
     monoSTemp_N     = WHERE(eSpec_interpreted.mono EQ 2,monoS_N)
     broadTemp_N     = WHERE(eSpec_interpreted.broad EQ 1,broad_N)
     broadSTemp_N    = WHERE(eSpec_interpreted.broad EQ 2,broadS_N)
     diffuseTemp_N   = WHERE(eSpec_interpreted.diffuse,diffuse_N)
     
     notStrict_N     = [mono_N ,broad_N , diffuse_N]
     strict_N        = [monoS_N,broadS_N,         0] + notStrict_n
     colors_N        = ['green','gold']          
     bottom_color_N  = 'gray'
  ENDIF ELSE BEGIN
     nPlots          = 2
     nBars           = 1
     indexArr        = [0]
  ENDELSE

  ;;Window?
  IF ~ISA(window) THEN BEGIN
     window          = WINDOW(DIMENSIONS=[800,600])
  ENDIF
  
  plotArr            = MAKE_ARRAY(nPlots,/OBJ)

  ;; Plot bars, stacked.
  iPlot              = 0
  plotArr[iPlot]     = BARPLOT(locations,notStrict, $
                               INDEX=indexArr[0], $
                               NBARS=nBars, $
                               YLOG=ylog, $
                               FILL_COLOR=colors[0], $
                               ;; BOTTOM_COLOR=bottom_color, $
                               XTICKVALUES=locations, $
                               XTICKNAME=names, $
                               XMINOR=0, $
                               CURRENT=window)
  iPlot++

  IF KEYWORD_SET(eSpec_interpreted) THEN BEGIN
     plotArr[iPlot]  = BARPLOT(locations,notStrict_N, $
                               INDEX=indexArr[1], $
                               NBARS=nBars, $
                               YLOG=ylog, $
                               FILL_COLOR=colors_N[0], $
                               ;; BOTTOM_COLOR=bottom_color_N, $
                               /OVERPLOT, $
                               CURRENT=window)

     iPlot++
  ENDIF
  
  plotArr[iPlot]    = BARPLOT(locations[0:1],strict[0:1], $
                              BOTTOM_VALUES=notStrict[0:1], $
                              INDEX=indexArr[0], $
                              NBARS=nBars, $
                              FILL_COLOR=colors[1], $
                              ;; BOTTOM_COLOR=bottom_color, $
                              /OVERPLOT, $
                              CURRENT=window)
  
  IF KEYWORD_SET(eSpec_interpreted) THEN BEGIN
     plotArr[iPlot]  = BARPLOT(locations[0:1],strict_N[0:1], $
                               BOTTOM_VALUES=notStrict_N[0:1], $
                               INDEX=indexArr[1], $
                               NBARS=nBars, $
                               YLOG=ylog, $
                               FILL_COLOR=colors_N[1], $
                               ;; BOTTOM_COLOR=bottom_color_N, $
                               CURRENT=window, $
                               /OVERPLOT)

     iPlot++
  ENDIF
  
  horiz_normal    = 0.2
  vert            = 0.7
  vert_delta      = 0.05
  vd_count        = 0
  text_s          = TEXT(horiz_normal, $
                         vert-vert_delta*(vd_count++), $
                         'Not strict', $
                         /CURRENT, $
                         COLOR=colors[0], $
                         /NORMAL)
  text_ns         = TEXT(horiz_normal, $
                         vert-vert_delta*(vd_count++), $
                         'Strict', $
                         /CURRENT, $
                         COLOR=colors[1], $
                         /NORMAL)

  IF KEYWORD_SET(eSpec_interpreted) THEN BEGIN
     text_s_N     = TEXT(horiz_normal, $
                         vert-vert_delta*(vd_count++), $
                         'Newell', $
                         /CURRENT, $
                         COLOR=colors_N[0], $
                         /NORMAL)
     text_ns_N    = TEXT(horiz_normal, $
                         vert-vert_delta*(vd_count++), $
                         'Newell (Strict)', $
                         /CURRENT, $
                         COLOR=colors_N[1], $
                         /NORMAL)
  ENDIF
     
  ;;Kill top x axis
  ax              = plotArr[0].AXES
  ax[2].HIDE      = 1

  ;; Add a title.
  plotArr[0].TITLE = "Mono, broad, and diffuse e!U-!N statistics for Alf events"
  
  IF KEYWORD_SET(savePlot) THEN BEGIN

     IF KEYWORD_SET(spName) THEN outName = spName ELSE BEGIN
        outName = GET_TODAY_STRING() + '--Newell-based_stats.png'
     ENDELSE
     IF N_ELEMENTS(plotDir) GT 0 THEN BEGIN
        pDir = plotDir
     ENDIF ELSE BEGIN
        SET_PLOT_DIR,pDir,/ADD_TODAY,/FOR_ALFVENDB
     ENDELSE

     PRINT,'Saving to ' + spName + '...'
     window.save,pDir+spName

     IF KEYWORD_SET(close_window_after_save) THEN BEGIN
        window.close
        window      = !NULL
     ENDIF

  ENDIF


  RETURN,plotArr

END