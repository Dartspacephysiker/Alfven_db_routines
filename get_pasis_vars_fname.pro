;;12/11/16
FUNCTION GET_PASIS_VARS_FNAME

  COMPILE_OPT IDL2

  @common__pasis_lists.pro
  
  CASE 1 OF
     KEYWORD_SET(PASIS__alfDB_plot_struct.executing_multiples): BEGIN
        fName = 'multi_PASIS_vars-' + PASIS__alfDB_plot_struct.multiString + '.sav'
     END
     ELSE: BEGIN
        fName = 'PASIS_vars-' + PASIS__alfDB_plot_struct.paramString + '.sav'
     END
  ENDCASE

  RETURN,fName

END
