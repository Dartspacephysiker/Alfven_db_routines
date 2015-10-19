;2015/10/19  Added ability to give negative minM so that, for example, the range 18 MLT to 6 MLT (nightside) is possible
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
        ;;Check whether minM is negative (so, for example, we can get pre-midnight to early morning)
        IF minM LT 0 THEN BEGIN
           PRINTF,lun,'Negative minM! Treating MLTs between ' + STRCOMPRESS(minM+24,/REMOVE_ALL) + ' and ' + STRCOMPRESS(maxM,/REMOVE_ALL)
           IF (minM + 24) GT maxM THEN BEGIN
              PRINTF,lun,"GET_MLT_INDS: minM and maxM together make no sense! (minM + 24) is greater than maxM!"
              STOP
           ENDIF
           mlt_i_1 = WHERE( maximus.mlt GE (minMLT+24),n_mlt1 )
           mlt_i_2 = WHERE( maximus.mlt LE maxMLT,n_mlt2)

           wherecheck,mlt_i_1,mlt_i_2
           n_mlt = n_mlt1 + n_mlt2
           mlt_i = cgsetintersection(mlt_i_1,mlt_i_2) 

           PRINTF,lun,FORMAT='("N events in MLT range         :",T35,I0)',n_mlt
        ENDIF ELSE BEGIN
           mlt_i = WHERE(maximus.mlt LE maxM and maximus.mlt GE minM,n_mlt,NCOMPLEMENT=n_outside_MLT)
           
           ;; PRINTF,lun,FORMAT='("MLT range: ",I0,"–",I0)',minM,maxM
           PRINTF,lun,FORMAT='("N events in MLT range         :",T35,I0)',n_mlt
        ENDELSE
     ENDELSE
  ENDELSE
  PRINTF,lun,FORMAT='("N outside MLT range           :",T35,I0)',n_outside_MLT
  PRINTF,lun,""
  
  RETURN,mlt_i
  
END