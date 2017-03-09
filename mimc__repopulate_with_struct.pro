;;12/02/16
PRO MIMC__REPOPULATE_WITH_STRUCT, $
   MIMC_struct, $
   MINMLT=minM, $
   MAXMLT=maxM, $
   BINM=binM, $
   SHIFTMLT=shiftM, $
   USE_LNG=use_lng, $
   MINLNG=minLng, $
   MAXLNG=maxLng, $
   BINLNG=binLng, $
   MINILAT=minI, $
   MAXILAT=maxI, $
   BINI=binI, $
   SHIFTILAT=shiftI, $
   DO_LSHELL=do_lShell, $
   MINLSHELL=minL, $
   MAXLSHELL=maxL, $
   BINL=binL, $
   REVERSE_LSHELL=reverse_lShell, $
   COORDINATE_SYSTEM=coordinate_system, $
   USE_AACGM_COORDS=use_AACGM, $
   USE_GEI_COORDS=use_GEI, $
   USE_GEO_COORDS=use_GEO, $
   USE_MAG_COORDS=use_MAG, $
   USE_SDT_COORDS=use_SDT, $
   MIN_MAGCURRENT=minMC, $
   MAX_NEGMAGCURRENT=maxNegMC, $
   HEMI=hemi, $
   NORTH=north, $
   SOUTH=south, $
   BOTH_HEMIS=both_hemis, $
   DAYSIDE=dayside, $
   NIGHTSIDE=nightside

  COMPILE_OPT IDL2,STRICTARRSUBS

  STR_ELEMENT,MIMC_struct,'minM',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     minM = MIMC_struct.minM
  ENDIF

  STR_ELEMENT,MIMC_struct,'maxM',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     maxM = MIMC_struct.maxM
  ENDIF

  STR_ELEMENT,MIMC_struct,'binM',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     binM = MIMC_struct.binM
  ENDIF

  STR_ELEMENT,MIMC_struct,'shiftM',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     shiftM = MIMC_struct.shiftM
  ENDIF

  STR_ELEMENT,MIMC_struct,'use_lng',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     use_lng = MIMC_struct.use_lng
  ENDIF

  STR_ELEMENT,MIMC_struct,'minLng',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     minLng = MIMC_struct.minLng
  ENDIF

  STR_ELEMENT,MIMC_struct,'maxLng',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     maxLng = MIMC_struct.maxLng
  ENDIF

  STR_ELEMENT,MIMC_struct,'binLng',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     binLng = MIMC_struct.binLng
  ENDIF

  STR_ELEMENT,MIMC_struct,'minI',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     minI = MIMC_struct.minI
  ENDIF

  STR_ELEMENT,MIMC_struct,'maxI',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     maxI = MIMC_struct.maxI
  ENDIF

  STR_ELEMENT,MIMC_struct,'binI',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     binI = MIMC_struct.binI
  ENDIF

  STR_ELEMENT,MIMC_struct,'shiftI',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     shiftI = MIMC_struct.shiftI
  ENDIF

  STR_ELEMENT,MIMC_struct,'do_lShell',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     do_lShell = MIMC_struct.do_lShell
  ENDIF

  STR_ELEMENT,MIMC_struct,'minL',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     minL = MIMC_struct.minL
  ENDIF

  STR_ELEMENT,MIMC_struct,'maxL',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     maxL = MIMC_struct.maxL
  ENDIF

  STR_ELEMENT,MIMC_struct,'binL',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     binL = MIMC_struct.binL
  ENDIF

  STR_ELEMENT,MIMC_struct,'reverse_Lshell',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     reverse_Lshell = MIMC_struct.reverse_Lshell
  ENDIF

  STR_ELEMENT,MIMC_struct,'coordinate_system',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     coordinate_system = MIMC_struct.coordinate_system
  ENDIF

  STR_ELEMENT,MIMC_struct,'use_AACGM',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     use_AACGM = MIMC_struct.use_AACGM
  ENDIF

  STR_ELEMENT,MIMC_struct,'use_GEI',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     use_GEI = MIMC_struct.use_GEI
  ENDIF

  STR_ELEMENT,MIMC_struct,'use_GEO',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     use_GEO = MIMC_struct.use_GEO
  ENDIF

  STR_ELEMENT,MIMC_struct,'use_MAG',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     use_MAG = MIMC_struct.use_MAG
  ENDIF

  STR_ELEMENT,MIMC_struct,'use_SDT',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     use_SDT = MIMC_struct.use_SDT
  ENDIF

  STR_ELEMENT,MIMC_struct,'minMC',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     minMC = MIMC_struct.minMC
  ENDIF

  STR_ELEMENT,MIMC_struct,'maxNegMC',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     maxNegMC = MIMC_struct.maxNegMC
  ENDIF

  STR_ELEMENT,MIMC_struct,'hemi',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     hemi = MIMC_struct.hemi
  ENDIF

  STR_ELEMENT,MIMC_struct,'north',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     north = MIMC_struct.north
  ENDIF

  STR_ELEMENT,MIMC_struct,'south',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     south = MIMC_struct.south
  ENDIF

  STR_ELEMENT,MIMC_struct,'both_hemis',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     both_hemis = MIMC_struct.both_hemis
  ENDIF

  STR_ELEMENT,MIMC_struct,'globe',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     globe = MIMC_struct.globe
  ENDIF

  STR_ELEMENT,MIMC_struct,'dayside',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     dayside = MIMC_struct.dayside
  ENDIF

  STR_ELEMENT,MIMC_struct,'nightside',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     nightside = MIMC_struct.nightside
  ENDIF

END
