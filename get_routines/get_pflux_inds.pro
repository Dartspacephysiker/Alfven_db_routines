FUNCTION GET_PFLUX_INDS,dbStruct,minpFlux,maxpFlux,LUN=lun

  COMPILE_OPT idl2

  pflux_i=WHERE(dbStruct.pFluxEst GE minpFlux AND dbStruct.pFluxEst LE maxpFlux,NCOMPLEMENT=n_pFlux_outside_range)
  
  PRINTF,lun,FORMAT='("N lost to pFlux  restr.      :",T35,I0)',n_pFlux_outside_range
  PRINTF,lun,''

  RETURN,pFlux_i

END