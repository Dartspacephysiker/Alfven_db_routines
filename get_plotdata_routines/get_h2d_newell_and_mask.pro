;;2016/04/05 Added IN_{MLTS,ILATS} to make it possible to circumvent eSpec and eSpec_i
PRO GET_H2D_NEWELL_AND_MASK,eSpec,eSpec_i, $
                            TITLE=title, $
                            IN_MLTS=in_mlts, $
                            IN_ILATS=in_ilats, $
                            ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                            IMF_STRUCT=IMF_struct, $
                            MIMC_STRUCT=MIMC_struct, $
                            NEWELL_PLOTRANGE=newell_plotRange, $
                            LOG_NEWELLPLOT=log_newellPlot, $
                            NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
                            NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
                            NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
                            TMPLT_H2DSTR=tmplt_h2dStr, $
                            H2DSTR=h2dStr, $
                            H2DFLUXN=h2dFluxN, $
                            NEWELL_NONZERO_NEV_I=newell_nonzero_nEv_i, $
                            DATANAME=dataName, $
                            DATARAWPTR=dataRawPtr, $
                            CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                            CB_FORCE_OOBLOW=cb_force_oobLow, $
                            PRINT_MANDM=print_mAndM, $
                            LUN=lun

  COMPILE_OPT idl2,strictarrsubs

  IF N_ELEMENTS(lun) EQ 0 THEN lun  = -1 ;stdout

  IF N_ELEMENTS(print_mAndM) EQ 0 THEN BEGIN
     print_mAndM                    = 1
  ENDIF

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN BEGIN
     tmplt_h2dStr                   = MAKE_H2DSTR_TMPLT(BIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.binLng : MIMC_struct.binM), $
                                                        BIN2=(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.binL : MIMC_struct.binI),$
                                                        MIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.minLng : MIMC_struct.minM), $
                                                        MIN2=(KEYWORD_SET(MIMC_struct.DO_LSHELL) ? MIMC_struct.minL : MIMC_struct.minI),$
                                                        MAX1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.maxLng : MIMC_struct.maxM), $
                                                        MAX2=(KEYWORD_SET(MIMC_struct.DO_LSHELL) ? MIMC_struct.maxL : MIMC_struct.maxI), $
                                                        SHIFT1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.shiftLng : MIMC_struct.shiftM),SHIFT2=shiftI, $
                                                        EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning, $
                                                        CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                                        CB_FORCE_OOBLOW=cb_force_oobLow)
     
  ENDIF

  h2dStr                = tmplt_h2dStr
  h2dStr.title          = title
  h2dStr.labelFormat    = '(I0)'
  h2dStr.do_midCBLabel  = 1
  h2dStr.name           = dataName
  h2dStr.dont_mask_me   = 1
  ;; h2dMaskStr                        = tmplt_h2dStr

  ;;########Flux_N########
  ;;First, histo to show where events are
  ;;shift MLTs backwards, because we want to shift the binning FORWARD
  mlts                    = KEYWORD_SET(in_MLTS) ? in_MLTs : (KEYWORD_SET(MIMC_struct.use_Lng) ? eSpec.lng[eSpec_i] - MIMC_struct.shiftLng : $
                                                              eSpec.mlt[eSpec_i]-MIMC_struct.shiftM)
  IF ~KEYWORD_SET(MIMC_struct.use_Lng) THEN BEGIN
     mlts[WHERE(mlts LT 0)]  = mlts[WHERE(mlts LT 0)] + 24
  ENDIF
  horiz                   = KEYWORD_SET(in_ILATs) ? in_ILATs : eSpec.ilat[eSpec_i]

  IF KEYWORD_SET(h2dStr.both_hemis) THEN horiz = ABS(horiz)

  CASE 1 OF
     KEYWORD_SET(alfDB_plot_struct.EA_binning): BEGIN
        h2dFluxN       = HIST2D__EQUAL_AREA_BINNING(mlts,$
                                                    horiz,$
                                                    MIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.minLng : MIMC_struct.minM), $
                                                    MIN2=(KEYWORD_SET(MIMC_struct.DO_LSHELL) ? MIMC_struct.minL : MIMC_struct.minI),$
                                                    MAX1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.maxLng : MIMC_struct.maxM), $
                                                    MAX2=(KEYWORD_SET(MIMC_struct.DO_LSHELL) ? MIMC_struct.maxL : MIMC_struct.maxI))

     END
     ELSE: BEGIN
        h2dFluxN       = HIST_2D(mlts,$
                                 horiz,$
                                 BIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.binLng : MIMC_struct.binM), $
                                 BIN2=(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.binL : MIMC_struct.binI),$
                                 MIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.minLng : MIMC_struct.minM), $
                                 MIN2=(KEYWORD_SET(MIMC_struct.DO_LSHELL) ? MIMC_struct.minL : MIMC_struct.minI),$
                                 MAX1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.maxLng : MIMC_struct.maxM), $
                                 MAX2=(KEYWORD_SET(MIMC_struct.DO_LSHELL) ? MIMC_struct.maxL : MIMC_struct.maxI))
     END
  ENDCASE
  
  h2dStr.data          = h2dFluxN

  pR_dimSize           = SIZE(newell_plotRange,/DIMENSIONS)
  CASE NDIMEN(newell_plotRange) OF
     -1: BEGIN
        h2dStr.lim     = DOUBLE([MIN(h2dFluxN),MAX(h2dFluxN)])
     END
     0: BEGIN
        h2dStr.lim     = DOUBLE([MIN(h2dFluxN),MAX(h2dFluxN)])
     END
     1: BEGIN
        IF pR_dimSize[0] EQ 2 THEN BEGIN
           h2dStr.lim  = newell_plotRange
        ENDIF ELSE BEGIN
           h2dStr.lim  = DOUBLE([MIN(h2dFluxN),MAX(h2dFluxN)])
        ENDELSE
     END
     2: BEGIN
        ;; IF (pR_dimSize[0] EQ 2) AND (pR_dimSize[1] EQ 3) THEN BEGIN
        ;;    h2dStr.lim         = newell_plotRange[*,i]
        ;; ENDIF ELSE BEGIN
        ;;    h2dStr.lim         = DOUBLE([MIN(h2dFluxN),MAX(h2dFluxN)])
        ;; ENDELSE
     END
  ENDCASE
  h2dStr.logLabels      = 1
  dataRawPtr            = PTR_NEW(h2dFluxN) 

  newell_nonzero_nEv_i  = WHERE(h2dFluxN GT 0)
  IF newell_nonzero_nEv_i[0] EQ -1 THEN BEGIN
     PRINT,"Ummm.... There's no data here, according to GET_H2D_NEWELL_AND_MASK."
     STOP
  ENDIF

END