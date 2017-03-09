;;02/09/17
FUNCTION MAKE_NEWELL_IDENT_STRUCT_FOR_ALFDB__FROM_FILE, $
   maximus,cdbTime,eSpec,fName, $
   USER_INDS=user_inds, $
   USE_COMMON_VARS=use_common_vars, $
   DONT_PERFORM_CORRECTION=dont_perform_SH_correction, $
   DONT_CONVERT_TO_STRICT_NEWELL=dont_convert_to_strict_newell, $
   DONT_MAP_TO_100KM=no_mapping, $
   DO_NOT_MAP_FLUXES=do_not_map_fluxes, $
   DO_NOT_MAP_DELTA_T=do_not_map_delta_t, $
   USE_2000KM_FILE=use_2000km_file


  COMPILE_OPT IDL2,STRICTARRSUBS

  IF ~KEYWORD_SET(use_common_vars) THEN BEGIN
     IF ~(KEYWORD_SET(maximus) AND KEYWORD_SET(eSpec) AND KEYWORD_SET(fName)) THEN BEGIN
        PRINT,"Unless using common vars, you must specify maximus, eSpec, and fName!"
        RETURN,-1
     ENDIF
  ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Now check for DBs and file
  hadMaximus      = 0B
  IF KEYWORD_SET(maximus) THEN BEGIN
     hadMaximus   = 1B
     pAlfDB       = PTR_NEW(TEMPORARY(maximus))
     pAlfTime     = PTR_NEW(TEMPORARY(cdbTime))
  ENDIF ELSE BEGIN
     @common__maximus_vars.pro
     IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
        LOAD_MAXIMUS_AND_CDBTIME
     ENDIF
        pAlfDB    = PTR_NEW(TEMPORARY(MAXIMUS__maximus))
        pAlfTime  = PTR_NEW(TEMPORARY(MAXIMUS__times))
  ENDELSE

  IF ~KEYWORD_SET(fName) THEN BEGIN
     fName = (*pAlfDB).info.DB_dir + (*pAlfDB).info.DB__into_eSpec_file
  ENDIF

  IF ~FILE_TEST(fName) THEN BEGIN
     PRINT,"Couldn't find file: " + fName + "! Returning ..."

     IF hadMaximus THEN BEGIN
        maximus           = TEMPORARY(*pAlfDB)
        cdbTime           = TEMPORARY(*pAlfTime)
     ENDIF ELSE BEGIN
        MAXIMUS__maximus  = TEMPORARY(*pAlfDB)
        MAXIMUS__times    = TEMPORARY(*pAlfTime)
     ENDELSE

     PTR_FREE,pAlfDB,pAlfTime
     HEAP_FREE,pAlfDB,/PTR
     HEAP_FREE,pAlfTime,/PTR
     HEAP_GC

     RETURN,-1
  ENDIF

  PRINT,"Restoring " + fName + ' ...'
  RESTORE,fName

  nInds           = N_ELEMENTS(alf_into_eSpecDB.inds)
  IF nInds NE N_ELEMENTS(*pAlfTime) THEN BEGIN
     PRINT,"Unequal numbers of inds into eSpecDB and AlfDB times! Care to inspect?"
     STOP
  ENDIF

  hadeSpec        = 0B
  IF KEYWORD_SET(eSpec) THEN BEGIN
     hadeSpec     = 1B
     peSpecDB     = PTR_NEW(TEMPORARY(eSpec))
  ENDIF ELSE BEGIN
     @common__newell_espec.pro
     IF N_ELEMENTS(NEWELL__eSpec) EQ 0 THEN BEGIN
        LOAD_NEWELL_ESPEC_DB, $
           DONT_PERFORM_CORRECTION=dont_perform_SH_correction, $
           DONT_CONVERT_TO_STRICT_NEWELL=dont_convert_to_strict_newell, $
           DONT_MAP_TO_100KM=no_mapping, $
           DO_NOT_MAP_FLUXES=do_not_map_fluxes, $
           DO_NOT_MAP_DELTA_T=do_not_map_delta_t, $
           USE_2000KM_FILE=use_2000km_file, $
           /LOAD_CHARE
     ENDIF
        peSpecDB  = PTR_NEW(TEMPORARY(NEWELL__eSpec))
  ENDELSE

  IF alf_into_eSpecDB.alfDB_info.DB_date NE (*pAlfDB).info.DB_date THEN BEGIN
     PRINT,"Mismatching AlfDBs, je crois ..."
     PRINT,FORMAT='(A0,T25,": ",A0)',"alfDB_into_eSpecDB alfDB_date",alf_into_eSpecDB.alfDB_info.DB_date
     PRINT,FORMAT='(A0,T25,": ",A0)',"alfDB DB_date",(*pAlfDB).info.DB_date

     IF hadMaximus THEN BEGIN
        maximus           = TEMPORARY(*pAlfDB)
        cdbTime           = TEMPORARY(*pAlfTime)
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(use_common_vars) THEN BEGIN
           MAXIMUS__maximus  = TEMPORARY(*pAlfDB)
           MAXIMUS__times    = TEMPORARY(*pAlfTime)
        ENDIF
     ENDELSE

     IF hadeSpec THEN BEGIN
        eSpec             = TEMPORARY(*peSpecDB)
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(use_common_vars) THEN BEGIN
           NEWELL__eSpec     = TEMPORARY(*peSpecDB)
        ENDIF
     ENDELSE

     PTR_FREE,pAlfDB,pAlfTime,peSpecDB
     HEAP_FREE,pAlfDB,/PTR
     HEAP_FREE,pAlfTime,/PTR
     HEAP_FREE,peSpecDB,/PTR
     HEAP_GC

     RETURN,-1
  ENDIF
  
  IF alf_into_eSpecDB.eSpec_info.DB_date NE (*peSpecDB).info.DB_date THEN BEGIN
     PRINT,"Mismatching eSpecDBs, je crois ..."
     PRINT,FORMAT='(A0,T25,": ",A0)',"alfDB_into_eSpecDB eSpecDB_date",alf_into_eSpecDB.eSpec_info.DB_date
     PRINT,FORMAT='(A0,T25,": ",A0)',"alfDB DB_date",(*peSpecDB).info.DB_date

     IF hadMaximus THEN BEGIN
        maximus           = TEMPORARY(*pAlfDB)
        cdbTime           = TEMPORARY(*pAlfTime)
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(use_common_vars) THEN BEGIN
           MAXIMUS__maximus  = TEMPORARY(*pAlfDB)
           MAXIMUS__times    = TEMPORARY(*pAlfTime)
        ENDIF
     ENDELSE

     IF hadeSpec THEN BEGIN
        eSpec             = TEMPORARY(*peSpecDB)
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(use_common_vars) THEN BEGIN
           NEWELL__eSpec     = TEMPORARY(*peSpecDB)
        ENDIF
     ENDELSE

     PTR_FREE,pAlfDB,pAlfTime,peSpecDB
     HEAP_FREE,pAlfDB,/PTR
     HEAP_FREE,pAlfTime,/PTR
     HEAP_FREE,peSpecDB,/PTR
     HEAP_GC

     RETURN,-1
  ENDIF
  
  IF KEYWORD_SET(user_inds) THEN BEGIN
     IF (MAX(user_inds) GE nInds) OR (N_ELEMENTS(user_inds) GT nInds) THEN BEGIN
        PRINT,"There is almost certainly an issue. You've got more user_inds than is lawful in this sitiation. (I ALWAYS mean sitiation.)"
        STOP
     ENDIF
  ENDIF ELSE BEGIN
     user_inds          = LINDGEN(nInds)
  ENDELSE

  alf_into_eSpecDB_inds = alf_into_eSpecDB.inds[user_inds]

  ;;Now do what we came for
  maxTDiff         = 10.
  tDiff            = (*peSpecDB).x[alf_into_eSpecDB_inds]-((*pAlfTime)[user_inds])
  disqualified_i   = WHERE(ABS(tDiff) GE maxTDiff, $
                           nDisqualified)
  IF ~KEYWORD_SET(quiet) THEN BEGIN
     PRINT,FORMAT='("Could disqualify ",I0," inds that are more than ",F0.2," s from the time of max IAW current")', $
           nDisqualified,maxTDiff
  ENDIF

  alfDB_eSpec     = {x          : (*peSpecDB).x         [alf_into_eSpecDB_inds], $
                     orbit      : (*peSpecDB).orbit     [alf_into_eSpecDB_inds], $
                     MLT        : (*peSpecDB).MLT       [alf_into_eSpecDB_inds], $
                     ILAT       : (*peSpecDB).ILAT      [alf_into_eSpecDB_inds], $
                     alt        : (*peSpecDB).alt       [alf_into_eSpecDB_inds], $
                     mono       : (*peSpecDB).mono      [alf_into_eSpecDB_inds], $
                     broad      : (*peSpecDB).broad     [alf_into_eSpecDB_inds], $
                     diffuse    : (*peSpecDB).diffuse   [alf_into_eSpecDB_inds], $
                     je         : (*peSpecDB).je        [alf_into_eSpecDB_inds], $
                     jee        : (*peSpecDB).jee       [alf_into_eSpecDB_inds], $
                     charE      : (*peSpecDB).charE     [alf_into_eSpecDB_inds], $
                     nBad_eSpec : (*peSpecDB).nBad_eSpec[alf_into_eSpecDB_inds], $
                     mapFactor  : (*peSpecDB).mapFactor [alf_into_eSpecDB_inds], $
                     tDiff      : tDiff                                        , $
                     maxTDiff   : maxTDiff                                     , $
                     disqual_i  : disqualified_i                               , $
                     info       : (*peSpecDB).info                             }

  alfDB_eSpec.info.is_alfNewell = 1B
  
  IF hadMaximus THEN BEGIN
     maximus           = TEMPORARY(*pAlfDB)
     cdbTime           = TEMPORARY(*pAlfTime)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(use_common_vars) THEN BEGIN
        MAXIMUS__maximus  = TEMPORARY(*pAlfDB)
        MAXIMUS__times    = TEMPORARY(*pAlfTime)
     ENDIF
  ENDELSE

  IF hadeSpec THEN BEGIN
     eSpec             = TEMPORARY(*peSpecDB)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(use_common_vars) THEN BEGIN
        NEWELL__eSpec     = TEMPORARY(*peSpecDB)
     ENDIF
  ENDELSE

  PTR_FREE,pAlfDB,pAlfTime,peSpecDB
  HEAP_FREE,pAlfDB,/PTR
  HEAP_FREE,pAlfTime,/PTR
  HEAP_FREE,peSpecDB,/PTR
  HEAP_GC
  
  RETURN,alfDB_eSpec
  
END
