;2015/11/03
FUNCTION MAKE_HISTOPLOT_PARAM_STRUCT, $
   NAME=name, $
   XRANGE=xRange, $
   YRANGE=yRange, $
   TITLE=title, $
   XTITLE=xTitle, $
   YTITLE=yTitle, $
   YLOG=yLog, $
   HISTBINSIZE=histBinsize, $
   XP_ARE_LOGGED=xP_are_logged, $
   LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF KEYWORD_SET(xRange) THEN BEGIN
     IF N_ELEMENTS(xRange) NE 2 THEN BEGIN
        PRINTF,lun,"Incorrect num of elements for xRange keyword!"
        PRINTF,lun,"Returning !NULL..."
        RETURN, !NULL
     ENDIF
  ENDIF

  IF KEYWORD_SET(yRange) THEN BEGIN
     IF N_ELEMENTS(yRange) NE 2 THEN BEGIN
        PRINTF,lun,"Incorrect num of elements for yRange keyword!"
        PRINTF,lun,"Returning !NULL..."
        RETURN, !NULL
     ENDIF
  ENDIF

  pHistParam_tmplt = {tmplt_pHistParam, $
                      NAME               : KEYWORD_SET(NAME) ? NAME : '', $
                      xRange             : KEYWORD_SET(xRange) ? xRange : MAKE_ARRAY(2,/DOUBLE), $
                      yRange             : KEYWORD_SET(yRange) ? yRange : MAKE_ARRAY(2,/DOUBLE), $
                      title              : KEYWORD_SET(title) ? title : '', $
                      xTitle             : KEYWORD_SET(xTitle) ? xTitle : '', $
                      yTitle             : KEYWORD_SET(yTitle) ? yTitle : '', $
                      yLog               : KEYWORD_SET(yLog) ? yLog : BYTE(0), $
                      histBinsize        : KEYWORD_SET(histBinsize) ? histBinsize : DOUBLE(0), $
                      xP_are_logged      : KEYWORD_SET(xP_are_logged) ? xP_are_logged : BYTE(0)}
  
  RETURN,pHistParam_tmplt

END