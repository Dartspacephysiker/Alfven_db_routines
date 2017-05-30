;2017/05/22
PRO LOAD_STRANGEWAY_BANDS_PFLUX_DB,leMaitre,times, $
                                   GOOD_I=good_i, $
                                   DBDir=DBDir, $
                                   DBFile=DBFile, $
                                   USE_8HZ_DB=use_8Hz_DB, $
                                   USE_8HZ__LOAD_DB=use_8Hz__load_dB, $
                                   USE_8HZ__LOAD_EFIELD=use_8Hz__load_eField, $
                                   USE_8HZ__LOAD_PFLUX=use_8Hz__load_pFlux, $
                                   USE_8HZ__LOAD_MAGFLAGS=use_8Hz__load_magFlags, $
                                   USE_8HZ__LOAD_PTCL=use_8Hz__load_ptcl, $
                                   ;; USE_8HZ__LOAD_EPHEM=use_8Hz__load_ephem, $
                                   USE_8HZ__SWAY_PLOTTYPE=use_8Hz__sWay_plotType, $
                                   ;; DB_TFILE=DB_tFile, $
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

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__strangeway_bands.pro

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1         ;stdout

  IF N_ELEMENTS(correct_fluxes) EQ 0 THEN correct_fluxes = 1
  ;; correct_fluxes = 0

  IF KEYWORD_SET(clear_memory) THEN BEGIN
     CLEAR_STRANGEWAY_COMMON_VARS
     RETURN
  ENDIF

  IF KEYWORD_SET(force_load) THEN BEGIN
     IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,"Forcing load of Strangeway DB..."
  ENDIF

  ;; DefDBDir             = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  DefDBDir             = '/SPENCEdata/software/sdt/batch_jobs/saves_output_etc/Strangeway_2bands/'
  defCoordDir          = DefDBDir + 'alternate_coords/'

  ;; orbRangeStr          = '1436-5382'
  ;; DB_date              = '20170522'

  orbRangeStr          = '1000-9936'
  DB_date              = '20170523'

  DefDBFile            = 'Strangeway_2bands__orbs_' + orbRangeStr + '_EESAItvl.sav'
  DefDBEphemFile       = 'Strangeway_2bands__orbs_' + orbRangeStr + '_EESAItvl__ephem.sav'
  DefDBEphemExtFile    = 'Strangeway_2bands__orbs_' + orbRangeStr + '_EESAItvl__ephem_extended.sav'
  ;; DefDB_tFile          = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav'
  DB_version           = 'v0.0'
  DB_extras            = ''

  IF KEYWORD_SET(use_8Hz_DB) THEN BEGIN

     ;; orbRangeStr              = '1436-5382'
     ;; DB_date                  = '20170526'

     ;; orbRangeStr              = '1000-7705'
     ;; DB_date                  = '20170527'

     orbRangeStr              = '1000-9936'
     DB_date                  = '20170529'

     DefDBDir                 = '/SPENCEdata/software/sdt/batch_jobs/saves_output_etc/Strangeway_3bands/'
     DefDBFile                = 'Strangeway_3bands--also_E_near_B__orbs_' + orbRangeStr + '_EESAItvl-v0.sav'
     
     dBSuff                   = 'dB'
     eFieldSuff               = 'eField'
     pFluxSuff                = 'pFlux'
     ptclSuff                 = 'ptcl'
     magFlagsSuff             = 'magFlags'
     ephemSuff                = 'ephem'

     dBSWayVarName            = 'SWAY__8Hz_dB'
     eFieldSWayVarName        = 'SWAY__8Hz_eField'
     magFlagsSWayVarName      = 'SWAY__8Hz_magFlags'
     ptclSWayVarName          = 'SWAY__8Hz_ptcl'
     pFluxSWayVarName         = 'SWAY__8Hz_pFlux'
     ephemSWayVarName         = 'SWAY__8Hz_ephem'

     dBSWayStruct             = 'dB'      
     eFieldSWayStruct         = 'e'  
     magFlagsSWayStruct       = 'magFlags'
     ptclSWayStruct           = 'ptcl'   
     pFluxSWayStruct          = 'pFlux'   
     ephemSWayStruct          = 'ephem'   

     IF N_ELEMENTS(SWAY__8Hz_varsToLoad) NE 0 THEN BEGIN
        PRINT,"Did this screw up last time? This should be an empty var ..."
        PRINT,"NVars to load: ",SWAY__8Hz_NVarsToLoad
        PRINT,"Vars to load: ",SWAY__8Hz_varsToLoad
     ENDIF
     ;; IF N_ELEMENTS(SWAY__8Hz_varsToLoad) EQ 0 THEN BEGIN
     SWAY__8Hz_NVarsToLoad = 0
     SWAY__8Hz_varsToLoad  = !NULL
     SWAY8StructNames      = !NULL
     SWAY8FilSuffs         = !NULL
     ;; ENDIF

     IF N_ELEMENTS(SWAY__8Hz_varsLoaded) EQ 0 THEN BEGIN
        SWAY__8Hz_NVarsLoaded = 0
        SWAY__8Hz_varsLoaded  = !NULL
     ENDIF

     IF KEYWORD_SET(use_8Hz__sWay_plotType) THEN BEGIN

        IF SIZE(use_8Hz__sWay_plotType,/TYPE) NE 7 THEN BEGIN
           PRINT,"Supposed to provide a string, dimwit. You know, like pFlux.B.DC or dB.P.ACHigh or E.nearB.AC"
           STOP
        ENDIF

        use_8Hz__load_pFlux  = (WHERE(STRMATCH(STRUPCASE(use_8Hz__sWay_plotType),'PFLUX*')))[0] NE -1
        use_8Hz__load_ptcl   = (WHERE(STRMATCH(STRUPCASE(use_8Hz__sWay_plotType),'PTCL*' )))[0] NE -1
        use_8Hz__load_dB     = (WHERE(STRMATCH(STRUPCASE(use_8Hz__sWay_plotType),'DB*'   )))[0] NE -1
        use_8Hz__load_eField = (WHERE(STRMATCH(STRUPCASE(use_8Hz__sWay_plotType),'E.*'   )))[0] NE -1
     ENDIF

     use_8Hz__load_ephem     = 1
        
     IF KEYWORD_SET(use_8Hz__load_ptcl) THEN BEGIN
        IF SIZE(SWAY__8Hz_ptcl,/TYPE) EQ 8 AND ~KEYWORD_SET(force_load) THEN BEGIN

        ENDIF ELSE BEGIN
           SWAY__8Hz_varsToLoad  = [SWAY__8Hz_varsToLoad,ptclSWayVarName]
           SWAY__8Hz_NVarsToLoad++
           SWAY8StructNames      = [SWAY8StructNames,ptclSWayStruct]
           SWAY8FilSuffs         = [SWAY8FilSuffs,ptclSuff]
        ENDELSE
     ENDIF

     IF KEYWORD_SET(use_8Hz__load_pFlux) THEN BEGIN
        IF SIZE(SWAY__8Hz_pFlux,/TYPE) EQ 8 AND ~KEYWORD_SET(force_load) THEN BEGIN

        ENDIF ELSE BEGIN
           SWAY__8Hz_varsToLoad  = [SWAY__8Hz_varsToLoad,pFluxSWayVarName]
           SWAY__8Hz_NVarsToLoad++
           SWAY8StructNames      = [SWAY8StructNames,pFluxSWayStruct]
           SWAY8FilSuffs         = [SWAY8FilSuffs,pFluxSuff]
        ENDELSE
     ENDIF

     IF KEYWORD_SET(use_8Hz__load_dB) THEN BEGIN
        IF SIZE(SWAY__8Hz_dB,/TYPE) EQ 8 AND ~KEYWORD_SET(force_load) THEN BEGIN

        ENDIF ELSE BEGIN
           SWAY__8Hz_varsToLoad  = [SWAY__8Hz_varsToLoad,dBSWayVarName]
           SWAY__8Hz_NVarsToLoad++
           SWAY8StructNames      = [SWAY8StructNames,dBSWayStruct]
           SWAY8FilSuffs         = [SWAY8FilSuffs,dBSuff]
        ENDELSE
     ENDIF

     IF KEYWORD_SET(use_8Hz__load_eField) THEN BEGIN
        IF SIZE(SWAY__8Hz_eField,/TYPE) EQ 8 AND ~KEYWORD_SET(force_load) THEN BEGIN

        ENDIF ELSE BEGIN
           SWAY__8Hz_varsToLoad  = [SWAY__8Hz_varsToLoad,eFieldSWayVarName]
           SWAY__8Hz_NVarsToLoad++
           SWAY8StructNames      = [SWAY8StructNames,eFieldSWayStruct]
           SWAY8FilSuffs         = [SWAY8FilSuffs,eFieldSuff]
        ENDELSE
     ENDIF

     IF KEYWORD_SET(use_8Hz__load_magFlags) THEN BEGIN
        IF SIZE(SWAY__8Hz_magFlags,/TYPE) EQ 8 AND ~KEYWORD_SET(force_load) THEN BEGIN

        ENDIF ELSE BEGIN
           SWAY__8Hz_varsToLoad  = [SWAY__8Hz_varsToLoad,magFlagsSWayVarName]
           SWAY__8Hz_NVarsToLoad++
           SWAY8StructNames      = [SWAY8StructNames,magFlagsSWayStruct]
           SWAY8FilSuffs         = [SWAY8FilSuffs,magFlagsSuff]
        ENDELSE
     ENDIF

     IF KEYWORD_SET(use_8Hz__load_ephem) THEN BEGIN
        ;; IF SIZE(SWAY__8Hz_ephem,/TYPE) EQ 8 ~KEYWORD_SET(force_load) THEN BEGIN
        IF SIZE(SWAY__DB,/TYPE) EQ 8 AND ~KEYWORD_SET(force_load) THEN BEGIN
           ;; leMaitre              = TEMPORARY(SWAY__DB)
        ENDIF ELSE BEGIN
           SWAY__8Hz_varsToLoad  = [SWAY__8Hz_varsToLoad,ephemSWayVarName]
           SWAY__8Hz_NVarsToLoad++
           SWAY8StructNames      = [SWAY8StructNames,ephemSWayStruct]
           SWAY8FilSuffs         = [SWAY8FilSuffs,ephemSuff]
        ENDELSE
     ENDIF

     ;; PRINT,"Sorry, don't have that yet!"
     ;; STOP

  ENDIF

  ;;How to use magFlags, you wonder? Like'is:
  ;; theseVals = VALUE_LOCATE(leMaitre.magFlags.x,leMaitre.time)

  ;; DB__into_eSpec_file  = 'Dartdb_20151222--500-16361_inc_lower_lats--max_magCurrent_time_alfs_into_20170203_eSpecDB.sav'
  ;; DB__into_eSpec_file  = 'Dartdb_20151222--500-16361_inc_lower_lats--max_magCurrent_time_alfs_into_20170203_eSpecDB__good_i.sav'

  ;; AACGM_file           = 'alfDB-20151222_v0_0-AACGM.sav'
  ;; GEI_file             = 'alfDB-20151222_v0_0-GEI.sav'
  ;; GEO_file             = 'alfDB-20151222_v0_0-GEO.sav'
  ;; MAG_file             = 'alfDB-20151222_v0_0-MAG.sav'
  ;; SDT_file             = 'alfDB-20151222_v0_0-SDT.sav'

  IF KEYWORD_SET(check_DB) THEN BEGIN

     leMaitre        = N_ELEMENTS(SWAY__DB)             GT 0 ? SWAY__DB              : !NULL
     ;; cdbTime      = N_ELEMENTS(SWAY__times)          GT 0 ? SWAY__times           : !NULL
     good_i          = N_ELEMENTS(SWAY__good_i)         GT 0 ? SWAY__good_i          : !NULL
     DBFile          = N_ELEMENTS(SWAY__dbFile)         GT 0 ? SWAY__dbFile          : !NULL
     DBEphemFile     = N_ELEMENTS(SWAY__dbEphemFile)    GT 0 ? SWAY__dbEphemFile     : !NULL
     DBEphemExtFile  = N_ELEMENTS(SWAY__dbEphemExtFile) GT 0 ? SWAY__dbEphemExtFile  : !NULL
     DBDir           = N_ELEMENTS(SWAY__dbDir)          GT 0 ? SWAY__dbDir           : !NULL

     RETURN
  ENDIF

  IF N_ELEMENTS(DBDir) EQ 0 THEN DBDir = DefDBDir

  IF N_ELEMENTS(DBFile) EQ 0 THEN BEGIN
     DBFile          = DefDBFile
     DBEphemFile     = DefDBEphemFile
     DBEphemExtFile  = DefDBEphemExtFile
     ;; DB_tFile = DefDB_tFile
  ENDIF ELSE BEGIN
     IF (KEYWORD_SET(force_load) AND $
         (STRUPCASE(DBFile) EQ "FROM ELSEWHERE!")) $
     THEN BEGIN
        DBFile          = DefDBFile
        DBEphemFile     = DefDBEphemFile
        DBEphemExtFile  = DefDBEphemExtFile
        ;; DB_tFile     = DefDB_tFile
     ENDIF 
  ENDELSE
     
  CASE 1 OF
     KEYWORD_SET(use_8Hz_DB): BEGIN
        shouldLoad = SWAY__8Hz_NVarsToLoad NE 0
     END
     ELSE: BEGIN
        shouldLoad = (N_ELEMENTS(SWAY__DB) EQ 0)
     END
  ENDCASE


  IF shouldLoad THEN BEGIN

        CASE 1 OF
           KEYWORD_SET(use_8Hz_DB): BEGIN

              WHILE SWAY__8Hz_NVarsToLoad GT 0 DO BEGIN

                 ;; PRINT,"Loading " + SWAY__8Hz_varsToLoad[0] + ' ...'
                 PRINT,"Loading " + SWAY8StructNames[0] + ' ...'

                 thisFile             = STRSPLIT(defDBFile,'.sav',/REGEX,/EXTRACT) + '-' + SWAY8FilSuffs[0] + '.sav'

                 IF ~FILE_TEST(DBDir+thisFile) THEN STOP

                 RESTORE,DBDir+thisFile
                 execStr              = 'gotIt = SIZE('+SWAY8StructNames[0]+',/TYPE)'
                 bro                  = EXECUTE(execStr)
                 IF ~bro THEN STOP

                 CASE gotIt OF
                    0: BEGIN
                       PRINT,"Couldn't get " + SWAY8StructNames[0] + '!'
                       STOP
                    END
                    8:
                    ELSE: BEGIN
                       PRINT,"Strange(way)! What is " + SWAY8StructNames[0] + '?'
                       STOP
                    END
                 ENDCASE
                 
                 IF STRUPCASE(SWAY8StructNames[0]) NE 'EPHEM' THEN BEGIN
                    PRINT,"Swap " + SWAY8StructNames[0] + " to " + SWAY__8Hz_varsToLoad[0]
                    execStr2             = SWAY__8Hz_varsToLoad[0] + ' = TEMPORARY(' + SWAY8StructNames[0] + ')'
                    bro                  = EXECUTE(execStr2)
                    IF ~bro THEN STOP
                 ENDIF

                 checkSomeMore = N_ELEMENTS(SWAY__8Hz_varsLoaded) GT 0
                 IF checkSomeMore THEN BEGIN
                    IF (WHERE(STRUPCASE(SWAY__8Hz_varsLoaded) EQ SWAY__8Hz_varsToLoad[0]))[0] EQ -1 THEN BEGIN
                       SWAY__8Hz_varsLoaded = [SWAY__8Hz_varsLoaded,SWAY__8Hz_varsToLoad[0]]
                       SWAY__8Hz_NVarsLoaded++
                    ENDIF
                 ENDIF ELSE BEGIN
                       SWAY__8Hz_varsLoaded = [SWAY__8Hz_varsToLoad[0]]
                       SWAY__8Hz_NVarsLoaded++
                 ENDELSE

                 CASE SWAY__8Hz_NVarsToLoad OF
                    1: BEGIN
                       SWAY__8Hz_varsToLoad = !NULL
                       SWAY8StructNames     = !NULL
                       SWAY8FilSuffs        = !NULL
                    END
                    ELSE: BEGIN
                       SWAY__8Hz_varsToLoad = SWAY__8Hz_varsToLoad[1:-1]
                       SWAY8StructNames     = SWAY8StructNames[1:-1]
                       SWAY8FilSuffs        = SWAY8FilSuffs[1:-1]
                    END
                 ENDCASE
                 SWAY__8Hz_NVarsToLoad--

              ENDWHILE

              IF N_ELEMENTS(ephem) GT 0 THEN BEGIN
                 SWAY__DB                   = TEMPORARY(ephem)
              ENDIF

           END
           ELSE: BEGIN

              IF FILE_TEST(DBDir+DBFile) THEN BEGIN

                 ;; IF ~KEYWORD_SET(just_time) THEN BEGIN

                 PRINT,'Loading Strangeway DB ...'
                 
                 RESTORE,DBDir+DBEphemFile
                 RESTORE,DBDir+DBFile
                 ;; leMaitre = CREATE_STRUCT(TEMPORARY(ephem),'dB',leMaitre.db,'e',leMaitre.e,'pFlux',leMaitre.pFlux,'info',leMaitre.info)
                 SWAY__DB = CREATE_STRUCT(TEMPORARY(ephem),TEMPORARY(leMaitre))

              ENDIF

           END
        ENDCASE

        IF ~TAG_EXIST(SWAY__DB.info,'has_been_infoed') THEN BEGIN

           FASTDB__ADD_INFO_STRUCT,SWAY__DB, $
                                   /FOR_SWAY_DB, $
                                   DB_DIR=DBDir, $
                                   DB_DATE=DB_date, $
                                   DB_VERSION=DB_version, $
                                   DB_EXTRAS=DB_extras, $
                                   DB__INTO_ESPEC_FILE=DB__into_eSpec_file
           
           ;; IF KEYWORD_SET(use_8Hz_DB) THEN BEGIN
           ;;    leMaitre.info.is_8Hz_DB = 1B
           ;; ENDIF
           SWAY__DB.info.is_8Hz_DB   = BYTE(KEYWORD_SET(use_8Hz_DB))
           ;; SWAY__DB.info.have_ACHigh = TAG_EXIST(SWAY__DB.dB.p,'ACHIGH')
           SWAY__DB.info.have_ACHigh = SWAY__DB.info.is_8Hz_DB

        ENDIF

        ;; STOP

        ;; IF KEYWORD_SET(use_GEO) THEN BEGIN
        ;; geo = SWAY__DB.ephem
        ;; ENDIF
        ;; SWAY__DB.info.using_heavies  = KEYWORD_SET(using_heavies)

        ;; ENDIF

     IF SWAY__DB EQ !NULL AND ~KEYWORD_SET(just_time) THEN BEGIN
        PRINT,"Couldn't load SWAY__DB!"
        STOP
     ENDIF

     pDBStruct                         = PTR_NEW(TEMPORARY(SWAY__DB)) 

  ENDIF ELSE BEGIN

     IF KEYWORD_SET(noMem) THEN BEGIN
        PRINT,"Sending leMaitre from vars loaded in memory ..."
        leMaitre        = TEMPORARY(SWAY__DB)
        ;; cdbTime      = TEMPORARY(SWAY__times)
        DBFile          = TEMPORARY(SWAY__DBFile)
        DBEphemFile     = TEMPORARY(SWAY__DBEphemFile)
        DBEphemExtFile  = TEMPORARY(SWAY__DBEphemExtFile)
        ;; DB_tFile     = TEMPORARY(SWAY__DB_tFile)

        pDBStruct       = PTR_NEW(leMaitre) 

     ENDIF ELSE BEGIN
        IF ~KEYWORD_SET(quiet) THEN BEGIN
           PRINTF,lun,"There is already a leMaitre struct loaded! Not loading " + DBFile
        ENDIF
     ENDELSE

     DBFile          = N_ELEMENTS(SWAY__dbFile)         GT 0 ? SWAY__dbFile          : '(blank)'
     DBEphemFile     = N_ELEMENTS(SWAY__dbEphemFile)    GT 0 ? SWAY__dbEphemFile     : '(blank)'
     DBEphemExtFile  = N_ELEMENTS(SWAY__dbEphemExtFile) GT 0 ? SWAY__dbEphemExtFile  : '(blank)'
     ;; DB_tFile     = N_ELEMENTS(SWAY__dbTimesFile)    GT 0 ? SWAY__dbTimesFile     : '(blank)'
     ;; despunDB     = N_ELEMENTS(SWAY__despun)         GT 0 ? SWAY__despun          : !NULL

     pDBStruct       = PTR_NEW(SWAY__DB) 

  ENDELSE

  ;; IF N_ELEMENTS(SWAY__times) EQ 0 OR $
  ;;    KEYWORD_SET(force_load_cdbTime) OR $
  ;;    KEYWORD_SET(swap_DBs) THEN BEGIN
  ;;    IF KEYWORD_SET(force_load_cdbTime) THEN BEGIN
  ;;       IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,"Forcing load, whether or not we already have cdbTime..."
  ;;    ENDIF
  ;;    IF FILE_TEST(DBDir+DB_tFile) $
  ;;       AND ~KEYWORD_SET(just_leMaitre) $
  ;;    THEN BEGIN
  ;;       RESTORE,DBDir+DB_tFile
  ;;    ENDIF
  ;;    IF ( cdbTime EQ !NULL AND ~KEYWORD_SET(just_leMaitre) ) $         
  ;;    THEN BEGIN
  ;;       PRINT,"Couldn't load cdbTime!"
  ;;       STOP
  ;;    ENDIF
  ;; ENDIF ELSE BEGIN
  ;;    IF ~KEYWORD_SET(quiet) THEN BEGIN
  ;;       PRINTF,lun,"There is already a cdbTime struct loaded! Not loading " + DB_tFile
  ;;    ENDIF

  ;; ENDELSE

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;What type of delta do you want?
  FASTDBS__DELTA_SWITCHER, $
     (*pDBStruct), $
     OUT_WIDTH_MEASURE=width_measure, $
     DBDIR=DBDir, $
     LOAD_DELTA_T=load_delta_t, $
     LOAD_DELTA_ILAT_NOT_DELTA_T=load_dILAT, $
     LOAD_DELTA_ANGLE_FOR_WIDTH_TIME=load_dAngle, $
     LOAD_DELTA_X_FOR_WIDTH_TIME=load_dx, $
     DO_NOT_MAP_DELTA_T=do_not_map_delta_t, $
     MAP_SQRT_FLUXES=map_sqrt_fluxes, $
     DILAT_FILE=dILAT_file, $
     /FOR_SWAY_DB
  ;; FOR_FASTLOC_DB=fastLocDB, $
  ;; FOR_ESPEC_DB=eSpecDB, $
  ;; FOR_ION_DB=ionDB

  IF N_ELEMENTS(width_measure) GT 0 THEN BEGIN
     (*pDBStruct).width_time  = TEMPORARY(width_measure)
  ENDIF

  IF correct_fluxes AND ~KEYWORD_SET(just_time) THEN BEGIN

     IF ~(*pDBStruct).info.is_scaled.pFlux THEN BEGIN

        ;; (*pDBStruct).pflux.b.DC *= 1D-9
        ;; (*pDBStruct).pflux.b.AC *= 1D-9

        ;; (*pDBStruct).pflux.p.DC *= 1D-9
        ;; (*pDBStruct).pflux.p.AC *= 1D-9

        (*pDBStruct).info.is_scaled.pFlux = 1B

     ENDIF
     
     IF ~(*pDBStruct).info.is_mapped.pFlux AND ~KEYWORD_SET(do_not_map_pflux) THEN BEGIN

        CASE 1 OF
           KEYWORD_SET(use_8Hz_DB): BEGIN

              IF N_ELEMENTS(SWAY__8Hz_pFlux) GT 0 THEN BEGIN
                 PRINT,"Mapping sWay 8-Hz pFlux ..."
                 
                 SWAY__8Hz_pFlux.b.DC         *= (*pDBStruct).magRatio

                 FOR k=0,7 DO BEGIN

                    SWAY__8Hz_pFlux.b.AC[k,*]     *= (*pDBStruct).magRatio
                    SWAY__8Hz_pFlux.b.ACHigh[k,*] *= (*pDBStruct).magRatio

                 ENDFOR

                 (*pDBStruct).info.is_mapped.pFlux = 1B

              ENDIF

           END
           ELSE: BEGIN

              PRINT,"Mapping sWay pFlux ..."

              (*pDBStruct).pflux.b.DC *= (*pDBStruct).magRatio
              (*pDBStruct).pflux.b.AC *= (*pDBStruct).magRatio

              (*pDBStruct).info.is_mapped.pFlux = 1B

           END
        ENDCASE           
           

     ENDIF

     ;; CORRECT_ALFVENDB_FLUXES,(*pDBStruct), $
     ;;                         MAP_ESA_CURRENT_TO_IONOS=~KEYWORD_SET(do_not_map_esa_current) $
     ;;                         AND ~KEYWORD_SET(no_mapping), $
     ;;                         MAP_MAG_CURRENT_TO_IONOS=~KEYWORD_SET(do_not_map_mag_current) $
     ;;                         AND ~KEYWORD_SET(no_mapping), $
     ;;                         MAP_PFLUX_TO_IONOS=~KEYWORD_SET(do_not_map_pflux) $
     ;;                         AND ~KEYWORD_SET(no_mapping), $
     ;;                         MAP_IONFLUX_TO_IONOS=~KEYWORD_SET(do_not_map_ionflux) $
     ;;                         AND ~KEYWORD_SET(no_mapping), $
     ;;                         MAP_HEAVIES_TO_IONOS=~KEYWORD_SET(do_not_map_heavies) $
     ;;                         AND ~KEYWORD_SET(no_mapping), $
     ;;                         MAP_WIDTH_T_TO_IONOS=~KEYWORD_SET(do_not_map_width_t) $
     ;;                         AND ~KEYWORD_SET(no_mapping), $
     ;;                         MAP_WIDTH_X_TO_IONOS=~KEYWORD_SET(do_not_map_width_x) $
     ;;                         AND ~KEYWORD_SET(no_mapping), $
     ;;                         MAP_SQRT_FLUXES=map_sqrt_fluxes, $
     ;;                         DESPUNDB=despunDB, $
     ;;                         CHASTDB=chastDB, $
     ;;                         USING_HEAVIES=using_heavies, $
     ;;                         QUIET=quiet

  ENDIF ELSE BEGIN
     PRINTF,lun,"Not correcting fluxes in leMaitre ..."
  ENDELSE

  IF ~KEYWORD_SET(just_time) THEN BEGIN

     FASTDBS__COORDINATE_SWITCHER, $
        (*pDBStruct), $
        COORDINATE_SYSTEM=coordinate_system, $
        USE_LNG=use_lng, $
        USE_AACGM_COORDS=use_AACGM, $
        USE_GEI_COORDS=use_GEI, $
        USE_GEO_COORDS=use_GEO, $
        USE_MAG_COORDS=use_MAG, $
        USE_SDT_COORDS=use_SDT, $
        DEFCOORDDIR=defCoordDir, $
        AACGM_FILE=AACGM_file, $
        GEI_FILE=GEI_file, $
        GEO_FILE=GEO_file, $
        MAG_FILE=MAG_file, $
        SDT_FILE=SDT_file, $
        NO_MEMORY_LOAD=noMem, $
        CHANGEDCOORDS=changedCoords

  ENDIF

  IF ARG_PRESENT(good_i) THEN BEGIN

     SET_ALFVENDB_PLOT_DEFAULTS, $
        ORBRANGE=orbRange, $
        ALTITUDERANGE=altitudeRange, $
        CHARERANGE=charERange, $
        POYNTRANGE=poyntRange, $
        SAMPLE_T_RESTRICTION=sample_t_restriction, $
        INCLUDE_32HZ=include_32Hz, $
        DISREGARD_SAMPLE_T=disregard_sample_t, $
        /DONT_BLACKBALL_LEMAITRE, $
        ;; DONT_BLACKBALL_FASTLOC=dont_blackball_fastloc, $
        MINMLT=minM, $
        MAXMLT=maxM, $
        BINMLT=binM, $
        SHIFTMLT=shiftM, $
        MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
        HEMI=hemi__good_i, $
        NORTH=north, $
        SOUTH=south, $
        BOTH_HEMIS=both_hemis, $
        DAYSIDE=dayside, $
        NIGHTSIDE=nightside, $
        EQUAL_AREA_BINNING=EA_binning, $
        DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
        REVERSE_LSHELL=reverse_lShell, $
        MIN_MAGCURRENT=minMC, $
        MAX_NEGMAGCURRENT=maxNegMC, $
        HWMAUROVAL=HwMAurOval, $
        HWMKPIND=HwMKpInd, $
        MASKMIN=maskMin, $
        THIST_MASK_BINS_BELOW_THRESH=tHist_mask_bins_below_thresh, $
        DESPUNDB=despunDB, $
        COORDINATE_SYSTEM=coordinate_system, $
        USE_AACGM_COORDS=use_AACGM, $
        USE_MAG_COORDS=use_MAG, $
        ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
        MIMC_STRUCT=MIMC_struct, $
        RESET_STRUCT=reset, $
        _EXTRA=e
     
     good_i = GET_CHASTON_IND( $
              (*pDBStruct), $
              ;; MIN_MAGCURRENT=minMC, $
              ;; MAX_NEGMAGCURRENT=maxNegMC, $
              ;; INCLUDE_32HZ=include_32Hz, $
              ;; HEMI=KEYWORD_SET(hemi__good_i) ? hemi__good_i : 'BOTH', $
              ;; DESPUNDB=despunDB, $
              DBTIMES=cdbTime, $
              ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
              MIMC_STRUCT=MIMC_struct, $
              RESET_GOOD_INDS=KEYWORD_SET(swap_DBs))

     SWAY__good_i = good_i

  ENDIF

  ;; ENDIF

  IF ~KEYWORD_SET(noMem) THEN BEGIN
     SWAY__DB               = TEMPORARY(*pDBStruct)
     ;; SWAY__times                 = N_ELEMENTS(cdbTime)  GT 0 ? cdbTime  : !NULL
     ;; SWAY__dbTimesFile           = N_ELEMENTS(DB_tFile) GT 0 ? DB_tFile : !NULL
     ;; SWAY__despun                = KEYWORD_SET(despunDB)
     SWAY__dbFile                = TEMPORARY(DBFile         )
     SWAY__dbEphemFile           = TEMPORARY(DBEphemFile    )
     SWAY__dbEphemExtFile        = TEMPORARY(DBEphemExtFile )
     SWAY__dbDir                 = TEMPORARY(DBDir          )
  ENDIF ELSE BEGIN
     leMaitre                    = TEMPORARY(*pDBStruct)
  ENDELSE

  PTR_FREE,pDBStruct

END
