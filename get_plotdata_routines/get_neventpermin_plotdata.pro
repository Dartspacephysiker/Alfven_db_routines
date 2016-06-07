PRO GET_NEVENTPERMIN_PLOTDATA,THISTDENOMINATOR=tHistDenominator, $
                              MINM=minM,MAXM=maxM, $
                              BINM=binM, $
                              SHIFTM=shiftM, $
                              MINI=minI,MAXI=maxI,BINI=binI, $
                              DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                              LOGNEVENTPERMIN=logNEventPerMin, $
                              NEVENTPERMINRANGE=nEventPerMinRange, $
                              NEVENTPERMINAUTOSCALE=nEventPerMinAutoscale, $
                              H2DSTR=h2dStr, $
                              TMPLT_H2DSTR=tmplt_h2dStr, $
                              H2DFLUXN=h2dFluxN, $
                              H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                              DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                              LUN=lun
  
  COMPILE_OPT idl2

     ;h2dStr(0) is automatically the n_events histo whenever either nEventPerOrbPlot or nEventPerMinPlot keywords are set.
     ;This makes h2dStr(1) the mask histo.

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF N_ELEMENTS(print_mandm) EQ 0 THEN print_mandm = 1

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(do_lShell) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(do_lShell) ? MAXL : MAXI), $
                                      SHIFT1=shiftM,SHIFT2=shiftI)
  ;; h2dStr={tmplt_h2dStr}
  h2dStr          = tmplt_h2dStr
  h2dStr.title    = 'N Events per minute'
  dataName        = "nEventPerMin"
  h2dStr.lim      = nEventPerMinRange
  h2dStr.name     = dataName

  h2dStr.data     = h2dFluxN

  ;; h2dNonzeroNEv_i = WHERE(h2dFluxN NE 0,/NULL)
  
  ;;output from get_timehist_denominator is in seconds, but we'll do minutes
  ;; h2dStr.data[h2dNonzeroNEv_i] = h2dStr.data[h2dNonzeroNEv_i]/tHistDenominator[h2d_nonzero_nEv_i]*60.
  h2dStr.data[h2d_nonzero_nEv_i] = h2dStr.data[h2d_nonzero_nEv_i]/tHistDenominator[h2d_nonzero_nEv_i]*60.
  
  IF KEYWORD_SET(print_mandm) THEN BEGIN
     IF ~KEYWORD_SET(logNEventPerMin) THEN BEGIN
        fmt    = 'G10.4' 
        maxh2d = MAX(h2dStr.data[h2d_nonzero_nEv_i])
        minh2d = MIN(h2dStr.data[h2d_nonzero_nEv_i])
        medh2d = MEDIAN(h2dStr.data[h2d_nonzero_nEv_i])
     ENDIF ELSE BEGIN
        fmt    = 'F10.2'
        maxh2d = ALOG10(MAX(h2dStr.data[h2d_nonzero_nEv_i]))
        minh2d = ALOG10(MIN(h2dStr.data[h2d_nonzero_nEv_i]))
        medh2d = ALOG10(MEDIAN(h2dStr.data[h2d_nonzero_nEv_i]))
     ENDELSE
     PRINTF,lun,h2dStr.title
     ;; PRINTF,lun,FORMAT='("Max, min:",T20,F10.2,T35,F10.2)', $
     ;;        MAX(h2dStr.data[h2d_nonzero_nEv_i]), $
     ;;        MIN(h2dStr.data[h2d_nonzero_nEv_i])
     PRINTF,lun,FORMAT='("Max, min. med:",T20,' + fmt + ',T35,' + fmt + ',T50,' + fmt +')', $
            maxh2d, $
            minh2d, $
            medh2d            

     IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
        grossFmt      = 'G18.6'
        PRINTF,lun,FORMAT='("Gross dayside, nightside:",T30,'+ grossFmt + ',T50,' + grossFmt + ')', $
               grossDay,grossNight
     ENDIF
  ENDIF

  IF KEYWORD_SET(logNEventPerMin) THEN BEGIN
     h2dStr.is_logged = 1
     h2dStr.data[WHERE(h2dStr.data GT 0,/NULL)] = ALOG10(h2dStr.data[WHERE(h2dStr.data GT 0,/NULL)]) 
     h2dStr.title = "Log " + h2dStr.title
     h2dStr.lim = ALOG10(h2dStr.lim)
  ENDIF

  IF KEYWORD_SET(nEventPerMinAutoscale) THEN BEGIN
     h2dStr.lim = [MIN(h2dStr.data[h2d_nonzero_nEv_i]),MAX(h2dStr.data[h2d_nonzero_nEv_i])]
  ENDIF

  ;; dataRawPtr = PTR_NEW(h2dStr.data)

END


