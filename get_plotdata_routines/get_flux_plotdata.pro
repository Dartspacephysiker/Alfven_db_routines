;2015/10/16
;Just generalize, my man
;
;2016/02/25
;Added DIVIDE_BY_WIDTH_X and can_div_by_w_x to make sure only quantities for which it makes sense can be divided by width_x
;2016/03/01 Added MULTIPLY_BY_WIDTH_X and can_mlt_by_w_x
;
;TO DO:
;2015/12/03 Fix e- number flux; most of those aren't actually number fluxes
; I've added this information to CORRECT_ALFVENDB_FLUXES

PRO GET_FLUX_PLOTDATA,maximus,plot_i, $
                      ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                      IMF_STRUCT=IMF_struct, $
                      MIMC_STRUCT=MIMC_struct, $
                      OUTH2DBINSMLT=outH2DBinsMLT, $
                      OUTH2DBINSILAT=outH2DBinsILAT, $
                      OUTH2DBINSLSHELL=outH2DBinsLShell, $
                      FLUXPLOTTYPE=fluxPlotType, $
                      PLOTRANGE=plotRange, $
                      PLOTAUTOSCALE=plotAutoscale, $
                      NEWELL_THE_CUSP=Newell_the_cusp, $
                      DIFFUSE_EVERYWHAR=fluxPlots__diffuse_everywhar, $
                      REMOVE_OUTLIERS=remove_outliers, $
                      REMOVE_LOG_OUTLIERS=remove_log_outliers, $
                      NOPOSFLUX=noPosFlux, $
                      NONEGFLUX=noNegFlux, $
                      ABSFLUX=absFlux, $
                      OUT_REMOVED_II=out_removed_ii, $
                      LOGFLUXPLOT=logFluxPlot, $
                      CB_DIVFACTOR=cb_divFactor, $
                      DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                      MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                      MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                      H2DPROBOCC=H2DProbOcc, $
                      DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                      DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
                      DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                      ;; PRINT_GROSSRATES=print_grossRates, $
                      GROSSRATE__H2D_AREAS=h2dAreas, $
                      DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
                      GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
                      GROSSRATE__CENTERS_MLT=centersMLT, $
                      GROSSRATE__CENTERS_ILAT=centersILAT, $
                      GROSSCONVFACTOR=H2DAreaConvFac, $
                      WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
                      GROSSLUN=grossLun, $
                      SHOW_INTEGRALS=show_integrals, $
                      THISTDENOMINATOR=tHistDenominator, $
                      H2DSTR=H2DStr, $
                      TMPLT_H2DSTR=tmplt_H2DStr, $
                      H2D_NONZERO_NEV_I=hEv_nz_i, $
                      H2DFLUXN=h2dFluxN, $
                      H2DMASK=h2dMask, $
                      UPDATE_H2D_MASK=update_h2d_mask, $
                      OUT_H2DMASK=out_h2dMask, $
                      DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                      MEDHISTOUTDATA=medHistOutData, $
                      MEDHISTOUTTXT=medHistOutTxt, $
                      MEDHISTDATADIR=medHistDataDir, $
                      DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                      ORBCONTRIB_H2DSTR_FOR_DIVISION=orbContrib_H2DStr_for_division, $
                      GET_EFLUX=get_eflux, $
                      GET_ENUMFLUX=get_eNumFlux, $
                      GET_PFLUX=get_pFlux, $
                      GET_IFLUX=get_iFlux, $
                      GET_OXYFLUX=get_oxyFlux, $
                      GET_CHAREE=get_ChareE, $
                      GET_CHARIE=get_chariE, $
                      GET_MAGC=get_magC, $
                      GET_SWAY=get_sWay, $
                      SWAY_STRUCTINDS=sWay_structInds, $
                      SWAY_STRUCTNAVN=sWay_structNavn, $
                      ;; EFLUX_ESPEC_DATA=eFlux_eSpec_data, $
                      ;; ENUMFLUX_ESPEC_DATA=eNumFlux_eSpec_data, $
                      IFLUX_ION_DATA=iFlux_ion_data, $
                      INUMFLUX_ION_DATA=iNumFlux_ion_data, $
                      INDICES__ESPEC=indices__eSpec, $
                      INDICES__ION=indices__ion, $
                      ;; ION_DELTA_T=ion_delta_t, $
                      ;; ION_MLTSILATS=ion_MLTsILATs, $
                      ;; ESPEC_MLTSILATS=eSpec_MLTsILATs, $
                      ESPEC_THISTDENOMINATOR=eSpec_tHistDenominator, $
                      DO_PLOT_I_INSTEAD_OF_HISTOS=do_plot_i_instead_of_histos, $
                      PRINT_MAX_AND_MIN=print_mandm, $
                      FANCY_PLOTNAMES=fancy_plotNames, $
                      LUN=lun
  
  COMPILE_OPT idl2,strictarrsubs

  for_pres = 1

  ;;The loaded defaults take advantage of KEYWORD_SET(fancy_plotNames)
  @fluxplot_defaults.pro

  @common__newell_espec.pro
  @common__newell_ion_db.pro
  @common__strangeway_bands.pro

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1
  IF N_ELEMENTS(print_mandm) EQ 0 THEN print_mandm = 1

  nDataz = 0

  IF N_ELEMENTS(update_h2d_mask) EQ 0 THEN update_h2d_mask = 1

  IF KEYWORD_SET(get_eFlux    ) THEN nDataz++
  IF KEYWORD_SET(get_eNumFlux ) THEN nDataz++
  IF KEYWORD_SET(get_pFlux    ) THEN nDataz++
  IF KEYWORD_SET(get_iFlux    ) THEN nDataz++
  IF KEYWORD_SET(get_ChareE   ) THEN nDataz++
  IF KEYWORD_SET(get_ChariE   ) THEN nDataz++
  IF KEYWORD_SET(get_magC     ) THEN nDataz++
  IF KEYWORD_SET(get_sWay     ) THEN nDataz++

  IF nDataz GT 1 THEN BEGIN
     IF KEYWORD_SET(get_eFlux) AND KEYWORD_SET(get_pFlux) THEN BEGIN
        PRINT,"Summed eFlux and Poynting flux ..."
        sum_eFlux_and_pFlux = 1
     ENDIF ELSE BEGIN
        PRINTF,lun,"Multiple plots at once currently not supported, you fool!"
        STOP
     ENDELSE
  ENDIF

  ;;Don't mod everyone's plot indices
  for_eSpec        = BYTE(KEYWORD_SET(indices__eSpec))
  for_ion          = BYTE(KEYWORD_SET(indices__ion))
  for_e_or_i       = for_eSpec OR for_ion
  for_sWay         = BYTE(KEYWORD_SET(get_sWay))
  CASE 1 OF
     for_eSpec: BEGIN
        tmp_i      = indices__eSpec
     END
     for_ion: BEGIN
        tmp_i      = indices__ion
        for_ion    = 1
     END
     ELSE: BEGIN
        tmp_i      = plot_i
     END
  ENDCASE

  ;; Flux plot safety
  IF KEYWORD_SET(logFluxPlot) AND $
     ~(KEYWORD_SET(absFlux) OR KEYWORD_SET(noNegFlux) OR KEYWORD_SET(noPosFlux)) $
  THEN BEGIN 
     PRINTF,lun,"Warning!: You're trying to do logplots of flux but you don't have 'absFlux', 'noNegFlux', or 'noPosFlux' set!"
     PRINTF,lun,"Can't make log plots without using absolute value or only positive values..."
     PRINTF,lun,"Default: junking all negative flux values"
     WAIT, 1
     noNegFlux = 1
  ENDIF
  IF KEYWORD_SET(noPosFlux) AND KEYWORD_SET (logFluxPlot) THEN absFlux = 1

  IF N_ELEMENTS(tmplt_H2DStr) EQ 0 THEN BEGIN
     tmplt_H2DStr  = MAKE_H2DSTR_TMPLT(BIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.binLng : MIMC_struct.binM), $
BIN2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.binL : MIMC_struct.binI),$
                                       MIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.minLng : MIMC_struct.minM), $
MIN2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.minL : MIMC_struct.minI),$
                                       MAX1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.maxLng : MIMC_struct.maxM), $
