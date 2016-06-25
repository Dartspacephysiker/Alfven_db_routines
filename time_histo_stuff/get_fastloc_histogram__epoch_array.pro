;2015/10/27
PRO GET_FASTLOC_HISTOGRAM__EPOCH_ARRAY, $
   T1_ARR=t1_arr, $
   T2_ARR=t2_arr, $
   CENTERTIME=centerTime, $
   RESTRICT_ALTRANGE=restrict_altRange, $
   RESTRICT_CHARERANGE=restrict_charERange, $
   RESTRICT_ORBRANGE=restrict_orbRange, $
   MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
   DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
   ;; BOTH_HEMIS=both_hemis, $
   ;; NORTH=north, $
   ;; SOUTH=south, $
   HEMI=hemi, $
   NEPOCHS=nEpochs, $
   OUTINDSPREFIX=outIndsPrefix, $
   HISTDATA=histData, $
   HISTTBINS=histtbins, $
   NEVHISTDATA=nEvHistData, $
   TAFTEREPOCH=tAfterEpoch,TBEFOREEPOCH=tBeforeEpoch, $
   HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot, $
   WINDOW_SUM=window_sum, $
   RUNNING_BIN_SPACING=running_bin_spacing, $
   RUNNING_BIN_OFFSET=bin_offset, $
   ;; RUNNING_BIN_L_OFFSET=bin_l_offset, $
   ;; RUNNING_BIN_R_OFFSET=bin_r_offset, $
   FASTLOC_I_LIST=fastLoc_i_list,FASTLOC_T_LIST=fastLoc_t_list,FASTLOC_DT_LIST=fastLoc_dt_list, $
   NONZERO_I=nz_i, $
   PRINT_MAXIND_SEA_STATS=print_maxInd_sea_stats, $
   FASTLOC_STRUCT=fastLoc, $
   FASTLOC_TIMES=fastLoc_times, $
   FASTLOC_DELTA_T=fastLoc_delta_t, $
   RESET_GOOD_INDS=reset_good_inds, $
   SAVE_OR_RESTORE_IF_POSSIBLE=save_or_restore_if_possible, $
   LET_OVERLAPS_FLY__FOR_SEA=let_overlaps_fly__for_sea, $
   LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1
   
   ;; IF N_ELEMENTS(fastLoc) EQ 0 OR N_ELEMENTS(fastLoc_times) EQ 0 OR N_ELEMENTS(fastLoc_delta_t) EQ 0 THEN BEGIN
   ;;    LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastLoc_times,fastloc_delta_t,DBFILE=fastLoc_dbFile,DB_TFILE=fastLoc_dbTimesFile
   ;; ENDIF

   ;; IF KEYWORD_SET(save_or_restore_if_possible) THEN BEGIN
   ;;    saveStr = STRING(FORMAT='()'

        ;;First, get all fastLoc inds for these periods, each as a list
   GET_FASTLOC_INDS_UTC_RANGE,fastloc_i_list, $
                              LIST_TO_ARR=0, $
                              T1_ARR=t1_arr, $
                              T2_ARR=t2_arr, $
                              OUT_GOOD_TARR_I=out_good_tArr_i, $
                              OUTINDSPREFIX=savePlotMaxName, $
                              ;; FASTLOC_STRUCT=fastLoc, $
                              ;; FASTLOC_TIMES=fastLoc_times, $
                              ;; FASTLOC_DELTA_T=fastLoc_delta_t, $
                              OUT_FASTLOC_TIMES=fastLoc_times, $
                              OUT_FASTLOC_DELTA_T=fastLoc_delta_t, $
                              FASTLOCFILE=fastLoc_dbFile, $
                              FASTLOCTIMEFILE=fastLoc_dbTimesFile, $
                              HEMI=hemi, $
                              RESET_GOOD_INDS=reset_good_inds, $
                              ALTITUDERANGE=restrict_altRange, $
                              CHARERANGE=restrict_charERange, $
                              ORBRANGE=restrict_orbRange, $
                              MINMLT=minM, $
                              MAXMLT=maxM, $
                              BINM=binM, $
                              MINILAT=minI, $
                              MAXILAT=maxI, $
                              BINI=binI, $
                              DO_LSHELL=do_lshell, $
                              MINLSHELL=minL, $
                              MAXLSHELL=maxL, $
                              BINL=binL, $
                              LET_OVERLAPS_FLY__FOR_SEA=let_overlaps_fly__for_sea, $
                              /DO_NOT_SET_DEFAULTS
   
        IF N_ELEMENTS(out_good_tArr_i) NE N_ELEMENTS(fastloc_i_list) THEN BEGIN
           PRINT,"There are very possibly issues with this plot; be careful ..."
           WAIT,3
        ENDIF

        iFirst                   = 0
        tempCT                   = centerTime[out_good_tArr_i]
        WHILE N_ELEMENTS(fastloc_t_list) EQ 0 DO BEGIN
           IF N_ELEMENTS(fastLoc_i_list[iFirst]) NE 0 THEN BEGIN
              IF fastLoc_i_list[iFirst,0] NE -1 THEN BEGIN
                 fastloc_t_list  = LIST((fastLoc_times[fastLoc_i_list[iFirst]] - tempCT[iFirst])/3600.0)
                 fastloc_dt_list = LIST(fastLoc_delta_t[fastLoc_i_list[iFirst]])
              ENDIF
           ENDIF
           iFirst++
        ENDWHILE
        FOR i = iFirst, N_ELEMENTS(fastloc_i_list)-1 DO BEGIN
           IF N_ELEMENTS(fastLoc_i_list[iFirst]) NE 0 THEN BEGIN
              IF fastLoc_i_list[i,0] NE -1 THEN BEGIN
                 fastloc_t_list.add,(fastLoc_times[fastLoc_i_list[i]] - tempCT[i])/3600.0
                 fastloc_dt_list.add,fastLoc_delta_t[fastLoc_i_list[i]]
              ENDIF
           ENDIF
        ENDFOR
        fastloc_i               = LIST_TO_1DARRAY(fastLoc_i_list,/SKIP_NEG1_ELEMENTS,/WARN)
        fastloc_t               = LIST_TO_1DARRAY(fastLoc_t_list,/SKIP_NEG1_ELEMENTS,/WARN)
        fastloc_dt              = LIST_TO_1DARRAY(fastLoc_dt_list,/SKIP_NEG1_ELEMENTS,/WARN)

        GET_ALFVENDBQUANTITY_HISTOGRAM__EPOCH_ARRAY,fastloc_t,fastloc_dt, $
           HISTOTYPE=0, $    ;no averaging!
           HISTDATA=histData, $
           HISTTBINS=histTBins, $
           ;; NEVHISTDATA=nEvHistData_pos, $
           RUNNING_BIN_SPACING=running_bin_spacing, $
           RUNNING_BIN_OFFSET=bin_offset, $
           ;; RUNNING_BIN_L_OFFSET=bin_l_offset, $
           ;; RUNNING_BIN_R_OFFSET=bin_r_offset, $
           TAFTEREPOCH=tAfterEpoch,TBEFOREEPOCH=tBeforeEpoch, $
           HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot, $
           WINDOW_SUM=window_sum, $
           NONZERO_I=nz_i, $
           PRINT_MAXIND_SEA_STATS=print_maxInd_sea_stats, $
           LUN=lun

END
