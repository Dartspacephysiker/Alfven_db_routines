
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
                          STABLEIMF=stableIMF, $
                          SMOOTHWINDOW=smoothWindow, $
                          INCLUDENOCONSECDATA=includeNoConsecData, $
                          DO_UTC_RANGE=DO_UTC_range, $
                          STORMSTRING=stormString, $
                          DSTCUTOFF=dstCutoff, $
                          T1_ARR=t1_arr, $
                          T2_ARR=t2_arr, $             
                          NPLOTS=nPlots, $
                          NEVENTSPLOTRANGE=nEventsPlotRange, $
                          LOGNEVENTSPLOT=logNEventsPlot, $
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
                          ORBCONTRIBPLOT=orbContribPlot, $
                          ORBTOTPLOT=orbTotPlot, $
                          ORBFREQPLOT=orbFreqPlot, $
                          ORBCONTRIBRANGE=orbContribRange, $
                          ORBTOTRANGE=orbTotRange, $
                          ORBFREQRANGE=orbFreqRange, $
                          NEVENTPERORBPLOT=nEventPerOrbPlot, $
                          LOGNEVENTPERORB=logNEventPerOrb, $
                          NEVENTPERORBRANGE=nEventPerOrbRange, $
                          DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                          NEVENTPERMINPLOT=nEventPerMinPlot, $
                          NEVENTPERMINRANGE=nEventPerMinRange, $
                          LOGNEVENTPERMIN=logNEventPerMin, $
                          PROBOCCURRENCEPLOT=probOccurrencePlot, $
                          PROBOCCURRENCERANGE=probOccurrenceRange, $
                          LOGPROBOCCURRENCE=logProbOccurrence, $
                          TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
                          TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
                          LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
                          TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
                          TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
                          LOGTIMEAVGD_EFLUXMAX=logTimeAvgd_EFluxMax, $
                          DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                          DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                          MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
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

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

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
        dataRawPtrArr=dataRawPtr
        dataNameArr=[dataName,"histoMask"] 
        dataRawPtrArr=[dataRawPtrArr,PTR_NEW(h2dMaskStr.data)] 
     ENDIF
     IF KEYWORD_SET(nPlots) THEN h2dStrArr=[h2dStr,h2dMaskStr] ELSE h2dStrArr = h2dMaskStr
     
     ;;Get tHist denominator here so other routines can use it as they please
     IF KEYWORD_SET(nEventPerMinPlot) OR KEYWORD_SET(probOccurrencePlot) $
        OR KEYWORD_SET(timeAvgd_pfluxPlot) OR KEYWORD_SET(timeAvgd_eFluxMaxPlot) $
        OR KEYWORD_SET(do_timeAvg_fluxQuantities) THEN BEGIN 
        tHistDenominator = GET_TIMEHIST_DENOMINATOR(CLOCKSTR=clockStr, $
                                                    ANGLELIM1=angleLim1, $
                                                    ANGLELIM2=angleLim2, $
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
                                                    STABLEIMF=stableIMF, $
                                                    SMOOTHWINDOW=smoothWindow, $
                                                    INCLUDENOCONSECDATA=includeNoConsecData, $
                                                    DO_UTC_RANGE=do_UTC_range, $
                                                    STORMSTRING=stormString, $
                                                    DSTCUTOFF=dstCutoff, $
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
                                                    ;; FASTLOC_STRUCT=fastLoc, $
                                                    ;; FASTLOC_TIMES=fastLoc_Times, $
                                                    ;; FASTLOC_DELTA_T=fastLoc_delta_t, $
                                                    ;; FASTLOCFILE=fastLocFile, $
                                                    ;; FASTLOCTIMEFILE=fastLocTimeFile, $
                                                    FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                                    INDSFILEPREFIX=ParamStrPrefix, $
                                                    INDSFILESUFFIX=paramStrSuffix, $
                                                    BURSTDATA_EXCLUDED=burstData_excluded, $
                                                    DATANAMEARR=dataNameArr, $
                                                    DATARAWPTRARR=dataRawPtrArr, $
                                                    KEEPME=keepme)
     ENDIF
        
     ;;#####FLUX QUANTITIES#########
     ;;########ELECTRON FLUX########
     IF KEYWORD_SET(eplots) THEN BEGIN
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
                          FLUXPLOTTYPE=eFluxPlotType, $
                          PLOTRANGE=ePlotRange, $
                          NOPOSFLUX=noPoseflux, $
                          NONEGFLUX=noNegeflux, $
                          ABSFLUX=abseflux, $
                          LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logEfPlot)), $
                          DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                          THISTDENOMINATOR=tHistDenominator, $
                          DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                          MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                          H2DSTR=h2dStr, $
                          TMPLT_H2DSTR=tmplt_h2dStr, $
                          H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                          H2DFLUXN=h2dFluxN, $
                          DATANAME=dataName, $
                          DATARAWPTR=dataRawPtr, $
                          MEDIANPLOT=medianplot, $
                          MEDHISTOUTDATA=medHistOutData, $
                          MEDHISTOUTTXT=medHistOutTxt, $
                          MEDHISTDATADIR=medHistDataDir, $
                          LOGAVGPLOT=logAvgPlot, $
                          FANCY_PLOTNAMES=fancy_plotNames

        
        h2dStrArr=[h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN
           dataNameArr=[dataNameArr,dataName] 
           dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
        ENDIF 
     ENDIF
     
     ;;########ELECTRON NUMBER FLUX########
     IF KEYWORD_SET(eNumFlPlots) THEN BEGIN
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
                          FLUXPLOTTYPE=eNumFlPlotType, $
                          PLOTRANGE=ENumFlPlotRange, $
                          NOPOSFLUX=noPosENumFl, $
                          NONEGFLUX=noNegENumFl, $
                          ABSFLUX=absENumFl, $
                          LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logENumFlPlot)), $
                          DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                          THISTDENOMINATOR=tHistDenominator, $
                          DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                          MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                          H2DSTR=h2dStr, $
                          TMPLT_H2DSTR=tmplt_h2dStr, $
                          H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                          H2DFLUXN=h2dFluxN, $
                          DATANAME=dataName, $
                          DATARAWPTR=dataRawPtr, $
                          MEDIANPLOT=medianplot, $
                          MEDHISTOUTDATA=medHistOutData, $
                          MEDHISTOUTTXT=medHistOutTxt, $
                          MEDHISTDATADIR=medHistDataDir, $
                          LOGAVGPLOT=logAvgPlot, $
                          FANCY_PLOTNAMES=fancy_plotNames

        h2dStrArr=[h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN 
           dataNameArr=[dataNameArr,dataName] 
           dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
        ENDIF 
        
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
                          NOPOSFLUX=noPosPflux, $
                          NONEGFLUX=noNegPflux, $
                          ABSFLUX=absPflux, $
                          LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logPfPlot)), $
                          DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                          THISTDENOMINATOR=tHistDenominator, $
                          DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                          MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                          H2DSTR=h2dStr, $
                          TMPLT_H2DSTR=tmplt_h2dStr, $
                          H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                          H2DFLUXN=h2dFluxN, $
                          DATANAME=dataName, $
                          DATARAWPTR=dataRawPtr, $
                          MEDIANPLOT=medianplot, $
                          MEDHISTOUTDATA=medHistOutData, $
                          MEDHISTOUTTXT=medHistOutTxt, $
                          MEDHISTDATADIR=medHistDataDir, $
                          LOGAVGPLOT=logAvgPlot, $
                          FANCY_PLOTNAMES=fancy_plotNames
        
        h2dStrArr=[h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN 
           dataNameArr=[dataNameArr,dataName] 
           dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
        ENDIF  
        
     ENDIF
     
     ;;########ION FLUX########
     IF KEYWORD_SET(ionPlots) THEN BEGIN
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
                          FLUXPLOTTYPE=iFluxPlotType, $
                          PLOTRANGE=iPlotRange, $
                          NOPOSFLUX=noPosIflux, $
                          NONEGFLUX=noNegIflux, $
                          ABSFLUX=absIflux, $
                          LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logIfPlot)), $
                          DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                          THISTDENOMINATOR=tHistDenominator, $
                          DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                          MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                          H2DSTR=h2dStr, $
                          TMPLT_H2DSTR=tmplt_h2dStr, $
                          H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                          H2DFLUXN=h2dFluxN, $
                          DATANAME=dataName, $
                          DATARAWPTR=dataRawPtr, $
                          MEDIANPLOT=medianplot, $
                          MEDHISTOUTDATA=medHistOutData, $
                          MEDHISTOUTTXT=medHistOutTxt, $
                          MEDHISTDATADIR=medHistDataDir, $
                          LOGAVGPLOT=logAvgPlot, $
                          FANCY_PLOTNAMES=fancy_plotNames
        
        h2dStrArr=[h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN 
           dataNameArr=[dataNameArr,dataName] 
           dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
        ENDIF  
        
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
                          NOPOSFLUX=noPosOxyFlux, $
                          NONEGFLUX=noNegOxyflux, $
                          ABSFLUX=absOxyFlux, $
                          LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logOxyfPlot)), $
                          DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                          THISTDENOMINATOR=tHistDenominator, $
                          DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                          MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                          H2DSTR=h2dStr, $
                          TMPLT_H2DSTR=tmplt_h2dStr, $
                          H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                          H2DFLUXN=h2dFluxN, $
                          DATANAME=dataName, $
                          DATARAWPTR=dataRawPtr, $
                          MEDIANPLOT=medianplot, $
                          MEDHISTOUTDATA=medHistOutData, $
                          MEDHISTOUTTXT=medHistOutTxt, $
                          MEDHISTDATADIR=medHistDataDir, $
                          LOGAVGPLOT=logAvgPlot, $
                          FANCY_PLOTNAMES=fancy_plotNames
        
        h2dStrArr=[h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN 
           dataNameArr=[dataNameArr,dataName] 
           dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
        ENDIF  
        
     ENDIF

     ;;########CHARACTERISTIC ELECTRON ENERGY########
     IF KEYWORD_SET(charEPlots) THEN BEGIN
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
                          PLOTRANGE=charEPlotRange, $
                          NOPOSFLUX=noPosCharE, $
                          NONEGFLUX=noNegCharE, $
                          ABSFLUX=absCharE, $
                          LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logCharEPlot)), $
                          DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                          THISTDENOMINATOR=tHistDenominator, $
                          DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                          MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                          H2DSTR=h2dStr, $
                          TMPLT_H2DSTR=tmplt_h2dStr, $
                          H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                          H2DFLUXN=h2dFluxN, $
                          DATANAME=dataName, $
                          DATARAWPTR=dataRawPtr, $
                          MEDIANPLOT=medianplot, $
                          MEDHISTOUTDATA=medHistOutData, $
                          MEDHISTOUTTXT=medHistOutTxt, $
                          MEDHISTDATADIR=medHistDataDir, $
                          LOGAVGPLOT=logAvgPlot, $
                          FANCY_PLOTNAMES=fancy_plotNames

        h2dStrArr=[h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN 
           dataNameArr=[dataNameArr,dataName] 
           dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
        ENDIF  
        
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
                          NOPOSFLUX=noPosChariE, $
                          NONEGFLUX=noNegChariE, $
                          ABSFLUX=absChariE, $
                          LOGFLUXPLOT=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logChariEPlot)), $
                          DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                          THISTDENOMINATOR=tHistDenominator, $
                          DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                          MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                          H2DSTR=h2dStr, $
                          TMPLT_H2DSTR=tmplt_h2dStr, $
                          H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                          H2DFLUXN=h2dFluxN, $
                          DATANAME=dataName, $
                          DATARAWPTR=dataRawPtr, $
                          MEDIANPLOT=medianplot, $
                          MEDHISTOUTDATA=medHistOutData, $
                          MEDHISTOUTTXT=medHistOutTxt, $
                          MEDHISTDATADIR=medHistDataDir, $
                          LOGAVGPLOT=logAvgPlot, $
                          FANCY_PLOTNAMES=fancy_plotNames
        
        h2dStrArr=[h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN 
           dataNameArr=[dataNameArr,dataName] 
           dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
        ENDIF  
        
     ENDIF


     ;;########Orbits########
     ;;Now do orbit data to show how many orbits contributed to each thingy.
     ;;A little extra tomfoolery is in order to get this right
     ;;h2dOrbN is a 2d histo just like the others
     ;;orbArr, on the other hand, is a 3D array, where the
     ;;2D array pointed to is indexed by MLTbin and ILATbin. The contents of
     ;;the 3D array are of the format [UniqueOrbs_ii index,MLT,ILAT]
     
     ;;The following two lines shouldn't be necessary; the data are being corrupted somewhere when I run this with clockstr="dawnward"
     uniqueOrbs_ii=UNIQ(maximus.orbit[plot_i],SORT(maximus.orbit[plot_i]))
     uniqueOrbs_i=plot_i[uniqueOrbs_ii]
     nOrbs=N_ELEMENTS(uniqueOrbs_i)
     
     IF KEYWORD_SET(orbContribPlot) OR KEYWORD_SET(orbfreqplot) OR KEYWORD_SET(neventperorbplot) OR KEYWORD_SET(numOrbLim) THEN BEGIN
        
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
                                         ORBCONTRIBRANGE=orbContribRange, $
                                         UNIQUEORBS_I=uniqueOrbs_i, $
                                         H2D_NONZERO_CONTRIBORBS_I=h2d_nonzero_contribOrbs_i, $
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

     ;;########TOTAL Orbits########
     IF KEYWORD_SET(orbtotplot) OR KEYWORD_SET(orbfreqplot) OR KEYWORD_SET(neventperorbplot) THEN BEGIN
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
                                       ORBFREQRANGE=orbFreqRange, $
                                       DIVNEVBYAPPLICABLE=divNEvByApplicable, $
                                       H2DSTR=h2dStr, $
                                       TMPLT_H2DSTR=tmplt_h2dStr, $
                                       H2DFLUXN=h2dFluxN, $
                                       H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
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
                                  DATANAME=dataName, $
                                  DATARAWPTR=dataRawPtr
        
        h2dStrArr=[h2dStrArr,h2dStr] 
        IF keepMe THEN BEGIN 
           dataNameArr=[dataNameArr,dataName] 
           dataRawPtrArr=[dataRawPtrArr,dataRawPtr] 
        ENDIF 
     ENDIF
     
     ;;########Event probability########
     IF KEYWORD_SET(probOccurrencePlot) THEN BEGIN
        GET_PROB_OCCURRENCE_PLOTDATA,maximus,plot_i,tHistDenominator, $
                                     LOGPROBOCCURRENCE=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logProbOccurrence)), $
                                     PROBOCCURRENCERANGE=probOccurrenceRange, $
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

     ;;########Time-averaged Poynting flux########
     IF KEYWORD_SET(timeAvgd_pfluxPlot) THEN BEGIN
        GET_PROB_OCCURRENCE_PLOTDATA,maximus,plot_i,tHistDenominator, $
                                     ;; DO_WIDTH_X=do_width_x, $
                                     /DO_TIMEAVGD_PFLUX, $
                                     LOGTIMEAVGD_PFLUX=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logTimeAvgd_PFlux)), $
                                     TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
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

     ;;########Time-averaged e- flux########
     IF KEYWORD_SET(timeAvgd_eFluxMaxPlot) THEN BEGIN
        GET_PROB_OCCURRENCE_PLOTDATA,maximus,plot_i,tHistDenominator, $
                                     ;; DO_WIDTH_X=do_width_x, $
                                     /DO_TIMEAVGD_EFLUXMAX, $
                                     LOGTIMEAVGD_EFLUXMAX=(KEYWORD_SET(all_logPlots) OR KEYWORD_SET(logTimeAvgd_EFluxMax)), $
                                     TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
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

     ;;********************************************************
     ;;If something screwy goes on, better take stock of it and alert user
     n_zero                     = N_ELEMENTS(h2dStrArr[0])-N_ELEMENTS(h2d_nonzero_nEv_i)
     FOR i = 2, N_ELEMENTS(h2dStrArr)-1 DO BEGIN 
        IF n_elements(where(h2dStrArr[i].data EQ 0,/NULL)) LT $
           n_zero THEN BEGIN 
           printf,lun,"h2dStrArr."+h2dStrArr[i].title + " has ", strtrim(n_elements(where(h2dStrArr[i].data EQ 0)),2)," elements that are zero, whereas FluxN has ", strtrim(n_zero,2),"." 
        printf,lun,"Sorry, can't plot anything meaningful." & ENDIF
     ENDFOR

     ;;Now that we're done using nplots, let's log it, if requested:
     IF KEYWORD_SET(nPlots) AND ( KEYWORD_SET(logNEventsPlot) OR KEYWORD_SET(all_logPlots) ) THEN BEGIN
        dataNameArr[0]         = 'log_' + dataNameArr[0]
        h2dStrArr[0].data[h2d_nonzero_nEv_i] = ALOG10(h2dStrArr[0].data[h2d_nonzero_nEv_i])
        h2dStrArr[0].lim       = [(h2dStrArr[0].lim[0] LT 1) ? 0 : ALOG10(h2dStrArr[0].lim[0]),ALOG10(h2dStrArr[0].lim[1])] ;lower bound must be one
        h2dStrArr[0].title     = 'Log ' + h2dStrArr[0].title
        h2dStrArr[0].is_logged = 1
     ENDIF

END