PRO PRINT_EPOCHSLICE_STRUCT_STATS,ssa,LUN=lun

  IF ~KEYWORD_SET(lun) THEN lun = -1

  PRINTF,lun,FORMAT='("Low (hr)",T10,"High (hr)",T20,"N",T30,"Mean",T40,"Std. dev.",T50,"Skewness",T60,"Kurtosis",T70,"Median")'

  FOR i=0,N_ELEMENTS(ssa)-1 DO BEGIN
     
     PRINTF,lun,FORMAT='("***",I4," : ",A0,"***")',i,ssa[i].dataName
     PRINTF,lun,FORMAT='(A8,T10,A8,T20,I0,T30,G9.4,T40,G9.4,T50,G9.4,T60,G9.4,T70,G9.4)', $
            TIME_TO_STR(ssa[i].eStart), $
            TIME_TO_STR(ssa[i].eEnd), $
            N_ELEMENTS(ssa[i].yList[0]), $
            ssa[i].moments.(0), $
            SQRT(ssa[i].moments.(1)), $
            ssa[i].moments.(2), $
            ssa[i].moments.(3), $
            ssa[i].moments.(4)[1]
     
  ENDFOR

END