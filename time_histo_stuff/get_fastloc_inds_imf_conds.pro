;+
;2015/04/09
;this can be used as a standalone routine or else called by plot_alfven_stats_imf_screening when
;making a plot of n events per minute
;-
PRO GET_FASTLOC_INDS_IMF_CONDS,fastLocInterped_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                               ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                               BYMIN=byMin, BYMAX=byMax, BZMIN=bzMin, BZMAX=bzMax, SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                               HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                               HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                               MAKE_OUTINDSFILE=make_outIndsFile, $
                               FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCDIR=fastLocOutputDir, $
                               BURSTDATA_EXCLUDED=burstData_excluded

  IF NOT KEYWORD_SET(lun) THEN lun = -1 ;stdout
  
  ;;Load FASTLoc & Co.
  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastloc_times,DBDir=DBDir,DBFile=DBFile,DB_tFile=DB_tFile,LUN=lun
  
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
                   '"--byMin_",F0.1,"--byMax_",F0.1,"--bzMin_",F0.1,"--bzMax_",F0.1,' + $
                   '"--hemi_",A0,' + $
                   '"--chareRange_",F0.2,"-",F0.2,"--altRange_",F0.2,"-",F0.2,"--orbRange",I0,"-",I0,' + $
                   '"--stableIMF_",I0,"min--delay_",I0,"--smoothWindow_",I0,"min")'
  outIndsFileBasename = STRING(FORMAT=basenameFormat,defOutIndsPrefix,clockStr,angleLim1,angleLim2,satellite,omni_Coords, $
                               byMin,byMax,bzMin,bzMax, $
                               hemi, $
                               charerange[0],charerange[1],altitudeRange[0],altitudeRange[1],orbRange[0],orbRange[1], $
                               stableIMF,delay,smoothWindow)

  IF KEYWORD_SET(burstData_excluded) THEN outIndsFileBasename += "_burstData_excluded"

  outIndsFilename = fastLocOutputDir+outIndsFileBasename+'.sav'
  ;;********************************************
  ;;If this file already exists, see if it will work for us!
  IF FILE_TEST(outIndsFilename) THEN BEGIN 
     PRINT,"Restoring " + outIndsFilename + "..."
     RESTORE,outIndsFilename
  ENDIF ELSE BEGIN
     GET_RESTRICTED_AND_INTERPED_DB_INDICES,fastLoc,satellite,delay,LUN=lun, $
                                            DBTIMES=fastLoc_times,dbfile=dbfile, HEMI=hemi, $
                                            ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                            MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                            BYMIN=byMin,BZMIN=bzMin,BYMAX=byMax,BZMAX=bzMax,CLOCKSTR=clockStr,BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
                                            STABLEIMF=stableIMF,OMNI_COORDS=omni_Coords,ANGLELIM1=angleLim1,ANGLELIM2=angleLim2, $
                                            HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd,NO_BURSTDATA=no_burstData

     fastLocInterped_i=fastLocInterp_i[phiImf_ii]
     
     IF KEYWORD_SET(make_outIndsFile) THEN BEGIN
        PRINT,'Saving outindsfile ' + outIndsFilename + '...'
        save,fastLocInterped_i,clockStr,angleLim1,angleLim2,smoothWindow,byMin,byMax,bzMin,bzMax, $
             minm,maxm,binm,mini,maxi,bini, $
             altituderange,charerange,orbrange, $
             delay,satdbdir,omni_coords,fastLocOutputDir,fastLocFile,fastLocTimeFile, $
             filename=outIndsFilename
     ENDIF
  ENDELSE

  STOP

END