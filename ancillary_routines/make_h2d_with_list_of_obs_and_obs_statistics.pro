;;2016/04/15 En route to Vienna from Istanbul. (Turkey rules, by the way, or at least Turkish Airlines does.)
;;Ripped off MAKE_TIMEHIST_DENOMINATOR for this action
PRO MAKE_H2D_WITH_LIST_OF_OBS_AND_OBS_STATISTICS,dbStruct_obsArr, $
   DONT_USE_THESE_INDS=dont_use_these_inds, $
   DO_LISTS_WITH_STATS=do_lists_with_stats, $
   OUTH2D_LISTS_WITH_OBS=outH2D_lists_with_obs,$
   OUTH2D_STATS=outH2D_stats, $
   OUTFILEPREFIX=outFilePrefix, $
   OUTFILESUFFIX=outFileSuffix, $
   OUTDIR=outDir, $
   OUTPUT_TEXTFILE=output_textFile, $
   LUN=lun

  COMPILE_OPT idl2

  COMMON H2D_LIST_OF_INDS,HLOI__H2D_lists_with_inds,HLOI__nInds,HLOI__nMLT,HLOI__nILAT

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
  baseFilePrefix   = todayStr + '--H2D_str_list_of_obs'
  defOutFilePrefix = ''
  defOutFileSuffix = ''

  defOutDir = '/SPENCEdata/Research/Cusp/Alfven_db_routines/'

  IF N_ELEMENTS(outFilePrefix) EQ 0 THEN outFilePrefix = defOutFilePrefix
  IF N_ELEMENTS(outFileSuffix) EQ 0 THEN outFileSuffix = defOutFileSuffix
  IF N_ELEMENTS(outDir) EQ 0 THEN outDir = defOutDir

  outFileName     = todayStr+outFilePrefix+outFileSuffix+'.sav'


  IF FILE_TEST(outDir+outFileName) THEN BEGIN
     PRINTF,lun,'H2D_list_with_obs file already exists: ' + outDir+outFileName
     PRINTF,lun,"Restoring..."
     RESTORE,outDir+outFileName
     IF N_ELEMENTS(outH2D_lists_with_obs) EQ 0 THEN BEGIN
        PRINTF,lun,"Error! No H2D_list_with_inds is in this file! Possibly corrupted/old file?"
        STOP
     ENDIF
  ENDIF ELSE BEGIN

     ;;are we doing a text file?
     IF KEYWORD_SET(output_textFile) THEN BEGIN
        textFileName='txtoutput/'+fNameSansPref + ".txt"

        OPENW,textLun,outDir+textFileName,/GET_LUN
        PRINTF,textLun,"Output from make_fastloc_histo"
        PRINTF,textLun,"The filename gives {min,max,binsize}{MLT,(ILAT|lShell)}--{min,max}Orb"
        PRINTF,textLun,FORMAT='("MLT",T10,"(ILAT|lShell)",T25,"Time in bin (minutes)")'
     ENDIF
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
           tempInds                = CGSETDIFFERENCE(tempInds,dont_use_these_inds,COUNT=tempCount,SUCCESS=remove_bad_inds)
           tempNRemoved            = nTemps-tempCount
           IF tempNRemoved GT 0 THEN BEGIN
              tempH2D_lists_with_inds[j] = LIST(tempInds)
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
  outH2D_stats                             = MAKE_ARRAY(4,HLOI__nMLT,HLOI__nILAT,/DOUBLE)
  outH2D_lists_with_obs                    = MAKE_ARRAY(HLOI__nMLT,HLOI__nILAT,/OBJ)
  FOR j=0,HLOI__nILAT-1 DO BEGIN
     FOR i=0,HLOI__nMLT-1 DO BEGIN
        ;;check if valid
        valid = ISA(tempH2D_lists_with_inds[i,j])
        IF valid THEN BEGIN
           tempObsList                     = LIST(dbStruct_obsArr[(tempH2D_lists_with_inds[i,j])[0]])
           outH2D_lists_with_obs[i,j]      = tempObsList
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
  ENDFOR

  ;; FOR j=0, N_ELEMENTS(HLOI__H2D_lists_with_inds)-1 DO BEGIN

  ;;    tempObsList                           = LIST(dbStruct_obsArr[(tempH2D_lists_with_inds[j])[0]])
  ;;    outH2D_lists_with_obs                 = [outH2D_lists_with_obs,tempObsList]

  ;;    ;;handle stats, if requested
  ;;    IF KEYWORD_SET(do_lists_with_stats) THEN BEGIN
  ;;       IF N_ELEMENTS(tempObsList[0]) GT 0 THEN BEGIN
  ;;          tempStats                       = MOMENT(tempObsList[0])
  ;;       ENDIF ELSE BEGIN
  ;;          tempStats                       = MAKE_ARRAY(4,VALUE=0)
  ;;       ENDELSE
  ;;       outH2D_stats                       = [outH2D_stats,tempStats]
  ;;    ENDIF

  ;; ENDFOR

  ;Now reform the sucker
  outH2D_lists_with_obs                    = REFORM(outH2D_lists_with_obs,HLOI__nMLT,HLOI__nILAT)

  ;;… and these'ns, if requested
  IF KEYWORD_SET(do_lists_with_stats) THEN BEGIN
     outH2D_stats                          = REFORM(outH2D_stats,4,HLOI__nMLT,HLOI__nILAT)
  ENDIF
  
END