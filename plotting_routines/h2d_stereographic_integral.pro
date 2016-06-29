PRO  H2D_STEREOGRAPHIC_INTEGRAL,h2dStr,lonsLats, $
                                H2D_MASKED=h2d_masked, $
                                INTEGRAL=integral, $
                                ABSINTEGRAL=absIntegral, $
                                DAWNINTEGRAL=dawnIntegral, $
                                DUSKINTEGRAL=duskIntegral, $
                                DAYINTEGRAL=dayIntegral, $
                                NIGHTINTEGRAL=nightIntegral, $
                                OUTPUT_INTEGRAL=output_integral, $
                                INTLUN=intLun
  

  nLats              = N_ELEMENTS(lonsLats[0,*,0,0])+1
  nLons              = N_ELEMENTS(lonsLats[*,0,0,0])+1
  
  ;Initialize integrals for each hemi
  dawnIntegral       = (h2dStr.is_fluxData) ? DOUBLE(0.0) : 0L
  duskIntegral       = (h2dStr.is_fluxData) ? DOUBLE(0.0) : 0L
  dayIntegral        = (h2dStr.is_fluxData) ? DOUBLE(0.0) : 0L
  nightIntegral      = (h2dStr.is_fluxData) ? DOUBLE(0.0) : 0L
  FOR j=0, nLats-2 DO BEGIN 
     FOR i=0, nLons-2 DO BEGIN 
        tempLons     = REFORM(lonsLats[i,j,0,*])
        tempLats     = REFORM(lonsLats[i,j,1,*])
        
        ;;Integrals
        IF ~h2d_masked[i,j] THEN BEGIN

           IF tempLons[0] GE 180 AND $
              tempLons[-1] GE 180 $
           THEN BEGIN
              duskIntegral    += (h2dStr.is_logged) ? 10.^h2dStr.data[i,j] : h2dStr.data[i,j]
           ENDIF ELSE BEGIN
              IF tempLons[0] LE 180 AND $
                 tempLons[-1] LE 180 $
              THEN BEGIN
                 dawnIntegral += (h2dStr.is_logged) ? 10.^h2dStr.data[i,j] : h2dStr.data[i,j]
              ENDIF
           ENDELSE

           IF (tempLons[0] LE 90  AND tempLons[-1] LE 90 ) OR $
              (tempLons[0] GE 270 AND tempLons[-1] GE 270)    $
           THEN BEGIN
              nightIntegral   += (h2dStr.is_logged) ? 10.^h2dStr.data[i,j] : h2dStr.data[i,j]
           ENDIF ELSE BEGIN
              IF (tempLons[0] GE 90  AND tempLons[-1] GE 90 ) AND $
                 (tempLons[0] LE 270 AND tempLons[-1] LE 270)    $
              THEN BEGIN
                 dayIntegral  += (h2dStr.is_logged) ? 10.^h2dStr.data[i,j] : h2dStr.data[i,j]
              ENDIF
           ENDELSE

        ENDIF

     ENDFOR 
  ENDFOR

  IF h2dStr.is_logged THEN BEGIN
     integral        = ALOG10(TOTAL(10.0^(h2dStr.data[WHERE(~h2d_masked)])))
     absIntegral     = integral
     dawnIntegral    = ALOG10(dawnIntegral)
     duskIntegral    = ALOG10(duskIntegral)
     dayIntegral     = ALOG10(dayIntegral)
     nightIntegral   = ALOG10(nightIntegral)
  ENDIF ELSE BEGIN
     integral        = TOTAL(h2dStr.data[WHERE(~h2d_masked)])
     absIntegral     = TOTAL(ABS(h2dStr.data[WHERE(~h2d_masked)]))
  ENDELSE     

     IF KEYWORD_SET(output_integral) THEN BEGIN
        ;; OPENW,intlun,integralFile,/GET_LUN,/APPEND

        ;; labFormat    = STRMID(h2dStr.labelFormat, $
        ;;                       1, $
        ;;                       STRPOS(h2dStr.labelFormat,')',/REVERSE_SEARCH)-1)
        labFormat    = 'G0.4'

        PRINTF,intLun,''
        PRINTF,intLun,FORMAT='(" Total ",T15,":",T20,'+labFormat+')',integral
        PRINTF,intLun,FORMAT='("|Total|",T15,":",T20,'+labFormat+')',integral
        PRINTF,intLun,''
        PRINTF,intLun,FORMAT='("Dayside",T15,":",T20,'+labFormat+')',dayIntegral
        PRINTF,intLun,FORMAT='("Nightside",T15,":",T20,'+labFormat+')',nightIntegral
        PRINTF,intLun,''
        PRINTF,intLun,FORMAT='("Dawnside",T15,":",T20,'+labFormat+')',dawnIntegral
        PRINTF,intLun,FORMAT='("Duskside",T15,":",T20,'+labFormat+')',duskIntegral
        PRINTF,intLun,''

        ;; CLOSE,intLun
        ;; FREE_LUN,intLun
     ENDIF



END