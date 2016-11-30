;;11/29/16
PRO GET_VARIANCE_PLOTDATA,dbStruct,maxInds, $
                          FOR_MAXIMUS=for_maximus, $
                          FOR_ESPEC_DBS=for_eSpec_DBs, $
                          IN_INDS=in_inds, $
                          IN_MLTS=in_mlts, $
                          IN_ILATS=in_ilats, $
                          H2DSTRARR=h2dStrArr, $
                          DATANAMEARR=dataNameArr, $
                          DATARAWPTRARR=dataRawPtrArr, $
                          REMOVED_II_LISTARR=removed_ii_listArr, $
                          DO_VAR_PLOTS=doing_var_plots, $
                          VAR__PLOTRANGE=var__plotRange, $
                          VAR__REL_TO_MEAN_VARIANCE=var__rel_to_mean_variance, $
                          VAR__DO_STDDEV_INSTEAD=var__do_stddev_instead, $
                          VAR__AUTOSCALE=var__autoscale, $
                          VARPLOTH2DINDS=varPlotH2DInds, $
                          DBTIMES=DBTimes, $
                          DONT_USE_THESE_INDS=dont_use_these_inds, $
                          DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                          GROSSRATE__H2D_AREAS=h2dAreas, $
                          DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
                          GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
                          GROSSCONVFACTOR=grossConvFactor, $
                          VAR_H2DSTRARR=var_h2dStrArr, $
                          VAR_DATANAMEARR=var_datNameArr, $
                          OUTH2D_LISTS_WITH_OBS=outH2D_lists_with_obs,$
                          OUTH2D_STATS=outH2D_stats, $
                          OUTFILESTRING=paramStr, $
                          OUTFILEPREFIX=paramStrPrefix, $
                          OUTFILESUFFIX=paramStrSuffix, $
                          OUTDIR=txtOutputDir, $
                          OUTPUT_TEXTFILE=write_obsArr_textFile, $
                          OUTPUT__INC_IMF=write_obsArr__inc_IMF, $
                          OUTPUT__ORB_AVG_OBS=write_obsArr__orb_avg_obs, $
                          VARPLOTRAWINDS=varPlotRawInds, $
                          OUTH2D_LISTS_WITH_INDS=outH2D_lists_with_inds,$
                          MINMLT=minM, $
                          MAXMLT=maxM, $
                          BINMLT=binM, $
                          SHIFTMLT=shiftM, $
                          MINILAT=minI, $
                          MAXILAT=maxI, $
                          BINILAT=binI, $
                          MEDIANPLOT=medianPlot, $
                          LOGAVGPLOT=logAvgPlot, $
                          ALL_LOGPLOTS=all_logPlots, $
                          NONALFVEN__NO_MAXIMUS=no_maximus, $
                          TMPLT_H2DSTR=tmplt_h2dStr, $
                          H2D_NONZERO_NEV_I=hEv_nz_i, $
                          DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                          LUN=lun
  
  COMPILE_OPT IDL2

  ;;some temp vars
  var_h2dStrArr                  = !NULL
  var_dataNameArr                = !NULL

  CASE 1 OF
     KEYWORD_SET(for_maximus): BEGIN
        indices                  = WHERE(h2dStrArr[varploth2dinds].is_alfDB,nInd)
     END
     KEYWORD_SET(for_eSpec_DBs): BEGIN
        indices                  = WHERE(~h2dStrArr[varploth2dinds].is_alfDB,nInd)
     END
     ELSE: BEGIN
        nInd                     = N_ELEMENTS(h2dStrArr)
        indices                  = INDGEN(nInd)
     END
  ENDCASE

  IF KEYWORD_SET(for_maximus) THEN BEGIN
     dbInds = maxInds
     MAKE_H2D_WITH_LIST_OF_INDS_FOR_EACH_BIN,dbStruct,dbInds, $
                                             OUTH2D_LISTS_WITH_INDS=outH2D_lists_with_inds,$
                                             MINMLT=minM, $
                                             MAXMLT=maxM, $
                                             BINMLT=binM, $
                                             SHIFTMLT=shiftM, $
                                             MINILAT=minI, $
                                             MAXILAT=maxI, $
                                             BINILAT=binI, $
                                             BOTH_HEMIS=KEYWORD_SET(tmplt_h2dStr.both_hemis), $
                                             DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                                             ;; OUTFILEPREFIX=outFilePrefix, $
                                             ;; OUTFILESUFFIX=outFileSuffix, $
                                             ;; OUTDIR=txtOutputDir, $
                                             ;; OUTPUT_TEXTFILE=output_textFile, $
                                             /FILL_WITH_INDICES_INTO_PLOT_I, $
                                             ;; RESET_H2D_LISTS_WITH_INDS=reset_h2d_lists_with_inds, $
                                             /RESET_H2D_LISTS_WITH_INDS, $
                                             LUN=lun
  ENDIF ELSE BEGIN
     dbInds = in_inds
     MAKE_H2D_WITH_LIST_OF_INDS_FOR_EACH_BIN,dbStruct,dbInds, $
                                             OUTH2D_LISTS_WITH_INDS=outH2D_lists_with_inds,$
                                             IN_INDS=in_inds, $
                                             IN_MLTS=in_mlts, $
                                             IN_ILATS=in_ilats, $
                                             MINMLT=minM, $
                                             MAXMLT=maxM, $
                                             BINMLT=binM, $
                                             SHIFTMLT=shiftM, $
                                             MINILAT=minI, $
                                             MAXILAT=maxI, $
                                             BINILAT=binI, $
                                             BOTH_HEMIS=KEYWORD_SET(tmplt_h2dStr.both_hemis), $
                                             DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                                             ;; OUTFILEPREFIX=outFilePrefix, $
                                             ;; OUTFILESUFFIX=outFileSuffix, $
                                             ;; OUTDIR=txtOutputDir, $
                                             ;; OUTPUT_TEXTFILE=output_textFile, $
                                             /FILL_WITH_INDICES_INTO_PLOT_I, $
                                             ;; RESET_H2D_LISTS_WITH_INDS=reset_h2d_lists_with_inds, $
                                             /RESET_H2D_LISTS_WITH_INDS, $
                                             LUN=lun


  ENDELSE

  

  FOR i=0,N_ELEMENTS(varPlotRawInds)-1 DO BEGIN
     
     dbStruct_obsArr               = *dataRawPtrArr[varPlotRawInds[i]]
     IF N_ELEMENTS((removed_ii_listArr[i])[0]) GT 0 THEN BEGIN
        dont_use_these_inds        = (removed_ii_listArr[i])[0]
     ENDIF ELSE BEGIN 
        dont_use_these_inds        = !NULL
     ENDELSE

     IF KEYWORD_SET(grossConvFactorArr) THEN grossConvFactor = grossConvFactorArr[i]

     MAKE_H2D_WITH_LIST_OF_OBS_AND_OBS_STATISTICS,dbStruct_obsArr, $
        FOR_MAXIMUS=for_maximus, $
        FOR_ESPEC_DBS=for_eSpec_DBs, $
        DBTIMES=DBTimes, $
        DONT_USE_THESE_INDS=dont_use_these_inds, $
        /DO_LISTS_WITH_STATS, $
        DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
        GROSSRATE__H2D_AREAS=h2dAreas, $
        DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
        GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
        GROSSCONVFACTOR=grossConvFactor, $
        BOTH_HEMIS=KEYWORD_SET(tmplt_h2dStr.both_hemis), $
        OUTH2D_LISTS_WITH_OBS=outH2D_lists_with_obs,$
        OUTH2D_STATS=outH2D_stats, $
        OUTFILESTRING=paramStr, $
        OUTFILEPREFIX=paramStrPrefix, $
        OUTFILESUFFIX=paramStrSuffix, $
        OUTDIR=txtOutputDir, $
        OUTPUT_TEXTFILE=write_obsArr_textFile, $
        OUTPUT__INC_IMF=write_obsArr__inc_IMF, $
        OUTPUT__ORB_AVG_OBS=write_obsArr__orb_avg_obs, $
        DATANAME=dataNameArr[varPlotH2DInds[i]], $
        DATATITLE=h2dStrArr[varPlotH2DInds[i]].title, $
        DBSTRUCT=dbStruct, $
        DBSTR_INDS=dbInds, $
        LUN=lun

     IF doing_var_plots THEN BEGIN       
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        ;;Now get it all set up
        h2dStrTemp                     = h2dStrArr[varPlotH2DInds[i]]
        IF KEYWORD_SET(var__do_stddev_instead) THEN BEGIN
           dataNameTemp                = dataNameArr[varPlotH2DInds[i]] + '_stddev'
        ENDIF ELSE BEGIN
           dataNameTemp                = dataNameArr[varPlotH2DInds[i]] + '_var'
        ENDELSE
        h2dStrTemp.data                = REFORM(outH2D_stats[1,*,*])

           ;;;;;;;;;;;;;;;;;;;; 
        ;;set up lims--2 std devs on either side
        ;; tempMed                        = MEDIAN(h2dStrTemp.data)
        notMasked                      = WHERE(h2dStrArr[KEYWORD_SET(nPlots)].data LT 250.)
        tempStats                      = MOMENT(h2dStrTemp.data[notMasked])
        h2dStrTemp.do_posNeg_cb        = 1
        h2dStrTemp.force_oobLow        = 0
        h2dStrTemp.force_oobHigh       = 0

        ;;handle ranges
        IF KEYWORD_SET(var__plotRange) OR KEYWORD_SET(var__autoscale) THEN BEGIN
           IF KEYWORD_SET(var__plotRange) AND KEYWORD_SET(var__autoscale) THEN BEGIN
              PRINTF,lun,"Both var__plotRange and var__autoscale are set! Assuming you'd rather have me autoscale..."
           ENDIF
           CASE 1 OF
              KEYWORD_SET(var__autoscale): BEGIN
                 h2dStrTemp.lim        = [MIN(h2dStrTemp.data[hEv_nz_i]), $
                                          MAX(h2dStrTemp.data[hEv_nz_i])]
              END
              KEYWORD_SET(var__plotRange): BEGIN
                 IF N_ELEMENTS(SIZE(var__plotRange,/DIMENSIONS)) GT 1 THEN BEGIN
                    h2dStrTemp.lim     = var__plotRange[*,i]
                 ENDIF ELSE BEGIN
                    h2dStrTemp.lim     = var__plotRange
                 ENDELSE
              END
           ENDCASE
        ENDIF
        
        IF KEYWORD_SET(var__rel_to_mean_variance) THEN BEGIN
           ;; IF KEYWORD_SET(var__do_stddev_instead) THEN BEGIN
           ;;    h2dStrTemp.data          = SQRT(h2dStrTemp.data) - SQRT(tempStats[0])
           ;;    h2dStrTemp.lim           = [-2.*SQRT(tempStats[1]), $
           ;;                                2.*SQRT(tempStats[1])]
           ;;    h2dStrTemp.title        += " (Stddev. rel.to mean stddev.)"
           ;; ENDIF ELSE BEGIN
           h2dStrTemp.data             = h2dStrTemp.data - tempStats[0]
           IF ~KEYWORD_SET(var__plotRange) THEN BEGIN
              h2dStrTemp.lim                 = [-2.*tempStats[1], $
                                                2.*tempStats[1]]
           ENDIF
           ;; h2dStrTemp.lim           = h2dStrTemp.lim - tempStats[0]
           h2dStrTemp.title        += " (Var. rel.to meanVar)"
           ;; ENDELSE
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(var__do_stddev_instead) THEN BEGIN
              h2dStrTemp.data          = SQRT(h2dStrTemp.data)
              IF ~KEYWORD_SET(var__plotRange) THEN BEGIN
                 h2dStrTemp.lim        = [SQRT(tempStats[0])-2.*SQRT(tempStats[1]), $
                                          SQRT(tempStats[0])+2.*SQRT(tempStats[1])]
              ENDIF
              h2dStrTemp.title        += " (Stddev.)"
           ENDIF ELSE BEGIN
              ;; h2dStrTemp.lim                 = [tempStats[0]-2.*tempStats[1], $
              ;;                                   tempStats[0]+2.*tempStats[1]]
              IF ~KEYWORD_SET(var__plotRange) THEN BEGIN
                 h2dStrTemp.lim        = [MIN(h2dStrTemp.data[notMasked]),MAX(h2dStrTemp.data[notMasked])]
              ENDIF
              h2dStrTemp.title        += " (Var.)"
           ENDELSE
        ENDELSE

        ;;Show us
        IF KEYWORD_SET(print_mandm) THEN BEGIN
           IF KEYWORD_SET(medianPlot) OR ~KEYWORD_SET(logAvgPlot) THEN BEGIN
              fmt    = 'G10.4' 
              maxh2d = MAX(h2dStrTemp.data[hEv_nz_i])
              minh2d = MIN(h2dStrTemp.data[hEv_nz_i])
              medh2d = MEDIAN(h2dStrTemp.data[hEv_nz_i])
           ENDIF ELSE BEGIN
              fmt    = 'F10.2'
              maxh2d = ALOG10(MAX(h2dStrTemp.data[hEv_nz_i]))
              minh2d = ALOG10(MIN(h2dStrTemp.data[hEv_nz_i]))
              medh2d = ALOG10(MEDIAN(h2dStrTemp.data[hEv_nz_i]))
           ENDELSE
           PRINTF,lun,h2dStrTemp.title
           ;; PRINTF,lun,FORMAT='("Max, min:",T20,F10.2,T35,F10.2)', $
           ;;        MAX(h2dStrTemp.data[hEv_nz_i]), $
           ;;        MIN(h2dStrTemp.data[hEv_nz_i])
           PRINTF,lun,FORMAT='("Max, min. med:",T20,' + fmt + ',T35,' + fmt + ',T50,' + fmt +')', $
                  maxh2d, $
                  minh2d, $
                  medh2d            
        ENDIF
        h2dStrTemp.name                = dataNameTemp

        var_h2dStrArr                  = [var_h2dStrArr,h2dStrTemp]
        var_dataNameArr                = [var_dataNameArr,dataNameTemp]
     ENDIF
  ENDFOR
  
  IF doing_var_plots THEN BEGIN       

     ;;Now update dat!!!
     CASE 1 OF
        KEYWORD_SET(only_variance_plots): BEGIN
           dataNameArr                 = [dataNameArr[KEYWORD_SET(nPlots)],var_dataNameArr]
           h2dStrArr                   = [h2dStrArr[KEYWORD_SET(nPlots)],var_h2dStrArr]
           nPlots                      = 0
        END
        KEYWORD_SET(add_variance_plots): BEGIN
           dataNameArr                 = [dataNameArr,var_dataNameArr]
           h2dStrArr                   = [h2dStrArr,var_h2dStrArr]
        END
     ENDCASE
  ENDIF



END
