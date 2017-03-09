PRO JOURNAL__20160721__GET_FASTLOC_STUFF_IN_GEO_COORDS

  COMPILE_OPT idl2,strictarrsubs

  fastLocFile          = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01.sav'
  fastLocTFile         = 'Dartdb_20160508--502-16361_despun--cdbtime--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'
  fastLocDir           = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/'

  outFile              = 'fastLoc_intervals4--500-16361--trimmed--sample_freq_le_0.01--bonus_ephem.sav'

  PRINT,"Working it out with FASTLOC"

  ;;Load the stuff we need 
  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastLoc_times

  GET_FA_ORBIT,fastLoc_times,/TIME_ARRAY,/ALL,/DEFINITIVE

  GET_DATA,'ORBIT',DATA=orbit
  GET_DATA,'fa_pos',DATA=fa_pos
  GET_DATA,'ALT',DATA=alt
  GET_DATA,'ILAT',DATA=ilat
  GET_DATA,'ILNG',DATA=ilng
  GET_DATA,'LAT',data=lat
  GET_DATA,'LNG',data=lng
  GET_DATA,'fa_vel',DATA=fa_vel

  fastLocEphem   = {orbit:orbit.y, $
                    fa_pos:fa_pos.y, $
                    alt:alt.y, $
                    lat:lat.y, $
                    lng:lng.y, $
                    fa_vel:fa_vel.y, $
                    POS_AND_VEL_COORDS:'GEI (per GET_FA_ORBIT)'}

  PRINT,"Saving bonus ephem to " + outFile + " ... " 
  SAVE,fastLocEphem,FILENAME=fastLocDir+outFile

END
