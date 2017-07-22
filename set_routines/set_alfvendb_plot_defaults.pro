;                    ORBRANGE          :  Two-element vector, lower and upper limit on orbits to include
;                    ALTITUDERANGE     :  Two-element vector, lower and upper limit on altitudes to include
;                    CHARERANGE        :  Two-element vector, lower ahd upper limit on characteristic energy of electrons in
;                                            the LOSSCONE (could change it to total in get_chaston_ind.pro).
;                    POYNTRANGE        :  Two-element vector, lower and upper limit Range of Poynting flux values to include.
PRO SET_ALFVENDB_PLOT_DEFAULTS, $
   ORBRANGE=orbRange, $
   ALTITUDERANGE=altitudeRange, $
   CHARERANGE=charERange, $
   POYNTRANGE=poyntRange, $
   SAMPLE_T_RESTRICTION=sample_t_restriction, $
   INCLUDE_32HZ=include_32Hz, $
   DISREGARD_SAMPLE_T=disregard_sample_t, $
   NUMORBLIM=numOrbLim, $
   DONT_BLACKBALL_MAXIMUS=dont_blackball_maximus, $
   DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
   DIV_FLUXPLOTS_BY_ORBTOT=div_fluxPlots_by_orbTot, $
   DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
   DO_NOT_MAP_ANYTHING=noMapping, $
   MINMLT=minMLT, $
   MAXMLT=maxMLT, $
   BINMLT=binMLT, $
   SHIFTMLT=shiftMLT, $
   MINILAT=minILAT, $
   MAXILAT=maxILAT, $
   BINILAT=binILAT, $
   EQUAL_AREA_BINNING=EA_binning, $
   DO_LSHELL=do_lShell, $
   MINLSHELL=minLshell, $
   MAXLSHELL=maxLshell, $
   BINLSHELL=binLshell, $
   REVERSE_LSHELL=reverse_lShell, $
   MIN_MAGCURRENT=minMC, $
   MAX_NEGMAGCURRENT=maxNegMC, $
   HWMAUROVAL=HwMAurOval, $
   HWMKPIND=HwMKpInd, $
   MASKMIN=maskMin, $
   THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
   DESPUNDB=despunDB, $
   CHASTDB=chastDB, $
   COORDINATE_SYSTEM=coordinate_system, $
   USE_LNG=use_Lng, $
   USE_AACGM_COORDS=use_AACGM, $
   USE_GEI_COORDS=use_GEI, $
   USE_GEO_COORDS=use_GEO, $
   USE_MAG_COORDS=use_MAG, $
   USE_SDT_COORDS=use_SDT, $
   LOAD_DELTA_ILAT_FOR_WIDTH_TIME=load_dILAT, $
   LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=load_dAngle, $
   LOAD_DELTA_X_FOR_WIDTH_TIME=load_dx, $
   HEMI=hemi, $
   NORTH=north, $
   SOUTH=south, $
   BOTH_HEMIS=both_hemis, $
   DAYSIDE=dayside, $
   NIGHTSIDE=nightside, $
   NPLOTS=nPlots, $
   EPLOTS=ePlots, $
   NEWELLPLOTS=NewellPlots, $
   EFLUXPLOTTYPE=eFluxPlotType, $
   ENUMFLPLOTS=eNumFlPlots, $
   ENUMFLPLOTTYPE=eNumFlPlotType, $
   OXYPLOTS=oxyPlots, $
   OXYFLUXPLOTTYPE=oxyFluxPlotType, $
   PPLOTS=pPlots, $
   TIMEAVGD_PFLUXPLOT=timeAvgd_pFluxPlot, $
   TIMEAVGD_EFLUXMAXPLOT=timeAvgd_eFluxMaxPlot, $
   IONPLOTS=ionPlots, $
   IFLUXPLOTTYPE=ifluxPlotType, $
   CHAREPLOTS=charEPlots, $
   CHARETYPE=charEType, $
   CHARIEPLOTS=chariEPlots, $
   MAGCPLOTS=magCPlots, $
   ;; CALCVAR_EFLUX=calcVar_Eflux, $
   ;; CALCVAR_ENUMFL=calcVar_ENumFl, $
   ;; CALCVAR__SWAY=calcVar__sWay, $
   ;; CALCVAR_PFLUX=calcVar_Pflux, $
   ;; CALCVAR_IFLUX=calcVar_Iflux, $
   ;; CALCVAR_OXYFLUX=calcVar_OxyFlux, $
   ;; CALCVAR_CHARE=calcVar_CharE, $
   ;; CALCVAR_CHARIE=calcVar_Charie, $
   ;; CALCVAR_MAGC=calcVar_MagC, $
   ;; AUTOSCALE_FLUXPLOTS=autoscale_fluxPlots, $
   FLUXPLOTS__REMOVE_OUTLIERS=fluxPlots__remove_outliers, $
   FLUXPLOTS__REMOVE_LOG_OUTLIERS=fluxPlots__remove_log_outliers, $
   FLUXPLOTS__ADD_SUSPECT_OUTLIERS=fluxPlots__add_suspect_outliers, $
   FLUXPLOTS__INVERT_NEWELL_THE_CUSP=fluxPlots__invert_Newell_the_cusp, $
   FLUXPLOTS__NEWELL_THE_CUSP=fluxPlots__Newell_the_cusp, $
   FLUXPLOTS__BROADBAND_EVERYWHAR=fluxPlots__broadband_everywhar, $
   FLUXPLOTS__DIFFUSE_EVERYWHAR=fluxPlots__diffuse_everywhar, $
   DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
   DO_LOGAVG_THE_TIMEAVG=do_logAvg_the_timeAvg, $
   DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
   NEWELL_ANALYZE_EFLUX=Newell_analyze_eFlux, $
   NEWELL__COMB_ACCELERATED=Newell__comb_accelerated, $
   FOR_ION_DBS=for_ion_DBs, $
   ION__NO_MAXIMUS=ion__no_maximus, $
   ION__NOMAPTO100KM=ion__noMap, $
   ION__DOWNGOING=ion__downgoing, $
   ION_FLUX_PLOTS=ion_flux_plots, $
   ION__JUNK_ALFVEN_CANDIDATES=ion__junk_alfven_candidates, $
   ION__ALL_FLUXES=ion__all_fluxes, $
   FOR_ESPEC_DBS=for_eSpec_DBs, $
   ESPEC__NO_MAXIMUS=eSpec__no_maximus, $
   ESPEC__UPGOING=eSpec__upgoing, $
   ESPEC_FLUX_PLOTS=eSpec_flux_plots, $
   ESPEC__JUNK_ALFVEN_CANDIDATES=eSpec__junk_alfven_candidates, $
   ESPEC__ALL_FLUXES=eSpec__all_fluxes, $
   ESPEC__NEWELL_2009_INTERP=eSpec__Newell_2009_interp, $
   ESPEC__USE_2000KM_FILE=eSpec__use_2000km_file, $
   ESPEC__NOMAPTO100KM=eSpec__noMap, $
   ESPEC__REMOVE_OUTLIERS=eSpec__remove_outliers, $
   ESPEC__NEWELLPLOT_PROBOCCURRENCE=eSpec__newellPlot_probOccurrence, $
   ESPEC__T_PROBOCCURRENCE=t_ProbOccurrence, $
   FOR_SWAY_DB=for_sWay_DB, $
   SWAY_USE_8HZ_DB=sWay_use_8Hz_DB, $
   SWAY_MAXMAGFLAG=sWay_maxMagFlag, $
   SWAY_PLOTTYPE=sWay_plotType, $
   USE_STORM_STUFF=use_storm_stuff, $
   NONSTORM=nonStorm, $
   RECOVERYPHASE=recoveryPhase, $
   MAINPHASE=mainPhase, $
   ALL_STORM_PHASES=all_storm_phases, $
   DSTCUTOFF=dstCutoff, $
   SMOOTH_DST=smooth_dst, $
   TRASH_SSC_INDS=trash_ssc_inds, $
   USE_MOSTRECENT_DST_FILES=use_mostRecent_Dst_files, $
   AE_STUFF=ae_stuff, $
   USE_AE=use_ae, $
   USE_AU=use_au, $
   USE_AL=use_al, $
   USE_AO=use_ao, $
   AECUTOFF=AEcutoff, $
   SMOOTH_AE=smooth_AE, $
   AE_HIGH=AE_high, $
   AE_LOW=AE_low, $
   AE_BOTH=AE_both, $
   USE_MOSTRECENT_AE_FILES=use_mostRecent_AE_files, $
   ORBCONTRIBPLOT=orbContribPlot, $
   ORBTOTPLOT=orbTotPlot, $
   ORBFREQPLOT=orbFreqPlot, $
   NEVENTPERORBPLOT=nEventPerOrbPlot, $
   NEVENTPERMINPLOT=nEventPerMinPlot, $
   NORBSWITHEVENTSPERCONTRIBORBSPLOT=nOrbsWithEventsPerContribOrbsPlot, $
   PROBOCCURRENCEPLOT=probOccurrencePlot, $
   THISTDENOMINATORPLOT=tHistDenominatorPlot, $
   SQUAREPLOT=squarePlot, $
   POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
   MEDIANPLOT=medianPlot, $
   MAXPLOT=maxPlot, $
   MINPLOT=minPlot, $
   LOGAVGPLOT=logAvgPlot, $
   PLOTMEDORAVG=plotMedOrAvg, $
   DATADIR=dataDir, $
   NO_BURSTDATA=no_burstData, $
   WRITEASCII=writeASCII, $
   WRITEHDF5=writeHDF5, $
   WRITEPROCESSEDH2D=writeProcessedH2D, $
   SAVERAW=saveRaw, $
   SAVEDIR=saveDir, $
   JUSTDATA=justData, $
   JUSTINDS_THENQUIT=justInds, $
   JUSTINDS_SAVETOFILE=justInds_saveToFile, $
   SHOWPLOTSNOSAVE=showPlotsNoSave, $
   MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
   OUTPUTPLOTSUMMARY=outputPlotSummary, DEL_PS=del_PS, $
   KEEPME=keepMe, $
   PARAMSTRING=paramString, $
   PARAMSTRPREFIX=paramStrPrefix, $
   PARAMSTRSUFFIX=paramStrSuffix,$
   PLOTH2D_CONTOUR=plotH2D_contour, $
   CONTOUR__LEVELS=contour__levels, $
   CONTOUR__PERCENT=contour__percent, $
   CONTOUR__NCOLORS=contour__nColors, $
   CONTOUR__CTINDEX=contour__CTIndex, $
   CONTOUR__CTBOTTOM=contour__CTBottom, $
   PLOTH2D__KERNEL_DENSITY_UNMASK=plotH2D__kernel_density_unmask, $
   SHOW_INTEGRALS=show_integrals, $
   MAKE_INTEGRAL_TXTFILE=make_integral_txtfile, $
   MAKE_INTEGRAL_SAVFILES=make_integral_savfiles, $
   INTEGRALSAVFILEPREF=integralSavFilePref, $
   CUSTOM_INTEGRAL_STRUCT=custom_integral_struct, $
   OVERPLOT_FILE=overplot_file, $
   OVERPLOT_ARR=overplot_arr, $
   OVERPLOT_CONTOUR__LEVELS=op_contour__levels, $
   OVERPLOT_CONTOUR__PERCENT=op_contour__percent, $
   OVERPLOT_CONTOUR__NCOLORS=op_contour__nColors, $
   OVERPLOT_CONTOUR__CTINDEX=op_contour__CTIndex, $
   OVERPLOT_CONTOUR__CTBOTTOM=op_contour__CTBottom, $
   OVERPLOT_PLOTRANGE=op_plotRange, $
   ;; HOYDIA=hoyDia, $
   ;; VAR__EACH_BIN=var__each_bin, $
   ;; VAR__DISTTYPE=var__distType, $
   VAROPT=varOpt, $
   LUN=lun, $
   DONT_CORRECT_ILATS=dont_correct_ilats, $
   MIMC_STRUCT=MIMC_struct, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   RESET_STRUCT=reset, $
   DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
   _EXTRA=e

  COMPILE_OPT idl2,strictarrsubs
  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  IF N_ELEMENTS(saveDir) EQ 0 THEN BEGIN 
     saveDir = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/saves_output_etc/'
  ENDIF

  ;for statistical auroral oval
  defHwMAurOval          = 0
  defHwMKpInd            = 7

  ;Aujour d'hui
  ;; hoyDia                 = GET_TODAY_STRING()

  ; Handle MLT and ILAT ... and L-shell
  IF ~KEYWORD_SET(do_not_set_defaults) THEN BEGIN
     SET_DEFAULT_MLT_ILAT_AND_MAGC, $
        MINMLT=minMLT,MAXMLT=maxMLT, $
        BINM=binMLT, $
        SHIFTMLT=shiftMLT, $
        MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
        DONT_CORRECT_ILATS=dont_correct_ilats, $
        COORDINATE_SYSTEM=coordinate_system, $
        USE_LNG=use_Lng, $
        USE_AACGM_COORDS=use_AACGM, $
        USE_GEI_COORDS=use_GEI, $
        USE_GEO_COORDS=use_GEO, $
        USE_MAG_COORDS=use_MAG, $
        USE_SDT_COORDS=use_SDT, $
        MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
        REVERSE_LSHELL=reverse_lShell, $
        MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
        HEMI=hemi, $
        NORTH=north, $
        SOUTH=south, $
        BOTH_HEMIS=both_hemis, $
        GLOBE=globe, $
        DAYSIDE=dayside, $
        NIGHTSIDE=nightside, $
        MIMC_STRUCT=MIMC_struct, $
        _EXTRA=e, $
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
  IF N_ELEMENTS(HwMAurOval       ) EQ 0 THEN HwMAurOval        = defHwMAurOval
  IF N_ELEMENTS(HwMKpInd         ) EQ 0 THEN HwMKpInd          = defHwMKpInd

  IF N_ELEMENTS(nPlots           ) EQ 0 THEN nPlots            = 0B                ; do num events plots?
  IF N_ELEMENTS(ePlots           ) EQ 0 THEN ePlots            = 0B                ;electron energy flux plots?
  IF N_ELEMENTS(eFluxPlotType    ) EQ 0 THEN eFluxPlotType     = defEFluxPlotType  ;options are "Integ" and "Max"
  IF N_ELEMENTS(iFluxPlotType    ) EQ 0 THEN iFluxPlotType     = defIFluxPlotType  ;options are "Integ", "Max", "Integ_Up", "Max_Up", and "Energy"
  IF N_ELEMENTS(eNumFlPlots      ) EQ 0 THEN eNumFlPlots       = 0B                ;electron number flux plots?
  IF N_ELEMENTS(eNumFlPlotType   ) EQ 0 THEN eNumFlPlotType    = defENumFlPlotType ;options are "Total_Eflux_Integ","Eflux_Losscone_Integ", "ESA_Number_flux"
  IF N_ELEMENTS(pPlots           ) EQ 0 THEN pPlots            = 0B                ;Poynting flux [estimate] plots?
  IF N_ELEMENTS(ionPlots         ) EQ 0 THEN ionPlots          = 0B                ;ion Plots?
  IF N_ELEMENTS(charEPlots       ) EQ 0 THEN charEPlots        = 0B                ;char E plots?
  IF N_ELEMENTS(charEType        ) EQ 0 THEN charEType         = defCharEPlotType  ;options are "lossCone" and "Total"
  IF N_ELEMENTS(chariEPlots      ) EQ 0 THEN chariEPlots       = 0B                ;char E plots?
  IF N_ELEMENTS(magCPlots        ) EQ 0 THEN magCPlots         = 0B
  IF N_ELEMENTS(orbContribPlot   ) EQ 0 THEN orbContribPlot    = 0B ;Contributing orbits plot?
  IF N_ELEMENTS(orbTotPlot       ) EQ 0 THEN orbTotPlot        = 0B ;"Total orbits considered" plot?
  IF N_ELEMENTS(orbFreqPlot      ) EQ 0 THEN orbFreqPlot       = 0B ;Contributing/total orbits plot?
  IF N_ELEMENTS(nEventPerOrbPlot ) EQ 0 THEN nEventPerOrbPlot  = 0B ;N Events/orbit plot?
  IF N_ELEMENTS(nEventPerMinPlot ) EQ 0 THEN nEventPerMinPlot  = 0B ;N Events/min plot?

  ;; IF KEYWORD_SET(autoscale_fluxPlots) THEN PRINT,"Autoscaling flux plots..."


  IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
     IF KEYWORD_SET(ePlots) OR KEYWORD_SET(eSpec__newellPlot_probOccurrence) THEN BEGIN
        eFluxPlotType           = 'eFlux_eSpec' + $
                                  ( KEYWORD_SET(eSpec__Newell_2009_interp) ? $
                                    '-2009' : '' )
     ENDIF

     IF KEYWORD_SET(eNumFlPlots) THEN BEGIN
        eNumFlPlotType          = 'eNumFlux_eSpec' + $
                                  ( KEYWORD_SET(eSpec__Newell_2009_interp) ? $
                                    '-2009' : '' )
     ENDIF

     IF KEYWORD_SET(charEPlots) OR KEYWORD_SET(eSpec__newellPlot_probOccurrence) THEN BEGIN
        charEType               = 'charE_eSpec' + $
                                  ( KEYWORD_SET(eSpec__Newell_2009_interp) ? $
                                    '-2009' : '' )
     ENDIF

     ;; IF KEYWORD_SET(ionPlots) THEN BEGIN
     ;;    CASE 1 OF
     ;;       STRUPCASE(iFluxPlotType) EQ 'ENERGY': BEGIN
     ;;          iFluxPlotType     = 'JEi_eSpec' + $
     ;;                              ( KEYWORD_SET(ion__Newell_2009_interp) ? $
     ;;                                '-2009' : '' )
     ;;       END
     ;;       ELSE: BEGIN
     ;;          iFluxPlotType     = 'Ji_eSpec' + $
     ;;                              ( KEYWORD_SET(ion__Newell_2009_interp) ? $
     ;;                                '-2009' : '' )
     ;;       END
     ;;    ENDCASE
     ;; ENDIF
  ENDIF

  ;; IF KEYWORD_SET(for_ion_DBs) THEN BEGIN
  ;;    IF KEYWORD_SET(ionPlots) THEN BEGIN
  ;;       iFluxPlotType           = 'eFlux_eSpec' + $
  ;;                                 ;; ( KEYWORD_SET(eSpec__Newell_2009_interp) ? $
  ;;                                 ;;   '-2009' : '' )
  ;;    ENDIF

  ;;    IF KEYWORD_SET(eNumFlPlots) THEN BEGIN
  ;;       eNumFlPlotType          = 'eNumFlux_eSpec' + $
  ;;                                 ( KEYWORD_SET(eSpec__Newell_2009_interp) ? $
  ;;                                   '-2009' : '' )
  ;;    ENDIF

  ;;    IF KEYWORD_SET(charEPlots) OR KEYWORD_SET(eSpec__newellPlot_probOccurrence) THEN BEGIN
  ;;       charEType               = 'charE_eSpec' + $
  ;;                                 ( KEYWORD_SET(eSpec__Newell_2009_interp) ? $
  ;;                                   '-2009' : '' )
  ;;    ENDIF

  ;;    ;; IF KEYWORD_SET(ionPlots) THEN BEGIN
  ;;    ;;    CASE 1 OF
  ;;    ;;       STRUPCASE(iFluxPlotType) EQ 'ENERGY': BEGIN
  ;;    ;;          iFluxPlotType     = 'JEi_eSpec' + $
  ;;    ;;                              ( KEYWORD_SET(ion__Newell_2009_interp) ? $
  ;;    ;;                                '-2009' : '' )
  ;;    ;;       END
  ;;    ;;       ELSE: BEGIN
  ;;    ;;          iFluxPlotType     = 'Ji_eSpec' + $
  ;;    ;;                              ( KEYWORD_SET(ion__Newell_2009_interp) ? $
  ;;    ;;                                '-2009' : '' )
  ;;    ;;       END
  ;;    ;;    ENDCASE
  ;;    ;; ENDIF
  ;; ENDIF

  IF (KEYWORD_SET(nEventPerOrbPlot) OR KEYWORD_SET(nEventPerMinPlot) ) AND NOT KEYWORD_SET(nPlots) THEN BEGIN
     print,"Can't do nEventPerOrbPlot without nPlots!!"
     print,"Enabling nPlots..."
     nPlots=1
  ENDIF

  ;; IF N_ELEMENTS(plotDir) EQ 0 THEN plotDir = defPlotDir ;;Directory stuff
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

  lngAble = KEYWORD_SET(use_AACGM) + KEYWORD_SET(use_GEI) + KEYWORD_SET(use_GEO) + KEYWORD_SET(use_MAG) 
  stopMe  = lngAble + KEYWORD_SET(use_SDT) ;have we set too many (i.e., gt 1) keywords?
  IF stopMe GT 1 THEN STOP
  CASE 1 OF
     KEYWORD_SET(use_AACGM): BEGIN
        coordStr = '_AACGM'
     END
     KEYWORD_SET(use_GEI): BEGIN
        coordStr = '_GEI'
     END
     KEYWORD_SET(use_GEO): BEGIN
        coordStr = '_GEO'
     END
     KEYWORD_SET(use_MAG): BEGIN
        coordStr = '_MAG'
     END
     ELSE: BEGIN
        coordStr = ''
     END
  ENDCASE

  IF KEYWORD_SET(use_Lng) THEN BEGIN
     IF KEYWORD_SET(lngAble) THEN BEGIN
        coordStr += '_lng'
     ENDIF ELSE BEGIN
        PRINT,"You've requested use of longitudes, but that's incompatible with the coordinate system you've selected: " + coordStr
        STOP
     ENDELSE
  ENDIF

  IF KEYWORD_SET(load_dILAT ) THEN coordStr += '_dI'
  IF KEYWORD_SET(load_dAngle) THEN coordStr += '_dA'
  IF KEYWORD_SET(load_dx    ) THEN coordStr += '_dx'

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
  IF KEYWORD_SET(no_burstData) THEN inc_burstStr ='-noBurst' ELSE inc_burstStr=''

  CASE 1 OF
     KEYWORD_SET(medianPlot): BEGIN
        plotMedOrAvg = "-med"
     END
     KEYWORD_SET(maxPlot): BEGIN
        plotMedOrAvg = "-max"
     END
     KEYWORD_SET(minPlot): BEGIN
        plotMedOrAvg = "-min"
     END
     ELSE: BEGIN
        IF KEYWORD_SET(logAvgPlot) THEN BEGIN
           plotMedOrAvg = "-lgAvg"
        ENDIF ELSE BEGIN
           plotMedOrAvg = "-avg"
        ENDELSE
     END
  ENDCASE

  ;;Set minimum allowable number of events for a histo bin to be displayed
  maskStr = ''
  IF N_ELEMENTS(maskMin) EQ 0 THEN BEGIN
     maskMin = defMaskMin
  ENDIF
  IF maskMin GT 1 THEN BEGIN
     maskStr = '-mskMin_' + STRING(FORMAT='(I0)',maskMin)
  ENDIF

  ;;Set minimum # minutes that must be spent in each bin for inclusion
  tMaskStr = ''
  ;; IF N_ELEMENTS(tHist_mask_bins_below_thresh) EQ 0 THEN BEGIN
  ;;    maskMin = defMaskMin
  ;; ENDIF
  IF N_ELEMENTS(tHist_mask_bins_below_thresh) GT 0 THEN BEGIN
     ;; IF tHist_mask_bins_below_thresh GT 1 THEN BEGIN
        tMaskStr = '-tThresh_' + STRING(FORMAT='(I0)',tHist_mask_bins_below_thresh)
     ;; ENDIF
  ENDIF

  EABinStr = ''
  IF KEYWORD_SET(EA_binning) THEN BEGIN
     EABinStr      = '-EA'
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
  nCharERestr      = 0
  IF KEYWORD_SET(fluxPlots__invert_Newell_the_cusp) THEN BEGIN
     bonusStr     += '-invNC'
     nCharERestr++
  ENDIF

  IF KEYWORD_SET(fluxPlots__Newell_the_cusp) THEN BEGIN
     bonusStr     += '-NC'
     nCharERestr++
  ENDIF

  IF KEYWORD_SET(fluxPlots__broadband_everywhar) THEN BEGIN
     bonusStr     += '-broadEvry'
     nCharERestr++
  ENDIF

  IF KEYWORD_SET(fluxPlots__diffuse_everywhar) THEN BEGIN
     bonusStr     += '-diffEvry'
     nCharERestr++
  ENDIF

  IF nCharERestr GT 1 THEN BEGIN
     PRINT,"Bro! You can't set more than one of FLUXPLOTS__INVERT_NEWELL_THE_CUSP, FLUXPLOTS__NEWELL_THE_CUSP, FLUXPLOTS__BROADBAND_EVERYWHAR, and FLUXPLOTS__DIFFUSE_EVERYWHAR, but that's exactly what you've done! Haven't you learned how to use your own program? Have you even considered what you're asking for? Don't lie to me and say that you have, because you know you haven't. What makes you think you're so much different—so ""special""— compared to the rest of us? Is that how your parents raised you? What would your mom think if she saw you acting this way?"
     PRINT,"You think this is some sort of joke, but I'm telling you—I know where you live. I know what else you think you're getting away with. Wanna find out what happens if you keep this up? Watch. Just watch what happens. You're gonna find out if this little ""joke"" is funny after all. Go ahead—restart the program and act like we didn't have this conversation. But it's not going to change the facts, or the world of pain you'll find yourself in when they find out, when I come for you. It's real this time, bro."
     STOP
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
                ;; maskStr+tMaskStr+EABinStr+inc_burstStr+polarContStr+paramStrSuffix
                maskStr+tMaskStr+EABinStr+inc_burstStr+paramStrSuffix

  ;;Shouldn't be leftover, unused params from batch call
  ;; IF ISA(e) THEN BEGIN
  ;;    IF $
  ;;       NOT tag_exist(e,"mirror") AND $
  ;;       ~(TAG_EXIST(e,"plottitle") OR TAG_EXIST(e,"midnight")) $ ;keywords for interp_polar2dhist
  ;;    THEN BEGIN                 ;Check for passed variables here
  ;;       HELP,e
  ;;       PRINT,e
  ;;       PRINT,"Why the extra parameters? They have no home..."
  ;;    ENDIF ELSE BEGIN
  ;;       IF TAG_EXIST(e,"wholecap") THEN BEGIN
  ;;          IF e.wholecap GT 0 THEN BEGIN
  ;;             MIMC_struct.minM = 0.0
  ;;             MIMC_struct.maxM = 24.0
  ;;          ENDIF
  ;;       ENDIF
  ;;    ENDELSE

  ;; ENDIF

  ;;Check on ILAT stuff; if I don't do this, all kinds of plots get boogered up
  IF ( (MIMC_struct.maxI-MIMC_struct.minI) MOD MIMC_struct.binI ) NE 0 AND $
     ~KEYWORD_SET(MIMC_struct.dont_correct_ilats) THEN BEGIN
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

     ;;Set one up with all of the binary values set
     alfDB_plot_struct = { $
                         include_32Hz                      : 0B, $
                         disregard_sample_t                : 0B, $
                         sample_t_restriction              : 0B, $
                         numOrbLim                         : 0B, $
                         dont_blackball_maximus            : 0B, $
                         dont_blackball_fastloc            : 0B, $
                         div_fluxPlots_by_orbTot           : 0B, $
                         div_fluxPlots_by_applicable_orbs  : 0B, $
                         noMapping                         : 0B, $
                         EA_binning                        : 0B, $
                         HwMAurOval                        : 0B, $
                         tHist_mask_bins_below_thresh      : 0B, $
                         despunDB                          : 0B, $
                         chastDB                           : 0B, $
                         load_dILAT                        : 0B, $
                         load_dAngle                       : 0B, $
                         load_dx                           : 0B, $
                         nPlots                            : 0B, $
                         ePlots                            : 0B, $
                         timeAvgd_eFluxMaxPlot             : 0B, $
                         eNumFlPlots                       : 0B, $
                         NewellPlots                       : 0B, $
                         oxyPlots                          : 0B, $
                         pPlots                            : 0B, $
                         timeAvgd_pFluxPlot                : 0B, $
                         ionPlots                          : 0B, $
                         charEPlots                        : 0B, $
                         chariEPlots                       : 0B, $
                         magCPlots                         : 0B, $
                         ;; calcVar_Eflux                     : 0B, $
                         ;; calcVar_ENumFl                    : 0B, $
                         ;; calcVar__sWay                     : 0B, $
                         ;; calcVar_Pflux                     : 0B, $
                         ;; calcVar_Iflux                     : 0B, $
                         ;; calcVar_OxyFlux                   : 0B, $
                         ;; calcVar_CharE                     : 0B, $
                         ;; calcVar_Charie                    : 0B, $
                         ;; calcVar_MagC                      : 0B, $
                         ;; autoscale_fluxPlots               : 0B, $
                         fluxPlots__remove_outliers        : 0B, $
                         fluxPlots__remove_log_outliers    : 0B, $
                         fluxPlots__add_suspect_outliers   : 0B, $
                         fluxPlots__invert_Newell_the_cusp : 0B, $
                         fluxPlots__Newell_the_cusp        : 0B, $
                         fluxPlots__broadband_everywhar    : 0B, $
                         fluxPlots__diffuse_everywhar      : 0B, $
                         do_timeAvg_fluxQuantities         : 0B, $
                         do_logAvg_the_timeAvg             : 0B, $
                         do_grossRate_fluxQuantities       : 0B, $
                         Newell_analyze_eFlux              : 0B, $
                         Newell__comb_accelerated          : 0B, $
                         for_ion_DBs                       : 0B, $
                         ion__no_maximus                   : 0B, $
                         ion__noMap                        : 0B, $
                         ion__downgoing                    : 0B, $
                         ion_flux_plots                    : 0B, $
                         ion__junk_alfven_candidates       : 0B, $
                         ion__all_fluxes                   : 0B, $
                         for_eSpec_DBs                     : 0B, $
                         eSpec__no_maximus                 : 0B, $
                         eSpec__upgoing                    : 0B, $
                         eSpec_flux_plots                  : 0B, $
                         eSpec__junk_alfven_candidates     : 0B, $
                         eSpec__all_fluxes                 : 0B, $
                         eSpec__Newell_2009_interp         : 0B, $
                         eSpec__use_2000km_file            : 0B, $
                         eSpec__noMap                      : 0B, $
                         eSpec__remove_outliers            : 0B, $
                         eSpec__newellPlot_probOccurrence  : 0B, $
                         t_probOccurrence                  : 0B, $
                         for_sWay_DB                       : 0B, $
                         sWay_use_8Hz_DB                   : 0B, $
                         sWay_maxMagFlag                   : 0B, $
                         sWay_plotType                     : '', $
                         orbContribPlot                    : 0B, $
                         orbTotPlot                        : 0B, $
                         orbFreqPlot                       : 0B, $
                         nEventPerOrbPlot                  : 0B, $
                         nEventPerMinPlot                  : 0B, $
                         nOrbsWithEventsPerContribOrbsPlot : 0B, $
                         probOccurrencePlot                : 0B, $
                         tHistDenominatorPlot              : 0B, $
                         squarePlot                        : 0B, $
                         polarContour                      : 0B, $
                         medianPlot                        : 0B, $
                         maxPlot                           : 0B, $
                         minPlot                           : 0B, $
                         logAvgPlot                        : 0B, $
                         plotMedOrAvg                      : 0B, $
                         no_burstData                      : 0B, $
                         writeASCII                        : 0B, $
                         writeHDF5                         : 0B, $
                         writeProcessedH2D                 : 0B, $
                         justData                          : 0B, $
                         justInds                          : 0B, $
                         justInds_saveToFile               : 0B, $
                         saveRaw                           : 0B, $
                         saveDir                           : '', $
                         showPlotsNoSave                   : 0B, $
                         outputPlotSummary                 : 0B, $
                         del_PS                            : 0B, $
                         keepMe                            : 0B, $
                         plotH2D_contour                   : 0B, $
                         contour__levels                   : 0B, $
                         contour__percent                  : 0B, $
                         contour__nColors                  : 0B, $
                         plotH2D__kernel_density_unmask    : 0B, $
                         ;; contour__CTIndex            : 0B, $
                         show_integrals                    : 0B, $
                         nCustomIntegrals                  : 0B, $
                         make_integral_txtfile             : 0B, $
                         make_integral_savfiles            : 0B, $
                         integralSavFilePref               : '', $
                         overplot_file                     : '', $
                         overplot_arr                      : 0B, $
                         op_contour__levels                : 0B, $
                         op_contour__percent               : 0B, $
                         op_plotRange                      : 0B, $
                         paramString                       : ''      , $
                         paramString_list                  : LIST()  , $
                         executing_multiples               : 0B, $
                         multiString                       : '', $
                         multiples                         : '', $
                         multi_i                           : 0 , $
                         multiple_IMF_clockAngles          : 0B, $
                         multiple_B_conds                  : 0B, $
                         multiple_delays                   : 0B, $
                         multiple_storm                    : 0B, $
                         multiple_AE                       : 0B, $
                         ae_stuff                          : 0B, $
                         use_storm_stuff                   : 0B, $
                         ;; var__each_bin                     : 0B, $
                         ;; var__distType                     : 'norm', $
                         varOpt                            : PAS__VAROPT_INIT() $
                         }

     IF KEYWORD_SET(use_storm_stuff) THEN BEGIN

        STR_ELEMENT,alfDB_plot_struct,'use_storm_stuff',use_storm_stuff,/ADD_REPLACE

        storm_opt = { $
                   nonStorm                  : 0B  , $
                   recoveryPhase             : 0B  , $
                   mainPhase                 : 0B  , $
                   all_storm_phases          : 0B  , $
                   dstCutoff                 : -20 , $
                   smooth_dst                : 0B  , $
                   use_mostRecent_Dst_files  : 0B  , $
                   trash_SSC_inds            : 0B}


        IF N_ELEMENTS(nonStorm) GT 0 THEN BEGIN
           STR_ELEMENT,storm_opt,'nonStorm',nonStorm,/ADD_REPLACE
           IF KEYWORD_SET(nonStorm) THEN BEGIN
              paramString = paramString + 'nStorm'
           ENDIF
        ENDIF

        IF N_ELEMENTS(recoveryPhase) GT 0 THEN BEGIN
           STR_ELEMENT,storm_opt,'recoveryPhase',recoveryPhase,/ADD_REPLACE
           IF KEYWORD_SET(recoveryPhase) THEN BEGIN
              paramString = paramString + 'rPhase'
           ENDIF
        ENDIF

        IF N_ELEMENTS(mainPhase) GT 0 THEN BEGIN
           STR_ELEMENT,storm_opt,'mainPhase',mainPhase,/ADD_REPLACE
           IF KEYWORD_SET(mainPhase) THEN BEGIN
              paramString = paramString + 'mPhase'
           ENDIF
        ENDIF

        IF N_ELEMENTS(all_storm_phases) GT 0 THEN BEGIN
           STR_ELEMENT,storm_opt,'all_storm_phases',all_storm_phases,/ADD_REPLACE
        ENDIF

        IF N_ELEMENTS(dstCutoff) GT 0 THEN BEGIN
           STR_ELEMENT,storm_opt,'dstCutoff',dstCutoff,/ADD_REPLACE
        ENDIF

        IF N_ELEMENTS(smooth_dst) GT 0 THEN BEGIN
           STR_ELEMENT,storm_opt,'smDst',smooth_dst,/ADD_REPLACE
        ENDIF

        IF N_ELEMENTS(use_mostRecent_Dst_files) GT 0 THEN BEGIN
           STR_ELEMENT,storm_opt,'use_mostRecent_Dst_files', $
                       use_mostRecent_Dst_files,/ADD_REPLACE
        ENDIF

        IF N_ELEMENTS(trash_SSC_inds) GT 0 THEN BEGIN
           STR_ELEMENT,storm_opt,'trash_SSC_inds', $
                       trash_SSC_inds,/ADD_REPLACE
        ENDIF

        STR_ELEMENT,alfDB_plot_struct,'storm_opt',storm_opt,/ADD_REPLACE

        IF KEYWORD_SET(all_storm_phases) THEN BEGIN
           multiples           = ["nStorm","mPhase","rPhase"]
           multiString         = "-allPhases"
           executing_multiples = 1
           alfDB_plot_struct.executing_multiples = 1
           alfDB_plot_struct.multiString         = multiString
           STR_ELEMENT,alfDB_plot_struct,'multiples',multiples,/ADD_REPLACE
        ENDIF
     ENDIF

     IF KEYWORD_SET(ae_stuff) THEN BEGIN

        STR_ELEMENT,alfDB_plot_struct,'ae_stuff',ae_stuff,/ADD_REPLACE

        ae_opt = { $
                 use_ae                   : 0B  , $
                 use_au                   : 0B  , $
                 use_al                   : 0B  , $
                 use_ao                   : 0B  , $
                 AEcutoff                 : 100 , $
                 smooth_AE                : 0B  , $
                 AE_high                  : 0B  , $
                 AE_low                   : 0B  , $
                 AE_both                  : 0B  , $
                 use_mostRecent_AE_files  : 0B}

        IF N_ELEMENTS(use_ae) GT 0 THEN BEGIN
           STR_ELEMENT,ae_opt,'use_ae',use_ae,/ADD_REPLACE
           navn = 'AE'
        ENDIF

        IF N_ELEMENTS(use_au) GT 0 THEN BEGIN
           STR_ELEMENT,ae_opt,'use_au',use_au,/ADD_REPLACE
           navn = 'AU'
        ENDIF

        IF N_ELEMENTS(use_al) GT 0 THEN BEGIN
           STR_ELEMENT,ae_opt,'use_al',use_al,/ADD_REPLACE
           navn = 'AL'
        ENDIF

        IF N_ELEMENTS(use_ao) GT 0 THEN BEGIN
           STR_ELEMENT,ae_opt,'use_ao',use_ao,/ADD_REPLACE
           navn = 'AO'
        ENDIF

        IF N_ELEMENTS(AEcutoff) GT 0 THEN BEGIN
           STR_ELEMENT,ae_opt,'AEcutoff',AEcutoff,/ADD_REPLACE
        ENDIF

        IF N_ELEMENTS(smooth_AE) GT 0 THEN BEGIN
           STR_ELEMENT,ae_opt,'smooth_AE',smooth_AE,/ADD_REPLACE
        ENDIF

        IF N_ELEMENTS(AE_high) GT 0 THEN BEGIN
           STR_ELEMENT,ae_opt,'AE_high',AE_high,/ADD_REPLACE
           IF KEYWORD_SET(AE_high) THEN BEGIN
              paramString = paramString + 'high_' + navn
           ENDIF
        ENDIF

        IF N_ELEMENTS(AE_low) GT 0 THEN BEGIN
           STR_ELEMENT,ae_opt,'AE_low',AE_low,/ADD_REPLACE
           IF KEYWORD_SET(AE_low) THEN BEGIN
              paramString = paramString + 'low_' + navn
           ENDIF
        ENDIF

        IF N_ELEMENTS(AE_both) GT 0 THEN BEGIN
           STR_ELEMENT,ae_opt,'AE_both',AE_both,/ADD_REPLACE
        ENDIF

        IF N_ELEMENTS(use_mostRecent_AE_files) GT 0 THEN BEGIN
           STR_ELEMENT,ae_opt,'use_mostRecent_AE_files', $
                       use_mostRecent_AE_files,/ADD_REPLACE
        ENDIF

        STR_ELEMENT,alfDB_plot_struct,'ae_opt',ae_opt,/ADD_REPLACE

        IF KEYWORD_SET(AE_both) THEN BEGIN
           multiples             = ['high_','low_'] + navn
           executing_multiples   = 1
           multiString           = '-' + navn+'_both'
           alfDB_plot_struct.executing_multiples = 1
           STR_ELEMENT,alfDB_plot_struct,'multiples',multiples,/ADD_REPLACE
        ENDIF
     ENDIF

     IF KEYWORD_SET(orbRange) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'orbRange', $
                    orbRange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(altitudeRange) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'altitudeRange', $
                    altitudeRange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(charERange) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'charERange', $
                    charERange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(poyntRange) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'poyntRange', $
                    poyntRange,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(sample_t_restriction) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'sample_t_restriction', $
                    sample_t_restriction,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(numOrbLim) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'numOrbLim', $
                    numOrbLim,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(dont_blackball_maximus) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'dont_blackball_maximus', $
                    dont_blackball_maximus,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(dont_blackball_fastloc) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'dont_blackball_fastloc', $
                    dont_blackball_fastloc,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(div_fluxPlots_by_orbTot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'div_fluxPlots_by_orbTot', $
                    div_fluxPlots_by_orbTot,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(div_fluxPlots_by_applicable_orbs) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'div_fluxPlots_by_applicable_orbs', $
                    div_fluxPlots_by_applicable_orbs,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(noMapping) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'noMapping', $
                    noMapping,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(include_32Hz) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'include_32Hz', $
                    BYTE(include_32Hz),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(disregard_sample_t) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'disregard_sample_t', $
                    BYTE(disregard_sample_t),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(EA_binning) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'EA_binning', $
                    BYTE(EA_binning),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(HwMAurOval) GT 0 THEN BEGIN
        STR_ELEMENT,AlfDB_Plot_Struct,'HwMAurOval', $
                    BYTE(HwMAurOval),/ADD_REPLACE
     ENDIF
     IF N_ELEMENTS(HwMKpInd) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'HwMKpInd', $
                    HwMKpInd,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(maskMin) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'maskMin', $
                    maskMin,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(tHist_mask_bins_below_thresh) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'tHist_mask_bins_below_thresh', $
                    tHist_mask_bins_below_thresh,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(despunDB) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'despunDB', $
                    BYTE(despunDB),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(load_dILAT) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'load_dILAT', $
                    BYTE(load_dILAT),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(load_dAngle) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'load_dAngle', $
                    BYTE(load_dAngle),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(load_dx) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'load_dx', $
                    BYTE(load_dx),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(chastDB) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'chastDB', $
                    BYTE(chastDB),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(nPlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'nPlots', $
                    BYTE(nPlots),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(ePlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'ePlots', $
                    BYTE(ePlots),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(timeAvgd_eFluxMaxPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'timeAvgd_eFluxMaxPlot', $
                    BYTE(timeAvgd_eFluxMaxPlot),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(NewellPlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'NewellPlots', $
                    BYTE(NewellPlots),/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(eFluxPlotType) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eFluxPlotType', $
                    eFluxPlotType,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(eNumFlPlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eNumFlPlots', $
                    BYTE(eNumFlPlots),/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(eNumFlPlotType) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eNumFlPlotType', $
                    eNumFlPlotType,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(oxyFluxPlotType) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'oxyFluxPlotType', $
                    oxyFluxPlotType,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(pPlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'pPlots', $
                    BYTE(pPlots),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(timeAvgd_pFluxPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'timeAvgd_pFluxPlot', $
                    BYTE(timeAvgd_pFluxPlot),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(ionPlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'ionPlots', $
                    BYTE(ionPlots),/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(ifluxPlotType) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'ifluxPlotType', $
                    ifluxPlotType,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(charEPlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'charEPlots', $
                    BYTE(charEPlots),/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(charEType) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'charEType', $
                    charEType,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(chariEPlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'chariEPlots', $
                    BYTE(chariEPlots),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(magCPlots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'magCPlots', $
                    BYTE(magCPlots),/ADD_REPLACE
     ENDIF

     ;; IF N_ELEMENTS(calcVar_Eflux) GT 0 THEN BEGIN
     ;;    STR_ELEMENT,alfDB_plot_struct,'calcVar_Eflux', $
     ;;    BYTE(calcVar_Eflux),/ADD_REPLACE
     ;; ENDIF
  
     ;; IF N_ELEMENTS(calcVar_ENumFl) GT 0 THEN BEGIN
     ;;    STR_ELEMENT,alfDB_plot_struct,'calcVar_ENumFl', $
     ;;    BYTE(calcVar_ENumFl),/ADD_REPLACE
     ;; ENDIF
     
     ;; IF N_ELEMENTS(calcVar__sWay) GT 0 THEN BEGIN
     ;;    STR_ELEMENT,alfDB_plot_struct,'calcVar__sWay', $
     ;;                BYTE(calcVar__sWay),/ADD_REPLACE
     ;; ENDIF
     
     ;; IF N_ELEMENTS(calcVar_Pflux) GT 0 THEN BEGIN
     ;;    STR_ELEMENT,alfDB_plot_struct,'calcVar_Pflux', $
     ;;                BYTE(calcVar_Pflux),/ADD_REPLACE
     ;; ENDIF
     
     ;; IF N_ELEMENTS(calcVar_Iflux) GT 0 THEN BEGIN
     ;;    STR_ELEMENT,alfDB_plot_struct,'calcVar_Iflux', $
     ;;                BYTE(calcVar_Iflux),/ADD_REPLACE
     ;; ENDIF
     
     ;; IF N_ELEMENTS(calcVar_OxyFlux) GT 0 THEN BEGIN
     ;;    STR_ELEMENT,alfDB_plot_struct,'calcVar_OxyFlux', $
     ;;                BYTE(calcVar_OxyFlux),/ADD_REPLACE
     ;; ENDIF

     ;; IF N_ELEMENTS(calcVar_CharE) GT 0 THEN BEGIN
     ;;    STR_ELEMENT,alfDB_plot_struct,'calcVar_CharE', $
     ;;                BYTE(calcVar_CharE),/ADD_REPLACE
     ;; ENDIF
     
     ;; IF N_ELEMENTS(calcVar_Charie) GT 0 THEN BEGIN
     ;;    STR_ELEMENT,alfDB_plot_struct,'calcVar_Charie', $
     ;;                BYTE(calcVar_Charie),/ADD_REPLACE
     ;; ENDIF

     ;; IF N_ELEMENTS(calcVar_MagC) GT 0 THEN BEGIN
     ;;    STR_ELEMENT,alfDB_plot_struct,'calcVar_MagC', $
     ;;                BYTE(calcVar_MagC),/ADD_REPLACE
     ;; ENDIF

     ;; IF N_ELEMENTS(autoscale_fluxPlots) GT 0 THEN BEGIN
     ;;    STR_ELEMENT,alfDB_plot_struct,'autoscale_fluxPlots', $
     ;;                BYTE(autoscale_fluxPlots),/ADD_REPLACE
     ;; ENDIF

     IF N_ELEMENTS(fluxPlots__remove_outliers) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'fluxPlots__remove_outliers', $
                    BYTE(fluxPlots__remove_outliers),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(fluxPlots__remove_log_outliers) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'fluxPlots__remove_log_outliers', $
                    BYTE(fluxPlots__remove_log_outliers),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(fluxPlots__add_suspect_outliers) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'fluxPlots__add_suspect_outliers', $
                    BYTE(fluxPlots__add_suspect_outliers),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(fluxPlots__invert_Newell_the_cusp) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'fluxPlots__invert_Newell_the_cusp', $
                    BYTE(fluxPlots__invert_Newell_the_cusp),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(fluxPlots__Newell_the_cusp) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'fluxPlots__Newell_the_cusp', $
                    BYTE(fluxPlots__Newell_the_cusp),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(fluxPlots__broadband_everywhar) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'fluxPlots__broadband_everywhar', $
                    BYTE(fluxPlots__broadband_everywhar),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(fluxPlots__diffuse_everywhar) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'fluxPlots__diffuse_everywhar', $
                    BYTE(fluxPlots__diffuse_everywhar),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(do_timeAvg_fluxQuantities) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'do_timeAvg_fluxQuantities', $
                    BYTE(do_timeAvg_fluxQuantities),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(do_logAvg_the_timeAvg) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'do_logAvg_the_timeAvg', $
                    BYTE(do_logAvg_the_timeAvg),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(do_grossRate_fluxQuantities) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'do_grossRate_fluxQuantities', $
                    BYTE(do_grossRate_fluxQuantities),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(Newell_analyze_eFlux) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'Newell_analyze_eFlux', $
                    BYTE(Newell_analyze_eFlux),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(Newell__comb_accelerated) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'Newell__comb_accelerated', $
                    BYTE(Newell__comb_accelerated),/ADD_REPLACE
     ENDIF

     ;;**IONS**
     IF N_ELEMENTS(for_ion_DBs) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'for_ion_DBs', $
                    BYTE(for_ion_DBs),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(ion__noMap) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'ion__noMap', $
                    BYTE(ion__noMap),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(ion__no_maximus) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'ion__no_maximus', $
                    BYTE(ion__no_maximus),/ADD_REPLACE
        STR_ELEMENT,alfDB_plot_struct,'no_maximus', $
                    BYTE(ion__no_maximus),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(ion_flux_plots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'ion_flux_plots', $
                    BYTE(ion_flux_plots),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(ion__downgoing) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'ion__downgoing', $
                    BYTE(ion__downgoing),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(ion__junk_alfven_candidates) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'ion__junk_alfven_candidates', $
                    BYTE(ion__junk_alfven_candidates),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(ion__all_fluxes) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'ion__all_fluxes', $
                    BYTE(ion__all_fluxes),/ADD_REPLACE
     ENDIF

     ;;**ELECTRONS**
     IF N_ELEMENTS(for_eSpec_DBs) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'for_eSpec_DBs', $
                    BYTE(for_eSpec_DBs),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(eSpec__no_maximus) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eSpec__no_maximus', $
                    BYTE(eSpec__no_maximus),/ADD_REPLACE
        STR_ELEMENT,alfDB_plot_struct,'no_maximus', $
                    BYTE(eSpec__no_maximus),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(eSpec_flux_plots) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eSpec_flux_plots', $
                    BYTE(eSpec_flux_plots),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(eSpec__upgoing) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eSpec__upgoing', $
                    BYTE(eSpec__upgoing),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(eSpec__junk_alfven_candidates) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eSpec__junk_alfven_candidates', $
                    BYTE(eSpec__junk_alfven_candidates),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(eSpec__all_fluxes) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eSpec__all_fluxes', $
                    BYTE(eSpec__all_fluxes),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(eSpec__Newell_2009_interp) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eSpec__Newell_2009_interp', $
                    BYTE(eSpec__Newell_2009_interp),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(eSpec__use_2000km_file) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eSpec__use_2000km_file', $
                    BYTE(eSpec__use_2000km_file),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(eSpec__noMap) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eSpec__noMap', $
                    BYTE(eSpec__noMap),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(eSpec__remove_outliers) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eSpec__remove_outliers', $
                    BYTE(eSpec__remove_outliers),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(eSpec__newellPlot_probOccurrence) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'eSpec__newellPlot_probOccurrence', $
                    BYTE(eSpec__newellPlot_probOccurrence),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(t_probOccurrence) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'t_probOccurrence', $
                    BYTE(t_probOccurrence),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(for_sWay_DB) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'for_sWay_DB', $
                    BYTE(for_sWay_DB),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(sWay_use_8Hz_DB) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'sWay_use_8Hz_DB', $
                    sWay_use_8Hz_DB,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(sWay_maxMagFlag) GT 0 THEN BEGIN

        IF ~KEYWORD_SET(alfDB_plot_struct.sWay_use_8Hz_DB) THEN BEGIN
           PRINT,"Ummm, you can't do that. You need the 8-Hz DB."
           STOP
        ENDIF
        
        STR_ELEMENT,alfDB_plot_struct,'sWay_maxMagFlag', $
                    sWay_maxMagFlag,/ADD_REPLACE

     ENDIF

     IF N_ELEMENTS(sWay_plotType) GT 0 THEN BEGIN

        IF ((WHERE(STRUPCASE(sWay_plotType) EQ '*ACHIGH'))[0] NE -1) AND $
           ~alfDB_plot_struct.sWay_use_8Hz_DB                             $
        THEN BEGIN
           PRINT,"Ummm, you can't do that. You need the 8-Hz DB."
           STOP
        ENDIF

        STR_ELEMENT,alfDB_plot_struct,'sWay_plotType', $
                    sWay_plotType,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(orbContribPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'orbContribPlot', $
                    BYTE(orbContribPlot),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(orbTotPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'orbTotPlot', $
                    BYTE(orbTotPlot),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(orbFreqPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'orbFreqPlot', $
                    BYTE(orbFreqPlot),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(nEventPerOrbPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'nEventPerOrbPlot', $
                    BYTE(nEventPerOrbPlot),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(nEventPerMinPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'nEventPerMinPlot', $
                    BYTE(nEventPerMinPlot),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(nOrbsWithEventsPerContribOrbsPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'nOrbsWithEventsPerContribOrbsPlot', $
                    BYTE(nOrbsWithEventsPerContribOrbsPlot),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(probOccurrencePlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'probOccurrencePlot', $
                    BYTE(probOccurrencePlot),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(tHistDenominatorPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'tHistDenominatorPlot', $
                    BYTE(tHistDenominatorPlot),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(squarePlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'squarePlot', $
                    BYTE(squarePlot),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(polarContour) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'polarContour', $
                    BYTE(polarContour),/ADD_REPLACE
     ENDIF
     IF N_ELEMENTS(wholeCap) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'wholeCap', $
                    BYTE(wholeCap),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(medianPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'medianPlot', $
                    BYTE(medianPlot),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(maxPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'maxPlot', $
                    BYTE(maxPlot),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(minPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'minPlot', $
                    BYTE(minPlot),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(logAvgPlot) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'logAvgPlot', $
                    BYTE(logAvgPlot),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(plotMedOrAvg) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'plotMedOrAvg', $
                    BYTE(plotMedOrAvg),/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(dataDir) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'dataDir', $
                    dataDir,/ADD_REPLACE
     ENDIF
     IF N_ELEMENTS(no_burstData) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'no_burstData', $
                    BYTE(no_burstData),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(writeASCII) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'writeASCII', $
                    BYTE(writeASCII),/ADD_REPLACE
     ENDIF
     IF N_ELEMENTS(writeHDF5) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'writeHDF5', $
                    BYTE(writeHDF5),/ADD_REPLACE
     ENDIF
     IF N_ELEMENTS(writeProcessedH2D) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'writeProcessedH2D', $
                    BYTE(writeProcessedH2D),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(saveRaw) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'saveRaw', $
                    BYTE(saveRaw),/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(saveDir) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'saveDir', $
                    saveDir,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(justData) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'justData', $
                    justData,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(justInds) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'justInds', $
                    justInds,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(justInds_saveToFile) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'justInds_saveToFile', $
                    justInds_saveToFile,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(showPlotsNoSave) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'showPlotsNoSave', $
                    BYTE(showPlotsNoSave),/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(plotDir) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'plotDir', $
                    plotDir,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(medHistOutData) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'medHistOutData', $
                    medHistOutData,/ADD_REPLACE
     ENDIF
     IF KEYWORD_SET(medHistOutTxt) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'medHistOutTxt', $
                    medHistOutTxt,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(outputPlotSummary) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'outputPlotSummary', $
                    BYTE(outputPlotSummary),/ADD_REPLACE
     ENDIF
     IF N_ELEMENTS(del_PS) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'del_PS', $
                    BYTE(del_PS),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(keepMe) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'keepMe', $
                    BYTE(keepMe),/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(paramString) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'paramString', $
                    paramString,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(paramStrPrefix) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'paramStrPrefix', $
                    paramStrPrefix,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(paramStrSuffix) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'paramStrSuffix', $
                    paramStrSuffix,/ADD_REPLACE
     ENDIF

     IF alfDB_plot_struct.executing_multiples THEN BEGIN
        alfDB_plot_struct.multiString      = alfDB_plot_struct.paramString + alfDB_plot_struct.multiString
        alfDB_plot_struct.paramString      = alfDB_plot_struct.multiString
        ;; alfDB_plot_struct.paramString_list.Add,alfDB_plot_struct.paramString + '-' + multiples[0]
        FOR k=0,N_ELEMENTS(alfDB_plot_struct.multiples)-1 DO BEGIN
           alfDB_plot_struct.paramString_list.Add,alfDB_plot_struct.paramString + '-' + multiples[k]
        ENDFOR
     ENDIF ELSE BEGIN
        alfDB_plot_struct.paramString_list.Add,alfDB_plot_struct.paramString
     ENDELSE

     IF N_ELEMENTS(do_not_set_defaults) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'do_not_set_defaults', $
                    BYTE(do_not_set_defaults),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(plotH2D_contour) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'plotH2D_contour', $
                    BYTE(plotH2D_contour),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(contour__levels) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'contour__levels', $
                    contour__levels,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(contour__percent) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'contour__percent', $
                    BYTE(contour__percent),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(contour__nColors) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'contour__nColors', $
                    BYTE(contour__nColors),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(contour__CTIndex) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'contour__CTIndex', $
                    FIX(contour__CTIndex),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(contour__CTBottom) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'contour__CTBottom', $
                    FIX(contour__CTBottom),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(plotH2D__kernel_density_unmask) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'plotH2D__kernel_density_unmask', $
                    BYTE(plotH2D__kernel_density_unmask),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(show_integrals) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'show_integrals', $
                    show_integrals,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(custom_integral_struct) GT 0 THEN BEGIN

        tmpStruct = custom_integral_struct

        validTags = ['mltRange','ilatRange']
        IF SIZE(tmpStruct,/TYPE) NE 8 THEN BEGIN
           PRINT,"custom_integral struct needs to be, as you may have guessed, a struct. Try again."
           STOP
        ENDIF
        tmpTags = TAG_NAMES(tmpStruct)
        nTags   = N_ELEMENTS(tmpTags)

        stdFriends = SIZE(tmpStruct.(0),/DIMENSIONS)
        FOR k=0,nTags-1 DO BEGIN
           IF (WHERE(STRUPCASE(tmpTags[k]) EQ STRUPCASE(validTags)))[0] EQ -1 THEN BEGIN
              PRINT,"Invalid tag: ",tmpTags[k]
              STOP
           ENDIF

           nFriends = SIZE(tmpStruct.(k),/DIMENSIONS)
           IF ~ARRAY_EQUAL(stdFriends,nFriends) THEN BEGIN
              PRINT,"Unequal dimensions of friends in custom_integral_struct"
              STOP
           ENDIF
           
           IF nFriends[0] NE 2 THEN BEGIN
              PRINT,"Invalid dimensions; needs to be 2xN"
              STOP
           ENDIF

           IF N_ELEMENTS(nFriends) EQ 1 THEN nFriends = [nFriends,1]

           CASE N_ELEMENTS(nFriends) OF
              2: BEGIN
                 alfDB_plot_struct.nCustomIntegrals = 1
                 FOR kk=0,nFriends[1]-1 DO BEGIN
                    ;; PRINT,FORMAT='("custom_integral ",A0,": [",F0.2,",",F0.2,"]")', $
                    ;;       tmpTags[k],tmpStruct.(k)[0,kk],tmpStruct.(k)[1,kk]

                    IF (tmpStruct.(k))[0,kk] GT (tmpStruct.(k))[1,kk] THEN BEGIN
                       (tmpStruct.(k))[*,kk] = [(tmpStruct.(k))[1,kk],(tmpStruct.(k))[0,kk]]
                    ENDIF

                 ENDFOR
              END
              3: BEGIN                 
                 alfDB_plot_struct.nCustomIntegrals = nFriends[2]

                 FOR jj=0,nFriends[2]-1 DO BEGIN
                    FOR kk=0,nFriends[1]-1 DO BEGIN
                       ;; PRINT,FORMAT='("custom_integral ",A0,": [",F0.2,",",F0.2,"]")', $
                       ;;       tmpTags[k],tmpStruct.(k)[0,kk],tmpStruct.(k)[1,kk]

                       IF (tmpStruct.(k))[0,kk,jj] GT (tmpStruct.(k))[1,kk,jj] THEN BEGIN
                          (tmpStruct.(k))[*,kk,jj] = [(tmpStruct.(k))[1,kk,jj],(tmpStruct.(k))[0,kk,jj]]
                       ENDIF

                    ENDFOR
                 ENDFOR

              END
           ENDCASE


        ENDFOR

        ;;flip sign, if we have ilatRange
        ;; IF STRUPCASE(MIMC_struct.hemi) EQ "NORTH" AND    $
        IF TAG_EXIST(tmpStruct,'ilatRange') $
        THEN BEGIN

           tmpILATRange = tmpStruct.ilatRange
           nFriends = SIZE(tmpILATRange,/DIMENSIONS)
           IF N_ELEMENTS(nFriends) EQ 1 THEN nFriends = [nFriends,1]

           CASE N_ELEMENTS(nFriends) OF
              2: BEGIN

                 custSign = ABS(tmpILATRange[0,*])/tmpILATRange[0,*]
                 hemiSign = ABS(MIMC_struct.maxI)/MIMC_struct.maxI

                 FOR kk=0,nFriends[1]-1 DO BEGIN

                    IF tmpILATRange[0,kk] GT tmpILATRange[1,kk] THEN BEGIN
                       tmpILATRange[*,kk] = [tmpILATRange[1,kk],tmpILATRange[0,kk]]
                    ENDIF

                    IF custSign[kk] NE hemiSign $
                    THEN BEGIN
                       tmpILATRange[*,kk] = (-1.)*[tmpILATRange[1,kk],tmpILATRange[0,kk]]
                    ENDIF

                 ENDFOR

              END
              3: BEGIN

                 FOR jj=0,nFriends[2]-1 DO BEGIN
                    custSign = ABS(tmpILATRange[0,*,jj])/tmpILATRange[0,*,jj]
                    hemiSign = ABS(MIMC_struct.maxI)/MIMC_struct.maxI

                    FOR kk=0,nFriends[1]-1 DO BEGIN

                       IF tmpILATRange[0,kk,jj] GT tmpILATRange[1,kk,jj] THEN BEGIN
                          tmpILATRange[*,kk,jj] = [tmpILATRange[1,kk,jj],tmpILATRange[0,kk,jj]]
                       ENDIF

                       IF custSign[kk] NE hemiSign $
                       THEN BEGIN
                          tmpILATRange[*,kk,jj] = (-1.)*[tmpILATRange[1,kk,jj],tmpILATRange[0,kk,jj]]
                       ENDIF

                    ENDFOR

                 ENDFOR

              END
           ENDCASE

           STR_ELEMENT,tmpStruct,'ilatRange',tmpILATRange,/ADD_REPLACE
        ENDIF

        STR_ELEMENT,tmpStruct,"nFriends",nFriends[1],/ADD_REPLACE
        STR_ELEMENT,tmpStruct,"friend_i",0S,/ADD_REPLACE
        STR_ELEMENT,alfDB_plot_struct,"custom_integral",tmpStruct,/ADD_REPLACE

     ENDIF

     IF N_ELEMENTS(make_integral_txtfile) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'make_integral_txtfile', $
                    make_integral_txtfile,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(make_integral_savfiles) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'make_integral_savfiles', $
                    make_integral_savfiles,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(integralSavFilePref) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'integralSavFilePref', $
                    integralSavFilePref,/ADD_REPLACE
     ENDIF
   
     IF N_ELEMENTS(overplot_file) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'overplot_file', $
                    overplot_file,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(overplot_arr) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'overplot_arr', $
                    overplot_arr,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(op_contour__levels) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'op_contour__levels', $
                    op_contour__levels,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(op_contour__percent) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'op_contour__percent', $
                    BYTE(op_contour__percent),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(op_contour__nColors) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'op_contour__nColors', $
                    BYTE(op_contour__nColors),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(op_contour__CTIndex) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'op_contour__CTIndex', $
                    FIX(op_contour__CTIndex),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(op_contour__CTBottom) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'op_contour__CTBottom', $
                    FIX(op_contour__CTBottom),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(op_plotRange) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'op_plotRange', $
                    op_plotRange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(hoyDia) THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'hoyDia', $
                    hoyDia,/ADD_REPLACE
     ENDIF

     ;; IF KEYWORD_SET(var__each_bin) THEN BEGIN
     ;;    STR_ELEMENT,alfDB_plot_struct,'var__each_bin', $
     ;;                var__each_bin,/ADD_REPLACE
     ;; ENDIF

     ;; IF KEYWORD_SET(var__distType) THEN BEGIN



     ;;    STR_ELEMENT,alfDB_plot_struct,'var__distType', $
     ;;                var__distType,/ADD_REPLACE
     ;; ENDIF

     IF KEYWORD_SET(varOpt) THEN BEGIN

        diff = COMPARE_STRUCT(alfDB_plot_struct.varOpt, $
                              varOpt, $
                              EXCEPT=['bro'])

        tmpVarOpt = alfDB_plot_struct.varOpt
        FOREACH diffStr,diff DO BEGIN

           PRINT,diffStr.field

           fieldNavn = (STRSPLIT(diffStr.field,'.',/EXTRACT))[0]
           IF STRUPCASE(fieldNavn) EQ 'VAR__DISTTYPE' THEN BEGIN

              IF STRUPCASE(fieldNavn) NE 'NORM'    AND $
                 STRUPCASE(fieldNavn) NE 'LOGNORM' AND $
                 STRUPCASE(fieldNavn) NE '' $
              THEN BEGIN
                 PRINT,"Must use 'norm' or 'lognorm' for calculating variance! It's all I know!!"
                 STOP
              ENDIF

           ENDIF

           STR_ELEMENT,tmpVarOpt, $
                       fieldNavn, $
                       varOpt.(diffStr.tag_num_B), $
                       /ADD_REPLACE


        ENDFOREACH

        STR_ELEMENT,alfDB_plot_struct,'varOpt',TEMPORARY(tmpVarOpt),/ADD_REPLACE

        ;; STR_ELEMENT,alfDB_plot_struct,'varOpt', $
        ;;             varOpt,/ADD_REPLACE

     ENDIF

  ENDIF
END
