;;05/26/16
PRO JOURNAL__20160526__MAKE_ESPEC_STRUCT_FOR_20151222_MAXIMUS

  ;;Get cdbTime and the DB directory
  LOAD_MAXIMUS_AND_CDBTIME,!NULL,cdbTime,/JUST_CDBTIME,DBDir=dbDir

  orbFile      = 'Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--orbits.sav'
  RESTORE,dbDir + orbFile

  alf_eSpecs   = MAKE_ESPEC_DB_FOR_ALFVEN_DB(cdbTime,alfven_orbList,OUT_DIFFS=eSpec_magc_diffs)

  SAVE,alf_eSpecs,eSpec_magc_diffs,FILENAME=dbDir+'../electron_Newell_db/alf_eSpec_20160522_db--' + GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '.sav'

END
