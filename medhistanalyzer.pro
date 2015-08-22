;+
; NAME: medHistAnalyzer
;
; PURPOSE: Produce text output of averages and means of data outputted by using the MEDHISTOUTDATA keyword in 
;            plot_alfven_stats_imf_screening.pro. This allows for inspection of the differences between the mean and
;            average of a given data product.
;
; INPUTS:            INFILE           :  IDL .sav file containing a pointer array, where each pointer points to an array
;                                          of observations corresponding to a given MLT/ILAT bin.
;
; OPTIONAL INPUTS:   OUTFILE          :  Text file to be outputted. Otherwise, stdout is used.
;
; OUTPUTS:                               A text file with MLT, ILAT, median, average, and n_elements for each bin.
;
; EXAMPLE:
;
;
;
; MODIFICATION HISTORY:
;
;-
;03/09/2015

PRO medHistAnalyzer,INFILE=infile,OUTFILE=outFile

  medHistDataDir = 'out/medHistData/'
  
  ;;open database
  ;; restore,'/SPENCEdata/Research/Cusp/database/dartdb/saves/Dartdb_02112015--500-14999--maximus.sav'
  
  ;;get your favorite hist file
  IF KEYWORD_SET(inFile) THEN restore,inFile $
  ELSE restore,medHistDataDir + 'North_dawnward_med--0stable--wind_ACE_maskMin_3_byMin_3.00000_Feb_18_15AbspFlux_medhist_data.sav'
  ;;restore,medHistDataDir + 'North_dawnward_med--0stable--wind_ACE_maskMin_3_byMin_3.00000_Feb_18_15Abs--LogeFluxMax_medhist_data.sav'
  ;;restore,medHistDataDir + 'North_dawnward_med--0stable--wind_ACE_maskMin_3_byMin_3.00000_Feb_18_15Abs--LogifluxMax_medhist_data.sav'

  ;;hist_i tells you where you have medians to calculate
  hist_i=WHERE(nonzeroHist GT 0)

  n_mlts = n_elements(obin1)
  n_ilats = n_elements(obin2)

  ;;output a nice text file
  IF KEYWORD_SET(outFile) THEN openw,lun,outFile,/get_lun ELSE lun = -1 ;stdout

  printf,lun, "MLT     ILAT      N ELEMENTS      MEDIAN      AVERAGE"
  FOR i=0, N_ELEMENTS(hist_i)-1 DO BEGIN
     mlt = obin1[hist_i[i] MOD n_mlts]
     ilat = obin2[(hist_i[i]/n_mlts)]
     nHistElem = n_elements(*ptrHist(hist_i[i]))
     
     ;median is all tricky
     IF N_ELEMENTS(*(ptrHist(hist_i[i]))) EQ 1 THEN BEGIN
        medio=*(ptrHist(hist_i[i])) 
     ENDIF ELSE BEGIN
        medio=MEDIAN(*ptrHist(hist_i[i]))
     ENDELSE

     avg = mean(*ptrHist(hist_i[i]))

     printf,lun,format='(F5.2,T9,F5.2,T19,I-6,T35,g-10.3,T47,g-10.3)',mlt,ilat,nHistElem,medio,avg

  ENDFOR

  IF KEYWORD_SET(outFile) THEN BEGIN 
     CLOSE,lun 
     FREE_LUN,lun 
  ENDIF

END