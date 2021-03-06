;2016/02/16 This one has been a long time coming. We've needed a way to 
PRO PLOT_2DHISTO_FILE,file, $
                      QUANTS_TO_PLOT=quants_to_plot, $
                      PLOTDIR=plotDir, $
                      PLOTNAMEPREF=plotNamePref, $
                      OUT_PLOTNAMES=out_plotNames, $
                      DEL_PS=del_ps, $
                      MIDNIGHT=midnight, $
                      NEW_LIMITS=new_limits, $
                      QUANTS_WITH_NEW_LIMITS=quants_with_new_limits, $
                      NO_COLORBAR=no_colorbar, $
                      CB_FORCE_OOBLOW=cb_force_ooblow, $
                      CB_FORCE_OOBHIGH=cb_force_oobhigh, $
                      LUN=lun

  IF ~KEYWORD_SET(lun) THEN lun = -1

  IF N_ELEMENTS(del_ps) EQ 0 THEN del_ps = 1 ;junk postscripts by default

  IF ~KEYWORD_SET(plotDir) THEN set_plot_dir,plotDir

  IF ~KEYWORD_SET(file) THEN BEGIN
     files = DIALOG_PICKFILE(/READ, $
                             /MULTIPLE_FILES, $
                             PATH='./', $
                             TITLE='Select H2D data file to plot', $
                             FILTER='*.dat')
     PRINTF,lun,'No file selected! Exiting ...'
     RETURN
  ENDIF
  
  IF FILE_TEST(file) EQ 1 THEN BEGIN
     RESTORE,file
  ENDIF ELSE BEGIN
     PRINTF,lun,'File does not exist: ' + file
     PRINT,lun,'Exiting...'
  ENDELSE
  
  ;;Make sure this thing has data
  nH2D                          = N_ELEMENTS(h2dStrArr)
  IF nH2D EQ 0 THEN BEGIN
     PRINTF,lun,'This file contains no h2dStrArr! Out.'
     RETURN
  ENDIF

  IF N_ELEMENTS(hemi) EQ 0 THEN BEGIN
     PRINTF,lun,'This file contains no hemi variable! Out.'
     RETURN
  ENDIF

  IF N_ELEMENTS(paramStr) EQ 0 THEN BEGIN
     PRINTF,lun,'This file contains no paramStr variable! Out.'
     RETURN
  ENDIF
  IF ~KEYWORD_SET(plotNamePref) THEN plotNamePref = paramStr


  ;;Make sure we have plot bounds set up
  IF N_ELEMENTS(binM) EQ 0 OR N_ELEMENTS(minM) EQ 0 OR N_ELEMENTS(maxM) EQ 0 THEN BEGIN
     PRINTF,lun,"Don't have all MLT quantities needed! Fix."
     STOP
  ENDIF
  IF KEYWORD_SET(DO_lShell) THEN BEGIN
     IF N_ELEMENTS(binL) EQ 0 OR N_ELEMENTS(minL) EQ 0 OR N_ELEMENTS(maxL) EQ 0 THEN BEGIN
        PRINTF,lun,"Don't have all L-shell quantities needed! Fix."
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     IF N_ELEMENTS(binI) EQ 0 OR N_ELEMENTS(minI) EQ 0 OR N_ELEMENTS(maxI) EQ 0 THEN BEGIN
        PRINTF,lun,"Don't have all ILAT quantities needed! Fix."
        STOP
     ENDIF
  ENDELSE

  ;;Get names of quantities
  IF N_ELEMENTS(dataNameArr) GT 0 THEN BEGIN
     dataNames                        = dataNameArr
  ENDIF ELSE BEGIN
     dataNames                        = !NULL
     FOR k=0,N_ELEMENTS(h2dStrArr)-1 DO BEGIN
           dataNames = [dataNames,h2dStrArr[k].title]
     ENDFOR
  ENDELSE

  ;;Trim crappy leading chars, if necessary
  FOR k=0,N_ELEMENTS(dataNames)-1 DO BEGIN
     curLen                        = STRLEN(dataNames[k])-1
     WHILE STRMID(dataNames[k],curLen,1) EQ '_' DO BEGIN
        dataNames[k] = STRMID(dataNames[k],0,curLen)
        curLen                     = STRLEN(dataNames[k])-1
     ENDWHILE
  ENDFOR

  ;;Get quantities to plot
  IF N_ELEMENTS(quants_to_plot) EQ 0 THEN BEGIN
     PRINTF,lun,'Here are the quantities we have in h2dStrArr:'
     FOR i=0, nH2D-1 DO BEGIN
        PRINTF,lun,FORMAT='(I0,T8,A0)',i,dataNames[i]
     ENDFOR
     PRINTF,lun,FORMAT='(I0,T8,A0)',nH2D,'Do ALL plots except mask'
     PRINTF,lun,FORMAT='(I0,T8,A0)',nH2D+1,'Do ALL plots'

     nPrompt = STRING(FORMAT='("Enter N plots you want to do (NOTE: Type ",A0," for plots ",I0," and ",I0,"): ")','"1"',nH2D,nH2D+1)
     READ_ARRAY_FROM_USER,quants_to_plot, $
                          NPROMPT=nPrompt, $
                          PROMPT='Enter plots you want to do, separated by a space: ',/QUIET
     
     IF quants_to_plot[0] EQ nH2D   THEN quants_to_plot = INDGEN(nH2D-1)
     IF quants_to_plot[0] EQ nH2D+1 THEN quants_to_plot = INDGEN(nH2D)
  ENDIF ELSE BEGIN

  ENDELSE

  nPlots                                             = N_ELEMENTS(quants_to_plot)

  ;;Assign new limits, if requested
  IF KEYWORD_SET(new_limits) THEN BEGIN
     IF KEYWORD_SET(quants_with_new_limits) THEN nLoop = N_ELEMENTS(quants_with_new_limits)-1 ELSE nLoop = nPlots-1

     FOR i=0,nLoop DO BEGIN
        IF KEYWORD_SET(quants_with_new_limits) THEN quant_i = quants_with_new_limits[i] ELSE quant_i = i
        PRINT,STRING(FORMAT='("Setting new limits for ",A0,": ",F0.2,", ",F0.2)',h2dStrArr[quant_i].title,new_limits[0,quant_i],new_limits[1,quant_i])

        h2dStrArr[quant_i].lim = new_limits[*,quant_i]
     ENDFOR
  ENDIF


  FOR i=0,nPlots-1 DO BEGIN
     quant_i                                         = quants_to_plot[i]

     CGPS_Open, plotDir +plotNamePref+'--'+dataNames[quant_i]+'.ps', $
                /NOMATCH, $
                XSIZE=5, $
                YSIZE=5, $
                LANDSCAPE=0, $
                ENCAPSULATED=eps_output, $
                /QUIET

     PLOTH2D_STEREOGRAPHIC,h2dStrArr[quant_i],file, $
                           NO_COLORBAR=no_colorbar, $
                           CB_FORCE_OOBLOW=cb_force_ooblow, $
                           CB_FORCE_OOBHIGH=cb_force_oobhigh, $
                           MIRROR=STRUPCASE(hemi) EQ 'SOUTH', $
                           MIDNIGHT=midnight, $
                           _EXTRA=e 
     CGPS_Close 
     ;;Create a PNG file with a width of 800 pixels.
     CGPS2RASTER, plotDir + plotNamePref+'--'+dataNames[quant_i]+'.ps', $
                  /PNG, $
                  WIDTH=800, $
                  DELETE_PS=del_PS
  ENDFOR

  out_plotNames                                      = dataNames

END