PRO SET_ALFVENDB_PLOT_DEFAULTS,ORBRANGE=orbRange, $
                               ALTITUDERANGE=altitudeRange, $
                               CHARERANGE=charERange, $
                               POYNTRANGE=poyntRange, $
                               SAMPLE_T_RESTRICTION=sample_t_restriction, $
                               MINMLT=minMLT,MAXMLT=maxMLT, $
                               BINMLT=binMLT, $
                               SHIFTMLT=shiftMLT, $
                               MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                               DO_LSHELL=do_lShell,MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
                               MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                               HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                               MIN_NEVENTS=min_nEvents, $
                               MASKMIN=maskMin, $
                               DO_DESPUNDB=do_despunDB, $
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
                               PLOTDIR=plotDir, $
                               MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                               OUTPUTPLOTSUMMARY=outputPlotSummary, DEL_PS=del_PS, $
                               KEEPME=keepMe, $
                               PARAMSTRING=paramString,PARAMSTRPREFIX=paramStrPrefix,PARAMSTRSUFFIX=paramStrSuffix,$
                               HOYDIA=hoyDia,LUN=lun, $
                               DONT_CORRECT_ILATS=dont_correct_ilats, $
                               DO_NOT_SET_DEFAULTS=do_not_set_defaults


  COMPILE_OPT idl2
  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  ;for statistical auroral oval
  defHwMAurOval          = 0
  defHwMKpInd            = 7

  ;Aujour d'hui
  hoyDia=GET_TODAY_STRING()

  ; Handle MLT and ILAT ... and L-shell
  IF ~KEYWORD_SET(do_not_set_defaults) THEN BEGIN
     SET_DEFAULT_MLT_ILAT_AND_MAGC,MINMLT=minMLT,MAXMLT=maxMLT, $
                                   BINM=binMLT, $
                                   SHIFTMLT=shiftMLT, $
                                   MINILAT=minILAT,MAXILAT=maxILAT,BINI=binILAT, $
                                   MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINL=binLshell, $
                                   MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                                   HEMI=hemi, $
                                   NORTH=north, $
                                   SOUTH=south, $
                                   BOTH_HEMIS=both_hemis, $
                                   LUN=lun
     
  ENDIF

  ;;***********************************************
  ;;Tons of defaults
  
  defeFluxPlotType = "Max"
  defENumFlPlotType = "ESA_Number_flux" 
  defIFluxPlotType = "Max"
  defCharEPlotType = "lossCone"

  ; assorted
  defMaskMin = 1

  defPlotDir = '/SPENCEdata/Research/Cusp/ACE_FAST/plots/'
  defRawDir = 'rawsaves/'

  defOutSummary = 1 ;for output plot summary

  defDataDir = "/SPENCEdata/Research/Cusp/database/"
  defMedHistDataDir = 'out/medHistData/'
  
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

  IF N_ELEMENTS(plotDir) EQ 0 THEN plotDir = defPlotDir ;;Directory stuff
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
     IF ~KEYWORD_SET(medHistDataDir) THEN medHistDataDir = defMedHistDataDir 
     medHistOutData = 1
  ENDIF

  IF N_ELEMENTS(paramStrSuffix) EQ 0 THEN paramStrSuffix = "" ;; ELSE paramStrSuffix = "--" + paramStrSuffix
  IF N_ELEMENTS(paramStrPrefix) EQ 0 THEN paramStrPrefix = "" ;; ELSE paramStrPrefix = paramStrPrefix + "--"

  lShellStr=''
  IF KEYWORD_SET(do_lShell) THEN lShellStr='--lShell'

  IF KEYWORD_SET(do_despundb) THEN despunStr     = '--despun' ELSE despunStr = ''

  IF KEYWORD_SET(sample_t_restriction) THEN BEGIN
     sample_t_string                             = STRING(FORMAT='("--sampT_restr_",F0.2,"s")',sample_t_restriction) 
  ENDIF ELSE BEGIN
     sample_t_string                             = ''
  ENDELSE
   
  ;;********************************************
  ;;A few other strings to tack on
  ;;tap DBs, and setup output
  IF KEYWORD_SET(no_burstData) THEN inc_burstStr ='--burstData_excluded' ELSE inc_burstStr=''

  IF KEYWORD_SET(medianplot) THEN plotMedOrAvg = "--median" ELSE BEGIN
     IF KEYWORD_SET(logAvgPlot) THEN plotMedOrAvg = "--logAvg" ELSE plotMedOrAvg = "--avg"
  ENDELSE

  ;;Set minimum allowable number of events for a histo bin to be displayed
  maskStr=''
  IF N_ELEMENTS(maskMin) EQ 0 THEN maskMin = defMaskMin $
  ELSE BEGIN
     IF maskMin GT 1 THEN BEGIN
        maskStr='--maskMin' + STRCOMPRESS(maskMin,/REMOVE_ALL)
     ENDIF
  ENDELSE
  
  ;;doing polar contour?
  polarContStr=''
  IF KEYWORD_SET(polarContour) THEN BEGIN
     polarContStr='--polarCont'
  ENDIF

  paramString=hoyDia+'--'+paramStrPrefix+(paramStrPrefix EQ "" ? "" : '--') + $
              hemi+despunStr+sample_t_string+lShellStr+plotMedOrAvg+maskStr+inc_burstStr+polarContStr+paramStrSuffix
  
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
  IF ( (maxILAT-minILAT) MOD binILAT ) NE 0 AND ~KEYWORD_SET(dont_correct_ilats) THEN BEGIN
     IF STRUPCASE(hemi) EQ "NORTH" THEN BEGIN
        minILAT += CEIL(maxILAT-minILAT) MOD binILAT
     ENDIF ELSE BEGIN
        maxILAT -= CEIL(maxILAT-minILAT) MOD binILAT
     ENDELSE
  ENDIF

END