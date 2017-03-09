;;10/05/16
PRO JOURNAL__20161005__INSERT_32HZ_STUFF_INTO_FASTLOC

  COMPILE_OPT IDL2,STRICTARRSUBS

  balderdash = '/SPENCEdata/Research/database/FAST/ephemeris/'
  geomagfile = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--GEO_and_MAG_coords.sav'
  AACGMfile  = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--AACGM_GEO_and_MAG_coords.sav'
  AACGM128file = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--AACGM_coords.sav'

  DefDBDir   = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/'

  ;;Out files
  outDir       = defDBDir + 'alternate_coords/'
  outAACGMFile = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--AACGM_coords.sav'
  outGEOFile   = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--GEO_coords.sav'  
  outMAGFile   = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--MAG_coords.sav'  
  
  ;;trickiness for AACGM
  tFile1       = 'fastLoc_intervals4--500-16361--below_aur_oval--20160213--times--noDupes--sample_freq_le_0.01.sav'
  tFile32Hz    = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--times.sav'


  ;;Trickier first
  IF ~FILE_TEST(outDir+outAACGMFile) THEN BEGIN

     RESTORE,defDBDir+tFile1
     RESTORE,outDir+AACGM128file
     fl128t = TEMPORARY(fastLoc_times)
     AACGM128 = TEMPORARY(FL_AACGM)

     RESTORE,defDBDir+tFile32Hz
     
     Hz128_i = VALUE_CLOSEST2(fastloc_times,fl128t)

     IF ~ARRAY_EQUAL(fastloc_times[Hz128_i],fl128t) THEN BEGIN
        PRINT,"These don't match, but they definitely should, children."
        STOP
     ENDIF ELSE BEGIN
        PRINT,"Just getting the inds that have a sample rate greater than 128 Hz .."
     ENDELSE

     RESTORE,balderdash+AACGMfile

     IF (N_ELEMENTS(fastLoc_times) - N_ELEMENTS(Hz128_i)) NE N_ELEMENTS(FL_AACGM.alt) THEN BEGIN
        PRINT,"These aren't going to match. Something's wrong with one of your sets of inds."
     ENDIF ELSE BEGIN
        PRINT,'Good, these match! We should be able to sandwich together the 128-Hz stuff with the 32-Hz stuff'
     ENDELSE

     ;; FL_AACGM = {alt:REFORM(FL_AACGM.alt), $
     ;;             mlt:REFORM(FL_AACGM.mlt), $
     ;;             lat:REFORM(FL_AACGM.lat)}
     FL_AACGM = {alt:[AACGM128.alt,REFORM(FL_AACGM.alt)], $
                 mlt:[AACGM128.mlt,REFORM(FL_AACGM.mlt)], $
                 lat:[AACGM128.lat,REFORM(FL_AACGM.lat)]}

     IF ( N_ELEMENTS(fastloc_times) NE N_ELEMENTS(FL_AACGM.alt) ) THEN BEGIN
        ;; IF (N_ELEMENTS(fastLoc_times) - N_ELEMENTS(Hz128_i)) NE N_ELEMENTS(FL_AACGM.alt) THEN BEGIN
        PRINT,"These aren't going to match. Something's wrong with one of your sets of inds."
     ENDIF ELSE BEGIN
        PRINT,'Good, these match! We should be able to sandwich together the 128-Hz stuff with the 32-Hz stuff'
     ENDELSE

     convInds         = CGSETDIFFERENCE(LINDGEN(N_ELEMENTS(fastLoc_times)),Hz128_i,COUNT=nTot)

     sort_i           = SORT([Hz128_i,convInds])
     
     IF ~ARRAY_EQUAL(fastLoc_times,([fastLoc_times[Hz128_i],fastLoc_times[convInds]])[sort_i]) THEN BEGIN
        PRINT,'Hmmm...'
        STOP
     ENDIF ELSE BEGIN
        PRINT,"Doing it, Chieftain."
     ENDELSE

     FL_AACGM         = {alt:FL_AACGM.alt[sort_i], $
                         mlt:FL_AACGM.mlt[sort_i], $
                         lat:FL_AACGM.lat[sort_i]}

     PRINT,'Saving AACGM file ...'
     SAVE,FL_AACGM,FILENAME=outDir+outAACGMFile

  ENDIF


  ;;GEO and MAG last
  RESTORE,balderdash+geomagfile

  IF ~FILE_TEST(outDir+outGEOFile) THEN BEGIN
     PRINT,"Saving GEO file ..."
     SAVE,FL_GEO,FILENAME=outDir+outGEOFile
  ENDIF

  IF ~FILE_TEST(outDir+outMAGFile) THEN BEGIN
     PRINT,"Saving MAG file ..."
     SAVE,FL_MAG,FILENAME=outDir+outMAGFile
  ENDIF


END
