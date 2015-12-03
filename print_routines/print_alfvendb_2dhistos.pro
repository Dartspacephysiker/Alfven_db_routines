;;2015/12/02 Just show us wassup
PRO PRINT_ALFVENDB_2DHISTOS, $
   H2DSTRARR=h2dStrArr, $
   DATANAMEARR=dataNameArr, $
   HEMI=hemi, $
   MIN1=min1, $
   MIN2=min2, $
   MAX1=max1, $
   MAX2=max2, $
   BIN1=bin1, $
   BIN2=bin2, $
   BIN1NAME=bin1name, $
   BIN2NAME=bin2name, $
   LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout
  
  IF N_ELEMENTS(bin1name) EQ 0 THEN bin1name = "MLT"
  IF N_ELEMENTS(bin2name) EQ 0 THEN bin2name = "ILAT"

  ;;get the bins
  nBins1   = (max1-min1)/bin1+1L
  nBins2   = (max2-min2)/bin2+1L

  ;;get bin centers
  bins1    = INDGEN(nBins1)*bin1 + min1
  bins1    = (bins1[1:-1] + bins1[0:-2])/2.0

  bins2    = INDGEN(nBins2)*bin2 + min2
  bins2    = (bins2[1:-1] + bins2[0:-2])/2.0

  PRINTF,lun,FORMAT='(A0," (bin center)",T30,A0," (bin center)")'
  FOR i = 0, N_ELEMENTS(h2dStrArr) - 2 DO BEGIN  
     PRINTF,lun,FORMAT='("****",A0,"****")',dataNameArr[i]

     FOR l = 0, N_ELEMENTS(bins1)-1 DO BEGIN

        nb2rem = N_ELEMENTS(bins2)
        WHILE nb2rem GT 0 DO BEGIN
           nbTemp = 5 < nb2rem
           FOR m = 0, nbTemp-1 DO BEGIN
              fmtStr
           ENDFOR
           nb2rem -= nbTemp
        ENDWHILE
     ENDFOR

  ENDFOR

END