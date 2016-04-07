;2016/04/07 Generalized from storms version

PRO GET_SEA_TIME_UTC,NEPOCHS=nEpochs, $
                     EPOCHINDS=epochInds, $
                     ;; SEAFILE=seaFile, $
                     MAXIMUS=maximus, $
                     ;; SEASTRUCTURE=seaStructure, $
                     USE_DARTDB_START_ENDDATE=use_dartDB_start_endDate, $                                         ;DBs
                     STARTDATE=startDate,STOPDATE=stopDate, $
                     SEA_CENTERTIMES_UTC=sea_centerTimes_utc, $ ;extra info
                     CENTERTIME=centerTime, $
                     TSTAMPS=tStamps, $
                     SEASTRING=seaString, $
                     ;; SEASTRUCT_INDS=seaStruct_inds, $ ; outs
                     RANDOMTIMES=randomTimes
  
  IF KEYWORD_SET(use_dartdb_start_enddate) THEN BEGIN
     startDate=str_to_time(maximus.time[0])
     stopDate=str_to_time(maximus.time[-1])
     PRINT,'Using start and stop time from Dartmouth/Chaston database.'
     PRINT,'Start time: ' + maximus.time[0]
     PRINT,'Stop time: ' + maximus.time[-1]
  ENDIF
  
  IF KEYWORD_SET(STARTDATE) THEN BEGIN
     IF N_ELEMENTS(STOPDATE) EQ 0 THEN BEGIN
        PRINT,"No stop year specified! Plotting data up to a full year after startDate."
        stopDate=startDate+86400.*31.*12.
     ENDIF
     
  ENDIF ELSE BEGIN
     PRINT,"No start date provided! Please specify one in UTC time, seconds since Jan 1, 1970."
     RETURN
  ENDELSE
  
  IF KEYWORD_SET(randomTimes) THEN BEGIN
     ;; seaStruct_inds = -1
     seaString              = 'random'
     centerTime             = RANDOMU(seed,nEpochs,/DOUBLE)*(stopDate-startDate)+startDate
     centerTime             = centerTime(SORT(centerTime))
     julDay                 = conv_utc_to_julday(centerTime,tStamps)
  ENDIF ELSE BEGIN
     sea_inds               = WHERE(sea_centerTimes_UTC GE startDate AND sea_centerTimes_UTC LE stopDate,/NULL,NCOMPLEMENT=nDropped)
     
     IF nDropped GT 0 THEN BEGIN
        PRINT,'Dropped ' + STRCOMPRESS(nDropped,/REMOVE_ALL) + "SEAs from the provided list; they're outside the start/stop time requested."
     ENDIF

     sea_centerTimes_UTC    = sea_centerTimes_UTC[sea_inds]

     ;; IF KEYWORD_SET(epochInds) THEN BEGIN
     ;;    PRINT,'Using provided epoch indices (' + STRCOMPRESS(N_ELEMENTS(epochInds),/REMOVE_ALL) + ' epochs)...'
     ;;    PRINT,"Database: " + seaFile
        
     ;;    seaStruct_inds = cgsetintersection(seaStruct_inds,epochInds)
     ;; ENDIF
     
     nEpochs=N_ELEMENTS(sea_centerTimes_UTC)     
     
     IF nEpochs EQ 0 THEN BEGIN
        PRINT,"No seas found for given time range:"
        PRINT,"Start date: ",time_to_str(startDate)
        PRINT,"Stop date: ",time_to_str(stopDate)
        PRINT,'Returning...'
        RETURN
     ENDIF
     
     centerTime = sea_centerTimes_utc
     tStamps    = TIME_TO_STR(sea_centerTimes_utc)
  ENDELSE

END