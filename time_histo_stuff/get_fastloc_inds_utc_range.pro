;+
;;Note, MINMLT,MAXILAT, etc., keywords got added 2015/10/27, and they may screw up other stuff. Just so
;;you know!
;2016/02/05 Nowe we have fastLoc4, which isn't full of lies.
;2015/10/21 Now using output from fastLoc_intervals3, which includes magnetometer sampling rates
;2015/04/09
;this can be used as a standalone routine or else called by plot_alfven_stats_imf_screening when
;making a plot of n events per minute
;-
PRO GET_FASTLOC_INDS_UTC_RANGE,fastLocInterped_i, $
                               LIST_TO_ARR=list_to_arr, $
                               T1_ARR=t1_arr, $
                               T2_ARR=t2_arr, $
                               OUT_GOOD_TARR_I=out_good_tArr_i, $
                               ORBRANGE=orbRange, $
                               ALTITUDERANGE=altitudeRange, $
                               CHARERANGE=charERange, $
                               HEMI=hemi, $
                               HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                               STORMSTRING=stormString, $
                               DSTCUTOFF=dstCutoff, $
                               MAKE_OUTINDSFILE=make_outIndsFile, $
                               OUTINDSPREFIX=outIndsPrefix, $
                               OUTINDSSUFFIX=outIndsSuffix, $
                               OUTINDSFILEBASENAME=outIndsFileBasename, $
                               FASTLOC_STRUCT=fastLoc_in, $
                               FASTLOC_TIMES=fastLoc_Times_in, $
                               FASTLOC_DELTA_T=fastLoc_delta_t_in, $
                               OUT_FASTLOC_STRUCT=fastLoc_out, $
                               OUT_FASTLOC_TIMES=fastLoc_times_out, $
                               OUT_FASTLOC_DELTA_T=fastLoc_delta_t_out, $
                               FASTLOCFILE=fastLocFile_in, $
                               FASTLOCTIMEFILE=fastLocTimeFile_in, $
                               FASTLOCOUTPUTDIR=fastLocOutputDir, $
                               ;;Note, all of the following keywords got added 2015/10/27, and they may screw up other stuff. Just so
                               ;;you know!
                               ;; RESTRICT_ALTRANGE=restrict_altRange, $
                               ;; RESTRICT_CHARERANGE=restrict_charERange, $
                               ;; RESTRICT_ORBRANGE=restrict_orbRange, $
                               MINMLT=minM, $
                               MAXMLT=maxM,BINM=binM, $
                               MINILAT=minI, $
                               MAXILAT=maxI, $
                               BINI=binI, $
                               DO_LSHELL=do_lshell, $
                               MINLSHELL=minL, $
                               MAXLSHELL=maxL, $
                               BINL=binL, $
                               RESET_GOOD_INDS=reset_good_inds, $
                               DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                               FOR_ESPEC_DBS=for_eSpec_DBs, $
                               LET_OVERLAPS_FLY__FOR_SEA=let_overlaps_fly__for_sea



  COMPILE_OPT idl2,strictarrsubs

  ;;Defined here, in GET_FASTLOC_INDS_IMF_CONDS_V2, and in GET_CHASTON_INDS
  @common__fastloc_vars.pro
  @common__fastloc_espec_vars.pro

  ;; COMMON FL_VARS
  ;; COMMON FL_ESPEC_VARS

  ;; minM=0
  ;; maxM=24
  ;; minI=-88
  ;; maxI=88

  IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
     IF KEYWORD_SET(fastLoc_in) AND ~KEYWORD_SET(FL_eSpec__fastLoc) THEN BEGIN
        FL_eSpec__fastLoc = fastLoc_in
     ENDIF

     IF KEYWORD_SET(fastLoc_times_in) AND ~KEYWORD_SET(FASTLOC_E__times) THEN BEGIN
        FASTLOC_E__times = fastLoc_times_in
     ENDIF

     IF KEYWORD_SET(fastLoc_delta_t_in) AND ~KEYWORD_SET(FASTLOC_E__delta_t) THEN BEGIN
        FASTLOC_E__delta_t = fastLoc_delta_t_in
     ENDIF

     IF KEYWORD_SET(fastLocFile_in) AND ~KEYWORD_SET(FASTLOC_E__dbFile) THEN BEGIN
        FASTLOC_E__dbFile = fastLocFile_in
     ENDIF

     IF KEYWORD_SET(fastLocTimeFile_in) AND ~KEYWORD_SET(FASTLOC_E__dbTimesFile) THEN BEGIN
        FASTLOC_E__dbTimesFile = fastLocTimeFile_in
     ENDIF     
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(fastLoc_in) AND ~KEYWORD_SET(FL__fastLoc) THEN BEGIN
        FL_eSpec__fastLoc = fastLoc_in
     ENDIF

     IF KEYWORD_SET(fastLoc_times_in) AND ~KEYWORD_SET(FASTLOC__times) THEN BEGIN
        FASTLOC__times = fastLoc_times_in
     ENDIF

     IF KEYWORD_SET(fastLoc_delta_t_in) AND ~KEYWORD_SET(FASTLOC__delta_t) THEN BEGIN
        FASTLOC__delta_t = fastLoc_delta_t_in
     ENDIF

     IF KEYWORD_SET(fastLocFile_in) AND ~KEYWORD_SET(FASTLOC__dbFile) THEN BEGIN
        FASTLOC__dbFile = fastLocFile_in
     ENDIF

     IF KEYWORD_SET(fastLocTimeFile_in) AND ~KEYWORD_SET(FASTLOC__dbTimesFile) THEN BEGIN
        FASTLOC__dbTimesFile = fastLocTimeFile_in
     ENDIF
  ENDELSE




  ;; fastLocOutputDir = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals3/time_histos/'
  defFastLocOutputDir = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/time_histos/'
  IF N_ELEMENTS(fastLocOutputDir) EQ 0 THEN fastLocOutputDir = defFastLocOutputDir
  IF NOT KEYWORD_SET(lun) THEN lun = -1 ;stdout
  
  PRINTF,lun,'GET_FASTLOC_INDS_UTC_RANGE is starting...'

  IF N_ELEMENTS(list_to_arr) EQ 0 THEN list_to_arr = 1

  IF KEYWORD_SET(stormString) THEN BEGIN
     IF KEYWORD_SET(DstCutoff) THEN BEGIN
        stormFile = TODAYS_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTLOC_INDICES(STORMSTRING=stormString,DSTCUTOFF=DstCutoff)
        IF FILE_TEST(stormFile) THEN BEGIN
           IF KEYWORD_SET(reset_good_inds) THEN BEGIN
              PRINTF,lun,"Already have " + stormString + "inds, but resetting..."
           ENDIF ELSE BEGIN
              PRINTF,lun,"Already have " + stormString + "inds! Restoring today's file..."
              RESTORE,stormFile
              IF N_ELEMENTS(fastLocInterped_i) GT 0 THEN RETURN ELSE BEGIN
                 PRINTF,lun,"stormFile was a blank! It didn't contain fastLocInterped_i..."
                 STOP
                 ENDELSE
           ENDELSE
        ENDIF 
     ENDIF ELSE BEGIN
        PRINTF,lun,"stormString is set (" + stormString + "), but no Dst cutoff provided! Something's wrong..."
        STOP
     ENDELSE
  ENDIF

  ;;Load FastLoc & Co.
  ;; LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastLoc_times,fastLoc_delta_t,DBDir=DBDir,DBFile=FastLocFile,DB_tFile=FastLocTimeFile,LUN=lun
  
  SET_ALFVENDB_PLOT_DEFAULTS,ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, POYNTRANGE=poyntRange, $
                             MINMLT=minM,MAXMLT=maxM,BINMLT=binM,MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                             DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                             MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                             HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                             MIN_NEVENTS=min_nEvents, MASKMIN=maskMin, $
                             HEMI=hemi, $
                             NPLOTS=nPlots, $
                             EPLOTS=ePlots, EFLUXPLOTTYPE=eFluxPlotType, $
                             ENUMFLPLOTS=eNumFlPlots, ENUMFLPLOTTYPE=eNumFlPlotType, $
                             PPLOTS=pPlots, $
                             IONPLOTS=ionPlots, IFLUXPLOTTYPE=ifluxPlotType, $
                             CHAREPLOTS=charEPlots, CHARETYPE=charEType, $
                             ORBCONTRIBPLOT=orbContribPlot, ORBTOTPLOT=orbTotPlot, ORBFREQPLOT=orbFreqPlot, $
                             NEVENTPERORBPLOT=nEventPerOrbPlot, $
                             NEVENTPERMINPLOT=nEventPerMinPlot, $
                             PROBOCCURRENCEPLOT=probOccurrencePlot, $
                             SQUAREPLOT=squarePlot, POLARCONTOUR=polarContour, $ ;WHOLECAP=wholeCap, $
                             MEDIANPLOT=medianPlot, LOGAVGPLOT=logAvgPlot, $
                             DATADIR=dataDir, NO_BURSTDATA=no_burstData, $
                             WRITEASCII=writeASCII, WRITEHDF5=writeHDF5, WRITEPROCESSEDH2D=writeProcessedH2d, $
                             SAVERAW=saveRaw, RAWDIR=rawDir, $
                             SHOWPLOTSNOSAVE=showPlotsNoSave, $
                             MEDHISTOUTDATA=medHistOutData, MEDHISTOUTTXT=medHistOutTxt, $
                             OUTPUTPLOTSUMMARY=outputPlotSummary, DEL_PS=del_PS, $
                             KEEPME=keepMe, $
                             PARAMSTRING=paramString,PARAMSTRPREFIX=paramStrPrefix,PARAMSTRSUFFIX=paramStrSuffix,$
                             HOYDIA=hoyDia,LUN=lun,_EXTRA=e, $
                             DO_NOT_SET_DEFAULTS=do_not_set_defaults

  IF ~KEYWORD_SET(do_not_set_defaults) THEN BEGIN
     SET_UTCPLOT_PARAMS_AND_IND_DEFAULTS,ORBRANGE=orbRange, $
                                         ALTITUDERANGE=altitudeRange, $
                                         CHARERANGE=charERange, $
                                         PARAMSTRING=paramString, $
                                         LUN=lun
  ENDIF

  ;; defOutIndsPrefix = 'fastLoc_intervals3'
  defOutIndsPrefix = 'fastLoc_intervals4'
  IF KEYWORD_SET(outIndsPrefix) THEN outIndsPrefix = defOutIndsPrefix + '--' + outIndsPrefix ELSE outIndsPrefix = defOutIndsPrefix
  IF ~KEYWORD_SET(outIndsSuffix) THEN outIndsSuffix = ''

  ;;********************************************
  ;;Build output filename based on stuff provided
  ;;Should include clockStr, angleLim1,angleLim2, satellite, omnicoords, bymin, stableimf, delay, smoothwindow
  IF ~KEYWORD_SET(stormFile) THEN BEGIN
  ;; IF ~KEYWORD_SET(stormFile) THEN BEGIN
     ;; stormSub       = STRMID(stormfile,stormfile.INDEXOF("todays")+7, $
     ;;                         stormpfile.INDEXOF('_fastLoc')-stormfile.INDEXOF("todays")-7)
  ;; ENDIF ELSE BEGIN
  ;;    stormSub       = ''
  ;; ENDELSE

     IF N_ELEMENTS(charerange) EQ 2 THEN tmpCER = chareRange ELSE tmpCER = [0,0]
     IF N_ELEMENTS(altitudeRange) EQ 2 THEN tmpAR = altitudeRange ELSE tmpAR = [0,0]
     IF N_ELEMENTS(orbRange) EQ 2 THEN tmpOR = orbRange ELSE tmpOR = [0,0]

     basenameFormat = '(A0,"--",A0,"--hemi_",A0,' + $
                      '"--chareRange_",F0.2,"-",F0.2,"--altRange_",F0.2,"-",F0.2,"--orbRange",I0,"-",I0,A0)'
     outIndsFileBasename = STRING(FORMAT=basenameFormat, $
                                  outIndsPrefix, $
                                  GET_TODAY_STRING(/DO_YYYYMMDD_FMT), $
                                  ;; stormSub, $
                                  hemi, $
                                  tmpCER[0],tmpCER[1],tmpAR[0],tmpAR[1],tmpOR[0],tmpOR[1],outIndsSuffix)
     outIndsFilename = fastLocOutputDir+outIndsFileBasename+'.sav' 
  ENDIF ELSE BEGIN
     outIndsFilename = stormFile
  ENDELSE


  ;;********************************************
  ;;If this file already exists, see if it will work for us!

  ;; IF FILE_TEST(outIndsFilename) THEN BEGIN 
  ;;    PRINT,"Restoring " + outIndsFilename + "..."
  ;;    RESTORE,outIndsFilename
  ;;    ;; WAIT,1
  ;; ENDIF ELSE BEGIN
  good_i = GET_CHASTON_IND(KEYWORD_SET(for_eSpec_DBs) ? FL_eSpec__fastLoc : FL__fastLoc, $
                           satellite,lun, $
                           GET_TIME_I_NOT_ALFVENDB_I=1, $
                           DBTIMES=KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__times : FASTLOC__times, $
                           DBFILE=KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__dbFile : FASTLOC__dbFile, $
                           HEMI=hemi, $
                           ORBRANGE=orbRange, $
                           ALTITUDERANGE=altitudeRange, $
                           MINMLT=minM,MAXMLT=maxM,BINM=binM, $
                           MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                           DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                           HWMAUROVAL=HwMAurOval, $
                           HWMKPIND=HwMKpInd, $
                           DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                           FOR_ESPEC_DBS=for_eSpec_DBs)
  
  GET_DATA_AVAILABILITY_FOR_ARRAY_OF_UTC_RANGES,T1_ARR=t1_arr,T2_ARR=t2_arr, $
     DBSTRUCT=KEYWORD_SET(for_eSpec_DBs) ? FL_eSpec__fastLoc : FL__fastLoc, $
     OUT_GOOD_TARR_I=out_good_tArr_i, $
     DBTIMES=KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__times : FASTLOC__times, $
     RESTRICT_W_THESEINDS=good_i, $
     OUT_INDS_LIST=fastLocInterped_i, $
     LIST_TO_ARR=list_to_arr, $
     UNIQ_ORBS_LIST=uniq_orbs_list, $
     UNIQ_ORB_INDS_LIST=uniq_orb_inds_list, $
     INDS_ORBS_LIST=inds_orbs_list, $
     TRANGES_ORBS_LIST=tranges_orbs_list, $
     TSPANS_ORBS_LIST=tspans_orbs_list, $
     LET_OVERLAPS_FLY__FOR_SEA=let_overlaps_fly__for_sea, $
     /PRINT_DATA_AVAILABILITY, $
     /SUMMARY
  
  IF KEYWORD_SET(make_outIndsFile) THEN BEGIN
     for_eSpec_DBs = KEYWORD_SET(for_eSpec_DBs)
     ;; PRINT,'Saving outindsfile ' + outIndsFilename + '...'
     ;; SAVE,fastLocInterped_i, $
     ;;      minm,maxm,binm, $
     ;;      mini,maxi,bini, $
     ;;      minl,maxl,binl, $
     ;;      altituderange, $
     ;;      charerange, $
     ;;      orbrange, $
     ;;      fastLoc__dbFile, $
     ;;      fastLoc__dbTimesFile, $
     ;;      for_eSpec_DBs, $
     ;;      FILENAME=outIndsFilename
  ENDIF
  ;; ENDELSE

  ;;Send back structs, if requested
  IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
     IF ARG_PRESENT(fastLoc_out)          THEN fastLoc_out         = FL_eSpec__fastLoc
     IF ARG_PRESENT(fastLoc_times_out)    THEN fastLoc_times_out   = FASTLOC_E__times
     IF ARG_PRESENT(fastLoc_delta_t_out)  THEN fastLoc_delta_t_out = FASTLOC_E__delta_t
  ENDIF ELSE BEGIN
     IF ARG_PRESENT(fastLoc_out)          THEN fastLoc_out         = FL__fastLoc
     IF ARG_PRESENT(fastLoc_times_out)    THEN fastLoc_times_out   = FASTLOC__times
     IF ARG_PRESENT(fastLoc_delta_t_out)  THEN fastLoc_delta_t_out = FASTLOC__delta_t
  ENDELSE


END