;;2016/11/03 But why have the current threshold at +/- 10 microA/m^2?
PRO JOURNAL__20161103__JIM_AND_I_REEXAMINE_CURRENT_THRESHOLD

  COMPILE_OPT idl2,strictarrsubs

  show_allSide   = 0
  show_dayside   = 1
  show_nightside = 1

  ;;Histo options
  binSize   = 0.25
  maxIn     = 40
  minIn     = 1.0

  ;;plot options
  xWinSize  = 800
  yWinSize  = 700

  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,CORRECT_FLUXES=0,/DO_NOT_MAP_ANYTHING

  plotQ      = 'MAG_CURRENT'

  midAlt     = 1500
  highAlt    = 4100

  titleArr = ['Above ' + STRCOMPRESS(midAlt,/REMOVE_ALL), $
               'Below ' + STRCOMPRESS(midAlt,/REMOVE_ALL), $
               'Above ' + STRCOMPRESS(highAlt,/REMOVE_ALL)] + ' km'

  ;;Allside
  inds       = WHERE(maximus.alt GE midAlt AND maximus.orbit LE 10800)
  indsLow    = WHERE(maximus.alt LT midAlt AND maximus.orbit LE 10800)
  indsHigh   = WHERE(maximus.alt GE highAlt AND maximus.orbit LE 10800)

  indsList   = LIST(inds,indsLow,indsHigh)

  ;;Dayside
  indsD      = WHERE((maximus.alt GE midAlt) AND (maximus.orbit LE 10800) AND $
                    (maximus.MLT GE 6.0)     AND (maximus.MLT LT 18.0))
  indsDLow   = WHERE(maximus.alt LT midAlt   AND maximus.orbit LE 10800 AND $
                    (maximus.MLT GE 6.0)     AND (maximus.MLT LT 18.0))
  indsDHigh  = WHERE(maximus.alt GE highAlt  AND maximus.orbit LE 10800 AND $
                    (maximus.MLT GE 6.0)     AND (maximus.MLT LT 18.0))
  titleDArr  = titleArr + ' (dayside)'

  indsDList  = LIST(indsD,indsDLow,indsDHigh)
  DIndOfInds = 1

  ;;Nightside
  indsN      = WHERE((maximus.alt GE midAlt) AND (maximus.orbit LE 10800) AND $
                    (maximus.MLT LT 6.0)     OR  (maximus.MLT GE 18.0))
  indsNLow   = WHERE(maximus.alt LT midAlt   AND maximus.orbit LE 10800 AND $
                    (maximus.MLT LT 6.0)     OR  (maximus.MLT GE 18.0))
  indsNHigh  = WHERE(maximus.alt GE highAlt  AND maximus.orbit LE 10800 AND $
                    (maximus.MLT LT 6.0)     OR  (maximus.MLT GE 18.0))
  indsNList  = LIST(indsN,indsNLow,indsNHigh)
  titleNArr  = titleArr + ' (nightside)'
  NIndOfInds = 2


  ;;Current inds
  inds10low  = CGSETINTERSECTION(indslow,WHERE(ABS(maximus.mag_current) GE 10))
  inds5low   = CGSETINTERSECTION(indslow,WHERE(ABS(maximus.mag_current) GE 5))

  inds10     = CGSETINTERSECTION(inds,WHERE(ABS(maximus.mag_current) GE 10))
  inds5      = CGSETINTERSECTION(inds,WHERE(ABS(maximus.mag_current) GE 5))


  maxDB_i    = (WHERE(STRUPCASE(TAG_NAMES(maximus)) EQ STRUPCASE(plotQ)))[0]

  IF maxDB_i EQ -1 THEN STOP

  ListOfIndsLists = LIST(indsList,indsDList,indsNList)
  ListOfTitleArrs = LIST(titleArr,titleDArr,titleNArr)

  ;; indsOfInds = 0
  IF N_ELEMENTS(show_allside  ) EQ 0 AND $
     ~(KEYWORD_SET(show_dayside) OR KEYWORD_SET(show_nightside)) THEN BEGIN
     indsOfInds = 0
  ENDIF ELSE BEGIN
     indsOfInds = 1
  ENDELSE
  IF KEYWORD_SET(show_dayside  ) THEN indsOfInds = [indsOfInds,DIndOfInds]
  IF KEYWORD_SET(show_nightside) THEN indsOfInds = [indsOfInds,NIndOfInds]


  FOR k=0,N_ELEMENTS(indsOfInds) -1 DO BEGIN

     indOfInds = indsOfInds[k]

     indsList = ListOfIndsLists[indOfInds]
     titleArr = ListOfTitleArrs[indOfInds]

     ;;Setup graphics
     WINDOW,indOfInds,XSIZE=xWinSize,YSIZE=yWinSize

     columns   = 2
     rows      = 2 
     !P.MULTI  = [0, columns, rows, 0, 0]

     
     FOR inds_i=0,N_ELEMENTS(indsList)-1 DO BEGIN
        ;;Above midAlt
        CGHISTOPLOT,ABS(maximus.(maxDB_i)[indsList[inds_i]]), $
                    ;; XTITLE=(TAG_NAMES(maximus))[maxDB_i], $
                    ;; XTICKVALUES=[1,2], $
                    BINSIZE=binSize, $
                    XTICKNAMES=(inds_i EQ 0 ? [' ',' ',' ',' ',' '] : !NULL), $
                    ;; XSTYLE=3, $
                    TITLE=titleArr[inds_i], $
                    MAXINPUT=maxIn, $
                    MININPUT=minIn
     ENDFOR

  ENDFOR

  ;; ;;Below midAlt
  ;; CGHISTOPLOT,ABS(maximus.(maxDB_i)[indslow]), $
  ;;             BINSIZE=binSize, $
  ;;             XTITLE=(TAG_NAMES(maximus))[maxDB_i], $
  ;;             TITLE=, $
  ;;             MAXINPUT=maxIn, $
  ;;             MININPUT=minIn

  ;; ;;Above highAlt
  ;; CGHISTOPLOT,ABS(maximus.(maxDB_i)[indsHigh]), $
  ;;             BINSIZE=binSize, $
  ;;             XTITLE=(TAG_NAMES(maximus))[maxDB_i], $
  ;;             TITLE=, $
  ;;             MAXINPUT=maxIn, $
  ;;             MININPUT=minIn
END