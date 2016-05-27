;;05/26/16
PRO JOURNAL__20160527__MAKE_ESPEC_STRUCT_FOR_20160508_DESPUN_MAXIMUS

  outDir      = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'
  outFile     = 'alf_eSpec_20160508_despun_db--' + GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '.sav'

  ;;Get cdbTime and the DB directory
  LOAD_MAXIMUS_AND_CDBTIME,!NULL,cdbTime,/JUST_CDBTIME,/DO_DESPUNDB

  orbFile     = 'Dartdb_20160508--2500-3599_plus_bonus__and_10220-16361_despun--orbits.sav'
  RESTORE,dbDir + orbFile

  alf_eSpecs  = MAKE_ESPEC_DB_FOR_ALFVEN_DB(cdbTime,alfven_orbList, $
                                             OUT_DIFFS=eSpec_magc_diffs, $
                                             OUT_MISSING=eSpec_missing_events)

  SAVE,alf_eSpecs,eSpec_magc_diffs,eSpec_missing_events,FILENAME=outDir+outFile

END
