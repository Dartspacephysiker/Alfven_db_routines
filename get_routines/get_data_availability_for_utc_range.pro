;2015/08/25
;Tell me when we have data for 
PRO GET_DATA_AVAILABILITY_FOR_UTC_RANGE,T1=t1,T2=t2, $
                                        DBSTRUCT=dbStruct,DBTIMES=dbTimes, RESTRICT_W_THESEINDS=restrict, $
                                        OUT_INDS=inds, $
                                        UNIQ_ORBS=uniq_orbs,UNIQ_ORB_INDS=uniq_orb_inds, $
                                        INDS_ORBS=inds_orbs,TRANGES_ORBS=tranges_orbs,TSPANS_ORBS=tspans_orbs, $
                                        PRINT_DATA_AVAILABILITY=print_data_availability, VERBOSE=verbose

  IF KEYWORD_SET(verbose) THEN BEGIN
     PRINT,'GET_DATA_AVAILABILITY_FOR_UTC_RANGE'
     print,'UTC Range: ' + TIME_TO_STR(t1) + ' through ' + TIME_TO_STR(t2)
  ENDIF

  IF KEYWORD_SET(restrict) THEN BEGIN
     IF KEYWORD_SET(verbose) THEN BEGIN
        PRINT,'Restricting with specified inds...'
        PRINT,'(' + STRCOMPRESS(N_ELEMENTS(restrict),/REMOVE_ALL) + ' inds provided...)'
     ENDIF
     ;; dbStruct=RESIZE_MAXIMUS(dbStruct,CDBTIME=dbTimes,inds=restrict)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(verbose) THEN BEGIN
        PRINT,'No restriction on inds...'
     ENDIF
     restrict = INDGEN(N_ELEMENTS(dbStruct),/L64)
  ENDELSE

  inds_ii = WHERE(dbTimes(restrict) GE t1 AND dbTimes(restrict) LE t2,nInds)
  IF inds_ii[0] EQ -1 THEN BEGIN

     inds = -1

     uniq_orb_inds = -1
     uniq_orbs = -1
     nUniq_orbs = 0

     inds_orbs = -1
     tRanges_orbs = -1

  ENDIF ELSE BEGIN

     inds = restrict(inds_ii)

     uniq_orb_inds_ii = UNIQ(dbStruct.orbit(inds))
     uniq_orb_inds = inds(uniq_orb_inds_ii)

     uniq_orbs = dbStruct.orbit(uniq_orb_inds)
     nUniq_orbs = N_ELEMENTS(uniq_orb_inds)
     
     inds_orbs = MAKE_ARRAY(nUniq_orbs,2,/L64)
     tranges_orbs = MAKE_ARRAY(nUniq_orbs,2,/DOUBLE)
     tspans_orbs = MAKE_ARRAY(nUniq_orbs,/DOUBLE)
     
     FOR i=0,nUniq_orbs-1 DO BEGIN
        orb = uniq_orbs[i]

        orbInds_ii = WHERE(dbStruct.orbit(inds) EQ orb)
        orbInds = inds(orbInds_ii)

        IF KEYWORD_SET(verbose) THEN BEGIN
           PRINT,'Checking out orb' + STRCOMPRESS(orb,/REMOVE_ALL) + '  (' + STRCOMPRESS(i,/REMOVE_ALL) + ' / ' + STRCOMPRESS(nUniq_orbs-1,/REMOVE_ALL) + ')'
           PRINT,'nInds : ' + STRCOMPRESS(N_ELEMENTS(orbInds),/REMOVE_ALL)
           PRINT,''
        ENDIF

        IF orbInds_ii[0] NE -1 THEN orbMin = MIN(dbTimes(orbInds),orbMin_ii,MAX=orbMax,SUBSCRIPT_MAX=orbMax_ii)
        
        inds_orbs[i,0] = orbInds(orbMin_ii)
        inds_orbs[i,1] = orbInds(orbMax_ii)

        tranges_orbs[i,0] = orbMin
        tranges_orbs[i,1] = orbMax
        
        tspans_orbs[i] = orbMax - orbMin
     ENDFOR
     
  ENDELSE

  IF KEYWORD_SET(print_data_availability) THEN BEGIN
     PRINT_DATA_AVAILABILITY_FOR_UTC_RANGE,T1=t1,T2=t2, $
                                           UNIQ_ORBS=uniq_orbs,UNIQ_ORB_INDS=uniq_orb_inds, $
                                           INDS_ORBS=inds_orbs,TRANGES_ORBS=tranges_orbs,TSPANS_ORBS=tspans_orbs, $
                                           /SUMMARY
  ENDIF

END