;;07/22/16
PRO JOURNAL__20160723__CONVERT_ALFDB_ILATS_TO_AACGM

  COMPILE_OPT IDL2

  orig_routineName = 'JOURNAL__20160723__CONVERT_ALFDB_ILATS_TO_AACGM'

  R_E              = 6371.2D    ;Earth radius in km, from IGRFLIB_V2.pro

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;output
  outDir           = '/SPENCEdata/Research/database/FAST/ephemeris/'
  outFile          = 'Dartdb_20160508--502-16361_despun--maximus--AACGM_coords.sav'

  ;;has GEO coords
  maxBonusFile        = 'Dartdb_20160508--502-16361_despun--maximus--GEO_and_MAG_coords.sav'
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Input
  maxEphemFile     = 'Dartdb_20160508--502-16361_despun--maximus--bonus_ephemeris_info.sav'

  maxFile          = 'Dartdb_20160508--502-16361_despun--maximus--pflux_lshell--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'
  maxTFile         = 'Dartdb_20160508--502-16361_despun--cdbtime--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'
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
  FOR i=0,nTot-1 DO BEGIN
  ;; FOR i=0,100-1 DO BEGIN

     e = AACGM_V2_SETDATETIME(YearArr[i],MonthArr[i],DayArr[i],HourArr[i],MinArr[i],SecArr[i])

     ;;Get AACGM coords
     tmpAACGM                  = CNVCOORD_V2(maxEphem_GEOSph_arr[*,i], /ALLOW_TRACE)
     AACGM_MLT                 = MLT_V2(tmpAACGM[1])
     maxEphem_AACGMSph_arr[*,i]  = [tmpAACGM,AACGM_MLT]

     IF (i MOD 1000) EQ 0 THEN PRINT,i

  ENDFOR

  maxEphem_AACGMSph_arr[2,*]     = (maxEphem_AACGMSph_arr[2,*]*R_E-R_E) ;convert back to altitude above sea level

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;make struct
  ;; maxCoord = {TIME: cdbTime, $
  ;;               MAG: maxEphem_MAG_arr, $
  ;;               GEO: maxEphem_GEO_arr, $
  ;;               CREATED: GET_TODAY_STRING(/DO_YYYYMMDD_FMT), $
  ;;               ORIGINATING_ROUTINE:orig_routineName}

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
