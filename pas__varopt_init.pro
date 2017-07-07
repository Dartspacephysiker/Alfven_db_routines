;2017/07/07
FUNCTION PAS__VAROPT_INIT

  COMPILE_OPT IDL2,STRICTARRSUBS

  PRINT,"Initializing struct w/ variance options ..."

  varOpt                       = {var__each_bin          : 0B, $
                                  var__distType          : '', $
                                  assume_lognorm         : 0B, $
                                  varScatterPlotPref     : '', $
                                  show_var_scatterplots  : 0B, $
                                  calcVar_Eflux          : 0B, $
                                  calcVar_ENumFl         : 0B, $
                                  calcVar__sWay          : 0B, $
                                  calcVar_Pflux          : 0B, $
                                  calcVar_Iflux          : 0B, $
                                  calcVar_OxyFlux        : 0B, $
                                  calcVar_CharE          : 0B, $
                                  calcVar_Charie         : 0B, $
                                  calcVar_MagC           : 0B $
                                 }

  RETURN,varOpt

END
