;;05/31/16
PRO JOURNAL__20160531__NOW_STITCH_TOGETHER_THE_RESULTS_AND_MAKE_SURE_THEYRE_NOT_BOGUS

  COMPILE_OPT IDL2

  ;;Stuff for eSpec database
  firstOrb                  = 500
  lastOrb                   = 16361


  dbDate                    = '20151222'

  todayStr                  = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  ;;THE MASTER OUT FILE
  theMasterOutFile          = STRING(FORMAT='("alf_eSpec_",I0,"_db--TIME_SERIES_AND_ORBITS_ALIGNED_WITH_DB--Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                     dbDate, $
                                     firstOrb, $
                                     lastOrb, $
                                     todayStr)

  ;;load maximus and cdbTime
  LOAD_MAXIMUS_AND_CDBTIME,!NULL,cdbTime,DBDir=dbDir,/JUST_CDBTIME

  ;;load alfven_orbList
  orbFile                   = 'Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--orbits.sav'
  RESTORE,dbDir + orbFile

  inDir                     = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'
  inTimeSeriesFile          = STRING(FORMAT='("alf_eSpec_",A0,"_db--TIME_SERIES_AND_ORBITS--Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                     dbDate, $
                                     firstOrb, $
                                     lastOrb, $
                                     todayStr)
  RESTORE,inDir+inTimeSeriesFile

  orbChunkSize              = 100
  nChunks                   = (lastOrb-firstOrb)/orbChunkSize
  ;; eSpec_orbPadding          = 1

  chunk_fName_pref          = 'alf_eSpec_20151222_db--ESPEC_TIMES_COINCIDING_WITH_ALFDB--'
  TIC

  closest_eSpec_i_final     = !NULL
  closest_eSpec_t_final     = !NULL
  closest_diffs_final       = !NULL
  alf_i_final               = !NULL

  PRINT,FORMAT='("nBad",T15,"nGood",T30,"nTot")'
  FOR iChunk=0,nChunks DO BEGIN

     startOrb               = firstOrb+iChunk*orbChunkSize
     stopOrb                = startOrb+orbChunkSize-1
     PRINT,FORMAT='("Orbs: ",I0,T20,I0)',startOrb,stopOrb

     temp_out_fname         = STRING(FORMAT='(A0,"Orbs_",I0,"-",I0,".sav")',chunk_fName_pref,startOrb,stopOrb)

     closest_eSpec_i        = !NULL
     temp_alf_i             = !NULL
     closest_diffs          = !NULL
     RESTORE,inDir+temp_out_fname
     IF N_ELEMENTS(closest_eSpec_i) EQ 0 OR N_ELEMENTS(temp_alf_i) EQ 0 OR N_ELEMENTS(closest_diffs) EQ 0 THEN STOP
     tempDiff               = cdbtime[temp_alf_i]-espec_times_final[closest_espec_i]
     bad                    = WHERE(ABS(tempDiff) GT 5,nBad,NCOMPLEMENT=nGood)

     ;; IF nBad GT 100 THEN STOP

     PRINT,FORMAT='(I0,T15,I0,T30,I0)',nBad,nGood,nBad+nGood

     ;;**Clock**
     IF KEYWORD_SET(clockme) THEN BEGIN
        clock               = TIC('Stitchem--' + STRCOMPRESS(iChunk,/REMOVE_ALL))
     ENDIF
     ;;**Clock**

     closest_eSpec_i_final  = [closest_eSpec_i_final,closest_eSpec_i]
     closest_eSpec_t_final  = [closest_eSpec_t_final,eSpec_times_final[closest_eSpec_i]]
     closest_diffs_final    = [closest_diffs_final,closest_diffs]
     alf_i_final            = [alf_i_final,temp_alf_i]

     ;;**Clock**
     IF KEYWORD_SET(clockme) THEN TOC,clock ;want a clock?
     ;;**Clock**

  ENDFOR

  PRINT,"Save all dat!!"
  SAVE,closest_diffs_final,alf_i_final, $
       closest_eSpec_i_final,closest_eSpec_t_final, $
       FILENAME=inDir+theMasterOutFile

  STOP

  terrible_ii               = WHERE(ABS(closest_diffs_final) GT 5,nTerrible)
  terrible                  = closest_eSpec_i_final[terrible_ii]
  terrible_orbs             = orbArr_final[terrible]
  CHECK_SORTED,terrible_orbs
  terrible_orbs             = terrible_orbs[UNIQ(terrible_orbs)]

  great_ii                  = WHERE(ABS(closest_diffs_final) LE 5,nGreat)
  great                     = closest_eSpec_i_final[great_ii]
  great_orbs                = orbArr_final[great]
  CHECK_SORTED,great_orbs
  great_orbs                = great_orbs[UNIQ(great_orbs)]

END
