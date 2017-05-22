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
FUNCTION GET_CHASTON_IND,dbStruct,lun, $
                         DBFILE=dbfile, $
                         DBTIMES=dbTimes, $
                         GET_TIME_I_NOT_ALFVENDB_I=get_time_i, $
                         GET_SWAY_I_NOT_ALFVENDB_I=get_sWay_i, $
                         GET_ALFVENDB_I=get_alfvendb_i, $
                         CORRECT_FLUXES=correct_fluxes, $
                         RESET_GOOD_INDS=reset_good_inds, $
                         DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                         PRINT_PARAM_SUMMARY=print_param_summary, $
                         FASTLOC_DELTA_T=fastloc_delta_t, $
                         FOR_ESPEC_DBS=for_eSpec_DBs, $
                         ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                         IMF_STRUCT=IMF_struct, $
                         MIMC_STRUCT=MIMC_struct, $
                         DONT_LOAD_IN_MEMORY=nonMem
                         
  COMPILE_OPT idl2,strictarrsubs
 
  @common__mlt_ilat_magc_etc.pro

  ;;LOAD_MAXIMUS_AND_CDBTIME is the other routine with this block
  @common__maximus_vars.pro

  @common__strangeway_bands.pro

  ;;Defined here, in GET_FASTLOC_INDS_IMF_CONDS_V2, and in GET_FASLOC_INDS_UTC_RANGE
  @common__fastloc_vars.pro

  @common__fastloc_espec_vars.pro

  defLun                         = -1

  IF ~KEYWORD_SET(lun) THEN lun  = defLun ;stdout

  IF ~KEYWORD_SET(do_not_set_defaults) THEN BEGIN
     SET_DEFAULT_MLT_ILAT_AND_MAGC,MINMLT=minM,MAXMLT=maxM,BINM=binM, $
                                   MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                   MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
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
     pDBStruct = PTR_NEW(dbStruct)
     IF N_ELEMENTS(DBTimes) GT 0 THEN BEGIN 
        pDBTimes = PTR_NEW(DBTimes)
     ENDIF
     dbFile    = 'From elsewhere!'

     IF KEYWORD_SET(get_time_i) OR KEYWORD_SET(get_sWay_i) THEN BEGIN
        is_maximus     = 0
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(get_alfvendb_i) THEN BEGIN
           is_maximus  = 1
        ENDIF ELSE BEGIN
           IS_STRUCT_ALFVENDB_OR_FASTLOC,*pDBStruct,is_maximus
        ENDELSE
     ENDELSE
  ENDIF ELSE BEGIN
     pDBStruct = PTR_NEW() ;null pointer
     IF KEYWORD_SET(get_time_i) OR KEYWORD_SET(get_sWay_i) THEN BEGIN
        is_maximus     = 0
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(get_alfvendb_i) THEN BEGIN
           is_maximus  = 1
        ENDIF
     ENDELSE
  ENDELSE

  IF ~KEYWORD_SET(get_alfvendb_i) $
     AND ~KEYWORD_SET(get_time_i) $
     AND ~KEYWORD_SET(get_sWay_i) $
     AND ~KEYWORD_SET(pDBStruct) THEN BEGIN
     PRINTF,lun,"Assuming this is maximus ..."
     is_maximus               = 1             ;We assume this is maximus
  ENDIF

  ;;Get the databases if they're already in mem
  IF is_maximus THEN BEGIN
     IF (N_ELEMENTS(MAXIMUS__maximus) NE 0 AND N_ELEMENTS(MAXIMUS__times) NE 0) OR KEYWORD_SET(pDBStruct) THEN BEGIN
     ENDIF ELSE BEGIN
        IF N_ELEMENTS(correct_fluxes) EQ 0 THEN BEGIN
           IF KEYWORD_SET(pDBStruct) THEN BEGIN
              PRINTF,lun,'GET_CHASTON_IND: Not attempting to correct fluxes since dbStruct already loaded ...'
              correct_fluxes  = 0
           ENDIF ELSE BEGIN
              correct_fluxes  = 1
           ENDELSE
        ENDIF
        LOAD_MAXIMUS_AND_CDBTIME, $
           DBDIR=loaddataDir, $
           DBFILE=dbFile, $
           DB_TFILE=dbTimesFile, $
           ;; DO_NOT_MAP_ANYTHING=no_mapping, $
           CHASTDB=alfDB_plot_struct.chastDB, $
           DESPUNDB=alfDB_plot_struct.despunDB, $
           COORDINATE_SYSTEM=MIMC_struct.coordinate_system, $
           USE_AACGM_COORDS=MIMC_struct.use_aacgm, $
           USE_MAG_COORDS=MIMC_struct.use_mag, $
           CORRECT_FLUXES=correct_fluxes

     ENDELSE

     IF ~KEYWORD_SET(pDBStruct) THEN BEGIN
        pDBStruct             = PTR_NEW(MAXIMUS__maximus)
        pDBTimes              = PTR_NEW(MAXIMUS__times)
     ENDIF
     IF N_ELEMENTS(dbFile) EQ 0 THEN BEGIN
        dbFile                = MAXIMUS__dbFile
        dbTimesFile           = MAXIMUS__dbTimesFile
     ENDIF
  ENDIF ELSE BEGIN

     loadFL                   = 0
     loadSWay                 = 0
     CASE 1 OF
        KEYWORD_SET(get_sWay_i): BEGIN
           IF N_ELEMENTS(SWAY__DB) NE 0 THEN BEGIN
              loadSWay         = 0
           ENDIF ELSE BEGIN
              loadSWay         = 1
           ENDELSE
        END
        KEYWORD_SET(for_eSpec_DBs): BEGIN
           ;; IF ~KEYWORD_SET(nonMem) THEN BEGIN
           IF N_ELEMENTS(FL_eSpec__fastLoc) NE 0 AND $
              N_ELEMENTS(FASTLOC_E__times) NE 0 THEN BEGIN
              ;; pDBStruct        = PTR_NEW(FL_eSpec__fastLoc )
              ;; pDBTimes         = PTR_NEW(FASTLOC_E__times  )
              ;; fastloc_delta_t  = FASTLOC_E__delta_t
              ;; dbFile           = FASTLOC_E__dbFile
              ;; dbTimesFile      = FASTLOC_E__dbTimesFile
              loadFL           = 0
           ENDIF ELSE BEGIN
              loadFL           = 1
           ENDELSE
           ;; ENDIF ELSE BEGIN
           ;;    loadFL              = 1
           ;; ENDELSE
        END
        ELSE: BEGIN
           IF N_ELEMENTS(FL__fastLoc) NE 0 AND $
              N_ELEMENTS(FASTLOC__times) NE 0 AND $
              N_ELEMENTS(FASTLOC__delta_t) NE 0 $
           THEN BEGIN
              ;; pDBStruct           = PTR_NEW(FL__fastLoc   )
              ;; pDBTimes            = PTR_NEW(FASTLOC__times)
              ;; fastloc_delta_t     = FASTLOC__delta_t
              ;; dbFile              = FASTLOC__dbFile
              ;; dbTimesFile         = FASTLOC__dbTimesFile
              loadFL              = 0
           ENDIF ELSE BEGIN
              loadFL              = 1
           ENDELSE
        END
     ENDCASE

     IF loadFL AND ~KEYWORD_SET(pDBStruct) THEN BEGIN
        LOAD_FASTLOC_AND_FASTLOC_TIMES, $
           DBDIR=loaddataDir, $
           DBFILE=dbFile, $
           DB_TFILE=dbTimesFile, $
           INCLUDE_32HZ=alfDB_plot_struct.include_32Hz, $
           USE_AACGM_COORDS=MIMC_struct.use_aacgm, $
           USE_MAG_COORDS=MIMC_struct.use_mag, $
           FOR_ESPEC_DBS=for_eSpec_DBs

     ENDIF ELSE BEGIN

        IF loadSWay AND ~KEYWORD_SET(pDBStruct) THEN BEGIN

           LOAD_STRANGEWAY_BANDS_PFLUX_DB,leMaitre,times, $
                                          GOOD_I=good_i, $
                                          DBDir=DBDir, $
                                          DBFile=DBFile, $
                                          CORRECT_FLUXES=correct_fluxes, $
                                          DO_NOT_MAP_PFLUX=do_not_map_pflux, $
                                          DO_NOT_MAP_IONFLUX=do_not_map_ionflux, $
                                          DO_NOT_MAP_ANYTHING=no_mapping, $
                                          COORDINATE_SYSTEM=coordinate_system, $
                                          USE_LNG=use_lng, $
                                          USE_AACGM_COORDS=use_AACGM, $
                                          USE_GEI_COORDS=use_GEI, $
                                          USE_GEO_COORDS=use_GEO, $
                                          USE_MAG_COORDS=use_MAG, $
                                          USE_SDT_COORDS=use_SDT, $
                                          HEMI__GOOD_I=hemi__good_i, $
                                          USING_HEAVIES=using_heavies, $
                                          FORCE_LOAD=force_load, $
                                          JUST_TIME=just_time, $
                                          LOAD_DELTA_ILAT_FOR_WIDTH_TIME=load_dILAT, $
                                          LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=load_dAngle, $
                                          LOAD_DELTA_X_FOR_WIDTH_TIME=load_dx, $
                                          CHECK_DB=check_DB, $
                                          QUIET=quiet, $
                                          CLEAR_MEMORY=clear_memory, $
                                          NO_MEMORY_LOAD=noMem, $
                                          LUN=lun

        ENDIF

     ENDELSE

     IF ~KEYWORD_SET(pDBStruct) THEN BEGIN
        CASE 1 OF
           KEYWORD_SET(for_eSpec_DBs): BEGIN
              IF N_ELEMENTS(FL_eSpec__fastLoc) NE 0 AND $
                 N_ELEMENTS(FASTLOC_E__times) NE 0 THEN BEGIN
                 pDBStruct        = PTR_NEW(FL_eSpec__fastLoc )
                 pDBTimes         = PTR_NEW(FASTLOC_E__times  )
                 ;; fastloc_delta_t  = FASTLOC_E__delta_t
                 dbFile           = FASTLOC_E__dbFile
                 dbTimesFile      = FASTLOC_E__dbTimesFile
              ENDIF ELSE BEGIN
                 STOP           ;should be loaded!
              ENDELSE
           END
           KEYWORD_SET(get_sWay_i): BEGIN
              IF N_ELEMENTS(SWAY__DB) NE 0 THEN BEGIN
                 pDBStruct        = PTR_NEW(SWAY__DB     )
                 pDBTimes         = PTR_NEW(SWAY__DB.time)
                 ;; fastloc_delta_t  = FASTLOC_E__delta_t
                 dbFile           = SWAY__dbFile
                 ;; dbTimesFile      = __dbTimesFile
              ENDIF ELSE BEGIN
                 STOP           ;should be loaded!
              ENDELSE
           END
           ELSE: BEGIN
              IF N_ELEMENTS(FL__fastLoc) NE 0 AND $
                 N_ELEMENTS(FASTLOC__times) NE 0 AND $
                 N_ELEMENTS(FASTLOC__delta_t) NE 0 $
              THEN BEGIN
                 pDBStruct           = PTR_NEW(FL__fastLoc   )
                 pDBTimes            = PTR_NEW(FASTLOC__times)
                 ;; fastloc_delta_t     = FASTLOC__delta_t
                 dbFile              = FASTLOC__dbFile
                 dbTimesFile         = FASTLOC__dbTimesFile
              ENDIF ELSE BEGIN
                 STOP           ;should be loaded!
              ENDELSE
           END
        ENDCASE
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(get_sWay_i) THEN BEGIN
           pDBTimes    = PTR_NEW((*pDBStruct).time)
        ENDIF
     ENDELSE
  ENDELSE

  ;;Now check to see whether we have the appropriate vars for each guy
  IF ~is_maximus THEN BEGIN

     CASE 1 OF
        KEYWORD_SET(for_eSpec_DBs): BEGIN
           have_good_i = KEYWORD_SET(FASTLOC_E_HAVE_GOOD_I)
           n_good_i    = N_ELEMENTS(FASTLOC_E_good_i)
        END
        KEYWORD_SET(get_sWay_i): BEGIN
           have_good_i = KEYWORD_SET(SWAY__HAVE_GOOD_I)
           n_good_i    = N_ELEMENTS(SWAY__good_i)
        END
        ELSE: BEGIN
           have_good_i = KEYWORD_SET(FASTLOC__HAVE_GOOD_I)
           n_good_i    = N_ELEMENTS(FASTLOC__good_i)
        END
     ENDCASE
     ;; have_good_i = KEYWORD_SET(for_eSpec_DBs) ? KEYWORD_SET(FASTLOC_E_HAVE_GOOD_I) : $
     ;;                                            KEYWORD_SET(FASTLOC__HAVE_GOOD_I)
     ;; n_good_i    = KEYWORD_SET(for_eSpec_DBs) ? N_ELEMENTS(FASTLOC_E_good_i)       : $
     ;;                                            N_ELEMENTS(FASTLOC__good_i)

     IF ~have_good_i OR KEYWORD_SET(reset_good_inds) THEN BEGIN

        IF KEYWORD_SET(reset_good_inds) THEN BEGIN
           PRINT,'Resetting good fastLoc inds...'
        ENDIF

        calculate                        = 1

     ENDIF ELSE BEGIN

        IF n_good_i NE 0 THEN BEGIN

           CHECK_FOR_NEW_IND_CONDS,is_maximus, $
                                   HAVE_GOOD_I=have_good_i, $
                                   MIMC_STRUCT=MIMC_struct, $
                                   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                   IMF_STRUCT=IMF_struct, $
                                   LUN=lun

           calculate                     = MIMC__RECALCULATE
           MAXIMUS__HAVE_GOOD_I          = have_good_i

           CASE 1 OF
              KEYWORD_SET(for_eSpec_DBs): BEGIN
                 IF ~KEYWORD_SET(nonMem) THEN BEGIN

                    FASTLOC_E__HAVE_GOOD_I  = have_good_i

                 ENDIF
              END
              KEYWORD_SET(get_sWay_i): BEGIN
                 SWAY__HAVE_GOOD_I       = have_good_i
              END
              ELSE: BEGIN
                 
                 FASTLOC__HAVE_GOOD_I    = have_good_i
                 
              END
           ENDCASE
           ;; IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN

        ENDIF ELSE BEGIN
           CASE 1 OF
              KEYWORD_SET(for_eSpec_DBs): BEGIN
                 PRINT,'But you should already have FASTLOC_E__good_i!!'
              END
              KEYWORD_SET(get_sWay_i): BEGIN
                 PRINT,'But you should already have SWAY__good_i!!'
              END
              ELSE: BEGIN
                 PRINT,'But you should already have FASTLOC__good_i!!'
              END
           ENDCASE
           STOP
        ENDELSE
     ENDELSE
  ENDIF ELSE BEGIN
     IF ~KEYWORD_SET(MAXIMUS__HAVE_GOOD_I) OR KEYWORD_SET(reset_good_inds) THEN BEGIN
        IF KEYWORD_SET(reset_good_inds) THEN BEGIN
           PRINT,'Resetting good maximus inds...'
        ENDIF
        calculate                        = 1
     ENDIF ELSE BEGIN
        IF N_ELEMENTS(MAXIMUS__good_i) NE 0 THEN BEGIN
           CHECK_FOR_NEW_IND_CONDS,is_maximus, $
                                   HAVE_GOOD_I=have_good_i, $
                                   MIMC_STRUCT=MIMC_struct, $
                                   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                                   IMF_STRUCT=IMF_struct, $
                                   LUN=lun

           calculate                     = MIMC__RECALCULATE
           MAXIMUS__HAVE_GOOD_I          = have_good_i
           IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
              IF ~KEYWORD_SET(nonMem) THEN BEGIN
                 FASTLOC_E__HAVE_GOOD_I  = have_good_i
              ENDIF 
           ENDIF ELSE BEGIN
              FASTLOC__HAVE_GOOD_I       = have_good_i
           ENDELSE
        ENDIF ELSE BEGIN
           PRINT,'But you should already have MAXIMUS__good_i!!'
           STOP
        ENDELSE
     ENDELSE
  ENDELSE

  IF KEYWORD_SET(calculate) THEN BEGIN

     ;;Welcome message
     PRINTF,lun,""
     PRINTF,lun,"****From GET_CHASTON_IND****"
     PRINTF,lun,FORMAT='("DBFile                        :",T35,A0)',dbFile
     PRINTF,lun,""

     ;;;;;;;;;;;;
     ;;Handle longitudes
     MIMC__minMLT     = (KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.minLng : MIMC_struct.minM)
     MIMC__maxMLT     = (KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.maxLng : MIMC_struct.maxM)
     MIMC__binMLT     = (KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.binLng : MIMC_struct.binM)
     MIMC__dayside    = KEYWORD_SET(MIMC_struct.dayside)
     MIMC__nightside  = KEYWORD_SET(MIMC_struct.nightside)
     mlt_i            = GET_MLT_INDS(*pDBStruct, $
                                     MIMC__minMLT, $
                                     MIMC__maxMLT, $
                                     DAYSIDE=MIMC__dayside, $
                                     NIGHTSIDE=MIMC__nightside, $
                                     N_MLT=n_mlt, $
                                     N_OUTSIDE_MLT=n_outside_MLT, $
                                     USE_LNG=MIMC_struct.use_Lng, $
                                     LUN=lun)
     
     ;;;;;;;;;;;;
     ;;Handle latitudes, combine with mlt
     MIMC__hemi           = MIMC_struct.hemi
     MIMC__north          = KEYWORD_SET(MIMC_struct.north)
     MIMC__south          = KEYWORD_SET(MIMC_struct.south)
     MIMC__both_hemis     = KEYWORD_SET(MIMC_struct.both_hemis)
     MIMC__globe          = KEYWORD_SET(MIMC_struct.globe)
     IF KEYWORD_SET(do_lShell) THEN BEGIN
        MIMC__minLshell   = MIMC_struct.minL
        MIMC__maxLshell   = MIMC_struct.maxL
        MIMC__binLshell   = MIMC_struct.binL
        lshell_i          = GET_LSHELL_INDS(*pDBStruct, $
                                            MIMC__minLshell, $
                                            MIMC__maxLshell, $
                                            MIMC__hemi, $
                                            N_LSHELL=n_lshell, $
                                            N_NOT_LSHELL=n_not_lshell, $
                                            LUN=lun)
        region_i          = CGSETINTERSECTION(lshell_i,mlt_i)
     ENDIF ELSE BEGIN
        MIMC__minILAT     = MIMC_struct.minI
        MIMC__maxILAT     = MIMC_struct.maxI
        MIMC__binILAT     = MIMC_struct.binI
        MIMC__EA_binning  = KEYWORD_SET(alfDB_plot_struct.EA_binning)

        ilat_i            = GET_ILAT_INDS(*pDBStruct, $
                                          MIMC__minILAT, $
                                          MIMC__maxILAT, $
                                          MIMC__hemi, $
                                          N_ILAT=n_ilat, $
                                          N_NOT_ILAT=n_not_ilat, $
                                          LUN=lun)
        region_i          = CGSETINTERSECTION(ilat_i,mlt_i)

        ;;Kill everything below 35 deg MAG lat (trust me, see the output from JOURNAL__20170201__ESPEC_PLOTS__DURING_STORMPHASES__ALTERNATE_COORDS
        Spence_cares = 0
        IF ~is_maximus AND Spence_cares THEN BEGIN
           GET_INDS_ABOVE_35_MAGLAT,dBStruct,ilat_i, $
                                    /FOR_FASTLOC_DB
        ENDIF

     ENDELSE

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;Want just Holzworth/Meng statistical auroral oval?
     test = 0
     STR_ELEMENT,alfDB_plot_struct,'HwMAurOval',test
     IF test THEN BEGIN
        region_i  = CGSETINTERSECTION( $
                    region_i, $
                    WHERE(ABS((*pDBStruct).ilat) GT $
                          AURORAL_ZONE((*pDBStruct).mlt,HwMKpInd,/LAT)/(!DPI)*180.))
     ENDIF
     ;;;;;;;;;;;;;;;;;;;;;;
     ;;Now combine them all
     IF KEYWORD_SET(MIMC_struct.do_lShell) THEN BEGIN
        PRINT,"We don't do L-shell nonsense here. Yet, anyway."
        STOP
     ENDIF ELSE BEGIN
     ENDELSE

     IF is_maximus THEN BEGIN
        MIMC__minMC               = MIMC_struct.minMC
        MIMC__maxNegMC            = MIMC_struct.maxNegMC
        magc_i                    = GET_MAGC_INDS(*pDBStruct, $
                                                  MIMC__minMC, $
                                                  MIMC__maxNegMC, $
                                                  N_OUTSIDE_MAGC=n_magc_outside_range, $
                                                  /UNMAP_IF_MAPPED)
        region_i                  = CGSETINTERSECTION(region_i,magc_i)
     ENDIF

     
     ;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;Limits on orbits to use?
     test = !NULL
     STR_ELEMENT,alfDB_plot_struct,'orbRange',test
     IF SIZE(test,/TYPE) NE 0 THEN BEGIN
        MIMC__orbRange        = alfDB_plot_struct.orbRange
        CASE N_ELEMENTS(alfDB_plot_struct.orbRange) OF
           1: BEGIN
              MIMC__orbRange  = [alfDB_plot_struct.orbRange,alfDB_plot_struct.orbRange]
           END
           2: BEGIN
              MIMC__orbRange  = alfDB_plot_struct.orbRange
           END
           ELSE: BEGIN
              PRINTF,lun,"Assuming you want me to believe you about this orbit array ..."
              is_orbArr       = 1
              MIMC__orbRange  = alfDB_plot_struct.orbRange
           END
        ENDCASE

        IF KEYWORD_SET(is_orbArr) THEN BEGIN
           tmp_i             = CGSETINTERSECTION((*pDBStruct).orbit, $
                                                 MIMC__orbRange, $
                                                 POSITIONS=orb_i)
        ENDIF ELSE BEGIN

           ;;This keyword is also used for killGap_file stuff
           bro               = 1 ;Are we going to trash bad ESA stuff?

           CASE 1 OF
              KEYWORD_SET(is_maximus): BEGIN
                 dont_trash_bad_orbits = KEYWORD_SET(alfDB_plot_struct.dont_blackball_maximus)
              END
              ~KEYWORD_SET(is_maximus) AND KEYWORD_SET(get_sWay_i): BEGIN
                 dont_trash_bad_orbits = 1
              END
              ~KEYWORD_SET(is_maximus): BEGIN
                 dont_trash_bad_orbits = KEYWORD_SET(alfDB_plot_struct.dont_blackball_fastloc)
              END
           ENDCASE

           orb_i                 = GET_ORBRANGE_INDS( $
                                   *pDBStruct, $
                                   MIMC__orbRange[0], $
                                   MIMC__orbRange[1], $
                                   DONT_TRASH_BAD_ORBITS=dont_trash_bad_orbits, $
                                   ;; SERIOUSLY__NOJUNK=bro, $ ;Unused now
                                   FOR_SWAY_DB=get_sWay_i, $
                                   DBTIMES=(*pDBTimes), $
                                   LUN=lun)

        ENDELSE

        IF orb_i[0] NE -1 THEN BEGIN
           region_i          = CGSETINTERSECTION(region_i,orb_i)
        ENDIF ELSE BEGIN
           PRINTF,lun,'No orbs matching provided range!'
           STOP
        ENDELSE
     ENDIF
     

     ;;limits on altitudes to use?
     test = !NULL
     STR_ELEMENT,alfDB_plot_struct,'altitudeRange',test
     IF SIZE(test,/TYPE) NE 0 THEN BEGIN
        MIMC__altitudeRange  = alfDB_plot_struct.altitudeRange
        IF N_ELEMENTS(alfDB_plot_struct.altitudeRange) EQ 2 THEN BEGIN
           alt_i             = GET_ALTITUDE_INDS( $
                               *pDBStruct, $
                               MIMC__altitudeRange[0], $
                               MIMC__altitudeRange[1],LUN=lun)
           region_i          = CGSETINTERSECTION(region_i,alt_i)
        ENDIF ELSE BEGIN
           PRINTF,lun,"Incorrect input for keyword 'altitudeRange'!!"
           PRINTF,lun,"Please use altitudeRange = [minAlt maxAlt]"
           RETURN,-1
        ENDELSE
     ENDIF
     
     ;; was using this to compare our Poynting flux estimates against Keiling et al. 2003 Fig. 3
     ;;limits on characteristic electron energies to use?
     test = !NULL
     STR_ELEMENT,alfDB_plot_struct,'charERange',test
     IF ((SIZE(test,/TYPE) NE 0)                             OR $
         alfDB_plot_struct.fluxPlots__invert_Newell_the_cusp OR $
         alfDB_plot_struct.fluxPlots__Newell_the_cusp        OR $
         alfDB_plot_struct.fluxPlots__broadband_everywhar    OR $
         alfDB_plot_struct.fluxPlots__diffuse_everywhar         ) AND $
        is_maximus THEN BEGIN
        IF N_ELEMENTS(alfDB_plot_struct.charERange) EQ 2 THEN BEGIN

           MIMC__charERange  = alfDB_plot_struct.charERange
           
           chare_i           = GET_CHARE_INDS( $
                               *pDBStruct, $
                               alfDB_plot_struct.charERange[0], $
                               alfDB_plot_struct.charERange[1], $
                               INVERT_NEWELL_THE_CUSP=alfDB_plot_struct.fluxPlots__invert_Newell_the_cusp, $
                               NEWELL_THE_CUSP=alfDB_plot_struct.fluxPlots__Newell_the_cusp, $
                               BROADBAND_EVERYWHAR=alfDB_plot_struct.fluxPlots__broadband_everywhar, $
                               DIFFUSE_EVERYWHAR=alfDB_plot_struct.fluxPlots__diffuse_everywhar, $
                               CHASTDB=alfDB_plot_struct.chastDB, $
                               LUN=lun)

           region_i          = CGSETINTERSECTION(region_i,chare_i)
        ENDIF ELSE BEGIN
           PRINTF,lun,"Incorrect input for keyword 'charERange'!!"
           PRINTF,lun,"Please use charERange = [minCharE maxCharE]"
           RETURN,-1
        ENDELSE
     ENDIF

     test = !NULL
     STR_ELEMENT,alfDB_plot_struct,'poyntRange',test
     IF (SIZE(test,/TYPE) NE 0) AND is_maximus THEN BEGIN
     ;; IF KEYWORD_SET (poyntRange) THEN BEGIN
        MIMC__poyntRange     = alfDB_plot_struct.poyntRange
        IF N_ELEMENTS(alfDB_plot_struct.poyntRange) EQ 2 THEN BEGIN
           pFlux_i           = GET_PFLUX_INDS( $
                               *pDBStruct, $
                               MIMC__poyntRange[0], $
                               MIMC__poyntRange[1], $
                               LUN=lun)
           region_i          = CGSETINTERSECTION(region_i,pFlux_i)
        ENDIF ELSE BEGIN
           PRINTF,lun,"Incorrect input for keyword 'poyntRange'!!"
           PRINTF,lun,"Please use poyntRange = [minpFlux, maxpFlux]"
           RETURN,-1
        ENDELSE
     ENDIF

     IF (KEYWORD_SET(alfDB_plot_struct.fluxplots__remove_outliers) OR   $
         KEYWORD_SET(alfDB_plot_struct.fluxplots__remove_log_outliers)) AND $
        is_maximus THEN BEGIN
     ;; IF 1 AND is_maximus THEN BEGIN
        inlier_i = GET_FASTDB_OUTLIER_INDICES( $
                   *pDBStruct, $
                   /FOR_ALFDB, $
                   REMOVE_OUTLIERS=alfDB_plot_struct.fluxplots__remove_outliers, $
                   USER_INDS=tmp_i, $
                   /ONLY_UPPER, $
                   ONLY_LOWER=only_lower, $
                   LOG_OUTLIERS=alfDB_plot_struct.fluxplots__remove_log_outliers, $
                   /DOUBLE, $
                   LOG__ABS=absFlux, $
                   LOG__NEG=noPosFlux, $
                   ADD_SUSPECTED=alfDB_plot_struct.fluxPlots__add_suspect_outliers)

        IF inlier_i[0] NE -1 THEN BEGIN
           region_i = CGSETINTERSECTION(region_i,inlier_i,NORESULT=-1)
           IF region_i[0] EQ -1 THEN BEGIN
              PRINT,"You killed it!!"
              STOP
           ENDIF
        ENDIF ELSE BEGIN
           PRINT,"Dead man."
           STOP
        ENDELSE
     ENDIF

     good_i = TEMPORARY(region_i)

     ;;Are we going to kill the bad ESA times? (See JOURNAL__20170119__STITCH_GAPS_FILES.PRO in espec_identification journals) 
     IF bro AND is_maximus THEN BEGIN

        killGap_file = GET_NEWELL_ESPEC_KILLGAP_FILE(dbStruct, $
                                                     NEWELLDBDIR=dbDir, $
                                                     /WHOWANTSTOKNOW, $
                                                     /STOP_IF_NOEXIST)

        RESTORE,killGap_file

        ;;Don't use befStartTimes, because exclusion of the first 10 seconds of ESA data was built in to ALFVEN_STATS_5.
        timeMe  = VALUE_CLOSEST2(junkTimes,(*pDBTimes))
        IF (WHERE(timeMe EQ -1))[0] NE -1 THEN timeMe[WHERE(timeMe EQ -1)] = 0
        likee = WHERE(ABS(junkTimes[timeMe]-(*pDBTimes)) GE 2.6,nLikee)
        IF nLikee NE 0 THEN BEGIN
           nGood  = N_ELEMENTS(good_i)
           good_i = CGSETINTERSECTION(likee,good_i,COUNT=nKeep)
           PRINT,"Lost " + STRCOMPRESS(nGood-nKeep) + " inds to junkTimes"
        ENDIF ELSE BEGIN
           PRINT,"DAWG!"
           STOP
        ENDELSE

     ENDIF

     ;;Now, clear out all the garbage (NaNs & Co.)
     IF is_maximus THEN BEGIN
        IF N_ELEMENTS(MAXIMUS__cleaned_i) EQ 0 THEN BEGIN
           MAXIMUS__cleaned_i  = ALFVEN_DB_CLEANER( $
                                 *pDBStruct, $
                                 LUN=lun, $
                                 IS_CHASTDB=alfDB_plot_struct.chastDB, $
                                 SAMPLE_T_RESTRICTION=TAG_EXIST(alfDB_plot_struct,'sample_t_restriction') ? alfDB_plot_struct.sample_t_restriction : !NULL, $
                                 INCLUDE_32Hz=alfDB_plot_struct.include_32Hz, $
                                 DISREGARD_SAMPLE_T=alfDB_plot_struct.disregard_sample_t, $
                                 DO_LSHELL=MIMC_struct.do_lshell, $
                                 USING_HEAVIES=(*pDBStruct).info.using_heavies)
           IF MAXIMUS__cleaned_i EQ !NULL THEN BEGIN
              PRINTF,lun,"Couldn't clean Alfvén DB! Sup with that?"
              STOP
           ENDIF ELSE BEGIN
           ENDELSE
        ENDIF

        good_i                 = CGSETINTERSECTION(good_i,MAXIMUS__cleaned_i) 

     ENDIF ELSE BEGIN
        CASE 1 OF
           KEYWORD_SET(for_eSpec_DBs): BEGIN
              nClean              = N_ELEMENTS(FASTLOC_E__cleaned_i)
           END
           KEYWORD_SET(get_sWay_i): BEGIN
              nClean              = 0
           END
           ELSE: BEGIN
              nClean              = N_ELEMENTS(FASTLOC__cleaned_i)
           ENDELSE
        ENDCASE

        IF nClean EQ 0 THEN BEGIN

           CASE 1 OF
              KEYWORD_SET(for_eSpec_DBS): BEGIN

                 FASTLOC_E__cleaned_i  = FASTLOC_CLEANER( $
                                         *pDBStruct, $
                                         /FOR_ESPEC_DBS, $
                                         INCLUDE_32Hz=alfDB_plot_struct.include_32Hz, $
                                         DISREGARD_SAMPLE_T=alfDB_plot_struct.disregard_sample_t, $
                                         LUN=lun)
                 
                 IF FASTLOC_E__cleaned_i EQ !NULL THEN BEGIN
                    PRINTF,lun,"Couldn't clean fastloc_eSpec DB! Sup with that?"
                    STOP
                 ENDIF ELSE BEGIN
                 ENDELSE

                 cleaned_i          = FASTLOC_E__cleaned_i

              END
              KEYWORD_SET(get_sWay_i): BEGIN

                 cleaned_i = LINDGEN(N_ELEMENTS((*pDBStruct).time))

                 ;; WHERE(FINITE(SWAY__DB.time))

                 nSubTags = [0, $ ;time
                             0, $ ;orbit
                             0, $ ;alt
                             0, $ ;mlt
                             0, $ ;ilat
                             0, $ ;magRatio
                             3, $ ;dB
                             1, $ ;e
                             3, $ ;pFlux
                             -1]

                 FOR k=0,N_ELEMENTS(TAG_NAMES(SWAY__DB))-1 DO BEGIN

                    PRINT,"SWAYCLEAN: TAG #",k

                    ;; shouldContinue = 0
                    CASE nSubTags[k] OF
                       -1: BEGIN
                          ;; shouldContinue = 1
                       END
                       0: BEGIN
                          cleaned_i = CGSETINTERSECTION(cleaned_i,WHERE(FINITE((*pDBStruct).(k))),COUNT=nClean)
                       END
                       ELSE: BEGIN

                          FOR kk=0,nSubTags[k]-1 DO BEGIN

                             CASE SIZE( (*pDBStruct).(k).(kk),/TYPE) OF
                                8: BEGIN

                                   tmpTagNames = TAG_NAMES( (*pDBStruct).(k).(kk) )
                                   
                                   ACTag       = WHERE(STRUPCASE(tmpTagNames) EQ 'AC') 
                                   DCTag       = WHERE(STRUPCASE(tmpTagNames) EQ 'DC') 

                                   IF ACTag[0] NE -1 THEN BEGIN

                                      cleaned_i = CGSETINTERSECTION(cleaned_i,WHERE(FINITE((*pDBStruct).(k).(kk).(ACTag))),COUNT=nClean)

                                      IF nClean LE 10 THEN STOP

                                   ENDIF

                                   IF DCTag[0] NE -1 THEN BEGIN

                                      cleaned_i = CGSETINTERSECTION(cleaned_i,WHERE(FINITE((*pDBStruct).(k).(kk).(DCTag))),COUNT=nClean)

                                      IF nClean LE 10 THEN STOP

                                   ENDIF

                                END
                                ELSE: BEGIN

                                   ;; STOP

                                END
                             ENDCASE

                          ENDFOR

                       END
                    ENDCASE

                    IF nClean LE 10 THEN STOP

                 ENDFOR

                 PRINT,"N clean SWAY inds: ",N_ELEMENTS(cleaned_i)

              END
              ELSE: BEGIN

                 FASTLOC__cleaned_i    = FASTLOC_CLEANER( $
                                         *pDBStruct, $
                                         INCLUDE_32Hz=alfDB_plot_struct.include_32Hz, $
                                         DISREGARD_SAMPLE_T=alfDB_plot_struct.disregard_sample_t, $
                                         LUN=lun)
                 IF FASTLOC__cleaned_i EQ !NULL THEN BEGIN
                    PRINTF,lun,"Couldn't clean fastloc DB! Sup with that?"
                    STOP
                 ENDIF ELSE BEGIN
                 ENDELSE

                 cleaned_i          = FASTLOC__cleaned_i

              END
           ENDCASE

        ENDIF

        good_i                      = CGSETINTERSECTION( $
                                      good_i, $
                                      cleaned_i) 


     ENDELSE

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                                ;Now some other user-specified exclusions set by keyword

     IF (~KEYWORD_SET(alfDB_plot_struct.chastDB) AND is_maximus) THEN BEGIN
        burst_i    = WHERE((*pDBStruct).burst,nBurst, $
                           COMPLEMENT=survey_i, $
                           NCOMPLEMENT=nSurvey, $
                           /NULL)
        IF KEYWORD_SET(no_burstData) THEN BEGIN
           good_i  = CGSETINTERSECTION(survey_i,good_i)
           
           PRINTF,lun,""
           PRINTF,lun,"You're losing " + strtrim(nBurst) + " events because you've excluded burst data."
        ENDIF
        PRINTF,lun,FORMAT='("N burst elements              :",T35,I0)',nBurst
        PRINTF,lun,FORMAT='("N survey elements             :",T35,I0)',nSurvey
        PRINTF,lun,''
     ENDIF

     IF KEYWORD_SET(print_param_summary) THEN BEGIN
        PRINT_ALFVENDB_PLOTSUMMARY, $
           *pDBStruct,good_i, $
           IMF_STRUCT=IMF_struct, $
           MIMC_STRUCT=MIMC_struct, $
           ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
           LUN=lun
     ENDIF
     
     PRINTF,lun,"There are " + STRTRIM(N_ELEMENTS(good_i),2) + " total indices making the cut." 
     PRINTF,lun,''
     PRINTF,lun,"****END GET_CHASTON_IND****"
     PRINTF,lun,""

     IF is_maximus THEN BEGIN
        MAXIMUS__good_i               = good_i
        MAXIMUS__HAVE_GOOD_I          = 1
     ENDIF ELSE BEGIN

        CASE 1 OF
           KEYWORD_SET(for_eSpec_DBs): BEGIN

              IF ~KEYWORD_SET(nonMem) THEN BEGIN
                 FASTLOC_E__good_i       = good_i
                 FASTLOC_E__HAVE_GOOD_I  = 1
              ENDIF

           END
           KEYWORD_SET(get_sWay_i): BEGIN

              SWAY__good_i               = good_i
              SWAY__HAVE_GOOD_I          = 1

           END
           ELSE: BEGIN

              FASTLOC__good_i            = good_i
              FASTLOC__HAVE_GOOD_I       = 1

           END
        ENDCASE

     ENDELSE

  ENDIF ELSE BEGIN ;END CALCULATE

     IF is_maximus THEN BEGIN

        good_i                        = MAXIMUS__good_i 
        MAXIMUS__HAVE_GOOD_I          = 1

     ENDIF ELSE BEGIN

        CASE 1 OF
           KEYWORD_SET(for_eSpec_DBs): BEGIN

              IF ~KEYWORD_SET(nonMem) THEN BEGIN
                 good_i                  = FASTLOC_E__good_i
                 FASTLOC_E__HAVE_GOOD_I  = 1
              ENDIF

           END
           KEYWORD_SET(get_sWay_i): BEGIN

              good_i                     = SWAY__good_i
              SWAY__HAVE_GOOD_I          = 1
              
           END
           ELSE: BEGIN

              good_i                     = FASTLOC__good_i
              FASTLOC__HAVE_GOOD_I       = 1

           END
        ENDCASE

     ENDELSE

  ENDELSE

  ;; good_i_file = '~/Desktop/maximus_good_i__NORTH-' + $
  ;;      GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '.sav'
  ;; PRINT,"Saving good_i to " + good_i_file
  ;; SAVE,good_i,FILENAME=good_i_file
  ;; STOP
  
  RETURN, good_i

  IF KEYWORD_SET(nonMem) THEN BEGIN

     CASE 1 OF
        KEYWORD_SET(is_maximus): BEGIN

           CLEAR_M_COMMON_VARS

        END
        KEYWORD_SET(for_eSpec_DBs): BEGIN

           CLEAR_FL_E_COMMON_VARS

        END
        KEYWORD_SET(get_sWay_i): BEGIN

           CLEAR_STRANGEWAY_COMMON_VARS

        END
        ELSE: BEGIN

           CLEAR_FL_COMMON_VARS

        END
     ENDCASE

  ENDIF

END