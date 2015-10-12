;+
;2015/04/09
;this can be used as a standalone routine or else called by plot_alfven_stats_imf_screening when
;making a plot of n events per minute
;-o
PRO GET_FASTLOC_INDS_IMF_CONDS,fastLocInterped_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                               ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                               BYMIN=byMin, BYMAX=byMax, BZMIN=bzMin, BZMAX=bzMax, SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                               HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                               HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                               MAKE_OUTINDSFILE=make_outIndsFile,OUTINDSFILEBASENAME=outIndsFileBasename, $
                               FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
                               FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir, $
                               BURSTDATA_EXCLUDED=burstData_excluded

  COMPILE_OPT idl2

  minM=0
  maxM=24
  minI=-88
  maxI=88

  fastLocOutputDir = '/SPENCEdata/Research/Cusp/database/time_histos/'

  IF NOT KEYWORD_SET(lun) THEN lun = -1 ;stdout
  
  ;;Load FASTLoc & Co.
  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastloc_times,fastloc_delta_t,DBDir=DBDir,DBFile=FastLocFile,DB_tFile=FastLocTimeFile,LUN=lun
  
  SET_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                  minMLT=minM,maxMLT=maxM,BINMLT=binM,MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                                  HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                  BYMIN=byMin, BZMIN=bzMin, BYMAX=byMax, BZMAX=bzMax, BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                  PARAMSTRING=paramStr, PARAMSTRPREFIX=plotPrefix,PARAMSTRSUFFIX=plotSuffix,$
                                  SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                  HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow,INCLUDENOCONSECDATA=includeNoConsecData, $
                                  HOYDIA=hoyDia,LUN=lun  

  defOutIndsPrefix = 'fastLoc_intervals2'

  ;;********************************************
  ;;Build output filename based on stuff provided
  ;;Should include clockStr, angleLim1,angleLim2, satellite, omnicoords, bymin, stableimf, delay, smoothwindow
  basenameFormat = '(A0,"--",A0,"_",F0.2,"-",F0.2,"deg--",A0,"_",A0,' + $
                   ;;'"--byMin_",F0.1,"--byMax_",F0.1,"--bzMin_",F0.1,"--bzMax_",F0.1,' + $
                   '"--hemi_",A0,' + $
                   '"--chareRange_",F0.2,"-",F0.2,"--altRange_",F0.2,"-",F0.2,"--orbRange",I0,"-",I0,' + $
                   '"--stableIMF_",I0,"min--delay_",I0,"sec")'
  outIndsFileBasename = STRING(FORMAT=basenameFormat,defOutIndsPrefix,clockStr,angleLim1,angleLim2,satellite,omni_Coords, $
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
  IF FILE_TEST(outIndsFilename) THEN BEGIN 
     PRINT,"Restoring " + outIndsFilename + "..."
     RESTORE,outIndsFilename
  ENDIF ELSE BEGIN
     fastLocInterped_i = GET_RESTRICTED_AND_INTERPED_DB_INDICES(fastLoc,satellite,delay,LUN=lun, $
                         DBTIMES=fastLoc_times,dbfile=dbfile, HEMI=hemi, $
                         ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                         MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                         BYMIN=byMin,BZMIN=bzMin,BYMAX=byMax,BZMAX=bzMax,CLOCKSTR=clockStr,BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
                         STABLEIMF=stableIMF,OMNI_COORDS=omni_Coords,ANGLELIM1=angleLim1,ANGLELIM2=angleLim2, $
                         HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd,NO_BURSTDATA=no_burstData,GET_TIME_I_NOT_ALFVENDB_I=1)
     
     IF KEYWORD_SET(make_outIndsFile) THEN BEGIN
        PRINT,'Saving outindsfile ' + outIndsFilename + '...'
        save,fastLocInterped_i,clockStr,angleLim1,angleLim2,smoothWindow,byMin,byMax,bzMin,bzMax, $
             minm,maxm,binm,mini,maxi,bini, $
             altituderange,charerange,orbrange, $
             delay,satdbdir,omni_coords,fastLocOutputDir,fastLocFile,fastLocTimeFile, $
             filename=outIndsFilename
     ENDIF
  ENDELSE

END