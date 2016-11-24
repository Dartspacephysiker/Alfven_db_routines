;2016/06/02
PRO GET_H2D_NEWELLS__EACH_TYPE,eSpec,plot_i, $
                               MINM=minM,MAXM=maxM, $
                               BINM=binM, $
                               SHIFTM=shiftM, $
                               MINI=minI,MAXI=maxI,BINI=binI, $
                               EQUAL_AREA_BINNING=EA_binning, $
                               NEWELL_PLOTRANGE=newell_plotRange, $
                               LOG_NEWELLPLOT=log_newellPlot, $
                               NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
                               NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
                               NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
                               NONALFVEN__NO_MAXIMUS=no_maximus, $
                               ;; NONALFVEN__ALL_FLUXES=nonalfven__all_fluxes, $
                               INDICES__NONALFVEN_ESPEC=indices__nonAlfven_eSpec, $
                               TMPLT_H2DSTR=tmplt_h2dStr, $
                               H2DSTRS=h2dStrs, $
                               ;; H2DMASKSTR=h2dMaskStr, $
                               H2DFLUXN=h2dFluxN, $
                               NEWELL_NONZERO_NEV_I=newell_nonzero_nEv_i, $
                               ;; MASKMIN=maskMin, $
                               DATANAMES=dataNames, $
                               DATARAWPTRS=dataRawPtrs, $
                               CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                               CB_FORCE_OOBLOW=cb_force_oobLow, $
                               PRINT_MANDM=print_mAndM, $
                               LUN=lun


  COMPILE_OPT idl2

  ;;This common block is defined ONLY here, in GET_ESPEC_ION_DB_IND, and in LOAD_ALF_NEWELL_ESPEC_DB
  @common__newell_alf.pro
  
  @common__maximus_vars.pro
  ;; COMMON M_VARS

  IF ~KEYWORD_SET(no_maximus) THEN BEGIN
     despun       = MAXIMUS__despun
  ENDIF

  ;; LOAD_MAXIMUS_AND_CDBTIME,!NULL,!NULL,DO_DESPUNDB=despun,/CHECK_DB,/QUIET

  IF ~KEYWORD_SET(no_maximus) THEN BEGIN
     IF N_ELEMENTS(NWLL_ALF__eSpec) EQ 0 OR N_ELEMENTS(NWLL_ALF__good_alf_i) EQ 0 THEN BEGIN
        LOAD_ALF_NEWELL_ESPEC_DB,espec,good_alf_i,DESPUN_ALF_DB=despun
     ENDIF ELSE BEGIN
        eSpec            = NWLL_ALF__eSpec
        good_eSpec_i     = NWLL_ALF__good_eSpec_i
        good_alf_i       = NWLL_ALF__good_alf_i
     ENDELSE

     plot_i__good_espec  = CGSETINTERSECTION(plot_i,good_alf_i,INDICES_B=temp_eSpec_indices)

     tmp_eSpec  = { x:eSpec.x[temp_eSpec_indices], $
                             orbit:eSpec.orbit[temp_eSpec_indices], $
                             MLT:eSpec.mlt[temp_eSpec_indices], $
                             ILAT:eSpec.ilat[temp_eSpec_indices], $
                             ALT:eSpec.alt[temp_eSpec_indices], $
                             mono:eSpec.mono[temp_eSpec_indices], $
                             broad:eSpec.broad[temp_eSpec_indices], $
                             diffuse:eSpec.diffuse[temp_eSpec_indices], $
                             Je:eSpec.Je[temp_eSpec_indices], $
                             Jee:eSpec.Jee[temp_eSpec_indices], $
                             nBad_eSpec:eSpec.nBad_eSpec[temp_eSpec_indices], $
                             info:eSpec.info}

  ENDIF ELSE BEGIN
     LOAD_NEWELL_ESPEC_DB,tmp_eSpec

     tmp_eSpec  = {mlt     : tmp_eSpec.mlt[indices__nonAlfven_eSpec]   , $
                   ilat    : tmp_eSpec.ilat[indices__nonAlfven_eSpec]  , $
                   mono    : tmp_eSpec.mono[indices__nonAlfven_eSpec]  , $
                   broad   : tmp_eSpec.broad[indices__nonAlfven_eSpec] , $
                   diffuse : tmp_eSpec.diffuse[indices__nonAlfven_eSpec], $
                   info    : eSpec.info}
  ENDELSE

  ;;The main body
  GET_H2D_NEWELLS__BODY,tmp_eSpec, $
                        MINM=minM, $
                        MAXM=maxM, $
                        BINM=binM, $
                        SHIFTM=shiftM, $
                        MINI=minI, $
                        MAXI=maxI, $
                        BINI=binI, $
                        EQUAL_AREA_BINNING=EA_binning, $
                        NEWELL_PLOTRANGE=newell_plotRange, $
                        LOG_NEWELLPLOT=log_newellPlot, $
                        NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
                        NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
                        NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
                        TMPLT_H2DSTR=tmplt_h2dStr, $
                        H2DSTRS=h2dStrs, $
                        ;; H2DMASKSTR=h2dMaskStr, $
                        H2DFLUXN=h2dFluxN, $
                        NEWELL_NONZERO_NEV_I=newell_nonzero_nEv_i, $
                        ;; MASKMIN=maskMin, $
                        DATANAMES=dataNames, $
                        DATARAWPTRS=dataRawPtrs, $
                        CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                        CB_FORCE_OOBLOW=cb_force_oobLow, $
                        PRINT_MANDM=print_mAndM, $
                        LUN=lun
END