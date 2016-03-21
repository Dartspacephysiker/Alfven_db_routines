;;OK, now we're grooving with this thing
PRO JOURNAL__20160317__TESTING_GET_CUSTOM_ALFVENDB_QUANTITY

  despun        = 1
  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=despun

  hemi          = 'NORTH'

  ;;This one is no good; can't divide logged by logged
  comeNGetIt    = "ALOG10(maximus.(18)[obs_inds]/maximus.width_x[obs_inds]*(mapRatio.ratio[obs_inds])^(0.5))/ALOG10(maximus.(49)[obs_inds])"

  ;;this is just the numerator, which works
  ;; comeNGetIt    = "ALOG10(maximus.(18)[obs_inds]/maximus.width_x[obs_inds]*(mapRatio.ratio[obs_inds])^(0.5))"

  ;;this one works
  comeNGetIt    = "ALOG10(maximus.(18)[obs_inds]/maximus.width_x[obs_inds]*(mapRatio.ratio[obs_inds])^(0.5)/(maximus.(49)[obs_inds]))"


  obs_inds_str  = "CGSETINTERSECTION(WHERE(maximus.(18) GT 0 AND FINITE(maximus.(49))),GET_CHASTON_IND(maximus,HEMI="+hemi+"))"

  maxData       = GET_CUSTOM_ALFVENDB_QUANTITY(comeNGetIt,GET_OBS_INDS__STRING=obs_inds_str,OUT_OBS_INDS=out_obs_inds,MAXIMUS=maximus,/VERBOSE)

END