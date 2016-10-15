PRO CHECK_FOR_NEW_IND_CONDS,is_maximus, $
                            CHASTDB=chastDB, $
                            DESPUNDB=despunDB, $
                            ORBRANGE=orbRange, $
                            ALTITUDERANGE=altitudeRange, $
                            CHARERANGE=charERange, $
                            POYNTRANGE=poyntRange, $
                            BOTH_HEMIS=both_hemis, $
                            NORTH=north, $
                            SOUTH=south, $
                            HEMI=hemi, $
                            HWMAUROVAL=HwMAurOval, $
                            HWMKPIND=HwMKpInd, $
                            MINMLT=minMLT, $
                            MAXMLT=maxMLT, $
                            BINM=binMLT, $
                            MINILAT=minILAT, $
                            MAXILAT=maxILAT, $
                            BINILAT=binILAT, $
                            EQUAL_AREA_BINNING=EA_binning, $
                            DO_LSHELL=do_lshell, $
                            MINLSHELL=minLshell, $
                            MAXLSHELL=maxLshell, $
                            BINLSHELL=binLshell, $
                            MIN_MAGCURRENT=minMC, $
                            MAX_NEGMAGCURRENT=maxNegMC, $
                            SAMPLE_T_RESTRICTION=sample_t_restriction, $
                            INCLUDE_32HZ=include_32Hz, $
                            DAYSIDE=dayside, $
                            NIGHTSIDE=nightside, $
                            HAVE_GOOD_I=have_good_i, $
                            LUN=lun

  COMPILE_OPT idl2

  COMMON MLT_ILAT_MAGC_ETC

  ;; Alfven DB-specific stuff
  IF KEYWORD_SET(is_maximus) THEN BEGIN
     
     IF N_ELEMENTS(minMC) GT 0 THEN BEGIN
        IF N_ELEMENTS(MIMC__minMC) GT 0 THEN BEGIN
           IF MIMC__minMC NE minMC THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF
     ENDIF

     IF N_ELEMENTS(maxNegMC) GT 0 THEN BEGIN
        IF N_ELEMENTS(MIMC__maxNegMC) GT 0 THEN BEGIN
           IF MIMC__maxNegMC NE maxNegMC THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF
     ENDIF

     IF N_ELEMENTS(chastDB) GT 0 THEN BEGIN
        IF N_ELEMENTS(MIMC__chastDB) GT 0 THEN BEGIN
           IF MIMC__chastDB NE chastDB THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF
     ENDIF

     ;; IF N_ELEMENTS(despunDB) GT 0 THEN BEGIN
     ;;    IF N_ELEMENTS(MIMC__despunDB) GT 0 THEN BEGIN
     ;;       IF MIMC__despunDB NE despunDB THEN BEGIN
     IF  ( KEYWORD_SET(despunDB) AND ~KEYWORD_SET(MIMC__despunDB) ) OR $
         ( ~KEYWORD_SET(despunDB) AND KEYWORD_SET(MIMC__despunDB) )    $
     THEN BEGIN
        ;; IF N_ELEMENTS(MIMC__despunDB) GT 0 THEN BEGIN
        ;; IF MIMC__despunDB NE despunDB THEN BEGIN
        MIMC__RECALCULATE = 1
        have_good_i       = 0
        RETURN
        ;; ENDIF
        ;; ENDIF
     ENDIF

     IF N_ELEMENTS(charERange) GT 0 THEN BEGIN
        IF N_ELEMENTS(MIMC__charERange) GT 0 THEN BEGIN
           IF ~ARRAY_EQUAL(MIMC__charERange,charERange) THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF
     ENDIF

     IF N_ELEMENTS(poyntRange) GT 0 THEN BEGIN
        IF N_ELEMENTS(MIMC__poyntRange) GT 0 THEN BEGIN
           IF ~ARRAY_EQUAL(MIMC__poyntRange,poyntRange) THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF
     ENDIF

  ENDIF

  IF N_ELEMENTS(orbRange) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__orbRange) GT 0 THEN BEGIN
        IF ~ARRAY_EQUAL(MIMC__orbRange, orbRange) THEN BEGIN
           MIMC__RECALCULATE = 1
              have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(altitudeRange) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__altitudeRange) GT 0 THEN BEGIN
        IF ~ARRAY_EQUAL(MIMC__altitudeRange,altitudeRange) THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF


  IF N_ELEMENTS(both_hemis) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__both_hemis) GT 0 THEN BEGIN
        IF MIMC__both_hemis NE both_hemis THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(north) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__north) GT 0 THEN BEGIN
        IF MIMC__north NE north THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(south) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__south) GT 0 THEN BEGIN
        IF MIMC__south NE south THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(sample_t_restriction) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__sample_t_restriction) GT 0 THEN BEGIN
        IF MIMC__sample_t_restriction NE sample_t_restriction THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF 
  ENDIF

  IF N_ELEMENTS(include_32Hz) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__include_32Hz) GT 0 THEN BEGIN
        IF MIMC__include_32Hz NE include_32Hz THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF 
  ENDIF

  IF N_ELEMENTS(hemi) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__hemi) GT 0 THEN BEGIN
        IF MIMC__hemi NE hemi THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(minMLT) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__minMLT) GT 0 THEN BEGIN
        IF MIMC__minMLT NE minMLT THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(maxMLT) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__maxMLT) GT 0 THEN BEGIN
        IF MIMC__maxMLT NE maxMLT THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(binMLT) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__binMLT) GT 0 THEN BEGIN
        IF MIMC__binMLT NE binMLT THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(minILAT) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__minILAT) GT 0 THEN BEGIN
        IF MIMC__minILAT NE minILAT THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(maxILAT) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__maxILAT) GT 0 THEN BEGIN
        IF MIMC__maxILAT NE maxILAT THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(binILAT) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__binILAT) GT 0 THEN BEGIN
        IF MIMC__binILAT NE binILAT THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(EA_binning) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__EA_binning) GT 0 THEN BEGIN
        IF MIMC__EA_binning NE EA_binning THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(do_lshell) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__do_lshell) GT 0 THEN BEGIN
        IF MIMC__do_lshell NE do_lshell THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(minLshell) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__minLshell) GT 0 THEN BEGIN
        IF MIMC__minLshell NE minLshell THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(maxLshell) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__maxLshell) GT 0 THEN BEGIN
        IF MIMC__maxLshell NE maxLshell THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(binLshell) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__binLshell) GT 0 THEN BEGIN
        IF MIMC__binLshell NE binLshell THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(dayside) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__dayside) GT 0 THEN BEGIN
        IF MIMC__dayside NE dayside THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(nightside) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__nightside) GT 0 THEN BEGIN
        IF MIMC__nightside NE nightside THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(HwMAurOval) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__HwMAurOval) GT 0 THEN BEGIN
        IF MIMC__HwMAurOval NE HwMAurOval THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF N_ELEMENTS(HwMKpInd) GT 0 THEN BEGIN
     IF N_ELEMENTS(MIMC__HwMKpInd) GT 0 THEN BEGIN
        IF MIMC__HwMKpInd NE HwMKpInd THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  MIMC__RECALCULATE          = 0
  have_good_i                = 1

END