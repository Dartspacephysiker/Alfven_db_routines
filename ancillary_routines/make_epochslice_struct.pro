;2015/11/03
FUNCTION MAKE_EPOCHSLICE_STRUCT, $
   DATANAME=dataName, $
   EPOCHSTART=eStart, $
   EPOCHEND=eEnd, $
   IS_LOGGED_YDATA=is_logged, $
   YDATA=yData, $
   DO_HIST=do_hist, $
   HISTMIN=hMin, $
   HISTMAX=hMax, $
   HIST_DO_REVINDS=hDoRI, $
   HISTBINSIZE=hBinsize, $
   TDATA=tData, $
   MOMENTSTRUCT=momentStruct, $
   GENERATING_FILE=genFile


  eSlice_tmplt    = {tmplt_eSlice, $
                     dataName           : '', $
                     eStart             : DOUBLE(0), $
                     eEnd               : DOUBLE(0), $
                     is_logged          : 0, $
                     yList              : LIST(), $
                     yHistStr           : MAKE_ALFVENDBQUANTITY_HIST_STRUCT(), $
                     has_hist           : BYTE(0), $
                     tList              : LIST(), $
                     moments            : MAKE_MOMENT_STRUCT(), $
                     generating_file    : STRING('')}

  IF KEYWORD_SET(dataName) THEN eSlice_tmplt.dataName = dataName
  IF KEYWORD_SET(eStart) THEN eSlice_tmplt.eStart = eStart
  IF KEYWORD_SET(eEnd) THEN eSlice_tmplt.eEnd = eEnd
  IF KEYWORD_SET(is_logged) THEN eSlice_tmplt.is_logged = is_logged
  IF KEYWORD_SET(yData) THEN BEGIN 
     eSlice_tmplt.yList.add,yData

     IF KEYWORD_SET(DO_HIST) THEN BEGIN
        eSlice_tmplt.has_hist  = 1
        eSlice_tmplt.yHistStr = MAKE_ALFVENDBQUANTITY_HIST_STRUCT(yData, $
                                                            MINVAL=hMin, $
                                                            MAXVAL=hMax, $
                                                            BINSIZE=hBinsize, $
                                                            DO_REVERSE_INDS=hDoRI)
     ENDIF ELSE BEGIN
        eSlice_tmplt.has_hist = 0
     ENDELSE
  ENDIF
  IF KEYWORD_SET(tData) THEN eSlice_tmplt.tList.add,tData
  IF KEYWORD_SET(momentStruct) THEN eSlice_tmplt.moments = momentStruct
  IF KEYWORD_SET(genFile) THEN eSlice_tmplt.generating_file = genFile


  RETURN,eSlice_tmplt

END