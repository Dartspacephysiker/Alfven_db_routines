;2015/11/03
FUNCTION MAKE_SCATTERPLOT_STRUCT, $
   DATANAME1=dataName1, $
   DATANAME2=dataName2, $
   EPOCHSTART=eStart, $
   EPOCHEND=eEnd, $
   DATA1=data1, $
   DATA2=data2, $
   IS_LOGGED_DATA1=is_xLogged, $
   IS_LOGGED_DATA2=is_yLogged, $
   MOMENTSTRUCT1=MomentStruct1, $
   MOMENTSTRUCT2=MomentStruct2, $
   GENERATING_FILE=genFile


  scatterStruct_tmplt    = {tmplt_scatter, $
                            dataName1           : '', $
                            dataName2           : '', $
                            eStart             : DOUBLE(0), $
                            eEnd               : DOUBLE(0), $
                            is_xLogged         : 0, $
                            is_yLogged         : 0, $
                            xList              : LIST(), $
                            yList              : LIST(), $
                            xMoments           : MAKE_MOMENT_STRUCT(), $
                            yMoments           : MAKE_MOMENT_STRUCT(), $
                            generating_file    : STRING('')}
  
  IF KEYWORD_SET(eStart) THEN scatterStruct_tmplt.eStart = eStart
  IF KEYWORD_SET(eEnd) THEN scatterStruct_tmplt.eEnd = eEnd

  IF KEYWORD_SET(dataName1) THEN scatterStruct_tmplt.dataName1 = dataName1
  IF KEYWORD_SET(dataName2) THEN scatterStruct_tmplt.dataName2 = dataName2

  IF KEYWORD_SET(data1) THEN scatterStruct_tmplt.xList.add,data1
  IF KEYWORD_SET(data2) THEN scatterStruct_tmplt.yList.add,data2

  IF KEYWORD_SET(is_logged_data1) THEN scatterStruct_tmplt.is_xLogged = is_xLogged
  IF KEYWORD_SET(is_logged_data2) THEN scatterStruct_tmplt.is_yLogged = is_yLogged

  IF KEYWORD_SET(momentStruct1) THEN scatterStruct_tmplt.xMoments = momentStruct1
  IF KEYWORD_SET(momentStruct2) THEN scatterStruct_tmplt.yMoments = momentStruct2

  IF KEYWORD_SET(genFile) THEN scatterStruct_tmplt.generating_file = genFile


  RETURN,scatterStruct_tmplt

END