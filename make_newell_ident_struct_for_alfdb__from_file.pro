;;02/09/17
FUNCTION MAKE_NEWELL_IDENT_STRUCT_FOR_ALFDB__FROM_FILE, $
   maximus,cdbTime,eSpec,fName, $
   USE_COMMON_VARS=use_common_vars

  COMPILE_OPT IDL2

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

  IF ~KEYWORD_SET(file) THEN BEGIN
     file = (*pAlfDB).info.DB_dir + (*pAlfDB).info.DB__into_eSpec_file
  ENDIF

  IF ~FILE_TEST(file) THEN BEGIN
     PRINT,"Couldn't find file: " + file + "! Returning ..."

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

  RESTORE,file


  hadeSpec        = 0B
  IF KEYWORD_SET(eSpec) THEN BEGIN
     hadeSpec     = 1B
     peSpecDB     = PTR_NEW(TEMPORARY(eSpec))
  ENDIF ELSE BEGIN
     @common__newell_espec.pro
     IF N_ELEMENTS(NEWELL__eSpec) EQ 0 THEN BEGIN
        LOAD_NEWELL_ESPEC_DB,/DONT_CONVERT_TO_STRICT_NEWELL
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
  
  maxTDiff         = 10.
  tDiff            = (*peSpecDB).x[alf_into_eSpecDB.inds]-(*pAlfTime)
  disqualified_i   = WHERE(ABS(tDiff) GE maxTDiff, $
                           nDisqualified)
  IF ~KEYWORD_SET(quiet) THEN BEGIN
     PRINT,FORMAT='("Could disqualify ",I0," inds that are more than ",F0.2," s from the time of max IAW current")', $
           nDisqualified,maxTDiff
  ENDIF

  alfDB_eSpec     = {x          : (*peSpecDB).x         [alf_into_eSpecDB.inds], $
                     orbit      : (*peSpecDB).orbit     [alf_into_eSpecDB.inds], $
                     MLT        : (*peSpecDB).MLT       [alf_into_eSpecDB.inds], $
                     ILAT       : (*peSpecDB).ILAT      [alf_into_eSpecDB.inds], $
                     alt        : (*peSpecDB).alt       [alf_into_eSpecDB.inds], $
                     mono       : (*peSpecDB).mono      [alf_into_eSpecDB.inds], $
                     broad      : (*peSpecDB).broad     [alf_into_eSpecDB.inds], $
                     diffuse    : (*peSpecDB).diffuse   [alf_into_eSpecDB.inds], $
                     je         : (*peSpecDB).je        [alf_into_eSpecDB.inds], $
                     jee        : (*peSpecDB).jee       [alf_into_eSpecDB.inds], $
                     nBad_eSpec : (*peSpecDB).nBad_eSpec[alf_into_eSpecDB.inds], $
                     mapFactor  : (*peSpecDB).mapFactor [alf_into_eSpecDB.inds], $
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
