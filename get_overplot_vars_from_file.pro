;;12/02/16
FUNCTION GET_OVERPLOT_VARS_FROM_FILE,overplot_file
  
  COMPILE_OPT IDL2,STRICTARRSUBS

  RESTORE,overplot_file

  IF N_ELEMENTS(h2dStrArr) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'h2dStrArr',h2dStrArr,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(dataNameArr) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'dataNameArr',dataNameArr,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(H2DMaskArr) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'H2DMaskArr',H2DMaskArr,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(maxM) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'maxM',maxM,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(minM) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'minM',minM,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(maxI) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'maxI',maxI,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(minI) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'minI',minI,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(binM) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'binM',binM,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(shiftM) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'shiftM',shiftM,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(binI) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'binI',binI,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(do_lShell) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'do_lShell',do_lShell,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(reverse_lShell) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'reverse_lShell',reverse_lShell,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(minL) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'minL',minL,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(maxL) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'maxL',maxL,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(binL) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'binL',binL,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(hemi) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'hemi',hemi,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(paramStr) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'paramStr',paramStr,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(rawDir) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'rawDir',rawDir,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(clockStr) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'clockStr',clockStr,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(plotMedOrAvg) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'plotMedOrAvg',plotMedOrAvg,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(stableIMF) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'stableIMF',stableIMF,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(smooth_IMF) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'smooth_IMF',smooth_IMF,/ADD_REPLACE
  ENDIF
  
  IF N_ELEMENTS(hoyDia) GT 0 THEN BEGIN
     STR_ELEMENT,overplotStr,'hoyDia',hoyDia,/ADD_REPLACE
  ENDIF
  
  STR_ELEMENT,overplotStr,'overplot_file',overplot_file,/ADD_REPLACE

  RETURN,overplotStr

END
