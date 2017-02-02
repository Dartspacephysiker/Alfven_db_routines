;2015/10/19  Added ability to give negative minM so that, for example, the range 18 MLT to 6 MLT (nightside) is possible
FUNCTION GET_MLT_INDS,dbStruct,minM,maxM, $
                      DAWNSECTOR=dawnSector, $
                      DUSKSECTOR=duskSector, $
                      DAYSIDE=dayside, $
                      NIGHTSIDE=nightside, $
                      N_MLT=n_mlt, $
                      N_OUTSIDE_MLT=n_outside_MLT, $
                      DIRECT_MLTS=direct_mlts, $
                      USE_LNG=use_Lng, $
                      LUN=lun

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun=-1 ;;stdout

  IF N_ELEMENTS(dbStruct) EQ 0 THEN BEGIN
     IF ~KEYWORD_SET(direct_mlts) THEN BEGIN
        PRINTF,lun,"Error! No dbStruct struct provided!"
        STOP
     ENDIF ELSE BEGIN
        PRINTF,lun,'Using direct mlts provided by user...'
        mlts              = direct_mlts
     ENDELSE
  ENDIF ELSE BEGIN
     CASE 1 OF
        KEYWORD_SET(use_Lng): BEGIN
           flip           = WHERE(dbStruct.lng LT 0)
           IF flip[0] NE -1 THEN BEGIN
              dbStruct.lng[flip]  = ABS(dbStruct.Lng[flip]) + 180.
              ;; mlts[flip]  = ABS(mlts[flip]) + 180.
           ENDIF
           mlts           = dbStruct.Lng
        END
        ELSE: BEGIN
           mlts           = dbStruct.mlt
           flip           = WHERE(mlts LT 0)
           IF flip[0] NE -1 THEN BEGIN
              mlts[flip]  = ABS(mlts[flip]) + 24.
           ENDIF
        END
     ENDCASE
  ENDELSE

  dawnMinM   = 3
  dawnMaxM   = 11
  duskMinM   = 13
  duskMaxM   = 19
  dayMinM    = 6.0
  dayMaxM    = 18.0
  nightMinM  = -6.0
  nightMaxM  = 6.0

  IF KEYWORD_SET(use_Lng) THEN BEGIN
     dawnMinM   *= 15.
     dawnMaxM   *= 15.
     duskMinM   *= 15.
     duskMaxM   *= 15.
     dayMinM    *= 15.
     dayMaxM    *= 15.
     nightMinM  *= 15.
     nightMaxM  *= 15.
  ENDIF

  CASE 1 OF
     KEYWORD_SET(dayside): BEGIN
        dminM = dayMinM
        dmaxM = dayMaxM

        mltStr = 'dayside'

     END
     KEYWORD_SET(nightside): BEGIN
        dminM = nightMinM
        dmaxM = nightMaxM

        mltStr = 'nightside'

        mlt_i = WHERE(mlts LE 6.0 OR mlts GE 18.0,n_mlt,NCOMPLEMENT=n_outside_MLT)
        
     END
     KEYWORD_SET(dawnSector): BEGIN
        dminM             = dawnMinM
        dmaxM             = dawnMaxM

        mltStr            = 'dawnSector'
     END
     KEYWORD_SET(duskSector): BEGIN

        mltStr            = 'duskSector'

        dminM             = duskMinM
        dmaxM             = duskMaxM
     END     
     KEYWORD_SET(dawnanddusk): BEGIN
        dawnDuskStr       = 'dawn_dusk'

        dminM             = [dawnMinM,duskMinM]
        dmaxM             = [dawnMaxM,duskMaxM]
     END
     ELSE: BEGIN
        mltStr            = 'Bonus'
        dminM             = minM
        dmaxM             = maxM
     END
  ENDCASE

  PRINTF,lun,FORMAT='("Only ",A0,"!")',mltStr

  mlt_i = !NULL
  n_mlt = 0
  n_outside_mlt = N_ELEMENTS(mlts)
  FOR k=0,N_ELEMENTS(dminM)-1 DO BEGIN

     IF dminM[k] LT 0 THEN BEGIN

        PRINTF,lun,'Negative minM! Treating MLTs between ' + STRCOMPRESS(dminM[k]+24,/REMOVE_ALL) + ' and ' + STRCOMPRESS(dmaxM[k],/REMOVE_ALL)
        IF (dminM[k] + 24) LT dmaxM[k] THEN BEGIN
           PRINTF,lun,"GET_MLT_INDS: minM and maxM together make no sense! (minM + 24) is less than maxM!"
           STOP
        ENDIF
        tmp_i_1 = WHERE( mlts GE (dminM[k]+24),n_tmp1 )
        tmp_i_2 = WHERE( mlts LE dmaxM[k],n_tmp2)

        wherecheck,tmp_i_1,tmp_i_2
        n_tmp = n_tmp1 + n_tmp2
        tmp_i = CGSETUNION(tmp_i_1,tmp_i_2) 

        PRINTF,lun,FORMAT='("N events in MLT range",T30,":",T35,I0)',n_tmp
     ENDIF ELSE BEGIN
        tmp_i = WHERE(mlts LE dmaxM[k] and mlts GE dminM[k],n_tmp,NCOMPLEMENT=n_outside_tmp)
        
        ;; PRINTF,lun,FORMAT='("MLT range: ",I0,"–",I0)',dminM[k],dmaxM[k]
        PRINTF,lun,FORMAT='("N events in MLT range",T30,":",T35,I0)',n_tmp
     ENDELSE

     IF tmp_i[0] EQ -1 THEN BEGIN
        PRINTF,lun,'No MLT entries found for the specified MLT range!'
        STOP
     ENDIF

     mlt_i          = [mlt_i,tmp_i]
     n_mlt         += n_tmp
     n_outside_mlt -= n_tmp

  ENDFOR

  IF mlt_i[0] EQ -1 THEN BEGIN
     PRINTF,lun,'No MLT entries found for the specified MLT range!'
     STOP
  ENDIF

  PRINTF,lun,FORMAT='("n events for ",A0,T30,":",T35,I0)',mltStr,n_mlt
  PRINTF,lun,FORMAT='("N outside MLT range",T30,":",T35,I0)',n_outside_MLT
  PRINTF,lun,""
  
  RETURN,mlt_i
  
END