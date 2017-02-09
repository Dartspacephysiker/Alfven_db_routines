;;02/09/17
FUNCTION MAKE_NEWELL_IDENT_STRUCT_FOR_ALFDB__FROM_FILE, $
   maximus,eSpec,fName, $
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
  ENDIF ELSE BEGIN
     @common__maximus_vars.pro
     IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
        LOAD_MAXIMUS_AND_CDBTIME

        pAlfDB    = PTR_NEW(TEMPORARY(MAXIMUS__maximus))
     ENDIF
  ENDELSE

  IF ~KEYWORD_SET(file) THEN BEGIN
     file = (*pAlfDB).info.DB_dir + (*pAlfDB).info.DB__into_eSpec_file
  ENDIF

  IF ~FILE_TEST(file) THEN BEGIN
     PRINT,"Couldn't find file: " + file + "! Returning ..."
     RETURN,-1
  ENDIF

  RESTORE,file


  hadeSpec        = 0B
  IF KEYWORD_SET(eSpec) THEN BEGIN
     hadeSpec     = 1B
     peSpecDB     = PTR_NEW(TEMPORARY(eSpec))
  ENDIF ELSE BEGIN
     @common__newell_espec.pro
     IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
        LOAD_NEWELL_ESPEC_DB

        peSpecDB  = PTR_NEW(TEMPORARY(NEWELL__eSpec))
     ENDIF
  ENDELSE

  IF alf_into_eSpecDB.alfDB_info.DB_date NE (*pAlfDB).info.DB_date THEN BEGIN
     PRINT,"Mismatching AlfDBs, je crois ..."
     PRINT,FORMAT='(A0,T25,": ",A0)',"alfDB_into_eSpecDB alfDB_date",alf_into_eSpecDB.alfDB_info.DB_date
     PRINT,FORMAT='(A0,T25,": ",A0)',"alfDB DB_date",(*pAlfDB).info.DB_date
     RETURN,-1
  ENDIF
  
  IF alf_into_eSpecDB.eSpec_info.DB_date NE (*peSpec).info.DB_date THEN BEGIN
     PRINT,"Mismatching eSpecDBs, je crois ..."
     PRINT,FORMAT='(A0,T25,": ",A0)',"alfDB_into_eSpecDB eSpecDB_date",alf_into_eSpecDB.eSpec_info.DB_date
     PRINT,FORMAT='(A0,T25,": ",A0)',"alfDB DB_date",(*peSpec).info.DB_date
     RETURN,-1
  ENDIF
  
  ;; maxTDiff         = 10.
  ;; disqualified_i   = WHERE(ABS((*peSpec).x[alfDB__eSpec_inds]-MAXIMUS__times) GE maxTDiff, $
  ;;                          nDisqualified)

  alfDB_eSpec     = {x          : (*peSpec).x         [alf_into_eSpecDB.inds], $
                     orbit      : (*peSpec).orbit     [alf_into_eSpecDB.inds], $
                     MLT        : (*peSpec).MLT       [alf_into_eSpecDB.inds], $
                     ILAT       : (*peSpec).ILAT      [alf_into_eSpecDB.inds], $
                     alt        : (*peSpec).alt       [alf_into_eSpecDB.inds], $
                     mono       : (*peSpec).mono      [alf_into_eSpecDB.inds], $
                     broad      : (*peSpec).broad     [alf_into_eSpecDB.inds], $
                     diffuse    : (*peSpec).diffuse   [alf_into_eSpecDB.inds], $
                     je         : (*peSpec).je        [alf_into_eSpecDB.inds], $
                     jee        : (*peSpec).jee       [alf_into_eSpecDB.inds], $
                     nBad_eSpec : (*peSpec).nBad_eSpec[alf_into_eSpecDB.inds], $
                     mapFactor  : (*peSpec).mapFactor [alf_into_eSpecDB.inds], $
                     info       : (*peSpec).info                             }


  IF hadMaximus THEN BEGIN
     maximus           = TEMPORARY(*pAlfDB)
  ENDIF ELSE BEGIN
     MAXIMUS__maximus  = TEMPORARY(*pAlfDB)
  ENDELSE


  IF hadeSpec THEN BEGIN
     eSpec             = TEMPORARY(*peSpec)
  ENDIF ELSE BEGIN
     NEWELL__eSpec     = TEMPORARY(*peSpec)
  ENDELSE

  PTR_FREE,pAlfDB,peSpec
  HEAP_FREE,pAlfDB,/PTR
  HEAP_FREE,peSpec,/PTR
  HEAP_GC
  
  RETURN,alfDB_eSpec
  
END
