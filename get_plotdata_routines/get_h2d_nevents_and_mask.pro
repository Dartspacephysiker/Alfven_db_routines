;;2016/04/05 Added IN_{MLTS,ILATS} to make it possible to circumvent maximus and plot_i
PRO GET_H2D_NEVENTS_AND_MASK,maximus,plot_i, $
                             IN_MLTS=in_mlts, $
                             IN_ILATS=in_ilats, $
                             ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                             IMF_STRUCT=IMF_struct, $
                             MIMC_STRUCT=MIMC_struct, $
                             NEVENTSPLOTRANGE=nEventsPlotRange, $
                             NEVENTSPLOT__NOMASK=nEventsPlot__noMask, $
                             TMPLT_H2DSTR=tmplt_h2dStr, $
                             H2DSTR=h2dStr,H2DMASKSTR=h2dMaskStr, $
                             H2DFLUXN=h2dFluxN,H2D_NONZERO_NEV_I=hEv_nz_i, $
                             MASKMIN=maskMin, $
                             DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                             CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                             CB_FORCE_OOBLOW=cb_force_oobLow, $
                             PRINT_MANDM=print_mAndM, $
                             LUN=lun

  COMPILE_OPT idl2,strictarrsubs

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  IF N_ELEMENTS(print_mAndM) EQ 0 THEN print_mAndM = 1

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN BEGIN
     tmplt_h2dStr       = MAKE_H2DSTR_TMPLT( $
                          BIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.binLng : MIMC_struct.binM), $
                          BIN2=(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.binL : MIMC_struct.binI),$
                          MIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.minLng : MIMC_struct.minM), $
                          MIN2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.minL : MIMC_struct.minI),$
                          MAX1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.maxLng : MIMC_struct.maxM), $
                          MAX2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.maxL : MIMC_struct.maxI), $
                          SHIFT1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.shiftLng : MIMC_struct.shiftM), $
                          SHIFT2=shiftI, $
                          EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning, $
                          CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                          CB_FORCE_OOBLOW=cb_force_oobLow)
     
  ENDIF

  h2dStr                = tmplt_h2dStr
  h2dStr.title          = "Number of events"
  h2dStr.labelFormat    = '(I0)'
  h2dStr.DO_midCBLabel  = 1
  dataName              = "nEvents"
  h2dStr.name           = dataName
  h2dStr.dont_mask_me   = KEYWORD_SET(nEventsPlot__noMask)

  h2dMaskStr            = tmplt_h2dStr
  h2dMaskStr.title      = "Histogram mask"
  h2dMaskStr.name       = "histoMask"

  ;;########Flux_N and Mask########
  ;;First, histo to show where events are
  ;; h2dFluxN           = HIST_2D(maximus.mlt[plot_i],$
  CASE 1 OF
     KEYWORD_SET(MIMC_struct.use_Lng): BEGIN
        mlts             = (KEYWORD_SET(in_MLTS) ? in_MLTs : maximus.lng[plot_i])-MIMC_struct.shiftLng 
        swapme           = WHERE(mlts LT 0,nSwap)
        IF nSwap GT 0 THEN BEGIN
           mlts[swapme]  = mlts[swapme] + 360.
        ENDIF
     END
     ELSE: BEGIN
        mlts             = (KEYWORD_SET(in_MLTS) ? in_MLTs : maximus.mlt[plot_i])-MIMC_struct.shiftM ;shift MLTs backwards, because we want to shift the binning FORWARD
        swapme           = WHERE(mlts LT 0,nSwap)
        IF nSwap GT 0 THEN BEGIN
           mlts[swapme]  = mlts[swapme] + 24
        ENDIF
     END
  ENDCASE
  horiz                  = KEYWORD_SET(in_ILATs) ? in_ILATs : ( (KEYWORD_SET(MIMC_struct.do_lShell) ? maximus.lshell : maximus.ilat)[plot_i] )

  IF KEYWORD_SET(h2dStr.both_hemis) THEN horiz = ABS(horiz)

  IF KEYWORD_SET(alfDB_plot_struct.EA_binning) THEN BEGIN
     h2dFluxN       = HIST2D__EQUAL_AREA_BINNING(mlts,$
                                                 horiz,$
                                                 ;; BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                                                 MIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.minLng : MIMC_struct.minM), $
                                                 MIN2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.minL : MIMC_struct.minI),$
                                                 MAX1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.maxLng : MIMC_struct.maxM), $
                                                 MAX2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.maxL : MIMC_struct.maxI))
  ENDIF ELSE BEGIN
     h2dFluxN       = HIST_2D(mlts,$
                              horiz,$
                              BIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.binLng : MIMC_struct.binM), $
                              BIN2=(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.binL : MIMC_struct.binI),$
                              MIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.minLng : MIMC_struct.minM), $
                              MIN2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.minL : MIMC_struct.minI),$
                              MAX1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.maxLng : MIMC_struct.maxM), $
                              MAX2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.maxL : MIMC_struct.maxI))
  ENDELSE 

  h2dStr.data       = h2dFluxN
  h2dStr.lim        = KEYWORD_SET(nEventsPlotRange) AND N_ELEMENTS(nEventsPlotRange) EQ 2 ? $
                      DOUBLE(nEventsPlotRange) : $
                      DOUBLE([MIN(h2dFluxN),MAX(h2dFluxN)]) 
  h2dStr.logLabels  = 1
  dataRawPtr        = PTR_NEW(h2dFluxN) 

  ;;Make a mask for plots so that we can show where no data exists
  h2dMaskStr.data   = h2dFluxN
  h2dMaskStr.data[where(h2dStr.data LT alfDB_plot_struct.maskMin,/NULL)] = 255
  h2dMaskStr.data[where(h2dStr.data GE alfDB_plot_struct.maskMin,/NULL)] = 0

  hEv_nz_i             = WHERE(h2dFluxN GT 0)
  IF hEv_nz_i[0] EQ -1 THEN BEGIN
     PRINT,"Ummm.... There's no data here, according to GET_H2D_NEVENTS_AND_MASK."
     STOP
  ENDIF
  
  IF KEYWORD_SET(print_mandm) THEN BEGIN
     ;; IF KEYWORD_SET(medianPlot) OR ~KEYWORD_SET(logAvgPlot) THEN BEGIN
        fmt                     = 'G10.4' 
        maxh2d                  = MAX(h2dStr.data[hEv_nz_i])
        minh2d                  = MIN(h2dStr.data[hEv_nz_i])
     ;; ENDIF ELSE BEGIN
     ;;    fmt    = 'F10.2'
     ;;    maxh2d = ALOG10(MAX(h2dStr.data[hEv_nz_i]))
     ;;    minh2d = ALOG10(MIN(h2dStr.data[hEv_nz_i]))
     ;; ENDELSE
     PRINTF,lun,h2dStr.title
     PRINTF,lun,FORMAT='("Max, min:",T20,' + fmt + ',T35,' + fmt + ')', $
            maxh2d, $
            minh2d
  ENDIF


END