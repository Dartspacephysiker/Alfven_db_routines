PRO JOURNAL__20160721__GET_ALFDB_STUFF_IN_GEO_COORDS

  COMPILE_OPT idl2,strictarrsubs

  maxFile          = 'Dartdb_20160508--502-16361_despun--maximus--pflux_lshell--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'
  maxTFile         = 'Dartdb_20160508--502-16361_despun--cdbtime--noDupes--refreshed_2500-3599_plus_bonus_and_10210-16361.sav'
  maxDir           = '/SPENCEdata/Research/database/FAST/dartdb/saves/'

  outFile          = 'Dartdb_20160508--502-16361_despun--maximus--bonus_ephemeris_info.sav'

  ;;Load the stuff we need 
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,/JUST_CDBTIME,DB_TFILE=maxTFile,DBDIR=maxDir

  GET_FA_ORBIT,cdbTime,/TIME_ARRAY,/ALL,/DEFINITIVE

  GET_DATA,'ORBIT',DATA=orbit
  GET_DATA,'fa_pos',DATA=fa_pos
  GET_DATA,'ALT',DATA=alt
  GET_DATA,'ILAT',DATA=ilat
  GET_DATA,'ILNG',DATA=ilng
  GET_DATA,'LAT',DATA=lat
  GET_DATA,'LNG',DATA=lng
  GET_DATA,'fa_vel',DATA=fa_vel

  maxEphem   = {orbit:orbit.y, $
                fa_pos:fa_pos.y, $
                alt:alt.y, $
                lat:lat.y, $
                lng:lng.y, $
                fa_vel:fa_vel.y, $
                POS_AND_VEL_COORDS:'GEI (per GET_FA_ORBIT)'}

  PRINT,"Saving bonus ephem to " + outFile + " ... " 
  SAVE,maxEphem,FILENAME=maxDir+outFile

END