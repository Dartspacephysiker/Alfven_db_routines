;;12/30/16
PRO JOURNAL__20161230__EXPLORE_MAG_AND_ESA_CURRENT_ASYMMETRY

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__maximus_vars.pro
  
  use_AACGM_coords = 1

  IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
     LOAD_MAXIMUS_AND_CDBTIME, $
        USE_AACGM_COORDS=use_AACGM_coords
  ENDIF

  minPow = -2
  maxPow = 5
  nPows  = (maxPow-minPow)*2+1
  pows   = INDGEN(nPows)/2.-MEAN([minPow,maxPow])-0.5

  ESACur = MAXIMUS__maximus.ESA_current
  MAGCur = MAXIMUS__maximus.MAG_current

  PRINT,FORMAT='(T20,A0,T70,A0)',"ESA Current","Mag current"
  PRINT,FORMAT='(A0,T20,A0,T30,A0,T40,A0,T70,A0,T80,A0,T90,A0)',"Pow","nNeg","nPos","Rat","nNeg","nPos","Rat"
  FOR k=0,nPows-1 DO BEGIN
     nESANeg = N_ELEMENTS(WHERE((ESACur LT 0) AND $
                                (ESACur GT ((-1)*(10.^pows[k]))),/NULL))
     nESAPos = N_ELEMENTS(WHERE((ESACur GT 0) AND $
                                (ESACur LT ((10.^pows[k]))),/NULL))
     ESARat  = (nESANeg GT 0 AND nESAPos GT 0) ? nESANeg/FLOAT(nESAPos) : 0

     nMAGNeg = N_ELEMENTS(WHERE((MAGCur LT 0) AND $
                                (MAGCur GT ((-1)*(10.^pows[k]))),/NULL))
     nMAGPos = N_ELEMENTS(WHERE((MAGCur GT 0) AND $
                                (MAGCur LT ((10.^pows[k]))),/NULL))
     MAGRat  = (nMAGNeg GT 0 AND nMAGPos GT 0) ? nMAGNeg/FLOAT(nMAGPos) : 0


     PRINT,FORMAT='(F5.2,T20,I-0,T30,I-0,T40,F-8.4,T70,I-0,T80,I-0,T90,F-8.4)', $
           pows[k], $
           nESANeg, $
           nESAPos, $
           ESARat, $
           nMAGNeg, $
           nMAGPos, $
           MAGRat

  ENDFOR

  STOP


END
