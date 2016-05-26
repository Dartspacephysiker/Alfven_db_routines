;;05/26/16
PRO JOURNAL__20160526__CHECK_OUT_INCOMPLETE_ESPEC_FILE_FOR_DARTDB_20151222 

  ;;Get 'em back!
  LOAD_MAXIMUS_AND_CDBTIME,!NULL,cdbTime,/JUST_CDBTIME,DBDir=dbDir
  eSpec_dir     = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'
  file          = 'alf_eSpec_20160522_db--20160526.sav'

  RESTORE,eSpec_dir+file

  STOP

END
