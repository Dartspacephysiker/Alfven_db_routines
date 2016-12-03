;		     ORBRANGE          :  Two-element vector, lower and upper limit on orbits to include   
;		     ALTITUDERANGE     :  Two-element vector, lower and upper limit on altitudes to include   
;                    CHARERANGE        :  Two-element vector, lower ahd upper limit on characteristic energy of electrons in 
;                                            the LOSSCONE (could change it to total in get_chaston_ind.pro).
;                    POYNTRANGE        :  Two-element vector, lower and upper limit Range of Poynting flux values to include.
PRO SET_ALFVENDB_PLOT_DEFAULTS, $
   ORBRANGE=orbRange, $
   ALTITUDERANGE=altitudeRange, $
   CHARERANGE=charERange, $
   CHARE__NEWELL_THE_CUSP=charE__Newell_the_cusp, $
   POYNTRANGE=poyntRange, $
   SAMPLE_T_RESTRICTION=sample_t_restriction, $
   INCLUDE_32HZ=include_32Hz, $
   DISREGARD_SAMPLE_T=disregard_sample_t, $
   DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
   DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
   MINMLT=minMLT,MAXMLT=maxMLT, $
   BINMLT=binMLT, $
   SHIFTMLT=shiftMLT, $
   MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
   EQUAL_AREA_BINNING=EA_binning, $
   DO_LSHELL=do_lShell,MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
   MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
   HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
   ;; MIN_NEVENTS=min_nEvents, $
   MASKMIN=maskMin, $
   THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
   DESPUNDB=despunDB, $
   CHASTDB=chastDB, $
   USE_AACGM_COORDS=use_aacgm, $
   USE_MAG_COORDS=use_MAG, $
   HEMI=hemi, $
   NORTH=north, $
   SOUTH=south, $
   BOTH_HEMIS=both_hemis, $
   NPLOTS=nPlots, $
   EPLOTS=ePlots, EFLUXPLOTTYPE=eFluxPlotType, $
   ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, $
   PPLOTS=pPlots, $
   IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, $
   CHAREPLOTS=charEPlots, CHARETYPE=charEType, $
   CHARIEPLOTS=chariEPlots, $
   AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
   ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
   NEVENTPERORBPLOT=nEventPerOrbPlot, $
   NEVENTPERMINPLOT=nEventPerMinPlot, $
   PROBOCCURRENCEPLOT=probOccurrencePlot, $
   SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
   MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, PLOTMEDORAVG=plotMedOrAvg, $
   DATADIR=dataDir, NO_BURSTDATA=no_burstData, $
   WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
   SAVERAW=saveRaw, RAWDIR=rawDir, $
   SHOWPLOTSNOSAVE=showPlotsNoSave, $
   MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
   OUTPUTPLOTSUMMARY=outputPlotSummary, DEL_PS=del_PS, $
   KEEPME=keepMe, $
   PARAMSTRING=paramString,PARAMSTRPREFIX=paramStrPrefix,PARAMSTRSUFFIX=paramStrSuffix,$
   PLOTH2D_CONTOUR=plotH2D_contour, $
   PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kernel_density_unmask, $
   HOYDIA=hoyDia,LUN=lun, $
   DONT_CORRECT_ILATS=dont_correct_ilats, $
   MIMC_STRUCT=MIMC_struct, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   RESET_STRUCT=reset, $
   DO_NOT_SET_DEFAULTS=do_not_set_defaults


  COMPILE_OPT idl2
  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  ;for statistical auroral oval
  defHwMAurOval          = 0
  defHwMKpInd            = 7

  ;Aujour d'hui
  hoyDia                 = GET_TODAY_STRING()

  ; Handle MLT and ILAT ... and L-shell
  IF ~KEYWORD_SET(do_not_set_defaults) THEN BEGIN
     SET_DEFAULT_MLT_ILAT_AND_MAGC,MINMLT=minMLT,MAXMLT=maxMLT, $
                                   BINM=binMLT, $
                                   SHIFTMLT=shiftMLT, $
                                   MINILAT=minILAT,MAXILAT=maxILAT,BINI=binILAT, $
                                   DONT_CORRECT_ILATS=dont_correct_ilats, $
                                   USE_AACGM_COORDS=use_AACGM, $
                                   USE_MAG_COORDS=use_MAG, $
                                   MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINL=binLshell, $
                                   MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                                   HEMI=hemi, $
                                   NORTH=north, $
                                   SOUTH=south, $
                                   BOTH_HEMIS=both_hemis, $
                                   MIMC_STRUCT=MIMC_struct, $
                                   LUN=lun
     
  ENDIF

  ;;***********************************************
  ;;Tons of defaults
  
  defOrbRange            = [0,12670]
  ;; defCharERange          = [4.0,300]
  ;; defAltRange            = [1000.0, 5000.0]
  defCharERange          = [4.0,3.0e4]
  defAltRange            = [0, 5000]

  defeFluxPlotType = "Max"
  defENumFlPlotType = "ESA_Number_flux" 
  defIFluxPlotType = "Max"
  defCharEPlotType = "lossCone"

  ; assorted
  defMaskMin = 1

  ;; defPlotDir = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plots/'
  defRawDir = 'rawsaves/'

  defOutSummary = 1 ;for output plot summary

  defDataDir = "/SPENCEdata/Research/database/"
  ;; defMedHistDataDir = 'out/medHistData/'
  
  ;;***********************************************
  ;;RESTRICTIONS ON DATA, SOME VARIABLES
  IF N_ELEMENTS(orbRange            ) EQ 0 THEN BEGIN
     orbRange               = defOrbRange ; 4,~300 eV in Strangeway
  ENDIF

  IF N_ELEMENTS(charERange          ) EQ 0 THEN BEGIN
     charERange             = defCharERange ; 4,~300 eV in Strangeway
  ENDIF

  IF N_ELEMENTS(altitudeRange       ) EQ 0 THEN BEGIN 
     altitudeRange          = defAltRange ;Rob Pfaff says no lower than 1000m
  ENDIF
  
  ;Auroral oval
  IF N_ELEMENTS(HwMAurOval) EQ 0 THEN HwMAurOval = defHwMAurOval
  IF N_ELEMENTS(HwMKpInd) EQ 0 THEN HwMKpInd = defHwMKpInd

  IF N_ELEMENTS(nPlots) EQ 0 THEN nPlots = 0                              ; do num events plots?
  IF N_ELEMENTS(ePlots) EQ 0 THEN ePlots =  0                             ;electron energy flux plots?
  IF N_ELEMENTS(eFluxPlotType) EQ 0 THEN eFluxPlotType = defEFluxPlotType ;options are "Integ" and "Max"
  IF N_ELEMENTS(iFluxPlotType) EQ 0 THEN iFluxPlotType = defIFluxPlotType ;options are "Integ", "Max", "Integ_Up", "Max_Up", and "Energy"
  IF N_ELEMENTS(eNumFlPlots) EQ 0 THEN eNumFlPlots = 0                    ;electron number flux plots?
  IF N_ELEMENTS(eNumFlPlotType) EQ 0 THEN eNumFlPlotType = defENumFlPlotType ;options are "Total_Eflux_Integ","Eflux_Losscone_Integ", "ESA_Number_flux" 
  IF N_ELEMENTS(pPlots) EQ 0 THEN pPlots =  0                             ;Poynting flux [estimate] plots?
  IF N_ELEMENTS(ionPlots) EQ 0 THEN ionPlots =  0                         ;ion Plots?
  IF N_ELEMENTS(charEPlots) EQ 0 THEN charEPlots =  0                     ;char E plots?
  IF N_ELEMENTS(charEType) EQ 0 THEN charEType = defCharEPlotType         ;options are "lossCone" and "Total"
  IF N_ELEMENTS(chariEPlots) EQ 0 THEN chariEPlots =  0                     ;char E plots?
  IF N_ELEMENTS(orbContribPlot) EQ 0 THEN orbContribPlot =  0             ;Contributing orbits plot?
  IF N_ELEMENTS(orbTotPlot) EQ 0 THEN orbTotPlot =  0                     ;"Total orbits considered" plot?
  IF N_ELEMENTS(orbFreqPlot) EQ 0 THEN orbFreqPlot =  0                   ;Contributing/total orbits plot?
  IF N_ELEMENTS(nEventPerOrbPlot) EQ 0 THEN nEventPerOrbPlot =  0         ;N Events/orbit plot?
  IF N_ELEMENTS(nEventPerMinPlot) EQ 0 THEN nEventPerMinPlot =  0         ;N Events/min plot?
  
  IF KEYWORD_SET(autoscale_fluxPlots) THEN PRINT,"Autoscaling flux plots..."


  IF (KEYWORD_SET(nEventPerOrbPlot) OR KEYWORD_SET(nEventPerMinPlot) ) AND NOT KEYWORD_SET(nPlots) THEN BEGIN
     print,"Can't do nEventPerOrbPlot without nPlots!!"
     print,"Enabling nPlots..."
     nPlots=1
  ENDIF

  ;; IF N_ELEMENTS(plotDir) EQ 0 THEN plotDir = defPlotDir ;;Directory stuff
  IF N_ELEMENTS(rawDir) EQ 0 THEN rawDir=defRawDir
  IF N_ELEMENTS(dataDir) EQ 0 THEN dataDir = defDataDir

  IF N_ELEMENTS(del_ps) EQ 0 THEN del_ps = 1            ;;not-directory stuff

  IF KEYWORD_SET(showPlotsNoSave) AND KEYWORD_SET(outputPlotSummary) THEN BEGIN    ;;Write output file with data params?
     print, "Is it possible to have outputPlotSummary==1 while showPlotsNoSave==0? You used to say no..."
     outputPlotSummary=defOutSummary   ;;Change to zero if not wanted
  ENDIF 

  ;;Any of multifarious reasons for needing output?
  IF KEYWORD_SET(writeASCII) OR KEYWORD_SET(writeHDF5) OR NOT KEYWORD_SET(squarePlot) OR KEYWORD_SET(saveRaw) THEN BEGIN
     keepMe = 1
  ENDIF ELSE keepMe = 0

  IF KEYWORD_SET(medHistOutTxt) AND NOT KEYWORD_SET(medHistOutData) THEN BEGIN
     PRINT, "medHistOutTxt is enabled, but medHistOutData is not!"
     print, "Enabling medHistOutData, since corresponding output is necessary for medHistOutTxt"
     WAIT, 0.5
     ;; IF ~KEYWORD_SET(medHistDataDir) THEN medHistDataDir = defMedHistDataDir 
     medHistOutData = 1
  ENDIF

  IF N_ELEMENTS(paramStrSuffix) EQ 0 THEN paramStrSuffix = "" ;; ELSE paramStrSuffix = "-" + paramStrSuffix
  IF N_ELEMENTS(paramStrPrefix) EQ 0 THEN paramStrPrefix = "" ;; ELSE paramStrPrefix = paramStrPrefix + "-"

  lShellStr = ''
  IF KEYWORD_SET(do_lShell) THEN lShellStr = '-lShell'

  IF KEYWORD_SET(despunDB) THEN despunStr  = '-despun' ELSE despunStr = ''

  IF KEYWORD_SET(use_AACGM) AND KEYWORD_SET(use_MAG) THEN STOP
  CASE 1 OF
     KEYWORD_SET(use_AACGM): BEGIN
        coordStr = '__AACGM'
     END
     KEYWORD_SET(use_MAG): BEGIN
        coordStr = '_MAG'
     END
     ELSE: BEGIN
        coordStr = ''
     END
  ENDCASE

  ;;Hz32 only possible if we haven't manually set sample_t_restriction
  sampTStr  = ''
  IF KEYWORD_SET(disregard_sample_t) AND KEYWORD_SET(include_32Hz) THEN STOP

  IF KEYWORD_SET(disregard_sample_t) THEN BEGIN
     sampTStr = '-0sampT'
  ENDIF ELSE BEGIN
     IF N_ELEMENTS(sample_t_restriction) GT 0 THEN BEGIN
        CASE sample_t_restriction OF
           0: BEGIN
              sampTStr = '-0sampT'
           END
           ELSE: BEGIN
              sampTStr  = STRING(FORMAT='(F0.2,"_sampT")',sample_t_restriction) 
           END
        ENDCASE
        IF KEYWORD_SET(include_32Hz) THEN BEGIN
           PRINT,"Can't do 32-Hz sample inclusion if sample_t has manually been set!"
           include_32Hz = 0
        ENDIF
     ENDIF ELSE BEGIN
        sampTStr  = ''

        IF KEYWORD_SET(include_32Hz) THEN BEGIN
           sampTStr  = '-inc_32Hz'
        ENDIF
     ENDELSE
  ENDELSE

  
  ;;********************************************
  ;;A few other strings to tack on
  ;;tap DBs, and setup output
  IF KEYWORD_SET(no_burstData) THEN inc_burstStr ='-burstData_excluded' ELSE inc_burstStr=''

  IF KEYWORD_SET(medianplot) THEN plotMedOrAvg = "-median" ELSE BEGIN
     IF KEYWORD_SET(logAvgPlot) THEN plotMedOrAvg = "-logAvg" ELSE plotMedOrAvg = "-avg"
  ENDELSE

  ;;Set minimum allowable number of events for a histo bin to be displayed
  maskStr = ''
  IF N_ELEMENTS(maskMin) EQ 0 THEN BEGIN
     maskMin = defMaskMin
  ENDIF
  IF maskMin GT 1 THEN BEGIN
     maskStr = '-maskMin_' + STRING(FORMAT='(I0)',maskMin)
  ENDIF
  
  ;;Set minimum # minutes that must be spent in each bin for inclusion
  tMaskStr = ''
  ;; IF N_ELEMENTS(tHist_mask_bins_below_thresh) EQ 0 THEN BEGIN
  ;;    maskMin = defMaskMin
  ;; ENDIF
  IF N_ELEMENTS(tHist_mask_bins_below_thresh) GT 0 THEN BEGIN
     IF tHist_mask_bins_below_thresh GT 1 THEN BEGIN
        tMaskStr = '-tThresh_' + STRING(FORMAT='(I0)',tHist_mask_bins_below_thresh)
     ENDIF
  ENDIF
  
  EABinStr = ''
  IF KEYWORD_SET(EA_binning) THEN BEGIN
     EABinStr      = '-EA_bins'
  ENDIF

  ;;current limits
  MCStr            = ''
  IF (ABS(MIMC_struct.minMC-10) GT 0.1) OR (ABS(MIMC_struct.maxNegMC+10) GT 0.1) THEN BEGIN
     MCStr         = STRING(FORMAT='("-cur_",I0,"-",I0)', $
                            MIMC_struct.maxNegMC, $
                            MIMC_struct.minMC)
  ENDIF

  ;;bonus
  bonusStr         = ''
  IF KEYWORD_SET(charE__Newell_the_cusp) THEN BEGIN
     bonusStr     += '-NC'
  ENDIF

  ;;doing polar contour?
  polarContStr=''
  IF KEYWORD_SET(plotH2D_contour) THEN BEGIN
     polarContStr  = '-cont'
  ENDIF

  IF KEYWORD_SET(plotH2D__kernel_density_unmask) THEN BEGIN
     polarContStr += '-kde'
  ENDIF
  
  ;; paramString=hoyDia+'-'+paramStrPrefix+(paramStrPrefix EQ "" ? "" : '-') + $
  paramString = paramStrPrefix+(paramStrPrefix EQ "" ? "" : '-') + $
                MIMC_struct.hemi+despunStr+coordStr+MCStr+bonusStr+sampTStr+ $
                lShellStr+plotMedOrAvg+$
                maskStr+tMaskStr+EABinStr+inc_burstStr+polarContStr+paramStrSuffix
  
  ;;Shouldn't be leftover, unused params from batch call
  IF ISA(e) THEN BEGIN
     IF $
        NOT tag_exist(e,"mirror") AND NOT tag_exist(e,"plottitle") AND NOT tag_exist(e,"midnight") $ ;keywords for interp_polar2dhist
     THEN BEGIN                 ;Check for passed variables here
        help,e
        print,e
        print,"Why the extra parameters? They have no home..."
        RETURN
     ENDIF ELSE BEGIN
        IF tag_exist(e,"wholecap") THEN BEGIN
           IF e.wholecap GT 0 THEN BEGIN
              minM=0.0
              maxM=24.0
           ENDIF
        ENDIF
     ENDELSE
     
  ENDIF
  
  ;;Check on ILAT stuff; if I don't do this, all kinds of plots get boogered up
  IF ( (MIMC_struct.maxI-MIMC_struct.minI) MOD MIMC_struct.binI ) NE 0 AND ~KEYWORD_SET(dont_correct_ilats) THEN BEGIN
     IF STRUPCASE(MIMC_struct.hemi) EQ "NORTH" THEN BEGIN
        MIMC_struct.minI += CEIL(MIMC_struct.maxI-MIMC_struct.minI) MOD binILAT
     ENDIF ELSE BEGIN
        MIMC_struct.maxI -= CEIL(MIMC_struct.maxI-MIMC_struct.minI) MOD binILAT
     ENDELSE
  ENDIF

  IF ARG_PRESENT(alfDB_plot_struct) THEN BEGIN

     IF N_ELEMENTS(alfDB_plot_struct) GT 0 AND ~KEYWORD_SET(reset) THEN BEGIN
        PRINT,"Already have an alfDB_plot_struct! Returning ..."
        RETURN
     ENDIF

     IF KEYWORD_SET(orbRange) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'orbRange',orbRange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(altitudeRange) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'altitudeRange',altitudeRange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(charERange) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'charERange',charERange,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(charE__Newell_the_cusp) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'charE__Newell_the_cusp',charE__Newell_the_cusp,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(poyntRange) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'poyntRange',poyntRange,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(sample_t_restriction) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'sample_t_restriction',sample_t_restriction,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(include_32Hz) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'include_32Hz',include_32Hz,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(disregard_sample_t) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'disregard_sample_t',disregard_sample_t,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(EA_binning) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'EA_binning',EA_binning,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(HwMAurOval) GT 0 THEN BEGIN
        STR_ELEMENT,AlfDB_Plot_Struct,'HwMAurOval',HwMAurOval,/ADD_REPLACE
     ENDIF
     IF N_ELEMENTS(HwMKpInd) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'HwMKpInd',HwMKpInd,/ADD_REPLACE
     ENDIF

     ;; IF N_ELEMENTS(min_nEvents) GT 0 THEN BEGIN
     ;;    STR_ELEMENT,alfDB_plot_struct,'min_nEvents',min_nEvents,/ADD_REPLACE
     ;; ENDIF

     IF N_ELEMENTS(maskMin) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'maskMin',maskMin,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(tHist_mask_bins_below_thresh) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'tHist_mask_bins_below_thresh',tHist_mask_bins_below_thresh,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(despunDB) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'despunDB',despunDB,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(chastDB) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'chastDB',chastDB,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(nPlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'nPlots',nPlots,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(ePlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'ePlots',ePlots,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(eFluxPlotType) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eFluxPlotType',eFluxPlotType,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(eNumFlPlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eNumFlPlots',eNumFlPlots,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(eNumFlPlotType) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eNumFlPlotType',eNumFlPlotType,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(pPlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'pPlots',pPlots,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(ionPlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'ionPlots',ionPlots,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(ifluxPlotType) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'ifluxPlotType',ifluxPlotType,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(charEPlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'charEPlots',charEPlots,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(charEType) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'charEType',charEType,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(chariEPlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'chariEPlots',chariEPlots,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(autoscale_fluxPlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'autoscale_fluxPlots',autoscale_fluxPlots,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(orbContribPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'orbContribPlot',orbContribPlot,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(orbTotPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'orbTotPlot',orbTotPlot,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(orbFreqPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'orbFreqPlot',orbFreqPlot,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(nEventPerOrbPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'nEventPerOrbPlot',nEventPerOrbPlot,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(nEventPerMinPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'nEventPerMinPlot',nEventPerMinPlot,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(probOccurrencePlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'probOccurrencePlot',probOccurrencePlot,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(squarePlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'squarePlot',squarePlot,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(polarContour) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'polarContour',polarContour,/ADD_REPLACE
     ENDIF
     IF N_ELEMENTS(wholeCap) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'wholeCap',wholeCap,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(medianPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'medianPlot',medianPlot,/ADD_REPLACE
     ENDIF
     IF N_ELEMENTS(logAvgPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'logAvgPlot',logAvgPlot,/ADD_REPLACE
     ENDIF
     IF N_ELEMENTS(plotMedOrAvg) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'plotMedOrAvg',plotMedOrAvg,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(dataDir) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'dataDir',dataDir,/ADD_REPLACE
     ENDIF
     IF N_ELEMENTS(no_burstData) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'no_burstData',no_burstData,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(writeASCII) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'writeASCII',writeASCII,/ADD_REPLACE
     ENDIF
     IF N_ELEMENTS(writeHDF5) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'writeHDF5',writeHDF5,/ADD_REPLACE
     ENDIF
     IF N_ELEMENTS(writeProcessedH2d) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'writeProcessedH2d',writeProcessedH2d,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(saveRaw) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'saveRaw',saveRaw,/ADD_REPLACE
     ENDIF
     IF KEYWORD_SET(rawDir) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'rawDir',rawDir,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(showPlotsNoSave) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'showPlotsNoSave',showPlotsNoSave,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(plotDir) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'plotDir',plotDir,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(medHistOutData) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'medHistOutData',medHistOutData,/ADD_REPLACE
     ENDIF
     IF KEYWORD_SET(medHistOutTxt) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'medHistOutTxt',medHistOutTxt,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(outputPlotSummary) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'outputPlotSummary',outputPlotSummary,/ADD_REPLACE
     ENDIF
     IF N_ELEMENTS(del_PS) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'del_PS',del_PS,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(keepMe) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'keepMe',keepMe,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(paramString) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'paramString',paramString,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(paramStrPrefix) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'paramStrPrefix',paramStrPrefix,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(paramStrSuffix) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'paramStrSuffix',paramStrSuffix,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(do_not_set_defaults) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'do_not_set_defaults',do_not_set_defaults,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(plotH2D_contour) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'plotH2D_contour',plotH2D_contour,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(plotH2D__kernel_density_unmask) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'plotH2D__kernel_density_unmask',plotH2D__kernel_density_unmask,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(hoyDia) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'hoyDia',hoyDia,/ADD_REPLACE
     ENDIF

  ENDIF
END