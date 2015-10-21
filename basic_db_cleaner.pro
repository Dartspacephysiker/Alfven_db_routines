;2015/10/20
;This one applies to both maximus and fastLoc structs
FUNCTION BASIC_DB_CLEANER,dbStruct,LUN=lun,CLEAN_NANS_AND_INFINITIES=clean_nans_and_infinities,DO_CHASTDB=do_ChastDB
  
  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1
  n_events = n_elements(dbStruct.orbit)
  n_good = n_events
  
  IS_STRUCT_ALFVENDB_OR_FASTLOC,dbStruct,is_maximus
  
  @alfven_db_cleaner_defaults.pro
  
  IF KEYWORD_SET(clean_nans_and_infinities) THEN BEGIN
     dbTags = tag_names(dbStruct)
     IF is_maximus THEN BEGIN
        IF KEYWORD_SET(do_ChastDB) THEN BEGIN
           clean_these_inds = [INDGEN(21),28]
        ENDIF ELSE BEGIN
           clean_these_inds = [INDGEN(26),32,48,49,50]
        ENDELSE
     ENDIF ELSE BEGIN
        clean_these_inds = INDGEN(N_ELEMENTS(dbTags))
     ENDELSE
     
     FOR i = 0,N_ELEMENTS(clean_these_inds)-1 DO BEGIN
        IF N_ELEMENTS(good_i) EQ 0 THEN BEGIN
           good_i = WHERE(FINITE(dbStruct.(clean_these_inds[i])),/NULL)
           nLost  = n_good-n_elements(good_i)
           n_good = n_good - nLost
           IF nLost GT 100 THEN BEGIN
              PRINTF,lun,FORMAT='("Just lost",I0," events to NaNs/infs in ",A0,"!!")',nLost,dbTags[clean_these_inds[i]]
           ENDIF
        ENDIF ELSE BEGIN
           test_i = WHERE(FINITE(dbStruct.(clean_these_inds[i])),/NULL)
           IF N_ELEMENTS(test_i) GT 0 THEN BEGIN
              good_i = cgsetintersection(test_i,good_i)
           ENDIF ELSE BEGIN
              PRINTF,lun,"Lost all indices to " + mTags[clean_these_inds[i]] + "!"
           ENDELSE
        ENDELSE
     ENDFOR
  ENDIF
  
  nLost = n_events-n_elements(good_i)
  n_good -= nLost
  printf,lun,FORMAT='("N lost to NaNs, infinities",T31,":",T35,I0)',nLost
  
  ;;Now handle the rest
  IF KEYWORD_SET(clean_nans_and_infinities) THEN $
     good_i = cgsetintersection(good_i,WHERE(dbStruct.ILAT LE ilat_hcutoff AND dbStruct.ILAT GE ilat_lcutoff)) $
  ELSE $
     good_i = WHERE(dbStruct.ILAT LE ilat_hcutoff AND dbStruct.ILAT GE ilat_lcutoff)

  good_i = cgsetintersection(good_i,WHERE(dbStruct.MLT LE mlt_hcutoff AND dbStruct.MLT GE 0.0))
  good_i = cgsetintersection(good_i,WHERE(dbStruct.ORBIT LE orbit_hcutoff AND dbStruct.ORBIT GE orbit_lcutoff))
  good_i = cgsetintersection(good_i,where(dbStruct.sample_t LE sample_t_hcutoff,/NULL))

  nlost = n_good-n_elements(good_i)
  printf,lun,FORMAT='("N lost to basic cutoffs",T31,":",T35,I0)',nlost
  printf,lun,FORMAT='("N surviving basic screening",T31,":",T35,I0)',n_good
  printf,lun,"****END basic_db_cleaner.pro****"
  printf,lun,""

  RETURN,good_i
  
END
