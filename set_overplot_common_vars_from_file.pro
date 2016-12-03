;;12/03/16
PRO SET_OVERPLOT_COMMON_VARS_FROM_FILE,overplot_file

  COMPILE_OPT IDL2

  @common__overplot_vars.pro
  
  RESTORE,overplot_file

  OP__overplot_file         = overplot_file

  IF N_ELEMENTS(dataNameArr) GT 0 THEN BEGIN
     OP__dataNameArr        = TEMPORARY(dataNameArr)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__dataNameArr     = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(H2DStrArr) GT 0 THEN BEGIN
     OP__H2DStrArr         = TEMPORARY(H2DStrArr)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_Vars) THEN BEGIN
        OP__H2DStrArr      = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(H2DMaskArr) GT 0 THEN BEGIN
     OP__H2DMaskArr         = TEMPORARY(H2DMaskArr)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_Vars) THEN BEGIN
        OP__H2DMaskArr      = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(maxM) GT 0 THEN BEGIN
     OP__maxM               = TEMPORARY(maxM)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__maxM            = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(minM) GT 0 THEN BEGIN
     OP__minM               = TEMPORARY(minM)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__minM            = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(maxI) GT 0 THEN BEGIN
     OP__maxI               = TEMPORARY(maxI)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__maxI            = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(minI) GT 0 THEN BEGIN
     OP__minI               = TEMPORARY(minI)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__minI            = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(binM) GT 0 THEN BEGIN
     OP__binM               = TEMPORARY(binM)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__binM            = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(shiftM) GT 0 THEN BEGIN
     OP__shiftM             = TEMPORARY(shiftM)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__shiftM          = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(binI) GT 0 THEN BEGIN
     OP__binI               = TEMPORARY(binI)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__binI            = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(do_lShell) GT 0 THEN BEGIN
     OP__do_lShell          = TEMPORARY(do_lShell)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__do_lShell       = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(reverse_lShell) GT 0 THEN BEGIN
     OP__reverse_lShell     = TEMPORARY(reverse_lShell)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__reverse_lShell  = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(minL) GT 0 THEN BEGIN
     OP__minL               = TEMPORARY(minL)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__minL            = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(maxL) GT 0 THEN BEGIN
     OP__maxL               = TEMPORARY(maxL)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__maxL            = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(binL) GT 0 THEN BEGIN
     OP__binL               = TEMPORARY(binL)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__binL            = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(hemi) GT 0 THEN BEGIN
     OP__hemi               = TEMPORARY(hemi)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__hemi            = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(paramStr) GT 0 THEN BEGIN
     OP__paramStr           = TEMPORARY(paramStr)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__paramStr        = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(rawDir) GT 0 THEN BEGIN
     OP__rawDir             = TEMPORARY(rawDir)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__rawDir          = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(clockStr) GT 0 THEN BEGIN
     OP__clockStr           = TEMPORARY(clockStr)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__clockStr        = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(plotMedOrAvg) GT 0 THEN BEGIN
     OP__plotMedOrAvg       = TEMPORARY(plotMedOrAvg)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__plotMedOrAvg    = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(stableIMF) GT 0 THEN BEGIN
     OP__stableIMF          = TEMPORARY(stableIMF)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__stableIMF       = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(smooth_IMF) GT 0 THEN BEGIN
     OP__smooth_IMF         = TEMPORARY(smooth_IMF)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__smooth_IMF      = !NULL
     ENDIF
  ENDELSE

  IF N_ELEMENTS(hoyDia) GT 0 THEN BEGIN
     OP__hoyDia             = TEMPORARY(hoyDia)
  ENDIF ELSE BEGIN
     IF KEYWORD_SET(clear_unavail_vars) THEN BEGIN
        OP__hoyDia          = !NULL
     ENDIF
  ENDELSE

END
