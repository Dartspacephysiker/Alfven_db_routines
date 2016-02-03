;;2015/10/12 Created
;;The DO_WIDTH_X keyword allows one to use spatial width of the current filaments instead of temporal, if so desired
PRO GET_PROB_OCCURRENCE_PLOTDATA,maximus,plot_i,tHistDenominator, $
                                 LOGPROBOCCURRENCE=logProbOccurrence, PROBOCCURRENCERANGE=probOccurrenceRange, $
                                 DO_WIDTH_X=do_width_x, $
                                 MINM=minM,MAXM=maxM, $
                                 BINM=binM, $
                                 SHIFTM=shiftM, $
                                 MINI=minI,MAXI=maxI,BINI=binI, $
                                 DO_LSHELL=do_lShell, MINL=minL,MAXL=maxL,BINL=binL, $
                                 OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                                 H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                                 H2DSTR=h2dStr, $
                                 H2DFLUXN=h2dFluxN, $
                                 TMPLT_H2DSTR=tmplt_h2dStr, $
                                 DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                                 PRINT_MAX_AND_MIN=print_mandm, $
                                 LUN=lun


  COMPILE_OPT idl2
  
  @orbplot_tplot_defaults.pro

  OPENW,lun,'/SPENCEdata/Research/Cusp/ACE_FAST/20160130--Alfven_cusp_figure_of_merit/Output_for_SOUTH_proboccurrence.txt',/APPEND,/GET_LUN

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1
  IF N_ELEMENTS(print_mandm) EQ 0 THEN print_mandm = 1

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                                      MIN1=minM,MIN2=(KEYWORD_SET(do_lShell) ? minL : minI),$
                                      MAX1=maxM,MAX2=(KEYWORD_SET(do_lShell) ? maxL : maxI), $
                                      SHIFT1=shiftM,SHIFT2=shiftI)

  ;; h2dStr                     = {tmplt_h2dStr}
  h2dStr                     = tmplt_h2dStr
  h2dStr.title               = "Probability of occurrence"
  h2dStr.lim                 = probOccurrenceRange

  h2dStr.labelFormat         = defProbOccurrenceCBLabelFormat
  h2dStr.logLabels           = defProbOccurrenceLogLabels

  h2dStr.do_plotIntegral     = defProbOccurrence_doPlotIntegral
  h2dStr.do_midCBLabel       = defProbOccurrence_do_midCBLabel
  dataName                   = "probOccurrence"
  
  h2dStr.force_oobHigh       = 0

  IF KEYWORD_SET(do_width_x) THEN BEGIN
     widthData = maximus.width_x[plot_i]
     dataName  = "probOccurrence_width_x"
  ENDIF ELSE BEGIN
     widthData = maximus.width_time[plot_i]
  ENDELSE

  ;;fix MLTs
  mlts                           = maximus.mlt[plot_i]-shiftM 
  mlts[WHERE(mlts LT 0.)]        = mlts[WHERE(mlts LT 0.)] + 24.

  h2dStr.data=hist2d(mlts, $
                     (KEYWORD_SET(do_lshell) ? maximus.lshell : maximus.ilat)[plot_i],$
                      widthData,$
                      MIN1=minM,MIN2=(KEYWORD_SET(do_lshell) ? minL : minI),$
                      MAX1=maxM,MAX2=(KEYWORD_SET(do_lshell) ? maxL : maxI),$
                      BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                      OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
  
  ;;make sure this makes any sense
  this   = WHERE( h2dstr.data EQ 0 )
  that   = WHERE( thistdenominator EQ 0 )
  nBad   = 0
  iBad   = !NULL
  FOR i=0,N_ELEMENTS(that)-1 DO BEGIN
     test                             = WHERE( that[i] EQ this )
     IF test[0] EQ -1 THEN BEGIN
        iBad                          = [iBad,that[i]]
        nBad++
     ENDIF
  ENDFOR
  IF nBad GT 0 THEN BEGIN
     nMLTs                            = N_ELEMENTS(outH2DBinsMLT)
     PRINTF,lun,STRCOMPRESS(nBad,/REMOVE_ALL) + " instances in the widthData histo where there are supposedly events, but the ephemeris data reports fast was never there!"
     PRINTF,lun,"Absurdity"
     threshold                       = 0.15           ;seconds
     PRINTF,lun,FORMAT='("Index",T10,"MLT",T20,"ILAT",T30,"Width_tval",T45,"N contr. events")'
     FOR i=0,nBad-1 DO BEGIN
        ind                           = iBad[i]
        PRINTF,lun,FORMAT='(I0,T10,F0.2,T20,F0.2,T30,F0.3,T45,I0)',ind,outH2DBinsMLT[ind MOD nMLTs],outH2DBinsILAT[ind / nMLTs],h2dStr.data[ind],h2dFluxN[ind]
        ;; IF h2dstr.data[ind] LT threshold THEN BEGIN
        ;;    PRINTF,lun,,'-->Below threshold (' + STRCOMPRESS(threshold,/REMOVE_ALL) + '); setting this width_time to zero ...'
        ;;    h2dstr.data[ind]           = 0
        ;; ENDIF
        PRINTF,lun,'Setting this width_time to zero ...'
        h2dstr.data[ind]              = 0
        tHistDenominator[ind]         = 999999.
     ENDFOR
     PRINTF,lun,""
     ;; STOP
  ENDIF

  h2dStr.data[WHERE(h2dstr.data GT 0)] = h2dStr.data[WHERE(h2dstr.data GT 0)]/tHistDenominator[WHERE(h2dstr.data GT 0)]

  IF KEYWORD_SET(logProbOccurrence) THEN BEGIN 
     h2dStr.is_logged = 1
     h2dStr.data[where(h2dStr.data GT 0,/NULL)]=ALOG10(h2dStr.data[WHERE(h2dStr.data GT 0,/null)]) 
     widthData[where(widthData GT 0,/null)]=ALOG10(widthData[WHERE(widthData GT 0,/null)]) 
     h2dStr.title =  'Log ' + h2dStr.title
     h2dStr.lim = ALOG10(h2dStr.lim)
  ENDIF

  IF KEYWORD_SET(print_mandm) THEN BEGIN
     PRINTF,lun,h2dStr.title
     PRINTF,lun,FORMAT='("Max, min:",T20,F10.2,T35,F10.2)',MAX(h2dStr.data[h2d_nonzero_nEv_i]),MIN(h2dStr.data[h2d_nonzero_nEv_i])
  ENDIF

  dataRawPtr = PTR_NEW(widthData)
  
  CLOSE,lun
  FREE_LUN,lun

END