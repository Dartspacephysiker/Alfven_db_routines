;;10/15/16
PRO LOAD_EQUAL_AREA_BINNING_STRUCT,EA

  COMPILE_OPT IDL2

     inDir        = '/SPENCEdata/Research/database/equal-area_binning/'
     EAbins_file  = 'equalArea--20161014--struct_and_ASCII_tmplt.idl'
     RESTORE,inDir+EAbins_file

END
