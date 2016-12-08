;;12/08/16
PRO JOURNAL__20161208__MAKE_DELTA_ILAT_THING_TO_APPEASE_KRISTINA

  COMPILE_OPT IDL2

  LOAD_MAXIMUS_AND_CDBTIME,dbStruct,timeArr,/NO_MEMORY_LOAD, $
                           /QUIET, $
                           /DO_NOT_MAP_ANYTHING

  outDir  = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  outFile = GET_FAST_DB_STRING(dbStruct,/FOR_ALFDB) + 'delta_ilats.sav'

  PRINT,'Creating delta-ILAT file: ' + outFile
  PRINT,'Output dir              : ' + outDir

  ;;Head check
  this = WHERE(DOUBLE(dbStruct.width_time) LE 0.D,nThis) 
  IF nThis GT 0 THEN STOP
  this = WHERE(DOUBLE(dbStruct.width_x) LE 0.D,nThis) 
  IF nThis GT 0 THEN STOP

  nEvents = N_ELEMENTS(dbStruct.ilat)
  tStart = TEMPORARY(timeArr)
  tStop  = tStart + DOUBLE(dbStruct.width_time)

  IF (nEvents NE N_ELEMENTS(tStart)) OR (nEvents NE N_ELEMENTS(tStop)) THEN STOP

  CHECK_SORTED,tStart,sortStart,/QUIET
  CHECK_SORTED,tStart,sortStop,/QUIET

  IF ~(sortStart AND sortStop) THEN STOP

  ;;The array
  startstopILAT = FLTARR(2,nEvents)
  startstopMLT  = FLTARR(2,nEvents)
  width_x       = FLTARR(nEvents)
  width_angle   = FLTARR(nEvents)
  
  ;;The starts ...
  PRINT,'Getting start ILATs and width_x ...'
  GET_FA_ORBIT,tStart,/TIME_ARRAY,/ALL
  GET_DATA,'ILAT',DATA=ilat
  GET_DATA,'MLT',DATA=mlt
  GET_DATA,'fa_vel',DATA=vel
  speed = SQRT(vel.y[*,0]^2+vel.y[*,1]^2+vel.y[*,2]^2)*1000.0
  IF N_ELEMENTS(speed) NE nEvents THEN STOP

  startstopILAT[0,*] = ilat.y
  startstopMLT[0,*]  = mlt.y

  ;;The stops ...
  PRINT,'Getting stop ILATs ...'
  GET_FA_ORBIT,tStop,/TIME_ARRAY,/ALL
  GET_DATA,'ILAT',DATA=ilat
  GET_DATA,'MLT',DATA=mlt
  startstopILAT[1,*] = ilat.y
  startstopMLT[1,*] = mlt.y

  width_x[*]     = speed * FLOAT(dbStruct.width_time)
  width_angle[*] = SPHDIST(DOUBLE(startstopMLT[0,*])*15.D, $
                           DOUBLE(startstopILAT[0,*]), $
                           DOUBLE(startstopMLT[1,*])*15.D, $
                           DOUBLE(startstopILAT[1,*]), $
                           /DEGREES)

  ;;The difference
  PRINT,'The difference ...'
  width_ILAT = startstopILAT[1,*]-startstopILAT[0,*]
  width_ILAT = REFORM(width_ILAT)

  width_MLT  = startstopMLT[1,*]-startstopMLT[0,*]
  width_MLT  = REFORM(width_MLT)

  dILAT_info = {routine_name : 'JOURNAL__20161208__MAKE_DELTA_ILAT_THING_TO_APPEASE_KRISTINA', $
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
