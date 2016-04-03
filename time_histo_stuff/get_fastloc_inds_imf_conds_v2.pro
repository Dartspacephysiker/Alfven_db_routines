;+
;2016/02/19 Completely redone.
;-
PRO GET_FASTLOC_INDS_IMF_CONDS_V2,fastLocInterped_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                  DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                  BYMIN=byMin, $
                                  BYMAX=byMax, $
                                  BZMIN=bzMin, $
                                  BZMAX=bzMax, $
                                  DO_ABS_BYMIN=abs_byMin, $
                                  DO_ABS_BYMAX=abs_byMax, $
                                  DO_ABS_BZMIN=abs_bzMin, $
                                  DO_ABS_BZMAX=abs_bzMax, $
                                  MINMLT=minM,MAXMLT=maxM,BINM=binM,SHIFTM=shiftM, $
                                  MINILAT=minI,MAXILAT=maxI,BINI=binI,SHIFTI=shiftI, $
                                  DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                  SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                  HEMI=hemi, $
                                  BOTH_HEMIS=both_hemis, $
                                  NORTH=north, $
                                  SOUTH=south, $
                                  DELAY=delay, $
                                  MULTIPLE_DELAYS=multiple_delays, $
                                  STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                  HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                  MAKE_OUTINDSFILE=make_outIndsFile, $
                                  OUTINDSPREFIX=outIndsPrefix,OUTINDSSUFFIX=outIndsSuffix,OUTINDSFILEBASENAME=outIndsFileBasename, $
                                  ;; FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                  ;; FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, $
                                  FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                  BURSTDATA_EXCLUDED=burstData_excluded, $
                                  GET_FASTLOC_STRUCT=get_fastLoc_struct, $
                                  GET_FASTLOC_DELTA_T=get_fastLoc_delta_t, $
                                  GET_FASTLOC_TIMES=get_fastLoc_times, $
                                  OUT_FASTLOC_STRUCT=out_fastLoc_struct, $
                                  OUT_FASTLOC_DELTA_T=out_fastLoc_delta_t, $
                                  OUT_FASTLOC_TIMES=out_fastLoc_times

  COMPILE_OPT idl2

  COMMON FL_VARS,FL_fastLoc,FASTLOC__times,FASTLOC__delta_t, $
     FASTLOC__good_i,FASTLOC__cleaned_i,FASTLOC__HAVE_GOOD_I, $
     FASTLOC__dbFile,FASTLOC__dbTimesFile

  IF NOT KEYWORD_SET(lun) THEN lun = -1 ;stdout
  
  SET_ALFVENDB_PLOT_DEFAULTS,ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                             MINMLT=minM,MAXMLT=maxM,BINMLT=binM,SHIFTMLT=shiftM, $
                             MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $;SHIFTI=shiftI, $
                             DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                             MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                             HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                             MIN_NEVENTS=min_nEvents, MASKMIN=maskMin, $
                             HEMI=hemi, $
                             BOTH_HEMIS=both_hemis, $
                             NORTH=north, $
                             SOUTH=south, $
                             NPLOTS=nPlots, $
                             EPLOTS=ePlots, EFLUXPLOTTYPE=eFluxPlotType, $
                             ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, $
                             PPLOTS=pPlots, $
                             IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, $
                             CHAREPLOTS=charEPlots, CHARETYPE=charEType, $
                             ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
                             NEVENTPERORBPLOT=nEventPerOrbPlot, $
                             NEVENTPERMINPLOT=nEventPerMinPlot, $
                             PROBOCCURRENCEPLOT=probOccurrencePlot, $
                             SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
                             MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
                             DATADIR=dataDir, NO_BURSTDATA=no_burstData, $
                             WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
                             SAVERAW=saveRaw, RAWDIR=rawDir, $
                             SHOWPLOTSNOSAVE=showPlotsNoSave, $
                             PLOTDIR=plotDir, PLOTPREFIX=plotPrefix, PLOTSUFFIX=plotSuffix, $
                             MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                             OUTPUTPLOTSUMMARY=outputPlotSummary, DEL_PS=del_PS, $
                             KEEPME=keepMe, $
                             PARAMSTRING=paramString,PARAMSTRPREFIX=paramStrPrefix,PARAMSTRSUFFIX=paramStrSuffix,$
                             HOYDIA=hoyDia,LUN=lun,_EXTRA=e
  
  SET_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                  BYMIN=byMin, $
                                  BZMIN=bzMin, $
                                  BYMAX=byMax, $
                                  BZMAX=bzMax, $
                                  DO_ABS_BYMIN=abs_byMin, $
                                  DO_ABS_BYMAX=abs_byMax, $
                                  DO_ABS_BZMIN=abs_bzMin, $
                                  DO_ABS_BZMAX=abs_bzMax, $
                                  BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                  DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                  PARAMSTRING=paramString, $
                                  SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                  DELAY=delay, $
                                  MULTIPLE_DELAYS=multiple_delays, $
                                  STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow,INCLUDENOCONSECDATA=includeNoConsecData, $
                                  LUN=lun
  
  fastLocInterped_i_list = GET_RESTRICTED_AND_INTERPED_DB_INDICES(FL_fastLoc,satellite,delay,LUN=lun, $
                                                                  DBTIMES=fastLoc__times,dbfile=fastLoc__dbfile, HEMI=hemi, $
                                                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                                                  MINMLT=minM,MAXMLT=maxM,BINM=binM,SHIFTM=shiftM, $
                                                                  MINILAT=minI,MAXILAT=maxI,BINI=binI, $;SHIFTI=shiftI, $ $
                                                                  DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                                                  BYMIN=byMin, $
                                                                  BZMIN=bzMin, $
                                                                  BYMAX=byMax, $
                                                                  BZMAX=bzMax, $
                                                                  DO_ABS_BYMIN=abs_byMin, $
                                                                  DO_ABS_BYMAX=abs_byMax, $
                                                                  DO_ABS_BZMIN=abs_bzMin, $
                                                                  DO_ABS_BZMAX=abs_bzMax, $
                                                                  CLOCKSTR=clockStr, $
                                                                  DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                                                  BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
                                                                  STABLEIMF=stableIMF, $
                                                                  MULTIPLE_DELAYS=multiple_delays, $
                                                                  OMNI_COORDS=omni_Coords, $
                                                                  ANGLELIM1=angleLim1, $
                                                                  ANGLELIM2=angleLim2, $
                                                                  HWMAUROVAL=HwMAurOval, $
                                                                  HWMKPIND=HwMKpInd, $
                                                                  NO_BURSTDATA=no_burstData, $
                                                                  GET_TIME_I_NOT_ALFVENDB_I=1)
  
  
  IF KEYWORD_SET(get_fastLoc_struct) THEN BEGIN
     out_fastLoc_struct = FL_fastLoc
  ENDIF

  IF KEYWORD_SET(get_fastLoc_delta_t) THEN BEGIN
     out_fastLoc_delta_t   = FASTLOC__delta_t
  ENDIF

  IF KEYWORD_SET(get_fastLoc_times) THEN BEGIN
     out_fastLoc_times   = FASTLOC__times
  ENDIF

  IF KEYWORD_SET(multiple_delays) THEN BEGIN
     fastLocInterped_i = fastLocInterped_i_list
  ENDIF ELSE BEGIN
     fastLocInterped_i = fastLocInterped_i_list[0]
  ENDELSE

END