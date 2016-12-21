PRO GET_ALFVENDB_2DHISTOS, $
   plot_i, $
   fastLocInterped_i, $
   H2DSTRARR=h2dStrArr, $
   DATARAWPTRARR=dataRawPtrArr, $
   DATANAMEARR=dataNameArr, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
   IMF_STRUCT=IMF_struct, $
   MIMC_STRUCT=MIMC_struct, $
   MASKMIN=maskMin, $
   THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
   HERE_ARE_YOUR_FASTLOC_INDS=fastLoc_inds, $
   NPLOTS=nPlots, $
   NEVENTSPLOTRANGE=nEventsPlotRange, $
   NEVENTSPLOT__NOMASK=nEventsPlot__noMask, $
   LOGNEVENTSPLOT=logNEventsPlot, $
   NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
   NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
   EPLOTS=ePlots, $
   EFLUXPLOTTYPE=eFluxPlotType, $
   LOGEFPLOT=logEfPlot, $
   ABSEFLUX=abseflux, $
   NOPOSEFLUX=noPosEFlux, $
   NONEGEFLUX=noNegEflux, $
   EPLOTRANGE=EPlotRange, $
   ENUMFLPLOTS=eNumFlPlots, $
   ENUMFLPLOTTYPE=eNumFlPlotType, $
   LOGENUMFLPLOT=logENumFlPlot, $
   ABSENUMFL=absENumFl, $
   NONEGENUMFL=noNegENumFl, $
   NOPOSENUMFL=noPosENumFl, $
   ENUMFLPLOTRANGE=ENumFlPlotRange, $
   AUTOSCALE_ENUMFLPLOTS=autoscale_eNumFlplots, $
   NEWELL_ANALYZE_MULTIPLY_BY_TYPE_PROBABILITY=newell_analyze_multiply_by_type_probability, $
   NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
   EFLUX_ESPEC_DATA=eFlux_eSpec_data, $
   ENUMFLUX_ESPEC_DATA=eNumFlux_eSpec_data, $
   IFLUX_ESPEC_DATA=iFlux_eSpec_data, $
   INUMFLUX_ESPEC_DATA=iNumFlux_eSpec_data, $
   INDICES__ESPEC=indices__eSpec, $
   INDICES__ION=indices__ion, $
   ;; ESPEC__NO_MAXIMUS=no_maximus, $
   ;; FOR_ESPEC_DB=for_eSpec_DB, $
   ESPEC__MLTS=eSpec__mlts, $
   ESPEC__ILATS=eSpec__ilats, $
   ;; FOR_ION_DB=for_ion_DB, $
   ION__MLTS=ion__mlts, $
   ION__ILATS=ion__ilats, $
   ION_DELTA_T=ion_delta_t, $
   PPLOTS=pPlots, $
   LOGPFPLOT=logPfPlot, $
   ABSPFLUX=absPflux, $
   NONEGPFLUX=noNegPflux, $
   NOPOSPFLUX=noPosPflux, $
   PPLOTRANGE=PPlotRange, $
   IONPLOTS=ionPlots, $
   IFLUXPLOTTYPE=ifluxPlotType, $
   LOGIFPLOT=logIfPlot, $
   ABSIFLUX=absIflux, $
   NONEGIFLUX=noNegIflux, $
   NOPOSIFLUX=noPosIflux, $
   IPLOTRANGE=IPlotRange, $
   OXYPLOTS=oxyPlots, $
   OXYFLUXPLOTTYPE=oxyFluxPlotType, $
   LOGOXYFPLOT=logOxyfPlot, $
   ABSOXYFLUX=absOxyFlux, $
   NONEGOXYFLUX=noNegOxyFlux, $
   NOPOSOXYFLUX=noPosOxyFlux, $
   OXYPLOTRANGE=oxyPlotRange, $
   CHAREPLOTS=charEPlots, $
   CHARETYPE=charEType, $
   LOGCHAREPLOT=logCharEPlot, $
   ABSCHARE=absCharE, $
   NONEGCHARE=noNegCharE, $
   NOPOSCHARE=noPosCharE, $
   CHAREPLOTRANGE=CharEPlotRange, $
   CHARIEPLOTS=chariePlots, $
   LOGCHARIEPLOT=logChariePlot, $
   ABSCHARIE=absCharie, $
   NONEGCHARIE=noNegCharie, $
   NOPOSCHARIE=noPosCharie, $
   CHARIEPLOTRANGE=ChariePlotRange, $
   AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
   FLUXPLOTS__REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
   FLUXPLOTS__REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
   FLUXPLOTS__NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
   DIV_FLUXPLOTS_BY_ORBTOT=div_fluxPlots_by_orbTot, $
   DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
   ORBCONTRIBPLOT=orbContribPlot, $
   ORBCONTRIBRANGE=orbContribRange, $
   ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
   ORBCONTRIB_NOMASK=orbContrib_noMask, $
   LOGORBCONTRIBPLOT=logOrbContribPlot, $
   ORBCONTRIB__REFERENCE_ALFVENDB_NOT_EPHEMERIS=orbContrib__reference_alfvenDB, $
   ORBTOTPLOT=orbTotPlot, $
   ORBFREQPLOT=orbFreqPlot, $
   ORBTOTRANGE=orbTotRange, $
   ORBFREQRANGE=orbFreqRange, $
   NEVENTPERORBPLOT=nEventPerOrbPlot, $
   LOGNEVENTPERORB=logNEventPerOrb, $
   NEVENTPERORBRANGE=nEventPerOrbRange, $
   NEVENTPERORBAUTOSCALE=nEventPerOrbAutoscale, $
   DIVNEVBYTOTAL=divNEvByTotal, $
   NEVENTPERMINPLOT=nEventPerMinPlot, $
   NEVENTPERMINRANGE=nEventPerMinRange, $
   LOGNEVENTPERMIN=logNEventPerMin, $
   NEVENTPERMINAUTOSCALE=nEventPerMinAutoscale, $
   NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
   LOG_NOWEPCOPLOT=log_nowepcoPlot, $
   NOWEPCO_RANGE=nowepco_range, $
   NOWEPCO_AUTOSCALE=nowepco_autoscale, $
   PROBOCCURRENCEPLOT=probOccurrencePlot, $
   PROBOCCURRENCERANGE=probOccurrenceRange, $
   PROBOCCURRENCEAUTOSCALE=probOccurrenceAutoscale, $
   LOGPROBOCCURRENCE=logProbOccurrence, $
   THISTDENOMINATORPLOT=tHistDenominatorPlot, $
   THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
   THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
   THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
   THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
   NEWELLPLOTS=newellPlots, $
   NEWELL_PLOTRANGE=newell_plotRange, $
   LOG_NEWELLPLOT=log_newellPlot, $
   NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
   NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
   NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
   ESPEC__NEWELLPLOT_PROBOCCURRENCE=eSpec__newellPlot_probOccurrence, $
   ESPEC__NEWELL_PLOTRANGE=eSpec__newell_plotRange, $
   ESPEC__T_PROBOCCURRENCE=eSpec__t_probOccurrence, $
   ESPEC__T_PROBOCC_PLOTRANGE=eSpec__t_probOcc_plotRange, $
   TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
   TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
   LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
   TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
   TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
   LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
   DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
   DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
   DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
   GROSSRATE__H2D_AREAS=h2dAreas, $
   DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
   GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
   GROSSRATE__CENTERS_MLT=centersMLT, $
   GROSSRATE__CENTERS_ILAT=centersILAT, $
   WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
   WRITE_ORB_AND_OBS_INFO=write_obsArr_textFile, $
   WRITE_ORB_AND_OBS__INC_IMF=write_obsArr__inc_IMF, $
   WRITE_ORB_AND_OBS__ORB_AVG_OBS=write_obsArr__orb_avg_obs, $
   GROSSLUN=grossLun, $
   SHOW_INTEGRALS=show_integrals, $
   DIVIDE_BY_WIDTH_X=divide_by_width_x, $
   MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
   MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
   ADD_VARIANCE_PLOTS=add_variance_plots, $
   ONLY_VARIANCE_PLOTS=only_variance_plots, $
   VAR__PLOTRANGE=var__plotRange, $
   VAR__REL_TO_MEAN_VARIANCE=var__rel_to_mean_variance, $
   VAR__DO_STDDEV_INSTEAD=var__do_stddev_instead, $
   VAR__AUTOSCALE=var__autoscale, $
   PLOT_CUSTOM_MAXIND=plot_custom_maxInd, $
   CUSTOM_MAXINDS=custom_maxInds, $
   CUSTOM_MAXIND_RANGE=custom_maxInd_range, $
   CUSTOM_MAXIND_AUTOSCALE=custom_maxInd_autoscale, $
   CUSTOM_MAXIND_DATANAME=custom_maxInd_dataname, $
   CUSTOM_MAXIND_TITLE=custom_maxInd_title, $
   CUSTOM_GROSSRATE_CONVFACTOR=custom_grossRate_convFactor, $
   LOG_CUSTOM_MAXIND=log_custom_maxInd, $
   SUM_ELECTRON_AND_POYNTINGFLUX=sum_electron_and_poyntingflux, $
   SUMMED_EFLUX_PFLUXPLOTRANGE=summed_eFlux_pFluxplotRange, $
   SUMMED_EFLUX_PFLUX_LOGPLOT=summed_eFlux_pFlux_logPlot, $
   MEDIANPLOT=medianPlot, $
   MEDHISTOUTDATA=medHistOutData, $
   MEDHISTOUTTXT=medHistOutTxt, $
   LOGAVGPLOT=logAvgPlot, $
   ALL_LOGPLOTS=all_logPlots, $
   PARAMSTRING=paramStr, $
   PARAMSTRPREFIX=paramStrPrefix, $
   PARAMSTRSUFFIX=paramStrSuffix, $
   SAVE_FASTLOC_INDS=save_fastLoc_inds, $
   IND_FILEDIR=ind_fileDir, $
   TMPLT_H2DSTR=tmplt_h2dStr, $
   RESET_GOOD_INDS=reset_good_inds, $
   RESET_OMNI_INDS=reset_omni_inds, $
   FANCY_PLOTNAMES=fancy_plotNames, $
   TXTOUTPUTDIR=txtOutputDir, $
   DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
   LUN=lun
  
  COMPILE_OPT idl2

  @common__maximus_vars.pro
  @common__fastloc_vars.pro
  @common__newell_espec.pro

  ;;set up variance plot inds
  varPlotRawInds         = !NULL
  varPlotH2DInds         = !NULL
  removed_ii_listarr     = !NULL
  ;; varPlotIsKeepInds      = !NULL
  grossConvFactorArr     = !NULL

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF N_ELEMENTS(print_mandm) EQ 0 THEN print_mandm = 1

  ;;########Flux_N and Mask########
  ;;First, histo to show where events are
  IF KEYWORD_SET(alfDB_plot_struct.no_maximus) THEN BEGIN
     CASE 1 OF
        ( (N_ELEMENTS(eFlux_eSpec_data) GT 0) OR $
          (N_ELEMENTS(eNumFlux_eSpec_data) GT 0) ): BEGIN
           in_MLTS  = NEWELL__eSpec.mlt[indices__eSpec]
           in_ILATS = NEWELL__eSpec.ilat[indices__eSpec]
        END
        ( (N_ELEMENTS(iFlux_eSpec_data) GT 0) OR $
          (N_ELEMENTS(iNumFlux_eSpec_data) GT 0) ): BEGIN
           in_MLTS  = NEWELL_I__ion.mlt[indices__ion]
           in_ILATS = NEWELL_I__ion.ilat[indices__ion]
        END
     ENDCASE

  ENDIF

  GET_H2D_NEVENTS_AND_MASK,MAXIMUS__maximus,plot_i, $
                           IN_MLTS=in_MLTs, $
                           IN_ILATS=in_ILATs, $
                           ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                           IMF_STRUCT=IMF_struct, $
                           MIMC_STRUCT=MIMC_struct, $
                           NEVENTSPLOTRANGE=nEventsPlotRange, $
                           NEVENTSPLOT__NOMASK=nEventsPlot__noMask, $
                           TMPLT_H2DSTR=tmplt_h2dStr, $
                           H2DSTR=h2dStr, $
                           H2DMASKSTR=h2dMaskStr, $
                           H2DFLUXN=h2dFluxN, $
                           H2D_NONZERO_NEV_I=hEv_nz_i, $
                           MASKMIN=maskMin, $
                           DATANAME=dataName, $
                           DATARAWPTR=dataRawPtr
  
  IF alfDB_plot_struct.keepMe THEN BEGIN 
     IF KEYWORD_SET(nPlots) THEN BEGIN
        h2dStrArr     = [h2dStr,h2dMaskStr] 
        dataNameArr   = [dataName,"histoMask"] 
        dataRawPtrArr = [dataRawPtr,PTR_NEW(h2dMaskStr.data)] 
     ENDIF ELSE BEGIN
        h2dStrArr     = h2dMaskStr
        dataNameArr   = "histoMask"
        dataRawPtrArr = PTR_NEW(h2dMaskStr.data)
     ENDELSE
  ENDIF
  
  ;;Get tHist denominator here so other routines can use it as they please
  IF KEYWORD_SET(alfDB_plot_struct.nEventPerMinPlot) OR $
     KEYWORD_SET(alfDB_plot_struct.probOccurrencePlot) $
     ;; OR KEYWORD_SET(timeAvgd_pfluxPlot) OR KEYWORD_SET(timeAvgd_eFluxMaxPlot) $
     OR KEYWORD_SET(alfDB_plot_struct.do_timeAvg_fluxQuantities) $
     OR KEYWORD_SET(alfDB_plot_struct.nEventPerOrbPlot) $
     OR KEYWORD_SET(alfDB_plot_struct.tHistDenominatorPlot) $
     OR KEYWORD_SET(alfDB_plot_struct.nOrbsWithEventsPerContribOrbsPlot) $
     OR KEYWORD_SET(alfDB_plot_struct.div_fluxPlots_by_applicable_orbs) $
     OR KEYWORD_SET(alfDB_plot_struct.tHist_mask_bins_below_thresh) $
     OR KEYWORD_SET(alfDB_plot_struct.numOrbLim) $
     OR KEYWORD_SET(alfDB_plot_struct.t_probOccurrence) $
  THEN BEGIN 

     IF ~KEYWORD_SET(alfDB_plot_struct.no_maximus) THEN BEGIN
        tHistDenominator = GET_TIMEHIST_DENOMINATOR( $
                           fastLocInterped_i, $
                           HERE_ARE_YOUR_FASTLOC_INDS=fastLoc_inds, $
                           ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                           IMF_STRUCT=IMF_struct, $
                           MIMC_STRUCT=MIMC_struct, $
                           FASTLOCOUTPUTDIR=txtOutputDir, $
                           MAKE_TIMEHIST_H2DSTR=tHistDenominatorPlot, $
                           THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
                           THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
                           THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
                           THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
                           TMPLT_H2DSTR=tmplt_h2dStr, $
                           H2DSTR=h2dStr, $
                           DATANAME=dataName, $
                           DATARAWPTR=dataRawPtr, $
                           H2D_NONZERO_NEV_I=hEv_nz_i, $
                           SAVE_FASTLOC_INDS=save_fastLoc_inds, $
                           PARAMSTR_FOR_SAVING=paramStr, $
                           IND_FILEDIR=ind_fileDir, $
                           INDSFILEPREFIX=paramStrPrefix, $
                           INDSFILESUFFIX=paramStrSuffix, $
                           DO_NOT_SET_DEFAULTS=do_not_set_defaults)

        
        IF KEYWORD_SET(tHist_mask_bins_below_thresh) THEN BEGIN
           PRINT,'Applying min threshold (' + $
                 STRCOMPRESS(tHist_mask_bins_below_thresh,/REMOVE_ALL) $
                 + ' min) to mask based on tHist ...'
           belowThresh_i = WHERE((tHistDenominator/60.) LT tHist_mask_bins_below_thresh,nBelow)
           IF nBelow GT 0 THEN BEGIN
              
              new_i = CGSETDIFFERENCE(belowThresh_i, $
                                      WHERE(h2dStrArr[KEYWORD_SET(nPlots)].data GT 250), $
                                      COUNT=nNew)
              IF nNew GT 0 THEN BEGIN
                 PRINT,'Masking an additional ' + $
                       STRCOMPRESS(nNew,/REMOVE_ALL) + $
                       " bins based on tHist thresh ..."
                 
                 h2dStrArr[KEYWORD_SET(nPlots)].data[new_i] = 255
              ENDIF ELSE BEGIN
                 PRINT,'No new bins to mask based on tHist thresh!'
              ENDELSE
           ENDIF
        ENDIF


        IF alfDB_plot_struct.keepMe THEN BEGIN 
           IF KEYWORD_SET(tHistDenominatorPlot) THEN BEGIN
              h2dStrArr       = [h2dStrArr,h2dStr] 
              dataNameArr     = [dataNameArr,dataName] 
              dataRawPtrArr   = [dataRawPtrArr,dataRawPtr] 
              varPlotH2DInds  = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
              varPlotRawInds  = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
              removed_ii_listArr = [removed_ii_listArr,LIST(!NULL)]
           ENDIF
        ENDIF

     ENDIF

     IF KEYWORD_SET(eFlux_eSpec_data   ) OR $
        KEYWORD_SET(eNumFlux_eSpec_data) OR $
        KEYWORD_SET(iFlux_eSpec_data   ) OR $
        KEYWORD_SET(iNumFlux_eSpec_data)    $
     THEN BEGIN
        eSpec_tHistDenominator = GET_TIMEHIST_DENOMINATOR( $
                                 fastLocInterped_i, $
                                 HERE_ARE_YOUR_FASTLOC_INDS=fastLoc_inds, $
                                 ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                 IMF_STRUCT=IMF_struct, $
                                 MIMC_STRUCT=MIMC_struct, $
                                 FASTLOCOUTPUTDIR=txtOutputDir, $
                                 MAKE_TIMEHIST_H2DSTR=tHistDenominatorPlot, $
                                 THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
                                 THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
                                 THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
                                 THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
                                 TMPLT_H2DSTR=tmplt_h2dStr, $
                                 H2DSTR=h2dStr, $
                                 DATANAME=dataName, $
                                 DATARAWPTR=dataRawPtr, $
                                 H2D_NONZERO_NEV_I=hEv_nz_i__nonAlfven, $
                                 SAVE_FASTLOC_INDS=save_fastLoc_inds, $
                                 PARAMSTR_FOR_SAVING=paramStr, $
                                 IND_FILEDIR=ind_fileDir, $
                                 INDSFILEPREFIX=paramStrPrefix, $
                                 INDSFILESUFFIX=paramStrSuffix, $
                                 DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                                 /FOR_ESPEC_DBS)
        

        IF alfDB_plot_struct.keepMe THEN BEGIN 
           IF KEYWORD_SET(tHistDenominatorPlot) THEN BEGIN
              dataName      = dataName+'_nonAlfven'
              h2dStr.name   = dataName
              h2dStr.title += ' (Non-Alf)'
              h2dStrArr     = [h2dStrArr,h2dStr] 
              dataNameArr   = [dataNameArr,dataName] 
              dataRawPtrArr = [dataRawPtrArr,dataRawPtr] 
           ENDIF
        ENDIF

     ENDIF 

  ENDIF
  
  ;;########Orbits########
  ;;Now do orbit data to show how many orbits contributed to each thingy.
  ;;A little extra tomfoolery is in order to get this right
  ;;h2dOrbN is a 2d histo just like the others
  ;;orbArr, on the other hand, is a 3D array, where the
  ;;2D array pointed to is indexed by MLTbin and ILATbin. The contents of
  ;;the 3D array are of the format [UniqueOrbs_ii index,MLT,ILAT]
  
  ;;Get orbs Contrib in case other routines want it
  IF KEYWORD_SET(orbContribPlot) OR KEYWORD_SET(orbfreqplot) $
     OR KEYWORD_SET(nEventPerOrbPlot) OR KEYWORD_SET(alfDB_plot_struct.numOrbLim) $
     OR KEYWORD_SET(nOrbsWithEventsPerContribOrbsPlot) $
     OR KEYWORD_SET(div_fluxPlots_by_applicable_orbs) THEN BEGIN
     
     IF KEYWORD_SET(orbContrib__reference_alfvenDB) THEN BEGIN
        alfRef_i = GET_CHASTON_IND( $
                   MAXIMUS__maximus, $
                   DBFILE=dbfile, $
                   DBTIMES=dbTimes, $
                   /GET_ALFVENDB_I, $
                   /RESET_GOOD_INDS, $
                   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                   IMF_STRUCT=IMF_struct, $
                   MIMC_STRUCT=MIMC_struct, $
                   /PRINT_PARAM_SUMMARY)




     ENDIF
        
     ;; ENDCASE

     GET_CONTRIBUTING_ORBITS_PLOTDATA, $
        (KEYWORD_SET(orbContrib__reference_alfvenDB) ? MAXIMUS__maximus : FL__fastLoc), $
        (KEYWORD_SET(orbContrib__reference_alfvenDB) ? alfRef_i : fastLocInterped_i), $
        MINM=MIMC_struct.minM, $
        MAXM=MIMC_struct.maxM, $
        BINM=MIMC_struct.binM, $
        SHIFTM=MIMC_struct.shiftM, $
        MINI=MIMC_struct.minI, $
        MAXI=MIMC_struct.maxI, $
        BINI=MIMC_struct.binI, $
        EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning, $
        DO_LSHELL=MIMC_struct.do_lShell, $
        MINL=MIMC_struct.minL, $
        MAXL=MIMC_struct.maxL, $
        BINL=MIMC_struct.binL, $
        LOGORBCONTRIBPLOT=logOrbContribPlot, $
        ORBCONTRIBRANGE=orbContribRange, $
        ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
        ORBCONTRIB_NOMASK=orbContrib_noMask, $
        UNIQUEORBS_I=uniqueOrbs_i, $
        H2D_NONZERO_CONTRIBORBS_I=h2d_nonzero_contribOrbs_i, $
        H2D_NONZERO_I=hEv_nz_i, $
        H2DSTR=h2dContribOrbStr, $
        TMPLT_H2DSTR=tmplt_h2dStr, $ ;H2DFLUXN=h2dFluxN, $
        DATANAME=dataName
     
     ;;Tell us who you are so we know 
     ;;(or rather, so GET_CONTRIBUTING_ORBITS_PLOTDATA knows) how to deal with you
     ADD_STR_ELEMENT,h2dContribOrbStr,'i_am_alf_ref', $
                     KEYWORD_SET(orbContrib__reference_alfvenDB)

     IF KEYWORD_SET(orbContribPlot) THEN BEGIN 
        h2dStrArr=[h2dStrArr,h2dContribOrbStr] 
        IF alfDB_plot_struct.keepMe THEN dataNameArr=[dataNameArr,dataName] 
     ENDIF
     
     ;;Mask all bins that don't have requisite number of orbits passing through
     IF KEYWORD_SET(alfDB_plot_struct.numOrbLim) THEN BEGIN 
        PRINT,'Applying orb threshold (' + STRCOMPRESS(alfDB_plot_struct.numOrbLim,/REMOVE_ALL) + $
              ' orbits) to mask based on nContribOrbs ...'
        belowThresh_i = WHERE(h2dContribOrbStr.data LT alfDB_plot_struct.numOrbLim,nBelow)
        IF nBelow GT 0 THEN BEGIN
           
           new_i = CGSETDIFFERENCE(belowThresh_i, $
                                   WHERE(h2dStrArr[KEYWORD_SET(nPlots)].data GT 250), $
                                   COUNT=nNew)
           IF nNew GT 0 THEN BEGIN
              PRINT,'Masking an additional ' + $
                    STRCOMPRESS(nNew,/REMOVE_ALL) + $
                    " bins based on numOrbLim thresh ..."
              
              h2dStrArr[KEYWORD_SET(nPlots)].data[new_i] = 255
           ENDIF ELSE BEGIN
              PRINT,'No new bins to mask based on numOrbLim thresh!'
           ENDELSE
        ENDIF

        ;; exc_orb_i = WHERE(h2dContribOrbStr.data LT alfDB_plot_struct.numOrbLim,nOrbLimExcl)
        ;; masked_i = WHERE(h2dStrArr[KEYWORD_SET(nPlots)].data GT 255,nAlreadyMasked)
        ;; PRINT,N_ELEMENTS(nOrbLimExcl) - N_ELEMENTS(CGSETINTERSECTION(exc_orb_i,masked_i))

        ;; h2dStrArr[KEYWORD_SET(nPlots)].data[WHERE(h2dContribOrbStr.data LT alfDB_plot_struct.numOrbLim)] = 255 ;mask 'em!

        ;;little check to see how many more elements are getting masked
        ;;8
     ENDIF
     
  ENDIF
  
  ;;########Probability of occurrence à la Chaston et al. [2007]########
  IF KEYWORD_SET(nOrbsWithEventsPerContribOrbsPlot) THEN BEGIN

     GET_CONTRIBUTING_ORBITS_PLOTDATA,MAXIMUS__maximus,plot_i, $
                                      MINM=MIMC_struct.minM, $
                                      MAXM=MIMC_struct.maxM, $
                                      BINM=MIMC_struct.binM, $
                                      SHIFTM=MIMC_struct.shiftM, $
                                      MINI=MIMC_struct.minI, $
                                      MAXI=MIMC_struct.maxI, $
                                      BINI=MIMC_struct.binI, $
                                      EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning, $
                                      DO_LSHELL=MIMC_struct.do_lShell, $
                                      MINL=MIMC_struct.minL, $
                                      MAXL=MIMC_struct.maxL, $
                                      BINL=MIMC_struct.binL, $
                                      LOGORBCONTRIBPLOT=log_nowepcoPlot, $
                                      ORBCONTRIBRANGE=nowepco_range, $
                                      ORBCONTRIBAUTOSCALE=nowepco_autoscale, $
                                      UNIQUEORBS_I=uniqueOrbs_wEvents_i, $
                                      H2D_NONZERO_CONTRIBORBS_I=h2d_nonzero_eventOrbs_i, $
                                      H2D_NONZERO_I=h2d_nonzero_contribOrbs_i, $
                                      H2DSTR=h2dNOrbsWEventsStr, $
                                      TMPLT_H2DSTR=tmplt_h2dStr, $ ;H2DFLUXN=h2dFluxN, $
                                      ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                                      DATANAME=dataName
     
     ;; h2dNOrbsWEventsStr.data[h2d_nonzero_contribOrbs_i] = h2dNOrbsWEventsStr.data[h2d_nonzero_contribOrbs_i]/h2dContribOrbStr.data[h2d_nonzero_contribOrbs_i]

     h2dStrArr=[h2dStrArr,h2dNOrbsWEventsStr] 
     IF alfDB_plot_struct.keepMe THEN dataNameArr=[dataNameArr,dataName] 
  ENDIF

  ;;########TOTAL Orbits########
  IF KEYWORD_SET(orbtotplot) OR KEYWORD_SET(orbfreqplot) $
     OR (KEYWORD_SET(nEventPerOrbPlot) AND KEYWORD_SET(divNEvByTotal)) THEN BEGIN
     GET_TOTAL_ORBITS_PLOTDATA,MAXIMUS__maximus, $
                               MINM=MIMC_struct.minM, $
                               MAXM=MIMC_struct.maxM, $
                               BINM=MIMC_struct.binM, $
                               SHIFTM=MIMC_struct.shiftM, $
                               MINI=MIMC_struct.minI, $
                               MAXI=MIMC_struct.maxI, $
                               BINI=MIMC_struct.binI, $
                               EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning, $
                               DO_LSHELL=MIMC_struct.do_lshell, $
                               MINL=MIMC_struct.minL, $
                               MAXL=MIMC_struct.maxL, $
                               BINL=MIMC_struct.binL, $
                               ORBTOTRANGE=orbTotRange, $
                               H2DSTR=h2dTotOrbStr, $
                               TMPLT_H2DSTR=tmplt_h2dStr, $
                               DATANAME=dataName, $
                               DATARAWPTR=dataRawPtr, $
                               KEEPME=alfDB_plot_struct.keepMe, $
                               UNIQUEORBS_I=uniqueOrbs_i, $
                               H2D_NONZERO_ALLORB_I=h2d_nonZero_allOrb_i, $
                               LUN=lun
     
     IF KEYWORD_SET(orbTotPlot) THEN BEGIN 
        h2dStrArr=[h2dStrArr,h2dTotOrbStr] 
        IF alfDB_plot_struct.keepMe THEN dataNameArr=[dataNameArr,dataName] 
     ENDIF
  ENDIF

  ;;########Orbit FREQUENCY########
  IF KEYWORD_SET(orbfreqplot) THEN BEGIN
     GET_ORBIT_FREQUENCY_PLOTDATA,MAXIMUS__maximus, $
                                  MINM=MIMC_struct.minM, $
                                  MAXM=MIMC_struct.maxM, $
                                  BINM=MIMC_struct.binM, $
                                  SHIFTM=MIMC_struct.shiftM, $
                                  MINI=MIMC_struct.minI, $
                                  MAXI=MIMC_struct.maxI, $
                                  BINI=MIMC_struct.binI, $
                                  EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning, $
                                  ORBFREQRANGE=orbFreqRange, $
                                  H2DSTR=h2dStr, $
                                  TMPLT_H2DSTR=tmplt_h2dStr, $
                                  H2DCONTRIBORBSTR=h2dContribOrbStr, $
                                  H2DTOTORBSTR=h2dTotOrbStr, $
                                  H2D_NONZERO_ALLORB_I=h2d_nonZero_allOrb_i, $
                                  H2D_NONZERO_CONTRIBORBS_I=h2d_nonzero_contribOrbs_i, $
                                  DATANAME=dataName
     
     h2dStrArr=[h2dStrArr,h2dStr] 
     IF alfDB_plot_struct.keepMe THEN dataNameArr=[dataNameArr,dataName] 
     
  ENDIF
  
  ;;########NEvents/orbit########
  IF KEYWORD_SET(nEventPerOrbPlot) THEN BEGIN 
     GET_NEVENTS_PER_ORBIT_PLOTDATA,MAXIMUS__maximus,plot_i, $
                                    MINM=MIMC_struct.minM, $
                                    MAXM=MIMC_struct.maxM, $
                                    BINM=MIMC_struct.binM, $
                                    SHIFTM=MIMC_struct.shiftM, $
                                    MINI=MIMC_struct.minI, $
                                    MAXI=MIMC_struct.maxI, $
                                    BINI=MIMC_struct.binI, $
                                    EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning, $
                                    DO_LSHELL=MIMC_struct.do_lshell, $
                                    MINL=MIMC_struct.minL, $
                                    MAXL=MIMC_struct.maxL, $
                                    BINL=MIMC_struct.binL, $
                                    NEVENTPERORBRANGE=nEventPerOrbRange, $
                                    NEVENTPERORBAUTOSCALE=nEventPerOrbAutoscale, $
                                    LOGNEVENTPERORB=logNEventPerOrb, $
                                    DIVNEVBYTOTAL=divNEvByTotal, $
                                    H2DSTR=h2dStr, $
                                    TMPLT_H2DSTR=tmplt_h2dStr, $
                                    H2DFLUXN=h2dFluxN, $
                                    H2D_NONZERO_NEV_I=hEv_nz_i, $
                                    H2D_NONZERO_CONTRIBORBS_I=h2d_nonZero_contribOrbs_i, $
                                    H2DCONTRIBORBSTR=h2dContribOrbStr, $
                                    H2DTOTORBSTR=h2dTotOrbStr, $
                                    DATANAME=dataName, $
                                    DATARAWPTR=dataRawPtr
     
     h2dStrArr=[h2dStrArr,h2dStr] 
     IF alfDB_plot_struct.keepMe THEN dataNameArr=[dataNameArr,dataName]
  ENDIF
  
  ;;########NEvents/minute########
  IF KEYWORD_SET(nEventPerMinPlot) THEN BEGIN

     FOR i=0,N_ELEMENTS(nEventPerMinPlot)-1 DO BEGIN

        nEvPMRange     = nEventPerMinRange[*,i]
        CASE N_ELEMENTS(logNEventPerMin) OF
           0:
           N_ELEMENTS(nEventPerMinPlot): logNEvPM = logNEventPerMin[i]
           ELSE: logNEvPM = logNEventPerMin
        ENDCASE
        CASE N_ELEMENTS(nEventPerMinAutoscale) OF
           0:
           N_ELEMENTS(nEventPerMinPlot): nEvPMAutoscale = nEventPerMinAutoscale[i]
           ELSE: nEvPMAutoscale = nEventPerMinAutoscale
        ENDCASE


        GET_NEVENTPERMIN_PLOTDATA,THISTDENOMINATOR=tHistDenominator, $
                                  MINM=MIMC_struct.minM, $
                                  MAXM=MIMC_struct.maxM, $
                                  BINM=MIMC_struct.binM, $
                                  SHIFTM=MIMC_struct.shiftM, $
                                  MINI=MIMC_struct.minI, $
                                  MAXI=MIMC_struct.maxI, $
                                  BINI=MIMC_struct.binI, $
                                  EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning, $
                                  DO_LSHELL=MIMC_struct.do_lshell, $
                                  MINL=MIMC_struct.minL, $
                                  MAXL=MIMC_struct.maxL, $
                                  BINL=MIMC_struct.binL, $
                                  LOGNEVENTPERMIN=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logNEvPM)), $
                                  NEVENTPERMINRANGE=nEvPMRange, $
                                  NEVENTPERMINAUTOSCALE=nEvPMAutoscale, $
                                  H2DSTR=h2dStr, $
                                  TMPLT_H2DSTR=tmplt_h2dStr, $
                                  H2DFLUXN=h2dFluxN, $
                                  H2D_NONZERO_NEV_I=hEv_nz_i, $
                                  DATANAME=dataName ; , $
        ;; DATARAWPTR=dataRawPtr
        
        h2dStrArr=[h2dStrArr,h2dStr] 
        IF alfDB_plot_struct.keepMe THEN BEGIN 
           dataNameArr=[dataNameArr,dataName] 
           ;; dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
        ENDIF 

     ENDFOR
  ENDIF
  
  ;;########Event probability########
  IF KEYWORD_SET(probOccurrencePlot) OR KEYWORD_SET(multiply_fluxes_by_probOccurrence) THEN BEGIN
     GET_PROB_OCCURRENCE_PLOTDATA,MAXIMUS__maximus,plot_i,tHistDenominator, $
                                  LOGPROBOCCURRENCE=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logProbOccurrence)), $
                                  PROBOCCURRENCERANGE=probOccurrenceRange, $
                                  PROBOCCURRENCEAUTOSCALE=probOccurrenceAutoscale, $
                                  DO_WIDTH_X=do_width_x, $
                                  MINM=MIMC_struct.minM, $
                                  MAXM=MIMC_struct.maxM, $
                                  BINM=MIMC_struct.binM, $
                                  SHIFTM=MIMC_struct.shiftM, $
                                  MINI=MIMC_struct.minI, $
                                  MAXI=MIMC_struct.maxI, $
                                  BINI=MIMC_struct.binI, $
                                  EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning, $
                                  DO_LSHELL=MIMC_struct.do_lshell, $
                                  MINL=MIMC_struct.minL, $
                                  MAXL=MIMC_struct.maxL, $
                                  BINL=MIMC_struct.binL, $
                                  OUTH2DBINSMLT=outH2DBinsMLT, $
                                  OUTH2DBINSILAT=outH2DBinsILAT, $
                                  OUTH2DBINSLSHELL=outH2DBinsLShell, $
                                  H2D_NONZERO_NEV_I=hEv_nz_i, $
                                  H2DFLUXN=h2dFluxN, $
                                  H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                                  OUT_H2DMASK=out_h2dMask, $
                                  OUT_H2DPROBOCC=H2DProbOcc, $
                                  H2DSTR=h2dStr, $
                                  TMPLT_H2DSTR=tmplt_h2dStr, $
                                  DATANAME=dataName, $
                                  DATARAWPTR=dataRawPtr
     
     h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

     IF KEYWORD_SET(probOccurrencePlot) THEN BEGIN
        h2dStrArr=[h2dStrArr,h2dStr] 
        IF alfDB_plot_struct.keepMe THEN BEGIN 
           dataNameArr=[dataNameArr,dataName] 
           dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
        ENDIF 
     ENDIF

  ENDIF

  ;;#####FLUX QUANTITIES#########
  ;;########ELECTRON FLUX########
  IF KEYWORD_SET(eplots) THEN BEGIN

     ;;Why ~KEYWORD_SET(no_maximus), you ask? Because if there's no maximus, we already have
     ;;the proper H2DFluxN
     IF KEYWORD_SET(eFlux_eSpec_data) AND ~KEYWORD_SET(alfDB_plot_struct.no_maximus) THEN BEGIN
        GET_H2D_NEVENTS_AND_MASK,IN_MLTS=in_MLTs, $
                                 IN_ILATS=in_ILATs, $
                                 ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                 IMF_STRUCT=IMF_struct, $
                                 MIMC_STRUCT=MIMC_struct, $
                                 NEVENTSPLOTRANGE=nEventsPlotRange, $
                                 NEVENTSPLOT__NOMASK=nEventsPlot__noMask, $
                                 TMPLT_H2DSTR=tmplt_h2dStr, $
                                 H2DSTR=tmpH2DStr, $
                                 H2DMASKSTR=tmpH2DMaskStr, $
                                 H2DFLUXN=tmpH2DFluxN, $
                                 H2D_NONZERO_NEV_I=tmphEv_nz_i, $
                                 MASKMIN=maskMin, $
                                 DATANAME=dataName, $
                                 DATARAWPTR=dataRawPtr

        tmpH2DMask            = tmpH2DMaskStr.data

     ENDIF ELSE BEGIN
        tmpH2DFluxN           = H2DFluxN
        tmphEv_nz_i  = hEv_nz_i
        tmpH2DMask            = h2dStrArr[KEYWORD_SET(nPlots)].data
     ENDELSE


     FOR i=0,N_ELEMENTS(eFluxPlotType)-1 DO BEGIN
        fluxPlotType = eFluxPlotType[i]

        IF KEYWORD_SET(alfDB_plot_struct.newell_analyze_eFlux) THEN BEGIN

           ;;pass all plot ranges to GET_NEWELL_FLUX_PLOTDATA
           plotRange          = ePlotRange
           noPosFlux          = N_ELEMENTS(noPosEFlux) GT 0 ? noPosEFlux : !NULL
           noNegFlux          = N_ELEMENTS(noNegEFlux) GT 0 ? noNegEFlux : !NULL
           absFlux            = N_ELEMENTS(absEFlux)   GT 0 ? absEFlux   : !NULL
           logPlot            = N_ELEMENTS(logEfPlot)  GT 0 ? logEfPlot  : !NULL

           GET_NEWELL_FLUX_PLOTDATA,MAXIMUS__maximus,plot_i,/GET_EFLUX, $
                                    ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                    IMF_STRUCT=IMF_struct, $
                                    MIMC_STRUCT=MIMC_struct, $
                                    OUTH2DBINSMLT=outH2DBinsMLT, $
                                    OUTH2DBINSILAT=outH2DBinsILAT, $
                                    OUTH2DBINSLSHELL=outH2DBinsLShell, $
                                    FLUXPLOTTYPE=fluxPlotType, $
                                    PLOTRANGE=plotRange, $
                                    PLOTAUTOSCALE=KEYWORD_SET(alfDB_plotLim_struct.autoscale_fluxPlots) OR KEYWORD_SET(autoscale_eplots), $
                                    NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
                                    REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
                                    REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
                                    NOPOSFLUX=noPosFlux, $
                                    NONEGFLUX=noNegFlux, $
                                    ABSFLUX=absFlux, $
                                    EFLUX_ESPEC_DATA=eFlux_eSpec_data, $
                                    INDICES__ESPEC=indices__eSpec, $
                                    COMBINE_ACCELERATED=alfDB_plot_struct.Newell__comb_accelerated, $
                                    ESPEC_MLT=eSpec__mlts, $
                                    ESPEC_ILAT=eSpec__ilats, $
                                    ESPEC_THISTDENOMINATOR=eSpec_tHistDenominator, $
                                    OUT_REMOVED_II=out_removed_ii, $
                                    LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logPlot)), $
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
                                    SHOW_INTEGRALS=show_integrals, $
                                    THISTDENOMINATOR=tHistDenominator, $
                                    DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                                    MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                                    MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                                    H2DPROBOCC=H2DProbOcc, $
                                    H2DSTRARR=h2dStrArr, $
                                    TMPLT_H2DSTR=tmplt_h2dStr, $
                                    H2D_NONZERO_NEV_I=tmphEv_nz_i, $
                                    H2DFLUXN=tmpH2DFluxN, $
                                    H2DMASK=tmpH2DMask, $
                                    OUT_H2DMASK=out_h2dMask, $
                                    DATANAMEARR=dataNameArr, $
                                    DATARAWPTRARR=dataRawPtrArr, $
                                    VARPLOTH2DINDS=varPlotH2DInds, $
                                    VARPLOTRAWINDS=varPlotRawInds, $
                                    REMOVED_II_LISTARR=removed_ii_listArr, $
                                    ;;VARPLOTISKEEPINDS=varPlotIsKeepInds, $
                                    MEDHISTOUTDATA=medHistOutData, $
                                    MEDHISTOUTTXT=medHistOutTxt, $
                                    MEDHISTDATADIR=txtOutputDir, $
                                    DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                                    ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                                    NEWELL_ANALYZE_MULTIPLY_BY_TYPE_PROBABILITY=newell_analyze_multiply_by_type_probability, $
                                    NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
                                    TXTOUTPUTDIR=txtOutputDir, $
                                    FANCY_PLOTNAMES=fancy_plotNames, $
                                    NPLOTS=nPlots, $
                                    MASKMIN=maskMin, $
                                    KEEPME=alfDB_plot_struct.keepMe, $
                                    LUN=lun

        ENDIF ELSE BEGIN        ;No newell analysis, just regular

           CASE N_ELEMENTS(noPosEFlux) OF
              0:   noPosFlux     = !NULL
              1:   noPosFlux     = noPosEFlux
              ELSE: noPosFlux    = noPosEFlux[i]
           ENDCASE

           CASE N_ELEMENTS(noNegEFlux) OF
              0:   noNegFlux     = !NULL
              1:   noNegFlux     = noNegEFlux
              ELSE: noNegFlux    = noNegEFlux[i]
           ENDCASE

           CASE N_ELEMENTS(absEFlux) OF
              0:   absFlux       = !NULL
              1:   absFlux       = absEFlux
              ELSE: absFlux      = absEFlux[i]
           ENDCASE

           CASE N_ELEMENTS(logEfPlot) OF
              0:   logPlot       = !NULL
              1:   logPlot       = logEfPlot
              ELSE: logPlot      = logEfPlot[i]
           ENDCASE

           dims                  = SIZE(ePlotRange,/DIMENSIONS)
           CASE N_ELEMENTS(dims) OF 
              0:   plotRange     = !NULL
              1: BEGIN
                 CASE dims OF
                    0: plotRange = !NULL
                    2: plotRange = ePlotRange
                    ELSE: BEGIN
                    END
                 ENDCASE
              END
              2:   plotRange     = ePlotRange[*,i]
           ENDCASE

           GET_FLUX_PLOTDATA,MAXIMUS__maximus,plot_i,/GET_EFLUX, $
                             ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                             IMF_STRUCT=IMF_struct, $
                             MIMC_STRUCT=MIMC_struct, $
                             OUTH2DBINSMLT=outH2DBinsMLT, $
                             OUTH2DBINSILAT=outH2DBinsILAT, $
                             OUTH2DBINSLSHELL=outH2DBinsLShell, $
                             FLUXPLOTTYPE=fluxPlotType, $
                             PLOTRANGE=plotRange, $
                             PLOTAUTOSCALE=KEYWORD_SET(alfDB_plotLim_struct.autoscale_fluxPlots) OR KEYWORD_SET(autoscale_eplots), $
                             NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
                             REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
                             REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
                             NOPOSFLUX=noPosFlux, $
                             NONEGFLUX=noNegFlux, $
                             ABSFLUX=absFlux, $
                             EFLUX_ESPEC_DATA=eFlux_eSpec_data, $
                             INDICES__ESPEC=indices__eSpec, $
                             ESPEC_MLT=eSpec__mlts, $
                             ESPEC_ILAT=eSpec__ilats, $
                             ESPEC_THISTDENOMINATOR=eSpec_tHistDenominator, $
                             OUT_REMOVED_II=out_removed_ii, $
                             LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logPlot)), $
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
                             SHOW_INTEGRALS=show_integrals, $
                             THISTDENOMINATOR=tHistDenominator, $
                             DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                             MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                             MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                             H2DPROBOCC=H2DProbOcc, $
                             H2DSTR=h2dStr, $
                             TMPLT_H2DSTR=tmplt_h2dStr, $
                             H2D_NONZERO_NEV_I=tmphEv_nz_i, $
                             H2DFLUXN=tmpH2DFluxN, $
                             H2DMASK=tmpH2DMask, $
                             OUT_H2DMASK=out_h2dMask, $
                             DATANAME=dataName, $
                             DATARAWPTR=dataRawPtr, $
                             MEDHISTOUTDATA=medHistOutData, $
                             MEDHISTOUTTXT=medHistOutTxt, $
                             MEDHISTDATADIR=txtOutputDir, $
                             DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                             ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                             FANCY_PLOTNAMES=fancy_plotNames

           
           IF ~KEYWORD_SET(eFlux_eSpec_data) THEN h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

           h2dStrArr            = [h2dStrArr,h2dStr] 
           IF alfDB_plot_struct.keepMe THEN BEGIN
              dataNameArr       = [dataNameArr,dataName] 
              dataRawPtrArr     =[dataRawPtrArr,dataRawPtr] 
              varPlotH2DInds  = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
              varPlotRawInds  = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
              removed_ii_listArr = [removed_ii_listArr,LIST(out_removed_ii)]
              ;;varplotiskeepInds = [varPlotIsKeepInds,0]
           ENDIF 

           IF KEYWORD_SET(do_grossRate_fluxQuantities) $
              OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
              grossConvFactorArr   = [grossConvFactorArr,grossConvFactor]
           ENDIF

        ENDELSE

     ENDFOR
  ENDIF
  
  ;;########ELECTRON NUMBER FLUX########
  IF KEYWORD_SET(eNumFlPlots) THEN BEGIN

     IF KEYWORD_SET(eNumFlux_eSpec_data) THEN BEGIN
        GET_H2D_NEVENTS_AND_MASK,IN_MLTS=in_MLTs, $
                                 IN_ILATS=in_ILATs, $
                                 ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                 IMF_STRUCT=IMF_struct, $
                                 MIMC_STRUCT=MIMC_struct, $
                                 NEVENTSPLOTRANGE=nEventsPlotRange, $
                                 NEVENTSPLOT__NOMASK=nEventsPlot__noMask, $
                                 TMPLT_H2DSTR=tmplt_h2dStr, $
                                 H2DSTR=tmpH2DStr, $
                                 H2DMASKSTR=tmpH2DMaskStr, $
                                 H2DFLUXN=tmpH2DFluxN, $
                                 H2D_NONZERO_NEV_I=tmphEv_nz_i, $
                                 MASKMIN=maskMin, $
                                 DATANAME=dataName, $
                                 DATARAWPTR=dataRawPtr
        
        tmpH2DMask            = tmpH2DMaskStr.data
        
     ENDIF ELSE BEGIN
        tmpH2DFluxN           = H2DFluxN
        tmphEv_nz_i           = hEv_nz_i
        tmpH2DMask            = h2dStrArr[KEYWORD_SET(nPlots)].data
     ENDELSE

     FOR i=0,N_ELEMENTS(eNumFlPlotType)-1 DO BEGIN
        fluxPlotType = eNumFlPlotType[i]

        IF KEYWORD_SET(alfDB_plot_struct.newell_analyze_eFlux) THEN BEGIN
           ;;A temporary kluge
           ;; IF N_ELEMENTS(eNumFlPlotRange) GT 2 THEN BEGIN
           ;;    plotRange     = eNumFlPlotRange[*,1]
           ;; ENDIF

           ;;pass all plot ranges to GET_NEWELL_FLUX_PLOTDATA
           plotRange          = eNumFlPlotRange
           noPosFlux          = N_ELEMENTS(noPosENumFl)   GT 0 ? noPosENumFl : !NULL
           noNegFlux          = N_ELEMENTS(noNegENumFl)   GT 0 ? noNegENumFl : !NULL
           absFlux            = N_ELEMENTS(absENumFl)     GT 0 ? absENumFl   : !NULL
           logPlot            = N_ELEMENTS(logENumFlPlot) GT 0 ? logENumFlPlot  : !NULL

           GET_NEWELL_FLUX_PLOTDATA,MAXIMUS__maximus,plot_i,/GET_ENUMFLUX, $
                                    ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                    IMF_STRUCT=IMF_struct, $
                                    MIMC_STRUCT=MIMC_struct, $
                                    OUTH2DBINSMLT=outH2DBinsMLT, $
                                    OUTH2DBINSILAT=outH2DBinsILAT, $
                                    OUTH2DBINSLSHELL=outH2DBinsLShell, $
                                    FLUXPLOTTYPE=fluxPlotType, $
                                    PLOTRANGE=plotRange, $
                                    PLOTAUTOSCALE=KEYWORD_SET(alfDB_plotLim_struct.autoscale_fluxPlots) OR KEYWORD_SET(autoscale_eNumFlplots), $
                                    NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
                                    REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
                                    REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
                                    NOPOSFLUX=noPosFlux, $
                                    NONEGFLUX=noNegFlux, $
                                    ABSFLUX=absFlux, $
                                    ENUMFLUX_ESPEC_DATA=eNumFlux_eSpec_data, $
                                    INDICES__ESPEC=indices__eSpec, $
                                    COMBINE_ACCELERATED=alfDB_plot_struct.Newell__comb_accelerated, $
                                    ESPEC_MLT=eSpec__mlts, $
                                    ESPEC_ILAT=eSpec__ilats, $
                                    ESPEC_THISTDENOMINATOR=eSpec_tHistDenominator, $
                                    OUT_REMOVED_II=out_removed_ii, $
                                    LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logPlot)), $
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
                                    SHOW_INTEGRALS=show_integrals, $
                                    THISTDENOMINATOR=tHistDenominator, $
                                    DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                                    MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                                    MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                                    H2DPROBOCC=H2DProbOcc, $
                                    H2DSTRARR=h2dStrArr, $
                                    TMPLT_H2DSTR=tmplt_h2dStr, $
                                    H2D_NONZERO_NEV_I=tmphEv_nz_i, $
                                    H2DFLUXN=tmpH2DFluxN, $
                                    H2DMASK=tmpH2DMask, $
                                    OUT_H2DMASK=out_h2dMask, $
                                    DATANAMEARR=dataNameArr, $
                                    DATARAWPTRARR=dataRawPtrArr, $
                                    VARPLOTH2DINDS=varPlotH2DInds, $
                                    VARPLOTRAWINDS=varPlotRawInds, $
                                    REMOVED_II_LISTARR=removed_ii_listArr, $
                                    ;;VARPLOTISKEEPINDS=varPlotIsKeepInds, $
                                    MEDHISTOUTDATA=medHistOutData, $
                                    MEDHISTOUTTXT=medHistOutTxt, $
                                    MEDHISTDATADIR=txtOutputDir, $
                                    DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                                    ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                                    NEWELL_ANALYZE_MULTIPLY_BY_TYPE_PROBABILITY=newell_analyze_multiply_by_type_probability, $
                                    NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
                                    FANCY_PLOTNAMES=fancy_plotNames, $
                                    NPLOTS=nPlots, $
                                    MASKMIN=maskMin, $
                                    KEEPME=alfDB_plot_struct.keepMe, $
                                    LUN=lun

        ENDIF ELSE BEGIN        ;No newell analysis, just regular

           CASE N_ELEMENTS(noPosENumFl) OF
              0:   noPosFlux     = !NULL
              1:   noPosFlux     = noPosENumFl
              ELSE: noPosFlux    = noPosENumFl[i]
           ENDCASE

           CASE N_ELEMENTS(noNegENumFl) OF
              0:   noNegFlux     = !NULL
              1:   noNegFlux     = noNegENumFl
              ELSE: noNegFlux    = noNegENumFl[i]
           ENDCASE

           CASE N_ELEMENTS(absENumFl) OF
              0:   absFlux       = !NULL
              1:   absFlux       = absENumFl
              ELSE: absFlux      = absENumFl[i]
           ENDCASE

           CASE N_ELEMENTS(logENumFlPlot) OF
              0:   logPlot       = !NULL
              1:   logPlot       = logENumFlPlot
              ELSE: logPlot      = logENumFlPlot[i]
           ENDCASE

           dims                  = SIZE(eNumFlPlotRange,/DIMENSIONS)
           CASE N_ELEMENTS(dims) OF 
              0:   plotRange     = !NULL
              1: BEGIN
                 CASE dims OF
                    0: plotRange = !NULL
                    2: plotRange = eNumFlPlotRange
                    ELSE: BEGIN
                    END
                 ENDCASE
              END
              2:   plotRange     = eNumFlPlotRange[*,i]
           ENDCASE

           GET_FLUX_PLOTDATA,MAXIMUS__maximus,plot_i,/GET_ENUMFLUX, $
                             ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                             IMF_STRUCT=IMF_struct, $
                             MIMC_STRUCT=MIMC_struct, $
                             OUTH2DBINSMLT=outH2DBinsMLT, $
                             OUTH2DBINSILAT=outH2DBinsILAT, $
                             OUTH2DBINSLSHELL=outH2DBinsLShell, $
                             FLUXPLOTTYPE=fluxPlotType, $
                             PLOTRANGE=plotRange, $
                             PLOTAUTOSCALE=KEYWORD_SET(alfDB_plotLim_struct.autoscale_fluxPlots) OR KEYWORD_SET(autoscale_eNumFlplots), $
                             NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
                             REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
                             REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
                             NOPOSFLUX=noPosFlux, $
                             NONEGFLUX=noNegFlux, $
                             ABSFLUX=absFlux, $
                             ENUMFLUX_ESPEC_DATA=eNumFlux_eSpec_data, $
                             INDICES__ESPEC=indices__eSpec, $
                             ESPEC_MLT=eSpec__mlts, $
                             ESPEC_ILAT=eSpec__ilats, $
                             ESPEC_THISTDENOMINATOR=eSpec_tHistDenominator, $
                             OUT_REMOVED_II=out_removed_ii, $
                             LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logPlot)), $
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
                             SHOW_INTEGRALS=show_integrals, $
                             THISTDENOMINATOR=tHistDenominator, $
                             DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                             MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                             MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                             H2DPROBOCC=H2DProbOcc, $
                             H2DSTR=h2dStr, $
                             TMPLT_H2DSTR=tmplt_h2dStr, $
                             H2D_NONZERO_NEV_I=tmphEv_nz_i, $
                             H2DFLUXN=tmpH2DFluxN, $
                             H2DMASK=tmpH2DMask, $
                             OUT_H2DMASK=out_h2dMask, $
                             DATANAME=dataName, $
                             DATARAWPTR=dataRawPtr, $
                             MEDHISTOUTDATA=medHistOutData, $
                             MEDHISTOUTTXT=medHistOutTxt, $
                             MEDHISTDATADIR=txtOutputDir, $
                             DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                             ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                             FANCY_PLOTNAMES=fancy_plotNames

           IF ~KEYWORD_SET(eNumFlux_eSpec_data) THEN h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

           h2dStrArr             = [h2dStrArr,h2dStr] 
           IF alfDB_plot_struct.keepMe THEN BEGIN 
              dataNameArr        = [dataNameArr,dataName] 
              dataRawPtrArr      = [dataRawPtrArr,dataRawPtr] 
              varPlotH2DInds     = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
              varPlotRawInds     = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
              removed_ii_listArr = [removed_ii_listArr,LIST(out_removed_ii)]
              ;;varplotiskeepInds  = [varPlotIsKeepInds,0]                 
           ENDIF 
           
           IF KEYWORD_SET(do_grossRate_fluxQuantities) $
              OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
              grossConvFactorArr   = [grossConvFactorArr,grossConvFactor]
           ENDIF

        ENDELSE
     ENDFOR
  ENDIF
  
  ;;########Poynting Flux########
  IF KEYWORD_SET(pplots) THEN BEGIN
     GET_FLUX_PLOTDATA,MAXIMUS__maximus,plot_i,$
                       /GET_PFLUX, $
                       ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                       IMF_STRUCT=IMF_struct, $
                       MIMC_STRUCT=MIMC_struct, $
                       OUTH2DBINSMLT=outH2DBinsMLT, $
                       OUTH2DBINSILAT=outH2DBinsILAT, $
                       OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       PLOTRANGE=PPlotRange, $
                       PLOTAUTOSCALE=KEYWORD_SET(alfDB_plotLim_struct.autoscale_fluxPlots) OR KEYWORD_SET(autoscale_pPlots), $
                       NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
                       REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
                       REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
                       NOPOSFLUX=noPosPflux, $
                       NONEGFLUX=noNegPflux, $
                       ABSFLUX=absPflux, $
                       OUT_REMOVED_II=out_removed_ii, $
                       LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logPfPlot)), $
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
                       SHOW_INTEGRALS=show_integrals, $
                       THISTDENOMINATOR=tHistDenominator, $
                       DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                       MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                       MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                       H2DPROBOCC=H2DProbOcc, $
                       H2DSTR=h2dStr, $
                       TMPLT_H2DSTR=tmplt_h2dStr, $
                       H2D_NONZERO_NEV_I=hEv_nz_i, $
                       H2DFLUXN=h2dFluxN, $
                       H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                       OUT_H2DMASK=out_h2dMask, $
                       DATANAME=dataName, $
                       DATARAWPTR=dataRawPtr, $
                       MEDHISTOUTDATA=medHistOutData, $
                       MEDHISTOUTTXT=medHistOutTxt, $
                       MEDHISTDATADIR=txtOutputDir, $
                       DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                       ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                       FANCY_PLOTNAMES=fancy_plotNames
     
     h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

     h2dStrArr             = [h2dStrArr,h2dStr] 
     IF alfDB_plot_struct.keepMe THEN BEGIN 
        dataNameArr        = [dataNameArr,dataName] 
        dataRawPtrArr      = [dataRawPtrArr,dataRawPtr] 
        varPlotH2DInds     = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
        varPlotRawInds     = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
        removed_ii_listArr = [removed_ii_listArr,LIST(out_removed_ii)]
        ;;varplotiskeepInds  = [varPlotIsKeepInds,0]
     ENDIF  
     
     IF KEYWORD_SET(do_grossRate_fluxQuantities) $
        OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        grossConvFactorArr = [grossConvFactorArr,grossConvFactor]
     ENDIF

  ENDIF
  
  ;;########ION FLUX########
  IF KEYWORD_SET(ionPlots) THEN BEGIN
     IF N_ELEMENTS(iFlux_eSpec_data) GT 0 OR N_ELEMENTS(iNumFlux_eSpec_data) GT 0 THEN BEGIN
        GET_H2D_NEVENTS_AND_MASK,IN_MLTS=in_MLTs, $
                                 IN_ILATS=in_MLTs, $
                                 ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                 IMF_STRUCT=IMF_struct, $
                                 MIMC_STRUCT=MIMC_struct, $
                                 NEVENTSPLOTRANGE=nEventsPlotRange, $
                                 NEVENTSPLOT__NOMASK=nEventsPlot__noMask, $
                                 TMPLT_H2DSTR=tmplt_h2dStr, $
                                 H2DSTR=tmpH2DStr, $
                                 H2DMASKSTR=tmpH2DMaskStr, $
                                 H2DFLUXN=tmpH2DFluxN, $
                                 H2D_NONZERO_NEV_I=tmphEv_nz_i, $
                                 MASKMIN=maskMin, $
                                 DATANAME=dataName, $
                                 DATARAWPTR=dataRawPtr
        
        tmpH2DMask            = tmpH2DMaskStr.data

     ENDIF ELSE BEGIN
        tmpH2DFluxN           = H2DFluxN
        tmphEv_nz_i  = hEv_nz_i
        tmpH2DMask            = h2dStrArr[KEYWORD_SET(nPlots)].data
     ENDELSE

     FOR i=0,N_ELEMENTS(iFluxPlotType)-1 DO BEGIN
        fluxPlotType = iFluxPlotType[i]

        CASE N_ELEMENTS(noPosIFlux) OF
           0:   noPosFlux     = !NULL
           1:   noPosFlux     = noPosIFlux
           ELSE: noPosFlux    = noPosIFlux[i]
        ENDCASE

        CASE N_ELEMENTS(noNegIFlux) OF
           0:   noNegFlux     = !NULL
           1:   noNegFlux     = noNegIFlux
           ELSE: noNegFlux    = noNegIFlux[i]
        ENDCASE

        CASE N_ELEMENTS(absIFlux) OF
           0:   absFlux       = !NULL
           1:   absFlux       = absIFlux
           ELSE: absFlux      = absIFlux[i]
        ENDCASE

        CASE N_ELEMENTS(logIfPlot) OF
           0:   logPlot       = !NULL
           1:   logPlot       = logIfPlot
           ELSE: logPlot      = logIfPlot[i]
        ENDCASE

        dims                  = SIZE(iPlotRange,/DIMENSIONS)
        CASE N_ELEMENTS(dims) OF 
           0:   plotRange     = !NULL
           1: BEGIN
              CASE dims OF
                 0: plotRange = !NULL
                 2: plotRange = iPlotRange
                 ELSE: BEGIN
                 END
              ENDCASE
           END
           2:   plotRange     = iPlotRange[*,i]
        ENDCASE
        GET_FLUX_PLOTDATA,MAXIMUS__maximus,plot_i,/GET_IFLUX, $
                          ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                          IMF_STRUCT=IMF_struct, $
                          MIMC_STRUCT=MIMC_struct, $
                          OUTH2DBINSMLT=outH2DBinsMLT, $
                          OUTH2DBINSILAT=outH2DBinsILAT, $
                          OUTH2DBINSLSHELL=outH2DBinsLShell, $
                          FLUXPLOTTYPE=fluxPlotType, $
                          PLOTRANGE=plotRange, $
                          PLOTAUTOSCALE=KEYWORD_SET(alfDB_plotLim_struct.autoscale_fluxPlots) OR KEYWORD_SET(autoscale_ionPlots), $
                          NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
                          REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
                          REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
                          NOPOSFLUX=noPosFlux, $
                          NONEGFLUX=noNegFlux, $
                          ABSFLUX=absFlux, $
                          IFLUX_ESPEC_DATA=iFlux_eSpec_data, $
                          INUMFLUX_ESPEC_DATA=iNumFlux_eSpec_data, $
                          INDICES__ION=indices__ion, $
                          ION_DELTA_T=ion_delta_t, $
                          ESPEC_MLT=ion__mlts, $
                          ESPEC_ILAT=ion__ilats, $
                          ESPEC_THISTDENOMINATOR=eSpec_tHistDenominator, $
                          OUT_REMOVED_II=out_removed_ii, $
                          LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logPlot)), $
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
                          SHOW_INTEGRALS=show_integrals, $
                          THISTDENOMINATOR=tHistDenominator, $
                          DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                          MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                          MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                          H2DPROBOCC=H2DProbOcc, $
                          H2DSTR=h2dStr, $
                          TMPLT_H2DSTR=tmplt_h2dStr, $
                          H2D_NONZERO_NEV_I=tmphEv_nz_i, $
                          H2DFLUXN=tmpH2DFluxN, $
                          H2DMASK=tmpH2DMask, $
                          OUT_H2DMASK=out_h2dMask, $
                          DATANAME=dataName, $
                          DATARAWPTR=dataRawPtr, $
                          MEDHISTOUTDATA=medHistOutData, $
                          MEDHISTOUTTXT=medHistOutTxt, $
                          MEDHISTDATADIR=txtOutputDir, $
                          DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                          ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                          FANCY_PLOTNAMES=fancy_plotNames
        
        IF ~KEYWORD_SET(iNumFlux_eSpec_data) AND ~KEYWORD_SET(iFlux_eSpec_data) THEN h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

        h2dStrArr             = [h2dStrArr,h2dStr] 
        IF alfDB_plot_struct.keepMe THEN BEGIN 
           dataNameArr        = [dataNameArr,dataName] 
           dataRawPtrArr      = [dataRawPtrArr,dataRawPtr] 
           varPlotH2DInds     = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
           varPlotRawInds     = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
           removed_ii_listArr = [removed_ii_listArr,LIST(out_removed_ii)]
           ;;varplotiskeepInds  = [varPlotIsKeepInds,0]
        ENDIF  
        
        IF KEYWORD_SET(do_grossRate_fluxQuantities) $
           OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
           grossConvFactorArr = [grossConvFactorArr,grossConvFactor]
        ENDIF

     ENDFOR
  ENDIF

  ;;########OXY FLUX########
  IF KEYWORD_SET(oxyPlots) THEN BEGIN
     GET_FLUX_PLOTDATA,MAXIMUS__maximus,plot_i,/GET_OXYFLUX, $
                       ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                       IMF_STRUCT=IMF_struct, $
                       MIMC_STRUCT=MIMC_struct, $
                       OUTH2DBINSMLT=outH2DBinsMLT, $
                       OUTH2DBINSILAT=outH2DBinsILAT, $
                       OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       FLUXPLOTTYPE=oxyFluxPlotType, $
                       PLOTRANGE=oxyPlotRange, $
                       PLOTAUTOSCALE=KEYWORD_SET(alfDB_plotLim_struct.autoscale_fluxPlots) OR KEYWORD_SET(autoscale_oxyPlots), $
                       NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
                       REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
                       REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
                       NOPOSFLUX=noPosOxyFlux, $
                       NONEGFLUX=noNegOxyflux, $
                       ABSFLUX=absOxyFlux, $
                       OUT_REMOVED_II=out_removed_ii, $
                       LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logOxyfPlot)), $
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
                       SHOW_INTEGRALS=show_integrals, $
                       THISTDENOMINATOR=tHistDenominator, $
                       DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                       MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                       MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                       H2DPROBOCC=H2DProbOcc, $
                       H2DSTR=h2dStr, $
                       TMPLT_H2DSTR=tmplt_h2dStr, $
                       H2D_NONZERO_NEV_I=hEv_nz_i, $
                       H2DFLUXN=h2dFluxN, $
                       H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                       OUT_H2DMASK=out_h2dMask, $
                       DATANAME=dataName, $
                       DATARAWPTR=dataRawPtr, $
                       MEDHISTOUTDATA=medHistOutData, $
                       MEDHISTOUTTXT=medHistOutTxt, $
                       MEDHISTDATADIR=txtOutputDir, $
                       DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                       ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                       FANCY_PLOTNAMES=fancy_plotNames
     
     h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

     h2dStrArr              = [h2dStrArr,h2dStr] 
     IF alfDB_plot_struct.keepMe THEN BEGIN 
        dataNameArr         = [dataNameArr,dataName] 
        dataRawPtrArr       = [dataRawPtrArr,dataRawPtr] 
        varPlotH2DInds      = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
        varPlotRawInds      = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
        removed_ii_listArr  = [removed_ii_listArr,LIST(out_removed_ii)]
        ;;varPlotIsKeepInds   = [varPlotIsKeepInds,0]
     ENDIF  
     
     IF KEYWORD_SET(do_grossRate_fluxQuantities) $
        OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        grossConvFactorArr  = [grossConvFactorArr,grossConvFactor]
     ENDIF

  ENDIF

  ;;########CHARACTERISTIC ELECTRON ENERGY########
  IF KEYWORD_SET(charEPlots) THEN BEGIN

     ;;Why ~KEYWORD_SET(no_maximus), you ask? Because if there's no maximus, we already have
     ;;the proper H2DFluxN
     IF KEYWORD_SET(eFlux_eSpec_data) AND ~KEYWORD_SET(alfDB_plot_struct.no_maximus) THEN BEGIN
        GET_H2D_NEVENTS_AND_MASK,IN_MLTS=in_MLTs, $
                                 IN_ILATS=in_ILATs, $
                                 ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                 IMF_STRUCT=IMF_struct, $
                                 MIMC_STRUCT=MIMC_struct, $
                                 NEVENTSPLOTRANGE=nEventsPlotRange, $
                                 NEVENTSPLOT__NOMASK=nEventsPlot__noMask, $
                                 TMPLT_H2DSTR=tmplt_h2dStr, $
                                 H2DSTR=tmpH2DStr, $
                                 H2DMASKSTR=tmpH2DMaskStr, $
                                 H2DFLUXN=tmpH2DFluxN, $
                                 H2D_NONZERO_NEV_I=tmphEv_nz_i, $
                                 MASKMIN=maskMin, $
                                 DATANAME=dataName, $
                                 DATARAWPTR=dataRawPtr

        tmpH2DMask            = tmpH2DMaskStr.data

     ENDIF ELSE BEGIN
        tmpH2DFluxN           = H2DFluxN
        tmphEv_nz_i  = hEv_nz_i
        tmpH2DMask            = h2dStrArr[KEYWORD_SET(nPlots)].data
     ENDELSE



     FOR i=0,N_ELEMENTS(charEType)-1 DO BEGIN
        fluxPlotType = charEType[i]

        IF KEYWORD_SET(alfDB_plot_struct.newell_analyze_eFlux) THEN BEGIN

           ;;pass all plot ranges to GET_NEWELL_FLUX_PLOTDATA
           plotRange          = charEPlotRange
           noPosFlux          = N_ELEMENTS(noPosCharE)   GT 0 ? noPosCharE   : !NULL
           noNegFlux          = N_ELEMENTS(noNegCharE)   GT 0 ? noNegCharE   : !NULL
           absFlux            = N_ELEMENTS(absCharE)     GT 0 ? absCharE     : !NULL
           logPlot            = N_ELEMENTS(logCharEPlot) GT 0 ? logCharEPlot : !NULL

           GET_NEWELL_FLUX_PLOTDATA,MAXIMUS__maximus,plot_i,/GET_CHAREE, $
                                    ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                    IMF_STRUCT=IMF_struct, $
                                    MIMC_STRUCT=MIMC_struct, $
                                    OUTH2DBINSMLT=outH2DBinsMLT, $
                                    OUTH2DBINSILAT=outH2DBinsILAT, $
                                    OUTH2DBINSLSHELL=outH2DBinsLShell, $
                                    FLUXPLOTTYPE=fluxPlotType, $
                                    PLOTRANGE=plotRange, $
                                    PLOTAUTOSCALE=KEYWORD_SET(alfDB_plotLim_struct.autoscale_fluxPlots) OR KEYWORD_SET(autoscale_eplots), $
                                    NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
                                    REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
                                    REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
                                    NOPOSFLUX=noPosFlux, $
                                    NONEGFLUX=noNegFlux, $
                                    ABSFLUX=absFlux, $
                                    EFLUX_ESPEC_DATA=eFlux_eSpec_data, $
                                    INDICES__ESPEC=indices__eSpec, $
                                    COMBINE_ACCELERATED=alfDB_plot_struct.Newell__comb_accelerated, $
                                    ESPEC_MLT=eSpec__mlts, $
                                    ESPEC_ILAT=eSpec__ilats, $
                                    ESPEC_THISTDENOMINATOR=eSpec_tHistDenominator, $
                                    OUT_REMOVED_II=out_removed_ii, $
                                    LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logPlot)), $
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
                                    SHOW_INTEGRALS=show_integrals, $
                                    THISTDENOMINATOR=tHistDenominator, $
                                    DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                                    MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                                    MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                                    H2DPROBOCC=H2DProbOcc, $
                                    H2DSTRARR=h2dStrArr, $
                                    TMPLT_H2DSTR=tmplt_h2dStr, $
                                    H2D_NONZERO_NEV_I=tmphEv_nz_i, $
                                    H2DFLUXN=tmpH2DFluxN, $
                                    H2DMASK=tmpH2DMask, $
                                    OUT_H2DMASK=out_h2dMask, $
                                    DATANAMEARR=dataNameArr, $
                                    DATARAWPTRARR=dataRawPtrArr, $
                                    VARPLOTH2DINDS=varPlotH2DInds, $
                                    VARPLOTRAWINDS=varPlotRawInds, $
                                    REMOVED_II_LISTARR=removed_ii_listArr, $
                                    ;;VARPLOTISKEEPINDS=varPlotIsKeepInds, $
                                    MEDHISTOUTDATA=medHistOutData, $
                                    MEDHISTOUTTXT=medHistOutTxt, $
                                    MEDHISTDATADIR=txtOutputDir, $
                                    DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                                    ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                                    NEWELL_ANALYZE_MULTIPLY_BY_TYPE_PROBABILITY=newell_analyze_multiply_by_type_probability, $
                                    NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
                                    TXTOUTPUTDIR=txtOutputDir, $
                                    FANCY_PLOTNAMES=fancy_plotNames, $
                                    NPLOTS=nPlots, $
                                    MASKMIN=maskMin, $
                                    KEEPME=alfDB_plot_struct.keepMe, $
                                    LUN=lun

        ENDIF ELSE BEGIN        ;No newell analysis, just regular


           CASE N_ELEMENTS(logCharEPlot) OF
              0:   logPlot       = !NULL
              1:   logPlot       = logCharEPlot
              ELSE: logPlot      = logCharEPlot[i]
           ENDCASE

           dims                  = SIZE(charEPlotRange,/DIMENSIONS)
           CASE N_ELEMENTS(dims) OF 
              0:   plotRange     = !NULL
              1: BEGIN
                 CASE dims OF
                    0: plotRange = !NULL
                    2: plotRange = charEPlotRange
                    ELSE: BEGIN
                    END
                 ENDCASE
              END
              2:   plotRange     = charEPlotRange[*,i]
           ENDCASE
           GET_FLUX_PLOTDATA,MAXIMUS__maximus,plot_i,/GET_CHAREE, $
                             ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                             IMF_STRUCT=IMF_struct, $
                             MIMC_STRUCT=MIMC_struct, $
                             OUTH2DBINSMLT=outH2DBinsMLT, $
                             OUTH2DBINSILAT=outH2DBinsILAT, $
                             OUTH2DBINSLSHELL=outH2DBinsLShell, $
                             FLUXPLOTTYPE=charEType, $
                             PLOTRANGE=plotRange, $
                             PLOTAUTOSCALE=KEYWORD_SET(alfDB_plotLim_struct.autoscale_fluxPlots) OR KEYWORD_SET(autoscale_charEPlots), $
                             NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
                             REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
                             REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
                             NOPOSFLUX=noPosCharE, $
                             NONEGFLUX=noNegCharE, $
                             ABSFLUX=absCharE, $
                             OUT_REMOVED_II=out_removed_ii, $
                             LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logPlot)), $
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
                             SHOW_INTEGRALS=show_integrals, $
                             THISTDENOMINATOR=tHistDenominator, $
                             DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                             MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                             MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                             H2DPROBOCC=H2DProbOcc, $
                             H2DSTR=h2dStr, $
                             TMPLT_H2DSTR=tmplt_h2dStr, $
                             H2D_NONZERO_NEV_I=hEv_nz_i, $
                             H2DFLUXN=h2dFluxN, $
                             H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                             OUT_H2DMASK=out_h2dMask, $
                             DATANAME=dataName, $
                             DATARAWPTR=dataRawPtr, $
                             MEDHISTOUTDATA=medHistOutData, $
                             MEDHISTOUTTXT=medHistOutTxt, $
                             MEDHISTDATADIR=txtOutputDir, $
                             DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                             ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                             FANCY_PLOTNAMES=fancy_plotNames

           IF ~KEYWORD_SET(eFlux_eSpec_data) THEN h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

           h2dStrArr              = [h2dStrArr,h2dStr] 
           IF alfDB_plot_struct.keepMe THEN BEGIN 
              dataNameArr         = [dataNameArr,dataName] 
              dataRawPtrArr       = [dataRawPtrArr,dataRawPtr] 
              varPlotH2DInds      = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
              varPlotRawInds      = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
              removed_ii_listArr  = [removed_ii_listArr,LIST(out_removed_ii)]
              ;;varplotiskeepInds   = [varPlotIsKeepInds,0]
           ENDIF  
           
           IF KEYWORD_SET(do_grossRate_fluxQuantities) $
              OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
              grossConvFactorArr  = [grossConvFactorArr,grossConvFactor]
           ENDIF

        ENDELSE

     ENDFOR
  ENDIF
  
  ;;########CHARACTERISTIC ION ENERGY########
  IF KEYWORD_SET(chariEPlots) THEN BEGIN
     GET_FLUX_PLOTDATA,MAXIMUS__maximus,plot_i,/GET_CHARIE, $
                       ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                       IMF_STRUCT=IMF_struct, $
                       MIMC_STRUCT=MIMC_struct, $
                       OUTH2DBINSMLT=outH2DBinsMLT, $
                       OUTH2DBINSILAT=outH2DBinsILAT, $
                       OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       PLOTRANGE=chariEPlotRange, $
                       PLOTAUTOSCALE=KEYWORD_SET(alfDB_plotLim_struct.autoscale_fluxPlots) OR KEYWORD_SET(autoscale_chariEPlots), $
                       NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
                       REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
                       REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
                       NOPOSFLUX=noPosChariE, $
                       NONEGFLUX=noNegChariE, $
                       ABSFLUX=absChariE, $
                       OUT_REMOVED_II=out_removed_ii, $
                       LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logChariEPlot)), $
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
                       SHOW_INTEGRALS=show_integrals, $
                       THISTDENOMINATOR=tHistDenominator, $
                       DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                       MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                       MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                       H2DPROBOCC=H2DProbOcc, $
                       H2DSTR=h2dStr, $
                       TMPLT_H2DSTR=tmplt_h2dStr, $
                       H2D_NONZERO_NEV_I=hEv_nz_i, $
                       H2DFLUXN=h2dFluxN, $
                       H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                       OUT_H2DMASK=out_h2dMask, $
                       DATANAME=dataName, $
                       DATARAWPTR=dataRawPtr, $
                       MEDHISTOUTDATA=medHistOutData, $
                       MEDHISTOUTTXT=medHistOutTxt, $
                       MEDHISTDATADIR=txtOutputDir, $
                       DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                       ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                       FANCY_PLOTNAMES=fancy_plotNames
     
     h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

     h2dStrArr              = [h2dStrArr,h2dStr] 
     IF alfDB_plot_struct.keepMe THEN BEGIN 
        dataNameArr         = [dataNameArr,dataName] 
        dataRawPtrArr       = [dataRawPtrArr,dataRawPtr] 
        varPlotH2DInds      = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
        varPlotRawInds      = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
        removed_ii_listArr  = [removed_ii_listArr,LIST(out_removed_ii)]
        ;;varplotiskeepInds   = [varPlotIsKeepInds,0]
     ENDIF  
     
     IF KEYWORD_SET(do_grossRate_fluxQuantities) $
        OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        grossConvFactorArr  = [grossConvFactorArr,grossConvFactor]
     ENDIF

  ENDIF

  ;;NEWELL PLOTS
  IF KEYWORD_SET(newellPlots) AND ~KEYWORD_SET(alfDB_plot_struct.no_maximus) THEN BEGIN
     GET_H2D_NEWELLS__EACH_TYPE,eSpec,plot_i, $
                                ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                IMF_STRUCT=IMF_struct, $
                                MIMC_STRUCT=MIMC_struct, $
                                NEWELL_PLOTRANGE=newell_plotRange, $
                                LOG_NEWELLPLOT=log_newellPlot, $
                                NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
                                NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
                                NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
                                ESPEC__NO_MAXIMUS=alfDB_plot_struct.no_maximus, $
                                ;; ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
                                INDICES__ESPEC=indices__eSpec, $
                                TMPLT_H2DSTR=tmplt_h2dStr, $
                                H2DSTRS=h2dStrs, $
                                H2DFLUXN=h2dFluxN, $
                                NEWELL_NONZERO_NEV_I=newell_nonzero_nEv_i, $
                                ;; MASKMIN=maskMin, $
                                DATANAMES=dataNames, $
                                DATARAWPTRS=dataRawPtrs, $
                                CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                CB_FORCE_OOBLOW=cb_force_oobLow, $
                                PRINT_MANDM=print_mAndM, $
                                LUN=lun

     h2dStrArr            = [h2dStrArr,h2dStrs]
     IF alfDB_plot_struct.keepMe THEN BEGIN 
        dataNameArr       = [dataNameArr,dataNames] 
        dataRawPtrArr     = [dataRawPtrArr,dataRawPtrs] 
     ENDIF

  ENDIF

  IF KEYWORD_SET(eSpec__newellPlot_probOccurrence) OR KEYWORD_SET(alfDB_plot_struct.t_probOccurrence) THEN BEGIN

     GET_H2D_NEWELLS__EACH_TYPE__NONALFVEN,eSpec,indices__eSpec, $
                                           ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                           IMF_STRUCT=IMF_struct, $
                                           MIMC_STRUCT=MIMC_struct, $
                                           NEWELL_PLOTRANGE=eSpec__newell_plotRange, $
                                           LOG_NEWELLPLOT=log_newellPlot, $
                                           NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
                                           NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
                                           NEWELLPLOT_PROBOCCURRENCE=eSpec__newellPlot_probOccurrence, $
                                           T_PROBOCCURRENCE=alfDB_plot_struct.t_probOccurrence, $
                                           T_PROBOCC_PLOTRANGE=eSpec__t_probOcc_plotRange, $
                                           THISTDENOMINATOR=eSpec_tHistDenominator, $
                                           NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
                                           COMBINE_ACCELERATED=alfDB_plot_struct.Newell__comb_accelerated, $
                                           TMPLT_H2DSTR=tmplt_h2dStr, $
                                           H2DSTRS=h2dStrs, $
                                           ;; H2DMASKSTR=h2dMaskStr, $
                                           H2DFLUXN=junk_h2dFluxN, $
                                           NEWELL_NONZERO_NEV_I=newell_nonzero_nEv_i, $
                                           ;; MASKMIN=maskMin, $
                                           DATANAMES=dataNames, $
                                           DATARAWPTRS=dataRawPtrs, $
                                           CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                           CB_FORCE_OOBLOW=cb_force_oobLow, $
                                           PRINT_MANDM=print_mAndM, $
                                           LUN=lun

     h2dStrArr            = [h2dStrArr,h2dStrs]
     IF alfDB_plot_struct.keepMe THEN BEGIN 
        dataNameArr       = [dataNameArr,dataNames] 
        dataRawPtrArr     = [dataRawPtrArr,dataRawPtrs] 
     ENDIF

  ENDIF


  ;;########BONUS########
  IF KEYWORD_SET(sum_electron_and_poyntingflux) THEN BEGIN
     
     ;; GET_FLUX_PLOTDATA,MAXIMUS__maximus,plot_i,$
     ;;                   /GET_PFLUX, $
     ;;                   /GET_EFLUX, $
     ;;                   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
     ;;                   IMF_STRUCT=IMF_struct, $
     ;;                   MIMC_STRUCT=MIMC_struct, $
     ;;                   OUTH2DBINSMLT=outH2DBinsMLT, $
     ;;                   OUTH2DBINSILAT=outH2DBinsILAT, $
     ;;                   OUTH2DBINSLSHELL=outH2DBinsLShell, $
     ;;                   PLOTRANGE=summed_eFlux_pFluxplotRange, $
     ;;                   PLOTAUTOSCALE=KEYWORD_SET(alfDB_plotLim_struct.autoscale_fluxPlots) OR KEYWORD_SET(autoscale_ePlots), $
     ;;                   NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
     ;;                   REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
     ;;                   REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
     ;;                   FLUXPLOTTYPE=eFluxPlotType, $
     ;;                   NOPOSFLUX=noPoseflux, $
     ;;                   NONEGFLUX=noNegeflux, $
     ;;                   ABSFLUX=abseflux, $
     ;;                   OUT_REMOVED_II=out_removed_ii, $
     ;;                   LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logefPlot) $
     ;;                                OR KEYWORD_SET(summed_eFlux_pFlux_logPlot) ), $
     ;;                   DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
     ;;                   DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
     ;;                   DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
     ;;                   GROSSRATE__H2D_AREAS=h2dAreas, $
     ;;                   DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
     ;;                   GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
     ;;                   GROSSRATE__CENTERS_MLT=centersMLT, $
     ;;                   GROSSRATE__CENTERS_ILAT=centersILAT, $
     ;;                   GROSSCONVFACTOR=grossConvFactor, $
     ;;                   WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
     ;;                   GROSSLUN=grossLun, $
     ;;                   SHOW_INTEGRALS=show_integrals, $
     ;;                   THISTDENOMINATOR=tHistDenominator, $
     ;;                   DIVIDE_BY_WIDTH_X=divide_by_width_x, $
     ;;                   MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
     ;;                   MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
     ;;                   H2DPROBOCC=H2DProbOcc, $
     ;;                   H2DSTR=h2dStr, $
     ;;                   TMPLT_H2DSTR=tmplt_h2dStr, $
     ;;                   H2D_NONZERO_NEV_I=hEv_nz_i, $
     ;;                   H2DFLUXN=h2dFluxN, $
     ;;                   H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
     ;;                   OUT_H2DMASK=out_h2dMask, $
     ;;                   DATANAME=dataName, $
     ;;                   DATARAWPTR=dataRawPtr, $
     ;;                   MEDHISTOUTDATA=medHistOutData, $
     ;;                   MEDHISTOUTTXT=medHistOutTxt, $
     ;;                   MEDHISTDATADIR=txtOutputDir, $
     ;;                   DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
     ;;                   ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
     ;;                   FANCY_PLOTNAMES=fancy_plotNames
     
     ;;Now pFlux
     GET_FLUX_PLOTDATA,MAXIMUS__maximus,plot_i,$
                       /GET_PFLUX, $
                       ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                       IMF_STRUCT=IMF_struct, $
                       MIMC_STRUCT=MIMC_struct, $
                       OUTH2DBINSMLT=outH2DBinsMLT, $
                       OUTH2DBINSILAT=outH2DBinsILAT, $
                       OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       PLOTRANGE=summed_eFlux_pFluxplotRange, $
                       PLOTAUTOSCALE=KEYWORD_SET(alfDB_plotLim_struct.autoscale_fluxPlots) OR KEYWORD_SET(autoscale_ePlots), $
                       NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
                       REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
                       REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
                       FLUXPLOTTYPE=eFluxPlotType, $
                       NOPOSFLUX=noPoseflux, $
                       NONEGFLUX=noNegeflux, $
                       ABSFLUX=abseflux, $
                       OUT_REMOVED_II=out_removed_ii, $
                       LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logefPlot) $
                                    OR KEYWORD_SET(summed_eFlux_pFlux_logPlot) ), $
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
                       SHOW_INTEGRALS=show_integrals, $
                       THISTDENOMINATOR=tHistDenominator, $
                       DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                       MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                       MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                       H2DPROBOCC=H2DProbOcc, $
                       H2DSTR=h2dStrPFlux, $
                       TMPLT_H2DSTR=tmplt_h2dStr, $
                       H2D_NONZERO_NEV_I=hEv_nz_i, $
                       H2DFLUXN=h2dFluxN, $
                       H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                       OUT_H2DMASK=out_h2dMask, $
                       DATANAME=dataName, $
                       DATARAWPTR=dataRawPtr, $
                       MEDHISTOUTDATA=medHistOutData, $
                       MEDHISTOUTTXT=medHistOutTxt, $
                       MEDHISTDATADIR=txtOutputDir, $
                       DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                       ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                       FANCY_PLOTNAMES=fancy_plotNames

     ;;now eFlux
     GET_FLUX_PLOTDATA,MAXIMUS__maximus,plot_i,$
                       /GET_EFLUX, $
                       ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                       IMF_STRUCT=IMF_struct, $
                       MIMC_STRUCT=MIMC_struct, $
                       OUTH2DBINSMLT=outH2DBinsMLT, $
                       OUTH2DBINSILAT=outH2DBinsILAT, $
                       OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       PLOTRANGE=summed_eFlux_pFluxplotRange, $
                       PLOTAUTOSCALE=KEYWORD_SET(alfDB_plotLim_struct.autoscale_fluxPlots) OR KEYWORD_SET(autoscale_ePlots), $
                       NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
                       REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
                       REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
                       FLUXPLOTTYPE=eFluxPlotType, $
                       NOPOSFLUX=noPoseflux, $
                       NONEGFLUX=noNegeflux, $
                       ABSFLUX=abseflux, $
                       OUT_REMOVED_II=out_removed_ii, $
                       LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logefPlot) $
                                    OR KEYWORD_SET(summed_eFlux_pFlux_logPlot) ), $
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
                       SHOW_INTEGRALS=show_integrals, $
                       THISTDENOMINATOR=tHistDenominator, $
                       DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                       MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                       MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                       H2DPROBOCC=H2DProbOcc, $
                       H2DSTR=h2dStrEFlux, $
                       TMPLT_H2DSTR=tmplt_h2dStr, $
                       H2D_NONZERO_NEV_I=hEv_nz_i, $
                       H2DFLUXN=h2dFluxN, $
                       H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                       OUT_H2DMASK=out_h2dMask, $
                       DATANAME=dataName, $
                       DATARAWPTR=dataRawPtr, $
                       MEDHISTOUTDATA=medHistOutData, $
                       MEDHISTOUTTXT=medHistOutTxt, $
                       MEDHISTDATADIR=txtOutputDir, $
                       DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                       ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                       FANCY_PLOTNAMES=fancy_plotNames

     h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

     dataName               = "eF_pF"
     h2dStr                 = TEMPORARY(h2dStrEFlux)
     h2dStr.data            = h2dStr.data + h2dStrPFlux.data
     h2dStr.name            = dataName
     h2dStr.title           = 'Summed e!U-!N and Poynting Fluxes (mW m!U-2!N) at 100 km'

     ;;And integrals
     h2dStr.grossIntegrals.day   = h2dStr.grossIntegrals.day   + h2dStrPflux.grossIntegrals.day
     h2dStr.grossIntegrals.night = h2dStr.grossIntegrals.night + h2dStrPflux.grossIntegrals.night
     h2dStr.grossIntegrals.total = h2dStr.grossIntegrals.total + h2dStrPflux.grossIntegrals.total

     h2dStrArr              = [h2dStrArr,h2dStr] 
     IF alfDB_plot_struct.keepMe THEN BEGIN 
        dataNameArr         = [dataNameArr,dataName] 
        dataRawPtrArr       = [dataRawPtrArr,dataRawPtr] 
        varPlotH2DInds      = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
        varPlotRawInds      = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
        removed_ii_listArr  = [removed_ii_listArr,LIST(out_removed_ii)]
        ;;varplotiskeepInds   = [varPlotIsKeepInds,0]
     ENDIF  
     
     IF KEYWORD_SET(do_grossRate_fluxQuantities) $
        OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        grossConvFactorArr  = [grossConvFactorArr,grossConvFactor]
     ENDIF

     ;; IF KEYWORD_SET(eNumFlPlots) AND KEYWORD_SET(pplots) THEN BEGIN
     ;;    ePlotInd            = WHERE(STRMATCH(dataNameArr, '*enumfl*', /FOLD_CASE) EQ 1)
     ;;    pPlotInd            = WHERE(STRMATCH(dataNameArr, '*pflux*', /FOLD_CASE) EQ 1)

     ;;    IF ePlotInd[0] NE -1 AND pPlotInd[0] NE -1 THEN BEGIN
     ;;       h2dStrEP         = tmplt_h2dStr
     ;;       EPdataName       = 'summed_e_and_p'
     ;;       h2dStrEP.title   = "Summed e- and Poynting flux (mW/m!U2!N)"
     ;;       h2dStrEP.lim     = [0.00,0.35]
     ;;       h2dStrEP.logLabels = 0
     ;;       h2dStrEP.data       = h2dStrArr[ePlotInd].data+h2dStrArr[pPlotInd].data

     ;;       ;;Add this curiosity to the mix
     ;;       dataNameArr        = [dataNameArr,EPdataName]
     ;;       h2dStrArr          = [h2dStrArr,h2dStrEP]
     ;;    ENDIF ELSE BEGIN
     ;;       PRINT,"Couldn't locate eplot and pplot for summing!"
     ;;       STOP
     ;;    ENDELSE
     ;; ENDIF ELSE BEGIN
     ;;    PRINT,'Have to set eplots and pplots keywords to make this work'
     ;; ENDELSE


  ENDIF


  ;;#####Custom maxInd--the best!!##########
  IF KEYWORD_SET(custom_maxInds) THEN BEGIN
     nameless_customData_count    = 0
     nameless_customTitle_count   = 0
     FOR i=0,N_ELEMENTS(custom_maxInds)-1 DO BEGIN
        
        
        GET_CUSTOM_MAXIND_ANCILLARIES,custom_range,log_custom,custom_title,custom_dataname,custom_autoscale, $
                                      INDEX=index, $
                                      CUSTOM_MAXINDS=custom_maxInds, $
                                      CUSTOM_MAXIND_RANGE=custom_maxInd_range, $
                                      CUSTOM_MAXIND_AUTOSCALE=custom_maxInd_autoscale, $
                                      CUSTOM_MAXIND_DATANAME=custom_maxInd_dataname, $
                                      CUSTOM_MAXIND_TITLE=custom_maxInd_title, $
                                      LOG_CUSTOM_MAXIND=log_custom_maxInd, $
                                      DO_OUTPUT_CUSTOM_MAXIND=do_output_custom_maxInd, $
                                      OUTPUT_CUSTOM_MAXIND=output_custom_maxInd, $
                                      RESET_COUNTERS=reset_counters
        
        IF KEYWORD_SET(do_grossRate_fluxQuantities) $
           OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN

           IF N_ELEMENTS(custom_grossRate_convFactor) NE 0 THEN BEGIN
              IF N_ELEMENTS(custom_grossRate_convFactor) GT 1 THEN BEGIN
                 grossRate_convFactor = custom_grossRate_convFactor[i]
              ENDIF ELSE BEGIN
                 grossRate_convFactor    = custom_grossRate_convFactor
              ENDELSE
           ENDIF ELSE BEGIN
              PRINTF,lun,"Have to provide a grossRate conv Factor to get your units right!!"
              STOP
           ENDELSE
        ENDIF

        GET_CUSTOM_MAXIND_PLOTDATA,MAXIMUS__maximus,plot_i,custom_maxInds[i], $
                                   CUSTOM_DATANAME=custom_dataname, $
                                   CUSTOM_TITLE=custom_title, $
                                   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                   IMF_STRUCT=IMF_struct, $
                                   MIMC_STRUCT=MIMC_struct, $
                                   OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT, $
                                   OUTH2DBINSLSHELL=outH2DBinsLShell, $
                                   PLOTRANGE=custom_range, $
                                   PLOTAUTOSCALE=custom_autoscale, $
                                   ;; NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
                                   NOPOSFLUX=noPosFlux, $
                                   NONEGFLUX=noNegFlux, $
                                   ABSFLUX=absFlux, $
                                   OUT_REMOVED_II=out_removed_ii, $
                                   LOGPLOT=log_custom, $
                                   DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                                   MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                                   MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                                   H2DPROBOCC=H2DProbOcc, $
                                   DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                                   DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
                                   DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                                   CUSTOM_GROSSRATE_CONVFACTOR=grossRate_convFactor, $
                                   GROSSRATE__H2D_AREAS=h2dAreas, $
                                   DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
                                   GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
                                   GROSSRATE__CENTERS_MLT=centersMLT, $
                                   GROSSRATE__CENTERS_ILAT=centersILAT, $
                                   GROSSCONVFACTOR=grossConvFactor, $
                                   WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
                                   GROSSLUN=grossLun, $
                                   SHOW_INTEGRALS=show_integrals, $
                                   THISTDENOMINATOR=tHistDenominator, $
                                   H2DSTR=h2dStr, $
                                   TMPLT_H2DSTR=tmplt_h2dStr, $
                                   H2D_NONZERO_NEV_I=hEv_nz_i, $
                                   H2DFLUXN=h2dFluxN, $
                                   H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                                   OUT_H2DMASK=out_h2dMask, $
                                   DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                                   MEDHISTOUTDATA=medHistOutData, $
                                   MEDHISTOUTTXT=medHistOutTxt, $
                                   MEDHISTDATADIR=txtOutputDir, $
                                   DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                                   ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                                   DO_PLOT_I_INSTEAD_OF_HISTOS=do_plot_i_instead_of_histos, $
                                   PRINT_MAX_AND_MIN=print_mandm, $
                                   FANCY_PLOTNAMES=fancy_plotNames, $
                                   LUN=lun
        

        h2dStrArr=[h2dStrArr,h2dStr] 
        IF alfDB_plot_struct.keepMe THEN BEGIN 
           dataNameArr=[dataNameArr,dataName] 
           dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
        ENDIF
        
        IF KEYWORD_SET(do_grossRate_fluxQuantities) $
           OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
           grossConvFactorArr   = [grossConvFactorArr,grossConvFactor]
        ENDIF

     ENDFOR
  ENDIF


  ;;********************************************************
  ;;If something screwy goes on, better take stock of it and alert user
  ;; n_zero                     = N_ELEMENTS(h2dFluxN)-N_ELEMENTS(hEv_nz_i)
  ;; FOR i = 2, N_ELEMENTS(h2dStrArr)-1 DO BEGIN 
  ;;    IF n_elements(where(h2dStrArr[i].data EQ 0,/NULL)) LT $
  ;;       n_zero THEN BEGIN 
  ;;       printf,lun,"h2dStrArr."+h2dStrArr[i].title + " has ", strtrim(n_elements(where(h2dStrArr[i].data EQ 0)),2)," elements that are zero, whereas FluxN has ", strtrim(n_zero,2),"." 
  ;;    printf,lun,"Sorry, can't plot anything meaningful." & ENDIF
  ;; ENDFOR

  IF N_ELEMENTS(print_mandm) EQ 0 THEN print_mandm = 1

  IF KEYWORD_SET(add_variance_plots) OR KEYWORD_SET(only_variance_plots) OR KEYWORD_SET(write_obsArr_textFile) THEN BEGIN

     IF KEYWORD_SET(add_variance_plots) OR KEYWORD_SET(only_variance_plots) THEN doing_var_plots = 1 ELSE doing_var_plots = 0
     IF doing_var_plots THEN PRINTF,lun,"Getting variance plot data ..."

     GET_VARIANCE_PLOTDATA,MAXIMUS__maximus,plot_i, $
                           FOR_MAXIMUS=~KEYWORD_SET(alfDB_plot_struct.no_maximus), $
                           FOR_ESPEC_DBS=KEYWORD_SET(alfDB_plot_struct.no_maximus), $
                           IN_INDS=indices__eSpec, $
                           IN_MLTS=eSpec__mlts, $
                           IN_ILATS=eSpec__ilats, $
                           FASTLOCINDS=fastLocInterped_i, $
                           H2DSTRARR=h2dStrArr, $
                           DATANAMEARR=dataNameArr, $
                           DATARAWPTRARR=dataRawPtrArr, $
                           REMOVED_II_LISTARR=removed_ii_listArr, $
                           ;;VARPLOTISKEEPINDS=varPlotIsKeepInds, $
                           DO_VAR_PLOTS=doing_var_plots, $
                           VAR__PLOTRANGE=var__plotRange, $
                           VAR__REL_TO_MEAN_VARIANCE=var__rel_to_mean_variance, $
                           VAR__DO_STDDEV_INSTEAD=var__do_stddev_instead, $
                           VAR__AUTOSCALE=var__autoscale, $
                           VARPLOTH2DINDS=varPlotH2DInds, $
                           DBTIMES=KEYWORD_SET(alfDB_plot_struct.no_maximus) ?  !NULL : MAXIMUS__times, $
                           ;; DONT_USE_THESE_INDS=dont_use_these_inds, $
                           DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                           GROSSRATE__H2D_AREAS=h2dAreas, $
                           DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
                           GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
                           GROSSCONVFACTOR=grossConvFactor, $
                           VAR_H2DSTRARR=var_h2dStrArr, $
                           VAR_DATANAMEARR=var_datNameArr, $
                           OUTH2D_LISTS_WITH_OBS=outH2D_lists_with_obs,$
                           OUTH2D_STATS=outH2D_stats, $
                           OUTFILESTRING=paramStr, $
                           OUTFILEPREFIX=paramStrPrefix, $
                           OUTFILESUFFIX=paramStrSuffix, $
                           OUTDIR=txtOutputDir, $
                           OUTPUT_TEXTFILE=write_obsArr_textFile, $
                           OUTPUT__INC_IMF=write_obsArr__inc_IMF, $
                           OUTPUT__ORB_AVG_OBS=write_obsArr__orb_avg_obs, $
                           VARPLOTRAWINDS=varPlotRawInds, $
                           OUTH2D_LISTS_WITH_INDS=outH2D_lists_with_inds,$
                           ALL_LOGPLOTS=all_logPlots, $
                           ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                           IMF_STRUCT=IMF_struct, $
                           MIMC_STRUCT=MIMC_struct, $
                           ESPEC__NO_MAXIMUS=alfDB_plot_struct.no_maximus, $
                           TMPLT_H2DSTR=tmplt_h2dStr, $
                           H2D_NONZERO_NEV_I=hEv_nz_i, $
                           LUN=lun


  ENDIF

  ;;Now that we're done using nplots, let's log it, if requested:
  IF KEYWORD_SET(nPlots) THEN BEGIN
     IF KEYWORD_SET(logNEventsPlot) OR KEYWORD_SET(all_logPlots) THEN BEGIN
        IF KEYWORD_SET(nEventsPlotNormalize) THEN BEGIN
           PRINT,"You realize you're asking me to both log-a-tize and normalize the nEvents plot, right?"
           WAIT,5
        ENDIF
        dataNameArr[0]         = 'log_' + dataNameArr[0]
        h2dStrArr[0].data[hEv_nz_i] = ALOG10(h2dStrArr[0].data[hEv_nz_i])
        h2dStrArr[0].lim       = [(h2dStrArr[0].lim[0] LT 1) ? 0 : ALOG10(h2dStrArr[0].lim[0]),ALOG10(h2dStrArr[0].lim[1])] ;lower bound must be one
        h2dStrArr[0].title     = 'Log ' + h2dStrArr[0].title
        h2dStrArr[0].name      = dataNameArr[0]
        h2dStrArr[0].is_logged = 1
     ENDIF
     IF KEYWORD_SET(nEventsPlotNormalize) THEN BEGIN
        dataNameArr[0]        += '_normed'
        maxNEv                 = MAX(h2dStrArr[0].data[hEv_nz_i])
        h2dStrArr[0].data      = h2dStrArr[0].data/maxNEv
        h2dStrArr[0].lim       = [0.0,1.0]
        h2dStrArr[0].title    += STRING(FORMAT='(" (norm: ",G0.3,")")',maxNEv)
        h2dStrArr[0].name      = dataNameArr[0]
        ;; h2dStrArr[0].dont_mask_me = 1
     ENDIF
     IF KEYWORD_SET(nEventsPlotAutoscale) THEN BEGIN
        PRINT,"Autoscaling nEvents plot..."
        h2dStrArr[0].lim       = [MIN(h2dStrArr[0].data[hEv_nz_i]), $
                                  MAX(h2dStrArr[0].data[hEv_nz_i])]
     ENDIF
  ENDIF

END