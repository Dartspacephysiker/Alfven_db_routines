;2015/01/01 Added NORTH, SOUTH, BOTH_HEMIS keywords
PRO SET_DEFAULT_MLT_ILAT_AND_MAGC,MINMLT=minM, $
                                  MAXMLT=maxM, $
                                  BINM=binM, $
                                  SHIFTMLT=shiftM, $
                                  MINILAT=minI, $
                                  MAXILAT=maxI, $
                                  BINI=binI, $
                                  DONT_CORRECT_ILATS=dont_correct_ilats, $
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
                                  BOTH_HEMIS=both_hemis, $
                                  DAYSIDE=dayside, $
                                  NIGHTSIDE=nightside, $
                                  MIMC_STRUCT=MIMC_struct, $
                                  LUN=lun

  COMPILE_OPT idl2

  IF N_ELEMENTS(MIMC_struct) GT 0 THEN BEGIN
     PRINT,'Repopulating MLT/ILAT/MAGC variables using MIMC struct ...'
     MIMC__REPOPULATE_WITH_STRUCT,MIMC_struct, $
                                  MINMLT=minM,MAXMLT=maxM, $
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
                                  MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                                  HEMI=hemi, $
                                  NORTH=north, $
                                  SOUTH=south, $
                                  BOTH_HEMIS=both_hemis, $
                                  DAYSIDE=dayside, $
                                  NIGHTSIDE=nightside

                                 
  ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; If no provided locations, then don't restrict based on ILAT, MLT
  defMinM     = 0
  defMaxM     = 24
  defBinM     = 1.0
  defShiftM   = 0.0

  defHemi     = 'North'
  defMinI     = 60
  defMaxI     = 85
  defBinI     = 2.5

  ;; defMinL     = (cos(defMinI*!PI/180.))^(-2)
  ;; defMaxL     = (cos(defMaxI*!PI/180.))^(-2)
  defMinL     = 2.5      ;50.768 ILAT
  defMaxL     = 16       ;77.079 ILAT
  defBinL     = 1.0

  defMinMC    = 10
  defMaxNegMC = -10

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  ;;Handle MLTs
  IF N_ELEMENTS(minM) EQ 0 THEN minM=defMinM
  IF N_ELEMENTS(maxM) EQ 0 THEN maxM=defMaxM
  IF N_ELEMENTS(binM) EQ 0 THEN binM=defBinM
  IF N_ELEMENTS(shiftM) EQ 0 THEN shiftM=defShiftM
  minM=FLOOR(minM*20.0)*0.05  ;to 1/20 precision
  maxM=FLOOR(maxM*20.0)*0.05

  ;;Handle ILATs
  IF N_ELEMENTS(hemi) EQ 0 THEN BEGIN
     IF KEYWORD_SET(both_hemis) THEN BEGIN
        PRINTF,lun,"hemi set to 'BOTH' via keyword /BOTH_HEMIS"
        hemi="BOTH"
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(north) THEN BEGIN
           PRINTF,lun,"hemi set to 'NORTH' via keyword /NORTH"
           hemi="NORTH"
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(south) THEN BEGIN
              PRINTF,lun,"hemi set to 'SOUTH' via keyword /SOUTH"
              hemi="SOUTH"
           ENDIF ELSE BEGIN
              hemi = defHemi
              hemi = STRUPCASE(hemi)
              PRINTF,lun,"No hemisphere specified! Set to default: " + hemi + "..."
           ENDELSE
        ENDELSE
     ENDELSE
  ENDIF ELSE BEGIN
     hemi = STRUPCASE(hemi)
  ENDELSE
  
  IF STRUPCASE(hemi) EQ "NORTH" THEN BEGIN
     IF N_ELEMENTS(minI) EQ 0 THEN minI = defMinI
     IF N_ELEMENTS(maxI) EQ 0 THEN maxI = defMaxI
  ENDIF ELSE BEGIN
     IF STRUPCASE(hemi) EQ "SOUTH" THEN BEGIN
        IF N_ELEMENTS(minI) EQ 0 THEN minI = -defMaxI
        IF N_ELEMENTS(maxI) EQ 0 THEN maxI = -defMinI
     ENDIF ELSE BEGIN
        IF STRUPCASE(hemi) EQ "BOTH" THEN BEGIN     ;;Other routines will handle this situation
           IF N_ELEMENTS(minI) EQ 0 THEN minI = defMinI
           IF N_ELEMENTS(maxI) EQ 0 THEN maxI = defMaxI
        ENDIF ELSE BEGIN
           PRINTF,lun,"Invalid hemisphere name provided! Should be 'North' or 'South'."
           PRINTF,lun,"Defaulting to 'North'."
           hemi="North"
           STOP
        ENDELSE
     ENDELSE
  ENDELSE
  IF N_ELEMENTS(binI) EQ 0 THEN binI = defBinI

  minI = FLOOR(minI*4.0D)*0.25D
  maxI = FLOOR(maxI*4.0D)*0.25D

  ;;Handle L-shells
  IF N_ELEMENTS(minL) EQ 0 THEN minL=defMinL
  IF N_ELEMENTS(maxL) EQ 0 THEN maxL=defMaxL
  IF N_ELEMENTS(binL) EQ 0 THEN binL=defBinL

  ;;Handle mag current
  IF N_ELEMENTS(minMC) EQ 0 THEN minMC = defMinMC                  ; Minimum current derived from mag data, in microA/m^2
  IF N_ELEMENTS(maxNegMC) EQ 0 THEN maxNegMC = defMaxNegMC         ; Current must be less than this, if it's going to make the cut

  IF ARG_PRESENT(MIMC_struct) THEN BEGIN

     IF N_ELEMENTS(MIMC_struct) GT 0 THEN BEGIN
        PRINT,"Already have MIMC struct! Not refilling ..."
        RETURN
     ENDIF

     ;; MIMC_struct = BLANK_MIMC_STRUCT()
     MIMC_struct = { $
                   dont_correct_ilats  : 0B, $
                   do_lShell           : 0B, $
                   use_AACGM           : 0B, $
                   use_MAG             : 0B, $
                   north               : 0B, $
                   south               : 0B, $
                   both_hemis          : 0B, $
                   dayside             : 0B, $
                   nightside           : 0B  }

     IF N_ELEMENTS(minM) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'minM',minM,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(maxM) THEN BEGIN
        STR_ELEMENT,MIMC_struct,'maxM',maxM,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(binM) THEN BEGIN
        STR_ELEMENT,MIMC_struct,'binM',binM,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(shiftM) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'shiftM',shiftM,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(minI) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'minI',minI,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(maxI) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'maxI',maxI,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(binI) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'binI',binI,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(dont_correct_ilats) THEN BEGIN
        STR_ELEMENT,MIMC_struct,'dont_correct_ilats',dont_correct_ilats,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(do_lShell) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'do_lShell',do_lShell,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(minL) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'minL',minL,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(maxL) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'maxL',maxL,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(binL) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'binL',binL,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(use_AACGM) THEN BEGIN
        STR_ELEMENT,MIMC_struct,'use_AACGM',use_AACGM,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(use_MAG) THEN BEGIN
        STR_ELEMENT,MIMC_struct,'use_MAG',use_MAG,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(minMC) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'minMC',minMC,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(maxNegMC) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'maxNegMC',maxNegMC,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(hemi) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'hemi',hemi,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(north) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'north',north,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(south) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'south',south,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(both_hemis) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'both_hemis',both_hemis,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(dayside) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'dayside',dayside,/ADD_REPLACE
     ENDIF

     IF N_ELEMENTS(nightside) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'nightside',nightside,/ADD_REPLACE
     ENDIF

  ENDIF

END