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
;                       2015/10/15 : Adding L-shell stuff
;                       2016/02/10 : Added DO_NOT_CONSIDER_IMF keyword
;-
PRO SET_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                    MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
                                    DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                    ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                    BYMIN=byMin, $
                                    BYMAX=byMax, $
                                    BZMIN=bzMin, $
                                    BZMAX=bzMax, $
                                    BTMIN=btMin, $
                                    BTMAX=btMax, $
                                    BXMIN=bxMin, $
                                    BXMAX=bxMax, $
                                    DO_ABS_BYMIN=abs_byMin, $
                                    DO_ABS_BYMAX=abs_byMax, $
                                    DO_ABS_BZMIN=abs_bzMin, $
                                    DO_ABS_BZMAX=abs_bzMax, $
                                    DO_ABS_BTMIN=abs_btMin, $
                                    DO_ABS_BTMAX=abs_btMax, $
                                    DO_ABS_BXMIN=abs_bxMin, $
                                    DO_ABS_BXMAX=abs_bxMax, $
                                    BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                    DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                    PARAMSTRING=paramString, $
                                    PARAMSTR_LIST=paramString_list, $
                                    SATELLITE=satellite, $
                                    OMNI_COORDS=omni_Coords, $
                                    DELAY=delay, $
                                    MULTIPLE_DELAYS=multiple_delays, $
                                    OUT_EXECUTING_MULTIPLES=executing_multiples, $
                                    OUT_MULTIPLES=multiples, $
                                    OUT_MULTISTRING=multiString, $
                                    RESOLUTION_DELAY=delay_res, $
                                    BINOFFSET_DELAY=binOffset_delay, $
                                    STABLEIMF=stableIMF, $
                                    SMOOTHWINDOW=smoothWindow, $
                                    INCLUDENOCONSECDATA=includeNoConsecData, $
                                    LUN=lun

  COMPILE_OPT idl2
  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout
  ;;***********************************************
  ;;Tons of defaults
  
  defOrbRange            = [0,16361]
  ;; defCharERange          = [4.0,300]
  ;; defAltRange            = [1000.0, 5000.0]
  defCharERange          = [4.0,10000.0]
  defAltRange            = [0.0, 5000.0]

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
  
  defClockStr            = 'dawnward'
  
  ;; defAngleLim1           = 60.0
  ;; defAngleLim2           = 120.0

  ;; defAngleLim1           = 30.0
  ;; defAngleLim2           = 150.0

  defAngleLim1           = 45.0
  defAngleLim2           = 135.0

  ;;***********************************************
  ;;RESTRICTIONS ON DATA, SOME VARIABLES
  IF N_ELEMENTS(orbRange)            EQ 0 THEN orbRange               = defOrbRange         ; 4,~300 eV in Strangeway

  IF N_ELEMENTS(charERange)          EQ 0 THEN charERange             = defCharERange       ; 4,~300 eV in Strangeway

  IF N_ELEMENTS(altitudeRange)       EQ 0 THEN altitudeRange          = defAltRange         ;Rob Pfaff says no lower than 1000m
  
  ;;********************************************
  ;;satellite data options
  
  IF N_ELEMENTS(satellite)           EQ 0 THEN satellite              = defSatellite        ;either "ACE", "wind", "wind_ACE", or "OMNI" (default, you see)
  IF N_ELEMENTS(omni_Coords)         EQ 0 THEN omni_Coords            = defOmni_Coords      ; either "GSE" or "GSM"

  IF N_ELEMENTS(delay)               EQ 0 THEN delay                  = defDelay            ;Delay between ACE propagated data and ChastonDB data
                                                                                            ;Bin recommends something like 11min
  
  IF ~KEYWORD_SET(delay_res)              THEN delay_res              = 120
  IF N_ELEMENTS(binOffset_delay)     EQ 0 THEN binOffset_delay        = 0 


  IF N_ELEMENTS(stableIMF)           EQ 0 THEN stableIMF              = defStableIMF        ;Set to a time (in minutes) over which IMF stability is required
  IF N_ELEMENTS(includeNoConsecData) EQ 0 THEN defIncludeNoConsecData = 0                   ;Setting this to 1 includes Chaston data for which  
                                                                                            ;there's no way to calculate IMF stability
                                                                                            ;Only valid for stableIMF GE 1
  IF N_ELEMENTS(checkBothWays)       EQ 0 THEN checkBothWays          = defCheckBothWays    ;
  
  IF N_ELEMENTS(Bx_over_ByBz_Lim)    EQ 0 THEN Bx_over_ByBz_Lim       = defBx_over_ByBz_Lim ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)
  
  ;;Which IMF clock angle are we doing?
  ;;options are 'duskward', 'dawnward', 'bzNorth', 'bzSouth', and 'all_IMF'
  IF KEYWORD_SET(do_not_consider_imf) THEN BEGIN
     clockStr                      = 'NO_IMF_CONSID'
     paramString                   = paramString + clockStr
     paramString_list              = LIST(paramString)
  ENDIF ELSE BEGIN

     IF ~KEYWORD_SET(dont_consider_clockAngles) THEN BEGIN
        IF N_ELEMENTS(clockStr) EQ 0 THEN BEGIN
           clockStr = defClockStr
        ENDIF
     
        ;;How to set angles? Note, clock angle is measured with
        ;;Bz North at zero deg, ranging from -180<clock_angle<180
        ;;Setting angle limits 45 and 135, for example, gives a 90-deg
        ;;window for dawnward and duskward plots
        IF clockStr[0] NE "all_IMF" THEN BEGIN
           angleLim1 = KEYWORD_SET(angleLim1) ? angleLim1 : defAngleLim1 ;in degrees
           angleLim2 = KEYWORD_SET(angleLim2) ? angleLim2 : defAngleLim2 ;in degrees
        ENDIF ELSE BEGIN 
           angleLim1 = KEYWORD_SET(angleLim1) ? angleLim1 : 180 ;for doing all IMF
           angleLim2 = KEYWORD_SET(angleLim2) ? angleLim2 : 180
        ENDELSE
     ENDIF ELSE BEGIN
        clockStr  = ''
     ENDELSE

     ;;Requirement for IMF By magnitude?
     byMinStr=''
     byMaxStr=''
     
     IF N_ELEMENTS(byMin) GT 0 THEN BEGIN
        byMinStr = '__' + (KEYWORD_SET(abs_byMin) ? 'ABS_' : '') $
                   + 'byMin' + String(byMin,format='(D0.1)') ;STRCOMPRESS(byMin,/REMOVE_ALL)
     ENDIF
     IF N_ELEMENTS(byMax) GT 0 THEN BEGIN
        byMaxStr = '__' + (KEYWORD_SET(abs_byMax) ? 'ABS_' : '') $
                  + 'byMax' + String(byMax,format='(D0.1)') ;STRCOMPRESS(byMax,/REMOVE_ALL)
     ENDIF
     
     ;;Requirement for IMF Bz magnitude?
     bzMinStr=''
     bzMaxStr=''
     
     IF N_ELEMENTS(bzMin) GT 0 THEN BEGIN
        bzMinStr = '__' + (KEYWORD_SET(abs_bzMin) ? 'ABS_' : '') $
                   + 'bzMin' + String(bzMin,format='(D0.1)')
     ENDIF
     IF N_ELEMENTS(bzMax) GT 0 THEN BEGIN
        bzMaxStr = '__' + (KEYWORD_SET(abs_bzMax) ? 'ABS_' : '') $
                   + 'bzMax' + String(bzMax,format='(D0.1)')
     ENDIF
     
     ;;Requirement for IMF Bt magnitude?
     btMinStr=''
     btMaxStr=''
     
     IF N_ELEMENTS(btMin) GT 0 THEN BEGIN
        btMinStr = '__' + (KEYWORD_SET(abs_btMin) ? 'ABS_' : '') $
                   + 'btMin' + String(btMin,format='(D0.1)')
     ENDIF
     IF N_ELEMENTS(btMax) GT 0 THEN BEGIN
        btMaxStr = '__' + (KEYWORD_SET(abs_btMax) ? 'ABS_' : '') $
                   + 'btMax' + String(btMax,format='(D0.1)')
     ENDIF
     
     ;;Requirement for IMF Bx magnitude?
     bxMinStr=''
     bxMaxStr=''
     
     IF N_ELEMENTS(bxMin) GT 0 THEN BEGIN
        bxMinStr = '__' + (KEYWORD_SET(abs_bxMin) ? 'ABS_' : '') $
                   + 'bxMin' + String(bxMin,format='(D0.1)')
     ENDIF
     IF N_ELEMENTS(bxMax) GT 0 THEN BEGIN
        bxMaxStr = '__' + (KEYWORD_SET(abs_bxMax) ? 'ABS_' : '') $
                   + 'bxMax' + String(bxMax,format='(D0.1)')
     ENDIF
     
     ;;********************************************
     ;;Set up some other strings
     
     ;;satellite string
     omniStr = ""
     IF satellite EQ "OMNI" then omniStr = "--" + omni_Coords 
     ;;IF delay NE defDelay THEN delayStr = strcompress(delay/60,/remove_all) + "mindelay_" ELSE delayStr = ""
     ;; IF delay GT 0 THEN delayStr = strcompress(delay/60,/remove_all) + "mindelay_" ELSE delayStr = ""
     IF N_ELEMENTS(delay) GT 0 THEN delayStr = STRING(FORMAT='("__",F0.2,"mindelay")',delay/60.) ELSE delayStr = ""
     IF N_ELEMENTS(delay_res) GT 0 THEN delayResStr = STRING(FORMAT='("__",F0.2,"Res")',delay_res/60.) ELSE delayResStr = ""
     ;; IF N_ELEMENTS(binOffset_delay) GT 0 THEN delBinOffStr = STRING(FORMAT='("__",F0.2,"binOffset")',binOffset_delay/60.) ELSE delBinOffStr = ""
     delBinOffStr = ""
     
     delayStr = delayStr + delayResStr + delBinOffStr

     IF KEYWORD_SET(smoothWindow) THEN smoothStr = '__' + strtrim(smoothWindow,2)+"min_IMFsmooth" ELSE smoothStr=""
     
     ;;parameter string
     paramString_list                    = LIST()
     IF clockStr[0] EQ '' THEN clockOutStr  = '' ELSE clockOutStr = '--' + clockStr
     IF N_ELEMENTS(paramString) EQ 0 THEN paramString = ''
     IF KEYWORD_SET(multiple_delays) OR KEYWORD_SET(multiple_IMF_clockAngles) THEN BEGIN
        executing_multiples           = 1
        IF KEYWORD_SET(multiple_delays) THEN BEGIN
           multiples                  = delay
           multiString                = "IMF_delays"
           FOR iDel=0,N_ELEMENTS(multiples)-1 DO BEGIN
              paramString_list.add,paramString+'--'+satellite+omniStr+clockOutStr+"__"+strtrim(stableIMF,2)+"stable"+smoothStr+delayStr[iDel]+$
                 byMinStr+byMaxStr+bzMinStr+bzMaxStr+btMinStr+btMaxStr+bxMinStr+bxMaxStr
           ENDFOR
        ENDIF

        IF KEYWORD_SET(multiple_IMF_clockAngles) THEN BEGIN
           multiples                  = clockStr
           ;; multiString                = "IMF_clock angles"
           multiString                = paramString+"__"+strtrim(stableIMF,2)+"stable"+smoothStr+delayStr[0]+$
                    byMinStr+byMaxStr+bzMinStr+bzMaxStr+btMinStr+btMaxStr+bxMinStr+bxMaxStr
           IF N_ELEMENTS(clockStr) EQ 8 THEN multiString_suff = '--theRing'
           IF KEYWORD_SET(multiString_suff) THEN multiString = multiString + multiString_suff
           FOR iClock=0,N_ELEMENTS(multiples)-1 DO BEGIN
              paramString_list.add,paramString+'--'+satellite+omniStr+clockOutStr[iClock]+"__"+strtrim(stableIMF,2)+"stable"+smoothStr+delayStr+$
                 byMinStr+byMaxStr+bzMinStr+bzMaxStr+btMinStr+btMaxStr+bxMinStr+bxMaxStr
              IF ~KEYWORD_SET(multiString_suff) THEN multiString = multiString+'_'+clockStr[iClock]
           ENDFOR
        ENDIF
     ENDIF ELSE BEGIN
        executing_multiples           = 0
        paramString=paramString+'--'+satellite+omniStr+clockOutStr+"__"+strtrim(stableIMF,2)+"stable"+smoothStr+delayStr[0]+$
                    byMinStr+byMaxStr+bzMinStr+bzMaxStr+btMinStr+btMaxStr+bxMinStr+bxMaxStr
        paramString_list.add,paramString
     ENDELSE
  ENDELSE



END