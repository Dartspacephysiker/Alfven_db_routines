;2015/12/22

PRO JOURNAL__20151222__CHECKING_PFLUX_BEFORE_AND_AFTER_MAPPING_TO_IONOS

  ;;prelims
  hoyDia         = GET_TODAY_STRING(/DO_YYYY)
  SET_PLOT_DIR,plotDir,/ADD_TODAY,/FOR_ALFVENDB

  beforeFile     = plotDir + hoyDia + '--maximus_PfluxEst--before_mapping.png'
  afterFile      = plotDir + hoyDia + '--maximus_PfluxEst--after_mapping.png'

  good_i=GET_CHASTON_IND(maximus,/BOTH_HEMIS) ;get the inds we want

  ;;with mapped Pflux (default)
  cghistoplot,ALOG10(maximus.pfluxest[good_i]),MAXINPUT=1.5,OUTPUT=afterFile

  ;;Now do it without mapping pflux
  LOAD_MAXIMUS_AND_CDBTIME,maximus,/DO_NOT_MAP_PFLUX,/FORCE_LOAD_MAXIMUS
  cghistoplot,ALOG10(maximus.pfluxest[good_i]),MAXINPUT=1.5,OUTPUT=beforeFile

  ;; save,good_i,FILENAME='/SPENCEdata/Research/database/good_i--20151222--temp_for_checking_Pflux_before_and_after_mapping.sav'


END