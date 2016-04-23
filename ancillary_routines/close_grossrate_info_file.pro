PRO CLOSE_GROSSRATE_INFO_FILE,grossRate_info_file,grossLun, $
                              LUN=lun
  PRINTF,lun,'Closing grossrate info file...'

  CLOSE,grossLun
  FREE_LUN,grossLun

END