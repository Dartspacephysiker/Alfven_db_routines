PRO JOURNAL__20160104__CHECK_OUT_DELTA_E_OVER_DELTA_B_VS_ALTITUDE

  outFile = 'altitude_vs__delta_e_over_delta_b--20160104.png'
  
  load_maximus_and_cdbtime,maximus
  
  dat=maximus.delta_e/maximus.delta_b
  
  good_i=get_chaston_ind(maximus,HEMI='BOTH')
  
  dat=maximus.delta_e[good_i]/maximus.delta_b[good_i]
  
  minDat=min(dat,min_ind,max=maxDat,SUBSCRIPT_MAX=max_ind)

  ;max and min of e/b ratio?
  print,minDat
;     0.086057439
  print,maxDat
;       939.58313
  
  ;;altitudes?
  print,maximus.alt[good_i[min_ind]]
  print,maximus.alt[good_i[max_ind]]
  
  ;;mins and max of delta_b and delta_e
  print,min(maximus.delta_b[good_i])
  print,min(maximus.delta_e[good_i])
  print,max(maximus.delta_b[good_i])
  print,max(maximus.delta_e[good_i])
  
  ;;max possible value for e/b in cleaned DB
  print,max(maximus.delta_e[good_i])/5.0

  ;;min possible value for e/b in cleaned DB
  print,10.0/max(maximus.delta_b[good_i])

  ;;this is kind of awesome
  window = window(dimensions=[1200,800])
  this   = scatterplot(maximus.alt[good_i],alog10(dat),sym_transparency=99,CURRENT=window)
  window.save,filename=outFile
  
END