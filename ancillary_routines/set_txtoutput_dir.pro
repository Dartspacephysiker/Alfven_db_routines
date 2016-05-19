;2016/05/19
PRO SET_TXTOUTPUT_DIR,txtOutputDir, $
                 FOR_STORMS=for_storms, $
                 FOR_SW_IMF=for_sw_imf, $
                 FOR_ALFVENDB=for_alfvendb, $
                 ADD_TODAY=add_today, $
                 ADD_SUFF=add_suff, $
                 ADD_DIR=add_dir, $
                 VERBOSE=verbose, $
                 LUN=lun
  
  defStormTxtOutputDir     = '/SPENCEdata/Research/Cusp/storms_Alfvens/txtOutput/'
  defSW_IMFTxtOutputDir    = '/SPENCEdata/Research/Cusp/ACE_FAST/txtOutput/'
  defAlfvenDBTxtOutputDir  = '/SPENCEdata/Research/Cusp/Alfven_db_routines/txtOutput/'

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  proceed                     = KEYWORD_SET(for_storms) + KEYWORD_SET(for_sw_imf) + KEYWORD_SET(for_alfvendb) + KEYWORD_SET(customDir)
  CASE proceed OF
     0: BEGIN
        do_customDir          = ''
        READ,do_customDir,PROMPT='SET_TXTOUTPUT_DIR: No keyword set! Are you doing a custom directory?'
        CASE STRUPCASE(STRMID(do_customDir,0,1)) OF
           'Y': BEGIN
              customDir    = ''
              READ,customDir,PROMPT='Enter custom directory, with slash at end (e.g., "/the/txtOutput/directory/"): '
              PRINT,'OK, text output going to ' + customDir + '!'
              txtOutputDir      = customDir
              proceed      = 1
              WAIT,1
           END
           'N': BEGIN
              response     = 0
              valid        = [1,2,3]
              READ,response,PROMPT='OK, select (1) for_storms, (2) for_sw_imf, or (3)for_alfvendb: '
              CASE response OF
                 1: BEGIN
                    txtOutputDir = defStormTxtOutputDir                       
                    proceed = 1
                 END
                 2: BEGIN
                    txtOutputDir = defSW_IMFTxtOutputDir
                    proceed = 1
                 END
                 3: BEGIN
                    txtOutputDir = defAlfvenDBTxtOutputDir
                    proceed = 1
                 END
                 ELSE: BEGIN
                    READ,response,PROMPT="Try again, fool. 1, 2, or 3: "
                    WHILE WHERE(response EQ valid) EQ -1 DO BEGIN
                       READ,response,PROMPT="Again: "
                       CASE response OF
                          1: BEGIN
                             txtOutputDir = defStormTxtOutputDir                       
                             proceed = 1
                          END
                          2: BEGIN
                             txtOutputDir = defSW_IMFTxtOutputDir
                             proceed = 1
                          END
                          3: BEGIN
                             txtOutputDir = defAlfvenDBTxtOutputDir
                             proceed = 1
                          END
                       ENDCASE
                    ENDWHILE
                    proceed = 1
                 END
              ENDCASE

              ;;Does user want 'TODAY' added to txtOutputDir?
              IF N_ELEMENTS(add_today) EQ 0 THEN BEGIN
                 do_add_today    = ''
                 READ,do_add_today,PROMPT="Do you want to append today's date to " + txtOutputDir + '? (y/n) '
                 CASE STRUPCASE(STRMID(do_add_today,0,1)) OF
                    'Y': BEGIN
                       add_today    = 1
                       PRINT,'OK, adding today!'
                    END
                    'N': BEGIN
                       add_today    = 0
                    END
                    ELSE: BEGIN
                       proceed = 0
                       WHILE proceed EQ 0 DO BEGIN
                          READ,do_add_today,PROMPT='Uhh, what? Say "Y"es or "N"o'
                          CASE STRUPCASE(STRMID(do_add_today,0,1)) OF
                             'Y': BEGIN
                                add_today    = 1
                                proceed      = 1
                                PRINT,'OK, adding today!'
                             END
                             'N': BEGIN
                                add_today    = 0
                                proceed      = 1
                             END
                          ENDCASE
                       ENDWHILE
                    END
                 ENDCASE
              ENDIF
           END
        ENDCASE
     END
     1: BEGIN
        CASE 1 OF
           KEYWORD_SET(for_storms): BEGIN
              txtOutputDir = defStormTxtOutputDir
           END
           KEYWORD_SET(for_sw_imf): BEGIN
              txtOutputDir = defSW_IMFTxtOutputDir
           END
           KEYWORD_SET(for_alfvendb): BEGIN
              txtOutputDir = defAlfvenDBTxtOutputDir
           END
           KEYWORD_SET(customDir): BEGIN
              txtOutputDir = customDir
           END
        ENDCASE
     END
     ELSE: BEGIN
        PRINTF,lun,'SET_TXTOUTPUT_DIR: More than one keyword set:'
        IF KEYWORD_SET(for_storms) THEN PRINTF,lun,'for_storms'
        IF KEYWORD_SET(for_sw_imf) THEN PRINTF,lun,'for_sw_imf'
        IF KEYWORD_SET(for_alfvendb) THEN PRINTF,lun,'for_alfvendb'
        IF KEYWORD_SET(for_customDir) THEN PRINTF,lun,'for_customDir'
        PRINTF,lun,'Fix it...'
        STOP
     END
  ENDCASE

  IF KEYWORD_SET(verbose) THEN PRINTF,lun,"txtOutputDir set to " + txtOutputDir

  ;; IF KEYWORD_SET(add_today) AND KEYWORD_SET(add_suff) THEN BEGIN
  ;;    txtOutputDir = txtOutputDir + GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--' + add_suff + '/'
  ;; ENDIF ELSE BEGIN
  IF KEYWORD_SET(add_today) THEN BEGIN
     txtOutputDir    = txtOutputDir + GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  ENDIF 
  IF KEYWORD_SET(add_suff) THEN BEGIN
     txtOutputDir = txtOutputDir + add_suff
  ENDIF
  ;; ENDELSE 

  ;;add final slash
  txtOutputDir  += '/'

  ;;check if this dir exists
  IF KEYWORD_SET(add_today) OR KEYWORD_SET(add_suff) OR KEYWORD_SET(customDir) THEN BEGIN
     txtOutputDir_exists = FILE_TEST(txtOutputDir,/DIRECTORY)
     IF ~txtOutputDir_exists THEN BEGIN
        IF KEYWORD_SET(verbose) THEN PRINTF,lun,"SET_TXTOUTPUT_DIR: Making directory " + txtOutputDir
        SPAWN,'mkdir -p ' + txtOutputDir
     ENDIF
     txtOutputDir_exists = FILE_TEST(txtOutputDir,/DIRECTORY)
     IF ~txtOutputDir_exists THEN BEGIN
        PRINTF,lun,'Failed to make directory: ' + txtOutputDir
        STOP
     ENDIF
  ENDIF 

END