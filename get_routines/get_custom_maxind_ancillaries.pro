PRO GET_CUSTOM_MAXIND_ANCILLARIES,custom_range,log_custom,custom_title,custom_dataname,custom_autoscale, $
                                  INDEX=index, $
                                  CUSTOM_MAXINDS=custom_maxInds, $
                                  CUSTOM_MAXIND_RANGE=custom_maxInd_range, $
                                  CUSTOM_MAXIND_AUTOSCALE=custom_maxInd_autoscale, $
                                  CUSTOM_MAXIND_DATANAME=custom_maxInd_dataname, $
                                  CUSTOM_MAXIND_TITLE=custom_maxInd_title, $
                                  LOG_CUSTOM_MAXIND=log_custom_maxInd, $
                                  DO_OUTPUT_CUSTOM_MAXIND=DO_output_custom_maxInd, $
                                  OUTPUT_CUSTOM_MAXIND=output_custom_maxInd, $
                                  MAXIMUS=maximus, $
                                  RESET_COUNTERS=reset_counters
                                  
                                  
  COMMON CUSTMAX__nameless_customData_count,CUSTMAX__nameless_customTitle_count,CUSTMAX__index

  IF KEYWORD_SET(reset_counters) OR N_ELEMENTS(CUSTMAX__index) EQ 0 THEN BEGIN
     CUSTMAX__nameless_customData_count         = 0
     CUSTMAX__nameless_customTitle_count        = 0
     CUSTMAX__index                             = 0
  ENDIF

  ;;User-defined, if need be
  IF KEYWORD_SET(index) THEN CUSTMAX__index     = index

  IF N_ELEMENTS(custom_maxInd_range) NE 0 THEN BEGIN
     IF N_ELEMENTS(custom_maxInd_range[0,*]) GT 1 THEN BEGIN
        custom_range = custom_maxInd_range[*,CUSTMAX__index]
     ENDIF ELSE BEGIN
        custom_range = custom_maxInd_range
     ENDELSE
  ENDIF ELSE BEGIN
     custom_range    = !NULL
  ENDELSE

  IF N_ELEMENTS(custom_maxInd_autoscale) NE 0 THEN BEGIN
     IF N_ELEMENTS(custom_maxInd_autoscale) GT 1 THEN BEGIN
        custom_autoscale = custom_maxInd_autoscale[CUSTMAX__index]
     ENDIF ELSE BEGIN
        custom_autoscale = custom_maxInd_autoscale
     ENDELSE
  ENDIF

  IF N_ELEMENTS(log_custom_maxInd) NE 0 THEN BEGIN
     IF N_ELEMENTS(log_custom_maxInd) GT 1 THEN BEGIN
        log_custom = log_custom_maxInd[CUSTMAX__index]
     ENDIF ELSE BEGIN
        log_custom = log_custom_maxInd
     ENDELSE
  ENDIF

  IF N_ELEMENTS(custom_maxInd_dataname) NE 0 THEN BEGIN
     IF N_ELEMENTS(custom_maxInd_dataname) GT 1 THEN BEGIN
        custom_dataname = custom_maxInd_dataname[CUSTMAX__index]
     ENDIF ELSE BEGIN
        custom_dataname = custom_maxInd_dataname 
     ENDELSE
  ENDIF ELSE BEGIN
     custom_dataname = 'custom_maxind_'+STRCOMPRESS(CUSTMAX__nameless_customData_count,/REMOVE_ALL)
     CUSTMAX__nameless_customData_count++
  ENDELSE

  IF N_ELEMENTS(custom_maxInd_title) NE 0 THEN BEGIN
     IF N_ELEMENTS(custom_maxInd_title) GT 1 THEN BEGIN
        custom_title = custom_maxInd_title[CUSTMAX__index]
     ENDIF ELSE BEGIN
        custom_title    = custom_maxInd_title
     ENDELSE
  ENDIF ELSE BEGIN
     custom_title = 'Custom MaxInd #'+STRCOMPRESS(CUSTMAX__nameless_customTitle_count,/REMOVE_ALL)
     CUSTMAX__nameless_customTitle_count++
  ENDELSE

  IF KEYWORD_SET(do_output_custom_maxInd) THEN BEGIN
     output_custom_maxInd = GET_CUSTOM_ALFVENDB_QUANTITY(custom_maxInd,MAXIMUS=maximus,/VERBOSE)
  ENDIF

  CUSTMAX__index++

END