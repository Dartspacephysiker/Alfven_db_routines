;2015/10/19 Barnebarn

PRO PRINT_ALFVENDB_PLOTSUMMARY,dbStruct,plot_i_list,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                               ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                               minMLT=minM,maxMLT=maxM, $
                               BINMLT=binM, $
                               SHIFTMLT=shiftM, $
                               MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                               DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                               MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                               HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
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
                               BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                               PARAMSTRING=paramString, $
                               PARAMSTR_LIST=paramString_list, $
                               PARAMSTRPREFIX=plotPrefix, $
                               PARAMSTRSUFFIX=plotSuffix,$
                               SATELLITE=satellite, $
                               OMNI_COORDS=omni_Coords, $
                               HEMI=hemi, $
                               DELAY=delay, $
                               MULTIPLE_DELAYS=multiple_delays, $
                               MULTIPLE_IMF_CLOCKANGLES=multiple_IMF_clockAngles, $
                               STABLEIMF=stableIMF, $
                               SMOOTHWINDOW=smoothWindow, $
                               INCLUDENOCONSECDATA=includeNoConsecData, $
                               HOYDIA=hoyDia, $
                               MASKMIN=maskMin, $
                               LUN=lun
  
  PRINTF,lun,""
  PRINTF,lun,"**********DATA SUMMARY**********"
  IF KEYWORD_SET(delay) THEN BEGIN
     IF KEYWORD_SET(multiple_delays) THEN BEGIN
        ;; PRINTF,lun,FORMAT='(A4, " sat delays (minutes)",T30,":")',satellite
        ;; PRINTF,lun,FORMAT='(6(I8, :, ", "))',delay
     ENDIF ELSE BEGIN
        PRINTF,lun,FORMAT='(A4, " satellite delay",T30,":",T35,I8,T45," seconds")',satellite,delay
     ENDELSE
  ENDIF
  IF KEYWORD_SET(stableIMF) THEN PRINTF,lun,FORMAT='("IMF stability requirement",T30,":",T35,I8,T45," minutes")',stableIMF
  PRINTF,lun,FORMAT='("")'
  PRINTF,lun,"************"
  PRINTF,lun,FORMAT='("Screening parameters",T30,":",T35,"   [Min]",T45,"   [Max]")'
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


  ;;Handle a few things that depend on whether or not there are multiple_delays
  nEvTot                        = N_ELEMENTS(dbStruct.orbit)
  IF KEYWORD_SET(multiple_delays) THEN BEGIN
     PRINTF,lun,FORMAT='("Delay (min)",T15,"N orbits",T30,"N Events",T45,"% DB used")'
     FOR iDel=0,N_ELEMENTS(plot_i_list)-1 DO BEGIN
        nEv                        = N_ELEMENTS(plot_i_list[iDel])
        PRINTF,lun,FORMAT='(F10.2,T15,I0,T30,I0,T45,F10.2)',delay[iDel]/60., $
               N_ELEMENTS(UNIQ(dbStruct.orbit[plot_i_list[iDel]],SORT(dbStruct.orbit[plot_i_list[iDel]]))), $
               nEv, $
               (FLOAT(nEv)/FLOAT(nEvTot)*100.0)               
        PRINTF,lun,FORMAT='("Parameter string",T30,":",T35,A0)',paramString_list[iDel]
     ENDFOR
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(multiple_IMF_clockAngles) THEN BEGIN
        PRINTF,lun,FORMAT='("clockAngle",T15,"N orbits",T30,"N Events",T45,"% DB used")'
        FOR iClock=0,N_ELEMENTS(plot_i_list)-1 DO BEGIN
           nEv                        = N_ELEMENTS(plot_i_list[iClock])
           PRINTF,lun,FORMAT='(A0,T15,I0,T30,I0,T45,F10.2)',clockStr[iClock], $
                  N_ELEMENTS(UNIQ(dbStruct.orbit[plot_i_list[iClock]],SORT(dbStruct.orbit[plot_i_list[iClock]]))), $
                  nEv, $
                  (FLOAT(nEv)/FLOAT(nEvTot)*100.0)               
           PRINTF,lun,FORMAT='("Parameter string",T30,":",T35,A0)',paramString_list[iClock]
        ENDFOR
     ENDIF ELSE BEGIN
        CASE SIZE(plot_i_list,/TYPE) OF
           11: BEGIN
              nEv                        = N_ELEMENTS(plot_i_list[0])
              PRINTF,lun,FORMAT='("Number of orbits used",T30,":",T35,I8)', $
                     N_ELEMENTS(UNIQ(dbStruct.orbit[plot_i_list[0]],SORT(dbStruct.orbit[plot_i_list[0]])))
              PRINTF,lun,FORMAT='("Total N events",T30,":",T35,I8)',nEv
              PRINTF,lun,FORMAT='("Percentage of DB used",T30,":",T35,G8.4,"%")',(FLOAT(nEv)/FLOAT(nEvTot)*100.0)
              PRINTF,lun,''
           END
           ELSE: BEGIN
              nEv                        = N_ELEMENTS(plot_i_list)
              PRINTF,lun,FORMAT='("Number of orbits used",T30,":",T35,I8)', $
                     N_ELEMENTS(UNIQ(dbStruct.orbit[plot_i_list],SORT(dbStruct.orbit[plot_i_list])))
              PRINTF,lun,FORMAT='("Total N events",T30,":",T35,I8)',nEv
              PRINTF,lun,FORMAT='("Percentage of DB used",T30,":",T35,G8.4,"%")',(FLOAT(nEv)/FLOAT(nEvTot)*100.0)
              PRINTF,lun,''
              IF KEYWORD_SET(paramString) THEN PRINTF,lun,FORMAT='("Parameter string",T30,":",T35,A0)',paramString
           END
        ENDCASE
     ENDELSE
  ENDELSE


END