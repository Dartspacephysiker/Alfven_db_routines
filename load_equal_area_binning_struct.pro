;;10/15/16
PRO LOAD_EQUAL_AREA_BINNING_STRUCT,EA

  COMPILE_OPT IDL2

  @common__ea_binning.pro

  IF N_ELEMENTS(EA__struct) EQ 0 THEN BEGIN
     inDir        = '/SPENCEdata/Research/database/equal-area_binning/'
     EAbins_file  = 'equalArea--20161014--struct_and_ASCII_tmplt.idl'
     RESTORE,inDir+EAbins_file
     EA__s        = EA
  ENDIF ELSE BEGIN
     EA           = EA__s
  ENDELSE
END
