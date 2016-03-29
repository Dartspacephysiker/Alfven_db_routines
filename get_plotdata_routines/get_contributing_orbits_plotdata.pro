PRO GET_CONTRIBUTING_ORBITS_PLOTDATA,dbStruct,inds,MINM=minM,MAXM=maxM, $
                                     BINM=binM, $
                                     SHIFTM=shiftM, $
                                     MINI=minI,MAXI=maxI,BINI=binI, $
                                     DO_LSHELL=do_lShell, MINL=minL,MAXL=maxL,BINL=binL, $
                                     ORBCONTRIBRANGE=orbContribRange, $
                                     UNIQUEORBS_I=uniqueOrbs_i, $
                                     H2D_NONZERO_CONTRIBORBS_I=h2d_nonzero_contribOrbs_i, $
                                     H2DSTR=h2dStr, $
                                     TMPLT_H2DSTR=tmplt_h2dStr, $ ;H2DFLUXN=h2dFluxN, $
                                     DATANAME=dataName


  ;;  @orbplot_defaults.PRO

  IF N_ELEMENTS(uniqueOrbs_i) EQ 0 THEN BEGIN
     uniqueOrbs_ii = UNIQ(dbStruct.orbit[inds],SORT(dbStruct.orbit[inds]))
     uniqueOrbs_i  = inds[uniqueOrbs_ii]
  ENDIF
  nOrbs            = N_ELEMENTS(uniqueOrbs_i)

  IF N_ELEMENTS(tmplt_h2dStr) EQ 0 THEN $
     tmplt_h2dStr  = MAKE_H2DSTR_TMPLT(BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                                       MIN1=MINM,MIN2=(KEYWORD_SET(do_lShell) ? MINL : MINI),$
                                      MAX1=MAXM,MAX2=(KEYWORD_SET(do_lShell) ? MAXL : MAXI), $
                                      SHIFT1=shiftM,SHIFT2=shiftI, $
                                      CB_FORCE_OOBHIGH=cb_force_oobHigh, $
                                      CB_FORCE_OOBLOW=cb_force_oobLow)

  ;; h2dStr                                            ={tmplt_h2dStr}
  h2dStr                                      = tmplt_h2dStr
  h2dStr.data[*,*]                            = 0
  h2dStr.title                                = "Num Contributing Orbits"
  dataName                                    = "orbsContributing_"

  h2dOrbN                                     = INTARR(N_ELEMENTS(tmplt_h2dStr.data[*,0]),N_ELEMENTS(tmplt_h2dStr.data[0,*]))
  orbArr                                      = INTARR(N_ELEMENTS(uniqueOrbs_i),N_ELEMENTS(tmplt_h2dStr.data[*,0]),N_ELEMENTS(tmplt_h2dStr.data[0,*]))
  ;; orbArr                                   = INTARR(N_ELEMENTS(uniqueOrbs_i),N_ELEMENTS(h2dFluxN[*,0]),N_ELEMENTS(h2dFluxN[0,*]))
  
  ;;fix MLTs
  mlts                                        = dbStruct.mlt[inds]-shiftM 
  mlts[WHERE(mlts LT 0.)]                     = mlts[WHERE(mlts LT 0.)] + 24.

  FOR j=0, N_ELEMENTS(uniqueOrbs_i)-1 DO BEGIN 
     tempOrb                                  = dbStruct.orbit[uniqueOrbs_i[j]] 
     temp_ii                                  = WHERE(dbStruct.orbit[inds] EQ tempOrb,/NULL) 
     h2dOrbTemp                               = HIST_2D(mlts[temp_ii],$
                                                        (KEYWORD_SET(do_lShell) ? dbStruct.lshell : dbStruct.ilat)[inds[temp_ii]],$
                                                        BIN1=binM,BIN2=(KEYWORD_SET(do_lShell) ? binL : binI),$
                                                        MIN1=MINM,MIN2=(KEYWORD_SET(do_lShell) ? MINL : MINI),$
                                                        MAX1=MAXM,MAX2=(KEYWORD_SET(do_lShell) ? MAXL : MAXI)) 
     orbArr[j,*,*]                            = h2dOrbTemp 
     h2dOrbTemp[WHERE(h2dOrbTemp GT 0,/NULL)] = 1 
     h2dStr.data                             += h2dOrbTemp 
  ENDFOR
  
  IF N_ELEMENTS(orbContribRange) EQ 0 OR N_ELEMENTS(orbContribRange) NE 2 THEN $
     h2dStr.lim                               = [MIN(h2dStr.data),MAX(h2dStr.data)] $
  ELSE $
     h2dStr.lim                               = orbContribRange

  h2d_nonzero_contribOrbs_i                   = WHERE(h2dStr.data GT 0,/NULL)
END