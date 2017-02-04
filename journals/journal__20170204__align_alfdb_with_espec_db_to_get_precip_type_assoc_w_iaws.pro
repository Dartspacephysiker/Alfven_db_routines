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
  IF (WHERE(alfven_start_time GE alfven_stop_time))[0] NE -1 THEN STOP

  nTotAlf   = N_ELEMENTS(MAXIMUS__times)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;The closest to game time

  ;;middle closest_i
  m_c_i           = VALUE_CLOSEST2(eSpecTimes,MAXIMUS__times)
  midTDiff        = ABS(eSpecTimes[m_c_i]-MAXIMUS__times)
  bigDiff_alfDB_i = WHERE(ABS(midTDiff) GT 12 OR $
                          ((alfven_stop_time-alfven_start_time) GT 20), $
                          nBigDiff, $
                          COMPLEMENT=keep_ii, $
                          NCOMPLEMENT=nKeep)

  eSpec_keep_i    = m_c_i[keep_ii]

  ;;NOTE that alfDB inds are offset one level from eSpec inds
  aTKeep1 = alfven_start_time[keep_ii]
  aTKeep2 = alfven_stop_time[keep_ii]
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;These ones are after start and before stop

  ;;after start, closest inds
  ;; aS_c_i = VALUE_CLOSEST2(eSpecTimes,aTKeep1,/ONLY_GE,EXTREME_I=extreme_aS_c_i)
  ;; ;;before stop, closest inds
  ;; bS_c_i = VALUE_CLOSEST2(eSpecTimes,aTKeep2 ,/ONLY_LE,EXTREME_I=extreme_bS_c_i)

  ;; diff   = bS_c_i - aS_c_i
  ;; tDiff  = eSpecTimes[bS_c_i] - eSpecTimes[aS_c_i]
  ;; IF (extreme_aS_c_i)[0] NE -1 THEN STOP
  ;; IF (extreme_bS_c_i)[0] NE -1 THEN STOP

  ;; ;;check 'em
  ;; aS_c_ii = WHERE(eSpecTimes[aS_c_i] GE aTKeep1,n_aS_true)
  ;; bS_c_ii = WHERE(eSpecTimes[bS_c_i] LE aTKeep2,n_bS_true)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;These ones are simply closest
  nearStrt_c_ii = VALUE_CLOSEST2(eSpecTimes,aTKeep1,EXTREME_I=extreme_nearStrt_c_ii)
  ;;before stop, closest inds
  nearStop_c_ii = VALUE_CLOSEST2(eSpecTimes,aTKeep2 ,EXTREME_I=extreme_nearStop_c_ii)


  diff   = nearStop_c_ii - nearStrt_c_ii
  tDiff  = eSpecTimes[nearStop_c_ii] - eSpecTimes[nearStrt_c_ii]

  IF (extreme_nearStrt_c_ii)[0] NE -1 THEN STOP
  IF (extreme_nearStop_c_ii)[0] NE -1 THEN STOP
  samme_iii = WHERE(diff EQ 0,nSamme)
  bogus_iii = WHERE(diff LT 0,nBogus)
  multi_iii = WHERE(diff GT 0,nMulti)
  
  inside_iii = WHERE((eSpecTimes[nearStrt_c_ii] GE aTKeep1) AND $
                     (eSpecTimes[nearStop_c_ii] LE aTKeep2), $
                     nInside, $
                     COMPLEMENT=outside_iii, $
                     NCOMPLEMENT=nOutside)

  ;For the bogus, we probably overshot
  
  minDiff = MIN(diff[multi_iii])
  maxDiff = MAX(diff[multi_iii])
  PRINT,FORMAT='(A0,T10,A0,T20,A0)',"DIFF","TDIFF","N"
  FOR k=minDiff,maxDiff DO BEGIN
     thisDiff_iv = WHERE(diff[multi_iii] EQ k,nThisDiff)

     IF nThisDiff GT 0 THEN BEGIN
        avgTDiff = MEAN(tDiff[thisDiff_iv])
     ENDIF ELSE BEGIN
        avgTDiff = 0.
     ENDELSE

     PRINT,FORMAT='(I0,T10,F0.2,T20,I0)', $
           k,avgTDiff,nThisDiff
  ENDFOR

  alf_event_objArr_into_eSpec_i = MAKE_ARRAY(nTotAlf,/OBJ)
  nGot = 0
  FOR k=0,nMulti-1 DO BEGIN
     tmp_iii  = multi_iii[k]
     tmp_ii   = [(nearStrt_c_ii[tmp_iii]):(nearStop_c_ii[tmp_iii])]

     ;;You're confused right here. Does this make sense? Should you be using eSpec_keep_i[tmp_ii] instead of just tmp_ii?
     ;;No, I think not! nearStrt_c_ii and nearStop_c_ii index straight into eSpecTimes, so that's good!
     ;;nearStrt_c_ii and nearStop_c_ii also INDIRECTLY map into the AlfDB inds via keep_ii.
     tmpTimes = eSpecTimes[tmp_ii]

     test_iii = WHERE(tmpTimes GE aTKeep1[tmp_iii] AND $
                      tmpTimes LE aTKeep2[tmp_iii], $
                      nTest)
     IF nTest GT 0 THEN BEGIN
        PRINT,keep_ii[tmp_iii],nTest,": ",tmp_ii
        alf_event_objArr_into_eSpec_i[keep_ii[tmp_iii]] = LIST(tmp_ii)
        nGot++
     ENDIF
  ENDFOR
  PRINT,"nGot: ",nGot

  STOP

  ;; bigDiff_i = WHERE(abs(tdiff) GT 10)
  ;;The midTDiff are the closest we can get, and if that isn't within two EESA samples I don't know what to say
  bigDiff   = {inds:bigDiff_alfDB_i, $
               nTotAlf:nTotAlf, $
               INFO:MAXIMUS__maximus.info, $
               ORIGINATING_ROUTINE:"JOURNAL__20170204__ALIGN_ALFDB_WITH_ESPEC_DB_TO_GET_PRECIP_TYPE_ASSOC_W_IAWS", $
               DATE:GET_TODAY_STRING(/DO_YYYYMMDD_FMT)}

  PRINT,"Saving inds where supposed Alf obs is very, very far (temporally) from Alf obs"
  SAVE,bigDiff,FILENAME=outDir+tooBigDiffFile

END
