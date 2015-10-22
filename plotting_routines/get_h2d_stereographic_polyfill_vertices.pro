FUNCTION GET_H2D_STEREOGRAPHIC_POLYFILL_VERTICES,lons,lats, $
                              BINSIZE_LON=binsize_lon,BINSIZE_LAT=binsize_lat, $
                              CONVERT_MLT_TO_LON=convert_MLT_to_lon, $
                              DEBUG=debug

  IF KEYWORD_SET(convert_mlt_to_lon) THEN BEGIN
     lonFactor = binsize_lon*15/2.0
  ENDIF ELSE BEGIN
     lonFactor = binsize_lon/2.0
  ENDELSE

  nLats = N_ELEMENTS(lats)
  nLons = N_ELEMENTS(lons)

  outLonsLats = MAKE_ARRAY(nLons-1,nLats-1,8,2)

  FOR j=0, nLats-2 DO BEGIN 
     FOR i=0, nLons-2 DO BEGIN 
        tempLats=[lats[j],lats[j]+binsize_lat/2.0,lats[j+1]] 
        tempLons=[lons[i],lons[i],lons[i]] 

        IF KEYWORD_SET(debug) THEN BEGIN
           print,tempLats & print,tempLons
           tempLons=REBIN(tempLons,4)  
           tempLats=REBIN(tempLats,4) 
        ENDIF

        tempLats=[lats[j],tempLats,lats[j+1],REVERSE(tempLats)] 
        tempLons=[lons[i]+lonFactor,tempLons,lons[i]+lonFactor,tempLons+lonFactor*2]  

        outLonsLats[i,j,0,*] = tempLons
        outLonsLats[i,j,1,*] = tempLats

     ENDFOR 
  ENDFOR

  RETURN,outLonsLats

END