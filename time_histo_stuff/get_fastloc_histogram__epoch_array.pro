;2015/10/27
PRO GET_FASTLOC_HISTOGRAM__EPOCH_ARRAY, $
   T1_ARR=t1_arr, $
   T2_ARR=t2_arr, $
   CENTERTIME=centerTime, $
   RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
   MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
   DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
   HEMI=hemi, $
   NEPOCHS=nEpochs, $
   OUTINDSPREFIX=outIndsPrefix, $
   HISTDATA=histData, $
   HISTTBINS=histtbins, $
   NEVHISTDATA=nEvHistData, $
   TAFTEREPOCH=tAfterEpoch,TBEFOREEPOCH=tBeforeEpoch, $
   HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot, $
   FASTLOC_I_LIST=fastLoc_i_list,FASTLOC_T_LIST=fastLoc_t_list,FASTLOC_DT_LIST=fastLoc_dt_list, $
   NONZERO_I=nz_i, $
   FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_times,FASTLOC_DELTA_T=fastLoc_delta_t, $
   SAVE_OR_RESTORE_IF_POSSIBLE=save_or_restore_if_possible

   
   IF N_ELEMENTS(fastLoc) EQ 0 OR N_ELEMENTS(fastLoc_times) EQ 0 OR N_ELEMENTS(fastLoc_delta_t) EQ 0 THEN BEGIN
      LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastLoc_times,fastloc_delta_t
   ENDIF

   ;; IF KEYWORD_SET(save_or_restore_if_possible) THEN BEGIN
   ;;    saveStr = STRING(FORMAT='()'

        ;;First, get all fastLoc inds for these periods, each as a list
   GET_FASTLOC_INDS_UTC_RANGE,fastloc_i_list, $
                              LIST_TO_ARR=0, $
                              T1_ARR=t1_arr, $
                              T2_ARR=t2_arr, $
                              OUTINDSPREFIX=savePlotMaxName, $
                              FASTLOC_STRUCT=fastLoc, $
                              FASTLOC_TIMES=fastLoc_times, $
                              FASTLOC_DELTA_T=fastLoc_delta_t, $
                              HEMI=hemi, $
                              RESTRICT_ALTRANGE=restrict_altRange,RESTRICT_CHARERANGE=restrict_charERange, $
                              MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                              DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL
   
        IF N_ELEMENTS(fastLoc_i_list) NE nEpochs THEN STOP
        iFirst = 0
        WHILE N_ELEMENTS(fastloc_t_list) EQ 0 DO BEGIN
           IF N_ELEMENTS(fastLoc_i_list[iFirst]) NE 0 THEN BEGIN
              IF fastLoc_i_list[iFirst,0] NE -1 THEN BEGIN
                 fastloc_t_list = LIST((fastLoc_times[fastLoc_i_list[iFirst]] - centerTime[iFirst])/3600.0)
                 fastloc_dt_list = LIST(fastLoc_delta_t[fastLoc_i_list[iFirst]])
              ENDIF
           ENDIF
           iFirst++
        ENDWHILE
        FOR i = iFirst, N_ELEMENTS(fastloc_i_list)-1 DO BEGIN
           IF N_ELEMENTS(fastLoc_i_list[iFirst]) NE 0 THEN BEGIN
              IF fastLoc_i_list[i,0] NE -1 THEN BEGIN
                 fastloc_t_list.add,(fastLoc_times[fastLoc_i_list[i]] - centerTime[i])/3600.0
                 fastloc_dt_list.add,fastLoc_delta_t[fastLoc_i_list[iFirst]]
              ENDIF
           ENDIF
        ENDFOR
        fastloc_i = LIST_TO_1DARRAY(fastLoc_i_list,/SKIP_NEG1_ELEMENTS,/WARN)
        fastloc_t = LIST_TO_1DARRAY(fastLoc_t_list,/SKIP_NEG1_ELEMENTS,/WARN)
        fastloc_dt = LIST_TO_1DARRAY(fastLoc_dt_list,/SKIP_NEG1_ELEMENTS,/WARN)

        GET_ALFVENDBQUANTITY_HISTOGRAM__EPOCH_ARRAY,fastloc_t,fastloc_dt, $
           HISTOTYPE=0, $    ;no averaging!
           HISTDATA=histData, $
           HISTTBINS=histTBins, $
           ;; NEVHISTDATA=nEvHistData_pos, $
           TAFTEREPOCH=tAfterEpoch,TBEFOREEPOCH=tBeforeEpoch, $
           HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot, $
           NONZERO_I=nz_i

END
