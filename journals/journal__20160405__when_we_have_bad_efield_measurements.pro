PRO JOURNAL__20160405__WHEN_WE_HAVE_BAD_EFIELD_MEASUREMENTS

  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime

  bad_eField_i = WHERE(~FINITE(maximus.delta_e))

  firstTime = cdbTime[0]
  lastTime  = cdbTime[-1]


  CGHISTOPLOT,(cdbTime[bad_eField_i]-firstTime)/3600./24./365.25

END