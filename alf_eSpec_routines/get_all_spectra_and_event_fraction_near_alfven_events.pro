;;06/04/16
PRO GET_ALL_SPECTRA_AND_EVENT_FRACTION_NEAR_ALFVEN_EVENTS

  COMPILE_OPT IDL2,STRICTARRSUBS

  despun                        = 0

  startStopDir                  = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  IF KEYWORD_SET(despun) THEN BEGIN
     startStopFile              = 'alfven_startstop_maxJ_times--502-16361_despun--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'
  ENDIF ELSE BEGIN
     startStopFile              = 'alfven_startstop_maxJ_times--500-16361_inc_lower_lats--burst_1000-16361.sav'
  ENDELSE
  RESTORE,startStopDir+startStopFile

  LOAD_ALF_NEWELL_ESPEC_DB,eSpec,alf_i__good_eSpec,good_eSpec_i,/DONT_LOAD_IN_MEMORY, $
                           DESPUN_ALF_DB=despun, $
                           NEWELLDBFILE=NewellDBFile, $
                           NEWELLDBDIR=NewellDBDir
  outFile                       = STRMID(NewellDBFile,0,STRPOS(newelldbfile,'TOTAL')) + $
                                  'all_good_alf_eSpec_i--killed_befs_afts--' + $
                                  STRMID(NewellDBFile,STRPOS(NewellDBFile,'Orbs_'),STRPOS(NewellDBFile,'2016')-STRPOS(NewellDBFile,'Orbs_')) + $
                                  GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '.sav'
  eSpec                         = !NULL

  alfven_start_time             = alfven_start_time[alf_i__good_eSpec]
  alfven_stop_time              = alfven_stop_time[alf_i__good_eSpec]
  cdbTime                       = cdbTime[alf_i__good_eSpec]
  nToCheck                      = N_ELEMENTS(alf_i__good_eSpec)

  ;;Head check
  diff                          = alfven_stop_time-alfven_start_time
  IF (WHERE(diff LT 0))[0] NE -1 THEN STOP

  ;;Load up all times from the Newell DB
  LOAD_NEWELL_ESPEC_DB,eSpec,/DONT_LOAD_IN_MEMORY
  eSpec_times                   = eSpec.x
  nEspecTimes                   = N_ELEMENTS(eSpec_times)
  eSpec                         = !NULL

  ;; all_alf_eSpec_list__i      = MAKE_ARRAY(nToCheck,/OBJ)
  ;; all_alf_eSpec_list__types  = MAKE_ARRAY(nToCheck,/OBJ)
  all_alf_eSpec_list__i         = LIST()
  all_alf_eSpec_list__types     = LIST()
  all_alf_eSpec_list__diffs     = LIST()

  ;;These variables are all for statistics
  ;;Points before and after the Alfven event can be killed, K?
  killedBef                     = 0
  killedAft                     = 0
  noIn                          = 0

  nBad                          = 0
  count                         = 0
  nToCount                      = 9999
  edgeTimeLim                   = 4
  TIC
  FOR i=0,nToCheck-1 DO BEGIN
     IF count EQ 0 THEN BEGIN
        clock                   = TIC("Clock_"+STRCOMPRESS(i,/REMOVE_ALL))
     ENDIF 


     tmpStart                   = alfven_start_time[i]
     tmpStop                    = alfven_stop_time[i]

     tmpEspecInds               = [(good_eSpec_i[i]-30) > 0:(good_eSpec_i[i]+30) < (nEspecTimes-1)]
     tmpTimes                   = eSpec_times[tmpEspecInds]

     tmp_in_ii                  = WHERE(tmpTimes GE tmpStart AND $
                                        tmpTimes LE tmpStop,nIn,/NULL)

     tmp_outbef_ii              = WHERE(tmpTimes LT tmpStart AND $
                                        (ABS(tmpTimes-tmpStart) LE edgeTimeLim),nOutBef,/NULL)
     tmp_outaft_ii              = WHERE(tmpTimes GT tmpStop AND $
                                        (ABS(tmpTimes-tmpStop) LE edgeTimeLim),nOutAft,/NULL)

     IF N_ELEMENTS(tmp_outbef_ii) GT 1 THEN BEGIN
        tmpJunk                 = MIN(ABS(tmpTimes[tmp_outbef_ii]),tmp_outbef_iii)
        tmp_outbef_ii           = tmp_outbef_ii[tmp_outbef_iii]
        nOutBef                 = 1
        ;; PRINT,"Winner: " + STRCOMPRESS(tmp_outBef_ii)
     ENDIF

     IF N_ELEMENTS(tmp_outaft_ii) GT 1 THEN BEGIN
        tmpJunk                 = MIN(ABS(tmpTimes[tmp_outaft_ii]),tmp_outaft_iii)
        tmp_outaft_ii           = tmp_outaft_ii[tmp_outaft_iii]
        nOutAft                 = 1
        ;; PRINT,"Winner: " + STRCOMPRESS(tmp_outAft_ii)
     ENDIF

     IF (nIn OR nOutBef OR nOutAft) GT 0 THEN BEGIN
        ;;Check who we have 
        IF (nOutBef GT 0) AND (nIn GT 0) THEN BEGIN
           IF MEAN([tmpTimes[tmp_in_ii[0]],tmpTimes[tmp_outbef_ii]]) LT tmpStart THEN BEGIN
              nOutBef           = 0
              tmp_outbef_ii     = !NULL
              killedBef++
           ENDIF
        ENDIF

        IF (nOutAft GT 0) AND (nIn GT 0) THEN BEGIN
           IF MEAN([tmpTimes[tmp_in_ii[0]],tmpTimes[tmp_outaft_ii]]) GT tmpStop THEN BEGIN
              nOutAft           = 0
              tmp_outaft_ii     = !NULL
              killedAft++
           ENDIF
        ENDIF

        IF (nIn EQ 0) AND (nOutAft EQ 1) AND (nOutBef EQ 1) THEN BEGIN
           noIn++
           IF MEAN([tmpTimes[tmp_outbef_ii[0]],tmpTimes[tmp_outaft_ii]]) GT tmpStop THEN BEGIN
              nOutAft           = 0
              tmp_outaft_ii     = !NULL
              killedAft++
           ENDIF ELSE BEGIN
              IF MEAN([tmpTimes[tmp_outbef_ii[0]],tmpTimes[tmp_outaft_ii]]) LT tmpStart THEN BEGIN
                 nOutBef        = 0
                 tmp_outbef_ii  = !NULL
                 killedBef++
              ENDIF
           ENDELSE
        ENDIF

        ;;First the indices
        tmpKeep_i               = [tmpEspecInds[tmp_outbef_ii],tmpEspecInds[tmp_in_ii],tmpEspecInds[tmp_outaft_ii]]

        ;;Now the differences
        tmpDiffs                = FLOAT([tmpTimes[tmp_outbef_ii],tmpTimes[tmp_in_ii],tmpTimes[tmp_outaft_ii]]-cdbTime[i])

        ;;Now types
        types                   = !NULL
        IF nOutBef GT 0 THEN BEGIN
           tmpOutBefType        = MAKE_ARRAY(nOutBef,VALUE=1,/BYTE)
           types                = [types,tmpOutBefType]
        ENDIF
        IF nIn GT 0 THEN BEGIN
           tmpInType            = MAKE_ARRAY(nIn,VALUE=2,/BYTE)
           types                = [types,tmpInType]
        ENDIF
        IF nOutAft GT 0 THEN BEGIN
           tmpOutAftType        = MAKE_ARRAY(nOutAft,VALUE=3,/BYTE)
           types                = [types,tmpOutAftType]
        ENDIF

        all_alf_eSpec_list__types.ADD,types
        all_alf_eSpec_list__i.ADD    ,tmpKeep_i
        all_alf_eSpec_list__diffs.ADD,tmpDiffs
     ENDIF ELSE BEGIN
        nBad++
        PRINT,'Bogey ' + STRCOMPRESS(i,/REMOVE_ALL)
        all_alf_eSpec_list__types.ADD,-1
        all_alf_eSpec_list__i.ADD    ,-1
        all_alf_eSpec_list__diffs.ADD,-1
     ENDELSE

     IF nBad GT 300 THEN STOP

     IF count EQ nToCount THEN BEGIN
        TOC,clock
        count                   = 0
     ENDIF ELSE count++

  ENDFOR

  PRINT,"******STATISTICS*******"
  PRINT,""
  PRINT,FORMAT='("Befores killed :",T20,I0)',killedBef
  PRINT,FORMAT='("Afters  killed :",T20,I0)',killedAft
  PRINT,FORMAT='("No Innies      :",T20,I0)',noIn
  PRINT,""

  ;;Head check
  ;; PRINT,'Head checking...'
  ;; FOR i=0,nToCheck-1 DO BEGIN
  ;;    IF ~ISA(all_alf_eSpec_list__i[i]) THEN STOP
  ;; ENDFOR

  PRINT,'Saving all these wonderful indices...'
  SAVE,all_alf_eSpec_list__i,all_alf_eSpec_list__types,all_alf_eSpec_list__diffs, $
       FILENAME=NewellDBDir+outFile
END
