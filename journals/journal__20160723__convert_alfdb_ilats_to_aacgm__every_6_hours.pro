;;07/22/16
PRO JOURNAL__20160723__CONVERT_ALFDB_ILATS_TO_AACGM__EVERY_6_HOURS

  COMPILE_OPT IDL2

  orig_routineName  = 'JOURNAL__20160723__CONVERT_ALFDB_ILATS_TO_AACGM'

  R_E               = 6371.2D    ;Earth radius in km, from IGRFLIB_V2.pro


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;output
  outDir            = '/SPENCEdata/Research/database/FAST/ephemeris/'
  outFile           = 'Dartdb_20160508--502-16361_despun--maximus--AACGM_coords.sav'

  ;;In case we get cut off--think SNES emulator savestate
  tmpFile           = outDir+'TEMP_AACGM--Dartdb_20160508.sav'

  ;;has GEO coords
  maxBonusFile      = 'Dartdb_20160508--502-16361_despun--maximus--GEO_and_MAG_coords.sav'
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Input
  maxEphemFile      = 'Dartdb_20160508--502-16361_despun--maximus--bonus_ephemeris_info.sav'

  maxFile           = 'Dartdb_20160508--502-16361_despun--maximus--pflux_lshell--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'
  maxTFile          = 'Dartdb_20160508--502-16361_despun--cdbtime--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'
  maxDir            = '/SPENCEdata/Research/database/FAST/dartdb/saves/'

  ;;Load the stuff we need 
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,DBFILE=maxFile,DB_TFILE=maxTFile,DBDIR=maxDir

  ;;Now the ephem file
  RESTORE,outDir+maxBonusFile

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Times in CDF epoch time
  ;; time_epoch          = UTC_TO_CDF_EPOCH(maximu)

  ;; YearArr                = FIX(STRMID(maximus.time,0,4))
  ;; MonthArr               = FIX(STRMID(maximus.time,5,2))
  ;; DayArr                 = FIX(STRMID(maximus.time,8,2))
  ;; HourArr                = FIX(STRMID(maximus.time,11,2))
  ;; MinArr                 = FIX(STRMID(maximus.time,14,2))
  ;; SecArr                 = FLOAT(STRMID(maximus.time,17,6))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;feed it to GEOPACK
  nTot                   = N_ELEMENTS(maximus.time)
  maxEphem_GEOSph_arr    = TRANSPOSE([[max_GEO.LAT],[max_GEO.LON],[max_GEO.ALT]])
  maxEphem_AACGMSph_arr  = MAKE_ARRAY(4,nTot,/FLOAT) ;;One more for MLT at end

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;generate the dates
  startYear       = 1996
  stopYear        = 2001

  hourArr         = [6,12,18]

  PRINT,'Making time arrays ...'
  MAKE_TIME_ARRAYS, $
     IN_STARTYEAR=startYear, $
     IN_STOPYEAR=stopYear, $
     IN_HOURARR=hourArr, $
     OUT_YEARARR=finalYearArr, $
     OUT_DOYARR=finalDOYArr, $
     OUT_MONTHARR=finalMonthArr, $
     OUT_DAYARR=finalDayArr, $
     OUT_HOURARR=finalHourArr, $
     OUT_JULDAY=julDay

  time_utc           = JULDAY_TO_UTC(julDay)
  nTimes             = N_ELEMENTS(time_utc)

  time_epoch         = UTC_TO_CDF_EPOCH(time_utc)


  ;;Free up dat mem
  maximus            = !NULL
  max_GEO            = !NULL
  max_MAG            = !NULL

  PRINT,"Feeding it to AACGM ..."

  
  IF FILE_TEST(tmpFile) THEN BEGIN
     PRINT,"Restoring " + tmpFile + ' ...'
     RESTORE,tmpFile
     PRINT,"nGotEm        : " + STRCOMPRESS(nGotEm,/REMOVE_ALL)
     PRINT,"lastCheck     : " + STRCOMPRESS(lastCheck,/REMOVE_ALL)
     PRINT,"checkInterval : " + STRCOMPRESS(checkInterval,/REMOVE_ALL)
     
     startK        = k

     PRINT,""
     PRINT,"Starting from k = " + STRCOMPRESS(startK,/REMOVE_ALL) + " ..."
  ENDIF ELSE BEGIN
     nGotEm        = 0
     lastCheck     = 0
     checkInterval = 100
     minK    = MIN(ABS(time_utc-cdbTime[0]),startK)
     startK  = (startK EQ 0 ? 0 : startK-1)
  ENDELSE


  TIC
  runCName = "AACGM Clock"
  runC     = TIC(runCName)
  FOR k=startK,nTimes-2 DO BEGIN ;nTimes-2 because we use k and k+1 for each iteration

     checkEmOut  = WHERE(( cdbTime GE  time_utc[k]) AND ( cdbTime LE time_utc[k+1]),nCheckEm)

     IF nCheckEm GT 0 THEN BEGIN

        e = AACGM_V2_SETDATETIME(finalYearArr[k],finalMonthArr[k],finalDayArr[k], $
                                 finalHourArr[k],0,0)

        tmpAACGM                  = CNVCOORD_V2(maxEphem_GEOSph_arr[*,checkEmOut], $
                                                /ALLOW_TRACE)
        AACGM_MLT                 = MLT_V2(tmpAACGM[1,*])
        maxEphem_AACGMSph_arr[*,checkEmOut]  = [tmpAACGM,AACGM_MLT]

        nGotEm   += nCheckEm
     ENDIF
     
     IF nGotEm GE (lastCheck+checkInterval) THEN BEGIN
        PRINT,"N completed : " + STRCOMPRESS(nGotEm,/REMOVE_ALL)
        TOC,runC
        lastCheck += checkInterval

        SAVE,maxEphem_AACGMSph_arr,lastCheck,checkInterval,nGotEm,k,FILENAME=tmpFile 
     ENDIF

  ENDFOR
  TOC

  maxEphem_AACGMSph_arr[2,*]     = (maxEphem_AACGMSph_arr[2,*]*R_E-R_E) ;convert back to altitude above sea level

  max_AACGM   = {ALT:maxEphem_AACGMSph_arr[2,*], $
                MLT:maxEphem_AACGMSph_arr[3,*], $
                LAT:maxEphem_AACGMSph_arr[0,*]}

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Save it
  PRINT,'Saving ' + outDir + outFile + '...'
  save,max_AACGM,FILENAME=outDir+outFile

  PRINT,"Did it!"
  STOP


END
