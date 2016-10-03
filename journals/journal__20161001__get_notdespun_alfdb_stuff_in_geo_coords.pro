PRO JOURNAL__20161001__GET_NOTDESPUN_ALFDB_STUFF_IN_GEO_COORDS

  COMPILE_OPT idl2

  maxFile          = 'Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--w_Lshell--correct_pFlux--maximus.sav'
  maxTFile         = 'Dartdb_20150814--500-16361_inc_lower_lats--burst_1000-16361--cdbtime.sav'
  maxDir           = '/SPENCEdata/Research/database/FAST/dartdb/saves/'

  outFile          = 'Dartdb_20151222--500-16361_inc_lower_lats--maximus--bonus_ephemeris_info.sav'

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
