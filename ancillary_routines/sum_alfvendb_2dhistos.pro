;;Get some sums
PRO SUM_ALFVENDB_2DHISTOS, $
   H2DSTRARR=h2dStrArr, $
   H2DMASK=h2dMask, $
   DATANAMEARR=dataNameArr, $
   FILE_TO_READ=file_to_read, $
   HEMI=hemi, $
   MINM_SUM=minM_sum, $
   MINI_SUM=minI_sum, $
   MAXM_SUM=maxM_sum, $
   MAXI_SUM=maxI_sum, $
   BIN1NAME=bin1name, $
   BIN2NAME=bin2name, $
   ;; PRINT_STATS=print_stats, $
   PRINT_LOGSTATS=print_logStats, $
   PRINT_SUM_CONSTITUENTS=print_sum_constituents, $
   SAVEOUTPUT=saveOutput, $
   OUTPUTFILENAME=outputFilename, $
   ;; UNLOG_DATA=unlog_data, $
   LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun           = -1 ;stdout
  
  IF N_ELEMENTS(print_stats) EQ 0 THEN print_stats = 1

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

  ;;Set up boundaries
  IF N_ELEMENTS(minM_sum) EQ 0 THEN minM_sum = minM
  IF N_ELEMENTS(maxM_sum) EQ 0 THEN maxM_sum = maxM

  IF N_ELEMENTS(minI_sum) EQ 0 THEN minI_sum = minI
  IF N_ELEMENTS(maxI_sum) EQ 0 THEN maxI_sum = maxI

  PRINTF,lun,"*****Params for summing*****"
  PRINTF,lun,FORMAT='("Min MLT",T20,": ",F0.2)',minM_sum
  PRINTF,lun,FORMAT='("Max MLT",T20,": ",F0.2)',maxM_sum
  PRINTF,lun,""
  PRINTF,lun,FORMAT='("Min ILAT",T20,": ",F0.2)',minI_sum
  PRINTF,lun,FORMAT='("Max ILAT",T20,": ",F0.2)',maxI_sum
  ;;Get the indices
  notMasked_i                                   = WHERE(h2dMask LT 1,nNotMasked,COMPLEMENT=masked_i,NCOMPLEMENT=nMasked)
  IF notMasked_i[0] EQ -1 THEN BEGIN
     PRINTF,lun,"No unmasked indices!"
     STOP
  ENDIF ELSE BEGIN
     PRINTF,outLun,FORMAT='("N values",T20,": ",I0)',N_ELEMENTS(h2dMask)
     PRINTF,outLun,FORMAT='("N notMasked values",T20,": ",I0)',nNotMasked
     PRINTF,outLun,FORMAT='("N masked values",T20,": ",I0)',nMasked
  ENDELSE

  mlt_i                                         = GET_MLT_INDS(!NULL,minM_sum,maxM_sum, $
                                                               DIRECT_MLTS=centersMLT)
  IF mlt_i[0] EQ -1 THEN BEGIN
     PRINTF,lun,"No indices for MLTs in requested range!"
     STOP
  ENDIF

  ilat_i                                        = GET_ILAT_INDS(!NULL,minI_sum,maxI_sum,hemi, $
                                                                DIRECT_LATITUDES=centersILAT)
  IF mlt_i[0] EQ -1 THEN BEGIN
     PRINTF,lun,"No indices for ILATs in requested range!"
     STOP
  ENDIF

  good_i                                        = CGSETINTERSECTION(mlt_i,ilat_i)
  IF good_i[0] EQ -1 THEN BEGIN
     PRINTF,lun,"No indices meeting both MLT and ILAT criteria"
     STOP
  ENDIF

  good_i                                        = CGSETINTERSECTION(good_i,notMasked_i)
  IF good_i[0] EQ -1 THEN BEGIN
     PRINTF,lun,"No indices that are both unmasked and meet MLT/ILAT criteria"
     STOP
  ENDIF
  nGood                                         = N_ELEMENTS(good_i)
  ;; good_i                                        = WHERE(centersMLT GE minM_sum AND centersMLT LE maxM_sum AND $
  ;;                                                       centersILAT GE minI_sum AND centersILAT LE maxI_sum AND $
  ;;                                                       h2dMask LT 1,nGood)
  ;; IF good_i[0] EQ -1 THEN BEGIN
  ;;    PRINTF,lun,"No bins match all requested params! Better narrow your requirements."
  ;;    RETURN
  ;; ENDIF

  PRINTF,lun,FORMAT='("N good bins",T20,": ",I0)',nGood
  PRINTF,lun,''

  FOR i=0,nH2DtoPrint-1 DO BEGIN  
     PRINTF,outLun,FORMAT='("****",A0,"****")',dataNameArr[i]

     ;; IF KEYWORD_SET(unlog_data) AND h2dStrArr[i].is_logged THEN BEGIN
     ;;    PRINTF,lun,'Unlogging ' + h2dStrArr[i].title + ' ...'
     ;;    h2dStrArr[i].data                       = 10.0D^(h2dStrArr[i].data)
     ;;    h2dStrArr[i].is_logged                  = 0
     ;; ENDIF

     ;;calculate sum and log sum
     IF KEYWORD_SET(h2dStrArr[i].is_logged) THEN BEGIN
        sum                                     = TOTAL(10.0D^(h2dStrArr[i].data[good_i]))
        stats                                   = MOMENT(10.0D^(h2dStrArr[i].data[good_i]))
        stats                                   = [stats,MEDIAN(10.0D^(h2dStrArr[i].data[good_i]))]

        logSum                                  = TOTAL(h2dStrArr[i].data[good_i])
        logStats                                = MOMENT(h2dStrArr[i].data[good_i])
        logStats                                = [logStats,MEDIAN(h2dStrArr[i].data[good_i])]
     ENDIF ELSE BEGIN

        sum                                     = TOTAL(h2dStrArr[i].data[good_i])
        stats                                   = MOMENT(h2dStrArr[i].data[good_i])
        stats                                   = [stats,MEDIAN(h2dStrArr[i].data[good_i])]

        neg_i                                   = WHERE(h2dStrArr[i].data LT 0)
        IF neg_i[0] NE -1 THEN BEGIN
           tempData                             = CONV_QUANTITY_TO_POS_NEG_OR_ABS(h2dStrArr[i].data[good_i],QUANTITY_NAME=h2dStrArr[i].title)
        ENDIF
        logSum                                  = TOTAL(ALOG10(tempData))
        logStats                                = MOMENT(ALOG10(tempData))
        logStats                                = [logStats,MEDIAN(ALOG10(tempData))]
     ENDELSE

     PRINTF,outLun,FORMAT='("N",T10,"Mean",T20,"Std. dev.",T30,"Skewness",T40,"Kurtosis",T50,"Median",T60,"Sum")'

     ;;All dat printing
     IF KEYWORD_SET(print_stats) THEN BEGIN
        PRINTF,outLun,"-->Regular statistics"
        
        PRINTF,outLun,FORMAT='("***",I4," : ",A0,"***")',i,h2dStrArr[i].title
        PRINTF,outLun,FORMAT='(I0,T10,G9.4,T20,G9.4,T30,G9.4,T40,G9.4,T50,G9.4,T60,G9.4)', $
               nGood, $
               stats[0], $
               SQRT(stats[1]), $
               stats[2], $
               stats[3], $
               stats[4], $
               sum

        PRINTF,outLun,''
     ENDIF

     IF KEYWORD_SET(print_logStats) THEN BEGIN
        PRINTF,outLun,"-->Log statistics"
        PRINTF,outLun,FORMAT='("N",T10,"Mean",T20,"Std. dev.",T30,"Skewness",T40,"Kurtosis",T50,"Median",T60,"Sum")'
        
        PRINTF,outLun,FORMAT='("***",I4," : ",A0,"***")',i,h2dStrArr[i].title
        PRINTF,outLun,FORMAT='(I0,T10,G9.4,T20,G9.4,T30,G9.4,T40,G9.4,T50,G9.4,T60,G9.4)', $
               nGood, $
               logStats[0], $
               SQRT(logStats[1]), $
               logStats[2], $
               logStats[3], $
               logStats[4], $
               logSum

        PRINTF,outLun,''

     ENDIF

     IF KEYWORD_SET(print_sum_constituents) THEN BEGIN
        PRINTF,outLun,'**Sum constituents**'
        PRINTF,outLun,FORMAT='(A0,T10,A0,T20,"Value ",A0)',bin1name,bin2Name,(KEYWORD_SET(plotMedOrAvg)? '(' + plotMedOrAvg + ')' : '')
        IF h2dStrArr[i].labelFormat EQ '' OR h2dStrArr[i].labelFormat EQ '(D5.3)' THEN BEGIN
           IF h2dStrArr[i].is_logged THEN BEGIN
              h2dStrArr[i].labelFormat          = 'F0.2'
           ENDIF ELSE BEGIN
              h2dStrArr[i].labelFormat          = 'G0.2'
           ENDELSE
        ENDIF ELSE BEGIN
                                ;strip parentheses
           pos                                  = STREGEX(h2dStrArr[i].labelformat,'\((.*)\)',length=len,/SUBEXPR)
           h2dStrArr[i].labelFormat             = STRMID(h2dStrArr[i].labelformat,pos[1],len[1])
        ENDELSE
        
        fmtStr                                  = '(F0.2,T10,F0.2,T20,'+h2dStrArr[i].labelFormat+')'
        FOR l=0,nGood-1 DO BEGIN
           IF ~h2dMask[good_i[l]] THEN PRINTF,outLun,FORMAT=fmtStr,centersMLT[good_i[l]],centersILAT[good_i[l]],h2dStrArr[i].data[good_i[l]]
        ENDFOR
        PRINTF,outLun,''
     ENDIF
  ENDFOR
  
  PRINTF,outLun,''

  IF KEYWORD_SET(saveOutput) THEN BEGIN
     CLOSE,outLun
     FREE_LUN,outLun
  ENDIF
END