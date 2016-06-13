;2016/06/04 RUN IT!!
PRO GET_NEWELL_FLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM, $
                             BINM=binM, $
                             SHIFTM=shiftM, $
                             MINI=minI,MAXI=maxI,BINI=binI, $
                             DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                             OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                             FLUXPLOTTYPE=fluxPlotType, $
                             PLOTRANGE=plotRange, $
                             PLOTAUTOSCALE=plotAutoscale, $
                             NOPOSFLUX=noPosFlux, $
                             NONEGFLUX=noNegFlux, $
                             ABSFLUX=absFlux, $
                             EFLUX_NONALFVEN_DATA=eFlux_nonAlfven_data, $
                             ENUMFLUX_NONALFVEN_DATA=eNumFlux_nonAlfven_data, $
                             ;; IFLUX_NONALFVEN_DATA=iFlux_nonAlfven_data, $
                             ;; INUMFLUX_NONALFVEN_DATA=iNumFlux_nonAlfven_data, $
                             INDICES__NONALFVEN_ESPEC=indices__nonAlfven_eSpec, $
                             ;; INDICES__NONALFVEN_ION=indices__nonAlfven_ion, $
                             NONALFVEN__JUNK_ALFVEN_CANDIDATES=nonAlfven__junk_alfven_candidates, $
                             NONALFVEN__ALL_FLUXES=nonalfven__all_fluxes, $
                             NONALFVEN_MLT=nonAlfven_mlt, $
                             NONALFVEN_ILAT=nonAlfven_ilat, $
                             NONALFVEN_DELTA_T=nonAlfven_delta_t, $
                             OUT_REMOVED_II=out_removed_ii, $
                             LOGFLUXPLOT=logFluxPlot, $
                             DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                             MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                             DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                             DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
                             DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                             GROSSRATE__H2D_AREAS=h2dAreas, $
                             DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
                             GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
                             GROSSRATE__CENTERS_MLT=centersMLT, $
                             GROSSRATE__CENTERS_ILAT=centersILAT, $
                             GROSSCONVFACTORARR=grossConvFactorArr, $
                             WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
                             GROSSLUN=grossLun, $
                             THISTDENOMINATOR=tHistDenominator, $
                             H2DSTRARR=h2dStrArr, $
                             TMPLT_H2DSTR=tmplt_h2dStr, $
                             H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                             H2DFLUXN=h2dFluxN, $
                             H2DMASK=h2dMask, $
                             UPDATE_H2D_MASK=update_h2d_mask, $
                             OUT_H2DMASK=out_h2dMask, $
                             DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr, $
                             VARPLOTH2DINDS=varPlotH2DInds, $
                             VARPLOTRAWINDS=varPlotRawInds, $
                             REMOVED_II_LISTARR=removed_ii_listArr, $
                             MEDIANPLOT=medianplot, $
                             MEDHISTOUTDATA=medHistOutData, $
                             MEDHISTOUTTXT=medHistOutTxt, $
                             MEDHISTDATADIR=medHistDataDir, $
                             LOGAVGPLOT=logAvgPlot, $
                             DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                             ORBCONTRIB_H2DSTR_FOR_DIVISION=orbContrib_h2dStr_for_division, $
                             GET_EFLUX=get_eflux, $
                             GET_ENUMFLUX=get_eNumFlux, $
                             NEWELL_ANALYZE_EFLUX=newell_analyze_eFlux, $
                             NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
                             TXTOUTPUTDIR=txtOutputDir, $
                             GET_PFLUX=get_pFlux, $
                             GET_IFLUX=get_iFlux, $
                             GET_OXYFLUX=get_oxyFlux, $
                             GET_CHAREE=get_ChareE, $
                             GET_CHARIE=get_chariE, $
                             DO_PLOT_I_INSTEAD_OF_HISTOS=do_plot_i_instead_of_histos, $
                             PRINT_MAX_AND_MIN=print_mandm, $
                             FANCY_PLOTNAMES=fancy_plotNames, $
                             NPLOTS=nPlots, $
                             MASKMIN=maskMin, $
                             KEEPME=keepMe, $
                             LUN=lun
  
  COMPILE_OPT idl2

  IF KEYWORD_SET(newell_analysis__output_summary) THEN BEGIN

     hamFile = "newell_event_info--"+GET_TODAY_STRING(/DO_YYYYMMDD_FMT)+".txt"
     PRINT,"Opening " + hamFile + '...'
     OPENW,sum_lun,txtOutputDir+hamFile,/GET_LUN,/APPEND
     
  ENDIF 

  IF KEYWORD_SET(eFlux_nonAlfven_data) OR KEYWORD_SET(eNumFlux_nonAlfven_data) $
  THEN BEGIN
     nonAlfven       = 1
     ;; nonAlf_inds     = indices__nonAlfven_eSpec
  ENDIF;;  ELSE BEGIN
  ;;    IF KEYWORD_SET(iFlux_nonAlfven_data) OR KEYWORD_SET(iNumFlux_nonAlfven_data) $
  ;;    THEN BEGIN
  ;;       nonAlfven    = 1
  ;;       nonAlf_inds  = indices__nonAlfven_ion
  ;;    ENDIF 
  ;; ENDELSE

  IF KEYWORD_SET(nonAlfven) THEN BEGIN

     SPLIT_ESPECDB_I_BY_ESPEC_TYPE,indices__nonAlfven_eSpec, $
                                   OUT_TITLES=out_titles, $
                                   OUT_DATANAMESUFFS=out_datanamesuffs, $
                                   OUT_I_LIST=out_i_list, $
                                   SUMMARY=newell_analysis__output_summary, $
                                   SUM_LUN=sum_lun


  ENDIF ELSE BEGIN

     SPLIT_ALFDB_I_BY_ESPEC_TYPE,plot_i,maximus.despun, $
                                 OUT_TITLES=out_titles, $
                                 OUT_DATANAMESUFFS=out_datanamesuffs, $
                                 OUT_I_LIST=out_i_list, $
                                 SUMMARY=newell_analysis__output_summary, $
                                 DESPUN_ALF_DB=despun_alf_db, $
                                 SUM_LUN=sum_lun
  ENDELSE

  IF KEYWORD_SET(newell_analysis__output_summary) THEN BEGIN
     CLOSE,sum_lun
     FREE_LUN,sum_lun
  ENDIF
  
  FOR k=0,N_ELEMENTS(out_i_list)-1 DO BEGIN
     
     tmp_i           = out_i_list[k]

     IF tmp_i[0] EQ -1 THEN CONTINUE

     ;;Need to provide a new h2dFluxN and a new mask for each of these
     GET_H2D_NEVENTS_AND_MASK,maximus,tmp_i, $
                             IN_MLTS=KEYWORD_SET(nonAlfven_mlt) ? nonAlfven_mlt[tmp_i] : !NULL, $
                             IN_ILATS=KEYWORD_SET(nonAlfven_ilat) ? nonAlfven_ilat[tmp_i] : !NULL, $
                             MINM=minM,MAXM=maxM, $
                             BINM=binM, $
                             SHIFTM=shiftM, $
                             MINI=minI,MAXI=maxI,BINI=binI, $
                             DO_LSHELL=do_lShell, MINL=minL,MAXL=maxL,BINL=binL, $
                             NEVENTSPLOTRANGE=nEventsPlotRange, $
                             TMPLT_H2DSTR=tmplt_h2dStr, $
                             H2DSTR=tempNh2dStr,H2DMASKSTR=temph2dMaskStr, $
                             H2DFLUXN=temph2dFluxN,H2D_NONZERO_NEV_I=temph2d_nonzero_nEv_i, $
                             MASKMIN=maskMin, $
                             DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                             CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                             CB_FORCE_OOBLOW=cb_force_oobLow, $
                             PRINT_MANDM=print_mAndM, $
                             LUN=lun     

     temph2dmask    = temph2dmaskstr.data

     GET_FLUX_PLOTDATA,maximus,tmp_i, $
                       MINM=minM,MAXM=maxM, $
                       BINM=binM, $
                       SHIFTM=shiftM, $
                       MINI=minI,MAXI=maxI,BINI=binI, $
                       DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT, $
                       OUTH2DBINSILAT=outH2DBinsILAT, $
                       OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       FLUXPLOTTYPE=fluxPlotType, $
                       PLOTRANGE=plotRange, $
                       PLOTAUTOSCALE=plotAutoscale, $
                       NOPOSFLUX=noPosFlux, $
                       NONEGFLUX=noNegFlux, $
                       ABSFLUX=absFlux, $
                       EFLUX_NONALFVEN_DATA=eFlux_nonAlfven_data, $
                       ENUMFLUX_NONALFVEN_DATA=eNumFlux_nonAlfven_data, $
                       ;; IFLUX_NONALFVEN_DATA=iFlux_nonAlfven_data, $
                       ;; INUMFLUX_NONALFVEN_DATA=iNumFlux_nonAlfven_data, $
                       INDICES__NONALFVEN_ESPEC=KEYWORD_SET(nonAlfven) ? tmp_i : indices__nonAlfven_eSpec, $
                       NONALFVEN__JUNK_ALFVEN_CANDIDATES=nonAlfven__junk_alfven_candidates, $
                       NONALFVEN__ALL_FLUXES=nonalfven__all_fluxes, $
                       NONALFVEN_MLT=nonAlfven_mlt, $
                       NONALFVEN_ILAT=nonAlfven_ilat, $
                       NONALFVEN_DELTA_T=nonAlfven_delta_t, $
                       OUT_REMOVED_II=out_removed_ii, $
                       LOGFLUXPLOT=logFluxPlot, $
                       DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                       MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                       DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                       DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
                       DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                       GROSSRATE__H2D_AREAS=h2dAreas, $
                       DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
                       GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
                       GROSSRATE__CENTERS_MLT=centersMLT, $
                       GROSSRATE__CENTERS_ILAT=centersILAT, $
                       GROSSCONVFACTOR=grossConvFactor, $
                       WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
                       GROSSLUN=grossLun, $
                       THISTDENOMINATOR=tHistDenominator, $
                       H2DSTR=h2dStr, $
                       TMPLT_H2DSTR=tmplt_h2dStr, $
                       H2D_NONZERO_NEV_I=temph2d_nonzero_nEv_i, $
                       H2DFLUXN=temph2dFluxN, $
                       H2DMASK=temph2dMask, $
                       UPDATE_H2D_MASK=update_h2d_mask, $
                       OUT_H2DMASK=out_h2dMask, $
                       DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot, $
                       MEDHISTOUTDATA=medHistOutData, $
                       MEDHISTOUTTXT=medHistOutTxt, $
                       MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot, $
                       DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                       ORBCONTRIB_H2DSTR_FOR_DIVISION=orbContrib_h2dStr_for_division, $
                       GET_EFLUX=get_eflux, $
                       GET_ENUMFLUX=get_eNumFlux, $
                       GET_PFLUX=get_pFlux, $
                       GET_IFLUX=get_iFlux, $
                       GET_OXYFLUX=get_oxyFlux, $
                       GET_CHAREE=get_ChareE, $
                       GET_CHARIE=get_chariE, $
                       DO_PLOT_I_INSTEAD_OF_HISTOS=do_plot_i_instead_of_histos, $
                       PRINT_MAX_AND_MIN=print_mandm, $
                       FANCY_PLOTNAMES=fancy_plotNames, $
                       LUN=lun

     ;; IF ~KEYWORD_SET(nonAlfven_mlt) THEN h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

     ;;Add Newell-specific stuff
     h2dStr.title        += out_titles[k]
     dataName            += out_datanamesuffs[k]
     h2dStr.mask          = out_h2dMask
     h2dStr.hasMask       = 1

     h2dStrArr            = [h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN
        dataNameArr       = [dataNameArr,dataName] 
        dataRawPtrArr     =[dataRawPtrArr,dataRawPtr] 
        varPlotH2DInds  = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
        varPlotRawInds  = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
        removed_ii_listArr = [removed_ii_listArr,LIST(out_removed_ii)]
     ENDIF 

     IF KEYWORD_SET(do_grossRate_fluxQuantities) $
        OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        grossConvFactorArr   = [grossConvFactorArr,grossConvFactor]
     ENDIF

  ENDFOR

END