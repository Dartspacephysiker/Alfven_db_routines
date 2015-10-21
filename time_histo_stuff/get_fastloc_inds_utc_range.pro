;+
;2015/10/21 Now using output from fastloc_intervals3, which includes magnetometer sampling rates
;2015/04/09
;this can be used as a standalone routine or else called by plot_alfven_stats_imf_screening when
;making a plot of n events per minute
;-
PRO GET_FASTLOC_INDS_UTC_RANGE,fastLocInterped_i,T1_ARR=t1_arr,T2_ARR=t2_arr, $
                               ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                               HEMI=hemi, $
                               HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                               MAKE_OUTINDSFILE=make_outIndsFile,OUTINDSFILEBASENAME=outIndsFileBasename, $
                               FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
                               FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir

  COMPILE_OPT idl2

  minM=0
  maxM=24
  minI=-88
  maxI=88

  fastLocOutputDir = '/SPENCEdata/Research/Cusp/database/time_histos/'

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

  SET_UTCPLOT_PARAMS_AND_IND_DEFAULTS,ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                      PARAMSTRING=paramString, $
                                      LUN=lun

  defOutIndsPrefix = 'fastLoc_intervals3'

  ;;********************************************
  ;;Build output filename based on stuff provided
  ;;Should include clockStr, angleLim1,angleLim2, satellite, omnicoords, bymin, stableimf, delay, smoothwindow
  basenameFormat = '(A0,"--hemi_",A0,' + $
                   '"--chareRange_",F0.2,"-",F0.2,"--altRange_",F0.2,"-",F0.2,"--orbRange",I0,"-",I0)'
  outIndsFileBasename = STRING(FORMAT=basenameFormat,defOutIndsPrefix,hemi, $
                               charerange[0],charerange[1],altitudeRange[0],altitudeRange[1],orbRange[0],orbRange[1])

  outIndsFilename = fastLocOutputDir+outIndsFileBasename+'.sav'
  ;;********************************************
  ;;If this file already exists, see if it will work for us!
  ;; IF FILE_TEST(outIndsFilename) THEN BEGIN 
  ;;    PRINT,"Restoring " + outIndsFilename + "..."
  ;;    RESTORE,outIndsFilename
  ;; ENDIF ELSE BEGIN
  
  good_i = get_chaston_ind(fastLoc,satellite,lun,GET_TIME_I_NOT_ALFVENDB_I=1, $
                           DBTIMES=fastLoc_times,DBFILE=FastLocFile, HEMI=hemi, $
                           ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange,POYNTRANGE=poyntRange, $
                           MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                           DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                           HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd)
  
  GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES,T1_ARR=t1_arr,T2_ARR=t2_arr, $
     DBSTRUCT=fastLoc,DBTIMES=fastLoc_times, RESTRICT_W_THESEINDS=good_i, $
     OUT_INDS_LIST=fastLocInterped_i,/LIST_TO_ARR, $
     UNIQ_ORBS_LIST=uniq_orbs_list,UNIQ_ORB_INDS_LIST=uniq_orb_inds_list, $
     INDS_ORBS_LIST=inds_orbs_list,TRANGES_ORBS_LIST=tranges_orbs_list,TSPANS_ORBS_LIST=tspans_orbs_list, $
     PRINT_DATA_AVAILABILITY=print_data_availability,VERBOSE=1
  
  IF KEYWORD_SET(make_outIndsFile) THEN BEGIN
     PRINT,'Saving outindsfile ' + outIndsFilename + '...'
     save,fastLocInterped_i,minm,maxm,binm,mini,maxi,bini,minl,maxl,binl, $
          altituderange,charerange,orbrange, $
          fastLocOutputDir,fastLocFile,fastLocTimeFile, $
          filename=outIndsFilename
  ENDIF

END