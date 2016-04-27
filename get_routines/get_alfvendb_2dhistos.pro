
PRO GET_ALFVENDB_2DHISTOS,maximus,plot_i, $
                          H2DSTRARR=h2dStrArr, $
                          KEEPME=keepMe, $
                          DATARAWPTRARR=dataRawPtrArr, $
                          DATANAMEARR=dataNameArr, $
                          MINMLT=minM, $
                          MAXMLT=maxM, $
                          BINMLT=binM, $
                          SHIFTMLT=shiftM, $
                          MINILAT=minI, $
                          MAXILAT=maxI, $
                          BINILAT=binI, $
                          DO_LSHELL=do_lShell, $
                          MINLSHELL=minL, $
                          MAXLSHELL=maxL, $
                          BINLSHELL=binL, $
                          ORBRANGE=orbRange, $
                          ALTITUDERANGE=altitudeRange, $
                          CHARERANGE=charERange, $
                          POYNTRANGE=poyntRange, $
                          NUMORBLIM=numOrbLim, $
                          MASKMIN=maskMin, $
                          SATELLITE=satellite, $
                          OMNI_COORDS=omni_Coords, $
                          HEMI=hemi, $
                          DO_IMF_CONDS=do_IMF_conds, $
                          CLOCKSTR=clockStr, $
                          ANGLELIM1=angleLim1, $
                          ANGLELIM2=angleLim2, $
                          DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                          BYMIN=byMin, $
                          BZMIN=bzMin, $
                          BYMAX=byMax, $
                          BZMAX=bzMax, $
                          DO_ABS_BYMIN=abs_byMin, $
                          DO_ABS_BYMAX=abs_byMax, $
                          DO_ABS_BZMIN=abs_bzMin, $
                          DO_ABS_BZMAX=abs_bzMax, $
                          DELAY=delay, $
                          MULTIPLE_DELAYS=multiple_delays, $
                          RESOLUTION_DELAY=delay_res, $
                          BINOFFSET_DELAY=binOffset_delay, $
                          STABLEIMF=stableIMF, $
                          SMOOTHWINDOW=smoothWindow, $
                          HERE_ARE_YOUR_FASTLOC_INDS=fastLoc_inds, $
                          INCLUDENOCONSECDATA=includeNoConsecData, $
                          DO_UTC_RANGE=DO_UTC_range, $
                          STORMSTRING=stormString, $
                          DSTCUTOFF=dstCutoff, $
                          T1_ARR=t1_arr, $
                          T2_ARR=t2_arr, $             
                          NPLOTS=nPlots, $
                          NEVENTSPLOTRANGE=nEventsPlotRange, $
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
                          DIV_FLUXPLOTS_BY_ORBTOT=div_fluxPlots_by_orbTot, $
                          DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                          ORBCONTRIBPLOT=orbContribPlot, $
                          ORBCONTRIBRANGE=orbContribRange, $
                          ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
                          ORBCONTRIB_NOMASK=orbContrib_noMask, $
                          LOGORBCONTRIBPLOT=logOrbContribPlot, $
                          ORBTOTPLOT=orbTotPlot, $
                          ORBFREQPLOT=orbFreqPlot, $
                          ORBTOTRANGE=orbTotRange, $
                          ORBFREQRANGE=orbFreqRange, $
                          NEVENTPERORBPLOT=nEventPerOrbPlot, $
                          LOGNEVENTPERORB=logNEventPerOrb, $
                          NEVENTPERORBRANGE=nEventPerOrbRange, $
                          DIVNEVBYTOTAL=divNEvByTotal, $
                          NEVENTPERMINPLOT=nEventPerMinPlot, $
                          NEVENTPERMINRANGE=nEventPerMinRange, $
                          LOGNEVENTPERMIN=logNEventPerMin, $
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
                          GROSSLUN=grossLun, $
                          DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                          MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
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
                          MEDIANPLOT=medianPlot, $
                          MEDHISTOUTDATA=medHistOutData, $
                          MEDHISTOUTTXT=medHistOutTxt, $
                          LOGAVGPLOT=logAvgPlot, $
                          ALL_LOGPLOTS=all_logPlots, $
                          PARAMSTRPREFIX=paramStrPrefix, $
                          PARAMSTRSUFFIX=paramStrSuffix, $
                          TMPLT_H2DSTR=tmplt_h2dStr, $
                          FANCY_PLOTNAMES=fancy_plotNames, $
                          LUN=lun
  
  COMPILE_OPT idl2

  ;;set up variance plot inds
  varPlotRawInds         = !NULL
  varPlotH2DInds         = !NULL
  removed_ii_listarr     = !NULL
  grossConvFactorArr     = !NULL

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF N_ELEMENTS(print_mandm) EQ 0 THEN print_mandm = 1

  ;;########Flux_N and Mask########
  ;;First, histo to show where events are
  GET_H2D_NEVENTS_AND_MASK,maximus,plot_i, $
                           MINM=minM, $
                           MAXM=maxM, $
                           BINM=binM, $
                           SHIFTM=shiftM, $
                           MINI=minI, $
                           MAXI=maxI, $
                           BINI=binI, $
                           DO_LSHELL=do_lshell, $
                           MINL=minL, $
                           MAXL=maxL, $
                           BINL=binL, $
                           NEVENTSPLOTRANGE=nEventsPlotRange, $
                           TMPLT_H2DSTR=tmplt_h2dStr, $
                           H2DSTR=h2dStr, $
                           H2DMASKSTR=h2dMaskStr, $
                           H2DFLUXN=h2dFluxN, $
                           H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                           MASKMIN=maskMin, $
                           DATANAME=dataName, $
                           DATARAWPTR=dataRawPtr
  
  IF keepMe THEN BEGIN 
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
  IF KEYWORD_SET(nEventPerMinPlot) OR KEYWORD_SET(probOccurrencePlot) $
     ;; OR KEYWORD_SET(timeAvgd_pfluxPlot) OR KEYWORD_SET(timeAvgd_eFluxMaxPlot) $
     OR KEYWORD_SET(do_timeAvg_fluxQuantities) $
     OR KEYWORD_SET(nEventPerOrbPlot) $
     OR KEYWORD_SET(tHistDenominatorPlot) $
     OR KEYWORD_SET(nOrbsWithEventsPerContribOrbsPlot) $
     OR KEYWORD_SET(div_fluxPlots_by_applicable_orbs) $
  THEN BEGIN 
     tHistDenominator = GET_TIMEHIST_DENOMINATOR(CLOCKSTR=clockStr, $
                                                 ANGLELIM1=angleLim1, $
                                                 ANGLELIM2=angleLim2, $
                                                 DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                                 ORBRANGE=orbRange, $
                                                 ALTITUDERANGE=altitudeRange, $
                                                 CHARERANGE=charERange, $
                                                 DO_IMF_CONDS=do_IMF_conds, $
                                                 BYMIN=byMin, $
                                                 BYMAX=byMax, $
                                                 BZMIN=bzMin, $
                                                 BZMAX=bzMax, $
                                                 DO_ABS_BYMIN=abs_byMin, $
                                                 DO_ABS_BYMAX=abs_byMax, $
                                                 DO_ABS_BZMIN=abs_bzMin, $
                                                 DO_ABS_BZMAX=abs_bzMax, $
                                                 SATELLITE=satellite, $
                                                 OMNI_COORDS=omni_Coords, $
                                                 DELAY=delay, $
                                                 RESOLUTION_DELAY=delay_res, $
                                                 BINOFFSET_DELAY=binOffset_delay, $
                                                 STABLEIMF=stableIMF, $
                                                 SMOOTHWINDOW=smoothWindow, $
                                                 INCLUDENOCONSECDATA=includeNoConsecData, $
                                                 DO_UTC_RANGE=do_UTC_range, $
                                                 STORMSTRING=stormString, $
                                                 DSTCUTOFF=dstCutoff, $
                                                 HERE_ARE_YOUR_FASTLOC_INDS=fastLoc_inds, $
                                                 T1_ARR=t1_arr, $
                                                 T2_ARR=t2_arr, $
                                                 MINM=minM, $
                                                 MAXM=maxM, $
                                                 BINM=binM, $
                                                 SHIFTM=shiftM, $
                                                 MINI=minI, $
                                                 MAXI=maxI, $
                                                 BINI=binI, $
                                                 DO_LSHELL=do_lshell, $
                                                 MINL=minL, $
                                                 MAXL=maxL, $
                                                 BINL=binL, $
                                                 HEMI=hemi, $
                                                 OUT_FASTLOC_STRUCT=fastLoc, $
                                                 ;; FASTLOC_TIMES=fastLoc_Times, $
                                                 ;; FASTLOC_DELTA_T=fastLoc_delta_t, $
                                                 ;; FASTLOCFILE=fastLocFile, $
                                                 ;; FASTLOCTIMEFILE=fastLocTimeFile, $
                                                 FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                                 OUT_FASTLOCINTERPED_I=fastLocInterped_i, $
                                                 MAKE_TIMEHIST_H2DSTR=tHistDenominatorPlot, $
                                                 THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
                                                 THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
                                                 THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
                                                 THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
                                                 TMPLT_H2DSTR=tmplt_h2dStr, $
                                                 H2DSTR=h2dStr, $
                                                 DATANAME=dataName, $
                                                 DATARAWPTR=dataRawPtr, $
                                                 H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                                                 INDSFILEPREFIX=ParamStrPrefix, $
                                                 INDSFILESUFFIX=paramStrSuffix, $
                                                 BURSTDATA_EXCLUDED=burstData_excluded)

     
     IF keepMe THEN BEGIN 
        IF KEYWORD_SET(tHistDenominatorPlot) THEN BEGIN
           h2dStrArr     = [h2dStrArr,h2dStr] 
           dataNameArr   = [dataNameArr,dataName] 
           dataRawPtrArr = [dataRawPtrArr,dataRawPtr] 
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
     OR KEYWORD_SET(nEventPerOrbPlot) OR KEYWORD_SET(numOrbLim) $
     OR KEYWORD_SET(nOrbsWithEventsPerContribOrbsPlot) $
     OR KEYWORD_SET(div_fluxPlots_by_applicable_orbs) THEN BEGIN
     
     GET_CONTRIBUTING_ORBITS_PLOTDATA,fastLoc,fastLocInterped_i, $
                                      MINM=minM, $
                                      MAXM=maxM, $
                                      BINM=binM, $
                                      SHIFTM=shiftM, $
                                      MINI=minI, $
                                      MAXI=maxI, $
                                      BINI=binI, $
                                      DO_LSHELL=do_lShell, $
                                      MINL=minL, $
                                      MAXL=maxL, $
                                      BINL=binL, $
                                      LOGORBCONTRIBPLOT=logOrbContribPlot, $
                                      ORBCONTRIBRANGE=orbContribRange, $
                                      ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
                                      ORBCONTRIB_NOMASK=orbContrib_noMask, $
                                      UNIQUEORBS_I=uniqueOrbs_i, $
                                      H2D_NONZERO_CONTRIBORBS_I=h2d_nonzero_contribOrbs_i, $
                                      H2D_NONZERO_I=h2d_nonzero_nEv_i, $
                                      H2DSTR=h2dContribOrbStr, $
                                      TMPLT_H2DSTR=tmplt_h2dStr, $ ;H2DFLUXN=h2dFluxN, $
                                      DATANAME=dataName
     
     IF KEYWORD_SET(orbContribPlot) THEN BEGIN 
        h2dStrArr=[h2dStrArr,h2dContribOrbStr] 
        IF keepMe THEN dataNameArr=[dataNameArr,dataName] 
     ENDIF
     
     ;;Mask all bins that don't have requisite number of orbits passing through
     IF KEYWORD_SET(numOrbLim) THEN BEGIN 
        h2dStrArr[KEYWORD_SET(nPlots)].data[WHERE(h2dContribOrbStr.data LT numOrbLim)] = 255 ;mask 'em!

        ;;little check to see how many more elements are getting masked
        ;;exc_orb_i = where(h2dContribOrbStr.data LT numOrbLim)
        ;;masked_i = where(h2dStr(1).data EQ 255)
        ;;print,n_elements(exc_orb_i) - n_elements(cgsetintersection(exc_orb_i,masked_i))
        ;;8
     ENDIF
     
  ENDIF
  
  ;;########Probability of occurrence à la Chaston et al. [2007]########
  IF KEYWORD_SET(nOrbsWithEventsPerContribOrbsPlot) THEN BEGIN

     GET_CONTRIBUTING_ORBITS_PLOTDATA,maximus,plot_i, $
                                      MINM=minM, $
                                      MAXM=maxM, $
                                      BINM=binM, $
                                      SHIFTM=shiftM, $
                                      MINI=minI, $
                                      MAXI=maxI, $
                                      BINI=binI, $
                                      DO_LSHELL=do_lShell, $
                                      MINL=minL, $
                                      MAXL=maxL, $
                                      BINL=binL, $
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
     IF keepMe THEN dataNameArr=[dataNameArr,dataName] 
  ENDIF

  ;;########TOTAL Orbits########
  IF KEYWORD_SET(orbtotplot) OR KEYWORD_SET(orbfreqplot) $
     OR (KEYWORD_SET(nEventPerOrbPlot) AND KEYWORD_SET(divNEvByTotal)) THEN BEGIN
     GET_TOTAL_ORBITS_PLOTDATA,maximus, $
                               MINM=minM, $
                               MAXM=maxM, $
                               BINM=binM, $
                               SHIFTM=shiftM, $
                               MINI=minI, $
                               MAXI=maxI, $
                               BINI=binI, $
                               DO_LSHELL=do_lshell, $
                               MINL=minL, $
                               MAXL=maxL, $
                               BINL=binL, $
                               ORBTOTRANGE=orbTotRange, $
                               H2DSTR=h2dTotOrbStr, $
                               TMPLT_H2DSTR=tmplt_h2dStr, $
                               DATANAME=dataName, $
                               DATARAWPTR=dataRawPtr, $
                               KEEPME=keepme, $
                               UNIQUEORBS_I=uniqueOrbs_i, $
                               H2D_NONZERO_ALLORB_I=h2d_nonZero_allOrb_i, $
                               LUN=lun
     
     IF KEYWORD_SET(orbTotPlot) THEN BEGIN 
        h2dStrArr=[h2dStrArr,h2dTotOrbStr] 
        IF keepMe THEN dataNameArr=[dataNameArr,dataName] 
     ENDIF
  ENDIF

  ;;########Orbit FREQUENCY########
  IF KEYWORD_SET(orbfreqplot) THEN BEGIN
     GET_ORBIT_FREQUENCY_PLOTDATA,maximus, $
                                  MINM=minM, $
                                  MAXM=maxM, $
                                  BINM=binM, $
                                  SHIFTM=shiftM, $
                                  MINI=minI, $
                                  MAXI=maxI, $
                                  BINI=binI, $
                                  ORBFREQRANGE=orbFreqRange, $
                                  H2DSTR=h2dStr, $
                                  TMPLT_H2DSTR=tmplt_h2dStr, $
                                  H2DCONTRIBORBSTR=h2dContribOrbStr, $
                                  H2DTOTORBSTR=h2dTotOrbStr, $
                                  H2D_NONZERO_ALLORB_I=h2d_nonZero_allOrb_i, $
                                  H2D_NONZERO_CONTRIBORBS_I=h2d_nonzero_contribOrbs_i, $
                                  DATANAME=dataName
     
     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN dataNameArr=[dataNameArr,dataName] 
     
  ENDIF
  
  ;;########NEvents/orbit########
  IF KEYWORD_SET(nEventPerOrbPlot) THEN BEGIN 
     GET_NEVENTS_PER_ORBIT_PLOTDATA,maximus,plot_i, $
                                    MINM=minM, $
                                    MAXM=maxM, $
                                    BINM=binM, $
                                    SHIFTM=shiftM, $
                                    MINI=minI, $
                                    MAXI=maxI, $
                                    BINI=binI, $
                                    DO_LSHELL=do_lshell, $
                                    MINL=minL, $
                                    MAXL=maxL, $
                                    BINL=binL, $
                                    NEVENTPERORBRANGE=nEventPerOrbRange, $
                                    LOGNEVENTPERORB=logNEventPerOrb, $
                                    DIVNEVBYTOTAL=divNEvByTotal, $
                                    H2DSTR=h2dStr, $
                                    TMPLT_H2DSTR=tmplt_h2dStr, $
                                    H2DFLUXN=h2dFluxN, $
                                    H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                                    H2D_NONZERO_CONTRIBORBS_I=h2d_nonZero_contribOrbs_i, $
                                    H2DCONTRIBORBSTR=h2dContribOrbStr, $
                                    H2DTOTORBSTR=h2dTotOrbStr, $
                                    DATANAME=dataName, $
                                    DATARAWPTR=dataRawPtr
     
     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN dataNameArr=[dataNameArr,dataName]
  ENDIF
  
  ;;########NEvents/minute########
  IF KEYWORD_SET(nEventPerMinPlot) THEN BEGIN
     GET_NEVENTPERMIN_PLOTDATA,THISTDENOMINATOR=tHistDenominator, $
                               MINM=minM, $
                               MAXM=maxM, $
                               BINM=binM, $
                               SHIFTM=shiftM, $
                               MINI=minI, $
                               MAXI=maxI, $
                               BINI=binI, $
                               DO_LSHELL=do_lshell, $
                               MINL=minL, $
                               MAXL=maxL, $
                               BINL=binL, $
                               LOGNEVENTPERMIN=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logNEventPerMin)), $
                               NEVENTPERMINRANGE=nEventPerMinRange, $
                               H2DSTR=h2dStr, $
                               TMPLT_H2DSTR=tmplt_h2dStr, $
                               H2DFLUXN=h2dFluxN, $
                               H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                               DATANAME=dataName ; , $
     ;; DATARAWPTR=dataRawPtr
     
     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,dataName] 
        ;; dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
     ENDIF 
  ENDIF
  
  ;;########Event probability########
  IF KEYWORD_SET(probOccurrencePlot) THEN BEGIN
     GET_PROB_OCCURRENCE_PLOTDATA,maximus,plot_i,tHistDenominator, $
                                  LOGPROBOCCURRENCE=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logProbOccurrence)), $
                                  PROBOCCURRENCERANGE=probOccurrenceRange, $
                                  PROBOCCURRENCEAUTOSCALE=probOccurrenceAutoscale, $
                                  DO_WIDTH_X=do_width_x, $
                                  MINM=minM, $
                                  MAXM=maxM, $
                                  BINM=binM, $
                                  SHIFTM=shiftM, $
                                  MINI=minI, $
                                  MAXI=maxI, $
                                  BINI=binI, $
                                  DO_LSHELL=do_lshell, $
                                  MINL=minL, $
                                  MAXL=maxL, $
                                  BINL=binL, $
                                  OUTH2DBINSMLT=outH2DBinsMLT, $
                                  OUTH2DBINSILAT=outH2DBinsILAT, $
                                  OUTH2DBINSLSHELL=outH2DBinsLShell, $
                                  H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                                  H2DFLUXN=h2dFluxN, $
                                  H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                                  OUT_H2DMASK=out_h2dMask, $
                                  H2DSTR=h2dStr, $
                                  TMPLT_H2DSTR=tmplt_h2dStr, $
                                  DATANAME=dataName, $
                                  DATARAWPTR=dataRawPtr
     
     h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

     h2dStrArr=[h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN 
        dataNameArr=[dataNameArr,dataName] 
        dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
     ENDIF 
  ENDIF


  ;;#####FLUX QUANTITIES#########
  ;;########ELECTRON FLUX########
  IF KEYWORD_SET(eplots) THEN BEGIN
     FOR i=0,N_ELEMENTS(eFluxPlotType)-1 DO BEGIN
        fluxPlotType = eFluxPlotType[i]
        dims                  = SIZE(ePlotRange,/DIMENSIONS)
        CASE N_ELEMENTS(dims) OF 
           0:   plotRange     = !NULL
           1:   plotRange     = ePlotRange
           2:   plotRange     = ePlotRange[*,i]
        ENDCASE
        GET_FLUX_PLOTDATA,maximus,plot_i,/GET_EFLUX, $
                          MINM=minM, $
                          MAXM=maxM, $
                          BINM=binM, $
                          SHIFTM=shiftM, $
                          MINI=minI, $
                          MAXI=maxI, $
                          BINI=binI, $
                          DO_LSHELL=do_lshell, $
                          MINL=minL, $
                          MAXL=maxL, $
                          BINL=binL, $
                          OUTH2DBINSMLT=outH2DBinsMLT, $
                          OUTH2DBINSILAT=outH2DBinsILAT, $
                          OUTH2DBINSLSHELL=outH2DBinsLShell, $
                          FLUXPLOTTYPE=fluxPlotType, $
                          PLOTRANGE=plotRange, $
                          PLOTAUTOSCALE=KEYWORD_SET(autoscale_fluxPlots) OR KEYWORD_SET(autoscale_eplots), $
                          NOPOSFLUX=noPoseflux, $
                          NONEGFLUX=noNegeflux, $
                          ABSFLUX=abseflux, $
                          OUT_REMOVED_II=out_removed_ii, $
                          LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logEfPlot)), $
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
                          DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                          MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                          H2DSTR=h2dStr, $
                          TMPLT_H2DSTR=tmplt_h2dStr, $
                          H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                          H2DFLUXN=h2dFluxN, $
                          H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                          OUT_H2DMASK=out_h2dMask, $
                          DATANAME=dataName, $
                          DATARAWPTR=dataRawPtr, $
                          MEDIANPLOT=medianplot, $
                          MEDHISTOUTDATA=medHistOutData, $
                          MEDHISTOUTTXT=medHistOutTxt, $
                          MEDHISTDATADIR=medHistDataDir, $
                          LOGAVGPLOT=logAvgPlot, $
                          DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                          ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                          FANCY_PLOTNAMES=fancy_plotNames

        
        h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

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
  ENDIF
  
  ;;########ELECTRON NUMBER FLUX########
  IF KEYWORD_SET(eNumFlPlots) THEN BEGIN
     FOR i=0,N_ELEMENTS(eNumFlPlotType)-1 DO BEGIN
        fluxPlotType = eNumFlPlotType[i]
        dims                  = SIZE(eNumFlPlotRange,/DIMENSIONS)
        CASE N_ELEMENTS(dims) OF 
           0:   plotRange     = !NULL
           1:   plotRange     = eNumFlPlotRange
           2:   plotRange     = eNumFlPlotRange[*,i]
        ENDCASE
        GET_FLUX_PLOTDATA,maximus,plot_i,/GET_ENUMFLUX, $
                          MINM=minM, $
                          MAXM=maxM, $
                          BINM=binM, $
                          SHIFTM=shiftM, $
                          MINI=minI, $
                          MAXI=maxI, $
                          BINI=binI, $
                          DO_LSHELL=do_lshell, $
                          MINL=minL, $
                          MAXL=maxL, $
                          BINL=binL, $
                          OUTH2DBINSMLT=outH2DBinsMLT, $
                          OUTH2DBINSILAT=outH2DBinsILAT, $
                          OUTH2DBINSLSHELL=outH2DBinsLShell, $
                          FLUXPLOTTYPE=fluxPlotType, $
                          PLOTRANGE=plotRange, $
                          PLOTAUTOSCALE=KEYWORD_SET(autoscale_fluxPlots) OR KEYWORD_SET(autoscale_eNumFlplots), $
                          NOPOSFLUX=noPosENumFl, $
                          NONEGFLUX=noNegENumFl, $
                          ABSFLUX=absENumFl, $
                          OUT_REMOVED_II=out_removed_ii, $
                          LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logENumFlPlot)), $
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
                          DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                          MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                          H2DSTR=h2dStr, $
                          TMPLT_H2DSTR=tmplt_h2dStr, $
                          H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                          H2DFLUXN=h2dFluxN, $
                          H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                          OUT_H2DMASK=out_h2dMask, $
                          DATANAME=dataName, $
                          DATARAWPTR=dataRawPtr, $
                          MEDIANPLOT=medianplot, $
                          MEDHISTOUTDATA=medHistOutData, $
                          MEDHISTOUTTXT=medHistOutTxt, $
                          MEDHISTDATADIR=medHistDataDir, $
                          LOGAVGPLOT=logAvgPlot, $
                          DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                          ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                          FANCY_PLOTNAMES=fancy_plotNames

        h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

        h2dStrArr            = [h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN 
           dataNameArr       = [dataNameArr,dataName] 
           dataRawPtrArr     = [dataRawPtrArr,dataRawPtr] 
           varPlotH2DInds  = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
           varPlotRawInds  = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
           removed_ii_listArr = [removed_ii_listArr,LIST(out_removed_ii)]
        ENDIF 
        
        IF KEYWORD_SET(do_grossRate_fluxQuantities) $
           OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
           grossConvFactorArr   = [grossConvFactorArr,grossConvFactor]
        ENDIF

     ENDFOR
  ENDIF
  
  ;;########Poynting Flux########
  IF KEYWORD_SET(pplots) THEN BEGIN
     GET_FLUX_PLOTDATA,maximus,plot_i,$
                       /GET_PFLUX, $
                       MINM=minM, $
                       MAXM=maxM, $
                       BINM=binM, $
                       SHIFTM=shiftM, $
                       MINI=minI, $
                       MAXI=maxI, $
                       BINI=binI, $
                       DO_LSHELL=do_lshell, $
                       MINL=minL, $
                       MAXL=maxL, $
                       BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT, $
                       OUTH2DBINSILAT=outH2DBinsILAT, $
                       OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       PLOTRANGE=PPlotRange, $
                       PLOTAUTOSCALE=KEYWORD_SET(autoscale_fluxPlots) OR KEYWORD_SET(autoscale_pPlots), $
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
                       THISTDENOMINATOR=tHistDenominator, $
                       DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                       MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                       H2DSTR=h2dStr, $
                       TMPLT_H2DSTR=tmplt_h2dStr, $
                       H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                       H2DFLUXN=h2dFluxN, $
                       H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                       OUT_H2DMASK=out_h2dMask, $
                       DATANAME=dataName, $
                       DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot, $
                       MEDHISTOUTDATA=medHistOutData, $
                       MEDHISTOUTTXT=medHistOutTxt, $
                       MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot, $
                       DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                       ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                       FANCY_PLOTNAMES=fancy_plotNames
     
     h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

     h2dStrArr            = [h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN 
        dataNameArr       = [dataNameArr,dataName] 
        dataRawPtrArr     = [dataRawPtrArr,dataRawPtr] 
        varPlotH2DInds  = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
        varPlotRawInds  = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
        removed_ii_listArr = [removed_ii_listArr,LIST(out_removed_ii)]
     ENDIF  
     
     IF KEYWORD_SET(do_grossRate_fluxQuantities) $
        OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        grossConvFactorArr   = [grossConvFactorArr,grossConvFactor]
     ENDIF

  ENDIF
  
  ;;########ION FLUX########
  IF KEYWORD_SET(ionPlots) THEN BEGIN
     FOR i=0,N_ELEMENTS(iFluxPlotType)-1 DO BEGIN
        fluxPlotType = iFluxPlotType[i]
        dims                  = SIZE(iPlotRange,/DIMENSIONS)
        CASE N_ELEMENTS(dims) OF 
           0:   plotRange     = !NULL
           1:   plotRange     = iPlotRange
           2:   plotRange     = iPlotRange[*,i]
        ENDCASE
        GET_FLUX_PLOTDATA,maximus,plot_i,/GET_IFLUX, $
                          MINM=minM, $
                          MAXM=maxM, $
                          BINM=binM, $
                          SHIFTM=shiftM, $
                          MINI=minI, $
                          MAXI=maxI, $
                          BINI=binI, $
                          DO_LSHELL=do_lshell, $
                          MINL=minL, $
                          MAXL=maxL, $
                          BINL=binL, $
                          OUTH2DBINSMLT=outH2DBinsMLT, $
                          OUTH2DBINSILAT=outH2DBinsILAT, $
                          OUTH2DBINSLSHELL=outH2DBinsLShell, $
                          FLUXPLOTTYPE=fluxPlotType, $
                          PLOTRANGE=plotRange, $
                          PLOTAUTOSCALE=KEYWORD_SET(autoscale_fluxPlots) OR KEYWORD_SET(autoscale_ionPlots), $
                          NOPOSFLUX=noPosIflux, $
                          NONEGFLUX=noNegIflux, $
                          ABSFLUX=absIflux, $
                          OUT_REMOVED_II=out_removed_ii, $
                          LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logIfPlot)), $
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
                          DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                          MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                          H2DSTR=h2dStr, $
                          TMPLT_H2DSTR=tmplt_h2dStr, $
                          H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                          H2DFLUXN=h2dFluxN, $
                          H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                          OUT_H2DMASK=out_h2dMask, $
                          DATANAME=dataName, $
                          DATARAWPTR=dataRawPtr, $
                          MEDIANPLOT=medianplot, $
                          MEDHISTOUTDATA=medHistOutData, $
                          MEDHISTOUTTXT=medHistOutTxt, $
                          MEDHISTDATADIR=medHistDataDir, $
                          LOGAVGPLOT=logAvgPlot, $
                          DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                          ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                          FANCY_PLOTNAMES=fancy_plotNames
        
        h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

        h2dStrArr            = [h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN 
           dataNameArr       = [dataNameArr,dataName] 
           dataRawPtrArr     = [dataRawPtrArr,dataRawPtr] 
           varPlotH2DInds  = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
           varPlotRawInds  = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
           removed_ii_listArr = [removed_ii_listArr,LIST(out_removed_ii)]
        ENDIF  
        
        IF KEYWORD_SET(do_grossRate_fluxQuantities) $
           OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
           grossConvFactorArr   = [grossConvFactorArr,grossConvFactor]
        ENDIF

     ENDFOR
  ENDIF

  ;;########OXY FLUX########
  IF KEYWORD_SET(oxyPlots) THEN BEGIN
     GET_FLUX_PLOTDATA,maximus,plot_i,/GET_OXYFLUX, $
                       MINM=minM, $
                       MAXM=maxM, $
                       BINM=binM, $
                       SHIFTM=shiftM, $
                       MINI=minI, $
                       MAXI=maxI, $
                       BINI=binI, $
                       DO_LSHELL=do_lshell, $
                       MINL=minL, $
                       MAXL=maxL, $
                       BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT, $
                       OUTH2DBINSILAT=outH2DBinsILAT, $
                       OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       FLUXPLOTTYPE=oxyFluxPlotType, $
                       PLOTRANGE=oxyPlotRange, $
                       PLOTAUTOSCALE=KEYWORD_SET(autoscale_fluxPlots) OR KEYWORD_SET(autoscale_oxyPlots), $
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
                       THISTDENOMINATOR=tHistDenominator, $
                       DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                       MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                       H2DSTR=h2dStr, $
                       TMPLT_H2DSTR=tmplt_h2dStr, $
                       H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                       H2DFLUXN=h2dFluxN, $
                       H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                       OUT_H2DMASK=out_h2dMask, $
                       DATANAME=dataName, $
                       DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot, $
                       MEDHISTOUTDATA=medHistOutData, $
                       MEDHISTOUTTXT=medHistOutTxt, $
                       MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot, $
                       DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                       ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                       FANCY_PLOTNAMES=fancy_plotNames
     
     h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

     h2dStrArr            = [h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN 
        dataNameArr       = [dataNameArr,dataName] 
        dataRawPtrArr     = [dataRawPtrArr,dataRawPtr] 
        varPlotH2DInds  = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
        varPlotRawInds  = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
        removed_ii_listArr = [removed_ii_listArr,LIST(out_removed_ii)]
     ENDIF  
     
     IF KEYWORD_SET(do_grossRate_fluxQuantities) $
        OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        grossConvFactorArr   = [grossConvFactorArr,grossConvFactor]
     ENDIF

  ENDIF

  ;;########CHARACTERISTIC ELECTRON ENERGY########
  IF KEYWORD_SET(charEPlots) THEN BEGIN
     FOR i=0,N_ELEMENTS(charEType)-1 DO BEGIN
        fluxPlotType = charEType[i]
        dims                  = SIZE(charEPlotRange,/DIMENSIONS)
        CASE N_ELEMENTS(dims) OF 
           0:   plotRange     = !NULL
           1:   plotRange     = charEPlotRange
           2:   plotRange     = charEPlotRange[*,i]
        ENDCASE
        GET_FLUX_PLOTDATA,maximus,plot_i,/GET_CHAREE, $
                          MINM=minM, $
                          MAXM=maxM, $
                          BINM=binM, $
                          SHIFTM=shiftM, $
                          MINI=minI, $
                          MAXI=maxI, $
                          BINI=binI, $
                          DO_LSHELL=do_lshell, $
                          MINL=minL, $
                          MAXL=maxL, $
                          BINL=binL, $
                          OUTH2DBINSMLT=outH2DBinsMLT, $
                          OUTH2DBINSILAT=outH2DBinsILAT, $
                          OUTH2DBINSLSHELL=outH2DBinsLShell, $
                          FLUXPLOTTYPE=charEType, $
                          PLOTRANGE=plotRange, $
                          PLOTAUTOSCALE=KEYWORD_SET(autoscale_fluxPlots) OR KEYWORD_SET(autoscale_charEPlots), $
                          NOPOSFLUX=noPosCharE, $
                          NONEGFLUX=noNegCharE, $
                          ABSFLUX=absCharE, $
                          OUT_REMOVED_II=out_removed_ii, $
                          LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logCharEPlot)), $
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
                          DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                          MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                          H2DSTR=h2dStr, $
                          TMPLT_H2DSTR=tmplt_h2dStr, $
                          H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                          H2DFLUXN=h2dFluxN, $
                          H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                          OUT_H2DMASK=out_h2dMask, $
                          DATANAME=dataName, $
                          DATARAWPTR=dataRawPtr, $
                          MEDIANPLOT=medianplot, $
                          MEDHISTOUTDATA=medHistOutData, $
                          MEDHISTOUTTXT=medHistOutTxt, $
                          MEDHISTDATADIR=medHistDataDir, $
                          LOGAVGPLOT=logAvgPlot, $
                          DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                          ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                          FANCY_PLOTNAMES=fancy_plotNames

        h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

        h2dStrArr            = [h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN 
           dataNameArr       = [dataNameArr,dataName] 
           dataRawPtrArr     = [dataRawPtrArr,dataRawPtr] 
           varPlotH2DInds  = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
           varPlotRawInds  = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
           removed_ii_listArr = [removed_ii_listArr,LIST(out_removed_ii)]
        ENDIF  
        
        IF KEYWORD_SET(do_grossRate_fluxQuantities) $
           OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
           grossConvFactorArr   = [grossConvFactorArr,grossConvFactor]
        ENDIF

     ENDFOR
  ENDIF
  
  ;;########CHARACTERISTIC ION ENERGY########
  IF KEYWORD_SET(chariEPlots) THEN BEGIN
     GET_FLUX_PLOTDATA,maximus,plot_i,/GET_CHARIE, $
                       MINM=minM, $
                       MAXM=maxM, $
                       BINM=binM, $
                       SHIFTM=shiftM, $
                       MINI=minI, $
                       MAXI=maxI, $
                       BINI=binI, $
                       DO_LSHELL=do_lshell, $
                       MINL=minL, $
                       MAXL=maxL, $
                       BINL=binL, $
                       OUTH2DBINSMLT=outH2DBinsMLT, $
                       OUTH2DBINSILAT=outH2DBinsILAT, $
                       OUTH2DBINSLSHELL=outH2DBinsLShell, $
                       PLOTRANGE=chariEPlotRange, $
                       PLOTAUTOSCALE=KEYWORD_SET(autoscale_fluxPlots) OR KEYWORD_SET(autoscale_chariEPlots), $
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
                       THISTDENOMINATOR=tHistDenominator, $
                       DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                       MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                       H2DSTR=h2dStr, $
                       TMPLT_H2DSTR=tmplt_h2dStr, $
                       H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                       H2DFLUXN=h2dFluxN, $
                       H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                       OUT_H2DMASK=out_h2dMask, $
                       DATANAME=dataName, $
                       DATARAWPTR=dataRawPtr, $
                       MEDIANPLOT=medianplot, $
                       MEDHISTOUTDATA=medHistOutData, $
                       MEDHISTOUTTXT=medHistOutTxt, $
                       MEDHISTDATADIR=medHistDataDir, $
                       LOGAVGPLOT=logAvgPlot, $
                       DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                       ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                       FANCY_PLOTNAMES=fancy_plotNames
     
     h2dStrArr[KEYWORD_SET(nPlots)].data = out_h2dMask

     h2dStrArr            = [h2dStrArr,h2dStr] 
     IF keepMe THEN BEGIN 
        dataNameArr       = [dataNameArr,dataName] 
        dataRawPtrArr     = [dataRawPtrArr,dataRawPtr] 
        varPlotH2DInds  = [varPlotH2DInds,N_ELEMENTS(h2dStrArr)-1]
        varPlotRawInds  = [varPlotRawInds,N_ELEMENTS(dataRawPtrArr)-1]
        removed_ii_listArr = [removed_ii_listArr,LIST(out_removed_ii)]
     ENDIF  
     
     IF KEYWORD_SET(do_grossRate_fluxQuantities) $
        OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        grossConvFactorArr   = [grossConvFactorArr,grossConvFactor]
     ENDIF

  ENDIF

  ;;########BONUS########
  IF KEYWORD_SET(sum_electron_and_poyntingflux) THEN BEGIN
     
     IF KEYWORD_SET(eNumFlPlots) AND KEYWORD_SET(pplots) THEN BEGIN
        ePlotInd            = WHERE(STRMATCH(dataNameArr, '*enumfl*', /FOLD_CASE) EQ 1)
        pPlotInd            = WHERE(STRMATCH(dataNameArr, '*pflux*', /FOLD_CASE) EQ 1)

        IF ePlotInd[0] NE -1 AND pPlotInd[0] NE -1 THEN BEGIN
           h2dStrEP         = tmplt_h2dStr
           EPdataName       = 'summed_e_and_p'
           h2dStrEP.title   = "Summed e- and Poynting flux (mW/m!U2!N)"
           h2dStrEP.lim     = [0.00,0.35]
           h2dStrEP.logLabels = 0
           h2dStrEP.data       = h2dStrArr[ePlotInd].data+h2dStrArr[pPlotInd].data

           ;;Add this curiosity to the mix
           dataNameArr        = [dataNameArr,EPdataName]
           h2dStrArr          = [h2dStrArr,h2dStrEP]
        ENDIF ELSE BEGIN
           PRINT,"Couldn't locate eplot and pplot for summing!"
           STOP
        ENDELSE
     ENDIF ELSE BEGIN
        PRINT,'Have to set eplots and pplots keywords to make this work'
     ENDELSE
  ENDIF


                                ;#####Custom maxInd--the best!!##########
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

        GET_CUSTOM_MAXIND_PLOTDATA,maximus,plot_i,custom_maxInds[i], $
                                   CUSTOM_DATANAME=custom_dataname, $
                                   CUSTOM_TITLE=custom_title, $
                                   MINM=minM,MAXM=maxM, $
                                   BINM=binM, $
                                   SHIFTM=shiftM, $
                                   MINI=minI,MAXI=maxI,BINI=binI, $
                                   DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                   OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT, $
                                   OUTH2DBINSLSHELL=outH2DBinsLShell, $
                                   PLOTRANGE=custom_range, $
                                   PLOTAUTOSCALE=custom_autoscale, $
                                   NOPOSFLUX=noPosFlux, $
                                   NONEGFLUX=noNegFlux, $
                                   ABSFLUX=absFlux, $
                                   OUT_REMOVED_II=out_removed_ii, $
                                   LOGPLOT=log_custom, $
                                   DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                                   MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
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
                                   THISTDENOMINATOR=tHistDenominator, $
                                   H2DSTR=h2dStr, $
                                   TMPLT_H2DSTR=tmplt_h2dStr, $
                                   H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                                   H2DFLUXN=h2dFluxN, $
                                   H2DMASK=h2dStrArr[KEYWORD_SET(nPlots)].data, $
                                   OUT_H2DMASK=out_h2dMask, $
                                   DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                                   MEDIANPLOT=medianplot, $
                                   MEDHISTOUTDATA=medHistOutData, $
                                   MEDHISTOUTTXT=medHistOutTxt, $
                                   MEDHISTDATADIR=medHistDataDir, $
                                   LOGAVGPLOT=logAvgPlot, $
                                   DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                                   ORBCONTRIB_H2DSTR_FOR_DIVISION=h2dContribOrbStr, $
                                   DO_PLOT_I_INSTEAD_OF_HISTOS=do_plot_i_instead_of_histos, $
                                   PRINT_MAX_AND_MIN=print_mandm, $
                                   FANCY_PLOTNAMES=fancy_plotNames, $
                                   LUN=lun
        

        h2dStrArr=[h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN 
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
  ;; n_zero                     = N_ELEMENTS(h2dFluxN)-N_ELEMENTS(h2d_nonzero_nEv_i)
  ;; FOR i = 2, N_ELEMENTS(h2dStrArr)-1 DO BEGIN 
  ;;    IF n_elements(where(h2dStrArr[i].data EQ 0,/NULL)) LT $
  ;;       n_zero THEN BEGIN 
  ;;       printf,lun,"h2dStrArr."+h2dStrArr[i].title + " has ", strtrim(n_elements(where(h2dStrArr[i].data EQ 0)),2)," elements that are zero, whereas FluxN has ", strtrim(n_zero,2),"." 
  ;;    printf,lun,"Sorry, can't plot anything meaningful." & ENDIF
  ;; ENDFOR

  IF KEYWORD_SET(add_variance_plots) OR KEYWORD_SET(only_variance_plots) THEN BEGIN
     PRINTF,lun,"Getting variance plot data ..."

     ;;some temp vars
     var_h2dStrArr                  = !NULL
     var_dataNameArr                = !NULL

     MAKE_H2D_WITH_LIST_OF_INDS_FOR_EACH_BIN,maximus,plot_i, $
                                             OUTH2D_LISTS_WITH_INDS=outH2D_lists_with_inds,$
                                             MINMLT=minM, $
                                             MAXMLT=maxM, $
                                             BINMLT=binM, $
                                             SHIFTMLT=shiftM, $
                                             MINILAT=minI, $
                                             MAXILAT=maxI, $
                                             BINILAT=binI, $
                                             DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                                             OUTFILEPREFIX=outFilePrefix, $
                                             OUTFILESUFFIX=outFileSuffix, $
                                             OUTDIR=outDir, $
                                             OUTPUT_TEXTFILE=output_textFile, $
                                             /FILL_WITH_INDICES_INTO_PLOT_I, $
                                             ;; RESET_H2D_LISTS_WITH_INDS=reset_h2d_lists_with_inds, $
                                             /RESET_H2D_LISTS_WITH_INDS, $
                                             LUN=lun

     FOR i=0,N_ELEMENTS(varPlotRawInds)-1 DO BEGIN
        
        dbStruct_obsArr               = *dataRawPtrArr[varPlotRawInds[i]]
        IF N_ELEMENTS((removed_ii_listArr[i])[0]) GT 0 THEN BEGIN
           dont_use_these_inds           = (removed_ii_listArr[i])[0]
        ENDIF ELSE BEGIN 
           dont_use_these_inds   = !NULL
        ENDELSE

        IF KEYWORD_SET(grossConvFactorArr) THEN grossConvFactor = grossConvFactorArr[i]

        MAKE_H2D_WITH_LIST_OF_OBS_AND_OBS_STATISTICS,dbStruct_obsArr, $
           DONT_USE_THESE_INDS=dont_use_these_inds, $
           /DO_LISTS_WITH_STATS, $
           DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
           GROSSRATE__H2D_AREAS=h2dAreas, $
           DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
           GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
           GROSSCONVFACTOR=grossConvFactor, $
           OUTH2D_LISTS_WITH_OBS=outH2D_lists_with_obs,$
           OUTH2D_STATS=outH2D_stats, $
           OUTFILEPREFIX=outFilePrefix, $
           OUTFILESUFFIX=outFileSuffix, $
           OUTDIR=outDir, $
           OUTPUT_TEXTFILE=output_textFile, $
           LUN=lun

           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;;Now get it all set up
        h2dStrTemp                     = h2dStrArr[varPlotH2DInds[i]]
        IF KEYWORD_SET(var__do_stddev_instead) THEN BEGIN
           dataNameTemp                = dataNameArr[varPlotH2DInds[i]] + '_stddev'
        ENDIF ELSE BEGIN
           dataNameTemp                = dataNameArr[varPlotH2DInds[i]] + '_var'
        ENDELSE
        h2dStrTemp.data                = REFORM(outH2D_stats[1,*,*])

           ;;;;;;;;;;;;;;;;;;;; 
        ;;set up lims--2 std devs on either side
        ;; tempMed                        = MEDIAN(h2dStrTemp.data)
        notMasked                      = WHERE(h2dStrArr[KEYWORD_SET(nPlots)].data LT 250.)
        tempStats                      = MOMENT(h2dStrTemp.data[notMasked])
        h2dStrTemp.do_posNeg_cb        = 1
        h2dStrTemp.force_oobLow        = 0
        h2dStrTemp.force_oobHigh       = 0

        ;;handle ranges
        IF KEYWORD_SET(var__plotRange) OR KEYWORD_SET(var__autoscale) THEN BEGIN
           IF KEYWORD_SET(var__plotRange) AND KEYWORD_SET(var__autoscale) THEN BEGIN
              PRINTF,lun,"Both var__plotRange and var__autoscale are set! Assuming you'd rather have me autoscale..."
           ENDIF
           CASE 1 OF
              KEYWORD_SET(var__autoscale): BEGIN
                 h2dStrTemp.lim        = [MIN(h2dStrTemp.data[h2d_nonzero_nEv_i]), $
                                          MAX(h2dStrTemp.data[h2d_nonzero_nEv_i])]
              END
              KEYWORD_SET(var__plotRange): BEGIN
                 IF N_ELEMENTS(SIZE(var__plotRange,/DIMENSIONS)) GT 1 THEN BEGIN
                    h2dStrTemp.lim     = var__plotRange[*,i]
                 ENDIF ELSE BEGIN
                    h2dStrTemp.lim     = var__plotRange
                 ENDELSE
              END
           ENDCASE
        ENDIF
        
        IF KEYWORD_SET(var__rel_to_mean_variance) THEN BEGIN
           ;; IF KEYWORD_SET(var__do_stddev_instead) THEN BEGIN
           ;;    h2dStrTemp.data          = SQRT(h2dStrTemp.data) - SQRT(tempStats[0])
           ;;    h2dStrTemp.lim           = [-2.*SQRT(tempStats[1]), $
           ;;                                2.*SQRT(tempStats[1])]
           ;;    h2dStrTemp.title        += " (Stddev. rel.to mean stddev.)"
           ;; ENDIF ELSE BEGIN
           h2dStrTemp.data             = h2dStrTemp.data - tempStats[0]
           IF ~KEYWORD_SET(var__plotRange) THEN BEGIN
              h2dStrTemp.lim                 = [-2.*tempStats[1], $
                                                2.*tempStats[1]]
           ENDIF
           ;; h2dStrTemp.lim           = h2dStrTemp.lim - tempStats[0]
           h2dStrTemp.title        += " (Var. rel.to meanVar)"
           ;; ENDELSE
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(var__do_stddev_instead) THEN BEGIN
              h2dStrTemp.data          = SQRT(h2dStrTemp.data)
              IF ~KEYWORD_SET(var__plotRange) THEN BEGIN
                 h2dStrTemp.lim        = [SQRT(tempStats[0])-2.*SQRT(tempStats[1]), $
                                          SQRT(tempStats[0])+2.*SQRT(tempStats[1])]
              ENDIF
              h2dStrTemp.title        += " (Stddev.)"
           ENDIF ELSE BEGIN
              ;; h2dStrTemp.lim                 = [tempStats[0]-2.*tempStats[1], $
              ;;                                   tempStats[0]+2.*tempStats[1]]
              IF ~KEYWORD_SET(var__plotRange) THEN BEGIN
                 h2dStrTemp.lim        = [MIN(h2dStrTemp.data[notMasked]),MAX(h2dStrTemp.data[notMasked])]
              ENDIF
              h2dStrTemp.title        += " (Var.)"
           ENDELSE
        ENDELSE

        ;;Show us
        IF KEYWORD_SET(print_mandm) THEN BEGIN
           IF KEYWORD_SET(medianPlot) OR ~KEYWORD_SET(logAvgPlot) THEN BEGIN
              fmt    = 'G10.4' 
              maxh2d = MAX(h2dStrTemp.data[h2d_nonzero_nEv_i])
              minh2d = MIN(h2dStrTemp.data[h2d_nonzero_nEv_i])
              medh2d = MEDIAN(h2dStrTemp.data[h2d_nonzero_nEv_i])
           ENDIF ELSE BEGIN
              fmt    = 'F10.2'
              maxh2d = ALOG10(MAX(h2dStrTemp.data[h2d_nonzero_nEv_i]))
              minh2d = ALOG10(MIN(h2dStrTemp.data[h2d_nonzero_nEv_i]))
              medh2d = ALOG10(MEDIAN(h2dStrTemp.data[h2d_nonzero_nEv_i]))
           ENDELSE
           PRINTF,lun,h2dStrTemp.title
           ;; PRINTF,lun,FORMAT='("Max, min:",T20,F10.2,T35,F10.2)', $
           ;;        MAX(h2dStrTemp.data[h2d_nonzero_nEv_i]), $
           ;;        MIN(h2dStrTemp.data[h2d_nonzero_nEv_i])
           PRINTF,lun,FORMAT='("Max, min. med:",T20,' + fmt + ',T35,' + fmt + ',T50,' + fmt +')', $
                  maxh2d, $
                  minh2d, $
                  medh2d            
        ENDIF

        var_h2dStrArr                  = [var_h2dStrArr,h2dStrTemp]
        var_dataNameArr                = [var_dataNameArr,dataNameTemp]
     ENDFOR

     ;;Now update dat!!!
     CASE 1 OF
        KEYWORD_SET(only_variance_plots): BEGIN
           dataNameArr                 = [dataNameArr[KEYWORD_SET(nPlots)],var_dataNameArr]
           h2dStrArr                   = [h2dStrArr[KEYWORD_SET(nPlots)],var_h2dStrArr]
           nPlots                      = 0
        END
        KEYWORD_SET(add_variance_plots): BEGIN
           dataNameArr                 = [dataNameArr,var_dataNameArr]
           h2dStrArr                   = [h2dStrArr,var_h2dStrArr]
        END
     ENDCASE

  ENDIF

  ;;Now that we're done using nplots, let's log it, if requested:
  IF KEYWORD_SET(nPlots) THEN BEGIN
     IF KEYWORD_SET(logNEventsPlot) OR KEYWORD_SET(all_logPlots) THEN BEGIN
        IF KEYWORD_SET(nEventsPlotNormalize) THEN BEGIN
           PRINT,"You realize you're asking me to both log-a-tize and normalize the nEvents plot, right?"
           WAIT,5
        ENDIF
        dataNameArr[0]         = 'log_' + dataNameArr[0]
        h2dStrArr[0].data[h2d_nonzero_nEv_i] = ALOG10(h2dStrArr[0].data[h2d_nonzero_nEv_i])
        h2dStrArr[0].lim       = [(h2dStrArr[0].lim[0] LT 1) ? 0 : ALOG10(h2dStrArr[0].lim[0]),ALOG10(h2dStrArr[0].lim[1])] ;lower bound must be one
        h2dStrArr[0].title     = 'Log ' + h2dStrArr[0].title
        h2dStrArr[0].is_logged = 1
     ENDIF
     IF KEYWORD_SET(nEventsPlotNormalize) THEN BEGIN
        dataNameArr[0]        += '_normed'
        maxNEv                 = MAX(h2dStrArr[0].data[h2d_nonzero_nEv_i])
        h2dStrArr[0].data      = h2dStrArr[0].data/maxNEv
        h2dStrArr[0].lim       = [0.0,1.0]
        h2dStrArr[0].title    += STRING(FORMAT='(" (norm: ",G0.3,")")',maxNEv)
        ;; h2dStrArr[0].dont_mask_me = 1
     ENDIF
     IF KEYWORD_SET(nEventsPlotAutoscale) THEN BEGIN
        PRINT,"Autoscaling nEvents plot..."
        h2dStrArr[0].lim       = [MIN(h2dStrArr[0].data[h2d_nonzero_nEv_i]), $
                                  MAX(h2dStrArr[0].data[h2d_nonzero_nEv_i])]
     ENDIF
  ENDIF

END