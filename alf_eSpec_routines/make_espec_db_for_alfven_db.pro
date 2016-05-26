;;05/26/16
FUNCTION MAKE_ESPEC_DB_FOR_ALFVEN_DB,cdbTime,orbArr,OUT_DIFFS=out_diffs

  COMPILE_OPT idl2

  maxDiff          = 10.0 ;max allowable difference between spec and event
  badVal           = -9999

  Newell_DB_dir    = '/SPENCEdata/software/sdt/batch_jobs/Alfven_study/20160520--get_Newell_identification_for_Alfven_events--NOT_despun/Newell_batch_output/'
  Newell_filePref  = 'Newell_et_al_identification_of_electron_spectra--ions_included--Orbit_'

  nTime            = N_ELEMENTS(cdbTime)
  n_orbArr         = N_ELEMENTS(orbArr)
  

  ;;Make sure these are sensible
  PRINT,FORMAT='("N events cdbTime, orbArr    :",T40,I0,T50,I0)',nTime,n_orbArr
  IF nTime NE n_orbArr THEN BEGIN
     PRINT,"Makes no sense! Unequal number of elements in each arr ..."
     STOP
  ENDIF


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Loop over all events, do in two separate loops to keep things fast

  firstOrb           = 500
  lastOrb            = 8000

  diffs_innie        = !NULL
  diffs_final        = !NULL
  final_eSpecs_innie = !NULL   ;for inner loop (speed, you know)
  final_eSpecs       = !NULL
  orbCount           = 0
  maxChain           = 1000
  missing            = MAKE_ARRAY(nTime,/BYTE,VALUE=0)
  FOR curOrb=firstOrb,lastOrb DO BEGIN
     
     ;;Get events in this orb
     temp_i          = WHERE(orbArr EQ curOrb,nHere)
     IF temp_i[0] EQ -1 THEN BEGIN
        PRINT,"No events for orbit " + STRCOMPRESS(curOrb,/REMOVE_ALL) + '!!!' 
        CONTINUE
     ENDIF

     ;;First, cat all eSpecs from each interval for this orbit
     doneski         = 0
     curInterval     = 0
     cur_eSpecs      = !NULL
     tempFile        = STRING(FORMAT='(A0,A0,I0,"_",I0,".sav")',Newell_DB_dir,Newell_filePref,curOrb,curInterval)
     IF ~FILE_TEST(tempFile) THEN BEGIN
        missing[temp_i] = 1
        CAT_EVENTS_FROM_PARSED_SPECTRAL_STRUCT,final_eSpecs_innie, $
                                               MAKE_BLANK_ESPEC_STRUCTS(nHere)
        diffs_innie  = [diffs_innie,MAKE_ARRAY(nHere,VALUE=badVal)]
        orbCount++
        doneski      = 1

        PRINT,FORMAT='("MISSING ORBIT: ",I0,". (Resulting N events lost: ",I0,")")',curOrb,nHere
        CONTINUE
     ENDIF
     WHILE ~doneski DO BEGIN
        RESTORE,tempFile
        
        IF N_ELEMENTS(eSpecs_parsed) EQ 0 THEN STOP

        CAT_EVENTS_FROM_PARSED_SPECTRAL_STRUCT,cur_eSpecs,eSpecs_parsed

        ;;Check for next interval
        curInterval++
        tempFile     = STRING(FORMAT='(A0,A0,I0,"_",I0,".sav")',Newell_DB_dir,Newell_filePref,curOrb,curInterval)
        IF ~FILE_TEST(tempFile) THEN doneski  = 1
     ENDWHILE

     ;;Now, pick up all the closest events
     tempTimes       = cdbTime[temp_i]
     alf_eSpec_i     = VALUE_CLOSEST(cur_eSpecs.x,tempTimes,diffs,SUCCESS=success)

     IF ~success THEN BEGIN
        PRINT,FORMAT='("NO EVENTS THIS ORB: ",I0,". (Resulting N events lost: ",I0,")")',curOrb,nHere
        CONTINUE
     ENDIF

     CAT_EVENTS_FROM_PARSED_SPECTRAL_STRUCT,final_eSpecs_innie,cur_eSpecs,alf_eSpec_i
     diffs_innie  = [diffs_innie,diffs]

     orbCount++

     IF orbCount GE maxChain THEN BEGIN
        ;;Update finals
        CAT_EVENTS_FROM_PARSED_SPECTRAL_STRUCT,final_eSpecs,final_eSpecs_innie
        diffs_final        = [diffs_final,diffs_innie]

        ;;Reset innies
        final_eSpecs_innie = !NULL
        diffs_innie        = !NULL
        orbCount           = 0
     ENDIF
  ENDFOR

  ;;Grab stragglers
  IF N_ELEMENTS(final_eSpecs_innie) NE 0 THEN BEGIN
     CAT_EVENTS_FROM_PARSED_SPECTRAL_STRUCT,final_eSpecs,final_eSpecs_innie
     diffs_final          = [diffs_final,diffs_innie]

     final_eSpecs_innie   = !NULL
     diffs_innie          = !NULL
     orbCount             = 0
  ENDIF

  out_diffs               = out_diffs

  RETURN,final_eSpecs

END
