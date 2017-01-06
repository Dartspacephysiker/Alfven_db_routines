;;01/05/17
PRO JOURNAL__20170105__CUSP__FAC_AMPLITUDES__LOW_AND_HIGH_ALTS

  COMPILE_OPT IDL2

  @common__maximus_vars.pro

  noMapping = 0

  ;;Histogram properties/lims
  PS        = 1

  frequency = 1
  freqYLim  = 0.2
  IF ~KEYWORD_SET(noMapping) THEN BEGIN
     freqYLim = 0.08
  ENDIF
  magCXLim  = 100
  magCYLim  = KEYWORD_SET(frequency) ? freqYLim : 1000
  binSize   = 2
  absMagC   = 1

  minMC     = 1
  maxNegMC  = -1

  force_load_maximus = 1

  IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 OR $
     KEYWORD_SET(force_load_maximus) $
  THEN BEGIN
     LOAD_MAXIMUS_AND_CDBTIME,DO_NOT_MAP_ANYTHING=noMapping, $
                              FORCE_LOAD_BOTH=force_load_maximus
  ENDIF

  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY
  psFileName = 'Altitude_vs_Alf_current_density' + $
               (KEYWORD_SET(noMapping) ? '' : '-mapped')

  txtName    = psFileName + '.txt'
  OPENW,lun,plotDir+txtName,/GET_LUN

  hemi = 'BOTH'
  minM = 11.5
  maxM = 12.5
  minI = 72
  maxI = 86
  
  altRange = [ $
             [300,700], $
             [700,1700], $
             [1700,2700], $
             [2700,3700], $
             [300,4300] $ ;Leave me alone! I am not counted in the plots
             ]

  ;; dstCutoff            = -30
  ;; nonStorm             = 1
  do_not_consider_IMF  = 1
  
  use_prev_plot_i      = 1
  remake_prev_plot_i   = 1
  justInds             = 1

  nIter                = N_ELEMENTS(altRange[0,*])

  i_final              = LIST()
  FOR k=0,nIter-1 DO BEGIN

     altitudeRange = altRange[*,k]

     PLOT_ALFVEN_STATS__SETUP, $
        MINILAT=minI, $
        MAXILAT=maxI, $
        MINMLT=minM, $
        MAXMLT=maxM, $
        MIN_MAGCURRENT=minMC, $
        MAX_NEGMAGCURRENT=maxNegMC, $
        HEMI=hemi, $
        ALTITUDERANGE=altitudeRange, $
        DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
        DSTCUTOFF=dstCutoff, $
        NONSTORM=nonStorm, $
        JUSTINDS_THENQUIT=justInds, $
        DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
        ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
        MIMC_STRUCT=MIMC_struct, $
        IMF_STRUCT=IMF_struct, $
        ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct
     
     PLOT_ALFVEN_STATS_IMF_SCREENING, $
        ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
        MIMC_STRUCT=MIMC_struct, $
        IMF_STRUCT=IMF_struct, $
        ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
        USE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=use_prev_plot_i, $
        REMAKE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=remake_prev_plot_i, $
        OUT_PLOT_I_LIST=plot_i_list

     PRINT,FORMAT='("Got ",I0," inds for altitude range [",I0,",",I0,"]")', $
           N_ELEMENTS(plot_i_list[0]), $
           altitudeRange
     
     i_final.Add,plot_i_list[0]

  ENDFOR
  
  
  nCol = ((N_ELEMENTS(i_final)/2) > 1)
  nRow = ((N_ELEMENTS(i_final)/2) > 1)
  
  nowCol = 0B
  nowRow = 1B
  WHILE (nCol*nRow) NE (CEIL(FLOAT(N_ELEMENTS(i_final))/2.)*2) DO BEGIN
     nCol += nowCol
     nRow += nowRow

     nowCol = ~nowCol
     nowRow = ~nowRow

  ENDWHILE

  ;; !P.MULTI = [0,nCol,nRow,0,0]
  ;; !P.MULTI = [0,3,1,0,0]
  ;; CASE 1 OF
  ;;    KEYWORD_SET(PS): BEGIN
  ;;       xSize = 9
  ;;       ySize = 3

  ;;       POPEN,plotDir+psFileName, $
  ;;             XSIZE=xSize, $
  ;;             YSIZE=ySize
        

  ;;    END
  ;;    ELSE: BEGIN
  ;;       xSize = 900
  ;;       ySize = 300

  ;;       WINDOW,0,XSIZE=xSize,YSIZE=ySize
  ;;    END
  ;; ENDCASE

  !P.MULTI = [0,4,1,0,0]
  CASE 1 OF
     KEYWORD_SET(PS): BEGIN
        xSize = 12
        ySize = 3

        POPEN,plotDir+psFileName, $
              XSIZE=xSize, $
              YSIZE=ySize
        

     END
     ELSE: BEGIN
        xSize = 1200
        ySize = 300

        WINDOW,0,XSIZE=xSize,YSIZE=ySize
     END
  ENDCASE

  data = MAXIMUS__maximus.mag_current
  IF KEYWORD_SET(absMagC) THEN BEGIN
     data = ABS(data)
     titlePref = ""
     xTitle    = "Current density (microA/m^2)"
  ENDIF ELSE BEGIN
     titlePref = ""
     xTitle    = "Current density magnitude (microA/m^2)"
  ENDELSE

  PRINTF,lun,FORMAT='(A0,T15,A0,T30,A0,T45,A0,T60,A0,T75,A0,T90,A0)', $
         'AltRange','N','% GE 10','% GE 50','% GE 100', $
         'Mean','Median'
  FOR k=0,nIter-1 DO BEGIN

     altitudeRange = altRange[*,k]

     altRangeStr = STRING(FORMAT='("[",I0,",",I0,"]")',altitudeRange)

     IF k NE (nIter-1) THEN BEGIN
        CGHISTOPLOT,data[i_final[k]], $
                    MININPUT=(KEYWORD_SET(frequency) ? 0 : $
                              (-1.)*magCXLim), $
                    MAXINPUT=magCXLim, $
                    MAX_VALUE=magCYLim, $
                    BINSIZE=binSize, $
                    FREQUENCY=frequency, $
                    XTITLE=xTitle, $
                    TITLE=titlePref + altRangeStr + " km"
     ENDIF
     
     nHere = N_ELEMENTS(i_final[k])
     PRINTF,lun,FORMAT='(A0,T15,I0,T30,F0.2,T45,F0.2,T60,F0.2,T75,F0.2,T90,F0.2)', $
           altRangeStr, $
           nHere, $
           N_ELEMENTS(WHERE(data[i_final[k]] GE 10))/FLOAT(nHere)*100., $
           N_ELEMENTS(WHERE(data[i_final[k]] GE 50))/FLOAT(nHere)*100., $
           N_ELEMENTS(WHERE(data[i_final[k]] GE 100))/FLOAT(nHere)*100., $
           MEAN(data[i_final[k]]), $
           MEDIAN(data[i_final[k]])

  ENDFOR


  IF KEYWORD_SET(PS) THEN BEGIN
     PCLOSE

     EPS2PDF,plotDir+psFileName, $
             /PS, $
             /TO_PNG, $
             /REMOVE_EPS

  ENDIF

  CLOSE,lun
  FREE_LUN,lun

  ;; inds = GET_ORBRANGE_INDS(MAXIMUS__maximus,1000,12670,/DONT_TRASH_BAD_ORBITS)
  ;; inds = CGSETINTERSECTION(inds, $
  ;;                          WHERE(maximus__maximus.mlt  GE minM AND $
  ;;                                maximus__maximus.mlt  LE maxM AND $
  ;;                                maximus__maximus.ilat GE minI AND $
  ;;                                maximus__maximus.ilat LE maxI))
  inds = i_final[-1]


  meanMag = !NULL
  medMag  = !NULL
  altArr  = !NULL
  altDelta = 500
  alt     = MIN(maximus__maximus.alt) ;
  altMax  = 4300
  WHILE alt LT altMax DO BEGIN
     tmpI    = CGSETINTERSECTION(inds,WHERE(maximus__maximus.alt GE alt AND $
                                            maximus__maximus.alt LT (alt+altDelta)))

     mean    = MEAN(data[tmpI])
     median  = MEDIAN(data[tmpI])
     meanMag = [meanMag,mean]
     medMag  = [medMag,median]

     altArr  = [altArr,MEAN([alt,alt+altDelta])]
     alt    += altDelta
     
  ENDWHILE


  title = STRING(FORMAT='(F0.1,"-",F0.1," MLT, ",F0.1,"-",F0.1," ILAT")', $
                 minM,maxM, $
                 minI,maxI)
  plot = PLOT(ABS(maximus__maximus.mag_current[inds]), $
              maximus__maximus.alt[inds], $
              LINESTYLE='', $
              SYMBOL='*', $
              SYM_TRANSPARENCY=85, $
              YRANGE=[300,4300], $
              ;; XRANGE=[0,100], $
              XRANGE=[1,1000], $
              XLOG=1, $
              TITLE=title, $
              YTITLE='Altitude (km)', $
              XTITLE='FG Mag Current Density ($\mu$A/m!U2!N)')
  ;; plot = PLOT(meanMag, $
  ;;             altArr, $
  ;;             COLOR='Red', $
  ;;             THICK=2, $
  ;;             /OVERPLOT)

  plot = PLOT(medMag, $
              altArr, $
              COLOR='Red', $
              THICK=2, $
              /OVERPLOT)

  plot.Save,plotDir + psFileName + '--all.png'
  STOP
  
END
