;;05/26/16
;;This one takes in a list of eSpec indices that we want to grab
;;This one returns UNcategorized Alfven events
FUNCTION MAKE_ESPEC_DB_FOR_ALFVEN_DB_V3,winnowed_file,winnowed_dir, $
                                        firstOrb,lastOrb, $
                                        JE_OUT=je_out, $
                                        JEE_OUT=jee_out

  COMPILE_OPT idl2

  Newell_DB_dir    = '/SPENCEdata/software/sdt/batch_jobs/Alfven_study/20160520--get_Newell_identification_for_Alfven_events--NOT_despun/Newell_batch_output/'
  Newell_filePref  = 'Newell_et_al_identification_of_electron_spectra--ions_included--Orbit_'

  ;;Right?
  nEnergies          = 47

  IF ~N_ELEMENTS(winnowed_file) THEN BEGIN
     PRINT,"MAKE_ESPEC_DB_FOR_ALFVEN_DB_V3: No input file provided!"
     RETURN,-1
  ENDIF

  IF ~N_ELEMENTS(winnowed_dir) THEN BEGIN
     PRINT,"MAKE_ESPEC_DB_FOR_ALFVEN_DB_V3: No dir for input file provided!"
     RETURN,-1
  ENDIF

  IF ~FILE_TEST(winnowed_dir+winnowed_file) THEN BEGIN
     PRINT,"MAKE_ESPEC_DB_FOR_ALFVEN_DB_V3: Bogus file or dir provided..."
     RETURN,-1
  ENDIF


  ;;Here are the variables you're getting from this file, with "good" being a time difference of less than 5 seconds
  ;;  alf_i__good_eSpec,good_eSpec_i,good_eSpec_t,good_diffs,good_orbs,good_orbs_unique
  ;;  alf_i__bad_eSpec,bad_eSpec_i,bad_eSpec_t,bad_diffs,bad_orbs,bad_orbs_unique

  RESTORE,winnowed_dir+winnowed_file

  totPredicted            = 0
  totObtained             = 0

  orbCount                = 0
  maxChain                = 50

  eventsReported          = 0
  eventsAccumulated       = 0


  orbChunkSize            = 200
  nChunks                 = (lastOrb-firstOrb)/orbChunkSize
  eSpec_orbPadding        = 5
  
  ;; chunk_fName_pref        = 'alf_eSpec_'+dbDate+'_db--ESPEC_TIMES_COINCIDING_WITH_ALFDB--'
  TIC

  PRINT,FORMAT='("Orbit",T10,"N reported",T30,"N for this orb",T50,"N accumulated")'
  FOR iChunk=0,nChunks DO BEGIN

     ;; coveredOrbs = !NULL

     startOrb             = firstOrb+iChunk*orbChunkSize
     stopOrb              = startOrb+orbChunkSize-1
     PRINT,FORMAT='("Orbs: ",I0,T20,I0)',startOrb,stopOrb
     ;; temp_out_fname       = STRING(FORMAT='(A0,"Orbs_",I0,"-",I0,".sav")',chunk_fName_pref,startOrb,stopOrb)
     
     tmpOrb_i             = WHERE(good_orbs_unique GE startOrb AND $
                                  good_orbs_unique LE stopOrb,nTmpOrbs)
     ;;If we got nothin', do not proceed
     ;; IF nTmpOrbs EQ 0 THEN STOP
     IF tmpOrb_i[0] EQ -1 THEN STOP
     tempOrbArr           = good_orbs_unique[tmpOrb_i]
     
     ;; offsetOrb            = MIN(WHERE(master_eSpec_orbArr GE (startOrb-eSpec_orbPadding) AND $
     ;;                                  master_eSpec_orbArr LT (stopOrb+eSpec_orbPadding),nTmpOrbs),tmp_eSpec_offset_i)

     predicted_nEvents   = N_ELEMENTS(WHERE(good_orbs GE startOrb AND $
                                            good_orbs LE stopOrb))
     obtained_nEvents    = 0


     ;; IF nTmpOrbs EQ 0 THEN CONTINUE

     ;;How fast?
     clock             = TIC('Orbjunk' + STRCOMPRESS(iChunk,/REMOVE_ALL))

     ;;Stitch together one orb at a time, grab relevant events, go to next orb
     FOR iOrb=0,nTmpOrbs-1 DO BEGIN

        curOrb          = tempOrbArr[iOrb]

        ;;First, cat all eSpecs from each interval for this orbit
        doneski         = 0
        curInterval     = 0
        tempFile        = STRING(FORMAT='(A0,A0,I0,"_",I0,".sav")',Newell_DB_dir,Newell_filePref,curOrb,curInterval)
        IF ~FILE_TEST(tempFile) THEN BEGIN

           PRINT,FORMAT='("BOGUS!! MISSING ORB: ",I0,". (Resulting N events lost: ",I0,")")',curOrb,nHere
           STOP
        ENDIF
        WHILE ~doneski DO BEGIN

           RESTORE,tempFile
           
           tmpJe              = eSpecs_parsed.je
           tmpJee             = eSpecs_parsed.jee
           IF N_ELEMENTS(tmpJe) NE N_ELEMENTS(tmpeSpec_lc.x[*,0]) THEN BEGIN
              ;;gotta align em
              tmp_espec_i     = VALUE_CLOSEST(eSpecs_parsed.x,tmpeSpec_lc.x[*,0],diffs,SUCCESS=success,/BATCH_MODE)
              tmpJe           = tmpJe[tmp_espec_i]
              tmpJee          = tmpJee[tmp_espec_i]
           ENDIF

           CAT_ESPECS_FROM_NEWELL_FILES,cur_eSpec,tmpeSpec_lc
           CAT_JE_AND_JEE_FROM_NEWELL_FILES,cur_je,tmpJe, $
                                            cur_jee,tmpJee
           ;;Check for next interval
           curInterval++
           tempFile     = STRING(FORMAT='(A0,A0,I0,"_",I0,".sav")',Newell_DB_dir,Newell_filePref,curOrb,curInterval)
           IF ~FILE_TEST(tempFile) THEN doneski  = 1
        ENDWHILE
        
        ;;With the orbit eSpecs in hand, only pick the most awesome ones.
        ;;The appropriate indices are offset by this many:
        tmpGood_i             = WHERE(good_orbs EQ curOrb,nEv)

        obtained_nEvents     += nEv

        IF tmpGood_i[0] EQ -1 THEN STOP
        first_good_i          = MIN(tmpGood_i,first_good_ii)
        timeDiff              = MIN(ABS(good_eSpec_t[first_good_i]-cur_eSpec.x), $
                                    first_indexed_into_cur)
        IF timeDiff GT 5 THEN STOP
        start_i__this_orb     = good_eSpec_i[first_good_i]-first_indexed_into_cur
        good_i_for_cur        = good_eSpec_i[tmpGood_i]-start_i__this_orb

        IF (WHERE(ABS(cur_eSpec.x[good_i_for_cur]-good_eSpec_t[tmpGood_i]) GT 5))[0] NE -1 THEN STOP

        CAT_ESPECS_FROM_NEWELL_FILES,good_eSpec,cur_eSpec,good_i_for_cur
        CAT_JE_AND_JEE_FROM_NEWELL_FILES,good_je,cur_je, $
                                         good_jee,cur_jee, $
                                         good_i_for_cur

        cur_eSpec       = !NULL
        cur_jee         = !NULL
        cur_je          = !NULL

        eventsReported       += N_ELEMENTS(tmpGood_i)
        eventsAccumulated    += N_ELEMENTS(good_i_for_cur)
        orbCount++

        ;; PRINT,FORMAT='(I0,T10,I0,T30,I0,T50,I0)',curOrb,eventsReported,eventsAccumulated,N_ELEMENTS(good_eSpec.x)

        IF eventsReported NE eventsAccumulated THEN STOP

     ENDFOR

     totPredicted        += predicted_nEvents
     totObtained         += obtained_nEvents
     IF predicted_nEvents NE obtained_nEvents THEN STOP
     PRINT,'Predicted   : ' + STRCOMPRESS(predicted_nEvents,/REMOVE_ALL)
     PRINT,'Obtained    : ' + STRCOMPRESS(obtained_nEvents,/REMOVE_ALL)
     PRINT,'totPredicted: ' + STRCOMPRESS(totPredicted,/REMOVE_ALL)
     PRINT,'totObtained : ' + STRCOMPRESS(totObtained,/REMOVE_ALL)

     TOC,clock

     ;; IF orbCount GE maxChain THEN BEGIN
     clock             = TIC('chainem_' + STRCOMPRESS(orbCount,/REMOVE_ALL)+'_orbs--'+ $
                             STRCOMPRESS(N_ELEMENTS(good_je),/REMOVE_ALL) + '_events')



     ;;Update finals
     CAT_ESPECS_FROM_NEWELL_FILES,good_eSpecs_final,good_eSpec
     CAT_JE_AND_JEE_FROM_NEWELL_FILES,good_je_final,good_je, $
                                      good_jee_final,good_jee

     ;;Reset innies
     good_eSpec  = !NULL
     good_je     = !NULL
     good_jee    = !NULL
     orbCount    = 0

     totGoodSpecs      = N_ELEMENTS(good_eSpecs_final.x)
     IF eventsReported NE N_ELEMENTS(good_eSpecs_final.x) THEN STOP

     TOC
     ;; ENDIF

  ENDFOR

  ;; IF orbCount GT 0 THEN BEGIN
  ;;    clock             = TIC('chainem_' + STRCOMPRESS(orbCount,/REMOVE_ALL)+'_orbs--'+ $
  ;;                            STRCOMPRESS(N_ELEMENTS(good_je),/REMOVE_ALL) + '_events--FINAL')

  ;;    ;;Update finals
  ;;    CAT_ESPECS_FROM_NEWELL_FILES,good_eSpecs_final,good_eSpec
  ;;    CAT_JE_AND_JEE_FROM_NEWELL_FILES,good_je_final,good_je, $
  ;;                                     good_jee_final,good_jee

  ;;    ;;Reset innies
  ;;    good_eSpec  = !NULL
  ;;    good_je     = !NULL
  ;;    good_jee    = !NULL
  ;;    orbCount    = 0

  ;;    TOC
  ;; ENDIF

  je_out                  = good_je_final
  jee_out                 = good_jee_final

  RETURN,good_eSpecs_final

END
