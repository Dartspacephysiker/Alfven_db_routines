PRO H2D_STEREOGRAPHIC_EXECUTE_POLYFILL,lonsLats,h2dScaledData, $
                                       EQUAL_AREA_BINNING=equal_area_binning, $
                                       H2D_MASKED=h2d_masked, $
                                       MASKCOLOR=maskColor, $
                                       MAP_OBJECT=map
                                       

  CASE 1 OF
     KEYWORD_SET(equal_area_binning): BEGIN
        nLats = N_ELEMENTS(lonsLats[0,*,0,0])
        nLons = nLats

        FOR j=0, nLats-2 DO BEGIN 
           tempLons = lonsLats[j,j,0,*]
           tempLats = lonsLats[j,j,1,*]
           cgColorFill,tempLons,tempLats, $
                       COLOR=(h2d_masked[j]) ? maskColor : h2dScaledData[j], $
                       MAP_OBJECT=map
        ENDFOR 
     END
     ELSE: BEGIN
        nLats = N_ELEMENTS(lonsLats[0,*,0,0]) + 1
        nLons = N_ELEMENTS(lonsLats[*,0,0,0]) + 1

        FOR j=0, nLats-2 DO BEGIN 
           FOR i=0, nLons-2 DO BEGIN 
              tempLons = lonsLats[i,j,0,*]
              tempLats = lonsLats[i,j,1,*]
              cgColorFill,tempLons,tempLats, $
                          COLOR=(h2d_masked[i,j]) ? maskColor : h2dScaledData[i,j], $
                          MAP_OBJECT=map
           ENDFOR 
        ENDFOR
     END
  ENDCASE


  RETURN

END