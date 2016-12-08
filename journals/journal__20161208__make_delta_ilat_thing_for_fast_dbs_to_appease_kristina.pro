;;12/08/16
;;But now it does 'em all!
PRO JOURNAL__20161208__MAKE_DELTA_ILAT_THING_FOR_FAST_DBS_TO_APPEASE_KRISTINA

  COMPILE_OPT IDL2

  do_eSpecDB       = 0

  do_alfDB         = 0

  do_fastLocDB     = 1
  FL_for_eSpec_DBs = 0

  bad = KEYWORD_SET(do_eSpecDB) + KEYWORD_SET(do_alfDB) + KEYWORD_SET(do_fastLocDB)
  IF bad GT 2 THEN STOP

  CASE 1 OF
     KEYWORD_SET(do_alfDB): BEGIN
        PRINT,"Alfvén DB ..."
        LOAD_MAXIMUS_AND_CDBTIME,dbStruct,timeArr,/NO_MEMORY_LOAD, $
                                 /QUIET, $
                                 /DO_NOT_MAP_ANYTHING
        dbStruct_delta_t = dbStruct.width_time

        outDir  = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
        outFile = GET_FAST_DB_STRING(dbStruct,/FOR_ALFDB) + 'delta_ilats.sav'
     END
     KEYWORD_SET(do_eSpecDB): BEGIN
        PRINT,"eSpec DB ..."
        LOAD_NEWELL_ESPEC_DB,dbStruct,timeArr,dbStruct_delta_t, $
                             /DONT_MAP_TO_100KM, $
                             /LOAD_DELTA_T, $
                             /NO_MEMORY_LOAD

        outDir = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/fully_parsed/'
        outFile = GET_FAST_DB_STRING(dbStruct,/FOR_ESPEC_DB) + 'delta_ilats.sav'

     END
     ELSE: BEGIN
        PRINT,"fastLoc DB ..."
        LOAD_FASTLOC_AND_FASTLOC_TIMES,dbStruct,timeArr,dbStruct_delta_t, $
                                       /NO_MEMORY_LOAD, $
                                       FOR_ESPEC_DBS=FL_for_eSpec_DBs, $
                                       /DO_NOT_MAP_DELTA_T

        outDir  = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/'
        IF KEYWORD_SET(FL_for_eSpec_DBs) THEN BEGIN
           outDir  = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals5/'
        ENDIF

        outFile = GET_FAST_DB_STRING(dbStruct,/FOR_FASTLOC_DB) + 'delta_ilats.sav'

     END
  ENDCASE

  PRINT,'Creating delta-ILAT file: ' + outFile
  PRINT,'Output dir              : ' + outDir

  ;;Head check
  this = WHERE(DOUBLE(dbStruct_delta_t) LE 0.D,nThis) 
  IF nThis GT 0 THEN BEGIN
     IF ABS(total(dbStruct_delta_t[this])) GT 0.1 THEN STOP
  ENDIF

  nEvents = N_ELEMENTS(dbStruct.ilat)
  tStart  = TEMPORARY(timeArr)
  tStop   = tStart + DOUBLE(dbStruct_delta_t)

  IF (nEvents NE N_ELEMENTS(tStart)) OR (nEvents NE N_ELEMENTS(tStop)) THEN STOP

  CHECK_SORTED,tStart,sortStart,/QUIET
  CHECK_SORTED,tStart,sortStop,/QUIET

  IF ~(sortStart AND sortStop) THEN STOP

  ;;The array
  startstopILAT = FLTARR(2,nEvents)
  startstopMLT  = FLTARR(2,nEvents)
  width_x       = FLTARR(nEvents)
  width_angle   = FLTARR(nEvents)
  
  nIter = FLOOR(nEvents/1e6)

  FOR k=0,nIter DO BEGIN
     
     ;;Set up the indices
     tmpInds = [(k*1e6):(((k*1e6)+999999) < (nEvents-1))]

     PRINT,FORMAT='("Inds ",I0," through ",I0)',tmpInds[0],tmpInds[-1]

     ;;The starts ...
     PRINT,'Getting start ILATs and width_x ...'
     GET_FA_ORBIT,tStart[tmpInds],/TIME_ARRAY,/ALL
     GET_DATA,'ILAT',DATA=ilat
     GET_DATA,'MLT',DATA=mlt
     GET_DATA,'fa_vel',DATA=vel
     speed = SQRT(vel.y[*,0]^2+vel.y[*,1]^2+vel.y[*,2]^2)*1000.0

     startstopILAT[0,tmpInds] = ilat.y
     startstopMLT[0,tmpInds]  = mlt.y
     IF N_ELEMENTS(speed) NE N_ELEMENTS(tmpInds) THEN STOP

     ;;The stops ...
     PRINT,'Getting stop ILATs ...'
     GET_FA_ORBIT,tStop[tmpInds],/TIME_ARRAY,/ALL
     GET_DATA,'ILAT',DATA=ilat
     GET_DATA,'MLT',DATA=mlt
     startstopILAT[1,tmpInds] = ilat.y
     startstopMLT[1,tmpInds]  = mlt.y

     width_x[tmpInds]     = speed * FLOAT(dbStruct_delta_t[tmpInds])
     width_angle[tmpInds] = SPHDIST(DOUBLE(startstopMLT[0,tmpInds])*15.D,DOUBLE(startstopILAT[0,tmpInds]), $
                                    DOUBLE(startstopMLT[1,tmpInds])*15.D,DOUBLE(startstopILAT[1,tmpInds]), $
                                    /DEGREES)

  ENDFOR

  ;;The difference
  PRINT,'The difference ...'
  width_ILAT = startstopILAT[1,*]-startstopILAT[0,*]
  width_ILAT = REFORM(width_ILAT)

  width_MLT  = startstopMLT[1,*]-startstopMLT[0,*]
  width_MLT  = REFORM(width_MLT)

  dILAT_info = {routine_name : 'JOURNAL__20161208__MAKE_DELTA_ILAT_THING_FOR_FASTLOC_TO_APPEASE_KRISTINA', $
                routine_dir  : '/SPENCEdata/Research/Satellites/FAST/Alfven_db_routines/journals/', $
                dbInfo       : dbStruct.info}

  PRINT,'Done! Saving to ' + outFile + ' ...'
  SAVE,width_x, $
       width_angle, $
       width_ILAT,startstopILAT, $
       width_MLT,startstopMLT, $
       dILAT_info, $
       FILENAME=outDir+outFile

  STOP

END

