;;11/22/16
;;This is all for the eSpec DB.
;;Make sure to compile AACGM routines: @compile_aacgm.pro
;;First, we want to make sure the data are OK.
PRO JOURNAL__20161122__CONVERT_THE_REMAINING_FASTLOC_INDS_TO_AACGM

  COMPILE_OPT IDL2

  get_GEI_coords         = 0
  do_GEO_MAG_conversions = 0
  do_AACGM_conversions   = 1
  
  AACGM__only_GT32Hz_times = 1

  ;;Need dbFile to make names for the others
  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastloc,fastloc_times, $
                                 /FOR_ESPEC_DBS, $
                                 DBFILE=dbFile, $
                                 DB_TFILE=db_tFile, $
                                 DBDIR=dbDir

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Options for GEI anD GEO coord files
  dbDir              = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/'
  coordDir           = dbDir + 'alternate_coords/'
  GEI_coord_filename = dbFile + '--GEI_coords'
  GEO_MAG_filename   = dbFile + '--GEO_MAG_coords'
  defGEIStructName   = 'GEICoords'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;The rest of these options pertain to AACGM conversions

  orig_routineName  = 'JOURNAL__20161122__CONVERT_THE_REMAINING_FASTLOC_INDS_TO_AACGM'

  R_E               = 6371.2D   ;Earth radius in km, from IGRFLIB_V2.pro

  altitude_max      = 4400      ;in km, and risk nothing
  allow_fl_trace    = 1         ;Allow fieldline tracing for AACGM_v2?
  check_if_exists   = 1

  create_notAltitude_file = 0
  notAltitude_suff        = '--missed_indices--' + GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  convert_varnames_and_resave_outFiles = 0

  force_newCheckItvl = 1000

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Input

  ;;Just for reference--we don't actually use these here
  ephemFileIndArr  = [[      0], $
                      [     -1]]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;output
  outFiles         = coordDir + dbFile + '--AACGM_v2'

  ;; outFiles         = 'sorted--eSpec_20160607_db--Orbs_500-16361--AACGM_v2_coords' + $
  ;;                    ['_1','_2','_3']+'--recalc_for_every_point.sav--mydude'

  ;;In case we get cut off--think SNES emulator savestate
  tmpFiles         = coordDir+'TEMP_AACGM--' + dbFile + '--AACGM_coords'
  timeFiles        = coordDir+'TEMP_AACGM--' + dbFile + '--AACGM_coords--timestamps'

  ;;Convert these var names to standard names
  in_names = {GEOSph       : 'GEOSph_arr', $
              AACGMSph     : 'AACGMSph_arr', $
              GEOStruct    : 'GEO', $
              AACGMStruct  : 'AACGM', $
              coordStruct  : 'GEICoords', $
              timeStr      : 'timeTmpStr', $
              DBInd        : 'remaining_i'}

  defNames = {AACGMSph    : 'AACGMSph', $
              AACGMStruct : 'AACGMStruct', $
              restrictVar : 'restrict_ii', $
              DBInd       : 'DBInds', $
              DBIndName   : 'db_i'}

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Load 'er up
  ;;No need for noMem; LOAD_FASTLOC doesn't know about the associated COMMON vars.
  ;;Only GET_CHASTON_IND does ...

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Get GEO coordinates
  ;;We're only doing it for coords that haven't been converted, you know

  IF KEYWORD_SET(get_GEI_coords) THEN BEGIN
     GET_FAST_GEI_COORDS,fastLoc_times, $
                         /SAVE_GEI_COORDS, $
                         GEI_COORD_DIR=coordDir, $
                         GEI_COORD_FILENAME=GEI_coord_filename, $ 
                         GEI_STRUCT_NAME=defGEIStructName, $
                         ORIG_ROUTINENAME=orig_routineName, $
                         QUIET=quiet
     STOP
  ENDIF

  IF KEYWORD_SET(do_GEO_MAG_conversions) THEN BEGIN
     CONVERT_GEI_COORDS_TO_GEO_AND_MAG_COORDS, $
        fastLoc.time, $
        fastLoc_times, $
        GEI_FILE=GEI_coord_filename, $
        GEI_DIR=coordDir, $
        GEI_STRUCT_NAME=defGEIStructName, $
        OUTFILE=GEO_MAG_filename, $
        OUTDIR=coordDir, $
        ORIG_ROUTINENAME=orig_routineName
  ENDIF

  IF KEYWORD_SET(do_AACGM_conversions) THEN BEGIN

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;Are the data OK?
     ;;We're going to MAKE them OK
     negSamp_t_i = WHERE(fastloc.sample_t LT 0,nBungle,COMPLEMENT=notNegSamp_t_i)
     
     IF nBungle GT 0 THEN BEGIN
        PRINT,"Crudsicles! " + STRCOMPRESS(nBungle,/REMOVE_ALL) + ' instances of negative sample_t!'
        tmpNotTimes = fastloc_times[notNegSamp_t_i]
        tmpTimes    = fastloc_times[negSamp_t_i]

        ;;Some of them aren't negative--who are they?
        closeNot_ia = VALUE_CLOSEST2(tmpNotTimes,tmpTimes)
        
        ;;Find out who is close enough to these poor neg timestamps to actually act as proxy
        legitimate_cNot_iib = WHERE(ABS(tmpNotTimes[closeNot_ia]-tmpTimes) LE 2.5, $
                                    nLegit_iib, $
                                    NCOMPLEMENT=nFriendless, $
                                    COMPLEMENT=illegitimate_cNot_iib)

        IF legitimate_cNot_iib[0] NE -1 THEN BEGIN
           PRINT,"Using " + STRCOMPRESS(nLegit_iib,/REMOVE_ALL) + " neighboring sample_ts to fix the negs "
           fastLoc.sample_t[negSamp_t_i[legitimate_cNot_iib]] = fastLoc.sample_t[notNegSamp_t_i[closeNot_ia[legitimate_cNot_iib]]]
        ENDIF

        PRINT,"Setting sample_t to .125 for " + STRCOMPRESS(nFriendless,/REMOVE_ALL) + " inds ..."
        fastLoc.sample_t[negSamp_t_i[illegitimate_cNot_iib]] = 0.125

        negSamp_t_i = WHERE(fastloc.sample_t LT 0,nBungle,COMPLEMENT=notNegSamp_t_i)
        IF nBungle NE 0 THEN STOP

        ;; befNegSamp   = (negSamp_t_i-1) > 0
        ;; aftNegSamp   = (negSamp_t_i+1) < (N_ELEMENTS(fastLoc.sample_t) - 1)
        ;; IllHelp      = WHERE(fastLoc.sample_t[befNegSamp] GT 
        IF negSamp_t_i[0] EQ 0 THEN BEGIN
           STOP
        ENDIF

        IF negSamp_t_i[-1] EQ (N_ELEMENTS(fastLoc.sample_t)-1) THEN BEGIN
           STOP
        ENDIF
     ENDIF

     ;;Side thing--what sample rates are legitimate?
     ;;REMEMBER, for the ChastDB maximus.mode is actually maximus.sample_t (and vice versa)
     IF KEYWORD_SET(maximus__which_sample_rates) THEN BEGIN
        LOAD_MAXIMUS_AND_CDBTIME,maximus,/DO_CHASTDB
        uniqSampleT = UNIQ(maximus.mode,SORT(maximus.mode))

        PRINT,FORMAT='(A0,T35,"N")',"Sample T"
        FOR k=0,N_ELEMENTS(uniqSampleT)-1 DO $
           PRINT, $
           maximus.mode[uniqSampleT[k]], $
           N_ELEMENTS(WHERE(ABS(maximus.mode - maximus.mode[uniqSampleT[k]]) LT 1e-4,/NULL))
     ENDIF

     IF KEYWORD_SET(AACGM__only_GT32Hz_times) THEN BEGIN
        LOAD_FASTLOC_AND_FASTLOC_TIMES,!NULL,fl32_times,/INCLUDE_32HZ,/JUST_TIMES

        alreadyConverted_i = VALUE_CLOSEST2(fastloc_times,fl32_times)
        legit_already_ii   = WHERE(ABS(fastLoc_times[alreadyConverted_i]-fl32_times) LT 1e-3, $
                                   nAlready, $
                                   COMPLEMENT=illegit_already_ii, $
                                   NCOMPLEMENT=nNotLegit_already)

        IF nNotLegit_already GT 0 THEN BEGIN
           PRINT,"By my calculations, there were " + STRCOMPRESS(nNotLegit_already,/REMOVE_ALL) + " BOGUS AACGM fastLoc inds"
           PRINT,"Dig?"
           
           user__restrict_i = alreadyConverted_i[TEMPORARY(illegit_already_ii)]
           
        ENDIF
        
        toBeConverted_i = CGSETDIFFERENCE(LINDGEN(N_ELEMENTS(fastLoc_times)), $
                                          alreadyConverted_i, $
                                          NORESULT=-1, $
                                          COUNT=nToBeConverted)

        IF nToBeConverted GT 0 THEN BEGIN
           PRINT,"By my calculations, we still need to convert " + STRCOMPRESS(nToBeConverted,/REMOVE_ALL) + "fastLoc inds"
           PRINT,"Dig?"
           
           IF N_ELEMENTS(user__restrict_i) GT 0 THEN BEGIN
              user__restrict_i = CGSETUNION(toBeConverted_i,user__restrict_i,COUNT=nTotToConvert)
           ENDIF ELSE BEGIN
              user__restrict_i = TEMPORARY(toBeConverted_i)
              nTotToConvert    = N_ELEMENTS(user__restrict_i)
           ENDELSE
           
           PRINT,"So we're converting " + STRCOMPRESS(nTotToConvert,/REMOVE_ALL) + " inds to AACGM in total."

        ENDIF

     ENDIF

     CONVERT_GEO_TO_AACGM, $
        COORDFILES=GEO_MAG_filename, $
        GEICOORDFILES=GEI_coord_filename, $
        COORDDIR=coordDir, $
        TMPFILES=tmpFiles, $
        TIMEFILES=timeFiles, $
        EPHEMFILEINDARR=ephemFileIndArr, $
        OUTDIR=coordDir, $
        OUTFILES=outFiles, $
        ORIG_ROUTINENAME=orig_routineName, $
        R_E=R_E, $
        ALTITUDE_MAX=altitude_max, $
        ALLOW_FL_TRACE=allow_FL_trace, $
        CHECK_IF_EXISTS=check_if_exists, $
        CREATE_NOTALTITUDE_FILE=create_notAltitude_file, $
        NOTALTITUDE_SUFF=notAltitude_suff, $
        CONVERT_VARNAMES_AND_RESAVE_OUTFILES=convert_varNames_and_resave_outFiles, $
        FORCE_NEWCHECKITVL=force_newCheckItvl, $
        USER__RESTRICT_II=user__restrict_i, $
        IN_NAMES=in_names, $
        DEFNAMES=defNames

  ENDIF


END
