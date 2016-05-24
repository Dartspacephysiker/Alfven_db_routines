PRO JOURNAL__20160507__CLEAR_DUPES_FROM_MAXIMUS_RUN__ORBS_2500_3599_AND_BONUS

  outDir        = '/SPENCEdata/Research/database/dartdb/saves/'
  in_maximus    = 'Dartdb_20160507--2500-3599_and_bonus--maximus--pflux--lshell.sav'
  cdbTimeFile   = 'Dartdb_20160507--2500-3599_and_bonus_despun--cdbtime.sav'

  out_maximus   = 'Dartdb_20160507--2500-3599_and_bonus--maximus--pflux--lshell--noDupes.sav'
  out_cdbTime   = 'Dartdb_20160507--2500-3599_and_bonus--cdbtime--noDupes.sav'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Generate and save cdbTime
  RESTORE,outDir+in_maximus
  cdbTime       = STR_TO_TIME(maximus.time)
  SAVE,cdbTime,FILENAME=outDir+cdbTimeFile

  RESTORE,outDir + cdbTimeFile

  ;;Now fick it
  CHECK_SORTED,cdbTime,is_sorted,SORTED_I=sorted_i

  ;;Now cdbTime is sorted, but not maximus!!!!
  
  ;; cdbTime = cdbTime[sorted_i]
  maximus = RESIZE_MAXIMUS__BEFORE_ADDING_CORRECTED_FLUXES_DESPUN_ETC(maximus,INDS=sorted_i,CDBTIME=cdbTime)

  PRINT,'Now checking for duplicates...'
  CHECK_DUPES,cdbTime,HAS_DUPES=has_dupes,N_DUPES=n_dupes,OUT_DUPE_I=out_dupe_i

  ;;Sorted?
  CHECK_SORTED,out_dupe_i,dupe_is_sorted

  IF ~dupe_is_sorted THEN BEGIN
     PRINT,"Dupes aren't even sorted!!!! The world is over."
     STOP
  ENDIF

  IF (WHERE(out_dupe_i LT 0))[0] NE -1 THEN BEGIN
     PRINT,"WHAATT"
     STOP
  ENDIF

  STOP

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
