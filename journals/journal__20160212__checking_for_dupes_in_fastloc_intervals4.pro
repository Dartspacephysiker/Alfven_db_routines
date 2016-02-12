;2016/02/12 So some evidence has cropped up that there's a ton of dupes in fastLoc_intervals4. Check it.
; There are definitely dupes ...
PRO JOURNAL__20160212__CHECKING_FOR_DUPES_IN_FASTLOC_INTERVALS4

  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastLoc_times,fastLoc_delta_t

  CHECK_DUPES,fastLoc_times,OUT_DUPE_I=fl_times_dupe_i
     

  nDupes             = N_ELEMENTS(fl_times_dupe_i)
  ;check 2 different ways
  FOR i=0,1000 DO BEGIN
     iDupe           = FIX(RANDOMU(seed)*nDupes)
     occ_i           = WHERE(fastLoc_times EQ fastLoc_times[iDupe],/NULL)
     FOR j=0,N_ELEMENTS(occ_i)-1 DO BEGIN
        PRINT,FORMAT='(I0,T10,F0.2,T25,A0,T50,A0,T75,F0.2)', $
              occ_i[j],fastloc_times[occ_i[j]],TIME_TO_STR(fastLoc_times[occ_i[j]]),fastLoc.time[occ_i[j]],fastloc.sample_t[occ_i[j]]
     ENDFOR
     PRINT,''
  ENDFOR

END