PRO H2D_STEREOGRAPHIC_EXECUTE_POLYFILL,lonsLats, $
                         BINSIZE_LON=binsize_lon,BINSIZE_LAT=binsize_lat, $
                         CONVERT_MLT_TO_LON=convert_MLT_to_lon, $
                         H2D_MASKED=h2d_masked,MASKCOLOR=maskColor

  nLats = N_ELEMENTS(lonsLats[0,*,0,0])
  nLons = N_ELEMENTS(lonsLats[*,0,0,0])

  FOR j=0, nLats-2 DO BEGIN 
     FOR i=0, nLons-2 DO BEGIN 

        tempLons = lonsLats[i,j,0,*]
        tempLats = lonsLats[i,j,1,*]
        cgColorFill,tempLons,tempLats,color=(h2d_masked[i,j]) ? maskColor : h2descl[i,j]

        ;;Integrals
        IF ~h2d_masked[i,j] AND tempLons[0] GE 180 AND tempLons[5] GE 180 THEN duskIntegral+=(temp.is_logged) ? 10.^temp.data[i,j] : temp.data[i,j] $
        ELSE IF ~h2d_masked[i,j] AND tempLons[0] LE 180 AND tempLons[5] LE 180 THEN dawnIntegral+=(temp.is_logged) ? 10.^temp.data[i,j] : temp.data[i,j]

     ENDFOR 
  ENDFOR

  RETURN

END