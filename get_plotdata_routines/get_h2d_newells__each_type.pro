;2016/06/02
PRO GET_H2D_NEWELLS__EACH_TYPE,eSpec,plot_i, $
                               MINM=minM,MAXM=maxM, $
                               BINM=binM, $
                               SHIFTM=shiftM, $
                               MINI=minI,MAXI=maxI,BINI=binI, $
                               NEWELL_PLOTRANGE=newell_plotRange, $
                               LOG_NEWELLPLOT=log_newellPlot, $
                               NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
                               NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
                               TMPLT_H2DSTR=tmplt_h2dStr, $
                               H2DSTRS=h2dStrs, $
                               ;; H2DMASKSTR=h2dMaskStr, $
                               H2DFLUXN=h2dFluxN, $
                               H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                               ;; MASKMIN=maskMin, $
                               DATANAMES=dataNames, $
                               DATARAWPTRS=dataRawPtrs, $
                               CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                               CB_FORCE_OOBLOW=cb_force_oobLow, $
                               PRINT_MANDM=print_mAndM, $
                               LUN=lun


  COMPILE_OPT idl2

  ;;This common block is defined ONLY here and in LOAD_NEWELL_ESPEC_DB
  COMMON NEWELL,NEWELL__eSpec, $
     NEWELL__good_eSpec_i, $
     NEWELL__good_alf_i, $
     NEWELL_failCodes, $
     NEWELL__dbFile,NEWELL__dbDir

  LOAD_MAXIMUS_AND_CDBTIME,!NULL,!NULL,DO_DESPUNDB=despun,/CHECK_DB

  IF N_ELEMENTS(NEWELL__eSpec) EQ 0 OR N_ELEMENTS(NEWELL__good_alf_i) EQ 0 THEN BEGIN
     LOAD_NEWELL_ESPEC_DB,espec,good_alf_i
  ENDIF ELSE BEGIN
     eSpec            = NEWELL__eSpec
     good_eSpec_i     = NEWELL__good_eSpec_i
     good_alf_i       = NEWELL__good_alf_i
  ENDELSE

  plot_i__good_espec  = CGSETINTERSECTION(plot_i,good_alf_i,INDICES_B=temp_eSpec_indices)


  tmp_eSpec           = { x:eSpec.x[temp_eSpec_indices], $
                          MLT:eSpec.mlt[temp_eSpec_indices], $
                          ILAT:eSpec.ilat[temp_eSpec_indices], $
                          mono:eSpec.mono[temp_eSpec_indices], $
                          broad:eSpec.broad[temp_eSpec_indices], $
                          diffuse:eSpec.diffuse[temp_eSpec_indices], $
                          Je:eSpec.Je[temp_eSpec_indices], $
                          Jee:eSpec.Jee[temp_eSpec_indices], $
                          nBad_eSpec:eSpec.nBad_eSpec[temp_eSpec_indices]}
  

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Indices
  mono_i              = WHERE((tmp_eSpec.mono EQ 1) OR (tmp_eSpec.mono EQ 2),nMono)
  broad_i             = WHERE((tmp_eSpec.broad EQ 1) OR (tmp_eSpec.broad EQ 2),nBroad)
  diffuse_i           = WHERE(tmp_eSpec.diffuse EQ 1,nDiffuse)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;MLTs
  mlt_mono            = tmp_eSpec.mlt[mono_i]-shiftM
  mlt_broad           = tmp_eSpec.mlt[broad_i]-shiftM
  mlt_diffuse         = tmp_eSpec.mlt[diffuse_i]-shiftM
  mlt_mono[WHERE(mlt_mono LT 0)]        = mlt_mono[WHERE(mlt_mono LT 0)] + 24
  mlt_broad[WHERE(mlt_broad LT 0)]      = mlt_broad[WHERE(mlt_broad LT 0)] + 24
  mlt_diffuse[WHERE(mlt_diffuse LT 0)]  = mlt_diffuse[WHERE(mlt_diffuse LT 0)] + 24

  mlt_list        = LIST(TEMPORARY(mlt_mono),TEMPORARY(mlt_broad),TEMPORARY(mlt_diffuse))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;ILATs
  ilat_mono       = tmp_eSpec.ilat[mono_i]
  ilat_broad      = tmp_eSpec.ilat[broad_i]
  ilat_diffuse    = tmp_eSpec.ilat[diffuse_i]
  ilat_list       = LIST(TEMPORARY(ilat_mono),TEMPORARY(ilat_broad),TEMPORARY(ilat_diffuse))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Bonus
  titles          = ['Monoenergetic','Broadband','Diffuse']
  dataNames       = ['mono'         ,'broad'    ,'diffuse']

  h2dStrs         = !NULL
  dataRawPtrs     = !NULL
  
  FOR i=0,N_ELEMENTS(titles)-1 DO BEGIN
     GET_H2D_NEWELL_AND_MASK,tmp_eSpec, $ ;eSpec_i, $
                             TITLE=titles[i], $
                             IN_MLTS=mlt_list[i], $
                             IN_ILATS=ilat_list[i], $
                             MINM=minM,MAXM=maxM, $
                             BINM=binM, $
                             SHIFTM=shiftM, $
                             MINI=minI,MAXI=maxI,BINI=binI, $
                             DO_LSHELL=do_lShell, MINL=minL,MAXL=maxL,BINL=binL, $
                             NEWELL_PLOTRANGE=newell_plotRange, $
                             LOG_NEWELLPLOT=log_newellPlot, $
                             NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
                             NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
                             TMPLT_H2DSTR=tmplt_h2dStr, $
                             H2DSTR=h2dStr, $
                             ;; H2DMASKSTR=h2dMaskStr, $
                             H2DFLUXN=h2dFluxN,H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                             ;; MASKMIN=maskMin, $
                             DATANAME=dataNames[i], $
                             DATARAWPTR=dataRawPtr, $
                             CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                             CB_FORCE_OOBLOW=cb_force_oobLow, $
                             PRINT_MANDM=print_mAndM, $
                             LUN=lun
     
     h2dStrs      = [h2dStrs,h2dStr]
     dataRawPtrs  = [dataRawPtrs,dataRawPtr]

  ENDFOR
END