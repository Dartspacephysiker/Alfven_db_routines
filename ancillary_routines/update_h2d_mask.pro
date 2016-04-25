PRO UPDATE_H2D_MASK,h2dStr,H2DBinsMLT,H2DBinsILAT,H2DFluxN,dataName, $
                    h2dMask,h2d_nonzero_nEv_i, $
   LUN=lun

  IF ~KEYWORD_SET(lun) THEN lun = -1

  ;;make sure this makes any sense
  ;; noData_i                            = WHERE( h2dstr.data EQ 0 )
  h2d_candidate_mask                  = h2dstr.data EQ 0
  nNewStinkers                        = N_ELEMENTS(WHERE(h2d_candidate_mask))
  nOldStinkers                        = N_ELEMENTS(WHERE(h2dMask))
  iBadBin                             = !NULL

  newestStinkers_i                    = CGSETDIFFERENCE(WHERE(h2d_candidate_mask), $
                                                        WHERE(h2dMask), $
                                                        SUCCESS=success, $
                                                        COUNT=nNewestStinkers)
  IF success THEN BEGIN
     nMLTs                            = N_ELEMENTS(H2DBinsMLT)
     PRINTF,lun,"Evidently we've dropped some data here; particularly, there are " + STRCOMPRESS(nNewestStinkers,/REMOVE_ALL) + " more bins that ought to be masked. So that's wassup."
     PRINTF,lun,FORMAT='("Index",T10,"MLT",T20,"ILAT",T30,A0,T60,"N PREVIOUS contr. events")',dataName

     FOR i=0,nNewestStinkers-1 DO BEGIN
        ind                           = newestStinkers_i[i]
        PRINTF,lun,FORMAT='(I0,T10,F0.2,T20,F0.2,T30,F0.3,T60,I0)',ind,H2DBinsMLT[ind MOD nMLTs],H2DBinsILAT[ind / nMLTs],h2dStr.data[ind],h2dFluxN[ind]
        PRINTF,lun,'Setting this bin to zero ...'
        h2dstr.data[ind]              = 0
        h2dMask[ind]                  = 255
     ENDFOR
     h2d_nonZero_nEv_i                = WHERE(~h2dMask)
     PRINTF,lun,""
  ENDIF

  ;; IF nNewStinkers GT nOldStinkers THEN BEGIN
  ;;    nMLTs                            = N_ELEMENTS(H2DBinsMLT)
  ;;    PRINTF,lun,"Evidently we've dropped some data here; particularly, there are " + STRCOMPRESS(nNewStinkers - nOldStinkers,/REMOVE_ALL) + " more bins that ought to be masked. So that's wassup."
  ;;    PRINTF,lun,FORMAT='("Index",T10,"MLT",T20,"ILAT",T30,A0,T45,"N PREVIOUS contr. events")',dataName
  ;;    newestStinkers_i                 = CGSETDIFFERENCE(WHERE(h2d_candidate_mask), $
  ;;                                                       WHERE(h2dMask),SUCCESS=success)
  ;;    IF success THEN BEGIN
  ;;       FOR i=0,newestStinkers_i-1 DO BEGIN
  ;;          ind                           = newestStinkers_i[i]
  ;;          PRINTF,lun,FORMAT='(I0,T10,F0.2,T20,F0.2,T30,F0.3,T45,I0)',ind,H2DBinsMLT[ind MOD nMLTs],H2DBinsILAT[ind / nMLTs],h2dStr.data[ind],h2dFluxN[ind]
  ;;          PRINTF,lun,'Setting this bin to zero ...'
  ;;          h2dstr.data[ind]              = 0
  ;;          h2dMask[ind]                  = 255
  ;;       ENDFOR
  ;;    PRINTF,lun,""
  ;;    ENDIF
  ;;    ;; STOP
  ;; ENDIF
  ;;ENDIF

END