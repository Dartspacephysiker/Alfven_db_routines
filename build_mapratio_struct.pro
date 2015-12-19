;2015/12/19 A thing for build our struct with quantities for mapping from
;  FAST altitude to the ionosphere at 100 km
PRO BUILD_MAPRATIO_STRUCT,mapRatio,mag1,mag2,ratio,times,orbit


  IF N_ELEMENTS(mapRatio) EQ 0 THEN BEGIN

     mapRatio = { mag1: mag1, $
                  mag2: mag2, $
                  ratio: ratio, $
                  times: times, $
                  orbit: REPLICATE(orbit,N_ELEMENTS(mag1))}


  ENDIF ELSE BEGIN

     mapRatio = { mag1: [mapRatio.mag1,mag1], $
                  mag2: [mapRatio.mag2,mag2], $
                  ratio: [mapRatio.ratio,ratio], $
                  times: [mapRatio.times,times], $
                  orbit: [mapRatio.orbit,REPLICATE(orbit,N_ELEMENTS(mag1))]}
     

  ENDELSE

END