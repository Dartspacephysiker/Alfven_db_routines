PRO PRINT_SUMMARY_IMF_PARAMS_AND_IND_DEFAULTS,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
   ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
   minMLT=minM,maxMLT=maxM,BINMLT=binM,MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
   DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
   HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
   BYMIN=byMin, BZMIN=bzMin, BYMAX=byMax, BZMAX=bzMax, BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
   PARAMSTRING=paramStr, PARAMSTRPREFIX=plotPrefix,PARAMSTRSUFFIX=plotSuffix,$
   SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
   HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow,INCLUDENOCONSECDATA=includeNoConsecData, $
   HOYDIA=hoyDia,LUN=lun
  
  printf,lun,""
  printf,lun,"**********DATA SUMMARY**********"
  IF KEYWORD_SET(delay)     THEN printf,lun,FORMAT='(A4, " satellite delay",T30,":",T35,I8,T45," seconds")',satellite,delay
  IF KEYWORD_SET(stableIMF) THEN printf,lun,FORMAT='("IMF stability requirement",T30,":",T35,I8,T45," minutes")',stableIMF
  printf,lun,FORMAT='("")'
  printf,lun,"************"
  printf,lun,FORMAT='("Screening parameters",T30,":",T35,"   [Min]",T45,"   [Max]")'
  printf,lun,FORMAT='("")'
  IF KEYWORD_SET(minMLT)    AND KEYWORD_SET(maxMLT)    THEN printf,lun,FORMAT='("MLT",T30,":",T35,I8,T45,I8)',minMLT,maxMLT
  IF KEYWORD_SET(maxILAT)   AND KEYWORD_SET(maxILAT)   THEN printf,lun,FORMAT='("ILAT",T30,":",T35,I8,T45,I8)',minILAT,maxILAT
  IF KEYWORD_SET(minlShell) AND KEYWORD_SET(maxlShell) THEN printf,lun,FORMAT='("(L-shell)",T30,":",T35,I8,T45,I8)',minlShell,maxlShell
  IF KEYWORD_SET(minMC)     AND KEYWORD_SET(maxMC)     THEN printf,lun,FORMAT='("Mag current",T30,":",T35,G8.2,T45,G8.2)',maxNEGMC,minMC
  printf,lun,FORMAT='("")'
  IF KEYWORD_SET(orbRange)      THEN printf,lun,FORMAT='("Orbits",T30,":",T35,I8,T45,I8)',orbRange[0],orbRange[1]
  IF KEYWORD_SET(altitudeRange) THEN printf,lun,FORMAT='("Altitude",T30,":",T35,I8,T45,I8)',altitudeRange[0],altitudeRange[1]
  IF KEYWORD_SET(charERange)    THEN printf,lun,FORMAT='("Char electron energy (eV)     :",T35,G8.2,T45,G8.2)',charERange[0],charERange[1]
  printf,lun,FORMAT='("")'
  IF KEYWORD_SET(hemi)          THEN printf,lun,FORMAT='("Hemisphere",T30,":",T35,A8)',hemi
  IF KEYWORD_SET(clockStr)      THEN printf,lun,FORMAT='("IMF Predominance",T30,":",T35,A8)',clockStr
  IF KEYWORD_SET(angleLim1)     THEN printf,lun,FORMAT='("Angle lim 1",T30,":",T35,I8)',angleLim1
  IF KEYWORD_SET(angleLim2)     THEN printf,lun,FORMAT='("Angle lim 2",T30,":",T35,I8)',angleLim2

END