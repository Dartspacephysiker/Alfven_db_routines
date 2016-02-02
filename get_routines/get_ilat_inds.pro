;Made sometime in late 2015
;Mods
;2015/12/03
;Converting all negative ILATs to positive when using HEMI='BOTH'
;
;2016/02/02  Made it possible to just directly provide an array of latitudes, since I'm attempting this e-POP conjunctive
;            thing with Kristina
FUNCTION GET_ILAT_INDS,maximus,minI,maxI,hemi, $
                       N_ILAT=n_ilat, $
                       N_NOT_ILAT=n_not_ilat, $
                       DIRECT_LATITUDES=direct_lats, $
                       LUN=lun

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun=-1 ;;stdout

  IF N_ELEMENTS(maximus) EQ 0 THEN BEGIN
     IF ~KEYWORD_SET(direct_lats) THEN BEGIN
        PRINTF,lun,"Error! No maximus struct provided!"
        STOP
     ENDIF ELSE BEGIN
        PRINTF,lun,'Using direct latitudes provided by user...'
        lats                     = direct_lats
     ENDELSE
  ENDIF ELSE BEGIN
     lats                        = maximus.ilat
  ENDELSE

  IF STRUPCASE(hemi) EQ "BOTH" THEN BEGIN
     ilat_i=cgsetunion( $
                where(lats GE minI AND lats LE maxI), $
                where(lats GE -ABS(maxI) AND lats LE -ABS(minI)))
     n_ilat = N_ELEMENTS(ilat_i)
     n_not_ilat = N_ELEMENTS(lats)-n_ilat

     PRINTF,lun,'Hemisphere: Northern AND Southern'
     PRINTF,lun,"Converting negative ILAT values (Southern Hemi) to positive with ABS function..."
     lats[ilat_i] = ABS(lats[ilat_i])
     ;; PRINT,"STOP: Why were you ever converting negs to pos in the first place?"
     ;; WAIT,2
     ;; STOP
  ENDIF ELSE BEGIN
     IF STRUPCASE(hemi) EQ "SOUTH" THEN BEGIN
        ilat_i=where(lats GE minI AND lats LE maxI,n_ilat,NCOMPLEMENT=n_not_ILAT)
        PRINTF,lun,'Hemisphere: Southern'
     ENDIF ELSE BEGIN
        IF STRUPCASE(hemi) EQ "NORTH" THEN BEGIN
           ilat_i=where(lats GE minI AND lats LE maxI,n_ilat,NCOMPLEMENT=n_not_ILAT) 
           PRINTF,lun,'Hemisphere: Northern'
        ENDIF ELSE BEGIN
           PRINTF,lun,"Invalid hemisphere provided! Can't get ILAT indices..."
           STOP
        ENDELSE
     ENDELSE
  ENDELSE

  IF ilat_i[0] EQ -1 THEN BEGIN
     PRINTF,lun,'No ILAT entries found for the specified ILAT range!'
     STOP
  ENDIF

  PRINTF,lun,FORMAT='("N outside ILAT range",T30,":",T35,I0)',n_not_ILAT
  ;; PRINTF,lun,'Losing ' + STRCOMPRESS(n_not_ILAT,/REMOVE_ALL) + ' events due to ILAT restriction'
  PRINTF,lun,''

  RETURN,ilat_i

END