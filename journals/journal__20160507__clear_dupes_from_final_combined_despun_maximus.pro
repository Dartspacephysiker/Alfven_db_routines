PRO JOURNAL__20160507__CLEAR_DUPES_FROM_FINAL_COMBINED_DESPUN_MAXIMUS

  outDate       = '20160508'
  outDir        = '/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  in_maximus    = 'Dartdb_'+outDate+'--502-16361_despun--maximus--pflux_lshell--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'
  cdbTimeFile   = 'Dartdb_'+outDate+'--502-16361_despun--cdbtime--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'

  out_maximus   = 'Dartdb_'+outDate+'--502-16361_despun--maximus--pflux_lshell--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'
  out_cdbTime   = 'Dartdb_'+outDate+'--502-16361_despun--cdbtime--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Generate and save cdbTime
  RESTORE,outDir+in_maximus
  RESTORE,outDir + cdbTimeFile

  ;;Now fick it
  CHECK_SORTED,cdbTime,is_sorted,SORTED_I=sorted_i

  ;;Now cdbTime is sorted, but not maximus!!!!
  
  ;; cdbTime = cdbTime[sorted_i]
  IF ~is_sorted THEN BEGIN
     PRINT,'Not sorted! sorting...'
     maximus = RESIZE_MAXIMUS__BEFORE_ADDING_CORRECTED_FLUXES_DESPUN_ETC(maximus,INDS=sorted_i,CDBTIME=cdbTime)
  ENDIF

  PRINT,'Now checking for duplicates...'
  CHECK_DUPES,cdbTime,HAS_DUPES=has_dupes,N_DUPES=n_dupes,OUT_DUPE_I=out_dupe_i

  ;;Sorted?
  check_sorted,out_dupe_i,dupe_is_sorted

  IF ~dupe_is_sorted THEN BEGIN
     PRINT,"Dupes aren't even sorted!!!! The world is over."
     STOP
  ENDIF

  IF (WHERE(out_dupe_i LT 0))[0] NE -1 THEN BEGIN
     PRINT,"WHAATT"
     STOP
  ENDIF

  ;;the not-dupes
  not_dupe_i                  = CGSETDIFFERENCE(LINDGEN(N_ELEMENTS(cdbTime)),out_dupe_i)
  
  ;;the unique dupes
  uniq_dupes_ii               = UNIQ(cdbTime[out_dupe_i])
  uniq_dupes_i                = out_dupe_i[uniq_dupes_ii]
  
  ;;The good inds
  combined_sorted_noDupes_i   = CGSETUNION(not_dupe_i,uniq_dupes_i)
  
  CHECK_SORTED,combined_sorted_noDupes_i,is_fantastically_sorted
  
  IF is_fantastically_sorted THEN BEGIN
     PRINT,"Great! You're on your way to a clean ephemeris."
  ENDIF ELSE BEGIN
     PRINT,"WHAHSDLFJL"
     STOP
  END

  ;;Last, reorganize maximus and cdbTime with these sorted, un-duped indices. Then move on with life.
  maximus = RESIZE_MAXIMUS__BEFORE_ADDING_CORRECTED_FLUXES_DESPUN_ETC(maximus,INDS=combined_sorted_noDupes_i,CDBTIME=cdbTime)

  ;;Final check
  CHECK_SORTED,cdbTime,is_sorted

  IF ~is_sorted THEN BEGIN
     PRINT,"All that work for nothing. cdbTime is still garbage."
     STOP
  ENDIF ELSE BEGIN
     ;;;final check
     temp = STR_TO_TIME(maximus.time)
     CHECK_SORTED,temp,is_sorted

     IF is_sorted THEN BEGIN
        PRINT,"Everyone's a winner today. They're all sorted."
        PRINT,"Saving maximus: " + outDir + out_maximus
        SAVE,maximus,FILENAME=outDir+out_maximus
        
        PRINT,"Saving cdbTime: " + outDir + out_cdbTime
        SAVE,cdbTime,FILENAME=outDir+out_cdbTime
     ENDIF ELSE BEGIN
        STOP
     ENDELSE
  ENDELSE  

END  