MAX2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.maxL : MIMC_struct.maxI), $
                                       SHIFT1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.shiftLng : MIMC_struct.shiftM),SHIFT2=shiftI, $
                                       EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning, $
                                       DO_PLOT_I_INSTEAD_OF_HISTOS=do_plot_i_instead_of_histos, $
                                       ;; PLOT_I=plot_i, $
                                       DO_TIMEAVG_FLUXQUANTITIES=alfDB_plot_struct.do_timeAvg_fluxQuantities, $
                                       CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                       CB_FORCE_OOBLOW=cb_force_oobLow)
  ENDIF

  ;;NOTE, this gets updated below after we figure out which type of flux we're doing. It may get turned off ...
  grossRateMe               = KEYWORD_SET(do_grossRate_fluxQuantities) OR $
                              KEYWORD_SET(do_grossRate_with_long_width) OR $
                              KEYWORD_SET(grossRate_info_file) OR $
                              KEYWORD_SET(show_integrals)

  ;; H2DStr                    = {tmplt_H2DStr}
  H2DStr                    = tmplt_H2DStr
  H2DStr.is_fluxData        = 1

  IF KEYWORD_SET(cb_divFactor) THEN BEGIN
     H2DStr.cb_divFactor    = cb_divFactor
  ENDIF

  IF KEYWORD_SET(get_eFlux) THEN BEGIN
     dataName               = "eFlux"
     H2DStr.labelFormat     = fluxPlotEPlotCBLabelFormat
     H2DStr.logLabels       = logeFluxLabels
     H2DStr.do_plotIntegral = eFlux_do_plotIntegral
     H2DStr.do_midCBLabel   = eFlux_do_midCBLabel

     CASE 1 OF
        STRUPCASE(fluxplottype) EQ STRUPCASE("Integ"): BEGIN
           tmpFluxPlotType  = 'Intg'
           H2DStr.title     = title__alfDB_ind_09
           inData           = maximus.integ_elec_energy_flux
           can_div_by_w_x   = 1
           can_mlt_by_w_x   = 0

           H2DStr.grossFac  = 1e9
           H2DStr.gUnits    = 'bro'
        END
        STRUPCASE(fluxplottype) EQ STRUPCASE("eflux_losscone_integ"): BEGIN
           tmpFluxPlotType  = 'LC_intg'
           H2DStr.title     = title__alfDB_ind_10
           inData           = maximus.eflux_losscone_integ
           can_div_by_w_x   = 1
           can_mlt_by_w_x   = 0
           IF KEYWORD_SET(divide_by_width_x) THEN BEGIN
              H2DStr.title  = title__alfDB_ind_10__div_by_width_x
              ;; dataName     += '__div_by_width_x'
              ;; LOAD_MAPPING_RATIO_DB,mapRatio, $
              ;;                       DESPUNDB=maximus.info.despun
              ;; magFieldFactor        = SQRT(mapRatio.ratio) ;This scales width_x to the ionosphere
              H2DStr.grossFac  = 1e9
              H2DStr.gUnits    = 'GW'

           ENDIF

           IF KEYWORD_SET(do_timeAvg_fluxQuantities) AND ~KEYWORD_SET(for_pres) THEN BEGIN
              H2DStr.title  = title__alfDB_ind_10 + '(time-averaged)'
           ENDIF

           IF KEYWORD_SET(grossRateMe) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    H2DStr.title   = title__alfDB_ind_10_grossRate + '(long. wid.)'
                    H2DAreaConvFac = 1 ;Lengths given in km, but we need them in m. To junk 'milli' prefix in mW, we get a net factor of 1
                 END
                 ELSE: BEGIN
                    IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                       H2DStr.title = title__alfDB_ind_10_grossRate
                    ENDIF
                    H2DAreaConvFac  = 1e3 ;Areas are given in km^2, but we need them in m^2 (less a factor of 10^3 to junk 'milli' prefix on mW)
                 END
              ENDCASE
           ENDIF
        END
        STRUPCASE(fluxplottype) EQ STRUPCASE("total_eflux_integ"): BEGIN

           tmpFluxPlotType  = 'tot_intg'
           H2DStr.title     = title__alfDB_ind_11
           inData           = maximus.total_eflux_integ
           can_div_by_w_x   = 1
           can_mlt_by_w_x   = 0

           IF KEYWORD_SET(divide_by_width_x) THEN BEGIN

              H2DStr.grossFac  = 1e9
              H2DStr.gUnits    = 'GW'
           
              H2DStr.title     = title__alfDB_ind_11__div_by_width_x
           ENDIF

           IF KEYWORD_SET(do_timeAvg_fluxQuantities) AND ~KEYWORD_SET(for_pres) THEN BEGIN
              H2DStr.title  = title__alfDB_ind_11 + '(time-averaged)'
           ENDIF

           IF KEYWORD_SET(grossRateMe) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    H2DStr.title   = title__alfDB_ind_11_grossRate + '(long. wid.)'
                    H2DAreaConvFac = 1 ;Lengths given in km, but we need them in m. To junk 'milli' prefix in mW, we get a net factor of 1
                 END
                 ELSE: BEGIN
                    IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                       H2DStr.title = title__alfDB_ind_11_grossRate
                    ENDIF
                    H2DAreaConvFac  = 1e3 ;Areas are given in km^2, but we need them in m^2 (less a factor of 10^3 to junk 'milli' prefix on mW)
                 END
              ENDCASE
           ENDIF
        END
        STRUPCASE(fluxplottype) EQ STRUPCASE("Max"): BEGIN
           tmpFluxPlotType  = 'Max'
           H2DStr.title     = title__alfDB_ind_08
           inData           = maximus.elec_energy_flux
           can_div_by_w_x   = 0
           can_mlt_by_w_x   = 1

           H2DStr.grossFac  = 1e9
           H2DStr.gUnits    = 'GW'

           IF KEYWORD_SET(grossRateMe) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    H2DStr.title   = title__alfDB_ind_08_grossRate + '(long. wid.)'
                    H2DAreaConvFac = 1 ;Lengths given in km, but we need them in m. To junk 'milli' prefix in mW, we get a net factor of 1
                 END
                 ELSE: BEGIN
                    IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                       H2DStr.title = title__alfDB_ind_08_grossRate
                    ENDIF
                    H2DAreaConvFac  = 1e3 ;Areas are given in km^2, but we need them in m^2 (less a factor of 10^3 to junk 'milli' prefix on mW)
                 END
              ENDCASE
           ENDIF
        END
        ((STRUPCASE(fluxPlotType) EQ STRUPCASE("eFlux_eSpec")) OR $
           (STRUPCASE(fluxPlotType) EQ STRUPCASE("eFlux_eSpec-2009"))): BEGIN
           tmpFluxPlotType  = 'eSpec' + (STRMATCH(fluxPlotType,'*2009*') ? '-2009' : '')
           H2DStr.title     = title__eSpec_ind_10
           ;;NOTE: microCoul_per_m2__to_num_per_cm2 = 1. / 1.6e-9
           ;; for_eSpec      = 1
           ;; inData           = eFlux_eSpec_data
           inData           = NEWELL__eSpec.jee
           can_div_by_w_x   = 0
           can_mlt_by_w_x   = 1

           H2DStr.grossFac  = 1e9
           H2DStr.gUnits    = 'GW'

           IF KEYWORD_SET(grossRateMe) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    H2DStr.title   = title__eSpec_ind_10__grossRate + '(long. wid.)'
                    H2DAreaConvFac = 1 ;Lengths given in km, but we need them in m. To junk 'milli' prefix in mW, we get a net factor of 1
                 END
                 ELSE: BEGIN
                    IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                       H2DStr.title = title__eSpec_ind_10__grossRate
                    ENDIF
                    H2DAreaConvFac  = 1e3 ;Areas are given in km^2, but we need them in m^2 (less a factor of 10^3 to junk 'milli' prefix on mW)
                 END
              ENDCASE
           ENDIF
           IF KEYWORD_SET(alfDB_plot_struct.eSpec__junk_alfven_candidates) THEN BEGIN
              dataname += '-candidates_removed'
           ENDIF ELSE BEGIN
              IF KEYWORD_SET(alfDB_plot_struct.eSpec__all_fluxes) THEN BEGIN
                 dataname += '-all_fluxes'
              ENDIF
           ENDELSE
        END
     ENDCASE
  ENDIF

  IF KEYWORD_SET(get_eNumFlux) THEN BEGIN
     dataName               = "eNumFl"
     H2DStr.labelFormat     = fluxPlotColorBarLabelFormat
     H2DStr.logLabels       = logeNumFluxLabels
     H2DStr.do_plotIntegral = eNumFlux_do_plotIntegral
     H2DStr.do_midCBLabel   = eNumFlux_do_midCBLabel

     CASE 1 OF
        STRUPCASE(fluxPlotType) EQ STRUPCASE("total_eflux_integ"): BEGIN

           tmpFluxPlotType  = 'tot_eF_intg'
           H2DStr.title     = title__alfDB_ind_11
           inData           = maximus.total_eflux_integ
           can_div_by_w_x   = 1
           can_mlt_by_w_x   = 0

           IF KEYWORD_SET(divide_by_width_x) THEN BEGIN

              H2DStr.grossFac  = 1e9
              H2DStr.gUnits    = 'GW'

              H2DStr.title     = title__alfDB_ind_11__div_by_width_x

           ENDIF

           IF KEYWORD_SET(grossRateMe) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    H2DStr.title   = title__alfDB_ind_11_grossRate + '(long. wid.)'
                    H2DAreaConvFac = 1 ;Lengths given in km, but we need them in m. To junk 'milli' prefix in mW, we get a net factor of 1
                 END
                 ELSE: BEGIN
                    IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                       H2DStr.title = title__alfDB_ind_11_grossRate
                    ENDIF
                    H2DAreaConvFac  = 1e3 ;Areas are given in km^2, but we need them in m^2 (less a factor of 10^3 to junk 'milli' prefix on mW)
                 END
              ENDCASE
           ENDIF

        END
        STRUPCASE(fluxPlotType) EQ STRUPCASE("Eflux_Losscone_Integ"): BEGIN
           tmpFluxPlotType  = 'eF_LC_intg'
           H2DStr.title     = title__alfDB_ind_10
           inData           = maximus.eflux_losscone_integ
           can_div_by_w_x   = 1
           can_mlt_by_w_x   = 0
           IF KEYWORD_SET(divide_by_width_x) THEN BEGIN
              H2DStr.title  = title__alfDB_ind_10__div_by_width_x

              H2DStr.grossFac  = 1e9
              H2DStr.gUnits    = 'GW'

              ;; dataName     += '__div_by_width_x'
              ;; LOAD_MAPPING_RATIO_DB,mapRatio, $
              ;;                       DESPUNDB=maximus.info.despun
              ;; magFieldFactor = SQRT(mapRatio.ratio) ;This scales width_x to the ionosphere
              magFieldFactor = 1.0D

              inData        = ((indata/magFieldFactor)/maximus.width_x) ;*mapRatio.ratio
              already_divided_by_width_x = 1

              ;;Make them sane
              pos_i         = WHERE(inData GT 0,nPos)
              IF nPos GT 0 THEN BEGIN
                 tmpPos_i   = CGSETINTERSECTION(pos_i,tmp_i,COUNT=nCheckIt)
                 IF nCheckIt GT 0 THEN BEGIN
                    fixMe_ii = WHERE(inData[tmpPos_i] GT maximus.elec_energy_flux[tmpPos_i],nFix)
                    IF fixMe_ii[0] NE -1 THEN BEGIN
                       PRINT,'Correcting ' + $
                             STRCOMPRESS(nFix,/REMOVE_ALL) + $
                             ' inds where spatially averaged eFlux is greater than max eFlux'
                       inData[tmpPos_i[fixMe_ii]] = maximus.elec_energy_flux[tmpPos_i[fixMe_ii]]
                    ENDIF
                 ENDIF
              ENDIF

              neg_i         = WHERE(inData LT 0,nNeg)
              IF nNeg GT 0 THEN BEGIN
                 tmpNeg_i   = CGSETINTERSECTION(neg_i,tmp_i,COUNT=nCheckIt)
                 IF nCheckIt GT 0 THEN BEGIN
                    fixMe_ii = WHERE(inData[tmpNeg_i] LT maximus.elec_energy_flux[tmpNeg_i],nFix)
                    IF fixMe_ii[0] NE -1 THEN BEGIN
                       PRINT,'Correcting ' + $
                             STRCOMPRESS(nFix,/REMOVE_ALL) + $
                             ' inds where negative spatially averaged eFlux is lt than negative max eFlux ...'
                       inData[tmpNeg_i[fixMe_ii]] = maximus.elec_energy_flux[tmpNeg_i[fixMe_ii]]
                    ENDIF
                 ENDIF
              ENDIF

           ENDIF

           IF KEYWORD_SET(do_timeAvg_fluxQuantities) AND ~KEYWORD_SET(for_pres) THEN BEGIN
              H2DStr.title  = title__alfDB_ind_10 + '(time-averaged)'
           ENDIF

           IF KEYWORD_SET(grossRateMe) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    H2DStr.title   = title__alfDB_ind_10_grossRate + '(long. wid.)'
                    H2DAreaConvFac = 1 ;Lengths given in km, but we need them in m. To junk 'milli' prefix in mW, we get a net factor of 1
                 END
                 ELSE: BEGIN
                    IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                       H2DStr.title = title__alfDB_ind_10_grossRate
                    ENDIF
                    H2DAreaConvFac  = 1e3 ;Areas are given in km^2, but we need them in m^2 (less a factor of 10^3 to junk 'milli' prefix on mW)
                 END
              ENDCASE
           ENDIF
        END
        STRUPCASE(fluxPlotType) EQ STRUPCASE("ESA_Number_flux"): BEGIN
           tmpFluxPlotType  = ''
           H2DStr.title  = title__alfDB_esa_nFlux

           H2DStr.grossFac  = 1e25
           H2DStr.gUnits    = 'E+25'
           ;;NOTE: microCoul_per_m2__to_num_per_cm2 = 1. / 1.6e-9
           ;; inData           = maximus.esa_current * (DOUBLE(1. / 1.6e-9))

           inData = maximus.ELEC_ENERGY_FLUX / maximus.MAX_CHARE_LOSSCONE * 6.242*1.0e11

           ;;Try it
           ;; inData           = (maximus.esa_current * (DOUBLE(1. / 1.6e-9)) * (-1.) +  $
           ;;                    maximus.integ_ion_flux) / 1e4

           IF KEYWORD_SET(multiply_by_width_x) THEN BEGIN
              PRINTF,lun,"you realize you should probably just divide energy flux by chare, right?"
              ;; STOP

              H2DStr.title     = title__alfDB_esa_nFlux_integ
              ;; LOAD_MAPPING_RATIO_DB,mapRatio, $
              ;;                       DESPUNDB=maximus.info.despun
              ;; IF maximus.info.mapped.esa_current THEN BEGIN 
              ;;    ;; PRINT,'Undoing a square-root factor of multiplication by magField ratio for ESA number flux...'
              ;;    ;; magFieldFactor        = 1.D/SQRT(mapRatio.ratio) ;This undoes the full multiplication by mapRatio performed in CORRECT_ALFVENDB_FLUXES
              ;; ENDIF ELSE BEGIN
              ;;    ;; magFieldFactor        = SQRT(mapRatio.ratio)
              ;;    ;; magFieldFactor        = SQRT(mapRatio.ratio)
              ;; ENDELSE
              magFieldFactor              = 1.0D
           ENDIF

           CASE 1 OF 
              KEYWORD_SET(do_timeAvg_fluxQuantities): BEGIN
                 IF ~KEYWORD_SET(for_pres) THEN BEGIN
                    H2DStr.title          = title__alfDB_esa_nFlux + '(time-averaged)'
                 ENDIF
              END
              ELSE: BEGIN
                 IF ~KEYWORD_SET(for_pres) THEN BEGIN
                    H2DStr.title          = title__alfDB_esa_nFlux + '(time-averaged)'
                 ENDIF
              END
           ENDCASE

           can_div_by_w_x   = 0
           can_mlt_by_w_x   = 1

           IF KEYWORD_SET(grossRateMe) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    H2DStr.title   = title__alfDB_esa_nFlux_grossRate + '(long. wid.)'
                    H2DAreaConvFac = 1e5 ;Lengths given in km, but we need them in cm.
                 END
                 ELSE: BEGIN
                    IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                       H2DStr.title = title__alfDB_esa_nFlux_grossRate
                    ENDIF
                    H2DAreaConvFac  = 1e10 ;Areas are given in km^2, but we need them in cm^2
                 END
              ENDCASE
           ENDIF
        END
        STRUPCASE(fluxPlotType) EQ STRUPCASE("ESA_Current"): BEGIN
           tmpFluxPlotType  = 'e_curr'
           H2DStr.title  = title__alfDB_ind_07
           ;;NOTE: microCoul_per_m2__to_num_per_cm2 = 1. / 1.6e-9
           inData           = maximus.esa_current

           ;; H2DStr.title  = title__alfDB_ind_07 + '(+i,outpos)'
           ;; inData           = maximus.esa_current*(-1.) + maximus.ion_flux*1.6e-9

           ;; H2DStr.title  = title__alfDB_ind_07 + '(justi)'
           ;; inData           = maximus.ion_flux*1.6e-9

           can_div_by_w_x   = 0
           can_mlt_by_w_x   = 1

           H2DStr.grossFac  = 1d6 ;Display amps with 'mega' prefix
           H2DStr.gUnits    = 'MA'
           H2DAreaConvFac   = 1.D  ;H2DAreas in km^2, so conv to m^2 to match ESA_current units
                                   ;(times 1e-6 to junk 'micro' prefix) 
        END
        ((STRUPCASE(fluxPlotType) EQ STRUPCASE("eNumFlux_eSpec")) OR $
         (STRUPCASE(fluxPlotType) EQ STRUPCASE("eNumFlux_eSpec-2009"))): BEGIN
           tmpFluxPlotType  = 'eSpec' + (STRMATCH(fluxPlotType,'*2009*') ? '-2009' : '')
           H2DStr.title     = title__eSpec_esa_nFlux
           ;;NOTE: microCoul_per_m2__to_num_per_cm2 = 1. / 1.6e-9
           ;; for_eSpec      = 1
           ;; tmp_i            = indices__eSpec
           ;; inData           = eNumFlux_eSpec_data
           inData           = NEWELL__eSpec.je
           can_div_by_w_x   = 0
           can_mlt_by_w_x   = 1

           H2DStr.grossFac  = 1e25
           H2DStr.gUnits    = 'E+25'

           IF KEYWORD_SET(alfDB_plot_struct.eSpec__junk_alfven_candidates) THEN BEGIN
              dataname += '-candidates_removed'
           ENDIF ELSE BEGIN
              IF KEYWORD_SET(alfDB_plot_struct.eSpec__all_fluxes) THEN BEGIN
                 dataname += '-all_fluxes'
              ENDIF
           ENDELSE

           IF KEYWORD_SET(grossRateMe) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    H2DStr.title    = title__eSpec_esa_nFlux__grossRate + '(long. wid.)'
                    H2DAreaConvFac  = 1e5 ;Lengths are in km, but we convert them to cm.
                 END
                 ELSE: BEGIN
                    IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                       H2DStr.title = title__eSpec_esa_nFlux__grossRate
                    ENDIF
                    H2DAreaConvFac  = 1e10 ;Areas are in km^2, but we convert them to cm^2
                 END
              ENDCASE
           ENDIF
        END
     ENDCASE

     IF KEYWORD_SET(multiply_by_width_x) AND can_mlt_by_w_x THEN BEGIN
        ;; scale_width_for_these_plots = [STRUPCASE("ESA_Number_flux"),STRUPCASE("eNumFlux_eSpec")]
        ;; scale_to_cm = WHERE(STRUPCASE(fluxPlotType) EQ scale_width_for_these_plots)
        scale_width_for_these_plots = [STRUPCASE("*ESA_Number_flux*"),STRUPCASE("*eNumFlux_eSpec*")]
        ;; scale_to_cm = WHERE(STRMATCH(STRUPCASE(fluxPlotType),scale_width_for_these_plots))
        ;; IF scale_to_cm[0] EQ -1 THEN BEGIN
        scale_to_cm = 0B
        FOR b=0,N_ELEMENTS(scale_width_for_these_plots)-1 DO BEGIN
           scale_to_cm = scale_to_cm OR STRMATCH(STRUPCASE(fluxPlotType),scale_width_for_these_plots[b])
        ENDFOR
        IF ~scale_to_cm THEN BEGIN
           sclFactor = 1.D
        ENDIF ELSE BEGIN 
           sclFactor = .01D 
           PRINT,'...Scaling WIDTH_X to centimeters for '+fluxPlotType+' plots...'
        ENDELSE
     ENDIF
  ENDIF
     
  IF KEYWORD_SET(get_pFlux) THEN BEGIN

     tmpFluxPlotType       = 'pF'
     H2DStr.grossFac       = 1.D9
     H2DStr.gUnits         = 'GW'

     CASE 1 OF
        KEYWORD_SET(do_timeAvg_fluxQuantities): BEGIN
           ;; CASE 1 OF
           ;;    KEYWORD_SET(do_grossRate_fluxQuantities): BEGIN
           ;;       H2DStr.title= title__alfDB_ind_49_grossRate
           ;;       H2DAreaConvFac =   1e3 ;Areas are given in km^2, but we need them in m^2 (less a factor of 10^3 to junk 'milli' prefix on mW)
           ;;    END
           ;;    KEYWORD_SET(do_grossRate_with_long_width): BEGIN
           ;;       H2DStr.title    = title__alfDB_ind_49_grossRate + '(long. wid.)'
           ;;       H2DAreaConvFac = 1 ;Lengths given in km, but we need them in m. To junk 'milli' prefix in mW, we get a net factor of 1
           ;;    END              
           ;;    ELSE: BEGIN
                 ;; H2DStr.title    = title__alfDB_ind_49_tAvg
           IF KEYWORD_SET(sum_eFlux_and_pFlux) THEN BEGIN
              ;; H2DStr.title          = 'Summed e!U-!N Energy Flux and Poynting Flux (mW m!U-2!N)'
              H2DStr.title          = 'Summed e!U-!N and Poynting Fluxes (mW m!U-2!N) at 100 km'

           ENDIF ELSE BEGIN
              IF ~KEYWORD_SET(for_pres) THEN BEGIN
                 H2DStr.title          = title__alfDB_ind_49 + '(time-averaged)'
              ENDIF ELSE BEGIN
                 H2DStr.title          = title__alfDB_ind_49
              ENDELSE

           ENDELSE
           
           ;;    END
           ;; ENDCASE
        END
        ELSE: BEGIN
           IF KEYWORD_SET(sum_eFlux_and_pFlux) THEN BEGIN
              H2DStr.title          = 'Summed eFlux and pFlux (mW/m!U2!N)'
           ENDIF ELSE BEGIN
              H2DStr.title          = title__alfDB_ind_49
           ENDELSE
        END
     ENDCASE

     IF KEYWORD_SET(multiply_by_width_x) THEN BEGIN
        H2DStr.title     = title__alfDB_ind_49_integ
        ;; LOAD_MAPPING_RATIO_DB,mapRatio, $
        ;;                       DESPUNDB=maximus.info.despun
        ;; IF maximus.mapped.pFlux THEN BEGIN ;Assume that pFlux has been multiplied by mapRatio
        ;;    PRINT,'Undoing a square-root factor of multiplication by magField ratio for Poynting flux ...'
        ;;    IF KEYWORD_SET(sum_eFlux_and_pFlux) THEN BEGIN
        ;;       magFieldFactor2    = 1.D/SQRT(mapRatio.ratio) ;This undoes the full multiplication by mapRatio performed in CORRECT_ALFVENDB_FLUXES
        ;;    ENDIF ELSE BEGIN
        ;;       magFieldFactor     = 1.D/SQRT(mapRatio.ratio) ;This undoes the full multiplication by mapRatio performed in CORRECT_ALFVENDB_FLUXES
        ;;    ENDELSE
        ;; ENDIF ELSE BEGIN
        ;;    IF KEYWORD_SET(sum_eFlux_and_pFlux) THEN BEGIN
        ;;       magFieldFactor2    = SQRT(mapRatio.ratio)
        ;;    ENDIF ELSE BEGIN
        ;;       magFieldFactor     = SQRT(mapRatio.ratio)
        ;;    ENDELSE
        ;; ENDELSE
        magFieldFactor2      = 1.0D
        magFieldFactor       = 1.0D
     ENDIF

     IF KEYWORD_SET(grossRateMe) THEN BEGIN
        CASE 1 OF
           KEYWORD_SET(do_grossRate_with_long_width): BEGIN
              IF KEYWORD_SET(sum_eFlux_and_pFlux) THEN BEGIN
                 H2DStr.title     = 'Gross summed eFlux and pFlux (long. wid.)'
                 H2DAreaConvFac2  = 1 ;Lengths given in km, but we need them in m. To junk 'milli' prefix in mW, we get a net factor of 1
              ENDIF ELSE BEGIN
                 H2DStr.title     = title__alfDB_ind_49_grossRate + '(long. wid.)'
                 H2DAreaConvFac   = 1 ;Lengths given in km, but we need them in m. To junk 'milli' prefix in mW, we get a net factor of 1
              ENDELSE
           END
           ELSE: BEGIN
              IF KEYWORD_SET(sum_eFlux_and_pFlux) THEN BEGIN
                 IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                    H2DStr.title     = "Gross summed eFlux and pFlux"
                 ENDIF
                 H2DAreaConvFac2     = 1e3 ;Areas are given in km^2, but we need them in m^2 (less a factor of 10^3 to junk 'milli' prefix on mW)
              ENDIF ELSE BEGIN
                 IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                    H2DStr.title     = title__alfDB_ind_49_grossRate
                 ENDIF
                 H2DAreaConvFac      = 1e3 ;Areas are given in km^2, but we need them in m^2 (less a factor of 10^3 to junk 'milli' prefix on mW)
              ENDELSE
           END
        ENDCASE
     ENDIF
     
     dataName               = KEYWORD_SET(sum_eFlux_and_pFlux) ? "eF_pF" : "pF"
     H2DStr.labelFormat     = fluxPlotPPlotCBLabelFormat
     ;; H2DStr.logLabels       = logPFluxLabels
     H2DStr.logLabels       = 0
     H2DStr.do_plotIntegral = PFlux_do_plotIntegral
     H2DStr.do_midCBLabel   = PFlux_do_midCBLabel

     IF KEYWORD_SET(sum_eFlux_AND_pFlux) THEN BEGIN
        inData2             = maximus.pFluxEst
        can_div_by_w_x2     = 0
        can_mlt_by_w_x2     = 1
     ENDIF ELSE BEGIN
        inData              = maximus.pFluxEst
        can_div_by_w_x      = 0
        can_mlt_by_w_x      = 1
     ENDELSE

  ENDIF

  IF KEYWORD_SET(get_iFlux) THEN BEGIN
     ;; H2DStr.title= "Ion Flux (ergs/cm!U2!N-s)"
     dataName               = "iflux" 
     H2DStr.labelFormat     = fluxPlotColorBarLabelFormat
     H2DStr.logLabels       = logiFluxLabels
     H2DStr.do_plotIntegral = iFlux_do_plotIntegral
     H2DStr.do_midCBLabel   = iFlux_do_midCBLabel

     CASE 1 OF
        STRUPCASE(fluxplottype) EQ STRUPCASE("Integ"): BEGIN
           tmpFluxPlotType  = 'Intg'
           H2DStr.title     = title__alfDB_ind_17
           inData           = maximus.integ_ion_flux
           can_div_by_w_x   = 1
           can_mlt_by_w_x   = 0


           H2DStr.grossFac       = 1.D22
           H2DStr.gUnits         = 'E+22'

           IF KEYWORD_SET(divide_by_width_x) THEN BEGIN
              H2DStr.title               = title__alfDB_ind_17__div_by_width_x

              ;;OOOOOH no you don't. Alreay handled by AS5
              ;; LOAD_MAPPING_RATIO_DB,mapRatio, $
              ;;                       DESPUNDB=maximus.info.despun

              magFieldFactor             = 1.0D
              inData                     = ((indata/magFieldFactor)/maximus.width_x)
              already_divided_by_width_x = 1
              ;; dataName     += '__div_by_width_x'
              ;; LOAD_MAPPING_RATIO_DB,mapRatio, $
              ;;                       DESPUNDB=maximus.info.despun
              ;; magFieldFactor        = SQRT(mapRatio.ratio) ;This scales width_x to the ionosphere
           ENDIF

           IF KEYWORD_SET(grossRateMe) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    H2DStr.title    = title__alfDB_ind_17 + '(long. wid.)'
                    H2DAreaConvFac  = 1e5 ;Lengths given in km, but we need them in cm.
                 END
                 ELSE: BEGIN
                    IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                       H2DStr.title = title__alfDB_ind_17_grossRate
                    ENDIF
                    H2DAreaConvFac  = 1e10 ;Areas are given in km^2, but we need them in cm^2
                 END
              ENDCASE
           ENDIF
        END
        STRUPCASE(fluxplottype) EQ STRUPCASE("Max"): BEGIN
           tmpFluxPlotType  = 'Max'
           H2DStr.title     = title__alfDB_ind_15
           inData           = maximus.ion_flux
           can_div_by_w_x   = 0
           can_mlt_by_w_x   = 1

           H2DStr.grossFac       = 1.D22
           H2DStr.gUnits         = 'E+22'

           IF KEYWORD_SET(grossRateMe) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    H2DAreaConvFac  = 1e5 ;Lengths given in km, but we need them in cm.
                 END
                 ELSE: BEGIN
                    IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                    ENDIF
                    H2DAreaConvFac  = 1e10 ;Areas are given in km^2, but we need them in cm^2
                 END
              ENDCASE
           ENDIF
        END
        STRUPCASE(fluxplottype) EQ STRUPCASE("Max_Up"): BEGIN
           tmpFluxPlotType  = 'MaxUp'
           H2DStr.title     = title__alfDB_ind_16
           inData           = maximus.ion_flux_up
           can_div_by_w_x   = 0
           can_mlt_by_w_x   = 1

           H2DStr.grossFac       = 1.D24
           H2DStr.gUnits         = 'E+24'

           IF KEYWORD_SET(grossRateMe) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    H2DAreaConvFac  = 1e5 ;Lengths given in km, but we need them in cm.
                 END
                 ELSE: BEGIN
                    IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                    ENDIF
                    H2DAreaConvFac  = 1e10 ;Areas are given in km^2, but we need them in cm^2
                 END
              ENDCASE
           ENDIF
        END
        STRUPCASE(fluxplottype) EQ STRUPCASE("Integ_Up"): BEGIN
           tmpFluxPlotType  = 'IntgUp'
           H2DStr.title     = title__alfDB_ind_18
           inData           = maximus.integ_ion_flux_up
           can_div_by_w_x   = 1
           can_mlt_by_w_x   = 0

           H2DStr.grossFac       = 1.D24
           H2DStr.gUnits         = 'E+24'

           IF KEYWORD_SET(divide_by_width_x) THEN BEGIN

              H2DStr.title  = title__alfDB_ind_18__div_by_width_x
              ;; dataName     += '__div_by_width_x'

              ;;OOOOOH no you don't. Alreay handled by AS5
              ;; LOAD_MAPPING_RATIO_DB,mapRatio, $
              ;;                       DESPUNDB=maximus.info.despun
              ;; magFieldFactor        = SQRT(mapRatio.ratio) ;This scales width_x to the ionosphere
              magFieldFactor = 1.0D

              ;; inData         = ((indata/magFieldFactor)/maximus.width_x)*mapRatio.ratio
              inData         = ((indata/magFieldFactor)/maximus.width_x)
              already_divided_by_width_x = 1

           ENDIF
           IF KEYWORD_SET(do_timeAvg_fluxQuantities) THEN BEGIN
              ;; CASE 1 OF
              ;;    KEYWORD_SET(do_grossRate_fluxQuantities): BEGIN
              ;;       H2DStr.title    = title__alfDB_ind_18_grossRate
              ;;       H2DAreaConvFac = 1e10 ;Areas are given in km^2, but we need them in cm^2
              ;;    END
              ;;    KEYWORD_SET(do_grossRate_with_long_width): BEGIN
              ;;       H2DStr.title    = title__alfDB_ind_18_grossRate + '(long. wid.)'
              ;;       H2DAreaConvFac = 1e5 ;Lengths given in km, but we need them in cm.
              ;;    END
              ;;    ELSE: BEGIN
              ;; H2DStr.title       = title__alfDB_ind_18_tAvg + '(time-averaged)'
              IF ~KEYWORD_SET(for_pres) THEN BEGIN

                 H2DStr.title       = title__alfDB_ind_18 + '(time-averaged)'
              ENDIF
              ;;    END
              ;; ENDCASE
           ENDIF

           IF KEYWORD_SET(grossRateMe) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    H2DStr.title    = title__alfDB_ind_18_grossRate + '(long. wid.)'
                    H2DAreaConvFac  = 1e5 ;Lengths given in km, but we need them in cm.
                 END
                 ELSE: BEGIN
                    IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                       H2DStr.title = title__alfDB_ind_18_grossRate
                    ENDIF
                    H2DAreaConvFac  = 1e10 ;Areas are given in km^2, but we need them in cm^2
                 END
              ENDCASE
           ENDIF
        END
        STRUPCASE(fluxPlotType) EQ STRUPCASE("Ji_ion"): BEGIN
           tmpFluxPlotType        = 'Ji_ion'
           CASE 1 OF
              KEYWORD_SET(NEWELL_I__ion.info.is_downgoing): BEGIN
                 H2DStr.title     = title__ion_flux__downgoing
                 H2DStr.grossFac  = 1.D24
                 H2DStr.gUnits    = 'E+24'
              END
              ELSE: BEGIN
                 H2DStr.title     = title__ion_flux
                 H2DStr.grossFac  = 1.D22
                 H2DStr.gUnits    = 'E+22'
              END
           ENDCASE
           ;;NOTE: microCoul_per_m2__to_num_per_cm2 EQ 1. / 1.6e-9
           ;; for_ion                = 1
           ;; tmp_i               = indices__ion
           ;; inData              = iNumFlux_ion_data
           inData                 = NEWELL_I__ion.ji

           can_div_by_w_x   = 0
           can_mlt_by_w_x   = 0

           IF KEYWORD_SET(alfDB_plot_struct.ion__junk_alfven_candidates) THEN BEGIN
              dataname += '-candidates_removed'
           ENDIF ELSE BEGIN
              IF KEYWORD_SET(alfDB_plot_struct.ion__all_fluxes) THEN BEGIN
                 dataname += '-all_fluxes'
              ENDIF
           ENDELSE

           IF KEYWORD_SET(grossRateMe) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    H2DStr.title    = title__eSpec_ind_18__grossRate + '(long. wid.)'
                    H2DAreaConvFac  = 1e5 ;Lengths given in km, but we need them in cm.
                 END
                 ELSE: BEGIN
                    IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                       H2DStr.title = title__eSpec_ind_18__grossRate
                    ENDIF
                    H2DAreaConvFac  = 1e10 ;H2DAreas are given in km^2, but we need them in cm^2
                 END
              ENDCASE
           ENDIF
        END
        STRUPCASE(fluxPlotType) EQ STRUPCASE("Jei_ion"): BEGIN
           tmpFluxPlotType  = 'Jei_ion'
           ;; H2DStr.title  = 'Ion Energy Flux (non-' + alficStr + ')'
           CASE 1 OF
              KEYWORD_SET(NEWELL_I__ion.info.is_downgoing): BEGIN
                 H2DStr.title     = title__ion_eFlux__downgoing
                 H2DStr.grossFac  = 1e9
                 H2DStr.gUnits    = 'GW'
              END
              ELSE: BEGIN
                 H2DStr.title     = title__ion_eFlux
                 H2DStr.grossFac  = 1e9
                 H2DStr.gUnits    = 'GW'
              END
           ENDCASE
           ;; H2DStr.title        = 'Ion Energy Flux (mW/m!U2!N)'
           ;;NOTE: microCoul_per_m2__to_num_per_cm2  EQ 1. / 1.6e-9
           ;; for_ion                = 1
           ;; tmp_i                  = indices__ion
           ;; inData              = iFlux_ion_data
           inData                 = NEWELL_I__ion.jei
           can_div_by_w_x         = 0
           can_mlt_by_w_x         = 1

           IF KEYWORD_SET(alfDB_plot_struct.ion__junk_alfven_candidates) THEN BEGIN
              dataname += '-candidates_removed'
           ENDIF ELSE BEGIN
              IF KEYWORD_SET(alfDB_plot_struct.ion__all_fluxes) THEN BEGIN
                 dataname += '-all_fluxes'
              ENDIF
           ENDELSE

           IF KEYWORD_SET(grossRateMe) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    H2DAreaConvFac = 1 ;Lengths given in km, but we need them in m. To junk 'milli' prefix in mW, we get a net factor of 1
                 END
                 ELSE: BEGIN
                    IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                    ENDIF
                    H2DAreaConvFac  = 1e3 ;Areas are given in km^2, but we need them in m^2 (less a factor of 10^3 to junk 'milli' prefix on mW)
                 END
              ENDCASE
           ENDIF
        END
        STRUPCASE(fluxplottype) EQ STRUPCASE("Energy"): BEGIN
           tmpFluxPlotType  = 'NRG'
           H2DStr.title     = title__alfDB_ind_14
           inData           = maximus.ion_energy_flux
           can_div_by_w_x   = 0
           can_mlt_by_w_x   = 1

           H2DStr.grossFac  = 1e6
           H2DStr.gUnits    = 'MW'

           IF KEYWORD_SET(grossRateMe) THEN BEGIN
              CASE 1 OF
                 KEYWORD_SET(do_grossRate_with_long_width): BEGIN
                    H2DAreaConvFac = 1 ;Lengths given in km, but we need them in m. To junk 'milli' prefix in mW, we get a net factor of 1
                 END
                 ELSE: BEGIN
                    IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
                    ENDIF
                    H2DAreaConvFac  = 1e3 ;Areas are given in km^2, but we need them in m^2 (less a factor of 10^3 to junk 'milli' prefix on mW)
                 END
              ENDCASE
           ENDIF
        END
     ENDCASE

     IF KEYWORD_SET(divide_by_width_x) AND can_div_by_w_x THEN BEGIN
        ;; scale_width_for_these_plots = [STRUPCASE("Integ"),STRUPCASE("Max"),STRUPCASE("Max_Up"),STRUPCASE("Integ_Up"),STRUPCASE("Jei_ion")]
        ;; scale_to_cm = WHERE(STRUPCASE(fluxPlotType) EQ scale_width_for_these_plots)
        scale_width_for_these_plots = [STRUPCASE("*Integ*"),STRUPCASE("*Max*"),STRUPCASE("*Max_Up*"),STRUPCASE("*Integ_Up*"),STRUPCASE("*Jei_ion*")]
        scale_to_cm = 0B
        FOR b=0,N_ELEMENTS(scale_width_for_these_plots)-1 DO BEGIN
           scale_to_cm = scale_to_cm OR STRMATCH(STRUPCASE(fluxPlotType),STRUPCASE(scale_width_for_these_plots[b]))
        ENDFOR
        ;; scale_to_cm = WHERE(STRMATCH(fluxPlotType,scale_width_for_these_plots))
        ;; IF scale_to_cm[0] EQ -1 THEN BEGIN
        IF ~scale_to_cm THEN BEGIN
           sclFactor           = 1.D
        ENDIF ELSE BEGIN 
           sclFactor           = .01D 
           PRINT,'...Scaling WIDTH_X to centimeters for dividing '+fluxPlotType+' plots...'
        ENDELSE
     ENDIF
  ENDIF

  IF KEYWORD_SET(get_ChareE) THEN BEGIN
     dataName               = 'charEE'
     H2DStr.labelFormat     = fluxPlotChareCBLabelFormat
     H2DStr.logLabels       = logChareLabels
     H2DStr.do_plotIntegral = Charee_do_plotIntegral
     H2DStr.do_midCBLabel   = Charee_do_midCBLabel

     H2DStr.do_plotIntegral = 0B
     H2DStr.is_fluxData     = 0B
     H2DStr.do_grossRate    = 0B
     H2DStr.do_timeAvg      = 0B

     CASE 1 OF
        STRUPCASE(fluxplottype) EQ STRUPCASE("lossCone"): BEGIN
           tmpFluxPlotType  = 'LC'
           H2DStr.title     = title__alfDB_ind_12
           inData           = maximus.max_chare_losscone
        END
        STRUPCASE(fluxplottype) EQ STRUPCASE("Total"): BEGIN
           tmpFluxPlotType  = 'tot'
           H2DStr.title     = title__alfDB_ind_13
           inData           = maximus.max_chare_total
        END
        ( (STRUPCASE(fluxplottype) EQ STRUPCASE("charE_eSpec")) OR $
          (STRUPCASE(fluxplottype) EQ STRUPCASE("charE_eSpec-2009"))): BEGIN
           tmpFluxPlotType  = 'eSpec' + (STRMATCH(fluxPlotType,'*2009*') ? '-2009' : '')           
           H2DStr.title     = title__eSpec_charEE
           ;;NOTE: microCoul_per_m2__to_num_per_cm2 = 1. / 1.6e-9
           ;; for_eSpec        = 1
           ;; tmp_i            = indices__eSpec
           ;; inData           = eNumFlux_eSpec_data
           inData           = ABS(NEWELL__eSpec.jee/NEWELL__eSpec.je)*6.242*1.0e11
           can_div_by_w_x   = 0
           can_mlt_by_w_x   = 1

           H2DStr.grossFac  = 0
           H2DStr.gUnits    = ''

           IF KEYWORD_SET(alfDB_plot_struct.eSpec__junk_alfven_candidates) THEN BEGIN
              dataname += '-cndidts_rmd'
           ENDIF ELSE BEGIN
              IF KEYWORD_SET(alfDB_plot_struct.eSpec__all_fluxes) THEN BEGIN
                 dataname += '-all_fluxes'
              ENDIF
           ENDELSE

        END
     ENDCASE
     can_div_by_w_x         = 0
     can_mlt_by_w_x         = 0
     cant_timeAvg           = 1
     H2DStr.do_timeAvg      = 0
     cant_grossRate         = 1
     tmpLogAvg              = 1
  ENDIF

  IF KEYWORD_SET(get_ChariE) THEN BEGIN
  
     H2DStr.labelFormat     = fluxPlotCharieCBLabelFormat
     H2DStr.logLabels       = logCharieLabels
     H2DStr.do_plotIntegral = Charie_do_plotIntegral
     H2DStr.do_midCBLabel   = Charie_do_midCBLabel

     CASE 1 OF
        for_ion: BEGIN
           H2DStr.title     = title__alfDB_ind_19
           dataName         = 'ion_charIE'
           inData           = NEWELL_i__ion.charE
        END
        ELSE: BEGIN
           H2DStr.title     = title__alfDB_ind_19
           dataName         = 'charIE'
           inData           = maximus.char_ion_energy
        END
     ENDCASE

     can_div_by_w_x         = 0
     can_mlt_by_w_x         = 0
     cant_timeAvg           = 1
     H2DStr.do_timeAvg      = 0
     cant_grossRate         = 1
     tmpLogAvg              = 1

     H2DStr.do_plotIntegral = 0B
     H2DStr.is_fluxData     = 0B
     H2DStr.do_grossRate    = 0B
     H2DStr.do_timeAvg      = 0B
     
  ENDIF

  IF KEYWORD_SET(get_magC) THEN BEGIN
     H2DStr.title            = title__alfDB_ind_06
     dataName                = 'magC'
     H2DStr.labelFormat      = fluxPlotMagCCBLabelFormat
     H2DStr.logLabels        = logMagCLabels
     H2DStr.do_plotIntegral  = MagC_do_plotIntegral
     H2DStr.do_midCBLabel    = MagC_do_midCBLabel
     inData                  = maximus.mag_current

     H2DStr.grossFac         = 1d6 ;Display amps with 'mega' prefix
     H2DStr.gUnits           = 'MA'
     H2DAreaConvFac          = 1.D ;H2DAreas in km^2, so conv to m^2 to match ESA_current units
                                ;(times 1e-6 to junk 'micro' prefix) 

     can_div_by_w_x          = 0
     can_mlt_by_w_x          = 1
  ENDIF

  IF KEYWORD_SET(get_sWay) THEN BEGIN
     dataName               = STRJOIN(sWay_structNavn,'_')
     H2DStr.labelFormat     = fluxPlotSWayCBLabelFormat
     H2DStr.logLabels       = logSWayLabels
     H2DStr.do_plotIntegral = sWay_do_plotIntegral
     H2DStr.do_midCBLabel   = sWay_do_midCBLabel

     can_div_by_w_x         = 0
     can_mlt_by_w_x         = 1

     inData                 = SWAY__DB.(sWay_structInds[0]).(sWay_structInds[1]).(sWay_structInds[2])

     ACDCString             = sWay_structNavn[2]

     tmpFluxPlotType        = SWAY__DB.info.is_8Hz_DB ? '8Hz' : ''

     CASE STRUPCASE(sWay_structNavn[0]) OF
        'DB': BEGIN

           unitString       = BFieldString

           CASE STRUPCASE(sWay_structNavn[1]) OF
              'B': BEGIN
                 H2DStr.title  = title__sWay_bb
              END
              'P': BEGIN
                 H2DStr.title  = title__sWay_bp
              END
              'V': BEGIN
                 H2DStr.title  = title__sWay_bv
              END
           ENDCASE

        END
        'E': BEGIN

           unitString       = EFieldString

           CASE STRUPCASE(sWay_structNavn[1]) OF
              'ALONGV': BEGIN
                 H2DStr.title = title__sWay_eAlongV
              END
           ENDCASE

        END
        'PFLUX': BEGIN

           unitString       = energyFluxStr

           CASE STRUPCASE(sWay_structNavn[1]) OF
              'B': BEGIN
                 H2DStr.title  = title__sWay_Pb
              END
              'P': BEGIN
                 H2DStr.title  = title__sWay_Pp
              END
              'V': BEGIN
                 H2DStr.title  = title__sWay_Pv
              END
           ENDCASE

        END
        ELSE: BEGIN
           STOP
        END
     ENDCASE

     H2DStr.title          += ' [' + ACDCString + '] (' + unitString + ')'

  ENDIF

  ;;Update grossRateMe
  grossRateMe               = grossRateMe AND ~KEYWORD_SET(cant_grossRate)

  ;;Handle name of data
  ;;Log plots desired?
  absStr                    = ""
  negStr                    = ""
  posStr                    = ""
  logStr                    = ""

  removed_ii                = !NULL
  IF N_ELEMENTS(WHERE(FINITE(inData[tmp_i]))) NE N_ELEMENTS(tmp_i) THEN BEGIN
     ;; finite_ii              =  WHERE(FINITE(inData[tmp_i]),COMPLEMENT=rmTmp_ii, $
     ;;                                 NCOMPLEMENT=nRem)
     finite_i               = WHERE(FINITE(inData),COMPLEMENT=rmTmp_i, $
                                     NCOMPLEMENT=nRem)
     rmTmp_ii               = WHERE(~FINITE(inData[tmp_i]))
     
     IF finite_i[0] NE -1 THEN BEGIN
        ;; PRINT,"BAD DATA: " + STRCOMPRESS(nRem,/REMOVE_ALL)
        ;; junk_i              = CGSETDIFFERENCE(tmp_i,finite_i,POSITIONS=rmTmp_ii,NORESULT=-1)
        tmp_i               = CGSETINTERSECTION(tmp_i,finite_i,COUNT=nFinite)
        ;; tmp_i               = tmp_i[finite_ii]
     ENDIF

     IF rmTmp_ii[0] NE -1 THEN BEGIN
        removed_ii          = [removed_ii,TEMPORARY(rmTmp_ii)]
     ENDIF

  ENDIF
  IF KEYWORD_SET(absFlux)THEN BEGIN
     PRINTF,lun,"N pos elements in " + dataName + " data: ",N_ELEMENTS(where(inData[tmp_i] GT 0.))
     PRINTF,lun,"N neg elements in " + dataName + " data: ",N_ELEMENTS(where(inData[tmp_i] LT 0.))
     IF KEYWORD_SET(noPosFlux) THEN BEGIN
        posStr              = 'NoP-'
        PRINTF,lun,"N elements in " + dataName + " before junking pos vals: ",N_ELEMENTS(tmp_i)
        ;; lt_ii                =  WHERE(inData[tmp_i] LT 0.,COMPLEMENT=rmTmp_ii)
        lt_i                = WHERE(inData LT 0.,COMPLEMENT=rmTmp_i)
        rmTmp_ii            = WHERE(inData[tmp_i] GE 0.)

        ;; IF lt_ii[0] NE -1 THEN BEGIN
        IF lt_i[0] NE -1 THEN BEGIN

           ;; tmp_i            = tmp_i[lt_ii]
           ;; junk_i           = CGSETDIFFERENCE(tmp_i,lt_i,POSITIONS=rmTmp_ii,NORESULT=-1)
           tmp_i            = CGSETINTERSECTION(tmp_i,lt_i,COUNT=nNeg)

           ;; tmp_i            = tmp_i[lt_ii]
           ;; PRINTF,lun,"N elements in " + dataName + " after junking pos vals: ",N_ELEMENTS(tmp_i)
           PRINTF,lun,"N elements in " + dataName + " after junking pos vals: ",nNeg
           inData           = ABS(inData)
        ENDIF

        IF rmTmp_ii[0] NE -1 THEN BEGIN
           removed_ii          = [removed_ii,TEMPORARY(rmTmp_ii)]
        ENDIF

     ENDIF ELSE BEGIN
        absStr              = 'Abs-' 
     ENDELSE
     inData                 = ABS(inData)
  ENDIF
  IF KEYWORD_SET(noNegFlux) THEN BEGIN
     negStr                 = 'NoN-'
     PRINTF,lun,"N elements in " + dataName + " before junking neg vals: ",N_ELEMENTS(tmp_i)
     ;; gt_ii                   =  WHERE(inData[tmp_i] GT 0.,COMPLEMENT=rmTmp_ii)
     gt_i                   = WHERE(inData GT 0.,COMPLEMENT=rmTmp_i)
     rmTmp_ii               = WHERE(inData[tmp_i] LE 0.)
     IF gt_i[0] NE -1 THEN BEGIN

        ;; junk_i           = CGSETDIFFERENCE(tmp_i,gt_i,POSITIONS=rmTmp_ii,NORESULT=-1)
        tmp_i            = CGSETINTERSECTION(tmp_i,gt_i,COUNT=nPos)
        ;; tmp_i               = tmp_i[gt_ii]
        ;; PRINTF,lun,"N elements in " + dataName + " after junking neg vals: ",N_ELEMENTS(tmp_i)
        PRINTF,lun,"N elements in " + dataName + " after junking neg vals: ",nPos
     ENDIF

     IF rmTmp_ii[0] NE -1 THEN BEGIN
        removed_ii          = [removed_ii,TEMPORARY(rmTmp_ii)]
     ENDIF

  ENDIF
  IF KEYWORD_SET(noPosFlux) AND ~KEYWORD_SET(absFlux) THEN BEGIN
     posStr                 = 'NoP-'
     PRINTF,lun,"N elements in " + dataName + " before junking pos vals: ",N_ELEMENTS(tmp_i)

     lt_i                    =  WHERE(inData        LT 0.,COMPLEMENT=rmTmp_i)
     rmTmp_ii                =  WHERE(inData[tmp_i] GE 0.)

     IF lt_i[0] NE -1 THEN BEGIN

        ;; tmp_i               = tmp_i[lt_ii]
        ;; PRINTF,lun,"N elements in " + dataName + " after junking pos vals: ",N_ELEMENTS(tmp_i)

        ;; junk_i           = CGSETDIFFERENCE(tmp_i,lt_i,POSITIONS=rmTmp_ii,NORESULT=-1)
        tmp_i            = CGSETINTERSECTION(tmp_i,lt_i,COUNT=nNeg)

        PRINTF,lun,"N elements in " + dataName + " after junking pos vals: ",nNeg
        inData           = ABS(inData)
     ENDIF

     IF rmTmp_ii[0] NE -1 THEN BEGIN
        removed_ii          = [removed_ii,TEMPORARY(rmTmp_ii)]
     ENDIF

  ENDIF
  IF KEYWORD_SET(logFluxPlot) THEN BEGIN
     IF ~H2DStr.logLabels THEN BEGIN
        logStr              = "Log "
     ENDIF
  ENDIF

  absnegslogStr             = absStr + negStr + posStr + logStr
  dataName                  = STRTRIM(absnegslogStr,2)+dataName + $
                              (KEYWORD_SET(tmpFluxPlotType) ? '_' + tmpFluxPlotType : '')
  ;; H2DStr.title              = absnegslogStr + H2DStr.title

  ;;This looks like a nice spot for outlier removal
  killOutliers = KEYWORD_SET(remove_outliers) OR KEYWORD_SET(remove_log_outliers)
  IF killOutliers THEN BEGIN
     ;; inlier_i = GET_FASTDB_OUTLIER_INDICES( $
     ;;            inData, $
     ;;            /FOR_DATA_ARRAY, $
     ;;            DATA_ARRAY__NAME=dataName, $
     ;;            /REMOVE_OUTLIERS, $
     ;;            USER_INDS=tmp_i, $
     ;;            ;; ONLY_UPPER=only_upper, $
     ;;            ONLY_UPPER=only_upper, $
     ;;            ONLY_LOWER=only_lower, $
     ;;            LOG_OUTLIERS=KEYWORD_SET(remove_log_outliers) OR $
     ;;            KEYWORD_SET(alfDB_plot_struct.logAvgPlot), $
     ;;            /DOUBLE, $
     ;;            ;; /LOG_OUTLIERS, $
     ;;            REMOVAL__NORESULT=-1, $
     ;;            LOG__ABS=absFlux, $
     ;;            LOG__NEG=noPosFlux, $
     ;;            ;; ADD_SUSPECTED=KEYWORD_SET(for_eSpec))
     ;;            /ADD_SUSPECTED)
     ;; IF (inlier_i[0] NE -1) AND (inlier_i[0] NE 0) THEN BEGIN
     ;;    tmp_i = TEMPORARY(inlier_i)
     ;; ENDIF ELSE BEGIN
     ;;    PRINT,"You're dead."
     ;;    STOP
     ;; ENDELSE

     ;;'igfpd' = 'in GET_FLUX_PLOTDATA'
     ;; dataName += '_rm' + ( KEYWORD_SET(remove_log_outliers) ? 'l' : '' ) + 'ol_igfpd'
     dataName += '_rm' + ( KEYWORD_SET(remove_log_outliers) ? 'l' : '' ) + 'ol-no_sus'
  ENDIF


  IF KEYWORD_SET(divide_by_width_x) THEN BEGIN
     IF can_div_by_w_x THEN BEGIN
        PRINT,'Dividing by WIDTH_X!'
        
        dataName               = 'sptAvg_' + dataName

        ;;If the ion plots or one of the select electron plots didn't pick this up, set it to 1
        ;;NOTE, oxy also needs to be scaled!!!
        IF N_ELEMENTS(sclFactor) EQ 0 THEN sclFactor = 1.0D
        IF N_ELEMENTS(magFieldFactor) EQ 0 THEN magFieldFactor = 1.0D

        IF ~KEYWORD_SET(already_divided_by_width_x) THEN BEGIN
           inData                 = inData*sclFactor*magFieldFactor/maximus.width_x
        ENDIF ELSE BEGIN
           ;; PRINT,'ALREADY DIVIDED ' + dataName + ', DUDE'
           inData                 = inData*sclFactor
        ENDELSE
     ENDIF ELSE BEGIN
        PRINTF,lun,"Can't divide " + dataName + " by width_x! Not in the cards."
     ENDELSE

     IF KEYWORD_SET(sum_eFlux_and_pFlux) THEN BEGIN
        IF can_div_by_w_x2 THEN BEGIN
           PRINT,'Dividing by WIDTH_X!'
           
           dataName               = 'sptAvg_' + dataName

           ;;If the ion plots or one of the select electron plots didn't pick this up, set it to 1
           ;;NOTE, oxy also needs to be scaled!!!
           IF N_ELEMENTS(sclFactor2) EQ 0 THEN sclFactor2 = 1.0D
           IF N_ELEMENTS(magFieldFactor2) EQ 0 THEN magFieldFactor2 = 1.0D

           inData2                 = inData2*sclFactor2*magFieldFactor2/maximus.width_x
        ENDIF ELSE BEGIN
           PRINTF,lun,"Can't divide " + dataName + " by width_x! Not in the cards."
        ENDELSE
     ENDIF
  ENDIF

  IF KEYWORD_SET(multiply_by_width_x) THEN BEGIN
     IF can_mlt_by_w_x THEN BEGIN
        PRINT,'Multiplying by WIDTH_X!'
        
        dataName               = 'sptIntg_' + dataName
        
        ;;If the ion plots or one of the select electron plots didn't pick this up, set it to 1
        ;;NOTE, oxy also needs to be scaled!!!
        IF N_ELEMENTS(sclFactor) EQ 0 THEN sclFactor = 1.0D
        IF N_ELEMENTS(magFieldFactor) EQ 0 THEN magFieldFactor = 1.0D
        
        inData                 = inData*sclFactor*magFieldFactor*maximus.width_x
     ENDIF ELSE BEGIN
        PRINTF,lun,"Can't multiply " + dataName + " by width_x! Not in the cards."
     ENDELSE

     IF KEYWORD_SET(sum_eFlux_and_pFlux) THEN BEGIN
        IF can_mlt_by_w_x2 THEN BEGIN
           PRINT,'Multiplying by WIDTH_X!'
           
           dataName               = 'sptIntg_' + dataName
           
           ;;If the ion plots or one of the select electron plots didn't pick this up, set it to 1
           ;;NOTE, oxy also needs to be scaled!!!
           IF N_ELEMENTS(sclFactor2) EQ 0 THEN sclFactor2 = 1.0D
           IF N_ELEMENTS(magFieldFactor2) EQ 0 THEN magFieldFactor2 = 1.0D
           
           inData2                 = inData2*sclFactor2*magFieldFactor2*maximus.width_x
        ENDIF ELSE BEGIN
           PRINTF,lun,"Can't multiply " + dataName + " by width_x! Not in the cards."
        ENDELSE
     ENDIF
  ENDIF

  ;;If summing eFlux and pFlux, we can do it here
  IF KEYWORD_SET(sum_eFlux_and_pFlux) THEN BEGIN
     ;; CASE 1 OF
     ;;    N_ELEMENTS(lt_ii) GT 0: BEGIN
     ;;       inData2                = inData2[lt_ii]
     ;;    END
     ;;    N_ELEMENTS(gt_ii) GT 0: BEGIN
     ;;       inData2                = inData2[gt_ii]
     ;;    END
     ;;    ELSE:
     ;; ENDCASE

     inData                 = inData + TEMPORARY(inData2)
  ENDIF

  ;;Is this going to be a time-averaged plot?
  IF KEYWORD_SET(do_timeAvg_fluxQuantities) AND ~KEYWORD_SET(cant_timeAvg) THEN BEGIN
     CASE 1 OF
        KEYWORD_SET(for_eSpec): BEGIN
           inData     = inData * NEWELL__delta_t
        END
        KEYWORD_SET(for_ion): BEGIN
           inData     = inData * NEWELL_I__delta_t
        END
        ELSE: BEGIN
           inData     = inData * maximus.width_time 
        END
     ENDCASE

     dataName        = 'tAvgd_' + dataName

  ENDIF

  ;;gross rates?
  IF (KEYWORD_SET(do_grossRate_fluxQuantities) $
      OR KEYWORD_SET(do_grossRate_with_long_width)) AND $
     ~KEYWORD_SET(cant_grossRate) $
  THEN BEGIN
     CASE 1 OF
        KEYWORD_SET(do_grossRate_with_long_width): BEGIN
           dataName   = 'grossRate_longWid_' + dataName
        END
        ELSE: BEGIN
           dataName   = 'grossRate_' + dataName
        END
     ENDCASE
  ENDIF

  ;;Averaging based on number of orbits passing through instead of nEvents, perhaps?
  IF KEYWORD_SET(div_fluxPlots_by_applicable_orbs) THEN BEGIN
     H2DStr.title     = 'Orbit-averaged ' + H2DStr.title
     dataName         = 'orbAvgd_' + dataName
  ENDIF

  ;;Update inData, others
  inData              = inData[tmp_i]

  ;;fix MLTs
  CASE 1 OF
     ;; KEYWORD_SET(eSpec_MLTsILATs): BEGIN
     for_eSpec: BEGIN
        mlts   = SHIFT_MLTS_FOR_H2D(!NULL,!NULL,MIMC_struct.shiftM, $
                                    IN_MLTS=(KEYWORD_SET(MIMC_struct.use_Lng) ? NEWELL__eSpec.lng : NEWELL__eSpec.mlt)[tmp_i], $
                                    SHIFTM_IS_SHIFTLNG=MIMC_struct.use_Lng)
        ilats  = NEWELL__eSpec.ilat[tmp_i]
     END
     ;; KEYWORD_SET(ion_MLTsILATs): BEGIN
     for_ion: BEGIN
        mlts   = SHIFT_MLTS_FOR_H2D(!NULL,!NULL,MIMC_struct.shiftM, $
                                    IN_MLTS=(KEYWORD_SET(MIMC_struct.use_Lng) ? NEWELL_I__ion.lng : NEWELL_I__ion.mlt)[tmp_i], $
                                    SHIFTM_IS_SHIFTLNG=MIMC_struct.use_Lng)
        ilats  = NEWELL_I__ion.ilat[tmp_i]
     END
     for_sWay: BEGIN
        mlts   = SHIFT_MLTS_FOR_H2D(!NULL,!NULL,MIMC_struct.shiftM, $
                                    IN_MLTS=(KEYWORD_SET(MIMC_struct.use_Lng) ? SWAY__DB.lng : SWAY__DB.mlt)[tmp_i], $
                                    SHIFTM_IS_SHIFTLNG=MIMC_struct.use_Lng)
        ilats  = SWAY__DB.ilat[tmp_i]
     END
     ELSE: BEGIN
        mlts   = SHIFT_MLTS_FOR_H2D(maximus,tmp_i,MIMC_struct.shiftM,SHIFTM_IS_SHIFTLNG=MIMC_struct.use_Lng)
        ilats  = (KEYWORD_SET(MIMC_struct.do_lShell) ? maximus.lshell : maximus.ilat)[tmp_i]
     END
  ENDCASE

  IF KEYWORD_SET(H2DStr.both_hemis) THEN ilats = ABS(ilats)

  IF KEYWORD_SET(do_plot_i_instead_of_histos) THEN BEGIN
     H2DStr.data.add,inData
     hEv_nz_i      = LINDGEN(N_ELEMENTS(inData))
  ENDIF ELSE BEGIN

     nz_inds = WHERE(h2dFluxN NE 0,/NULL)

     CASE 1 OF
        KEYWORD_SET(alfDB_plot_struct.medianPlot): BEGIN 

           IF KEYWORD_SET(medHistOutData) THEN BEGIN
              medHistDatFile      = medHistDataDir + dataName+"medhist_data.sav"
           ENDIF
           
           H2DStr.data = MEDIAN_HIST(mlts, $
                                     ilats,$
                                     inData,$
                                     MIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.minLng : MIMC_struct.minM), $
                                     MIN2=(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.minL : MIMC_struct.minI), $
                                     BINSIZE1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.binLng : MIMC_struct.binM), $
                                     MAX1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.maxLng : MIMC_struct.maxM), $
                                     MAX2=(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.maxL : MIMC_struct.maxI), $
                                     BINSIZE2=(KEYWORD_SET(MIMC_struct.do_lshell) ? MIMC_struct.binL : MIMC_struct.binI),$
                                     OBIN1=outH2DBinsMLT, $
                                     OBIN2=(KEYWORD_SET(MIMC_struct.do_lshell) ? outH2DBinsLShell : outH2DBinsILAT),$
                                     ABSMED=absFlux, $
                                     OUTFILE=medHistDatFile, $
                                     PLOT_I=tmp_i, $
                                     EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning) 
           
           IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + dataName + "medhist.txt"
        END
        KEYWORD_SET(do_timeAvg_fluxQuantities) AND ~KEYWORD_SET(cant_timeAvg): BEGIN

           CASE 1 OF
              KEYWORD_SET(alfDB_plot_struct.EA_binning): BEGIN
                 H2DStr.data = HIST2D__EQUAL_AREA_BINNING(mlts, $
                                                          ilats,$
                                                          (KEYWORD_SET(alfDB_plot_struct.do_logAvg_the_timeAvg) ? ALOG10(DOUBLE(inData)) : DOUBLE(inData)),$
                                                          MIN1=MIMC_struct.minM,MIN2=(KEYWORD_SET(do_lshell) ? MIMC_struct.minL : MIMC_struct.minI),$
                                                          MAX1=MIMC_struct.maxM,MAX2=(KEYWORD_SET(do_lshell) ? MIMC_struct.maxL : MIMC_struct.maxI),$
                                                          OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
              END
              ELSE: BEGIN
                 H2DStr.data = HIST2D(mlts, $
                                      ilats,$
                                      (KEYWORD_SET(alfDB_plot_struct.do_logAvg_the_timeAvg) ? ALOG10(inData) : inData),$
                                      MIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.minLng : MIMC_struct.minM), $
MIN2=(KEYWORD_SET(do_lshell) ? MIMC_struct.minL : MIMC_struct.minI),$
                                      MAX1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.maxLng : MIMC_struct.maxM), $
