;2016/10/01
PRO JOURNAL__20161001__CONVERT_ALFDB_NOTDESPUN_ILATS_TO_AACGM

  COMPILE_OPT IDL2,STRICTARRSUBS

  orig_routineName = 'JOURNAL__20161001__CONVERT_ALFDB_NOTDESPUN_ILATS_TO_AACGM'

  R_E              = 6371.2D    ;Earth radius in km, from IGRFLIB_V2.pro

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;output
  outDir           = '/SPENCEdata/Research/database/FAST/ephemeris/'
  outFile          = 'Dartdb_20151222--500-16361_inc_lower_lats--maximus--AACGM_coords.sav'

  ;;has GEO coords
  maxBonusFile     = 'Dartdb_20151222--500-16361_inc_lower_lats--maximus--GEO_and_MAG_coords.sav'
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Input
  maxEphemFile     = 'Dartdb_20151222--500-16361_inc_lower_lats--maximus--bonus_ephemeris_info.sav'

  maxFile          = 'Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--w_Lshell--correct_pFlux--maximus.sav'
  maxTFile         = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav'
  maxDir           = '/SPENCEdata/Research/database/FAST/dartdb/saves/'

  ;;Load the stuff we need 
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,DBFILE=maxFile,DB_TFILE=maxTFile,DBDIR=maxDir,/JUST_MAXIMUS

  ;;Now the ephem file
  RESTORE,outDir+maxBonusFile

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Times in CDF epoch time
  ;; time_epoch         = UTC_TO_CDF_EPOCH(maximu)

  YearArr       = FIX(STRMID(maximus.time,0,4))
  MonthArr      = FIX(STRMID(maximus.time,5,2))
  DayArr        = FIX(STRMID(maximus.time,8,2))
  HourArr       = FIX(STRMID(maximus.time,11,2))
  MinArr        = FIX(STRMID(maximus.time,14,2))
  SecArr        = FLOAT(STRMID(maximus.time,17,6))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;feed it to GEOPACK
  nTot                         = N_ELEMENTS(maximus.time)
  maxEphem_GEOSph_arr            = TRANSPOSE([[max_GEO.LAT],[max_GEO.LON],[max_GEO.ALT]])
  maxEphem_AACGMSph_arr          = MAKE_ARRAY(4,nTot,/FLOAT) ;;One more for MLT at end

  ;;Free up dat mem
  maximus          = !NULL

  PRINT,"Feeding it to AACGM ..."
  TIC
  runCName = "AACGM Clock"
  runC     = TIC(runCName)
  FOR i=0,nTot-1 DO BEGIN
  ;; FOR i=0,100-1 DO BEGIN

     e = AACGM_V2_SETDATETIME(YearArr[i],MonthArr[i],DayArr[i],HourArr[i],MinArr[i],SecArr[i])

     ;;Get AACGM coords
     tmpAACGM                  = CNVCOORD_V2(maxEphem_GEOSph_arr[*,i], /ALLOW_TRACE)
     AACGM_MLT                 = MLT_V2(tmpAACGM[1])
     maxEphem_AACGMSph_arr[*,i]  = [tmpAACGM,AACGM_MLT]

     IF (i MOD 1000) EQ 0 THEN BEGIN
        PRINT,"N completed : " + STRCOMPRESS(i,/REMOVE_ALL)
        TOC,runC
     ENDIF

  ENDFOR
  TOC

  maxEphem_AACGMSph_arr[2,*]     = (maxEphem_AACGMSph_arr[2,*]*R_E-R_E) ;convert back to altitude above sea level

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;make struct
  ;; maxCoord = {TIME: cdbTime, $
  ;;               MAG: maxEphem_MAG_arr, $
  ;;               GEO: maxEphem_GEO_arr, $
  ;;               CREATED: GET_TODAY_STRING(/DO_YYYYMMDD_FMT), $
  ;;               ORIGINATING_ROUTINE:orig_routineName}

  max_AACGM   = {ALT:REFORM(maxEphem_AACGMSph_arr[2,*]), $
                MLT:REFORM(maxEphem_AACGMSph_arr[3,*]), $
                LAT:REFORM(maxEphem_AACGMSph_arr[0,*])}

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Save it
  PRINT,'Saving ' + outDir + outFile + '...'
  save,max_AACGM,FILENAME=outDir+outFile

  PRINT,"Did it!"
  STOP


END
