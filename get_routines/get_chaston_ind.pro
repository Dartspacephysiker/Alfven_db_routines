;***********************************************
;This script merely accesses the ACE and Chaston
;current filaments databases in order to generate
;Created 01/08/2014
;See 'current_event_Poynt_flux_vs_imf.pro' for
;more info, since that's where this code comes from.

;2015/08/15 Added NO_BURSTDATA keyword

FUNCTION get_chaston_ind,maximus,satellite,lun,DBFILE=dbfile,CDBTIME=cdbTime,CbHASTDB=CHASTDB, $
                         ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange,CHARERANGE=charERange, $
                         BOTH_HEMIS=both_hemis,NORTH=north,SOUTH=south,HEMI=hemi, $
                         HWMAUROVAL=HwMAurOval,HWMKPIND=HwMKpInd, $
                         DAYSIDE=dayside,NIGHTSIDE=nightside, $
                         NO_BURSTDATA=no_burstData
  
  COMMON ContVars, minM, maxM, minI, maxI,binM,binI,minMC,maxNegMC

  ;For statistical auroral oval
  defHwMAurOval=0
  defHwMKpInd=7

  defSatellite = 'OMNI'
  defLun = -1
  ;;***********************************************
  ;;Load up all the dater, working from ~/Research/ACE_indices_data/idl
  
  SETDEFAULTMLT_ILAT_MAGC,MINMLT=minM,MAXMLT=maxM,BINM=binM,MINILAT=minI,MAXILAT=maxI,BINI=binI,MIN_MAGCURRENT=minMC,MAX_NEGMAGCURRENT=maxNegMC,HEMI=hemi
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,DBDir=loaddataDir,DBFile=dbFile,DB_tFile=cdbTimeFile,DO_CHASTDB=chastDB

  IF ~KEYWORD_SET(HwMAurOval) THEN HwMAurOval = defHwMAurOval
  IF ~KEYWORD_SET(HwMKpInd) THEN HwMKpInd = defHwMKpInd


  IF ~KEYWORD_SET(lun) THEN lun = defLun ;stdout

  IF ~KEYWORD_SET(satellite) THEN BEGIN
     PRINTF,lun,"No satellite provided! Setting to '" + defSatellite + "' by default..."
     satellite = defSatellite
  ENDIF

  ;;Welcome message
  printf,lun,""
  printf,lun,"****From get_chaston_ind.pro****"
  printf,lun,"DBFile = " + dbfile
  printf,lun,""

  ;;generate indices based on restrictions in interp_plots.pro

  ;;;;;;;;;;;;
  ;;Handle latitudes
  ind_ilat = GET_ILAT_INDS(maximus,minI,maxI,hemi,N_ILAT=n_ilat,N_NOT_ILAT=n_not_ilat,LUN=lun)
  ;;;;;;;;;;;;
  ;;Handle longitudes
  mlt_i = GET_MLT_INDS(maximus,minM,maxM,DAYSIDE=dayside,NIGHTSIDE=nightside,N_ILAT=n_ilat,N_OUTSIDE_MLT=n_outside_MLT,LUN=lun)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Want just Holzworth/Meng statistical auroral oval?
  IF HwMAurOval THEN ind_region=cgsetintersection(ind_region,where(abs(maximus.ilat) GT auroral_zone(maximus.mlt,HwMKpInd,/lat)/(!DPI)*180.))

  magc_i = GET_MAGC_INDS(maximus,minMC,maxNegMC,N_OUTSIDE_MAGC=n_magc_outside_range)

  ;;;;;;;;;;;;;;;;;;;;;;
  ;;Now combine them all
  ind_region=cgsetintersection(ind_ilat,mlt_i)
  ind_region_magc=cgsetintersection(ind_region,magc_i)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Limits on orbits to use?
  IF KEYWORD_SET (orbRange) THEN BEGIN
     IF N_ELEMENTS(orbRange) EQ 2 THEN BEGIN
        ind_orbs = GET_ORBRANGE_INDS(maximus,orbRange[0],orbRange[1],LUN=lun)
     ENDIF ELSE BEGIN
        printf,lun,"Incorrect input for keyword 'orbRange'!!"
        printf,lun,"Please use orbRange=[minOrb maxOrb]"
        RETURN, -1
     ENDELSE
  ENDIF
  
  ind_region_magc=cgsetintersection(ind_region_magc,ind_orbs)

  ;;limits on altitudes to use?
  IF KEYWORD_SET (altitudeRange) THEN BEGIN
     IF N_ELEMENTS(altitudeRange) EQ 2 THEN BEGIN
        
        printf,lun,"Min altitude: " + strcompress(altitudeRange[0],/remove_all)
        printf,lun,"Max altitude: " + strcompress(altitudeRange[1],/remove_all)

        ind_n_orbs=where(maximus.alt GE altitudeRange[0] AND maximus.alt LE altitudeRange[1])
        ind_region_magc=cgsetintersection(ind_region_magc,ind_n_orbs)
     ENDIF ELSE BEGIN
        printf,lun,"Incorrect input for keyword 'altitudeRange'!!"
        printf,lun,"Please use altitudeRange=[minAlt maxAlt]"
        RETURN, -1
     ENDELSE
  ENDIF
  
  ;;limits on characteristic electron energies to use?
  IF KEYWORD_SET (charERange) THEN BEGIN
     IF N_ELEMENTS(charERange) EQ 2 THEN BEGIN
        
        printf,lun,"Min characteristic electron energy: " + strcompress(charERange[0],/remove_all)
        printf,lun,"Max characteristic electron energy: " + strcompress(charERange[1],/remove_all)

        IF KEYWORD_SET(chastDB) THEN  ind_n_orbs=where(maximus.char_elec_energy GE charERange[0] AND maximus.char_elec_energy LE charERange[1]) $
           ELSE ind_n_orbs=where(maximus.max_chare_losscone GE charERange[0] AND maximus.max_chare_losscone LE charERange[1])
        ind_region_magc=cgsetintersection(ind_region_magc,ind_n_orbs)
     ENDIF ELSE BEGIN
        printf,lun,"Incorrect input for keyword 'charERange'!!"
        printf,lun,"Please use charERange=[minCharE maxCharE]"
        RETURN, -1
     ENDELSE
  ENDIF


  ;;gotta screen to make sure it's in ACE db too:
  ;;Only so many are useable, since ACE data start in 1998
  
  ind_ACEstart=(satellite EQ "ACE") ? 82896 : 0
  
  ind_region_magc_ACEstart=ind_region_magc(where(ind_region_magc GE ind_ACEstart,$
                                                                 nGood,complement=lost,ncomplement=nlost))
  lost=ind_region_magc(lost)

  ;;Now, clear out all the garbage (NaNs & Co.)
  ;; IF KEYWORD_SET(chastDB) THEN restore,defChastDB_cleanIndFile ELSE good_i = alfven_db_cleaner(maximus,LUN=lun)
  IF KEYWORD_SET(chastDB) THEN good_i = alfven_db_cleaner(maximus,LUN=lun,/IS_CHASTDB) ELSE good_i = alfven_db_cleaner(maximus,LUN=lun)

  IF good_i NE !NULL THEN ind_region_magc_ACEstart=cgsetintersection(ind_region_magc_ACEstart,good_i)

  ;Re-make cdbTime if we don't have it made already
  IF N_ELEMENTS(cdbTime) EQ 0 THEN cdbTime=str_to_time( maximus.time( ind_region_magc_ACEstart ) ) $
  ELSE cdbTime = cdbTime(ind_region_magc_ACEstart)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;Now some other user-specified exclusions set by keyword

  IF ~KEYWORD_SET(chastDB) THEN BEGIN
     burst_i = WHERE(maximus.burst,nBurst,COMPLEMENT=survey_i,NCOMPLEMENT=nSurvey,/NULL)
     IF KEYWORD_SET(no_burstData) THEN BEGIN
        ind_region_magc_ACEstart = cgsetintersection(survey_i,ind_region_magc_ACEstart)
        
        printf,lun,""
        printf,lun,"You're losing " + strtrim(nBurst) + " events because you've excluded burst data."
     ENDIF
     PRINTF,lun,'N burst elements: ' + STRCOMPRESS(nBurst,/REMOVE_ALL)
     PRINTF,lun,'N survey elements: ' + STRCOMPRESS(nSurvey,/REMOVE_ALL)
     PRINTF,lun,''
  ENDIF

  IF KEYWORD_SET (orbRange) AND N_ELEMENTS(orbRange) EQ 2 THEN BEGIN
     printf,lun,"Min orbit: " + strcompress(orbRange[0],/remove_all)
     printf,lun,"Max orbit: " + strcompress(orbRange[1],/remove_all)
  ENDIF
  IF KEYWORD_SET (altitudeRange) AND N_ELEMENTS(altitudeRange) EQ 2 THEN BEGIN
     printf,lun,"Min altitude: " + strcompress(altitudeRange[0],/remove_all)
     printf,lun,"Max altitude: " + strcompress(altitudeRange[1],/remove_all)
  ENDIF
  IF KEYWORD_SET (charERange) AND N_ELEMENTS(charERange) EQ 2 THEN BEGIN
     printf,lun,"Min characteristic electron energy: " + strcompress(charERange[0],/remove_all)
     printf,lun,"Max characteristic electron energy: " + strcompress(charERange[1],/remove_all)
  ENDIF
  IF (satellite EQ "ACE") THEN $
     printf,lun,"You're losing " + strtrim(nlost,2) + $
            " current events because ACE data doesn't start until " + strtrim(maximus.time(ind_ACEstart),2) + "."

  printf,lun,"There are " + strtrim(n_elements(ind_region_magc_ACEstart),2) + " total events making the cut." 
  PRINTF,lun,''
  printf,lun,"****END get_chaston_ind.pro****"
  printf,lun,""

  RETURN, ind_region_magc_ACEstart
  
END