;2016/04/19 Added FILL_WITH_INDICES_INTO_PLOT_I so that I can index into dataRawPtr output from GET_FLUX_PLOTDATA
;;2016/04/15 En route to Vienna from Istanbul. (Turkey rules, by the way, or at least Turkish Airlines does.)
;;Ripped off MAKE_TIMEHIST_DENOMINATOR for this action
PRO MAKE_H2D_WITH_LIST_OF_INDS_FOR_EACH_BIN,dbStruct,dbStruct_inds, $
   IN_INDS=in_inds, $
   IN_MLTS=in_mlts, $
   IN_ILATS=in_ilats, $
   OUTH2D_LISTS_WITH_INDS=outH2D_lists_with_inds, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   IMF_STRUCT=IMF_struct, $
   MIMC_STRUCT=MIMC_struct, $
   ;; OUTFILEPREFIX=outFilePrefix, $
   ;; OUTFILESUFFIX=outFileSuffix, $
   ;; OUTDIR=outDir, $
   ;; OUTPUT_TEXTFILE=output_textFile, $
   FILL_WITH_INDICES_INTO_PLOT_I=fill_with_indices_into_plot_i, $
   RESET_H2D_LISTS_WITH_INDS=reset_H2D_lists_with_inds, $
   LUN=lun

  COMPILE_OPT idl2

  DEBUG = 0

  ;;Because MAKE_H2D_WITH_LIST_OF_OBS_AND_OBS_STATISTICS wants to use 'em too
  COMMON H2D_LIST_OF_INDS,HLOI__H2D_lists_with_inds,HLOI__nInds,HLOI__nMLT,HLOI__nILAT,HLOI__H2D_binCenters

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF N_ELEMENTS(HLOI_H2D_lists_with_inds) GT 0 THEN BEGIN
     IF KEYWORD_SET(reset_H2D_lists_with_inds) THEN BEGIN
        PRINTF,lun,"Resetting H2D_lists_with_inds ..."
     ENDIF ELSE BEGIN
        PRINTF,lun,"Already have an H2D_list_with_inds! Passing it over and stepping out ..."
        outH2D_lists_with_inds     = HLOI__H2D_lists_with_inds
        RETURN
     ENDELSE
  ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;SET UP GRID
  nXlines  = (MIMC_struct.maxM-MIMC_struct.minM)/MIMC_struct.binM + 1
  nYlines  = ((KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.maxLshell : MIMC_struct.maxI)-(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.minLshell : MIMC_struct.minI))/ $
             (KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.binLshell : MIMC_struct.binI) + 1

  mlts     = INDGEN(nXlines)*MIMC_struct.binM+MIMC_struct.minM
  ilats    = INDGEN(nYlines)*(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.binLshell : MIMC_struct.binI) + $
                             (KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.minLshell : MIMC_struct.minI)

  nMLT    = N_ELEMENTS(mlts)
  nILAT   = N_ELEMENTS(ilats)
  nInds   = 0

  ;; outH2D_lists_with_inds  = MAKE_ARRAY(nMLT,nILAT,/DOUBLE) ;how long FAST spends in each bin

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;fix MLTs, if need be
  IF N_ELEMENTS(in_mlts) GT 0 THEN BEGIN
     ;; indices   = in_inds
     DBMLTs    = SHIFT_MLTS_FOR_H2D(!NULL,!NULL,MIMC_struct.shiftM,IN_MLTS=in_MLTs[in_inds])
     DBILATs   = in_ILATs[in_inds]
  ENDIF ELSE BEGIN
     indices   = dbStruct_inds
     DBMLTs    = SHIFT_MLTS_FOR_H2D(dbStruct,dbStruct_inds,MIMC_struct.shiftM)
     DBILATs   = (KEYWORD_SET(MIMC_struct.do_lShell) ? dbStruct.lShell : dbStruct.ILAT)[dbStruct_inds]
  ENDELSE

  IF KEYWORD_SET(MIMC_struct.both_hemis) THEN DBILATs = ABS(DBILATs)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;loop over MLTs and ILATs
  outH2D_lists_with_inds                   = MAKE_ARRAY(nMLT,nILAT,/OBJ)
  ;; outH2D_lists_with_obs                 = !NULL
  IF KEYWORD_SET(fill_with_indices_into_plot_i) THEN BEGIN
     loopInds                              = INDGEN(N_ELEMENTS(KEYWORD_SET(in_MLTs) ? in_inds : dbStruct_inds),/LONG)
  ENDIF ELSE BEGIN
     loopInds                              = (KEYWORD_SET(in_mlts) ? in_inds : dbStruct_inds)
  ENDELSE
  IF DEBUG THEN finalInds                  = !NULL
  FOR j=0, nILAT-2 DO BEGIN
     FOR i=0, nMLT-2 DO BEGIN
        ;; inds                               = indices[WHERE(DBMLTs GE mlts[i] AND $
        inds                               = loopInds[WHERE(DBMLTs GE mlts[i] AND $
                                                            DBMLTs LT mlts[i+1] AND $
                                                            DBILATs GE ilats[j] AND $
                                                            DBILATs LT ilats[j+1],nTemp,/NULL)]
        tempIndsList                       = LIST(inds)


        ;; tempIndsList                       = LIST(WHERE(DBMLTs GE mlts[i] AND $
        ;;                                                 DBMLTs LT mlts[i+1] AND $
        ;;                                                 DBILATs GE ilats[j] AND $
        ;;                                                 DBILATs LT ilats[j+1],nTemp,/NULL))

        ;;Whether empty or not, add to the array of lists
        ;; outH2D_lists_with_inds             = [outH2D_lists_with_inds,tempIndsList]
        outH2D_lists_with_inds[i,j]        = tempIndsList
        nInds                             += nTemp

        IF DEBUG THEN finalInds            = [finalInds,inds] ;;debug

     ENDFOR
  ENDFOR

  ;;Get bin centers
  GET_H2D_BIN_CENTERS_OR_EDGES,HLOI__H2D_binCenters, $
                               BINSIZE1=MIMC_struct.binM, BINSIZE2=MIMC_struct.binI, $
                               MIN1=MIMC_struct.minM, MIN2=MIMC_struct.minI,$
                               MAX1=MIMC_struct.maxM, MAX2=MIMC_struct.maxI,  $
                               SHIFT1=MIMC_struct.shiftM,SHIFT2=MIMC_struct.shiftI, $
                               OMIN1=Omin1, OMIN2=Omin2, $
                               OMAX1=Omax1, OMAX2=Omax2,  $
                               OBIN1=Obin1, OBIN2=Obin2, $
                               NBINS1=nBins1, NBINS2=nBins2, $
                               BINEDGE1=Binedge1, BINEDGE2=Binedge2



  ;Now reform the sucker
  ;; outH2D_lists_with_inds                   = REFORM(outH2D_lists_with_inds,nMLT,nILAT)
  
  IF DEBUG THEN BEGIN
     PRINTF,lun,"Check to make sure you've got 'em all."
     STOP
  ENDIF

  HLOI__H2D_lists_with_inds                = outH2D_lists_with_inds
  HLOI__nInds                              = nInds
  HLOI__nMLT                               = nMLT
  HLOI__nILAT                              = nILAT

END