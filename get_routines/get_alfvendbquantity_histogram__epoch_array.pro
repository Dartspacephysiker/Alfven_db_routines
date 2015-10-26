;2015/10/25
;Types of histograms:
;0: Just sum everything in a given bin
;1: Straight averages
;2: log averages
PRO GET_ALFVENDBQUANTITY_HISTOGRAM__EPOCH_ARRAY,alf_t_list,alf_y_list,HISTOTYPE=histoType, $
   HISTDATA=histData, $
   HISTTBINS=histTBins, $
   NEVHISTDATA=nEvHistData, $
   TAFTEREPOCH=tafterepoch,TBEFOREEPOCH=tBeforeEpoch, $
   HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot, $
   NONZERO_I=nz_i
   ;; CHISTDATA=cHistData, $
   ;; SAVEFILE=saveFile,SAVESTR=saveStr, $
  

  IF ~KEYWORD_SET(histoType) THEN histoType = 0

  nEpochs = N_ELEMENTS(alf_t_list)

  FOR i=0,nEpochs-1 DO BEGIN
     
        
     IF N_ELEMENTS(alf_t_list[i]) GT 1 AND alf_t_list[i,0] NE -1 THEN BEGIN
        alf_t = alf_t_list[i]

        ;:Make nEvent histo if requested or if necessary for doing averaging
        IF KEYWORD_SET(only_nEvents) OR histoType GT 0 THEN BEGIN
           IF N_ELEMENTS(nEvHistData) EQ 0 THEN BEGIN
              nEvHistData=histogram(alf_t,LOCATIONS=histTBins, $
                                    MAX=tAfterEpoch,MIN=-tBeforeEpoch, $
                                    BINSIZE=histoBinSize)
           ENDIF ELSE BEGIN
              nEvHistData=histogram(alf_t,LOCATIONS=histTBins, $
                                    MAX=tAfterEpoch,MIN=-tBeforeEpoch, $
                                    BINSIZE=histoBinSize, $
                                    INPUT=histData)
           ENDELSE
        ENDIF
        
        ;;Do weighted histos
        IF ~KEYWORD_SET(only_nEvents) THEN BEGIN
           alf_y = alf_y_list[i]
           
           IF histoType EQ 2 THEN BEGIN ;;Log, if we're doing log averages
              IF N_ELEMENTS(WHERE(alf_y LE 0,/NULL)) GT 0 THEN BEGIN
                 PRINT,"GET_ALFVENDBQUANTITY_HISTOGRAM: Careful! I'm logging and making abs vals of input data for you..."
                 WAIT,1
              ENDIF
              alf_y = ABS(alf_y)
              valid_i = WHERE(FINITE(alf_y) AND alf_y GT 0)
              alf_t = alf_t(valid_i)
              alf_y = alf_y(valid_i)
           ENDIF
           
           IF N_ELEMENTS(hData) EQ 0 THEN BEGIN
              hData=hist1d(alf_t,alf_y,LOCATIONS=histTBins, $
                              MAX=tAfterEpoch,MIN=-tBeforeEpoch, $
                              BINSIZE=histoBinSize)
           ENDIF ELSE BEGIN
              hData=hist1d(alf_t,alf_y,LOCATIONS=histTBins, $
                              MAX=tAfterEpoch,MIN=-tBeforeEpoch, $
                              BINSIZE=histoBinSize, $
                              INPUT=hData)
           ENDELSE
        ENDIF
     ENDIF
  ENDFOR
  
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


