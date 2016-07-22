;;2016/07/21 Ryan McGranaghan has brought to my attention that I ought to be checking out the NEXT thing
PRO JOURNAL__20160721__CONVERT_ALL_ALFDB_ILATS_TO_MLATS

  COMPILE_OPT idl2

  orig_routineName = 'JOURNAL__20160721__CONVERT_ALL_ALFDB_ILATS_TO_MLATS'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;output
  outDir           = '/SPENCEdata/Research/database/FAST/ephemeris/'
  outFile          = 'Dartdb_20160508--502-16361_despun--maximus--GEO_and_MAG_coords.sav'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Input
  maxEphemFile     = 'Dartdb_20160508--502-16361_despun--maximus--bonus_ephemeris_info.sav'

  maxFile          = 'Dartdb_20160508--502-16361_despun--maximus--pflux_lshell--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'
  maxTFile         = 'Dartdb_20160508--502-16361_despun--cdbtime--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'
  maxDir           = '/SPENCEdata/Research/database/FAST/dartdb/saves/'

  ;;Load the stuff we need 
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,DBFILE=maxFile,DB_TFILE=maxTFile,DBDIR=maxDir

  ;;Now the ephem file
  RESTORE,maxDir+maxEphemFile
  
  ;; GEOPACK_CONV_COORD
  ;; Description: Convert between a variety of commonly used coordinate systems.
  ;; Calling Sequence: geopack_conv_coord(_08), s1, s2, s3, d1, d2, d3.
  ;; Inputs: s1, s2, s3: Coordinates in system of origin.
  ;; Outputs: d1, d2, d3: Coordinates in target system.
  ;; Keywords: FROM_GEO: Specify source in geopgraphic coordinates. 
  ;;  FROM_MAG: Specify source in geomagnetic coordinates.
  ;;  FROM_GEI: Specify source in geocentric equatorial inertial coordinates.
  ;;  FROM_SM: Specify source in solar magnetic coordinates.
  ;;  FROM_GSM: Specify source in geocentric solar magnetospheric
  ;;  coordinates.
  ;;  FROM_GSE: Specify source in geocentric solar ecliptic coordinates.
  ;;  TO_GEO: Specify destination in geopgraphic coordinates.
  ;;  TO_MAG: Specify destination in geomagnetic coordinates.
  ;;  TO_GEI: Specify destination in geocentric equatorial inertial coordinates.
  ;;  TO_SM: Specify destination in solar magnetic coordinates.
  ;;  TO_GSM: Specify destination in geocentric solar magnetospheric
  ;;  coordinates. 

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Times in CDF epoch time
  time_epoch         = UTC_TO_CDF_EPOCH(cdbTime)

  ;; GEOPACK_RECALC_08
  ;; GEOPACK_CONV_COORD_08,cuspLoc_MAG[0],cuspLoc_MAG[1],cuspLoc_MAG[2],clgeo_x,clgeo_y,clgeo_z,/FROM_MAG,/TO_GEO,EPOCH=time_epoch

  YearArr       = FIX(STRMID(maximus.time,0,4))
  MonthArr      = FIX(STRMID(maximus.time,5,2))
  DayArr        = FIX(STRMID(maximus.time,8,2))
  HourArr       = FIX(STRMID(maximus.time,11,2))
  MinArr        = FIX(STRMID(maximus.time,14,2))
  SecArr        = FLOAT(STRMID(maximus.time,17,6))

  ;;Free up dat mem
  maximus          = !NULL

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;feed it to GEOPACK
  nTot               = N_ELEMENTS(cdbTime)
  TiltArr            = !NULL
  fEphem_MAG_arr        = MAKE_ARRAY(3,nTot,/FLOAT)
  fEphem_GEO_arr        = MAKE_ARRAY(3,nTot,/FLOAT)
  FOR i=0,nTot-1 DO BEGIN
     ;; GEOPACK_RECALC,YearArr[i],DOYArr[i],TILT=tempTilt,/DATE
     GEOPACK_RECALC,YearArr[i],MonthArr[i],DayArr[i],HourArr[i],MinArr[i],SecArr[i],/DATE 

     ;;do that dance

     ;;To MAG
     GEOPACK_CONV_COORD,maxEphem.fa_pos[i,0],maxEphem.fa_pos[i,1],maxEphem.fa_pos[i,2], $
                        faPosmag_x,faPosmag_y,faPosmag_z, $
                        /FROM_GEI,/TO_MAG,EPOCH=time_epoch[i]

     ;;To GEO
     GEOPACK_CONV_COORD,maxEphem.fa_pos[i,0],maxEphem.fa_pos[i,1],maxEphem.fa_pos[i,2], $
                        faPosgeo_x,faPosgeo_y,faPosgeo_z, $
                        /FROM_GEI,/TO_GEO,EPOCH=time_epoch[i]

     ;;update
     ;; TiltArr    = [TiltArr,tempTilt]
     fEphem_MAG_arr[*,i] = [faPosmag_x,faPosmag_y,faPosmag_z]
     fEphem_GEO_arr[*,i] = [faPosgeo_x,faPosgeo_y,faPosgeo_z]
  ENDFOR

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Create format strings for a two-level axis:
  dummy              = LABEL_DATE(DATE_FORMAT=['%D-%M','%Y'])
  ;;plot it
  ;; plot               = PLOT(julDay, $
  ;;                           TiltArr, $
  ;;                           XTICKUNITS=['Time', 'Time'], $
  ;;                           XTICKFORMAT='LABEL_DATE', $
  ;;                           XSTYLE=1, $
  ;;                           XMAJOR=6, $
  ;;                           XMINOR=0)

  ;; inds               = [0:1000]
  ;; plot               = PLOT(julDay[inds], $
  ;;                           (faPos_GSM_arr[2,*])[inds], $
  ;;                           NAME='Northern cusp', $
  ;;                           COLOR='red', $
  ;;                           XTICKUNITS=['Time', 'Time'], $
  ;;                           XTICKFORMAT='LABEL_DATE', $
  ;;                           XSTYLE=1, $
  ;;                           XMAJOR=6, $
  ;;                           XMINOR=0, $
  ;;                           YTITLE = 'Z (GSM)')

  ;; plot               = PLOT(julDay[inds], $
  ;;                           (clS_GSM_arr[2,*])[inds], $
  ;;                           NAME='Southern cusp', $
  ;;                           COLOR='blue', $
  ;;                           XTICKUNITS=['Time', 'Time'], $
  ;;                           XTICKFORMAT='LABEL_DATE', $
  ;;                           /OVERPLOT, $
  ;;                           XSTYLE=1, $
  ;;                           XMAJOR=6, $
  ;;                           XMINOR=0, $
  ;;                           YTITLE = 'Z (GSM)')

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;make some stuff
  ;; tStamp             = TIMESTAMP(DAY=DayArr, $
  ;;                                MONTH=MonthArr, $
  ;;                                YEAR=YearArr) + "/00:00:00"


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;make struct
  maxCoords = {TIME: cdbTime, $
                 MAG: fEphem_MAG_arr, $
                 GEO: fEphem_GEO_arr, $
                 CREATED: GET_TODAY_STRING(/DO_YYYYMMDD_FMT), $
                 ORIGINATING_ROUTINE: orig_routineName}

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Save it
  PRINT,'Saving ' + outDir + outFile + '...'
  save,maxCoords,FILENAME=outDir+outFile

  PRINT,"Did it!"
  STOP

END

