;;02/08/17
PRO JOURNAL__20170208__LOOK_AT_WIDTH_X_DISTRIBUTIONS_FOR_OLGA__CAN_WE_DIVIDE_INTO_TWO_FREQ_BANDS

  COMPILE_OPT IDL2

  PS = 1

  fileName = '~/Desktop/IAW_temporal_width'

  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,/NO_MEMORY_LOAD

  PLOT_ALFVEN_STATS__SETUP,ORBRANGE=[500,12670], $
                           MAX_NEGMAGCURRENT=-1, $
                           MIN_MAGCURRENT=1, $
                           ALTITUDERANGE=[300,4300], $
                           ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                           HEMI='BOTH', $
                           MINI=60, $
                           MAXI=90, $
                           MIMC_STRUCT=MIMC_struct, $
                           /DONT_BLACKBALL_MAXIMUS
  
  good_i = GET_CHASTON_IND(maximus,DBTIMES=cdbTime, $
                           ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                           /DO_NOT_SET_DEFAULTS, $
                           MIMC_STRUCT=MIMC_struct)

  ;; inds_LE_2_5 = WHERE(maximus.width_time LE 2.5, $
  ;;                     nLE_2_5, $
  ;;                     COMPLEMENT=inds_GT_2_5, $
  ;;                     NCOMPLEMENT=nGT_2_5)





  ;; !P.MULTI = [0,1,2,0,0]

  IF KEYWORD_SET(PS) THEN BEGIN
     POPEN,fileName
  ENDIF ELSE BEGIN
     WINDOW,0,XSIZE=700,YSIZE=700
  ENDELSE

  nEv = N_ELEMENTS(maximus.width_time[good_i])
  CGHISTOPLOT,maximus.width_time[good_i], $
              ;; TITLE="FAST Inertial Alfv" + STRING(233B) + $
              ;; "n Wave Obs (N = " + STRCOMPRESS(nEv,/REMOVE_ALL) + $
              ;; ")", $
              TITLE="FAST Inertial Alfven Wave Obs (N = " + STRCOMPRESS(nEv,/REMOVE_ALL) + $
              ")", $
              XTITLE="Temporal width (s)",MAXINPUT=5, $
              YTITLE="N Obs"
  ;; CGHISTOPLOT,maximus.width_time[inds_LE_2_5],TITLE="Temporal width (s)"

  IF KEYWORD_SET(PS) THEN BEGIN
     PRINT,"Closing " + fileName
     PCLOSE

     EPS2PDF,fileName,/TO_PNG,/PS
  ENDIF

  STOP

END