MAX2=(KEYWORD_SET(do_lshell) ? MIMC_struct.maxL : MIMC_struct.maxI),$
                                      BINSIZE1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.binLng : MIMC_struct.binM), $
                                      BINSIZE2=(KEYWORD_SET(do_lshell) ? MIMC_struct.binL : MIMC_struct.binI),$
                                      OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
              END
           ENDCASE

           IF KEYWORD_SET(alfDB_plot_struct.do_logAvg_the_timeAvg) THEN BEGIN
              H2DStr.data[hEv_nz_i]=H2DStr.data[hEv_nz_i]/h2dFluxN[hEv_nz_i] 
              H2DStr.data[WHERE(h2dFluxN GT 0,/NULL)] = 10^(H2DStr.data[WHERE(h2dFluxN GT 0,/NULL)])
           ENDIF

           PROBOCCURRENCE_AND_TIMEAVG_SANITY_CHECK,H2DStr, $
                                                   KEYWORD_SET(for_e_or_i) ? eSpec_tHistDenominator : tHistDenominator, $
                                                   outH2DBinsMLT, $
                                                   outH2DBinsILAT, $
                                                   H2DFluxN, $
                                                   dataName, $
                                                   h2dMask

           ;;junked all those WHERE(H2DStr.data GT 0) as of 2016/04/23
           H2DStr.data[WHERE(ABS(H2DStr.data) GT 0)] = H2DStr.data[WHERE(ABS(H2DStr.data) GT 0)]/ $
                                                  (KEYWORD_SET(for_e_or_i) ? eSpec_tHistDenominator : $
                                                   tHistDenominator)[WHERE(ABS(H2DStr.data) GT 0)]
           ;; H2DStr.data[hEv_nz_i] = H2DStr.data[hEv_nz_i]/tHistDenominator[hEv_nz_i]

        END
        (KEYWORD_SET(alfDB_plot_struct.maxPlot) OR KEYWORD_SET(alfDB_plot_struct.minPlot)): BEGIN

           H2DStr.data = MEDIAN_HIST(mlts, $
                                     ilats,$
                                     inData,$
                                     MAXIMUM=alfDB_plot_struct.maxPlot, $
                                     MINIMUM=alfDB_plot_struct.minPlot, $
                                     MIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.minLng : MIMC_struct.minM), $
                                     MIN2=(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.minL : MIMC_struct.minI), $
                                     BINSIZE1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.binLng : MIMC_struct.binM), $
                                     MAX1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.maxLng : MIMC_struct.maxM), $
                                     MAX2=(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.maxL : MIMC_struct.maxI), $
                                     BINSIZE2=(KEYWORD_SET(MIMC_struct.do_lshell) ? MIMC_struct.binL : MIMC_struct.binI),$
                                     OBIN1=outH2DBinsMLT, $
                                     OBIN2=(KEYWORD_SET(MIMC_struct.do_lshell) ? outH2DBinsLShell : outH2DBinsILAT),$
                                     ABSMED=absFlux, $
                                     OUTFILE=medHistDatFile, $
                                     PLOT_I=tmp_i, $
                                     EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning) 


        END
        ELSE: BEGIN
           CASE 1 OF
              KEYWORD_SET(alfDB_plot_struct.EA_binning): BEGIN
                 H2DStr.data  = HIST2D__EQUAL_AREA_BINNING(mlts, $
                                                           ilats,$
                                                           (KEYWORD_SET(alfDB_plot_struct.logAvgPlot) OR KEYWORD_SET(tmpLogAvg) ? ALOG10(DOUBLE(inData)) : DOUBLE(inData)),$
                                                           MIN1=MIMC_struct.minM, $
MIN2=(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.minL : MIMC_struct.minI),$
                                                           MAX1=MIMC_struct.maxM, $
MAX2=(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.maxL : MIMC_struct.maxI),$
                                                           OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
              END
              ELSE: BEGIN
                 H2DStr.data  = HIST2D(mlts, $
                                       ilats,$
                                       (KEYWORD_SET(alfDB_plot_struct.logAvgPlot) OR KEYWORD_SET(tmpLogAvg) ? ALOG10(DOUBLE(inData)) : DOUBLE(inData)),$
                                       MIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.minLng : MIMC_struct.minM), $
                                       MIN2=(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.minL : MIMC_struct.minI),$
                                       MAX1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.maxLng : MIMC_struct.maxM), $
                                       MAX2=(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.maxL : MIMC_struct.maxI),$
                                       BINSIZE1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.binLng : MIMC_struct.binM), $
                                       BINSIZE2=(KEYWORD_SET(MIMC_struct.do_lshell) ? MIMC_struct.binL : MIMC_struct.binI),$
                                       OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
              END
           ENDCASE
           
           IF KEYWORD_SET(update_h2d_mask) THEN BEGIN
              UPDATE_H2D_MASK,H2DStr,outH2DBinsMLT,outH2DBinsILAT, $
                              H2DFluxN,dataName, $
                              h2dMask,hEv_nz_i, $
                              LUN=lun
           ENDIF

           IF KEYWORD_SET(div_fluxPlots_by_applicable_orbs) THEN BEGIN
              
              tempDenom               = orbContrib_H2DStr_for_division.data
              IF orbContrib_H2DStr_FOR_division.is_logged THEN BEGIN
                 tempDenom[hEv_nz_i]  = 10.^(tempDenom[hEv_nz_i])
              ENDIF

              H2DStr.data[hEv_nz_i]   = H2DStr.data[hEv_nz_i]/tempDenom[hEv_nz_i]

           ENDIF ELSE BEGIN
              H2DStr.data[hEv_nz_i]   = H2DStr.data[hEv_nz_i]/h2dFluxN[hEv_nz_i] 
           ENDELSE
           
           IF (KEYWORD_SET(alfDB_plot_struct.logAvgPlot) OR KEYWORD_SET(tmpLogAvg)) THEN BEGIN
              H2DStr.data[nz_inds] = 10.^(H2DStr.data[nz_inds])
           ENDIF
           
        END
     ENDCASE

     ;; nz_h2dDat_i = WHERE(ABS(H2DStr.data) GT 0)
     nz_h2dDat_i = hEv_nz_i
     IF KEYWORD_SET(multiply_fluxes_by_probOccurrence) THEN BEGIN
        PRINT,'Multiplying by probability of occurrence!'
        dataName += '_probOcc'
        H2DStr.data *= H2DProbOcc
     ENDIF

     IF TAG_EXIST(alfDB_plot_struct,'custom_integral') AND  $
        (KEYWORD_SET(grossRateMe) OR N_ELEMENTS(centersMLT) GT 0) THEN BEGIN

        tmpI           = alfDB_plot_struct.custom_integral.friend_i
        PRINT,"FRIEND_I: ",tmpI

        haveCustomMLT  = TAG_EXIST(alfDB_plot_struct.custom_integral,'mltRange')
        haveCustomILAT = TAG_EXIST(alfDB_plot_struct.custom_integral,'ilatRange')
        haveBoth       = haveCustomMLT AND haveCustomILAT
        IF haveCustomMLT THEN BEGIN
           tmpDim      = SIZE(alfDB_plot_struct.custom_integral.mltRange,/DIMENSIONS)
           nDim        = N_ELEMENTS(tmpDim)
           CASE nDim OF
              2: BEGIN
                 customMLTInds = GET_MLT_INDS(!NULL, $
                                              alfDB_plot_struct.custom_integral.mltRange[0,tmpI], $
                                              alfDB_plot_struct.custom_integral.mltRange[1,tmpI], $
                                              DIRECT_MLTS=centersMLT/15., $
                                              N_MLT=nCustomMLT)
              END
              3: BEGIN
                 customMLTInds = LIST()
                 nCustomMLT    = !NULL
                 FOR jj=0,tmpDim[2]-1 DO BEGIN
                    PRINT,"[minM,maxM]: " ,alfDB_plot_struct.custom_integral.mltRange[0,tmpI,jj],alfDB_plot_struct.custom_integral.mltRange[1,tmpI,jj]
                    customMLTInds.Add,GET_MLT_INDS(!NULL, $
                                                   alfDB_plot_struct.custom_integral.mltRange[0,tmpI,jj], $
                                                   alfDB_plot_struct.custom_integral.mltRange[1,tmpI,jj], $
                                                   DIRECT_MLTS=centersMLT/15., $
                                                   N_MLT=tmpNCustomMLT)
                    nCustomMLT = [nCustomMLT,tmpNCustomMLT]
                 ENDFOR
              END
           ENDCASE
        ENDIF

        IF haveCustomILAT THEN BEGIN
           tmpDim      = SIZE(alfDB_plot_struct.custom_integral.ilatRange,/DIMENSIONS)
           nDim        = N_ELEMENTS(tmpDim)
           CASE nDim OF
              2: BEGIN
                 customILATInds = GET_ILAT_INDS(!NULL, $
                                                alfDB_plot_struct.custom_integral.ilatRange[0,tmpI], $
                                                alfDB_plot_struct.custom_integral.ilatRange[1,tmpI], $
                                                MIMC_struct.hemi, $
                                                DIRECT_LATITUDES=centersILAT, $
                                                N_ILAT=nCustomILAT)
              END
              3: BEGIN
                 customILATInds = LIST()
                 nCustomILAT    = !NULL
                 FOR jj=0,tmpDim[2]-1 DO BEGIN
                    PRINT,"[minI,maxI]: " ,alfDB_plot_struct.custom_integral.ilatRange[0,tmpI,jj],alfDB_plot_struct.custom_integral.ilatRange[1,tmpI,jj]
                    customILATInds.Add,GET_ILAT_INDS(!NULL, $
                                                     alfDB_plot_struct.custom_integral.ilatRange[0,tmpI,jj], $
                                                     alfDB_plot_struct.custom_integral.ilatRange[1,tmpI,jj], $
                                                     MIMC_struct.hemi, $
                                                     DIRECT_LATITUDES=centersILAT, $
                                                     N_ILAT=tmpNCustomILAT)
                    nCustomILAT = [nCustomILAT,tmpNCustomILAT]
                 ENDFOR
              END
           ENDCASE
        ENDIF

        CASE 1 OF
           haveBoth: BEGIN
              CASE nDim OF
                 2: BEGIN
                    customIntegInds = CGSETINTERSECTION(TEMPORARY(customMLTInds), $
                                                        TEMPORARY(customILATInds), $
                                                        COUNT=nCustomInteg)
                 END
                 3: BEGIN
                    customIntegInds = LIST()
                    nCustomInteg    = !NULL
                    FOR jj=0,tmpDim[2]-1 DO BEGIN
                       customIntegInds.Add,CGSETINTERSECTION(customMLTInds[jj], $
                                                             customILATInds[jj], $
                                                             COUNT=tmpNCustomInteg)
                       nCustomInteg = [nCustomInteg,tmpNCustomInteg]
                    ENDFOR
                 END
              ENDCASE
           END
           haveCustomMLT: BEGIN
              CASE nDim OF
                 2: BEGIN
                    customIntegInds = TEMPORARY(customMLTInds)
                    nCustomInteg    = nCustomMLT
                 END
                 3: BEGIN
                    customIntegInds = customMLTInds
                    nCustomInteg    = nCustomMLT
                 END
              ENDCASE
           END
           haveCustomILAT: BEGIN
              CASE nDim OF
                 2: BEGIN
                    customIntegInds = TEMPORARY(customILATInds)
                    nCustomInteg    = nCustomILAT
                 END
                 3: BEGIN
                    customIntegInds = customILATInds
                    nCustomInteg    = nCustomILAT
                 END
              ENDCASE
           END
        ENDCASE

        PRINT,"N Custom Integ: ",nCustomInteg
        IF (WHERE(nCustomInteg LT 2))[0] NE -1 THEN STOP

     ENDIF

     IF KEYWORD_SET(grossRateMe) THEN BEGIN

        dayInds    = WHERE((centersMLT GE 6*15  AND centersMLT LT 18*15) AND ~h2dMask)
        nightInds  = WHERE((centersMLT GE 18*15 OR  centersMLT LT 6*15 ) AND ~h2dMask)

        ;;Only make changes to H2DStr.data if it has been explicitly requested
        CASE 1 OF
           KEYWORD_SET(do_grossRate_with_long_width): BEGIN
              H2DStr.data[nz_h2dDat_i] = H2DStr.data[nz_h2dDat_i]*h2dLongWidths[nz_h2dDat_i]*H2DAreaConvFac
              ;; H2DStr.data[hEv_nz_i] = H2DStr.data[hEv_nz_i]*h2dLongWidths[hEv_nz_i]*H2DAreaConvFac
           END
           KEYWORD_SET(do_grossRate_fluxQuantities): BEGIN
              ;;Note, areas in square kilometers
              H2DStr.data[nz_h2dDat_i] = H2DStr.data[nz_h2dDat_i]*h2dAreas[nz_h2dDat_i]*H2DAreaConvFac
              ;; H2DStr.data[hEv_nz_i] = H2DStr.data[hEv_nz_i]*h2dAreas[hEv_nz_i]*H2DAreaConvFac
           END
           ELSE:
        ENDCASE

        grossDat    = H2DStr.data
        grossDat[*] = 0.
        grossDat[nz_h2dDat_i] = H2DStr.data[nz_h2dDat_i]*h2dAreas[nz_h2dDat_i]*H2DAreaConvFac
        ;;Note, areas in square kilometers
        
        IF dayInds[0] NE -1 THEN BEGIN
           grossDay            = TOTAL(grossDat[dayInds])
        ENDIF ELSE grossDay    = 0

        IF nightInds[0] NE -1 THEN BEGIN
           grossNight          = TOTAL(grossDat[nightInds])
        ENDIF ELSE grossNight  = 0

        IF N_ELEMENTS(customIntegInds) GT 0 THEN BEGIN
           CASE N_ELEMENTS(nCustomInteg) OF
              1: BEGIN
                 grossCustom   = TOTAL(grossDat[customIntegInds])
              END
              ELSE: BEGIN
                 grossCustom   = !NULL
                 FOR jj=0,N_ELEMENTS(nCustomInteg)-1 DO BEGIN
                    grossCustom   = [grossCustom,TOTAL(grossDat[customIntegInds[jj]])]
                 ENDFOR
              END
           ENDCASE

        ENDIF ELSE grossCustom = 0
     ENDIF

  ENDELSE

  IF KEYWORD_SET(print_mandm) THEN BEGIN


     IF KEYWORD_SET(alfDB_plot_struct.medianPlot) OR ~(KEYWORD_SET(alfDB_plot_struct.logAvgPlot) OR KEYWORD_SET(tmpLogAvg)) THEN BEGIN
        fmt    = 'G10.4' 
        maxh2d = MAX(H2DStr.data[hEv_nz_i])
        minh2d = MIN(H2DStr.data[hEv_nz_i])
        medh2d = MEDIAN(H2DStr.data[hEv_nz_i])

        IF KEYWORD_SET(grossRateMe) THEN BEGIN
           grossMaxh2d                  = MAX(grossDat[hEv_nz_i])
           grossMinh2d                  = MIN(grossDat[hEv_nz_i])
           grossMedh2d                  = MEDIAN(grossDat[hEv_nz_i])
           dayMaxh2d                    = (dayInds[0] NE -1) ? MAX(grossDat[dayInds]) : 0.00
           dayMinh2d                    = (dayInds[0] NE -1) ? MIN(grossDat[dayInds]) : 0.00
           dayMedh2d                    = (dayInds[0] NE -1) ? MEDIAN(grossDat[dayInds]) : 0.00
           nightMaxh2d                  = (nightInds[0] NE -1) ? MAX(grossDat[nightInds]) : 0.00
           nightMinh2d                  = (nightInds[0] NE -1) ? MIN(grossDat[nightInds]) : 0.00
           nightMedh2d                  = (nightInds[0] NE -1) ? MEDIAN(grossDat[nightInds]) : 0.00
           H2DStr.grossIntegrals.day    = grossDay
           H2DStr.grossIntegrals.night  = grossNight
           H2DStr.grossIntegrals.total  = grossDay+grossNight
           H2DStr.grossIntegrals.custom = grossCustom
           H2DStr.gAreas                = h2dAreas ;Note, areas in square kilometers

           ;; IF N_ELEMENTS(grossCustom) GT 0 THEN BEGIN
           ;;    ;; tmpGross                  = H2DStr.grossIntegrals
           ;;    ;; STR_ELEMENT,tmpGross,'custom',grossCustom,/ADD_REPLACE
           ;;    ;; STR_ELEMENT,H2DStr,'grossIntegrals',tmpGross,/ADD_REPLACE
           ;;    H2DStr.grossIntegrals.custom = grossCustom
           ;; ENDIF
        ENDIF

     ENDIF ELSE BEGIN
        fmt    = 'F10.2'
        maxh2d = ALOG10(MAX(H2DStr.data[hEv_nz_i]))
        minh2d = ALOG10(MIN(H2DStr.data[hEv_nz_i]))
        medh2d = ALOG10(MEDIAN(H2DStr.data[hEv_nz_i]))
     ENDELSE
     PRINTF,lun,H2DStr.title
     ;; PRINTF,lun,FORMAT='("Max, min:",T20,F10.2,T35,F10.2)', $
     ;;        MAX(H2DStr.data[hEv_nz_i]), $
     ;;        MIN(H2DStr.data[hEv_nz_i])
     PRINTF,lun,FORMAT='("Max, min. med:",T20,' + fmt + ',T35,' + fmt + ',T50,' + fmt +')', $
            maxh2d, $
            minh2d, $
            medh2d            

     ;;KLUGE IT
     IF N_ELEMENTS(centersMLT) GT 0 THEN BEGIN
        dayInds    = WHERE(centersMLT GE 11*15 AND centersMLT LT 15*15 AND ~h2dMask)
        nightInds  = WHERE((centersMLT GE 21*15 OR centersMLT LT 1*15) AND ~h2dMask)

        dayMax   = MAX(H2DStr.data[dayInds],maxDayInd_ii)
        nightMax = MAX(H2DStr.data[nightInds],maxNightInd_ii)

        PRINT,"Day max (MLT,ILAT): ",dayMax, $
              '(' + STRCOMPRESS(centersMLT[dayInds[maxDayInd_ii]]/15.,/REMOVE_ALL), $
              ', ' + STRCOMPRESS(centersILAT[dayInds[maxDayInd_ii]]) + ')'
        PRINT,"Night max (MLT,ILAT): ",nightMax, $
              '(' + STRCOMPRESS(centersMLT[nightInds[maxNightInd_ii]]/15.,/REMOVE_ALL), $
              ', ' + STRCOMPRESS(centersILAT[nightInds[maxNightInd_ii]]) + ')'

        IF TAG_EXIST(alfDB_plot_struct,'custom_integral') THEN BEGIN
           
           CASE N_ELEMENTS(nCustomInteg) OF
              1: BEGIN
                 cMax   = MAX(H2DStr.data[customIntegInds],maxCustomInd_ii)
                 PRINT,"Custom max (MLT,ILAT): ",cMax, $
                       '(' + STRCOMPRESS(centersMLT[customIntegInds[maxCustomInd_ii]]/15.,/REMOVE_ALL), $
                       ', ' + STRCOMPRESS(centersILAT[customIntegInds[maxCustomInd_ii]]) + ')'
              END
              ELSE: BEGIN
                 FOR jj=0,N_ELEMENTS(nCustomInteg)-1 DO BEGIN
                    cMax   = MAX(H2DStr.data[customIntegInds[jj]],maxCustomInd_ii)
                    PRINT,"Custom max (MLT,ILAT): ",cMax, $
                          '(' + STRCOMPRESS(centersMLT[(customIntegInds[jj])[maxCustomInd_ii]]/15.,/REMOVE_ALL), $
                          ', ' + STRCOMPRESS(centersILAT[(customIntegInds[jj])[maxCustomInd_ii]]) + ')'
                 ENDFOR
              END
           ENDCASE

        ENDIF

     ENDIF

     IF KEYWORD_SET(grossRateMe) THEN BEGIN
        grossFmt      = 'G18.6'
        PRINTF,lun,FORMAT='("Gross dayside, nightside:",T30,'+ grossFmt + ',T50,' + grossFmt + ')', $
               grossDay,grossNight

        IF KEYWORD_SET(grossRate_info_file) THEN BEGIN
           PRINTF,grossLun,H2DStr.title
           PRINTF,grossLun,FORMAT='("Max, min. med.        :",T25,' + fmt + ',T40,' + fmt + ',T55,' + fmt +')', $
                  maxh2d, $
                  minh2d, $
                  medh2d
           PRINTF,grossLun,FORMAT='("Max, min. med. (Day)  :",T25,' + fmt + ',T40,' + fmt + ',T55,' + fmt +')', $
                  dayMaxh2d, $
                  dayMinh2d, $
                  dayMedh2d
           PRINTF,grossLun,FORMAT='("Max, min. med. (Night):",T25,' + fmt + ',T40,' + fmt + ',T55,' + fmt +')', $
                  nightMaxh2d, $
                  nightMinh2d, $
                  nightMedh2d
           PRINTF,grossLun,FORMAT='(%"GrossVals\n========\nDayside   : ",' + grossFmt + ',%"\nNightside : ",' + grossFmt + ',%"\nNet       : ",' + $
                  grossFmt + ')', $
                  grossDay, $
                  grossNight, $
                  (grossDay+grossNight)
           PRINTF,grossLun,''
        ENDIF
     ENDIF
  ENDIF


  ;;Do custom range for flux plot, if requested
  IF  KEYWORD_SET(plotRange) OR KEYWORD_SET(plotAutoscale) THEN BEGIN
     IF KEYWORD_SET(plotRange) AND KEYWORD_SET(plotAutoscale) THEN BEGIN
        PRINTF,lun,"Both plotRange and plotAutoscale are set! Assuming you'd rather have me autoscale..."
     ENDIF
     CASE 1 OF
        KEYWORD_SET(plotAutoscale): BEGIN
           H2DStr.lim   = [MIN(H2DStr.data[WHERE(H2DStr.data NE 0,/NULL)]), $
                           MAX(H2DStr.data[WHERE(H2DStr.data NE 0,/NULL)])]
        END
        KEYWORD_SET(plotRange): BEGIN
           H2DStr.lim   = plotRange
        END
     ENDCASE
  ENDIF ELSE BEGIN
     H2DStr.lim         = [MIN(H2DStr.data),MAX(H2DStr.data)]
  ENDELSE
  
  IF KEYWORD_SET(logFluxPlot) THEN BEGIN 
     IF KEYWORD_SET(do_plot_i_instead_of_histos) THEN BEGIN
        H2DStr.data[0,WHERE(H2DStr.data[0] NE 0,/NULL)] = ALOG10(H2DStr.data[WHERE(H2DStr.data[0] NE 0,/NULL)])
     ENDIF ELSE BEGIN
        H2DStr.data[WHERE(H2DStr.data NE 0,/NULL)]=ALOG10(H2DStr.data[WHERE(H2DStr.data NE 0,/NULL)]) 
        inData[WHERE(inData NE 0,/NULL)]=ALOG10(inData[WHERE(inData NE 0,/NULL)]) 
     ENDELSE
     H2DStr.lim        = ALOG10(H2DStr.lim)
     H2DStr.is_logged  = 1
  ENDIF

  dataRawPtr           = PTR_NEW(inData)
  H2DStr.name          = dataName
  out_h2dMask          = h2dMask

  IF for_e_or_i THEN BEGIN
     H2DStr.is_AlfDB   = 0B
     H2DStr.is_eSpecDB = BYTE(KEYWORD_SET(for_eSpec))
     H2DStr.is_ionDB   = BYTE(KEYWORD_SET(for_ion  ))
     H2DStr.mask       = h2dMask
     H2DStr.hasMask    = 1

     ;; IF KEYWORD_SET(alfDB_plot_struct.eSpec__Newell_2009_interp) THEN BEGIN
     ;;    dataName      += '-2009'
     ;; ENDIF

     IF KEYWORD_SET(alfDB_plot_struct.eSpec__use_2000km_file) THEN BEGIN
        dataName      += '-2kmFil'
     ENDIF
  ENDIF

  showMeThings = 0
  IF N_ELEMENTS(fluxPlotType) GT 0 AND KEYWORD_SET(showMeThings) THEN BEGIN
     ;; IF (STRUPCASE(fluxPlotType) EQ STRUPCASE("total_eflux_integ")) OR $
     ;;    (STRUPCASE(fluxPlotType) EQ STRUPCASE("Eflux_Losscone_Integ")) THEN BEGIN
     ;; IF (STRUPCASE(fluxPlotType) EQ STRUPCASE("integ")) OR $
     ;;    (STRUPCASE(fluxPlotType) EQ STRUPCASE("integ_up")) THEN BEGIN
     IF (STRUPCASE(fluxPlotType) EQ STRUPCASE("esa_current")) THEN BEGIN
        PRINT,fluxplottype,MEAN(H2DStr.data),MAX(H2DStr.data),MIN(H2DStr.data)
        HELP,H2DStr.grossintegrals

        PRINT,"H2DAreaConvFac : ",H2DAreaConvFac
        PRINT,"G Units        : ",H2DStr.gUnits
        PRINT,"GrossFac       : ",H2DStr.grossFac
        nCol = 2
        nRow = 3

        CGHISTOPLOT,H2DStr.data[WHERE(~h2dMask)],TITLE=fluxplottype

        PRINT,"Et sample: ",indata[LONG(LINDGEN(5)/4.*(N_ELEMENTS(tmp_i)-1))]
        STOP
     ENDIF
  ENDIF

  IF N_ELEMENTS(removed_ii) NE 0 THEN BEGIN 
     pref = "!!!Removed_ii has " + STRCOMPRESS(N_ELEMENTS(WHERE(removed_ii NE -1)),/REMOVE_ALL) + " inds for " + dataName + "!"
     IF removed_ii[0] NE -1 THEN BEGIN 
        out_removed_ii = TEMPORARY(removed_ii)
     ENDIF ELSE BEGIN 
        out_removed_ii = !NULL 
     ENDELSE 
  ENDIF ELSE BEGIN 
     out_removed_ii = !NULL 
  ENDELSE

  H2DAreaConvFac = !NULL

END
