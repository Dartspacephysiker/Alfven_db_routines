FUNCTION GET_LSHELL_INDS,maximus,minL,maxL,hemi,N_LSHELL=n_lshell,N_NOT_LSHELL=n_not_lshell,LUN=lun

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun=-1 ;;stdout

  IF N_ELEMENTS(maximus) EQ 0 THEN BEGIN
     PRINTF,lun,"Error! No maximus struct provided!"
     STOP
  ENDIF

  IF STRUPCASE(hemi) EQ "BOTH" THEN BEGIN
     ;; lshell_i=cgsetunion( $
     ;;            where(maximus.lshell GE minL AND maximus.lshell LE maxL), $
     ;;            where(maximus.lshell GE -ABS(maxL) AND maximus.lshell LE -ABS(minL)))
     lshell_i=cgsetunion( $
                where(maximus.lshell GE minL AND maximus.lshell LE maxL AND maximus.ilat GT 0), $
                where(maximus.lshell GE minL AND maximus.lshell LE maxL AND maximus.ilat LT 0))
     n_lshell = N_ELEMENTS(lshell_i)
     n_not_lshell = N_ELEMENTS(cdbTime)-n_lshell

     PRINTF,lun,'Hemisphere: Northern AND Southern'
  ENDIF ELSE BEGIN
     IF STRUPCASE(hemi) EQ "SOUTH" THEN BEGIN
        lshell_i=where(maximus.lshell GE minL AND maximus.lshell LE maxL AND maximus.ilat LT 0,n_lshell,NCOMPLEMENT=n_not_LSHELL)
        ;; PRINTF,lun,'Hemisphere: Southern'
     ENDIF ELSE BEGIN
        IF STRUPCASE(hemi) EQ "NORTH" THEN BEGIN
           lshell_i=where(maximus.lshell GE minL AND maximus.lshell LE maxL AND maximus.ilat GT 0,n_lshell,NCOMPLEMENT=n_not_LSHELL) 
           ;; PRINTF,lun,'Hemisphere: Northern'
        ENDIF ELSE BEGIN
           PRINTF,lun,"Invalid hemisphere provided! Can't get LSHELL indices..."
           STOP
        ENDELSE
     ENDELSE
  ENDELSE

  PRINTF,lun,FORMAT='("N outside ILAT range",T30,":",T35,I0)',n_not_LSHELL
;;  PRINTF,lun,'Losing ' + STRCOMPRESS(n_not_LSHELL,/REMOVE_ALL) + ' events due to LSHELL restriction'
  PRINTF,lun,''

  RETURN,lshell_i

END