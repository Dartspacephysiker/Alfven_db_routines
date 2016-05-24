PRO JOURNAL__20151221__FIGURING_OUT_WHICH_MAPRATIO_TIMES_ARE_BAD

  ;; restore,'/SPENCEdata/Research/database/mapratio_for_20151014_DB--up_to16361--20151221.dat'
  load_mapping_ratio_db,mapRatio

  load_maximus_and_cdbtime,maximus,cdbTime
  good_i = GET_CHASTON_IND(maximus,/BOTH_HEMIS)

  help,mapRatio.times
  help,cdbTime


  ;;Good, we have the same number of elements

  dat=mapRatio.times[good_i]-cdbtime[good_i]

  ;;This is less awesome. How to fix?
  ;; cghistoplot,dat,mininput=-50,maxinput=50
  cghistoplot,dat,mininput=-3,maxinput=3
  what = n_elements(where(ABS(dat) GT 50,/NULL))

  ;;redo orbits around here?
  IF what GT 0 THEN BEGIN
     redo_orbs_i     = WHERE(ABS(dat) GT 50)
     redo_orbs       = mapRatio.orbit[redo_orbs_i]
     uniq_redo_orbs  = redo_orbs[UNIQ(redo_orbs)]
  ENDIF ELSE BEGIN
     PRINT,"You're good, son."
  ENDELSE

END