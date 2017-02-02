FUNCTION GET_LSHELL_INDS,maximus, $
                         minL, $
                         maxL, $
                         hemi, $
                         N_LSHELL=n_lshell, $
                         N_NOT_LSHELL=n_not_lshell, $
                         LUN=lun

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun=-1 ;;stdout

  IF N_ELEMENTS(maximus) EQ 0 THEN BEGIN
     PRINTF,lun,"Error! No maximus struct provided!"
     STOP
  ENDIF

  CASE 1 OF
     STRUPCASE(hemi) EQ "NORTH": BEGIN
        lshell_i=where(maximus.lshell GE minL AND $
                       maximus.lshell LE maxL AND $
                       maximus.ilat GT 0, $
                       n_lshell, $
                       NCOMPLEMENT=n_not_LSHELL) 
        PRINTF,lun,'Hemisphere: Northern'
     END
     STRUPCASE(hemi) EQ "SOUTH": BEGIN
        lshell_i=where(maximus.lshell GE minL AND $
                       maximus.lshell LE maxL AND $
                       maximus.ilat LT 0, $
                       n_lshell, $
                       NCOMPLEMENT=n_not_LSHELL)
        PRINTF,lun,'Hemisphere: Southern'
     END
     STRUPCASE(hemi) EQ "BOTH": BEGIN
        lshell_i=cgsetunion( $
                 where(maximus.lshell GE minL AND maximus.lshell LE maxL AND maximus.ilat GT 0), $
                 where(maximus.lshell GE minL AND maximus.lshell LE maxL AND maximus.ilat LT 0))
        n_lshell = N_ELEMENTS(lshell_i)
        n_not_lshell = N_ELEMENTS(maximus.time)-n_lshell

        PRINTF,lun,'Hemisphere: Northern AND Southern'
     END
     STRUPCASE(hemi) EQ "GLOBE": BEGIN
        lshell_i=where(maximus.lshell GE minL AND maximus.lshell LE maxL,n_lshell,NCOMPLEMENT=n_not_LSHELL) 
        PRINTF,lun,"GLOBE!"
     END
     ELSE: BEGIN
        PRINTF,lun,"Invalid hemisphere provided! Can't get LSHELL indices..."
        STOP
     END
  ENDCASE


  PRINTF,lun,FORMAT='("N outside L-shell range",T30,":",T35,I0)',n_not_LSHELL
  PRINTF,lun,''

  RETURN,lshell_i

END