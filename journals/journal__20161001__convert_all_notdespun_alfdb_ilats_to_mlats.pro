;;2016/10/01 Ryan McGranaghan has brought to my attention that I ought to be checking out the NEXT thing
PRO JOURNAL__20161001__CONVERT_ALL_NOTDESPUN_ALFDB_ILATS_TO_MLATS

  COMPILE_OPT idl2,strictarrsubs

  orig_routineName = 'JOURNAL__20161001__CONVERT_ALL_NOTDESPUN_ALFDB_ILATS_TO_MLATS'

  R_E              = 6371.2D    ;Earth radius in km, from IGRFLIB_V2.pro

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;output
  outDir           = '/SPENCEdata/Research/database/FAST/ephemeris/'
  outFile          = 'Dartdb_20151222--500-16361_inc_lower_lats--maximus--GEO_and_MAG_coords.sav'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Input
  maxEphemFile     = 'Dartdb_20151222--500-16361_inc_lower_lats--maximus--bonus_ephemeris_info.sav'
                     
  maxFile          = 'Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--w_Lshell--correct_pFlux--maximus.sav'
  maxTFile         = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav'
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
  fEphem_MAGSph_arr     = MAKE_ARRAY(3,nTot,/FLOAT)
  fEphem_GEOSph_arr     = MAKE_ARRAY(3,nTot,/FLOAT)
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


     ;;The others stuff
     GEOPACK_SPHCAR,faPosgeo_x,faPosgeo_y,faPosgeo_z,geo_r,geo_theta,geo_phi,/TO_SPHERE,/DEGREE
     GEOPACK_SPHCAR,faPosmag_x,faPosmag_y,faPosmag_z,mag_r,mag_theta,mag_phi,/TO_SPHERE,/DEGREE

     ;;Lat, long, height
     fEphem_MAGSph_arr[*,i]    = [mag_theta,mag_phi,mag_r] 
     fEphem_GEOSph_arr[*,i]    = [geo_theta,geo_phi,geo_r] 
     ;;update
     ;; TiltArr    = [TiltArr,tempTilt]
     fEphem_MAG_arr[*,i] = [faPosmag_x,faPosmag_y,faPosmag_z]
     fEphem_GEO_arr[*,i] = [faPosgeo_x,faPosgeo_y,faPosgeo_z]

     IF (i MOD 1000) EQ 0 THEN PRINT,i
  ENDFOR


     ;;Lat, long, height
     fEphem_MAGSph_arr    = [ $
                            [90.-REFORM(fEphem_MAGSph_arr[0,*])], $
                            [REFORM(fEphem_MAGSph_arr[1,*])], $
                            [REFORM(fEphem_MAGSph_arr[2,*])-R_E] $ ;Convert to latitude from colatitude here
                            ]   

     fEphem_GEOSph_arr    = [ $
                            [90.-REFORM(fEphem_GEOSph_arr[0,*])], $
                            [REFORM(fEphem_GEOSph_arr[1,*])], $
                            [REFORM(fEphem_GEOSph_arr[2,*])-R_E] $ ;Convert to latitude from colatitude here
                            ]

     ;; fEphem_GEOSph_arr[*,i]    = [90.-geo_theta,geo_phi,geo_r-R_E] ;Convert to latitude from colatitude here


     ;; fEphem_GEOSph_arr = TRANSPOSE(fEphem_GEOSph_arr)
     ;; fEphem_MAGSph_arr = TRANSPOSE(fEphem_MAGSph_arr)


  max_GEO     = {ALT:REFORM(fEphem_GEOSph_arr[*,2]), $
                 LON:REFORM(fEphem_GEOSph_arr[*,1]), $
                 LAT:REFORM(fEphem_GEOSph_arr[*,0])}

  max_MAG     = {ALT:REFORM(fEphem_MAGSph_arr[*,2]), $
                 LON:REFORM(fEphem_MAGSph_arr[*,1]), $
                 LAT:REFORM(fEphem_MAGSph_arr[*,0])}


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
  save,maxCoords,max_GEO,max_MAG,FILENAME=outDir+outFile

  PRINT,"Did it!"
  STOP

END


