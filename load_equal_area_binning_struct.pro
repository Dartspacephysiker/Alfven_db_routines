;;10/15/16
PRO LOAD_EQUAL_AREA_BINNING_STRUCT,EA, $
                                   HEMI=hemi, $
                                   FORCE_LOAD=force_load

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__ea_binning.pro

  IF (N_ELEMENTS(EA__s) EQ 0) OR KEYWORD_SET(force_load) THEN BEGIN

     IF KEYWORD_SET(force_load) THEN BEGIN
        PRINT,"Forced reloading of EA_binning struct!"
     ENDIF

     inDir        = '/SPENCEdata/Research/database/equal-area_binning/'
     EAbins_file  = 'equalArea--20161014--struct_and_ASCII_tmplt.idl'

     RESTORE,inDir+EAbins_file

     EA__s        = TEMPORARY(EA)
     EA__s        = CREATE_STRUCT(EA__s,'hemi','NORTH')
  ENDIF

  IF KEYWORD_SET(hemi) THEN BEGIN
     CASE STRUPCASE(hemi) OF
        'NORTH': BEGIN
           IF STRUPCASE(EA__s.hemi) EQ 'SOUTH' THEN BEGIN
              tmpMinI    = (-1.)*REVERSE(EA__s.maxI)
              tmpMaxI    = (-1.)*REVERSE(EA__s.minI)

              ;; tmpMinM    = REVERSE(EA__s.maxM)
              ;; tmpMaxM    = REVERSE(EA__s.minM)

              tmpMinM    = REVERSE(EA__s.minM)
              tmpMaxM    = REVERSE(EA__s.maxM)

              EA__s.minI = TEMPORARY(tmpMinI)
              EA__s.maxI = TEMPORARY(tmpMaxI)

              EA__s.minM = tmpMinM
              EA__s.maxM = tmpMaxM

              EA__s.hemi = 'NORTH'
           ENDIF
        END
        'SOUTH': BEGIN
           IF STRUPCASE(EA__s.hemi) EQ 'NORTH' THEN BEGIN
              tmpMinI    = (-1.)*REVERSE(EA__s.maxI)
              tmpMaxI    = (-1.)*REVERSE(EA__s.minI)

              ;; tmpMinM    = REVERSE(EA__s.maxM)
              ;; tmpMaxM    = REVERSE(EA__s.minM)

              tmpMinM    = REVERSE(EA__s.minM)
              tmpMaxM    = REVERSE(EA__s.maxM)

              EA__s.minI = TEMPORARY(tmpMinI)
              EA__s.maxI = TEMPORARY(tmpMaxI)

              EA__s.minM = tmpMinM
              EA__s.maxM = tmpMaxM

              EA__s.hemi = 'SOUTH'
           ENDIF
        END
        'GLOBE': BEGIN
           PRINT,"Can't do full globe with equal area binning ..."
           STOP
        END
        ELSE: STOP
     ENDCASE
  ENDIF

  EA = EA__s

END
