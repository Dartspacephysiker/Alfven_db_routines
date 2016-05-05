;2015
;2015/10/15 This may now have some serious problems as of this date; be sure to check it!
PRO GET_NEVENTS_PER_ORBIT_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM, $
                                   BINM=binM,$
                                   SHIFTM=shiftM, $
                                   MINI=minI,MAXI=maxI,BINI=binI, $
                                   DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                   NEVENTPERORBRANGE=nEventPerOrbRange, $
                                   NEVENTPERORBAUTOSCALE=nEventPerOrbAutoscale, $
                                   LOGNEVENTPERORB=logNEventPerOrb, $
                                   DIVNEVBYTOTAL=divNEvByTotal, $
                                   H2D_NONZERO_NEV_I=h2d_Nonzero_nEv_i, $
                                   H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2DFLUXN=h2dFluxN, $
                                   H2DCONTRIBORBSTR=h2dContribOrbStr, $
                                   H2D_NONZERO_CONTRIBORBS_I=h2d_nonZero_contribOrbs_i, $
                                   H2DTOTORBSTR=h2dTotOrbStr, H2D_NONZERO_ALLORB_I=h2d_nonZero_allOrb_i, $
                                   DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                                   PRINT_MAX_AND_MIN=print_mandm, $
                                   LUN=lun
                                   

  COMPILE_OPT idl2

  IF N_ELEMENTS(print_mandm) EQ 0 THEN print_mandm = 1

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1
  ;;h2dStr(0) is automatically the n_events histo whenever either nEventPerOrbPlot or nEventPerMinPlot keywords are set.
  ;;This makes h2dStr(1) the mask histo.
  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI), $
                                      SHIFT1=shiftM,SHIFT2=shiftI, $
                                      CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                      CB_FORCE_OOBLOW=cb_force_oobLow)

  ;; h2dStr = {tmplt_h2dStr}
  h2dStr            = tmplt_h2dStr
  h2dStr.data[*,*]  = 0
  
  nEvByAppStr       = ""
  IF KEYWORD_SET(divNEvByTotal) THEN BEGIN
     nEvByAppStr     = "_divbytotal"
     nEvByAppNiceStr = "Total Number of Orbits"
  ENDIF ELSE BEGIN
     nEvByAppStr     = ""
     nEvByAppNiceStr = "Orbit"
  ENDELSE
  h2dStr.title      = 'Number of Events per ' + nEvByAppNiceStr
  dataName          = "nEventPerOrb" + nEvByAppStr

  IF KEYWORD_SET(divNEvByTotal) THEN BEGIN
     div_i          = CGSETINTERSECTION(h2d_nonZero_allOrb_i,h2d_nonzero_nEv_i)
     divisor        = h2dTotOrbStr.data[div_i] ;Divide by all orbits passing through relevant bin
  ENDIF ELSE BEGIN
     div_i          = CGSETINTERSECTION(h2d_nonZero_contribOrbs_i,h2d_nonzero_nEv_i)
     divisor        = h2dContribOrbStr.data[div_i] ;Only divide by number of orbits that occurred during specified IMF conditions
  ENDELSE
  h2dStr.data[div_i] = h2dFluxN[div_i]/divisor
  
  IF N_ELEMENTS(nEventPerOrbRange) NE 2 THEN BEGIN
     h2dStr.lim      = [MIN(h2dStr.data[div_i]),MAX(h2dStr.data[div_i])]
  ENDIF ELSE BEGIN
     h2dStr.lim      = nEventPerOrbRange
  ENDELSE


  IF KEYWORD_SET(logNEventPerOrb) THEN BEGIN
     h2dStr.data[where(h2dStr.data GT 0,/NULL)]=ALOG10(h2dStr.data[where(h2dStr.data GT 0,/NULL)])
     h2dStr.is_logged = 1
     dataName         = "log" + dataName
     h2dStr.title     = "Log " + h2dStr.title
     h2dStr.lim       = [0,ALOG10(h2dStr.lim[1])]
  ENDIF
  
  IF KEYWORD_SET(nEventPerOrbAutoscale) THEN BEGIN
     PRINT,'Autoscaling nEventPerOrb plot...'
     h2dStr.lim       = [MIN(h2dStr.data[div_i]),MAX(h2dStr.data[div_i])]
  ENDIF

  IF KEYWORD_SET(print_mandm) THEN BEGIN
     IF ~KEYWORD_SET(logNEventPerOrb) THEN BEGIN
        fmt    = 'G10.4' 
        maxh2d = MAX(h2dStr.data[h2d_nonzero_nEv_i])
        minh2d = MIN(h2dStr.data[h2d_nonzero_nEv_i])
        medh2d = MEDIAN(h2dStr.data[h2d_nonzero_nEv_i])
     ENDIF ELSE BEGIN
        fmt    = 'F10.2'
        maxh2d = MAX(h2dStr.data[h2d_nonzero_nEv_i])
        minh2d = MIN(h2dStr.data[h2d_nonzero_nEv_i])
        medh2d = MEDIAN(h2dStr.data[h2d_nonzero_nEv_i])
     ENDELSE
     PRINTF,lun,h2dStr.title
     PRINTF,lun,FORMAT='("Max, min. med:",T20,' + fmt + ',T35,' + fmt + ',T50,' + fmt +')', $
            maxh2d, $
            minh2d, $
            medh2d            

  ENDIF

END