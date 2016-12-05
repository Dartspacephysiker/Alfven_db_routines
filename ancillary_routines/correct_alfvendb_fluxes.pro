;+
;2015/11/27
;This pro is coming about because it has come to my attention that there are myriad
; discrepancies in the sign convention used from one flux quantity to the other in the 
; Alfven wave DB. 
;
;;;;;;;;;;;;;;;;;;;;;
;Modification history
;;;;;;;;;;;;;;;;;;;;;
;2016/01/13
;Now we have this ritzy despun database, and I want to correct the fluxes of the heavy ion species.
; If you check out JOURNAL__20160113__SUP_WITH_DESPUN_ION_DATA, you'll see where I get the idea
; that we need to correct heavy ions the same way that we correct the ion ESA data.

;2015/12/03
;Added whether or not each quantity is mapped to the ionosphere below, as well as to 
; the titles of the plots given by GET_FLUX_PLOTDATA
;2015/11/30
;There's a new sheriff in town. Here's the deal (see 20151130--flux_conventions--electrons_down--ions_up.txt):
;************
;*Electrons 
;>(no correction relative to 20151127 needed--already corrects to make Earthward positive)
;
;>07-ESA_CURRENT                : Flip sign in N Hemi
;>08-ELEC_ENERGY_FLUX           : No correction, done in AS5
;>09-INTEG_ELEC_ENERGY_FLUX     : No correction, done in AS5
;>10-EFLUX_LOSSCONE_INTEG       : Flip sign in S Hemi
;>11-TOTAL_EFLUX_INTEG          : Flip sign in S Hemi
;>12-MAX_CHARE_LOSSCONE         : How to handle? Already all positive
;>13-MAX_CHARE_TOTAL            : How to handle? I believe there are sign issues
;
;*************
;*Ions
;>14-ION_ENERGY_FLUX            : Absolute value of energy flux, so already all positive
;
;PREVIOUS: >15-ION_FLUX                   : Flip sign in N Hemi
;NEW     : >15-ION_FLUX                   : Flip sign in S Hemi
;
;>16-ION_FLUX_UP                : How to handle? Already all positive
;
;PREVIOUS:>17-INTEG_ION_FLUX             : Flip sign in S Hemi
;NEW     :>17-INTEG_ION_FLUX             : Flip sign in N Hemi
;
;PREVIOUS:>18-INTEG_ION_FLUX_UP          : Flip sign in S Hemi
;NEW     :>18-INTEG_ION_FLUX_UP          : Flip sign in N Hemi
;
;>19-CHAR_ION_ENERGY            : How to handle? Division of two quantities where hemi isn't accounted for
;
;;;;;;;;;;;;;;;
;2015/11/27
;Please see 20151127--why_flux_is_so_weird_in_Alfven_DB.txt
;
;The convention being implemented for electrons is the same used by Chaston for 
;electrons--downward (earthward) is always positive.
;For ions, I am using the convention that outflow is positive.
;
;Here is a summary from the text file mentioned above
;>07-ESA_CURRENT                : Flip sign in N Hemi
;>08-ELEC_ENERGY_FLUX           : No correction, done in AS5
;>09-INTEG_ELEC_ENERGY_FLUX     : No correction, done in AS5
;>10-EFLUX_LOSSCONE_INTEG       : Flip sign in S Hemi
;>11-TOTAL_EFLUX_INTEG          : Flip sign in S Hemi
;>12-MAX_CHARE_LOSSCONE         : How to handle? Already all positive
;>13-MAX_CHARE_TOTAL            : How to handle? I believe there are sign issues
;
;*Ions
;>14-ION_ENERGY_FLUX            : Absolute value of energy flux, so already all positive
;>15-ION_FLUX                   : Flip sign in N Hemi
;>16-ION_FLUX_UP                : How to handle? Already all positive
;>17-INTEG_ION_FLUX             : Flip sign in S Hemi
;>18-INTEG_ION_FLUX_UP          : Flip sign in S Hemi
;>19-CHAR_ION_ENERGY            : How to handle? Division of two quantities where hemi isn't
;>accounted for
;
;
;2016/04/23
;Adding MAP_ESA_CURRENT keyword since I'd like to look at e- number fluxes
;
;2015/12/22
;Added MAP_PFLUX_TO_IONOS keyword, based on my recent work to collect mapping ratios.
;This is represented in pros such as LOAD_MAPPING_RATIO, and the SDT batch job in the folder
;map_Poyntingflux_20151217.
;Added DESPUNDB keyword.
;
;2016/01/13
;Adding stuff for heavy ions, since the new despun DB can do dat
;2016/01/26 Added MAP_HEAVIES keyword
;2016/01/27 Added MAP_IONFLUX keyword
;2016/02/23 Added MAP_WIDTH_X keyword so we can use it with the integrated data
;2016/02/23 Added correctStr so I can see at any time what's been corrected
;2016/03/15 Having misgivings about mapping width_x, so I've commented it out for now.
;2016/07/18 Wow, missing a factor of two in dividing Poynting flux.
;-
PRO CORRECT_ALFVENDB_FLUXES,maximus, $
                            MAP_ESA_CURRENT_TO_IONOS=map_esa_current, $
                            MAP_PFLUX_TO_IONOS=map_pflux, $
                            DESPUNDB=despunDB, $
                            CHASTDB=chastDB, $
                            USING_HEAVIES=using_heavies, $
                            MAP_HEAVIES_TO_IONOS=map_heavies, $
                            MAP_IONFLUX_TO_IONOS=map_ionflux, $
                            MAP_WIDTH_T_TO_IONOS=map_width_t, $
                            ;; MAP_WIDTH_X_TO_IONOS=map_width_x, $
                            QUIET=quiet, $
                            LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  IF N_ELEMENTS(map_pflux) EQ 0 THEN BEGIN
     map_pflux                     = 1
  ENDIF
  
  IF N_ELEMENTS(map_ionflux) EQ 0 THEN BEGIN
     map_ionflux                   = 1
  ENDIF

  IF N_ELEMENTS(map_heavies) EQ 0 THEN  BEGIN
     map_heavies                   = 1
  ENDIF

  IF N_ELEMENTS(map_width_t) EQ 0 THEN BEGIN
     map_width_t                   = 1
  ENDIF
  
  IS_STRUCT_ALFVENDB_OR_FASTLOC,maximus,is_maximus

  ;;Find out if correction is applicable
  IF is_maximus THEN BEGIN
     IF TAG_EXIST(maximus,"CORRECTED_FLUXES") THEN BEGIN
        IF maximus.info.corrected_fluxes THEN BEGIN
           do_correction           = 0
        ENDIF ELSE BEGIN
           do_correction           = 1
        ENDELSE
     ENDIF ELSE BEGIN
        do_correction              = 1
     ENDELSE
  ENDIF ELSE BEGIN
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,"Can't correct Alfven DB fluxes! This isn't a FAST Alfvén wave database..."
     do_correction                 = 0
  ENDELSE

  ;;Perform correction if so
  IF do_correction THEN BEGIN
     north_i                       = WHERE(maximus.ilat GT 0)
     south_i                       = WHERE(maximus.ilat LT 0)

     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,"Corrected the following: "
     correctStr = "Corrected the following: " + STRING(10B)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;ELECTRONS--Earthward flow is positive

     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,"ELECTRONS: Earthward flow is positive"
     correctStr += "ELECTRONS: Earthward flow is positive" + STRING(10B)

     ;;07-ESA_CURRENT
     maximus.esa_current[north_i]  = -1 * maximus.esa_current[north_i]
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'07-ESA_CURRENT             (Flip sign in N Hemi)'
     correctStr += '07-ESA_CURRENT             (Flip sign in N Hemi)' + STRING(10B)
     
     ;;08-ELEC_ENERGY_FLUX 
     ;;Max energy flux from losscone
     ;;Mapped to the ionosphere
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'08-ELEC_ENERGY_FLUX        (Earthward is positive per AS5)'
     correctStr += '08-ELEC_ENERGY_FLUX        (Earthward is positive per AS5)' + STRING(10B)

     ;;09-INTEG_ELEC_ENERGY_FLUX ALREADY HANDLED BY AS5
     ;;Not really integrated--just max energy flux from all angles as opposed to losscone
     ;;Mapped to ionosphere
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'09-INTEG_ELEC_ENERGY_FLUX  (Earthward is positive per AS5)'
     correctStr += '09-INTEG_ELEC_ENERGY_FLUX  (Earthward is positive per AS5)' + STRING(10B)

     IF ~KEYWORD_SET(chastDB) THEN BEGIN

        ;;10-EFLUX_LOSSCONE_INTEG
        ;;Truly integrated over Alfven interval, mapped to ionosphere
        maximus.eflux_losscone_integ[south_i] = -1 * maximus.eflux_losscone_integ[south_i]
        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'10-EFLUX_LOSSCONE_INTEG    (Flip sign in S Hemi)'
        correctStr += '10-EFLUX_LOSSCONE_INTEG    (Flip sign in S Hemi)' + STRING(10B)

     ;;11-TOTAL_EFLUX_INTEG
     ;;Field-aligned energy flux (with contrib. from ALL angles) that is then mapped to ionosphere
     maximus.total_eflux_integ[south_i] = -1 * maximus.total_eflux_integ[south_i]
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'11-TOTAL_EFLUX_INTEG       (Flip sign in S Hemi)'
     correctStr += '11-TOTAL_EFLUX_INTEG       (Flip sign in S Hemi)' + STRING(10B)

     ENDIF;;  ELSE BEGIN

     ;;    maximus.integ_elec_energy_flux[south_i] = -1 * maximus.integ_elec_energy_flux[south_i]
     ;;    IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'10-EFLUX_LOSSCONE_INTEG    (Flip sign in S Hemi)'
     ;;    correctStr += '10-INTEG_ELEC_ENERGY_FLUX  (Flip sign in S Hemi)' + STRING(10B)
     ;; ENDELSE



     ;;12-MAX_CHARE_LOSSCONE
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'12-MAX_CHARE_LOSSCONE      (All positive because AS5 uses MAX)'
     correctStr += '12-MAX_CHARE_LOSSCONE      (All positive because AS5 uses MAX)' + STRING(10B)

     ;;13-MAX_CHARE_TOTAL
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'13-MAX_CHARE_TOTAL         (Some negs because we divide e- energy flux by e- flux)'
     correctStr += '13-MAX_CHARE_TOTAL         (Some negs because we divide e- energy flux by e- flux)' + STRING(10B)

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;IONS--outflow is positive

     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'IONS: Outflow is positive'
     correctStr += 'IONS: Outflow is positive' + STRING(10B)

     ;;14-ION_ENERGY_FLUX use abs val
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'14-ION_ENERGY_FLUX         (Abs. val. of energy flux per AS5, so already all pos)'
     correctStr += '14-ION_ENERGY_FLUX         (Abs. val. of energy flux per AS5, so already all pos)' + STRING(10B)

     ;;15-ION_FLUX
     ;;old
     ;; maximus.ion_flux[north_i] = -1 * maximus.ion_flux[north_i]
     ;; IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'ION_FLUX             (Flip sign in N Hemi)'
     ;;new
     maximus.ion_flux[south_i]     = -1 * maximus.ion_flux[south_i]
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'15-ION_FLUX                (Flip sign in S Hemi)'
     correctStr += '15-ION_FLUX                (Flip sign in S Hemi)' + STRING(10B)
     
     ;;16-ION_FLUX_UP uses abs val
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'16-ION_FLUX_UP             (Abs. val. per AS5, so all positive)'
     correctStr += '16-ION_FLUX_UP             (Abs. val. per AS5, so all positive)' + STRING(10B)
     
     ;;17-INTEG_ION_FLUX
     ;;old
     ;; maximus.integ_ion_flux[south_i] = -1 * maximus.integ_ion_flux[south_i]
     ;; IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'17-INTEG_ION_FLUX          (Flip sign in S Hemi)'
     ;;new
     maximus.integ_ion_flux             =  100 * maximus.integ_ion_flux
     maximus.integ_ion_flux[north_i]    =   -1 * maximus.integ_ion_flux[north_i]
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'17-INTEG_ION_FLUX          (Flip sign in N Hemi, scale to #/cm-s)'
     correctStr += '17-INTEG_ION_FLUX          (Flip sign in N Hemi, scale to #/cm-s)' + STRING(10B)

     ;;18-INTEG_ION_FLUX_UP
     ;;old
     ;; maximus.integ_ion_flux_up[south_i] = -1 *maximus.integ_ion_flux_up[south_i]
     ;; IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'18-INTEG_ION_FLUX_UP       (Flip sign in S Hemi)'
     ;;new
     maximus.integ_ion_flux_up          =  100 * maximus.integ_ion_flux_up
     maximus.integ_ion_flux_up[north_i] =   -1 * maximus.integ_ion_flux_up[north_i]
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'18-INTEG_ION_FLUX_UP       (Flip sign in N Hemi, scale to #/cm-s)'
     correctStr += '18-INTEG_ION_FLUX_UP       (Flip sign in N Hemi, scale to #/cm-s)' + STRING(10B)

     ;;19-CHAR_ION_ENERGY--what to do?
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'19-CHAR_ION_ENERGY         (In AS5, division of two quantities where hemi is not accounted for--how to interpret sign?)'
     correctStr += '19-CHAR_ION_ENERGY         (In AS5, division of two quantities where hemi is not accounted for--how to interpret sign?)' + STRING(10B)

     IF KEYWORD_SET(map_heavies) OR KEYWORD_SET(map_pflux) OR KEYWORD_SET(map_ionflux) THEN BEGIN
        LOAD_MAPPING_RATIO_DB,mapRatio, $
                              DESPUNDB=despunDB, $
                              CHASTDB=chastDB

        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,"***Mapped the following to the ionosphere, multiplying by B_100km/B_alt"
        correctStr += "***Mapped the following to the ionosphere, multiplying by B_100km/B_alt" + STRING(10B)
     ENDIF

     IF KEYWORD_SET(using_heavies) THEN BEGIN

     ;;26-PROTON_FLUX_UP
        maximus.proton_flux_up[north_i] = -1 * maximus.proton_flux_up[north_i]
        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'26-PROTON_FLUX_UP             (Flip sign in N Hemi)'
        correctStr += '26-PROTON_FLUX_UP             (Flip sign in N Hemi)' + STRING(10B)

     ;;28-OXY_FLUX_UP
        maximus.oxy_flux_up[north_i] = -1 * maximus.oxy_flux_up[north_i]
        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'28-OXY_FLUX_UP                (Flip sign in N Hemi)'
        correctStr += '28-OXY_FLUX_UP                (Flip sign in N Hemi)' + STRING(10B)

     ;;30-HELIUM_FLUX_UP
        maximus.helium_flux_up[north_i] = -1 * maximus.helium_flux_up[north_i]
        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'30-HELIUM_FLUX_UP             (Flip sign in N Hemi)'
        correctStr += '30-HELIUM_FLUX_UP             (Flip sign in N Hemi)' + STRING(10B)

        IF KEYWORD_SET(map_heavies) THEN BEGIN
           maximus.proton_flux_up = maximus.proton_flux_up  * mapRatio.ratio
           maximus.oxy_flux_up    = maximus.oxy_flux_up     * mapRatio.ratio
           maximus.helium_flux_up = maximus.helium_flux_up  * mapRatio.ratio
           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'-->26-PROTON_FLUX_UP'
           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'-->28-OXY_FLUX_UP'
           IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'-->30-HELIUM_FLUX_UP'
           correctStr += '-->26-PROTON_FLUX_UP' + STRING(10B)
           correctStr += '-->28-OXY_FLUX_UP' + STRING(10B)
           correctStr += '-->30-HELIUM_FLUX_UP' + STRING(10B)

           maximus.info.mapped.heavies = 1
        ENDIF
     ENDIF

     ;;Added 2016/04/23
     IF KEYWORD_SET(map_esa_current) THEN BEGIN
        maximus.esa_current       = maximus.esa_current * mapRatio.ratio
        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'-->07-ESA_CURRENT'
        correctStr += '-->07-ESA_CURRENT' + STRING(10B)

        maximus.info.mapped.esa_current = 1
     ENDIF

     ;;Added 2015/12/22
     mu_0                         = DOUBLE(4.0D*!PI*1e-7)

     pfluxest                     = DOUBLE((maximus.delta_e)*(maximus.delta_b*1e-9))/(2.D*mu_0) ;rm factor of 1e-3 from E-field since we want mW/m^2

     CASE 1 OF
        KEYWORD_SET(chastDB): BEGIN
           maximus                = CREATE_STRUCT(maximus,'pFluxEst',pFluxEst)
        END
        ELSE: BEGIN
           maximus.pfluxest       = pFluxEst
        END
     ENDCASE

     IF KEYWORD_SET(map_pflux) THEN BEGIN
        maximus.pFluxEst          = maximus.pFluxEst         * mapRatio.ratio
        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'-->49-PFLUXEST'
        correctStr += '-->49-PFLUXEST' + STRING(10B)

        maximus.info.mapped.pFlux = 1
     ENDIF

     IF KEYWORD_SET(map_ionflux) THEN BEGIN
        maximus.ion_energy_flux   = maximus.ion_energy_flux  * mapRatio.ratio
        maximus.ion_flux          = maximus.ion_flux         * mapRatio.ratio
        maximus.ion_flux_up       = maximus.ion_flux_up      * mapRatio.ratio
        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'-->15-ION_FLUX'
        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'-->16-ION_FLUX_UP'
        correctStr += '-->15-ION_FLUX' + STRING(10B)
        correctStr += '-->16-ION_FLUX_UP' + STRING(10B)

        maximus.info.mapped.ion_flux = 1
     ENDIF

     IF KEYWORD_SET(map_width_t) THEN BEGIN
        maximus.sample_t          = maximus.width_time   / SQRT(mapRatio.ratio)
        IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'-->20-WIDTH_TIME'
        correctStr += '-->20-WIDTH_TIME' + STRING(10B)

        maximus.info.mapped.width_time = 1
     ENDIF

     ;; IF KEYWORD_SET(map_width_x) THEN BEGIN
     ;;    maximus.width_x           = maximus.width_x * mapRatio.ratio
     ;;    IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'-->21-WIDTH_X'
     ;;    correctStr += '-->21-WIDTH_X' + STRING(10B)
     ;; ENDIF

     ;;Now add the CORRECTED_FLUXES tag to maximus
     ;; maximus=CREATE_STRUCT(NAME='maximus',maximus,'CORRECTED_FLUXES',1)     
     ;; IF TAG_EXIST(maximus,'info') THEN BEGIN
     maximus.info.corrected_fluxes = 1B
     maximus.info.corrected_string = correctStr
     ;; ENDIF ELSE BEGIN
     ;;    maximus                = CREATE_STRUCT(maximus,'CORRECTED_FLUXES',1,'CORRECTED_STRING',correctStr)
     ;; ENDELSE
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'...Finished correcting fluxes in Alfvén DB!'

  ENDIF ELSE BEGIN
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'Alfvén DB fluxes have already been corrected! Not correcting...'
  ENDELSE

END