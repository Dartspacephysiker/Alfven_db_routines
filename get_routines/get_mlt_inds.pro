FUNCTION GET_MLT_INDS,maximus,minM,maxM,DAYSIDE=dayside,NIGHTSIDE=nightside,N_MLT=n_mlt,N_OUTSIDE_MLT=n_outside_MLT,LUN=lun

  COMPILE_OPT idl2

  IF KEYWORD_SET(dayside) THEN BEGIN
     mlt_i = WHERE(maximus.mlt GE 0.0 AND maximus.mlt LE 18.0,n_mlt,NCOMPLEMENT=n_outside_MLT)
     
     PRINTF,lun,FORMAT='("Only dayside!",T35,I0)'
     PRINTF,lun,FORMAT='("n events on dayside           :",T35,I0)',n_mlt
  ENDIF ELSE BEGIN
     
     ;;special treatment for nightside
     IF KEYWORD_SET(nightside) THEN BEGIN
        mlt_i = WHERE(maximus.mlt LE 6.0 OR maximus.mlt GE 18.0,n_mlt,NCOMPLEMENT=n_outside_MLT)
        
        PRINTF,lun,"Only nightside!"
        PRINTF,lun,FORMAT='("n events on nightside         :",T35,I0)',n_mlt
     ENDIF ELSE BEGIN
        mlt_i = WHERE(maximus.mlt LE maxM and maximus.mlt GE minM,n_mlt,NCOMPLEMENT=n_outside_MLT)
        
        ;; PRINTF,lun,FORMAT='("MLT range: ",I0,"–",I0)',minM,maxM
        PRINTF,lun,FORMAT='("N events in MLT range         :",T35,I0)',n_mlt
     ENDELSE
  ENDELSE
  PRINTF,lun,FORMAT='("N outside MLT range           :",T35,I0)',n_outside_MLT
  PRINTF,lun,""
  
  RETURN,mlt_i
  
END