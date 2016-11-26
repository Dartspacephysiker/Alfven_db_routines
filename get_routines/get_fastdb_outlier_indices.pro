;;11/26/16
FUNCTION GET_FASTDB_OUTLIER_INDICES,dbStruct, $
                                    REMOVE_OUTLIERS=remove_outliers, $
                                    REMOVAL__NORESULT=NORESULT, $
                                    FOR_ESPEC=for_eSpec, $
                                    FOR_DATA_ARRAY=for_data_array, $
                                    DATA_ARRAY__NAME=data_array__name, $
                                    USER_INDS=user_inds, $
                                    ONLY_UPPER=only_upper, $
                                    ONLY_LOWER=only_lower, $
                                    LOG_OUTLIERS=log_outliers, $
                                    LOG__ABS=log__abs, $
                                    LOG__NEG=log__neg, $
                                    ;; NULL=null, $
                                    DOUBLE=double, $
                                    ADD_SUSPECTED=add_suspected
  

  COMPILE_OPT IDL2

  IF ~( KEYWORD_SET(for_eSpec) OR KEYWORD_SET(for_data_array) ) THEN BEGIN
     PRINT,"Sorry"
     RETURN,-1
  ENDIF

  CASE 1 OF
     KEYWORD_SET(for_eSpec): BEGIN
        structnames = ['Je','Jee']
        dbNavn = 'eSpec'
     END
     KEYWORD_SET(for_data_array): BEGIN
        dbNavn = KEYWORD_SET(data_array__name) ? data_array__name : 'data array'
        structnames = dbNavn
     END
     ELSE: BEGIN

     END
  ENDCASE

  PRINT,'GET_FASTDB_OUTLIER_INDICES (for ' + dbNavn + ')'
  opener = 'GET_FASTDB_OUTLIER_INDICES (for ' + dbNavn + '): '

  outlier_i_list = LIST()
  FOR k=0,N_ELEMENTS(structNames)-1 DO BEGIN

     IF KEYWORD_SET(for_data_array) THEN BEGIN

     ENDIF ELSE BEGIN
        STR_ELEMENT,dbStruct,structNames[k],INDEX=structInd
        IF structInd LT 0 THEN BEGIN
           PRINT,opener + "Can't find " + structNames[k] + '! Skipping ...'
           CONTINUE
        ENDIF
     ENDELSE
     
     tmpOutlier_i = GET_OUTLIER_INDICES( $
                    (KEYWORD_SET(for_data_array) ? $
                     dbStruct : $
                     dbStruct.(structInd)), $
                    USER_INDS=user_inds, $
                    ONLY_UPPER=only_upper, $
                    ONLY_LOWER=only_lower, $
                    SUSPECTED_OUTLIER_I=susOut_i, $
                    ;; COMPLEMENT_INDICES=comp_i, $
                    LOG_OUTLIERS=log_outliers, $
                    LOG__ABS=log__abs, $
                    LOG__NEG=log__neg, $
                    /NULL, $
                    FINITE=finite, $
                    DOUBLE=double, $
                    RETURN_STATISTICS=return_stats, $
                    OUT_STATISTICS=outStats, $
                    VERBOSE=verbose)

     IF N_ELEMENTS(tmpOutlier_i) GT 0 OR $
        ( KEYWORD_SET(add_suspected) AND $
          N_ELEMENTS(susOut_i) GT 0) $
     THEN BEGIN
        outlier_i_list.Add,(KEYWORD_SET(add_suspected) ? $
                            CGSETUNION(tmpOutlier_i,susOut_i) : $
                            TEMPORARY(tmpOutlier_i))
     ENDIF
     
  ENDFOR

  IF N_ELEMENTS(outlier_i_list) GT 0 THEN BEGIN
     outlier_i = LIST_TO_1DARRAY(TEMPORARY(outlier_i_list))
  ENDIF ELSE BEGIN
     outlier_i = -1
  ENDELSE

  IF KEYWORD_SET(remove_outliers) THEN BEGIN

     IF outlier_i[0] NE -1 THEN BEGIN

        IF N_ELEMENTS(user_inds) GT 0 THEN BEGIN
           nBef = N_ELEMENTS(user_inds)
           inlier_i = CGSETDIFFERENCE(user_inds, $
                                      TEMPORARY(outlier_i), $
                                      NORESULT=-1,COUNT=nGood)
        ENDIF ELSE BEGIN
           nBef = N_ELEMENTS(dbStruct.(0))
           inlier_i = CGSETDIFFERENCE(LINDGEN(N_ELEMENTS(dbStruct.(0))), $
                                      TEMPORARY(outlier_i), $
                                      NORESULT=-1,COUNT=nGood)
        ENDELSE

     ENDIF ELSE BEGIN
        inlier_i = KEYWORD_SET(NORESULT) ? noResult : $
                   LINDGEN(N_ELEMENTS( (KEYWORD_SET(for_data_array) ? $
                                        dbStruct                    : $
                                        dbStruct.(0))))
     ENDELSE

     PRINT,FORMAT='(A0,T40,"Junked ",I0," outlier indices, keeping ",I0," ...")',opener,nBef-nGood,nGood

     RETURN,inlier_i

  ENDIF 


  RETURN,outlier_i

END
