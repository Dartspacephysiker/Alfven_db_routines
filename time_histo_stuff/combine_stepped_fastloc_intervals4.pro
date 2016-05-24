;2016/02/04 This PRO takes what is outputted by COMBINE_FASTLOC_INTERVALS4_STEPS, and goes about combining THOSE into something more
;dense. K?
PRO COMBINE_STEPPED_FASTLOC_INTERVALS4,fastLoc

  date                      = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  fastLoc_DB                = '/SPENCEdata/software/sdt/batch_jobs/FASTlocation/batch_output__intervals--20160201/'
  ;; contents_file             = './orbits_contained_in_fastloc_'+date+'.txt'

  ;; minOrb                    = 500
  ;; maxOrb                    = 11000

  minOrb                    = 11000
  ;; minOrb                    = 16000
  maxOrb                    = 16500
  fileStep                  = 125

  fNamePrefix               = 'Dartmouth_fastloc_intervals4'
  fNameSuffix               = '--below_aur_oval.sav'
  fNameSuffLen              = STRLEN(fNameSuffix)

  outDir                    = '/SPENCEdata/Research/database/FAST_ephemeris/fastLoc_intervals4/'

  outMaxSuffix              = STRING(FORMAT='(I0,"--",I0,"--below_aur_oval")',minOrb,maxOrb-1)
  outMaxFileSansFExt        = 'fastLoc_intervals4--'+outMaxSuffix+'--'+date
  outMaxFile                = outMaxFileSansFExt+'.sav'
  outMaxTimeFile            = outMaxFileSansFExt+'--times.sav'
  outMaxTimeFile_raw        = outMaxFileSansFExt+'--times.sav_raw'

 ;open file to write list of orbits included
  ;; OPENW,outlun,contents_file,/get_lun

  i                         = 0
  nSteps                    = (maxOrb-minOrb)/fileStep+1

  ;Get list of files to concatenate
  outFileArr                = !NULL
  outTimeFileArr            = !NULL
  outTF_rawArr              = !NULL
  WHILE i LT nSteps DO BEGIN

     stepMin                = minOrb+i*fileStep
     stepMax                = minOrb+(i+1)*fileStep-1

     outSuffix              = STRING(FORMAT='(I0,"--",I0,"--below_aur_oval")',stepMin,stepMax)
     outFileSansFExt        = 'fastLoc_intervals4--'+outSuffix+'--'+date
     outFile                = outFileSansFExt+'.sav'
     outTimeFile            = outFileSansFExt+'--times.sav'
     outTimeFile_raw        = outFileSansFExt+'--times.sav_raw'

     result_out             = file_which(outDir,outFile)
     result_TF              = file_which(outDir,outTimeFile)
     result_TF_raw          = file_which(outDir,outTimeFile_raw)
     
     IF result_out THEN BEGIN
        outFileArr          = [outFileArr,outFile]
     ENDIF ELSE PRINT,"Couldn't open " + outFile + "!!!"
     
     IF result_TF THEN BEGIN
        outTimeFileArr      = [outTimeFileArr,outTimeFile]
     ENDIF ELSE PRINT,"Couldn't open " + outTimeFile + "!!!"
     
     IF result_TF_raw THEN BEGIN
        outTF_rawArr        = [outTF_rawArr,outTimeFile_raw]
     ENDIF ELSE PRINT,"Couldn't open " + outTimeFile_raw + "!!!"
     
     i++
  ENDWHILE

  nFiles                    = N_ELEMENTS(outFileArr)
  nTF                       = N_ELEMENTS(outTimeFileArr)
  nTF_raw                   = N_ELEMENTS(outTF_rawArr)

  IF (nFiles NE nTF) OR (nFiles NE nTF_raw) OR (nTF NE nTF_raw) THEN BEGIN
     PRINT,"Unequal numbers of files!"
     PRINT,"N Files          : ",STRCOMPRESS(nFiles,/REMOVE_ALL)
     PRINT,"N Time Files     : ",STRCOMPRESS(nTF,/REMOVE_ALL)
     PRINT,"N Raw Time Files : ",STRCOMPRESS(nTF_raw,/REMOVE_ALL)
     PRINT,'Exiting ...'
     RETURN
  ENDIF

  ;;Print list of files
  PRINT,'File Array (each includes a time file and a raw time file)'
  FOR i=0,nFiles-1 DO BEGIN
     PRINT,outFileArr[i]
  ENDFOR

  choice   = ''
  breakout = 0
  EXITOSO  = 0
  ;; Read input from the terminal:
  nBefore = N_ELEMENTS(data)

  READ, choice, PROMPT='Combine these little guys? (Y/N)'
  WHILE breakout EQ 0 DO BEGIN
     CASE STRUPCASE(choice) OF
        'Y': BEGIN
           breakout = 1
           exitoso  = 0
           PRINT,'K, proceeding ...'
        END
        'N': BEGIN
           breakout = 1
           exitoso  = 1
           PRINT,'K, exiting ...'
        END
        ELSE: PRINT,'Bad selection; please type Y or N'
     ENDCASE
  ENDWHILE

  IF exitoso THEN BEGIN
     RETURN
  ENDIF

  FOR i=0,nFiles-1 DO BEGIN

     RESTORE,outDir+outFileArr[i]
     print,outFileArr[i]
     ;; printf,outlun,j,jj
     IF i GT 0 THEN BEGIN
        fastLoc_max={ORBIT:[fastLoc_max.orbit,fastLoc.orbit],$
                     TIME:[fastLoc_max.time,fastLoc.time],$
                     ALT:[fastLoc_max.alt,fastLoc.alt],$
                     MLT:[fastLoc_max.mlt,fastLoc.mlt],$
                     ILAT:[fastLoc_max.ilat,fastLoc.ilat],$
                     FIELDS_MODE:[fastLoc_max.fields_mode,fastLoc.fields_mode],$
                     SAMPLE_T:[fastLoc_max.sample_t,fastLoc.sample_t],$
                     INTERVAL:[fastLoc_max.interval,fastLoc.interval],$
                     INTERVAL_START:[fastLoc_max.interval_start,fastLoc.interval_start],$
                     INTERVAL_STOP:[fastLoc_max.interval_stop,fastLoc.interval_stop]}
        ;; INTERVAL_STOP:[fastLoc_max.INTERVAL_STOP,fastLoc.INTERVAL_STOP],$
        ;; LSHELL:[fastLoc_max.LSHELL,fastLoc.LSHELL]}
     ENDIF ELSE BEGIN
        PRINT,'Got the first file: ',outFileArr[i]
        fastLoc_max = fastLoc
     ENDELSE
     
     RESTORE,outDir+outTimeFileArr[i]
     IF i GT 0 THEN BEGIN
        fastLoc_times_max                            = [fastLoc_times_max,fastLoc_times]
        fastLoc_delta_t_max                          = [fastLoc_delta_t_max,fastLoc_delta_t]
     ENDIF ELSE BEGIN
        fastLoc_times_max                            = fastLoc_times
        fastLoc_delta_t_max                          = fastLoc_delta_t
     ENDELSE

  ENDFOR

  ;;get the names right again
  fastLoc                                            = fastLoc_max
  fastLoc_times                                      = fastLoc_times_max
  fastLoc_delta_t                                    = fastLoc_delta_t_max

  PRINT,'Saving fastLoc to ' + outMaxFile + '...'
  save,fastLoc,FILENAME=outDir+outMaxFile

  PRINT,'Saving fastLoc_times & Co. to ' + outMaxTimeFile + '...'
  save,fastloc_times,fastLoc_delta_t,FILENAME=outDir+outMaxTimeFile
  


  ;;Now do raw files
  fastLoc_times_max                                  = !NULL
  fastLoc_delta_t_max                                = !NULL
  FOR i=0,nFiles-1 DO BEGIN
     RESTORE,outDir+outTF_rawArr[i]
     IF i GT 0 THEN BEGIN
        fastLoc_times_max                            = [fastLoc_times_max,fastLoc_times]
        fastLoc_delta_t_max                          = [fastLoc_delta_t_max,fastLoc_delta_t]
     ENDIF ELSE BEGIN
        fastLoc_times_max                            = fastLoc_times
        fastLoc_delta_t_max                          = fastLoc_delta_t
     ENDELSE

  ENDFOR

  ;;Get the names right
  fastLoc_times                                      = fastLoc_times_max
  fastLoc_delta_t                                    = fastLoc_delta_t_max

  PRINT,'Saving fastLoc_times_raw & Co. to ' + outMaxTimeFile + '...'
  save,fastLoc_Times,fastLoc_delta_t,FILENAME=outDir+outMaxTimeFile_raw



  RETURN

END
