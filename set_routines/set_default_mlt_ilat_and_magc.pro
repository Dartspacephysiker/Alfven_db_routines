;2015/01/01 Added NORTH, SOUTH, BOTH_HEMIS keywords
PRO SET_DEFAULT_MLT_ILAT_AND_MAGC,MINMLT=minM, $
                                  MAXMLT=maxM, $
                                  BINM=binM, $
                                  SHIFTMLT=shiftM, $
                                  MINILAT=minI, $
                                  MAXILAT=maxI, $
                                  BINI=binI, $
                                  SHIFTILAT=shiftI, $
                                  DONT_CORRECT_ILATS=dont_correct_ilats, $
                                  DO_LSHELL=do_lShell, $
                                  MINLSHELL=minL, $
                                  MAXLSHELL=maxL, $
                                  BINL=binL, $
                                  REVERSE_LSHELL=reverse_lShell, $
                                  COORDINATE_SYSTEM=coordinate_system, $
                                  USE_AACGM_COORDS=use_AACGM, $
                                  USE_MAG_COORDS=use_MAG, $
                                  USE_GEO_COORDS=use_GEO, $
                                  USE_SDT_COORDS=use_SDT, $
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
                                  SHIFTILAT=shiftI, $
                                  DO_LSHELL=do_lShell, $
                                  MINLSHELL=minL, $
                                  MAXLSHELL=maxL, $
                                  BINL=binL, $
                                  REVERSE_LSHELL=reverse_lShell, $
                                  COORDINATE_SYSTEM=coordinate_system, $
                                  USE_AACGM_COORDS=use_AACGM, $
                                  USE_MAG_COORDS=use_MAG, $
                                  USE_GEO_COORDS=use_GEO, $
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
  defMaxI     = 90
  defBinI     = 2.5
  defShiftI   = 0.0

  ;; defMinL     = (cos(defMinI*!PI/180.))^(-2)
  ;; defMaxL     = (cos(defMaxI*!PI/180.))^(-2)
  defMinL     = 2.5      ;50.768 ILAT
  defMaxL     = 16       ;77.079 ILAT
  defBinL     = 1.0

  defMinMC    = 10
  defMaxNegMC = -10

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  ;;Handle MLTs
  IF N_ELEMENTS(minM   ) EQ 0 THEN minM   = defMinM
  IF N_ELEMENTS(maxM   ) EQ 0 THEN maxM   = defMaxM
  IF N_ELEMENTS(binM   ) EQ 0 THEN binM   = defBinM
  IF N_ELEMENTS(shiftM ) EQ 0 THEN shiftM = defShiftM
  IF N_ELEMENTS(shiftI ) EQ 0 THEN shiftI = defShiftI

  ;;Handle ILATs
  IF N_ELEMENTS(hemi) EQ 0 THEN BEGIN
     IF KEYWORD_SET(both_hemis) THEN BEGIN
        PRINTF,lun,"hemi set to 'BOTH' via keyword /BOTH_HEMIS"
        hemi        = "BOTH"
     ENDIF ELSE BEGIN
        IF KEYWORD_SET(north) THEN BEGIN
           PRINTF,lun,"hemi set to 'NORTH' via keyword /NORTH"
           hemi     = "NORTH"
        ENDIF ELSE BEGIN
           IF KEYWORD_SET(south) THEN BEGIN
              PRINTF,lun,"hemi set to 'SOUTH' via keyword /SOUTH"
              hemi="SOUTH"
           ENDIF ELSE BEGIN
              hemi  = defHemi
              hemi  = STRUPCASE(hemi)
              PRINTF,lun,"No hemisphere specified! Set to default: " + hemi + "..."
           ENDELSE
        ENDELSE
     ENDELSE
  ENDIF ELSE BEGIN
     hemi           = STRUPCASE(hemi)
  ENDELSE
  
  IF ( (STRUPCASE(hemi) NE "NORTH") AND $
       (STRUPCASE(hemi) NE "SOUTH") AND $
       (STRUPCASE(hemi) NE "BOTH" ) )   $
  THEN BEGIN
     PRINTF,lun,"Invalid hemisphere name provided! Should be 'North' or 'South'."
     PRINTF,lun,"Defaulting to 'North'."
     hemi           = "North"
  ENDIF

  CASE 1 OF
     STRUPCASE(hemi) EQ "NORTH": BEGIN
        IF N_ELEMENTS(minI)       EQ 0 THEN minI  = defMinI
        IF N_ELEMENTS(maxI)       EQ 0 THEN maxI  = defMaxI

        ;;Flip things if they're lacking sense
        IF minI LT 0 THEN minI *= -1.
        IF maxI LT 0 THEN maxI *= -1.
     END
     STRUPCASE(hemi) EQ "SOUTH": BEGIN
        IF N_ELEMENTS(minI)    EQ 0 THEN minI  = -defMaxI
        IF N_ELEMENTS(maxI)    EQ 0 THEN maxI  = -defMinI

        ;;Flip things if they're lacking sense
        IF minI GT 0 THEN minI *= -1.
        IF maxI GT 0 THEN maxI *= -1.
     END
     STRUPCASE(hemi) EQ "BOTH": BEGIN     ;;Other routines will handle this situation
        IF N_ELEMENTS(minI) EQ 0 THEN minI  = defMinI
        IF N_ELEMENTS(maxI) EQ 0 THEN maxI  = defMaxI

        ;;Flip things if they're lacking sense
        IF minI LT 0 THEN minI *= -1.
        IF maxI LT 0 THEN maxI *= -1.
     END
  ENDCASE

  ;;Fix 'em
  IF minI GT maxI THEN BEGIN
     tmp  = maxI
     maxI = minI
     minI = TEMPORARY(tmp)
  ENDIF

  IF N_ELEMENTS(binI) EQ 0 THEN binI = defBinI

  ;;min/maxM to 1/20 precision
  minM = FLOOR(minM*20.0)*0.05
  maxM = FLOOR(maxM*20.0)*0.05

  ;;min/maxI to 1/4 precision
  minI = FLOOR(minI*4.0D)*0.25D
  maxI = FLOOR(maxI*4.0D)*0.25D

  ;;Handle L-shells
  IF N_ELEMENTS(minL) EQ 0 THEN minL = defMinL
  IF N_ELEMENTS(maxL) EQ 0 THEN maxL = defMaxL
  IF N_ELEMENTS(binL) EQ 0 THEN binL = defBinL

  ;;Handle mag current
  IF N_ELEMENTS(minMC   ) EQ 0 THEN minMC    = defMinMC    ; Minimum current derived from mag data, in microA/m^2
  IF N_ELEMENTS(maxNegMC) EQ 0 THEN maxNegMC = defMaxNegMC ; Current must be less than this, if it's going to make the cut

  ;;Make struct
  IF ARG_PRESENT(MIMC_struct) THEN BEGIN

     IF N_ELEMENTS(MIMC_struct) GT 0 THEN BEGIN
        PRINT,"Already have MIMC struct! Not refilling ..."
        RETURN
     ENDIF

     ;; MIMC_struct = BLANK_MIMC_STRUCT()
     MIMC_struct = { $
                   dont_correct_ilats  : 0B    , $
                   do_lShell           : 0B    , $
                   reverse_Lshell      : 0B    , $
                   coordinate_system   : 'SDT' , $
                   use_AACGM           : 0B    , $
                   use_MAG             : 0B    , $
                   use_GEO             : 0B    , $
                   use_SDT             : 0B    , $
                   north               : 0B    , $
                   south               : 0B    , $
                   both_hemis          : 0B    , $
                   dayside             : 0B    , $
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

     IF N_ELEMENTS(shiftI) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'shiftI',shiftI,/ADD_REPLACE
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

     IF N_ELEMENTS(reverse_Lshell) GT 0 THEN BEGIN
        STR_ELEMENT,MIMC_struct,'reverse_Lshell',reverse_Lshell,/ADD_REPLACE
     ENDIF

     IF KEYWORD_SET(coordinate_system) THEN BEGIN
        CASE STRUPCASE(coordinate_system) OF
           'AACGM': BEGIN
              use_AACGM = 1
              use_GEO   = 0
              use_MAG   = 0
              use_SDT   = 0
           END
           'GEO'  : BEGIN
              use_AACGM = 0
              use_MAG   = 0
              use_GEO   = 1
              use_SDT   = 0
           END
           'MAG'  : BEGIN
              use_AACGM = 0
              use_MAG   = 1
              use_GEO   = 0
              use_SDT   = 0
           END
           ELSE: BEGIN
              use_AACGM = 0
              use_MAG   = 0
              use_GEO   = 0
              use_SDT   = 1
           END
        ENDCASE
     ENDIF

     IF KEYWORD_SET(use_AACGM) THEN BEGIN
        STR_ELEMENT,MIMC_struct,'use_AACGM',use_AACGM,/ADD_REPLACE
        coordinate_system             = 'AACGM'
        MIMC_struct.coordinate_system = coordinate_system
     ENDIF

     IF KEYWORD_SET(use_MAG) THEN BEGIN
        STR_ELEMENT,MIMC_struct,'use_MAG',use_MAG,/ADD_REPLACE
        coordinate_system             = 'MAG'
        MIMC_struct.coordinate_system = coordinate_system
     ENDIF

     IF KEYWORD_SET(use_GEO) THEN BEGIN
        STR_ELEMENT,MIMC_struct,'use_GEO',use_GEO,/ADD_REPLACE
        coordinate_system             = 'GEO'
        MIMC_struct.coordinate_system = coordinate_system
     ENDIF

     IF KEYWORD_SET(use_GEO) THEN BEGIN
        STR_ELEMENT,MIMC_struct,'use_SDT',use_SDT,/ADD_REPLACE
        coordinate_system             = 'SDT'
        MIMC_struct.coordinate_system = coordinate_system
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