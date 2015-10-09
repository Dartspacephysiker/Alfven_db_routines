;+
; NAME:    SET_IMF_PARAMS_AND_IND_DEFAULTS
;
; PURPOSE: For the love, it is high time to consolidate like thirty different codes all doing the same thing a little differently
;
; CALLING SEQUENCE: 
;
; INPUTS:
;
; OPTIONAL INPUTS:   
;                *DATABASE PARAMETERS
;                    CLOCKSTR          :  Interplanetary magnetic field clock angle.
;                                            Can be 'dawnward', 'duskward', 'bzNorth', 'bzSouth', 'all_IMF',
;                                            'dawn-north', 'dawn-south', 'dusk-north', or 'dusk-south'.
;		     ANGLELIM1         :     
;		     ANGLELIM2         :     
;		     ORBRANGE          :  Two-element vector, lower and upper limit on orbits to include   
;		     ALTITUDERANGE     :  Two-element vector, lower and upper limit on altitudes to include   
;                    CHARERANGE        :  Two-element vector, lower ahd upper limit on characteristic energy of electrons in 
;                                            the LOSSCONE (could change it to total in get_chaston_ind.pro).
;                    POYNTRANGE        :  Two-element vector, lower and upper limit Range of Poynting flux values to include.
; 		     MINMLT            :  MLT min  (Default: 9)
; 		     MAXMLT            :  MLT max  (Default: 15)
; 		     BINMLT            :  MLT binsize  (Default: 0.5)
;		     MINILAT           :  ILAT min (Default: 64)
;		     MAXILAT           :  ILAT max (Default: 80)
;		     BINILAT           :  ILAT binsize (Default: 2.0)
;                    BYMIN             :  Minimum value of IMF By during an event to accept the event for inclusion in the analysis.
;                    BZMIN             :  Minimum value of IMF Bz during an event to accept the event for inclusion in the analysis.
;                    BYMAX             :  Maximum value of IMF By during an event to accept the event for inclusion in the analysis.
;                    BZMAX             :  Maximum value of IMF Bz during an event to accept the event for inclusion in the analysis.
;                    HEMI              :  Hemisphere for which to show statistics. Can be "North", "South", or "Both".
;
;                *IMF SATELLITE PARAMETERS
;                    SATELLITE         :  Satellite to use for checking FAST data against IMF.
;                                           Can be any of "ACE", "wind", "wind_ACE", or "OMNI" (default).
;                    OMNI_COORDS       :  If using "OMNI" as the satellite, choose between GSE or GSM coordinates for the database.
;                    DELAY             :  Time (in seconds) to lag IMF behind FAST observations. 
;                                         Binzheng Zhang has found that current IMF conditions at ACE or WIND usually rear   
;                                            their heads in the ionosphere about 11 minutes after they are observed.
;                    STABLEIMF         :  Time (in minutes) over which stability of IMF is required to include data.
;                                            NOTE! Cannot be less than 1 minute.
;                    SMOOTHWINDOW      :  Smooth IMF data over a given window (default: none)
;
;                *HOLZWORTH/MENG STATISTICAL AURORAL OVAL PARAMETERS 
;                    HWMAUROVAL        :  Only include those data that are above the statistical auroral oval.
;                    HWMKPIND          :  Kp Index to use for determining the statistical auroral oval (def: 7)
;
;                  *VARIOUS OUTPUT OPTIONS
;		     PARAMSTRPREFIX    :     
;		     PARAMSTRSUFFIX    :     
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS: 
;                    MAXIMUS           :  Return maximus structure used in this pro.
;
; PROCEDURE:
;
; EXAMPLE: 
;     Use Chaston's original (ALFVEN_STATS_3) database, only including orbits falling in the range 1000-4230
;     plot_alfven_stats_imf_screening,clockstr="duskward",/do_chastdb,$
;                                          plotpref='NESSF2014_reproduction_Jan2015--orbs1000-4230',ORBRANGE=[1000,4230]
;
;
;
; MODIFICATION HISTORY: Best to follow my mod history on the Github repository...
;                       
;                       2015/10/09 : This pro was born in an attempt to consolidate probably four or five versions of the same
;                                    code floating around the FAST repositories. Not any longer!
;                       
;                       
;-
PRO SET_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                    ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                    minMLT=minMLT,maxMLT=maxMLT,BINMLT=binMLT,MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                                    MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                                    HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                    BYMIN=byMin, BZMIN=bzMin, BYMAX=byMax, BZMAX=bzMax,BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                    PARAMSTRING=paramString, PARAMSTRPREFIX=paramStrPrefix,PARAMSTRSUFFIX=paramStrSuffix,$
                                    SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                    HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow,INCLUDENOCONSECDATA=includeNoConsecData, $
                                    HOYDIA=hoyDia,LUN=lun

  COMPILE_OPT idl2
  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout
  ;;***********************************************
  ;;Tons of defaults
  
  defOrbRange            = [0,40000]
  defCharERange          = [4.0,300]
  defAltRange            = [1000.0, 5000.0]

  ; satellite defaults
  defSatellite           = "OMNI"    ;either "ACE", "wind", "wind_ACE", or "OMNI" (default, you see)
  defOmni_Coords         = "GSM"             ; either "GSE" or "GSM"

  defDelay               = 900

  defstableIMF           = 0S             ;Set to a time (in minutes) over which IMF stability is required
  defIncludeNoConsecData = 0    ;Setting this to 1 includes Chaston data for which  
                                ;there's no way to calculate IMF stability
                                ;Only valid for stableIMF GE 1
  defCheckBothWays       = 0          
  
  defBx_over_ByBz_Lim    = 0       ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)
  
  ;for statistical auroral oval
  defHwMAurOval          = 0
  defHwMKpInd            = 7

  defClockStr            = 'dawnward'
  
  defAngleLim1           = 60.0
  defAngleLim2           = 120.0

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Now set up vars

  ; Handle MLT and ILAT
  SET_DEFAULT_MLT_ILAT_AND_MAGC,MINMLT=minMLT,MAXMLT=maxMLT,BINM=binMLT, $
                                MINILAT=minILAT,MAXILAT=maxILAT,BINI=binILAT, $
                                MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                                HEMI=hemi,LUN=lun

  ;;***********************************************
  ;;RESTRICTIONS ON DATA, SOME VARIABLES
  IF N_ELEMENTS(orbRange) EQ 0 THEN orbRange = defOrbRange         ; 4,~300 eV in Strangeway

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
  printf,lun,FORMAT='(A4, " satellite delay          :",T35,I8,T45," seconds")',satellite,delay
  printf,lun,FORMAT='("IMF stability requirement     :",T35,I8,T45," minutes")',stableIMF
  printf,lun,FORMAT='("")'
  printf,lun,"************"
  printf,lun,FORMAT='("Screening parameters          :",T35,"   [Min]",T45,"   [Max]")'
  printf,lun,FORMAT='("")'
  printf,lun,FORMAT='("MLT                           :",T35,I8,T45,I8)',minMLT,maxMLT
  printf,lun,FORMAT='("ILAT                          :",T35,I8,T45,I8)',minILAT,maxILAT
  printf,lun,FORMAT='("Mag current                   :",T35,G8.2,T45,G8.2)',maxNEGMC,minMC
  printf,lun,FORMAT='("")'
  printf,lun,FORMAT='("Orbits                        :",T35,I8,T45,I8)',orbRange[0],orbRange[1]
  printf,lun,FORMAT='("Altitude                      :",T35,I8,T45,I8)',altitudeRange[0],altitudeRange[1]
  printf,lun,FORMAT='("Char electron energy (eV)     :",T35,G8.2,T45,G8.2)',charERange[0],charERange[1]
  printf,lun,FORMAT='("")'
  printf,lun,FORMAT='("Hemisphere                    :",T35,A8)',hemStr
  printf,lun,FORMAT='("IMF Predominance              :",T35,A8)',clockStr
  printf,lun,FORMAT='("Angle lim 1                   :",T35,I8)',angleLim1
  printf,lun,FORMAT='("Angle lim 2                   :",T35,I8)',angleLim2


  ;;######ELECTRON FLUXES, ENERGY AND NUMBER 
  ;;;MAKE THESE THEIR OWN ROUTINES
END