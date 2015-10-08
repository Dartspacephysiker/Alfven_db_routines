;+
;2015/04/09
;this can be used as a standalone routine or else called by plot_alfven_stats_imf_screening when
;making a plot of n events per minute
;-
PRO GET_FASTLOC_INDS_IMF_CONDS,fastLocInterped_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                               BYMIN=byMin, BZMIN=bzMin, SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                               DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                               MAKE_OUTINDSFILE=make_outIndsFile, $
                               FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCDIR=fastLocOutputDir, $
                               BURSTDATA_EXCLUDED=burstData_excluded

  PRINT,"This is not updated at all relative to get_inds_from_db.pro or get_chaston_inds.pro. You'd better be awfully careful."
  STOP

  defClockStr = 'duskward'

  
;                    CLOCKSTR          :  Interplanetary magnetic field clock angle.
;                                            Can be 'dawnward', 'duskward', 'bzNorth', 'bzSouth', 'all_IMF',
;                                            'dawn-north', 'dawn-south', 'dusk-north', or 'dusk-south'.

  
  defSatellite = "OMNI"    ;either "ACE", "wind", "wind_ACE", or "OMNI" (default, you see)
  defOmni_Coords = "GSM"             ; either "GSE" or "GSM"

  defDelay = 660

  defByMin = 5
  defBzMin = 0
  defBx_over_ByBz_Lim = 0       ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)
  defstableIMF = 1S             ;Set to a time (in minutes) over which IMF stability is required
  defSmoothWindow = 5           ;Set to a time over which to smooth IMF
  defIncludeNoConsecData = 0    ;Setting this to 1 includes Chaston data for which  
                                ;there's no way to calculate IMF stability
                                ;Only valid for stableIMF GE 1
  defCheckBothWays = 0          
  
  defAngleLim1 = 45.0
  defAngleLim2 = 135.0

  defFastLocOutputDir = '/SPENCEdata/Research/Cusp/database/time_histos/'
  defFastLocFile = 'fastLoc_intervals2--500-16361_all--20150613.sav'
  defFastLocTimeFile = 'fastLoc_intervals2--500-16361_all--20150613--times.sav'

  defLun = -1 ;stdout
  defOutIndsPrefix = 'fastLoc_intervals2'
  defOutIndsFileExt = ".sav" 

  ;;********************************************
  ;;satellite data options
  IF NOT KEYWORD_SET(clockStr) THEN clockStr = defClockStr

  IF NOT KEYWORD_SET(satellite) THEN satellite = defSatellite          ;either "ACE", "wind", "wind_ACE", or "OMNI" (default, you see)
  IF NOT KEYWORD_SET(omni_Coords) THEN omni_Coords = defOmni_Coords    ; either "GSE" or "GSM"

  IF delay EQ !NULL THEN delay = defDelay                      ;Delay between ACE propagated data and ChastonDB data
                                                                       ;Bin recommends something like 11min
  
  IF stableIMF EQ !NULL THEN stableIMF = defStableIMF                    ;Set to a time (in minutes) over which IMF stability is required
  IF includeNoConsecData EQ !NULL THEN includeNoConsecData = defIncludeNoConsecData ;Setting this to 1 includes Chaston data for which  
                                                                       ;there's no way to calculate IMF stability
                                                                       ;Only valid for stableIMF GE 1
  IF NOT KEYWORD_SET(checkBothWays) THEN checkBothWays = defCheckBothWays       ;
  
  IF NOT KEYWORD_SET(Bx_over_ByBz_Lim) THEN Bx_over_ByBz_Lim = defBx_over_ByBz_Lim       ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)
  
  IF NOT KEYWORD_SET(lun) THEN lun = defLun

  IF N_ELEMENTS(byMin) EQ 0 THEN byMin = defByMin

  IF N_ELEMENTS(bzMin) EQ 0 THEN bzMin = defBzMin

  IF NOT KEYWORD_SET(smoothWindow) THEN smoothWindow = defSmoothWindow  ;in Min

  IF NOT KEYWORD_SET(fastLocOutputDir) THEN fastLocOutputDir = defFastLocOutputDir
  IF NOT KEYWORD_SET(fastLocFile) THEN fastLocFile = defFastLocFile
  IF NOT KEYWORD_SET(fastLocTimeFile) THEN fastLocTimeFile = defFastLocTimeFile


  IF ~KEYWORD_SET(angleLim1) THEN BEGIN
     IF clockStr NE "all_IMF" THEN BEGIN
        angleLim1=defAngleLim1  ;in degrees
     ENDIF ELSE angleLim1=180.0 ;for doing all IMF
  ENDIF

  IF ~KEYWORD_SET(angleLim2) THEN BEGIN
     IF clockStr NE "all_IMF" THEN BEGIN
        angleLim2=defAngleLim2  ;in degrees
     ENDIF ELSE angleLim2=180.0 ;for doing all IMF
  ENDIF 

  ;;********************************************
  ;;Build output filename based on stuff provided
  ;;Should include clockStr, angleLim1,angleLim2, satellite, omnicoords, bymin, stableimf, delay, smoothwindow
  basenameFormat = '(A0,"--",A0,"_",F0.2,"-",F0.2,"deg--",A0,"_",A0,"--byMin_",F0.1,"--bzMin_",F0.1,' + $
                   '"--stableIMF_",I0,"min--delay_",I0,"--smoothWindow_",I0,"min")'
  outIndsFileBasename = STRING(FORMAT=basenameFormat,defOutIndsPrefix,clockStr,angleLim1,angleLim2,satellite,omni_Coords, $
                               byMin,bzMin,stableIMF,delay,smoothWindow)

  IF KEYWORD_SET(burstData_excluded) THEN outIndsFileBasename += "_burstData_excluded"

  outIndsFilename = fastLocOutputDir+outIndsFileBasename+defOutIndsFileExt
  ;;********************************************
  ;;If this file already exists, see if it will work for us!
  IF FILE_TEST(outIndsFilename) THEN BEGIN 
     ;; desiredAngleLim1 = angleLim1
     ;; desiredAngleLim2 = angleLim2
     PRINT,"Restoring " + outIndsFilename + "..."
     RESTORE,outIndsFilename
     ;now, if the restored angleLims match the desired ones, we're in business!
     ;; IF desiredAngleLim1 NE angleLim1 OR desiredAngleLim2 NE angleLim2 THEN BEGIN
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