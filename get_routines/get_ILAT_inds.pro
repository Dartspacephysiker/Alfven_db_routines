FUNCTION GET_ILAT_INDS,maximus,minI,maxI,hemi,N_ILAT=n_ilat,N_NOT_ILAT=n_not_ilat,LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun=-1 ;;stdout

  IF N_ELEMENTS(maximus) EQ 0 THEN BEGIN
     PRINTF,lun,"Error! No maximus struct provided!"
     STOP
  ENDIF

  ;; IF STRUPCASE(hemi) EQ "BOTH" THEN BEGIN
  ;;    ind_ilat=cgsetunion( $
  ;;               where(maximus.ilat GE minI AND maximus.ilat LE maxI), $
  ;;               where(maximus.ilat GE -ABS(maxI) AND maximus.ilat LE -ABS(minI)))
  ;;    n_ilat = N_ELEMENTS(ind_ilat)
  ;;    n_not_ilat = N_ELEMENTS(cdbTime)-n_ilat

  ;;    PRINTF,lun,'Hemisphere: Northern AND Southern'
  ;; ENDIF ELSE BEGIN
  ;;    IF STRUPCASE(hemi) EQ "SOUTH" THEN BEGIN
  ;;       ;; ind_ilat=where(maximus.ilat GE -ABS(maxI) AND maximus.ilat LE -ABS(minI) AND maximus.mlt GE minM AND maximus.mlt LE maxM) 
  ;;       ind_ilat=where(maximus.ilat GE -ABS(maxI) AND maximus.ilat LE -ABS(minI),n_ilat,NCOMPLEMENT=n_not_ILAT) 
  ;;       PRINTF,lun,'Hemisphere: Southern'
  ;;    ENDIF ELSE BEGIN
  ;;       IF STRUPCASE(hemi) EQ "NORTH" THEN BEGIN
  ;;          ;; ind_ilat=where(maximus.ilat GE ABS(minI) AND maximus.ilat LE ABS(maxI) AND maximus.mlt GE minM AND maximus.mlt LE maxM) 
  ;;          ind_ilat=where(maximus.ilat GE ABS(minI) AND maximus.ilat LE ABS(maxI),n_ilat,NCOMPLEMENT=n_not_ILAT) 
  ;;          PRINTF,lun,'Hemisphere: Northern'
  ;;       ;; ENDIF ELSE ind_ilat=where(maximus.ilat GE minI AND maximus.ilat LE maxI AND maximus.mlt GE minM AND maximus.mlt LE maxM) 
  ;;       ENDIF ELSE BEGIN
  ;;          ind_ilat=where(maximus.ilat GE minI AND maximus.ilat LE maxI,n_ilat,NCOMPLEMENT=n_not_ILAT)
  ;;       ENDELSE
  ;;    ENDELSE
  ;; ENDELSE

  IF STRUPCASE(hemi) EQ "BOTH" THEN BEGIN
     ind_ilat=cgsetunion( $
                where(maximus.ilat GE minI AND maximus.ilat LE maxI), $
                where(maximus.ilat GE -ABS(maxI) AND maximus.ilat LE -ABS(minI)))
     n_ilat = N_ELEMENTS(ind_ilat)
     n_not_ilat = N_ELEMENTS(cdbTime)-n_ilat

     PRINTF,lun,'Hemisphere: Northern AND Southern'
  ENDIF ELSE BEGIN
     IF STRUPCASE(hemi) EQ "SOUTH" THEN BEGIN
        PRINTF,lun,'Hemisphere: Southern'
        ind_ilat=where(maximus.ilat GE minI AND maximus.ilat LE maxI,n_ilat,NCOMPLEMENT=n_not_ILAT)
     ENDIF ELSE BEGIN
        IF STRUPCASE(hemi) EQ "NORTH" THEN BEGIN
           ind_ilat=where(maximus.ilat GE minI AND maximus.ilat LE maxI,n_ilat,NCOMPLEMENT=n_not_ILAT) 
           PRINTF,lun,'Hemisphere: Northern'
        ENDIF ELSE BEGIN
           PRINTF,lun,"Invalid hemisphere provided! Can't get ILAT indices..."
           STOP
        ENDELSE
     ENDELSE
  ENDELSE

  PRINTF,lun,'Min ILAT: ' + STRCOMPRESS(minI,/REMOVE_ALL)
  PRINTF,lun,'Max ILAT: ' + STRCOMPRESS(maxI,/REMOVE_ALL)
  PRINTF,lun,'Losing ' + STRCOMPRESS(n_not_ILAT,/REMOVE_ALL) + ' events due to ILAT restriction'
  PRINTF,lun,''


  RETURN,ind_ilat

END