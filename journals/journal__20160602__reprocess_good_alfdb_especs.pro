;;06/02/16
PRO JOURNAL__20160602__REPROCESS_GOOD_ALFDB_ESPECS

  COMPILE_OPT IDL2,STRICTARRSUBS

  quiet                     = 1

  despun                    = 1

  date_for_inputs           = '20160609'

  IF KEYWORD_SET(despun) THEN BEGIN
     despunStr              = '--despun'
     dbDate                 = '20160508'
     firstDBOrb             = 502
     orbFile                = 'Dartdb_20160508_despun--502-16361_despun--orbits.sav'
  ENDIF ELSE BEGIN
     despunStr              = ''
     dbDate                 = '20151222'
     firstDBOrb             = 500
     orbFile                = 'Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--orbits.sav'
  ENDELSE
  firstOrb                  = 500
  lastOrb                   = 16361

  newFileDateStr            = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  inDir                     = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'

  ;;Use this file to figure out which Alfven DB inds we have
  winnowedFile              = STRING(FORMAT='("alf_eSpec_",A0,"_db",A0,"--TIME_SERIES_AND_ORBITS_ALIGNED_WITH_DB--WINNOWED--Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                     dbDate, $
                                     despunStr, $
                                     firstDBOrb, $
                                     lastOrb, $
                                     date_for_inputs)
  
  eSpecUnparsedFile         = STRING(FORMAT='("alf_eSpec_",A0,"_db",A0,"--ESPECS_ALIGNED_UNPARSED--Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                     dbDate, $
                                     despunStr, $
                                     firstDBOrb, $
                                     lastOrb, $
                                     newFileDateStr)

  save_chunks_for_speed     = 1
  chunk_save_interval       = 50000
  chunkDir                  = inDir+'fully_parsed/'
  chunk_saveFile_pref       = STRING(FORMAT='("alf_eSpec_",A0,"_db",A0,"--PARSED--Orbs_",I0,"-",I0,"--",A0)', $
                                     dbDate, $
                                     despunStr, $
                                     firstDBOrb, $
                                     lastOrb, $
                                     newFileDateStr)

  RESTORE,inDir+winnowedFile
  RESTORE,inDir+eSpecUnparsedFile

  ;;Give 'er a check
  CHECK_DIFF_EFLUX_INPUTS_BEFORE_BEGINNING,eSpecs,jee_out,je_out,alf_mlt,alf_ilat,alf_alt,alf_orbit

  ;;Now give everything a second run-through
  IDENTIFY_DIFF_EFLUXES_AND_CREATE_STRUCT,eSpecs,jee_out,je_out, $
                                          alf_mlt,alf_ilat, $
                                          alf_ilat,alf_orbit, $
                                          alf_eSpecs_parsed, $
                                          SC_POT=alf_sc_pot, $
                                          ;; IND_SC_POT=ind_sc_pot, $
                                          ;; ORBSTR=orbStr, $
                                          /HAS_ALT_AND_ORBIT, $
                                          ;; /PRODUCE_FAILCODE_OUTPUT, $
                                          OUT_FAILCODES=failCodes, $
                                          SAVE_CHUNKS_FOR_SPEED=save_chunks_for_speed, $
                                          CHUNK_SAVE_INTERVAL=chunk_save_interval, $
                                          CHUNK_SAVEFILE_PREF=chunk_saveFile_pref, $
                                          CHUNKDIR=chunkDir, $
                                          /GIVE_TIMESPLIT_INFO, $
                                          QUIET=quiet, $
                                          /BATCH_MODE, $
                                          ERRORLOGFILE=errorLogFile

  
  IF ~KEYWORD_SET(save_chunks_for_speed) THEN BEGIN
     PRINT,'Saving parsed output to ' + eSpecParsedFile + '...'
     SAVE,alf_eSpecs_parsed,failCodes,FILENAME=inDir+eSpecParsedFile
  ENDIF

END
