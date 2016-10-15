;;2016/03/29
;;In this case, we're getting the number of orbits passing through a given bin per MINUTE
PRO GET_ORBIT_FREQUENCY_PLOTDATA,maximus,MINM=minM,MAXM=maxM, $
                                 SHIFTM=shiftM, $
                                 BINM=binM, $
                                 MINI=minI,MAXI=maxI,BINI=binI, $
                                 EQUAL_AREA_BINNING=EA_binning, $
                                 ORBFREQRANGE=orbFreqRange, $
                                 H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr, $
                                 H2DCONTRIBORBSTR=h2dContribOrbStr, $
                                 THISTDENOMINATOR=tHistDenominator, $
                                 H2DTOTORBSTR=h2dTotOrbStr, $
                                 H2D_NONZERO_ALLORB_I=h2d_nonZero_allOrb_i, $
                                 H2D_NONZERO_CONTRIBORBS_I=h2d_nonzero_contribOrbs_i, $
                                 DIV_ORBCONTRIB_BY_ORBTOT=div_orbContrib_by_orbTot, $
                                 DATANAME=dataName

  COMPILE_OPT idl2

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI), $
                                      SHIFT1=shiftM,SHIFT2=shiftI, $
                                      EQUAL_AREA_BINNING=EA_binning, $
                                      CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                      CB_FORCE_OOBLOW=cb_force_oobLow)

  ;; h2dStr={tmplt_h2dStr}
  h2dStr          = tmplt_h2dStr
  
  h2dStr.data     = h2dContribOrbStr.data
  IF KEYWORD_SET(div_orbContrib_by_orbTot) THEN BEGIN
     h2dStr.title    = "N Orbits per Total N Orbits"
     dataName        = "orbContrib_per_orbTot"
     h2dStr.name     = dataName
     h2dStr.data[h2d_nonZero_allOrb_i]=DOUBLE(h2dContribOrbStr.data[h2d_nonZero_allOrb_i])/h2dTotOrbStr.data[h2d_nonZero_allOrb_i]
  ENDIF ELSE BEGIN
     h2dStr.title    = "Orbit Frequency"
     dataName        = "orbFreq_"
     h2dStr.name     = dataName
     H2D_OK_i        = WHERE(tHistDenominator GT 0)
     h2dStr.data[H2D_OK_i] = DOUBLE(h2dContribOrbStr.data[H2D_OK_i])/h2dTotOrbStr.data[H2D_OK_i]
  ENDELSE
  
  IF N_ELEMENTS(orbFreqRange) EQ 0 OR N_ELEMENTS(orbFreqRange) NE 2 THEN $
     h2dStr.lim   = [MIN(h2dStr.data),MAX(h2dStr.data)] $
  ELSE $
     h2dStr.lim   = orbFreqRange
  
END