;;06/02/16
PRO JOURNAL__20160602__STRING_TOGETHER_CHUNKED_REPROCESSED_ALFDB_ESPECS

  COMPILE_OPT IDL2

  has_failcodes             = 1

  IF has_failcodes THEN BEGIN
     failCodes_string = 'failCodes_'
  ENDIF ELSE BEGIN
     failCodes_string = ''
  ENDELSE

  dbDate                    = '20151222'
  date_for_inputs           = '20160602'

  firstOrb                  = 500
  lastOrb                   = 16361
  newFileDateStr            = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  inDir                     = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'

  totalSpectra              = 1139699
  chunk_save_interval       = 50000
  nChunks                   = CEIL(totalSpectra/FLOAT(chunk_save_interval))
  totNSpectra               = 1139699
  chunkDir                  = inDir+'fully_parsed/'
  chunk_saveFile_pref       = STRING(FORMAT='("alf_eSpec_20151222_db--PARSED--Orbs_",I0,"-",I0,"--",A0)', $
                                     firstOrb, $
                                     lastOrb, $
                                     date_for_inputs)
  
  TOTALGLORY                = STRING(FORMAT='("alf_eSpec_20151222_db--TOTAL_ESPECS_",A0,"_Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                     STRUPCASE(failCodes_string), $
                                     firstOrb, $
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

  PRINT,'Saving to ' + TOTALGLORY + '...'
  IF KEYWORD_SET(has_failCodes) THEN BEGIN
     SAVE,eSpec,failCodes,FILENAME=chunkDir+TOTALGLORY
  ENDIF ELSE BEGIN
     SAVE,eSpec,FILENAME=chunkDir+TOTALGLORY
  ENDELSE
END
