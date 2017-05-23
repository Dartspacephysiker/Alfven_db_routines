;;11/25/16
PRO FASTDB__ADD_INFO_STRUCT,dbStruct, $
                            FOR_ALFDB=for_alfDB, $
                            FOR_SWAY_DB=for_swayDB, $
                            FOR_FASTLOC=for_fastLoc, $
                            DB_DIR=DB_dir, $
                            DB_DATE=DB_date, $
                            DB_VERSION=DB_version, $
                            DB_EXTRAS=DB_extras, $
                            DB__INTO_ESPEC_FILE=DB__into_eSpec_file ;, $
  ;; REDUCE_DBSIZE=reduce_dbSize, $
  ;; IS_ALFNEWELL=is_AlfNewell


  COMPILE_OPT IDL2,STRICTARRSUBS

  CASE 1 OF
     KEYWORD_SET(for_fastLoc): BEGIN
        dbNavn = 'fastLoc'
        info  = { $             ;converted        : 0B, $
                ;; corrected_fluxes : 0B, $
                ;; corrected_string : '', $
                ;; is_reduced       : BYTE(KEYWORD_SET(reduce_dbSize)), $
                DB_dir           : '', $
                DB_date          : '', $
                DB_version       : '', $
                DB_extras        : '', $
                is_32Hz          : 0B, $
                is_128Hz         : 0B, $
                is_noRestrict    : 0B, $
                is_mapped        : 0B, $
                dILAT_not_dt     : 0B, $
                dAngle_not_dt    : 0B, $
                dx_not_dt        : 0B, $
                for_eSpecDB      : 0B, $
                coords           : 'SDT'}
     END
     KEYWORD_SET(for_swayDB): BEGIN
        dbNavn = 'Strangeway_bands'
        
        info   = dbStruct.info

        STR_ELEMENT,info,'coords','SDT',/ADD_REPLACE
        STR_ELEMENT,info,'DB_Dir',DB_dir,/ADD_REPLACE
        STR_ELEMENT,info,'DB_Date',DB_date,/ADD_REPLACE
        STR_ELEMENT,info,'DB_version',DB_version,/ADD_REPLACE
        STR_ELEMENT,info,'DB_extras',DB_extras,/ADD_REPLACE
        STR_ELEMENT,info,'tag_names',TAG_NAMES_R(dbStruct),/ADD_REPLACE

        STR_ELEMENT,info,'tag_names_l1',TAG_NAMES(dbStruct),/ADD_REPLACE
        tag_names_l2 = LIST()
        FOR k=0,N_ELEMENTS(TAG_NAMES(dbStruct))-1 DO BEGIN

           IF SIZE(dbStruct.(k),/TYPE) EQ 8 THEN BEGIN
              tag_names_l2.Add,TAG_NAMES(dbStruct.(k))
           ENDIF ELSE BEGIN
              tag_names_l2.Add,''
           ENDELSE

        ENDFOR

     END
     ELSE: BEGIN
        dbNavn = 'maximus'
        info  = { $             ;converted        : 0B, $
                ;; is_reduced       : BYTE(KEYWORD_SET(reduce_dbSize)), $
                DB_dir              : '', $
                DB_date             : '', $
                DB_version          : '', $
                DB_extras           : '', $
                DB__into_eSpec_file : '', $
                ;; is_AlfNewell     : BYTE(KEYWORD_SET(is_AlfNewell)), $
                despun              : 0B, $
                is_chastDB          : 0B, $
                using_heavies       : 0B, $
                coords              : 'SDT', $
                rmOutliers          : 0B, $
                corrected_fluxes    : 0B, $
                corrected_string    : '', $
                mapped              : {mag_current : 0B, $
                                       esa_current : 0B, $
                                       pFlux       : 0B, $
                                       ion_flux    : 0B, $
                                       heavies     : 0B, $
                                       width_time  : 0B, $
                                       width_x     : 0B, $
                                       sqrt        : 0B}, $
                dILAT_not_dt        : 0B, $
                dAngle_not_dt       : 0B, $
                dx_not_dt           : 0B}
     END
  ENDCASE

  IF KEYWORD_SET(DB_dir) THEN BEGIN
     info.DB_dir     = DB_dir
  ENDIF

  IF KEYWORD_SET(DB_date) THEN BEGIN
     info.DB_date    = DB_date
  ENDIF

  IF KEYWORD_SET(DB_version) THEN BEGIN
     info.DB_version = DB_version
  ENDIF

  IF KEYWORD_SET(DB_extras) THEN BEGIN
     info.DB_extras  = DB_extras
  ENDIF

  IF KEYWORD_SET(DB__into_eSpec_file) THEN BEGIN
     info.DB__into_eSpec_file  = DB__into_eSpec_file
  ENDIF

  ;;Now see whether to replace or just append the thing
  STR_ELEMENT,dbStruct,"info",INDEX=infoIndex
  CASE 1 OF
     infoIndex LT 0: BEGIN
        dbStruct = CREATE_STRUCT(dbStruct,"info",info)
     END
     KEYWORD_SET(for_swayDB): BEGIN

        STR_ELEMENT,dbStruct,'info',info,/ADD_REPLACE

     END
     ELSE: BEGIN

        ;; STR_ELEMENT,dbStruct.info,'converted',INDEX=convIndex
        ;; IF convIndex LT 0 THEN BEGIN
        ;;    tmpInfo = dbStruct.info
        ;;    tmpInfo = CREATE_STRUCT(TEMPORARY(info),tmpInfo)
        ;;    STR_ELEMENT,dbStruct,'info',TEMPORARY(tmpInfo),/ADD_REPLACE
        ;; ENDIF ELSE BEGIN
        PRINT,dbNavn + " appears to have 'info' already! You may care to inspect."
        STOP
        ;; ENDELSE

     END
  ENDCASE

END
