;2015/10/19 Barnebarn

PRO PRINT_ALFVENDB_PLOTSUMMARY,maximus,plot_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                               ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                               minMLT=minM,maxMLT=maxM,BINMLT=binM,MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                               DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                               MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                               HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                               BYMIN=byMin, BZMIN=bzMin, BYMAX=byMax, BZMAX=bzMax, BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                               PARAMSTRING=paramStr, PARAMSTRPREFIX=plotPrefix,PARAMSTRSUFFIX=plotSuffix,$
                               SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                               HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow,INCLUDENOCONSECDATA=includeNoConsecData, $
                               HOYDIA=hoyDia,MASKMIN=maskMin,LUN=lun
  
  printf,lun,""
  printf,lun,"**********DATA SUMMARY**********"
  IF KEYWORD_SET(delay)     THEN printf,lun,FORMAT='(A4, " satellite delay",T30,":",T35,I8,T45," seconds")',satellite,delay
  IF KEYWORD_SET(stableIMF) THEN printf,lun,FORMAT='("IMF stability requirement",T30,":",T35,I8,T45," minutes")',stableIMF
  printf,lun,FORMAT='("")'
  printf,lun,"************"
  printf,lun,FORMAT='("Screening parameters",T30,":",T35,"   [Min]",T45,"   [Max]")'
  printf,lun,FORMAT='("")'
  IF N_ELEMENTS(minM) GT 0  AND N_ELEMENTS(maxM) GT 0 THEN printf,lun,FORMAT='("MLT",T30,":",T35,I8,T45,I8)',minM,maxM
  IF KEYWORD_SET(maxI)  AND KEYWORD_SET(maxI)     THEN printf,lun,FORMAT='("ILAT",T30,":",T35,I8,T45,I8)',minI,maxI
  IF KEYWORD_SET(minL)  AND KEYWORD_SET(maxL)     THEN printf,lun,FORMAT='("(L-shell)",T30,":",T35,I8,T45,I8)',minL,maxL
  IF KEYWORD_SET(minMC) AND KEYWORD_SET(maxNegMC) THEN printf,lun,FORMAT='("Mag current",T30,":",T35,G8.2,T45,G8.2)',maxNegMC,minMC
  printf,lun,FORMAT='("")'
  IF KEYWORD_SET(orbRange)      THEN printf,lun,FORMAT='("Orbits",T30,":",T35,I8,T45,I8)',orbRange[0],orbRange[1]
  IF KEYWORD_SET(altitudeRange) THEN printf,lun,FORMAT='("Altitude",T30,":",T35,I8,T45,I8)',altitudeRange[0],altitudeRange[1]
  IF KEYWORD_SET(charERange)    THEN printf,lun,FORMAT='("Char electron energy (eV)     :",T35,G8.2,T45,G8.2)',charERange[0],charERange[1]
  printf,lun,FORMAT='("")'
  IF KEYWORD_SET(hemi)          THEN printf,lun,FORMAT='("Hemisphere",T30,":",T35,A8)',hemi
  IF KEYWORD_SET(clockStr)      THEN printf,lun,FORMAT='("IMF Predominance",T30,":",T35,A8)',clockStr
  IF KEYWORD_SET(angleLim1)     THEN printf,lun,FORMAT='("Angle lim 1",T30,":",T35,I8)',angleLim1
  IF KEYWORD_SET(angleLim2)     THEN printf,lun,FORMAT='("Angle lim 2",T30,":",T35,I8)',angleLim2

  IF KEYWORD_SET(maskMin)       THEN printf,lun,FORMAT='("Events per bin req",T30,": >=",T35,I8)',maskMin
  printf,lun,FORMAT='("Number of orbits used",T30,":",T35,I8)',N_ELEMENTS(UNIQ(maximus.orbit(plot_i),SORT(maximus.orbit(plot_i))))
  printf,lun,FORMAT='("Total N events",T30,":",T35,I8)',N_ELEMENTS(plot_i)
;; printf,lun,FORMAT='("Percentage of Chaston DB used: ",T35,I0)' + $
;;        strtrim((N_ELEMENTS(plot_i))/134925.0*100.0,2) + "%"
  printf,lun,FORMAT='("Percentage of DB used",T30,":",T35,G8.4,"%")',(FLOAT(N_ELEMENTS(plot_i))/FLOAT(n_elements(maximus.orbit))*100.0)

END