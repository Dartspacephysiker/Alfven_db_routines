PRO CHECK_FOR_NEW_IND_CONDS, $
   is_maximus, $
   HAVE_GOOD_I=have_good_i, $
   MIMC_STRUCT=MIMC_struct, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   IMF_STRUCT=IMF_struct, $
   LUN=lun

  COMPILE_OPT idl2

  ;; COMMON MLT_ILAT_MAGC_ETC
  @common__mlt_ilat_magc_etc.pro

  ;; Alfven DB-specific stuff
  IF KEYWORD_SET(is_maximus) THEN BEGIN
     
     test = !NULL
     STR_ELEMENT,MIMC_struct,'minMC',test
     IF SIZE(test,/TYPE) NE 0 THEN BEGIN
        IF N_ELEMENTS(MIMC__minMC) GT 0 THEN BEGIN
           IF MIMC__minMC NE MIMC_struct.minMC THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF ELSE BEGIN
           MIMC__RECALCULATE    = 1
           have_good_i          = 0
           RETURN
        ENDELSE
     ENDIF

     test = !NULL
     STR_ELEMENT,MIMC_struct,'maxNegMC',test
     IF SIZE(test,/TYPE) NE 0 THEN BEGIN
        IF N_ELEMENTS(MIMC__maxNegMC) GT 0 THEN BEGIN
           IF MIMC__maxNegMC NE MIMC_struct.maxNegMC THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF ELSE BEGIN
           MIMC__RECALCULATE    = 1
           have_good_i          = 0
           RETURN
        ENDELSE
     ENDIF

     test = !NULL
     STR_ELEMENT,alfDB_plot_struct,'chastDB',test
     IF SIZE(test,/TYPE) NE 0 THEN BEGIN
        IF N_ELEMENTS(MIMC__chastDB) GT 0 THEN BEGIN
           IF MIMC__chastDB NE alfDB_plot_struct.chastDB THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF ELSE BEGIN
           MIMC__RECALCULATE    = 1
           have_good_i          = 0
           RETURN
        ENDELSE
     ENDIF

     test = !NULL
     STR_ELEMENT,alfDB_plot_struct,'despunDB',test
     IF SIZE(test,/TYPE) NE 0 THEN BEGIN
        IF  (  KEYWORD_SET(alfDB_plot_struct.despunDB) AND ~KEYWORD_SET(MIMC__despunDB) ) OR $
           ( ~KEYWORD_SET(alfDB_plot_struct.despunDB) AND  KEYWORD_SET(MIMC__despunDB) )    $
        THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF

     test = !NULL
     STR_ELEMENT,alfDB_plot_struct,'charERange',test
     IF SIZE(test,/TYPE) NE 0 THEN BEGIN

        IF N_ELEMENTS(MIMC__charERange) GT 0 THEN BEGIN
           IF ~ARRAY_EQUAL(MIMC__charERange,alfDB_plot_struct.charERange) THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF ELSE BEGIN
           MIMC__RECALCULATE    = 1
           have_good_i          = 0
           RETURN
        ENDELSE
     ENDIF

     test = !NULL
     STR_ELEMENT,alfDB_plot_struct,'charE__Newell_the_cusp',test
     IF SIZE(test,/TYPE) NE 0 THEN BEGIN
        IF N_ELEMENTS(MIMC__charE__Newell_the_cusp) GT 0 THEN BEGIN
           IF MIMC__charE__Newell_the_cusp NE alfDB_plot_struct.charE__Newell_the_cusp THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF ELSE BEGIN
           MIMC__RECALCULATE    = 1
           have_good_i          = 0
           RETURN
        ENDELSE
     ENDIF

     test = !NULL
     STR_ELEMENT,alfDB_plot_struct,'poyntRange',test
     IF SIZE(test,/TYPE) NE 0 THEN BEGIN
        IF N_ELEMENTS(MIMC__poyntRange) GT 0 THEN BEGIN
           IF ~ARRAY_EQUAL(MIMC__poyntRange,alfDB_plot_struct.poyntRange) THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF ELSE BEGIN
           MIMC__RECALCULATE    = 1
           have_good_i          = 0
           RETURN
        ENDELSE
     ENDIF

     test = !NULL
     STR_ELEMENT,alfDB_plot_struct,'fluxplots__remove_outliers',test
     IF SIZE(test,/TYPE) NE 0 THEN BEGIN
        IF N_ELEMENTS(MIMC__fluxplots__remove_outliers) GT 0 THEN BEGIN
           IF MIMC__fluxplots__remove_outliers NE $
              alfDB_plot_struct.fluxplots__remove_outliers THEN BEGIN
              MIMC__RECALCULATE  = 1
              have_good_i        = 0
              RETURN
           ENDIF
        ENDIF ELSE BEGIN
           MIMC__RECALCULATE     = 1
           have_good_i           = 0
           RETURN
        ENDELSE
     ENDIF

     test = !NULL
     STR_ELEMENT,alfDB_plot_struct,'fluxplots__remove_log_outliers',test
     IF SIZE(test,/TYPE) NE 0 THEN BEGIN
        IF N_ELEMENTS(MIMC__fluxplots__remove_log_outliers) GT 0 THEN BEGIN
           IF MIMC__fluxplots__remove_log_outliers NE $
              alfDB_plot_struct.fluxplots__remove_log_outliers THEN BEGIN
              MIMC__RECALCULATE  = 1
              have_good_i        = 0
              RETURN
           ENDIF
        ENDIF ELSE BEGIN
           MIMC__RECALCULATE     = 1
           have_good_i           = 0
           RETURN
        ENDELSE
     ENDIF

     test = !NULL
     STR_ELEMENT,alfDB_plot_struct,'fluxplots__add_suspect_outliers',test
     IF SIZE(test,/TYPE) NE 0 THEN BEGIN
        IF N_ELEMENTS(MIMC__fluxplots__add_suspect_outliers) GT 0 THEN BEGIN
           IF MIMC__fluxplots__add_suspect_outliers NE $
              alfDB_plot_struct.fluxplots__add_suspect_outliers THEN BEGIN
              MIMC__RECALCULATE  = 1
              have_good_i        = 0
              RETURN
           ENDIF
        ENDIF ELSE BEGIN
           MIMC__RECALCULATE     = 1
           have_good_i           = 0
           RETURN
        ENDELSE
     ENDIF

  ENDIF

  test = !NULL
  STR_ELEMENT,alfDB_plot_struct,'orbRange',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__orbRange) GT 0 THEN BEGIN
        IF ~ARRAY_EQUAL(MIMC__orbRange,alfDB_plot_struct.orbRange) THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,alfDB_plot_struct,'altitudeRange',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__altitudeRange) GT 0 THEN BEGIN
        IF ~ARRAY_EQUAL(MIMC__altitudeRange,alfDB_plot_struct.altitudeRange) THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF


  test = !NULL
  STR_ELEMENT,alfDB_plot_struct,'both_hemis',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__both_hemis) GT 0 THEN BEGIN
        IF MIMC__both_hemis NE MIMC_struct.both_hemis THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,alfDB_plot_struct,'north',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__north) GT 0 THEN BEGIN
        IF MIMC__north NE MIMC_struct.north THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,alfDB_plot_struct,'south',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__south) GT 0 THEN BEGIN
        IF MIMC__south NE MIMC_struct.south THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,alfDB_plot_struct,'sample_t_restriction',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__sample_t_restriction) GT 0 THEN BEGIN
        IF MIMC__sample_t_restriction NE alfDB_plot_struct.sample_t_restriction THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE 
  ENDIF

  test = !NULL
  STR_ELEMENT,alfDB_plot_struct,'include_32Hz',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__include_32Hz) GT 0 THEN BEGIN
        IF MIMC__include_32Hz NE alfDB_plot_struct.include_32Hz THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE 
  ENDIF

  test = !NULL
  STR_ELEMENT,alfDB_plot_struct,'disregard_sample_t',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__disregard_sample_t) GT 0 THEN BEGIN
        IF MIMC__disregard_sample_t NE alfDB_plot_struct.disregard_sample_t THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE 
  ENDIF

  test = !NULL
  STR_ELEMENT,MIMC_struct,'hemi',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__hemi) GT 0 THEN BEGIN
        IF MIMC__hemi NE MIMC_struct.hemi THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,MIMC_struct,'minM',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__minMLT) GT 0 THEN BEGIN
        IF MIMC__minMLT NE MIMC_struct.minM THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,MIMC_struct,'maxM',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__maxMLT) GT 0 THEN BEGIN
        IF MIMC__maxMLT NE MIMC_struct.maxM THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,MIMC_struct,'binM',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__binMLT) GT 0 THEN BEGIN
        IF MIMC__binMLT NE MIMC_struct.binM THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,MIMC_struct,'minI',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__minILAT) GT 0 THEN BEGIN
        IF MIMC__minILAT NE MIMC_struct.minI THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,MIMC_struct,'maxI',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__maxILAT) GT 0 THEN BEGIN
        IF MIMC__maxILAT NE MIMC_struct.maxI THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,MIMC_struct,'binI',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__binILAT) GT 0 THEN BEGIN
        IF MIMC__binILAT NE MIMC_struct.binI THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,alfDB_plot_struct,'EA_binning',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__EA_binning) GT 0 THEN BEGIN
        IF MIMC__EA_binning NE alfDB_plot_struct.EA_binning THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,MIMC_struct,'do_lshell',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__do_lshell) GT 0 THEN BEGIN
        IF MIMC__do_lshell NE MIMC_struct.do_lshell THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,MIMC_struct,'minL',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__minLshell) GT 0 THEN BEGIN
        IF MIMC__minLshell NE MIMC_struct.minL THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,MIMC_struct,'maxL',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__maxLshell) GT 0 THEN BEGIN
        IF MIMC__maxLshell NE MIMC_struct.maxL THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,MIMC_struct,'binL',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__binLshell) GT 0 THEN BEGIN
        IF MIMC__binLshell NE MIMC_struct.binL THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,MIMC_struct,'dayside',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__dayside) GT 0 THEN BEGIN
        IF MIMC__dayside NE MIMC_struct.dayside THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,MIMC_struct,'nightside',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__nightside) GT 0 THEN BEGIN
        IF MIMC__nightside NE MIMC_struct.nightside THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  test = !NULL
  STR_ELEMENT,alfDB_plot_struct,'HwMAurOval',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__HwMAurOval) GT 0 THEN BEGIN
        IF MIMC__HwMAurOval NE alfDB_plot_struct.HwMAurOval THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF 

  test = !NULL
  STR_ELEMENT,alfDB_plot_struct,'HwMKpInd',test
  IF SIZE(test,/TYPE) NE 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__HwMKpInd) GT 0 THEN BEGIN
        IF MIMC__HwMKpInd NE alfDB_plot_struct.HwMKpInd THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF ELSE BEGIN
        MIMC__RECALCULATE    = 1
        have_good_i          = 0
        RETURN
     ENDELSE
  ENDIF

  MIMC__RECALCULATE          = 0
  have_good_i                = 1

END