;***********************************************
;This script merely accesses the ACE and Chaston
;current filaments databases in order to generate
;Created 01/08/2014
;See 'current_event_Poynt_flux_vs_imf.pro' for
;more info, since that's where this code comes from.

;2015/10/09 Overhauling so that this can be used for time histos or Alfven DB structures
;2015/08/15 Added NO_BURSTDATA keyword

FUNCTION GET_CHASTON_IND,dbStruct,satellite,lun,DBFILE=dbfile,DBTIMES=dbTimes,CHASTDB=CHASTDB, $
                         ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange,CHARERANGE=charERange, $
                         BOTH_HEMIS=both_hemis,NORTH=north,SOUTH=south,HEMI=hemi, $
                         HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                         MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI, $
                         MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC, $
                         DAYSIDE=dayside,NIGHTSIDE=nightside, $
                         NO_BURSTDATA=no_burstData,GET_TIME_I_NOT_ALFVENDB_I=get_time_i_not_alfvendb_i
  COMPILE_OPT idl2
 
;;  COMMON ContVars, minM, maxM, minI, maxI,binM,binI,minMC,maxNegMC

  ;For statistical auroral oval
  defHwMAurOval=0
  defHwMKpInd=7

  defLun = -1

  is_maximus = 0        ;We assume this is not maximus
  ;;***********************************************
  ;;Load up all the dater, working from ~/Research/ACE_indices_data/idl
  
  SET_DEFAULT_MLT_ILAT_AND_MAGC,MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI,MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC,HEMI=hemi

  IF KEYWORD_SET(get_time_i_NOT_alfvendb_i) THEN BEGIN
     LOAD_FASTLOC_AND_FASTLOC_TIMES,dbStruct,dbTimes,DBDir=loaddataDir,DBFile=dbFile,DB_tFile=dbTimesFile
     is_maximus = 0
  ENDIF ELSE BEGIN
     LOAD_MAXIMUS_AND_CDBTIME,dbStruct,dbTimes,DBDir=loaddataDir,DBFile=dbFile,DB_tFile=dbTimesFile,DO_CHASTDB=chastDB
     is_maximus = 1
  ENDELSE

  IF ~KEYWORD_SET(HwMAurOval) THEN HwMAurOval = defHwMAurOval
  IF ~KEYWORD_SET(HwMKpInd) THEN HwMKpInd = defHwMKpInd


  IF ~KEYWORD_SET(lun) THEN lun = defLun ;stdout

  ;;Welcome message
  printf,lun,""
  printf,lun,"****From get_chaston_ind.pro****"
  printf,lun,"DBFile = " + dbfile
  printf,lun,""

  ;;;;;;;;;;;;;;;
  ;;Check whether this is a maximus or fastloc struct
  IS_STRUCT_ALFVENDB_OR_FASTLOC,dbStruct,is_maximus

  ;;;;;;;;;;;;
  ;;Handle latitudes
  ilat_i = GET_ILAT_INDS(dbStruct,minI,maxI,hemi,N_ILAT=n_ilat,N_NOT_ILAT=n_not_ilat,LUN=lun)
  ;;;;;;;;;;;;
  ;;Handle longitudes
  mlt_i = GET_MLT_INDS(dbStruct,minM,maxM,DAYSIDE=dayside,NIGHTSIDE=nightside,N_ILAT=n_ilat,N_OUTSIDE_MLT=n_outside_MLT,LUN=lun)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Want just Holzworth/Meng statistical auroral oval?
  IF HwMAurOval THEN ind_region=cgsetintersection(ind_region,where(abs(dbStruct.ilat) GT auroral_zone(dbStruct.mlt,HwMKpInd,/lat)/(!DPI)*180.))


  ;;;;;;;;;;;;;;;;;;;;;;
  ;;Now combine them all
  final_i=cgsetintersection(ilat_i,mlt_i)
  IF is_maximus THEN BEGIN
     magc_i = GET_MAGC_INDS(dbStruct,minMC,maxNegMC,N_OUTSIDE_MAGC=n_magc_outside_range)
     final_i=cgsetintersection(final_i,magc_i)
  ENDIF

  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Limits on orbits to use?
  IF KEYWORD_SET (orbRange) THEN BEGIN
     IF N_ELEMENTS(orbRange) EQ 2 THEN BEGIN
        orb_i = GET_ORBRANGE_INDS(dbStruct,orbRange[0],orbRange[1],LUN=lun)
        final_i=cgsetintersection(final_i,orb_i)
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
        final_i=cgsetintersection(final_i,alt_i)
     ENDIF ELSE BEGIN
        printf,lun,"Incorrect input for keyword 'altitudeRange'!!"
        printf,lun,"Please use altitudeRange=[minAlt maxAlt]"
        RETURN, -1
     ENDELSE
  ENDIF
  
  ;;limits on characteristic electron energies to use?
  IF KEYWORD_SET (charERange) AND is_maximus THEN BEGIN
     IF N_ELEMENTS(charERange) EQ 2 THEN BEGIN
        
        printf,lun,"Min characteristic electron energy: " + strcompress(charERange[0],/remove_all)
        printf,lun,"Max characteristic electron energy: " + strcompress(charERange[1],/remove_all)

        IF KEYWORD_SET(chastDB) THEN  orb_i=where(dbStruct.char_elec_energy GE charERange[0] AND dbStruct.char_elec_energy LE charERange[1]) $
           ELSE orb_i=where(dbStruct.max_chare_losscone GE charERange[0] AND dbStruct.max_chare_losscone LE charERange[1])
        final_i=cgsetintersection(final_i,orb_i)
     ENDIF ELSE BEGIN
        printf,lun,"Incorrect input for keyword 'charERange'!!"
        printf,lun,"Please use charERange=[minCharE maxCharE]"
        RETURN, -1
     ENDELSE
  ENDIF

  ;;gotta screen to make sure it's in ACE db too:
  ;;Only so many are useable, since ACE data start in 1998
  
  sat_i=GET_SATELLITE_INDS(dbStruct,satellite,LUN=lun)
  final_i_ACEstart=final_i[where(final_i GE sat_i,$
                                                                 nGood,complement=lost,ncomplement=nlost)]
  lost=final_i[lost]

  ;;Now, clear out all the garbage (NaNs & Co.)
  ;; IF KEYWORD_SET(chastDB) THEN restore,defChastDB_cleanIndFile ELSE good_i = alfven_db_cleaner(dbStruct,LUN=lun)
  ;; IF KEYWORD_SET(chastDB) THEN good_i = alfven_db_cleaner(dbStruct,LUN=lun,/IS_CHASTDB) ELSE good_i = alfven_db_cleaner(dbStruct,LUN=lun)
  IF is_maximus THEN BEGIN
     good_i = alfven_db_cleaner(dbStruct,LUN=lun,IS_CHASTDB=chastDB)
     IF good_i NE !NULL THEN final_i_ACEstart=cgsetintersection(final_i_ACEstart,good_i)
  ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Now some other user-specified exclusions set by keyword

  IF (~KEYWORD_SET(chastDB) AND is_maximus) THEN BEGIN
     burst_i = WHERE(dbStruct.burst,nBurst,COMPLEMENT=survey_i,NCOMPLEMENT=nSurvey,/NULL)
     IF KEYWORD_SET(no_burstData) THEN BEGIN
        final_i_ACEstart = cgsetintersection(survey_i,final_i_ACEstart)
        
        printf,lun,""
        printf,lun,"You're losing " + strtrim(nBurst) + " events because you've excluded burst data."
     ENDIF
     PRINTF,lun,'N burst elements: ' + STRCOMPRESS(nBurst,/REMOVE_ALL)
     PRINTF,lun,'N survey elements: ' + STRCOMPRESS(nSurvey,/REMOVE_ALL)
     PRINTF,lun,''
  ENDIF

  printf,lun,"There are " + strtrim(n_elements(final_i_ACEstart),2) + " total indices making the cut." 
  PRINTF,lun,''
  printf,lun,"****END get_chaston_ind.pro****"
  printf,lun,""

  RETURN, final_i_ACEstart
  
END