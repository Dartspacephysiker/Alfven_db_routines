;2015/11/03
PRO SET_PLOT_DIR,plotDir, $
                 FOR_STORMS=for_storms, $
                 FOR_SW_IMF=for_sw_imf, $
                 FOR_ALFVENDB=for_alfvendb, $
                 FOR_ESPEC_DB=for_eSpec_db, $
                 FOR_SDT=for_sdt, $
                 ADD_TODAY=add_today, $
                 ADD_SUFF=add_suff, $
                 ADD_DIR=add_dir, $
                 VERBOSE=verbose, $
                 LUN=lun
  
  defStormPlotDir     = '/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/plots/'
  defSW_IMFPlotDir    = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/plots/'
  defAlfvenDBPlotDir  = '/SPENCEdata/Research/Satellites/FAST/Alfven_db_routines/plots/'
  defeSpecPlotDir     = '/SPENCEdata/Research/Satellites/FAST/espec_identification/plots/'
  defSDTDir           = '/SPENCEdata/software/sdt/batch_jobs/plots/'

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  proceed                     = KEYWORD_SET(for_storms)   + KEYWORD_SET(for_sw_imf) + $
                                KEYWORD_SET(for_alfvendb) + KEYWORD_SET(customDir) + $
                                KEYWORD_SET(for_sdt)      + KEYWORD_SET(for_eSpec_db)
  CASE proceed OF
     0: BEGIN
        do_customDir          = ''
        READ,do_customDir,PROMPT='SET_PLOT_DIR: No keyword set! Are you doing a custom directory?'
        CASE STRUPCASE(STRMID(do_customDir,0,1)) OF
           'Y': BEGIN
              customDir    = ''
              READ,customDir,PROMPT='Enter custom directory, with slash at end (e.g., "/the/plot/directory/"): '
              PRINT,'OK, plotting to ' + customDir + '!'
              plotDir      = customDir
              proceed      = 1
              WAIT,1
           END
           'N': BEGIN
              response     = 0
              valid        = [1,2,3]
              READ,response,PROMPT='OK, select (1) for_storms, (2) for_sw_imf, or (3)for_alfvendb: '
              CASE response OF
                 1: BEGIN
                    plotDir = defStormPlotDir                       
                    proceed = 1
                 END
                 2: BEGIN
                    plotDir = defSW_IMFPlotDir
                    proceed = 1
                 END
                 3: BEGIN
                    plotDir = defAlfvenDBPlotDir
                    proceed = 1
                 END
                 ELSE: BEGIN
                    READ,response,PROMPT="Try again, fool. 1, 2, or 3: "
                    WHILE WHERE(response EQ valid) EQ -1 DO BEGIN
                       READ,response,PROMPT="Again: "
                       CASE response OF
                          1: BEGIN
                             plotDir = defStormPlotDir                       
                             proceed = 1
                          END
                          2: BEGIN
                             plotDir = defSW_IMFPlotDir
                             proceed = 1
                          END
                          3: BEGIN
                             plotDir = defAlfvenDBPlotDir
                             proceed = 1
                          END
                       ENDCASE
                    ENDWHILE
                    proceed = 1
                 END
              ENDCASE

              ;;Does user want 'TODAY' added to plotDir?
              IF N_ELEMENTS(add_today) EQ 0 THEN BEGIN
                 do_add_today    = ''
                 READ,do_add_today,PROMPT="Do you want to append today's date to " + plotDir + '? (y/n) '
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
              plotDir = defStormPlotDir
           END
           KEYWORD_SET(for_sw_imf): BEGIN
              plotDir = defSW_IMFPlotDir
           END
           KEYWORD_SET(for_alfvendb): BEGIN
              plotDir = defAlfvenDBPlotDir
           END
           KEYWORD_SET(for_eSpec_db): BEGIN
              plotDir = defeSpecPlotDir
           END
           KEYWORD_SET(for_sdt): BEGIN
              plotDir = defSDTDir
           END
           KEYWORD_SET(customDir): BEGIN
              plotDir = customDir
           END
        ENDCASE
     END
     ELSE: BEGIN
        PRINTF,lun,'SET_PLOT_DIR: More than one keyword set:'
        IF KEYWORD_SET(for_storms)    THEN PRINTF,lun,'for_storms'
        IF KEYWORD_SET(for_sw_imf)    THEN PRINTF,lun,'for_sw_imf'
        IF KEYWORD_SET(for_alfvendb)  THEN PRINTF,lun,'for_alfvendb'
        IF KEYWORD_SET(for_sdt)       THEN PRINTF,lun,'for_sdt'
        IF KEYWORD_SET(for_eSpec_db)  THEN PRINTF,lun,'for_eSpec_db'
        IF KEYWORD_SET(for_customDir) THEN PRINTF,lun,'for_customDir'
        PRINTF,lun,'Fix it...'
        STOP
     END
  ENDCASE

  ;; IF KEYWORD_SET(add_today) AND KEYWORD_SET(add_suff) THEN BEGIN
  ;;    plotDir = plotDir + GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '--' + add_suff + '/'
  ;; ENDIF ELSE BEGIN
  IF KEYWORD_SET(add_today) THEN BEGIN
     plotDir    = plotDir + GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  ENDIF 
  IF KEYWORD_SET(add_suff) THEN BEGIN
     plotDir = plotDir + add_suff
  ENDIF
  ;; ENDELSE 

  ;;add final slash
  plotDir  += '/'

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

  IF KEYWORD_SET(verbose) THEN PRINTF,lun,"plotDir set to " + plotDir

END