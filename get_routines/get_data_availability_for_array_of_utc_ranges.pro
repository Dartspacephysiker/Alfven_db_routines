;2015/10/13
;Now I want to get data for a who' lotta ranges!
PRO GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES,T1_ARR=t1_arr,T2_ARR=t2_arr, $
                                        DBSTRUCT=dbStruct,DBTIMES=dbTimes, RESTRICT_W_THESEINDS=restrict, $
                                        OUT_INDS_LIST=inds_list, $
                                        UNIQ_ORBS_LIST=uniq_orbs_list,UNIQ_ORB_INDS_LIST=uniq_orb_inds_list, $
                                        INDS_ORBS_LIST=inds_orbs_list,TRANGES_ORBS_LIST=tranges_orbs_list,TSPANS_ORBS_LIST=tspans_orbs_list, $
                                        PRINT_DATA_AVAILABILITY=print_data_availability, VERBOSE=verbose,LIST_TO_ARR=list_to_arr

  IS_STRUCT_ALFVENDB_OR_FASTLOC,dbStruct,is_maximus

  IF KEYWORD_SET(verbose) THEN BEGIN
     PRINT,'GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES'
     print,'N UTC Ranges: ' + N_ELEMENTS(T1_ARR)
  ENDIF

  IF KEYWORD_SET(restrict) THEN BEGIN
     IF KEYWORD_SET(verbose) THEN BEGIN
        PRINT,'Restricting with specified inds...'
        PRINT,'(' + STRCOMPRESS(N_ELEMENTS(restrict),/REMOVE_ALL) + ' inds provided...)'

     ENDIF
     ;; dbStruct=RESIZE_MAXIMUS(dbStruct,DBTIMES=dbTimes,inds=restrict)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(verbose) THEN BEGIN
        PRINT,'No restriction on inds...'
     ENDIF
     restrict = INDGEN(N_ELEMENTS(dbStruct),/L64)
  ENDELSE

  
  ;;Now find out where we have data in this restricted interval
  ;; inds_ii = WHERE(dbTimes(restrict) GE t1_arr[0] AND dbTimes(restrict) LE t2_arr[0],nInds)
  ;; FOR i=1,N_ELEMENTS(t1_arr)-1 DO BEGIN
  ;;    temp_ii = WHERE(dbTimes(restrict) GE t1_arr[i] AND dbTimes(restrict) LE t2_arr[i],nTemp)
     
  ;;    IF temp_ii[0] NE -1 THEN BEGIN
  ;;       inds_ii = [inds_ii,temp_ii]
  ;;       nInds += nTemp
  ;;    ENDIF ELSE BEGIN
  ;;       IF KEYWORD_SET(verbose) THEN PRINTF,lun,FORMAT='("Interval ",I0," has no data!")',i
  ;;    ENDELSE
  ;; ENDFOR
  
  ;; inds = restrict(inds_ii)

  ;;Initialize, please
  nGood = 0
  iFirst = 0
  WHILE nGood EQ 0 DO BEGIN

     GET_DATA_AVAILABILITY_FOR_UTC_RANGE,T1=t1_arr[iFirst],T2=t2_arr[iFirst], $
                                      DBSTRUCT=dbStruct,DBTIMES=dbTimes, RESTRICT_W_THESEINDS=restrict, $
                                      OUT_INDS=inds, $
                                      UNIQ_ORBS=uniq_orbs,UNIQ_ORB_INDS=uniq_orb_inds, $
                                      INDS_ORBS=inds_orbs,TRANGES_ORBS=tranges_orbs,TSPANS_ORBS=tspans_orbs, $
                                      PRINT_DATA_AVAILABILITY=print_data_availability, VERBOSE=verbose

     IF inds[0] NE -1 THEN BEGIN
        nGood += 1
        inds_list          = LIST(inds)
        uniq_orbs_list     = LIST(uniq_orbs)
        uniq_orb_inds_list = LIST(uniq_orb_inds)
        inds_orbs_list     = LIST(inds_orbs)
        tranges_orbs_list  = LIST(tranges_orbs)
        tspans_orbs_list   = LIST(tspans_orbs)
     ENDIF
     iFirst++
  ENDWHILE

  FOR i = iFirst,N_ELEMENTS(t1_arr)-1 DO BEGIN

     GET_DATA_AVAILABILITY_FOR_UTC_RANGE,T1=t1_arr[i],T2=t2_arr[i], $
                                         DBSTRUCT=dbStruct,DBTIMES=dbTimes, RESTRICT_W_THESEINDS=restrict, $
                                         OUT_INDS=inds, $
                                         UNIQ_ORBS=uniq_orbs,UNIQ_ORB_INDS=uniq_orb_inds, $
                                         INDS_ORBS=inds_orbs,TRANGES_ORBS=tranges_orbs,TSPANS_ORBS=tspans_orbs, $
                                         PRINT_DATA_AVAILABILITY=print_data_availability, VERBOSE=verbose
     IF inds[0] NE -1 THEN BEGIN
        inds_list.add,inds
        uniq_orbs_list.add,uniq_orbs
        uniq_orb_inds_list.add,uniq_orb_inds
        inds_orbs_list.add,inds_orbs
        tranges_orbs_list.add,tranges_orbs
        tspans_orbs_list.add,tspans_orbs
        nGood++
     ENDIF

  ENDFOR
  
  IF KEYWORD_SET(list_to_arr) THEN BEGIN

     inds_arr             = inds_list[0]
     uniq_orbs_arr        = uniq_orbs_list[0]
     uniq_orb_inds_arr    = uniq_orb_inds_list[0]
     inds_orbs_arr        = inds_orbs_list[0]
     tranges_orbs_arr     = tranges_orbs_list[0]
     tspans_orbs_arr      = tspans_orbs_list[0]
     
     FOR i=0,nGood-1 DO BEGIN
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