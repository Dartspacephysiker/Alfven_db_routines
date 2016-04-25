PRO SETUP_GROSSRATE_INFO_FILE,grossRate_info_file, $
                              PARAMSTRING=paramString, $
                              GROSSLUN=grossLun, $
                              LUN=lun

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

     PRINTF,lun,"Opening grossRate file: " + grossRate_info_file
     IF FILE_TEST(grossRate_info_file) THEN BEGIN
        PRINTF,lun,"grossRate info file exists; appending..."
        OPENW,grossLun,grossRate_info_file,/GET_LUN,/APPEND
        PRINTF,grossLun,""
        PRINTF,grossLun,"##############################"
        PRINTF,grossLun,"Next run: " + SYSTIME()
        PRINTF,grossLun,"##############################"
     ENDIF ELSE BEGIN
        OPENW,grossLun,grossRate_info_file,/GET_LUN
     ENDELSE
     PRINTF,grossLun,GET_TODAY_STRING(/DO_YYYYMMDD_FMT) $
            +  (KEYWORD_SET(paramString) ? ": " + paramString : '')


END