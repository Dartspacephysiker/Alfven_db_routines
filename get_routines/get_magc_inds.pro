FUNCTION GET_MAGC_INDS,maximus,minMC,maxNegMC, $
                       N_OUTSIDE_MAGC=n_magc_outside_range, $
                       MAGC_I_GE_MINMC=magc_i_ge_minMC, $
                       MAGC_I_LE_NEGMC=magc_i_le_NegMC, $
                       MAGC_I_IN_RANGE=magc_i_in_range, $
                       UNMAP_IF_MAPPED=unmap_if_mapped, $
                       LUN=lun

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF KEYWORD_SET(unmap_if_mapped) THEN BEGIN
     IF maximus.info.mapped.mag_current THEN BEGIN
        PRINT,"Temporarily unmapping mag_current for screening ..."
        LOAD_MAPPING_RATIO_DB,mapRatio, $
                              DESPUNDB=maximus.info.despun, $
                              CHASTDB=maximus.info.is_chastDB
        maximus.mag_current /= mapRatio.ratio
     ENDIF
  ENDIF

  magc_i_ge_minMC = WHERE(maximus.mag_current GE minMC)
  magc_i_le_NegMC = WHERE(maximus.mag_current LE maxNegMC)
  magc_i          = WHERE(maximus.mag_current LE maxNegMC OR $
                          maximus.mag_current GE minMC, $
                          NCOMPLEMENT=n_magc_outside_range)

  ;;LOOK OUT! Flipping the situation
  ;; magc_i_ge_minMC=WHERE(maximus.mag_current LE minMC)
  ;; magc_i_le_NegMC=WHERE(maximus.mag_current GE maxNegMC)
  ;; magc_i=WHERE(maximus.mag_current GE maxNegMC AND maximus.mag_current LE minMC,NCOMPLEMENT=n_magc_outside_range)

  IF KEYWORD_SET(unmap_if_mapped) THEN BEGIN
     IF maximus.info.mapped.mag_current THEN BEGIN
        PRINT,"Re-mapping mag_current ..."
        maximus.mag_current *= (TEMPORARY(mapRatio)).ratio
     ENDIF
  ENDIF

  PRINTF,lun,FORMAT='("N lost to current thresh      :",T35,I0)',n_magc_outside_range
  PRINTF,lun,''

  RETURN,magc_i

END