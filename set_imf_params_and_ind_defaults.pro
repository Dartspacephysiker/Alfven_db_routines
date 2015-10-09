PRO SET_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                    ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, NUMORBLIM=numOrbLim, $
                                    minMLT=minMLT,maxMLT=maxMLT,BINMLT=binMLT,MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                                    MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                                    HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                    BYMIN=byMin, BZMIN=bzMin, BYMAX=byMax, BZMAX=bzMax,BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                    PARAMSTRING=paramString, PARAMSTRPREFIX=paramStrPrefix,PARAMSTRSUFFIX=paramStrSuffix,$
                                    SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                    HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow,INCLUDENOCONSECDATA=includeNoConsecData, $
                                    LUN=lun

  COMPILE_OPT idl2
  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout
  ;;***********************************************
  ;;Tons of defaults
  
  defCharERange = [4.0,300]
  defAltRange = [1000.0, 5000.0]

  ; satellite defaults
  defSatellite = "OMNI"    ;either "ACE", "wind", "wind_ACE", or "OMNI" (default, you see)
  defOmni_Coords = "GSM"             ; either "GSE" or "GSM"

  defDelay = 900

  defstableIMF = 0S             ;Set to a time (in minutes) over which IMF stability is required
  defIncludeNoConsecData = 0    ;Setting this to 1 includes Chaston data for which  
                                ;there's no way to calculate IMF stability
                                ;Only valid for stableIMF GE 1
  defCheckBothWays = 0          
  
  defBx_over_ByBz_Lim = 0       ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)
  
  ;for statistical auroral oval
  defHwMAurOval=0
  defHwMKpInd=7

  defClockStr = 'dawnward'
  
  defAngleLim1 = 60.0
  defAngleLim2 = 120.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Now set up vars

  ; Handle MLT and ILAT
  SET_DEFAULT_MLT_ILAT_AND_MAGC,MINMLT=minMLT,MAXMLT=maxMLT,BINM=binMLT, $
                                MINILAT=minILAT,MAXILAT=maxILAT,BINI=binILAT, $
                                MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                                HEMI=hemi,LUN=lun

  ;;***********************************************
  ;;RESTRICTIONS ON DATA, SOME VARIABLES
  IF N_ELEMENTS(charERange) EQ 0 THEN charERange = defCharERange         ; 4,~300 eV in Strangeway

  IF N_ELEMENTS(altitudeRange) EQ 0 THEN altitudeRange = defAltRange ;Rob Pfaff says no lower than 1000m
  
  ;Auroral oval
  IF N_ELEMENTS(HwMAurOval) EQ 0 THEN HwMAurOval = defHwMAurOval
  IF N_ELEMENTS(HwMKpInd) EQ 0 THEN HwMKpInd = defHwMKpInd

  ;;********************************************
  ;;satellite data options
  
  IF N_ELEMENTS(satellite) EQ 0 THEN satellite = defSatellite          ;either "ACE", "wind", "wind_ACE", or "OMNI" (default, you see)
  IF N_ELEMENTS(omni_Coords) EQ 0 THEN omni_Coords = defOmni_Coords    ; either "GSE" or "GSM"

  IF N_ELEMENTS(delay) EQ 0 THEN delay = defDelay                      ;Delay between ACE propagated data and ChastonDB data
                                                                       ;Bin recommends something like 11min
  
  IF N_ELEMENTS(stableIMF) EQ 0 THEN stableIMF = defStableIMF                    ;Set to a time (in minutes) over which IMF stability is required
  IF N_ELEMENTS(includeNoConsecData) EQ 0 THEN defIncludeNoConsecData = 0 ;Setting this to 1 includes Chaston data for which  
                                                                       ;there's no way to calculate IMF stability
                                                                       ;Only valid for stableIMF GE 1
  IF N_ELEMENTS(checkBothWays) EQ 0 THEN checkBothWays = defCheckBothWays       ;
  
  IF N_ELEMENTS(Bx_over_ByBz_Lim) EQ 0 THEN Bx_over_ByBz_Lim = defBx_over_ByBz_Lim       ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)
  
  ;;Which IMF clock angle are we doing?
  ;;options are 'duskward', 'dawnward', 'bzNorth', 'bzSouth', and 'all_IMF'
  IF N_ELEMENTS(clockStr) EQ 0 THEN clockStr = defClockStr

  ;;How to set angles? Note, clock angle is measured with
  ;;Bz North at zero deg, ranging from -180<clock_angle<180
  ;;Setting angle limits 45 and 135, for example, gives a 90-deg
  ;;window for dawnward and duskward plots
  IF clockStr NE "all_IMF" THEN BEGIN
     angleLim1=defAngleLim1               ;in degrees
     angleLim2=defAngleLim2              ;in degrees
  ENDIF ELSE BEGIN 
     angleLim1=180.0              ;for doing all IMF
     angleLim2=180.0 
  ENDELSE

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


  ;Aujour d'hui
  hoyDia= STRCOMPRESS(STRMID(SYSTIME(0), 4, 3),/REMOVE_ALL) + "_" + $
          STRCOMPRESS(STRMID(SYSTIME(0), 8,2),/REMOVE_ALL) + "_" + STRCOMPRESS(STRMID(SYSTIME(0), 22, 2),/REMOVE_ALL)

  ;;********************************************
  ;;Set up some other strings
  IF minILAT GT 0 THEN hemStr='North' ELSE IF maxILAT LT 0 THEN hemStr='South' $
  ELSE BEGIN 
     printf,lun,"Which hemisphere?" & hemStr = '??'
  ENDELSE
  
  ;;satellite string
  omniStr = ""
  IF satellite EQ "OMNI" then omniStr = "_" + omni_Coords 
  ;;IF delay NE defDelay THEN delayStr = strcompress(delay/60,/remove_all) + "mindelay_" ELSE delayStr = ""
  IF delay GT 0 THEN delayStr = strcompress(delay/60,/remove_all) + "mindelay_" ELSE delayStr = ""

  IF KEYWORD_SET(smoothWindow) THEN smoothStr = strtrim(smoothWindow,2)+"min_IMFsmooth--" ELSE smoothStr=""

  IF N_ELEMENTS(paramStrSuffix) EQ 0 THEN paramStrSuffix = "" ;; ELSE paramStrSuffix = "--" + paramStrSuffix
  IF N_ELEMENTS(paramStrPrefix) EQ 0 THEN paramStrPrefix = "" ;; ELSE paramStrPrefix = paramStrPrefix + "--"

  ;;parameter string
  paramString=paramStrPrefix+hemStr+'_'+clockStr+"--"+strtrim(stableIMF,2)+"stable--"+smoothStr+satellite+omniStr+"_"+delayStr+$
           byMinStr+byMaxStr+bzMinStr+bzMaxStr+paramStrSuffix+hoyDia

  printf,lun,""
  printf,lun,"**********DATA SUMMARY**********"
  printf,lun,satellite+" satellite data delay: " + strtrim(delay,2) + " seconds"
  printf,lun,"IMF stability requirement: " + strtrim(stableIMF,2) + " minutes"
  printf,lun,"Screening parameters: [Min] [Max]"
  printf,lun,"Mag current: " + strtrim(maxNEGMC,2) + " " + strtrim(minMC,2)
  printf,lun,"MLT: " + strtrim(minMLT,2) + " " + strtrim(maxMLT,2)
  printf,lun,"ILAT: " + strtrim(minILAT,2) + " " + strtrim(maxILAT,2)
  printf,lun,"Hemisphere: " + hemStr
  printf,lun,"IMF Predominance: " + clockStr
  printf,lun,"Angle lim 1: " + strtrim(angleLim1,2)
  printf,lun,"Angle lim 2: " + strtrim(angleLim2,2)


  ;;######ELECTRON FLUXES, ENERGY AND NUMBER 
  ;;;MAKE THESE THEIR OWN ROUTINES
END