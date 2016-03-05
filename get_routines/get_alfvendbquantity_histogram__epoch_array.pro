;2015/10/25
;Types of histograms:
;0: Just sum everything in a given bin
;1: Straight averages
;2: log averages (The data are logged by GET_DATA_FOR_ALFVENDB_EPOCH_PLOTS)
;
;2015/12/22 Added RUNNING_AVERAGE keyword. Time to get it working.
;2015/12/24 Running median too, and errors bars and things in the past few days
PRO GET_ALFVENDBQUANTITY_HISTOGRAM__EPOCH_ARRAY,alf_t_arr,alf_y_arr,HISTOTYPE=histoType, $
   HISTDATA=histData, $
   HISTTBINS=histTBins, $
   RUNNING_AVERAGE=running_average, $
   RA_T=ra_t, $
   RA_Y=ra_y, $
   RA_NONZERO_I=ra_nz_i, $
   RA_ZERO_I=ra_z_i, $
   RUNNING_MEDIAN=running_median, $
   RM_T=rm_t, $
   RM_Y=rm_y, $
   RM_NONZERO_I=rm_nz_i, $
   RM_ZERO_I=rm_z_i, $
   RUNNING_BIN_SPACING=bin_spacing, $
   RUNNING_SMOOTH_NPOINTS=running_smooth_nPoints, $
   RUNNING_BIN_OFFSET=bin_offset, $
   ;; RUNNING_BIN_L_OFFSET=bin_l_offset, $
   ;; RUNNING_BIN_R_OFFSET=bin_r_offset, $
   RUNNING_BIN_L_EDGES=bin_l_edges, $
   RUNNING_BIN_R_EDGES=bin_r_edges, $
   WINDOW_SUM=window_sum, $
   MAKE_ERROR_BARS=make_error_bars, $
   ERROR_BAR_NBOOT=error_bar_nBoot, $
   ERROR_BAR_CONFLIMIT=error_bar_confLimit, $
   OUT_ERROR_BARS=out_error_bars, $
   NEVHISTDATA=nEvHistData, $
   TAFTEREPOCH=tAfterEpoch,TBEFOREEPOCH=tBeforeEpoch, $
   HISTOBINSIZE=histoBinSize,NEVTOT=nEvTot, $
   NONZERO_I=nz_i, $
   PRINT_MAXIND_SEA_STATS=print_maxInd_sea_stats, $
   LUN=lun

  COMPILE_OPT idl2

  ;for printing stats
  epoch_stats_ranges            = [[-60,0],[0,10],[10,20],[20,30],[30,40],[40,60]] ;pre-storm, 10 hours after commencement, and 10-20 hours after
  
  IF ~KEYWORD_SET(lun) THEN lun = -1 ;stdout

  IF ~KEYWORD_SET(histoType) THEN histoType = 0

  IF N_ELEMENTS(alf_t_arr) GT 1 AND alf_t_arr[0] NE -1 THEN BEGIN
     ;;Make nEvent histo if requested or if necessary for doing averaging
        ;;Window summing uses different bin types
        IF ~KEYWORD_SET(window_sum) THEN BEGIN
           IF N_ELEMENTS(nEvHistData) EQ 0 THEN BEGIN
              nEvHistData       = HISTOGRAM(alf_t_arr,LOCATIONS=histTBins, $
                                            MAX=tAfterEpoch,MIN=-tBeforeEpoch, $
                                            BINSIZE=histoBinSize)
           ENDIF ELSE BEGIN
              nEvHistData       = HISTOGRAM(alf_t_arr,LOCATIONS=histTBins, $
                                            MAX=tAfterEpoch,MIN=-tBeforeEpoch, $
                                            BINSIZE=histoBinSize, $
                                            INPUT=nEvHistData)
              
           ENDELSE
        ENDIF ELSE BEGIN
           ;;calculate nEvent bins with bins from RUNNING_HISTO with window_sum as 
           IF N_ELEMENTS(nEvHistData) EQ 0 THEN BEGIN
              nEvHistData       = RUNNING_HISTO(alf_t_arr,window_sum, $
                                                BIN_CENTERS=histTBins, $
                                                BIN_SPACING=bin_spacing, $
                                                BIN_OFFSET=bin_offset, $
                                                ;; BIN_L_OFFSET=bin_l_offset, $
                                                ;; BIN_R_OFFSET=bin_r_offset, $
                                                BIN_L_EDGES=bin_l_edges, $
                                                BIN_R_EDGES=bin_r_edges, $
                                                XMIN=-tBeforeEpoch, $
                                                XMAX=tAfterEpoch, $
                                                DONT_TRUNCATE_EDGES=dont_truncate_edges, $
                                                /DROP_EDGES, $
                                                OUT_NONZERO_i=nz_i, $
                                                OUT_ZERO_I=z_i, $
                                                LUN=lun)
              
              histoBinsize      = (bin_r_edges[1]-bin_l_edges[1])
              PRINTF,lun,'Histo binsize set to ' + STRCOMPRESS(histobinSize,/REMOVE_ALL) + ' because of window_sum ...'
           ENDIF ELSE BEGIN
              temp_nEvHistData   = nEvHistData

              nEvHistData        = RUNNING_HISTO(alf_t_arr,window_sum, $
                                                 BIN_CENTERS=histTBins, $
                                                 BIN_SPACING=bin_spacing, $
                                                 BIN_OFFSET=bin_offset, $
                                                 ;; BIN_L_OFFSET=bin_l_offset, $
                                                 ;; BIN_R_OFFSET=bin_r_offset, $
                                                 BIN_L_EDGES=bin_l_edges, $
                                                 BIN_R_EDGES=bin_r_edges, $
                                                 XMIN=-tBeforeEpoch, $
                                                 XMAX=tAfterEpoch, $
                                                 DONT_TRUNCATE_EDGES=dont_truncate_edges, $
                                                 /DROP_EDGES, $
                                                 OUT_NONZERO_i=nz_i, $
                                                 OUT_ZERO_I=z_i, $
                                                 LUN=lun)

              nEvHistData        = nEvHistData + temp_nEvHistData
           ENDELSE
        ENDELSE

     ;;Do weighted histos
     IF ~KEYWORD_SET(only_nEvents) THEN BEGIN

        IF KEYWORD_SET(window_sum) THEN BEGIN
           PRINTF,lun,'Performing window sum ...'
           alf_t_dat    = alf_t_arr
           alf_y_dat    = alf_y_arr

           histData     = RUNNING_AVERAGE(alf_t_dat, alf_y_dat,window_sum, $
                                          BIN_OFFSET=bin_offset, $
                                          ;; BIN_L_OFFSET=bin_l_offset, $
                                          ;; BIN_R_OFFSET=bin_r_offset, $
                                          BIN_L_EDGES=bin_l_edges, $
                                          BIN_R_EDGES=bin_r_edges, $
                                          BIN_CENTERS=histTBins, $
                                          BIN_SPACING=bin_spacing, $
                                          OUT_NONZERO_I=nz_i, $
                                          OUT_ZERO_I=z_i, $
                                          SMOOTH_NPOINTS=running_smooth_nPoints, $
                                          WINDOW_SUM=window_sum, $
                                          ;; MAKE_ERROR_BARS=make_error_bars, $
                                          ;; ERROR_BAR_NBOOT=error_bar_nBoot, $
                                          ;; OUT_ERROR_BARS=out_error_bars, $
                                          XMIN=-tBeforeEpoch, $
                                          XMAX=tAfterEpoch, $
                                          /DROP_EDGES, $
                                          PRINT_STATS_FOR_THESE_RANGES=KEYWORD_SET(print_maxInd_sea_stats) ? epoch_stats_ranges : !NULL, $
                                          LUN=lun)

        ENDIF ELSE BEGIN

           nz_i = WHERE(nEvHistData NE 0,COMPLEMENT=z_i)
           IF histoType EQ 2 THEN BEGIN
              ;;probably not necessary; performing log of the data should already be handled by GET_DATA_FOR_ALFVENDB_EPOCH_PLOTS
              ;; alf_y_arr = ABS(alf_y_arr)
              valid_i   = WHERE(FINITE(alf_y_arr))
              ;; alf_t_arr = alf_t_arr[valid_i]
              alf_t_dat = alf_t_arr[valid_i]
              alf_y_dat = ALOG10(alf_y_arr[valid_i])
           ENDIF ELSE BEGIN
              alf_t_dat = alf_t_arr
              alf_y_dat = alf_y_arr
           ENDELSE
           
           IF N_ELEMENTS(histData) EQ 0 THEN BEGIN
              histData  = hist1d(alf_t_dat,alf_y_dat, $ ;LOCATIONS=histTBins, $
                                 MAX=tAfterEpoch,MIN=-tBeforeEpoch, $
                                 BINSIZE=histoBinSize)
           ENDIF ELSE BEGIN
              histData  = hist1d(alf_t_dat,alf_y_dat, $ ;LOCATIONS=histTBins, $
                                 MAX=tAfterEpoch,MIN=-tBeforeEpoch, $
                                 BINSIZE=histoBinSize, $
                                 INPUT=histData)
           ENDELSE
           
        ENDELSE
     ENDIF
  ENDIF

  ;;Perform averaging, if requested
  IF histoType GT 0 THEN BEGIN ; OR KEYWORD_SET(window_sum) THEN BEGIN

     IF KEYWORD_SET(running_average) AND KEYWORD_SET(running_median) THEN BEGIN
        PRINTF,lun,"Both running average and running median are set! Bogus!"
        PRINTF,lun,"Stopping ..."
        STOP
     ENDIF

     ;; IF KEYWORD_SET(running_average) OR KEYWORD_SET(window_sum) THEN BEGIN
     IF KEYWORD_SET(running_average) THEN BEGIN

        ra_y              = RUNNING_AVERAGE(alf_t_dat, alf_y_dat,running_average, $
                                            BIN_OFFSET=bin_offset, $
                                            ;; BIN_L_OFFSET=bin_l_offset, $
                                            ;; BIN_R_OFFSET=bin_r_offset, $
                                            BIN_L_EDGES=bin_l_edges, $
                                            BIN_R_EDGES=bin_r_edges, $
                                            BIN_CENTERS=ra_t, $
                                            BIN_SPACING=bin_spacing, $
                                            OUT_NONZERO_I=ra_nz_i, $
                                            OUT_ZERO_I=ra_z_i, $
                                            SMOOTH_NPOINTS=running_smooth_nPoints, $
                                            WINDOW_SUM=window_sum, $
                                            MAKE_ERROR_BARS=make_error_bars, $
                                            ERROR_BAR_NBOOT=error_bar_nBoot, $
                                            ERROR_BAR_CONFLIMIT=error_bar_confLimit, $
                                            OUT_ERROR_BARS=out_error_bars, $
                                            XMIN=-tBeforeEpoch, $
                                            XMAX=tAfterEpoch, $
                                            /DROP_EDGES, $
                                            PRINT_STATS_FOR_THESE_RANGES=KEYWORD_SET(print_maxInd_sea_stats) ? epoch_stats_ranges : !NULL, $
                                            LUN=lun)

        IF histoType EQ 2 THEN BEGIN

           ra_y[ra_nz_i]     = 10^(ra_y[ra_nz_i])
           ra_y[ra_z_i]      = 1e-10

           IF KEYWORD_SET(make_error_bars) THEN BEGIN
              out_error_bars[*,ra_nz_i] = 10^(out_error_bars[*,ra_nz_i])
              IF N_ELEMENTS(ra_z_i) GT 0 THEN BEGIN
                 out_error_bars[*,ra_z_i]  = REPLICATE(1e-10,2,N_ELEMENTS(ra_z_i))
              ENDIF
           ENDIF
        ENDIF

     ENDIF

     IF KEYWORD_SET(running_median) THEN BEGIN

        rm_y              = RUNNING_MEDIAN(alf_t_dat, alf_y_dat, running_median, $
                                           BIN_OFFSET=bin_offset, $
                                           ;; BIN_L_OFFSET=bin_l_offset, $
                                           ;; BIN_R_OFFSET=bin_r_offset, $
                                           BIN_L_EDGES=bin_l_edges, $
                                           BIN_R_EDGES=bin_r_edges, $
                                           BIN_CENTERS=rm_t, $
                                           BIN_SPACING=bin_spacing, $
                                           OUT_NONZERO_I=rm_nz_i, $
                                           OUT_ZERO_I=rm_z_i, $
                                           SMOOTH_NPOINTS=running_smooth_nPoints, $
                                           MAKE_ERROR_BARS=make_error_bars, $
                                           ERROR_BAR_NBOOT=error_bar_nBoot, $
                                           OUT_ERROR_BARS=out_error_bars, $
                                           XMIN=-tBeforeEpoch, $
                                           XMAX=tAfterEpoch, $
                                           /DROP_EDGES, $
                                           PRINT_STATS_FOR_THESE_RANGES=KEYWORD_SET(print_maxInd_sea_stats) ? epoch_stats_ranges : !NULL)

        IF histoType EQ 2 THEN BEGIN

           rm_y[rm_nz_i]     = 10^(rm_y[rm_nz_i])
           rm_y[rm_z_i]      = 1e-10

           IF KEYWORD_SET(make_error_bars) THEN BEGIN
              out_error_bars[*,rm_nz_i] = 10^(out_error_bars[*,rm_nz_i])
              IF N_ELEMENTS(rm_z_i) GT 0 THEN BEGIN
                 out_error_bars[*,rm_z_i]  = REPLICATE(1e-10,2,N_ELEMENTS(rm_z_i))
              ENDIF
           ENDIF
        ENDIF
     ENDIF

     IF ~KEYWORD_SET(window_sum) THEN BEGIN
        IF nz_i[0] NE -1 THEN BEGIN
           histData = DOUBLE(histData)
           histData[nz_i] = histData[nz_i]/nEvHistData[nz_i]
           histData[z_i] = 0
           
           IF histoType EQ 2 THEN BEGIN
              histData[nz_i] = 10^(histData[nz_i])
              histData[z_i] = 1e-10
           ENDIF
        ENDIF ELSE BEGIN
           PRINTF,lun,"It's all bad! Couldn't find any histo elements that were nonzero..."
        ENDELSE
     ENDIF
  ENDIF

  ;; cHistData = TOTAL(histData, /CUMULATIVE) / nEvTot
  ;; IF saveFile THEN saveStr+=',cHistData,histData,histTBins,histoBinSize'

END
