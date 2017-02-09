;;2015/10/14
;2015/12/25 Added force_oobHigh and force_oobLow keywords
FUNCTION MAKE_H2DSTR_TMPLT,MIN1=min1in,MIN2=min2in, $
                           MAX1=max1in,MAX2=max2in, $
                           BIN1=b1in,BIN2=b2in, $
                           SHIFT1=s1in,SHIFT2=s2in, $
                           DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                           DO_PLOT_I_INSTEAD_OF_HISTOS=do_plot_i, $
                           EQUAL_AREA_BINNING=EA_binning, $
                           ;; PLOT_I=plot_i, $
                           DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                           ;; USE_LNG=use_lng, $
                           BOTH_HEMIS=both_hemis, $
                           CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                           CB_FORCE_OOBLOW=cb_force_oobLow, $
                           NCUSTOMINTEGRALS=nCustomIntegrals

  COMPILE_OPT idl2

  ;;Everyone needs 'em
  b1       = (N_ELEMENTS(b1in)   GT 0) ? b1in    : 1L
  b2       = (N_ELEMENTS(b2in)   GT 0) ? b2in    : 1L
  s1       = (N_ELEMENTS(s1in)   GT 0) ? s1in    : 0
  s2       = (N_ELEMENTS(s2in)   GT 0) ? s2in    : 0

  CASE 1 OF
     KEYWORD_SET(do_plot_i): BEGIN
        h2dDatTmplt   = LIST()
        h2dMaskTmplt  = LIST()
     END
     KEYWORD_SET(EA_binning): BEGIN
        h2dDatTmplt   = MAKE_ARRAY(672,VALUE=0.)
        h2dMaskTmplt  = h2dDatTmplt
     END
     ELSE: BEGIN
        ;;Supply default values for keywords.
        min1     = (N_ELEMENTS(min1in) GT 0) ? min1in  : (0 < im1min)
        max1     = (N_ELEMENTS(max1in) GT 0) ? max1in  : im1max
        min2     = (N_ELEMENTS(min2in) GT 0) ? min2in  : (0 < im2min)
        max2     = (N_ELEMENTS(max2in) GT 0) ? max2in  : im2max

        ;;Get # of bins for each
        im1bins  = FLOOR((max1-min1) / b1) + 1L
        im2bins  = FLOOR((max2-min2) / b2) + 1L

        if (im1bins le 0) then MESSAGE, 'Illegal bin size for V1.'
        if (im2bins le 0) then MESSAGE, 'Illegal bin size for V2.'

        h2dDatTmplt  = DBLARR(im1bins,im2bins)

        h2dMaskTmplt = DBLARR(im1bins,im2bins)
     END
  ENDCASE

  h2dStr_tmplt={data            :  h2dDatTmplt, $
                name            :  '', $
                title           :  "Template for 2D hist structure", $
                lim             :  DBLARR(2), $
                shift1          :  s1, $
                shift2          :  s2, $
                is_logged       :  0B, $
                avgType         :  '', $
                is_fluxdata     :  0B, $
                labelFormat     :  '', $
                do_midCBLabel   :  0B, $
                logLabels       :  0B, $
                do_posNeg_cb    :  0B, $
                cb_divFactor    : 1.0, $
                do_plotIntegral :  0B, $
                do_timeAvg      :  BYTE(KEYWORD_SET(do_timeAvg_fluxQuantities)), $
                do_grossRate    :  BYTE(KEYWORD_SET(do_grossRate_fluxQuantities)), $
                grossIntegrals  : {day:0.D, $
                                   night:0.D, $
                                   total:0.D, $
                                   custom:(KEYWORD_SET(nCustomIntegrals) ? MAKE_ARRAY(nCustomIntegrals,VALUE=0.D) : 0.D)}, $
                grossFac        : 1.D, $
                gUnits          :  '', $
                gAreas          : h2dDatTmplt, $
                ;; grossConvFactor : h2dDatTmplt, $
                both_hemis      : BYTE(KEYWORD_SET(both_hemis)), $
                force_oobHigh   : BYTE(KEYWORD_SET(cb_force_oobHigh)), $
                force_oobLow    : BYTE(KEYWORD_SET(cb_force_oobLow)), $
                mask            : h2dMaskTmplt, $
                hasMask         : 0B, $
                dont_mask_me    : 0B, $
                is_alfDB        : 1B, $
                is_eSpecDB      : 0B, $
                is_fastLocDB    : 0B}

  RETURN,h2dStr_tmplt

END