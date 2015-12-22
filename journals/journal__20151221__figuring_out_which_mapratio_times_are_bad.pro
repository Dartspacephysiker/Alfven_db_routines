PRO JOURNAL__20151221__FIGURING_OUT_WHICH_MAPRATIO_TIMES_ARE_BAD

  restore,'/SPENCEdata/Research/Cusp/database/mapratio_for_20151014_DB--up_to16361--20151221.dat'
  load_maximus_and_cdbtime,maximus,cdbTime
  good_i = GET_CHASTON_IND(maximus,/BOTH_HEMIS)

  help,mapRatio.times
  help,cdbTime


  ;;Good, we have the same number of elements

  dat=mapratio.times[good_i]-cdbtime[good_i]

  ;;This is less awesome. How to fix?
  cghistoplot,dat,mininput=-50,maxinput=50
  what=n_elements(where(ABS(dat) GT 50))

  ;;redo orbits around here?
  redo_orbs_i     = WHERE(ABS(dat) GT 50)
  redo_orbs       = mapRatio.orbit[redo_orbs_i]
  uniq_redo_orbs  = redo_orbs[UNIQ(redo_orbs)]
  
END