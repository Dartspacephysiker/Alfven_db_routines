;;12/08/16
PRO JOURNAL__20161208__SEE_STARTSTOP_TIMES_HAS_PROBLEMS

  COMPILE_OPT IDL2,STRICTARRSUBS

  inDir   = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  inFile  = 'alfven_startstop_maxJ_times--500-16361_inc_lower_lats--burst_1000-16361.sav'

  PRINT,'Restoring start/stop arrays for maximus ...'
  RESTORE,inDir+inFile

  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,/NO_MEMORY_LOAD,/QUIET

  outDir  = inDir
  outFile = GET_FAST_DB_STRING(maximus) + 'delta_ilats.sav'

  ;;Head check
  nEvents = N_ELEMENTS(maximus.ilat)
  IF (nEvents NE N_ELEMENTS(Alfven_start_time)) OR (nEvents NE N_ELEMENTS(Alfven_stop_time)) THEN STOP

  CHECK_SORTED,cdbTime          ,sortCDB,/QUIET
  CHECK_SORTED,Alfven_start_time,sortStart,/QUIET
  CHECK_SORTED,Alfven_start_time,sortStop,/QUIET

  IF ~(sortStart AND sortStop AND sortCDB) THEN BEGIN
     PRINT,"Someone is out of sorts! "

     PRINT,FORMAT='(A-15,": ",I0)','sortCDB',sortCDB  
     PRINT,FORMAT='(A-15,": ",I0)','sortStart',sortStart
     PRINT,FORMAT='(A-15,": ",I0)','sortStop',sortStop 

     PRINT,"What about maximus?"
     CHECK_SORTED,maximus.time      ,sortMax,/QUIET
     CHECK_SORTED,maximus.start_time,sortMaxStart,/QUIET
     CHECK_SORTED,maximus.start_time,sortMaxStop,/QUIET

     PRINT,FORMAT='(A-15,": ",I0)','sortMax',sortMax
     PRINT,FORMAT='(A-15,": ",I0)','sortMaxStart',sortMaxStart
     PRINT,FORMAT='(A-15,": ",I0)','sortMaxStop',sortMaxStop 

     diff = Alfven_stop_time - Alfven_start_time
     junk = WHERE(diff LT 0,nBackwards)
     PRINT,STRCOMPRESS(nBackwards,/REMOVE_ALL) + " elements where stop time is less than start time"
     
     junk = WHERE(( cdbTime - Alfven_start_time ) LT 0.,nBackwards)
     PRINT,STRCOMPRESS(nBackwards,/REMOVE_ALL) + " elements where time of delta_J__peak is less than start time"
     
     junk = WHERE(( Alfven_stop_time - cdbTime ) LT 0.,nBackwards)
     PRINT,STRCOMPRESS(nBackwards,/REMOVE_ALL) + " elements where stop time is less than time of delta_J__peak"

     sortStart = SORT(Alfven_start_time) & sortStop = SORT(Alfven_stop_time) & this = ARRAY_EQUAL(sortStart,sortStop)
     PRINT,"Min start time: ",TIME_TO_STR(MIN(Alfven_start_time),/MS)
     PRINT,"Max start time: ",TIME_TO_STR(MAX(Alfven_start_time),/MS)
     PRINT,"Min stop  time: ",TIME_TO_STR(MIN(Alfven_stop_time ),/MS)
     PRINT,"Max stop  time: ",TIME_TO_STR(MAX(Alfven_stop_time ),/MS)

     startDiff = Alfven_start_time[1:-1] - Alfven_start_time[0:-2]
     stopDiff  = Alfven_stop_time[1:-1]  - Alfven_stop_time[0:-2]
     cdbDiff   = cdbTime[1:-1]  - cdbTime[0:-2]

     badStart  = WHERE(startDiff LT 0.,nBadStart)
     badStop   = WHERE(stopDiff  LT 0.,nBadStop )
     badCDB   = WHERE(cdbDiff    LT 0.,nBadCDB )
     PRINT,'nBadStart: ',nBadStart
     PRINT,'nBadStop : ',nBadStop 
     PRINT,'nBadCDB  : ',nBadCDB

     IF nBadStart GT 0 THEN BEGIN
        PRINT,startDiff[badStart]
        PRINT,'Bad starts: '
        FOR k=0,nBadStart-1 DO BEGIN
           PRINT,FORMAT='(I03," : ",A27," followed by ",A27)',k, $ 
                 TIME_TO_STR(Alfven_start_time[badStart[k]],/MS), $
                 TIME_TO_STR(Alfven_start_time[badStart[k]+1],/MS)
        ENDFOR
     ENDIF

     IF nBadStop GT 0 THEN BEGIN
        PRINT,stopDiff[badStop]
        PRINT,''

        PRINT,'Bad stops: '
        FOR k=0,nBadStop-1 DO BEGIN
           PRINT,FORMAT='(I03," : ",A27," followed by ",A27)',k, $
                 TIME_TO_STR(Alfven_stop_time[badStop[k]],/MS), $
                 TIME_TO_STR(Alfven_stop_time[badStop[k]+1],/MS)
        ENDFOR
     ENDIF

     IF nBadCdb GT 0 THEN BEGIN
        PRINT,cdbDiff[badCdb]
        PRINT,''

        PRINT,'Bad cdbs: '
        FOR k=0,nBadCdb-1 DO BEGIN
           PRINT,FORMAT='(I03," : ",A27," followed by ",A27)',k, $
                 TIME_TO_STR(cdbTime[badCdb[k]],/MS), $
                 TIME_TO_STR(cdbTime[badCdb[k]+1],/MS)
        ENDFOR
     ENDIF

  ENDIF

     STOP

END
