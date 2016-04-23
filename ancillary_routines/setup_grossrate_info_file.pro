PRO SETUP_GROSSRATE_INFO_FILE,grossRate_info_file, $
                              PARAMSTRING=paramString, $
                              GROSSLUN=grossLun, $
                              LUN=lun

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

     PRINTF,lun,"Opening grossRate file: " + grossRate_info_file
     OPENW,grossLun,grossRate_info_file,/GET_LUN
     PRINTF,grossLun,GET_TODAY_STRING(/DO_YYYYMMDD_FMT) $
            +  (KEYWORD_SET(paramString) ? ": " + paramString : '')


END