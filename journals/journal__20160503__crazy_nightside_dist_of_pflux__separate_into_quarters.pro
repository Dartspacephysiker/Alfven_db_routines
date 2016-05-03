PRO JOURNAL__20160503__CRAZY_NIGHTSIDE_DIST_OF_PFLUX__SEPARATE_INTO_QUARTERS

  LOAD_MAXIMUS_AND_CDBTIME,maximus,/GET_GOOD_I,GOOD_I=good_i

  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY

  ;;Bounds
  minMLT            = [18,0]
  maxMLT            = [24,6]

  ;;Inds
  ;; premidnight_i     = CGSETINTERSECTION(good_i,WHERE(maximus.mlt GE minMLT[0] AND maximus.mlt LE maxMLT[0]))
  premidnight_i     = CGSETINTERSECTION(good_i,WHERE(maximus.mlt GE minMLT[0]))
  postmidnight_i    = CGSETINTERSECTION(good_i,WHERE(maximus.mlt LE maxMLT[1]))

  ;;plotstuff
  plotMin           = -4.5
  plotMax           = 1.
  binsize           = 0.1

  ;;Now plot premidnight
  titlePremidnightMLT       = STRING(FORMAT='("(",I0,"-",I0," MLT)")',minMLT[0],maxMLT[0])
  filePremidnightMLT        = STRING(FORMAT='(I0,"-",I0,"_MLT")',minMLT[0],maxMLT[0])
  CGHISTOPLOT,ALOG10(maximus.pfluxest[premidnight_i]), $
              TITLE="Premidnight Log Poynting flux distribution" + titlePremidnightMLT, $
              OUTPUT=plotDir+'pFlux_dist_premidnight--'+filePremidnightMLT+'.png', $
              MAXINPUT=plotMax, $
              MININPUT=plotMin, $
              BINSIZE=binsize

  ;;Now postmidnight
  titlePostmidnightMLT       = STRING(FORMAT='("(",I0,"-",I0," MLT)")',minMLT[1],maxMLT[1])
  filePostmidnightMLT        = STRING(FORMAT='(I0,"-",I0,"_MLT")',minMLT[1],maxMLT[1])
  CGHISTOPLOT,ALOG10(maximus.pfluxest[postmidnight_i]), $
              TITLE="Postmidnight Log Poynting flux distribution" + titlePostmidnightMLT, $
              OUTPUT=plotDir+'pFlux_dist_postmidnight--'+filePostmidnightMLT+'.png', $
              MAXINPUT=plotMax, $
              MININPUT=plotMin, $
              BINSIZE=binsize

END