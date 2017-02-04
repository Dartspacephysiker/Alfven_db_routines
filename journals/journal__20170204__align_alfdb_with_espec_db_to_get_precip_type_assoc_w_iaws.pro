;;02/04/17
PRO JOURNAL__20170204__ALIGN_ALFDB_WITH_ESPEC_DB_TO_GET_PRECIP_TYPE_ASSOC_W_IAWS

  COMPILE_OPT IDL2

  startStop_file = '/SPENCEdata/software/sdt/batch_jobs/saves_output_etc/20160520--get_Newell_identification/alfven_startstop_times--500-16361_inc_lower_lats--burst_1000-16361.sav'

  outDir         = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  tooBigDiffFile = 'Dartdb_20151222--500-16361_inc_lower_lats--alfs_way_separated_from_eesa_obs.sav'

  @common__newell_espec.pro
  IF N_ELEMENTS(NEWELL__eSpec) EQ 0 THEN BEGIN
     LOAD_NEWELL_ESPEC_DB,/DO_NOT_MAP_DELTA_T,/DO_NOT_MAP_FLUXES,/DONT_PERFORM_CORRECTION
  ENDIF
  eSpecTimes   = (TEMPORARY(NEWELL__eSpec)).x

  @common__maximus_vars.pro
  IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
     LOAD_MAXIMUS_AND_CDBTIME
  ENDIF

  RESTORE,startStop_file
  IF N_ELEMENTS(alfven_start_time) NE N_ELEMENTS(MAXIMUS__maximus.orbit) OR $
     N_ELEMENTS(alfven_stop_time ) NE N_ELEMENTS(MAXIMUS__maximus.orbit) THEN STOP
  IF (WHERE(alfven_start_time EQ alfven_stop_time))[0] NE -1 THEN STOP

  ;;after start, closest inds
  ;; aS_c_i = VALUE_CLOSEST2(eSpecTimes,alfven_start_time,/ONLY_GE,EXTREME_I=extreme_aS_c_i)
  ;; ;;before stop, closest inds
  ;; bS_c_i = VALUE_CLOSEST2(eSpecTimes,alfven_stop_time ,/ONLY_LE,EXTREME_I=extreme_bS_c_i)

  aS_c_i = VALUE_CLOSEST2(eSpecTimes,alfven_start_time,EXTREME_I=extreme_aS_c_i)
  ;;before stop, closest inds
  bS_c_i = VALUE_CLOSEST2(eSpecTimes,alfven_stop_time ,EXTREME_I=extreme_bS_c_i)

  diff   = bS_c_i - aS_c_i
  tDiff = eSpecTimes[bS_c_i] - eSpecTimes[aS_c_i]
  IF (extreme_aS_c_i)[0] NE -1 THEN STOP
  IF (extreme_bS_c_i)[0] NE -1 THEN STOP

  ;;check 'em
  aS_c_ii = WHERE(eSpecTimes[aS_c_i] GE alfven_start_time,n_aS_true)
  bS_c_ii = WHERE(eSpecTimes[bS_c_i] LE alfven_stop_time,n_bS_true)

  samme_ii = WHERE(diff EQ 0,nSamme)
  bogus_ii = WHERE(diff LT 0,nBogus)
  multi_ii = WHERE(diff GT 0,nMulti)
  
  ;For the bogus, we probably overshot
  ;;middle closest_i
  m_c_i   = VALUE_CLOSEST2(eSpecTimes,MAXIMUS__times)
  midTDiff=ABS(eSpecTimes[m_c_i]-MAXIMUS__times)
  ;; m_cBetter_aS_ii = WHERE(midTDiff LT ABS(eSpecTimes[aS_c_ii]-
  
  STOP

  ;; bigDiff_i = WHERE(abs(tdiff) GT 10)
  ;;The midTDiff are the closest we can get, and if that isn't within two EESA samples I don't know what to say
  bigDiff_i = WHERE(ABS(midTDiff) GT 12)
  nTotAlf   = N_ELEMENTS(midTDiff)

  bigDiff   = {inds:bigDiff_i, $
               nTotAlf:nTotAlf, $
               INFO:MAXIMUS__maximus.info, $
               ORIGINATING_ROUTINE:"JOURNAL__20170204__ALIGN_ALFDB_WITH_ESPEC_DB_TO_GET_PRECIP_TYPE_ASSOC_W_IAWS", $
               DATE:GET_TODAY_STRING(/DO_YYYYMMDD_FMT)}

  PRINT,"Saving inds where supposed Alf obs is very, very far (temporally) from Alf obs"
  SAVE,bigDiff,FILENAME=outDir+tooBigDiffFile

END
