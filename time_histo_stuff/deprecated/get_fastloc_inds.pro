PRO  GET_FASTLOC_INDS,,CLOCKSTR=clockStr, $
                      ANGLELIM1=angleLim1, $
                      ANGLELIM2=angleLim2, $
                      DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                      ORBRANGE=orbRange, $
                      ALTITUDERANGE=altitudeRange, $
                      CHARERANGE=charERange, $
                      SAMPLE_T_RESTRICTION=sample_t_restriction, $
                      DO_IMF_CONDS=do_IMF_conds, $
                      BYMIN=byMin, $
                      BYMAX=byMax, $
                      BZMIN=bzMin, $
                      BZMAX=bzMax, $
                      BTMIN=btMin, $
                      BTMAX=btMax, $
                      BXMIN=bxMin, $
                      BXMAX=bxMax, $
                      DO_ABS_BYMIN=abs_byMin, $
                      DO_ABS_BYMAX=abs_byMax, $
                      DO_ABS_BZMIN=abs_bzMin, $
                      DO_ABS_BZMAX=abs_bzMax, $
                      DO_ABS_BTMIN=abs_btMin, $
                      DO_ABS_BTMAX=abs_btMax, $
                      DO_ABS_BXMIN=abs_bxMin, $
                      DO_ABS_BXMAX=abs_bxMax, $
                      SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                      DELAY=delay, $
                      MULTIPLE_DELAYS=multiple_delays, $
                      RESOLUTION_DELAY=delay_res, $
                      BINOFFSET_DELAY=binOffset_delay, $
                      MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
                      STABLEIMF=stableIMF, $
                      SMOOTHWINDOW=smoothWindow, $
                      INCLUDENOCONSECDATA=includeNoConsecData, $
                      DO_UTC_RANGE=DO_UTC_range, $
                      STORMSTRING=stormString, $
                      DSTCUTOFF=dstCutoff, $
                      HERE_ARE_YOUR_FASTLOC_INDS=fastLoc_inds, $
                      RESET_GOOD_INDS=reset_good_inds, $
                      RESET_OMNI_INDS=reset_omni_inds, $
                      T1_ARR=t1_arr,T2_ARR=t2_arr, $
                      MINM=minM,MAXM=maxM, $
                      BINM=binM, $
                      SHIFTM=shiftM, $
                      MINI=minI,MAXI=maxI,BINI=binI, $
                      DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                      HEMI=hemi, $
                      OUT_FASTLOC_STRUCT=out_fastLoc, $
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
                      SAVE_FASTLOC_INDS=save_fastLoc_inds, $
                      PARAMSTR_FOR_SAVING=paramStr, $
                      INDSFILEPREFIX=indsFilePrefix, $
                      INDSFILESUFFIX=indsFileSuffix, $
                      IND_FILEDIR=ind_fileDir, $
                      BURSTDATA_EXCLUDED=burstData_excluded, $
                      DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                      FOR_ESPEC_DBS=for_eSpec_DBs, $
                      DONT_LOAD_IN_MEMORY=nonMem, $
                      LUN=lun

  COMPILE_OPT idl2

  ;;Defined here, in GET_FASTLOC_INDS_IMF_CONDS_V2, in GET_FASTLOC_INDS_UTC_RANGE, and in GET_CHASTON_INDS
  COMMON FL_VARS,FL_fastLoc,FASTLOC__times,FASTLOC__delta_t, $
     FASTLOC__good_i,FASTLOC__cleaned_i,FASTLOC__HAVE_GOOD_I, $
     FASTLOC__dbFile,FASTLOC__dbTimesFile

  ;; IF ~KEYWORD_SET(nonMem) THEN BEGIN
  COMMON FL_ESPEC_VARS,FL_eSpec__fastLoc,FASTLOC_E__times,FASTLOC_E__delta_t, $
     FASTLOC_E__good_i,FASTLOC_E__cleaned_i,FASTLOC_E__HAVE_GOOD_I, $
     FASTLOC_E__dbFile,FASTLOC_E__dbTimesFile
  ;; ENDIF ELSE BEGIN
  ;;    FL_eSpec__fastLoc                   = !NULL
  ;;    FASTLOC_E__times                    = !NULL
  ;;    FASTLOC_E__delta_t                  = !NULL
  ;;    FASTLOC_E__dbFile                   = !NULL
  ;;    FASTLOC_E__dbTimesFile              = !NULL
  ;; ENDELSE

  IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
     IF N_ELEMENTS(FL_eSpec__fastloc) NE 0 AND N_ELEMENTS(FASTLOC_E_times) NE 0 THEN BEGIN
        dbStruct                 = FL_eSpec__fastloc
        dbTimes                  = FASTLOC_E__times
        fastloc_delta_t          = FASTLOC_E__delta_t
        dbFile                   = FASTLOC_E__dbFile
        dbTimesFile              = FASTLOC_E__dbTimesFile
     ENDIF ELSE BEGIN
        LOAD_FASTLOC_AND_FASTLOC_TIMES,dbStruct,dbTimes,fastloc_delta_t, $
                                       DBDir=loaddataDir, $
                                       DBFile=dbFile, $
                                       DB_TFILE=dbTimesFile, $
                                       FOR_ESPEC_DBS=for_eSpec_DBs
        FL_eSpec__fastloc        = TEMPORARY(dbStruct);These are too unbelievably unwieldy to have copies hanging around
        FASTLOC_E__times         = TEMPORARY(dbTimes) ;These are too huge
        FASTLOC_E__delta_t       = fastloc_delta_t
        FASTLOC_E__dbFile        = dbFile
        FASTLOC_E__dbTimesFile   = dbTimesFile
     ENDELSE
  ENDIF ELSE BEGIN
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
  ENDELSE

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
                                   MINMLT=minM,MAXMLT=maxM, $
                                   BINM=binM, $
                                   SHIFTM=shiftM, $
                                   MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                   DO_LSHELL=do_lshell, MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                   HEMI=hemi, $
                                   ORBRANGE=orbRange, $
                                   ALTITUDERANGE=altitudeRange, $
                                   CHARERANGE=charERange, $
                                   SAMPLE_T_RESTRICTION=sample_t_restriction, $
                                   CLOCKSTR=clockStr, $
                                   DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                   ANGLELIM1=angleLim1, $
                                   ANGLELIM2=angleLim2, $
                                   BYMIN=byMin, $
                                   BYMAX=byMax, $
                                   BZMIN=bzMin, $
                                   BZMAX=bzMax, $
                                   BTMIN=btMin, $
                                   BTMAX=btMax, $
                                   BXMIN=bxMin, $
                                   BXMAX=bxMax, $
                                   DO_ABS_BYMIN=abs_byMin, $
                                   DO_ABS_BYMAX=abs_byMax, $
                                   DO_ABS_BZMIN=abs_bzMin, $
                                   DO_ABS_BZMAX=abs_bzMax, $
                                   DO_ABS_BTMIN=abs_btMin, $
                                   DO_ABS_BTMAX=abs_btMax, $
                                   DO_ABS_BXMIN=abs_bxMin, $
                                   DO_ABS_BXMAX=abs_bxMax, $
                                   SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                   DELAY=delay, $
                                   MULTIPLE_DELAYS=multiple_delays, $
                                   RESOLUTION_DELAY=delay_res, $
                                   BINOFFSET_DELAY=binOffset_delay, $
                                   STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                   HWMAUROVAL=0,HWMKPIND=!NULL, $
                                   RESET_GOOD_INDS=reset_good_inds, $
                                   RESET_OMNI_INDS=reset_omni_inds, $
                                   BURSTDATA_EXCLUDED=burstData_excluded, $
                                   DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                                   FOR_ESPEC_DBS=for_eSpec_DBs



     PRINTF,lun,FORMAT='("N fastLoc inds from IMF conds",T40,": ",I0)',N_ELEMENTS(fastLocInterped_i)

     IF KEYWORD_SET(do_UTC_range) THEN BEGIN
        PRINT,"Do you know what you're doing? You've requested both a set of IMF conditions and a UTC range."
        nStart             = N_ELEMENTS(fastLocInterped_i)
        GET_FASTLOC_INDS_UTC_RANGE,fastLocInterped_UTC_i,T1_ARR=t1_arr,T2_ARR=t2_arr, $
                                   ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                   MINMLT=minM, $
                                   MAXMLT=maxM, $
                                   BINM=binM, $
                                   ;; SHIFTM=shiftM, $
                                   MINILAT=minI, $
                                   MAXILAT=maxI, $
                                   BINI=binI, $
                                   DO_LSHELL=do_lshell, $
                                   MINLSHELL=minL, $
                                   MAXLSHELL=maxL, $
                                   BINL=binL, $
                                   HEMI=hemi, $
                                   HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                   STORMSTRING=stormString, $
                                   DSTCUTOFF=dstCutoff, $
                                   MAKE_OUTINDSFILE=1, $
                                   OUTINDSPREFIX=indsFilePrefix,OUTINDSSUFFIX=indsFileSuffix,OUTINDSFILEBASENAME=outIndsBasename, $
                                   ;; FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
                                   ;; FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, $
                                   FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                   DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                                   FOR_ESPEC_DBS=for_eSpec_DBs


        PRINTF,lun,FORMAT='("N fastLoc inds from UTC ranges",T40,": ",I0)',N_ELEMENTS(fastLocInterped_UTC_i)
        fastLocInterped_i = CGSETINTERSECTION(fastLocInterped_i,fastLocInterped_UTC_i)
        PRINTF,lun,FORMAT='("N fastLoc inds from combination",T40,": ",I0)',N_ELEMENTS(fastLocInterped_i)
        PRINTF,lun,FORMAT='("N lost due to combination",T40,": ",I0)',nStart-N_ELEMENTS(fastLocInterped_i)

     ENDIF

  ENDIF ELSE BEGIN
     IF KEYWORD_SET(do_UTC_range) THEN BEGIN
        GET_FASTLOC_INDS_UTC_RANGE,fastLocInterped_i,T1_ARR=t1_arr,T2_ARR=t2_arr, $
                                   ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                   MINMLT=minM, $
                                   MAXMLT=maxM, $
                                   BINM=binM, $
                                   MINILAT=minI, $
                                   MAXILAT=maxI, $
                                   BINI=binI, $
                                   DO_LSHELL=do_lshell, $
                                   MINLSHELL=minL, $
                                   MAXLSHELL=maxL, $
                                   BINL=binL, $
                                   HEMI=hemi, $
                                   HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                   STORMSTRING=stormString, $
                                   DSTCUTOFF=dstCutoff, $
                                   OUTINDSPREFIX=indsFilePrefix,OUTINDSSUFFIX=indsFileSuffix,OUTINDSFILEBASENAME=outIndsBasename, $
                                   FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                   DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                                   FOR_ESPEC_DBS=for_eSpec_DBs

        PRINTF,lun,FORMAT='("N fastLoc inds from UTC ranges",T40,": ",I0)',N_ELEMENTS(fastLocInterped_UTC_i)
     ENDIF ELSE BEGIN
        ;;No restrictions whatsoever, eh?

        IF KEYWORD_SET(fastLoc_inds) THEN BEGIN
           PRINT,'Using user-provided fastLoc inds ...'
           fastLocInterped_i_list = fastLoc_inds
        ENDIF ELSE BEGIN
           fastLocInterped_i_list = GET_RESTRICTED_AND_INTERPED_DB_INDICES(KEYWORD_SET(for_eSpec_DBs) ? FL_eSpec__fastLoc : FL_fastLoc, $
                                                                           satellite,delay,LUN=lun, $
                                                                           DBTIMES=KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__times : FASTLOC__times, $
                                                                           DBFILE=KEYWORD_SET(for_eSpec_DBs) ? FASTLOC_E__dbFile : FASTLOC__dbFile, $
                                                                           HEMI=hemi, $
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
                                                                           NO_BURSTDATA=no_burstData, $
                                                                           /GET_TIME_I_NOT_ALFVENDB_I, $
                                                                           GET_TIME_FOR_ESPEC_DBS=for_eSpec_DBs, $
                                                                           DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                                                                           DONT_LOAD_IN_MEMORY=nonMem)
           fastLocInterped_i = fastLocInterped_i_list[0]
        ENDELSE
     ENDELSE
  ENDELSE

  IF KEYWORD_SET(save_fastLoc_inds) THEN BEGIN
     PRINT,'Saving fastLoc inds with this paramStr: ' + paramStr
     SAVE,fastLocInterped_i,FILENAME=ind_fileDir + paramStr + '--' + 'fastLoc_indices.sav'
  ENDIF


END