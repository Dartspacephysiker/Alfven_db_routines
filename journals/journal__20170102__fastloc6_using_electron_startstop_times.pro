;;2017/01/02
;;Just waiting for the day when I get all of the Je_time stuff un-duped so I can pull the trigger here
PRO JOURNAL__20170102__FASTLOC6_USING_ELECTRON_STARTSTOP_TIMES

  COMPILE_OPT IDL2

  startOrb = 500
  stopOrb  = 25007

  resumeFromTmp = 0

  jeDir    = '/home/spencerh/software/sdt/batch_jobs/saves_output_etc/eesa_time_intervals/'

  outDir   = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals6/'
  outFile  = STRING(FORMAT='("fastLoc_intervals6--",A0,"--",I0,"-",I0,"--Je_times.sav")', $
                    GET_TODAY_STRING(/DO_YYYYMMDD_FMT), $
                    startOrb, $
                    stopOrb)
  outMFile = STRING(FORMAT='("fastLoc_intervals6--",A0,"--",I0,"-",I0,"--Je_times--mapRatio.sav")', $
                    GET_TODAY_STRING(/DO_YYYYMMDD_FMT), $
                    startOrb, $
                    stopOrb)
  outTFile = STRING(FORMAT='("fastLoc_intervals6--",A0,"--",I0,"-",I0,"--Je_times--time_and_delta_t.sav")', $
                    GET_TODAY_STRING(/DO_YYYYMMDD_FMT), $
                    startOrb, $
                    stopOrb)
  tmpFile  = "TMP--" + outFile

  ;;Assume an array of 50 million
  nElem          = 50000000L
  fastLoc        = {x      :   MAKE_ARRAY(nElem,/DOUBLE), $
                    orbit  :   MAKE_ARRAY(nElem,/INTEGER), $
                    alt    :   MAKE_ARRAY(nElem,/FLOAT), $
                    MLT    :   MAKE_ARRAY(nElem,/FLOAT), $
                    ILAT   :   MAKE_ARRAY(nElem,/FLOAT)}
  mapRatio       = MAKE_ARRAY(nElem,/FLOAT)
  
  ;;Start 'er up
  curElem        = 0L
  TIC
  orbClock       = 'fastLoc6'
  ticTocClock    = TIC(orbClock)

  checkInterval  = 5000
  CASE 1 OF
     KEYWORD_SET(resumeFromTmp): BEGIN
        IF FILE_TEST(outDir+tmpFile) THEN BEGIN
           PRINT,'Resuming from tmpFile: ' + tmpFile + ' ...'
           RESTORE,outDir+tmpFile
           startOrb       = TEMPORARY(startOrbSav)
           stopOrb        = TEMPORARY(stoporbSav)
           fastLoc        = TEMPORARY(fastLocSav)
           mapRatio       = TEMPORARY(mapRatioSav)
           checkInterval  = TEMPORARY(checkIntervalSav)
           curElem        = TEMPORARY(curElemSav)
        ENDIF ELSE BEGIN
           PRINT,"Couldn't restore tmpFile! Creating fastLoc6 from scratch ..."
        ENDELSE
     END
     ELSE: BEGIN
        PRINT,'Beginning creation of fastLoc6 ...'
     END
  ENDCASE

  orb = startOrb
  ;; FOR orb=startOrb,stopOrb DO BEGIN
  WHILE orb LT stopOrb DO BEGIN

     this = LOAD_JE_AND_JE_TIMES_FOR_ORB(orb, $
                                         /USE_DUPELESS_FILES, $
                                         TIME_RANGES_OUT=tmpTRanges, $
                                         NINTERVALS_OUT=tmpNIntervals, $
                                         OUT_FILE_ORB1=orb1, $
                                         OUT_FILE_ORB2=orb2, $
                                         OUT_JEFILENAME=out_jeFileName)

     RESTORE,jeDir+out_jeFileName

     PRINT,'out_jeFileName: ',out_jeFileName
     ;; times = !NULL & FOREACH struct,je_hash DO time = [times,struct.x]
