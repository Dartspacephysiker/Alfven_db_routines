;+
; NAME:              COMBINE_ALFVEN_STATS_PLOTS
;
; PURPOSE:
;
; CATEGORY:
;
; CALLING SEQUENCE:  TO BE CALLED BY ONE OF THE PLOT_ALFVEN_STATS ROUTINES
;
; INPUTS:
;
; OPTIONAL INPUTS:
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS:
;
; EXAMPLE:
;
; MODIFICATION HISTORY:
;            2016/01/01   Barn
;            2016/02/17   Added PLOTS_TO_COMBINE keyword so that we don't have to plot all the stupid plots in the H2D file
;-
PRO COMBINE_ALFVEN_STATS_PLOTS,titles, $
                               N_TO_COMBINE=n_to_combine, $
                               PLOTS_TO_COMBINE=plots_to_combine, $
                               PLOTNAMES=dataNames, $
                               TEMPFILES=tempFiles, $
                               ;; LOGAVGPLOTS=logAvgPlots, $
                               ;; MEDIANPLOT=medianPlot, $
                               OUT_IMGS_ARR=out_imgs_arr, $
                               OUT_TITLEOBJS_ARR=out_titleObjs_arr, $
                               COMBINED_TO_BUFFER=combined_to_buffer, $
                               SAVE_COMBINED_WINDOW=save_combined_window, $
                               SAVE_COMBINED_NAME=save_combined_name, $
                               PLOTSUFFIX=plotSuffix, $
                               PLOTDIR=plotDir, $
                               DELETE_PLOTS_WHEN_FINISHED=delete_plots_when_finished
   

     ;;Number of files
  nFiles                              = N_ELEMENTS(tempFiles)
  IF nFiles GT 3 THEN BEGIN
     PRINT,'COMBINE_ALFVEN_STATS_PLOTS cannot combine more than 3 plots!'
     STOP
  ENDIF

  RESTORE,tempFiles[0]
  
  ;;just clean up data names while we're here
  IF ~KEYWORD_SET(dataNames) THEN BEGIN
     dataNames                        = dataNameArr
     FOR k=0,N_ELEMENTS(dataNames)-1 DO BEGIN
        curLen                        = STRLEN(dataNames[k])-1
        WHILE STRMID(dataNames[k],curLen,1) EQ '_' DO BEGIN
           dataNames[k] = STRMID(dataNames[k],0,curLen)
           curLen                     = STRLEN(dataNames[k])-1
        ENDWHILE
     ENDFOR
  ENDIF

  IF N_ELEMENTS(plots_to_combine) GT 0 THEN BEGIN
     nPlots                        = N_ELEMENTS(plots_to_combine)
  ENDIF ELSE BEGIN
     IF ~KEYWORD_SET(n_to_combine) THEN BEGIN
        ;;Get the number of plots to combine
        nPlots                        = N_ELEMENTS(dataNames)-1
        plots_to_combine              = INDGEN(nPlots)
     ENDIF ELSE BEGIN
        nPlots                        = n_to_combine
        plots_to_combine              = INDGEN(n_to_combine)
     ENDELSE
  ENDELSE
  
  PRINT,FORMAT='("Combining these plots: ",10(A0, :,"  "))',dataNames[plots_to_combine]

  ;;Generate list of file names
  plotFileArr                      = !NULL
  FOR j=0,nFiles-1 DO BEGIN
     RESTORE,tempFiles[j]
     plotFileArr                   = [plotFileArr,plotDir+paramStr+dataNames[plots_to_combine[0]]+'.png']
  ENDFOR
  plotFileArr__list                = LIST(plotFileArr)
  
  ;;Reset the plotFileArr and get the rest, if any
  FOR i=1, nPlots-1 DO BEGIN
     plotFileArr                   = !NULL
     FOR j=0,nFiles-1 DO BEGIN
        RESTORE,tempFiles[j]
        plotFileArr                = [plotFileArr,plotDir+paramStr+dataNames[plots_to_combine[i]]+'.png']
     ENDFOR
     plotFileArr__list.add,plotFileArr
  ENDFOR
  
  out_imgs_arr                     = !NULL
  out_titleObjs_arr                = !NULL
  FOR i=0,nPlots-1 DO BEGIN
     
     save_combined_name         = paramStr + dataNames[plots_to_combine[i]] + $
                                  (KEYWORD_SET(plotSuffix) ? plotSuffix : '') + '--combined.png'
     PRINT,"Saving to " + save_combined_name + "..."
     
     TILE_THREE_PLOTS,plotFileArr__list[i],titles, $
                      OUT_IMGS=out_imgs, $
                      OUT_TITLEOBJS=out_titleObjs, $
                      COMBINED_TO_BUFFER=combined_to_buffer, $
                      SAVE_COMBINED_WINDOW=save_combined_window, $
                      SAVE_COMBINED_NAME=save_combined_name, $
                      PLOTDIR=plotDir, $
                      DELETE_PLOTS_WHEN_FINISHED=delete_plots_when_finished
     
     IF N_ELEMENTS(out_imgs) GT 0 THEN BEGIN
        out_imgs_arr              = [out_imgs_arr,out_imgs]
     ENDIF
     
     IF N_ELEMENTS(out_titleObjs) GT 0 THEN BEGIN
        out_titleObjs_arr         = [out_titleObjs_arr,out_titleObjs]
     ENDIF
  ENDFOR
  
END