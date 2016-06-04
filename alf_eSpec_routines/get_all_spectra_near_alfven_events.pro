;;06/04/16
PRO GET_ALL_SPECTRA_NEAR_ALFVEN_EVENTS

  COMPILE_OPT IDL2

  startStopDir                  = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  startStopFile                 = 'alfven_startstop_maxJ_times--500-16361_inc_lower_lats--burst_1000-16361.sav'
  RESTORE,startStopDir+startStopFile

  LOAD_ALF_NEWELL_ESPEC_DB,eSpec,alf_i__good_eSpec,good_eSpec_i,/DONT_LOAD_IN_MEMORY, $
                           NEWELLDBFILE=NewellDBFile, $
                           NEWELLDBDIR=NewellDBDir
  outFile                       = STRMID(NewellDBFile,0,STRPOS(newelldbfile,'TOTAL')) + $
                                  'all_good_alf_eSpec_i--' + $
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

  nBad                          = 0
  count                         = 0
  nToCount                      = 9999

  TIC
  FOR i=0,nToCheck-1 DO BEGIN
     IF count EQ 0 THEN BEGIN
        clock                   = TIC("Clock_"+STRCOMPRESS(i,/REMOVE_ALL))
     ENDIF 


     tmpEspecInds               = [(good_eSpec_i[i]-30) > 0:(good_eSpec_i[i]+30) < (nEspecTimes-1)]
     tmpTimes                   = eSpec_times[tmpEspecInds]

     tmp_in_ii                  = WHERE(tmpTimes GE alfven_start_time[i] AND $
                            tmpTimes LE alfven_stop_time[i],nIn,/NULL)

     tmp_outbef_ii              = WHERE(tmpTimes LT alfven_start_time[i] AND $
                            (ABS(tmpTimes-alfven_start_time[i]) LE 5),nOutBef,/NULL)
     tmp_outaft_ii              = WHERE(tmpTimes GT alfven_stop_time[i] AND $
                            (ABS(tmpTimes-alfven_stop_time[i]) LE 5),nOutAft,/NULL)

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
     ENDELSE

     IF nBad GT 5 THEN STOP

     IF count EQ nToCount THEN BEGIN
        TOC,clock
        count                   = 0
     ENDIF ELSE count++

  ENDFOR

  ;;Head check
  ;; PRINT,'Head checking...'
  ;; FOR i=0,nToCheck-1 DO BEGIN
  ;;    IF ~ISA(all_alf_eSpec_list__i[i]) THEN STOP
  ;; ENDFOR

  PRINT,'Saving all these wonderful indices...'
  SAVE,all_alf_eSpec_list__i,all_alf_eSpec_list__types,all_alf_eSpec_list__diffs, $
       FILENAME=NewellDBDir+outFile
END
