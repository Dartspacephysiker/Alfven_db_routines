PRO CLOSE_GROSSRATE_INFO_FILE,grossRate_info_file,grossLun, $
                              LUN=lun
  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1
  PRINTF,lun,'Closing grossrate info file...'

  CLOSE,grossLun
  FREE_LUN,grossLun

END