;;2015/12/02 Just show us wassup
PRO PRINT_ALFVENDB_2DHISTOS, $
   H2DSTRARR=h2dStrArr, $
   H2DMASK=h2dMask, $
   DATANAMEARR=dataNameArr, $
   FILE_TO_READ=file_to_read, $
   HEMI=hemi, $
   MIN1=min1, $
   MIN2=min2, $
   MAX1=max1, $
   MAX2=max2, $
   BIN1=bin1, $
   BIN2=bin2, $
   SHIFT1=shift1, $
   SHIFT2=shift2, $
   BIN1NAME=bin1name, $
   BIN2NAME=bin2name, $
   SAVEOUTPUT=saveOutput, $
   OUTPUTFILENAME=outputFilename, $
   UNLOG_DATA=unlog_data
   LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun           = -1 ;stdout
  
  IF N_ELEMENTS(h2dStrArr) EQ 0 THEN BEGIN
     IF N_ELEMENTS(file_to_read) GT 0 THEN BEGIN
        IF file_test(file_to_read) THEN BEGIN
           PRINTF,lun,'Restoring ' + file_to_read + ' ...'
           RESTORE,file_to_read

           ;;Make sure we got what we needed
           IF N_ELEMENTS(minM) EQ 0 OR N_ELEMENTS(minI) EQ 0 OR $
              N_ELEMENTS(maxM) EQ 0 OR N_ELEMENTS(maxM) EQ 0 OR $
              N_ELEMENTS(minM) EQ 0 OR N_ELEMENTS(minM) EQ 0 OR $
              N_ELEMENTS(binM) EQ 0 OR N_ELEMENTS(binM) EQ 0 OR $
              N_ELEMENTS(h2dStrArr) EQ 0 OR $
              N_ELEMENTS(paramStr) EQ 0 THEN BEGIN
              PRINTF,lun,"Restored file doesn't contain all necessary variables! See for yourself."
              STOP
           ENDIF

           min1                              = minM
           min2                              = minI
           max1                              = maxM
           max2                              = maxI
           bin1                              = binM
           bin2                              = binI
           bin1name                          = 'MLT'
           bin2name                          = 'ILAT'
           IF KEYWORD_SET(shiftM) THEN shift1 = shiftM 
           IF KEYWORD_SET(shiftI) THEN shift2 = shiftI

           IF N_ELEMENTS(h2dStrArr) GT 1 THEN BEGIN
              IF STRMATCH(h2dStrArr[-1].title,'Histogram mask',/FOLD_CASE) THEN BEGIN
                 h2dMask                        = h2dStrArr[-1].data
                 nH2DtoPrint                    = N_ELEMENTS(h2dStrArr)-1
                 PRINTF,lun,"Found histogram mask in provided file! Gonna use it."
              ENDIF ELSE BEGIN
                 PRINTF,lun,"Didn't find histogram mask in provided file..."
                 nH2DtoPrint                    = N_ELEMENTS(h2dStrArr)
              ENDELSE
           ENDIF ELSE nH2DtoPrint               = 1
        ENDIF ELSE BEGIN
           PRINTF,lun,"Couldn't open " + file_to_read + '!!!'
           PRINTF,lun,"Quitting ..."
           RETURN
        ENDELSE
     ENDIF ELSE BEGIN
        PRINTF,lun,"No data provided, and no provided filename to be opened! Quitting ..."
        RETURN
     ENDELSE
  ENDIF ELSE BEGIN
     PRINTF,lun,"Assuming you've provided MLT and ILAT 2D histos ..."
     IF N_ELEMENTS(bin1name) EQ 0 THEN bin1name = "MLT"
     IF N_ELEMENTS(bin2name) EQ 0 THEN bin2name = "ILAT"
  ENDELSE

  IF KEYWORD_SET(saveOutput) THEN BEGIN
     IF N_ELEMENTS(outputFilename) EQ 0 THEN BEGIN
        IF N_ELEMENTS(paramStr) GT 0 THEN BEGIN
           outputFilename                    = paramStr + '.txt'
        ENDIF ELSE BEGIN
           outputFilename                    = 'Output--print_alfvendb_2dhistos--' + GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '.txt'
        ENDELSE
     ENDIF
     PRINTF,lun,'Output filename: ' + outputFilename
     OPENW,outLun,outputFilename,/GET_LUN
  ENDIF ELSE BEGIN
     outLun                                  = lun
  ENDELSE


  ;;Get the ILAT and MLT bin centers
  GET_H2D_BIN_CENTERS_OR_EDGES,centers, $
                               CENTERS1=centersMLT,CENTERS2=centersILAT, $
                               BINSIZE1=bin1, BINSIZE2=bin2, $
                               MAX1=max1, MAX2=max2, $
                               MIN1=min1, MIN2=min2, $
                               SHIFT1=shift2, SHIFT2=shift2, $
                               NBINS1=nBins1, NBINS2=nBins2

  ;Check on the mask
  IF KEYWORD_SET(h2dMask) THEN BEGIN
     IF N_ELEMENTS(h2dMask) NE N_ELEMENTS(h2dStrArr[0].data) THEN BEGIN
        PRINTF,lun,'N elements of h2dMask do not match N elements in h2dStrArr! Check it out.'
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     h2dMask                                 = MAKE_ARRAY(nBins1,nBins2,VALUE=0)
  ENDELSE

  PRINTF,outLun,FORMAT='(A0,T10,A0,T20,"Value ",A0)',bin1name,bin2Name,(KEYWORD_SET(plotMedOrAvg)? '(' + plotMedOrAvg + ')' : '')
  FOR i=0,nH2DtoPrint-1 DO BEGIN  
     PRINTF,outLun,FORMAT='("****",A0,"****")',dataNameArr[i]
     IF KEYWORD_SET(unlog_data) AND h2dStrArr[i].is_logged THEN BEGIN
        PRINTF,lun,'Unlogging ' + h2dStrArr[i].title + ' ...'
        h2dStrArr[i].data                       = 10.^(h2dStrArr[i].data)
        h2dStrArr[i].is_logged                  = 0
     ENDIF

     IF h2dStrArr[i].labelFormat EQ '' OR h2dStrArr[i].labelFormat EQ '(D5.3)' THEN BEGIN
        IF h2dStrArr[i].is_logged THEN BEGIN
           h2dStrArr[i].labelFormat             = 'F0.2'
        ENDIF ELSE BEGIN
           h2dStrArr[i].labelFormat             = 'G0.2'
        ENDELSE
     ENDIF ELSE BEGIN
        ;strip parentheses
        pos                                     = STREGEX(h2dstrarr[i].labelformat,'\((.*)\)',length=len,/SUBEXPR)
        h2dStrArr[i].labelFormat                = STRMID(h2dstrarr[i].labelformat,pos[1],len[1])
     ENDELSE

     fmtStr                                     = '(F0.2,T10,F0.2,T20,'+h2dStrArr[i].labelFormat+')'
     FOR l=0,nBins1-1 DO BEGIN
        FOR m=0,nBins2-1 DO BEGIN
           IF ~h2dMask[l,m] THEN PRINTF,outLun,FORMAT=fmtStr,centersMLT[l,m],centersILAT[l,m],h2dStrArr[i].data[l,m]
        ENDFOR
     ENDFOR

  ENDFOR
  
  nMasked                                       = N_ELEMENTS(WHERE(h2dMask GT 0,/NULL,NCOMPLEMENT=nUnmasked))
  PRINTF,outLun,''
  PRINTF,outLun,'N total values   : ' + STRCOMPRESS(N_ELEMENTS(h2dMask),/REMOVE_ALL)
  PRINTF,outLun,'N unmasked values: ' + STRCOMPRESS(nUnmasked,/REMOVE_ALL)
  PRINTF,outLun,'N masked values  : ' + STRCOMPRESS(nMasked,/REMOVE_ALL)

  IF KEYWORD_SET(saveOutput) THEN BEGIN
     CLOSE,outLun
     FREE_LUN,outLun
  ENDIF
END