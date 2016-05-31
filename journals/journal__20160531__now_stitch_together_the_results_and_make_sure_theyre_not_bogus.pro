;;05/31/16
PRO JOURNAL__20160531__NOW_STITCH_TOGETHER_THE_RESULTS_AND_MAKE_SURE_THEYRE_NOT_BOGUS

  COMPILE_OPT IDL2

  ;;Stuff for eSpec database
  firstOrb                  = 500
  lastOrb                   = 14000

  ;;THE MASTER OUT FILE
  theMasterOutFile          = 'alf_eSpec_20151222_db--TIME_SERIES_AND_ORBITS_ALIGNED_WITH_DB--Orbs_500-14000--20160531.sav'

  ;;load maximus and cdbTime
  LOAD_MAXIMUS_AND_CDBTIME,!NULL,cdbTime,DBDir=dbDir,/JUST_CDBTIME

  ;;load alfven_orbList
  orbFile                   = 'Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--orbits.sav'
  RESTORE,dbDir + orbFile

  inDir                     = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'
  inTimeSeriesFile          = 'alf_eSpec_20151222_db--TIME_SERIES_AND_ORBITS--Orbs_500-14000--20160531.sav'
  RESTORE,inDir+inTimeSeriesFile

  orbChunkSize              = 100
  nChunks                   = (lastOrb-firstOrb)/orbChunkSize
  eSpec_orbPadding          = 5

  chunk_fName_pref          = 'alf_eSpec_20151222_db--ESPEC_TIMES_COINCIDING_WITH_ALFDB--'
  TIC

  closest_eSpec_i_final     = !NULL
  closest_diffs_final       = !NULL
  alf_i_final               = !NULL
  FOR iChunk=0,nChunks DO BEGIN
     startOrb               = firstOrb+iChunk*orbChunkSize
     stopOrb                = startOrb+orbChunkSize
     PRINT,FORMAT='("Orbs: ",I0,T20,I0)',startOrb,stopOrb

     temp_out_fname         = STRING(FORMAT='(A0,"Orbs_",I0,"-",I0,".sav")',chunk_fName_pref,startOrb,stopOrb)
     RESTORE,inDir+temp_out_fname

     clock                  = TIC('Stitchem--' + STRCOMPRESS(iChunk,/REMOVE_ALL))
     closest_eSpec_i_final  = [closest_eSpec_i_final,closest_eSpec_i]
     closest_diffs_final    = [closest_diffs_final,closest_diffs]
     alf_i_final            = [alf_i_final,temp_alf_i]
     TOC,clock

     closest_eSpec_i        = !NULL
     temp_alf_i             = !NULL
     closest_diffs          = !NULL

  ENDFOR

  PRINT,"Save all dat!!"
  SAVE,closest_diffs_final,alf_i_final,closest_eSpec_i_final,FILENAME=inDir+theMasterOutFile

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
