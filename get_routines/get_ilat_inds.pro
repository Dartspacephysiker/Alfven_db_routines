FUNCTION GET_ILAT_INDS,maximus,minI,maxI,hemi,N_ILAT=n_ilat,N_NOT_ILAT=n_not_ilat,LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun=-1 ;;stdout

  IF N_ELEMENTS(maximus) EQ 0 THEN BEGIN
     PRINTF,lun,"Error! No maximus struct provided!"
     STOP
  ENDIF

  ;; IF STRUPCASE(hemi) EQ "BOTH" THEN BEGIN
  ;;    ilat_i=cgsetunion( $
  ;;               where(maximus.ilat GE minI AND maximus.ilat LE maxI), $
  ;;               where(maximus.ilat GE -ABS(maxI) AND maximus.ilat LE -ABS(minI)))
  ;;    n_ilat = N_ELEMENTS(ilat_i)
  ;;    n_not_ilat = N_ELEMENTS(cdbTime)-n_ilat

  ;;    PRINTF,lun,'Hemisphere: Northern AND Southern'
  ;; ENDIF ELSE BEGIN
  ;;    IF STRUPCASE(hemi) EQ "SOUTH" THEN BEGIN
  ;;       ;; ilat_i=where(maximus.ilat GE -ABS(maxI) AND maximus.ilat LE -ABS(minI) AND maximus.mlt GE minM AND maximus.mlt LE maxM) 
  ;;       ilat_i=where(maximus.ilat GE -ABS(maxI) AND maximus.ilat LE -ABS(minI),n_ilat,NCOMPLEMENT=n_not_ILAT) 
  ;;       PRINTF,lun,'Hemisphere: Southern'
  ;;    ENDIF ELSE BEGIN
  ;;       IF STRUPCASE(hemi) EQ "NORTH" THEN BEGIN
  ;;          ;; ilat_i=where(maximus.ilat GE ABS(minI) AND maximus.ilat LE ABS(maxI) AND maximus.mlt GE minM AND maximus.mlt LE maxM) 
  ;;          ilat_i=where(maximus.ilat GE ABS(minI) AND maximus.ilat LE ABS(maxI),n_ilat,NCOMPLEMENT=n_not_ILAT) 
  ;;          PRINTF,lun,'Hemisphere: Northern'
  ;;       ;; ENDIF ELSE ilat_i=where(maximus.ilat GE minI AND maximus.ilat LE maxI AND maximus.mlt GE minM AND maximus.mlt LE maxM) 
  ;;       ENDIF ELSE BEGIN
  ;;          ilat_i=where(maximus.ilat GE minI AND maximus.ilat LE maxI,n_ilat,NCOMPLEMENT=n_not_ILAT)
  ;;       ENDELSE
  ;;    ENDELSE
  ;; ENDELSE

  IF STRUPCASE(hemi) EQ "BOTH" THEN BEGIN
     ilat_i=cgsetunion( $
                where(maximus.ilat GE minI AND maximus.ilat LE maxI), $
                where(maximus.ilat GE -ABS(maxI) AND maximus.ilat LE -ABS(minI)))
     n_ilat = N_ELEMENTS(ilat_i)
     n_not_ilat = N_ELEMENTS(cdbTime)-n_ilat

     PRINTF,lun,'Hemisphere: Northern AND Southern'
  ENDIF ELSE BEGIN
     IF STRUPCASE(hemi) EQ "SOUTH" THEN BEGIN
        ilat_i=where(maximus.ilat GE minI AND maximus.ilat LE maxI,n_ilat,NCOMPLEMENT=n_not_ILAT)
        ;; PRINTF,lun,'Hemisphere: Southern'
     ENDIF ELSE BEGIN
        IF STRUPCASE(hemi) EQ "NORTH" THEN BEGIN
           ilat_i=where(maximus.ilat GE minI AND maximus.ilat LE maxI,n_ilat,NCOMPLEMENT=n_not_ILAT) 
           ;; PRINTF,lun,'Hemisphere: Northern'
        ENDIF ELSE BEGIN
           PRINTF,lun,"Invalid hemisphere provided! Can't get ILAT indices..."
           STOP
        ENDELSE
     ENDELSE
  ENDELSE

  PRINTF,lun,'Losing ' + STRCOMPRESS(n_not_ILAT,/REMOVE_ALL) + ' events due to ILAT restriction'
  PRINTF,lun,''

  RETURN,ilat_i

END