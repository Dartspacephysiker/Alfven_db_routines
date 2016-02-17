;;2016/02/17
;;Wrapper for PLOT_2DHISTO_FILE
PRO PLOT_2DHISTO_FILES_DIALOG,files, $
                              PROMPT_FOR_QUANTS_TO_PLOT_FOR_EACH_FILE=reprompt, $
                              PLOTDIR=plotDir, $
                              LUN=lun
  
  IF ~KEYWORD_SET(lun) THEN lun = -1

  IF ~KEYWORD_SET(files) THEN BEGIN
     files = DIALOG_PICKFILE(/READ, $
                             /MULTIPLE_FILES, $
                             PATH='./', $
                             TITLE='Select H2D data file(s) to plot', $
                             FILTER='*.dat')
     IF files[0] EQ '' THEN BEGIN
        PRINTF,lun,'No files selected! Exiting ...'
        RETURN
     ENDIF
  ENDIF
  nFiles = N_ELEMENTS(files)

  IF ~KEYWORD_SET(plotDir) THEN set_plot_dir,plotDir

  FOR i=0,nFiles-1 DO BEGIN
     IF KEYWORD_SET(reprompt) THEN quants_to_plot = !NULL

     plot_2dhisto_file,files[i], $
                       PLOTDIR=plotDir, $
                       QUANTS_TO_PLOT=quants_to_plot, $
                       LUN=lun
  ENDFOR
  
END