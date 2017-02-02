;;11/25/16
PRO FASTDB__ADD_INFO_STRUCT,dbStruct, $
                            FOR_ALFDB=for_alfDB, $
                            FOR_FASTLOC=for_fastLoc, $
                            DB_DIR=DB_dir, $
                            DB_DATE=DB_date, $
                            DB_VERSION=DB_version, $
                            DB_EXTRAS=DB_extras ;, $
  ;; REDUCE_DBSIZE=reduce_dbSize, $
  ;; IS_ALFNEWELL=is_AlfNewell


  COMPILE_OPT IDL2

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
     ELSE: BEGIN
        dbNavn = 'maximus'
        info  = { $             ;converted        : 0B, $
                ;; is_reduced       : BYTE(KEYWORD_SET(reduce_dbSize)), $
                DB_dir           : '', $
                DB_date          : '', $
                DB_version       : '', $
                DB_extras        : '', $
                ;; is_AlfNewell     : BYTE(KEYWORD_SET(is_AlfNewell)), $
                despun           : 0B, $
                is_chastDB       : 0B, $
                using_heavies    : 0B, $
                coords           : 'SDT', $
                rmOutliers       : 0B, $
                corrected_fluxes : 0B, $
                corrected_string : '', $
                mapped           : {mag_current : 0B, $
                                    esa_current : 0B, $
                                    pFlux       : 0B, $
                                    ion_flux    : 0B, $
                                    heavies     : 0B, $
                                    width_time  : 0B, $
                                    width_x     : 0B, $
                                    sqrt        : 0B}, $
                dILAT_not_dt     : 0B, $
                dAngle_not_dt    : 0B, $
                dx_not_dt        : 0B}
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

  ;;Now see whether to replace or just append the thing
  STR_ELEMENT,dbStruct,"info",INDEX=infoIndex
  IF infoIndex LT 0 THEN BEGIN
     dbStruct = CREATE_STRUCT(dbStruct,"info",info)
  ENDIF ELSE BEGIN
     ;; STR_ELEMENT,dbStruct.info,'converted',INDEX=convIndex
     ;; IF convIndex LT 0 THEN BEGIN
     ;;    tmpInfo = dbStruct.info
     ;;    tmpInfo = CREATE_STRUCT(TEMPORARY(info),tmpInfo)
     ;;    STR_ELEMENT,dbStruct,'info',TEMPORARY(tmpInfo),/ADD_REPLACE
     ;; ENDIF ELSE BEGIN
     PRINT,dbNavn + " appears to have 'info' already! You may care to inspect."
     STOP
     ;; ENDELSE
  ENDELSE

END
