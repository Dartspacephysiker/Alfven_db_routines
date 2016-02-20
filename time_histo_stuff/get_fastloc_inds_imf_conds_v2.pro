;+
;2016/02/19 Completely redone.
;-
PRO GET_FASTLOC_INDS_IMF_CONDS_V2,fastLocInterped_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                  BYMIN=byMin, $
                                  BYMAX=byMax, $
                                  BZMIN=bzMin, $
                                  BZMAX=bzMax, $
                                  DO_ABS_BYMIN=abs_byMin, $
                                  DO_ABS_BYMAX=abs_byMax, $
                                  DO_ABS_BZMIN=abs_bzMin, $
                                  DO_ABS_BZMAX=abs_bzMax, $
                                  SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                  HEMI=hemi, $
                                  BOTH_HEMIS=both_hemis, $
                                  NORTH=north, $
                                  SOUTH=south, $
                                  DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                  HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                  MAKE_OUTINDSFILE=make_outIndsFile, $
                                  OUTINDSPREFIX=outIndsPrefix,OUTINDSSUFFIX=outIndsSuffix,OUTINDSFILEBASENAME=outIndsFileBasename, $
                                  ;; FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
                                  ;; FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, $
                                  FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                  BURSTDATA_EXCLUDED=burstData_excluded

  COMPILE_OPT idl2

  COMMON FL_VARS,FL_fastLoc,FASTLOC__times,FASTLOC__delta_t, $
     FASTLOC__good_i,FASTLOC__cleaned_i,FASTLOC__HAVE_GOOD_I, $
     FASTLOC__dbFile,FASTLOC__dbTimesFile

  IF NOT KEYWORD_SET(lun) THEN lun = -1 ;stdout
  
  SET_ALFVENDB_PLOT_DEFAULTS,ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                             MINMLT=minM,MAXMLT=maxM,BINMLT=binM,MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
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
                                    PARAMSTRING=paramString, $
                                    SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                    DELAY=delay, STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow,INCLUDENOCONSECDATA=includeNoConsecData, $
                                    LUN=lun

  fastLocInterped_i_list = GET_RESTRICTED_AND_INTERPED_DB_INDICES(fl_fastLoc,satellite,delay,LUN=lun, $
                                                                  DBTIMES=fastLoc__times,dbfile=fastloc__dbfile, HEMI=hemi, $
                                                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                                                  MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
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
                                                                  BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
                                                                  STABLEIMF=stableIMF, $
                                                                  OMNI_COORDS=omni_Coords, $
                                                                  ANGLELIM1=angleLim1, $
                                                                  ANGLELIM2=angleLim2, $
                                                                  HWMAUROVAL=HwMAurOval, $
                                                                  HWMKPIND=HwMKpInd, $
                                                                  NO_BURSTDATA=no_burstData, $
                                                                  GET_TIME_I_NOT_ALFVENDB_I=1)
  
  
  fastLocInterped_i = fastLocInterped_i_list[0]

END