;2016/03/12 I ultimately want to be able to calculate gross rates of energy deposition, ion outflow, etc., but to do that
;           I need the area of lat/long patches. Check it.
PRO JOURNAL__20160312__MESSING_WITH_NEW_AREA_CALCULATOR


  ;; hemi                                        = 'SOUTH'
  hemi                                        = 'NORTH'

  binI                                        = 3

  minM                                        = 0.00000
  maxM                                        = 24.0000
  binM                                        = 0.5
  ;; shiftM                                      = 0.25

  IF STRUPCASE(hemi) EQ 'SOUTH' THEN BEGIN
     minI                                     = -83.0000
     maxI                                     = -56.0000
  ENDIF ELSE BEGIN
     minI                                     = 56.0000
     maxI                                     = 83.0000
  ENDELSE

  GET_H2D_BIN_CENTERS_OR_EDGES,centers, $
                    CENTERS1=centersMLT,CENTERS2=centersILAT, $
                    BINSIZE1=binM, BINSIZE2=binI, $
                    MAX1=maxM, MAX2=maxI, $
                    MIN1=minM, MIN2=minI, $
                    SHIFT1=shiftM, SHIFT2=shiftI, $
                    BINEDGE1=-1,BINEDGE2=-1

  ;;Get the ILAT and MLT bin areas, assuming R = 6471 km (R_earth + 100km)
  GET_H2D_BIN_AREAS,areas, $
                    CENTERS1=centersMLT,CENTERS2=centersILAT, $
                    BINSIZE1=binM*15., BINSIZE2=binI, $
                    MAX1=maxM*15., MAX2=maxI, $
                    MIN1=minM*15., MIN2=minI, $
                    SHIFT1=shiftM*15., SHIFT2=shiftI

END