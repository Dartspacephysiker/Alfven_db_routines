;;12/07/16
PRO COMPARE_MIMC_STRUCT,MIMC_struct1,MIMC_struct2,INDS_RESET=inds_reset,DBS_RESET=DBs_reset

  COMPILE_OPT IDL2

  inds_reset = 0B
  DBS_reset  = 0B

  IF MIMC_struct1.minMC NE MIMC_struct2.minMC THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"minMC", $
           MIMC_struct1.minMC,MIMC_struct2.minMC
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.maxNegMC NE MIMC_struct2.maxNegMC THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"maxNegMC", $
           MIMC_struct1.maxNegMC,MIMC_struct2.maxNegMC
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.minM NE MIMC_struct2.minM THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"minM", $
           MIMC_struct1.minM,MIMC_struct2.minM
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.maxM NE MIMC_struct2.maxM THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"maxM", $
           MIMC_struct1.maxM,MIMC_struct2.maxM
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.minI NE MIMC_struct2.minI THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"minI", $
           MIMC_struct1.minI,MIMC_struct2.minI
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.maxI NE MIMC_struct2.maxI THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"maxI", $
           MIMC_struct1.maxI,MIMC_struct2.maxI
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.hemi NE MIMC_struct2.hemi THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",A0,", ",A0,"! Resetting ...")',"hemi", $
           MIMC_struct1.hemi,MIMC_struct2.hemi
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.north NE MIMC_struct2.north THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"north", $
           MIMC_struct1.north,MIMC_struct2.north
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.south NE MIMC_struct2.south THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"south", $
           MIMC_struct1.south,MIMC_struct2.south
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.both_hemis NE MIMC_struct2.both_hemis THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"both_hemis", $
           MIMC_struct1.both_hemis,MIMC_struct2.both_hemis
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.dayside NE MIMC_struct2.dayside THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"dayside", $
           MIMC_struct1.dayside,MIMC_struct2.dayside
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.nightside NE MIMC_struct2.nightside THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"nightside", $
           MIMC_struct1.nightside,MIMC_struct2.nightside
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.do_lShell NE MIMC_struct2.do_lShell THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"do_lShell", $
           MIMC_struct1.do_lShell,MIMC_struct2.do_lShell
     inds_reset = 1B
  ENDIF

  IF MIMC_struct1.use_AACGM NE MIMC_struct2.use_AACGM THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"use_AACGM", $
           MIMC_struct1.use_AACGM,MIMC_struct2.use_AACGM
     DBs_reset  = 1B
  ENDIF

  IF MIMC_struct1.use_MAG NE MIMC_struct2.use_MAG THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"use_MAG", $
           MIMC_struct1.use_MAG,MIMC_struct2.use_MAG
     DBs_reset  = 1B
  ENDIF

  IF MIMC_struct1.use_GEO NE MIMC_struct2.use_GEO THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"use_GEO", $
           MIMC_struct1.use_GEO,MIMC_struct2.use_GEO
     DBs_reset  = 1B
  ENDIF

  IF MIMC_struct1.use_SDT NE MIMC_struct2.use_SDT THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",I0,", ",I0,"! Resetting ...")',"use_SDT", $
           MIMC_struct1.use_SDT,MIMC_struct2.use_SDT
     DBs_reset  = 1B
  ENDIF

  IF MIMC_struct1.coordinate_system NE MIMC_struct2.coordinate_system THEN BEGIN
     PRINT,FORMAT='("Different values for ",A-20," : ",A0,", ",A0,"! Resetting ...")',"coordinate_system", $
           MIMC_struct1.coordinate_system,MIMC_struct2.coordinate_system
     DBs_reset  = 1B
  ENDIF

  except_list = ['minMC', $
                 'maxNegMC', $
                 'binM', $
                 'shiftM', $
                 'binI', $
                 'minI', $
                 'maxI', $
                 'minM', $
                 'maxM', $
                 'hemi', $
                 'north', $
                 'south', $
                 'both_hemis', $
                 'dayside', $
                 'nightside', $
                 'do_lShell', $
                 'use_AACGM', $
                 'use_MAG', $
                 'use_GEO', $
                 'use_SDT', $
                 'coordinate_system']

  comp = COMPARE_STRUCT(MIMC_struct1,MIMC_struct2,/RECUR_A,/RECUR_B,EXCEPT=except_list)

  FOR k=0,N_ELEMENTS(comp)-1 DO BEGIN
     tmpComp  = comp[k]

     dontstop = 0
     IF tmpComp.nDiff GT 0 THEN BEGIN

        IF KEYWORD_SET(dontStop) THEN BEGIN
           PRINT,'Not stopping!'
        ENDIF ELSE BEGIN
           HELP,tmpComp
           PRINT,'MIMC__struct1 : ',MIMC_struct1.(tmpComp.tag_num_A)
           PRINT,'MIMC__struct2 : ',MIMC_struct2.(tmpComp.tag_num_B)
           STOP
        ENDELSE
     ENDIF

  ENDFOR


END
