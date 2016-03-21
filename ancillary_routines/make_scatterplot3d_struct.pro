;2015/11/03
FUNCTION MAKE_SCATTERPLOT3D_STRUCT, $
   DATANAME1=dataName1, $
   DATANAME2=dataName2, $
   DATANAME3=dataName3, $
   EPOCHSTART=eStart, $
   EPOCHEND=eEnd, $
   DATA1=data1, $
   DATA2=data2, $
   DATA3=data3, $
   IS_LOGGED_DATA1=is_xLogged, $
   IS_LOGGED_DATA2=is_yLogged, $
   IS_LOGGED_DATA3=is_zLogged, $
   MOMENTSTRUCT1=MomentStruct1, $
   MOMENTSTRUCT2=MomentStruct2, $
   MOMENTSTRUCT3=MomentStruct3, $
   GENERATING_FILE=genFile


  scatterStruct3d_tmplt    = {tmplt_scatter3d, $
                              dataName1           : '', $
                              dataName2           : '', $
                              dataName3           : '', $
                              eStart             : DOUBLE(0), $
                              eEnd               : DOUBLE(0), $
                              is_xLogged         : 0, $
                              is_yLogged         : 0, $
                              is_zLogged         : 0, $
                              xList              : LIST(), $
                              yList              : LIST(), $
                              zList              : LIST(), $
                              xMoments           : MAKE_MOMENT_STRUCT(), $
                              yMoments           : MAKE_MOMENT_STRUCT(), $
                              zMoments           : MAKE_MOMENT_STRUCT(), $
                              generating_file    : STRING('')}
  
  IF KEYWORD_SET(eStart) THEN scatterStruct3d_tmplt.eStart = eStart
  IF KEYWORD_SET(eEnd) THEN scatterStruct3d_tmplt.eEnd = eEnd

  IF KEYWORD_SET(dataName1) THEN scatterStruct3d_tmplt.dataName1 = dataName1
  IF KEYWORD_SET(dataName2) THEN scatterStruct3d_tmplt.dataName2 = dataName2
  IF KEYWORD_SET(dataName3) THEN scatterStruct3d_tmplt.dataName3 = dataName3

  IF KEYWORD_SET(data1) THEN scatterStruct3d_tmplt.xList.add,data1
  IF KEYWORD_SET(data2) THEN scatterStruct3d_tmplt.yList.add,data2
  IF KEYWORD_SET(data3) THEN scatterStruct3d_tmplt.zList.add,data3

  IF KEYWORD_SET(is_logged_data1) THEN scatterStruct3d_tmplt.is_xLogged = is_xLogged
  IF KEYWORD_SET(is_logged_data2) THEN scatterStruct3d_tmplt.is_yLogged = is_yLogged
  IF KEYWORD_SET(is_logged_data3) THEN scatterStruct3d_tmplt.is_zLogged = is_zLogged

  IF KEYWORD_SET(momentStruct1) THEN scatterStruct3d_tmplt.xMoments = momentStruct1
  IF KEYWORD_SET(momentStruct2) THEN scatterStruct3d_tmplt.yMoments = momentStruct2
  IF KEYWORD_SET(momentStruct3) THEN scatterStruct3d_tmplt.zMoments = momentStruct3

  IF KEYWORD_SET(genFile) THEN scatterStruct3d_tmplt.generating_file = genFile


  RETURN,scatterStruct3d_tmplt

END