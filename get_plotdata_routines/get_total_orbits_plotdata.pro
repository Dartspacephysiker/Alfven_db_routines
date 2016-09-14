;This thing will give you EVERYWHERE FAST has been, with no screening, so look out!
PRO GET_TOTAL_ORBITS_PLOTDATA,dbStruct,MINM=minM,MAXM=maxM, $
                              BINM=binM, $
                              SHIFTM=shiftM, $
                              MINI=minI,MAXI=maxI,BINI=binI, $
                              DO_LSHELL=do_lshell, MINL=minL,MAXL=maxL,BINL=binL, $
                              ORBTOTRANGE=orbTotRange, $
                              H2DSTR=h2dStr,TMPLT_H2DSTR=tmplt_h2dStr, $
                              DATANAME=dataName,DATARAWPTR=dataRawPtr,KEEPME=keepme, $
                              UNIQUEORBS_I=uniqueOrbs_i,H2D_NONZERO_ALLORB_I=h2d_nonZero_allOrb_i, $
                              LUN=lun

  COMPILE_OPT idl2

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
                                      CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                      CB_FORCE_OOBLOW=cb_force_oobLow)

  ;; h2dStr={tmplt_h2dStr}
  h2dStr           = tmplt_h2dStr
  h2dStr.data[*,*] = 0
  h2dStr.title     = "Total Orbits"
  dataName         = "orbTot"
  h2dStr.name      = dataName

  orbArr           = INTARR(N_ELEMENTS(uniqueOrbs_i), $
                            N_ELEMENTS(tmplt_h2dStr.data[*,0]), $
                            N_ELEMENTS(tmplt_h2dStr.data[0,*]))
    
  ;;FOR j=0, N_ELEMENTS(uniqueOrbs_i)-1 DO BEGIN 
  ;;   tempOrb=dbStruct.orbit(ind_region_magc_geabs10_acestart(uniqueOrbs_i[j])) 
  ;;   temp_ii=WHERE(dbStruct.orbit(ind_region_magc_geabs10_acestart) EQ tempOrb) 
  ;;   h2dOrbTemp=hist_2d(dbStruct.mlt(ind_region_magc_geabs10_acestart(temp_ii)),$
  ;;                      (KEYWORD_SET(do_lShell) ? dbStruct.lShell : dbStruct.ilat )(ind_region_magc_geabs10_acestart(temp_ii)),$
  ;;                      BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
  ;;                      MIN1=MINM,MIN2=MINI,$
  ;;                      MAX1=MAXM,MAX2=MAXI) 
  ;;   orbARR[j,*,*]=h2dOrbTemp 
  ;;   h2dOrbTemp(WHERE(h2dOrbTemp GT 0)) = 1 
  ;;   h2dStr.data += h2dOrbTemp 
  ;;ENDFOR
  
  ;;fix MLTs
  mlts                      = SHIFT_MLTS_FOR_H2D(maximus,INDGEN(N_ELEMENTS(maximus.mlt)),shiftM)
  ilats                     = KEYWORD_SET(do_lShell) ? dbStruct.lshell : dbStruct.ilat
  IF KEYWORD_SET(h2dStr.both_hemis) THEN ilats = ABS(ilats)

  FOR j=0,N_ELEMENTS(uniqueOrbs_i)-1 DO BEGIN 
     tempOrb=dbStruct.orbit[uniqueOrbs_i[j]]
     temp_i=WHERE(dbStruct.orbit EQ tempOrb,/NULL) 
     h2dOrbTemp=hist_2d(mlts[temp_i],$
                        ilats[temp_i],$
                        BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                        MIN1=MINM,MIN2=(KEYWORD_SET(do_lShell) ? minL : minI),$
                        MAX1=MAXM,MAX2=(KEYWORD_SET(do_lShell) ? maxL : maxI)) 

     orbARR[j,*,*]=h2dOrbTemp 
     h2dOrbTemp[WHERE(h2dOrbTemp GT 0,/NULL)] = 1 
     h2dStr.data += h2dOrbTemp 
  ENDFOR

  IF N_ELEMENTS(orbTotRange) EQ 0 OR N_ELEMENTS(orbTotRange) NE 2 THEN $
     h2dStr.lim=[MIN(h2dStr.data),MAX(h2dStr.data)] $ 
  ELSE $
     h2dStr.lim=orbTotRange

  h2d_nonZero_allOrb_i =  WHERE(h2dStr.data GT 0,/NULL)

END