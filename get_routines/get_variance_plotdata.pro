;;11/29/16
PRO GET_VARIANCE_PLOTDATA,dbStruct,maxInds, $
                          FOR_MAXIMUS=for_maximus, $
                          FOR_ESPEC_DBS=for_eSpec_DBs, $
                          IN_INDS=in_inds, $
                          IN_MLTS=in_mlts, $
                          IN_ILATS=in_ilats, $
                          FASTLOCINDS=fastLocInds, $
                          H2DSTRARR=H2DStrArr, $
                          DATANAMEARR=dataNameArr, $
                          DATARAWPTRARR=dataRawPtrArr, $
                          REMOVED_II_LISTARR=removed_ii_listArr, $
                          DO_VAR_PLOTS=doing_var_plots, $
                          VAR__PLOTRANGE=var__plotRange, $
                          VAR__REL_TO_MEAN_VARIANCE=var__rel_to_mean_variance, $
                          VAR__DO_STDDEV_INSTEAD=var__do_stddev_instead, $
                          VAR__AUTOSCALE=var__autoscale, $
                          VARPLOTH2DINDS=varPlotH2DInds, $
                          ;; H2D_THIST_I=H2D_tHist_i, $
                          VARPLOTRAWINDS=varPlotRawInds, $
                          DBTIMES=DBTimes, $
                          THISTDENOMINATOR=tHistDenominator, $
                          DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                          GROSSRATE__H2D_AREAS=h2dAreas, $
                          DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
                          GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
                          GROSSCONVFACTOR=grossConvFactor, $
                          VAR_H2DSTRARR=var_H2DStrArr, $
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
                          OUTH2D_LISTS_WITH_INDS=outH2D_lists_with_inds,$
                          ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                          IMF_STRUCT=IMF_struct, $
                          MIMC_STRUCT=MIMC_struct, $
                          ALL_LOGPLOTS=all_logPlots, $
                          ESPEC__NO_MAXIMUS=no_maximus, $
                          TMPLT_H2DSTR=tmplt_h2dStr, $
                          H2D_NONZERO_NEV_I=hEv_nz_i, $
                          LUN=lun
  
  COMPILE_OPT IDL2
  @common__newell_espec.pro

  IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
     @common__fastloc_espec_vars.pro
  ENDIF ELSE BEGIN
     @common__fastloc_vars.pro
  ENDELSE

  ;;some temp vars
  var_H2DStrArr    = !NULL
  var_dataNameArr  = !NULL

  H2D_ii__alfDB    = WHERE(H2DStrArr[varploth2dinds].is_alfDB    ,nAlfDB  )
  H2D_ii__eSpec    = WHERE(H2DStrArr[varploth2dinds].is_eSpecDB  ,nESpec  )
  H2D_ii__fastLoc  = WHERE(H2DStrArr[varploth2dinds].is_fastLocDB,nFastLoc)

  nLoops           = 0
  loopType         = !NULL
  ;; nThisLoop        = !NULL
  IF nAlfDB GT 0 THEN BEGIN
     ;; nThisLoop    = [nThisLoop,nAlfDB]
     loopType     = [loopType,0]
     nLoops++
  ENDIF

  IF nESpec GT 0 THEN BEGIN
     ;; nThisLoop    = [nThisLoop,nESpec]
     loopType     = [loopType,1]
     nLoops++
  ENDIF

  IF nFastLoc GT 0 THEN BEGIN
     ;; nThisLoop    = [nThisLoop,nESpec]
     loopType     = [loopType,2]
     nLoops++
  ENDIF

  ;; FOR kj=0,nLoops-1 DO BEGIN
  FOR k=0,nLoops-1 DO BEGIN

     ;;Maximus or eSpec?
     CASE loopType[k] OF
        0: BEGIN
           dbInds       = maxInds
           tmpTimes     = DBTimes
           tmpVarH2D_i  = varPlotH2DInds[H2D_ii__alfDB]
           tmpVarRaw_i  = varPlotRawInds[H2D_ii__alfDB]
           send_DB      = 1
           nVarInds     = nAlfDB
        END
        1: BEGIN
           dbInds       = in_inds
           tmpVarH2D_i  = varPlotH2DInds[H2D_ii__eSpec]
           tmpVarRaw_i  = varPlotRawInds[H2D_ii__eSpec]
           send_DB      = 0
           nVarInds     = nESpec
        END
        2: BEGIN
           dbInds       = fastLocInds
           tmpTimes     = (KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__times : FASTLOC__times)
           tmpVarH2D_i  = varPlotH2DInds[H2D_ii__fastLoc]
           tmpVarRaw_i  = varPlotRawInds[H2D_ii__fastLoc]
           send_DB      = 0
           nVarInds     = nFastLoc
        END
     ENDCASE

     IF (loopType[k] EQ 1) OR (loopType[k] EQ 2) THEN BEGIN

        haveStuff       = 1

        CASE loopType[k] OF
           1: BEGIN
              tmpInds   = in_inds
              tmpMLTs   = KEYWORD_SET(MIMC_struct.use_Lng) ? NEWELL__eSpec.lng : NEWELL__eSpec.mlt 
              tmpILATs  = NEWELL__eSpec.ilat
           END
           2: BEGIN
              tmpInds   = fastLocInds
              ;; tmpMLTs   = (KEYWORD_SET(for_eSpec_DBs) ? FL_E__fastLoc : FL__fastLoc).mlt [fastLocInds]
              ;; tmpILATs  = (KEYWORD_SET(for_eSpec_DBs) ? FL_E__fastLoc : FL__fastLoc).ilat[fastLocInds]
              CASE 1 OF
                 KEYWORD_SET(MIMC_struct.use_Lng): BEGIN
                    tmpMLTs = (KEYWORD_SET(for_eSpec_DBs) ? FL_E__fastLoc : FL__fastLoc).lng
                 END
                 ELSE: BEGIN
                    tmpMLTs = (KEYWORD_SET(for_eSpec_DBs) ? FL_E__fastLoc : FL__fastLoc).mlt
                 END
              ENDCASE
              tmpILATs  = (KEYWORD_SET(for_eSpec_DBs) ? FL_E__fastLoc : FL__fastLoc).ilat
           END
        ENDCASE
     ENDIF ELSE BEGIN

        haveStuff = 0
        tmpInds   = !NULL
        tmpMLTs   = !NULL
        tmpILATS  = !NULL

     ENDELSE

     MAKE_H2D_WITH_LIST_OF_INDS_FOR_EACH_BIN, $
        (send_DB ? dbStruct : !NULL), $
        (send_DB ? dbInds   : !NULL), $
        OUTH2D_LISTS_WITH_INDS=outH2D_lists_with_inds,$
        IN_INDS=( send_DB ? !NULL : tmpInds), $
        IN_MLTS=( send_DB ? !NULL : (haveStuff ? tmpMLTs  : in_mlts )), $
        IN_ILATS=(send_DB ? !NULL : (haveStuff ? tmpILATs : in_ilats)), $
        ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
        IMF_STRUCT=IMF_struct, $
        MIMC_STRUCT=MIMC_struct, $
        /FILL_WITH_INDICES_INTO_PLOT_I, $
        /RESET_H2D_LISTS_WITH_INDS, $
        LUN=lun

     FOR i=0,nVarInds-1 DO BEGIN
        
        dbStruct_obsArr                   = *dataRawPtrArr[tmpVarRaw_i[i]]
        IF N_ELEMENTS((removed_ii_listArr[tmpVarRaw_i[i]])[0]) GT 0 THEN BEGIN
           CASE loopType[k] OF
              0: BEGIN
                 ;; dont_use_these_inds      = (removed_ii_listArr[tmpVarRaw_i[i]])[0]
                 dont_use_these_inds      = (removed_ii_listArr[tmpVarRaw_i[i]])[0]
              END
              1: BEGIN
                 ;; dont_use_these_inds      = CGSETINTERSECTION(in_inds,(removed_ii_listArr[tmpVarRaw_i[i]])[0],COUNT=dontDoIt)
                 ;; dont_use_these_inds      = CGSETINTERSECTION(in_inds,(removed_ii_listArr[i])[0],COUNT=dontDoIt)
                 ;; dont_use_these_inds      = CGSETINTERSECTION(in_inds,(removed_ii_listArr[tmpVarRaw_i[i]])[0],COUNT=dontDoIt)
                 dont_use_these_inds      = (removed_ii_listArr[tmpVarRaw_i[i]])[0]
              END
              2: BEGIN
                 dont_use_these_inds      = CGSETINTERSECTION( $
                                            tmpInds, $
                                            (removed_ii_listArr[tmpVarRaw_i[i]])[0], $
                                            COUNT=dontDoIt)
              END
           ENDCASE

           PRINT,"I got " + STRCOMPRESS(N_ELEMENTS(dont_use_these_inds)) + " bad inds for " + dataNameArr[tmpVarH2D_i[i]]
        ENDIF ELSE BEGIN 
           dont_use_these_inds            = !NULL
        ENDELSE

        IF KEYWORD_SET(grossConvFactorArr) THEN grossConvFactor = grossConvFactorArr[tmpVarRaw_i[i]]

        MAKE_H2D_WITH_LIST_OF_OBS_AND_OBS_STATISTICS,dbStruct_obsArr, $
           FOR_MAXIMUS=loopType[k] EQ 0, $
           FOR_ESPEC_DBS=loopType[k] EQ 1, $
           FOR_FASTLOC_DBS=loopType[k] EQ 2, $
           DBTIMES=tmpTimes, $
           IMF_STRUCT=IMF_struct, $
           ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
           MIMC_STRUCT=MIMC_struct, $
           DONT_USE_THESE_INDS=dont_use_these_inds, $
           /DO_LISTS_WITH_STATS, $
           DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
           GROSSRATE__H2D_AREAS=h2dAreas, $
           DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
           GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
           GROSSCONVFACTOR=grossConvFactor, $
           DO_TIMEAVG_FLUXQUANTITIES=alfDB_plot_struct.do_timeAvg_fluxQuantities AND H2DStrArr[tmpVarH2D_i[i]].do_timeAvg, $
           ;; THISTDENOMINATOR=(N_ELEMENTS(H2D_tHist_i) GT 0 ? H2DStrArr[H2D_tHist_i].data : !NULL), $
           THISTDENOMINATOR=tHistDenominator, $
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
           DATANAME=dataNameArr[tmpVarH2D_i[i]], $
           DATATITLE=H2DStrArr[tmpVarH2D_i[i]].title, $
           DBSTRUCT=(send_DB ? dbStruct : !NULL), $
           DBSTR_INDS=(send_DB ? dbInds : tmpInds), $
           LUN=lun

        IF doing_var_plots THEN BEGIN       
           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
           ;;Now get it all set up
           h2dStrTemp                     = H2DStrArr[tmpVarH2D_i[i]]
           IF KEYWORD_SET(var__do_stddev_instead) THEN BEGIN
              dataNameTemp                = dataNameArr[tmpVarH2D_i[i]] + '_stddev'
           ENDIF ELSE BEGIN
              dataNameTemp                = dataNameArr[tmpVarH2D_i[i]] + '_var'
           ENDELSE
           h2dStrTemp.data                = REFORM(outH2D_stats[1,*,*])

           ;;;;;;;;;;;;;;;;;;;; 
           ;;set up lims--2 std devs on either side
           notMasked                      = WHERE(H2DStrArr[KEYWORD_SET(nPlots)].data LT 250.)
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
              h2dStrTemp.data             = h2dStrTemp.data - tempStats[0]
              IF ~KEYWORD_SET(var__plotRange) THEN BEGIN
                 h2dStrTemp.lim                 = [-2.*tempStats[1], $
                                                   2.*tempStats[1]]
              ENDIF

              h2dStrTemp.title        += " (Var. rel.to meanVar)"

           ENDIF ELSE BEGIN
              IF KEYWORD_SET(var__do_stddev_instead) THEN BEGIN
                 h2dStrTemp.data          = SQRT(h2dStrTemp.data)
                 IF ~KEYWORD_SET(var__plotRange) THEN BEGIN
                    h2dStrTemp.lim        = [SQRT(tempStats[0])-2.*SQRT(tempStats[1]), $
                                             SQRT(tempStats[0])+2.*SQRT(tempStats[1])]
                 ENDIF
                 h2dStrTemp.title        += " (Stddev.)"
              ENDIF ELSE BEGIN
                 IF ~KEYWORD_SET(var__plotRange) THEN BEGIN
                    h2dStrTemp.lim        = [MIN(h2dStrTemp.data[notMasked]),MAX(h2dStrTemp.data[notMasked])]
                 ENDIF
                 h2dStrTemp.title        += " (Var.)"
              ENDELSE
           ENDELSE

           ;;Show us
           IF KEYWORD_SET(print_mandm) THEN BEGIN
              IF KEYWORD_SET(alfDB_plot_struct.medianPlot) OR ~KEYWORD_SET(alfDB_plot_struct.logAvgPlot) THEN BEGIN
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
              PRINTF,lun, $
                     FORMAT='("Max, min. med:",T20,' + $
                     fmt + ',T35,' + $
                     fmt + ',T50,' + $
                     fmt +')', $
                     maxh2d, $
                     minh2d, $
                     medh2d            
           ENDIF
           h2dStrTemp.name  = dataNameTemp

           var_H2DStrArr    = [var_H2DStrArr,h2dStrTemp]
           var_dataNameArr  = [var_dataNameArr,dataNameTemp]
        ENDIF
     ENDFOR

  ENDFOR
  ;; ENDFOR



  ;; MAKE_H2D_WITH_LIST_OF_INDS_FOR_EACH_BIN, $
  ;;    dbStruct,dbInds, $
  ;;    OUTH2D_LISTS_WITH_INDS=outH2D_lists_with_inds,$
  ;;    MINMLT=minM, $
  ;;    MAXMLT=maxM, $
  ;;    BINMLT=binM, $
  ;;    SHIFTMLT=shiftM, $
  ;;    MINILAT=minI, $
  ;;    MAXILAT=maxI, $
  ;;    BINILAT=binI, $
  ;;    BOTH_HEMIS=KEYWORD_SET(tmplt_h2dStr.both_hemis), $
  ;;    DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
  ;;    /FILL_WITH_INDICES_INTO_PLOT_I, $
  ;;    /RESET_H2D_LISTS_WITH_INDS, $
  ;;    LUN=lun

  IF doing_var_plots THEN BEGIN       

     ;;Now update dat!!!
     CASE 1 OF
        KEYWORD_SET(only_variance_plots): BEGIN
           dataNameArr  = [dataNameArr[KEYWORD_SET(nPlots)],var_dataNameArr]
           H2DStrArr    = [H2DStrArr[KEYWORD_SET(nPlots)],var_H2DStrArr]
           nPlots       = 0
        END
        KEYWORD_SET(add_variance_plots): BEGIN
           dataNameArr  = [dataNameArr,var_dataNameArr]
           H2DStrArr    = [H2DStrArr,var_H2DStrArr]
        END
     ENDCASE
  ENDIF

END
