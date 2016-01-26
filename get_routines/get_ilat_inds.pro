;Made sometime in late 2015
;Mods
;2015/12/03
;Converting all negative ILATs to positive when using HEMI='BOTH'
FUNCTION GET_ILAT_INDS,maximus,minI,maxI,hemi,N_ILAT=n_ilat,N_NOT_ILAT=n_not_ilat,LUN=lun

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun=-1 ;;stdout

  IF N_ELEMENTS(maximus) EQ 0 THEN BEGIN
     PRINTF,lun,"Error! No maximus struct provided!"
     STOP
  ENDIF

  IF STRUPCASE(hemi) EQ "BOTH" THEN BEGIN
     ilat_i=cgsetunion( $
                where(maximus.ilat GE minI AND maximus.ilat LE maxI), $
                where(maximus.ilat GE -ABS(maxI) AND maximus.ilat LE -ABS(minI)))
     n_ilat = N_ELEMENTS(ilat_i)
     n_not_ilat = N_ELEMENTS(maximus.ilat)-n_ilat

     PRINTF,lun,'Hemisphere: Northern AND Southern'
     PRINTF,lun,"Converting negative ILAT values (Southern Hemi) to positive with ABS function..."
     maximus.ilat[ilat_i] = ABS(maximus.ilat[ilat_i])
     ;; PRINT,"STOP: Why were you ever converting negs to pos in the first place?"
     ;; WAIT,2
     ;; STOP
  ENDIF ELSE BEGIN
     IF STRUPCASE(hemi) EQ "SOUTH" THEN BEGIN
        ilat_i=where(maximus.ilat GE minI AND maximus.ilat LE maxI,n_ilat,NCOMPLEMENT=n_not_ILAT)
        PRINTF,lun,'Hemisphere: Southern'
     ENDIF ELSE BEGIN
        IF STRUPCASE(hemi) EQ "NORTH" THEN BEGIN
           ilat_i=where(maximus.ilat GE minI AND maximus.ilat LE maxI,n_ilat,NCOMPLEMENT=n_not_ILAT) 
           PRINTF,lun,'Hemisphere: Northern'
        ENDIF ELSE BEGIN
           PRINTF,lun,"Invalid hemisphere provided! Can't get ILAT indices..."
           STOP
        ENDELSE
     ENDELSE
  ENDELSE

  PRINTF,lun,FORMAT='("N outside ILAT range",T30,":",T35,I0)',n_not_ILAT
  ;; PRINTF,lun,'Losing ' + STRCOMPRESS(n_not_ILAT,/REMOVE_ALL) + ' events due to ILAT restriction'
  PRINTF,lun,''

  RETURN,ilat_i

END