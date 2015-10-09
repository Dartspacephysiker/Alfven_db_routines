FUNCTION GET_MLT_INDS,maximus,minM,maxM,DAYSIDE=dayside,NIGHTSIDE=nightside,N_ILAT=n_ilat,N_OUTSIDE_MLT=n_outside_MLT,LUN=lun

  IF KEYWORD_SET(dayside) THEN BEGIN
     mlt_i = WHERE(maximus.mlt GE 0.0 AND maximus.mlt LE 18.0,NCOMPLEMENT=n_outside_MLT)
     
     PRINTF,lun,"Only dayside!"
     PRINTF,lun,"n events on dayside: " + STRCOMPRESS(N_ELEMENTS(mlt_i),/REMOVE_ALL)
  ENDIF ELSE BEGIN
     
     ;;special treatment for nightside
     IF KEYWORD_SET(nightside) THEN BEGIN
        mlt_i = WHERE(maximus.mlt LE 6.0 OR maximus.mlt GE 18.0,NCOMPLEMENT=n_outside_MLT)
        
        PRINTF,lun,"Only nightside!"
        PRINTF,lun,"n events on nightside: " + STRCOMPRESS(N_ELEMENTS(mlt_i),/REMOVE_ALL)
     ENDIF ELSE BEGIN
        mlt_i = WHERE(maximus.mlt LE maxM and maximus.mlt GE minM,NCOMPLEMENT=n_outside_MLT)
        
        PRINTF,lun,"MLT range: " + STRCOMPRESS(minM,/REMOVE_ALL) + "–" + $
               STRCOMPRESS(maxM,/REMOVE_ALL)
        PRINTF,lun," N events in MLT range: " + STRCOMPRESS(N_ELEMENTS(mlt_i),/REMOVE_ALL)
     ENDELSE
  ENDELSE
  PRINTF,lun,'N outside MLT range: ' + STRCOMPRESS(n_outside_MLT,/REMOVE_ALL)
  PRINTF,lun,''
  
  RETURN,mlt_i
  
END