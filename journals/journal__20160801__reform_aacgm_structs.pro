;;07/31/16
PRO JOURNAL__20160801__REFORM_AACGM_STRUCTS

  COMPILE_OPT IDL2,STRICTARRSUBS

  outDir            = '/SPENCEdata/Research/database/FAST/ephemeris/'

  max_inFile        = 'Dartdb_20160508--502-16361_despun--maximus--AACGM_coords.sav_unreformed'
  FL_inFile         = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--AACGM_GEO_and_MAG_coords.sav_unreformed'

  max_outFile       = 'Dartdb_20160508--502-16361_despun--maximus--AACGM_coords.sav'
  FL_outFile        = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--AACGM_GEO_and_MAG_coords.sav'

  RESTORE,outDir+max_inFile
  RESTORE,outDir+FL_inFile

  FL_AACGM   = {ALT:REFORM(FL_aacgm.alt), $
                MLT:REFORM(FL_aacgm.mlt), $
                LAT:REFORM(FL_aacgm.lat)}

  FL_GEO     = {ALT:REFORM(FL_GEO.alt), $
                LAT:REFORM(FL_GEO.lat)}

  FL_MAG     = {ALT:REFORM(FL_MAG.alt), $
                LAT:REFORM(FL_MAG.lat)}


  MAX_AACGM   = {ALT:REFORM(max_aacgm.alt), $
                MLT:REFORM(max_aacgm.mlt), $
                LAT:REFORM(max_aacgm.lat)}

  STOP

  PRINT,'Saving reformed files ...'
  SAVE,FL_aacgm,FL_geo,FL_mag,FILENAME=outDir+FL_outFile
  SAVE,max_aacgm,FILENAME=outDir+max_outFile


END
