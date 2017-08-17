;;2017/02/09
PRO JOURNAL__20170209__ALIGN_ALFDB_WITH_CLOSEST_ESPEC_DB_TO_GET_PRECIP_TYPE

  COMPILE_OPT IDL2,STRICTARRSUBS

  orig_rtine       = 'JOURNAL__20170209__ALIGN_ALFDB_WITH_CLOSEST_ESPEC_DB_TO_GET_PRECIP_TYPE'

  outDir           = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  ;; tooBigDiffFile = 'Dartdb_20151222--500-16361_inc_lower_lats--alfs_way_separated_from_eesa_obs.sav'
  ;; alfIntoeSpecFile = 'Dartdb_20151222--500-16361_inc_lower_lats--max_magCurrent_time_alfs_into_20170203_eSpecDB.sav'
  alfIntoeSpecFile = 'Dartdb_20151222--500-16361_inc_lower_lats--max_magCurrent_time_alfs_into_20160607_eSpecDB.sav'

  @common__newell_espec.pro
  IF N_ELEMENTS(NEWELL__eSpec) EQ 0 THEN BEGIN
     ;; LOAD_NEWELL_ESPEC_DB,/DO_NOT_MAP_DELTA_T,/DO_NOT_MAP_FLUXES,/DONT_PERFORM_CORRECTION
     LOAD_NEWELL_ESPEC_DB,/DO_NOT_MAP_DELTA_T,/DO_NOT_MAP_FLUXES,/DONT_PERFORM_CORRECTION,/DONT_CONVERT_TO_STRICT_NEWELL
  ENDIF
  eSpecTimes   = NEWELL__eSpec.x

  @common__maximus_vars.pro
  IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
     LOAD_MAXIMUS_AND_CDBTIME
  ENDIF

  nTotAlf   = N_ELEMENTS(MAXIMUS__times)

  ;;See if you can abbreviate eSpecTimes, since it goes way past the alfDB
  CHECK_SORTED,NEWELL__eSpec.x,is_sorted
  IF ~is_sorted THEN STOP
  pastTheMark_i = WHERE(NEWELL__eSpec.x GT MAX(MAXIMUS__times))
  latest_i      = MIN(pastTheMark_i)
  ;; eSpecTimes    = NEWELL__eSpec.x[0:latest_i]
  
  
  alfDB__eSpec_inds = VALUE_CLOSEST2(NEWELL__eSpec.x,MAXIMUS__times, $
                                     EXTREME_I=extreme_i, $
                                     /CONSTRAINED)

  maxTDiff         = 10.
  disqualified_i   = WHERE(ABS(NEWELL__eSpec.x[alfDB__eSpec_inds]-MAXIMUS__times) GE maxTDiff, $
                           nDisqualified)

  ;; eSpec            = {X          : NEWELL__eSpec.X         [alfDB__eSpec_inds], $
  ;;                     orbit      : NEWELL__eSpec.orbit     [alfDB__eSpec_inds], $
  ;;                     MLT        : NEWELL__eSpec.MLT       [alfDB__eSpec_inds], $
  ;;                     ILAT       : NEWELL__eSpec.ILAT      [alfDB__eSpec_inds], $
  ;;                     alt        : NEWELL__eSpec.alt       [alfDB__eSpec_inds], $
  ;;                     mono       : NEWELL__eSpec.mono      [alfDB__eSpec_inds], $
  ;;                     broad      : NEWELL__eSpec.broad     [alfDB__eSpec_inds], $
  ;;                     diffuse    : NEWELL__eSpec.diffuse   [alfDB__eSpec_inds], $
  ;;                     je         : NEWELL__eSpec.je        [alfDB__eSpec_inds], $
  ;;                     jee        : NEWELL__eSpec.jee       [alfDB__eSpec_inds], $
  ;;                     nBad_eSpec : NEWELL__eSpec.nBad_eSpec[alfDB__eSpec_inds], $
  ;;                     mapFactor  : NEWELL__eSpec.mapFactor [alfDB__eSpec_inds], $
  ;;                     eSpec_info : NEWELL__eSpec.info                         , $
  ;;                     alfDB_info : MAXIMUS__maximus.info                      }



  PRINT,FORMAT='("Could disqualify ",I0," inds that are more than ",F0.2," s from the time of max IAW current")',nDisqualified,maxTDiff
  ;; IF nDisqualified GT 0 THEN BEGIN
  ;;    alfDB__eSpec_inds[disqualified_i] = -1
  ;; ENDIF

  alf_into_eSpecDB = {inds:alfDB__eSpec_inds, $                 
                      ALFDB_INFO:MAXIMUS__maximus.info, $
                      ESPEC_INFO:NEWELL__eSpec.info, $
                      ORIGINATING_ROUTINE:orig_rtine, $
                      DATE:GET_TODAY_STRING(/DO_YYYYMMDD_FMT)}

  PRINT,"Saving eSpecDB inds corresponding to EESA obs nearest to IAW obs"
  SAVE,alf_into_eSpecDB,FILENAME=outDir+alfIntoeSpecFile

  STOP

END
