;+
;2016/02/19 Completely redone.
;-
PRO GET_FASTLOC_INDS_IMF_CONDS_V2,fastLocInterped_i, $
                                  ORBRANGE=orbRange, $
                                  ALTITUDERANGE=altitudeRange, $
                                  CHARERANGE=charERange, $
                                  SAMPLE_T_RESTRICTION=sample_t_restriction, $
                                  DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
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
                                  MINMLT=minM,MAXMLT=maxM,BINM=binM,SHIFTM=shiftM, $
                                  MINILAT=minI,MAXILAT=maxI,BINI=binI,SHIFTI=shiftI, $
                                  DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                  SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                  HEMI=hemi, $
                                  BOTH_HEMIS=both_hemis, $
                                  NORTH=north, $
                                  SOUTH=south, $
                                  DELAY=delay, $
                                  MULTIPLE_DELAYS=multiple_delays, $
                                  RESOLUTION_DELAY=delay_res, $
                                  BINOFFSET_DELAY=binOffset_delay, $
                                  STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                  HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                  RESET_GOOD_INDS=reset_good_inds, $
                                  RESET_OMNI_INDS=reset_omni_inds, $
                                  ;; MAKE_OUTINDSFILE=make_outIndsFile, $
                                  ;; OUTINDSPREFIX=outIndsPrefix,OUTINDSSUFFIX=outIndsSuffix,OUTINDSFILEBASENAME=outIndsFileBasename, $
                                  ;; FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                  ;; FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, $
                                  ;; FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                  BURSTDATA_EXCLUDED=burstData_excluded, $
                                  DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                                  GET_FASTLOC_STRUCT=get_fastLoc_struct, $
                                  GET_FASTLOC_DELTA_T=get_fastLoc_delta_t, $
                                  GET_FASTLOC_TIMES=get_fastLoc_times, $
                                  OUT_FASTLOC_STRUCT=out_fastLoc_struct, $
                                  OUT_FASTLOC_DELTA_T=out_fastLoc_delta_t, $
                                  OUT_FASTLOC_TIMES=out_fastLoc_times

  COMPILE_OPT idl2

  COMMON FL_VARS,FL_fastLoc,FASTLOC__times,FASTLOC__delta_t, $
     FASTLOC__good_i,FASTLOC__cleaned_i,FASTLOC__HAVE_GOOD_I, $
     FASTLOC__dbFile,FASTLOC__dbTimesFile

  IF NOT KEYWORD_SET(lun) THEN lun = -1 ;stdout
  
  fastLocInterped_i_list = GET_RESTRICTED_AND_INTERPED_DB_INDICES(FL_fastLoc,satellite,delay,LUN=lun, $
                                                                  DBTIMES=fastLoc__times, $
                                                                  DBFILE=fastLoc__dbfile, $
                                                                  HEMI=hemi, $
                                                                  ORBRANGE=orbRange, $
                                                                  ALTITUDERANGE=altitudeRange, $
                                                                  CHARERANGE=charERange, $
                                                                  SAMPLE_T_RESTRICTION=sample_t_restriction, $
                                                                  MINMLT=minM,MAXMLT=maxM,BINM=binM,SHIFTM=shiftM, $
                                                                  MINILAT=minI,MAXILAT=maxI,BINI=binI, $;SHIFTI=shiftI, $ $
                                                                  DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
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
                                                                  CLOCKSTR=clockStr, $
                                                                  DONT_CONSIDER_CLOCKANGLES=dont_consider_clockAngles, $
                                                                  ANGLELIM1=angleLim1, $
                                                                  DO_NOT_SET_DEFAULTS=do_not_set_defaults, $
                                                                  ANGLELIM2=angleLim2, $
                                                                  DO_NOT_CONSIDER_IMF=do_not_consider_IMF, $
                                                                  BX_OVER_BYBZ=Bx_over_ByBz_Lim, $
                                                                  STABLEIMF=stableIMF, $
                                                                  MULTIPLE_DELAYS=multiple_delays, $
                                                                  RESOLUTION_DELAY=delay_res, $
                                                                  BINOFFSET_DELAY=binOffset_delay, $
                                                                  OMNI_COORDS=omni_Coords, $
                                                                  HWMAUROVAL=HwMAurOval, $
                                                                  HWMKPIND=HwMKpInd, $
                                                                  RESET_GOOD_INDS=reset_good_inds, $
                                                                  RESET_OMNI_INDS=reset_omni_inds, $
                                                                  NO_BURSTDATA=no_burstData, $
                                                                  /GET_TIME_I_NOT_ALFVENDB_I)
  
  
  IF KEYWORD_SET(get_fastLoc_struct) THEN BEGIN
     out_fastLoc_struct = FL_fastLoc
  ENDIF

  IF KEYWORD_SET(get_fastLoc_delta_t) THEN BEGIN
     out_fastLoc_delta_t   = FASTLOC__delta_t
  ENDIF

  IF KEYWORD_SET(get_fastLoc_times) THEN BEGIN
     out_fastLoc_times   = FASTLOC__times
  ENDIF

  IF KEYWORD_SET(multiple_delays) THEN BEGIN
     fastLocInterped_i = fastLocInterped_i_list
  ENDIF ELSE BEGIN
     fastLocInterped_i = fastLocInterped_i_list[0]
  ENDELSE

END