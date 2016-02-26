PRO PROBOCCURRENCE_AND_TIMEAVG_SANITY_CHECK,h2dStr,h2dTimeDenom,H2DBinsMLT,H2DBinsILAT,H2DFluxN,dataName, $
   LUN=lun

  IF ~KEYWORD_SET(lun) THEN lun = -1

  ;;make sure this makes any sense
  noData_i                           = WHERE( h2dstr.data EQ 0 )
  noTData_i                          = WHERE( h2dTimeDenom EQ 0 )
  nBadTBins                           = 0
  iBadTBin                            = !NULL
  FOR i=0,N_ELEMENTS(noTData_i)-1 DO BEGIN
     test                             = WHERE( noTData_i[i] EQ noData_i )
     IF test[0] EQ -1 THEN BEGIN
        iBadTBin                      = [iBadTBin,noTData_i[i]]
        nBadTBins++
     ENDIF
  ENDFOR
  IF nBadTBins GT 0 THEN BEGIN
     nMLTs                            = N_ELEMENTS(H2DBinsMLT)
     PRINTF,lun,STRCOMPRESS(nBadTBins,/REMOVE_ALL) + " instances in " + dataName + " histo where there are supposedly events, but the ephemeris data reports fast was never there!"
     PRINTF,lun,"Absurdity"
     threshold                        = 0.15           ;seconds
     PRINTF,lun,FORMAT='("Index",T10,"MLT",T20,"ILAT",T30,A0,T45,"N contr. events")',dataName
     FOR i=0,nBadTBins-1 DO BEGIN
        ind                           = iBadTBin[i]
        PRINTF,lun,FORMAT='(I0,T10,F0.2,T20,F0.2,T30,F0.3,T45,I0)',ind,H2DBinsMLT[ind MOD nMLTs],H2DBinsILAT[ind / nMLTs],h2dStr.data[ind],h2dFluxN[ind]
        ;; IF h2dstr.data[ind] LT threshold THEN BEGIN
        ;;    PRINTF,lun,,'-->Below threshold (' + STRCOMPRESS(threshold,/REMOVE_ALL) + '); setting this width_time to zero ...'
        ;;    h2dstr.data[ind]           = 0
        ;; ENDIF
        PRINTF,lun,'Setting this bin to zero ...'
        h2dstr.data[ind]              = 0
        h2dTimeDenom[ind]             = 999999.
     ENDFOR
     PRINTF,lun,""
     STOP
     ;; STOP
  ENDIF

END