;2015/08/25
;Tell me when we have data for 
PRO GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES,T1_ARR=t1_arr,T2_ARR=t2_arr, $
                                        MAXIMUS=maximus,CDBTIME=cdbtime, RESTRICT_W_THESEINDS=restrict, $
                                        OUT_INDS_LIST=inds_list, $
                                        UNIQ_ORBS_LIST=uniq_orbs_list,UNIQ_ORB_INDS_LIST=uniq_orb_inds_list, $
                                        INDS_ORBS_LIST=inds_orbs_list,TRANGES_ORBS_LIST=tranges_orbs_list,TSPANS_ORBS_LIST=tspans_orbs_list, $
                                        PRINT_DATA_AVAILABILITY=print_data_availability, VERBOSE=verbose,LIST_TO_ARR=list_to_arr

  IF KEYWORD_SET(verbose) THEN BEGIN
     PRINT,'GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES'
     print,'N UTC Ranges: ' + N_ELEMENTS(T1_ARR)
  ENDIF

  IF KEYWORD_SET(restrict) THEN BEGIN
     IF KEYWORD_SET(verbose) THEN BEGIN
        PRINT,'Restricting with specified inds...'
        PRINT,'(' + STRCOMPRESS(N_ELEMENTS(restrict),/REMOVE_ALL) + ' inds provided...)'
     ENDIF
     ;; maximus=RESIZE_MAXIMUS(maximus,CDBTIME=cdbtime,inds=restrict)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(verbose) THEN BEGIN
        PRINT,'No restriction on inds...'
     ENDIF
     restrict = INDGEN(N_ELEMENTS(maximus),/L64)
  ENDELSE

  inds_ii = WHERE(cdbTime(restrict) GE t1 AND cdbTime(restrict) LE t2,nInds)
  inds = restrict(inds_ii)

  GET_DATA_AVAILABILITY_FOR_UTC_RANGE,T1=t1_arr[0],T2=t2_arr[0], $
                                      MAXIMUS=maximus,CDBTIME=cdbtime, RESTRICT_W_THESEINDS=restrict, $
                                      OUT_INDS=inds, $
                                      UNIQ_ORBS=uniq_orbs,UNIQ_ORB_INDS=uniq_orb_inds, $
                                      INDS_ORBS=inds_orbs,TRANGES_ORBS=tranges_orbs,TSPANS_ORBS=tspans_orbs, $
                                      PRINT_DATA_AVAILABILITY=print_data_availability, VERBOSE=verbose

  inds_list          = LIST(inds)
  uniq_orbs_list     = LIST(uniq_orbs)
  uniq_orb_inds_list = LIST(uniq_orb_inds)
  inds_orbs_list     = LIST(inds_orbs)
  tranges_orbs_list  = LIST(tranges_orbs)
  tspans_orbs_list   = LIST(tspans_orbs)

  FOR i = 1,N_ELEMENTS(t1_arr)-1 DO BEGIN

     GET_DATA_AVAILABILITY_FOR_UTC_RANGE,T1=t1_arr[i],T2=t2_arr[i], $
                                         MAXIMUS=maximus,CDBTIME=cdbtime, RESTRICT_W_THESEINDS=restrict, $
                                         OUT_INDS=inds, $
                                         UNIQ_ORBS=uniq_orbs,UNIQ_ORB_INDS=uniq_orb_inds, $
                                         INDS_ORBS=inds_orbs,TRANGES_ORBS=tranges_orbs,TSPANS_ORBS=tspans_orbs, $
                                         PRINT_DATA_AVAILABILITY=print_data_availability, VERBOSE=verbose
     inds_list.add,inds
     uniq_orbs_list.add,uniq_orbs
     uniq_orb_inds_list.add,uniq_orb_inds
     inds_orbs_list.add,inds_orbs_list
     tranges_orbs_list.add,tranges_orbs
     tspans_orbs_list.add,tspans_orbs

  ENDFOR
  
  IF KEYWORD_SET(list_to_arr) THEN BEGIN

     inds_arr             = inds_list[0]
     uniq_orbs_arr        = uniq_orbs_list[0]
     uniq_orb_inds_arr    = uniq_orb_inds_list[0]
     inds_orbs_arr        = inds_orbs_list[0]
     tranges_orbs_arr     = tranges_orbs_list[0]
     tspans_orbs_arr      = tspans_orbs_list[0]
     
     FOR i=0,N_ELEMENTS(t1_arr)-1 DO BEGIN
        inds_arr          = [ inds_arr, inds_list[i] ]
        uniq_orbs_arr     = [ uniq_orbs_arr, uniq_orbs_list[i] ]
        uniq_orb_inds_arr = [ uniq_orb_inds_arr, uniq_orb_inds_list[i] ]
        inds_orbs_arr     = [ inds_orbs_arr, inds_orbs_list[i] ]
        tranges_orbs_arr  = [ tranges_orbs_arr, tranges_orbs_list[i] ]
        tspans_orbs_arr   = [ tspans_orbs_arr, tspans_orbs_list[i] ]
     ENDFOR

     inds_list            = inds_arr
     uniq_orbs_list       = uniq_orbs_arr
     uniq_orb_inds_list   = uniq_orb_inds_arr
     inds_orbs_list       = inds_orbs_arr
     tranges_orbs_list    = tranges_orbs_arr
     tspans_orbs_list     = tspans_orbs_arr
     
  ENDIF

END