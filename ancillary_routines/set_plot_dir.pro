;2015/11/03
PRO SET_PLOT_DIR,plotDir, $
                 FOR_STORMS=for_storms, $
                 FOR_SW_IMF=for_sw_imf, $
                 FOR_ALFVENDB=for_alfvendb, $
                 ADD_TODAY=add_today, $
                 ADD_SUFF=add_suff, $
                 VERBOSE=verbose, $
                 LUN=lun
  
  defStormPlotDir     = '/SPENCEdata/Research/Cusp/storms_Alfvens/plots/'
  defSW_IMFPlotDir    = '/SPENCEdata/Research/Cusp/ACE_FAST/plots/'
  defAlfvenDBPlotDir  = '/SPENCEdata/Research/Cusp/Alfven_db_routines/plots/'

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  proceed                     = KEYWORD_SET(for_storms) + KEYWORD_SET(for_sw_imf) + KEYWORD_SET(for_alfvendb) + KEYWORD_SET(customDir)
  CASE proceed OF
     0: BEGIN
        do_customDir          = ''
        READ,do_customDir,PROMPT='SET_PLOT_DIR: No keyword set! Are you doing a custom directory?'
        WHILE proceed EQ 0 DO BEGIN
           CASE STRUPCASE(STRMID(do_customDir,0,1)) OF
              'Y': BEGIN
                 customDir    = ''
                 READ,customDir,PROMPT='Enter custom directory, with slash at end (e.g., "/the/plot/directory/")'
                 PRINT,'OK, plotting to ' + customDir + '!'
                 plotDir      = customDir
                 proceed      = 1
                 WAIT,1
              END
              'N': BEGIN
                 response     = 0
                 valid        = [1,2,3]
                 READ,response,PROMPT='OK, select (1) for_storms, (2) for_sw_imf, or (3)for_alfvendb'
                 PRINT,'PROCEED',proceed
                 PRINT,'RESPONSE',response
                 WHILE WHERE(response EQ valid) EQ -1 DO BEGIN
                    READ,response,PROMPT="Try again, fool. 1, 2, or 3."
                    CASE response OF
                       1: BEGIN
                          plotDir = defStormPlotDir                       
                       END
                       2: BEGIN
                          plotDir = defSW_IMFPlotDir
                       END
                       3: BEGIN
                          plotDir = defAlfvenDBPlotDir
                       END
                       ELSE: PRINTF,lun,'Again.'
                    ENDCASE
                 ENDWHILE
                 proceed = 1
              END
           ENDCASE
        ENDWHILE
     END
     1: BEGIN
        CASE 1 OF
           KEYWORD_SET(for_storms): BEGIN
              plotDir = defStormPlotDir
           END
           KEYWORD_SET(for_sw_imf): BEGIN
              plotDir = defSW_IMFPlotDir
           END
           KEYWORD_SET(for_alfvendb): BEGIN
              plotDir = defAlfvenDBPlotDir
           END
           KEYWORD_SET(customDir): BEGIN
              plotDir = customDir
           END
        ENDCASE
     END
     ELSE: BEGIN
        PRINTF,lun,'SET_PLOT_DIR: More than one keyword set:'
        IF KEYWORD_SET(for_storms) THEN PRINTF,lun,'for_storms'
        IF KEYWORD_SET(for_sw_imf) THEN PRINTF,lun,'for_sw_imf'
        IF KEYWORD_SET(for_alfvendb) THEN PRINTF,lun,'for_alfvendb'
        IF KEYWORD_SET(for_customDir) THEN PRINTF,lun,'for_customDir'
        PRINTF,lun,'Fix it...'
        STOP
     END
  ENDCASE

  IF KEYWORD_SET(verbose) THEN PRINTF,lun,"plotDir set to " + plotDir

  IF KEYWORD_SET(add_today) AND KEYWORD_SET(add_suff) THEN BEGIN
     plotDir = plotDir + GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--' + add_suff + '/'
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(add_today) THEN BEGIN
        plotDir = plotDir + GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '/'
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(add_suff) THEN BEGIN
           plotDir = plotDir + add_suff + '/'
        ENDIF
     ENDELSE
  ENDELSE 

  ;;check if this dir exists
  IF KEYWORD_SET(add_today) OR KEYWORD_SET(add_suff) OR KEYWORD_SET(customDir) THEN BEGIN
     plotDir_exists = FILE_TEST(plotDir,/DIRECTORY)
     IF ~plotDir_exists THEN BEGIN
        IF KEYWORD_SET(verbose) THEN PRINTF,lun,"SET_PLOT_DIR: Making directory " + plotDir
        SPAWN,'mkdir -p ' + plotDir
     ENDIF
     plotDir_exists = FILE_TEST(plotDir,/DIRECTORY)
     IF ~plotDir_exists THEN BEGIN
        PRINTF,lun,'Failed to make directory: ' + plotDir
        STOP
     ENDIF
  ENDIF 

END