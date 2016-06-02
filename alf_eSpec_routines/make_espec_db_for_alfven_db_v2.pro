;;05/26/16
;;This one returns UNcategorized Alfven events
FUNCTION MAKE_ESPEC_DB_FOR_ALFVEN_DB_V2,cdbTime,orbArr,firstOrb,lastOrb, $
                                        JE_OUT=je_out, $
                                        JEE_OUT=jee_out, $
                                        OUT_DIFFS=out_diffs, $
                                        OUT_MISSING_EVENTS=out_missing_events, $
                                        VERY_SLOW_DIAGNOSTIC=very_slow_diagnostic, $
                                        ONLY_PRODUCE_MISSING_ORB_OUTPUT=only_missing_output, $
                                        OUT_MISSING_ORB_ARR=missingOrbArr

  COMPILE_OPT idl2

  maxDiff          = 10.0 ;max allowable difference between spec and event
  badVal           = -9999

  Newell_DB_dir    = '/SPENCEdata/software/sdt/batch_jobs/Alfven_study/20160520--get_Newell_identification_for_Alfven_events--NOT_despun/Newell_batch_output/'
  Newell_filePref  = 'Newell_et_al_identification_of_electron_spectra--ions_included--Orbit_'

  nTime            = N_ELEMENTS(cdbTime)
  n_orbArr         = N_ELEMENTS(orbArr)
  
  missingOrbArr    = !NULL

  ;;Make sure these are sensible
  PRINT,FORMAT='("N events cdbTime, orbArr    :",T40,I0,T50,I0)',nTime,n_orbArr
  IF nTime NE n_orbArr THEN BEGIN
     PRINT,"Makes no sense! Unequal number of elements in each arr ..."
     STOP
  ENDIF


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Loop over all events, do in two separate loops to keep things fast

  IF ~KEYWORD_SET(firstOrb) THEN firstOrb           = 500
  IF ~KEYWORD_SET(lastOrb) THEN lastOrb             = 12335

  IF KEYWORD_SET(only_missing_output) THEN BEGIN
     GENERATE_MISSING_ORBS_OUTPUT,cdbTime,orbArr,firstOrb,lastOrb,missingOrbArr, $
                                  Newell_DB_dir,Newell_filePref
     RETURN,missingOrbArr
  ENDIF
  
  nEnergies          = 47

  diffs_innie        = !NULL
  diffs_final        = !NULL
  final_eSpecs_innie = !NULL   ;for inner loop (speed, you know)
  final_eSpecs       = !NULL
  orbCount           = 0
  maxChain           = 250
  missing            = MAKE_ARRAY(nTime,/BYTE,VALUE=1)

  FOR curOrb=firstOrb,lastOrb DO BEGIN
     
     ;;Get events in this orb
     temp_i          = WHERE(orbArr EQ curOrb,nHere)
     IF temp_i[0] EQ -1 THEN BEGIN
        PRINT,"No events for orbit " + STRCOMPRESS(curOrb,/REMOVE_ALL) + '!!!' 
        CONTINUE
     ENDIF

     IF KEYWORD_SET(very_slow_diagnostic) THEN BEGIN
        IF N_ELEMENTS(cur_eSpec) GT 0 THEN BEGIN
           IF N_ELEMENTS(cur_eSpec.x) NE N_ELEMENTS(cur_je) THEN STOP
        ENDIF
     ENDIF

     ;;First, cat all eSpecs from each interval for this orbit
     doneski         = 0
     curInterval     = 0
     cur_eSpec       = !NULL
     cur_jee         = !NULL
     cur_je          = !NULL
     diffs           = !NULL
     tempFile        = STRING(FORMAT='(A0,A0,I0,"_",I0,".sav")',Newell_DB_dir,Newell_filePref,curOrb,curInterval)
     IF ~FILE_TEST(tempFile) THEN BEGIN

        MAKE_BLANK_ESPEC_JE_AND_JEE_STRUCTS,blank_eSpec,blank_je,blank_jee,nHere,nEnergies

        CAT_ESPECS_FROM_NEWELL_FILES,final_eSpecs_innie,blank_eSpec
        CAT_JE_AND_JEE_FROM_NEWELL_FILES,final_je_innie,blank_je, $
                                         final_jee,blank_jee

        diffs_innie  = [diffs_innie,MAKE_ARRAY(nHere,VALUE=badVal)]
        orbCount++
        doneski      = 1

        missingOrbArr = [missingOrbArr,curOrb]

        PRINT,FORMAT='("MISSING ORBIT: ",I0,". (Resulting N events lost: ",I0,")")',curOrb,nHere
        CONTINUE
     ENDIF
     WHILE ~doneski DO BEGIN
        RESTORE,tempFile
        
        ;; IF N_ELEMENTS(tmpeSpec_lc) EQ 0 OR N_ELEMENTS(tmpjee_lc) EQ 0 OR N_ELEMENTS(tmpje_lc) EQ 0 THEN STOP

        tmpJe              = eSpecs_parsed.je
        tmpJee             = eSpecs_parsed.jee
        IF N_ELEMENTS(tmpJe) NE N_ELEMENTS(tmpeSpec_lc.x[*,0]) THEN BEGIN
           ;;gotta align em
           tmp_espec_i     = VALUE_CLOSEST(eSpecs_parsed.x,tmpeSpec_lc.x[*,0],diffs,SUCCESS=success,/BATCH_MODE)
           tmpJe           = tmpJe[tmp_espec_i]
           tmpJee          = tmpJee[tmp_espec_i]
        ENDIF

        CAT_ESPECS_FROM_NEWELL_FILES,cur_eSpec,tmpeSpec_lc
        ;; CAT_JE_AND_JEE_FROM_NEWELL_FILES,cur_je,eSpecs_parsed.je, $
        ;;                                  cur_jee,eSpecs_parsed.jee
        CAT_JE_AND_JEE_FROM_NEWELL_FILES,cur_je,tmpJe, $
                                         cur_jee,tmpJee
        ;;Check for next interval
        curInterval++
        tempFile     = STRING(FORMAT='(A0,A0,I0,"_",I0,".sav")',Newell_DB_dir,Newell_filePref,curOrb,curInterval)
        IF ~FILE_TEST(tempFile) THEN doneski  = 1
     ENDWHILE

     ;;Now, pick up all the closest events
     tempTimes       = cdbTime[temp_i]
     missing[temp_i] = 0
     alf_eSpec_i     = VALUE_CLOSEST(cur_eSpec.x,tempTimes,diffs,SUCCESS=success,/BATCH_MODE)

     ;; IF ~success THEN BEGIN
     ;;    PRINT,FORMAT='("NO EVENTS THIS ORB: ",I0,". (Resulting N events lost: ",I0,")")',curOrb,nHere
     ;;    CONTINUE
     ;; ENDIF

     CAT_ESPECS_FROM_NEWELL_FILES,final_eSpecs_innie,cur_eSpec,alf_eSpec_i
     CAT_JE_AND_JEE_FROM_NEWELL_FILES,final_je_innie,cur_je, $
                                      final_jee_innie,cur_jee, $
                                      alf_eSpec_i

     IF KEYWORD_SET(very_slow_diagnostic) THEN BEGIN
        IF N_ELEMENTS(final_eSpecs_innie.x) NE N_ELEMENTS(final_je_innie) THEN STOP
     ENDIF

     diffs_innie  = [diffs_innie,diffs]

     orbCount++

     IF orbCount GE maxChain THEN BEGIN
        ;;Update finals
        CAT_ESPECS_FROM_NEWELL_FILES,final_eSpecs,final_eSpecs_innie
        CAT_JE_AND_JEE_FROM_NEWELL_FILES,final_je,final_je_innie, $
                                         final_jee,final_jee_innie
        diffs_final        = [diffs_final,diffs_innie]

        ;;Reset innies
        final_eSpecs_innie = !NULL
        final_je_innie     = !NULL
        final_jee_innie    = !NULL
        diffs_innie        = !NULL
        orbCount           = 0
        IF KEYWORD_SET(very_slow_diagnostic) THEN BEGIN
           IF N_ELEMENTS(final_eSpecs.x) NE N_ELEMENTS(final_je) THEN STOP
        ENDIF
     ENDIF
  ENDFOR

  ;;Grab stragglers
  IF orbCount GT 0 THEN BEGIN
     CAT_ESPECS_FROM_NEWELL_FILES,final_eSpecs,final_eSpecs_innie
     CAT_JE_AND_JEE_FROM_NEWELL_FILES,final_je,final_je_innie, $
                                      final_jee,final_jee_innie
     diffs_final          = [diffs_final,diffs_innie]

     final_eSpecs_innie   = !NULL
     final_je_innie       = !NULL
     final_jee_innie      = !NULL
     diffs_innie          = !NULL
     orbCount             = 0
  ENDIF

  out_diffs               = diffs_final
  out_missing_events      = missing
  je_out                  = final_je
  jee_out                 = final_jee

  RETURN,final_eSpecs

END

PRO GENERATE_MISSING_ORBS_OUTPUT,cdbTime,orbArr,firstOrb,lastOrb,missingOrbArr, $
                                 Newell_DB_dir,Newell_filePref

  missingOrbArr      = !NULL
  curInterval        = 0

  FOR curOrb=firstOrb,lastOrb DO BEGIN
     
     ;;Get events in this orb
     temp_i          = WHERE(orbArr EQ curOrb,nHere)
     IF temp_i[0] EQ -1 THEN BEGIN
        PRINT,"No events for orbit " + STRCOMPRESS(curOrb,/REMOVE_ALL) + '!!!' 
        CONTINUE
     ENDIF

     ;;First, cat all eSpecs from each interval for this orbit
     tempFile        = STRING(FORMAT='(A0,A0,I0,"_",I0,".sav")',Newell_DB_dir,Newell_filePref,curOrb,curInterval)
     IF ~FILE_TEST(tempFile) THEN BEGIN

        missingOrbArr = [[missingOrbArr],[curOrb,nHere]]

        PRINT,FORMAT='("MISSING ORBIT: ",I0,". (Resulting N events lost: ",I0,")")',curOrb,nHere
     ENDIF

  ENDFOR  

END