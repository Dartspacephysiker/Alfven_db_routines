;2015/10/19 Barnebarn

PRO PRINT_ALFVENDB_PLOTSUMMARY, $
   dbStruct, $
   plot_i_list, $
   IMF_STRUCT=IMF_struct, $
   MIMC_STRUCT=MIMC_struct, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   PARAMSTRING=paramString, $
   PARAMSTR_LIST=paramString_list, $
   LUN=lun
  
  COMPILE_OPT idl2,strictarrsubs

  PRINTF,lun,""
  PRINTF,lun,"**********DATA SUMMARY**********"
  test = 0
  STR_ELEMENT,IMF_struct,'delay',test
  IF test NE 0 THEN BEGIN
     test = 0
     STR_ELEMENT,IMF_struct,'multiple_delays',test
     IF test NE 0 THEN BEGIN
        ;; PRINTF,lun,FORMAT='(A4, " sat delays (minutes)",T30,":")',satellite
        ;; PRINTF,lun,FORMAT='(6(I8, :, ", "))',delay
     ENDIF ELSE BEGIN
        PRINTF,lun,FORMAT='(A4, " satellite delay",T30,":",T35,I8,T45," seconds")', $
               IMF_struct.satellite,IMF_struct.delay
     ENDELSE
  ENDIF
  IF TAG_EXIST(IMF_struct,'stableIMF') THEN $
     PRINTF,lun,FORMAT='("IMF stability requirement",T30,":",T35,I8,T45," minutes")', $
            IMF_struct.stableIMF
  PRINTF,lun,FORMAT='("")'
  PRINTF,lun,"************"
  PRINTF,lun,FORMAT='("Screening parameters",T30,":",T35,"   [Min]",T45,"   [Max]")'
  PRINTF,lun,FORMAT='("")'
  ;; IF N_ELEMENTS(minM) GT 0  AND N_ELEMENTS(maxM) GT 0 THEN $
     PRINTF,lun,FORMAT='("MLT",T30,":",T35,I8,T45,I8)', $
            MIMC_struct.minM, $
            MIMC_struct.maxM
  IF TAG_EXIST(MIMC_struct,'minI')  AND TAG_EXIST(MIMC_struct,'maxI')     THEN $
     PRINTF,lun,FORMAT='("ILAT",T30,":",T35,I8,T45,I8)', $
            MIMC_struct.minI, $
            MIMC_struct.maxI
  IF TAG_EXIST(MIMC_struct,'minL')  AND TAG_EXIST(MIMC_struct,'maxL')     THEN $
     PRINTF,lun,FORMAT='("(L-shell)",T30,":",T35,I8,T45,I8)', $
            MIMC_struct.minL, $
            MIMC_struct.maxL
  IF TAG_EXIST(MIMC_struct,'minMC') AND TAG_EXIST(MIMC_struct,'maxNegMC') THEN $
     PRINTF,lun,FORMAT='("Mag current",T30,":",T35,G8.2,T45,G8.2)', $
            MIMC_struct.maxNegMC, $
            MIMC_struct.minMC
  PRINTF,lun,FORMAT='("")'
  IF TAG_EXIST(alfDB_plot_struct,'orbRange')      THEN $
     PRINTF,lun,FORMAT='("Orbits",T30,":",T35,I8,T45,I8)', $
            alfDB_plot_struct.orbRange[0],alfDB_plot_struct.orbRange[1]
  IF TAG_EXIST(alfDB_plot_struct,'altitudeRange') THEN $
     PRINTF,lun,FORMAT='("Altitude",T30,":",T35,I8,T45,I8)', $
            alfDB_plot_struct.altitudeRange[0],alfDB_plot_struct.altitudeRange[1]
  IF TAG_EXIST(alfDB_plot_struct,'charERange')    THEN $
     PRINTF,lun,FORMAT='("Char electron energy (eV)    :",T35,G8.2,T45,G8.2)', $
            alfDB_plot_struct.charERange[0],alfDB_plot_struct.charERange[1]
  PRINTF,lun,FORMAT='("")'
  IF TAG_EXIST(alfDB_plot_struct,'charE__Newell_the_cusp')    THEN $
     PRINTF,lun,FORMAT='("CharE, Newelled cusp         :",T35,I0)', $
            alfDB_plot_struct.charE__Newell_the_cusp

  IF TAG_EXIST(MIMC_struct,'hemi')          THEN $
     PRINTF,lun,FORMAT='("Hemisphere",T30,":",T35,A8)', $
            MIMC_struct.hemi
  IF TAG_EXIST(IMF_struct,'clockStr')      THEN $
     PRINTF,lun,FORMAT='("IMF Predominance",T30,":",T35,8(A0,:,", "))', $
            IMF_struct.clockStr
  IF TAG_EXIST(IMF_struct,'angleLim1')      THEN $
     PRINTF,lun,FORMAT='("Angle lim 1",T30,":",T35,I8)', $
            IMF_struct.angleLim1
  IF TAG_EXIST(IMF_struct,'angleLim2')      THEN $
     PRINTF,lun,FORMAT='("Angle lim 2",T30,":",T35,I8)', $
            IMF_struct.angleLim2

  test = 0
  STR_ELEMENT,IMF_struct,'EA_binning',test
  IF test THEN $
     PRINTF,lun,FORMAT='(A0)',"Using equal-area binning (props, Ryan)"
  IF TAG_EXIST(alfDB_plot_struct,'maskMin')                   THEN $
     PRINTF,lun,FORMAT='("Events per bin req",T30,": >=",T35,I8)', $
            alfDB_plot_struct.maskMin


  ;;Handle a few things that depend on whether or not there are multiple_delays
  nEvTot                        = N_ELEMENTS(dbStruct.orbit)
  test = 0
  STR_ELEMENT,IMF_struct,'multiple_delays',test
  IF test THEN BEGIN
     PRINTF,lun,FORMAT='("Delay (min)",T15,"N orbits",T30,"N Events",T45,"% DB used")'
     FOR iDel=0,N_ELEMENTS(plot_i_list)-1 DO BEGIN
        nEv                        = N_ELEMENTS(plot_i_list[iDel])
        PRINTF,lun,FORMAT='(F10.2,T15,I0,T30,I0,T45,F10.2)', $
               IMF_struct.delay[iDel]/60., $
               N_ELEMENTS(UNIQ(dbStruct.orbit[plot_i_list[iDel]],SORT(dbStruct.orbit[plot_i_list[iDel]]))), $
               nEv, $
               (FLOAT(nEv)/FLOAT(nEvTot)*100.0)               
        PRINTF,lun,FORMAT='("Parameter string",T30,":",T35,A0)', $
               alfDB_plot_struct.paramString_list[iDel]
     ENDFOR
  ENDIF ELSE BEGIN
     test = 0
     STR_ELEMENT,IMF_struct,'multiple_IMF_clockAngles',test
     test = test AND (SIZE(plot_i_list,/TYPE) EQ 11)
     IF test THEN BEGIN
        PRINTF,lun,FORMAT='("clockAngle",T15,"N orbits",T30,"N Events",T45,"% DB used")'
        FOR iClock=0,N_ELEMENTS(plot_i_list)-1 DO BEGIN
           nEv                        = N_ELEMENTS(plot_i_list[iClock])
           PRINTF,lun,FORMAT='(A0,T15,I0,T30,I0,T45,F10.2)', $
                  IMF_struct.clockStr[iClock], $
                  N_ELEMENTS(UNIQ(dbStruct.orbit[plot_i_list[iClock]],SORT(dbStruct.orbit[plot_i_list[iClock]]))), $
                  nEv, $
                  (FLOAT(nEv)/FLOAT(nEvTot)*100.0)               
           PRINTF,lun,FORMAT='("Parameter string",T30,":",T35,A0)', $
                  alfDB_plot_struct.paramString_list[iClock]
        ENDFOR
     ENDIF ELSE BEGIN
        CASE SIZE(plot_i_list,/TYPE) OF
           11: BEGIN
              nEv                        = N_ELEMENTS(plot_i_list[0])
              PRINTF,lun,FORMAT='("Number of orbits used",T30,":",T35,I8)', $
                     N_ELEMENTS(UNIQ(dbStruct.orbit[plot_i_list[0]],SORT(dbStruct.orbit[plot_i_list[0]])))
              PRINTF,lun,FORMAT='("Total N events",T30,":",T35,I8)', $
                     nEv
              PRINTF,lun,FORMAT='("Percentage of DB used",T30,":",T35,G8.4,"%")', $
                     (FLOAT(nEv)/FLOAT(nEvTot)*100.0)
              PRINTF,lun,''
           END
           ELSE: BEGIN
              nEv                        = N_ELEMENTS(plot_i_list)
              PRINTF,lun,FORMAT='("Number of orbits used",T30,":",T35,I8)', $
                     N_ELEMENTS(UNIQ(dbStruct.orbit[plot_i_list],SORT(dbStruct.orbit[plot_i_list])))
              PRINTF,lun,FORMAT='("Total N events",T30,":",T35,I8)', $
                     nEv
              PRINTF,lun,FORMAT='("Percentage of DB used",T30,":",T35,G8.4,"%")', $
                     (FLOAT(nEv)/FLOAT(nEvTot)*100.0)
              PRINTF,lun,''
              IF TAG_EXIST(IMF_struct,'paramString') THEN $
                 PRINTF,lun,FORMAT='("Parameter string",T30,":",T35,A0)', $
                        alfDB_plot_struct.paramString
           END
        ENDCASE
     ENDELSE
  ENDELSE


END