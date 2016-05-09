;2016/05/09
;;Take plots for multiple IMF conditions, organize into one type
PRO REARRANGE_H2DSTRARR_LIST_INTO_LIKE_PLOTS,h2dStrArr_list,dataNameArr_list,dataRawPtrArr_list,paramString_list, $
   HAS_NPLOTS=has_nplots, $
   NEW_PARAMSTR_FOR_LIKE_PLOTARRS=new_paramStr_for_like_plotArrs, $
   SCALE_LIKE_PLOTS_FOR_TILING=scale_like_plots_for_tiling, $
   DO_REARRANGE_DATARAWPTRARR_LIST=do_rearrange_dataRawPtrArr_list, $
   OUT_MASK_H2DSTRARR=out_mask_h2dStrArr

  COMPILE_OPT idl2

  ;;First, how many plots here?
  nConditions              = N_ELEMENTS(h2dStrArr_list)
  nQuantities              = N_ELEMENTS(h2dStrArr_list[0])

  new_h2dStrArr_list       = LIST()
  new_dataNameArr_list     = LIST()
  new_dataRawPtrArr_list   = LIST()
  new_paramString_list     = LIST()

  ;;Pick up masks
  tempQuantH2DArr       = !NULL
  ;; tempDataNameArr       = !NULL
  ;; tempDataRawPtrArr     = !NULL
  FOR iCond=0,nConditions-1 DO BEGIN
     tempQuantH2DArr    = [tempQuantH2DArr,h2dStrArr_list[iCond,KEYWORD_SET(has_nPlots)]]
     ;; tempDataNameArr    = [tempDataNameArr,dataNameArr_list[iCond,KEYWORD_SET(has_nPlots)]]
     ;; tempDataRawPtrArr  = [tempDataRawPtrArr,dataRawPtrArr_list[iCond,KEYWORD_SET(has_nPlots)]]
  ENDFOR
  out_mask_h2dStrArr    = tempQuantH2DArr


  ;;Get nPlots, if present
  IF KEYWORD_SET(has_nPlots) THEN BEGIN
     tempQuantH2DArr       = !NULL
     tempDataNameArr       = !NULL
     tempDataRawPtrArr     = !NULL
     
     currentMax            = MAX(h2dStrArr_list[0,0].data[WHERE(out_mask_h2dStrArr[0].data LT 1)],MIN=currentMin)

     ;;Pick up nPlots
     FOR iCond=0,nConditions-1 DO BEGIN
        tempQuantH2DArr    = [tempQuantH2DArr,h2dStrArr_list[iCond,0]]
        tempDataNameArr    = [tempDataNameArr,dataNameArr_list[iCond,0]]
        IF KEYWORD_SET(do_rearrange_dataRawPtrArr_list) THEN tempDataRawPtrArr  = [tempDataRawPtrArr,dataRawPtrArr_list[iCond,0]]

        tempMax            = MAX(h2dStrArr_list[iCond,0].data[WHERE(out_mask_h2dStrArr[iCond].data LT 1)],MIN=tempMin)
        IF tempMax GT currentMax THEN currentMax = tempMax
        IF tempMin LT currentMin THEN currentMin = tempMin
     ENDFOR

     IF KEYWORD_SET(scale_like_plots_for_tiling) THEN BEGIN
        FOR iCond=0,nConditions-1 DO BEGIN
           tempQuantH2DArr[iCond].lim = [currentMin,currentMax]
        ENDFOR

        fmt    = 'G10.4' 
        PRINT,tempQuantH2DArr[0].title
        ;; PRINTF,lun,FORMAT='("Max, min:",T20,F10.2,T35,F10.2)', $
        ;;        MAX(h2dStr.data[h2d_nonzero_nEv_i]), $
        ;;        MIN(h2dStr.data[h2d_nonzero_nEv_i])
        PRINT,FORMAT='("Scaled Max, min. :",T20,' + fmt + ',T35,' + fmt + ',T50,' + fmt +')', $
              currentMax, $
              currentMin
     ENDIF

     new_h2dStrArr_list.add,tempQuantH2DArr
     new_dataNameArr_list.add,tempDataNameArr
     IF KEYWORD_SET(do_rearrange_dataRawPtrArr_list) THEN new_dataRawPtrArr_list.add,tempDataRawPtrArr
     new_paramString_list.add,new_paramStr_for_like_plotArrs + "_" + tempDataNameArr[0]

  ENDIF

  ;;Now the rest
  FOR iQuant=1+KEYWORD_SET(has_nPlots),nQuantities-1 DO BEGIN
     tempQuantH2DArr       = !NULL
     tempDataNameArr       = !NULL
     tempDataRawPtrArr     = !NULL

     currentMax            = MAX(h2dStrArr_list[0,iQuant].data[WHERE(out_mask_h2dStrArr[0].data LT 1)],MIN=currentMin)

     FOR iCond=0,nConditions-1 DO BEGIN
        tempQuantH2DArr    = [tempQuantH2DArr,h2dStrArr_list[iCond,iQuant]]
        tempDataNameArr    = [tempDataNameArr,dataNameArr_list[iCond,iQuant]]
     IF KEYWORD_SET(do_rearrange_dataRawPtrArr_list) THEN tempDataRawPtrArr  = [tempDataRawPtrArr,dataRawPtrArr_list[iCond,iQuant]]

        tempMax            = MAX(h2dStrArr_list[iCond,iQuant].data[WHERE(out_mask_h2dStrArr[iCond].data LT 1)],MIN=tempMin)
        IF tempMax GT currentMax THEN currentMax = tempMax
        IF tempMin LT currentMin THEN currentMin = tempMin

     ENDFOR

     IF KEYWORD_SET(scale_like_plots_for_tiling) THEN BEGIN
        FOR iCond=0,nConditions-1 DO BEGIN
           tempQuantH2DArr[iCond].lim = [currentMin,currentMax]
        ENDFOR

        fmt    = 'G10.4' 
        PRINT,tempQuantH2DArr[0].title
        ;; PRINTF,lun,FORMAT='("Max, min:",T20,F10.2,T35,F10.2)', $
        ;;        MAX(h2dStr.data[h2d_nonzero_nEv_i]), $
        ;;        MIN(h2dStr.data[h2d_nonzero_nEv_i])
        PRINT,FORMAT='("Scaled Max, min. :",T20,' + fmt + ',T35,' + fmt + ',T50,' + fmt +')', $
              currentMax, $
              currentMin
     ENDIF

     new_h2dStrArr_list.add,tempQuantH2DArr
     new_dataNameArr_list.add,tempDataNameArr
     IF KEYWORD_SET(do_rearrange_dataRawPtrArr_list) THEN new_dataRawPtrArr_list.add,tempDataRawPtrArr
     new_paramString_list.add,new_paramStr_for_like_plotArrs + "_" + tempDataNameArr[0]
  ENDFOR


  ;Now replace
  h2dStrArr_list           = new_h2dStrArr_list
  dataNameArr_list         = new_dataNameArr_list
  IF KEYWORD_SET(do_rearrange_dataRawPtrArr_list) THEN dataRawPtrArr_list = new_dataRawPtrArr_list
  paramString_list         = new_paramString_list

  HEAP_GC

END