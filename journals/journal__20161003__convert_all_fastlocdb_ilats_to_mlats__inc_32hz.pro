;;2016/07/21 Ryan McGranaghan has brought to my attention that I ought to be checking out the NEXT thing
PRO JOURNAL__20161003__CONVERT_ALL_FASTLOCDB_ILATS_TO_MLATS__INC_32HZ

  COMPILE_OPT idl2,strictarrsubs

  orig_routineName = 'JOURNAL__20160721__CONVERT_ALL_FASTLOCDB_ILATS_TO_MLATS'

  R_E              = 6371.2D    ;Earth radius in km, from IGRFLIB_V2.pro

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;output
  outDir           = '/SPENCEdata/Research/database/FAST/ephemeris/'
  outFile          = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--GEO_and_MAG_coords.sav'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Input
  fastLocEphemFile = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--bonus_ephem.sav'

  fastLocFile      = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05.sav'
  fastLocTFile     = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--times.sav'
  fastLocDir       = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/'

  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastLoc_times, $
                                 DBFILE=fastLocFile, $
                                 DB_TFILE=fastLocTFile, $
                                 DBDIR=fastLocDir
                                 

  ;;Load the stuff we need 
  RESTORE,fastLocDir+fastLocEphemFile
  
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
  time_epoch         = UTC_TO_CDF_EPOCH(fastLoc_times)

  YearArr       = FIX(STRMID(fastLoc.time,0,4))
  MonthArr      = FIX(STRMID(fastLoc.time,5,2))
  DayArr        = FIX(STRMID(fastLoc.time,8,2))
  HourArr       = FIX(STRMID(fastLoc.time,11,2))
  MinArr        = FIX(STRMID(fastLoc.time,14,2))
  SecArr        = FLOAT(STRMID(fastLoc.time,17,6))

  ;;Free up dat mem
  fastLoc          = !NULL

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;feed it to GEOPACK
  nTot             = N_ELEMENTS(fastLoc_times)

  fEphem_MAG_arr   = MAKE_ARRAY(3,nTot,/FLOAT)
  fEphem_GEO_arr   = MAKE_ARRAY(3,nTot,/FLOAT)
  fEphem_MAGSph_arr     = MAKE_ARRAY(3,nTot,/FLOAT)
  fEphem_GEOSph_arr     = MAKE_ARRAY(3,nTot,/FLOAT)

  PRINT,"Feeding it to GEOPACK ..."
  FOR i=0,nTot-1 DO BEGIN

     GEOPACK_RECALC,YearArr[i],MonthArr[i],DayArr[i],HourArr[i],MinArr[i],SecArr[i],/DATE

     ;;do that dance
     ;;To MAG
     GEOPACK_CONV_COORD,fastLocEphem.fa_pos[i,0],fastLocEphem.fa_pos[i,1],fastLocEphem.fa_pos[i,2], $
                        faPosmag_x,faPosmag_y,faPosmag_z, $
                        /FROM_GEI,/TO_MAG,EPOCH=time_epoch[i]
     ;;To GEO
     GEOPACK_CONV_COORD,fastLocEphem.fa_pos[i,0],fastLocEphem.fa_pos[i,1],fastLocEphem.fa_pos[i,2], $
                        faPosgeo_x,faPosgeo_y,faPosgeo_z, $
                        /FROM_GEI,/TO_GEO,EPOCH=time_epoch[i]

     GEOPACK_SPHCAR,faPosgeo_x,faPosgeo_y,faPosgeo_z,geo_r,geo_theta,geo_phi,/TO_SPHERE,/DEGREE
     GEOPACK_SPHCAR,faPosmag_x,faPosmag_y,faPosmag_z,mag_r,mag_theta,mag_phi,/TO_SPHERE,/DEGREE

     ;;Lat, long, height
     fEphem_MAGSph_arr[*,i]    = [mag_theta,mag_phi,mag_r] 
     fEphem_GEOSph_arr[*,i]    = [geo_theta,geo_phi,geo_r] 

     ;;update
     ;; TiltArr    = [TiltArr,tempTilt]
     fEphem_MAG_arr[*,i] = [faPosmag_x,faPosmag_y,faPosmag_z]
     fEphem_GEO_arr[*,i] = [faPosgeo_x,faPosgeo_y,faPosgeo_z]

     ;;update
     fEphem_MAG_arr[*,i] = [faPosmag_x,faPosmag_y,faPosmag_z]
     fEphem_GEO_arr[*,i] = [faPosgeo_x,faPosgeo_y,faPosgeo_z]
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

  FL_GEO     = {ALT:fEphem_GEOSph_arr[*,2], $
                 LON:fEphem_GEOSph_arr[*,1], $
                 LAT:fEphem_GEOSph_arr[*,0]}

  FL_MAG     = {ALT:fEphem_MAGSph_arr[*,2], $
                 LON:fEphem_MAGSph_arr[*,1], $
                 LAT:fEphem_MAGSph_arr[*,0]}

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;make struct
  fastCoords = {TIME: fastLoc_times, $
                 MAG: fEphem_MAG_arr, $
                 GEO: fEphem_GEO_arr, $
                 CREATED: GET_TODAY_STRING(/DO_YYYYMMDD_FMT), $
                 ORIGINATING_ROUTINE:orig_routineName}

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Save it
  PRINT,'Saving ' + outDir + outFile + '...'
  save,fastCoords,FL_GEO,FL_MAG,FILENAME=outDir+outFile

  PRINT,"Did it!"
  STOP

END


