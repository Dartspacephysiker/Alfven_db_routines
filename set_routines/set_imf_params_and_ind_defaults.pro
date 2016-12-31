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
;                                          plotpref='NESSF2014_reproduction_Jan2015-orbs1000-4230',ORBRANGE=[1000,4230]
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
PRO SET_IMF_PARAMS_AND_IND_DEFAULTS, $
   CLOCKSTR=clockStr, $
   ANGLELIM1=angleLim1,  $
   ANGLELIM2=angleLim2, $
   THETACONEMIN=tConeMin, $
   THETACONEMAX=tConeMax, $
   MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
   DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
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
   BX_OVER_BY_RATIO_MAX=bx_over_by_ratio_max, $
   BX_OVER_BY_RATIO_MIN=bx_over_by_ratio_min, $
   BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
   DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
   SKIP_IMF_STRING=skip_IMF_string, $
   OMNIPARAMSTR=OMNIparamStr, $
   OMNI_PARAMSTR_LIST=OMNIparamStr_list, $
   SATELLITE=satellite, $
   OMNI_COORDS=OMNI_coords, $
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
   EARLIEST_UTC=earliest_UTC, $
   LATEST_UTC=latest_UTC, $
   USE_JULDAY_NOT_UTC=use_julDay_not_UTC, $
   EARLIEST_JULDAY=earliest_julDay, $
   LATEST_JULDAY=latest_julDay, $
   IMF_STRUCT=IMF_struct, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   RESET_STRUCT=reset, $
   _EXTRA=e, $
   LUN=lun

  COMPILE_OPT idl2
  IF N_ELEMENTS(lun) EQ 0 THEN BEGIN
     lun = -1                   ;stdout
  ENDIF
  ;;***********************************************
  ;;Tons of defaults
  
                                ; satellite defaults
  defSatellite           = "OMNI" ;either "ACE", "wind", "wind_ACE", or "OMNI" (default, you see)
  defOMNI_Coords         = "GSM"  ; either "GSE" or "GSM"

  defDelay               = 900

  defstableIMF           = 0S   ;Set to a time (in minutes) over which IMF stability is required
  defIncludeNoConsecData = 0    ;Setting this to 1 includes Chaston data for which  
                                ;there's no way to calculate IMF stability
                                ;Only valid for stableIMF GE 1
  defCheckBothWays       = 0          
  
  defBx_over_ByBz_Lim    = 0    ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)
  
  defClockStr            = 'dawnward'
  
  ;; defAngleLim1           = 60.0
  ;; defAngleLim2           = 120.0

  ;; defAngleLim1           = 30.0
  ;; defAngleLim2           = 150.0

  defAngleLim1           = 45.0
  defAngleLim2           = 135.0

  IF N_ELEMENTS(earliest_UTC) EQ 0 THEN BEGIN
     earliest_UTC = STR_TO_TIME('1996-10-06/16:26:02.417')
  ENDIF

  ;;We have more uncorrupted data for the eSpec DB, you know
  CASE 1 OF
     KEYWORD_SET(alfDB_plot_struct.for_eSpec_DBs): BEGIN
        IF N_ELEMENTS(latest_UTC) EQ 0 THEN BEGIN
           latest_UTC   = STR_TO_TIME('2001-12-31/23:59:59.999')
        ENDIF
     END
     ELSE: BEGIN
        IF N_ELEMENTS(latest_UTC) EQ 0 THEN BEGIN
           latest_UTC   = STR_TO_TIME('1999-11-03/03:20:59.853')
        ENDIF
     END
  ENDCASE

  IF N_ELEMENTS(earliest_julDay) EQ 0 THEN BEGIN
     earliest_julDay = UTC_TO_JULDAY(earliest_UTC)
  ENDIF

  IF N_ELEMENTS(latest_julDay) EQ 0 THEN BEGIN
     latest_julDay   = UTC_TO_JULDAY(latest_UTC)
  ENDIF


  ;;********************************************
  ;;satellite data options
  
  IF N_ELEMENTS(satellite           ) EQ 0 THEN BEGIN
     satellite              = defSatellite ;either "ACE", "wind", "wind_ACE", or "OMNI" (default, you see)
  ENDIF
  IF N_ELEMENTS(OMNI_coords         ) EQ 0 THEN BEGIN
     OMNI_coords            = defOMNI_Coords ; either "GSE" or "GSM"
  ENDIF

  IF N_ELEMENTS(delay               ) EQ 0 THEN BEGIN
     delay                  = defDelay ;Delay between ACE propagated data and ChastonDB data
                                ;Bin recommends something like 11min
  ENDIF
  
  IF ~KEYWORD_SET(delay_res) THEN BEGIN
     delay_res              = 120
  ENDIF
  IF N_ELEMENTS(binOffset_delay     ) EQ 0 THEN BEGIN
     binOffset_delay        = 0 
  ENDIF

  IF N_ELEMENTS(stableIMF           ) EQ 0 THEN BEGIN
     stableIMF              = defStableIMF ;Set to a time (in minutes) over which IMF stability is required
  ENDIF

  IF N_ELEMENTS(includeNoConsecData ) EQ 0 THEN BEGIN
     defIncludeNoConsecData = 0 ;Setting this to 1 includes Chaston data for which  
                                ;there's no way to calculate IMF stability
                                ;Only valid for stableIMF GE 1
  ENDIF

  IF N_ELEMENTS(checkBothWays       ) EQ 0 THEN BEGIN
     checkBothWays          = defCheckBothWays ;
  ENDIF
  
  IF N_ELEMENTS(Bx_over_ByBz_Lim    ) EQ 0 THEN BEGIN
     Bx_over_ByBz_Lim       = defBx_over_ByBz_Lim ;Set this to the max ratio of Bx / SQRT(By*By + Bz*Bz)
  ENDIF

  IF N_ELEMENTS(OMNIparamStr) EQ 0 THEN BEGIN
     OMNIparamStr             = ''
  ENDIF


  ;;Which IMF clock angle are we doing?
  ;;options are 'duskward', 'dawnward', 'bzNorth', 'bzSouth', and 'all_IMF'
  IF KEYWORD_SET(do_not_consider_imf) THEN BEGIN
     clockStr                   = KEYWORD_SET(skip_IMF_string) ? '' : 'NO_IMF_CONSID'
     IF (clockStr NE '') AND (OMNIparamStr NE '') THEN BEGIN
        OMNIparamStr                = OMNIparamStr + '-' + clockStr
     ENDIF
     OMNIparamStr_list           = LIST(OMNIparamStr)
  ENDIF ELSE BEGIN

     ;;How many?
     nB_conds                    = 1 > $
                                   N_ELEMENTS(byMin) > N_ELEMENTS(byMax) > $
                                   N_ELEMENTS(bzMin) > N_ELEMENTS(bzMax) > $
                                   N_ELEMENTS(btMin) > N_ELEMENTS(btMax) > $
                                   N_ELEMENTS(bxMin) > N_ELEMENTS(bxMax) > $
                                   N_ELEMENTS(bx_over_by_ratio_min) > $
                                   N_ELEMENTS(bx_over_by_ratio_max) > $
                                   N_ELEMENTS(tConeMin) > N_ELEMENTS(tConeMax)

     multiple_B_conds            = nB_conds GT 1

     IF ~KEYWORD_SET(dont_consider_clockAngles) THEN BEGIN
        IF N_ELEMENTS(clockStr) EQ 0 THEN BEGIN
           clockStr              = defClockStr
        ENDIF
        
        ;;How to set angles? Note, clock angle is measured with
        ;;Bz North at zero deg, ranging from -180<clock_angle<180
        ;;Setting angle limits 45 and 135, for example, gives a 90-deg
        ;;window for dawnward and duskward plots
        IF clockStr[0] NE "all_IMF" THEN BEGIN
           angleLim1             = N_ELEMENTS(angleLim1) GT 0 ? angleLim1 : defAngleLim1 ;in degrees
           angleLim2             = N_ELEMENTS(angleLim2) GT 0 ? angleLim2 : defAngleLim2 ;in degrees
        ENDIF ELSE BEGIN 
           angleLim1             = N_ELEMENTS(angleLim1) GT 0 ? angleLim1 : 180 ;for doing all IMF
           angleLim2             = N_ELEMENTS(angleLim2) GT 0 ? angleLim2 : 180
        ENDELSE
     ENDIF ELSE BEGIN
        clockStr                 = ''
     ENDELSE

     ;;Requirement for IMF By magnitude?
     byMinStr                    = ''
     byMaxStr                    = ''
     
     nByMin                      = N_ELEMENTS(byMin)
     IF (nByMin GE 1) AND (nB_conds GT 1) THEN BEGIN
        IF (nByMin GT 1) AND (nB_conds NE nByMin) THEN BEGIN
           PRINT,"Unequal number of B conds provided!"
           STOP
        ENDIF ELSE BEGIN
           byMin                 = REPLICATE(byMin,nB_conds)
        ENDELSE
     ENDIF
     IF nByMin GT 0 THEN BEGIN
        byMinStr                 = '_' + (KEYWORD_SET(abs_byMin) ? 'ABS' : '') $
                                   + 'byMin' + STRING(byMin,FORMAT='(D0.1)') ;STRCOMPRESS(byMin,/REMOVE_ALL)
     ENDIF

     nByMax                      = N_ELEMENTS(byMax)
     IF (nByMax GE 1) AND (nB_conds GT 1) THEN BEGIN
        IF (nByMax GT 1) AND (nB_conds NE nByMax) THEN BEGIN
           PRINT,"Unequal number of B conds provided!"
           STOP
        ENDIF ELSE BEGIN
           ByMax                 = REPLICATE(ByMax,nB_conds)
        ENDELSE
     ENDIF
     IF nByMax GT 0 THEN BEGIN
        byMaxStr                 = '_' + (KEYWORD_SET(abs_byMax) ? 'ABS' : '') $
                                   + 'byMax' + STRING(byMax,FORMAT='(D0.1)') ;STRCOMPRESS(byMax,/REMOVE_ALL)
     ENDIF
     
     ;;Requirement for IMF Bz magnitude?
     bzMinStr                    = ''
     bzMaxStr                    = ''
     
     nBzMin                      = N_ELEMENTS(bzMin)
     IF (nBzMin GE 1) AND (nB_conds GT 1) THEN BEGIN
        IF (nBzMin GT 1) AND (nB_conds NE nBzMin) THEN BEGIN
           PRINT,"Unequal number of B conds provided!"
           STOP
        ENDIF ELSE BEGIN
           BzMin                 = REPLICATE(BzMin,nB_conds)
        ENDELSE
     ENDIF
     IF nBzMin GT 0 THEN BEGIN
        bzMinStr                 = '_' + (KEYWORD_SET(abs_bzMin) ? 'ABS' : '') $
                                   + 'bzMin' + STRING(bzMin,FORMAT='(D0.1)')
     ENDIF

     nBzMax                      = N_ELEMENTS(bzMax)
     IF (nBzMax GE 1) AND (nB_conds GT 1) THEN BEGIN
        IF (nBzMax GT 1) AND (nB_conds NE nBzMax) THEN BEGIN
           PRINT,"Unequal number of B conds provided!"
           STOP
        ENDIF ELSE BEGIN
           BzMax                 = REPLICATE(BzMax,nB_conds)
        ENDELSE
     ENDIF
     IF nBzMax GT 0 THEN BEGIN
        bzMaxStr                 = '_' + (KEYWORD_SET(abs_bzMax) ? 'ABS' : '') $
                                   + 'bzMax' + STRING(bzMax,FORMAT='(D0.1)')
     ENDIF
     
     ;;Requirement for IMF Bt magnitude?
     btMinStr                    = ''
     btMaxStr                    = ''
     
     nBtMin                      = N_ELEMENTS(btMin)
     IF (nBtMin GE 1) AND (nB_conds GT 1) THEN BEGIN
        IF (nBtMin GT 1) AND (nB_conds NE nBtMin) THEN BEGIN
           PRINT,"Unequal number of B conds provided!"
           STOP
        ENDIF ELSE BEGIN
           BtMin                 = REPLICATE(BtMin,nB_conds)
        ENDELSE
     ENDIF
     IF nBtMin GT 0 THEN BEGIN
        IF btMin LT 0 THEN BEGIN
           PRINT,'btMin shouldn''t be less than zero!'
           STOP
        ENDIF
        btMinStr                 = '_' + (KEYWORD_SET(abs_btMin) ? 'ABS' : '') $
                                   + 'btMin' + STRING(btMin,FORMAT='(D0.1)')
     ENDIF

     nBtMax                      = N_ELEMENTS(btMax)
     IF (nBtMax GE 1) AND (nB_conds GT 1) THEN BEGIN
        IF (nBtMax GT 1) AND (nB_conds NE nBtMax) THEN BEGIN
           PRINT,"Unequal number of B conds provided!"
           STOP
        ENDIF ELSE BEGIN
           BtMax                 = REPLICATE(BtMax,nB_conds)
        ENDELSE
     ENDIF
     IF nBtMax GT 0 THEN BEGIN
        IF btMax LT 0 THEN BEGIN
           PRINT,'btMax shouldn''t be less than zero!'
           STOP
        ENDIF
        btMaxStr                 = '_' + (KEYWORD_SET(abs_btMax) ? 'ABS' : '') $
                                   + 'btMax' + STRING(btMax,FORMAT='(D0.1)')
     ENDIF
     
     ;;Requirement for IMF Bx magnitude?
     bxMinStr                    = ''
     bxMaxStr                    = ''
     
     nBxMin                      = N_ELEMENTS(bxMin)
     IF (nBxMin GE 1) AND (nB_conds GT 1) THEN BEGIN
        IF (nBxMin GT 1) AND (nB_conds NE nBxMin) THEN BEGIN
           PRINT,"Unequal number of B conds provided!"
           STOP
        ENDIF ELSE BEGIN
           BxMin                 = REPLICATE(BxMin,nB_conds)
        ENDELSE
     ENDIF
     IF nBxMin GT 0 THEN BEGIN
        bxMinStr                 = '_' + (KEYWORD_SET(abs_bxMin) ? 'ABS' : '') $
                                   + 'bxMin' + STRING(bxMin,FORMAT='(D0.1)')
     ENDIF

     nBxMax                      = N_ELEMENTS(bxMax)
     IF (nBxMax GE 1) AND (nB_conds GT 1) THEN BEGIN
        IF (nBxMax GT 1) AND (nB_conds NE nBxMax) THEN BEGIN
           PRINT,"Unequal number of B conds provided!"
           STOP
        ENDIF ELSE BEGIN
           BxMax                 = REPLICATE(BxMax,nB_conds)
        ENDELSE
     ENDIF
     IF nBxMax GT 0 THEN BEGIN
        bxMaxStr                 = '_' + (KEYWORD_SET(abs_bxMax) ? 'ABS' : '') $
                                   + 'bxMax' + STRING(bxMax,FORMAT='(D0.1)')
     ENDIF
     
     ;;Requirement for IMF Bx magnitude?
     bx_over_by_ratio_minStr     = ''
     bx_over_by_ratio_maxStr     = ''
     
     nBx_over_by_ratio_min       = N_ELEMENTS(bx_over_by_ratio_min)
     IF (nBx_over_by_ratio_min GE 1) AND (nB_conds GT 1) THEN BEGIN
        IF (nBx_over_by_ratio_min GT 1) AND (nB_conds NE nBx_over_by_ratio_min) THEN BEGIN
           PRINT,"Unequal number of B conds provided!"
           STOP
        ENDIF ELSE BEGIN
           Bx_over_by_ratio_min                 = REPLICATE(Bx_over_by_ratio_min,nB_conds)
        ENDELSE
     ENDIF
     IF nBx_over_by_ratio_min GT 0 THEN BEGIN
        bx_over_by_ratio_minStr  = '_' + (KEYWORD_SET(abs_bx_over_by_ratio_min) ? 'ABS' : '') $
                                   + 'bxy_rMn' + STRING(bx_over_by_ratio_min,FORMAT='(D0.1)')
     ENDIF

     nBx_over_by_ratio_max       = N_ELEMENTS(bx_over_by_ratio_max)
     IF (nBx_over_by_ratio_max GE 1) AND (nB_conds GT 1) THEN BEGIN
        IF (nBx_over_by_ratio_max GT 1) AND (nB_conds NE nBx_over_by_ratio_max) THEN BEGIN
           PRINT,"Unequal number of B conds provided!"
           STOP
        ENDIF ELSE BEGIN
           Bx_over_by_ratio_max                 = REPLICATE(Bx_over_by_ratio_max,nB_conds)
        ENDELSE
     ENDIF
     IF nBx_over_by_ratio_max GT 0 THEN BEGIN
        bx_over_by_ratio_maxStr  = '_' + (KEYWORD_SET(abs_bx_over_by_ratio_max) ? 'ABS' : '') $
                                   + 'bxy_rMx' + STRING(bx_over_by_ratio_max,FORMAT='(D0.1)')
     ENDIF


     ;;Requirement for IMF cone angle?
     tConeMinStr                    = ''
     tConeMaxStr                    = ''
     
     nTConeMin                      = N_ELEMENTS(tConeMin)
     IF (nTConeMin GE 1) AND (nB_conds GT 1) THEN BEGIN
        IF (nTConeMin GT 1) AND (nB_conds NE nTConeMin) THEN BEGIN
           PRINT,"Unequal number of B conds provided!"
           STOP
        ENDIF ELSE BEGIN
           TConeMin                 = REPLICATE(TConeMin,nB_conds)
        ENDELSE
     ENDIF
     IF nTConeMin GT 0 THEN BEGIN
        tConeMinStr                 = '_' + (KEYWORD_SET(abs_tConeMin) ? 'ABS' : '') $
                                   + 'tConeMin' + STRING(tConeMin,FORMAT='(D0.1)')
     ENDIF

     nTConeMax                      = N_ELEMENTS(tConeMax)
     IF (nTConeMax GE 1) AND (nB_conds GT 1) THEN BEGIN
        IF (nTConeMax GT 1) AND (nB_conds NE nTConeMax) THEN BEGIN
           PRINT,"Unequal number of B conds provided!"
           STOP
        ENDIF ELSE BEGIN
           TConeMax                 = REPLICATE(TConeMax,nB_conds)
        ENDELSE
     ENDIF
     IF nTConeMax GT 0 THEN BEGIN
        tConeMaxStr                 = '_' + (KEYWORD_SET(abs_tConeMax) ? 'ABS' : '') $
                                   + 'tConeMax' + STRING(tConeMax,FORMAT='(D0.1)')
     ENDIF
     

     ;;********************************************
     ;;Set up some other strings
     
     ;;satellite string
     omniStr                    = ""
     IF satellite EQ "OMNI" THEN BEGIN
        ;; omniStr                 = 
        IF STRUPCASE(OMNI_coords) NE 'GSM' THEN BEGIN
           OMNIStr += "-" + OMNI_coords
        ENDIF
     ENDIF

     IF N_ELEMENTS(delay) GT 0 THEN BEGIN
        delayStr                = STRING(FORMAT='("_",F0.1,"Del")',delay/60.) 
     ENDIF ELSE BEGIN
        delayStr                = ""
     ENDELSE
     IF N_ELEMENTS(delay_res) GT 0 THEN BEGIN
        delayResStr             = STRING(FORMAT='("_",F0.1,"Res")',delay_res/60.)
     ENDIF ELSE BEGIN
        delayResStr             = ""
     ENDELSE

     IF N_ELEMENTS(binOffset_delay) GT 0 THEN BEGIN
        delBinOffStr            = STRING(FORMAT='("_",F0.1,"Ofst")',binOffset_delay/60.) 
        ;; delBinOffStr            = ""
     ENDIF ELSE BEGIN
        delBinOffStr            = ""
     ENDELSE
     
     delayStr                   = delayStr + delayResStr + delBinOffStr

     IF KEYWORD_SET(smoothWindow) THEN BEGIN
        smoothStr               = '_' + strtrim(smoothWindow,2)+"sm" 
     ENDIF ELSE BEGIN
        smoothStr               = ""
     ENDELSE
     
     ;;parameter string
     OMNIparamStr_list           = LIST()
     IF clockStr[0] EQ '' THEN BEGIN
        clockOutStr             = '' 
     ENDIF ELSE BEGIN
        clockOutStr             = '-' + clockStr
     ENDELSE

     haveMulti = KEYWORD_SET(multiple_delays) + KEYWORD_SET(multiple_IMF_clockAngles) + KEYWORD_SET(multiple_B_conds)
     IF haveMulti GT 1 THEN STOP

     IF (haveMulti GT 0) THEN BEGIN
        executing_multiples     = 1
        IF KEYWORD_SET(multiple_delays) THEN BEGIN
           multiples            = delay
           multiString          = "IMF_delays"
           FOR iDel=0,N_ELEMENTS(multiples)-1 DO BEGIN
              OMNIparamStr_list.add,OMNIparamStr+'-'+omniStr+clockOutStr+"_"+strtrim(stableIMF,2)+"stable"+smoothStr+delayStr[iDel]+$
                 byMinStr+byMaxStr+bzMinStr+bzMaxStr+btMinStr+btMaxStr+bxMinStr+bxMaxStr+bx_over_by_ratio_minStr+bx_over_by_ratio_maxStr+tConeMinStr+tConeMaxStr
           ENDFOR
        ENDIF

        IF KEYWORD_SET(multiple_IMF_clockAngles) THEN BEGIN
           multiples            = clockStr
           ;; multiString       = "IMF_clock angles"
           multiString          = OMNIparamStr+"_"+strtrim(stableIMF,2)+"stable"+smoothStr+delayStr[0]+$
                                  byMinStr+byMaxStr+bzMinStr+bzMaxStr+btMinStr+btMaxStr+bxMinStr+bxMaxStr+bx_over_by_ratio_minStr+bx_over_by_ratio_maxStr+tConeMinStr+tConeMaxStr
           IF N_ELEMENTS(clockStr) EQ 8 THEN BEGIN
              multiString_suff  = '-Ring'
           ENDIF
           IF KEYWORD_SET(multiString_suff) THEN BEGIN
              multiString       = multiString + multiString_suff
           ENDIF

           FOR iClock=0,N_ELEMENTS(multiples)-1 DO BEGIN
              OMNIparamStr_list.add,OMNIparamStr+'-'+omniStr+clockOutStr[iClock]+"_"+ $
                 strtrim(stableIMF,2)+"stable"+smoothStr+delayStr+$
                 byMinStr+byMaxStr+bzMinStr+bzMaxStr+btMinStr+btMaxStr+bxMinStr+bxMaxStr+bx_over_by_ratio_minStr+bx_over_by_ratio_maxStr+tConeMinStr+tConeMaxStr

              IF ~KEYWORD_SET(multiString_suff) THEN BEGIN
                 multiString    = multiString+'_'+clockStr[iClock]
              ENDIF
           ENDFOR
        ENDIF

        IF KEYWORD_SET(multiple_B_conds) THEN BEGIN
           multiples            = byMinStr+byMaxStr+bzMinStr+bzMaxStr+btMinStr+btMaxStr+bxMinStr+bxMaxStr+bx_over_by_ratio_minStr+bx_over_by_ratio_maxStr+tConeMinStr+tConeMaxStr
           multiString          = OMNIparamStr+"_"+strtrim(stableIMF,2)+"stable"+smoothStr+delayStr[0]
           IF KEYWORD_SET(multiString_suff) THEN BEGIN
              multiString       = multiString + multiString_suff
           ENDIF ELSE BEGIN
              multiString       = multiString + 'multiple_B_conds'
           ENDELSE

           FOR iClock=0,N_ELEMENTS(multiples)-1 DO BEGIN
              OMNIparamStr_list.add,OMNIparamStr+'-'+omniStr+clockOutStr[iClock]+"_"+ $
                 STRTRIM(stableIMF,2)+"stable"+smoothStr+delayStr+$
                 byMinStr[iClock]+byMaxStr[iClock]+bzMinStr[iClock]+bzMaxStr[iClock]+btMinStr[iClock]+btMaxStr[iClock]+bxMinStr[iClock]+bxMaxStr[iClock]+bx_over_by_ratio_minStr[iClock]+bx_over_by_ratio_maxStr[iClock]+tConeMinStr[iClock]+tConeMaxStr[iClock]

              IF ~KEYWORD_SET(multiString_suff) THEN BEGIN
                 multiString    = multiString+'_'+clockStr[iClock]
              ENDIF
           ENDFOR
        ENDIF

        alfDB_plot_struct.multiString = alfDB_plot_struct.paramString + multiString

        ;; IF alfDB_plot_struct.multiString EQ '' AND $
        ;;    alfDB_plot_struct.executing_multiples   $
        ;; THEN BEGIN
        ;;    alfDB_plot_struct.multiString = alfDB_plot_struct.paramString + OMNIparamStr
        ;; ENDIF ELSE BEGIN
        ;;    IF STRUPCASE(alfDB_plot_struct.multiString) EQ STRUPCASE(OMNIparamStr) THEN BEGIN
        ;;       alfDB_plot_struct.multiString = alfDB_plot_struct.paramString + OMNIparamStr
        ;;    ENDIF ELSE BEGIN
        ;;       STOP
        ;;    ENDELSE
        ;; ENDELSE

     ENDIF ELSE BEGIN
        executing_multiples     = 0
        OMNIparamStr             = OMNIparamStr+'-'+omniStr+clockOutStr+"_"+ $
                                  strtrim(stableIMF,2)+"stable"+smoothStr+delayStr[0]+$
                                  byMinStr+byMaxStr+bzMinStr+bzMaxStr+btMinStr+btMaxStr+bxMinStr+bxMaxStr+bx_over_by_ratio_minStr+bx_over_by_ratio_maxStr+tConeMinStr+tConeMaxStr
        OMNIparamStr_list.add,OMNIparamStr
     ENDELSE
  ENDELSE

  IF ARG_PRESENT(IMF_struct) THEN BEGIN

     IF N_ELEMENTS(IMF_struct) GT 0 AND ~KEYWORD_SET(reset) THEN BEGIN
        PRINT,'Already have IMF_struct! Returning ...'
        RETURN
     ENDIF
     
     IMF_struct = BLANK_IMF_STRUCT()

     IF N_ELEMENTS(clockStr) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'clockStr',clockStr,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(angleLim1) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'angleLim1',FLOAT(angleLim1),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(angleLim2) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'angleLim2',FLOAT(angleLim2),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(multiple_IMF_clockAngles) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'multiple_IMF_clockAngles', $
                    BYTE(multiple_IMF_clockAngles),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(multiple_B_conds) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'multiple_B_conds', $
                    BYTE(multiple_B_conds),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(dont_consider_clockAngles) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'dont_consider_clockAngles', $
                    BYTE(dont_consider_clockAngles),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(byMin) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'byMin',FLOAT(byMin),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(byMax) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'byMax',FLOAT(byMax),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(bzMin) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'bzMin',FLOAT(bzMin),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(bzMax) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'bzMax',FLOAT(bzMax),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(btMin) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'btMin',FLOAT(btMin),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(btMax) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'btMax',FLOAT(btMax),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(bxMin) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'bxMin',FLOAT(bxMin),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(bxMax) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'bxMax',FLOAT(bxMax),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(abs_byMin) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'abs_byMin',BYTE(abs_byMin),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(abs_byMax) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'abs_byMax',BYTE(abs_byMax),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(abs_bzMin) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'abs_bzMin',BYTE(abs_bzMin),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(abs_bzMax) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'abs_bzMax',BYTE(abs_bzMax),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(abs_btMin) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'abs_btMin',BYTE(abs_btMin),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(abs_btMax) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'abs_btMax',BYTE(abs_btMax),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(abs_bxMin) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'abs_bxMin',BYTE(abs_bxMin),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(abs_bxMax) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'abs_bxMax',BYTE(abs_bxMax),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(bx_over_by_ratio_max) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'bx_over_by_ratio_max',FLOAT(bx_over_by_ratio_max),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(bx_over_by_ratio_min) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'bx_over_by_ratio_min',FLOAT(bx_over_by_ratio_min),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(Bx_over_ByBz_Lim) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'Bx_over_ByBz_Lim',FLOAT(Bx_over_ByBz_Lim),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(tConeMin) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'tConeMin',FLOAT(tConeMin),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(tConeMax) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'tConeMax',FLOAT(tConeMax),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(do_not_consider_IMF) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'do_not_consider_IMF',BYTE(do_not_consider_IMF),/ADD_REPLACE
     ENDIF

     IF OMNIparamStr NE '' THEN BEGIN
        IF alfDB_plot_struct.paramString EQ '' THEN BEGIN
           STR_ELEMENT,alfDB_plot_struct,'paramString',OMNIparamStr,/ADD_REPLACE
        ENDIF ELSE BEGIN
           alfDB_plot_struct.paramString += OMNIparamStr
        ENDELSE
     ENDIF

     IF N_ELEMENTS(OMNIparamStr_list) GT 0 THEN BEGIN
        IF N_ELEMENTS(alfDB_plot_struct.paramString_list) EQ 0 THEN BEGIN
           STR_ELEMENT,alfDB_plot_struct,'paramString_list',OMNIparamStr_list,/ADD_REPLACE
           IF KEYWORD_SET(alfDB_plot_struct.executing_multiples) THEN BEGIN
              FOR k=0,N_ELEMENTS(alfDB_plot_struct.paramString_list)-1 DO BEGIN
                 alfDB_plot_struct.paramString_list[k] = alfDB_plot_struct.paramString+alfDB_plot_struct.paramString_list[k]
              ENDFOR
           ENDIF
        ENDIF ELSE BEGIN
           CASE N_ELEMENTS(alfDB_plot_struct.paramString_list) OF
              N_ELEMENTS(OMNIparamStr_list): BEGIN
                 FOR k=0,N_ELEMENTS(OMNIparamStr_list)-1 DO BEGIN
                    alfDB_plot_struct.paramString_list[k] = alfDB_plot_struct.paramString_list[k] + OMNIparamStr_list[k]
                 ENDFOR
              END
              1: BEGIN
                 alfDB_plot_struct.paramString_list[0] = alfDB_plot_struct.paramString+OMNIparamStr_list[0]
                 FOR k=1,N_ELEMENTS(OMNIparamStr_list)-1 DO BEGIN
                    alfDB_plot_struct.paramString_list.Add,alfDB_plot_struct.paramString+OMNIparamStr_list[k]
                 ENDFOR
              END
              ELSE:
           ENDCASE

        ENDELSE
     ENDIF

     IF N_ELEMENTS(satellite) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'satellite',satellite,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(OMNI_coords) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'OMNI_coords',OMNI_coords,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(delay) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'delay',FLOAT(delay),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(multiple_delays) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'multiple_delays',BYTE(multiple_delays),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(executing_multiples) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct, $
                    'executing_multiples', $
                    BYTE(executing_multiples), $
                    /ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(multiples) GT 0 THEN BEGIN
        STR_ELEMENT,alfDB_plot_struct,'multiples',multiples,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(delay_res) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'delay_res',FLOAT(delay_res),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(binOffset_delay) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'binOffset_delay',FLOAT(binOffset_delay),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(stableIMF) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'stableIMF',FLOAT(stableIMF),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(smoothWindow) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'smoothWindow',FLOAT(smoothWindow),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(includeNoConsecData) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'includeNoConsecData',BYTE(includeNoConsecData),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(earliest_UTC) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'earliest_UTC',DOUBLE(earliest_UTC),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(latest_UTC) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'latest_UTC',DOUBLE(latest_UTC),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(earliest_julDay) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'earliest_julDay',DOUBLE(earliest_julDay),/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(latest_julDay) GT 0 THEN BEGIN
        STR_ELEMENT,IMF_struct,'latest_julDay',DOUBLE(latest_julDay),/ADD_REPLACE
     ENDIF

  ENDIF

END