;2016/10/03
;A key idea here is that we're only going to do the ones for which the sample rate is greater than or equal to 0.01, since we've
;already converted all instances where the sample rate is lt 0.01
PRO JOURNAL__20161003__CONVERT_FASTLOCDB_ILATS_TO_AACGM_AND_OTHERS__INC_32HZ

  COMPILE_OPT IDL2

  orig_routineName = 'JOURNAL__20161003__CONVERT_FASTLOCDB_ILATS_TO_AACGM_AND_OTHERS__INC_32HZ'

  R_E              = 6371.2D    ;Earth radius in km, from IGRFLIB_V2.pro

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;output
  outDir           = '/SPENCEdata/Research/database/FAST/ephemeris/'
  ;; outFile          = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--AACGM_GEO_and_MAG_coords.sav'
  outFile          = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--AACGM_GEO_and_MAG_coords.sav'

  ;;has GEO coords
  FLBonusFile        = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--GEO_and_MAG_coords.sav'
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Input
  fastLocEphemFile = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--bonus_ephem.sav'

  fastLocFile      = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05.sav'
  fastLocTFile     = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--times.sav'
  fastLoc128tfile  = 'fastLoc_intervals4--500-16361--below_aur_oval--20160213--times--noDupes--sample_freq_le_0.01.sav'
  fastLocDir       = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/'


  RESTORE,fastLocDir+fastLoc128tfile
  fl128t = TEMPORARY(fastLoc_times)

  ;;Load the stuff we need 
  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastLoc_times, $
                                 DBFILE=fastLocFile, $
                                 DB_TFILE=fastLocTFile, $
                                 DBDIR=fastLocDir
                                 
  Hz128_i = VALUE_CLOSEST2(fastloc_times,fl128t)

  IF ~ARRAY_EQUAL(fastloc_times[Hz128_i],fl128t) THEN BEGIN
     PRINT,"These don't match, but they definitely should, children."
     STOP
  ENDIF ELSE BEGIN
     PRINT,"Just getting the inds that have a sample rate greater than 128 Hz .."
  ENDELSE

  fl128t           = !NULL

  convInds         = CGSETDIFFERENCE(LINDGEN(N_ELEMENTS(fastLoc_times)),Hz128_i,COUNT=nTot)

  ;;Now the GEO file
  RESTORE,outDir+FLBonusFile

  ;;Now convert everyone
  fastLoc = { $
            orbit     : fastLoc.orbit[convInds], $   
            time      : fastLoc.time[convInds], $    
            alt       : fastLoc.alt[convInds], $     
            mlt       : fastLoc.mlt[convInds], $     
            ilat      : fastLoc.ilat[convInds], $    
            sample_t  : fastLoc.sample_t[convInds]}
            
  fastLoc_times = fastLoc_times[convInds]

  YearArr       = FIX(STRMID(fastLoc.time,0,4))
  MonthArr      = FIX(STRMID(fastLoc.time,5,2))
  DayArr        = FIX(STRMID(fastLoc.time,8,2))
  HourArr       = FIX(STRMID(fastLoc.time,11,2))
  MinArr        = FIX(STRMID(fastLoc.time,14,2))
  SecArr        = FLOAT(STRMID(fastLoc.time,17,6))

  FL_GEO        = {LAT:FL_GEO.LAT[convInds], $
                   LON:FL_GEO.LON[convInds], $
                   ALT:FL_GEO.ALT[convInds]}

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;feed it to GEOPACK
  fEphem_GEOSph_arr            = TRANSPOSE([[FL_GEO.LAT],[FL_GEO.LON],[FL_GEO.ALT]])
  fEphem_AACGMSph_arr          = MAKE_ARRAY(4,nTot,/FLOAT) ;;One more for MLT at end

  ;;Free up dat mem
  fastLoc                      = !NULL
  fastLoc_times                = !NULL
  FL_GEO                       = !NULL
  FL_MAG                       = !NULL

  PRINT,"Feeding it to AACGM_v2 routines ..."
  
  runCName = "AACGM Clock"
  runC     = TIC(runCName)
  TIC
  FOR i=0,nTot-1 DO BEGIN

     e = AACGM_V2_SETDATETIME(YearArr[i],MonthArr[i],DayArr[i],HourArr[i],MinArr[i],SecArr[i])

     ;;Get AACGM coords
     tmpAACGM                  = CNVCOORD_V2(fEphem_GEOSph_arr[*,i], /ALLOW_TRACE)
     AACGM_MLT                 = MLT_V2(tmpAACGM[1])
     fEphem_AACGMSph_arr[*,i]  = [tmpAACGM,AACGM_MLT]

     IF (i MOD 1000) EQ 0 THEN BEGIN
        PRINT,"N completed : " + STRCOMPRESS(i,/REMOVE_ALL)
        TOC,runC

        IF (i MOD 100000) THEN BEGIN
           PRINT,'Saving tempfile ...'
           SAVE,fEphem_AACGMSph_arr,FILENAME=outDir+outFile+'--'+STRCOMPRESS(i,/REMOVE_ALL)
        ENDIF
     ENDIF

  ENDFOR
  TOC

  fEphem_AACGMSph_arr[2,*]     = (fEphem_AACGMSph_arr[2,*]*R_E-R_E) ;convert back to altitude above sea level

  ;;Check it out 
  ;; GEOPACK_SPHCAR(_08), r, theta, phi, x, y, z, /to_rect
  ;; GEOPACK_SPHCAR, x, y, z, r, theta, phi, /to_sphere
  ;; GEOPACK_SPHCAR,faPosgeo_x,faPosgeo_y,faPosgeo_z,geo_r,geo_theta,geo_phi,/to_sphere
  ;; GEOPACK_SPHCAR,faPosmag_x,faPosmag_y,faPosmag_z,mag_r,mag_theta,mag_phi,/to_sphere

  FL_AACGM   = {ALT:fEphem_AACGMSph_arr[2,*], $
                MLT:fEphem_AACGMSph_arr[3,*], $
                LAT:fEphem_AACGMSph_arr[0,*]}

  ;; FL_GEO     = {ALT:fEphem_GEOSph_arr[2,*], $
  ;;               LAT:fEphem_GEOSph_arr[0,*]}

  ;; FL_MAG     = {ALT:fEphem_MAGSph_arr[2,*], $
  ;;               LAT:fEphem_MAGSph_arr[0,*]}

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Save it
  PRINT,'Saving ' + outDir + outFile + '...'
  ;; SAVE,FL_AACGM,FL_GEO,FL_MAG,FILENAME=outDir+outFile
  SAVE,FL_AACGM,convInds,FILENAME=outDir+outFile

  PRINT,"Did it!"
  STOP


END

