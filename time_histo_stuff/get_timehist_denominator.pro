FUNCTION GET_TIMEHIST_DENOMINATOR,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                  ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                  BYMIN=byMin, BYMAX=byMax, BZMIN=bzMin, BZMAX=bzMax, SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                  HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                  MINM=minM,MAXM=maxM,BINM=binM, $
                                  MINI=minI,MAXI=maxI,BINI=binI, $
                                  DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                                  FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                  FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                  BURSTDATA_EXCLUDED=burstData_excluded, $
                                  DATANAMEARR=dataNameArr,DATARAWPTRARR=dataRawPtrArr,KEEPME=keepme


     ;Get the appropriate divisor for IMF conditions
     GET_FASTLOC_INDS_IMF_CONDS,fastLocInterped_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                BYMIN=byMin, BYMAX=byMax, BZMIN=bzMin, BZMAX=bzMax, SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                HEMI='BOTH', DELAY=delay, STABLEIMF=stableIMF, SMOOTHWINDOW=smoothWindow, INCLUDENOCONSECDATA=includeNoConsecData, $
                                HWMAUROVAL=0,HWMKPIND=!NULL, $
                                MAKE_OUTINDSFILE=1,OUTINDSFILEBASENAME=outIndsBasename, $
                                FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastLoc_delta_t, $
                                FASTLOCFILE=fastLocFile, FASTLOCTIMEFILE=fastLocTimeFile, FASTLOCOUTPUTDIR=fastLocOutputDir, $
                                BURSTDATA_EXCLUDED=burstData_excluded

     MAKE_FASTLOC_HISTO,OUTTIMEHISTO=tHistDenominator, $
                        FASTLOC_INDS=fastLocInterped_i, $
                        FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
                        MINMLT=minM,MAXMLT=maxM,BINMLT=binM, $
                        MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                        DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                        FASTLOCFILE=fastLocFile,FASTLOCTIMEFILE=fastLocTimeFile, $
                        OUTFILEPREFIX=outIndsBasename,OUTFILESUFFIX=outFileSuffix, OUTDIR=fastLocOutputDir, $
                        OUTPUT_TEXTFILE=output_textFile


  RETURN,tHistDenominator

END