;+
;2015/11/27
;This pro is coming about because it has come to my attention that there are myriad
; discrepancies in the sign convention used from one flux quantity to the other in the 
; Alfven wave DB. 
;
;;;;;;;;;;;;;;;;;;;;;
;Modification history
;;;;;;;;;;;;;;;;;;;;;
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
;2015/12/22
;Added MAP_PFLUX_TO_IONOS keyword, based on my recent work to collect mapping ratios.
;This is represented in pros such as LOAD_MAPPING_RATIO, and the SDT batch job in the folder
;map_Poyntingflux_20151217.
;Added DO_DESPUNDB keyword.
;-
PRO CORRECT_ALFVENDB_FLUXES,maximus, $
                            MAP_PFLUX_TO_IONOS=map_pflux, $
                            DO_DESPUNDB=do_despunDB, $
                            LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  IF N_ELEMENTS(map_pflux) EQ 0 THEN BEGIN
     map_pflux = 1
  ENDIF

  IS_STRUCT_ALFVENDB_OR_FASTLOC,maximus,is_maximus

  ;;Find out if correction is applicable
  IF is_maximus THEN BEGIN
     IF TAG_EXIST(maximus,"CORRECTED_FLUXES") THEN BEGIN
        IF maximus.corrected_fluxes THEN BEGIN
           do_correction = 0
        ENDIF ELSE BEGIN
           do_correction = 1
        ENDELSE
     ENDIF ELSE BEGIN
        do_correction = 1
     ENDELSE
  ENDIF ELSE BEGIN
     PRINTF,lun,"Can't correct Alfven DB fluxes! This isn't a FAST Alfvén wave database..."
     do_correction = 0
  ENDELSE

  ;;Perform correction if so
  IF do_correction THEN BEGIN
     north_i = WHERE(maximus.ilat GT 0)
     south_i = WHERE(maximus.ilat LT 0)

     PRINTF,lun,"Corrected the following: "

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;ELECTRONS--Earthward flow is positive

     PRINTF,lun,"ELECTRONS: Earthward flow is positive"

     ;;07-ESA_CURRENT
     maximus.esa_current[north_i] = -1 * maximus.esa_current[north_i]
     PRINTF,lun,'07-ESA_CURRENT             (Flip sign in N Hemi)'
     
     ;;08-ELEC_ENERGY_FLUX 
     ;;Max energy flux from losscone
     ;;Mapped to the ionosphere
     PRINTF,lun,'08-ELEC_ENERGY_FLUX        (Earthward is positive per AS5)'

     ;;09-INTEG_ELEC_ENERGY_FLUX ALREADY HANDLED BY AS5
     ;;Not really integrated--just max energy flux from all angles as opposed to losscone
     ;;Mapped to ionosphere
     PRINTF,lun,'09-INTEG_ELEC_ENERGY_FLUX  (Earthward is positive per AS5)'

     ;;10-EFLUX_LOSSCONE_INTEG
     ;;Truly integrated over Alfven interval, mapped to ionosphere
     maximus.eflux_losscone_integ[south_i] = -1 * maximus.eflux_losscone_integ[south_i]
     PRINTF,lun,'10-EFLUX_LOSSCONE_INTEG    (Flip sign in S Hemi)'

     ;;11-TOTAL_EFLUX_INTEG
     ;;field-aligned energy flux Integrated over all angles, mapped to ionosphere
     maximus.total_eflux_integ[south_i] = -1 * maximus.total_eflux_integ[south_i]
     PRINTF,lun,'11-TOTAL_EFLUX_INTEG       (Flip sign in S Hemi)'

     ;;12-MAX_CHARE_LOSSCONE
     PRINTF,lun,'12-MAX_CHARE_LOSSCONE      (All positive because AS5 uses MAX)'

     ;;13-MAX_CHARE_TOTAL
     PRINTF,lun,'13-MAX_CHARE_TOTAL         (Some negs because we divide e- energy flux by e- flux)'

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;IONS--outflow is positive

     PRINTF,lun,'IONS: Outflow is positive'

     ;;14-ION_ENERGY_FLUX use abs val
     PRINTF,lun,'14-ION_ENERGY_FLUX         (Abs. val. of energy flux per AS5, so already all pos)'

     ;;15-ION_FLUX
     ;;old
     ;; maximus.ion_flux[north_i] = -1 * maximus.ion_flux[north_i]
     ;; PRINTF,lun,'ION_FLUX             (Flip sign in N Hemi)'
     ;;new
     maximus.ion_flux[south_i] = -1 * maximus.ion_flux[south_i]
     PRINTF,lun,'15-ION_FLUX                (Flip sign in S Hemi)'
     
     ;;16-ION_FLUX_UP uses abs val
     PRINTF,lun,'16-ION_FLUX_UP             (Abs. val. per AS5, so all positive)'
     
     ;;17-INTEG_ION_FLUX
     ;;old
     ;; maximus.integ_ion_flux[south_i] = -1 * maximus.integ_ion_flux[south_i]
     ;; PRINTF,lun,'17-INTEG_ION_FLUX          (Flip sign in S Hemi)'
     ;;new
     maximus.integ_ion_flux[north_i] = -1 * maximus.integ_ion_flux[north_i]
     PRINTF,lun,'17-INTEG_ION_FLUX          (Flip sign in N Hemi)'

     ;;18-INTEG_ION_FLUX_UP
     ;;old
     ;; maximus.integ_ion_flux_up[south_i] = -1 *maximus.integ_ion_flux_up[south_i]
     ;; PRINTF,lun,'18-INTEG_ION_FLUX_UP       (Flip sign in S Hemi)'
     ;;new
     maximus.integ_ion_flux_up[north_i] = -1 *maximus.integ_ion_flux_up[north_i]
     PRINTF,lun,'18-INTEG_ION_FLUX_UP       (Flip sign in N Hemi)'

     ;;19-CHAR_ION_ENERGY--what to do?
     PRINTF,lun,'19-CHAR_ION_ENERGY         (In AS5, division of two quantities where hemi is not accounted for--how to interpret sign?)'


     ;;Added 2015/12/22
     IF KEYWORD_SET(map_pflux) THEN BEGIN
        PRINTF,lun,'49-PFLUXEST                Map to ionosphere, multiplying by B_100km/B_alt'
        LOAD_MAPPING_RATIO_DB,mapRatio, $
                              DO_DESPUNDB=do_despunDB
        maximus.pFluxEst = maximus.pFluxEst * mapRatio.ratio
     ENDIF

     ;;Now add the CORRECTED_FLUXES tag to maximus
     ;; maximus=CREATE_STRUCT(NAME='maximus',maximus,'CORRECTED_FLUXES',1)     
     maximus=CREATE_STRUCT(maximus,'CORRECTED_FLUXES',1)     
     PRINTF,lun,'...Finished correcting fluxes in Alfvén DB!'

  ENDIF ELSE BEGIN
     PRINTF,lun,'Alfvén DB fluxes have already been corrected! Not correcting...'
  ENDELSE

END