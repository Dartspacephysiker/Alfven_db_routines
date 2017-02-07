;;02/04/17
PRO JOURNAL__20170204__ALIGN_ALFDB_WITH_ESPEC_DB_TO_GET_PRECIP_TYPE_ASSOC_W_IAWS

  COMPILE_OPT IDL2

  startStop_file   = '/SPENCEdata/software/sdt/batch_jobs/saves_output_etc/20160520--get_Newell_identification/alfven_startstop_times--500-16361_inc_lower_lats--burst_1000-16361.sav'

  outDir           = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  ;; tooBigDiffFile = 'Dartdb_20151222--500-16361_inc_lower_lats--alfs_way_separated_from_eesa_obs.sav'
  alfIntoeSpecFile = 'Dartdb_20151222--500-16361_inc_lower_lats--alfs_into_20170203_eSpecDB.sav'

  @common__newell_espec.pro
  IF N_ELEMENTS(NEWELL__eSpec) EQ 0 THEN BEGIN
     LOAD_NEWELL_ESPEC_DB,/DO_NOT_MAP_DELTA_T,/DO_NOT_MAP_FLUXES,/DONT_PERFORM_CORRECTION
  ENDIF
  eSpec_info   = NEWELL__eSpec.info
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

  ;;See if you can abbreviate eSpecTimes, since it goes way past the alfDB
  CHECK_SORTED,eSpecTimes,is_sorted
  IF ~is_sorted THEN STOP
  pastTheMark_i = WHERE(eSpecTimes GT MAX(alfven_stop_time))
  latest_i      = MIN(pastTheMark_i)
  eSpecTimes    = eSpecTimes[0:latest_i]
  
  ;;2017/02/06 All of what is below is based on my previous understanding. But now I've looked at ALFVEN_STATS_5, and the big
  ;;idea is to just look for alfWaves that have eSpec obs in between the start and stop time. Those that don't just get
  ;;associated with the nearest measurement.
  
  ;;Zeroth, make an array for all of the winners
  ;;The zeroth index gives inds into the eSpec DB that are ≤ 3 s before the alfven_start_time
  ;;The first  index gives inds into the eSpec DB that are sitting ON the alfven_start_time
  ;;The next four indices gives inds into the eSpec DB that are sitting between the alfven_start_time and the alfven_stop_time
  ;;The sixth index gives inds into the eSpec DB that are sitting ON the alfven_stop_time
  ;;The seventh index gives inds into the eSpec DB that are ≤ 3 s after the alfven_stop_time
  
  ;; alfDB__eSpec_inds     = MAKE_ARRAY(nTotAlf,8,/LONG,VALUE=-1L)
  ;; onStopInd             = 6
  ;; aftStopInd            = 7
  alfDB__eSpec_inds     = MAKE_ARRAY(nTotAlf,6,/LONG,VALUE=-1L)
  onStopInd             = 4
  aftStopInd            = 5
  checkTRange_startStop = MAKE_ARRAY(nTotAlf,2,/DOUBLE,VALUE=0.D)
  checkTRange_stop      = MAKE_ARRAY(nTotAlf,/DOUBLE,VALUE=0.D)

  ;;First, find all the eSpec points that are within 3 seconds of the start time
  eSpec_bef_alfStart_i              = VALUE_CLOSEST2(eSpecTimes,alfven_start_time,/ONLY_LE,EXTREME_I=eSpec_bef_alfStart_i__extreme)
  eSpec_on_alfStart_ii              = WHERE(eSpecTimes[eSpec_bef_alfStart_i] EQ alfven_start_time, $
                                            n_eSpec_on_alfStart)              
  eSpec_within_3sec_bef_alfStart_ii = WHERE((alfven_start_time - eSpecTimes[eSpec_bef_alfStart_i]) LE 3. AND $
                                            (alfven_start_time - eSpecTimes[eSpec_bef_alfStart_i]) GT 0., $
                                            n_eSpec_within_3sec_bef_alfStart, $
                                            COMPLEMENT=eSpec_NOT_within_3sec_bef_alfStart_ii, $
                                            NCOMPLEMENT=n_eSpec_NOT_within_3sec_bef_alfStart)

  eSpec_aft_alfStop_i               = VALUE_CLOSEST2(eSpecTimes,alfven_stop_time,/ONLY_GE,EXTREME_I=eSpec_aft_alfStop_i__extreme)
  eSpec_on_alfStop_ii               = WHERE(eSpecTimes[eSpec_aft_alfStop_i] EQ alfven_stop_time, $
                                            n_eSpec_on_alfStop)              
  eSpec_within_3sec_aft_alfStop_ii  = WHERE((eSpecTimes[eSpec_aft_alfStop_i] - alfven_stop_time ) LE 3. AND $
                                            (eSpecTimes[eSpec_aft_alfStop_i] - alfven_stop_time ) GT 0., $
                                            n_eSpec_within_3sec_aft_alfStop, $
                                            COMPLEMENT=eSpec_NOT_within_3sec_aft_alfStop_ii, $
                                            NCOMPLEMENT=n_eSpec_NOT_within_3sec_aft_alfStop)

  eSpec_on_alfStart_i                 = !NULL
  eSpec_on_alfStop_i                  = !NULL
  eSpec_within_3sec_bef_alfStart_i    = !NULL
  eSpec_within_3sec_aft_alfStop_i     = !NULL
  
  IF eSpec_bef_alfStart_i[0] NE -1 THEN BEGIN
     IF eSpec_within_3sec_bef_alfStart_ii[0] NE -1 THEN BEGIN
        PRINT,"Loading 'em up with eSpec_within_3sec_bef_alfStarters ..."
        eSpec_within_3sec_bef_alfStart_i                            = eSpec_bef_alfStart_i[eSpec_within_3sec_bef_alfStart_ii]
        alfDB__eSpec_inds[eSpec_within_3sec_bef_alfStart_ii,0]      = eSpec_within_3sec_bef_alfStart_i
        checkTRange_startStop[eSpec_within_3sec_bef_alfStart_ii,0]  = eSpecTimes[eSpec_within_3sec_bef_alfStart_i]
        eSpec_within_3sec_bef_alfStart_i                            = !NULL
     ENDIF
     IF eSpec_on_alfStart_ii[0] NE -1 THEN BEGIN
        PRINT,"Loading 'em up with eSpec_on_alfStarters ..."
        eSpec_on_alfStart_i                                         = eSpec_bef_alfStart_i[eSpec_on_alfStart_ii]
        alfDB__eSpec_inds[eSpec_on_alfStart_ii,1]                   = eSpec_on_alfStart_i
        checkTRange_startStop[eSpec_on_alfStart_ii,0]               = eSpecTimes[eSpec_on_alfStart_i]
        eSpec_on_alfStart_i                                         = !NULL
     ENDIF
  ENDIF
  
  IF eSpec_aft_alfStop_i[0] NE -1 THEN BEGIN
     IF eSpec_on_alfStop_ii[0] NE -1 THEN BEGIN
        PRINT,"Loading 'em up with eSpec_on_alfStoppers ..."
        eSpec_on_alfStop_i                                          = eSpec_aft_alfStop_i[eSpec_on_alfStop_ii]
        alfDB__eSpec_inds[eSpec_on_alfStop_ii,onStopInd]            = eSpec_on_alfStop_i
        checkTRange_startStop[eSpec_on_alfStop_ii,1]                = eSpecTimes[eSpec_on_alfStop_i]
        eSpec_on_alfStop_i                                          = !NULL
     ENDIF
     IF eSpec_within_3sec_aft_alfStop_ii[0] NE -1 THEN BEGIN
        PRINT,"Loading 'em up with eSpec_within_3sec_bef_alfStoppers ..."
        eSpec_within_3sec_aft_alfStop_i                             = eSpec_aft_alfStop_i[eSpec_within_3sec_aft_alfStop_ii]
        alfDB__eSpec_inds[eSpec_within_3sec_aft_alfStop_ii,aftStopInd] = eSpec_within_3sec_aft_alfStop_i
        checkTRange_startStop[eSpec_within_3sec_aft_alfStop_ii,1]   = eSpecTimes[eSpec_within_3sec_aft_alfStop_i]
        eSpec_within_3sec_aft_alfStop_i                             = !NULL
     ENDIF
  ENDIF
  
  ;;Get those times!!
  fillin_startT_ii                                                  = WHERE(checkTRange_startStop[*,0] EQ 0.D,n_fillin_startT)
  IF fillin_startT_ii[0] NE -1 THEN BEGIN
     PRINT,"Filling in " + STRCOMPRESS(n_fillin_startT,/REMOVE_ALL) + " start times with alfDB times ..."
     checkTRange_startStop[fillin_startT_ii,0]                      = alfven_start_time[fillin_startT_ii]
  ENDIF

  fillin_stopT_ii                                                   = WHERE(checkTRange_startStop[*,1] EQ 0.D,n_fillin_stopT)
  IF fillin_stopT_ii[0] NE -1 THEN BEGIN
     PRINT,"Filling in " + STRCOMPRESS(n_fillin_stopT,/REMOVE_ALL) + " stop times with alfDB times ..."
     checkTRange_startStop[fillin_stopT_ii,1]                       = alfven_stop_time[fillin_stopT_ii]
  ENDIF

  ;;Now all that remains are the in-betweeners
  

  ;;The acceptable time diffs are LE 10.0 s
  alfDB__acceptable_tDiff_ii = WHERE((alfven_stop_time - alfven_start_time) LE 10. AND $
                                     (alfven_stop_time - alfven_start_time) GT 0., $
                                     n_acceptable_tDiff, $
                                     COMPLEMENT=alfDB__NOT_acceptable_tDiff_ii, $
                                     NCOMPLEMENT=n_alfDB__NOT_acceptable_tDiff)

  ;; FOR k=0,nTotAlf-1 DO BEGIN
  ;; nMulti = 0
  ;; min_i  = 0
  ;; n_eSpecT = N_ELEMENTS(eSpecTimes)-1
  ;; FOR k=0,n_acceptable_tDiff-1 DO BEGIN
  ;;    realK = alfDB__acceptable_tDiff_ii[k]
     
  ;;    tmpInds = [min_i:n_eSpecT]
  ;;    tmp_i = WHERE((eSpecTimes[tmpInds] GT checkTRange_startStop[realK,0]) AND $
  ;;                  (eSpecTimes[tmpInds] LT checkTRange_startStop[realK,1]),    $
  ;;                  nTmp)
     
  ;;    IF nTmp GT 0 THEN BEGIN
        
  ;;       IF nTmp GT 4 THEN STOP
        
  ;;       alfDB__eSpec_inds[realK,[2+[0:(nTmp-1)]]] = tmp_i

  ;;       nMulti++

  ;;       min_i = MAX(tmp_i)
  ;;    ENDIF
     
  ;; ENDFOR
  
  startMulti_i = VALUE_CLOSEST2(eSpecTimes,checkTRange_startStop[*,0],/ONLY_GE)
  stopMulti_i  = VALUE_CLOSEST2(eSpecTimes,checkTRange_startStop[*,1],/ONLY_LE)
  
  multi_in_ii  = WHERE((stopMulti_i - startMulti_i) GT 0,n_multi_in )
  single_in_ii = WHERE((stopMulti_i - startMulti_i) EQ 0,n_single_in)

  IF multi_in_ii[0] EQ -1 THEN STOP

  IF (n_acceptable_tDiff GT 0) AND (n_multi_in GT 0) THEN BEGIN
     multiAccept_ii = CGSETINTERSECTION(multi_in_ii,alfDB__acceptable_tDiff_ii,COUNT=nMultiAccept,NORESULT=-1)

     IF nMultiAccept GT 0 THEN BEGIN
        alfDB__eSpec_inds[multi_in_ii,2] = startMulti_i[multiAccept_ii]
        alfDB__eSpec_inds[multi_in_ii,3] = stopMulti_i[multiAccept_ii]
     ENDIF
  ENDIF
  ;;YOU ARE HERE, TRYING TO MAKE SURE EVENTS THAT ARE TOO LONG DON'T SNEAK IN
  alfDB__eSpec_inds[multi_in_ii,2] = startMulti_i[multi_in_ii]
  alfDB__eSpec_inds[multi_in_ii,3] = stopMulti_i[multi_in_ii]

  alfDB__eSpec_inds[single_in_ii,2] = startMulti_i[single_in_ii]
  alfDB__eSpec_inds[single_in_ii,3] = stopMulti_i[single_in_ii]

  bro  = TOTAL(alfDB__eSpec_inds,2,/INTEGER)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;The closest to game time

  ;;middle closest_i
  ;; m_c_i           = VALUE_CLOSEST2(eSpecTimes,MAXIMUS__times)
  ;; midTDiff        = ABS(eSpecTimes[m_c_i]-MAXIMUS__times)
  ;; bigDiff_alfDB_i = WHERE(ABS(midTDiff) GT 12 OR $
  ;;                         ((alfven_stop_time-alfven_start_time) GT 20), $
  ;;                         nBigDiff, $
  ;;                         COMPLEMENT=keep_ii, $
  ;;                         NCOMPLEMENT=nKeep)

  ;; eSpec_keep_i    = m_c_i[keep_ii]

  ;; ;;NOTE that alfDB inds are offset one level from eSpec inds
  ;; aTKeep1 = alfven_start_time[keep_ii]
  ;; aTKeep2 = alfven_stop_time[keep_ii]
  ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; ;;These ones are after start and before stop

  ;; ;;after start, closest inds
  ;; ;; aS_c_i = VALUE_CLOSEST2(eSpecTimes,aTKeep1,/ONLY_GE,EXTREME_I=extreme_aS_c_i)
  ;; ;; ;;before stop, closest inds
  ;; ;; bS_c_i = VALUE_CLOSEST2(eSpecTimes,aTKeep2 ,/ONLY_LE,EXTREME_I=extreme_bS_c_i)

  ;; ;; diff   = bS_c_i - aS_c_i
  ;; ;; tDiff  = eSpecTimes[bS_c_i] - eSpecTimes[aS_c_i]
  ;; ;; IF (extreme_aS_c_i)[0] NE -1 THEN STOP
  ;; ;; IF (extreme_bS_c_i)[0] NE -1 THEN STOP

  ;; ;; ;;check 'em
  ;; ;; aS_c_ii = WHERE(eSpecTimes[aS_c_i] GE aTKeep1,n_aS_true)
  ;; ;; bS_c_ii = WHERE(eSpecTimes[bS_c_i] LE aTKeep2,n_bS_true)

  ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; ;;These ones are simply closest
  ;; nearStrt_c_ii = VALUE_CLOSEST2(eSpecTimes,aTKeep1,EXTREME_I=extreme_nearStrt_c_ii)
  ;; ;;before stop, closest inds
  ;; nearStop_c_ii = VALUE_CLOSEST2(eSpecTimes,aTKeep2 ,EXTREME_I=extreme_nearStop_c_ii)


  ;; diff   = nearStop_c_ii - nearStrt_c_ii
  ;; tDiff  = eSpecTimes[nearStop_c_ii] - eSpecTimes[nearStrt_c_ii]

  ;; IF (extreme_nearStrt_c_ii)[0] NE -1 THEN STOP
  ;; IF (extreme_nearStop_c_ii)[0] NE -1 THEN STOP
  ;; samme_iii = WHERE(diff EQ 0,nSamme)
  ;; bogus_iii = WHERE(diff LT 0,nBogus)
  ;; multi_iii = WHERE(diff GT 0,nMulti)
  
  ;; inside_iii = WHERE((eSpecTimes[nearStrt_c_ii] GE aTKeep1) AND $
  ;;                    (eSpecTimes[nearStop_c_ii] LE aTKeep2), $
  ;;                    nInside, $
  ;;                    COMPLEMENT=outside_iii, $
  ;;                    NCOMPLEMENT=nOutside)

  ;; ;For the bogus, we probably overshot
  
  ;; minDiff = MIN(diff[multi_iii])
  ;; maxDiff = MAX(diff[multi_iii])
  ;; PRINT,FORMAT='(A0,T10,A0,T20,A0)',"DIFF","TDIFF","N"
  ;; FOR k=minDiff,maxDiff DO BEGIN
  ;;    thisDiff_iv = WHERE(diff[multi_iii] EQ k,nThisDiff)

  ;;    IF nThisDiff GT 0 THEN BEGIN
  ;;       avgTDiff = MEAN(tDiff[thisDiff_iv])
  ;;    ENDIF ELSE BEGIN
  ;;       avgTDiff = 0.
  ;;    ENDELSE

  ;;    PRINT,FORMAT='(I0,T10,F0.2,T20,I0)', $
  ;;          k,avgTDiff,nThisDiff
  ;; ENDFOR

  ;; alf_event_objArr_into_eSpec_i = MAKE_ARRAY(nTotAlf,/OBJ)
  ;; nGot = 0
  ;; FOR k=0,nMulti-1 DO BEGIN
  ;;    tmp_iii  = multi_iii[k]
  ;;    tmp_ii   = [(nearStrt_c_ii[tmp_iii]):(nearStop_c_ii[tmp_iii])]

  ;;    ;;You're confused right here. Does this make sense? Should you be using eSpec_keep_i[tmp_ii] instead of just tmp_ii?
  ;;    ;;No, I think not! nearStrt_c_ii and nearStop_c_ii index straight into eSpecTimes, so that's good!
  ;;    ;;nearStrt_c_ii and nearStop_c_ii also INDIRECTLY map into the AlfDB inds via keep_ii.
  ;;    tmpTimes = eSpecTimes[tmp_ii]

  ;;    test_iii = WHERE(tmpTimes GE aTKeep1[tmp_iii] AND $
  ;;                     tmpTimes LE aTKeep2[tmp_iii], $
  ;;                     nTest)
  ;;    IF nTest GT 0 THEN BEGIN
  ;;       PRINT,keep_ii[tmp_iii],nTest,": ",tmp_ii
  ;;       alf_event_objArr_into_eSpec_i[keep_ii[tmp_iii]] = LIST(tmp_ii)
  ;;       nGot++
  ;;    ENDIF
  ;; ENDFOR
  ;; PRINT,"nGot: ",nGot

  ;; STOP

  ;; bigDiff_i = WHERE(abs(tdiff) GT 10)
  ;;The midTDiff are the closest we can get, and if that isn't within two EESA samples I don't know what to say
  
  ;; bigDiff   = {inds:bigDiff_alfDB_i, $
  ;;              nTotAlf:nTotAlf, $
  ;;              INFO:MAXIMUS__maximus.info, $
  ;;              ORIGINATING_ROUTINE:"JOURNAL__20170204__ALIGN_ALFDB_WITH_ESPEC_DB_TO_GET_PRECIP_TYPE_ASSOC_W_IAWS", $
  ;;              DATE:GET_TODAY_STRING(/DO_YYYYMMDD_FMT)}

  ;; PRINT,"Saving inds where supposed Alf obs is very, very far (temporally) from Alf obs"
  ;; SAVE,bigDiff,FILENAME=outDir+tooBigDiffFile

  alf_into_eSpecDB = {inds:alfDB__eSpec_inds, $
                      ALFDB_INFO:MAXIMUS__maximus.info, $
                      ESPEC_INFO:eSpec_info, $
                      ORIGINATING_ROUTINE:"JOURNAL__20170204__ALIGN_ALFDB_WITH_ESPEC_DB_TO_GET_PRECIP_TYPE_ASSOC_W_IAWS", $
                      DATE:GET_TODAY_STRING(/DO_YYYYMMDD_FMT)}

  PRINT,"Saving inds where supposed Alf obs is very, very far (temporally) from Alf obs"
  SAVE,alf_into_eSpecDB,FILENAME=outDir+alfIntoeSpecFile

END
