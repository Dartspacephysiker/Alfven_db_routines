PRO SET_DEFAULT_MLT_ILAT_AND_MAGC,MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI,MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC,HEMI=hemi,LUN=lun

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; If no provided locations, then don't restrict based on ILAT, MLT
  defMinM     = 0
  defMaxM     = 24
  defBinM     = 1.0

  defHemi     = 'North'
  defMinI     = 50
  defMaxI     = 85
  defBinI     = 2.0

  defMinMC    = 10
  defMaxNegMC = -10

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF N_ELEMENTS(minM) EQ 0 THEN minM=defMinM
  IF N_ELEMENTS(maxM) EQ 0 THEN maxM=defMaxM

  IF N_ELEMENTS(hemi) EQ 0 THEN BEGIN
     hemi = defHemi
     hemi = STRUPCASE(hemi)
     PRINTF,lun,"No hemisphere specified! Set to default: " + hemi + "..."
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

  IF N_ELEMENTS(minMC) EQ 0 THEN minMC = defMinMC                  ; Minimum current derived from mag data, in microA/m^2
  IF N_ELEMENTS(maxNegMC) EQ 0 THEN maxNegMC = defMaxNegMC         ; Current must be less than this, if it's going to make the cut

END