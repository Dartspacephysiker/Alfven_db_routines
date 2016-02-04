;+
;2015/10/21 Now using output from fastloc_intervals3, which includes magnetometer sampling rates
;2015/04/09
;this can be used as a standalone routine or else called by plot_alfven_stats_imf_screening when
;making a plot of n events per minute
;2016/01/01 Added NORTH, SOUTH, and BOTH_HEMIS keywords.
;2016/01/23 Added DO_ABS_BZM{IN,AX} keywords
;-
PRO GET_FASTLOC_INDS_IMF_CONDS,fastLocInterped_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
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
                               FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
                               FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir, $
                               BURSTDATA_EXCLUDED=burstData_excluded

  COMPILE_OPT idl2

  ;; minM=0
  ;; maxM=24
  ;; minI=-88
  ;; maxI=88

  ;; fastLocOutputDir = '/SPENCEdata/Research/Cusp/database/FAST_ephemeris/fastLoc_intervals3/'
  fastLocOutputDir = '/SPENCEdata/Research/Cusp/database/FAST_ephemeris/fastLoc_intervals4/'

  IF NOT KEYWORD_SET(lun) THEN lun = -1 ;stdout
  
  ;;Load FASTLoc & Co.
  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastloc_times,fastloc_delta_t,DBDir=DBDir,DBFile=FastLocFile,DB_tFile=FastLocTimeFile,LUN=lun
  
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

  ;; defOutIndsPrefix = 'fastLoc_intervals3'
  defOutIndsPrefix = 'fastLoc_intervals4'
  IF KEYWORD_SET(outIndsPrefix) THEN outIndsPrefix = defOutIndsPrefix + outIndsPrefix ELSE outIndsPrefix = defOutIndsPrefix
  IF ~KEYWORD_SET(outIndsSuffix) THEN outIndsSuffix = ''
  ;;********************************************
  ;;Build output filename based on stuff provided
  ;;Should include clockStr, angleLim1,angleLim2, satellite, omnicoords, bymin, stableimf, delay, smoothwindow
  basenameFormat = '(A0,"--",A0,"_",F0.2,"-",F0.2,"deg--",A0,"_",A0,' + $
                   ;;'"--byMin_",F0.1,"--byMax_",F0.1,"--bzMin_",F0.1,"--bzMax_",F0.1,' + $
                   '"--hemi_",A0,' + $
                   '"--chareRange_",F0.2,"-",F0.2,"--altRange_",F0.2,"-",F0.2,"--orbRange",I0,"-",I0,' + $
                   '"--stableIMF_",I0,"min--delay_",I0,"sec")'
  outIndsFileBasename = STRING(FORMAT=basenameFormat,outIndsPrefix,clockStr,angleLim1,angleLim2,satellite,omni_Coords, $
                               ;;byMin,byMax,bzMin,bzMax, $
                               hemi, $
                               charerange[0],charerange[1],altitudeRange[0],altitudeRange[1],orbRange[0],orbRange[1], $
                               stableIMF,delay)

  ;;Requirement for IMF By magnitude?
  byMinStr=''
  byMaxStr=''

  IF KEYWORD_SET(byMin) THEN BEGIN
     byMinStr='byMin_' + String(byMin,format='(D0.1)') + '_' ;STRCOMPRESS(byMin,/REMOVE_ALL)
  ENDIF
  IF KEYWORD_SET(byMax) THEN BEGIN
     byMaxStr='byMax_' + String(byMax,format='(D0.1)') + '_' ;STRCOMPRESS(byMax,/REMOVE_ALL)
  ENDIF

  ;;Requirement for IMF Bz magnitude?
  bzMinStr=''
  bzMaxStr=''

  IF KEYWORD_SET(bzMin) THEN BEGIN
     bzMinStr='bzMin_' + String(bzMin,format='(D0.1)') + '_' 
  ENDIF
  IF KEYWORD_SET(bzMax) THEN BEGIN
     bzMaxStr='bzMax_' + String(bzMax,format='(D0.1)') + '_'
  ENDIF

  IF KEYWORD_SET(smoothWindow) THEN smoothStr = strtrim(smoothWindow,2)+"min_IMFsmooth--" ELSE smoothStr=""

  IF KEYWORD_SET(burstData_excluded) THEN outIndsFileBasename += "_burstData_excluded"

  outIndsFilename = fastLocOutputDir+outIndsFileBasename+byMinStr+byMaxStr+bzMinStr+bzMaxStr+smoothStr+'.sav'
  ;;********************************************
  ;;If this file already exists, see if it will work for us!
  ;; IF FILE_TEST(outIndsFilename) THEN BEGIN 
  ;;    PRINT,"Restoring " + outIndsFilename + "..."
  ;;    RESTORE,outIndsFilename
  ;; ENDIF ELSE BEGIN
     fastLocInterped_i = GET_RESTRICTED_AND_INTERPED_DB_INDICES(fastLoc,satellite,delay,LUN=lun, $
                         DBTIMES=fastLoc_times,dbfile=dbfile, HEMI=hemi, $
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
                         STABLEIMF=stableIMF,OMNI_COORDS=omni_Coords,ANGLELIM1=angleLim1,ANGLELIM2=angleLim2, $
                         HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd,NO_BURSTDATA=no_burstData,GET_TIME_I_NOT_ALFVENDB_I=1)
     
     IF KEYWORD_SET(make_outIndsFile) THEN BEGIN
        PRINT,'Saving outindsfile ' + outIndsFilename + '...'
        save,fastLocInterped_i,clockStr,angleLim1,angleLim2,smoothWindow,byMin,byMax,bzMin,bzMax, $
             minm,maxm,binm,mini,maxi,bini,minl,maxl,binl, $
             altituderange,charerange,orbrange, $
             delay,satdbdir,omni_coords,fastLocOutputDir,fastLocFile,fastLocTimeFile, $
             filename=outIndsFilename
     ENDIF
  ;; ENDELSE

END