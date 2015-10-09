;+
;2015/04/09
;this can be used as a standalone routine or else called by plot_alfven_stats_imf_screening when
;making a plot of n events per minute
;-
PRO GET_FASTLOC_INDS_IMF_CONDS,fastLocInterped_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                               BYMIN=byMin, BYMAX=byMax, BZMIN=bzMin, BZMAX=bzMax, SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                               DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                               MAKE_OUTINDSFILE=make_outIndsFile, $
                               FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCDIR=fastLocOutputDir, $
                               BURSTDATA_EXCLUDED=burstData_excluded

  defOutIndsPrefix = 'fastLoc_intervals2'
  defOutIndsFileExt = ".sav" 

  IF NOT KEYWORD_SET(lun) THEN lun = -1 ;stdout

  ;;Load FASTLoc & Co.
  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastloc_times,DBDir=DBDir,DBFile=DBFile,DB_tFile=DB_tFile,LUN=lun
  
  ;;********************************************
  ;;Build output filename based on stuff provided
  ;;Should include clockStr, angleLim1,angleLim2, satellite, omnicoords, bymin, stableimf, delay, smoothwindow
  basenameFormat = '(A0,"--",A0,"_",F0.2,"-",F0.2,"deg--",A0,"_",A0,"--byMin_",F0.1,"--byMax_",F0.1,"--bzMin_",F0.1,"--bzMax_",F0.1' + $
                   '"--stableIMF_",I0,"min--delay_",I0,"--smoothWindow_",I0,"min")'
  outIndsFileBasename = STRING(FORMAT=basenameFormat,defOutIndsPrefix,clockStr,angleLim1,angleLim2,satellite,omni_Coords, $
                               byMin,byMax,bzMin,bzMax,stableIMF,delay,smoothWindow)

  IF KEYWORD_SET(burstData_excluded) THEN outIndsFileBasename += "_burstData_excluded"

  outIndsFilename = fastLocOutputDir+outIndsFileBasename+defOutIndsFileExt
  ;;********************************************
  ;;If this file already exists, see if it will work for us!
  IF FILE_TEST(outIndsFilename) THEN BEGIN 
     PRINT,"Restoring " + outIndsFilename + "..."
     RESTORE,outIndsFilename
  ENDIF ELSE BEGIN

     
     ;;Now get the appropriate indices
     phiFastLoc = interp_mag_data_for_fastloc(satellite,SATDBDIR=satDBDir,OMNI_COORDS=omni_Coords,DELAY=delay, $
                                              FASTLOC_TIMES=fastLoc_Times,FASTLOCINTERP_I=fastLocInterp_i,SATDBINTERP_I=SATdbInterp_i, $
                                              MAG_UTC=mag_utc, PHICLOCK=phiClock,SMOOTHWINDOW=smoothWindow, $
                                              BYMIN=byMin, BZMIN=bzMin, $
                                              LUN=lun)
     phiImf_ii = check_imf_stability_for_fastloc(clockStr,angleLim1,angleLim2,phiFastLoc,SATdbInterp_i,stableIMF,mag_utc,phiClock,$
                                                 bx_over_bybz=Bx_over_ByBz_Lim,LUN=lun)  
     
     fastLocInterped_i=fastLocInterp_i(phiImf_ii)
     
     IF KEYWORD_SET(make_outIndsFile) THEN BEGIN
        PRINT,'Saving outindsfile ' + outIndsFilename + '...'
        save,fastLocInterped_i,clockStr,angleLim1,angleLim2,smoothWindow,byMin,bzMin, $
             delay,satdbdir,omni_coords,fastLocOutputDir,fastLocFile,fastLocTimeFile, $
             filename=outIndsFilename
     ENDIF
  ENDELSE

  RETURN

END