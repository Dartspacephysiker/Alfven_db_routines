;;2016/04/15 En route to Vienna from Istanbul. (Turkey rules, by the way, or at least Turkish Airlines does.)
;;Ripped off MAKE_TIMEHIST_DENOMINATOR for this action
PRO MAKE_H2D_WITH_LIST_OF_INDS_FOR_EACH_BIN,dbStruct,dbStruct_inds, $
   OUTH2D_LISTS_WITH_INDS=outH2D_lists_with_inds, $
   MINMLT=minMLT, $
   MAXMLT=maxMLT, $
   BINMLT=binMLT, $
   SHIFTMLT=shiftM, $
   MINILAT=minILAT, $
   MAXILAT=maxILAT, $
   BINILAT=binILAT, $
   DO_LSHELL=do_lShell,MINLSHELL=minLshell,MAXLSHELL=maxLshell,BINLSHELL=binLshell, $
   MINALT=minAlt, $
   MAXALT=maxAlt, $
   BINALT=binAlt, $
   OUTFILEPREFIX=outFilePrefix, $
   OUTFILESUFFIX=outFileSuffix, $
   OUTDIR=outDir, $
   OUTPUT_TEXTFILE=output_textFile, $
   RESET_H2D_LISTS_WITH_INDS=reset_H2D_lists_with_inds, $
   LUN=lun

  COMPILE_OPT idl2

  ;;Because MAKE_H2D_WITH_LIST_OF_OBS_AND_OBS_STATISTICS wants to use 'em too
  COMMON H2D_LIST_OF_INDS,HLOI__H2D_lists_with_inds,HLOI__nInds,HLOI__nMLT,HLOI__nILAT

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  IF N_ELEMENTS(HLOI_H2D_lists_with_inds) GT 0 THEN BEGIN
     IF KEYWORD_SET(reset_H2D_lists_with_inds) THEN BEGIN
        PRINTF,lun,"Resetting H2D_lists_with_inds ..."
     ENDIF ELSE BEGIN
        PRINTF,lun,"Already have an H2D_list_with_inds! Passing it over and stepping out ..."
        outH2D_lists_with_inds     = HLOI__H2D_lists_with_inds
        RETURN
     ENDELSE
  ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Doing text output?
  todayStr         = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  baseFilePrefix   = todayStr + '--H2D_str_list_of_inds'
  defOutFilePrefix = ''
  defOutFileSuffix = ''

  defOutDir = '/SPENCEdata/Research/Cusp/Alfven_db_routines/'

  IF N_ELEMENTS(outFilePrefix) EQ 0 THEN outFilePrefix = defOutFilePrefix
  IF N_ELEMENTS(outFileSuffix) EQ 0 THEN outFileSuffix = defOutFileSuffix
  IF N_ELEMENTS(outDir) EQ 0 THEN outDir = defOutDir

  outFileName     = todayStr+outFilePrefix+outFileSuffix+'.sav'


  IF FILE_TEST(outDir+outFileName) THEN BEGIN
     PRINTF,lun,'H2D_list_with_inds file already exists: ' + outDir+outFileName
     PRINTF,lun,"Restoring..."
     RESTORE,outDir+outFileName
     IF N_ELEMENTS(outH2D_lists_with_inds) EQ 0 THEN BEGIN
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


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;SET UP GRID
  nXlines                                  = (maxMLT-minMLT)/binMLT + 1
  nYlines                                  = ((KEYWORD_SET(do_lShell) ? maxLshell : maxILAT)-(KEYWORD_SET(do_lShell) ? minLshell : minILAT))/(KEYWORD_SET(do_lShell) ? binLshell : binILAT) + 1

  mlts                                     = INDGEN(nXlines)*binMLT+minMLT
  ilats                                    = INDGEN(nYlines)*(KEYWORD_SET(do_lShell) ? binLshell : binILAT)+(KEYWORD_SET(do_lShell) ? minLshell : minILAT)

  nMLT                                     = N_ELEMENTS(mlts)
  nILAT                                    = N_ELEMENTS(ilats)
  nInds                                    = 0

  ;; outH2D_lists_with_inds                = MAKE_ARRAY(nMLT,nILAT,/DOUBLE) ;how long FAST spends in each bin

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;fix MLTs, if need be
  IF shiftM GT 0. THEN PRINT,'Shifting dbStruct MLTs by ' + STRCOMPRESS(shiftM,/REMOVE_ALL) + '...'
  dbStructMLTs                             = dbStruct.mlt[dbStruct_inds]-shiftM
  dbStructMLTs[WHERE(dbStructMLTs LT 0.)]  = dbStructMLTs[WHERE(dbStructMLTs LT 0.)] + 24.

  dbStructILATS                            = (KEYWORD_SET(do_lShell) ? dbStruct.lShell : dbStruct.ILAT)[dbStruct_inds]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;loop over MLTs and ILATs
  outH2D_lists_with_inds                   = !NULL
  ;; outH2D_lists_with_obs                 = !NULL
  FOR j=0, nILAT-2 DO BEGIN
     FOR i=0, nMLT-2 DO BEGIN
        tempIndsList                       = LIST(WHERE(dbStructMLTs GE mlts[i] AND $
                                                        dbStructMLTs LT mlts[i+1] AND $
                                                        dbStructILATS GE ilats[j] AND $
                                                        dbStructILATS LT ilats[j+1],nTemp,/NULL))
        ;;Whether empty or not, add to the array of lists
        outH2D_lists_with_inds             = [outH2D_lists_with_inds,tempIndsList]
        nInds                             += nTemp

        ;; IF KEYWORD_SET(do_lists_with_obs) THEN BEGIN
        ;;    outH2D_lists_with_obs        = [outH2D_lists_with_obs,dbStruct_obsArr[tempIndsList[0]]]
        ;; ENDIF
     ENDFOR
  ENDFOR

  ;Now reform the sucker
  outH2D_lists_with_inds                   = REFORM(outH2D_lists_with_inds,nMLT,nILAT)
  ;; outH2D_lists_with_obs                 = REFORM(outH2D_lists_with_obs,nMLT,nILAT)
  STOP ;cause we're new
  
  HLOI__H2D_lists_with_inds                = outH2D_lists_with_inds
  HLOI__nInds                              = nInds
  HLOI__nMLT                               = nMLT
  HLOI__nILAT                              = nILAT

END