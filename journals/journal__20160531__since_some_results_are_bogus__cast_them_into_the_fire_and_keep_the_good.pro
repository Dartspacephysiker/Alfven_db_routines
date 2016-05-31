;;05/31/16
PRO JOURNAL__20160531__SINCE_SOME_RESULTS_ARE_BOGUS__CAST_THEM_INTO_THE_FIRE_AND_KEEP_THE_GOOD

  COMPILE_OPT IDL2

  inDir                     = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'
  winnowedFile              = 'alf_eSpec_20151222_db--TIME_SERIES_AND_ORBITS_ALIGNED_WITH_DB--WINNOWED--Orbs_500-14000--20160531.sav'
  ;;THE MASTER IN FILE
  theMasterInFile           = 'alf_eSpec_20151222_db--TIME_SERIES_AND_ORBITS_ALIGNED_WITH_DB--Orbs_500-14000--20160531.sav'

  RESTORE,inDir+theMasterInFile

  great_ii                  = WHERE(ABS(closest_diffs_final) LE 5,nGreat)
  
  alf_i__good_eSpec         = alf_i_final[great_ii]
  good_eSpec_i              = closest_eSpec_i_final[great_ii]
  good_diffs                = closest_diffs_final[great_ii]

  PRINT,'Saving winnowed stuff to ' + winnowedFile + '...'
  SAVE,alf_i__good_eSpec,good_eSpec_i,good_diffs,FILENAME=inDir+winnowedFile
  
END
