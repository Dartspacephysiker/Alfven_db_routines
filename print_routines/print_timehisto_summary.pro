;2016/01/01 Barnebarn, because who knows what we're getting into?

PRO PRINT_TIMEHISTO_SUMMARY,fastLoc,good_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                            ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                            MINMLT=minM,MAXMLT=maxM, $
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
  
  PRINTF,lun,""
  PRINTF,lun,"**********FASTLOC TIMEHISTO SUMMARY**********"
  IF KEYWORD_SET(delay)     THEN BEGIN
     IF KEYWORD_SET(multiple_delays) THEN BEGIN
        ;; FOR i=0,N_ELEMENTS(delay) DO BEGIN
        ;; ENDFOR
        PRINTF,lun,FORMAT='("N delays",T30,":",T35,I8,)',N_ELEMENTS(delay)
        PRINTF,lun,FORMAT='(A4, " satellite delay",T30,":",T35,I8,T45," seconds")',satellite,delay[0]
     ENDIF ELSE BEGIN
        PRINTF,lun,FORMAT='(A4, " satellite delay",T30,":",T35,I8,T45," seconds")',satellite,delay
     ENDELSE
  ENDIF
  IF KEYWORD_SET(stableIMF) THEN PRINTF,lun,FORMAT='("IMF stability requirement",T30,":",T35,I8,T45," minutes")',stableIMF
  PRINTF,lun,FORMAT='("")'
  PRINTF,lun,"************"
  PRINTF,lun,FORMAT='("Screening parameters",T30,":",T35,"   [Min]",T45,"   [Max]")'
  PRINTF,lun,FORMAT='("")'
  IF KEYWORD_SET(do_IMF_conds)  THEN BEGIN

     PRINTF,lun,FORMAT='("Do IMF conds",T30,":",T35,I8)',do_IMF_conds
  ENDIF
  PRINTF,lun,FORMAT='("")'
  IF KEYWORD_SET(do_UTC_range)  THEN BEGIN
     PRINTF,lun,FORMAT='("Do UTC Range",T30,":",T35,I8)',do_UTC_range
     PRINTF,lun,FORMAT='("N UTC ranges",T30,":",T35,I8)',N_ELEMENTS(t1_arr)
  ENDIF
  PRINTF,lun,FORMAT='("")'
  IF N_ELEMENTS(minM) GT 0  AND N_ELEMENTS(maxM) GT 0 THEN PRINTF,lun,FORMAT='("MLT",T30,":",T35,I8,T45,I8)',minM,maxM
  IF KEYWORD_SET(maxI)  AND KEYWORD_SET(maxI)     THEN PRINTF,lun,FORMAT='("ILAT",T30,":",T35,I8,T45,I8)',minI,maxI
  IF KEYWORD_SET(minL)  AND KEYWORD_SET(maxL)     THEN PRINTF,lun,FORMAT='("(L-shell)",T30,":",T35,I8,T45,I8)',minL,maxL
  IF KEYWORD_SET(minMC) AND KEYWORD_SET(maxNegMC) THEN PRINTF,lun,FORMAT='("Mag current",T30,":",T35,G8.2,T45,G8.2)',maxNegMC,minMC
  PRINTF,lun,FORMAT='("")'
  IF KEYWORD_SET(orbRange)      THEN PRINTF,lun,FORMAT='("Orbits",T30,":",T35,I8,T45,I8)',orbRange[0],orbRange[1]
  IF KEYWORD_SET(altitudeRange) THEN PRINTF,lun,FORMAT='("Altitude",T30,":",T35,I8,T45,I8)',altitudeRange[0],altitudeRange[1]
  IF KEYWORD_SET(charERange)    THEN PRINTF,lun,FORMAT='("Char electron energy (eV)     :",T35,G8.2,T45,G8.2)',charERange[0],charERange[1]
  PRINTF,lun,FORMAT='("")'
  IF KEYWORD_SET(hemi)          THEN PRINTF,lun,FORMAT='("Hemisphere",T30,":",T35,A8)',hemi
  IF KEYWORD_SET(clockStr)      THEN PRINTF,lun,FORMAT='("IMF Predominance",T30,":",T35,A8)',clockStr
  IF KEYWORD_SET(angleLim1)     THEN PRINTF,lun,FORMAT='("Angle lim 1",T30,":",T35,I8)',angleLim1
  IF KEYWORD_SET(angleLim2)     THEN PRINTF,lun,FORMAT='("Angle lim 2",T30,":",T35,I8)',angleLim2

  IF KEYWORD_SET(maskMin)       THEN PRINTF,lun,FORMAT='("Events per bin req",T30,": >=",T35,I8)',maskMin
  PRINTF,lun,FORMAT='("Number of orbits used",T30,":",T35,I8)',N_ELEMENTS(UNIQ(fastLoc.orbit[good_i],SORT(fastLoc.orbit[good_i])))
  PRINTF,lun,FORMAT='("Total N timePoints",T30,":",T35,I8)',N_ELEMENTS(good_i)
;; PRINTF,lun,FORMAT='("Percentage of Chaston DB used: ",T35,I0)' + $
;;        strtrim((N_ELEMENTS(good_i))/134925.0*100.0,2) + "%"
  PRINTF,lun,FORMAT='("Percentage of DB used",T30,":",T35,G8.4,"%")',(FLOAT(N_ELEMENTS(good_i))/FLOAT(N_ELEMENTS(fastLoc.orbit))*100.0)
  PRINTF,lun,''
  IF KEYWORD_SET(paramString) THEN PRINTF,lun,FORMAT='("Parameter string",T30,":",T35,A0)',paramString

END