;;2016/04/15 En route to Vienna from Istanbul. (Turkey rules, by the way, or at least Turkish Airlines does.)
;;Ripped off MAKE_TIMEHIST_DENOMINATOR for this action

;;CAREFUL!! for_eSpec_DBs and alfDB_plot_struct.for_eSpec_DBs do not mean the same thing in this routine!!!
PRO MAKE_H2D_WITH_LIST_OF_OBS_AND_OBS_STATISTICS,dbStruct_obsArr, $
   FOR_MAXIMUS=for_maximus, $
   FOR_ESPEC_DBS=for_eSpec_DBs, $
   FOR_FASTLOC_DBS=for_fastLoc_DBs, $
   DBTIMES=dbTimes, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   IMF_STRUCT=IMF_struct, $
   MIMC_STRUCT=MIMC_struct, $
   DONT_USE_THESE_INDS=dont_use_these_inds, $
   DO_LISTS_WITH_STATS=do_lists_with_stats, $
   DO_GROSSRATE_FLUXQUANTITIES=do_grossRate_fluxQuantities, $
   GROSSRATE__H2D_AREAS=h2dAreas, $
   DO_GROSSRATE_WITH_LONG_WIDTH=do_grossRate_with_long_width, $
   GROSSRATE__H2D_LONGWIDTHS=h2dLongWidths, $
   GROSSCONVFACTOR=grossConvFactor, $
   DO_TIMEAVG_FLUXQUANTITIES=do_timeAvg_fluxQuantities, $
   THISTDENOMINATOR=tHistDenominator, $
   BOTH_HEMIS=both_hemis, $
   OUTH2D_LISTS_WITH_OBS=outH2D_lists_with_obs,$
   OUTH2D_STATS=outH2D_stats, $
   OUTFILESTRING=outFileString, $
   OUTFILEPREFIX=outFilePrefix, $
   OUTFILESUFFIX=outFileSuffix, $
   OUTDIR=outDir, $
   OUTPUT_TEXTFILE=output_textFile, $
   OUTPUT__INC_IMF_=output__inc_IMF, $
   OUTPUT__ORB_AVG_OBS=output__orb_avg_obs, $
   DATANAME=dataName, $
   DATATITLE=dataTitle, $
   DBSTRUCT=dbStruct, $
   DBSTR_INDS=dbStruct_inds, $
   LUN=lun

  COMPILE_OPT idl2

  COMMON H2D_LIST_OF_INDS,HLOI__H2D_lists_with_inds,HLOI__nInds,HLOI__nMLT,HLOI__nILAT,HLOI__H2D_binCenters

  IF KEYWORD_SET(output__inc_IMF) THEN BEGIN
     @common__omni_stability.pro

     IF N_ELEMENTS(C_OMNI__mag_UTC) EQ 0 THEN BEGIN

        PRINTF,lun,'Restoring culled OMNI data to get mag_utc ...'
        dataDir         = "/SPENCEdata/Research/database/"

        RESTORE,dataDir + "/OMNI/culled_OMNI_magdata.dat"

        OMNI__SELECT_COORDS,Bx, $
                            By_GSE,Bz_GSE,Bt_GSE, $
                            thetaCone_GSE,phiClock_GSE,cone_overClock_GSE,Bxy_over_Bz_GSE, $
                            By_GSM,Bz_GSM,Bt_GSM, $
                            thetaCone_GSM,phiClock_GSM,cone_overClock_GSM,Bxy_over_Bz_GSM, $
                            OMNI_COORDS=IMF_struct.OMNI_coords, $
                            LUN=lun

        C_OMNI__clean_i = GET_CLEAN_OMNI_I(C_OMNI__Bx,C_OMNI__By,C_OMNI__Bz, $
                                           LUN=lun)
        C_OMNI__time_i  = GET_OMNI_TIME_I(mag_UTC, $
                                          IMF_STRUCT=IMF_struct, $
                                          LUN=lun)

        C_OMNI__mag_UTC = TEMPORARY(mag_UTC)

     ENDIF
  ENDIF

  @common__newell_espec.pro
  IF KEYWORD_SET(for_fastLoc_DBs) THEN BEGIN
     @common__fastloc_espec_vars.pro
     @common__fastloc_vars.pro

     IF KEYWORD_SET(alfDB_plot_struct.for_eSpec_DBs) THEN BEGIN
        FLTMP      = FL_E__fastLoc
        FLTMPTIMES = FASTLOC_E__times
     ENDIF ELSE BEGIN
        FLTMP      = FL__fastLoc
        FLTMPTIMES = FLTMP.time
     ENDELSE
  ENDIF


  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF N_ELEMENTS(HLOI__H2D_lists_with_inds) EQ 0 THEN BEGIN
     PRINTF,lun,'Gotta provide the input H2D list thing! Come on, bro.'
     STOP
  ENDIF

  nInds             = HLOI__nInds - (KEYWORD_SET(dont_use_these_inds) ? N_ELEMENTS(dont_use_these_inds) : 0)
  IF N_ELEMENTS(dbStruct_obsArr) NE nInds THEN BEGIN
     PRINTF,lun,"You're about to run into mismatched obs and indices. There are unequal numbers of observations and indices."
     STOP
  ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Doing text output?
  todayStr         = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  baseFilePrefix   = 'H2D--' + (KEYWORD_SET(outFileString) ? outFileString : '')

  defOutDir = '/SPENCEdata/Research/Satellites/FAST/Alfven_db_routines/txtOutput/'

  IF N_ELEMENTS(outDir) EQ 0 THEN outDir = defOutDir

  outFileName     = baseFilePrefix+'--'+dataName+(KEYWORD_SET(output__orb_avg_obs) ? '--orbAvg' : '')+'.txt'

  IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
     outFileName = outFileName.Replace('eFlux','eSpecDB')
     outFileName = outFileName.Replace('eNumFl','eSpecDB')
     outFileName = outFileName.Replace('_ENUMFLUX_NONALFVEN','')
     outFileName = outFileName.Replace('_EFLUX_NONALFVEN','')
  ENDIF

  IF N_ELEMENTS(dataTitle) GT 0 THEN dTitle = dataName ELSE dTitle = 'Observation'
  IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
     dTitle = 'eSpec_DB'
  ENDIF

  IF KEYWORD_SET(for_fastLoc_DBs) THEN BEGIN
     dTitle = 'fastLoc_DB'
  ENDIF

  ;;No silly, extraneous info
  dTitle = dTitle.Replace('Abs--','')
  dTitle = dTitle.Replace('NoNegs--','')

  IF KEYWORD_SET(output_textFile) THEN BEGIN
     PRINTF,lun,"Creating obs/orb file: " + outDir + outFileName

     IF FILE_TEST(outDir+outFileName) AND KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
        PRINTF,lun,'H2D_list_with_obs file already exists: ' + outDir+outFileName + '. Skipping ...'
        skip = 1
     ENDIF

     IF ~KEYWORD_SET(skip) THEN BEGIN
        OPENW,textLun,outDir+outFileName,/GET_LUN
     ENDIF
  ENDIF

  ;;Doing any gross rate stuff?
  IF KEYWORD_SET(do_grossRate_fluxQuantities) $
     OR KEYWORD_SET(do_grossRate_with_long_width) THEN BEGIN
     do_grossRates                        = 1
     CASE 1 OF
        KEYWORD_SET(do_grossRate_fluxQuantities): BEGIN
           grossH2DSpatialFactor          = h2dAreas*grossConvFactor
        END
        KEYWORD_SET(do_grossRate_with_long_width): BEGIN
           grossH2DSpatialFactor          = h2dLongWidths*grossConvFactor
        END
     ENDCASE
  ENDIF ELSE BEGIN
     do_grossRates                        = 0
  ENDELSE

  
  ;;Make a copy of HLOI__H2D_lists_with_inds in case we're modding
  tempH2D_lists_with_inds          = HLOI__H2D_lists_with_inds

  ;;Go through, make sure no bad guys
  IF N_ELEMENTS(dont_use_these_inds) GT 0 THEN BEGIN
     nRemoved                      = 0
     ;; remove_bad_inds               = 1
     FOR j=0,N_ELEMENTS(tempH2D_lists_with_inds)-1 DO BEGIN
        tempInds                   = (tempH2D_lists_with_inds[j])[0]
        nTemps                     = N_ELEMENTS(tempInds)
        IF ISA((tempH2D_lists_with_inds[j])[0]) AND nTemps GT 0 THEN BEGIN
           tempInds                = CGSETDIFFERENCE(tempInds,dont_use_these_inds, $
                                                     COUNT=tempCount, $
                                                     SUCCESS=remove_bad_inds)
           tempNRemoved            = nTemps-tempCount
           ;; PRINTF,lun,"TempNRemoved: " + STRCOMPRESS(tempNRemoved,/REMOVE_ALL)
           IF tempNRemoved GT 0 THEN BEGIN
              tempH2D_lists_with_inds[j] = LIST(tempInds)
              ;; tempH2D_lists_with_orbs[j] = LIST(tempOrbs)
              nRemoved            += tempNRemoved
           ENDIF
        ENDIF;;  ELSE BEGIN
     
        ;; ENDELSE
     ENDFOR
     PRINTF,lun,'Removed ' + STRCOMPRESS(nRemoved,/REMOVE_ALL) + " bad inds from candidate H2D_with_list_of_obs"
  ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;loop over MLTs and ILATs
  ;; outH2D_stats                             = !NULL
  ;; outH2D_lists_with_obs                    = !NULL
  CASE 1 OF
     KEYWORD_SET(alfDB_plot_struct.EA_binning): BEGIN
        outH2D_stats          = MAKE_ARRAY(4,HLOI__nMLT,/DOUBLE)
        outH2D_lists_with_obs = MAKE_ARRAY(HLOI__nMLT,/OBJ)
     END
     ELSE: BEGIN
        outH2D_stats          = MAKE_ARRAY(4,HLOI__nMLT,HLOI__nILAT,/DOUBLE)
        outH2D_lists_with_obs = MAKE_ARRAY(HLOI__nMLT,HLOI__nILAT,/OBJ)
     END
  ENDCASE

  IF KEYWORD_SET(output_textFile) AND ~KEYWORD_SET(skip) THEN BEGIN
     CASE 1 OF
        KEYWORD_SET(output__inc_IMF): BEGIN
           PRINTF,textLun,FORMAT='(A0,T9,A0,T19,A0,T46,A0,T54,A0,T64,' + $
                  'A0,T75,A0,T85,A0,T94,A0,T103,A0,T112,' + $
                  'A0,T121,A0)', $
                  "MLT","ILAT","Time","Orbit","Alt", $
                  ;; "pFlux","charE","eFlux","Bx","By", $
                  (KEYWORD_SET(for_eSpec_DBs) ? "eFlux"    :  dTitle), $
                  (KEYWORD_SET(for_eSpec_DBs) ? "eNumFlux" : "charE"), $
                  (KEYWORD_SET(for_eSpec_DBs) ? "charE"    : "eFlux"), $
                  "Bx","By","Bz","NEvents" ;"Dst"

           ;; PRINTF,textLun,FORMAT='("MLT",T10,"ILAT",T20,"Time",T47,"Orbit",T56,"Alt",T65,A0,T74,A0,T85,A0,T97,A0,T108)', $
           ;;        'pFlux', $
           ;;        'Bx', $
           ;;        'By', $
           ;;        'Bz', $
           ;;        'Char e'
        END
        ELSE: BEGIN
           PRINTF,textLun,FORMAT='("MLT",T10,"ILAT",T20,"Time",T47,"Orbit",T56,"Altitude",T67,A0)',dTitle
        END
     ENDCASE
  ENDIF
  FOR j=0,HLOI__nILAT-1 DO BEGIN

     FOR i=0,HLOI__nMLT-1 DO BEGIN
        ;;check if valid
        valid = ISA((tempH2D_lists_with_inds[i,j])[0])
        IF valid THEN BEGIN
           tempObs                     = dbStruct_obsArr[(tempH2D_lists_with_inds[i,j])[0]]

           IF do_grossRates THEN BEGIN
              tempObs                  = tempObs*grossH2DSpatialFactor[i,j]
           ENDIF

           tempObsList                 = LIST(tempObs)
           outH2D_lists_with_obs[i,j]  = tempObsList

           ;;Output to text file if requested
           IF (KEYWORD_SET(output_textFile) AND ~KEYWORD_SET(skip)) THEN BEGIN
              ;;Everyone want dat

              CASE 1 OF
                 KEYWORD_SET(for_eSpec_DBs): BEGIN
                    tempMLTs  = NEWELL__eSpec.mlt[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                    tempILATs = NEWELL__eSpec.ilat[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                    tempTimes = NEWELL__eSpec.x[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                    tempOrbs  = NEWELL__eSpec.orbit[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                    tempAlts  = NEWELL__eSpec.alt[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                 END
                 KEYWORD_SET(for_fastLoc_DBs): BEGIN
                    tempMLTs  = FLTMP.mlt[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                    tempILATs = FLTMP.ilat[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                    tempTimes = FLTMPTIMES[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                    tempOrbs  = FLTMP.orbit[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                    tempAlts  = FLTMP.alt[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]

                 END
                 ELSE: BEGIN
                    tempMLTs  = dbStruct.mlt[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                    tempILATs = dbStruct.ilat[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                    tempTimes = dbStruct.time[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                    tempOrbs  = dbStruct.orbit[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                    tempAlts  = dbStruct.alt[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                 END
              ENDCASE

              ;; PRINTF,textLun,FORMAT='("MLT",T10,"ILAT",T25,"Orbit",T35,"Observation")'
              ;; PRINTF,textLun,FORMAT='(F0.3,T10,F0.3)',HLOI__H2D_binCenters[0,i,j],HLOI__H2D_binCenters[1,i,j]
              ;; PRINTF,textLun,'*************************'
              IF (KEYWORD_SET(do_timeAvg_fluxQuantities) AND N_ELEMENTS(tHistDenominator) GT 0) THEN BEGIN
                 ;; PRINTF,textLun,FORMAT='(F0.3,T10,F0.3,T30,"T here (seconds): ",F-7.3)', $
                 PRINTF,textLun,FORMAT='(F0.3,T10,F0.3,T20,F-7.3)', $
                        HLOI__H2D_binCenters[0,i,j],HLOI__H2D_binCenters[1,i,j],tHistDenominator[i,j]
                 PRINTF,textLun,'************************************************************'
                 ;; PRINTF,textLun,FORMAT='("T here (seconds): ",T64,F-7.3)',tHistDenominator[i,j]
                 ;; PRINTF,textLun,'*************************'
              ENDIF ELSE BEGIN
                 PRINTF,textLun,FORMAT='(F0.3,T10,F0.3)',HLOI__H2D_binCenters[0,i,j],HLOI__H2D_binCenters[1,i,j]
                 PRINTF,textLun,'*************************'
              ENDELSE

              CASE 1 OF
                 KEYWORD_SET(output__inc_IMF): BEGIN
                    
                    CASE 1 OF
                       KEYWORD_SET(output__orb_avg_obs): BEGIN
                          ;;CAREFUL!! for_eSpec_DBs and alfDB_plot_struct.for_eSpec_DBs do not mean the same thing in this routine!!!
                          tempUTC           = (KEYWORD_SET(for_eSpec_DBs) ? NEWELL__eSpec.x : dbTimes) $
                                              [dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                          CASE 1 OF
                             KEYWORD_SET(for_maximus): BEGIN
                                tempChare         = dbStruct.max_chare_losscone[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                                tempeFlux         = dbStruct.elec_energy_flux[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                             END
                             KEYWORD_SET(for_fastLoc_DBs): BEGIN
                                tempChare         = MAKE_ARRAY(N_ELEMENTS((tempH2D_lists_with_inds[i,j])[0]),VALUE=0B,/BYTE)
                                tempeFlux         = MAKE_ARRAY(N_ELEMENTS((tempH2D_lists_with_inds[i,j])[0]),VALUE=0B,/BYTE)
                             END
                             KEYWORD_SET(for_eSpec_DBs): BEGIN
                                tempeFlux         = NEWELL__eSpec.jee[dBStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                                tempeNumFlux      = NEWELL__eSpec.je[dBStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                                tempChare         = tempeFlux/tempeNumFlux*6.242*1.0e11
                             END
                             ELSE: BEGIN

                             END
                          ENDCASE

                          IMFinds           = VALUE_CLOSEST2(C_OMNI__mag_UTC,tempUTC)
                          tempIMFBx         = C_OMNI__Bx[IMFinds]
                          tempIMFBy         = C_OMNI__By[IMFinds]
                          tempIMFBz         = C_OMNI__Bz[IMFinds]
                          tempIMFphiClock   = C_OMNI__phiClock[IMFinds]
                          tempIMFthetaCone  = C_OMNI__thetaCone[IMFinds]

                          uniqOrb_i        = UNIQ(tempOrbs,SORT(tempOrbs))
                          FOR k=0,N_ELEMENTS(uniqOrb_i)-1 DO BEGIN
                             tmpTempOrb     = tempOrbs[uniqOrb_i[k]]

                             tmpTmpInds     = WHERE(tempOrbs EQ tmpTempOrb,nTmpTmp)
                             IF tmpTmpInds[0] EQ -1 THEN STOP

                             CASE 1 OF
                                (KEYWORD_SET(do_timeAvg_fluxQuantities) AND N_ELEMENTS(tHistDenominator) GT 0): BEGIN
                                   tmptempObs   = TOTAL(tempObs  [tmpTmpInds])/tHistDenominator[i,j]
                                   tmptempeFlux = TOTAL(tempeFlux[tmpTmpInds])/tHistDenominator[i,j]
                                   IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
                                      tmptempeNumFlux = TOTAL(tempeNumFlux[tmpTmpInds])/tHistDenominator[i,j]
                                   ENDIF
                                END
                                ELSE: BEGIN
                                   tmptempObs   = 10.^(MEAN(ALOG10(tempObs  [tmpTmpInds])))
                                   tmptempeFlux = 10.^(MEAN(ALOG10(tempeFlux[tmpTmpInds])))
                                   IF KEYWORD_SET(for_eSpec_DBs) THEN BEGIN
                                      tmptempeNumFlux = 10.^(MEAN(ALOG10(tempeNumFlux[tmpTmpInds])))
                                   ENDIF
                                END
                             ENDCASE
                             ;; tmptempObs     = MEAN(tempObs  [tmpTmpInds])
                             tmptempAlts    = MEAN(tempAlts [tmpTmpInds])
                             tmptempMLTs    = MEAN(tempMLTs [tmpTmpInds])
                             tmptempILATs   = MEAN(tempILATs[tmpTmpInds])
                             tmptempUTC     = MEAN(tempUTC  [tmpTmpInds])
                             junk           = MIN(ABS(tempUTC[tmpTmpInds]-tmptempUTC),minInd)
                             tmpTempTimes   = tempTimes[tmpTmpInds[minInd]]
                             tmptempChare   = MEAN(tempChare[tmpTmpInds])        

                             tmpIMFinds          = IMFinds[tmpTmpInds]  
                             tmptempIMFBx        = MEAN(tempIMFBx       [tmpTmpInds]) 
                             tmptempIMFBy        = MEAN(tempIMFBy       [tmpTmpInds]) 
                             tmptempIMFBz        = MEAN(tempIMFBz       [tmpTmpInds]) 
                             tmptempIMFphiClock  = MEAN(tempIMFphiClock [tmpTmpInds]) 
                             tmptempIMFthetaCone = MEAN(tempIMFthetaCone[tmpTmpInds])
                             ;; tmpTempDst          = MEAN(tempDst[tmpTmpInds])

                             PRINTF,textLun,FORMAT='(F-5.2,T9,F-6.2,T19,A-0,T46,I-5,T54,F-8.1,T64,' + $
                                    'G-9.3,T74,G-8.2,T85,G-8.2,T94,F-7.3,T103,F-7.3,T112,' + $
                                    'F-7.3,T121,I0)', $ ; THIS ONE FOR DST--> F-7.3)', $ ;,T130,I0)', $
                                    tmpTempMLTs,tmpTempILATs,tmpTempTimes,tmpTempOrb,tmpTempAlts, $
                                    (KEYWORD_SET(for_eSpec_DBs) ? tmptempeFlux     : tmpTempObs  ), $
                                    (KEYWORD_SET(for_eSpec_DBs) ? tmptempeNumFlux  : tmpTempChare), $
                                    (KEYWORD_SET(for_eSpec_DBs) ? tmptempChare     : tmpTempeFlux), $
                                    tmpTempIMFBx,tmpTempIMFBy,tmpTempIMFBz, $
                                    nTmpTmp
                          ENDFOR

                       END
                       ELSE: BEGIN
                          tempUTC           = dbTimes[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                          tempChare         = dbStruct.max_chare_losscone[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]
                          tempeFlux         = dbStruct.elec_energy_flux[dbStruct_inds[(tempH2D_lists_with_inds[i,j])[0]]]

                          IMFinds           = VALUE_CLOSEST2(C_OMNI__mag_UTC,tempUTC)
                          tempIMFBx         = C_OMNI__Bx[IMFinds]
                          tempIMFBy         = C_OMNI__By[IMFinds]
                          tempIMFBz         = C_OMNI__Bz[IMFinds]
                          tempIMFphiClock   = C_OMNI__phiClock[IMFinds]
                          tempIMFthetaCone  = C_OMNI__thetaCone[IMFinds]

                          FOR iObs=0,N_ELEMENTS(tempObs)-1 DO BEGIN
                             PRINTF,textLun,FORMAT='(F-5.2,T9,F-6.2,T19,A-0,T46,I-5,T54,F-8.1,T65,' + $
                                    'F-9.3,T74,F-8.2,T85,F-7.3,T94,F-7.3,T103,F-7.3,T112,' + $
                                    'F-7.3)', $
                                    tempMLTs[iObs],tempILATs[iObs],tempTimes[iObs],tempOrbs[iObs],tempAlts[iObs], $
                                    tempObs[iObs],tempChare[iObs],tempeFlux[iObs],tempIMFBx[iObs],tempIMFBy[iObs], $
                                    tempIMFBz[iObs]

                             ;; PRINT,'Tdiff: ' + STRCOMPRESS(C_OMNI__mag_UTC[IMFinds[iObs]]-tempUTC[iObs],/REMOVE_ALL) + ' s'
                          ENDFOR
                       END
                    ENDCASE

                 END
                 ELSE: BEGIN
                    FOR iObs=0,N_ELEMENTS(tempObs)-1 DO BEGIN
                       PRINTF,textLun,FORMAT='(F0.3,T10,F0.3,T20,A0,T47,I0,T56,F0.3,T67,F0.3)', $
                              tempMLTs[iObs], $
                              tempILATs[iObs], $
                              tempTimes[iObs], $
                              tempOrbs[iObs], $
                              tempAlts[iObs], $
                              tempObs[iObs]
                    ENDFOR
                 END
              ENDCASE

              PRINTF,textLun,''
           ENDIF
        ENDIF ELSE BEGIN

        ENDELSE

        ;;handle stats, if requested
        IF KEYWORD_SET(do_lists_with_stats) AND valid THEN BEGIN
           IF N_ELEMENTS(tempObsList[0]) GT 0 THEN BEGIN
              tempStats                       = MOMENT(tempObsList[0])
           ENDIF ELSE BEGIN
              tempStats                       = MAKE_ARRAY(4,VALUE=0)
           ENDELSE
           outH2D_stats[*,i,j]                = tempStats
        ENDIF

        
     ENDFOR

     IF KEYWORD_SET(alfDB_plot_struct.EA_binning) THEN BREAK

  ENDFOR

  ;;Now reform the sucker
  IF ~KEYWORD_SET(alfDB_plot_struct.EA_binning) THEN BEGIN
     outH2D_lists_with_obs  = REFORM(outH2D_lists_with_obs,HLOI__nMLT,HLOI__nILAT)

     ;;… and these'ns, if requested
     IF KEYWORD_SET(do_lists_with_stats) THEN BEGIN
        outH2D_stats        = REFORM(outH2D_stats,4,HLOI__nMLT,HLOI__nILAT)
     ENDIF
  ENDIF
  
  ;;close output, if we've been doing ... it
  IF KEYWORD_SET(output_textFile) AND ~KEYWORD_SET(skip) THEN BEGIN
     ;; PRINTF,lun,'Finished writing ' + outDir+outFileName
     CLOSE,textLun
     FREE_LUN,textLun
  ENDIF

END