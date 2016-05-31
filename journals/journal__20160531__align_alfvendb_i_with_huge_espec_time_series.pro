;;05/31/16
;;I originally failed to check for false positives by failing to check the results of (WHERE())[0] EQ -1. You see some lines below
;;indicating that life is good.
PRO JOURNAL__20160531__ALIGN_ALFVENDB_I_WITH_HUGE_ESPEC_TIME_SERIES

  COMPILE_OPT IDL2

  ;;Stuff for eSpec database
  firstOrb                = 500
  lastOrb                 = 14000

  ;;load maximus and cdbTime
  LOAD_MAXIMUS_AND_CDBTIME,!NULL,cdbTime,DBDir=dbDir,/JUST_CDBTIME

  ;;load alfven_orbList
  orbFile                 = 'Dartdb_20151222--500-16361_inc_lower_lats--burst_1000-16361--orbits.sav'
  RESTORE,dbDir + orbFile

  inDir                   = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'
  inTimeSeriesFile        = 'alf_eSpec_20151222_db--TIME_SERIES_AND_ORBITS--Orbs_500-14000--20160531.sav'
  RESTORE,inDir+inTimeSeriesFile

  orbChunkSize            = 100
  nChunks                 = (lastOrb-firstOrb)/orbChunkSize
  eSpec_orbPadding        = 5
  
  chunk_fName_pref        = 'alf_eSpec_20151222_db--ESPEC_TIMES_COINCIDING_WITH_ALFDB--'
  TIC
  FOR iChunk=0,nChunks DO BEGIN

     startOrb             = firstOrb+iChunk*orbChunkSize
     stopOrb              = startOrb+orbChunkSize
     PRINT,FORMAT='("Orbs: ",I0,T20,I0)',startOrb,stopOrb
     temp_out_fname       = STRING(FORMAT='(A0,"Orbs_",I0,"-",I0,".sav")',chunk_fName_pref,startOrb,stopOrb)

     temp_alf_i           = WHERE(alfven_orbList GE startOrb AND alfven_orbList LT stopOrb,nTmpAlf)

     ;;To check whether any of these are garbage (because I didn't do it up front!!!)
     ;;(AFTER CHECKING): Turns out they're all safe
     ;; IF temp_alf_i[0] EQ -1 THEN PRINT,"BEWARE: This orb range doesn't actually have squattum!"
     ;; CONTINUE

     temp_eSpec_i         = WHERE(orbArr_final GE (startOrb-eSpec_orbPadding) AND $
                                  orbArr_final LT (stopOrb+eSpec_orbPadding),nTmpEspec)

     ;;Keep track of offset relative to all inds so we know who goes where
     ;; temp_alf_offset      = temp_alf_i[0]
     ;; temp_eSpec_offset    = temp_eSpec_i[0]

     ;; temp_alf_time        = cdbTime[TEMPORARY(temp_alf_i)]
     ;; temp_eSpec_times     = eSpec_times_final[TEMPORARY(temp_eSpec_i)]
     temp_alf_times       = cdbTime[temp_alf_i]
     temp_eSpec_times     = eSpec_times_final[temp_eSpec_i]
     ;; temp_alf_time        = cdbTime[WHERE(alfven_orbList GE startOrb AND alfven_orbList LT stopOrb,nTmpAlf)]
     ;; temp_eSpec_times     = eSpec_times_final[WHERE(orbArr_final GE (startOrb-eSpec_orbPadding) AND $
     ;;                                                orbArr_final LT (stopOrb+eSpec_orbPadding),nTmpEspec)]
     
     
     clock                = TIC('Orbjunk' + STRCOMPRESS(iChunk,/REMOVE_ALL))
     temp_closest_ii      = VALUE_CLOSEST(temp_eSpec_times,temp_alf_times,closest_diffs,/BATCH_MODE)
     TOC,clock

     closest_eSpec_i      = temp_eSpec_i[TEMPORARY(temp_closest_ii)]

     PRINT,'Saving temp stuff...'
     SAVE,temp_alf_i,closest_eSpec_i,closest_diffs,FILENAME=inDir+temp_out_fname

     closest_eSpec_i      = !NULL
     temp_alf_i           = !NULL
     closest_diffs        = !NULL

  ENDFOR


END
