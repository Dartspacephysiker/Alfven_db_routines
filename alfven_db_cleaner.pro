;+
; NAME:                  ALFVEN_DB_CLEANER
;
; PURPOSE:               Get rid of all those nasty NaNs and huge values in various quanitities.
;                        I've been meaning to write such a function for a while. This is finally being precipitated by a
;                        discussion with Professor LaBelle I had while traveling from the MIT Haystack Observatory.
;
; CALLING SEQUENCE:      good_indices = alfven_db_cleaner(maximus)
;
; INPUTS:                Maximus
;
; OUTPUTS:
;
; MODIFICATION HISTORY:  
; 2015/10/20    Incorporating BASIC_DB_CLEANER routine here to try to keep some uniformity between the Alfven wave DB and the FAST
;               ephemeris DB.
; 2015/08/19    A bunch of limits got changed yesterday. I think I include more extreme events, but based on the distributions of the
;                 relevant quantities, they don't seem to be physically unreasonable.
; 2015/08/18    Thought about adding specific keyword so that ChastDB gets treated on its own each time.

; 02/14/2015 Born  
;; Note, there are also several bad measurements of TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT,
;;   TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX, TOTAL_ION_OUTFLOW_MULTIPLE_TOT, TOTAL_ALFVEN_ION_OUTFLOW, 
;;   TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT, TOTAL_ALFVEN_UPWARD_ION_OUTFLOW
;; I never use these quantities, so I'm ignoring their NaNs.
;; 2016/01/13 New USING_HEAVIES keyword for times when TEAMS data are coming into play
; 
;; 2016/05/04 New SAMPLE_T_RESTRICTION keyword, in case we want to lighten the requirement
;-

