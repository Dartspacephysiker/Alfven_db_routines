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

  IF KEYWORD_SET(for_storms) THEN BEGIN
     plotDir = defStormPlotDir
     IF KEYWORD_SET(verbose) THEN PRINTF,lun,'Using storms plotdir: ' +defStormPlotDir
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(for_sw_imf) THEN BEGIN
        plotDir = defSW_IMFPlotDir
        IF KEYWORD_SET(verbose) THEN PRINTF,lun,'Using SW/IMF plotdir: ' +defSW_IMFPlotDir
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(for_alfvendb) THEN BEGIN
           plotDir = defAlfvenDBPlotDir
           IF KEYWORD_SET(verbose) THEN PRINTF,lun,'Using Alfven DB plotdir: ' +defAlfvenDBPlotDir
        ENDIF ELSE BEGIN
           plotDir = defAlfvenDBPlotDir
        ENDELSE
     ENDELSE
  ENDELSE

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
  IF KEYWORD_SET(add_today) OR KEYWORD_SET(add_suff) THEN BEGIN
     plotDir_exists = FILE_TEST(plotDir,/DIRECTORY)
     IF ~plotDir_exists THEN BEGIN
        IF KEYWORD_SET(verbose) THEN PRINTF,lun,"SET_PLOT_DIR: Making directory " + plotDir
        SPAWN,'mkdir ' + plotDir
     ENDIF
     plotDir_exists = FILE_TEST(plotDir,/DIRECTORY)
     IF ~plotDir_exists THEN BEGIN
        PRINTF,lun,'Failed to make directory: ' + plotDir
        STOP
     ENDIF
  ENDIF 

END