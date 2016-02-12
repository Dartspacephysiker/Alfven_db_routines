;2015/10/20
;This one applies to both maximus and fastLoc structs
;            Mod history
; 2015/12/28 Fastloc has a bunch of strange sample_t values (negatives), so I'm junking them
;; 2016/01/13 New USING_HEAVIES keyword for times when TEAMS data are coming into play
FUNCTION BASIC_DB_CLEANER,dbStruct,LUN=lun, $
                          CLEAN_NANS_AND_INFINITIES=clean_nans_and_infinities, $
                          DO_LSHELL=DO_lshell, $
                          USING_HEAVIES=using_heavies, $
                          DO_CHASTDB=do_ChastDB
  
  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1
  n_events = n_elements(dbStruct.orbit)
  n_good = n_events
  tot_nLost = 0
  
  IS_STRUCT_ALFVENDB_OR_FASTLOC,dbStruct,is_maximus
  
  @alfven_db_cleaner_defaults.pro
  
  IF KEYWORD_SET(clean_nans_and_infinities) THEN BEGIN
     dbTags = tag_names(dbStruct)
     IF is_maximus THEN BEGIN
        IF KEYWORD_SET(do_ChastDB) THEN BEGIN
           clean_these_inds = [INDGEN(21),28]
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(using_heavies) THEN BEGIN
              PRINTF,lun,'Cleaning heavies!'
              clean_these_inds = [INDGEN(33),48,49]
           ENDIF ELSE BEGIN
              clean_these_inds = [INDGEN(26),32,48,49]
           ENDELSE
        ENDELSE

        IF KEYWORD_SET(do_lshell) THEN BEGIN
           PRINTF,lun,'Cleaning L-shell!'
           clean_these_inds = [clean_these_inds,50]
        ENDIF
     ENDIF ELSE BEGIN
        clean_these_inds = INDGEN(N_ELEMENTS(dbTags))
     ENDELSE
     
     FOR i = 0,N_ELEMENTS(clean_these_inds)-1 DO BEGIN
        IF N_ELEMENTS(good_i) EQ 0 THEN BEGIN
           good_i     = WHERE(FINITE(dbStruct.(clean_these_inds[i])),/NULL)
           nLost      = n_good-n_elements(good_i)
           tot_nLost += nLost
           n_good     = n_good - nLost

           IF nLost GT 0 THEN BEGIN
              PRINTF,lun,FORMAT='("NaNs/infs in ",A20,T40,": ",I0)',dbTags[clean_these_inds[i]],nLost
           ENDIF
        ENDIF ELSE BEGIN
           test_i = WHERE(FINITE(dbStruct.(clean_these_inds[i])),/NULL)
           IF N_ELEMENTS(test_i) GT 0 THEN BEGIN
              good_i     = cgsetintersection(test_i,good_i)
              nLost      = n_good-n_elements(good_i)
              tot_nLost += nLost
              n_good     = n_good - nLost

              IF nLost GT 0 THEN BEGIN
                 PRINTF,lun,FORMAT='("NaNs/infs in ",A20,T40,": ",I0)',dbTags[clean_these_inds[i]],nLost
              ENDIF
           ENDIF ELSE BEGIN
              PRINTF,lun,"Lost all indices to " + mTags[clean_these_inds[i]] + "!"
           ENDELSE
        ENDELSE
     ENDFOR
  ENDIF
  
  ;; nLost = n_events-n_elements(good_i)
  ;; n_good -= nLost
  printf,lun,FORMAT='("NaNs, infinities",T40,": ",I0)',tot_nLost
  
  ;;Now handle the rest
  IF KEYWORD_SET(clean_nans_and_infinities) THEN BEGIN
     good_i = cgsetintersection(good_i,WHERE(dbStruct.ILAT LE ilat_hcutoff AND dbStruct.ILAT GE ilat_lcutoff)) 
  ENDIF ELSE BEGIN
     good_i = WHERE(dbStruct.ILAT LE ilat_hcutoff AND dbStruct.ILAT GE ilat_lcutoff)
  ENDELSE
  nlost      = n_good-n_elements(good_i)
  tot_nLost += nLost
  n_good -= nLost
  IF nLost GT 0 THEN BEGIN
     PRINTF,lun,FORMAT='("N lost to basic ILAT restr",T40,": ",I0)',nlost
  ENDIF

  good_i = cgsetintersection(good_i,WHERE(dbStruct.MLT LE mlt_hcutoff AND dbStruct.MLT GE 0.0))
  nlost      = n_good-n_elements(good_i)
  tot_nLost += nLost
  n_good -= nLost
  IF nLost GT 0 THEN BEGIN
     PRINTF,lun,FORMAT='("N lost to basic MLT restr",T40,": ",I0)',nlost
  ENDIF

  good_i = cgsetintersection(good_i,WHERE(dbStruct.ORBIT LE orbit_hcutoff AND dbStruct.ORBIT GE orbit_lcutoff))
  nlost      = n_good-n_elements(good_i)
  tot_nLost += nLost
  n_good -= nLost
  IF nLost GT 0 THEN BEGIN
     PRINTF,lun,FORMAT='("N lost to basic ORBIT restr",T40,": ",I0)',nlost
  ENDIF

  ;; good_i = cgsetintersection(good_i,where(dbStruct.sample_t LE sample_t_hcutoff,/NULL))
  good_i = cgsetintersection(good_i,where(ABS(dbStruct.sample_t) LE sample_t_hcutoff AND ABS(dbStruct.sample_t) GT 0.,/NULL))
  nlost      = n_good-n_elements(good_i)
  tot_nLost += nLost
  n_good -= nLost
  IF nLost GT 0 THEN BEGIN
     PRINTF,lun,FORMAT='("N lost to basic sample freq restr",T40,": ",I0)',nlost
  ENDIF

  ;; nlost = n_good-n_elements(good_i)
  printf,lun,FORMAT='("N lost to basic cutoffs",T40,": ",I0)',tot_nlost
  printf,lun,FORMAT='("N surviving basic screening",T40,": ",I0)',n_good
  printf,lun,"****END basic_db_cleaner.pro****"
  printf,lun,""

  RETURN,good_i
  
END
