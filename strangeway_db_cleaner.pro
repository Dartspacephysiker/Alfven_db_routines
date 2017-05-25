;2017/05/25
FUNCTION STRANGEWAY_DB_CLEANER,dbStruct, $
                               MAXMAGFLAG=maxMagFlag

  COMPILE_OPT IDL2,STRICTARRSUBS

  ;; @common__strangeway_bands.pro

  ;;See JOURNAL__20170525__EXPLORING_STRANGEWAY_DB_WITH_HISTOS for some reasoning
  eAlongVDCLim = 1D3
  eAlongVACLim = 1D3

  ;; dBPDCLim     = 10.^(5.0)
  dBPDCLim     = 10.^(3.3)
  dBPDCLim     = 10.^(3.0)
  dBPACLim     = 1D3

  dBVDCLim     = 10.^(3.0)

  dBBDCLim     = 10.^(3.0)

  IF KEYWORD_SET(sWay_maxMagFlag) THEN BEGIN
     ;;How to use magFlags, you wonder? Like'is:
     theseVals = VALUE_LOCATE(dbStruct.magFlags.x,dbStruct.time)

     STOP

  ENDIF


  cleaned_i = LINDGEN(N_ELEMENTS(dbStruct.time))

  ;; WHERE(FINITE(dbStruct.time))

  nSubTags = [0, $                ;time
              0, $                ;orbit
              0, $                ;alt
              0, $                ;mlt
              0, $                ;ilat
              0, $                ;magRatio
              3, $                ;dB
              1, $                ;e
              -1, $               ;ptcl
              3, $                ;pFlux
              -1]

  FOR k=0,N_ELEMENTS(TAG_NAMES(dbStruct))-1 DO BEGIN

     PRINT,"SWAYCLEAN: TAG #",k

     ;; shouldContinue = 0
     CASE nSubTags[k] OF
        -1: BEGIN
           ;; shouldContinue = 1
        END
        0: BEGIN
           cleaned_i = CGSETINTERSECTION(cleaned_i,WHERE(FINITE(dbStruct.(k))),COUNT=nClean)
        END
        ELSE: BEGIN

           FOR kk=0,nSubTags[k]-1 DO BEGIN

              CASE SIZE( dbStruct.(k).(kk),/TYPE) OF
                 8: BEGIN

                    tmpTagNames = TAG_NAMES( dbStruct.(k).(kk) )
                    
                    ACTag       = WHERE(STRUPCASE(tmpTagNames) EQ 'AC') 
                    DCTag       = WHERE(STRUPCASE(tmpTagNames) EQ 'DC') 

                    IF ACTag[0] NE -1 THEN BEGIN

                       cleaned_i = CGSETINTERSECTION(cleaned_i,WHERE(FINITE(dbStruct.(k).(kk).(ACTag))),COUNT=nClean)

                       IF nClean LE 10 THEN STOP

                    ENDIF

                    IF DCTag[0] NE -1 THEN BEGIN

                       cleaned_i = CGSETINTERSECTION(cleaned_i,WHERE(FINITE(dbStruct.(k).(kk).(DCTag))),COUNT=nClean)

                       IF nClean LE 10 THEN STOP

                    ENDIF

                 END
                 ELSE: BEGIN

                    ;; STOP

                 END
              ENDCASE

           ENDFOR

        END
     ENDCASE

     IF nClean LE 10 THEN STOP

  ENDFOR

  ;;StrangewayLims
  ;;FLOAT(N_ELEMENTS(WHERE(ALOG10(ABS(sway__db.e.alongv.dc)) GE 3)))/N_ELEMENTS(sway__db.e.alongv.dc)*100.
  ;; 0.23166740

  ;;FLOAT(N_ELEMENTS(WHERE(ALOG10(ABS(sway__db.e.alongv.ac)) GE 3)))/N_ELEMENTS(sway__db.e.alongv.dc)*100.
  ;; 0.11114024

  ;; badGuy_i = WHERE(ALOG10(ABS(sway__db.e.alongv.dc)) GE 4)
  ;; uniqBads = dbStruct.orbit[badGuy_i[UNIQ(sway__db.orbit[badGuy_i])]]
  ;; PRINT,uniqBads

  ;;There's a little horn here
  ;; this = WHERE(ALOG10(ABS(sway__DB.db.p.dc)) GE 2.7 AND ALOG10(ABS(sway__DB.db.p.dc)) LE 2.8)
  ;; uniqOrbs = dbStruct.orbit[this[UNIQ(dbStruct.orbit[this])]]
  ;; FOR k=0,N_ELEMENTS(uniqOrbs)-1 DO BEGIN & orb = uniqOrbs[k] & ind = WHERE(dbStruct.orbit EQ orb) & PRINT,orb,', ',N_ELEMENTS(WHERE(ABS(ALOG10(dbStruct.dB.P.DC[ind])) GE 2.7 AND ABS(ALOG10(dbStruct.dB.P.DC[ind])) LE 2.8)) & ENDFOR

  cleaned_i = CGSETINTERSECTION(cleaned_i,WHERE(ABS( dbStruct.e.alongV.DC) LE eAlongVDCLim),COUNT=nClean)
  cleaned_i = CGSETINTERSECTION(cleaned_i,WHERE(ABS( dbStruct.e.alongV.AC) LE eAlongVACLim),COUNT=nClean)

  cleaned_i = CGSETINTERSECTION(cleaned_i,WHERE(ABS( dbStruct.dB.P.AC    ) LE dBPACLim    ),COUNT=nClean)
  cleaned_i = CGSETINTERSECTION(cleaned_i,WHERE(ABS( dbStruct.dB.P.DC    ) LE dBPDCLim    ),COUNT=nClean)

  cleaned_i = CGSETINTERSECTION(cleaned_i,WHERE(ABS( dbStruct.dB.V.DC    ) LE dBVDCLim    ),COUNT=nClean)

  cleaned_i = CGSETINTERSECTION(cleaned_i,WHERE(ABS( dbStruct.dB.B.DC    ) LE dBBDCLim    ),COUNT=nClean)

  ;; FLOAT(N_ELEMENTS(WHERE(ALOG10(ABS(sway__db.db.p.ac)) GE 3)))/N_ELEMENTS(sway__db.e.alongv.dc)*100.

  PRINT,"N clean SWAY inds: ",N_ELEMENTS(cleaned_i)

  RETURN,cleaned_i

END
