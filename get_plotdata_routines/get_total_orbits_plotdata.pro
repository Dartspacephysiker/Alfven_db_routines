;This thing will give you EVERYWHERE FAST has been, with no screening, so look out!
PRO GET_TOTAL_ORBITS_PLOTDATA,dbStruct,MINM=minM,MAXM=maxM, $
                              BINM=binM, $
                              SHIFTM=shiftM, $
                              USE_LNG=use_Lng,$
                              MINI=minI,MAXI=maxI,BINI=binI, $
                              EQUAL_AREA_BINNING=EA_binning, $
                              DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                              ORBTOTRANGE=orbTotRange, $
                              H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr, $
                              DATANAME=dataName,DATARAWPTR=dataRawPtr,KEEPME=keepme, $
                              UNIQUEORBS_I=uniqueOrbs_i,H2D_NONZERO_ALLORB_I=h2d_nonZero_allOrb_i, $
                              LUN=lun

  COMPILE_OPT idl2,strictarrsubs

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF N_ELEMENTS(uniqueOrbs_i) EQ 0 THEN BEGIN
     uniqueOrbs_i = UNIQ(dbStruct.orbit,SORT(dbStruct.orbit))
     ;; uniqueOrbs_ii = UNIQ(dbStruct.orbit[plot_i],SORT(dbStruct.orbit[plot_i]))
     ;; uniqueOrbs_i = plot_i[uniqueOrbs_ii]
  ENDIF
  nOrbs = N_ELEMENTS(uniqueOrbs_i)

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(DO_lshell) ? binL : binI),$
                                      MIN1=MINM,MIN2=(KEYWORD_SET(DO_LSHELL) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(DO_LSHELL) ? MAXL : MAXI), $
                                      SHIFT1=shiftM,SHIFT2=shiftI, $
                                      EQUAL_AREA_BINNING=EA_binning, $
                                      CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                      CB_FORCE_OOBLOW=cb_force_oobLow)

  ;;fix MLTs
  mlts                      = SHIFT_MLTS_FOR_H2D(maximus,INDGEN(N_ELEMENTS(maximus.mlt)),shiftM,SHIFTM_IS_SHIFTLNG=use_Lng)
  ilats                     = KEYWORD_SET(do_lShell) ? dbStruct.lshell : dbStruct.ilat
  IF KEYWORD_SET(h2dStr.both_hemis) THEN ilats = ABS(ilats)

  ;; h2dStr        = {tmplt_h2dStr}
  h2dStr           = tmplt_h2dStr
  h2dStr.data[*]   = 0
  h2dStr.title     = "Total Orbits"
  dataName         = "orbTot"
  h2dStr.name      = dataName

  CASE 1 OF
     KEYWORD_SET(EA_binning): BEGIN
        LOAD_EQUAL_AREA_BINNING_STRUCT,EA

        nBins         = N_ELEMENTS(EA.minI)
        orbArr        = MAKE_ARRAY(N_ELEMENTS(uniqueOrbs_i),nBins,VALUE=0L,/LONG)

        FOR j=0,N_ELEMENTS(uniqueOrbs_i)-1 DO BEGIN
           tempOrb    = dbStruct.orbit[uniqueOrbs_i[j]]
           temp_i     = WHERE(dbStruct.orbit EQ tempOrb)
           IF temp_i[0] NE -1 THEN BEGIN
              h2dOrbTemp = HIST2D__EQUAL_AREA_BINNING(mlts[temp_i],$
                                                      ilats[temp_i],$
                                                      EQUAL_AREA_STRUCT=EA, $
                                                      MIN1=MINM,MIN2=(KEYWORD_SET(do_lShell) ? minL : minI),$
                                                      MAX1=MAXM,MAX2=(KEYWORD_SET(do_lShell) ? maxL : maxI))
              orbArr[j,*]                              = h2dOrbTemp
              h2dOrbTemp[WHERE(h2dOrbTemp GT 0,/NULL)] = 1
              h2dStr.data                             += h2dOrbTemp
           ENDIF
        ENDFOR
     END
     ELSE: BEGIN
        orbArr        = INTARR(N_ELEMENTS(uniqueOrbs_i), $
                               N_ELEMENTS(tmplt_h2dStr.data[*,0]), $
                               N_ELEMENTS(tmplt_h2dStr.data[0,*]))

        FOR j=0,N_ELEMENTS(uniqueOrbs_i)-1 DO BEGIN
           tempOrb    = dbStruct.orbit[uniqueOrbs_i[j]]
           temp_i     = WHERE(dbStruct.orbit EQ tempOrb,/NULL)
           h2dOrbTemp = hist_2d(mlts[temp_i],$
                                ilats[temp_i],$
                                BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                                MIN1=MINM,MIN2=(KEYWORD_SET(do_lShell) ? minL : minI),$
                                MAX1=MAXM,MAX2=(KEYWORD_SET(do_lShell) ? maxL : maxI))

           orbArr[j,*,*]                            = h2dOrbTemp
           h2dOrbTemp[WHERE(h2dOrbTemp GT 0,/NULL)] = 1
           h2dStr.data                             += h2dOrbTemp
        ENDFOR
     END
  ENDCASE

  IF N_ELEMENTS(orbTotRange) EQ 0 OR N_ELEMENTS(orbTotRange) NE 2 THEN BEGIN
     h2dStr.lim         = [MIN(h2dStr.data),MAX(h2dStr.data)]
  ENDIF ELSE BEGIN
     h2dStr.lim         = orbTotRange
  ENDELSE
  h2d_nonZero_allOrb_i  =  WHERE(h2dStr.data GT 0,/NULL)

END