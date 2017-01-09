;;2017/01/02
PRO JOURNAL__20170102__FASTLOC6_USING_ELECTRON_STARTSTOP_TIMES

  COMPILE_OPT IDL2

  startOrb = 500
  stopOrb  = 23999

  resumeFromTmp = 1

  outDir   = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals6/'
  outFile  = STRING(FORMAT='("fastLoc_intervals6--",A0,"--",I0,"-",I0,"--Je_times.sav")', $
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

  ;;Start 'er up
  curElem        = 0L
  TIC
  orbClock       = 'fastLoc6'
  ticTocClock    = TIC(orbClock)

  checkInterval  = 100
  CASE 1 OF
     KEYWORD_SET(resumeFromTmp): BEGIN
        IF FILE_TEST(outDir+tmpFile) THEN BEGIN
           PRINT,'Resuming from tmpFile: ' + tmpFile + ' ...'
           RESTORE,outDir+tmpFile
           startOrb       = TEMPORARY(startOrbSav)
           stopOrb        = TEMPORARY(stoporbSav)
           fastLoc        = TEMPORARY(fastLocSav)
           checkInterval  = TEMPORARY(checkIntervalSav)
           curElem        = TEMPORARY(curElemSav)
        ENDIF ELSE BEGIN
           PRINT,"Couldn't restore tmpFile! Creating fastLoc5 from scratch ..."
        ENDELSE
     END
     ELSE: BEGIN
        PRINT,'Beginning creation of fastLoc5 ...'
     END
  ENDCASE
  FOR orb=startOrb,stopOrb DO BEGIN

     this = LOAD_JE_AND_JE_TIMES_FOR_ORB(orb, $
                                         /USE_DUPELESS_FILES, $
                                         TIME_RANGES_OUT=tmpTRanges, $
                                         NINTERVALS_OUT=tmpNIntervals)
     IF this EQ 0 THEN BEGIN
        FOR k=0,tmpNIntervals-1 DO BEGIN
           GET_FA_ORBIT, $
              tmpTRanges[k,0], $
              tmpTRanges[k,1], $
              DELTA_T=2.5, $
              /DEFINITIVE

           GET_DATA,'ORBIT',DATA=tmpOrb
           GET_DATA,'ALT',DATA=tmpAlt
           GET_DATA,'ILAT',DATA=tmpILAT
           GET_DATA,'MLT',DATA=tmpMLT

           bro     = N_ELEMENTS(tmpOrb.x)
           tmpInds = [curElem:(curElem+bro-1)]

           fastLoc.x[tmpInds] = tmpOrb.x
           fastLoc.orbit[tmpInds] = tmpOrb.y
           fastLoc.alt[tmpInds] = tmpAlt.y
           fastLoc.mlt[tmpInds] = tmpMlt.y
           fastLoc.ilat[tmpInds] = tmpIlat.y

           curElem += bro
        ENDFOR
                                         
        IF ( (orb MOD checkInterval) EQ 0) THEN BEGIN
           PRINT,FORMAT='("Orbit ",I0)',orb
           TOC,ticTocClock

           startOrbSav       = startOrb
           stopOrbSav        = stopOrb
           orbSav            = orb
           fastLocSav        = fastLoc
           checkIntervalSav  = checkInterval
           curElemSav        = curElem

           PRINT,'Saving to tmpFile: ' + tmpFile + ' ...'
           SAVE,startOrbSav,stopOrbSav,orbSav,fastLocSav,checkIntervalSav,curElemSav,FILENAME=outDir+tmpFile

        ENDIF

     ENDIF ELSE BEGIN
        ;; PRINT,"Issues with orbit " + STRCOMPRESS(orb,/REMOVE_ALL) + "!!"
     ENDELSE
        
  ENDFOR

  ;;And where are we?
  fastLoc        = {x      :   fastLoc.x[0:curElem-1], $
                    orbit  :   fastLoc.orbit[0:curElem-1], $
                    alt    :   fastLoc.alt[0:curElem-1], $
                    MLT    :   fastLoc.mlt[0:curElem-1], $
                    ILAT   :   fastLoc.ilat[0:curElem-1]}

  PRINT,"Saving fastLoc6 to " + outFile + '...'
  SAVE,fastLoc,FILENAME=outDir+outFile

  fastLoc_times = fastLoc.x
  fastLoc_delta_t = MAKE_ARRAY(N_ELEMENTS(fastLoc.x),/FLOAT,VALUE=2.5)
  PRINT,"Saving fastLoc_times and fastLoc_delta_t to " + outTFile + '...'
  SAVE,fastLoc_times,fastLoc_delta_t,FILENAME=outDir+outTFile
END

