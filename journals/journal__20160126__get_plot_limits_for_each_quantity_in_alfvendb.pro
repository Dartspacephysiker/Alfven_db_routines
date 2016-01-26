PRO JOURNAL__20160126__GET_PLOT_LIMITS_FOR_EACH_QUANTITY_IN_ALFVENDB,maxMins,maxMinsClean


  load_maximus_and_cdbtime,maximus,/DO_DESPUNDB
  good_i = get_chaston_ind(maximus,/BOTH_HEMIS,/USING_HEAVIES)

  ;; max=resize_maximus(maximus,INDS=good_i)
  mt                  = tag_names(maximus)
  maxMins             = LIST(!NULL)
  maxMinsClean        = LIST(!NULL)
  ;;Format dat
  fmtDigs             = 'G0.6'
  fmtString           = '(I02,T4,A0,T35,' + fmtDigs + ',T55,' + fmtDigs + ',T75,' + fmtDigs + ',T95,' + fmtDigs + ')'

  ;Let's see 'em
  PRINT,FORMAT='("Ind",T4,"Name",T35,"Min",T55,"Max",T75,"Clean Min",T95,"Clean Max")'
  FOR i=0,N_ELEMENTS(mt)-1 DO BEGIN
     max              = MAX(maximus.(i),MIN=min)
     cleanMax         = MAX(maximus.(i)[good_i],MIN=cleanMin)

     maxMins.add,[min,max]
     maxMinsClean.add,[cleanMin,cleanMax]
     PRINT,FORMAT=fmtString,i,mt[i],min,max,cleanMin,cleanMax
  ENDFOR


END