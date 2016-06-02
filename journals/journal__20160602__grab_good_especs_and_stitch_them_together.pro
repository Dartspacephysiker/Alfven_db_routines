;;06/02/16
PRO JOURNAL__20160602__GRAB_GOOD_ESPECS_AND_STITCH_THEM_TOGETHER

  COMPILE_OPT IDL2

  dbDate                    = '20151222'

  firstOrb                  = 500
  lastOrb                   = 16361
  todayStr                  = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  inDir                     = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'

  eSpecUnparsedFile         = STRING(FORMAT='("alf_eSpec_",I0,"_db--ESPECS_ALIGNED_UNPARSED--Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                     dbDate, $
                                     firstOrb, $
                                     lastOrb, $
                                     todayStr)

  ;;Here are the variables you're getting from this file, with "good" being a time difference of less than 5 seconds
  ;;  alf_i__good_eSpec,good_eSpec_i,good_eSpec_t,good_diffs,good_orbs,good_orbs_unique
  ;;  alf_i__bad_eSpec,bad_eSpec_i,bad_eSpec_t,bad_diffs,bad_orbs,bad_orbs_unique
  winnowedFile              = STRING(FORMAT='("alf_eSpec_",I0,"_db--TIME_SERIES_AND_ORBITS_ALIGNED_WITH_DB--WINNOWED--Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                     dbDate, $
                                     firstOrb, $
                                     lastOrb, $
                                     todayStr)

  eSpecs                    = MAKE_ESPEC_DB_FOR_ALFVEN_DB_V3(winnowedFile,inDir, $
                                                             firstOrb,lastOrb, $
                                                             JE_OUT=je_out, $
                                                             JEE_OUT=jee_out)

  ;;Put the important stuff together
  RESTORE,inDir+winnowedFile
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbtime,DBDIR=dbDir

  alf_sc_pot = maximus.sc_pot[alf_i__good_eSpec]
  alf_mlt    = maximus.mlt[alf_i__good_eSpec]
  alf_ilat   = maximus.ilat[alf_i__good_eSpec]

  SAVE,eSpecs,je_out,jee_out,alf_sc_pot,alf_mlt,alf_ilat,FILENAME=inDir+eSpecUnparsedFile
  
END
