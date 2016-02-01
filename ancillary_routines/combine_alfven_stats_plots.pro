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
;-
PRO COMBINE_ALFVEN_STATS_PLOTS,titles, $
                               N_TO_COMBINE=n_to_combine, $
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
   

     ;;Get the number of plots to combine
     RESTORE,tempFiles[0]

     IF ~KEYWORD_SET(n_to_combine) THEN BEGIN
        nPlots                        = N_ELEMENTS(dataNameArr)-1
     ENDIF ELSE BEGIN
        nPlots                        = n_to_combine
     ENDELSE
     PRINT,FORMAT='("Combining these plots: ",10(A0, :,"  "))',dataNameArr[0:nPlots-1]

     ;;What kind?
     ;; IF KEYWORD_SET(logAvgPlot) THEN BEGIN
     ;;    statType                      = 'log_avg'
     ;; ENDIF ELSE BEGIN
     ;;    IF KEYWORD_SET(medianPlot) THEN BEGIN
     ;;       statType                   = 'median'
     ;;    ENDIF ELSE BEGIN
     ;;       statType                   = 'avg'
     ;;    ENDELSE
     ;; ENDELSE

     ;;Generate list of file names
     plotFileArr                      = !NULL
     FOR j=0,2 DO BEGIN
        RESTORE,tempFiles[j]
        plotFileArr                   = [plotFileArr,plotDir+paramStr+dataNameArr[0]+'.png']
     ENDFOR
     plotFileArr__list                = LIST(plotFileArr)

     ;;Reset the plotFileArr and get the rest, if any
     FOR i=1, nPlots-1 DO BEGIN
        plotFileArr                   = !NULL
        FOR j=0,2 DO BEGIN
           RESTORE,tempFiles[j]
           plotFileArr                = [plotFileArr,plotDir+paramStr+dataNameArr[i]+'.png']
        ENDFOR
        plotFileArr__list.add,plotFileArr
     ENDFOR

     out_imgs_arr                     = !NULL
     out_titleObjs_arr                = !NULL
     FOR i=0,nPlots-1 DO BEGIN

        save_combined_name         = paramStr + dataNameArr[i] + $
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