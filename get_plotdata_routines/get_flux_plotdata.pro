;2015/10/16
;Just generalize, my man
;
;TO DO:
;2015/12/03 Fix e- number flux; most of those aren't actually number fluxes
; I've added this information to CORRECT_ALFVENDB_FLUXES

PRO GET_FLUX_PLOTDATA,maximus,plot_i,MINM=minM,MAXM=maxM,BINM=binM,MINI=minI,MAXI=maxI,BINI=binI, $
                      DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                      OUTH2DBINSMLT=outH2DBinsMLT,OUTH2DBINSILAT=outH2DBinsILAT,OUTH2DBINSLSHELL=outH2DBinsLShell, $
                      FLUXPLOTTYPE=fluxPlotType,PLOTRANGE=plotRange, $
                      NOPOSFLUX=noPosFlux,NONEGFLUX=noNegFlux,ABSFLUX=absFlux,LOGFLUXPLOT=logFluxPlot, $
                      H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr,H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, H2DFLUXN=h2dFluxN, $
                      DATANAME=dataName,DATARAWPTR=dataRawPtr, $
                      MEDIANPLOT=medianplot,MEDHISTOUTDATA=medHistOutData,MEDHISTOUTTXT=medHistOutTxt,MEDHISTDATADIR=medHistDataDir, $
                      LOGAVGPLOT=logAvgPlot, $
                      WRITEHDF5=writeHDF5,WRITEASCII=writeASCII,SQUAREPLOT=squarePlot,SAVERAW=saveRaw, $
                      GET_EFLUX=get_eflux,GET_ENUMFLUX=get_eNumFlux,GET_PFLUX=get_pFlux,GET_IFLUX=get_iFlux, $
                      GET_CHAREE=get_ChareE,GET_CHARIE=get_chariE, $
                      PRINT_MAX_AND_MIN=print_mandm
                      LUN=lun
  
  COMPILE_OPT idl2

  @fluxplot_defaults.pro

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1
  IF N_ELEMENTS(print_mandm) EQ 0 THEN print_mandm = 1

  nDataz = 0

  IF KEYWORD_SET(get_eFlux) THEN nDataz++
  IF KEYWORD_SET(get_eNumFlux) THEN nDataz++
  IF KEYWORD_SET(get_pFlux) THEN nDataz++
  IF KEYWORD_SET(get_iFlux) THEN nDataz++
  IF KEYWORD_SET(get_ChareE) THEN nDataz++
  IF KEYWORD_SET(get_ChariE) THEN nDataz++

  IF nDataz GT 1 THEN BEGIN
     PRINTF,lun,"Multiple plots at once currently not supported, you fool!"
     STOP
  ENDIF

  ;; Flux plot safety
  IF KEYWORD_SET(logFluxPlot) AND NOT KEYWORD_SET(absFlux) AND NOT KEYWORD_SET(noNegFlux) AND NOT KEYWORD_SET(noPosFlux) THEN BEGIN 
     PRINTF,lun,"Warning!: You're trying to do logplots of flux but you don't have 'absFlux', 'noNegFlux', or 'noPosFlux' set!"
     PRINTF,lun,"Can't make log plots without using absolute value or only positive values..."
     PRINTF,lun,"Default: junking all negative flux values"
     WAIT, 1
     noNegFlux=1
  ENDIF
  IF KEYWORD_SET(noPosFlux) AND KEYWORD_SET (logFluxPlot) THEN absFlux = 1

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI))
  h2dStr={tmplt_h2dStr}
  h2dStr.is_fluxData = 1

  IF KEYWORD_SET(get_eFlux) THEN BEGIN
     dataName               = "eFlux"
     h2dStr.labelFormat     = fluxPlotColorBarLabelFormat
     h2dStr.logLabels       = logeFluxLabels
     h2dStr.do_plotIntegral = eFlux_do_plotIntegral

     ;;If not allowing negative fluxes
     IF STRUPCASE(fluxplottype) EQ STRUPCASE("Integ") THEN BEGIN
        h2dStr.title = title__alfDB_ind_09
        ;;plot_i=cgsetintersection(WHERE(FINITE(maximus.integ_elec_energy_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
        ;;PRINTF,lun,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in " + STRUPCASE(fluxplottype) + " " + dataName + " data..."
        inData= maximus.integ_elec_energy_flux[plot_i] 
     ENDIF ELSE BEGIN
        IF STRUPCASE(fluxplottype) EQ STRUPCASE("Max") THEN BEGIN
           h2dStr.title = title__alfDB_ind_08
           ;;plot_i=cgsetintersection(WHERE(FINITE(maximus.elec_energy_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
           ;;PRINTF,lun,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in " + STRUPCASE(fluxplottype) + " " + dataName + " data..."
           inData = maximus.elec_energy_flux[plot_i]
        ENDIF
     ENDELSE
  ENDIF

  IF KEYWORD_SET(get_eNumFlux) THEN BEGIN
     dataName               = "eNumFl"
     h2dStr.labelFormat     = fluxPlotColorBarLabelFormat
     h2dStr.logLabels       = logeFluxLabels
     h2dStr.do_plotIntegral = eFlux_do_plotIntegral
     h2dStr.do_midCBLabel   = eFlux_do_midCBLabel

     IF STRUPCASE(fluxPlotType) EQ STRUPCASE("Total_Eflux_Integ") THEN BEGIN
        h2dStr.title = title__alfDB_ind_11

        ;;plot_i=cgsetintersection(WHERE(FINITE(maximus.total_eflux_integ),NCOMPLEMENT=lost),plot_i) ;;NaN check
        ;;PRINTF,lun,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in " + STRUPCASE(fluxplottype) + " " + dataName + " data..."
        inData= maximus.total_eflux_integ[plot_i] 
     ENDIF ELSE BEGIN
        IF STRUPCASE(fluxPlotType) EQ STRUPCASE("Eflux_Losscone_Integ") THEN BEGIN
           h2dStr.title = title__alfDB_ind_10
           ;;plot_i=cgsetintersection(WHERE(FINITE(maximus.eflux_losscone_integ),NCOMPLEMENT=lost),plot_i) ;;NaN check
           ;;PRINTF,lun,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in " + STRUPCASE(fluxplottype) + " " + dataName + " data..."
           inData = maximus.eflux_losscone_integ[plot_i]
        ENDIF ELSE BEGIN
           IF STRUPCASE(fluxPlotType) EQ STRUPCASE("ESA_Number_flux") THEN BEGIN
              h2dStr.title = title__alfDB_esa_nFlux
              ;;plot_i=cgsetintersection(WHERE(FINITE(maximus.esa_current),NCOMPLEMENT=lost),plot_i) ;;NaN check
              ;;PRINTF,lun,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in " + STRUPCASE(fluxplottype) + " " + dataName + " data..."
           ENDIF
           ;;NOTE: microCoul_per_m2__to_num_per_cm2 = 1. / 1.6e-9
           inData = maximus.esa_current[plot_i] * 1. / 1.6e-9
        ENDELSE
     ENDELSE
  ENDIF
     
  IF KEYWORD_SET(get_pFlux) THEN BEGIN

     h2dStr.title           = title__alfDB_ind_49
     dataName               = "pFlux_"
     h2dStr.labelFormat     = fluxPlotColorBarLabelFormat
     h2dStr.logLabels       = logPFluxLabels
     h2dStr.do_plotIntegral = PFlux_do_plotIntegral
     h2dStr.do_midCBLabel   = PFlux_do_midCBLabel

     inData = maximus.pFluxEst[plot_i]

  ENDIF

  IF KEYWORD_SET(get_iFlux) THEN BEGIN
     ;; h2dStr.title= "Ion Flux (ergs/cm!U2!N-s)"
     dataName               = "iflux" 
     h2dStr.labelFormat     = fluxPlotColorBarLabelFormat
     h2dStr.logLabels       = logiFluxLabels
     h2dStr.do_plotIntegral = iFlux_do_plotIntegral
     h2dStr.do_midCBLabel   = iFlux_do_midCBLabel

     IF STRUPCASE(fluxplottype) EQ STRUPCASE("Integ") THEN BEGIN
        h2dStr.title= title__alfDB_ind_17
        ;;plot_i=cgsetintersection(WHERE(FINITE(maximus.integ_ion_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
        ;;PRINTF,lun,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in " + STRUPCASE(fluxplottype) + " " + dataName + " data..."
     inData=maximus.integ_ion_flux[plot_i]
     ENDIF ELSE BEGIN
        IF STRUPCASE(fluxplottype) EQ STRUPCASE("Max") THEN BEGIN
           h2dStr.title= title__alfDB_ind_15
           ;;plot_i=cgsetintersection(WHERE(FINITE(maximus.ion_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
           ;;PRINTF,lun,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in " + STRUPCASE(fluxplottype) + " " + dataName + " data..."pp
           inData=maximus.ion_flux[plot_i]
        ENDIF ELSE BEGIN
           IF STRUPCASE(fluxplottype) EQ STRUPCASE("Max_Up") THEN BEGIN
              h2dStr.title= title__alfDB_ind_16
              ;;plot_i=cgsetintersection(WHERE(FINITE(maximus.ion_flux_up),NCOMPLEMENT=lost),plot_i) ;;NaN check
              ;;PRINTF,lun,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in " + STRUPCASE(fluxplottype) + " " + dataName + " data..."
              inData=maximus.ion_flux_up[plot_i]
           ENDIF ELSE BEGIN
              IF STRUPCASE(fluxplottype) EQ STRUPCASE("Integ_Up") THEN BEGIN
                 h2dStr.title= title__alfDB_ind_18
                 ;;plot_i=cgsetintersection(WHERE(FINITE(maximus.integ_ion_flux_up),NCOMPLEMENT=lost),plot_i) ;;NaN check
                 ;;PRINTF,lun,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in " + STRUPCASE(fluxplottype) + " " + dataName + " data..."
                 inData=maximus.integ_ion_flux_up[plot_i]
              ENDIF ELSE BEGIN
                 IF STRUPCASE(fluxplottype) EQ STRUPCASE("Energy") THEN BEGIN
                    h2dStr.title= title__alfDB_ind_14
                    ;;plot_i=cgsetintersection(WHERE(FINITE(maximus.ion_energy_flux),NCOMPLEMENT=lost),plot_i) ;;NaN check
                    ;;PRINTF,lun,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in " + STRUPCASE(fluxplottype) + " " + dataName + " data..."
                    inData=maximus.ion_energy_flux[plot_i]
                 ENDIF
              ENDELSE
           ENDELSE
        ENDELSE
     ENDELSE
  ENDIF

  IF KEYWORD_SET(get_ChareE) THEN BEGIN
     dataName               = 'charEE'
     h2dStr.labelFormat     = fluxPlotChareCBLabelFormat
     h2dStr.logLabels       = logChareLabels
     h2dStr.do_plotIntegral = Charee_do_plotIntegral
     h2dStr.do_midCBLabel   = Charee_do_midCBLabel

     IF STRUPCASE(fluxplottype) EQ STRUPCASE("lossCone") THEN BEGIN
        h2dStr.title      = title__alfDB_ind_12
        ;;plot_i=cgsetintersection(WHERE(FINITE(maximus.max_chare_losscone),NCOMPLEMENT=lost),plot_i) ;;NaN check
        ;;PRINTF,lun,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in " + STRUPCASE(fluxplottype) + " " + dataName + " data..."
        inData=maximus.max_chare_losscone[plot_i] 
     ENDIF ELSE BEGIN
        IF STRUPCASE(fluxplottype) EQ STRUPCASE("Total") THEN BEGIN
           h2dStr.title      = title__alfDB_ind_13
           ;;plot_i=cgsetintersection(WHERE(FINITE(maximus.max_chare_total),NCOMPLEMENT=lost),plot_i) ;;NaN check
           ;;PRINTF,lun,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in " + STRUPCASE(fluxplottype) + " " + dataName + " data..."
           inData=maximus.max_chare_total[plot_i]
        ENDIF
     ENDELSE
  ENDIF

  IF KEYWORD_SET(get_ChariE) THEN BEGIN
     h2dStr.title           = title__alfDB_ind_19
     dataName               = 'charIE'
     h2dStr.labelFormat     = fluxPlotChariCBLabelFormat
     h2dStr.logLabels       = logChariLabels
     h2dStr.do_plotIntegral = Charie_do_plotIntegral
     h2dStr.do_midCBLabel   = Charie_do_midCBLabel
     ;;plot_i=cgsetintersection(WHERE(FINITE(maximus.char_ion_energy),NCOMPLEMENT=lost),plot_i) ;;NaN check
     ;;PRINTF,lun,"Lost " + strcompress(lost,/remove_all) + " events to NaNs in " + dataName + " data..."
     inData=maximus.char_ion_energy[plot_i] 
  ENDIF

  ;;Handle name of data
  ;;Log plots desired?
  absStr=""
  negStr=""
  posStr=""
  logStr=""
  IF KEYWORD_SET(absFlux)THEN BEGIN
     absEStr= 'Abs--' 
     PRINTF,lun,"N pos elements in " + dataName + " data: ",N_ELEMENTS(where(inData GT 0.))
     PRINTF,lun,"N neg elements in " + dataName + " data: ",N_ELEMENTS(where(inData LT 0.))
     inData = ABS(inData)
  ENDIF
  IF KEYWORD_SET(noNegFlux) THEN BEGIN
     negEStr = 'NoNegs--'
     PRINTF,lun,"N elements in " + dataName + " before junking neg vals: ",N_ELEMENTS(inData)
     gt_i   =  WHERE(inData GT 0.)
     inData = inData[gt_i]
     plot_i = plot_i[gt_i]
     PRINTF,lun,"N elements in " + dataName + " after junking neg vals: ",N_ELEMENTS(inData)
  ENDIF
  IF KEYWORD_SET(noPosFlux) THEN BEGIN
     posEStr = 'NoPos--'
     PRINTF,lun,"N elements in " + dataName + " before junking pos vals: ",N_ELEMENTS(inData)
     lt_i   =  WHERE(inData LT 0.)
     inData = inData[lt_i]
     plot_i = plot_i[lt_i]
     PRINTF,lun,"N elements in " + dataName + " after junking pos vals: ",N_ELEMENTS(inData)
     inData = ABS(inData)
  ENDIF
  IF KEYWORD_SET(logFluxPlot) THEN BEGIN
     logStr="Log "
  ENDIF

  absnegslogStr=absStr + negStr + posStr + logStr
  dataName = STRTRIM(absnegslogStr,2)+dataName+'_'+(KEYWORD_SET(fluxPlotType) ? STRUPCASE(fluxplottype) : '')
  h2dStr.title= absnegslogStr + h2dStr.title

  IF KEYWORD_SET(medianplot) THEN BEGIN 

     IF KEYWORD_SET(medHistOutData) THEN medHistDatFile = medHistDataDir + dataName+"medhist_data.sav"

     h2dStr.data=median_hist(maximus.mlt[plot_i],(KEYWORD_SET(DO_LSHELL) ? maximus.lshell : maximus.ilat)[plot_i],$
                              inData,$
                              MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                              MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI),$
                              BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                              OBIN1=outH2DBinsMLT,OBIN2=(KEYWORD_SET(do_lshell) ? outH2DBinsLShell : outH2DBinsILAT),$
                              ABSMED=absFlux,OUTFILE=medHistDatFile,PLOT_I=plot_i) 

     IF KEYWORD_SET(medHistOutTxt) THEN MEDHISTANALYZER,INFILE=medHistDatFile,outFile=medHistDataDir + dataName + "medhist.txt"

  ENDIF ELSE BEGIN 

     h2dStr.data=hist2d(maximus.mlt[plot_i], $
                         (KEYWORD_SET(DO_LSHELL) ? maximus.lshell : maximus.ilat)[plot_i],$
                         (KEYWORD_SET(logAvgPlot) ? ALOG10(inData) : inData),$
                         MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                         MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI),$
                         BINSIZE1=binM,BINSIZE2=(KEYWORD_SET(do_lshell) ? binL : binI),$
                         OBIN1=outH2DBinsMLT,OBIN2=outH2DBinsILAT) 
     h2dStr.data[h2d_nonzero_nEv_i]=h2dStr.data[h2d_nonzero_nEv_i]/h2dFluxN[h2d_nonzero_nEv_i] 

     IF KEYWORD_SET(logAvgPlot) THEN h2dStr.data[where(h2dFluxN NE 0,/null)] = 10^(h2dStr.data[where(h2dFluxN NE 0,/null)])

  ENDELSE

  IF KEYWORD_SET(print_mandm) THEN BEGIN
     IF KEYWORD_SET(medianPlot) OR ~KEYWORD_SET(logAvgPlot) THEN BEGIN
        fmt = 'G10.4' 
     ENDIF ELSE BEGIN
        fmt = 'F10.2'
     ENDELSE
     PRINTF,lun,h2dStr.title
     ;; PRINTF,lun,FORMAT='("Max, min:",T20,F10.2,T35,F10.2)', $
     ;;        MAX(h2dStr.data[h2d_nonzero_nEv_i]), $
     ;;        MIN(h2dStr.data[h2d_nonzero_nEv_i])
     PRINTF,lun,FORMAT='("Max, min:",T20,' + fmt + ',T35,' + fmt + ')', $
            MAX(h2dStr.data[h2d_nonzero_nEv_i]), $
            MIN(h2dStr.data[h2d_nonzero_nEv_i])
  ENDIF


  ;;Do custom range for flux plot, if requested
  IF  KEYWORD_SET(plotRange) THEN h2dStr.lim=plotRange $
  ELSE h2dStr.lim = [MIN(h2dStr.data),MAX(h2dStr.data)]
  
  IF KEYWORD_SET(logFluxPlot) THEN BEGIN 
     h2dStr.data[where(h2dStr.data NE 0,/NULL)]=ALOG10(h2dStr.data[where(h2dStr.data NE 0,/null)]) 
     inData[where(inData NE 0,/null)]=ALOG10(inData[where(inData NE 0,/null)]) 
     h2dStr.lim = ALOG10(h2dStr.lim)
     h2dStr.is_logged = 1
  ENDIF

  dataRawPtr = PTR_NEW(inData)

END