;;12/02/16
PRO MIMC__REPOPULATE_WITH_STRUCT, $
   MIMC_struct, $
   MINMLT=minM, $
   MAXMLT=maxM, $
   BINM=binM, $
   SHIFTMLT=shiftM, $
   MINILAT=minI, $
   MAXILAT=maxI, $
   BINI=binI, $
   DO_LSHELL=do_lShell, $
   MINLSHELL=minL, $
   MAXLSHELL=maxL, $
   BINL=binL, $
   USE_AACGM_COORDS=use_AACGM, $
   USE_MAG_COORDS=use_MAG, $
   MIN_MAGCURRENT=minMC, $
   MAX_NEGMAGCURRENT=maxNegMC, $
   HEMI=hemi, $
   NORTH=north, $
   SOUTH=south, $
   BOTH_HEMIS=both_hemis

  COMPILE_OPT IDL2

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

  STR_ELEMENT,MIMC_struct,'use_AACGM',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     use_AACGM = MIMC_struct.use_AACGM
  ENDIF

  STR_ELEMENT,MIMC_struct,'use_MAG',INDEX=tmpInd
  IF tmpInd GE 0 THEN BEGIN
     use_MAG = MIMC_struct.use_MAG
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

END
