;***********************************************
;This script merely accesses the ACE and Chaston
;current filaments databases in order to generate
;Created 01/08/2014
;See 'current_event_Poynt_flux_vs_imf.pro' for
;more info, since that's where this code comes from.

;2015/10/15 Added L-shell stuff
;2015/10/09 Overhauling so that this can be used for time histos or Alfven DB structures
;2015/08/15 Added NO_BURSTDATA keyword
;2015/10/19 Added PRINT_PARAM_SUMMARY keyword
;2015/12/28 There are a bunch of weird sample_t values in fastloc. I'm junking them in fastloc_cleaner.
;2016/01/07 Added DESPUNDB keyword to let us get dat despun database
;2016/01/13 Added USING_HEAVIES keyword for those magical times when personen wants to use TEAMS data
FUNCTION GET_CHASTON_IND,dbStruct,satellite,lun,DBFILE=dbfile,DBTIMES=dbTimes, $
                         CHASTDB=chastDB, $
                         DESPUNDB=despunDB, $
                         ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange,CHARERANGE=charERange,POYNTRANGE=poyntRange, $
                         BOTH_HEMIS=both_hemis, $
                         NORTH=north, $
                         SOUTH=south, $
                         HEMI=hemi, $
                         HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                         MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                         DO_LSHELL=do_lshell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                         MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                         DAYSIDE=dayside,NIGHTSIDE=nightside, $
                         USING_HEAVIES=using_heavies, $
                         NO_BURSTDATA=no_burstData,GET_TIME_I_NOT_ALFVENDB_I=get_time_i_not_alfvendb_i, $
                         CORRECT_FLUXES=correct_fluxes, $
                         PRINT_PARAM_SUMMARY=print_param_summary
  COMPILE_OPT idl2
 
  ;For statistical auroral oval
  defHwMAurOval=0
  defHwMKpInd=7

  defLun = -1

  ;; defPrintSummary = 0

  is_maximus = 0        ;We assume this is not maximus
  ;;***********************************************
  ;;Load up all the dater, working from ~/Research/ACE_indices_data/idl
  
  IF ~KEYWORD_SET(lun) THEN lun = defLun ;stdout

  ;; IF KEYWORD_SET(both_hemis) THEN BEGIN
  ;;    PRINTF,lun,"hemi set to 'BOTH' via keyword /BOTH_HEMIS"
  ;;    hemi="BOTH"
  ;; ENDIF ELSE BEGIN
  ;;    IF KEYWORD_SET(north) THEN BEGIN
  ;;       PRINTF,lun,"hemi set to 'NORTH' via keyword /NORTH"
  ;;       hemi="NORTH"
  ;;    ENDIF ELSE BEGIN
  ;;       IF KEYWORD_SET(south) THEN BEGIN
  ;;          PRINTF,lun,"hemi set to 'SOUTH' via keyword /SOUTH"
  ;;          hemi="SOUTH"
  ;;       ENDIF
  ;;    ENDELSE
  ;; ENDELSE


  SET_DEFAULT_MLT_ILAT_AND_MAGC,MINMLT=minM,MAXMLT=maxM,BINM=binM, $
                                MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                                MINLSHELL=minL,MAXLSHELL=maxL,BINL=binL, $
                                MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                                HEMI=hemi, $
                                BOTH_HEMIS=both_hemis, $
                                NORTH=north, $
                                SOUTH=south, $
                                LUN=lun

  IF KEYWORD_SET(get_time_i_NOT_alfvendb_i) THEN BEGIN
     LOAD_FASTLOC_AND_FASTLOC_TIMES,dbStruct,dbTimes,DBDir=loaddataDir,DBFile=dbFile,DB_tFile=dbTimesFile
     is_maximus = 0
  ENDIF ELSE BEGIN
     IF N_ELEMENTS(correct_fluxes) EQ 0 THEN BEGIN
        IF N_ELEMENTS(dbStruct) GT 0 THEN BEGIN
           PRINTF,lun,'GET_CHASTON_IND: Not attempting to correct fluxes since dbStruct already loaded ...'
           correct_fluxes = 0
        ENDIF ELSE BEGIN
           correct_fluxes = 1
        ENDELSE
     ENDIF
     LOAD_MAXIMUS_AND_CDBTIME,dbStruct,dbTimes,DBDir=loaddataDir,DBFile=dbFile,DB_tFile=dbTimesFile, $
                              DO_CHASTDB=chastDB, $
                              DO_DESPUNDB=despunDB, $
                              CORRECT_FLUXES=correct_fluxes

     is_maximus = 1
  ENDELSE

  IF ~KEYWORD_SET(HwMAurOval) THEN HwMAurOval = defHwMAurOval
  IF ~KEYWORD_SET(HwMKpInd) THEN HwMKpInd = defHwMKpInd


  ;; IF ~KEYWORD_SET(print_param_summary) THEN print_param_summary = defPrintSummary

  ;;Welcome message
  printf,lun,""
  printf,lun,"****From get_chaston_ind.pro****"
  printf,lun,FORMAT='("DBFile                        :",T35,A0)',dbFile
  printf,lun,""

  ;;;;;;;;;;;;;;;
  ;;Check whether this is a maximus or fastloc struct
  IS_STRUCT_ALFVENDB_OR_FASTLOC,dbStruct,is_maximus

  ;;;;;;;;;;;;
  ;;Handle longitudes
  mlt_i = GET_MLT_INDS(dbStruct,minM,maxM,DAYSIDE=dayside,NIGHTSIDE=nightside,N_MLT=n_mlt,N_OUTSIDE_MLT=n_outside_MLT,LUN=lun)

  ;;;;;;;;;;;;
  ;;Handle latitudes, combine with mlt
  IF KEYWORD_SET(do_lShell) THEN BEGIN
     lshell_i = GET_LSHELL_INDS(dbStruct,minL,maxL,hemi,N_LSHELL=n_lshell,N_NOT_LSHELL=n_not_lshell,LUN=lun)
     region_i = CGSETINTERSECTION(lshell_i,mlt_i)
  ENDIF ELSE BEGIN
     ilat_i   = GET_ILAT_INDS(dbStruct,minI,maxI,hemi,N_ILAT=n_ilat,N_NOT_ILAT=n_not_ilat,LUN=lun)
     region_i = CGSETINTERSECTION(ilat_i,mlt_i)
  ENDELSE

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Want just Holzworth/Meng statistical auroral oval?
  IF HwMAurOval THEN region_i=CGSETINTERSECTION(region_i,where(abs(dbStruct.ilat) GT auroral_zone(dbStruct.mlt,HwMKpInd,/lat)/(!DPI)*180.))

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;Now combine them all
  IF KEYWORD_SET(do_lShell) THEN BEGIN
  ENDIF ELSE BEGIN
  ENDELSE

  IF is_maximus THEN BEGIN
     magc_i = GET_MAGC_INDS(dbStruct,minMC,maxNegMC,N_OUTSIDE_MAGC=n_magc_outside_range)
     region_i=CGSETINTERSECTION(region_i,magc_i)
  ENDIF

  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Limits on orbits to use?
  IF KEYWORD_SET (orbRange) THEN BEGIN
     IF N_ELEMENTS(orbRange) EQ 2 THEN BEGIN
        orb_i = GET_ORBRANGE_INDS(dbStruct,orbRange[0],orbRange[1],LUN=lun)
        region_i=CGSETINTERSECTION(region_i,orb_i)
     ENDIF ELSE BEGIN
        printf,lun,"Incorrect input for keyword 'orbRange'!!"
        printf,lun,"Please use orbRange=[minOrb maxOrb]"
        RETURN, -1
     ENDELSE
  ENDIF
  

  ;;limits on altitudes to use?
  IF KEYWORD_SET (altitudeRange) THEN BEGIN
     IF N_ELEMENTS(altitudeRange) EQ 2 THEN BEGIN
        alt_i = GET_ALTITUDE_INDS(dbStruct,altitudeRange[0],altitudeRange[1],LUN=lun)
        region_i=CGSETINTERSECTION(region_i,alt_i)
     ENDIF ELSE BEGIN
        printf,lun,"Incorrect input for keyword 'altitudeRange'!!"
        printf,lun,"Please use altitudeRange=[minAlt maxAlt]"
        RETURN, -1
     ENDELSE
  ENDIF
  
  ;;limits on characteristic electron energies to use?
  IF KEYWORD_SET (charERange) AND is_maximus THEN BEGIN
     IF N_ELEMENTS(charERange) EQ 2 THEN BEGIN
        
        IF KEYWORD_SET(chastDB) THEN  orb_i=where(dbStruct.char_elec_energy GE charERange[0] AND dbStruct.char_elec_energy LE charERange[1]) $
           ELSE orb_i=where(dbStruct.max_chare_losscone GE charERange[0] AND dbStruct.max_chare_losscone LE charERange[1])
        region_i=CGSETINTERSECTION(region_i,orb_i)
     ENDIF ELSE BEGIN
        printf,lun,"Incorrect input for keyword 'charERange'!!"
        printf,lun,"Please use charERange=[minCharE maxCharE]"
        RETURN, -1
     ENDELSE
  ENDIF

  ;; was using this to compare our Poynting flux estimates against Keiling et al. 2003 Fig. 3
  IF KEYWORD_SET(poyntRange) AND is_maximus THEN BEGIN
     IF N_ELEMENTS(poyntRange) NE 2 OR (poyntRange[1] LE poyntRange[0]) THEN BEGIN
        PRINT,"Invalid Poynting range specified! poyntRange should be a two-element vector, [minPoynt maxPoynt]"
        PRINT,"No Poynting range set..."
        RETURN, -1
     ENDIF ELSE BEGIN
        plot_i=CGSETINTERSECTION(plot_i,where(dbStruct.pFluxEst GE poyntRange[0] AND dbStruct.pFluxEst LE poyntRange[1]))
        printf,lun,FORMAT='("Poynting flux limits (eV)     :",T35,G8.2,T45,G8.2)',poyntRange[0],poyntRange[1]
     ENDELSE
  ENDIF


  ;;gotta screen to make sure it's in ACE db too:
  ;;Only so many are useable, since ACE data start in 1998
  
  IF KEYWORD_SET(satellite) THEN BEGIN
     sat_i=GET_SATELLITE_INDS(dbStruct,satellite,LUN=lun)
     good_i=region_i[where(region_i GE sat_i,nGood,complement=lost,ncomplement=nlost)]
     lost=region_i[lost]
  ENDIF ELSE BEGIN
     good_i = region_i
  ENDELSE

  ;;Now, clear out all the garbage (NaNs & Co.)
  ;; IF KEYWORD_SET(chastDB) THEN restore,defChastDB_cleanIndFile ELSE cleaned_i = alfven_db_cleaner(dbStruct,LUN=lun)
  ;; IF KEYWORD_SET(chastDB) THEN cleaned_i = alfven_db_cleaner(dbStruct,LUN=lun,/IS_CHASTDB) ELSE cleaned_i = alfven_db_cleaner(dbStruct,LUN=lun)
  IF is_maximus THEN BEGIN
     cleaned_i = alfven_db_cleaner(dbStruct,LUN=lun, $
                                   IS_CHASTDB=chastDB, $
                                   DO_LSHELL=DO_lshell, $
                                   USING_HEAVIES=using_heavies)
     IF cleaned_i NE !NULL THEN good_i=CGSETINTERSECTION(good_i,cleaned_i)
  ENDIF ELSE BEGIN
     cleaned_i = fastloc_cleaner(dbStruct,LUN=lun)
     IF cleaned_i NE !NULL THEN good_i=CGSETINTERSECTION(good_i,cleaned_i)
  ENDELSE

  ;; IF N_ELEMENTS(dbTimes) EQ 0 THEN dbTimes=str_to_time( dbStruct.time( good_i ) ) $
  ;; ELSE dbTimes = dbTimes[good_i]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Now some other user-specified exclusions set by keyword

  IF (~KEYWORD_SET(chastDB) AND is_maximus) THEN BEGIN
     burst_i = WHERE(dbStruct.burst,nBurst,COMPLEMENT=survey_i,NCOMPLEMENT=nSurvey,/NULL)
     IF KEYWORD_SET(no_burstData) THEN BEGIN
        good_i = CGSETINTERSECTION(survey_i,good_i)
        
        printf,lun,""
        printf,lun,"You're losing " + strtrim(nBurst) + " events because you've excluded burst data."
     ENDIF
     PRINTF,lun,FORMAT='("N burst elements              :",T35,I0)',nBurst
     PRINTF,lun,FORMAT='("N survey elements             :",T35,I0)',nSurvey
     PRINTF,lun,''
  ENDIF

  IF KEYWORD_SET(print_param_summary) THEN BEGIN
     PRINT_ALFVENDB_PLOTSUMMARY,dbStruct,good_i,CLOCKSTR=clockStr, ANGLELIM1=angleLim1, ANGLELIM2=angleLim2, $
                                ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                minMLT=minM,maxMLT=maxM,BINMLT=binM,MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $
                                DO_LSHELL=do_lShell,MINLSHELL=minL,MAXLSHELL=maxL,BINLSHELL=binL, $
                                MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                                HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                                BYMIN=byMin, BZMIN=bzMin, BYMAX=byMax, BZMAX=bzMax, BX_OVER_BYBZ_LIM=Bx_over_ByBz_Lim, $
                                PARAMSTRING=paramString, PARAMSTRPREFIX=plotPrefix,PARAMSTRSUFFIX=plotSuffix,$
                                SATELLITE=satellite, OMNI_COORDS=omni_Coords, $
                                HEMI=hemi, DELAY=delay, STABLEIMF=stableIMF,SMOOTHWINDOW=smoothWindow,INCLUDENOCONSECDATA=includeNoConsecData, $
                                HOYDIA=hoyDia,MASKMIN=maskMin,LUN=lun
  ENDIF
  
  printf,lun,"There are " + strtrim(n_elements(good_i),2) + " total indices making the cut." 
  PRINTF,lun,''
  printf,lun,"****END get_chaston_ind.pro****"
  printf,lun,""

  RETURN, good_i
  
END