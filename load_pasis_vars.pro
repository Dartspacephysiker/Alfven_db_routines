;;12/11/16
FUNCTION LOAD_PASIS_VARS, $
   FILENAME=fileName, $
   SAVEDIR=dir, $
   NEED_FASTLOC_I=need_fastLoc_i, $
   REMAKE_PREVIOUS_PLOT_I_LISTS_IF_EXISTING=remake_prev_plot_file, $
   VERBOSE=verbose

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__pasis_lists.pro

  IF KEYWORD_SET(filename) AND KEYWORD_SET(dir) THEN BEGIN
     checkAgainst = 0
  ENDIF ELSE BEGIN
     checkAgainst = 1
  ENDELSE

  saveDir = KEYWORD_SET(dir)      ? dir      : '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'
  fName   = KEYWORD_SET(fileName) ? fileName : GET_PASIS_VARS_FNAME(NEED_FASTLOC_I=need_fastLoc_i)

  IF KEYWORD_SET(remake_prev_plot_file) THEN BEGIN
     IF FILE_TEST(saveDir+fName) THEN BEGIN
        PRINT,'Remaking PASIS inds file: ' + saveDir + fName
     ENDIF
     RETURN,0
  ENDIF 

  IF KEYWORD_SET(verbose) THEN BEGIN 
     PRINT,"Loading PASIS vars from " + saveDir + fName + ' ...'
  ENDIF


  IF FILE_TEST(saveDir+fName) THEN BEGIN

     ;;Setup temps for comparison
     IF KEYWORD_SET(checkAgainst) THEN BEGIN
        compare_alfDB_plot_struct = 1
        compare_MIMC_struct       = 1
        compare_IMF_struct        = 1

        inds_reset = 0B
        DBs_reset  = 0B
        plot_reset = 0B 

        alfDB_plot_struct = TEMPORARY(PASIS__alfDB_plot_struct)
        MIMC_struct       = TEMPORARY(PASIS__MIMC_struct)
        IMF_struct        = TEMPORARY(PASIS__IMF_struct)
     ENDIF

     RESTORE,saveDir+fName
  ENDIF ELSE BEGIN
     PRINT,"Couldn't get PASIS vars file!"
     RETURN,0
  ENDELSE

  CASE 1 OF
     KEYWORD_SET(alfdb_plot_struct.for_eSpec_DBs): BEGIN
        IF (N_ELEMENTS(PASIS__paramString_list        ) EQ 0) OR $
           (N_ELEMENTS(PASIS__paramString             ) EQ 0) OR $
           ;; N_ELEMENTS(PASIS__plot_i_list            ) EQ 0 OR $
           (N_ELEMENTS(PASIS__fastLocInterped_i_list  ) EQ 0) OR $
           (N_ELEMENTS(PASIS__indices__eSpec_list     ) EQ 0) OR $
           ;; N_ELEMENTS(PASIS__indices__ion_list   ) EQ 0 OR $
           ((N_ELEMENTS(PASIS__eFlux_eSpec_data       ) EQ 0) AND $
            (N_ELEMENTS(PASIS__eNumFlux_eSpec_data    ) EQ 0)) OR $
           ;; (N_ELEMENTS(PASIS__eSpec__MLTs             ) EQ 0) OR $
           ;; (N_ELEMENTS(PASIS__eSpec__ILATs            ) EQ 0) OR $
           ;; N_ELEMENTS(PASIS__iFlux_eSpec_data       ) EQ 0 OR $
           ;; N_ELEMENTS(PASIS__iNumFlux_eSpec_data    ) EQ 0 OR $
           ;; N_ELEMENTS(PASIS__ion_delta_t            ) EQ 0 OR $
           ;; N_ELEMENTS(PASIS__ion__MLTs              ) EQ 0 OR $
           ;; N_ELEMENTS(PASIS__ion__ILATs             ) EQ 0 OR $
           (N_ELEMENTS(PASIS__alfDB_plot_struct       ) EQ 0) OR $
           (N_ELEMENTS(PASIS__IMF_struct              ) EQ 0) OR $
           (N_ELEMENTS(PASIS__MIMC_struct             ) EQ 0) $
        THEN BEGIN
           PRINT,"BROOOOOO!"
           STOP
        ENDIF

        PASIS__eFlux_eSpec_data    = 1
        PASIS__eNumFlux_eSpec_data = 1
        PASIS__eSpec__MLTs         = 1
        ;; PASIS__eSpec__ILATs        = 1
     END
     KEYWORD_SET(alfdb_plot_struct.for_ion_DBs): BEGIN
        IF (N_ELEMENTS(PASIS__paramString_list        ) EQ 0) OR $
           (N_ELEMENTS(PASIS__paramString             ) EQ 0) OR $
           (N_ELEMENTS(PASIS__fastLocInterped_i_list  ) EQ 0) OR $
           (N_ELEMENTS(PASIS__indices__ion_list     ) EQ 0) OR $
           ((N_ELEMENTS(PASIS__iFlux_ion_data       ) EQ 0) AND $
            (N_ELEMENTS(PASIS__iNumFlux_ion_data    ) EQ 0)) OR $
           (N_ELEMENTS(PASIS__alfDB_plot_struct       ) EQ 0) OR $
           (N_ELEMENTS(PASIS__IMF_struct              ) EQ 0) OR $
           (N_ELEMENTS(PASIS__MIMC_struct             ) EQ 0) $
        THEN BEGIN
           PRINT,"BROOOOOO!"
           STOP
        ENDIF

        PASIS__iFlux_ion_data      = 1
        PASIS__iNumFlux_ion_data   = 1
        PASIS__ion__MLTs           = 1
     END
     KEYWORD_SET(alfdb_plot_struct.for_sWay_DB): BEGIN
        IF (N_ELEMENTS(PASIS__paramString_list        ) EQ 0) OR $
           (N_ELEMENTS(PASIS__paramString             ) EQ 0) OR $
           ;; (N_ELEMENTS(PASIS__fastLocInterped_i_list  ) EQ 0) OR $
           (N_ELEMENTS(PASIS__indices__sWay_list     ) EQ 0) OR $
           ;; ((N_ELEMENTS(PASIS__iFlux_ion_data       ) EQ 0) AND $
           ;;  (N_ELEMENTS(PASIS__iNumFlux_ion_data    ) EQ 0)) OR $
           (N_ELEMENTS(PASIS__alfDB_plot_struct       ) EQ 0) OR $
           (N_ELEMENTS(PASIS__IMF_struct              ) EQ 0) OR $
           (N_ELEMENTS(PASIS__MIMC_struct             ) EQ 0) $
        THEN BEGIN
           PRINT,"EMMMCCCEEEE!"
           STOP
        ENDIF

     END
     ELSE: BEGIN
        IF N_ELEMENTS(PASIS__paramString_list        ) EQ 0  OR $
           N_ELEMENTS(PASIS__paramString             ) EQ 0  OR $
           N_ELEMENTS(PASIS__plot_i_list             ) EQ 0  OR $
           (KEYWORD_SET(need_fastLoc_i) AND $
            N_ELEMENTS(PASIS__fastLocInterped_i_list ) EQ 0) OR $
           ;; N_ELEMENTS(PASIS__indices__eSpec_list ) EQ 0 OR $
           ;; N_ELEMENTS(PASIS__indices__ion_list   ) EQ 0 OR $
           ;; N_ELEMENTS(PASIS__eFlux_eSpec_data       ) EQ 0 OR $
           ;; N_ELEMENTS(PASIS__eNumFlux_eSpec_data    ) EQ 0 OR $
           ;; N_ELEMENTS(PASIS__eSpec__MLTs         ) EQ 0 OR $
           ;; N_ELEMENTS(PASIS__eSpec__ILATs        ) EQ 0 OR $
           ;; N_ELEMENTS(PASIS__iFlux_eSpec_data       ) EQ 0 OR $
           ;; N_ELEMENTS(PASIS__iNumFlux_eSpec_data    ) EQ 0 OR $
           ;; N_ELEMENTS(PASIS__ion_delta_t            ) EQ 0 OR $
           ;; N_ELEMENTS(PASIS__ion__MLTs              ) EQ 0 OR $
           ;; N_ELEMENTS(PASIS__ion__ILATs             ) EQ 0 OR $
           (~KEYWORD_SET(checkAgainst) AND $
            (N_ELEMENTS(PASIS__alfDB_plot_struct      ) EQ 0 OR $
             N_ELEMENTS(PASIS__IMF_struct             ) EQ 0 OR $
             N_ELEMENTS(PASIS__MIMC_struct            ) EQ 0)) $
        THEN BEGIN
           IF N_ELEMENTS(PASIS__plot_i_list) EQ 0 THEN BEGIN
              inds_reset = 1
           ENDIF ELSE BEGIN
              PRINT,"BROOOOOO!"
              STOP
           ENDELSE
        ENDIF
     END
  ENDCASE

  IF KEYWORD_SET(checkAgainst) THEN BEGIN

     IF compare_alfDB_plot_struct THEN BEGIN
        COMPARE_ALFDB_PLOT_STRUCT,PASIS__alfDB_plot_struct,alfDB_plot_struct, $
                                  INDS_RESET=inds_resetTmp, $
                                  DBS_RESET=DBS_resetTmp
        inds_reset += TEMPORARY(inds_resetTmp)
        DBs_reset  += TEMPORARY(DBs_resetTmp )
     ENDIF

     IF compare_IMF_struct THEN BEGIN

        comp =  COMPARE_STRUCT(PASIS__IMF_struct,IMF_struct,EXCEPT=['clock_i'])
        CASE N_ELEMENTS(comp) OF
           1: BEGIN
              IF comp.nDiff GT 0 THEN BEGIN

                 STOP

              ENDIF
           END
           ELSE: BEGIN
              IF (WHERE(comp[*].nDiff GT 0))[0] NE -1 THEN BEGIN

                 STOP

              ENDIF
           END
        ENDCASE

     ENDIF


     IF compare_MIMC_struct THEN BEGIN
        COMPARE_MIMC_STRUCT,PASIS__MIMC_struct,MIMC_struct,INDS_RESET=inds_resetTmp,DBS_RESET=DBs_resetTmp
        
        inds_reset += TEMPORARY(inds_resetTmp)
        DBs_reset  += TEMPORARY(DBs_resetTmp )

     ENDIF

     IF KEYWORD_SET(inds_reset) OR $
        KEYWORD_SET(plot_reset) OR $
        KEYWORD_SET(DBs_reset) $
     THEN BEGIN
        PRINT,"Deleting PASIS vars file; it doesn't match ..."
        SPAWN,'rm ' + saveDir + fName
     ENDIF

     CLEAR_PASIS_VARS,INDS_RESET=inds_reset, $
                      PLOTS_RESET=plots_reset, $
                      DBS_RESET=DBs_reset

     IF N_ELEMENTS(PASIS__plot_i_list) GT 0 THEN BEGIN
        get_plot_i              = 0
     ENDIF ELSE BEGIN
        get_plot_i              = 1
     ENDELSE

     IF (N_ELEMENTS(PASIS__indices__eSpec_list) GT 0) THEN BEGIN
        get_eSpec_i             = 0
     ENDIF ELSE BEGIN
        get_eSpec_i             = 1
     ENDELSE

     IF (N_ELEMENTS(PASIS__indices__ion_list) GT 0) THEN BEGIN
        get_ion_i             = 0
     ENDIF ELSE BEGIN
        get_ion_i             = 1
     ENDELSE

     IF (N_ELEMENTS(PASIS__indices__sWay_list) GT 0) THEN BEGIN
        get_sWay_i            = 0
     ENDIF ELSE BEGIN
        get_sWay_i            = 1
     ENDELSE

     IF N_ELEMENTS(PASIS__fastLocInterped_i_list) GT 0 THEN BEGIN
        get_fastLoc_i           = 0
     ENDIF ELSE BEGIN
        get_fastLoc_i           = 1
     ENDELSE

     IF KEYWORD_SET(PASIS__paramString_list) THEN BEGIN
        get_paramString_list    = 0
     ENDIF

     IF KEYWORD_SET(PASIS__paramString) THEN BEGIN
        get_paramString         = 0
     ENDIF

  ENDIF

  PASIS__alfDB_plot_struct = TEMPORARY(alfDB_plot_struct)
  PASIS__MIMC_struct       = TEMPORARY(MIMC_struct)
  PASIS__IMF_struct        = TEMPORARY(IMF_struct)

  RETURN,1
  
END