;; help,je_trange_hash[1002]
;; <Expression>    DOUBLE    = Array[1, 2]

     times = !NULL
     lastStartT = 0
     lastStopT  = 0
     keys = LIST_TO_1DARRAY(je_tRange_hash.keys())

     ;;what happens if I just get all of the times first?
     tRangeArr = MAKE_ARRAY(10000,2,VALUE=0.D,/DOUBLE)
     keys = keys[SORT(keys)]
     curElom = 0
     FOREACH key,keys DO BEGIN
        ;; FOREACH tRange,je_tRange_hash,key DO BEGIN
        tRange  = je_tRange_hash[key]
        nTRange = N_ELEMENTS(tRange[*,0])

        IF nTRange EQ 0 THEN BEGIN
           PRINT,"Orb " + key
           STOP
           CONTINUE
        ENDIF

        IF nTRange GT 1 THEN BEGIN
           CHECK_SORTED,tRange[*,0],isStartSorted,/QUIET
           CHECK_SORTED,tRange[*,1],isStopSorted,/QUIET
           IF ~(isStartSorted AND isStopSorted) THEN STOP
        ENDIF
        
        tRangeArr[[curElom:(curElom+nTRange-1)],0] = tRange[*,0]
        tRangeArr[[curElom:(curElom+nTRange-1)],1] = tRange[*,1]

        curElom += nTRange

        ;; FOR k=0,N_ELEMENTS(tRange[*,0])-1 DO BEGIN
        ;;    startT = tRange[k,0]
        ;;    stopT  = tRange[k,1]

        ;;    IF (startT LE lastStartT) OR (stopT LE lastStopT) OR (startT LE lastStopT) THEN BEGIN
        ;;       PRINT,"WHATTTTT FOR ORBIT " + STRCOMPRESS(key,/REMOVE_ALL)
        ;;    ENDIF
        ;;    times = [times, $
        ;;             MAKE_EVENLY_SPACED_TIME_SERIES(DELTA_T=2.5, $
        ;;                                            START_T=startT, $
        ;;                                            STOP_T=stopT)]

        ;;    lastStartT = startT
        ;;    lastStopT  = stopT
        ;; ENDFOR

     ENDFOREACH
     tRangeArr = tRangeArr[[0:(curElom-1)],*]

     IF (WHERE((tRangeArr[*,1]-tRangeArr[*,0]) LE 0))[0] NE -1 THEN STOP
     IF (WHERE((tRangeArr[[1:(curElom-1)],0]-tRangeArr[[0:(curElom-2)],0]) LE 0))[0] NE -1 THEN STOP
     IF (WHERE((tRangeArr[[1:(curElom-1)],1]-tRangeArr[[0:(curElom-2)],1]) LE 0))[0] NE -1 THEN STOP

     FOR k=0,curElom-1 DO BEGIN
        times = [times,MAKE_EVENLY_SPACED_TIME_SERIES(DELTA_T=2.5, $
                                                   START_T=tRangeArr[k,0], $
                                                   STOP_T=tRangeArr[k,1])]
     ENDFOR

     ;; FOREACH key,keys DO BEGIN
     ;;    ;; FOREACH tRange,je_tRange_hash,key DO BEGIN
     ;;    tRange = je_tRange_hash[key]
     ;;    FOR k=0,N_ELEMENTS(tRange[*,0])-1 DO BEGIN
     ;;       startT = tRange[k,0]
     ;;       stopT  = tRange[k,1]

     ;;       IF (startT LE lastStartT) OR (stopT LE lastStopT) OR (startT LE lastStopT) THEN BEGIN
     ;;          PRINT,"WHATTTTT FOR ORBIT " + STRCOMPRESS(key,/REMOVE_ALL)
     ;;       ENDIF
     ;;       times = [times, $
     ;;                MAKE_EVENLY_SPACED_TIME_SERIES(DELTA_T=2.5, $
     ;;                                               START_T=startT, $
     ;;                                               STOP_T=stopT)]

     ;;       lastStartT = startT
     ;;       lastStopT  = stopT
     ;;    ENDFOR
     ;; ENDFOREACH

     IF (WHERE((times[1:-1]-times[0:-2]) LT 0))[0] NE -1 THEN STOP

     ;; IF this EQ 0 THEN BEGIN
        ;; FOR k=0,tmpNIntervals-1 DO BEGIN
        GET_FA_ORBIT, $
           times, $
           /TIME_ARRAY, $
           /ALL, $
           ;; DELTA_T=2.5, $
           /DEFINITIVE

        ;; GET_FA_ORBIT, $
        ;;    tmpTRanges[k,0], $
        ;;    tmpTRanges[k,1], $
        ;;    /ALL, $
        ;;    DELTA_T=2.5, $
        ;;    /DEFINITIVE

        GET_DATA,'ORBIT',DATA=tmpOrb
        GET_DATA,'ALT',DATA=tmpAlt
        GET_DATA,'ILAT',DATA=tmpILAT
        GET_DATA,'MLT',DATA=tmpMLT
        GET_DATA,'B_model',DATA=bMod
        GET_DATA,'BFOOT',DATA=bFoot

        mag1      = (bMod.y[*,0]*bMod.y[*,0]+ $
                     bMod.y[*,1]*bMod.y[*,1]+ $
                     bMod.y[*,2]*bMod.y[*,2])^0.5
        mag2      = (bFoot.y[*,0]*bFoot.y[*,0]+ $
                     bFoot.y[*,1]*bFoot.y[*,1]+ $
                     bFoot.y[*,2]*bFoot.y[*,2])^0.5
        ratio     = TEMPORARY(mag2)/TEMPORARY(mag1)


        bro     = N_ELEMENTS(tmpOrb.x)
        tmpInds = [curElem:(curElem+bro-1)]

        fastLoc.x[tmpInds]      = tmpOrb.x
        fastLoc.orbit[tmpInds]  = (TEMPORARY(tmpOrb)).y
        fastLoc.alt[tmpInds]    = (TEMPORARY(tmpAlt)).y
        fastLoc.mlt[tmpInds]    = (TEMPORARY(tmpMlt)).y
        fastLoc.ilat[tmpInds]   = (TEMPORARY(tmpIlat)).y
        mapRatio[tmpInds]       = TEMPORARY(ratio)

        curElem += bro
        ;; ENDFOR
        
        PRINT,FORMAT='("Orbits ",I0,"-",I0," (",I0," elems so far)")',orb1,orb2,curElem
        TOC,ticTocClock

        IF ( (orb MOD checkInterval) EQ 0) THEN BEGIN

           startOrbSav       = startOrb
           stopOrbSav        = stopOrb
           orbSav            = orb
           fastLocSav        = TEMPORARY(fastLoc)
           mapRatioSav       = TEMPORARY(mapRatio)
           checkIntervalSav  = checkInterval
           curElemSav        = curElem

           PRINT,'Saving to tmpFile: ' + tmpFile + ' ...'
           SAVE,startOrbSav,stopOrbSav,orbSav,fastLocSav,mapRatioSav,checkIntervalSav,curElemSav,FILENAME=outDir+tmpFile

           fastLoc           = TEMPORARY(fastLocSav)
           mapRatio          = TEMPORARY(mapRatioSav)

        ENDIF

     ;; ENDIF ELSE BEGIN
     ;;    ;; PRINT,"Issues with orbit " + STRCOMPRESS(orb,/REMOVE_ALL) + "!!"
     ;; ENDELSE
     
           orb = orb2 + 1

  ENDWHILE
  ;; ENDFOR

  STOP

  ;;And where are we?
  fastLoc          = {x      :   fastLoc.x[0:(curElem-1)], $
                      orbit  :   fastLoc.orbit[0:(curElem-1)], $
                      alt    :   fastLoc.alt[0:(curElem-1)], $
                      MLT    :   fastLoc.mlt[0:(curElem-1)], $
                      ILAT   :   fastLoc.ilat[0:(curElem-1)]}
  mapRatio         = mapRatio[0:(curElem-1)]

  PRINT,"Saving fastLoc6 to " + outFile + '...'
  SAVE,fastLoc,FILENAME=outDir+outFile

  PRINT,"Saving fastLoc6 mapRatio to " + outMFile + '...'
  SAVE,mapRatio,FILENAME=outDir+outMFile

  ;; fastLoc_times    = fastLoc.x ;;Don't need to include fastLoc_times since we can set fastLoc_has_times in LOAD_FASTLOC_AND_FASTLOC_TIMES
  fastLoc_delta_t  = MAKE_ARRAY(N_ELEMENTS(fastLoc.x),/FLOAT,VALUE=2.5)
  PRINT,"Saving fastLoc_times and fastLoc_delta_t to " + outTFile + '...'
  ;; SAVE,fastLoc_times,fastLoc_delta_t,FILENAME=outDir+outTFile
  SAVE,fastLoc_delta_t,FILENAME=outDir+outTFile

END

