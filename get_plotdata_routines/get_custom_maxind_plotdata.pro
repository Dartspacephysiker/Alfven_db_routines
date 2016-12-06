;2016/04/20 For customizing

PRO GET_CUSTOM_MAXIND_PLOTDATA,maximus,plot_i,custom_maxInd, $
                               ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                               IMF_STRUCT=IMF_struct, $
                               MIMC_STRUCT=MIMC_struct, $
                               CUSTOM_DATANAME=custom_dataname, $
                               CUSTOM_TITLE=custom_title, $
                               OUTH2DBINSMLT=outH2DBinsMLT, $
                               OUTH2DBINSILAT=outH2DBinsILAT, $
                               OUTH2DBINSLSHELL=outH2DBinsLShell, $
                               PLOTRANGE=plotRange, $
                               PLOTAUTOSCALE=plotAutoscale, $
                               NOPOSFLUX=noPosFlux, $
                               NONEGFLUX=noNegFlux, $
                               ABSFLUX=absFlux, $
                               OUT_REMOVED_II=out_removed_ii, $
                               LOGPLOT=logPlot, $
                               DIVIDE_BY_WIDTH_X=divide_by_width_x, $
                               MULTIPLY_BY_WIDTH_X=multiply_by_width_x, $
                               MULTIPLY_FLUXES_BY_PROBOCCURRENCE=multiply_fluxes_by_probOccurrence, $
                               H2DPROBOCC=H2DProbOcc, $
                               DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                               DO_LOGAVG_THE_TIMEAVG=do_logavg_the_timeAvg, $
                               DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
                               CUSTOM_GROSSRATE_CONVFACTOR=custom_grossRate_convFactor, $
                               GROSSRATE__H2D_AREAS=h2dAreas, $
                               DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
                               GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
                               GROSSRATE__CENTERS_MLT=centersMLT, $
                               GROSSRATE__CENTERS_ILAT=centersILAT, $
                               GROSSCONVFACTOR=grossConvFactor, $
                               WRITE_GROSSRATE_INFO_TO_THIS_FILE=grossRate_info_file, $
                               GROSSLUN=grossLun, $
                               SHOW_INTEGRALS=show_integrals, $
                               THISTDENOMINATOR=tHistDenominator, $
                               H2DSTR=h2dStr, $
                               TMPLT_H2DSTR=tmplt_h2dStr, $
                               H2D_NONZERO_NEV_I=hEv_nz_i, $
                               H2DFLUXN=h2dFluxN, $
                               H2DMASK=h2dMask, $
                               OUT_H2DMASK=out_h2dMask, $
                               DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                               MEDHISTOUTDATA=medHistOutData, $
                               MEDHISTOUTTXT=medHistOutTxt, $
                               MEDHISTDATADIR=medHistDataDir, $
                               DIV_FLUXPLOTS_BY_APPLICABLE_ORBS=div_fluxPlots_by_applicable_orbs, $
                               ORBCONTRIB_H2DSTR_FOR_DIVISION=orbContrib_h2dStr_for_division, $
                               DO_PLOT_I_INSTEAD_OF_HISTOS=do_plot_i_instead_of_histos, $
                               PRINT_MAX_AND_MIN=print_mandm, $
                               FANCY_PLOTNAMES=fancy_plotNames, $
                               LUN=lun
  
  COMPILE_OPT idl2

  ;;The loaded defaults take advantage of KEYWORD_SET(fancy_plotNames)
  @fluxplot_defaults.pro

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1
  IF N_ELEMENTS(print_mandm) EQ 0 THEN print_mandm = 1

  ;;Don't mod everyone's plot indices
  tmp_i = plot_i

  ;; Flux plot safety
  IF KEYWORD_SET(logPlot) AND NOT KEYWORD_SET(absFlux) AND NOT KEYWORD_SET(noNegFlux) AND NOT KEYWORD_SET(noPosFlux) THEN BEGIN 
     PRINTF,lun,"Warning!: You're trying to do logplots of flux but you don't have 'absFlux', 'noNegFlux', or 'noPosFlux' set!"
     PRINTF,lun,"Can't make log plots without using absolute value or only positive values..."
     PRINTF,lun,"Default: junking all negative flux values"
     WAIT, 1
     noNegFlux=1
  ENDIF
  IF KEYWORD_SET(noPosFlux) AND KEYWORD_SET (logPlot) THEN absFlux = 1

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN BEGIN
     tmplt_h2dStr  = MAKE_H2DSTR_TMPLT(BIN1=MIMC_struct.binM,BIN2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.binL : MIMC_struct.binI),$
                                       MIN1=MIMC_struct.MINM,MIN2=(KEYWORD_SET(MIMC_STRUCT.DO_LSHELL) ? MIMC_struct.MINL : MIMC_struct.MINI),$
                                       MAX1=MIMC_struct.MAXM,MAX2=(KEYWORD_SET(MIMC_STRUCT.DO_LSHELL) ? MIMC_struct.MAXL : MIMC_struct.MAXI), $
                                       SHIFT1=MIMC_struct.shiftM,SHIFT2=shiftI, $
                                       EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning, $
                                       DO_PLOT_I_INSTEAD_OF_HISTOS=do_plot_i_instead_of_histos, $
                                       ;; PLOT_I=plot_i, $
                                       DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                                       CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                       CB_FORCE_OOBLOW=cb_force_oobLow)
  ENDIF

  h2dStr                    = tmplt_h2dStr

  grossRateMe = KEYWORD_SET(do_grossRate_fluxQuantities) OR $
                KEYWORD_SET(do_grossRate_with_long_width) OR $
                KEYWORD_SET(grossRate_info_file) OR $
                KEYWORD_SET(show_integrals)

  dataName                  = N_ELEMENTS(custom_dataName) GT 0 ? custom_dataName : "custom_maxInd"
  h2dStr.labelFormat        = fluxPlotEPlotCBLabelFormat
  h2dStr.logLabels          = 0
  h2dStr.do_plotIntegral    = 0
  h2dStr.do_midCBLabel      = 0
  h2dStr.title              = N_ELEMENTS(custom_title) GT 0 ? custom_title : "custom_maxInd"

  inData                    = GET_CUSTOM_ALFVENDB_QUANTITY(custom_maxInd,MAXIMUS=maximus,/VERBOSE)
  inData                    = inData[tmp_i]

  can_div_by_w_x            = 1
  can_mlt_by_w_x            = 1

  ;;Handle name of data
  ;;Log plots desired?
  absStr                    = ""
  negStr                    = ""
  posStr                    = ""
  logStr                    = ""
  IF KEYWORD_SET(absFlux)THEN BEGIN
     PRINTF,lun,"N pos elements in " + dataName + " data: ",N_ELEMENTS(where(inData GT 0.))
     PRINTF,lun,"N neg elements in " + dataName + " data: ",N_ELEMENTS(where(inData LT 0.))
     IF KEYWORD_SET(noPosFlux) THEN BEGIN
        posStr                = 'NoPos--'
        PRINTF,lun,"N elements in " + dataName + " before junking pos vals: ",N_ELEMENTS(inData)
        lt_i                   =  WHERE(inData LT 0.,COMPLEMENT=removed_ii)
        inData                 = inData[lt_i]
        tmp_i                 = tmp_i[lt_i]
        PRINTF,lun,"N elements in " + dataName + " after junking pos vals: ",N_ELEMENTS(inData)
        inData                 = ABS(inData)
     ENDIF ELSE BEGIN
        absStr                = 'Abs--' 
     ENDELSE
     inData = ABS(inData)
  ENDIF
  IF KEYWORD_SET(noNegFlux) THEN BEGIN
     negStr                = 'NoNegs--'
     PRINTF,lun,"N elements in " + dataName + " before junking neg vals: ",N_ELEMENTS(inData)
     gt_i                   =  WHERE(inData GT 0.,COMPLEMENT=removed_ii)
     inData                 = inData[gt_i]
     tmp_i                 = tmp_i[gt_i]
     PRINTF,lun,"N elements in " + dataName + " after junking neg vals: ",N_ELEMENTS(inData)
  ENDIF
  IF KEYWORD_SET(noPosFlux) AND ~KEYWORD_SET(absFlux) THEN BEGIN
     posStr                = 'NoPos--'
     PRINTF,lun,"N elements in " + dataName + " before junking pos vals: ",N_ELEMENTS(inData)
     lt_i                   =  WHERE(inData LT 0.,COMPLEMENT=removed_ii)
     inData                 = inData[lt_i]
     tmp_i                 = tmp_i[lt_i]
     PRINTF,lun,"N elements in " + dataName + " after junking pos vals: ",N_ELEMENTS(inData)
     inData                 = ABS(inData)
  ENDIF
  IF KEYWORD_SET(logPlot) AND ~h2dStr.logLabels THEN BEGIN
     logStr                 = "Log "
  ENDIF

  absnegslogStr             = absStr + negStr + posStr + logStr
  dataName                  = STRTRIM(absnegslogStr,2)+dataName + $
                              (KEYWORD_SET(fluxPlotType) ? '_' + STRUPCASE(fluxplottype) : '')

  IF KEYWORD_SET(divide_by_width_x) THEN BEGIN
     IF can_div_by_w_x THEN BEGIN
        PRINT,'Dividing by WIDTH_X!'
        
        dataName               = 'spatialAvg_' + dataName

        ;;If the ion plots or one of the select electron plots didn't pick this up, set it to 1
        ;;NOTE, oxy also needs to be scaled!!!
        IF N_ELEMENTS(factor) EQ 0 THEN factor = 1.0D
        IF N_ELEMENTS(magFieldFactor) EQ 0 THEN magFieldFactor = 1.0D

        inData                 = inData*factor*magFieldFactor/maximus.width_x[tmp_i]
     ENDIF ELSE BEGIN
        PRINTF,lun,"Can't divide " + dataName + " by width_x! Not in the cards."
     ENDELSE
  ENDIF

  IF KEYWORD_SET(multiply_by_width_x) THEN BEGIN
     IF can_mlt_by_w_x THEN BEGIN
        PRINT,'Multiplying by WIDTH_X!'
        
        dataName               = 'spatialInteg_' + dataName
        
        ;;If the ion plots or one of the select electron plots didn't pick this up, set it to 1
        ;;NOTE, oxy also needs to be scaled!!!
        IF N_ELEMENTS(factor) EQ 0 THEN factor = 1.0D
        IF N_ELEMENTS(magFieldFactor) EQ 0 THEN magFieldFactor = 1.0D
        
        inData                 = inData*factor*magFieldFactor*maximus.width_x[tmp_i]
     ENDIF ELSE BEGIN
        PRINTF,lun,"Can't multiply " + dataName + " by width_x! Not in the cards."
     ENDELSE
  ENDIF

  ;;Is this going to be a time-averaged plot?
  IF KEYWORD_SET(do_timeAvg_fluxQuantities) THEN BEGIN
     inData                 = inData * maximus.width_time[tmp_i]
     dataName               = 'timeAvgd_' + dataName
  ENDIF

  ;;gross rates?
  IF KEYWORD_SET(grossRateMe) THEN BEGIN

     IF ~KEYWORD_SET(custom_grossRate_convFactor) THEN BEGIN
        PRINTF,lun,'Must provide a conversion factor for custome maxInd! Out...'
        STOP
     ENDIF ELSE BEGIN
        grossConvFactor     = custom_grossRate_convFactor
     ENDELSE

     CASE 1 OF
        KEYWORD_SET(do_grossRate_fluxQuantities): BEGIN
           dataName         = 'grossRate_' + dataName
        END
        KEYWORD_SET(do_grossRate_with_long_width): BEGIN
           dataName         = 'grossRate_longWid_' + dataName
        END
     ENDCASE
  ENDIF

  ;;Averaging based on number of orbits passing through instead of nEvents, perhaps?
  IF KEYWORD_SET(div_fluxPlots_by_applicable_orbs) THEN BEGIN
     h2dStr.title           = 'Orbit-averaged ' + h2dStr.title
     dataName               = 'orbAvgd_' + dataName
  ENDIF

  ;;fix MLTs
  mlts                      = SHIFT_MLTS_FOR_H2D(maximus,tmp_i,MIMC_struct.shiftM)
  ilats                     = (KEYWORD_SET(MIMC_struct.do_Lshell) ? maximus.lshell : maximus.ilat)[tmp_i]
  IF KEYWORD_SET(h2dStr.both_hemis) THEN ilats = ABS(ilats)

  IF KEYWORD_SET(do_plot_i_instead_of_histos) THEN BEGIN
     h2dStr.data.add,inData
     hEv_nz_i      = INDGEN(N_ELEMENTS(inData))
  ENDIF ELSE BEGIN
     CASE 1 OF
        KEYWORD_SET(alfDB_plot_struct.medianplot): BEGIN 

           IF KEYWORD_SET(medHistOutData) THEN BEGIN
              medHistDatFile  = medHistDataDir + dataName+"medhist_data.sav"
           ENDIF
           
           h2dStr.data = MEDIAN_HIST(mlts, $
                                     ilats,$
                                     inData,$
                                     MIN1=MIMC_struct.MINM,MIN2=(KEYWORD_SET(MIMC_STRUCT.DO_LSHELL) ? MIMC_struct.MINL : MIMC_struct.MINI),$
                                     MAX1=MIMC_struct.MAXM,MAX2=(KEYWORD_SET(MIMC_STRUCT.DO_LSHELL) ? MIMC_struct.MAXL : MIMC_struct.MAXI),$
                                     BINSIZE1=MIMC_struct.binM,BINSIZE2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.binL : MIMC_struct.binI),$
                                     OBIN1=outH2DBinsMLT,OBIN2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? outH2DBinsLShell : outH2DBinsILAT),$
                                     ABSMED=absFlux, $
                                     OUTFILE=medHistDatFile, $
                                     PLOT_I=tmp_i, $
                                     EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning) 
           
           IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + dataName + "medhist.txt"
        END
        KEYWORD_SET(do_timeAvg_fluxQuantities): BEGIN

           CASE 1 OF
              KEYWORD_SET(alfDB_plot_struct.EA_binning): BEGIN
                 h2dStr.data = HIST2D__EQUAL_AREA_BINNING(mlts, $
                                                          ilats,$
                                                          (KEYWORD_SET(do_logAvg_the_timeAvg) ? ALOG10(inData) : inData),$
                                                          MIN1=MIMC_struct.minM,MIN2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.minL : MIMC_struct.minI),$
                                                          MAX1=MIMC_struct.maxM,MAX2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.maxL : MIMC_struct.maxI),$
                                                          OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
              END
              ELSE: BEGIN
                 h2dStr.data = HIST2D(mlts, $
                                      ilats,$
                                      (KEYWORD_SET(do_logAvg_the_timeAvg) ? ALOG10(inData) : inData),$
                                      MIN1=MIMC_struct.minM,MIN2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.minL : MIMC_struct.minI),$
                                      MAX1=MIMC_struct.maxM,MAX2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.maxL : MIMC_struct.maxI),$
                                      BINSIZE1=MIMC_struct.binM,BINSIZE2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.binL : MIMC_struct.binI),$
                                      OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
              END
           ENDCASE

           IF KEYWORD_SET(do_logAvg_the_timeAvg) THEN BEGIN
              h2dStr.data[hEv_nz_i]=h2dStr.data[hEv_nz_i]/h2dFluxN[hEv_nz_i] 
              h2dStr.data[where(h2dFluxN GT 0,/NULL)] = 10^(h2dStr.data[where(h2dFluxN GT 0,/NULL)])
           ENDIF

           PROBOCCURRENCE_AND_TIMEAVG_SANITY_CHECK,h2dStr,tHistDenominator,outH2DBinsMLT,outH2DBinsILAT,H2DFluxN,dataName,h2dMask

           h2dStr.data[WHERE(h2dstr.data GT 0)] = h2dStr.data[WHERE(h2dstr.data GT 0)]/tHistDenominator[WHERE(h2dstr.data GT 0)]

           ;; IF KEYWORD_SET(do_grossRate_fluxQuantities) THEN BEGIN
           ;;    h2dStr.data[WHERE(h2dstr.data GT 0)] = h2dStr.data[WHERE(h2dstr.data GT 0)]*h2dAreas[WHERE(h2dstr.data GT 0)]*grossConvFactor

           ;;    dayInds                           = WHERE(centersMLT GE 6*15 AND centersMLT LT 18*15 AND ~h2dMask)
           ;;    nightInds                         = WHERE((centersMLT GE 18*15 OR centersMLT LT 6*15) AND ~h2dMask)

           ;;    IF dayInds[0] NE -1 THEN BEGIN
           ;;       grossDay                       = TOTAL(h2dStr.data[dayInds])
           ;;    ENDIF ELSE grossDay               = 0

           ;;    IF nightInds[0] NE -1 THEN BEGIN
           ;;       grossNight                     = TOTAL(h2dStr.data[nightInds])
           ;;    ENDIF ELSE grossNight             = 0
           ;; ENDIF
        END
        ELSE: BEGIN
           CASE 1 OF
              KEYWORD_SET(alfDB_plot_struct.EA_binning): BEGIN
                 h2dStr.data  = HIST2D__EQUAL_AREA_BINNING(mlts, $
                                                           ilats,$
                                                           (KEYWORD_SET(alfDB_plot_struct.logAvgPlot) ? ALOG10(inData) : inData),$
                                                           MIN1=MIMC_struct.MINM,MIN2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.minL : MIMC_struct.minI),$
                                                           MAX1=MIMC_struct.MAXM,MAX2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.maxL : MIMC_struct.maxI),$
                                                           OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
              END
              ELSE: BEGIN
                 h2dStr.data  = HIST2D(mlts, $
                                       ilats,$
                                       (KEYWORD_SET(alfDB_plot_struct.logAvgPlot) ? ALOG10(inData) : inData),$
                                       MIN1=MIMC_struct.MINM,MIN2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.minL : MIMC_struct.minI),$
                                       MAX1=MIMC_struct.MAXM,MAX2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.maxL : MIMC_struct.maxI),$
                                       BINSIZE1=MIMC_struct.binM,BINSIZE2=(KEYWORD_SET(MIMC_struct.do_Lshell) ? MIMC_struct.binL : MIMC_struct.binI),$
                                       OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
              END
           ENDCASE

           IF KEYWORD_SET(div_fluxPlots_by_applicable_orbs) THEN BEGIN
              
              tempDenom                        = orbContrib_h2dStr_for_division.data
              IF orbContrib_H2DStr_FOR_division.is_logged THEN BEGIN
                 tempDenom[hEv_nz_i]  = 10.^(tempDenom[hEv_nz_i])
              ENDIF

              h2dStr.data[hEv_nz_i]   = h2dStr.data[hEv_nz_i]/tempDenom[hEv_nz_i]

           ENDIF ELSE BEGIN
              h2dStr.data[hEv_nz_i]   = h2dStr.data[hEv_nz_i]/h2dFluxN[hEv_nz_i] 
           ENDELSE
           
           IF KEYWORD_SET(alfDB_plot_struct.logAvgPlot) THEN h2dStr.data[where(h2dFluxN NE 0,/NULL)] = 10^(h2dStr.data[where(h2dFluxN NE 0,/NULL)])
           
        END
     ENDCASE

     IF KEYWORD_SET(multiply_fluxes_by_probOccurrence) THEN BEGIN
        PRINT,'Multiplying by probability of occurrence!'
        dataName += '_probOcc'
        h2dStr.data *= H2DProbOcc
     ENDIF

     IF KEYWORD_SET(grossRateMe) THEN BEGIN
        CASE 1 OF
           KEYWORD_SET(do_grossRate_fluxQuantities): BEGIN
              ;; h2dStr.data[WHERE(h2dstr.data GT 0)] = h2dStr.data[WHERE(h2dstr.data GT 0)]*h2dAreas[WHERE(h2dstr.data GT 0)]*grossConvFactor
              h2dStr.data[hEv_nz_i] = h2dStr.data[hEv_nz_i]*h2dAreas[hEv_nz_i]*grossConvFactor
           END
           KEYWORD_SET(do_grossRate_with_long_width): BEGIN
              ;; h2dStr.data[WHERE(h2dstr.data GT 0)] = h2dStr.data[WHERE(h2dstr.data GT 0)]*h2dLongWidths[WHERE(h2dstr.data GT 0)]*grossConvFactor
              h2dStr.data[hEv_nz_i] = h2dStr.data[hEv_nz_i]*h2dLongWidths[hEv_nz_i]*grossConvFactor
           END
        ENDCASE

        dayInds                           = WHERE(centersMLT GE 6*15 AND centersMLT LT 18*15 AND ~h2dMask)
        nightInds                         = WHERE((centersMLT GE 18*15 OR centersMLT LT 6*15) AND ~h2dMask)

        IF dayInds[0] NE -1 THEN BEGIN
           grossDay                       = TOTAL(h2dStr.data[dayInds])
        ENDIF ELSE grossDay               = 0

        IF nightInds[0] NE -1 THEN BEGIN
           grossNight                     = TOTAL(h2dStr.data[nightInds])
        ENDIF ELSE grossNight             = 0

        grossDat    = h2dStr.data
        grossDat[*] = 0.
        grossDat[WHERE(h2dstr.data GT 0)] = h2dStr.data[WHERE(h2dstr.data GT 0)]*h2dAreas[WHERE(h2dstr.data GT 0)]*grossConvFactor

        IF dayInds[0] NE -1 THEN BEGIN
           grossDay            = TOTAL(grossDat[dayInds])
        ENDIF ELSE grossDay    = 0

        IF nightInds[0] NE -1 THEN BEGIN
           grossNight          = TOTAL(grossDat[nightInds])
        ENDIF ELSE grossNight  = 0
     ENDIF
  ENDELSE

  IF KEYWORD_SET(print_mandm) THEN BEGIN
     IF KEYWORD_SET(alfDB_plot_struct.medianPlot) OR ~KEYWORD_SET(alfDB_plot_struct.logAvgPlot) THEN BEGIN
        fmt    = 'G10.4' 
        maxh2d = MAX(h2dStr.data[hEv_nz_i])
        minh2d = MIN(h2dStr.data[hEv_nz_i])
        medh2d = MEDIAN(h2dStr.data[hEv_nz_i])

        IF KEYWORD_SET(grossRateMe) THEN BEGIN
           grossMaxh2d = MAX(grossDat[hEv_nz_i])
           grossMinh2d = MIN(grossDat[hEv_nz_i])
           grossMedh2d = MEDIAN(grossDat[hEv_nz_i])
           dayMaxh2d = (dayInds[0] NE -1) ? MAX(grossDat[dayInds]) : 0.00
           dayMinh2d = (dayInds[0] NE -1) ? MIN(grossDat[dayInds]) : 0.00
           dayMedh2d = (dayInds[0] NE -1) ? MEDIAN(grossDat[dayInds]) : 0.00
           nightMaxh2d = (nightInds[0] NE -1) ? MAX(grossDat[nightInds]) : 0.00
           nightMinh2d = (nightInds[0] NE -1) ? MIN(grossDat[nightInds]) : 0.00
           nightMedh2d = (nightInds[0] NE -1) ? MEDIAN(grossDat[nightInds]) : 0.00
           h2dStr.grossIntegrals.day   = grossDay
           h2dStr.grossIntegrals.night = grossNight
           h2dStr.grossIntegrals.total = grossDay+grossNight

        ENDIF

     ENDIF ELSE BEGIN
        fmt    = 'F10.2'
        maxh2d = ALOG10(MAX(h2dStr.data[hEv_nz_i]))
        minh2d = ALOG10(MIN(h2dStr.data[hEv_nz_i]))
        medh2d = ALOG10(MEDIAN(h2dStr.data[hEv_nz_i]))
     ENDELSE
     PRINTF,lun,h2dStr.title
     ;; PRINTF,lun,FORMAT='("Max, min:",T20,F10.2,T35,F10.2)', $
     ;;        MAX(h2dStr.data[hEv_nz_i]), $
     ;;        MIN(h2dStr.data[hEv_nz_i])
     PRINTF,lun,FORMAT='("Max, min. med:",T20,' + fmt + ',T35,' + fmt + ',T50,' + fmt +')', $
            maxh2d, $
            minh2d, $
            medh2d            

     ;;KLUGE IT
     GET_H2D_BIN_AREAS,h2dAreas, $
                       CENTERS1=centersMLT,CENTERS2=centersILAT, $
                       BINSIZE1=MIMC_struct.binM*15.,BINSIZE2=MIMC_struct.binI, $
                       MAX1=MIMC_struct.maxM*15.,MAX2=MIMC_struct.maxI, $
                       MIN1=MIMC_struct.minM*15.,MIN2=MIMC_struct.minI, $
                       SHIFT1=MIMC_struct.shiftM*15.,SHIFT2=shiftI, $
                       EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning
     ;; dayInds    = WHERE(centersMLT GE 6*15 AND centersMLT LT 18*15 AND ~h2dMask)
     ;; nightInds  = WHERE((centersMLT GE 18*15 OR centersMLT LT 6*15) AND ~h2dMask)
     dayInds    = WHERE(centersMLT GE 11*15 AND centersMLT LT 15*15 AND ~h2dMask)
     nightInds  = WHERE((centersMLT GE 21*15 OR centersMLT LT 1*15) AND ~h2dMask)

     ;; nightMaxes = GET_N_MAXIMA_IN_ARRAY(h2dstr.data[nightinds], $
     ;;                                   N=10, $
     ;;                                   OUT_I=nightMax_ii)
     ;; dayMaxes = GET_N_MAXIMA_IN_ARRAY(h2dstr.data[dayinds], $
     ;;                                   N=10, $
     ;;                                   OUT_I=dayMax_ii)
     
     ;; dayMaxes   = MAX(h2dstr.data[dayinds],maxdayindii)

     dayMax   = MAX(h2dstr.data[dayinds],maxdayindii)
     nightMax = MAX(h2dstr.data[nightinds],maxnightindii)

     PRINT,"Day max (MLT,ILAT): ",dayMax, $
           '(' + STRCOMPRESS(centersmlt[dayinds[maxdayindii]]/15.,/REMOVE_ALL), $
           ', ' + STRCOMPRESS(centersilat[dayinds[maxdayindii]]) + ')'
     PRINT,"Night max (MLT,ILAT): ",nightMax, $
           '(' + STRCOMPRESS(centersmlt[nightinds[maxnightindii]]/15.,/REMOVE_ALL), $
           ', ' + STRCOMPRESS(centersilat[nightinds[maxnightindii]]) + ')'


     IF KEYWORD_SET(grossRateMe) THEN BEGIN
        grossFmt      = 'G18.6'
        PRINTF,lun,FORMAT='("Gross dayside, nightside:",T30,'+ $
               grossFmt + ',T50,' + grossFmt + ')', $
               grossDay,grossNight

        IF KEYWORD_SET(grossRate_info_file) THEN BEGIN
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
           h2dStr.lim   = [MIN(h2dStr.data[hEv_nz_i]), $
                           MAX(h2dStr.data[hEv_nz_i])]
        END
        KEYWORD_SET(plotRange): BEGIN
           h2dStr.lim   = plotRange
        END
     ENDCASE
  ENDIF ELSE BEGIN
     h2dStr.lim         = [MIN(h2dStr.data),MAX(h2dStr.data)]
  ENDELSE
  
  IF KEYWORD_SET(logPlot) THEN BEGIN 
     IF KEYWORD_SET(do_plot_i_instead_of_histos) THEN BEGIN
        h2dStr.data[0,WHERE(h2dStr.data[0] NE 0,/NULL)] = ALOG10(h2dStr.data[WHERE(h2dStr.data[0] NE 0,/NULL)])
     ENDIF ELSE BEGIN
        h2dStr.data[where(h2dStr.data NE 0,/NULL)]=ALOG10(h2dStr.data[where(h2dStr.data NE 0,/NULL)]) 
        inData[where(inData NE 0,/NULL)]=ALOG10(inData[where(inData NE 0,/NULL)]) 
     ENDELSE
     h2dStr.lim        = ALOG10(h2dStr.lim)
     h2dStr.is_logged  = 1
  ENDIF

  dataRawPtr           = PTR_NEW(inData)
  h2dStr.name          = dataName
  out_h2dMask          = h2dMask

  IF removed_ii[0] NE -1 THEN out_removed_ii = removed_ii ELSE out_removed_ii = !NULL
END