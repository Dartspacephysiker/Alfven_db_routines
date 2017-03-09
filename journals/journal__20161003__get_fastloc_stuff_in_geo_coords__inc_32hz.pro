PRO JOURNAL__20161003__GET_FASTLOC_STUFF_IN_GEO_COORDS__INC_32HZ

  COMPILE_OPT idl2,strictarrsubs

  fastLocFile      = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05.sav'
  fastLocTFile     = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--times.sav'
  fastLocDir       = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/'

  outFile          = 'fastLoc_intervals4--500-16361--below_aur_oval--20160505--noDupes--samp_t_le_0.05--bonus_ephem.sav'

  PRINT,"Working it out with FASTLOC"

  ;;Load the stuff we need 
  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastLoc_times, $
                                 DBFILE=fastLocFile, $
                                 DB_TFILE=fastLocTFile, $
                                 DBDIR=fastLocDir
                                 
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

