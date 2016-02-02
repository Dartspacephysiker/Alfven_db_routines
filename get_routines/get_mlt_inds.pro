;2015/10/19  Added ability to give negative minM so that, for example, the range 18 MLT to 6 MLT (nightside) is possible
FUNCTION GET_MLT_INDS,maximus,minM,maxM, $
                      DAYSIDE=dayside, $
                      NIGHTSIDE=nightside, $
                      N_MLT=n_mlt, $
                      N_OUTSIDE_MLT=n_outside_MLT, $
                      DIRECT_MLTS=direct_mlts, $
                      LUN=lun

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun=-1 ;;stdout

  IF N_ELEMENTS(maximus) EQ 0 THEN BEGIN
     IF ~KEYWORD_SET(direct_mlts) THEN BEGIN
        PRINTF,lun,"Error! No maximus struct provided!"
        STOP
     ENDIF ELSE BEGIN
        PRINTF,lun,'Using direct mlts provided by user...'
        mlts                     = direct_mlts
     ENDELSE
  ENDIF ELSE BEGIN
     mlts                        = maximus.mlt
  ENDELSE

  IF KEYWORD_SET(dayside) THEN BEGIN
     mlt_i = WHERE(mlts GE 0.0 AND mlts LE 18.0,n_mlt,NCOMPLEMENT=n_outside_MLT)
     
     PRINTF,lun,FORMAT='("Only dayside!",T35,I0)'
     PRINTF,lun,FORMAT='("n events on dayside",T30,":",T35,I0)',n_mlt
  ENDIF ELSE BEGIN
     
     ;;special treatment for nightside
     IF KEYWORD_SET(nightside) THEN BEGIN
        mlt_i = WHERE(mlts LE 6.0 OR mlts GE 18.0,n_mlt,NCOMPLEMENT=n_outside_MLT)
        
        PRINTF,lun,"Only nightside!"
        PRINTF,lun,FORMAT='("n events on nightside",T30,":",T35,I0)',n_mlt
     ENDIF ELSE BEGIN
        ;;Check whether minM is negative (so, for example, we can get pre-midnight to early morning)
        IF minM LT 0 THEN BEGIN
           PRINTF,lun,'Negative minM! Treating MLTs between ' + STRCOMPRESS(minM+24,/REMOVE_ALL) + ' and ' + STRCOMPRESS(maxM,/REMOVE_ALL)
           IF (minM + 24) LT maxM THEN BEGIN
              PRINTF,lun,"GET_MLT_INDS: minM and maxM together make no sense! (minM + 24) is less than maxM!"
              STOP
           ENDIF
           mlt_i_1 = WHERE( mlts GE (minM+24),n_mlt1 )
           mlt_i_2 = WHERE( mlts LE maxM,n_mlt2)

           wherecheck,mlt_i_1,mlt_i_2
           n_mlt = n_mlt1 + n_mlt2
           n_outside_mlt = N_ELEMENTS(mlts) - n_mlt
           mlt_i = cgsetunion(mlt_i_1,mlt_i_2) 

           PRINTF,lun,FORMAT='("N events in MLT range",T30,":",T35,I0)',n_mlt
        ENDIF ELSE BEGIN
           mlt_i = WHERE(mlts LE maxM and mlts GE minM,n_mlt,NCOMPLEMENT=n_outside_MLT)
           
           ;; PRINTF,lun,FORMAT='("MLT range: ",I0,"–",I0)',minM,maxM
           PRINTF,lun,FORMAT='("N events in MLT range",T30,":",T35,I0)',n_mlt
        ENDELSE
     ENDELSE
  ENDELSE

  IF mlt_i[0] EQ -1 THEN BEGIN
     PRINTF,lun,'No MLT entries found for the specified MLT range!'
     STOP
  ENDIF


  PRINTF,lun,FORMAT='("N outside MLT range",T30,":",T35,I0)',n_outside_MLT
  PRINTF,lun,""
  
  RETURN,mlt_i
  
END