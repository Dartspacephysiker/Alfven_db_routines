FUNCTION GET_TIMEHIST_DENOMINATOR,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
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
                                  DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                  DO_UTC_RANGE=DO_UTC_range, $
                                  STORMSTRING=stormString, $
                                  DSTCUTOFF=dstCutoff, $
                                  T1_ARR=t1_arr,T2_ARR=t2_arr, $
                                  MINM=minM,MAXM=maxM, $
                                  BINM=binM, $
                                  SHIFTM=shiftM, $
                                  MINI=minI,MAXI=maxI,BINI=binI, $
                                  DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                  HEMI=hemi, $
                                  FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                  FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                  INDSFILEPREFIX=indsFilePrefix,INDSFILESUFFIX=indsFileSuffix, $
                                  BURSTDATA_EXCLUDED=burstData_excluded, $
                                  DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme, $
                                  LUN=lun

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  PRINTF,lun,"Getting time histogram denominator ..."

     ;Get the appropriate divisor for IMF conditions
  ;; IF KEYWORD_SET(do_IMF_conds) THEN BEGIN
  ;;    GET_FASTLOC_INDS_IMF_CONDS,fastLocInterped_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
  ;;                               ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
  ;;                               BYMIN=byMin, BYMAX=byMax, BZMIN=bzMin, BZMAX=bzMax, SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
  ;;                               HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
  ;;                               HWMAUROVAL=0,HWMKPIND=!NULL, $
  ;;                               MAKE_OUTINDSFILE=1, $
  ;;                               OUTINDSPREFIX=indsFilePrefix,OUTINDSSUFFIX=indsFileSuffix,OUTINDSFILEBASENAME=outIndsBasename, $
  ;;                               FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
  ;;                               FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir, $
  ;;                               BURSTDATA_EXCLUDED=burstData_excluded
  ;; ENDIF ELSE BEGIN
  ;;    IF KEYWORD_SET(do_UTC_range) THEN BEGIN
  ;;       GET_FASTLOC_INDS_UTC_RANGE,fastLocInterped_i,T1_ARR=t1_arr,T2_ARR=t2_arr, $
  ;;                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
  ;;                                  HEMI=hemi, $
  ;;                                  HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
  ;;                                  MAKE_OUTINDSFILE=1, $
  ;;                                  OUTINDSPREFIX=indsFilePrefix,OUTINDSSUFFIX=indsFileSuffix,OUTINDSFILEBASENAME=outIndsBasename, $
  ;;                                  FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
  ;;                                  FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir
  ;;    ENDIF
  ;; ENDELSE

  IF KEYWORD_SET(do_IMF_conds) THEN BEGIN
     GET_FASTLOC_INDS_IMF_CONDS,fastLocInterped_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                BYMIN=byMin, $
                                BYMAX=byMax, $
                                BZMIN=bzMin, $
                                BZMAX=bzMax, $
                                DO_ABS_BYMIN=abs_byMin, $
                                DO_ABS_BYMAX=abs_byMax, $
                                DO_ABS_BZMIN=abs_bzMin, $
                                DO_ABS_BZMAX=abs_bzMax, $
                                SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                HWMAUROVAL=0,HWMKPIND=!NULL, $
                                ;; MAKE_OUTINDSFILE=1, $
                                OUTINDSPREFIX=indsFilePrefix,OUTINDSSUFFIX=indsFileSuffix,OUTINDSFILEBASENAME=outIndsBasename, $
                                FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir, $
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
                                   FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
                                   FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir

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
                                   FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
                                   FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir

        PRINTF,lun,FORMAT='("N fastLoc inds from UTC ranges",T40,": ",I0)',N_ELEMENTS(fastLocInterped_UTC_i)
     ENDIF ELSE BEGIN
        ;;No restrictions whatsoever, eh?
        LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastloc_times,fastloc_delta_t,DBDir=DBDir,DBFile=FastLocFile,DB_tFile=FastLocTimeFile,LUN=lun
        fastLocInterped_i = GET_RESTRICTED_AND_INTERPED_DB_INDICES(fastLoc,satellite,delay,LUN=lun, $
                                                                   DBTIMES=fastLoc_times,dbfile=dbfile, HEMI=hemi, $
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
     ENDELSE
  ENDELSE


  MAKE_FASTLOC_HISTO,OUTTIMEHISTO=tHistDenominator, $
                     FASTLOC_INDS=fastLocInterped_i, $
                     FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
                     MINMLT=minM,MAXMLT=maxM, $
                     BINMLT=binM, $
                     SHIFTMLT=shiftM, $
                     MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                     DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                     FASTLOCFILE=fastLocFile,FASTLOCTIMEFILE=fastLocTimeFile, $
                     OUTFILEPREFIX=outIndsBasename,OUTFILESUFFIX=outFileSuffix, OUTDIR=fastLocOutputDir, $
                     OUTPUT_TEXTFILE=output_textFile
  

  PRINT_TIMEHISTO_SUMMARY,fastLoc,fastLocInterped_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
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
                          PARAMSTRING=paramString, PARAMSTRPREFIX=plotPrefix,PARAMSTRSUFFIX=plotSuffix,$
                          DO_UTC_RANGE=DO_UTC_range,T1_ARR=t1_arr,T2_ARR=t2_arr, $
                          DO_IMF_CONDS=do_IMF_conds, $
                          SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                          HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow,INCLUDENOCONSECDATA=includeNoConsecData, $
                          HOYDIA=hoyDia,MASKMIN=maskMin,LUN=lun



  RETURN,tHistDenominator

END