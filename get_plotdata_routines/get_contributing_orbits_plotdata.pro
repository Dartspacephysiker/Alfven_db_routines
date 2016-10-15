PRO GET_CONTRIBUTING_ORBITS_PLOTDATA,dbStruct,plot_i, $
                                     MINM=minM, $
                                     MAXM=maxM, $
                                     BINM=binM, $
                                     SHIFTM=shiftM, $
                                     MINI=minI, $
                                     MAXI=maxI, $
                                     BINI=binI, $
                                     EQUAL_AREA_BINNING=EA_binning, $
                                     DO_LSHELL=do_lShell,MINL=minL,MAXL=maxL,BINL=binL, $
                                     ORBCONTRIBRANGE=orbContribRange, $
                                     ORBCONTRIBAUTOSCALE=orbContribAutoscale, $
                                     LOGORBCONTRIBPLOT=logOrbContribPlot, $
                                     ORBCONTRIB_NOMASK=orbContrib_noMask, $
                                     UNIQUEORBS_I=uniqueOrbs_i, $
                                     H2D_NONZERO_CONTRIBORBS_I=h2d_nonZero_contribOrbs_i, $
                                     H2D_NONZERO_I=h2d_nonzero_i, $
                                     H2DSTR=h2dStr, $
                                     TMPLT_H2DSTR=tmplt_h2dStr, $ ;H2DFLUXN=h2dFluxN, $
                                     ORBCONTRIB_H2DSTR_FOR_DIVISION=orbContrib_h2dStr_for_division, $
                                     EXTRACT_ORBARR_FOR_PRINTING=extract_orbArr_for_printing, $
                                     DATANAME=dataName, $
                                     PRINT_MAX_AND_MIN=print_mandm, $
                                     LUN=lun
  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF N_ELEMENTS(print_mandm) EQ 0 THEN print_mandm = 1

  ;;  @orbplot_defaults.PRO

  IF N_ELEMENTS(uniqueOrbs_i) EQ 0 THEN BEGIN
     uniqueOrbs_ii = UNIQ(dbStruct.orbit[plot_i],SORT(dbStruct.orbit[plot_i]))
     uniqueOrbs_i  = plot_i[uniqueOrbs_ii]
  ENDIF
  nOrbs            = N_ELEMENTS(uniqueOrbs_i)

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr  = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                                       MIN1=MINM,MIN2=(KEYWORD_SET(do_lShell) ? MINL : MINI),$
                                       MAX1=MAXM,MAX2=(KEYWORD_SET(do_lShell) ? MAXL : MAXI), $
                                       SHIFT1=shiftM,SHIFT2=shiftI, $
                                       EQUAL_AREA_BINNING=EA_binning, $
                                       CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                       CB_FORCE_OOBLOW=cb_force_oobLow)

  ;; h2dStr         = {tmplt_h2dStr}
  h2dStr            = tmplt_h2dStr
  h2dStr.data[*]    = 0
  IS_STRUCT_ALFVENDB_OR_FASTLOC,dbStruct,is_maximus
  is_orb_probOcc    = is_maximus AND (N_ELEMENTS(orbContrib_h2dStr_for_division) GT 0)
  IF is_orb_probOcc THEN BEGIN
     h2dStr.title   = "Probability of Occurrence (orbit-based)"
     dataName       = "NOrbsWEventsPerContribOrbs"
     h2dStr.name    = dataName

     STR_ELEMENT,orbContrib_h2dStr_for_division,'i_am_alf_ref',INDEX=have_alfdb_ref
     IF have_alfDB_ref GT 0 THEN BEGIN
        dataName   += '_alfRef'
     ENDIF
  ENDIF ELSE BEGIN
     h2dStr.title   = "Num Contributing Orbits"
     dataName       = "orbsContributing"
     h2dStr.name    = dataName
  ENDELSE

  ;;fix MLTs
  mlts       = SHIFT_MLTS_FOR_H2D(dbStruct,plot_i,shiftM)
  ilats      = (KEYWORD_SET(do_lShell) ? dbStruct.lshell : dbStruct.ilat)[plot_i]
  IF KEYWORD_SET(h2dStr.both_hemis) THEN BEGIN
     ilats  = ABS(ilats)
  ENDIF

  CASE 1 OF
     KEYWORD_SET(EA_binning): BEGIN
        LOAD_EQUAL_AREA_BINNING_STRUCT,EA

        nBins                = N_ELEMENTS(EA.minI)
        h2dOrbN              = INTARR(nBins)
        orbArr               = INTARR(N_ELEMENTS(uniqueOrbs_i),nBins)

        h2dOrbTemp           = MAKE_ARRAY(N_ELEMENTS(EA.minI),VALUE=0L,/LONG)
        FOR j=0,N_ELEMENTS(uniqueOrbs_i)-1 DO BEGIN 
           tempOrb           = dbStruct.orbit[uniqueOrbs_i[j]] 
           temp_ii           = WHERE(dbStruct.orbit[plot_i] EQ tempOrb) 
           IF temp_ii[0] NE -1 THEN BEGIN
              h2dOrbTemp     = HIST2D__EQUAL_AREA_BINNING(mlts[temp_ii],$
                                                          ilats[temp_ii],$
                                                          ;; BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                                                          MIN1=MINM,MIN2=(KEYWORD_SET(do_lShell) ? MINL : MINI),$
                                                          MAX1=MAXM,MAX2=(KEYWORD_SET(do_lShell) ? MAXL : MAXI))
           ENDIF ELSE BEGIN
              h2dOrbTemp[*]  = 0
           ENDELSE

           orbArr[j,*]          = h2dOrbTemp 
           add_i                = WHERE(h2dOrbTemp GT 0)
           IF add_i[0] NE -1 THEN BEGIN
              h2dOrbTemp[add_i] = 1 
              h2dStr.data      += h2dOrbTemp 
           ENDIF
        ENDFOR
     END
     ELSE: BEGIN
        h2dOrbN                  = INTARR(N_ELEMENTS(tmplt_h2dStr.data[*,0]),N_ELEMENTS(tmplt_h2dStr.data[0,*]))
        orbArr                   = INTARR(N_ELEMENTS(uniqueOrbs_i),N_ELEMENTS(tmplt_h2dStr.data[*,0]),N_ELEMENTS(tmplt_h2dStr.data[0,*]))
        ;; orbArr                = INTARR(N_ELEMENTS(uniqueOrbs_i),N_ELEMENTS(h2dFluxN[*,0]),N_ELEMENTS(h2dFluxN[0,*]))
  
        h2dOrbTemp               = INTARR(N_ELEMENTS(tmplt_h2dStr.data[*,0]),N_ELEMENTS(tmplt_h2dStr.data[0,*]))
        h2dOrbTemp[*,*]          = 0
        FOR j=0,N_ELEMENTS(uniqueOrbs_i)-1 DO BEGIN 
           tempOrb               = dbStruct.orbit[uniqueOrbs_i[j]] 
           temp_ii               = WHERE(dbStruct.orbit[plot_i] EQ tempOrb) 
           IF temp_ii[0] NE -1 THEN BEGIN
              h2dOrbTemp         = HIST_2D(mlts[temp_ii],$
                                             ilats[temp_ii],$
                                             BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                                             MIN1=MINM,MIN2=(KEYWORD_SET(do_lShell) ? MINL : MINI),$
                                             MAX1=MAXM,MAX2=(KEYWORD_SET(do_lShell) ? MAXL : MAXI)) 
           ENDIF ELSE BEGIN
              h2dOrbTemp[*,*]    = 0
           ENDELSE
           orbArr[j,*,*]         = h2dOrbTemp 
           add_i                 = WHERE(h2dOrbTemp GT 0)
           IF add_i[0] NE -1 THEN BEGIN
              h2dOrbTemp[add_i]  = 1 
              h2dStr.data       += h2dOrbTemp 
           ENDIF
        ENDFOR
     END
  ENDCASE
  
  IF N_ELEMENTS(orbContribRange) EQ 0 OR N_ELEMENTS(orbContribRange) NE 2 THEN $
     h2dStr.lim                   = [MIN(h2dStr.data),MAX(h2dStr.data)] $
  ELSE $
     h2dStr.lim                   = orbContribRange

  IF is_orb_probOcc THEN BEGIN
     tempDenom                    = orbContrib_h2dStr_for_division.data
     IF orbContrib_H2DStr_for_division.is_logged THEN BEGIN
        tempDenom[h2d_nonzero_i]  = 10.^(tempDenom[h2d_nonzero_i])
     ENDIF
     h2dStr.data[h2d_nonzero_i]   = h2dStr.data[h2d_nonzero_i]/tempDenom[h2d_nonzero_i]

     ridiculous_i                 = WHERE(h2dStr.data GT 1,ridicCount)
     IF ridicCount GT 0 THEN BEGIN
        PRINT,"What on earth??? I'm being told there are places where FAST has never been, and yet has data."
        h2dStr.title              = h2dStr.title + 'P GE 1!!'
        ;; h2dStr.data[ridiculous_i]  = 1
     ENDIF
  ENDIF ELSE BEGIN
     h2d_nonZero_contribOrbs_i        = WHERE(h2dStr.data GT 0,/NULL)
  ENDELSE

  ;;temp this, just in case we're not masking
  IF KEYWORD_SET(orbContrib_noMask) THEN BEGIN
     h2d_include_i          = INDGEN(N_ELEMENTS(h2dStr.data))
     h2dStr.dont_mask_me    = 1
  ENDIF ELSE BEGIN
     h2d_include_i          = h2d_nonzero_i
  ENDELSE
  
  IF KEYWORD_SET(print_mandm) THEN BEGIN
     fmt    = 'F10.2'
     maxh2d = MAX(h2dStr.data[h2d_include_i])
     minh2d = MIN(h2dStr.data[h2d_include_i])
     medh2d = MEDIAN(h2dStr.data[h2d_include_i])
     PRINTF,lun,h2dStr.title
     PRINTF,lun,FORMAT='("Max, min. med:",T20,' + fmt + ',T35,' + fmt + ',T50,' + fmt +')', $
            maxh2d, $
            minh2d, $
            medh2d
  ENDIF

  IF KEYWORD_SET(logOrbContribPlot) THEN BEGIN 
     h2dStr.data[where(h2dStr.data NE 0,/NULL)]=ALOG10(h2dStr.data[where(h2dStr.data NE 0,/NULL)]) 
     h2dStr.lim        = ALOG10(h2dStr.lim)
     h2dStr.is_logged  = 1
     h2dStr.title      = "Log " + h2dStr.title
  ENDIF

  IF KEYWORD_SET(orbContribAutoscale) THEN BEGIN
     PRINTF,lun,'Autoscaling orbContrib...'
     h2dStr.lim       = [MIN(h2dStr.data[h2d_include_i]), $
                         MAX(h2dStr.data[h2d_include_i])]

  ENDIF

  IF KEYWORD_SET(extract_orbArr_for_printing) THEN BEGIN
     extract_orbArr_for_printing = orbArr
  ENDIF

END