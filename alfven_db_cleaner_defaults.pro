  ;; mag current cutoffs
  magc_hcutOff = 5.0e2          ;junks 245 events above, 256 below
  ;; magc_hcutOff = 8.0e2
  ;; magc_hcutOff = 1.0e4           ;junks 36 events with sample_freq restriction
  ;; magc_lcutOff = -1.0e3 ;
  
  ;; delta_B cutoffs
  ;; dB_hcutOff = 1.0e3            ;junks 190 events
  ;; dB_lcutOff = -1.0e3 ;
  dB_hcutOff = 1.0e4            ;junks 3 events when including restriction on sample frequency
  ;; dB_lcutOff = -1.0e4 ;
  dB_lcutOff = 0. ;already all neg anyway
  ;;  dB_lcutOff = 0.0 ; Below zero should be garbage?
  

  ;; delta_E cutoffs
  dE_hcutoff = 1.0e3            ;junks 328 events
  ;; dE_lcutoff = -5.0e3
  dE_lcutoff = 0
  ;; dE_lcutoff = 0.0              ; Below zero should be garbage?
  
  ;; losscone electron flux cutoffs
  ;; ef_lc_integ_hcutoff = 1.0e7   ;junks 191 events
  ;; ef_lc_integ_lcutoff = -1.0e7
  ;; ef_lc_integ_hcutoff = 1.0e9   ;junks 139 events
  ;; ef_lc_integ_lcutoff = -1.0e9
  ef_lc_integ_hcutoff = 1.0e12   ;junks 19 events, or 2 with sample-frequency restriction
  ;; ef_lc_integ_lcutoff = -1.0e13  ;junks 20 events, or 0 with sample-frequency restriction
  ef_lc_integ_lcutoff = 0.  ;junks 20 events, or 0 with sample-frequency restriction
  
  ;; electron energy flux cutoffs
  ;; 2015/08/19
  ;; NOTE: For Dartmouth DBs, 'maximus.elec_energy_flux' only takes on absurd values for elec_energy_flux < 0
  ;; However, in the original Chaston DB, 'maximus.elec_energy_flux' takes on perfectly reasonable values and has a reasonable
  ;; distribution for elec_energy_flux < 0, generally ABS(maximus.elec_energy_flux) in ChastDB is < 10^2.
  elec_ef_hcutoff = 1.5e2       ;junks 284 events. NOTE, units are ergs-cm^(-2)-s^(-1). 
                                ;1e3 ergs corresponds to ~6x10^14 eV, and Nakajima et al. [2008]
                                ;  call FAST observations of eflux > 10^12 eV-cm^(-2)-s^(-1)
                                ;  "remarkable"; in short this cutoff gives plenty of room for good data.


  elec_ef_lcutoff = 0.0         ;because less than zero is garbage, right?
  
  ;; max characteristic electron energy cutoffs
  max_chare_hcutoff = 3.0e4
  max_chare_lcutoff = 0.0  
  
  ;; ion flux cutoffs
  iflux_hcutoff = 8.0e11
  ;; iflux_lcutoff = -8.0e11
  iflux_lcutoff = 0.
  
  ;; ion energy flux cutoffs
  ieflux_hcutoff = 5.0e1
  ieflux_hcutoff = 110          ;highest event is 106.78, I believe
  ieflux_lcutoff = 0.0          ;below zero is junk, eh?
  
  ;; upward ion flux cutoffs
  iflux_up_hcutoff = 1.0e12     ;changed from 1.0e11 2016/01/04. 
  iflux_up_lcutoff = 0.0   
  
  ;; characteristic ion energy cutoffs
  char_ion_e_hcutoff = 1.0e6
  ;; char_ion_e_lcutoff = 1.0e-2  
  ;; char_ion_e_lcutoff = -2.5e4
  char_ion_e_lcutoff = 0
  
  ;; cutoffs for sample_t, fields instrument
  ;; 512 Hz
  ;; sample_t_hcutoff = 0.0023
  ;; sample_t_lcutoff = 0.0014

  ;; 128 Hz
  ;; sample_t_hcutoff = 0.009
  ;; sample_t_lcutoff = 0.007

  ;; 32 Hz
  ;; sample_t_hcutoff = 0.033
  ;; sample_t_lcutoff = 0.029

  ;; 8 Hz
  ;; sample_t_hcutoff = 0.120
  ;; sample_t_lcutoff = 0.030

  ;; < 0.8 Hz, which is too small
  ;; sample_t_hcutoff = 1.25

  ;; < 100 Hz—exclude all of these per meeting with Professor LaBelle 2015/05/28
  sample_t_hcutoff = 0.01

  ;; Keep all with sample rate > 5 Hz, which is good (I hope) 
  ;; --> IT ISN'T! Try the following:
  ;; cghistoplot,maximus.width_time(where(maximus.sample_t LE 0.01)),maxinput=4
  ;; cghistoplot,maximus.width_time(where(maximus.sample_t LE 0.1)),maxinput=4
  ;; cghistoplot,maximus.width_time(where(maximus.sample_t LE 0.2)),maxinput=4
  ;; sample_t_hcutoff = 0.2
  
  ;;Cutoff for width_time (FAST spin period is 4.946 s)
  ;;Is it valid to cut it off at half a spin period? Perhaps not ...
  ;; width_t_cutoff = 4.946*0.5
  width_t_cutoff = 2.5
  ;; width_t_cutoff = 20


  ;;just to be safe
  mlt_hcutoff = 24
  mlt_lcutoff = 0

  ilat_hcutoff = 90
  ilat_lcutoff = -90

  orbit_hcutoff = 16361
  orbit_lcutoff = 500

  fieldsmode_lcutoff = 0

  ;;2016/11/28 Conservatismo

  ;; prod = 'eflux_losscone_integ'
  ;; ;; prod = 'elec_energy_flux'
  ;; ;; prod = 'max_chare_losscone'
  ;; ;; prod = 'delta_e'
  ;; ;; prod = 'ION_ENERGY_FLUX'
  ;; ;; prod = 'ION_FLUX_UP'
  ;; ;; prod = 'ESA_CURRENT'
  ;; ;; prod = 'MAG_CURRENT' 
  ;; ;; prosjent = 99.5
  ;; prosjent = 99.9
  ;; ;; prosjent = 99.0
  ;; STR_ELEMENT,maximus,prod,INDEX=ind 
  ;; above_i = GET_INDICES_ABOVE_PERCENT_THRESHOLD(ABS(maximus.(ind)), $
  ;;                                               prosjent, $
  ;;                                               OUT_FINAL_VAL=val, $
  ;;                                               COMPLEMENT_I=below_i, $
  ;;                                               /NAN) 
  ;; PRINT,prod,':',val 
  ;; abbel = LIST(TEMPORARY(above_i),TEMPORARY(below_i))
  ;; PRINT,"Minmax above: ",MIN(maximus.(ind)[abbel[0]]),MAX(maximus.(ind)[abbel[0]])
  ;; PRINT,"Minmax below: ",MIN(maximus.(ind)[abbel[1]]),MAX(maximus.(ind)[abbel[1]])

  ;; !P.MULTI = [0,1,2,0,0] 
  ;; CGHISTOPLOT,(keyword_set(log) ? ALOG10(maximus.(ind)[abbel[0]]) : maximus.(ind)[abbel[0]]), $
  ;;             TITLE=prod+" (top " + STRCOMPRESS(prosjent,/REMOVE_ALL) + "%)" 
  ;; CGHISTOPLOT,(keyword_set(log) ? ALOG10(maximus.(ind)[abbel[1]]) : maximus.(ind)[abbel[1]])

  ;; magc_hcutOff = 87.3           ;junk 0.5%
  ;; esac_hcutOff = 75.12          ; junk 0.5%

  ;; magc_hcutOff = 117.           ;junk 0.25%
  ;; esac_hcutOff = 112          ; junk 0.2%

  magc_hcutOff = 159.           ;junk 0.1%
  esac_hcutOff = 159.         ; junk 0.1%

  ;; magc_hcutOff = 87.3           ;junk 0.5%
  ;; esac_hcutOff = 75.12          ; junk 0.5%

  ;; magc_hcutOff = 65.01          ;junk 1.0%
  ;; esac_hcutOff = 53.34          ; junk 1.0%

  ;; ef_lc_integ_hcutoff = 1.0e5   ;junks 2% of all events
  ;; elec_ef_hcutoff = 30.         ;Tossing out top 1%
  ;; iflux_hcutoff = 6.96e9        ;junk top 0.5%
  ;; ieflux_hcutoff = 0.178        ;Drops 0.5%

  ef_lc_integ_hcutoff = 1.58e6   ;junks 0.1% of all events
