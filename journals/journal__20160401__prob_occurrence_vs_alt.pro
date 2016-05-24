PRO JOURNAL__20160401__PROB_OCCURRENCE_VS_ALT

  outPlot_pref                   = "journal__20160401__plot_probOccurrence_vs_alt--"
  outFile_dir                    = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/'
  outFile_dat                    = 'probOccurrence_vs_alt_data.sav'

  nonstorm                       = 0
  do_not_consider_IMF            = 1

  minAlt                         = 340
  maxAlt                         = 4175
  altDelta                       = 200

  altArr                         = INDGEN((maxAlt-minAlt)/altDelta+1)*altDelta + minAlt
  altArr                         = [altArr,4175] ;;add last one

  altStr                         = STRING(FORMAT='("--altDelta_",I0,"km")',altDelta)

  ;;DB stuff
  do_despun                      = 1

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Customize 'em!
  hemi                           = 'NORTH'
  minILAT                        = 61
  maxILAT                        = 85

  ;; Looks like Southern Hemi cells split around 11.25, and the important stuff is below -71 
  ;; hemi                           = 'SOUTH'
  ;; minILAT                        = -85
  ;; maxILAT                        = -61

  minMLT                         = 12
  maxMLT                         = 18

  MLTILATStr                     = STRING(FORMAT='("--minMLT_",F0.2,"__maxMLT_",F0.2)',minMLT,maxMLT) $
                                   + STRING(FORMAT='("--minILAT_",F0.2,"__maxILAT_",F0.2)',minILAT,maxILAT)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Plot stuff

  ;; plot_i_list_list               = LIST()
  ;; fastloc_i_list_list            = LIST()
  ;; title_list                     = LIST()
  probOcc=!NULL
  nAlts                         = N_ELEMENTS(altArr)
  ;;loop over clockstrings, then cells
  FOR alt_i=0,nAlts-2 DO BEGIN
     altitudeRange               = [altArr[alt_i],altArr[alt_i+1]]

     PRINT,altitudeRange
     SET_ALFVENDB_PLOT_DEFAULTS,ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                                MINMLT=minMLT,MAXMLT=maxMLT, $
                                BINMLT=binMLT, $
                                SHIFTMLT=shiftMLT, $
                                MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                                MIN_MAGCURRENT=minMC, $
                                MAX_NEGMAGCURRENT=maxNegMC, $
                                HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                DO_DESPUNDB=do_despun, $
                                HEMI=hemi, $
                                BOTH_HEMIS=both_hemis, $
                                DATADIR=dataDir, $
                                PARAMSTRING=paramString, $
                                PARAMSTRPREFIX=plotPrefix, $
                                PARAMSTRSUFFIX=plotSuffix,$
                                /DONT_CORRECT_ILATS, $
                                HOYDIA=hoyDia,LUN=lun,_EXTRA=e
     
     SET_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr, $
                                     ANGLELIM1=angleLim1, $
                                     ANGLELIM2=angleLim2, $
                                     ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                     BYMIN=byMin, $
                                     BZMIN=bzMin, $
                                     BYMAX=byMax, $
                                     BZMAX=bzMax, $
                                     DO_ABS_BYMIN=do_abs_byMin, $
                                     DO_ABS_BYMAX=do_abs_byMax, $
                                     DO_ABS_BZMIN=do_abs_bzMin, $
                                     DO_ABS_BZMAX=do_abs_bzMax, $
                                     BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                     DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                     PARAMSTRING=paramString, $
                                     PARAMSTR_LIST=paramString_list, $
                                     SATELLITE=satellite, $
                                     OMNI_COORDS=omni_Coords, $
                                     DELAY=delay, $
                                     STABLEIMF=stableIMF, $
                                     SMOOTHWINDOW=smoothWindow, $
                                     INCLUDENOCONSECDATA=includeNoConsecData, $
                                     LUN=lun
     
     plot_i_list                    = GET_RESTRICTED_AND_INTERPED_DB_INDICES(maximus,satellite,delay,LUN=lun, $
                                                                             DBTIMES=cdbTime,dbfile=dbfile, $
                                                                             DO_DESPUNDB=do_despun, $
                                                                             HEMI=hemi, $
                                                                             ORBRANGE=orbRange, $
                                                                             ALTITUDERANGE=altitudeRange, $
                                                                             CHARERANGE=charERange, $
                                                                             POYNTRANGE=poyntRange, $
                                                                             MINMLT=minMLT,MAXMLT=maxMLT, $
                                                                             BINM=binMLT, $
                                                                             SHIFTM=shiftMLT, $
                                                                             MINILAT=minILAT, $
                                                                             MAXILAT=maxILAT, $
                                                                             BINI=binILAT, $
                                                                             DO_LSHELL=do_lshell, $
                                                                             MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                                                             SMOOTHWINDOW=smoothWindow, $
                                                                             BYMIN=byMin,BZMIN=bzMin, $
                                                                             BYMAX=byMax,BZMAX=bzMax, $
                                                                             DO_ABS_BYMIN=do_abs_byMin, $
                                                                             DO_ABS_BYMAX=do_abs_byMax, $
                                                                             DO_ABS_BZMIN=do_abs_bzMin, $
                                                                             DO_ABS_BZMAX=do_abs_bzMax, $
                                                                             CLOCKSTR=clockStr, $
                                                                             RESTRICT_WITH_THESE_I=restrict_with_these_i, $
                                                                             BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
                                                                             STABLEIMF=stableIMF, $
                                                                             DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                                                             OMNI_COORDS=omni_Coords, $
                                                                             OUT_OMNI_PARAMSTR=omni_paramStr, $
                                                                             ANGLELIM1=angleLim1, $
                                                                             ANGLELIM2=angleLim2, $
                                                                             HWMAUROVAL=HwMAurOval, $
                                                                             HWMKPIND=HwMKpInd, $
                                                                             NO_BURSTDATA=no_burstData)


     GET_FASTLOC_INDS_IMF_CONDS_V2,fastLocInterped_i_list, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                   ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                   CLOCKSTR=clockStr, $
                                   BYMIN=byMin, $
                                   BYMAX=byMax, $
                                   BZMIN=bzMin, $
                                   BZMAX=bzMax, $
                                   DO_ABS_BYMIN=abs_byMin, $
                                   DO_ABS_BYMAX=abs_byMax, $
                                   DO_ABS_BZMIN=abs_bzMin, $
                                   DO_ABS_BZMAX=abs_bzMax, $
                                   MINMLT=minMLT,MAXMLT=maxMLT, $
                                   BINM=binMLT, $
                                   SHIFTM=shiftMLT, $
                                   MINILAT=minILAT, $
                                   MAXILAT=maxILAT, $
                                   BINI=binILAT, $
                                   SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                   HEMI=hemi, $
                                   STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                   HWMAUROVAL=0,HWMKPIND=!NULL, $
                                   ;; MAKE_OUTINDSFILE=1, $
                                   OUTINDSPREFIX=indsFilePrefix,OUTINDSSUFFIX=indsFileSuffix,OUTINDSFILEBASENAME=outIndsBasename, $
                                   ;; FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                   ;; FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, $
                                   DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                   FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                   BURSTDATA_EXCLUDED=burstData_excluded, $
                                   GET_FASTLOC_STRUCT=(N_ELEMENTS(fastLoc) EQ 0), $
                                   GET_FASTLOC_DELTA_T=(N_ELEMENTS(fastLoc_delta_t) EQ 0), $
                                   OUT_FASTLOC_STRUCT=fastLoc, $
                                   OUT_FASTLOC_DELTA_T=fastLoc_delta_t
     
     
     
     ;; plot_i_list_list.add,plot_i_list
     ;; fastLocInterped_i_list_list.add,fastLocInterped_i_list
     ;; title_list.add,
     
     numerator   = TOTAL(maximus.width_time[plot_i_list[0]])
     denominator = TOTAL(fastLoc_delta_t[fastLocInterped_i_list])
     probOcc     = [probOcc,numerator/denominator]

  ENDFOR


  xRange    = [altArr[0],altArr[-1]]
  ;; yRangeMin = MIN(probOcc,MAX=yRangeMax)
  yRangeMin = 0
  yRangeMax = CEIL(MAX(probOcc)*20.)/20.

  WINDOW_CUSTOM_SETUP,NPLOTCOLUMNS=1, $
                      NPLOTROWS=1, $
                      SPACE_HORIZ_BETWEEN_COLS=0.08, $
                      SPACE_VERT_BETWEEN_ROWS=0.04, $
                      SPACE_FOR_ROW_NAMES=0.05, $
                      SPACE_FOR_COLUMN_NAMES=0.05, $
                      XTITLE='Altitude (km)', $
                      YTITLE='Probability of Occurrence', $
                      CURRENT_WINDOW=window,/MAKE_NEW
  
  plot  = PLOT(altArr,probOcc, $
               TITLE=MLTILATStr, $
               XRANGE=xRange, $
               YRANGE=[yRangeMin,yRangeMax], $
               /HISTOGRAM, $
               THICK=3.0, $
               CURRENT=window, $
               POSITION=WINDOW_CUSTOM_NEXT_POS(/NEXT_ROW))

  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY

  outPlot = outPlot_pref + hemi + MLTILATStr+altStr+'.png'
  PRINT,'saving ' + outPlot
  window.save,plotDir+outPlot

     save,probOcc,altArr,nAlts,altDelta, $
          ;; title_list, $
          hemi,minMLT,maxMLT,minILAT,maxILAT, $
          FILENAME=outFile_dir+outFile_dat


END