FUNCTION ALFVEN_DB_CLEANER,maximus,IS_CHASTDB=is_chastDB, $
                           SAMPLE_T_RESTRICTION=sample_t_restriction, $
                           DO_LSHELL=DO_lshell, $
                           USING_HEAVIES=using_heavies, $
                           INCLUDE_32HZ=include_32Hz, $
                           DISREGARD_SAMPLE_T=disregard_sample_t, $
                           LUN=lun

  COMPILE_OPT idl2

  ;;If not lun, just send to stdout
  IF NOT KEYWORD_SET(lun) THEN lun = -1

  ;;First make sure maximus is present
  IF N_ELEMENTS(maximus) EQ 0 THEN BEGIN
     PRINTF,lun,"No such structure as maximus! Can't clean up Alfven database."
     PRINTF,lun,"Returning..."
     ;; RETURN, !NULL
     RETURN, !NULL
  ENDIF

  @alfven_db_cleaner_defaults.pro

  n_events = N_ELEMENTS(maximus.orbit)
  good_i   = BASIC_DB_CLEANER(maximus,DO_CHASTDB=is_chastDB, $
                              /CLEAN_NANS_AND_INFINITIES, $
                              SAMPLE_T_RESTRICTION=sample_t_restriction, $
                              INCLUDE_32Hz=include_32Hz, $
                              DISREGARD_SAMPLE_T=disregard_sample_t, $
                              DO_LSHELL=DO_lshell, $
                              USING_HEAVIES=using_heavies)

  nAft    = N_ELEMENTS(good_i)
  n_basic = nAft

  ;;*********
  ;;Keywords*
  ;;*********
  IF KEYWORD_SET(sample_t_restriction) THEN BEGIN
     PRINTF,lun,"Using sample_t restriction specified by user!"
     PRINTF,lun,STRING(FORMAT='("Sample_t_hcutoff = ",G0.3," s")',sample_t_restriction)
     sample_t_hcutoff = sample_t_restriction
  ENDIF


                                ;**********
                                ;   NaNs  *
                                ;**********

  ;; IF ~KEYWORD_SET(IS_CHASTDB) THEN BEGIN
  ;;    ;; Get rid of junk in various dangerous quantities we might be using
  
  ;;    ;;number of events in total
  ;;    ;; n_events = N_ELEMENTS(maximus.alfvenic)
  
  ;;    ;; Cutoff values
  
  ;;    ;;Gots to be alfvenic
  ;;    alfvenic=1

  ;;    ;; alfvenicness
  ;;    ;; good_i = WHERE(maximus.alfvenic GT 0.1,/NULL )
  
  ;;    ;; delta Bs and delta Es
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.delta_B),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.delta_E),/NULL))
  
  ;;    ;; Now electron stuff
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.elec_energy_flux),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.integ_elec_energy_flux),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.eflux_losscone_integ),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.total_eflux_integ),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.max_chare_losscone),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.max_chare_total),/NULL))
  
  ;;    ;; Now ion stuff
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.ion_energy_flux),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.ion_flux),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.ion_flux_up),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.integ_ion_flux),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.integ_ion_flux_up),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.char_ion_energy),/NULL))
  
  ;; ENDIF ELSE BEGIN

  ;;    n_events = N_ELEMENTS(maximus.time)
  ;;    ;; delta Bs and delta Es
  ;;    ;; good_i = indgen(n_events,/L64)
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.delta_B),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.delta_E),/NULL))
  
  ;;    ;; Now electron stuff
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.elec_energy_flux),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.integ_elec_energy_flux),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.char_elec_energy),/NULL))
  
  ;;    ;; Now ion stuff
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.ion_energy_flux),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.ion_flux),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.ion_flux_up),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.integ_ion_flux),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.integ_ion_flux_up),/NULL))
  ;;    ;; good_i = cgsetintersection(good_i,WHERE(FINITE(maximus.char_ion_energy),/NULL))

  ;; ENDELSE

  PRINTF,lun,""
  PRINTF,lun,"****ALFVEN_DB_CLEANER****"

  ;; nlost = n_events-N_ELEMENTS(good_i)
  ;; PRINTF,lun,FORMAT='("N lost to NaNs, infinities    :",T35,I0)',nlost
  ;; n_events -=nlost
  
                                ;******************
                                ;   Other limits  *
                                ;******************
  
  IF ~KEYWORD_SET(is_chastDB) THEN BEGIN
     ;;No delta_Bs above any absurd values
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE(abs(maximus.mag_current) LE magc_hcutOff,/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"MAG_CURRENT",nBef-nAft

     ;; nBef   = nAft
     ;; good_i = CGSETINTERSECTION(good_i, $
     ;;                            WHERE(ABS(maximus.esa_current) LE esac_hcutOff,/NULL), $
     ;;                            COUNT=nAft, $
     ;;                            NORESULT=-1)
     ;; IF good_i[0] EQ -1 THEN STOP
     ;; PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"ESA_CURRENT",nBef-nAft
     
     ;;No delta_Bs above any absurd values
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((maximus.delta_b LE dB_hcutOff) AND $
                                      (maximus.delta_b GT dB_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"DELTA_B",nBef-nAft
     
     ;;No delta_Es above any absurd values
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((maximus.delta_e LE dE_hcutOff) AND $
                                      (maximus.delta_e GT dE_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"DELTA_E",nBef-nAft

     ;;No losscone e- fluxes with any absurd values
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((maximus.eflux_losscone_integ LE ef_lc_integ_hcutOff) AND $
                                      (maximus.eflux_losscone_integ GT ef_lc_integ_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"INTEG_ELEC_ENERGY_FLUX",nBef-nAft

     ;;No absurd electron energy fluxes ;At least for the dartDBs, negative values are absurd (like 10^-8, 10^-9--total garbage)
     ;;  nBef   = nAft
     ;; good_i = CGSETINTERSECTION(good_i, $
     ;;                            WHERE((maximus.elec_energy_flux LE elec_ef_hcutOff) AND $
     ;;                                  (maximus.elec_energy_flux GT elec_ef_lcutoff),/NULL), $
     ;;                            COUNT=nAft, $
     ;;                            NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP 

     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((maximus.elec_energy_flux LE elec_ef_hcutOff) AND $
                                      (maximus.elec_energy_flux GT elec_ef_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP 
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"ELEC_ENERGY_FLUX",nBef-nAft

     ;;No absurd characteristic electron energies
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((maximus.max_chare_losscone LE max_chare_hcutOff) AND $
                                      (maximus.max_chare_losscone GT max_chare_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP 
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"CHAR_ELEC_ENERGY_FLUX",nBef-nAft
     
     ;;No absurd ion fluxes
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((maximus.ion_flux LE iflux_hcutOff) AND $
                                      (maximus.ion_flux GT iflux_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP 
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"ION_FLUX",nBef-nAft

     ;;No weird ion energy fluxes
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((maximus.ion_energy_flux LE ieflux_hcutOff) AND $
                                      (maximus.ion_energy_flux GT ieflux_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP 
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"ION_ENERGY_FLUX",nBef-nAft

     ;;No wonky upward ion fluxes
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((maximus.ion_flux_up LE iflux_up_hcutOff) AND $
                                      (maximus.ion_flux_up GT iflux_up_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP 
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"ION_FLUX_UP",nBef-nAft

     ;;No weird characteristic ion energies
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((ABS(maximus.char_ion_energy) LE char_ion_e_hcutOff) AND $
                                      (ABS(maximus.char_ion_energy) GT char_ion_e_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP 
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"CHAR_ION_ENERGY",nBef-nAft

     ;; Now sample_t stuff
     noSampTRestriction = KEYWORD_SET(disregard_sample_t)
     IF ~noSampTRestriction THEN BEGIN
        IF N_ELEMENTS(sample_t_restriction) GT 0 THEN BEGIN
           noSampTRestriction = sample_t_restriction EQ 0
        ENDIF
     ENDIF

     nBef  = nAft
     CASE 1 OF
        ((N_ELEMENTS(sample_t_restriction) GT 0) OR $
         (KEYWORD_SET(disregard_sample_t))): BEGIN
           IF noSampTRestriction THEN BEGIN
              PRINT,'Screening by sample_t disabled ...'
           ENDIF ELSE BEGIN
              good_i = CGSETINTERSECTION(good_i, $
                                         WHERE(ABS(maximus.sample_t) LE sample_t_hcutoff,/NULL), $
                                         COUNT=nAft, $
                                         NORESULT=-1)
              IF good_i[0] EQ -1 THEN STOP
              PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"SAMPLE_T",nBef-nAft
           ENDELSE

           ;;And I guess we screen by width_t in any case
           widthTDat = maximus.width_time
           IF maximus.info.mapped.width_time THEN BEGIN
              PRINT,"Temporarily unmapping width time for screening ..."
              LOAD_MAPPING_RATIO_DB,mapRatio, $
                                    DESPUNDB=maximus.info.despun, $
                                    CHASTDB=maximus.info.is_chastDB
              widthTDat *= SQRT((TEMPORARY(mapRatio)).ratio)
           ENDIF

           CASE 1 OF
              maximus.info.dILAT_not_dt: BEGIN
                 PRINT,"Screening maximus filament widths based on dILAT, not dt"
                 width_t_cutoff = 2.
              END
              maximus.info.dAngle_not_dt: BEGIN
                 PRINT,"Screening maximus filament widths based on dAngle, not dt"
                 width_t_cutoff = 2.
              END
              maximus.info.dx_not_dt: BEGIN
                 PRINT,"Screening maximus filament widths based on dx, not dt"
                 PRINT,"Need to decide what's appropriate in this case ..."
                 STOP
                 width_t_cutoff = 2.
              END
           ENDCASE

           good_i = CGSETINTERSECTION(good_i, $
                                      WHERE(widthTDat LE width_t_cutoff,/NULL), $
                                      COUNT=nKept,NORESULT=-1)
           IF good_i[0] EQ -1 THEN STOP
           PRINT,"Lost " + STRCOMPRESS(nBef-nKept,/REMOVE_ALL) + ' events to width_t cutoff ...'
           
        END
        KEYWORD_SET(include_32Hz): BEGIN

           width128_cutoff = 2.5  ; 1./(128/20.)
           width32_cutoff  = 0.63 ; 1./(32/20.)

           Hz32_i  = WHERE((ABS(maximus.sample_t - 0.03125) LT 0.003) AND $
                           (maximus.width_time LE width32_cutoff),nHz32,/NULL)

           Hz128_i = WHERE((ABS(maximus.sample_t) LE sample_t_hcutoff) AND $
                           (maximus.width_time LE width128_cutoff),nHz128,/NULL)


           PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"sample_t & width_time (128/32Hz)",nBef-nAft
           good_i  = CGSETINTERSECTION(good_i,CGSETUNION(Hz32_i,Hz128_i))

        END
        ELSE: BEGIN
           good_i = CGSETINTERSECTION(good_i, $
                                      WHERE(ABS(maximus.sample_t) LE sample_t_hcutoff,/NULL),COUNT=nAft)
           PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"WIDTH_TIME",nBef-nAft

           nBef   = nAft
           good_i = CGSETINTERSECTION(good_i, $
                                      WHERE(maximus.width_time LE width_t_cutoff,/NULL),COUNT=nAft)

           PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"WIDTH_TIME",nBef-nAft
        END
     ENDCASE
     

     ;; for i=0,N_ELEMENTS(max_tags)-1 do begin
     ;;    nkept=N_ELEMENTS(WHERE(FINITE(maximus.(i)),NCOMPLEMENT=nlost))
     ;;    PRINTF,lun,"Maximus." + max_tags(i) + " is causing us to lose " + strcompress(nlost,/REMOVE_ALL) + " events." 
     ;; endfor

  ENDIF ELSE BEGIN

     ;;No currents above any absurd values
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE(ABS(maximus.mag_current) LE magc_hcutOff,/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"MAG_CURRENT",nBef-nAft
     ;;NEW 20161128
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE(ABS(maximus.esa_current) LE esac_hcutOff,/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"ESA_CURRENT",nBef-nAft
     
     ;;No delta_Bs above any absurd values
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((maximus.delta_b LE dB_hcutOff) AND $
                                      (maximus.delta_b GT dB_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"DELTA_B",nBef-nAft
     
     ;;No delta_Es above any absurd values
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((maximus.delta_e LE dE_hcutOff) AND $
                                      (maximus.delta_e GT dE_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"DELTA_E",nBef-nAft

     ;;No losscone e- fluxes with any absurd values
     ;;  nBef   = nAft
     ;; good_i = CGSETINTERSECTION(good_i, $
     ;;                            WHERE((maximus.integ_elec_energy_flux LE ef_lc_integ_hcutOff) AND $
     ;;                                  (maximus.integ_elec_energy_flux GT ef_lc_integ_lcutoff),/NULL), $
     ;;                            COUNT=nAft, $
     ;;                            NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP

     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE(ABS(maximus.integ_elec_energy_flux) LE ef_lc_integ_hcutOff,/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"INTEG_ELEC_ENERGY_FLUX",nBef-nAft

     ;;No absurd electron energy fluxes
     ;;  nBef   = nAft
     ;; good_i = CGSETINTERSECTION(good_i, $
     ;;                            WHERE((maximus.elec_energy_flux LE elec_ef_hcutOff) AND $
     ;;                                  (maximus.elec_energy_flux GT elec_ef_lcutoff),/NULL), $
     ;;                            COUNT=nAft, $
     ;;                            NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP 
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE(ABS(maximus.elec_energy_flux) LE elec_ef_hcutOff,/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP 
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"ELEC_ENERGY_FLUX",nBef-nAft

     ;;No absurd characteristic electron energies
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((maximus.char_elec_energy LE max_chare_hcutOff) AND $
                                      (maximus.char_elec_energy GT max_chare_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP 
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"CHAR_ELEC_ENERGY_FLUX",nBef-nAft
     
     ;;No absurd ion fluxes
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((maximus.ion_flux LE iflux_hcutOff) AND $
                                      (maximus.ion_flux GT iflux_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP 
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"ION_FLUX",nBef-nAft

     ;;No weird ion energy fluxes
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((maximus.ion_energy_flux LE ieflux_hcutOff) AND $
                                      (maximus.ion_energy_flux GT ieflux_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP 
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"ION_ENERGY_FLUX",nBef-nAft

     ;;No wonky upward ion fluxes
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((maximus.ion_flux_up LE iflux_up_hcutOff) AND $
                                      (maximus.ion_flux_up GT iflux_up_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP 
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"ION_FLUX_UP",nBef-nAft

     ;;No weird characteristic ion energies
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE((maximus.char_ion_energy LE char_ion_e_hcutOff) AND $
                                      (maximus.char_ion_energy GT char_ion_e_lcutoff),/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP 
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"CHAR_ION_ENERGY",nBef-nAft

     ;; Now sample_t stuff
     ;;This is screwed up in the original DB; MODE = SAMPLE_T and SAMPLE_T = MODE
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE(maximus.mode LE sample_t_hcutoff,/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"SAMPLE_T",nBef-nAft

     ;;Remove that spin-plane stuff
     nBef   = nAft
     good_i = CGSETINTERSECTION(good_i, $
                                WHERE(maximus.width_time LE width_t_cutoff,/NULL), $
                                COUNT=nAft, $
                                NORESULT=-1)
     IF good_i[0] EQ -1 THEN STOP
     PRINTF,lun,FORMAT='("N lost to cutoff in ",A-30," : ",I0)',"WIDTH_TIME",nBef-nAft

     ;; for i=0,N_ELEMENTS(max_tags)-1 do begin
     ;;    nkept=N_ELEMENTS(WHERE(FINITE(maximus.(i)),NCOMPLEMENT=nlost))
     ;;    printf,lun,"Maximus." + max_tags(i) + " is causing us to lose " + strcompress(nlost,/REMOVE_ALL) + " events." 
     ;; endfor

  ENDELSE

  nlost = n_basic-N_ELEMENTS(good_i)
  PRINTF,lun,FORMAT='("N lost to user-defined (besides basic) cutoffs:",T50,I0)', nlost

  PRINTF,lun,"****END ALFVEN_DB_CLEANER****"
  PRINTF,lun,""

  RETURN, good_i

END

;; ORBIT ALFVENIC TIME ALT MLT ILAT MAG_CURRENT ESA_CURRENT ELEC_ENERGY_FLUX
;; INTEG_ELEC_ENERGY_FLUX EFLUX_LOSSCONE_INTEG TOTAL_EFLUX_INTEG MAX_CHARE_LOSSCONE
;; MAX_CHARE_TOTAL ION_ENERGY_FLUX ION_FLUX ION_FLUX_UP INTEG_ION_FLUX
;; INTEG_ION_FLUX_UP CHAR_ION_ENERGY WIDTH_TIME WIDTH_X DELTA_B DELTA_E SAMPLE_T
;; MODE PROTON_FLUX_UP PROTON_CHAR_ENERGY OXY_FLUX_UP OXY_CHAR_ENERGY
;; HELIUM_FLUX_UP HELIUM_CHAR_ENERGY SC_POT L_PROBE MAX_L_PROBE MIN_L_PROBE
;; MEDIAN_L_PROBE TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE
;; TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX
;; TOTAL_ION_OUTFLOW_SINGLE TOTAL_ION_OUTFLOW_MULTIPLE_TOT TOTAL_ALFVEN_ION_OUTFLOW
;; TOTAL_UPWARD_ION_OUTFLOW_SINGLE TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT
;; TOTAL_ALFVEN_UPWARD_ION_OUTFLOW


;; for i=0,N_ELEMENTS(max_tags)-1 do begin & $
;;     nkept=N_ELEMENTS(WHERE(FINITE(maximus.(i)),NCOMPLEMENT=nlost)) & $
;;     printf,lun,"Maximus." + max_tags(i) + " is causing us to lose " + strcompress(nlost,/REMOVE_ALL) + " events." & $
;; endfor
;; Maximus.ORBIT is causing us to lose 0 events.
;; Maximus.ALFVENIC is causing us to lose 0 events.
;; Maximus.TIME is causing us to lose 0 events.
;; Maximus.ALT is causing us to lose 0 events.
;; Maximus.MLT is causing us to lose 0 events.
;; Maximus.ILAT is causing us to lose 0 events.
;; Maximus.MAG_CURRENT is causing us to lose 0 events.
;; Maximus.ESA_CURRENT is causing us to lose 0 events.
;; Maximus.ELEC_ENERGY_FLUX is causing us to lose 1 events.
;; Maximus.INTEG_ELEC_ENERGY_FLUX is causing us to lose 0 events.
;; Maximus.EFLUX_LOSSCONE_INTEG is causing us to lose 903 events.
;; Maximus.TOTAL_EFLUX_INTEG is causing us to lose 903 events.
;; Maximus.MAX_CHARE_LOSSCONE is causing us to lose 2 events.
;; Maximus.MAX_CHARE_TOTAL is causing us to lose 0 events.
;; Maximus.ION_ENERGY_FLUX is causing us to lose 0 events.
;; Maximus.ION_FLUX is causing us to lose 45 events.
;; Maximus.ION_FLUX_UP is causing us to lose 0 events.
;; Maximus.INTEG_ION_FLUX is causing us to lose 956 events.
;; Maximus.INTEG_ION_FLUX_UP is causing us to lose 956 events.
;; Maximus.CHAR_ION_ENERGY is causing us to lose 228 events.
;; Maximus.WIDTH_TIME is causing us to lose 0 events.
;; Maximus.WIDTH_X is causing us to lose 0 events.
;; Maximus.DELTA_B is causing us to lose 0 events.
;; Maximus.DELTA_E is causing us to lose 22890 events.
;; Maximus.SAMPLE_T is causing us to lose 0 events.
;; Maximus.MODE is causing us to lose 0 events.
;; Maximus.PROTON_FLUX_UP is causing us to lose 0 events.
;; Maximus.PROTON_CHAR_ENERGY is causing us to lose 0 events.
;; Maximus.OXY_FLUX_UP is causing us to lose 0 events.
;; Maximus.OXY_CHAR_ENERGY is causing us to lose 0 events.
;; Maximus.HELIUM_FLUX_UP is causing us to lose 0 events.
;; Maximus.HELIUM_CHAR_ENERGY is causing us to lose 0 events.
;; Maximus.SC_POT is causing us to lose 0 events.
;; Maximus.L_PROBE is causing us to lose 0 events.
;; Maximus.MAX_L_PROBE is causing us to lose 733774 events.
;; Maximus.MIN_L_PROBE is causing us to lose 733774 events.
;; Maximus.MEDIAN_L_PROBE is causing us to lose 733773 events.
;; Maximus.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE is causing us to lose 0 events.
;; Maximus.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT is causing us to lose 60446 events.
;; Maximus.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX is causing us to lose 10245 events.
;; Maximus.TOTAL_ION_OUTFLOW_SINGLE is causing us to lose 0 events.
;; Maximus.TOTAL_ION_OUTFLOW_MULTIPLE_TOT is causing us to lose 67864 events.
;; Maximus.TOTAL_ALFVEN_ION_OUTFLOW is causing us to lose 10039 events.
;; Maximus.TOTAL_UPWARD_ION_OUTFLOW_SINGLE is causing us to lose 0 events.
;; Maximus.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT is causing us to lose 67864 events.
;; Maximus.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW is causing us to lose 10039 events.

;; max_tags=tag_names(maximus)
;; for i=0,N_ELEMENTS(max_tags)-1 do begin 
;;    nkept=N_ELEMENTS(WHERE(FINITE(maximus.(i)),NCOMPLEMENT=nlost)) 
;;    printf,lun,"Maximus." + max_tags(i) + " is causing us to lose " + strcompress(nlost,/REMOVE_ALL) + " events." 
;; endfor