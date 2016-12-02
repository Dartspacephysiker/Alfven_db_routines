PRO SET_ALFVEN_STATS_PLOT_LIMS,EPLOTRANGE=EPlotRange, $
                               ENUMFLPLOTRANGE=ENumFlPlotRange, $
                               PPLOTRANGE=PPlotRange, $
                               CHAREPLOTRANGE=charePlotRange, $
                               CHARIEPLOTRANGE=chariEPlotRange, $
                               NEVENTPERMINRANGE=nEventPerMinRange, $
                               NEVENTPERORBRANGE=nEventPerOrbRange, $
                               PROBOCCURRENCERANGE=probOccurrenceRange, $
                               THISTDENOMPLOTRANGE=tHistDenomPlotRange, $
                               NOWEPCO_RANGE=nowepco_range, $
                               ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
                               RESET_STRUCT=reset

  COMPILE_OPT idl2

  defENumFlPlotRange        = [1e5,1e9]

  defEPlotRange             = [0.01,100]

  defPPlotRange             = [1e-4,1e0]

  defChariEPlotRange        = [1e-2,1e1]

  defNEventPerMinRange      = [0,25]


  defNEventPerOrbRange      = [0.01,7]

  defProbOccurrenceRange    = [1e-4,1.0]

  defTHistDenomPlotRange    = [0,60.]

  defNOWEPCORange           = [0,1]

  IF N_ELEMENTS(ENumFlPlotRange) EQ 0 THEN BEGIN   ;;For linear or log e- number flux plotrange

     ENumFlPlotRange = defENumFlPlotRange
  ENDIF

  IF N_ELEMENTS(EPlotRange) EQ 0 THEN BEGIN   ;;For linear or log e- energy Flux plotrange

     EPlotRange = defEPlotRange
  ENDIF

  ;;For linear or log PFlux plotrange
  IF N_ELEMENTS(PPlotRange) EQ 0 THEN BEGIN

     PPlotRange=defPPlotRange
  ENDIF

  IF N_ELEMENTS(charEPlotRange) EQ 0 THEN BEGIN   ;;For linear or log charE plotrange
     charEPlotRange=charERange
  ENDIF


  IF N_ELEMENTS(chariEPlotRange) EQ 0 THEN BEGIN   ;;For linear or log charE plotrange
     chariEPlotRange=defChariEPlotRange
  ENDIF

  IF N_ELEMENTS(nEventPerMinRange) EQ 0 OR $
     (N_ELEMENTS(nEventPerMinRange) MOD 2) NE 0 THEN BEGIN
     nEventPerMinRange = defNEventPerMinRange
  ENDIF
     
  IF N_ELEMENTS(nEventPerOrbRange) EQ 0 OR N_ELEMENTS(nEventPerOrbRange) NE 2 THEN BEGIN
     nEventPerOrbRange = defNEventPerOrbRange
  ENDIF
     
  IF N_ELEMENTS(probOccurrenceRange) EQ 0 OR N_ELEMENTS(probOccurrenceRange) NE 2 THEN BEGIN
     probOccurrenceRange = defProbOccurrenceRange
  ENDIF
     
  IF N_ELEMENTS(tHistDenomPlotRange) EQ 0 OR N_ELEMENTS(tHistDenomPlotRange) NE 2 THEN BEGIN
     tHistDenomPlotRange = defTHistDenomPlotRange
  ENDIF

  IF N_ELEMENTS(nowepco_range) EQ 0 OR N_ELEMENTS(nowepco_range) NE 2 THEN BEGIN
     nowepco_range       = defNOWEPCORange
  ENDIF

  IF ARG_PRESENT(alfDB_plotLim_struct) THEN BEGIN

     IF N_ELEMENTS(alfDB_plotLim_struct) GT 0 AND ~KEYWORD_SET(reset) THEN BEGIN
        PRINT,"Already have an alfDB_plotLim_struct! Returning ..."
        RETURN
     ENDIF

     IF KEYWORD_SET(EPlotRange) THEN BEGIN
        STR_ELEMENT,alfDB_plotLim_struct,EPlotRange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(ENumFlPlotRange) THEN BEGIN
        STR_ELEMENT,alfDB_plotLim_struct,ENumFlPlotRange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(PPlotRange) THEN BEGIN
        STR_ELEMENT,alfDB_plotLim_struct,PPlotRange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(charePlotRange) THEN BEGIN
        STR_ELEMENT,alfDB_plotLim_struct,charePlotRange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(charERange) THEN BEGIN
        STR_ELEMENT,alfDB_plotLim_struct,charERange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(chariEPlotRange) THEN BEGIN
        STR_ELEMENT,alfDB_plotLim_struct,chariEPlotRange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(nEventPerMinRange) THEN BEGIN
        STR_ELEMENT,alfDB_plotLim_struct,nEventPerMinRange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(nEventPerOrbRange) THEN BEGIN
        STR_ELEMENT,alfDB_plotLim_struct,nEventPerOrbRange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(probOccurrenceRange) THEN BEGIN
        STR_ELEMENT,alfDB_plotLim_struct,probOccurrenceRange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(tHistDenomPlotRange) THEN BEGIN
        STR_ELEMENT,alfDB_plotLim_struct,tHistDenomPlotRange,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(nowepco_range) THEN BEGIN
        STR_ELEMENT,alfDB_plotLim_struct,nowepco_range,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(alfDB_plotLim_struct) THEN BEGIN
        STR_ELEMENT,alfDB_plotLim_struct,alfDB_plotLim_struct,/ADD_REPLACE
     ENDIF
     
  ENDIF

END