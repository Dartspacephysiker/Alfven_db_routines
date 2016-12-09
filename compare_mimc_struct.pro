;;12/07/16
PRO COMPARE_MIMC_STRUCT,MIMC_struct1,MIMC_struct2,INDS_RESET=inds_reset;,DBS_RESET=DBs_reset

  COMPILE_OPT IDL2

  inds_reset = 0B
  ;; DBS_reset  = 0B

  IF MIMC_struct1.minMC NE MIMC_struct2.minMC THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"minMC", $
           MIMC_struct1.minMC,MIMC_struct2.minMC
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.maxNegMC NE MIMC_struct2.maxNegMC THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"maxNegMC", $
           MIMC_struct1.maxNegMC,MIMC_struct2.maxNegMC
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.hemi NE MIMC_struct2.hemi THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"hemi", $
           MIMC_struct1.hemi,MIMC_struct2.hemi
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.north NE MIMC_struct2.north THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"north", $
           MIMC_struct1.north,MIMC_struct2.north
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.south NE MIMC_struct2.south THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"south", $
           MIMC_struct1.south,MIMC_struct2.south
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.both_hemis NE MIMC_struct2.both_hemis THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"both_hemis", $
           MIMC_struct1.both_hemis,MIMC_struct2.both_hemis
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.dayside NE MIMC_struct2.dayside THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"dayside", $
           MIMC_struct1.dayside,MIMC_struct2.dayside
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.nightside NE MIMC_struct2.nightside THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"nightside", $
           MIMC_struct1.nightside,MIMC_struct2.nightside
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.do_lShell NE MIMC_struct2.do_lShell THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"do_lShell", $
           MIMC_struct1.do_lShell,MIMC_struct2.do_lShell
     inds_reset = 1B
  ENDIF

END
