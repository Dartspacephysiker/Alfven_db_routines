; The purpose of this file is just what you'd expect--we want to resize maximus based on some stuff

FUNCTION resize_maximus,maximus,MAXIMUS_IND=maximus_ind,MIN_FOR_IND=min_for_ind,MAX_FOR_IND=max_for_ind,ONLY_ABSVALS=only_absVals,INDS=inds,CDBTIME=cdbTime

  IF KEYWORD_SET(inds) THEN allowed_i = inds ELSE BEGIN
     IF KEYWORD_SET(only_absVals) THEN BEGIN
        allowed_i=where(abs(maximus.(maximus_ind)) GE min_for_ind AND abs(maximus.(maximus_ind)) LE max_for_ind)
     ENDIF ELSE BEGIN
        allowed_i=where(maximus.(maximus_ind) GE min_for_ind AND maximus.(maximus_ind) LE max_for_ind)
     ENDELSE
  ENDELSE

  maxTags = tag_names(maximus)
  print,''
  print,"**********from resize_maximus.pro**********"
  IF KEYWORD_SET(inds) THEN print,"Resizing based on indices" ELSE BEGIN
     print,"Resizing based on " +  (KEYWORD_SET(only_absVals) ? 'ABS(' + maxTags(maximus_ind)  + ')' : maxTags(maximus_ind) )
     print,"Upper limit: " + strcompress(max_for_ind,/remove_all)
     print,"Lower limit: " + strcompress(min_for_ind,/remove_all)
     print,''
  ENDELSE
  print,"N_elements before: " + strcompress(n_elements(maximus.orbit),/remove_all)

  resize_maximus={orbit:maximus.orbit(allowed_i),$
                  alfvenic:maximus.alfvenic(allowed_i),$
                  TIME:maximus.time(allowed_i),$
                  ALT:maximus.alt(allowed_i),$
                  MLT:maximus.mlt(allowed_i),$
                  ILAT:maximus.ilat(allowed_i),$
                  MAG_CURRENT:maximus.MAG_CURRENT(allowed_i),$
                  ESA_CURRENT:maximus.ESA_CURRENT(allowed_i),$
                  ELEC_ENERGY_FLUX:maximus.ELEC_ENERGY_FLUX(allowed_i),$
                  INTEG_ELEC_ENERGY_FLUX:maximus.INTEG_ELEC_ENERGY_FLUX(allowed_i),$
                  EFLUX_LOSSCONE_INTEG:maximus.EFLUX_LOSSCONE_INTEG(allowed_i),$
                  total_eflux_integ:maximus.total_eflux_integ(allowed_i),$
                  max_chare_losscone:maximus.max_chare_losscone(allowed_i),$
                  max_chare_total:maximus.max_chare_total(allowed_i),$
                  ION_ENERGY_FLUX:maximus.ION_ENERGY_FLUX(allowed_i),$
                  ION_FLUX:maximus.ION_FLUX(allowed_i),$
                  ION_FLUX_UP:maximus.ION_FLUX_UP(allowed_i),$
                  INTEG_ION_FLUX:maximus.INTEG_ION_FLUX(allowed_i),$
                  INTEG_ION_FLUX_UP:maximus.INTEG_ION_FLUX_UP(allowed_i),$
                  CHAR_ION_ENERGY:maximus.CHAR_ION_ENERGY(allowed_i),$
                  WIDTH_TIME:maximus.WIDTH_TIME(allowed_i),$
                  WIDTH_X:maximus.WIDTH_X(allowed_i),$
                  DELTA_B:maximus.DELTA_B(allowed_i),$
                  DELTA_E:maximus.DELTA_E(allowed_i),$
                  SAMPLE_T:maximus.SAMPLE_T(allowed_i),$
                  MODE:maximus.MODE(allowed_i),$
                  PROTON_FLUX_UP:maximus.PROTON_FLUX_UP(allowed_i),$
                  PROTON_CHAR_ENERGY:maximus.PROTON_CHAR_ENERGY(allowed_i),$
                  OXY_FLUX_UP:maximus.OXY_FLUX_UP(allowed_i),$
                  OXY_CHAR_ENERGY:maximus.OXY_CHAR_ENERGY(allowed_i),$
                  HELIUM_FLUX_UP:maximus.HELIUM_FLUX_UP(allowed_i),$
                  HELIUM_CHAR_ENERGY:maximus.HELIUM_CHAR_ENERGY(allowed_i),$
                  SC_POT:maximus.SC_POT(allowed_i),$
                  L_PROBE:maximus.L_PROBE(allowed_i),$
                  MAX_L_PROBE:maximus.MAX_L_PROBE(allowed_i),$
                  MIN_L_PROBE:maximus.MIN_L_PROBE(allowed_i),$
                  MEDIAN_L_PROBE:maximus.MEDIAN_L_PROBE(allowed_i),$
                  START_TIME:maximus.START_TIME(allowed_i),$
                  STOP_TIME:maximus.STOP_TIME(allowed_i),$
                  TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE:maximus.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE(allowed_i),$
                  TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT:maximus.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT(allowed_i),$
                  TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX:maximus.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX(allowed_i),$
                  TOTAL_ION_OUTFLOW_SINGLE:maximus.TOTAL_ION_OUTFLOW_SINGLE(allowed_i),$
                  TOTAL_ION_OUTFLOW_MULTIPLE_TOT:maximus.TOTAL_ION_OUTFLOW_MULTIPLE_TOT(allowed_i),$
                  TOTAL_ALFVEN_ION_OUTFLOW:maximus.TOTAL_ALFVEN_ION_OUTFLOW(allowed_i),$
                  TOTAL_UPWARD_ION_OUTFLOW_SINGLE:maximus.TOTAL_UPWARD_ION_OUTFLOW_SINGLE(allowed_i),$
                  TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT:maximus.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT(allowed_i),$
                  TOTAL_ALFVEN_UPWARD_ION_OUTFLOW:maximus.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW(allowed_i),$
                  BURST:maximus.burst(allowed_i), $
                  PFLUXEST:maximus.delta_b(allowed_i)*maximus.delta_e(allowed_i)*4.0e-7*!PI}

  
  IF KEYWORD_SET(cdbTime) THEN BEGIN
     print,''    
     print,"Also doing cdbTime!"
     print,"N cdbTime before: " + strcompress(n_elements(cdbTime),/remove_all)
     cdbTime=cdbTime(allowed_i)
     print,"N cdbTime after: " + strcompress(n_elements(cdbTime),/remove_all)
     print,''
  ENDIF

  print,"N_elements after: " + strcompress(n_elements(resize_maximus.orbit),/remove_all)
  print,"***********end resize_maximus.pro**********"
  print,''

  RETURN, resize_maximus

END