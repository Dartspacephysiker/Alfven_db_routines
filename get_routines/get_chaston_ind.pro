;***********************************************
;This script merely accesses the ACE and Chaston
;current filaments databases in order to generate
;Created 01/08/2014
;See 'current_event_Poynt_flux_vs_imf.pro' for
;more info, since that's where this code comes from.

;2015/10/15 Added L-shell stuff
;2015/10/09 Overhauling so that this can be used for time histos or Alfven DB structures
;2015/08/15 Added NO_BURSTDATA keyword
;2015/10/19 Added PRINT_PARAM_SUMMARY keyword
;2015/12/28 There are a bunch of weird sample_t values in fastloc. I'm junking them in fastloc_cleaner.
;2016/01/07 Added DESPUNDB keyword to let us get dat despun database
;2016/01/13 Added USING_HEAVIES keyword for those magical times when personen wants to use TEAMS data
;2016/06/13 Added FOR_ESPEC_DBS keywords so we can use this routine for the eSpec and ion DBs
FUNCTION GET_CHASTON_IND,dbStruct,satellite,lun, $
                         DBFILE=dbfile, $
                         DBTIMES=dbTimes, $
                         CHASTDB=chastDB, $
                         DESPUNDB=despunDB, $
                         ORBRANGE=orbRange, $
                         ALTITUDERANGE=altitudeRange, $
                         CHARERANGE=charERange, $
                         POYNTRANGE=poyntRange, $
                         BOTH_HEMIS=both_hemis, $
                         NORTH=north, $
                         SOUTH=south, $
                         HEMI=hemi, $
                         HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                         MINMLT=minM,MAXMLT=maxM,BINM=binM, $
                         MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                         DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                         COORDINATE_SYSTEM=coordinate_system, $
                         USE_AACGM_COORDS=use_aacgm, $
                         USE_MAG_COORDS=use_mag, $
                         MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                         SAMPLE_T_RESTRICTION=sample_t_restriction, $
                         INCLUDE_32HZ=include_32Hz, $
                         DAYSIDE=dayside,NIGHTSIDE=nightside, $
                         USING_HEAVIES=using_heavies, $
                         NO_BURSTDATA=no_burstData, $
                         GET_TIME_I_NOT_ALFVENDB_I=get_time_i, $
                         GET_ALFVENDB_I=get_alfvendb_i, $
                         CORRECT_FLUXES=correct_fluxes, $
                         RESET_GOOD_INDS=reset_good_inds, $
                         DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                         PRINT_PARAM_SUMMARY=print_param_summary, $
                         FASTLOC_DELTA_T=fastloc_delta_t, $
                         OUT_MAXIMUS=out_maximus, $
                         OUT_CDBTIME=out_cdbTime, $
                         OUT_DELTA_T_FASTLOC=out_delta_t_fastLoc, $
                         OUT_TIMES_FASTLOC=out_times_fastLoc, $
                         OUT_FASTLOC=out_fastloc, $
                         FOR_ESPEC_DBS=for_eSpec_DBs, $
                         DONT_LOAD_IN_MEMORY=nonMem
                         
  COMPILE_OPT idl2
 
  @common__mlt_ilat_magc_etc.pro

  ;;LOAD_MAXIMUS_AND_CDBTIME is the other routine with this block
  @common__maximus_vars.pro

  ;;Defined here, in GET_FASTLOC_INDS_IMF_CONDS_V2, and in GET_FASLOC_INDS_UTC_RANGE
  @common__fastloc_vars.pro

  ;; IF ~KEYWORD_SET(nonMem) THEN BEGIN
  @common__fastloc_espec_vars.pro

  ;; ENDIF ELSE BEGIN
  ;;    FL_eSpec__fastLoc                   = !NULL
  ;;    FASTLOC_E__times                    = !NULL
  ;;    FASTLOC_E__delta_t                  = !NULL
  ;;    FASTLOC_E__dbFile                   = !NULL
  ;;    FASTLOC_E__dbTimesFile              = !NULL
  ;; ENDELSE

  ;For statistical auroral oval
  defHwMAurOval                                   = 0
  defHwMKpInd                                     = 7

  defLun                                          = -1

  ;; defPrintSummary                              = 0

  IF ~KEYWORD_SET(lun) THEN lun                   = defLun ;stdout

  IF ~KEYWORD_SET(do_not_set_defaults) THEN BEGIN
     SET_DEFAULT_MLT_ILAT_AND_MAGC,MINMLT=minM,MAXMLT=maxM,BINM=binM, $
                                   MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                   MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                   MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                                   HEMI=hemi, $
                                   BOTH_HEMIS=both_hemis, $
                                   NORTH=north, $
                                   SOUTH=south, $
                                   LUN=lun
  ENDIF

  ;;;;;;;;;;;;;;;
  ;;Check whether this is a maximus or fastloc struct
  IF KEYWORD_SET(dbStruct) THEN BEGIN
     IF KEYWORD_SET(get_time_i) THEN BEGIN
        is_maximus                                = 0
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(get_alfvendb_i) THEN BEGIN
           is_maximus                             = 1
        ENDIF ELSE BEGIN
           IS_STRUCT_ALFVENDB_OR_FASTLOC,dbStruct,is_maximus
        ENDELSE
     ENDELSE
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(get_time_i) THEN BEGIN
        is_maximus                                = 0
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(get_alfvendb_i) THEN BEGIN
           is_maximus                             = 1
        ENDIF
     ENDELSE
  ENDELSE

  IF ~KEYWORD_SET(get_alfvendb_i) AND ~KEYWORD_SET(get_time_i) AND ~KEYWORD_SET(dbStruct) THEN BEGIN
     PRINTF,lun,"Assuming this is maximus ..."
     is_maximus                                   = 1             ;We assume this is maximus
  ENDIF

  ;;Get the databases if they're already in mem
  IF is_maximus THEN BEGIN
     IF N_ELEMENTS(MAXIMUS__maximus) NE 0 AND N_ELEMENTS(MAXIMUS__times) NE 0 THEN BEGIN
        dbStruct                                  = MAXIMUS__maximus
        dbTimes                                   = MAXIMUS__times
        dbFile                                    = MAXIMUS__dbFile
        dbTimesFile                               = MAXIMUS__dbTimesFile
     ENDIF ELSE BEGIN
        IF N_ELEMENTS(correct_fluxes) EQ 0 THEN BEGIN
           IF N_ELEMENTS(dbStruct) GT 0 THEN BEGIN
              PRINTF,lun,'GET_CHASTON_IND: Not attempting to correct fluxes since dbStruct already loaded ...'
              correct_fluxes                      = 0
           ENDIF ELSE BEGIN
              correct_fluxes                      = 1
           ENDELSE
        ENDIF
        LOAD_MAXIMUS_AND_CDBTIME,dbStruct,dbTimes, $
                                 DBDIR=loaddataDir, $
                                 DBFILE=dbFile, $
                                 DB_TFILE=dbTimesFile, $
                                 ;; DO_NOT_MAP_ANYTHING=no_mapping, $
                                 DO_CHASTDB=chastDB, $
                                 DO_DESPUNDB=despunDB, $
                                 COORDINATE_SYSTEM=coordinate_system, $
                                 USE_AACGM_COORDS=use_aacgm, $
                                 USE_MAG_COORDS=use_mag, $
                                 CORRECT_FLUXES=correct_fluxes
        MAXIMUS__maximus                          = dbStruct
        MAXIMUS__times                            = dbTimes
        MAXIMUS__dbFile                           = dbFile
        MAXIMUS__dbTimesFile                      = dbTimesFile
        MIMC__despunDB                            = KEYWORD_SET(despunDB)
        MIMC__chastDB                             = KEYWORD_SET(chastDB)
     ENDELSE
  ENDIF ELSE BEGIN
     CASE 1 OF
        KEYWORD_SET(for_eSpec_DBs): BEGIN
           IF ~KEYWORD_SET(nonMem) THEN BEGIN
              IF N_ELEMENTS(FL_eSpec__fastLoc) NE 0 AND N_ELEMENTS(FASTLOC_E__times) NE 0 THEN BEGIN
                 dbStruct                         = FL_eSpec__fastLoc
                 dbTimes                          = FASTLOC_E__times
                 fastloc_delta_t                  = FASTLOC_E__delta_t
                 dbFile                           = FASTLOC_E__dbFile
                 dbTimesFile                      = FASTLOC_E__dbTimesFile
                 loadFL                           = 0
              ENDIF ELSE BEGIN
                 loadFL                           = 1
              ENDELSE
           ENDIF ELSE BEGIN
              loadFL                              = 1
           ENDELSE
        END
        ELSE: BEGIN
           IF N_ELEMENTS(FL__fastLoc) NE 0 AND $
              N_ELEMENTS(FASTLOC__times) NE 0 AND $
              N_ELEMENTS(FASTLOC__delta_t) NE 0 $
           THEN BEGIN
              dbStruct                            = FL__fastLoc
              dbTimes                             = FASTLOC__times
              fastloc_delta_t                     = FASTLOC__delta_t
              dbFile                              = FASTLOC__dbFile
              dbTimesFile                         = FASTLOC__dbTimesFile
              loadFL                              = 0
           ENDIF ELSE BEGIN
              loadFL                              = 1
           ENDELSE
        END
     ENDCASE

     IF loadFL THEN BEGIN
        LOAD_FASTLOC_AND_FASTLOC_TIMES,dbStruct,dbTimes,fastloc_delta_t, $
                                       DBDIR=loaddataDir, $
                                       DBFILE=dbFile, $
                                       DB_TFILE=dbTimesFile, $
                                       COORDINATE_SYSTEM=coordinate_system, $
                                       INCLUDE_32HZ=include_32Hz, $
                                       USE_AACGM_COORDS=use_aacgm, $
                                       USE_MAG_COORDS=use_mag, $
                                       FOR_ESPEC_DBS=for_eSpec_DBs
        IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
           IF ~KEYWORD_SET(nonMem) THEN BEGIN
              FL_eSpec__fastLoc                   = dbStruct
              FASTLOC_E__times                    = dbTimes
              FASTLOC_E__delta_t                  = fastloc_delta_t
              FASTLOC_E__dbFile                   = dbFile
              FASTLOC_E__dbTimesFile              = dbTimesFile
           ENDIF
        ENDIF ELSE BEGIN
           FL__fastLoc                            = dbStruct
           FASTLOC__times                         = dbTimes
           FASTLOC__delta_t                       = fastloc_delta_t
           FASTLOC__dbFile                        = dbFile
           FASTLOC__dbTimesFile                   = dbTimesFile
        ENDELSE
     ENDIF ELSE BEGIN
     ENDELSE
  ENDELSE

  ;;Now check to see whether we have the appropriate vars for each guy
  IF ~is_maximus THEN BEGIN
     have_good_i                                  = KEYWORD_SET(for_eSpec_DBs) ? KEYWORD_SET(FASTLOC_E_HAVE_GOOD_I) : KEYWORD_SET(FASTLOC__HAVE_GOOD_I)
     n_good_i                                     = KEYWORD_SET(for_eSpec_DBs) ? N_ELEMENTS(FASTLOC_E_good_i) : N_ELEMENTS(FASTLOC__good_i)
     IF ~have_good_i OR KEYWORD_SET(reset_good_inds) THEN BEGIN
        IF KEYWORD_SET(reset_good_inds) THEN BEGIN
           PRINT,'Resetting good fastLoc inds...'
        ENDIF
        calculate                                 = 1
     ENDIF ELSE BEGIN
        IF n_good_i NE 0 THEN BEGIN
           CHECK_FOR_NEW_IND_CONDS,is_maximus, $
                                   CHASTDB=chastDB, $
                                   DESPUNDB=despunDB, $
                                   ORBRANGE=orbRange, $
                                   ALTITUDERANGE=altitudeRange, $
                                   CHARERANGE=charERange, $
                                   POYNTRANGE=poyntRange, $
                                   BOTH_HEMIS=both_hemis, $
                                   NORTH=north, $
                                   SOUTH=south, $
                                   HEMI=hemi, $
                                   HWMAUROVAL=HwMAurOval, $
                                   HWMKPIND=HwMKpInd, $
                                   MINMLT=minM, $
                                   MAXMLT=maxM, $
                                   BINM=binM, $
                                   MINILAT=minI, $
                                   MAXILAT=maxI, $
                                   BINILAT=binI, $
                                   DO_LSHELL=do_lshell, $
                                   MINLSHELL=minL, $
                                   MAXLSHELL=maxL, $
                                   BINLSHELL=binL, $
                                   MIN_MAGCURRENT=minMC, $
                                   MAX_NEGMAGCURRENT=maxNegMC, $
                                   SAMPLE_T_RESTRICTION=sample_t_restriction, $
                                   INCLUDE_32HZ=include_32Hz, $
                                   DAYSIDE=dayside, $
                                   NIGHTSIDE=nightside, $
                                   HAVE_GOOD_I=have_good_i, $
                                   LUN=lun
           calculate                              = MIMC__RECALCULATE
           MAXIMUS__HAVE_GOOD_I                   = have_good_i
           IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
              IF ~KEYWORD_SET(nonMem) THEN BEGIN
                 FASTLOC_E__HAVE_GOOD_I           = have_good_i
              ENDIF
           ENDIF ELSE BEGIN
              FASTLOC__HAVE_GOOD_I                = have_good_i
           ENDELSE
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
              PRINT,'But you should already have FASTLOC_E__good_i!!'
           ENDIF ELSE BEGIN
              PRINT,'But you should already have FASTLOC__good_i!!'
           ENDELSE
           STOP
        ENDELSE
     ENDELSE
  ENDIF ELSE BEGIN
     IF ~KEYWORD_SET(MAXIMUS__HAVE_GOOD_I) OR KEYWORD_SET(reset_good_inds) THEN BEGIN
        IF KEYWORD_SET(reset_good_inds) THEN BEGIN
           PRINT,'Resetting good maximus inds...'
        ENDIF
        calculate                                 = 1
     ENDIF ELSE BEGIN
        IF N_ELEMENTS(MAXIMUS__good_i) NE 0 THEN BEGIN
           CHECK_FOR_NEW_IND_CONDS,is_maximus, $
                                   CHASTDB=chastDB, $
                                   DESPUNDB=despunDB, $
                                   ORBRANGE=orbRange, $
                                   ALTITUDERANGE=altitudeRange, $
                                   CHARERANGE=charERange, $
                                   POYNTRANGE=poyntRange, $
                                   BOTH_HEMIS=both_hemis, $
                                   NORTH=north, $
                                   SOUTH=south, $
                                   HEMI=hemi, $
                                   HWMAUROVAL=HwMAurOval, $
                                   HWMKPIND=HwMKpInd, $
                                   MINMLT=minM, $
                                   MAXMLT=maxM, $
                                   BINM=binM, $
                                   MINILAT=minI, $
                                   MAXILAT=maxI, $
                                   BINILAT=binI, $
                                   DO_LSHELL=do_lshell, $
                                   MINLSHELL=minL, $
                                   MAXLSHELL=maxL, $
                                   BINLSHELL=binL, $
                                   MIN_MAGCURRENT=minMC, $
                                   MAX_NEGMAGCURRENT=maxNegMC, $
                                   SAMPLE_T_RESTRICTION=sample_t_restriction, $
                                   INCLUDE_32HZ=include_32Hz, $
                                   DAYSIDE=dayside, $
                                   NIGHTSIDE=nightside, $
                                   HAVE_GOOD_I=have_good_i, $
                                   LUN=lun
           calculate                              = MIMC__RECALCULATE
           MAXIMUS__HAVE_GOOD_I                   = have_good_i
           IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
              IF ~KEYWORD_SET(nonMem) THEN BEGIN
                 FASTLOC_E__HAVE_GOOD_I           = have_good_i
              ENDIF 
           ENDIF ELSE BEGIN
              FASTLOC__HAVE_GOOD_I                = have_good_i
           ENDELSE
        ENDIF ELSE BEGIN
           PRINT,'But you should already have MAXIMUS__good_i!!'
           STOP
        ENDELSE
     ENDELSE
  ENDELSE

  IF KEYWORD_SET(calculate) THEN BEGIN

     IF ~KEYWORD_SET(HwMAurOval) THEN HwMAurOval  = defHwMAurOval
     IF ~KEYWORD_SET(HwMKpInd) THEN HwMKpInd      = defHwMKpInd


     ;;Welcome message
     PRINTF,lun,""
     PRINTF,lun,"****From GET_CHASTON_IND****"
     PRINTF,lun,FORMAT='("DBFile                        :",T35,A0)',dbFile
     PRINTF,lun,""

  ;;;;;;;;;;;;
     ;;Handle longitudes
     MIMC__minMLT                                 = minM
     MIMC__maxMLT                                 = maxM
     MIMC__binMLT                                 = binM
     MIMC__dayside                                = KEYWORD_SET(dayside)
     MIMC__nightside                              = KEYWORD_SET(nightside)
     mlt_i                                        = GET_MLT_INDS(dbStruct,MIMC__minMLT,MIMC__maxMLT, $
                                                                 DAYSIDE=MIMC__dayside,NIGHTSIDE=MIMC__nightside, $
                                                                 N_MLT=n_mlt,N_OUTSIDE_MLT=n_outside_MLT,LUN=lun)
     
     ;;;;;;;;;;;;
     ;;Handle latitudes, combine with mlt
     MIMC__hemi                                   = hemi
     MIMC__north                                  = KEYWORD_SET(north)
     MIMC__south                                  = KEYWORD_SET(south)
     MIMC__both_hemis                             = KEYWORD_SET(both_hemis)
     IF KEYWORD_SET(do_lShell) THEN BEGIN
        MIMC__minLshell                           = minL
        MIMC__maxLshell                           = maxL
        MIMC__binLshell                           = binL
        lshell_i                                  = GET_LSHELL_INDS(dbStruct,MIMC__minLshell,MIMC__maxLshell,MIMC__hemi, $
                                                                    N_LSHELL=n_lshell,N_NOT_LSHELL=n_not_lshell,LUN=lun)
        region_i                                  = CGSETINTERSECTION(lshell_i,mlt_i)
     ENDIF ELSE BEGIN
        MIMC__minILAT                             = minI
        MIMC__maxILAT                             = maxI
        MIMC__binILAT                             = binI
        ilat_i                                    = GET_ILAT_INDS(dbStruct,MIMC__minILAT,MIMC__maxILAT,MIMC__hemi, $
                                                                  N_ILAT=n_ilat,N_NOT_ILAT=n_not_ilat,LUN=lun)
        region_i                                  = CGSETINTERSECTION(ilat_i,mlt_i)
     ENDELSE

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;Want just Holzworth/Meng statistical auroral oval?
     IF HwMAurOval THEN region_i                  = CGSETINTERSECTION(region_i, $
                                                     WHERE(ABS(dbStruct.ilat) GT auroral_zone(dbStruct.mlt,HwMKpInd,/lat)/(!DPI)*180.))

  ;;;;;;;;;;;;;;;;;;;;;;
     ;;Now combine them all
     IF KEYWORD_SET(do_lShell) THEN BEGIN
     ENDIF ELSE BEGIN
     ENDELSE

     IF is_maximus THEN BEGIN
        MIMC__minMC                               = minMC
        MIMC__maxNegMC                            = maxNegMC
        magc_i                                    = GET_MAGC_INDS(dbStruct,MIMC__minMC,MIMC__maxNegMC, $
                                                                  N_OUTSIDE_MAGC=n_magc_outside_range)
        region_i                                  = CGSETINTERSECTION(region_i,magc_i)
     ENDIF

     
  ;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;Limits on orbits to use?
     IF KEYWORD_SET (orbRange) THEN BEGIN
        MIMC__orbRange                            = orbRange
        CASE N_ELEMENTS(orbRange) OF
           1: BEGIN
              MIMC__orbRange                      = [orbRange,orbRange]
           END
           2: BEGIN
              MIMC__orbRange                      = orbRange
           END
           ELSE: BEGIN
              PRINTF,lun,"Assuming you want me to believe you about this orbit array ..."
              is_orbArr                           = 1
              MIMC__orbRange                      = orbRange
              ;; PRINTF,lun,"Incorrect input for keyword 'orbRange'!!"
              ;; PRINTF,lun,"Please use orbRange=[minOrb maxOrb] or a single element"
              ;; RETURN, -1
           END
        ENDCASE
        ;; IF N_ELEMENTS(orbRange) EQ 2 THEN BEGIN

        IF KEYWORD_SET(is_orbArr) THEN BEGIN
           tmp_i                                  = CGSETINTERSECTION(dbStruct.orbit, $
                                                                      MIMC__orbRange, $
                                                                      POSITIONS=orb_i)
        ENDIF ELSE BEGIN
           orb_i                                  = GET_ORBRANGE_INDS(dbStruct,MIMC__orbRange[0],MIMC__orbRange[1],LUN=lun)
        ENDELSE

        IF orb_i[0] NE -1 THEN BEGIN
           region_i                               = CGSETINTERSECTION(region_i,orb_i)
        ENDIF ELSE BEGIN
           PRINTF,lun,'No orbs matching provided range!'
           STOP
        ENDELSE
        ;; ENDIF ELSE BEGIN
        ;; ENDELSE
     ENDIF
     

     ;;limits on altitudes to use?
     IF KEYWORD_SET (altitudeRange) THEN BEGIN
        MIMC__altitudeRange                       = altitudeRange
        IF N_ELEMENTS(altitudeRange) EQ 2 THEN BEGIN
           alt_i                                  = GET_ALTITUDE_INDS(dbStruct,MIMC__altitudeRange[0],MIMC__altitudeRange[1],LUN=lun)
           region_i                               = CGSETINTERSECTION(region_i,alt_i)
        ENDIF ELSE BEGIN
           PRINTF,lun,"Incorrect input for keyword 'altitudeRange'!!"
           PRINTF,lun,"Please use altitudeRange=[minAlt maxAlt]"
           RETURN, -1
        ENDELSE
     ENDIF
     
     ;; was using this to compare our Poynting flux estimates against Keiling et al. 2003 Fig. 3
     ;;limits on characteristic electron energies to use?
     IF KEYWORD_SET (charERange) AND is_maximus THEN BEGIN
        IF N_ELEMENTS(charERange) EQ 2 THEN BEGIN
           MIMC__charERange                       = charERange
           
           IF KEYWORD_SET(chastDB) THEN BEGIN
              chare_i                             = WHERE(dbStruct.char_elec_energy GE MIMC__charERange[0] AND $
                            dbStruct.char_elec_energy LE MIMC__charERange[1])
           ENDIF ELSE BEGIN
              chare_i                             = WHERE(dbStruct.max_chare_losscone GE MIMC__charERange[0] AND $
                            dbStruct.max_chare_losscone LE MIMC__charERange[1])
           ENDELSE
           region_i                               = CGSETINTERSECTION(region_i,chare_i)
        ENDIF ELSE BEGIN
           PRINTF,lun,"Incorrect input for keyword 'charERange'!!"
           PRINTF,lun,"Please use charERange=[minCharE maxCharE]"
           RETURN, -1
        ENDELSE
     ENDIF

     IF KEYWORD_SET (poyntRange) THEN BEGIN
        MIMC__poyntRange                          = poyntRange
        IF N_ELEMENTS(poyntRange) EQ 2 THEN BEGIN
           pFlux_i                                = GET_PFLUX_INDS(dbStruct,MIMC__poyntRange[0],MIMC__poyntRange[1],LUN=lun)
           region_i                               = CGSETINTERSECTION(region_i,pFlux_i)
        ENDIF ELSE BEGIN
           PRINTF,lun,"Incorrect input for keyword 'poyntRange'!!"
           PRINTF,lun,"Please use poyntRange=[minpFlux, maxpFlux]"
           RETURN, -1
        ENDELSE
     ENDIF

     ;; IF KEYWORD_SET(poyntRange) AND is_maximus THEN BEGIN
     ;;    MIMC__poyntRange                       = poyntRange
     ;;    IF N_ELEMENTS(poyntRange) NE 2 OR (MIMC__poyntRange[1] LE MIMC__poyntRange[0]) THEN BEGIN
     ;;       PRINT,"Invalid Poynting range specified! poyntRange should be a two-element vector, [minPoynt maxPoynt]"
     ;;       PRINT,"No Poynting range set..."
     ;;       RETURN, -1
     ;;    ENDIF ELSE BEGIN
     ;;       region_i=CGSETINTERSECTION(region_i,where(dbStruct.pFluxEst GE MIMC__poyntRange[0] AND $
     ;;                                             dbStruct.pFluxEst LE MIMC__poyntRange[1]))
     ;;       PRINTF,lun,FORMAT='("Poynting flux limits (eV)     :",T35,G8.2,T45,G8.2)',MIMC__poyntRange[0],MIMC__poyntRange[1]
     ;;    ENDELSE
     ;; ENDIF


     ;;gotta screen to make sure it's in ACE db too:
     ;;Only so many are useable, since ACE data start in 1998
     
     ;; IF KEYWORD_SET(satellite) THEN BEGIN
     ;;    sat_i                                     = GET_SATELLITE_INDS(dbStruct,satellite,LUN=lun)
     ;;    good_i                                    = region_i[where(region_i GE sat_i,nGood,complement=lost,ncomplement=nlost)]
     ;;    lost                                      = region_i[lost]
     ;; ENDIF ELSE BEGIN
        good_i                                    = region_i
     ;; ENDELSE

     ;;Now, clear out all the garbage (NaNs & Co.)
     IF is_maximus THEN BEGIN
        IF N_ELEMENTS(MAXIMUS__cleaned_i) EQ 0 THEN BEGIN
           MAXIMUS__cleaned_i                     = ALFVEN_DB_CLEANER(dbStruct,LUN=lun, $
                                                                      IS_CHASTDB=chastDB, $
                                                                      SAMPLE_T_RESTRICTION=sample_t_restriction, $
                                                                      INCLUDE_32Hz=include_32Hz, $
                                                                      DO_LSHELL=DO_lshell, $
                                                                      USING_HEAVIES=using_heavies)
           IF MAXIMUS__cleaned_i EQ !NULL THEN BEGIN
              PRINTF,lun,"Couldn't clean Alfvén DB! Sup with that?"
              STOP
           ENDIF ELSE BEGIN
           ENDELSE
        ENDIF
        good_i                                    = CGSETINTERSECTION(good_i,MAXIMUS__cleaned_i) 
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
           nClean                                 = N_ELEMENTS(FASTLOC_E__cleaned_i)
        ENDIF ELSE BEGIN
           nClean                                 = N_ELEMENTS(FASTLOC__cleaned_i)
        ENDELSE
        IF nClean EQ 0 THEN BEGIN
           IF KEYWORD_SET(for_eSpec_DBS) THEN BEGIN
              FASTLOC_E__cleaned_i                = FASTLOC_CLEANER(dbStruct, $
                                                                    /FOR_ESPEC_DBS, $
                                                                    INCLUDE_32Hz=include_32Hz, $
                                                                    LUN=lun)
              
              IF FASTLOC_E__cleaned_i EQ !NULL THEN BEGIN
                 PRINTF,lun,"Couldn't clean fastloc_eSpec DB! Sup with that?"
                 STOP
              ENDIF ELSE BEGIN
              ENDELSE
           ENDIF ELSE BEGIN
              FASTLOC__cleaned_i                  = FASTLOC_CLEANER(dbStruct, $
                                                                    INCLUDE_32Hz=include_32Hz, $
                                                                    LUN=lun)
              IF FASTLOC__cleaned_i EQ !NULL THEN BEGIN
                 PRINTF,lun,"Couldn't clean fastloc DB! Sup with that?"
                 STOP
              ENDIF ELSE BEGIN
              ENDELSE
           ENDELSE
        ENDIF
        good_i                                    = CGSETINTERSECTION(good_i, $
                                                                      KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__cleaned_i : FASTLOC__cleaned_i) 


     ENDELSE

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                ;Now some other user-specified exclusions set by keyword

     IF (~KEYWORD_SET(chastDB) AND is_maximus) THEN BEGIN
        burst_i                                   = WHERE(dbStruct.burst,nBurst,COMPLEMENT=survey_i,NCOMPLEMENT=nSurvey,/NULL)
        IF KEYWORD_SET(no_burstData) THEN BEGIN
           good_i                                 = CGSETINTERSECTION(survey_i,good_i)
           
           PRINTF,lun,""
           PRINTF,lun,"You're losing " + strtrim(nBurst) + " events because you've excluded burst data."
        ENDIF
        PRINTF,lun,FORMAT='("N burst elements              :",T35,I0)',nBurst
        PRINTF,lun,FORMAT='("N survey elements             :",T35,I0)',nSurvey
        PRINTF,lun,''
     ENDIF

     IF KEYWORD_SET(print_param_summary) THEN BEGIN
        PRINT_ALFVENDB_PLOTSUMMARY,dbStruct,good_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                   ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                   minMLT=minM,maxMLT=maxM, $
                                   BINMLT=binM, $
                                   SHIFTMLT=shiftM, $
                                   MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                                   DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                                   MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                                   HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                   BYMIN=byMin, BZMIN=bzMin, BYMAX=byMax, BZMAX=bzMax, BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                   PARAMSTRING=paramString, PARAMSTRPREFIX=plotPrefix,PARAMSTRSUFFIX=plotSuffix,$
                                   SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                   HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow,INCLUDENOCONSECDATA=includeNoConsecData, $
                                   HOYDIA=hoyDia,MASKMIN=maskMin,LUN=lun
     ENDIF
     
     PRINTF,lun,"There are " + strtrim(n_elements(good_i),2) + " total indices making the cut." 
     PRINTF,lun,''
     PRINTF,lun,"****END GET_CHASTON_IND****"
     PRINTF,lun,""

     IF is_maximus THEN BEGIN
        MAXIMUS__good_i                           = good_i
        MAXIMUS__HAVE_GOOD_I                      = 1
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
           IF ~KEYWORD_SET(nonMem) THEN BEGIN
              FASTLOC_E__good_i                   = good_i
              FASTLOC_E__HAVE_GOOD_I              = 1
           ENDIF
        ENDIF ELSE BEGIN
           FASTLOC__good_i                        = good_i
           FASTLOC__HAVE_GOOD_I                   = 1
        ENDELSE
     ENDELSE

  ENDIF ELSE BEGIN
     IF is_maximus THEN BEGIN
        good_i                                    = MAXIMUS__good_i 
        MAXIMUS__HAVE_GOOD_I                      = 1
        IF ARG_PRESENT(out_maximus) THEN BEGIN
           PRINT,'Giving you maximus...'
           out_maximus                            = MAXIMUS__maximus
        ENDIF
        IF ARG_PRESENT(out_cdbTime) THEN BEGIN
           PRINT,'Giving you maximus...'
           out_cdbTime                            = MAXIMUS__times
        ENDIF
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
           IF ~KEYWORD_SET(nonMem) THEN BEGIN
              good_i                              = FASTLOC_E__good_i
              FASTLOC_E__HAVE_GOOD_I              = 1
           ENDIF
        ENDIF ELSE BEGIN
           good_i                                 = FASTLOC__good_i
           FASTLOC__HAVE_GOOD_I                   = 1
        ENDELSE
        IF ARG_PRESENT(out_fastLoc) AND N_ELEMENTS(out_fastLoc) EQ 0 THEN BEGIN
           PRINT,'Giving you fastLoc...'
           out_fastLoc                            = KEYWORD_SET(for_eSpec_DBs) ? FL_eSpec__fastLoc : FL__fastLoc
        ENDIF
        IF ARG_PRESENT(out_times_fastLoc) AND N_ELEMENTS(out_times_fastLoc) EQ 0 THEN BEGIN
           PRINT,'Giving you fastLoc_times...'
           out_times_fastLoc                      = KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__times : FASTLOC__times
        ENDIF
        IF ARG_PRESENT(out_delta_t_fastLoc) AND N_ELEMENTS(out_delta_t_fastLoc) EQ 0 THEN BEGIN
           PRINT,'Giving you fastLoc_times...'
           out_delta_t_fastLoc                    = KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__delta_t : FASTLOC__delta_t
        ENDIF
     ENDELSE
  ENDELSE

  RETURN, good_i

  IF KEYWORD_SET(nonMem) THEN BEGIN
     CLEAR_FL_E_COMMON_VARS
     CLEAR_FL_COMMON_VARS
     CLEAR_M_COMMON_VARS
  ENDIF

END