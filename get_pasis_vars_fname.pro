;;12/11/16
FUNCTION GET_PASIS_VARS_FNAME,NEED_FASTLOC_I=need_fastLoc_i

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__pasis_lists.pro
  
  CASE 1 OF
     KEYWORD_SET(PASIS__alfDB_plot_struct.executing_multiples): BEGIN
        PASISpref     = 'multi_PASIS_vars-'
        PASISparamStr =  PASIS__alfDB_plot_struct.multiString
     END
     ELSE: BEGIN
        PASISpref     = 'PASIS_vars-'
        PASISparamStr =  PASIS__alfDB_plot_struct.paramString
     END
  ENDCASE

  IF ABS(PASIS__MIMC_struct.minI) LT 60 THEN BEGIN
     PASISparamStr += STRING(FORMAT='("--",I0,"-",I0,"_ILAT")',PASIS__MIMC_struct.minI,PASIS__MIMC_struct.maxI)
  ENDIF

  CASE 1 OF
     KEYWORD_SET(PASIS__alfDB_plot_struct.for_eSpec_DBs): BEGIN
        PASISpref    += (KEYWORD_SET(PASIS__alfDB_plot_struct.eSpec__upgoing) ? 'up_' : '') + $
                        (KEYWORD_SET(PASIS__alfDB_plot_struct.eSpec__gigante_DB) ? 'big_' : '') + $
                        'eSpec-'
     END
     KEYWORD_SET(PASIS__alfDB_plot_struct.for_ion_DBs): BEGIN
        PASISpref    += (KEYWORD_SET(PASIS__alfDB_plot_struct.ion__downgoing) ? 'down_' : '') + $
                        'ion-'
     END
     KEYWORD_SET(PASIS__alfDB_plot_struct.for_sWay_DB): BEGIN
        PASISpref    += 'sWay-' + (PASIS__alfDB_plot_struct.sWay_use_8Hz_DB ? '8HzDB-' : '')
     END
     ELSE: BEGIN
        PASISpref    += 'alfDB-'
     END
  ENDCASE

  IF KEYWORD_SET(need_fastLoc_i) THEN BEGIN
     PASISpref       += 'w_t-'
  ENDIF

  fName               = PASISpref + PASISparamStr + '.sav'

  RETURN,fName

END
