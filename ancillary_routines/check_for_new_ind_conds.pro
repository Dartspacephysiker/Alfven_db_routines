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
                            DO_LSHELL=do_lshell, $
                            MINLSHELL=minLshell, $
                            MAXLSHELL=maxLshell, $
                            BINLSHELL=binLshell, $
                            MIN_MAGCURRENT=minMC, $
                            MAX_NEGMAGCURRENT=maxNegMC, $
                            DAYSIDE=dayside, $
                            NIGHTSIDE=nightside, $
                            HAVE_GOOD_I=have_good_i, $
                            LUN=lun

  COMPILE_OPT idl2

  COMMON MLT_ILAT_MAGC_ETC

  ;; Alfven DB-specific stuff
  IF KEYWORD_SET(is_maximus) THEN BEGIN
     
     IF KEYWORD_SET(MIN_minMC) THEN BEGIN
        IF KEYWORD_SET(MIMC__MIN_minMC) THEN BEGIN
           IF MIMC__MIN_minMC NE MIN_minMC THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF
     ENDIF

     IF KEYWORD_SET(MAX_maxNegMC) THEN BEGIN
        IF KEYWORD_SET(MIMC__MAX_maxNegMC) THEN BEGIN
           IF MIMC__MAX_maxNegMC NE MAX_maxNegMC THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF
     ENDIF

     IF KEYWORD_SET(chastDB) THEN BEGIN
        IF KEYWORD_SET(MIMC__chastDB) THEN BEGIN
           IF MIMC__chastDB NE chastDB THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF
     ENDIF

     IF KEYWORD_SET(despunDB) THEN BEGIN
        IF KEYWORD_SET(MIMC__despunDB) THEN BEGIN
           IF MIMC__despunDB NE despunDB THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF
     ENDIF

     IF KEYWORD_SET(charERange) THEN BEGIN
        IF KEYWORD_SET(MIMC__charERange) THEN BEGIN
           IF ~ARRAY_EQUAL(MIMC__charERange,charERange) THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF
     ENDIF

     IF KEYWORD_SET(poyntRange) THEN BEGIN
        IF KEYWORD_SET(MIMC__poyntRange) THEN BEGIN
           IF ~ARRAY_EQUAL(MIMC__poyntRange,poyntRange) THEN BEGIN
              MIMC__RECALCULATE = 1
              have_good_i       = 0
              RETURN
           ENDIF
        ENDIF
     ENDIF

  ENDIF

  IF KEYWORD_SET(orbRange) THEN BEGIN
     IF KEYWORD_SET(MIMC__orbRange) THEN BEGIN
        IF ~ARRAY_EQUAL(MIMC__orbRange, orbRange) THEN BEGIN
           MIMC__RECALCULATE = 1
              have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(altitudeRange) THEN BEGIN
     IF KEYWORD_SET(MIMC__altitudeRange) THEN BEGIN
        IF ~ARRAY_EQUAL(MIMC__altitudeRange,altitudeRange) THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF


  IF KEYWORD_SET(both_hemis) THEN BEGIN
     IF KEYWORD_SET(MIMC__both_hemis) THEN BEGIN
        IF MIMC__both_hemis NE both_hemis THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(north) THEN BEGIN
     IF KEYWORD_SET(MIMC__north) THEN BEGIN
        IF MIMC__north NE north THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(south) THEN BEGIN
     IF KEYWORD_SET(MIMC__south) THEN BEGIN
        IF MIMC__south NE south THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(hemi) THEN BEGIN
     IF KEYWORD_SET(MIMC__hemi) THEN BEGIN
        IF MIMC__hemi NE hemi THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(HwMAurOval) THEN BEGIN
     IF KEYWORD_SET(MIMC__HwMAurOval) THEN BEGIN
        IF MIMC__HwMAurOval NE HwMAurOval THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(HwMKpInd) THEN BEGIN
     IF KEYWORD_SET(MIMC__HwMKpInd) THEN BEGIN
        IF MIMC__HwMKpInd NE HwMKpInd THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(minMLT) THEN BEGIN
     IF KEYWORD_SET(MIMC__minMLT) THEN BEGIN
        IF MIMC__minMLT NE minMLT THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(maxMLT) THEN BEGIN
     IF KEYWORD_SET(MIMC__maxMLT) THEN BEGIN
        IF MIMC__maxMLT NE maxMLT THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(binMLT) THEN BEGIN
     IF KEYWORD_SET(MIMC__binMLT) THEN BEGIN
        IF MIMC__binMLT NE binMLT THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(minILAT) THEN BEGIN
     IF KEYWORD_SET(MIMC__minILAT) THEN BEGIN
        IF MIMC__minILAT NE minILAT THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(maxILAT) THEN BEGIN
     IF KEYWORD_SET(MIMC__maxILAT) THEN BEGIN
        IF MIMC__maxILAT NE maxILAT THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(binILAT) THEN BEGIN
     IF KEYWORD_SET(MIMC__binILAT) THEN BEGIN
        IF MIMC__binILAT NE binILAT THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(DO_do_lshell) THEN BEGIN
     IF KEYWORD_SET(MIMC__DO_do_lshell) THEN BEGIN
        IF MIMC__DO_do_lshell NE DO_do_lshell THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(minLshell) THEN BEGIN
     IF KEYWORD_SET(MIMC__minLshell) THEN BEGIN
        IF MIMC__minLshell NE minLshell THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(maxLshell) THEN BEGIN
     IF KEYWORD_SET(MIMC__maxLshell) THEN BEGIN
        IF MIMC__maxLshell NE maxLshell THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(binLshell) THEN BEGIN
     IF KEYWORD_SET(MIMC__binLshell) THEN BEGIN
        IF MIMC__binLshell NE binLshell THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(dayside) THEN BEGIN
     IF KEYWORD_SET(MIMC__dayside) THEN BEGIN
        IF MIMC__dayside NE dayside THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(nightside) THEN BEGIN
     IF KEYWORD_SET(MIMC__nightside) THEN BEGIN
        IF MIMC__nightside NE nightside THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(HwMAurOval) THEN BEGIN
     IF KEYWORD_SET(MIMC__HwMAurOval) THEN BEGIN
        IF MIMC__HwMAurOval NE HwMAurOval THEN BEGIN
           MIMC__RECALCULATE = 1
           have_good_i       = 0
           RETURN
        ENDIF
     ENDIF
  ENDIF

  IF KEYWORD_SET(HwMKpInd) THEN BEGIN
     IF KEYWORD_SET(MIMC__HwMKpInd) THEN BEGIN
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