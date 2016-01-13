;2016/11/13 I'm suspicious that we're going to have totally bogus ion data in the Southern hemisphere, since ALFVEN_STATS_5 may have
;been using the wrong angular range in every single case. It's really too bad.
;Wait! Everything looks OK after all.
PRO JOURNAL__20160113__SUP_WITH_DESPUN_ION_DATA

  ;; LOAD_MAXIMUS_AND_CDBTIME,maximus,CORRECT_FLUXES=0
  ;; north_i=get_chaston_ind(maximus,/NORTH)
  ;; south_i=get_chaston_ind(maximus,/SOUTH)

  LOAD_MAXIMUS_AND_CDBTIME,maximus_desp,/DO_DESPUNDB,CORRECT_FLUXES=0
  north_desp_i=get_chaston_ind(maximus_desp,/NORTH,/USING_HEAVIES)
  south_desp_i=get_chaston_ind(maximus_desp,/SOUTH,/USING_HEAVIES)

  ;;sanidad
  sane_n         = WHERE(FINITE(maximus_desp.oxy_flux_up[north_desp_i]),nSane_n,/NULL)
  sane_s         = WHERE(FINITE(maximus_desp.oxy_flux_up[south_desp_i]),nSane_s,/NULL)

  up_north_hyd = WHERE(maximus_desp.proton_flux_up[north_desp_i] GE 0,nUpN_hyd,COMPLEMENT=down_north_hyd,NCOMPLEMENT=nDownN_hyd,/NULL)
  up_south_hyd = WHERE(maximus_desp.proton_flux_up[south_desp_i] GE 0,nUpS_hyd,COMPLEMENT=down_south_hyd,NCOMPLEMENT=nDownS_hyd,/NULL)

  up_north_hel = WHERE(maximus_desp.helium_flux_up[north_desp_i] GE 0,nUpN_hel,COMPLEMENT=down_north_hel,NCOMPLEMENT=nDownN_hel,/NULL)
  up_south_hel = WHERE(maximus_desp.helium_flux_up[south_desp_i] GE 0,nUpS_hel,COMPLEMENT=down_south_hel,NCOMPLEMENT=nDownS_hel,/NULL)

  up_north_oxy = WHERE(maximus_desp.oxy_flux_up[north_desp_i] GE 0,nUpN_oxy,COMPLEMENT=down_north_oxy,NCOMPLEMENT=nDownN_oxy,/NULL)
  up_south_oxy = WHERE(maximus_desp.oxy_flux_up[south_desp_i] GE 0,nUpS_oxy,COMPLEMENT=down_south_oxy,NCOMPLEMENT=nDownS_oxy,/NULL)


  PRINT,'***HYDROGEN***'
  PRINT,FORMAT='("N upward hydrogen in Northern Hem.  : ",T50,I0)',nUpN_hyd
  PRINT,FORMAT='("N upward hydrogen in Southern Hem.  : ",T50,I0)',nUpS_hyd
  PRINT,FORMAT='("N downward hydrogen in Northern Hem.: ",T50,I0)',nDownN_hyd
  PRINT,FORMAT='("N downward hydrogen in Southern Hem.: ",T50,I0)',nDownS_hyd
  PRINT,''
  PRINT,'***HELIUM***'
  PRINT,FORMAT='("N upward helium in Northern Hem.  : ",T50,I0)',nUpN_hel
  PRINT,FORMAT='("N upward helium in Southern Hem.  : ",T50,I0)',nUpS_hel
  PRINT,FORMAT='("N downward helium in Northern Hem.: ",T50,I0)',nDownN_hel
  PRINT,FORMAT='("N downward helium in Southern Hem.: ",T50,I0)',nDownS_hel
  PRINT,''
  PRINT,'***OXYGEN***'
  PRINT,FORMAT='("N upward oxygen in Northern Hem.  : ",T50,I0)',nUpN_oxy
  PRINT,FORMAT='("N upward oxygen in Southern Hem.  : ",T50,I0)',nUpS_oxy
  PRINT,FORMAT='("N downward oxygen in Northern Hem.: ",T50,I0)',nDownN_oxy
  PRINT,FORMAT='("N downward oxygen in Southern Hem.: ",T50,I0)',nDownS_oxy

  ;;Now check out 'sup when we correct these:
  LOAD_MAXIMUS_AND_CDBTIME,maximus_desp,/DO_DESPUNDB,CORRECT_FLUXES=1,/USING_HEAVIES

  up_north_hyd = WHERE(maximus_desp.proton_flux_up[north_desp_i] GE 0,nUpN_hyd,COMPLEMENT=down_north_hyd,NCOMPLEMENT=nDownN_hyd,/NULL)
  up_south_hyd = WHERE(maximus_desp.proton_flux_up[south_desp_i] GE 0,nUpS_hyd,COMPLEMENT=down_south_hyd,NCOMPLEMENT=nDownS_hyd,/NULL)

  up_north_hel = WHERE(maximus_desp.helium_flux_up[north_desp_i] GE 0,nUpN_hel,COMPLEMENT=down_north_hel,NCOMPLEMENT=nDownN_hel,/NULL)
  up_south_hel = WHERE(maximus_desp.helium_flux_up[south_desp_i] GE 0,nUpS_hel,COMPLEMENT=down_south_hel,NCOMPLEMENT=nDownS_hel,/NULL)

  up_north_oxy = WHERE(maximus_desp.oxy_flux_up[north_desp_i] GE 0,nUpN_oxy,COMPLEMENT=down_north_oxy,NCOMPLEMENT=nDownN_oxy,/NULL)
  up_south_oxy = WHERE(maximus_desp.oxy_flux_up[south_desp_i] GE 0,nUpS_oxy,COMPLEMENT=down_south_oxy,NCOMPLEMENT=nDownS_oxy,/NULL)

  PRINT,'***HYDROGEN***'
  PRINT,FORMAT='("N upward hydrogen in Northern Hem.  : ",T50,I0)',nUpN_hyd
  PRINT,FORMAT='("N upward hydrogen in Southern Hem.  : ",T50,I0)',nUpS_hyd
  PRINT,FORMAT='("N downward hydrogen in Northern Hem.: ",T50,I0)',nDownN_hyd
  PRINT,FORMAT='("N downward hydrogen in Southern Hem.: ",T50,I0)',nDownS_hyd
  PRINT,''
  PRINT,'***HELIUM***'
  PRINT,FORMAT='("N upward helium in Northern Hem.  : ",T50,I0)',nUpN_hel
  PRINT,FORMAT='("N upward helium in Southern Hem.  : ",T50,I0)',nUpS_hel
  PRINT,FORMAT='("N downward helium in Northern Hem.: ",T50,I0)',nDownN_hel
  PRINT,FORMAT='("N downward helium in Southern Hem.: ",T50,I0)',nDownS_hel
  PRINT,''
  PRINT,'***OXYGEN***'
  PRINT,FORMAT='("N upward oxygen in Northern Hem.  : ",T50,I0)',nUpN_oxy
  PRINT,FORMAT='("N upward oxygen in Southern Hem.  : ",T50,I0)',nUpS_oxy
  PRINT,FORMAT='("N downward oxygen in Northern Hem.: ",T50,I0)',nDownN_oxy
  PRINT,FORMAT='("N downward oxygen in Southern Hem.: ",T50,I0)',nDownS_oxy


END