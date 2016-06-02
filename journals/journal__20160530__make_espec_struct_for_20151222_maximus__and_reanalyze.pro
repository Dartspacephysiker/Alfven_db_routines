;;05/26/16
PRO JOURNAL__20160530__MAKE_ESPEC_STRUCT_FOR_20151222_MAXIMUS__AND_REANALYZE

  PRINT,"You know this journal is junk aside from producing missing orb output, right? See the journals from 20160531, 20160602"
  STOP

  recreate_database       = 0
  parse_eSpecs            = 0

  only_missing_output     = 1

  firstOrb                = 500
  lastOrb                 = 16361

  outMissingOrbsFile      = STRING(FORMAT='("alf_eSpec_20151222_db--MISSING_ORBS--Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                   firstOrb, $
                                   lastOrb, $
                                   GET_TODAY_STRING(/DO_YYYYMMDD_FMT))

  outDir                  = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'
  outunParsedF            = STRING(FORMAT='("alf_eSpec_20151222_db--UNPARSED--Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                   firstOrb, $
                                   lastOrb, $
                                   GET_TODAY_STRING(/DO_YYYYMMDD_FMT))
  outParsedF              = STRING(FORMAT='("alf_eSpec_20151222_db--PARSED--Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                   firstOrb, $
                                   lastOrb, $
                                   GET_TODAY_STRING(/DO_YYYYMMDD_FMT))

  ;;Get cdbTime and the DB directory
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,DBDir=dbDir

  orbFile                 = 'Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--orbits.sav'
  RESTORE,dbDir + orbFile

  IF KEYWORD_SET(recreate_database) OR KEYWORD_SET(only_missing_output) THEN BEGIN
     alf_eSpecs_unparsed  = MAKE_ESPEC_DB_FOR_ALFVEN_DB_V2(cdbTime,alfven_orbList,firstOrb,lastOrb, $
                                                           JE_OUT=je, $
                                                           JEE_OUT=jee, $
                                                           ;; /VERY_SLOW_DIAGNOSTIC, $
                                                           OUT_DIFFS=eSpec_magc_diffs, $
                                                           OUT_MISSING_EVENTS=eSpec_missing_events, $
                                                           ONLY_PRODUCE_MISSING_ORB_OUTPUT=only_missing_output, $
                                                           OUT_MISSING_ORB_ARR=missingOrbArr)
     IF ~KEYWORD_SET(only_missing_output) THEN BEGIN
        SAVE,alf_eSpecs_unparsed,je,jee,eSpec_magc_diffs,eSpec_missing_events,FILENAME=outDir+outunParsedF
     ENDIF ELSE BEGIN
        PRINT,'Saving missing orb data to ' + outMissingOrbsFile
        SAVE,missingOrbArr,FILENAME=outDir+outMissingOrbsFile
     ENDELSE
  ENDIF ELSE BEGIN
     RESTORE,outDir+outunParsedF
  ENDELSE

  IF KEYWORD_SET(parse_eSpecs) THEN BEGIN
     ;;Now give everything a second run-through
     IDENTIFY_DIFF_EFLUXES_AND_CREATE_STRUCT,alf_eSpecs_unparsed,Jee,Je, $
                                             maximus.mlt,maximus.ilat, $
                                             alf_eSpecs_parsed, $
                                             CHECK_FOR_DUDS=check_for_duds, $
                                             SC_POT=maximus.sc_pot, $
                                             ;; IND_SC_POT=ind_sc_pot, $
                                             QUIET=quiet, $
                                             /BATCH_MODE, $
                                             ;; ORBSTR=orbStr, $
                                             /PRODUCE_FAILCODE_OUTPUT, $
                                             OUT_FAILCODES=failCodes, $
                                             ERRORLOGFILE=errorLogFile
     SAVE,alf_eSpecs_parsed,failCodes,FILENAME=outDir+outParsedF
  ENDIF

  PRINT,'DONE!'
END
