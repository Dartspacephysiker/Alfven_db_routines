;;12/20/16
PRO CLEAR_COMMON_VARS

  COMPILE_OPT IDL2,STRICTARRSUBS

  PRINT,"Clearing COMMON vars"

  PRINT,"CLEAR_ALL_ALFVENDB_COMMON_VARS ..."
  CLEAR_ALL_ALFVENDB_COMMON_VARS

  PRINT,"CLEAR_PASIS_VARS ..."
  CLEAR_PASIS_VARS

  ;; PRINT,"CLEAR_MIMC_COMMON_VARS ..."
  CLEAR_MIMC_COMMON_VARS
  



END
