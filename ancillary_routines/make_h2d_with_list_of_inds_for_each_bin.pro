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

  COMPILE_OPT idl2,strictarrsubs

  DEBUG = 1

  ;;Because MAKE_H2D_WITH_LIST_OF_OBS_AND_OBS_STATISTICS wants to use 'em too
  COMMON H2D_LIST_OF_INDS,HLOI__H2D_lists_with_inds,HLOI__nInds,HLOI__nMLT,HLOI__nILAT,HLOI__H2D_binCenters

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF N_ELEMENTS(HLOI__H2D_lists_with_inds) GT 0 THEN BEGIN
     IF KEYWORD_SET(reset_H2D_lists_with_inds) THEN BEGIN
        PRINTF,lun,"Resetting H2D_lists_with_inds ..."
     ENDIF ELSE BEGIN
        PRINTF,lun,"Already have an H2D_list_with_inds! Passing it over and stepping out ..."
        outH2D_lists_with_inds     = HLOI__H2D_lists_with_inds
        RETURN
     ENDELSE
  ENDIF

  ;;Keep track of hvor mange
  nInds   = 0
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;SET UP GRID
  CASE 1 OF
     KEYWORD_SET(alfDB_plot_struct.EA_binning): BEGIN

        @common__ea_binning.pro

        IF N_ELEMENTS(EA__s) EQ 0 THEN BEGIN
           LOAD_EQUAL_AREA_BINNING_STRUCT,HEMI=MIMC_struct.hemi
        ENDIF

        nILAT                  = N_ELEMENTS(EA__s.minI)
        nMLT                   = N_ELEMENTS(EA__s.minM)
        outH2D_lists_with_inds = MAKE_ARRAY(nMLT,/OBJ)

     END
     ELSE: BEGIN
        CASE 1 OF
           KEYWORD_SET(MIMC_struct.use_Lng): BEGIN
              nXlines  = (MIMC_struct.maxLng-MIMC_struct.minLng)/MIMC_struct.binLng + 1
              mlts     = INDGEN(nXlines)*MIMC_struct.binLng+MIMC_struct.minLng
           END
           ELSE: BEGIN
              nXlines  = (MIMC_struct.maxM-MIMC_struct.minM)/MIMC_struct.binM + 1
              mlts     = INDGEN(nXlines)*MIMC_struct.binM+MIMC_struct.minM
           END
        ENDCASE
        nYlines  = ((KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.maxLshell : MIMC_struct.maxI)-(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.minLshell : MIMC_struct.minI))/ $
                   (KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.binLshell : MIMC_struct.binI) + 1

        ilats    = INDGEN(nYlines)*(KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.binLshell : MIMC_struct.binI) + $
                   (KEYWORD_SET(MIMC_struct.do_lShell) ? MIMC_struct.minLshell : MIMC_struct.minI)

        nMLT    = N_ELEMENTS(mlts)
        nILAT   = N_ELEMENTS(ilats)

        outH2D_lists_with_inds = MAKE_ARRAY(nMLT,nILAT,/OBJ)

     END
  ENDCASE
  ;; outH2D_lists_with_inds  = MAKE_ARRAY(nMLT,nILAT,/DOUBLE) ;how long FAST spends in each bin

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;fix MLTs, if need be
  IF N_ELEMENTS(in_mlts) GT 0 THEN BEGIN
     indices   = in_inds
     DBMLTs    = SHIFT_MLTS_FOR_H2D(!NULL,!NULL, $
                                    (KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.shiftLng : MIMC_struct.shiftM), $
                                    IN_MLTS=in_MLTs[in_inds], $
                                    SHIFTM_IS_SHIFTLNG=MIMC_struct.use_Lng)
     DBILATs   = in_ILATs[in_inds]
  ENDIF ELSE BEGIN
     indices   = dbStruct_inds
     DBMLTs    = SHIFT_MLTS_FOR_H2D(dbStruct, $
                                    dbStruct_inds, $
                                    (KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.shiftLng : MIMC_struct.shiftM), $
                                    SHIFTM_IS_SHIFTLNG=MIMC_struct.use_Lng)
     DBILATs   = (KEYWORD_SET(MIMC_struct.do_lShell) ? dbStruct.lShell : dbStruct.ILAT)[dbStruct_inds]
  ENDELSE

  IF KEYWORD_SET(MIMC_struct.both_hemis) THEN DBILATs = ABS(DBILATs)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;loop over MLTs and ILATs

  ;; outH2D_lists_with_obs                 = !NULL
  IF KEYWORD_SET(fill_with_indices_into_plot_i) THEN BEGIN
     loopInds                              = INDGEN(N_ELEMENTS(KEYWORD_SET(in_MLTs) ? in_inds : dbStruct_inds),/LONG)
  ENDIF ELSE BEGIN
     loopInds                              = (KEYWORD_SET(in_mlts) ? in_inds : dbStruct_inds)
  ENDELSE
  IF DEBUG THEN finalInds                  = !NULL

  CASE 1 OF
     KEYWORD_SET(alfDB_plot_struct.EA_binning): BEGIN

        latSwitch_i  = [0,WHERE((EA__s.mini[1:-1]-EA__s.mini[0:-2]) NE 0),N_ELEMENTS(EA__s.mini)-1] ;Because rows of latitudes are of unequal lengths

        nLatSwitch   = N_ELEMENTS(latSwitch_i)

        FOR k=0,nLatSwitch-2 DO BEGIN

           tmpInds   = [latSwitch_i[k]:(latSwitch_i[k+1]-1)]
           nTmpInds  = N_ELEMENTS(tmpInds)

           FOR kk=0,nTmpInds-1 DO BEGIN
              inds   = WHERE((DBMLTs GE EA__s.minM[tmpInds[kk]]) AND $
                             ( EA__s.maxM[tmpInds[kk]] EQ MAX(EA__s.maxM) ? $
                               (DBMLTs LE EA__s.maxM[tmpInds[kk]])        : $
                               (DBMLTs LT EA__s.maxM[tmpInds[kk]])) AND $
                             (DBILATs GE EA__s.minI[tmpInds[kk]]) AND $
                             ( EA__s.maxI[tmpInds[kk]] EQ MAX(EA__s.maxI) ? $
                               (DBILATs LE EA__s.maxI[tmpInds[kk]])       : $
                               (DBILATs LT EA__s.maxI[tmpInds[kk]])), $
                             nTemp, $
                             /NULL)

              tempIndsList                        = LIST(inds)

              ;;Whether empty or not, add to the array of lists
              outH2D_lists_with_inds[tmpInds[kk]] = tempIndsList
              nInds                              += nTemp

              IF DEBUG THEN finalInds             = [finalInds,inds] ;;debug

           ENDFOR
        ENDFOR        

        ;;Last by hand; necessary because I use latSwitch_i instead of something more s'fissicated
        inds         = WHERE((DBMLTs GE EA__s.minM[latSwitch_i[-1]]) AND (DBMLTs LT EA__s.maxM[latSwitch_i[-1]]) AND $
                             (DBILATs GE EA__s.minI[latSwitch_i[-1]]) AND (DBILATs LT EA__s.maxI[latSwitch_i[-1]]), $
                             nTemp, $
                             /NULL)
        nInds       += nTemp
        tempIndsList = LIST(inds)

        IF DEBUG THEN BEGIN 
           finalInds = [finalInds,inds] ;;debug
        ENDIF

     END
     ELSE: BEGIN

        FOR j=0, nILAT-2 DO BEGIN
           FOR i=0, nMLT-2 DO BEGIN
              ;; inds                               = indices[WHERE(DBMLTs GE mlts[i] AND $
              inds = loopInds[ $
                     WHERE( $
                     DBMLTs GE mlts[i] AND $
                     (mlts[i+1] EQ MAX(mlts) ? (DBMLTs LE mlts[i+1]) : (DBMLTs LT mlts[i+1])) AND $
                     DBILATs GE ilats[j] AND $
                     (ilats[j+1] EQ MAX(ilats) ? (DBILATs LT ilats[j+1]) : (DBILATs LT ilats[j+1])), $
                     nTemp,/NULL)]

              ;;Handle edges
              ;; CASE 1 OF
              ;;    ( (i EQ (nMLT - 1)) AND (j EQ (nILAT - 1))): BEGIN
              ;;       inds = [inds,WHERE(DBMLTs EQ mlts[i+1] AND $
              ;;                          DBILATs EQ ilats[j+i],nBonus,/NULL)]
              ;;       nTemp += nBonus
              ;;    END
              ;;    (i EQ (nMLT - 1)): BEGIN
              ;;       inds = [inds,WHERE(DBMLTs EQ mlts[i+1] AND $
              ;;                          DBILATs GE ilats[j] AND $
              ;;                          DBILATs LT ilats[j+i],nBonus,/NULL)]
              ;;       nTemp += nBonus
              ;;    END
              ;;    (j EQ (nILAT - 1)): BEGIN
              ;;       inds = [inds,WHERE(DBILATs EQ ilats[j+1] AND $
              ;;                          DBMLTs GE mlts[i] AND $
              ;;                          DBMLTs LT mlts[i+i],nBonus,/NULL)]
              ;;       nTemp += nBonus
              ;;    END
              ;;    ELSE: 
              ;; ENDCASE

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

     END
  ENDCASE

  ;;Get bin centers
  GET_H2D_BIN_CENTERS_OR_EDGES,HLOI__H2D_binCenters, $
                               EQUAL_AREA_BINNING=alfDB_plot_struct.EA_binning, $
                               BINSIZE1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.binLng : MIMC_struct.binM), $
                               BINSIZE2=MIMC_struct.binI, $
                               MIN1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.minLng : MIMC_struct.minM), $
                               MIN2=MIMC_struct.minI,$
                               MAX1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.maxLng : MIMC_struct.maxM), $
                               MAX2=MIMC_struct.maxI,  $
                               SHIFT1=(KEYWORD_SET(MIMC_struct.use_Lng) ? MIMC_struct.shiftLng : MIMC_struct.shiftM), $
                               SHIFT2=MIMC_struct.shiftI, $
                               OMIN1=Omin1,OMIN2=Omin2, $
                               OMAX1=Omax1,OMAX2=Omax2,  $
                               OBIN1=Obin1,OBIN2=Obin2, $
                               NBINS1=nBins1,NBINS2=nBins2, $
                               BINEDGE1=Binedge1,BINEDGE2=Binedge2



  ;Now reform the sucker
  ;; outH2D_lists_with_inds                   = REFORM(outH2D_lists_with_inds,nMLT,nILAT)
  
  ;; IF ~ARRAY_EQUAL(LIST_TO_1DARRAY(tempIndsList),indices[SORT(indices)]) THEN STOP
  IF DEBUG THEN BEGIN
     IF KEYWORD_SET(fill_with_indices_into_plot_i) THEN BEGIN
        compInds  = ((KEYWORD_SET(in_mlts) ? in_inds : dbStruct_inds))[finalInds]
     ENDIF ELSE BEGIN
        compInds  = (INDGEN(N_ELEMENTS(KEYWORD_SET(in_MLTs) ? in_inds : dbStruct_inds),/LONG))[finalInds]
     ENDELSE

     IF ~ARRAY_EQUAL(compInds[SORT(compInds)],indices[SORT(indices)]) THEN BEGIN

        why = CGSETDIFFERENCE(indices,compInds,POSITIONS=baaad)
        PRINTF,lun,"Check to see why you can't graduate."
        STOP
     ENDIF

  ENDIF

  HLOI__H2D_lists_with_inds                = outH2D_lists_with_inds
  HLOI__nInds                              = nInds
  HLOI__nMLT                               = nMLT
  HLOI__nILAT                              = nILAT

END