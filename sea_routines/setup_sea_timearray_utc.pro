;2016/04/07
PRO SETUP_SEA_TIMEARRAY_UTC,sea_timeArray_UTC,TBEFOREEPOCH=tBeforeEpoch,TAFTEREPOCH=tAfterEpoch, $
                            NEPOCHS=nEpochs, $
                            EPOCHINDS=epochInds, $
                            SEAFILE=seaFile, $
                            MAXIMUS=maximus, $
                            ;; SEASTRUCTURE=seaStruct, $
                            USE_DARTDB_START_ENDDATE=use_dartDB_start_endDate, $ ;DBs
                            SEATYPE=seaType, $
                            STARTDATE=startDate, $
                            STOPDATE=stopDate, $
                            SEA_CENTERTIMES_UTC=sea_centerTimes_UTC, $ ;extra info
                            CENTERTIME=centerTime, $
                            DATSTARTSTOP=datStartStop, $
                            TSTAMPS=tStamps, $
                            SEASTRING=seaString, $
                            ;; SEASTRUCT_INDS=seaStruct_inds, $ ; outs
                            RANDOMTIMES=randomTimes, $
                            SAVEFILE=saveFile,SAVESTR=saveString

  IF N_ELEMENTS(sea_timeArray_UTC) NE 0 THEN BEGIN

     nEpochs    = N_ELEMENTS(sea_timeArray_UTC)
     centerTime = sea_timeArray_UTC
     tStamps    = TIME_TO_STR(sea_timeArray_UTC)
     seaString  = 'user-provided'

  ENDIF ELSE BEGIN

     IF randomTimes GT 1 THEN BEGIN
        nEpochs=randomTimes
        GET_SEA_TIME_UTC,NEPOCHS=nEpochs, $
                         EPOCHINDS=epochInds, $
                         MAXIMUS=maximus, $
                         USE_DARTDB_START_ENDDATE=use_dartDB_start_endDate, $ ;DBs
                         STARTDATE=startDate,STOPDATE=stopDate, $
                         SEA_CENTERTIMES_UTC=sea_centerTimes_UTC, $ ;extra info
                         CENTERTIME=centerTime, $
                         TSTAMPS=tStamps, $
                         SEASTRING=seaString, $
                         RANDOMTIMES=randomTimes
     ENDIF ELSE BEGIN
        ;; PRINT,"Why are we here? I think nothing useful happens. If you provided SEA epoch times, you should have been helped elsewhere."
        ;; STOP
        nEpochs=N_ELEMENTS(sea_centerTimes_UTC)
        
        GET_SEA_TIME_UTC,NEPOCHS=nEpochs, $
                         EPOCHINDS=epochInds, $
                         MAXIMUS=maximus, $
                         USE_DARTDB_START_ENDDATE=use_dartDB_start_endDate, $ ;DBs
                         STARTDATE=startDate,STOPDATE=stopDate, $
                         SEA_CENTERTIMES_UTC=sea_centerTimes_UTC, $ ;extra info
                         CENTERTIME=centerTime, $
                         TSTAMPS=tStamps, $
                         SEASTRING=seaString, $
                         RANDOMTIMES=randomTimes
        
     ENDELSE
  ENDELSE

  IF saveFile THEN saveStr+=',startDate,stopDate'

  datStartStop = MAKE_ARRAY(nEpochs,2,/DOUBLE)
  datStartStop[*,0] = centerTime - tBeforeEpoch*3600.   ;[*,0] are the times before which we don't want data for each epoch
  datStartStop[*,1] = centerTime + tAfterEpoch*3600.    ;[*,1] are the times after which we don't want data for each epoch

END