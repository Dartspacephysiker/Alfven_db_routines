;;2015/10/12 Created
;;2016/02/20 Added DO_TIMEAVGD_PFLUX keyword to get, well, time-averaged Poynting flux!
;;The DO_WIDTH_X keyword allows one to use spatial width of the current filaments instead of temporal, if so desired
PRO GET_PROB_OCCURRENCE_PLOTDATA,maximus,plot_i,tHistDenominator, $
                                 LOGPROBOCCURRENCE=logProbOccurrence, $
                                 PROBOCCURRENCERANGE=probOccurrenceRange, $
                                 PROBOCCURRENCEAUTOSCALE=probOccurrenceAutoscale, $
                                 DO_WIDTH_X=do_width_x, $
                                 DO_TIMEAVGD_PFLUX=do_timeAvgd_pflux, $
                                 LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
                                 TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
                                 DO_TIMEAVGD_EFLUXMAX=do_timeAvgd_eFluxMax, $
                                 LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
                                 TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
                                 MINM=minM,MAXM=maxM, $
                                 BINM=binM, $
                                 SHIFTM=shiftM, $
                                 MINI=minI,MAXI=maxI,BINI=binI, $
                                 DO_LSHELL=do_lShell, MINL=minL,MAXL=maxL,BINL=binL, $
                                 OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                                 H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                                 H2DSTR=h2dStr, $
                                 H2DFLUXN=h2dFluxN, $
                                 H2DMASK=h2dMask, $
                                 OUT_H2DMASK=out_h2DMask, $
                                 TMPLT_H2DSTR=tmplt_h2dStr, $
                                 DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                                 PRINT_MAX_AND_MIN=print_mandm, $
                                 LUN=lun


  COMPILE_OPT idl2
  
  @orbplot_tplot_defaults.pro

  ;; OPENW,lun,'/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/20160130--Alfven_cusp_figure_of_merit/Output_for_SOUTH_proboccurrence.txt',/APPEND,/GET_LUN

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1
  IF N_ELEMENTS(print_mandm) EQ 0 THEN print_mandm = 1

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                                      MIN1=minM,MIN2=(KEYWORD_SET(do_lShell) ? minL : minI),$
                                      MAX1=maxM,MAX2=(KEYWORD_SET(do_lShell) ? maxL : maxI), $
                                      SHIFT1=shiftM,SHIFT2=shiftI)

  h2dStr                     = tmplt_h2dStr
  
  ;; h2dStr.force_oobHigh       = 0

  CASE 1 OF 
     KEYWORD_SET(do_width_x): BEGIN
        widthData                  = maximus.width_x[plot_i]
        dataName                   = "probOccurrence_width_x"
        h2dStr.title               = "Event width/Time in bin (m/s)"  ;;but what even is this quantity, bro?
     END                           
     KEYWORD_SET(do_timeavgd_pflux): BEGIN
        widthData                  = maximus.width_time[plot_i]*maximus.pFluxEst[plot_i]
        dataName                   = name__timeAvgd_pFlux
        h2dStr.title               = title__timeAvgd_pFlux
        h2dStr.lim                 = timeAvgd_pFluxRange
        
        h2dStr.labelFormat         = defTimeAvgd_PFluxCBLabelFormat

        h2dStr.logLabels           = defTimeAvgd_PFluxLogLabels
        logged                     = KEYWORD_SET(logTimeAvgd_PFlux)
        
        h2dStr.do_plotIntegral     = defTimeAvgd_PFlux_doPlotIntegral
        h2dStr.do_midCBLabel       = defTimeAvgd_PFlux_do_midCBLabel
     END                           
     KEYWORD_SET(do_timeAvgd_eFluxMax): BEGIN
        widthData                  = maximus.width_time[plot_i]*maximus.elec_energy_flux[plot_i]
        dataName                   = name__timeAvgd_eFluxMax
        h2dStr.title               = title__timeAvgd_eFluxMax
        h2dStr.lim                 = timeAvgd_eFluxMaxRange
        
        h2dStr.labelFormat         = defTimeAvgd_EFluxMaxCBLabelFormat

        h2dStr.logLabels           = defTimeAvgd_EFluxMaxLogLabels
        logged                     = KEYWORD_SET(logTimeAvgd_EFluxMax)
        
        h2dStr.do_plotIntegral     = defTimeAvgd_EFluxMax_doPlotIntegral
        h2dStr.do_midCBLabel       = defTimeAvgd_EFluxMax_do_midCBLabel
     END
     ELSE: BEGIN                   
        widthData                  = maximus.width_time[plot_i]
        dataName                   = name__probOccurrence
        h2dStr.title               = title__probOccurrence

        h2dStr.lim                 = probOccurrenceRange
        
        h2dStr.labelFormat         = defProbOccurrenceCBLabelFormat

        h2dStr.logLabels           = defProbOccurrenceLogLabels
        logged                     = KEYWORD_SET(logProbOccurrence)
        
        h2dStr.do_plotIntegral     = defProbOccurrence_doPlotIntegral
        h2dStr.do_midCBLabel       = defProbOccurrence_do_midCBLabel

        ;;Temporary
        ;; h2dStr.force_oobHigh       = 0
     END
     KEYWORD_SET(in_fluxStruct): BEGIN
        widthData                  = in_fluxQuantity[plot_i]
        
        ;;All of these other variables should have been handled in GET_FLUX_PLOTDATA
        ;; dataName                   = name__probOccurrence
        ;; h2dStr.title               = title__probOccurrence

        ;; h2dStr.lim                 = probOccurrenceRange
        
        ;; h2dStr.labelFormat         = defProbOccurrenceCBLabelFormat

        ;; h2dStr.logLabels           = defProbOccurrenceLogLabels
        ;; logged                     = KEYWORD_SET(logProbOccurrence)
        
        ;; h2dStr.do_plotIntegral     = defProbOccurrence_doPlotIntegral
        ;; h2dStr.do_midCBLabel       = defProbOccurrence_do_midCBLabel
     END
  ENDCASE

  ;;fix MLTs
  mlts                      = SHIFT_MLTS_FOR_H2D(maximus,plot_i,shiftM)
  ilats                     = (KEYWORD_SET(do_lshell) ? maximus.lshell : maximus.ilat)[plot_i]

  h2dStr.data=hist2d(mlts, $
                     ilats,$
                      widthData,$
                      MIN1=minM,MIN2=(KEYWORD_SET(do_lshell) ? minL : minI),$
                      MAX1=maxM,MAX2=(KEYWORD_SET(do_lshell) ? maxL : maxI),$
                      BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                      OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
  

  PROBOCCURRENCE_AND_TIMEAVG_SANITY_CHECK,h2dStr,tHistDenominator,outH2DBinsMLT,outH2DBinsILAT,H2DFluxN,dataName,h2dMask

  ;; h2dStr.data[WHERE(h2dstr.data GT 0)] = h2dStr.data[WHERE(h2dstr.data GT 0)]/tHistDenominator[WHERE(h2dstr.data GT 0)]
  h2dStr.data[WHERE(~h2dMask)] = h2dStr.data[WHERE(~h2dMask)]/tHistDenominator[WHERE(~h2dMask)]

  IF KEYWORD_SET(logged) THEN BEGIN 
     h2dStr.data[WHERE(h2dStr.data GT 0,/NULL)]=ALOG10(h2dStr.data[WHERE(h2dStr.data GT 0,/NULL)]) 
     widthData[WHERE(widthData GT 0,/NULL)]=ALOG10(widthData[WHERE(widthData GT 0,/NULL)]) 
     ;; h2dStr.title =  'Log ' + h2dStr.title
     h2dStr.lim = ALOG10(h2dStr.lim)
     h2dStr.is_logged = 1
  ENDIF

  IF KEYWORD_SET(probOccurrenceAutoscale) THEN BEGIN
     PRINTF,lun,'Autoscaling probOccurrence...'
     h2dStr.lim       = [MIN(h2dStr.data[WHERE(~h2dMask)]), $
                         MAX(h2dStr.data[WHERE(~h2dMask)])]
  ENDIF

  IF KEYWORD_SET(print_mandm) THEN BEGIN
     PRINTF,lun,h2dStr.title
     ;; PRINTF,lun,FORMAT='("Max, min:",T20,F10.2,T35,F10.2)',MAX(h2dStr.data[h2d_nonzero_nEv_i]),MIN(h2dStr.data[h2d_nonzero_nEv_i])
     PRINTF,lun,FORMAT='("Max, min, med:",T20,F10.2,T35,F10.2,T50,F10.2)', $
            MAX(h2dStr.data[WHERE(~h2dMask)]), $
            MIN(h2dStr.data[WHERE(~h2dMask)]), $
            MEDIAN(h2dStr.data[WHERE(~h2dMask)])
  ENDIF

  dataRawPtr           = PTR_NEW(widthData)
  h2dStr.name          = dataName
  out_h2dMask          = h2dMask
  ;; CLOSE,lun
  ;; FREE_LUN,lun

END