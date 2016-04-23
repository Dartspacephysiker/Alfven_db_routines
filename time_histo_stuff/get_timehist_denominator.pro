FUNCTION GET_TIMEHIST_DENOMINATOR,CLOCKSTR=clockStr, $
                                  ANGLELIM1=angleLim1, $
                                  ANGLELIM2=angleLim2, $
                                  DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                  DO_IMF_CONDS=do_IMF_conds, $
                                  BYMIN=byMin, $
                                  BYMAX=byMax, $
                                  BZMIN=bzMin, $
                                  BZMAX=bzMax, $
                                  DO_ABS_BYMIN=abs_byMin, $
                                  DO_ABS_BYMAX=abs_byMax, $
                                  DO_ABS_BZMIN=abs_bzMin, $
                                  DO_ABS_BZMAX=abs_bzMax, $
                                  SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                  DELAY=delay, $
                                  MULTIPLE_DELAYS=multiple_delays, $
                                  RESOLUTION_DELAY=delay_res, $
                                  BINOFFSET_DELAY=binOffset_delay, $
                                  STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                  DO_UTC_RANGE=DO_UTC_range, $
                                  STORMSTRING=stormString, $
                                  DSTCUTOFF=dstCutoff, $
                                  HERE_ARE_YOUR_FASTLOC_INDS=fastLoc_inds, $
                                  T1_ARR=t1_arr,T2_ARR=t2_arr, $
                                  MINM=minM,MAXM=maxM, $
                                  BINM=binM, $
                                  SHIFTM=shiftM, $
                                  MINI=minI,MAXI=maxI,BINI=binI, $
                                  DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                  HEMI=hemi, $
                                  OUT_FASTLOC_STRUCT=out_fastLoc, $
                                  ;; FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                  ;; FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, $
                                  FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                  OUT_FASTLOCINTERPED_I=out_fastLocInterped_i, $
                                  MAKE_TIMEHIST_H2DSTR=make_timeHist_h2dStr, $
                                  THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
                                  THISTDENOMPLOTAUTOSCALE=tHistDenomPlotAutoscale, $
                                  THISTDENOMPLOTNORMALIZE=tHistDenomPlotNormalize, $
                                  THISTDENOMPLOT_NOMASK=tHistDenomPlot_noMask, $
                                  TMPLT_H2DSTR=tmplt_h2dStr, $
                                  H2DSTR=h2dStr, $
                                  DATANAME=dataName, $
                                  DATARAWPTR=dataRawPtr, $
                                  H2D_NONZERO_NEV_I=h2d_nonzero_nEv_i, $
                                  PRINT_MAXANDMIN=print_mandm, $
                                  INDSFILEPREFIX=indsFilePrefix,INDSFILESUFFIX=indsFileSuffix, $
                                  BURSTDATA_EXCLUDED=burstData_excluded, $
                                  LUN=lun

  COMPILE_OPT idl2

  COMMON FL_VARS,FL_fastLoc,FASTLOC__times,FASTLOC__delta_t, $
     FASTLOC__good_i,FASTLOC__cleaned_i,FASTLOC__HAVE_GOOD_I, $
     FASTLOC__dbFile,FASTLOC__dbTimesFile

  @orbplot_tplot_defaults.pro
  
  IF N_ELEMENTS(FL_fastloc) NE 0 AND N_ELEMENTS(FASTLOC__times) NE 0 THEN BEGIN
     dbStruct                 = FL_fastloc
     dbTimes                  = FASTLOC__times
     fastloc_delta_t          = FASTLOC__delta_t
     dbFile                   = FASTLOC__dbFile
     dbTimesFile              = FASTLOC__dbTimesFile
  ENDIF ELSE BEGIN
     LOAD_FASTLOC_AND_FASTLOC_TIMES,dbStruct,dbTimes,fastloc_delta_t,DBDir=loaddataDir,DBFile=dbFile,DB_tFile=dbTimesFile
     FL_fastloc               = dbStruct
     FASTLOC__times           = dbTimes
     FASTLOC__delta_t         = fastloc_delta_t
     FASTLOC__dbFile          = dbFile
     FASTLOC__dbTimesFile     = dbTimesFile
  ENDELSE

  ;; IF N_ELEMENTS(FL_fastLoc) EQ 0 OR N_ELEMENTS(fastLoc__times) EQ 0 OR N_ELEMENTS(fastLoc__delta_t) EQ 0 THEN BEGIN
  ;;    LOAD_FASTLOC_AND_FASTLOC_TIMES,fastloc,fastloc_times,fastloc_delta_t
  ;;    FL_fastloc = fastloc
  ;;    fastloc__times = fastloc_times
  ;;    fastloc__delta_t = fastloc_delta_t
  ;; ENDIF ELSE BEGIN
  ;;    fastLoc = FL_fastLoc
  ;;    fastloc_times = fastloc__times
  ;;    fastloc_delta_t = fastloc__delta_t
  ;; ENDELSE

  IF N_ELEMENTS(print_mandm) EQ 0 THEN print_mandm = 1
  IF N_ELEMENTS(lun)         EQ 0 THEN lun         = -1 ;stdout

  PRINTF,lun,"Getting time histogram denominator ..."

  ;;Make sure no conflicting stuff
  IF KEYWORD_SET(fastLoc_inds) AND (KEYWORD_SET(do_IMF_conds) OR KEYWORD_SET(do_UTC_range)) THEN BEGIN
     PRINTF,lun,"Just so you know, I'm not set up to simultaneously take user-provided inds and also go looking for more. Figure it out."
     STOP
  ENDIF

  ;;Get the appropriate divisor for IMF conditions
  IF KEYWORD_SET(do_IMF_conds) THEN BEGIN
     GET_FASTLOC_INDS_IMF_CONDS_V2,fastLocInterped_i, $
                                   ORBRANGE=orbRange, $
                                   ALTITUDERANGE=altitudeRange, $
                                   CHARERANGE=charERange, $
                                   CLOCKSTR=clockStr, $
                                   DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                   ANGLELIM1=angleLim1, $
                                   ANGLELIM2=angleLim2, $
                                   BYMIN=byMin, $
                                   BYMAX=byMax, $
                                   BZMIN=bzMin, $
                                   BZMAX=bzMax, $
                                   DO_ABS_BYMIN=abs_byMin, $
                                   DO_ABS_BYMAX=abs_byMax, $
                                   DO_ABS_BZMIN=abs_bzMin, $
                                   DO_ABS_BZMAX=abs_bzMax, $
                                   SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                   HEMI=hemi, $
                                   DELAY=delay, $
                                   MULTIPLE_DELAYS=multiple_delays, $
                                   RESOLUTION_DELAY=delay_res, $
                                   BINOFFSET_DELAY=binOffset_delay, $
                                   STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                   HWMAUROVAL=0,HWMKPIND=!NULL, $
                                   ;; MAKE_OUTINDSFILE=1, $
                                   OUTINDSPREFIX=indsFilePrefix,OUTINDSSUFFIX=indsFileSuffix,OUTINDSFILEBASENAME=outIndsBasename, $
                                   ;; FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                   ;; FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, $
                                   FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                   BURSTDATA_EXCLUDED=burstData_excluded

     PRINTF,lun,FORMAT='("N fastLoc inds from IMF conds",T40,": ",I0)',N_ELEMENTS(fastLocInterped_i)

     IF KEYWORD_SET(do_UTC_range) THEN BEGIN
        PRINT,"Do you know what you're doing? You've requested both a set of IMF conditions and a UTC range."
        ;; WAIT,5
        nStart             = N_ELEMENTS(fastLocInterped_i)
        GET_FASTLOC_INDS_UTC_RANGE,fastLocInterped_UTC_i,T1_ARR=t1_arr,T2_ARR=t2_arr, $
                                   ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                   HEMI=hemi, $
                                   HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                   STORMSTRING=stormString, $
                                   DSTCUTOFF=dstCutoff, $
                                   MAKE_OUTINDSFILE=1, $
                                   OUTINDSPREFIX=indsFilePrefix,OUTINDSSUFFIX=indsFileSuffix,OUTINDSFILEBASENAME=outIndsBasename, $
                                   ;; FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
                                   ;; FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, $
                                   FASTLOCOUTPUTDIR=fastLocOutputDir

        PRINTF,lun,FORMAT='("N fastLoc inds from UTC ranges",T40,": ",I0)',N_ELEMENTS(fastLocInterped_UTC_i)
        fastLocInterped_i = CGSETINTERSECTION(fastLocInterped_i,fastLocInterped_UTC_i)
        PRINTF,lun,FORMAT='("N fastLoc inds from combination",T40,": ",I0)',N_ELEMENTS(fastLocInterped_i)
        PRINTF,lun,FORMAT='("N lost due to combination",T40,": ",I0)',nStart-N_ELEMENTS(fastLocInterped_i)

     ENDIF

  ENDIF ELSE BEGIN
     IF KEYWORD_SET(do_UTC_range) THEN BEGIN
        GET_FASTLOC_INDS_UTC_RANGE,fastLocInterped_i,T1_ARR=t1_arr,T2_ARR=t2_arr, $
                                   ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                   HEMI=hemi, $
                                   HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                   STORMSTRING=stormString, $
                                   DSTCUTOFF=dstCutoff, $
                                   ;; MAKE_OUTINDSFILE=1, $
                                   OUTINDSPREFIX=indsFilePrefix,OUTINDSSUFFIX=indsFileSuffix,OUTINDSFILEBASENAME=outIndsBasename, $
                                   ;; FASTLOC_STRUCT=FL_fastLoc,FASTLOC_TIMES=FASTLOC__Times,FASTLOC_DELTA_T=FASTLOC__delta_t, $
                                   ;; FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, $
                                   FASTLOCOUTPUTDIR=fastLocOutputDir

        PRINTF,lun,FORMAT='("N fastLoc inds from UTC ranges",T40,": ",I0)',N_ELEMENTS(fastLocInterped_UTC_i)
     ENDIF ELSE BEGIN
        ;;No restrictions whatsoever, eh?
        ;; LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastloc_times,fastloc_delta_t,DBDir=DBDir,DBFile=FastLocFile,DB_tFile=FastLocTimeFile,LUN=lun
        IF KEYWORD_SET(fastLoc_inds) THEN BEGIN
           PRINT,'Using user-provided fastLoc inds ...'
           fastLocInterped_i_list = fastLoc_inds
        ENDIF ELSE BEGIN
           fastLocInterped_i_list = GET_RESTRICTED_AND_INTERPED_DB_INDICES(FL_fastLoc,satellite,delay,LUN=lun, $
                                                                           DBTIMES=fastLoc__times,dbfile=FASTLOC__dbfile, HEMI=hemi, $
                                                                           ORBRANGE=orbRange, $
                                                                           ALTITUDERANGE=altitudeRange, $
                                                                           CHARERANGE=charERange, $
                                                                           MINMLT=minM, $
                                                                           MAXMLT=maxM, $
                                                                           BINM=binM, $
                                                                           MINILAT=minI, $
                                                                           MAXILAT=maxI, $
                                                                           BINI=binI, $
                                                                           DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                                                           CLOCKSTR=clockStr, $
                                                                           /DO_NOT_CONSIDER_IMF, $
                                                                           HWMAUROVAL=HwMAurOval, HWMKPIND=HwMKpInd, $
                                                                           NO_BURSTDATA=no_burstData,GET_TIME_I_NOT_ALFVENDB_I=1)
           fastLocInterped_i = fastLocInterped_i_list[0]
        ENDELSE
     ENDELSE
  ENDELSE


  MAKE_FASTLOC_HISTO,OUTTIMEHISTO=tHistDenominator, $
                     FASTLOC_INDS=fastLocInterped_i, $
                     OUT_DELTA_TS=out_delta_ts, $
                     FASTLOC_STRUCT=FL_fastLoc, $
                     FASTLOC_TIMES=FASTLOC__Times, $
                     FASTLOC_DELTA_T=FASTLOC__delta_t, $
                     MINMLT=minM,MAXMLT=maxM, $
                     BINMLT=binM, $
                     SHIFTMLT=shiftM, $
                     MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                     DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                     FASTLOCFILE=FASTLOC__dbFile,FASTLOCTIMEFILE=FASTLOC__dbTimesFile, $
                     OUTFILEPREFIX=outIndsBasename,OUTFILESUFFIX=outFileSuffix, OUTDIR=fastLocOutputDir, $
                     OUTPUT_TEXTFILE=output_textFile
  

  PRINT_TIMEHISTO_SUMMARY,FL_fastLoc,fastLocInterped_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                          ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                          minMLT=minM,maxMLT=maxM, $
                          BINMLT=binM, $
                          SHIFTMLT=shiftM, $
                          MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                          DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                          MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                          HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                          BYMIN=byMin, $
                          BZMIN=bzMin, $
                          BYMAX=byMax, $
                          BZMAX=bzMax, $
                          DO_ABS_BZMIN=abs_bzMin, $
                          DO_ABS_BZMAX=abs_bzMax, $
                          BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                          ;; PARAMSTRING=paramString, PARAMSTRPREFIX=plotPrefix,PARAMSTRSUFFIX=plotSuffix,$
                          DO_UTC_RANGE=DO_UTC_range,T1_ARR=t1_arr,T2_ARR=t2_arr, $
                          DO_IMF_CONDS=do_IMF_conds, $
                          SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                          HEMI=hemi, $
                          DELAY=delay, $
                          MULTIPLE_DELAYS=multiple_delays, $
                          STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow,INCLUDENOCONSECDATA=includeNoConsecData, $
                          HOYDIA=hoyDia,MASKMIN=maskMin,LUN=lun


  ;;Out vars
  out_fastLocInterped_i = fastLocInterped_i
  out_fastLoc           = FL_fastLoc

  IF KEYWORD_SET(make_timeHist_h2dStr) THEN BEGIN
     IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN BEGIN
        tmplt_h2dStr  = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                          MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                          MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI), $
                                          SHIFT1=shiftM,SHIFT2=shiftI, $
                                          DO_PLOT_I_INSTEAD_OF_HISTOS=do_plot_i, $
                                          ;; PLOT_I=plot_i, $
                                          DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
                                          CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                          CB_FORCE_OOBLOW=cb_force_oobLow)
     ENDIF

     h2dStr                    = tmplt_h2dStr
     h2dStr.is_fluxData        = 0
     
     dataName                  = "tHistDenom"

     ;;temp this, just in case we're not masking
     IF KEYWORD_SET(tHistDenomPlot_noMask) THEN BEGIN
        h2d_include_i          = INDGEN(N_ELEMENTS(h2dStr.data))
        h2dStr.dont_mask_me    = 1
     ENDIF ELSE BEGIN
        h2d_include_i          = h2d_nonzero_nEv_i
     ENDELSE

     h2dStr.labelFormat        = defTHistDenomCBLabelFormat
     h2dStr.logLabels          = defTHistDenomLogLabels
     h2dStr.do_plotIntegral    = defTHistDenom_doPlotIntegral
     h2dStr.do_midCBLabel      = defTHistDenom_do_midCBLabel
     h2dStr.title              = defTHistDenomPlotTitle
     h2dStr.data               = tHistDenominator/60.
     IF KEYWORD_SET(tHistDenomPlotAutoscale) THEN BEGIN
        PRINTF,lun,"Autoscaling tHistDenom plot..."
        h2dStr.lim             = [MIN(h2dStr.data[h2d_include_i]), $
                                   MAX(h2dStr.data[h2d_include_i])]
     ENDIF ELSE BEGIN
        h2dStr.lim             = KEYWORD_SET(tHistDenomPlotRange) ? tHistDenomPlotRange : [0,500]
     ENDELSE

     dataRawPtr                = PTR_NEW(out_delta_ts)

     IF KEYWORD_SET(print_mandm) THEN BEGIN
        fmt    = 'F0.2'
        maxh2d = MAX(h2dStr.data[h2d_include_i])
        minh2d = MIN(h2dStr.data[h2d_include_i])
        medh2d = MEDIAN(h2dStr.data[h2d_include_i])

        PRINTF,lun,h2dStr.title
        PRINTF,lun,FORMAT='("Max, min. med:",T20,' + fmt + ',T35,' + fmt + ',T50,' + fmt +')', $
               maxh2d, $
               minh2d, $
               medh2d
     ENDIF

     IF KEYWORD_SET(tHistDenomPlotNormalize) AND KEYWORD_SET(tHistDenomPlotAutoscale) THEN BEGIN
        PRINTF,lun,"You're asking me to both autoscale and normalize tHistDenom! What does it mean?"
        STOP
     ENDIF

     IF KEYWORD_SET(tHistDenomPlotNormalize) THEN BEGIN
        dataName += "_normed"
        maxTHist                = MAX(h2dStr.data[h2d_include_i])
        h2dStr.title            = defTHistDenomNormedPlotTitle + $
                                  STRING(FORMAT='(" (norm: ",G0.2,"min)")',maxTHist)
        h2dStr.lim              = [0.0,1]
        h2dStr.data             = h2dStr.data/maxTHist
     ENDIF

  ENDIF

  RETURN,tHistDenominator

END