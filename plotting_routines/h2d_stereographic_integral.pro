PRO H2D_STEREOGRAPHIC_INTEGRAL,H2DStr,lonsLats, $
                               ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
                               EQUAL_AREA_BINNING=EA_binning, $
                               H2D_MASKED=h2d_masked, $
                               INTEGRAL=integral, $
                               ABSINTEGRAL=absIntegral, $
                               DAWNINTEGRAL=dawnIntegral, $
                               DUSKINTEGRAL=duskIntegral, $
                               DAYINTEGRAL=dayIntegral, $
                               NIGHTINTEGRAL=nightIntegral, $
                               OUTPUT_INTEGRAL_TXTFILE=output_integral_txt, $
                               OUTPUT_INTEGRAL_SAVFILE=output_integral_sav, $
                               INTEGSAVFILE=integralSavFile, $
                               INTLUN=intLun
  

  nLats              = N_ELEMENTS(lonsLats[0,*,0,0])+1
  nLons              = N_ELEMENTS(lonsLats[*,0,0,0])+1
  
  ;Initialize integrals for each hemi
  dawnIntegral       = (H2DStr.is_fluxData) ? DOUBLE(0.0) : 0L
  duskIntegral       = (H2DStr.is_fluxData) ? DOUBLE(0.0) : 0L
  dayIntegral        = (H2DStr.is_fluxData) ? DOUBLE(0.0) : 0L
  nightIntegral      = (H2DStr.is_fluxData) ? DOUBLE(0.0) : 0L

  ;;Initialize area avgs for each hemi
  dawnArea            = DOUBLE(0.0)
  duskArea            = DOUBLE(0.0)
  dayArea             = DOUBLE(0.0)
  nightArea           = DOUBLE(0.0)

  CASE 1 OF
     KEYWORD_SET(EA_binning): BEGIN
        LOAD_EQUAL_AREA_BINNING_STRUCT,EA
        EA.minM    *= 15.
        EA.maxM    *= 15.
        grateMe_i   = WHERE(~h2d_masked,nGrate)
        dusk_i      = WHERE((EA.minM GE 180) AND (EA.maxM GE 180),nPureDusk)
        dawn_i      = WHERE((EA.minM LE 180) AND (EA.maxM LE 180),nPureDawn)
        night_i     = WHERE((EA.minM LE 90   AND EA.maxM LE 90  ) OR $
                            (EA.minM GE 270  AND EA.maxM GE 270 ),nPureNight)
        day_i       = WHERE((EA.minM GE 90  AND EA.maxM GE 90   ) AND $
                            (EA.minM LE 270 AND EA.maxM LE 270  ),nPureDay)
        noon_i      = WHERE((EA.minM GE 135 AND EA.maxM GE 135  ) AND $
                            (EA.minM LE 225 AND EA.maxM LE 225  ),nPureNoon)
        morn_i      = WHERE((EA.minM GE 45  AND EA.maxM GE 45  ) AND $
                            (EA.minM LE 135 AND EA.maxM LE 135  ),nPureMorn)
        even_i      = WHERE((EA.minM GE 225 AND EA.maxM GE 225 ) AND $
                            (EA.minM LE 315 AND EA.maxM LE 315  ),nPureEven)
        midN_i      = WHERE((EA.minM GE 315 AND EA.maxM GE 315 ) OR  $
                            (EA.minM LE 45  AND EA.maxM LE 45  ),nPuremidN)

        ;;Weird stuff happens at boundaries, so divide 'em up
        ;;45,90,135,180,225,270,315
        pDawnDusk_i = WHERE((EA.minM LT 180) AND (EA.maxM GT 180),nDawnDusk)
        pDayNight_i = WHERE((EA.minM LT 90 ) AND (EA.maxM GT 90 ) OR $
                            (EA.minM LT 270) AND (EA.maxM GT 270),nDayNight)
        pMidNMorn_i = WHERE((EA.minM LT 45 ) AND (EA.maxM GT 45 ),nMornNoon)
        pMornNoon_i = WHERE((EA.minM LT 135) AND (EA.maxM GT 135),nMornNoon)
        pNoonEven_i = WHERE((EA.minM LT 225) AND (EA.maxM GT 225),nNoonEven)
        pEvenMidN_i = WHERE((EA.minM LT 315) AND (EA.maxM GT 315),nEvenMidN)


        dusk_i      = CGSETINTERSECTION(grateMe_i,dusk_i,COUNT=Ndusk,NORESULT=-1)
        IF dusk_i[0] EQ -1 THEN BEGIN
           dusk_i   = !NULL
        ENDIF

        dawn_i      = CGSETINTERSECTION(grateMe_i,dawn_i,COUNT=Ndawn,NORESULT=-1)
        IF dawn_i[0] EQ -1 THEN BEGIN
           dawn_i   = !NULL
        ENDIF

        night_i     = CGSETINTERSECTION(grateMe_i,night_i,COUNT=Nnight,NORESULT=-1)
        IF night_i[0] EQ -1 THEN BEGIN
           night_i  = !NULL
        ENDIF
        
        day_i       = CGSETINTERSECTION(grateMe_i,day_i,COUNT=Nday,NORESULT=-1)
        IF day_i[0] EQ -1 THEN BEGIN
           day_i    = !NULL
        ENDIF

        morn_i      = CGSETINTERSECTION(grateMe_i,morn_i,COUNT=Nmorn,NORESULT=-1)
        IF morn_i[0] EQ -1 THEN BEGIN
           morn_i   = !NULL
        ENDIF

        noon_i      = CGSETINTERSECTION(grateMe_i,noon_i,COUNT=Nnoon,NORESULT=-1)
        IF noon_i[0] EQ -1 THEN BEGIN
           noon_i   = !NULL
        ENDIF

        even_i      = CGSETINTERSECTION(grateMe_i,even_i,COUNT=Neven,NORESULT=-1)
        IF even_i[0] EQ -1 THEN BEGIN
           even_i   = !NULL
        ENDIF

        midN_i      = CGSETINTERSECTION(grateMe_i,midN_i,COUNT=NmidN,NORESULT=-1)
        IF midN_i[0] EQ -1 THEN BEGIN
           midN_i   = !NULL
        ENDIF

        pDawnDusk_i = CGSETINTERSECTION(grateMe_i,pDawnDusk_i,COUNT=NpDawnDusk,NORESULT=-1)
        IF pDawnDusk_i[0] EQ -1 THEN BEGIN
           pDawnDusk_i = !NULL
        ENDIF

        pDayNight_i = CGSETINTERSECTION(grateMe_i,pDayNight_i,COUNT=NpDayNight,NORESULT=-1)
        IF pDayNight_i[0] EQ -1 THEN BEGIN
           pDayNight_i = !NULL
        ENDIF

        
        pMidNMorn_i = CGSETINTERSECTION(grateMe_i,pMidNMorn_i,COUNT=NpMidNMorn,NORESULT=-1)
        IF pMidNMorn_i[0] EQ -1 THEN BEGIN
           pMidNMorn_i = !NULL
        ENDIF

        pMornNoon_i = CGSETINTERSECTION(grateMe_i,pMornNoon_i,COUNT=NpMornNoon,NORESULT=-1)
        IF pMornNoon_i[0] EQ -1 THEN BEGIN
           pMornNoon_i = !NULL
        ENDIF

        pNoonEven_i = CGSETINTERSECTION(grateMe_i,pNoonEven_i,COUNT=NpNoonEven,NORESULT=-1)
        IF pNoonEven_i[0] EQ -1 THEN BEGIN
           pNoonEven_i = !NULL
        ENDIF

        pEvenMidN_i = CGSETINTERSECTION(grateMe_i,pEvenMidN_i,COUNT=NpEvenMidN,NORESULT=-1)
        IF pEvenMidN_i[0] EQ -1 THEN BEGIN
           pEvenMidN_i = !NULL
        ENDIF

        ctrLon      = MEAN([[EA.minM],[EA.maxm]],DIMENSION=2,/DOUBLE)
        
        FOR j=0,nLats-2 DO BEGIN 

           ;; tempLons     = REFORM(lonsLats[j,j,0,*])
           ;; tempLats     = REFORM(lonsLats[j,j,1,*])
           

           ;;Integrals
           IF ~h2d_masked[j] THEN BEGIN

              ;; IF tempLons[0] GE 180 AND $
              ;;    tempLons[-1] GE 180 $
              ;; THEN BEGIN
              IF ctrLon[j] GE 180 $
              THEN BEGIN
                 duskIntegral += ((H2DStr.is_logged) ? $
                                  10.^H2DStr.data[j] : H2DStr.data[j]) * H2DStr.gAreas[j] 
                 duskArea      += H2DStr.gAreas[j]
              ENDIF ELSE BEGIN
                 ;; IF tempLons[0] LE 180 AND $
                 ;;    tempLons[-1] LE 180 $
                 ;; THEN BEGIN
                 IF ctrLon[j] GE 0 $
                 THEN BEGIN
                    dawnIntegral += ((H2DStr.is_logged) ? $
                                    10.^H2DStr.data[j] : H2DStr.data[j]) * H2DStr.gAreas[j] 
                    dawnArea      += H2DStr.gAreas[j]
                 ENDIF
              ENDELSE

              ;; IF (tempLons[0] LE 90  AND tempLons[-1] LE 90 ) OR $
              ;;    (tempLons[0] GE 270 AND tempLons[-1] GE 270)    $
              ;; THEN BEGIN
              IF (ctrLon[j] LE 90 ) OR $
                 (ctrLon[j] GT 270)    $
              THEN BEGIN
                 nightIntegral   += ((H2DStr.is_logged) ? $
                                    10.^H2DStr.data[j] : H2DStr.data[j]) * H2DStr.gAreas[j] 
                 nightArea        += H2DStr.gAreas[j]
              ENDIF ELSE BEGIN
                 ;; IF (tempLons[0] GE 90  AND tempLons[-1] GE 90 ) AND $
                 ;;    (tempLons[0] LE 270 AND tempLons[-1] LE 270)    $
                 IF (ctrLon[j] GT 90 ) AND $
                    (ctrLon[j] LE 270)    $
                 THEN BEGIN
                    dayIntegral  += ((H2DStr.is_logged) ? $
                                    10.^H2DStr.data[j] : H2DStr.data[j]) * H2DStr.gAreas[j] 
                    dayArea        += H2DStr.gAreas[j]
                 ENDIF
              ENDELSE

           ENDIF

        ENDFOR 

     END
     ELSE: BEGIN

        grateMe_i   = WHERE(~h2d_masked,nGrate)
        FOR j=0, nLats-2 DO BEGIN 
           FOR i=0, nLons-2 DO BEGIN 

              tempLons     = REFORM(lonsLats[i,j,0,*])
              ;; tempLats     = REFORM(lonsLats[i,j,1,*])
              
              ;;Integrals
              IF ~h2d_masked[i,j] THEN BEGIN

                 IF tempLons[0] GE 180 AND $
                    tempLons[-1] GE 180 $
                 THEN BEGIN
                    duskIntegral += ((H2DStr.is_logged) ? $
                                    10.^H2DStr.data[i,j] : H2DStr.data[i,j]) * H2DStr.gAreas[j] 
                    duskArea      += H2DStr.gAreas[i,j]
                 ENDIF ELSE BEGIN
                    IF tempLons[0] LE 180 AND $
                       tempLons[-1] LE 180 $
                    THEN BEGIN
                       dawnIntegral += ((H2DStr.is_logged) ? $
                                       10.^H2DStr.data[i,j] : H2DStr.data[i,j]) * H2DStr.gAreas[j] 
                       dawnArea      += H2DStr.gAreas[i,j]
                    ENDIF
                 ENDELSE

                 IF (tempLons[0] LE 90  AND tempLons[-1] LE 90 ) OR $
                    (tempLons[0] GE 270 AND tempLons[-1] GE 270)    $
                 THEN BEGIN
                    nightIntegral   += ((H2DStr.is_logged) ? $
                                       10.^H2DStr.data[i,j] : H2DStr.data[i,j]) * H2DStr.gAreas[j] 
                    nightArea        += H2DStr.gAreas[i,j]
                 ENDIF ELSE BEGIN
                    IF (tempLons[0] GE 90  AND tempLons[-1] GE 90 ) AND $
                       (tempLons[0] LE 270 AND tempLons[-1] LE 270)    $
                    THEN BEGIN
                       dayIntegral  += ((H2DStr.is_logged) ? $
                                       10.^H2DStr.data[i,j] : H2DStr.data[i,j]) * H2DStr.gAreas[j] 
                       dayArea       += H2DStr.gAreas[i,j]
                    ENDIF
                 ENDELSE

              ENDIF

           ENDFOR 
        ENDFOR
     END
  ENDCASE


  IF H2DStr.is_logged THEN BEGIN
     integral        = ALOG10(TOTAL(10.0^(H2DStr.data[grateMe_i])))
     absIntegral     = integral
     dawnIntegral    = ALOG10(dawnIntegral)
     duskIntegral    = ALOG10(duskIntegral)
     dayIntegral     = ALOG10(dayIntegral)
     nightIntegral   = ALOG10(nightIntegral)
  ENDIF ELSE BEGIN
     integral        = TOTAL(H2DStr.data[grateMe_i] * H2DStr.gAreas[grateMe_i])
     absIntegral     = TOTAL(ABS(H2DStr.data[grateMe_i] * H2DStr.gAreas[grateMe_i]))
  ENDELSE     

  H2DAreaConvFac     = 1
  IF H2DStr.gUnits EQ 'E+25' THEN BEGIN
     H2DAreaConvFac  = 1e10
  ENDIF
  IF H2DStr.gUnits EQ 'GW' THEN BEGIN
     H2DAreaConvFac  = 1e3
  ENDIF

  integral      *= H2DAreaConvFac
  absIntegral   *= H2DAreaConvFac
  dawnIntegral  *= H2DAreaConvFac
  duskIntegral  *= H2DAreaConvFac
  dayIntegral   *= H2DAreaConvFac
  nightIntegral *= H2DAreaConvFac

  IF KEYWORD_SET(output_integral_txt) THEN BEGIN
     ;; OPENW,intlun,integralFile,/GET_LUN,/APPEND

     ;; labFormat    = STRMID(H2DStr.labelFormat, $
     ;;                       1, $
     ;;                       STRPOS(H2DStr.labelFormat,')',/REVERSE_SEARCH)-1)
     labFormat    = 'G0.4'

     PRINTF,intLun,''
     PRINTF,intLun,FORMAT='(" Total ",T15,":",T20,'+labFormat+')',integral
     PRINTF,intLun,FORMAT='("|Total|",T15,":",T20,'+labFormat+')',integral
     PRINTF,intLun,''
     PRINTF,intLun,FORMAT='("Dayside",T15,":",T20,'+labFormat+')',dayIntegral
     PRINTF,intLun,FORMAT='("Nightside",T15,":",T20,'+labFormat+')',nightIntegral
     PRINTF,intLun,''
     PRINTF,intLun,FORMAT='("Dawnside",T15,":",T20,'+labFormat+')',dawnIntegral
     PRINTF,intLun,FORMAT='("Duskside",T15,":",T20,'+labFormat+')',duskIntegral
     PRINTF,intLun,''

     ;; CLOSE,intLun
     ;; FREE_LUN,intLun
  ENDIF

  IF KEYWORD_SET(output_integral_sav) THEN BEGIN
     IF FILE_TEST(integralSavFile) THEN BEGIN
        ;; PRINT,'Restoring ' + integralSavFile + ' ...'
        RESTORE,integralSavFile

        hemiIntegs = {name:hemiIntegs.name, $
                      integrals:{day:[hemiIntegs.integrals.day,dayIntegral], $
                                 night:[hemiIntegs.integrals.night,nightIntegral], $
                                 dawn:[hemiIntegs.integrals.dawn,dawnIntegral], $
                                 dusk:[hemiIntegs.integrals.dusk,duskIntegral]}, $
                      area:{day:[hemiIntegs.area.day,dayArea], $
                            night:[hemiIntegs.area.night,nightArea], $
                            dawn:[hemiIntegs.area.dawn,dawnArea], $
                            dusk:[hemiIntegs.area.dusk,duskArea]}}
     ENDIF ELSE BEGIN
        hemiIntegs = {name:H2DStr.name, $
                      integrals:{day:dayIntegral, $
                                 night:nightIntegral, $
                                 dawn:dawnIntegral, $
                                 dusk:duskIntegral}, $
                      area:{day:dayArea, $
                            night:nightArea, $
                            dawn:dawnArea, $
                            dusk:duskArea}}

     ENDELSE
     
     ;; PRINT,'Saving ' + integralSavFile + '...'
     SAVE,hemiIntegs,FILENAME=integralSavFile
  ENDIF

END
