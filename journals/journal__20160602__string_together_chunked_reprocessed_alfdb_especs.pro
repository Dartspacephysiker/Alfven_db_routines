;;06/02/16
PRO JOURNAL__20160602__STRING_TOGETHER_CHUNKED_REPROCESSED_ALFDB_ESPECS

  COMPILE_OPT IDL2

  has_failcodes             = 1

  IF has_failcodes THEN BEGIN
     failCodes_string = 'failCodes_'
  ENDIF ELSE BEGIN
     failCodes_string = ''
  ENDELSE

  despun                    = 1

  date_for_inputs           = '20160603'

  IF KEYWORD_SET(despun) THEN BEGIN
     despunStr              = '--despun'
     dbDate                 = '20160508'
     firstDBOrb             = 502
     orbFile                = 'Dartdb_20160508_despun--502-16361_despun--orbits.sav'
     totNSpectra            = 979303
  ENDIF ELSE BEGIN
     despunStr              = ''
     dbDate                 = '20151222'
     firstDBOrb             = 500
     orbFile                = 'Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--orbits.sav'
     totNSpectra            = 1139922
  ENDELSE
  firstOrb                  = 500
  lastOrb                   = 16361
  newFileDateStr            = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  inDir                     = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'

  chunk_save_interval       = 50000
  nChunks                   = CEIL(totNSpectra/FLOAT(chunk_save_interval))
  chunkDir                  = inDir+'fully_parsed/'
  chunk_saveFile_pref       = STRING(FORMAT='("alf_eSpec_",A0,"_db",A0,"--PARSED--Orbs_",I0,"-",I0,"--",A0)', $
                                     dbDate, $
                                     despunStr, $
                                     firstDBOrb, $
                                     lastOrb, $
                                     newFileDateStr)
  
  winnowedFile              = STRING(FORMAT='("alf_eSpec_",A0,"_db",A0,"--TIME_SERIES_AND_ORBITS_ALIGNED_WITH_DB--WINNOWED--Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                     dbDate, $
                                     despunStr, $
                                     firstDBOrb, $
                                     lastOrb, $
                                     todayStr)


  TOTALGLORY                = STRING(FORMAT='("alf_eSpec_",A0,"_db",A0,"--TOTAL_ESPECS_",A0,"_Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                     dbDate, $
                                     despunStr, $
                                     STRUPCASE(failCodes_string), $
                                     firstDBOrb, $
                                     lastOrb, $
                                     newFileDateStr)


  FOR iChunk=0,nChunks-1 DO BEGIN

     startSpectra             = chunk_save_interval*iChunk + 1
     stopSpectra              = ( chunk_save_interval*(iChunk + 1) < totNSpectra )

     chunkTempFName  = STRING(FORMAT='(A0,"--CHUNK_",I0,"--eSpecs_",A0,I0,"-",I0,".sav")',chunk_saveFile_pref,iChunk, $
                              failCodes_string,startSpectra,stopSpectra)

     failCodes_final          = !NULL
     events_final             = !NULL
     RESTORE,chunkDir+chunkTempFName

     
     ADD_EVENT_TO_SPECTRAL_STRUCT,eSpec,events_final
     IF KEYWORD_SET(has_failCodes) THEN ADD_ESPEC_FAILCODES_TO_FAILCODE_STRUCT,failCodes,failCodes_final
     

  ENDFOR

  ;;To get alf_i__good_eSpec and good_eSpec_i
  RESTORE,inDir+winnowedFile

  PRINT,'Saving to ' + TOTALGLORY + '...'
  IF KEYWORD_SET(has_failCodes) THEN BEGIN
     SAVE,eSpec,failCodes,alf_i__good_eSpec,good_eSpec_i,good_orbs,good_orbs_unique,FILENAME=chunkDir+TOTALGLORY
  ENDIF ELSE BEGIN
     SAVE,eSpec,alf_i__good_eSpec,good_eSpec_i,good_orbs,good_orbs_unique,FILENAME=chunkDir+TOTALGLORY
  ENDELSE
END
