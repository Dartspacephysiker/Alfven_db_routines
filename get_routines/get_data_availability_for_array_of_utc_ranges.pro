;2015/10/13
;Now I want to get data for a who' lotta ranges!
;NOTE: It is recommended that you use GET_FASTLOC_INDS_UTC_RANGE to get ephemeris indices! It handles all the screening and defaults.
;2016/02/06 Added SAVE_INDS_TO_FILENAME keyword
PRO GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES, $
   T1_ARR=t1_arr, $
   T2_ARR=t2_arr, $
   DBSTRUCT=dbStruct, $
   DBTIMES=dbTimes, $
   FOR_ESPEC_DB=for_eSpec_db, $
   FOR_SWAY_DB=for_sWay_db, $
   FOR_OMNI_DB=for_OMNI_db, $
   DO_NOT_MAKE_ORB_INFO=no_orb_info, $
   RESTRICT_W_THESEINDS=restrict, $
   OUT_GOOD_TARR_I=out_good_tArr_i, $
   OUT_INDS_LIST=inds_list, $
   UNIQ_ORBS_LIST=uniq_orbs_list, $
   UNIQ_ORB_INDS_LIST=uniq_orb_inds_list, $
   INDS_ORBS_LIST=inds_orbs_list, $
   TRANGES_ORBS_LIST=tranges_orbs_list, $
   TSPANS_ORBS_LIST=tspans_orbs_list, $
   PRINT_DATA_AVAILABILITY=print_data_availability, $
   SUMMARY=summary, $
   LIST_TO_ARR=list_to_arr, $
   SAVE_INDS_TO_FILENAME=save_filename, $
   GIVE_TIMESPLIT_INFO=give_timeSplit_info, $
   VERBOSE=verbose, $
   LET_OVERLAPS_FLY__FOR_SEA=let_overlaps_fly__for_sea, $
   DEBUG=debug, $
   LUN=lun
  
  COMPILE_OPT idl2,strictarrsubs

  IF N_ELEMENTS(lun) EQ 0 THEN lun  = -1

  IF KEYWORD_SET(give_timesplit_info) THEN BEGIN
     TIC
  ENDIF


  CASE 1 OF
     KEYWORD_SET(for_eSpec_db): BEGIN
        ;;Use for_eSpec_db             = 2 here to indicate that conversion has already happened
        IF for_eSpec_db NE 2 THEN BEGIN
           dbTimes                     = N_ELEMENTS(dbStruct) GT 0 ? dbStruct.x : dbTimes
           for_eSpec_db                = 2
           dbString                    = 'eSpec'
        ENDIF
     END
     KEYWORD_SET(for_sWay_db): BEGIN
        ;;Use for_eSpec_db EQ 2 here to indicate that conversion has already happened
        IF for_sWay_db NE 2 THEN BEGIN
           dbTimes                     = N_ELEMENTS(dbStruct) GT 0 ? dbStruct.time : dbTimes
           for_sWay_db                 = 2
           dbString                    = 'sWay'
        ENDIF
     END
     KEYWORD_SET(for_OMNI_db): BEGIN
        dbString                       = 'OMNI'
     END
     ELSE: BEGIN
        IS_STRUCT_ALFVENDB_OR_FASTLOC,dbStruct,is_maximus
        IF is_maximus THEN dbString    = 'maximus' ELSE dbString = 'fastLoc'
     END
  ENDCASE

  PRINTF,lun,'GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES: for ' + dbString

  IF KEYWORD_SET(restrict) THEN BEGIN
     IF KEYWORD_SET(verbose) THEN BEGIN
        PRINTF,LUN,'Restricting with specified inds...'
        PRINTF,LUN,'(' + STRCOMPRESS(N_ELEMENTS(restrict),/REMOVE_ALL) + ' inds provided...)'

     ENDIF
     ;; dbStruct=RESIZE_MAXIMUS(dbStruct,DBTIMES=dbTimes,inds=restrict)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(verbose) THEN BEGIN
        PRINTF,LUN,'No restriction on inds...'
     ENDIF
     restrict                       = INDGEN(N_ELEMENTS(dbTimes),/L64)
  ENDELSE

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Data integrity checks
  PRINTF,lun,"Making sure t1_arr and t2_arr are sane ..."

  n_t1                              = N_ELEMENTS(t1_arr)
  n_t2                              = N_ELEMENTS(t2_arr)
  IF n_t1 NE n_t2 THEN BEGIN
     PRINTF,lun,"Unequal numbers of elements in t1_arr and t2_arr! Stopping ..."
     STOP
  ENDIF

  ;;Find out whether any ranges are bogus, report
  bogus_range_i                     = WHERE((t2_arr-t1_arr) LE 0,nBogus)
  IF bogus_range_i[0] NE -1 THEN BEGIN
     PRINTF,lun,"Bogus ranges! t2 comes before t1 in " + STRCOMPRESS(nBogus,/REMOVE_ALL) + " instances!"
     STOP
  ENDIF

  IF n_t1 GT 1 THEN BEGIN
     bogus_range_i                  = WHERE(((SHIFT(t1_arr,-1))[0:-2]-t1_arr[0:-2]) LE 0,nBogus)
     IF bogus_range_i[0] NE -1 THEN BEGIN
        PRINTF,lun,"Bogus ranges! t1[later] comes before t1[earlier] in " + STRCOMPRESS(nBogus,/REMOVE_ALL) + " instances!"
        STOP
     ENDIF
  ENDIF
  
  IF n_t2 GT 1 THEN BEGIN
     bogus_range_i                  = WHERE(((SHIFT(t2_arr,-1))[0:-2]-t2_arr[0:-2]) LE 0,nBogus)
     IF bogus_range_i[0] NE -1 THEN BEGIN
        PRINTF,lun,"Bogus ranges! t2[later] comes before t2[earlier] in " + STRCOMPRESS(nBogus,/REMOVE_ALL) + " instances!"
        STOP
     ENDIF
  ENDIF

  ;;Check for duplicates, report
  IF n_t1 GT 1 THEN BEGIN
     check_dupes,t1_arr,HAS_DUPES=t1_has_dupes,OUT_DUPE_I=t1_dupe_i,/PRINT_SAMPLE
     IF t1_has_dupes THEN BEGIN
        PRINTF,lun,"t1_arr has duplicate entries! Take a look:"
        STOP
     ENDIF
  ENDIF
  IF n_t2 GT 1 THEN BEGIN
     check_dupes,t2_arr,HAS_DUPES=t2_has_dupes,OUT_DUPE_I=t2_dupe_i,/PRINT_SAMPLE
     IF t2_has_dupes THEN BEGIN
        PRINTF,lun,"t2_arr has duplicate entries! Take a look:"
        STOP
     ENDIF  
  ENDIF

  ;;Check to see if there are overlaps
  PRINTF,lun,"Making sure there are no overlaps..."
  overlap_t1_arr_i                  = !NULL
  overlap_t2_arr_i                  = !NULL
  n_overlap_t1                      = 0
  n_overlap_t2                      = 0
  IF n_t1 GT 1 THEN BEGIN 
     FOR i=0,n_t1-2 DO BEGIN
        test_1                      = t1_arr[i+1] LT t2_arr[i]
        test_2                      = t2_arr[i]   GT t1_arr[i+1]

        IF test_1 THEN BEGIN
           overlap_t1_arr_i         = [overlap_t1_arr_i,i+1]
           n_overlap_t1++
        ENDIF

        IF test_2 THEN BEGIN
           overlap_t2_arr_i         = [overlap_t2_arr_i,i]
           n_overlap_t2++
        ENDIF
     ENDFOR

     IF n_overlap_t1 GT 0 OR n_overlap_t2 GT 0 THEN BEGIN
        PRINTF,lun,"Overlaps exist!"
        PRINTF,lun,"N Instances where t1[i+1] occurs before t2[i]: " + STRCOMPRESS(n_overlap_t1,/REMOVE_ALL)
        FOR jj=0,n_overlap_t1-1 DO BEGIN
           PRINTF,lun,FORMAT='("t1[",I0,"] : ",A0)', $
                  overlap_t1_arr_i[jj], $
                  TIME_TO_STR(t1_arr[overlap_t1_arr_i[jj]],/MS)
           PRINTF,lun,FORMAT='("t2[",I0,"] : ",A0)', $
                  overlap_t1_arr_i[jj]-1, $
                  TIME_TO_STR(t2_arr[overlap_t1_arr_i[jj]-1],/MS)
        ENDFOR
        PRINTF,lun,''
        PRINTF,lun,"N Instances where t2[1] occurs after t1[i+1]: " + STRCOMPRESS(n_overlap_t2,/REMOVE_ALL)
        FOR jj=0,n_overlap_t2-1 DO BEGIN
           PRINTF,lun,FORMAT='("t1[",I0,"] : ",A0)', $
                  overlap_t2_arr_i[jj]+1, $
                  TIME_TO_STR(t1_arr[overlap_t2_arr_i[jj]+1],/MS)
           PRINTF,lun,FORMAT='("t2[",I0,"] : ",A0)', $
                  overlap_t2_arr_i[jj], $
                  TIME_TO_STR(t2_arr[overlap_t2_arr_i[jj]],/MS)
        ENDFOR
        PRINTF,lun,''
        IF KEYWORD_SET(let_overlaps_fly__for_sea) THEN BEGIN
           PRINTF,lun,"Assuming this is OK since we're doing SEA ..."
           WAIT,0.5
        ENDIF ELSE BEGIN
           STOP
        ENDELSE
     ENDIF
  ENDIF

  PRINTF,lun,"t{1,2}_arr appear sane!"
  ;;END checks
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;Now find out where we have data in this restricted interval
  ;; inds_ii                        = WHERE(dbTimes(restrict) GE t1_arr[0] AND dbTimes(restrict) LE t2_arr[0],nInds)
  ;; FOR i=1,n_t1-1 DO BEGIN
  ;;    temp_ii                     = WHERE(dbTimes(restrict) GE t1_arr[i] AND dbTimes(restrict) LE t2_arr[i],nTemp)
  
  ;;    IF temp_ii[0] NE -1 THEN BEGIN
  ;;       inds_ii                  = [inds_ii,temp_ii]
  ;;       nInds += nTemp
  ;;    ENDIF ELSE BEGIN
  ;;       IF KEYWORD_SET(verbose) THEN PRINTF,lun,FORMAT='("Interval ",I0," has no data!")',i
  ;;    ENDELSE
  ;; ENDFOR
  
  ;; inds                           = restrict(inds_ii)

  ;;Initialize, please
  nGood                             = 0
  iFirst                            = 0
  out_good_tArr_i                   = !NULL
  WHILE nGood EQ 0 DO BEGIN

     IF KEYWORD_SET(give_timesplit_info) THEN BEGIN
        clock                       = TIC("GET_DATA_FOR_UTC_RANGE_iFirst"+STRCOMPRESS(nGood,/REMOVE_ALL)+'_clock')
     ENDIF

     GET_DATA_AVAILABILITY_FOR_UTC_RANGE,T1=t1_arr[iFirst],T2=t2_arr[iFirst], $
                                         DBSTRUCT=dbStruct, $
                                         DBTIMES=dbTimes, $
                                         FOR_ESPEC_DB=for_eSpec_db, $
                                         FOR_OMNI_DB=for_OMNI_db, $
                                         DO_NOT_MAKE_ORB_INFO=no_orb_info, $
                                         RESTRICT_W_THESEINDS=restrict, $
                                         OUT_INDS=inds, $
                                         UNIQ_ORBS=uniq_orbs,UNIQ_ORB_INDS=uniq_orb_inds, $
                                         INDS_ORBS=inds_orbs,TRANGES_ORBS=tranges_orbs, $
                                         TSPANS_ORBS=tspans_orbs,TSPANTOTAL=tSpanTotal, $
                                         PRINT_DATA_AVAILABILITY=verbose, $
                                         VERBOSE=verbose, DEBUG=debug

     IF inds[0] NE -1 THEN BEGIN
        nGood             ++
        out_good_tArr_i             = [out_good_tArr_i,iFirst]
        inds_list                   = LIST(inds)
        IF ~KEYWORD_SET(for_OMNI_db) AND N_ELEMENTS(dbStruct) GT 0 THEN BEGIN
           uniq_orbs_list           = LIST(uniq_orbs)
           uniq_orb_inds_list       = LIST(uniq_orb_inds)
           IF ~KEYWORD_SET(no_orb_info) THEN BEGIN
              inds_orbs_list        = LIST(inds_orbs)
              tranges_orbs_list     = LIST(tranges_orbs)
              tspans_orbs_list      = LIST(tspans_orbs)
              arrTSpanTotal         = tSpanTotal
           ENDIF
        ENDIF
     ENDIF
     iFirst++

     IF KEYWORD_SET(give_timesplit_info) THEN BEGIN
        TOC,clock
     ENDIF

  ENDWHILE

  FOR i=iFirst,n_t1-1 DO BEGIN

     IF KEYWORD_SET(give_timesplit_info) THEN BEGIN
        clock                       = TIC("GET_DATA_FOR_UTC_RANGE_"+STRCOMPRESS(i,/REMOVE_ALL)+'_clock')
     ENDIF

     GET_DATA_AVAILABILITY_FOR_UTC_RANGE,T1=t1_arr[i],T2=t2_arr[i], $
                                         DBSTRUCT=dbStruct, $
                                         DBTIMES=dbTimes, $
                                         FOR_ESPEC_DB=for_eSpec_db, $
                                         FOR_OMNI_DB=for_OMNI_db, $
                                         DO_NOT_MAKE_ORB_INFO=no_orb_info, $
                                         RESTRICT_W_THESEINDS=restrict, $
                                         OUT_INDS=inds, $
                                         UNIQ_ORBS=uniq_orbs,UNIQ_ORB_INDS=uniq_orb_inds, $
                                         INDS_ORBS=inds_orbs,TRANGES_ORBS=tranges_orbs, $
                                         TSPANS_ORBS=tSpans_orbs,TSPANTOTAL=tSpanTotal, $
                                         PRINT_DATA_AVAILABILITY=verbose, $
                                         VERBOSE=verbose,DEBUG=debug
     IF inds[0] NE -1 THEN BEGIN
        nGood++
        out_good_tArr_i             = [out_good_tArr_i,i]
        inds_list.add,inds
        IF ~KEYWORD_SET(for_OMNI_db) AND N_ELEMENTS(dbStruct) GT 0 THEN BEGIN
           uniq_orbs_list.add,uniq_orbs
           uniq_orb_inds_list.add,uniq_orb_inds
           IF ~KEYWORD_SET(no_orb_info) THEN BEGIN
              inds_orbs_list.add,inds_orbs
              tranges_orbs_list.add,tranges_orbs
              tspans_orbs_list.add,tspans_orbs
              arrTSpanTotal   += tSpanTotal
           ENDIF
        ENDIF
     ENDIF

     IF KEYWORD_SET(give_timesplit_info) THEN BEGIN
        TOC,clock
     ENDIF
  ENDFOR
  
  IF KEYWORD_SET(print_data_availability) OR KEYWORD_SET(summary) AND ~KEYWORD_SET(no_orb_info) THEN BEGIN

     IF ~KEYWORD_SET(for_OMNI_db) THEN BEGIN
        arrTotUniqOrbs                 = 0
        arrTotInds                     = 0
        FOR k=0,N_ELEMENTS(uniq_orbs_list)-1 DO BEGIN
           arrTotUniqOrbs   += N_ELEMENTS(uniq_orbs_list[k])
           arrTotInds       += N_ELEMENTS(inds_list[k])
        ENDFOR
     ENDIF ELSE BEGIN
        arrTotInds                     = 0
        FOR k=0,N_ELEMENTS(inds_list)-1 DO BEGIN
           arrTotInds       += N_ELEMENTS(inds_list[k])
        ENDFOR
     ENDELSE

     PRINTF,lun,'***********************************'
     PRINTF,lun,'***SUMMARY OF DATA FOR UTC ARRAY***'
     PRINTF,lun,'UTC Range for array: ' + TIME_TO_STR(t1_arr[0]) + ' through ' + TIME_TO_STR(t2_arr[-1])
     PRINTF,lun,'N UTC Ranges: ' + STRCOMPRESS(N_ELEMENTS(t1_arr),/REMOVE_ALL)
     PRINTF,lun,'N with data : ' + STRCOMPRESS(nGood,/REMOVE_ALL)
     PRINTF,lun,FORMAT='("Array total event indices",T38,":",T40,I0)',arrTotInds
     IF ~KEYWORD_SET(for_OMNI_db) THEN PRINTF,lun,FORMAT='("Array total N unique orbits",T38,":",T40,I0)',arrTotUniqOrbs
     IF ~KEYWORD_SET(no_orb_info) THEN BEGIN
        IF ~KEYWORD_SET(for_OMNI_db) THEN PRINTF,lun,FORMAT='("Array total of all interval lengths w/ data (hrs)",T38,":",T40,F0.2)',arrTSpanTotal/3600.
     ENDIF
     PRINTF,lun,'***********************************'
     PRINTF,lun,''
  ENDIF

  IF KEYWORD_SET(list_to_arr) THEN BEGIN

     inds_arr                       = inds_list[0]
     IF ~KEYWORD_SET(for_OMNI_db) AND N_ELEMENTS(dbStruct) GT 0 THEN BEGIN
        uniq_orbs_arr                  = uniq_orbs_list[0]
        uniq_orb_inds_arr              = uniq_orb_inds_list[0]
        IF ~KEYWORD_SET(no_orb_info) THEN BEGIN
           inds_orbs_arr               = inds_orbs_list[0]
           tranges_orbs_arr            = tranges_orbs_list[0]
           tspans_orbs_arr             = tspans_orbs_list[0]
        ENDIF
     ENDIF

     IF ~KEYWORD_SET(for_OMNI_db) AND N_ELEMENTS(dbStruct) GT 0 THEN BEGIN
        FOR i=1,nGood-1 DO BEGIN
           inds_arr                    = [ inds_arr, inds_list[i] ]
           uniq_orbs_arr               = [ uniq_orbs_arr, uniq_orbs_list[i] ]
           uniq_orb_inds_arr           = [ uniq_orb_inds_arr, uniq_orb_inds_list[i] ]
           IF ~KEYWORD_SET(no_orb_info) THEN BEGIN
              inds_orbs_arr            = [ inds_orbs_arr, inds_orbs_list[i] ]
              tranges_orbs_arr         = [ tranges_orbs_arr, tranges_orbs_list[i] ]
              tspans_orbs_arr          = [ tspans_orbs_arr, tspans_orbs_list[i] ]
           ENDIF
        ENDFOR
     ENDIF ELSE BEGIN
        FOR i=1,nGood-1 DO BEGIN
           inds_arr                    = [ inds_arr, inds_list[i] ]
        ENDFOR
     ENDELSE

     inds_list                      = inds_arr

     IF ~KEYWORD_SET(for_OMNI_db) AND N_ELEMENTS(dbStruct) GT 0 THEN BEGIN
        uniq_orbs_list              = uniq_orbs_arr
        uniq_orb_inds_list          = uniq_orb_inds_arr
        IF ~KEYWORD_SET(no_orb_info) THEN BEGIN
           inds_orbs_list           = inds_orbs_arr
           tranges_orbs_list        = tranges_orbs_arr
           tspans_orbs_list         = tspans_orbs_arr
        ENDIF
     ENDIF 
  ENDIF

  IF KEYWORD_SET(save_filename) THEN BEGIN
     PRINTF,lun,'Saving data availability information for UTC ranges to file: ' + save_filename
     IF N_ELEMENTS(list_to_arr) EQ 0 THEN BEGIN
        list_to_arr                 = 0
     ENDIF
     IF ~KEYWORD_SET(for_OMNI_db) THEN BEGIN
        SAVE,inds_list,uniq_orbs_list,uniq_orb_inds_list,inds_orbs_list,tranges_orbs_list,tspans_orbs_list,list_to_arr,FILENAME=save_filename
     ENDIF ELSE BEGIN
        SAVE,inds_list,list_to_arr,FILENAME=save_filename
     ENDELSE
  ENDIF

END
