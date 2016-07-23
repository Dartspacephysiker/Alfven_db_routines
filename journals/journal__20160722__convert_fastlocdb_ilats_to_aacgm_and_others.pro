;;07/22/16
PRO JOURNAL__20160722__CONVERT_FASTLOCDB_ILATS_TO_AACGM_AND_OTHERS

  COMPILE_OPT IDL2

  orig_routineName = 'JOURNAL__20160722__CONVERT_FASTLOCDB_ILATS_TO_AACGM_AND_OTHERS'

  R_E              = 6371.2D    ;Earth radius in km, from IGRFLIB_V2.pro

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;output
  outDir           = '/SPENCEdata/Research/database/FAST/ephemeris/'
  outFile          = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--AACGM_GEO_and_MAG_coords.sav'

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Input
  fastLocEphemFile = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--bonus_ephem.sav'

  fastLocFile      = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01.sav'
  fastLocTFile     = 'Dartdb_20160508--502-16361_despun--cdbtime--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'
  fastLocDir       = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/'

  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastLoc_times

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
  fastLoc                      = !NULL

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;feed it to GEOPACK
  nTot                         = N_ELEMENTS(fastLoc_times)
  TiltArr                      = !NULL
  fEphem_MAG_arr               = MAKE_ARRAY(3,nTot,/FLOAT)
  fEphem_GEO_arr               = MAKE_ARRAY(3,nTot,/FLOAT)
  fEphem_MAGSph_arr            = MAKE_ARRAY(3,nTot,/FLOAT)
  fEphem_GEOSph_arr            = MAKE_ARRAY(3,nTot,/FLOAT)
  fEphem_AACGMSph_arr          = MAKE_ARRAY(4,nTot,/FLOAT) ;;One more for MLT at end

  PRINT,"Feeding it to GEOPACK ..."
  FOR i=0,nTot-1 DO BEGIN
  ;; FOR i=0,100-1 DO BEGIN

     ;; GEOPACK_RECALC,YearArr[i],DOYArr[i],TILT=tempTilt,/DATE
     GEOPACK_RECALC,YearArr[i],MonthArr[i],DayArr[i],HourArr[i],MinArr[i],SecArr[i],/DATE

     e = AACGM_V2_SETDATETIME(YearArr[i],MonthArr[i],DayArr[i],HourArr[i],MinArr[i],SecArr[i])

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

     ;;update
     fEphem_MAG_arr[*,i]       = [faPosmag_x,faPosmag_y,faPosmag_z]
     fEphem_GEO_arr[*,i]       = [faPosgeo_x,faPosgeo_y,faPosgeo_z]

     ;;Lat, long, height
     fEphem_MAGSph_arr[*,i]    = [90.-mag_theta,mag_phi,mag_r-R_E] ;Convert to latitude from colatitude here
     fEphem_GEOSph_arr[*,i]    = [90.-geo_theta,geo_phi,geo_r-R_E] ;Convert to latitude from colatitude here

     ;;Get AACGM coords
     tmpAACGM                  = CNVCOORD_V2(fEphem_GEOSph_arr[*,i], /ALLOW_TRACE)
     AACGM_MLT                 = MLT_V2(tmpAACGM[1])
     fEphem_AACGMSph_arr[*,i]  = [tmpAACGM,AACGM_MLT]

     IF (i MOD 1000) EQ 0 THEN PRINT,i

  ENDFOR

  fEphem_AACGMSph_arr[2,*]     = (fEphem_AACGMSph_arr[2,*]*R_E-R_E) ;convert back to altitude above sea level

  ;;Check it out 
  ;; GEOPACK_SPHCAR(_08), r, theta, phi, x, y, z, /to_rect
  ;; GEOPACK_SPHCAR, x, y, z, r, theta, phi, /to_sphere
  ;; GEOPACK_SPHCAR,faPosgeo_x,faPosgeo_y,faPosgeo_z,geo_r,geo_theta,geo_phi,/to_sphere
  ;; GEOPACK_SPHCAR,faPosmag_x,faPosmag_y,faPosmag_z,mag_r,mag_theta,mag_phi,/to_sphere

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;make struct
  fastCoords = {TIME: fastLoc_times, $
                MAG: fEphem_MAG_arr, $
                GEO: fEphem_GEO_arr, $
                CREATED: GET_TODAY_STRING(/DO_YYYYMMDD_FMT), $
                ORIGINATING_ROUTINE:orig_routineName}

  FL_AACGM   = {ALT:fEphem_AACGMSph_arr[2,*], $
                MLT:fEphem_AACGMSph_arr[3,*], $
                LAT:fEphem_AACGMSph_arr[0,*]}

  FL_GEO     = {ALT:fEphem_GEOSph_arr[2,*], $
                LAT:fEphem_GEOSph_arr[0,*]}

  FL_MAG     = {ALT:fEphem_MAGSph_arr[2,*], $
                LAT:fEphem_MAGSph_arr[0,*]}

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Save it
  PRINT,'Saving ' + outDir + outFile + '...'
  save,FL_AACGM,FL_GEO,FL_MAG,FILENAME=outDir+outFile

  PRINT,"Did it!"
  STOP


END
