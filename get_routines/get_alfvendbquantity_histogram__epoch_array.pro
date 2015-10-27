;2015/10/25
;Types of histograms:
;0: Just sum everything in a given bin
;1: Straight averages
;2: log averages (The data are logged elsewher)
PRO GET_ALFVENDBQUANTITY_HISTOGRAM__EPOCH_ARRAY,alf_t_arr,alf_y_arr,HISTOTYPE=histoType, $
   HISTDATA=histData, $
   HISTTBINS=histTBins, $
   NEVHISTDATA=nEvHistData, $
   TAFTEREPOCH=tafterepoch,TBEFOREEPOCH=tBeforeEpoch, $
   HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot, $
   NONZERO_I=nz_i
   ;; CHISTDATA=cHistData, $
   ;; SAVEFILE=saveFile,SAVESTR=saveStr, $
  

  IF ~KEYWORD_SET(histoType) THEN histoType = 0

  ;; nEpochs = N_ELEMENTS(alf_t_arr)

  IF N_ELEMENTS(alf_t_arr) GT 1 AND alf_t_arr[0] NE -1 THEN BEGIN
     ;;Make nEvent histo if requested or if necessary for doing averaging
     ;; IF KEYWORD_SET(only_nEvents) OR histoType GT 0 THEN BEGIN
        IF N_ELEMENTS(nEvHistData) EQ 0 THEN BEGIN
           nEvHistData=histogram(alf_t_arr,LOCATIONS=histTBins, $
                                 MAX=tAfterEpoch,MIN=-tBeforeEpoch, $
                                 BINSIZE=histoBinSize)
        ENDIF ELSE BEGIN
           nEvHistData=histogram(alf_t_arr,LOCATIONS=histTBins, $
                                 MAX=tAfterEpoch,MIN=-tBeforeEpoch, $
                                 BINSIZE=histoBinSize, $
                                 INPUT=nEvHistData)
        ENDELSE
     ;; ENDIF
     
     ;;Do weighted histos
     IF ~KEYWORD_SET(only_nEvents) THEN BEGIN
        
        IF histoType EQ 2 THEN BEGIN
           ;;Below not applicable because logging is handled elsewhere
           ;; IF N_ELEMENTS(WHERE(alf_y_arr LE 0,/NULL)) GT 0 THEN BEGIN
           ;;    PRINT,"GET_ALFVENDBQUANTITY_HISTOGRAM: Careful! I'm making abs vals of input data for you..."
           ;;    WAIT,1
           ;; ENDIF

           alf_y_arr = ABS(alf_y_arr)
           ;; valid_i = WHERE(FINITE(alf_y_arr) AND alf_y_arr GT 0)  ;This is no good because the logging is handled in the get_data routine
           valid_i = WHERE(FINITE(alf_y_arr))
           alf_t_arr = alf_t_arr[valid_i]
           alf_y_arr = alf_y_arr[valid_i]
        ENDIF
        
        IF N_ELEMENTS(hData) EQ 0 THEN BEGIN
           hData=hist1d(alf_t_arr,alf_y_arr, $;LOCATIONS=histTBins, $
                        MAX=tAfterEpoch,MIN=-tBeforeEpoch, $
                        BINSIZE=histoBinSize)
        ENDIF ELSE BEGIN
           hData=hist1d(alf_t_arr,alf_y_arr, $;LOCATIONS=histTBins, $
                        MAX=tAfterEpoch,MIN=-tBeforeEpoch, $
                        BINSIZE=histoBinSize, $
                        INPUT=hData)
        ENDELSE
     ENDIF
  ENDIF
  
  ;;Perform averaging, if requested
  IF histoType GT 0 THEN BEGIN
     nz_i = WHERE(nEvHistData NE 0,COMPLEMENT=z_i)
     
     IF nz_i[0] NE -1 THEN BEGIN
        histData = DOUBLE(hData)
        histData[nz_i] = hData[nz_i]/nEvHistData[nz_i]
        histData[z_i] = 0
        
        IF histoType EQ 2 THEN BEGIN
           histData[nz_i] = 10^(histData[nz_i])
        ENDIF
     ENDIF ELSE BEGIN
        PRINT,"It's all bad! Couldn't find any histo elements that were nonzero..."
     ENDELSE
  ENDIF
  
  ;; cHistData = TOTAL(histData, /CUMULATIVE) / nEvTot
  ;; IF saveFile THEN saveStr+=',cHistData,histData,histTBins,histoBinSize'

END


