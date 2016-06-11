;;2016/04/05 Added IN_{MLTS,ILATS} to make it possible to circumvent eSpec and eSpec_i
PRO GET_H2D_NEWELL_AND_MASK,eSpec,eSpec_i, $
                            TITLE=title, $
                            IN_MLTS=in_mlts, $
                            IN_ILATS=in_ilats, $
                            MINM=minM,MAXM=maxM, $
                            BINM=binM, $
                            SHIFTM=shiftM, $
                            MINI=minI,MAXI=maxI,BINI=binI, $
                            DO_LSHELL=do_lShell, MINL=minL,MAXL=maxL,BINL=binL, $
                            NEWELL_PLOTRANGE=newell_plotRange, $
                            LOG_NEWELLPLOT=log_newellPlot, $
                            NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
                            NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
                            NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
                            TMPLT_H2DSTR=tmplt_h2dStr, $
                            H2DSTR=h2dStr, $
                            ;; H2DMASKSTR=h2dMaskStr, $
                            H2DFLUXN=h2dFluxN, $
                            NEWELL_NONZERO_NEV_I=newell_nonzero_nEv_i, $
                            ;; MASKMIN=maskMin, $
                            DATANAME=dataName, $
                            DATARAWPTR=dataRawPtr, $
                            CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                            CB_FORCE_OOBLOW=cb_force_oobLow, $
                            PRINT_MANDM=print_mAndM, $
                            LUN=lun

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun  = -1 ;stdout

  IF N_ELEMENTS(print_mAndM) EQ 0 THEN BEGIN
     print_mAndM                    = 1
  ENDIF

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN BEGIN
     tmplt_h2dStr                   = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                                                        MIN1=minM,MIN2=(KEYWORD_SET(DO_LSHELL) ? minL : minI),$
                                                        MAX1=maxM,MAX2=(KEYWORD_SET(DO_LSHELL) ? maxL : maxI), $
                                                        SHIFT1=shiftM,SHIFT2=shiftI, $
                                                        CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                                        CB_FORCE_OOBLOW=cb_force_oobLow)
     
  ENDIF

  h2dStr                            = tmplt_h2dStr
  h2dStr.title                      = title
  h2dStr.labelFormat                = '(I0)'
  h2dStr.do_midCBLabel              = 1
  h2dStr.name                       = dataName
  h2dStr.dont_mask_me               = 1
  ;; h2dMaskStr                        = tmplt_h2dStr

  ;;########Flux_N########
  ;;First, histo to show where events are
  ;;shift MLTs backwards, because we want to shift the binning FORWARD
  mlts                              = KEYWORD_SET(in_MLTS) ? in_MLTs : eSpec.mlt[eSpec_i]-shiftM
  mlts[WHERE(mlts LT 0)]            = mlts[WHERE(mlts LT 0)] + 24
  horiz                             = KEYWORD_SET(in_ILATs) ? in_ILATs : eSpec.ilat[eSpec_i]

  h2dFluxN                          = HIST_2D(mlts,$
                                              horiz,$
                                              BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                                              MIN1=minM,MIN2=(KEYWORD_SET(DO_LSHELL) ? minL : minI),$
                                              MAX1=maxM,MAX2=(KEYWORD_SET(DO_LSHELL) ? maxL : maxI))
  
  h2dStr.data                       = h2dFluxN
  h2dStr.lim                        = KEYWORD_SET(newell_plotRange) AND N_ELEMENTS(newell_plotRange) EQ 2 ? $
                                      DOUBLE(newell_plotRange) : $
                                      DOUBLE([MIN(h2dFluxN),MAX(h2dFluxN)]) 
  h2dStr.logLabels                  = 1
  dataRawPtr                        = PTR_NEW(h2dFluxN) 

  ;;Make a mask for plots so that we can show where no data exists
  ;; h2dMaskStr.data                   = h2dFluxN
  ;; h2dMaskStr.data[where(h2dStr.data LT maskMin,/NULL)]=255
  ;; h2dMaskStr.data[where(h2dStr.data GE maskMin,/NULL)]=0

  newell_nonzero_nEv_i             = WHERE(h2dFluxN GT 0)
  IF newell_nonzero_nEv_i[0] EQ -1 THEN BEGIN
     PRINT,"Ummm.... There's no data here, according to GET_H2D_NEWELL."
     STOP
  ENDIF
  
  ;; CASE 1 OF
  ;;    KEYWORD_SET(newellPlot_probOccurrence): BEGIN
  ;;       dataName         = dataName + "_probOcc"
  ;;       h2dStr.title     = h2dStr.title + " (Prob. Occ.)"
  ;;       h2dStr.name      = dataname
  ;;       ;;Logging, etc happens outside of this routine
  ;;       IF KEYWORD_SET(newellPlot_normalize) OR $
  ;;          KEYWORD_SET(newellPlot_autoscale) THEN BEGIN
  ;;          PRINT,"Can't do normalization or autoscale when also doing probOccurrence!"
  ;;       ENDIF
  ;;       IF KEYWORD_SET(newellPlot_normalize) OR $
  ;;          KEYWORD_SET(newellPlot_autoscale) THEN BEGIN
  ;;          PRINT,"Normalization is a strangeness when also doing probOccurrence!"
  ;;       ENDIF
  ;;    END
  ;;    ELSE: BEGIN
  ;;       IF KEYWORD_SET(log_newellPlot) THEN BEGIN
  ;;          dataName         = 'log_' + dataName
  ;;          h2dStr.data[newell_nonzero_nEv_i] = ALOG10(h2dStr.data[newell_nonzero_nEv_i])
  ;;          h2dStr.lim       = [(h2dStr.lim[0] LT 1) ? 0 : ALOG10(h2dStr.lim[0]),ALOG10(h2dStr.lim[1])] ;lower bound must be one
  ;;          h2dStr.title     = 'Log ' + h2dStr.title
  ;;          h2dStr.name      = dataName
  ;;          h2dStr.is_logged = 1
  ;;       ENDIF
  ;;       IF KEYWORD_SET(newellPlot_normalize) THEN BEGIN
  ;;          dataName        += '_normed'
  ;;          maxNEv                 = MAX(h2dStr.data[newell_nonzero_nEv_i])
  ;;          h2dStr.data      = h2dStr.data/maxNEv
  ;;          h2dStr.lim       = [0.0,1.0]
  ;;          h2dStr.title    += STRING(FORMAT='(" (norm: ",G0.3,")")',maxNEv)
  ;;          h2dStr.name      = dataName
  ;;       ENDIF
  ;;       IF KEYWORD_SET(newellPlot_autoscale) THEN BEGIN
  ;;          PRINT,"Autoscaling nEvents plot..."
  ;;          h2dStr.lim       = [MIN(h2dStr.data[newell_nonzero_nEv_i]), $
  ;;                              MAX(h2dStr.data[newell_nonzero_nEv_i])]
  ;;       ENDIF
  ;;    END
  ;; ENDCASE


END