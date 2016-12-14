;;12/11/16
FUNCTION GET_PASIS_VARS_FNAME,NEED_FASTLOC_I=need_fastLoc_i

  COMPILE_OPT IDL2

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


  CASE 1 OF
     KEYWORD_SET(PASIS__alfDB_plot_struct.for_eSpec_DBs): BEGIN
        PASISpref    += 'eSpec-'
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
