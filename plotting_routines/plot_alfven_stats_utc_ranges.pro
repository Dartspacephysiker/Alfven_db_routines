;+
; NAME: PLOT_ALFVEN_STATS_UTC_RANGES
;
; PURPOSE: Plot FAST data processed by Chris Chaston's ALFVEN_STATS_5 procedure (with mods).
;          All data are binned by MLT and ILAT (bin sizes can be set manually).
;
; CALLING SEQUENCE: PLOT_ALFVEN_STATS_IMF_SCREENING
;
; INPUTS:
;
; OPTIONAL INPUTS:   
;                *DATABASE PARAMETERS
;		     ORBRANGE          :  Two-element vector, lower and upper limit on orbits to include   
;		     ALTITUDERANGE     :  Two-element vector, lower and upper limit on altitudes to include   
;                    CHARERANGE        :  Two-element vector, lower ahd upper limit on characteristic energy of electrons in 
;                                            the LOSSCONE (could change it to total in get_chaston_ind.pro).
;                    POYNTRANGE        :  Two-element vector, lower and upper limit Range of Poynting flux values to include.
;                    NUMORBLIM         :  Minimum number of orbits passing through a given bin in order for the bin to be 
;                                            included and not masked in the plot.
; 		     MINMLT            :  MLT min  (Default: 9)
; 		     MAXMLT            :  MLT max  (Default: 15)
; 		     BINMLT            :  MLT binsize  (Default: 0.5)
;		     MINILAT           :  ILAT min (Default: 64)
;		     MAXILAT           :  ILAT max (Default: 80)
;		     BINILAT           :  ILAT binsize (Default: 2.0)
;		     MIN_NEVENTS       :  Minimum number of events an orbit must contain to qualify as a "participating orbit"
;                    MASKMIN           :  Minimum number of events a given MLT/ILAT bin must contain to show up on the plot.
;                                            Otherwise it gets shown as "no data". (Default: 1)
;                    BYMIN             :  Minimum value of IMF By during an event to accept the event for inclusion in the analysis.
;                    BZMIN             :  Minimum value of IMF Bz during an event to accept the event for inclusion in the analysis.
;                    BYMAX             :  Maximum value of IMF By during an event to accept the event for inclusion in the analysis.
;                    BZMAX             :  Maximum value of IMF Bz during an event to accept the event for inclusion in the analysis.
;		     NPLOTS            :  Plot number of orbits.   
;                    HEMI              :  Hemisphere for which to show statistics. Can be "North", "South", or "Both".
;
;                *HOLZWORTH/MENG STATISTICAL AURORAL OVAL PARAMETERS 
;                    HWMAUROVAL        :  Only include those data that are above the statistical auroral oval.
;                    HWMKPIND          :  Kp Index to use for determining the statistical auroral oval (def: 7)
;
;                *ELECTRON FLUX PLOT OPTIONS
;		     EPLOTS            :     
;                    EFLUXPLOTTYPE     :  Options are 'Integ' for integrated or 'Max' for max data point.
;                    LOGEFPLOT         :  Do log plots of electron energy flux.
;                    ABSEFLUX          :  Use absolute value of electron energy flux (required for log plots).
;                    NONEGEFLUX        :  Do not use negative e fluxes in any of the plots (positive is earthward for eflux)
;                    NOPOSEFLUX        :  Do not use positive e fluxes in any of the plots
;                    EPLOTRANGE        :  Range of allowable values for e- flux plots. 
;                                         (Default: [-500000,500000]; [1,5] for log plots)
;
;                *ELECTRON NUMBER FLUX PLOT OPTIONS
;		     ENUMFLPLOTS       :  Do plots of max electron number flux
;                    ENUMFLPLOTTYPE    :  Options are 'Total_Eflux_Integ', 'Eflux_Losscone_Integ', 'ESA_Number_flux'.
;                    LOGENUMFLPLOT     :  Do log plots of electron number flux.
;                    ABSENUMFL         :  Use absolute value of electron number flux (required for log plots).
;                    NONEGENUMFL       :  Do not use negative e num fluxes in any of the plots (positive is earthward for eflux)
;                    NOPOSENUMFL       :  Do not use positive e num fluxes in any of the plots
;                    ENUMFLPLOTRANGE   :  Range of allowable values for e- num flux plots. 
;                                         (Default: [-500000,500000]; [1,5] for log plots)
;                    
;                *POYNTING FLUX PLOT OPTIONS
;		     PPLOTS            :  Do Poynting flux plots.
;                    LOGPFPLOT         :  Do log plots of Poynting flux.
;                    ABSPFLUX          :  Use absolute value of Poynting flux (required for log plots).
;                    NONEGPFLUX        :  Do not use negative Poynting fluxes in any of the plots
;                    NOPOSPFLUX        :  Do not use positive Poynting fluxes in any of the plots
;                    PPLOTRANGE        :  Range of allowable values for e- flux plots. 
;                                         (Default: [0,3]; [-1,0.5] for log plots)
;
;                *ION FLUX PLOT OPTIONS
;		     IONPLOTS          :  Do ion plots (using ESA data).
;                    IFLUXPLOTTYPE     :  Options are 'Integ', 'Max', 'Integ_Up', 'Max_Up', or 'Energy'.
;                    LOGIFPLOT         :  Do log plots of ion flux.
;                    ABSIFLUX          :  Use absolute value of ion flux (required for log plots).
;                    NONEGIFLUX        :  Do not use negative ion fluxes in any of the plots (positive is earthward for ion flux)
;                    NOPOSIFLUX        :  Do not use positive ion fluxes in any of the plots
;                    IPLOTRANGE        :  Range of allowable values for ion flux plots. 
;                                         (Default: [-500000,500000]; [1,5] for log plots)
;
;                *CHAR E PLOTS
;                    CHAREPLOTS        :  Do characteristic electron energy plots
;                    CHARETYPE         :  Options are 'lossCone' for electrons in loss cone or 'Total' for all electrons.
;                    LOGCHAREPLOT      :  Do log plots of characteristic electron energy.
;                    ABSCHARE          :  Use absolute value of characteristic electron (required for log plots).
;                    NONEGCHARE        :  Do not use negative char e in any of the plots (positive MIGHT be earthward...)
;                    NOPOSCHARE        :  Do not use positive char e in any of the plots
;                    CHAREPLOTRANGE    :  Range of allowable values for characteristic electron energy plots. 
;                                         (Default: [-500000,500000]; [0,3.6] for log plots)
;
;                *ORBIT PLOT OPTIONS
;		     ORBCONTRIBPLOT    :  Contributing orbit plots
;		     ORBCONTRIBRANGE   :  Range for contributing orbit plot
;		     ORBTOTPLOT        :  Plot of total number of orbits for each bin, 
;                                            given user-specified restrictions on the database.
;		     ORBTOTRANGE       :  Range for Orbtotplot 
;		     ORBFREQPLOT       :  Plot of orbits contributing to a given bin, 
;		     ORBFREQRANGE      :  Range for Orbfreqplot.
;                                            divided by total orbits passing through the bin.
;                    NEVENTSPLOTRANGE  :  Range for nEvents plot.
;                    LOGNEVENTSPLOT    :  Do log plot for n events
;
;                    NEVENTPERORBPLOT  :  Plot of number of events per orbit.
;                    NEVENTPERORBRANGE :  Range for Neventperorbplot.
;                    LOGNEVENTPERORB   :  Log of Neventperorbplot (for comparison with Chaston et al. [2003])
;                    DIVNEVBYTOTAL     :  Divide number of events in given bin by the number of orbits occurring 
;                                            during specified IMF conditions. (Default is to divide by total number of orbits 
;                                            pass through given bin for ANY IMF condition.)
;
;                    NEVENTPERMINPLOT  :  Plot of number of events per minute that FAST spent in a given MLT/ILAT region when
;                                           FAST electron survey data were available (since that's the only time we looked
;                                           for Alfvén activity.
;                    LOGNEVENTPERMIN   :  Log of Neventpermin plot 
;                    MAKESMALLESTBINMIN:  Find the smallest bin, make that 
;
;                *ASSORTED PLOT OPTIONS--TOTAL TO ALL PLOTS
;		     MEDIANPLOT        :  Do median plots instead of averages.
;                    LOGAVGPLOT        :  Do log averaging instead of straight averages
;		     ALL_LOGPLOT       :  All plots logged
;		     SQUAREPLOT        :  Do plots in square bins. (Default plot is in polar stereo projection)    
;                    POLARCONTOUR      :  Do polar plot, but do a contour instead
;                    WHOLECAP*         :   *(Only for polar plot!) Plot the entire polar cap, not just a range of MLTs and ILATs
;                    MIDNIGHT*         :   *(Only for polar plot!) Orient polar plot with midnight (24MLT) at bottom
;		     DBFILE            :  Which database file to use?
;                    NO_BURSTDATA      :  Exclude data from burst runs of Alfven_stats_5 (burst data were produced 2015/08/10)
;		     DATADIR           :     
;		     DO_CHASTDB        :  Use Chaston's original ALFVEN_STATS_3 database. 
;                                            (He used it for a few papers, I think, so it's good).
;
;                  *VARIOUS OUTPUT OPTIONS
;		     WRITEASCII        :     
;		     WRITEHDF5         :      
;                    WRITEPROCESSEDH2D :  Use this to output processed, histogrammed data. That way you
;                                            can share with others!
;		     SAVERAW           :  Save all raw data
;		     RAWDIR            :  Directory in which to store raw data
;                    JUSTDATA          :  No plots whatsoever; just give me the dataz.
;                    SHOWPLOTSNOSAVE   :  Don't save plots, just show them immediately
;		     PLOTDIR           :     
;		     PLOTPREFIX        :     
;		     PLOTSUFFIX        :     
;                    OUTPUTPLOTSUMMARY :  Make a text file with record of running params, various statistics
;                    MEDHISTOUTDATA    :  If doing median plots, output the median pointer array. 
;                                           (Good for further inspection of the statistics involved in each bin
;                    MEDHISTDATADIR    :  Directory where median histogram data is outputted.
;                    MEDHISTOUTTXT     :  Use 'medhistoutdata' output to produce .txt files with
;                                           median and average values for each MLT/ILAT bin.
;                    DEL_PS            :  Delete postscript outputted by plotting routines
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS: 
;                    MAXIMUS           :  Return maximus structure used in this pro.
;

; RESTRICTIONS:
;
; PROCEDURE:
;
; EXAMPLE: 
;
;
; MODIFICATION HISTORY: 2015/10/21  : Branched from plot_alfven_stats_imf_screening.
;-

PRO PLOT_ALFVEN_STATS_UTC_RANGES,maximus,T1_ARR=t1_arr,T2_ARR=t2_arr,$
                                 CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                 ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, NUMORBLIM=numOrbLim, $
                                 MINMLT=minM,MAXMLT=maxM, $
                                 BINMLT=binM, $
                                 SHIFTMLT=shiftM, $
                                 MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                                 DO_LSHELL=do_lShell,REVERSE_LSHELL=reverse_lShell, $
                                 MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                                 MIN_MAGCURRENT=minMC, $
                                 MAX_NEGMAGCURRENT=maxNegMC, $
                                 BOTH_HEMIS=both_hemis, $
                                 NORTH=north, $
                                 SOUTH=south, $
                                 HEMI=hemi, $
                                 HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                 ;; MIN_NEVENTS=min_nEvents, $
                                 MASKMIN=maskMin, $
                                 DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                 NPLOTS=nPlots, $
                                 EPLOTS=ePlots, EPLOTRANGE=ePlotRange, EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
                                 ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, $
                                 ENUMFLPLOTS=eNumFlPlots, $
                                 ENUMFLPLOTTYPE=eNumFlPlotType, $
                                 LOGENUMFLPLOT=logENumFlPlot, $
                                 ABSENUMFL=absENumFl, $
                                 NONEGENUMFL=noNegENumFl, $
                                 NOPOSENUMFL=noPosENumFl, $
                                 ENUMFLPLOTRANGE=ENumFlPlotRange, $
                                 AUTOSCALE_ENUMFLPLOTS=autoscale_eNumFlplots, $
                                 NEWELL_ANALYZE_EFLUX=newell_analyze_eFlux, $
                                 NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
                                 PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
                                 NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
                                 IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
                                 NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
                                 OXYPLOTS=oxyPlots, $
                                 OXYFLUXPLOTTYPE=oxyFluxPlotType, $
                                 LOGOXYFPLOT=logOxyfPlot, $
                                 ABSOXYFLUX=absOxyFlux, $
                                 NONEGOXYFLUX=noNegOxyFlux, $
                                 NOPOSOXYFLUX=noPosOxyFlux, $
                                 OXYPLOTRANGE=oxyPlotRange, $
                                 CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
                                 NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
                                 CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
                                 NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
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
                                 NEWELLPLOTS=newellPlots, $
                                 NEWELL_PLOTRANGE=newell_plotRange, $
                                 LOG_NEWELLPLOT=log_newellPlot, $
                                 NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
                                 NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
                                 NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
                                 TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
                                 TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
                                 LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
                                 TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
                                 TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
                                 LOGTIMEAVGD_EFLUXMAX=logtimeAvgd_eFluxMax, $
                                 DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                                 DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                                 DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
                                 WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
                                 WRITE_ORB_AND_OBS_INFO=write_obsArr_textFile, $
                                 DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
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
                                 MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
                                 ALL_LOGPLOTS=all_logPlots, $
                                 SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
                                 DBFILE=dbfile, NO_BURSTDATA=no_burstData, DATADIR=dataDir, $
                                 DO_CHASTDB=do_chastDB, $
                                 DO_DESPUNDB=do_despunDB, $
                                 NEVENTSPLOTRANGE=nEventsPlotRange, LOGNEVENTSPLOT=logNEventsPlot, $
                                 NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
                                 NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
                                 WRITEASCII=writeASCII, $
                                 WRITEHDF5=writeHDF5, $
                                 WRITEPROCESSEDH2D=writeProcessedH2d, $
                                 SAVERAW=saveRaw, $
                                 RAWDIR=rawDir, $
                                 JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
                                 PLOTDIR=plotDir, $
                                 PLOTPREFIX=plotPrefix, $
                                 PLOTSUFFIX=plotSuffix, $
                                 SAVE_ALF_INDICES=save_alf_indices, $
                                 TXTOUTPUTDIR=txtOutputDir, $
                                 MEDHISTOUTDATA=medHistOutData, $
                                 MEDHISTOUTTXT=medHistOutTxt, $
                                 OUTPUTPLOTSUMMARY=outputPlotSummary, $
                                 DEL_PS=del_PS, $
                                 EPS_OUTPUT=eps_output, $
                                 PRINT_ALFVENDB_2DHISTOS=print_alfvendb_2dhistos, $
                                 OUT_TEMPFILE=out_tempFile, $
                                 SUPPRESS_GRIDLABELS=suppress_gridLabels, $
                                 LABELS_FOR_PRESENTATION=labels_for_presentation, $
                                 TILE_IMAGES=tile_images, $
                                 N_TILE_ROWS=n_tile_rows, $
                                 N_TILE_COLUMNS=n_tile_columns, $
                                 TILING_ORDER=tiling_order, $
                                 TILEPLOTSUFF=tilePlotSuff, $
                                 TILEPLOTTITLE=tilePlotTitle, $
                                 TILE__FAVOR_ROWS=tile__favor_rows, $
                                 NO_COLORBAR=no_colorbar, $
                                 CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                 CB_FORCE_OOBLOW=cb_force_oobLow, $
                                 FANCY_PLOTNAMES=fancy_plotNames, $
                                 LUN=lun, $
                                 PRINT_DATA_AVAILABILITY=print_data_availability, $
                                 VERBOSE=verbose, $
                                 _EXTRA = e
  
  COMPILE_OPT idl2
  !EXCEPT=0                     ;Do report errors, please
  
  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1
  
  IF NOT KEYWORD_SET(t1_arr) OR NOT KEYWORD_SET(t2_arr) THEN BEGIN
     PRINTF,lun,"What are you thinking? You didn't even provide time arrays..."
     RETURN
  ENDIF
  
  SET_ALFVENDB_PLOT_DEFAULTS,ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                             MINMLT=minM,MAXMLT=maxM, $
                             BINMLT=binM, $
                             SHIFTMLT=shiftM, $
                             MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                             DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                             MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                             HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                             ;; MIN_NEVENTS=min_nEvents, $
                             MASKMIN=maskMin, $
                             DO_DESPUNDB=do_despunDB, $
                             HEMI=hemi, $
                             NORTH=north, $
                             SOUTH=south, $
                             BOTH_HEMIS=both_hemis, $
                             NPLOTS=nPlots, $
                             EPLOTS=ePlots, EFLUXPLOTTYPE=eFluxPlotType, $
                             ENUMFLPLOTS=eNumFlPlots, $
                             ENUMFLPLOTTYPE=eNumFlPlotType, $
                             PPLOTS=pPlots, $
                             IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, $
                             CHAREPLOTS=charEPlots, CHARETYPE=charEType, $
                             CHARIEPLOTS=chariEPlots, $
                             ORBCONTRIBPLOT=orbContribPlot, $
                             ORBTOTPLOT=orbTotPlot, $
                             ORBFREQPLOT=orbFreqPlot, $
                             NEVENTPERORBPLOT=nEventPerOrbPlot, $
                             NEVENTPERMINPLOT=nEventPerMinPlot, $
                             PROBOCCURRENCEPLOT=probOccurrencePlot, $
                             SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
                             MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, PLOTMEDORAVG=plotMedOrAvg, $
                             DATADIR=dataDir, NO_BURSTDATA=no_burstData, $
                             WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
                             SAVERAW=saveRaw, RAWDIR=rawDir, $
                             SHOWPLOTSNOSAVE=showPlotsNoSave, $
                             ;; PLOTDIR=plotDir, $
                             MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                             OUTPUTPLOTSUMMARY=outputPlotSummary, DEL_PS=del_PS, $
                             KEEPME=keepMe, $
                             PARAMSTRING=paramString,PARAMSTRPREFIX=plotPrefix,PARAMSTRSUFFIX=plotSuffix,$
                             HOYDIA=hoyDia,LUN=lun,_EXTRA=e
  
  SET_UTCPLOT_PARAMS_AND_IND_DEFAULTS,ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                      PARAMSTRING=paramString, $
                                      LUN=lun

  ;;Open file for text summary, if desired
  IF KEYWORD_SET(outputPlotSummary) THEN $
     OPENW,lun,txtOutputDir + 'outputSummary_'+paramString+'.txt',/GET_LUN $
  ELSE lun=-1                   ;-1 is lun for STDOUT
  
  ;;********************************************************
  ;;Now clean and tap the database
  good_i = GET_CHASTON_IND(maximus,satellite,lun, $
                           BOTH_HEMIS=both_hemis, $
                           NORTH=north, $
                           SOUTH=south, $
                           HEMI=hemi, $
                           DBTIMES=cdbTime,dbfile=dbfile, $
                           CHASTDB=do_chastdb, $
                           DESPUNDB=do_despunDB, $
                           ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange,POYNTRANGE=poyntRange, $
                           MINMLT=minM,MAXMLT=maxM,BINM=binM, $
                           MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                           DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                           HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd)
  
  GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES,T1_ARR=t1_arr,T2_ARR=t2_arr, $
     DBSTRUCT=maximus,DBTIMES=cdbTime, RESTRICT_W_THESEINDS=good_i, $
     OUT_INDS_LIST=plot_i,  $
     UNIQ_ORBS_LIST=uniq_orbs_list,UNIQ_ORB_INDS_LIST=uniq_orb_inds_list, $
     INDS_ORBS_LIST=inds_orbs_list,TRANGES_ORBS_LIST=tranges_orbs_list,TSPANS_ORBS_LIST=tspans_orbs_list, $
     PRINT_DATA_AVAILABILITY=print_data_availability, $
     LIST_TO_ARR=1,$
     VERBOSE=verbose, DEBUG=debug, LUN=lun

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot lims
  SET_ALFVEN_STATS_PLOT_LIMS,EPLOTRANGE=EPlotRange, $
                             ENUMFLPLOTRANGE=ENumFlPlotRange, $
                             PPLOTRANGE=PPlotRange, $
                             CHAREPLOTRANGE=charePlotRange,CHARERANGE=charERange, $
                             CHARIEPLOTRANGE=chariEPlotRange, $
                             NEVENTPERMINRANGE=nEventPerMinRange, $
                             PROBOCCURRENCERANGE=probOccurrenceRange, $
                             NOWEPCO_RANGE=nowepco_range
  
  ;;********************************************
  ;;Now time for data summary

  PRINT_ALFVENDB_PLOTSUMMARY,maximus,plot_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                             ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                             MINMLT=minM,MAXMLT=maxM, $
                             BINMLT=binM, $
                             SHIFTMLT=shiftM, $
                             MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                             DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                             MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                             HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                             PARAMSTRING=paramString, PARAMSTRPREFIX=plotPrefix,PARAMSTRSUFFIX=plotSuffix,$
                             HEMI=hemi, $
                             HOYDIA=hoyDia,MASKMIN=maskMin,LUN=lun



  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Saving indices?
  IF KEYWORD_SET(save_alf_indices) THEN BEGIN
     alfDB_ind_filename    = paramString + '--' + 'alfDB_indices.sav'
     alfDB_ind_fileDir     = plotDir + '../../saves_output_etc/'
     SAVE_ALFVENDB_INDICES,alfDB_ind_filename, $
                           alfDB_ind_fileDir, $
                           plot_i, $
                           CLOCKSTR=clockStr, $
                           ANGLELIM1=angleLim1, $
                           ANGLELIM2=angleLim2, $
                           ORBRANGE=orbRange, $
                           ALTITUDERANGE=altitudeRange, $
                           CHARERANGE=charERange, $
                           minMLT=minM, $
                           maxMLT=maxM, $
                           BINMLT=binM, $
                           SHIFTMLT=shiftM, $
                           MINILAT=minI, $
                           MAXILAT=maxI, $
                           BINILAT=binI, $
                           DO_LSHELL=do_lShell, $
                           MINLSHELL=minL, $
                           MAXLSHELL=maxL, $
                           BINLSHELL=binL, $
                           MIN_MAGCURRENT=minMC, $
                           MAX_NEGMAGCURRENT=maxNegMC, $
                           HWMAUROVAL=HwMAurOval, $
                           HWMKPIND=HwMKpInd, $
                           BYMIN=byMin, $
                           BYMAX=byMax, $
                           BZMIN=bzMin, $
                           BZMAX=bzMax, $
                           BTMIN=btMin, $
                           BTMAX=btMax, $
                           BXMIN=bxMin, $
                           BXMAX=bxMax, $
                           DO_ABS_BYMIN=abs_byMin, $
                           DO_ABS_BYMAX=abs_byMax, $
                           DO_ABS_BZMIN=abs_bzMin, $
                           DO_ABS_BZMAX=abs_bzMax, $
                           DO_ABS_BTMIN=abs_btMin, $
                           DO_ABS_BTMAX=abs_btMax, $
                           DO_ABS_BXMIN=abs_bxMin, $
                           DO_ABS_BXMAX=abs_bxMax, $
                           BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                           PARAMSTRING=paramString, $
                           PARAMSTR_LIST=paramString_list, $
                           PARAMSTRPREFIX=plotPrefix, $
                           PARAMSTRSUFFIX=plotSuffix,$
                           SATELLITE=satellite, $
                           OMNI_COORDS=omni_Coords, $
                           HEMI=hemi, $
                           DELAY=delay, $
                           MULTIPLE_DELAYS=multiple_delays, $
                           MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
                           STABLEIMF=stableIMF, $
                           SMOOTHWINDOW=smoothWindow, $
                           INCLUDENOCONSECDATA=includeNoConsecData, $
                           HOYDIA=hoyDia, $
                           MASKMIN=maskMin
  ENDIF

  ;;********************************************************
  ;;HISTOS

  tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                                   MIN1=minM,MIN2=(KEYWORD_SET(DO_LSHELL) ? minL : minI),$
                                   MAX1=maxM,MAX2=(KEYWORD_SET(DO_LSHELL) ? maxL : maxI), $
                                   SHIFT1=shiftM,SHIFT2=shiftI, $
                                   DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                                   CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                   CB_FORCE_OOBLOW=cb_force_oobLow)

  ;;Need area or length of each bin for gross rates
  IF KEYWORD_SET(do_grossRate_fluxQuantities) OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
     IF KEYWORD_SET(do_grossRate_fluxQuantities) AND KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        PRINTF,lun,"Can't do both types of gross rates simultaneously!!!"
        STOP
     ENDIF
     
     IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
        GET_H2D_BIN_AREAS,h2dAreas, $
                          CENTERS1=centersMLT,CENTERS2=centersILAT, $
                          BINSIZE1=binM*15., BINSIZE2=binI, $
                          MAX1=maxM*15., MAX2=maxI, $
                          MIN1=minM*15., MIN2=minI, $
                          SHIFT1=shiftM*15., SHIFT2=shiftI
     END

     IF KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
        GET_H2D_BIN_LENGTHS,h2dLongWidths, $
                            /LONGITUDINAL, $
                            CENTERS1=centersMLT,CENTERS2=centersILAT, $
                            BINSIZE1=binM*15., BINSIZE2=binI, $
                            MAX1=maxM*15., MAX2=maxI, $
                            MIN1=minM*15., MIN2=minI, $
                            SHIFT1=shiftM*15., SHIFT2=shiftI
     ENDIF
  ENDIF

  IF KEYWORD_SET(grossRate_info_file) THEN BEGIN
     SETUP_GROSSRATE_INFO_FILE,grossRate_info_file, $
                               GROSSLUN=grossLun, $
                               PARAMSTRING=paramString
  ENDIF

  GET_ALFVENDB_2DHISTOS,maximus,plot_i, H2DSTRARR=h2dStrArr, $
                        KEEPME=keepMe, DATARAWPTRARR=dataRawPtrArr,DATANAMEARR=dataNameArr, $
                        /DO_NOT_SET_DEFAULTS, $
                        MINMLT=minM,MAXMLT=maxM, $
                        BINMLT=binM, $
                        SHIFTMLT=shiftM, $
                        MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                        DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                        ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, $
                        CHARERANGE=charERange, POYNTRANGE=poyntRange, NUMORBLIM=numOrbLim, $
                        MASKMIN=maskMin, $
                        SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                        HEMI=hemi, $
                        DO_IMF_CONDS=do_IMF_conds, $
                        CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                        BYMIN=byMin, BZMIN=bzMin, $
                        BYMAX=byMax, BZMAX=bzMax, $
                        DELAY=delay, STABLEIMF=stableIMF, $
                        SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                        /DO_UTC_RANGE,T1_ARR=t1_arr,T2_ARR=t2_arr, $
                        NPLOTS=nPlots, $
                        NEVENTSPLOTRANGE=nEventsPlotRange, $
                        LOGNEVENTSPLOT=logNEventsPlot, $
                        NEVENTSPLOTAUTOSCALE=nEventsPlotAutoscale, $
                        NEVENTSPLOTNORMALIZE=nEventsPlotNormalize, $
                        EPLOTS=ePlots, EFLUXPLOTTYPE=eFluxPlotType, LOGEFPLOT=logEfPlot, $
                        ABSEFLUX=abseflux, NOPOSEFLUX=noPosEFlux, NONEGEFLUX=noNegEflux, EPLOTRANGE=EPlotRange, $
                        ENUMFLPLOTS=eNumFlPlots, $
                        ENUMFLPLOTTYPE=eNumFlPlotType, $
                        LOGENUMFLPLOT=logENumFlPlot, $
                        ABSENUMFL=absENumFl, $
                        NONEGENUMFL=noNegENumFl, $
                        NOPOSENUMFL=noPosENumFl, $
                        ENUMFLPLOTRANGE=ENumFlPlotRange, $
                        AUTOSCALE_ENUMFLPLOTS=autoscale_eNumFlplots, $
                        NEWELL_ANALYZE_EFLUX=newell_analyze_eFlux, $
                        NEWELL_ANALYSIS__OUTPUT_SUMMARY=newell_analysis__output_summary, $
                        PPLOTS=pPlots, LOGPFPLOT=logPfPlot, ABSPFLUX=absPflux, $
                        NONEGPFLUX=noNegPflux, NOPOSPFLUX=noPosPflux, PPLOTRANGE=PPlotRange, $
                        IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, LOGIFPLOT=logIfPlot, ABSIFLUX=absIflux, $
                        NONEGIFLUX=noNegIflux, NOPOSIFLUX=noPosIflux, IPLOTRANGE=IPlotRange, $
                        OXYPLOTS=oxyPlots, $
                        OXYFLUXPLOTTYPE=oxyFluxPlotType, $
                        LOGOXYFPLOT=logOxyfPlot, $
                        ABSOXYFLUX=absOxyFlux, $
                        NONEGOXYFLUX=noNegOxyFlux, $
                        NOPOSOXYFLUX=noPosOxyFlux, $
                        OXYPLOTRANGE=oxyPlotRange, $
                        CHAREPLOTS=charEPlots, CHARETYPE=charEType, LOGCHAREPLOT=logCharEPlot, ABSCHARE=absCharE, $
                        NONEGCHARE=noNegCharE, NOPOSCHARE=noPosCharE, CHAREPLOTRANGE=CharEPlotRange, $
                        CHARIEPLOTS=chariePlots, LOGCHARIEPLOT=logChariePlot, ABSCHARIE=absCharie, $
                        NONEGCHARIE=noNegCharie, NOPOSCHARIE=noPosCharie, CHARIEPLOTRANGE=ChariePlotRange, $
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
                        NEWELLPLOTS=newellPlots, $
                        NEWELL_PLOTRANGE=newell_plotRange, $
                        LOG_NEWELLPLOT=log_newellPlot, $
                        NEWELLPLOT_AUTOSCALE=newellPlot_autoscale, $
                        NEWELLPLOT_NORMALIZE=newellPlot_normalize, $
                        NEWELLPLOT_PROBOCCURRENCE=newellPlot_probOccurrence, $
                        TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
                        TIMEAVGD_PFLUXRANGE=timeAvgd_pFluxRange, $
                        LOGTIMEAVGD_PFLUX=logTimeAvgd_PFlux, $
                        TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
                        TIMEAVGD_EFLUXMAXRANGE=timeAvgd_eFluxMaxRange, $
                        LOGTIMEAVGD_EFLUXMAX=logtimeAvgd_eFluxMax, $
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
                        WRITE_ORB_AND_OBS_INFO=write_obsArr_textFile, $
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
                        MEDIANPLOT=medianPlot, $
                        MEDHISTOUTDATA=medHistOutData, $
                        MEDHISTOUTTXT=medHistOutTxt, $
                        LOGAVGPLOT=logAvgPlot, $
                        ALL_LOGPLOTS=all_logPlots, $
                        PARAMSTRING=paramString, $
                        PARAMSTRPREFIX=plotPrefix, $
                        PARAMSTRSUFFIX=plotSuffix, $
                        SAVE_FASTLOC_INDS=save_alf_indices, $
                        IND_FILEDIR=alfDB_ind_fileDir, $
                        TMPLT_H2DSTR=tmplt_h2dStr, $
                        FANCY_PLOTNAMES=fancy_plotNames, $
                        TXTOUTPUTDIR=txtOutputDir, $
                        ;; PLOTDIR=plotDir, $
                        LUN=lun

    IF KEYWORD_SET(grossRate_info_file) THEN BEGIN
       CLOSE_GROSSRATE_INFO_FILE,grossRate_info_file,grossLun,LUN=lun
    ENDIF

  ;;********************************************************
  ;;Handle Plots all at once

  ;;!!Make sure mask and FluxN are ultimate and penultimate arrays, respectively
  h2dStrArr=SHIFT(h2dStrArr,-1-nPlots)
  IF keepMe THEN BEGIN 
     dataNameArr=SHIFT(dataNameArr,-1-nPlots) 
     dataRawPtrArr=SHIFT(dataRawPtrArr,-1-nPlots) 
  ENDIF

  IF N_ELEMENTS(squarePlot) EQ 0 THEN BEGIN
     SAVE_ALFVENDB_TEMPDATA,H2DSTRARR=h2dStrArr,DATANAMEARR=dataNameArr,$
                            MAXM=maxM,MINM=minM,MAXI=maxI,MINI=minI,BINM=binM,BINI=binI, $
                            DO_LSHELL=do_lShell,REVERSE_LSHELL=reverse_lShell, $
                            MINL=minL,MAXL=maxL,BINL=binL,$
                            RAWDIR=rawDir,PARAMSTR=paramString,$
                            CLOCKSTR=clockStr,PLOTMEDORAVG=plotMedOrAvg, $
                            STABLEIMF=stableIMF,HOYDIA=hoyDia,HEMI=hemi, $
                            OUT_TEMPFILE=out_tempFile, $
                            LUN=lun
  ENDIF

  ;;Now plots
  PLOT_ALFVENDB_2DHISTOS,H2DSTRARR=h2dStrArr,DATANAMEARR=dataNameArr,TEMPFILE=out_tempFile, $
                         SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ 
                         JUSTDATA=justData, SHOWPLOTSNOSAVE=showPlotsNoSave, $
                         PLOTDIR=plotDir, PLOTMEDORAVG=plotMedOrAvg, $
                         PARAMSTR=paramString, DEL_PS=del_PS, $
                         HEMI=hemi, $
                         SUPPRESS_GRIDLABELS=suppress_gridLabels, $
                         LABELS_FOR_PRESENTATION=labels_for_presentation, $
                         TILE_IMAGES=tile_images, $
                         N_TILE_ROWS=n_tile_rows, $
                         N_TILE_COLUMNS=n_tile_columns, $
                         TILING_ORDER=tiling_order, $
                         TILEPLOTSUFF=tilePlotSuff, $
                         TILEPLOTTITLE=tilePlotTitle, $
                         TILE__FAVOR_ROWS=tile__favor_rows, $
                         NO_COLORBAR=no_colorbar, $
                         ;; CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                         ;; CB_FORCE_OOBLOW=cb_force_oobLow, $
                         CLOCKSTR=clockStr, $
                         EPS_OUTPUT=eps_output, $
                         _EXTRA = e

  ;;Haven't finished writing this yet
  ;; IF KEYWORD_SET(print_alfvendb_2dhistos) THEN BEGIN
  ;;    PRINT_ALFVENDB_2DHISTOS, $
  ;;       H2DSTRARR=h2dStrArr, $
  ;;       DATANAMEARR=dataNameArr, $
  ;;       HEMI=hemi
  ;; ENDIF

  IF KEYWORD_SET(outputPlotSummary) THEN BEGIN 
     CLOSE,lun 
     FREE_LUN,lun 
  ENDIF

  ;;Save raw data, if desired
  IF KEYWORD_SET(saveRaw) THEN BEGIN
     SAVE, /ALL, filename=rawDir+'fluxplots_'+paramString+".dat"

  ENDIF

  ;; out_tempFile=tempFile

  WRITE_ALFVENDB_2DHISTOS,MAXIMUS=maximus,PLOT_I=plot_i, $
                          WRITEHDF5=writeHDF5, $
                          WRITEPROCESSEDH2D=WRITEPROCESSEDH2D, $
                          WRITEASCII=writeASCII, $
                          H2DSTRARR=h2dStrArr, $
                          DATARAWPTRARR=dataRawPtrArr, $
                          DATANAMEARR=dataNameArr, $
                          PARAMSTR=paramString, $
                          TXTOUTPUTDIR=txtOutputDir


END