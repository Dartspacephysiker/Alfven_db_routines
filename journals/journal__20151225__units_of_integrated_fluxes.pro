;2015/12/25
;The issue is this: what are the units of integrated fluxes?
;>JE_2D_B says:
;>   ;	Returns the field aligned energy flux, JEz, ergs/cm^2-sec, assumes a narrow (< 5 deg) field aligned beam
PRO JOURNAL__20151225__UNITS_OF_INTEGRATED_FLUXES

  ;;The following lines are from alfven_stats_5.pro

  ;;OK, this is the time between measurements of the magnetic field in the interval, in seconds
  fields_res_interval=magz.x(intervalfields)-magz.x(intervalfields-1)

  ;;This is the FAST speed, presumably in m/s
  speed=sqrt(vel.y(*,0)^2+vel.y(*,1)^2+vel.y(*,2)^2)*1000.0

  ;;This is the integrated quantity--we're integrating ergs/cm^2-sec over speed_mag_point
  ;;(m/s)*fields_res_inteval (s), so the resulting quantity is 
  ;; ergs/cm^2-sec * m = ergs/cm^2-sec (100 cm) = 100 ergs/cm-sec

  ;;1 erg = 1e-7 joules = 1e-4 millijoules
  ;; 1 erg/cm^2-s = (1e-4 millijoules) / ( 1e-4 m^2)-s = 1 mW/m^2

  ;; Now, since 1 erg/cm^2-s = 1 mW/m^2, 
  ;; > 1 erg/cm^2-sec * (1 m) = 1 mW/m

  current_intervals(j,7)=int_tabulated(findgen(n_elements(intervalfields))*speed_mag_point(intervalfields)*fields_res_interval,jee_tmp_data_fields_res_interval,/double)

  ;;As for number fluxes,
  ;; #/cm^2-s * m = 1/(1e-4 m^2)-s * m = 1e4/m-s
  ;;           OR = 1/cm-(1e-2 m)-s * m = 1e2/cm-s = 1e4/m-s

END