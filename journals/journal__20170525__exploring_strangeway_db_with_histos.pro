;2017/05/25
PRO JOURNAL__20170525__EXPLORING_STRANGEWAY_DB_WITH_HISTOS

  COMPILE_OPT IDL2,STRICTARRSUBS

  noLog = 0
  abs   = 0
  pos   = 0
  neg   = 1

  @common__strangeway_bands.pro
  IF N_ELEMENTS(SWAY__DB) EQ 0 THEN BEGIN
     LOAD_STRANGEWAY_BANDS_PFLUX_DB
  ENDIF

  IF N_ELEMENTS(SWAY__cleaned_i) EQ 0 THEN BEGIN
     SWAY__cleaned_i = STRANGEWAY_DB_CLEANER(SWAY__DB, $
                                       MAXMAGFLAG=maxMagFlag)
  ENDIF

  !P.MULTI = [0,3,2,0,0]

  dBPDCLim = [-2,3.5]
  dBVDCLim = [-2,3.5]

  dBPACLim = [-5,3.5]
  dBVACLim = [-5,3.5]

  eAVDCLim = [-2,3.5]
  eAVACLim = [-2,3.5]

  pFBDCLim = [-4,5.0]
  pFBACLim = [-4,5.0]

  CASE 1 OF
     KEYWORD_SET(abs): BEGIN
        winOffset = 0
        dBPDC = ABS(SWAY__DB.dB.p.DC[SWAY__cleaned_i])
        dBPAC = ABS(SWAY__DB.dB.p.AC[SWAY__cleaned_i])
        dBVDC = ABS(SWAY__DB.dB.v.DC[SWAY__cleaned_i])
        dBVAC = ABS(SWAY__DB.dB.v.AC[SWAY__cleaned_i])
        dBBDC = ABS(SWAY__DB.dB.B.DC[SWAY__cleaned_i])
        dBBAC = ABS(SWAY__DB.dB.B.AC[SWAY__cleaned_i])
        eAVDC = ABS(SWAY__DB.e.AlongV.DC[SWAY__cleaned_i])
        eAVAC = ABS(SWAY__DB.e.AlongV.AC[SWAY__cleaned_i])
        pFBDC = ABS(SWAY__DB.pFlux.B.DC[SWAY__cleaned_i])
        pFBAC = ABS(SWAY__DB.pFlux.B.AC[SWAY__cleaned_i])
     END
     KEYWORD_SET(pos): BEGIN
        winOffset = 2
        dBPDC = SWAY__DB.dB.p.DC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.dB.p.DC GT 0))]
        dBPAC = SWAY__DB.dB.p.AC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.dB.p.AC GT 0))]
        dBVDC = SWAY__DB.dB.v.DC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.dB.v.DC GT 0))]
        dBVAC = SWAY__DB.dB.v.AC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.dB.v.AC GT 0))]
        dBBDC = SWAY__DB.dB.B.DC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.dB.B.DC GT 0))]
        dBBAC = SWAY__DB.dB.B.AC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.dB.B.AC GT 0))]
        eAVDC = SWAY__DB.e.alongV.DC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.e.alongV.DC GT 0))]
        eAVAC = SWAY__DB.e.alongV.AC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.e.alongV.AC GT 0))]
        pFBDC = SWAY__DB.pFlux.B.DC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.pFlux.B.DC GT 0))]
        pFBAC = SWAY__DB.pFlux.B.AC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.pFlux.B.AC GT 0))]
     END
     KEYWORD_SET(neg): BEGIN
        winOffset = 4
        dBPDC = SWAY__DB.dB.p.DC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.dB.p.DC LT 0))]
        dBPAC = SWAY__DB.dB.p.AC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.dB.p.AC LT 0))]
        dBVDC = SWAY__DB.dB.v.DC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.dB.v.DC LT 0))]
        dBVAC = SWAY__DB.dB.v.AC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.dB.v.AC LT 0))]
        dBBDC = SWAY__DB.dB.B.DC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.dB.B.DC LT 0))]
        dBBAC = SWAY__DB.dB.B.AC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.dB.B.AC LT 0))]
        eAVDC = SWAY__DB.e.alongV.DC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.e.alongV.DC LT 0))]
        eAVAC = SWAY__DB.e.alongV.AC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.e.alongV.AC LT 0))]
        pFBDC = SWAY__DB.pFlux.B.DC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.pFlux.B.DC LT 0))]
        pFBAC = SWAY__DB.pFlux.B.AC[CGSETINTERSECTION(SWAY__cleaned_i,WHERE(SWAY__DB.pFlux.B.AC LT 0))]
     END
     ELSE: BEGIN
        winOffset = 6
        dBPDC = SWAY__DB.dB.p.DC[SWAY__cleaned_i]
        dBPAC = SWAY__DB.dB.p.AC[SWAY__cleaned_i]
        dBVDC = SWAY__DB.dB.v.DC[SWAY__cleaned_i]
        dBVAC = SWAY__DB.dB.v.AC[SWAY__cleaned_i]
        dBBDC = SWAY__DB.dB.B.DC[SWAY__cleaned_i]
        dBBAC = SWAY__DB.dB.B.AC[SWAY__cleaned_i]
        eAVDC = SWAY__DB.e.alongV.DC[SWAY__cleaned_i]
        eAVAC = SWAY__DB.e.alongV.AC[SWAY__cleaned_i]
        pFBDC = SWAY__DB.pFlux.B.DC[SWAY__cleaned_i]
        pFBAC = SWAY__DB.pFlux.B.AC[SWAY__cleaned_i]
     END
  ENDCASE

  WINDOW,winOffset

  IF ~KEYWORD_SET(noLog) THEN BEGIN
     dBPDC = ALOG10(ABS(dBPDC))
     dBPAC = ALOG10(ABS(dBPAC))
     dBVDC = ALOG10(ABS(dBVDC))
     dBVAC = ALOG10(ABS(dBVAC))
     dBBDC = ALOG10(ABS(dBBDC))
     dBBAC = ALOG10(ABS(dBBAC))
     eAVDC = ALOG10(ABS(eAVDC))
     eAVAC = ALOG10(ABS(eAVAC))
     pFBDC = ALOG10(ABS(pFBDC))
     pFBAC = ALOG10(ABS(pFBAC))
  ENDIF

  CGHISTOPLOT,dBPDC, $
              TITLE='dB.p.DC (nT)', $
              MININPUT=dBPDCLim[0], $
              MAXINPUT=dBPDCLim[1]
  CGHISTOPLOT,dBVDC, $
              TITLE='dB.v.DC (nT)', $
              MININPUT=dBVDCLim[0], $
              MAXINPUT=dBVDCLim[1]

  CGHISTOPLOT,dBBDC, $
              TITLE='dB.B.DC (nT)';; , $
              ;; MININPUT=dBVDCLim[0], $
              ;; MAXINPUT=dBVDCLim[1]

  CGHISTOPLOT,dBPAC, $
              TITLE='dB.p.AC (nT)', $
              MININPUT=dBPACLim[0], $
              MAXINPUT=dBPACLim[1]
  CGHISTOPLOT,dBVAC, $
              TITLE='dB.v.AC (nT)', $
              MININPUT=dBVACLim[0], $
              MAXINPUT=dBVACLim[1]

  CGHISTOPLOT,dBBAC, $
              TITLE='dB.B.AC (nT)';; , $
              ;; MININPUT=dBVACLim[0], $
              ;; MAXINPUT=dBVACLim[1]


  WINDOW,winOffset+1

  !P.MULTI = [0,2,2,0,0]

  CGHISTOPLOT,eAVDC, $
              TITLE='e.AlongV.DC (nT)', $
              MININPUT=eAVDCLim[0], $
              MAXINPUT=eAVDCLim[1]
  CGHISTOPLOT,eAVAC, $
              TITLE='e.AlongV.AC (nT)', $
              MININPUT=eAVACLim[0], $
              MAXINPUT=eAVACLim[1]
  CGHISTOPLOT,pFBDC, $
              TITLE='pFlux.B.DC (nT)', $
              MININPUT=pFBDCLim[0], $
              MAXINPUT=pFBDCLim[1]
  CGHISTOPLOT,pFBAC, $
              TITLE='pFlux.B.AC (nT)', $
              MININPUT=pFBACLim[0], $
              MAXINPUT=pFBACLim[1]
  

  ;;What's the horn?
  ;;There's a little horn here
  this = WHERE(ALOG10(ABS(sway__DB.db.p.dc)) GE 2.7 AND ALOG10(ABS(sway__DB.db.p.dc)) LE 2.75)
  uniqOrbs = SWAY__DB.orbit[this[UNIQ(SWAY__DB.orbit[this])]]
  FOR k=0,N_ELEMENTS(uniqOrbs)-1 DO BEGIN & orb = uniqOrbs[k] & ind = WHERE(SWAY__DB.orbit EQ orb) & PRINT,orb,', ',N_ELEMENTS(WHERE(ABS(ALOG10(SWAY__DB.dB.P.DC[ind])) GE 2.7 AND ABS(ALOG10(SWAY__DB.dB.P.DC[ind])) LE 2.8)) & ENDFOR

  
  STOP

END
