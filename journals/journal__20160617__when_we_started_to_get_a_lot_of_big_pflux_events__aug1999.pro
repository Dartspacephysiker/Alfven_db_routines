;20160617 After running JOURNAL__20160502__BIG_PFLUX_WITH_MLT_ON_SIDE__ALTSLICES, 
; it appears to me that all of the big stuff started happening after a lull in the availability of data at a sufficiently awesome sample rate.
PRO JOURNAL__20160617__WHEN_WE_STARTED_TO_GET_A_LOT_OF_BIG_PFLUX_EVENTS__AUG1999


  ;;Used this file:
  ;;Dartdb_20160508--502-16361_despun--maximus--pflux_lshell--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav
  LOAD_MAXIMUS_AND_CDBTIME,maximus,/DO_DESPUNDB
  
  
  PRINT,maximus.time[484320]
  ;;1999-08-01/01:34:50.033
  
  PRINT,maximus.orbit[484320]
  ;;11645



END