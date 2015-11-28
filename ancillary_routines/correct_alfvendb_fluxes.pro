;2015/11/28
;This pro is coming about because it has come to my attention that there are myriad
; discrepancies in the sign convention used from one flux quantity to the other in the 
; Alfven wave DB. Please see 20151127--why_flux_is_so_weird_in_Alfven_DB.txt
;
;The convention being implemented is the same used by Chaston for electrons--downward 
; (earthward) is always positive.
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
;>19-CHAR_ION_ENERGY            : How to handle? Division of two quantities where hemi isn't acco
PRO CORRECT_ALFVENDB_FLUXES,maximus, $
                            LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

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

     ;;ESA_CURRENT
     maximus.esa_current[north_i] = -1 * maximus.esa_current[north_i]
     PRINTF,lun,"ESA_CURRENT          (Flip sign in N Hemi)"
     
     ;;ELEC_ENERGY_FLUX AND INTEG_ELEC_ENERGY_FLUX ALREADY HANDLED BY AS5

     ;;EFLUX_LOSSCONE_INTEG
     maximus.eflux_losscone_integ[south_i] = -1 * maximus.eflux_losscone_integ[south_i]
     PRINTF,lun,"EFLUX_LOSSCONE_INTEG (Flip sign in S Hemi)"

     ;;TOTAL_EFLUX_INTEG
     maximus.total_eflux_integ[south_i] = -1 * maximus.total_eflux_integ[south_i]
     PRINTF,lun,"TOTAL_EFLUX_INTEG    (Flip sign in S Hemi)"

     ;;12 and 13 not clear what to do; all good, I suppose?

     ;;ION_ENERGY_FLUX use abs val

     ;;ION_FLUX
     maximus.ion_flux[north_i] = -1 * maximus.ion_flux[north_i]
     PRINTF,lun,"ION_FLUX             (Flip sign in N Hemi)"
     
     ;;ION_FLUX_UP uses abs val
     
     ;;INTEG_ION_FLUX
     maximus.integ_ion_flux[south_i] = -1 * maximus.integ_ion_flux[south_i]
     PRINTF,lun,"INTEG_ION_FLUX       (Flip sign in S Hemi)"

     ;;INTEG_ION_FLUX_UP
     maximus.integ_ion_flux_up[south_i] = -1 *maximus.integ_ion_flux_up[south_i]
     PRINTF,lun,"INTEG_ION_FLUX_UP    (Flip sign in S Hemi)"

     ;;CHAR_ION_ENERGY--what to do?

     ;;Now add the CORRECTED_FLUXES tag to maximus
     maximus=CREATE_STRUCT(NAME="maximus",maximus,"CORRECTED_FLUXES",1)     
     PRINTF,lun,"...Finished correcting fluxes in Alfvén DB!"

  ENDIF ELSE BEGIN
     PRINTF,lun,"Alfvén DB fluxes have already been corrected! Not correcting..."
  ENDELSE

END