PRO H2D_STEREOGRAPHIC_EXECUTE_POLYFILL,lonsLats,h2dScaledData, $
                         H2D_MASKED=h2d_masked,MASKCOLOR=maskColor

  nLats = N_ELEMENTS(lonsLats[0,*,0,0]) + 1
  nLons = N_ELEMENTS(lonsLats[*,0,0,0]) + 1

  FOR j=0, nLats-2 DO BEGIN 
     FOR i=0, nLons-2 DO BEGIN 
        tempLons = lonsLats[i,j,0,*]
        tempLats = lonsLats[i,j,1,*]
        cgColorFill,tempLons,tempLats,color=(h2d_masked[i,j]) ? maskColor : h2dScaledData[i,j]
     ENDFOR 
  ENDFOR

  RETURN

END