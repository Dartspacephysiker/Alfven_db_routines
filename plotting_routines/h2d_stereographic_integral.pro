PRO  H2D_STEREOGRAPHIC_INTEGRAL,h2dStr,lonsLats, $
                                H2D_MASKED=h2d_masked, $
                                INTEGRAL=integral,ABSINTEGRAL=absIntegral, $
                                DAWNINTEGRAL=dawnIntegral,DUSKINTEGRAL=duskIntegral

  nLats = N_ELEMENTS(lonsLats[0,*,0,0])+1
  nLons = N_ELEMENTS(lonsLats[*,0,0,0])+1
  
  ;Initialize integrals for each hemi
  dawnIntegral=(h2dStr.is_fluxData) ? DOUBLE(0.0) : 0L
  duskIntegral=(h2dStr.is_fluxData) ? DOUBLE(0.0) : 0L
  FOR j=0, nLats-2 DO BEGIN 
     FOR i=0, nLons-2 DO BEGIN 
        tempLons = lonsLats[i,j,0,*]
        tempLats = lonsLats[i,j,1,*]
        
        ;;Integrals
        IF ~h2d_masked[i,j] AND tempLons[0] GE 180 AND tempLons[5] GE 180 THEN duskIntegral+=(h2dStr.is_logged) ? 10.^h2dStr.data[i,j] : h2dStr.data[i,j] $
        ELSE IF ~h2d_masked[i,j] AND tempLons[0] LE 180 AND tempLons[5] LE 180 THEN dawnIntegral+=(h2dStr.is_logged) ? 10.^h2dStr.data[i,j] : h2dStr.data[i,j]
     ENDFOR 
  ENDFOR

  IF h2dStr.is_logged THEN BEGIN
     integral=ALOG10(TOTAL(10.0^(h2dStr.data[WHERE(~h2d_masked)])))
     absIntegral=integral
        dawnIntegral=ALOG10(dawnIntegral)
        duskIntegral=ALOG10(duskIntegral)
     ENDIF ELSE BEGIN
        integral=TOTAL(h2dStr.data[WHERE(~h2d_masked)])
        absIntegral=TOTAL(ABS(h2dStr.data[WHERE(~h2d_masked)]))
     ENDELSE     

END