PRO COMBINE_FASTLOC_INTERVALS4_STRUCTS__FINAL_STEP,fastLoc

  date                      = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  file1minOrb               = 500
  file1maxOrb               = 10999
  file1date                 = '20160204'

  file1Suffix              = STRING(FORMAT='(I0,"--",I0,"--below_aur_oval")',file1minOrb,file1maxOrb)
  file1FileSansFExt        = 'fastLoc_intervals4--'+file1Suffix+'--'+file1date
  file1File                = file1FileSansFExt+'.sav'
  file1TimeFile            = file1FileSansFExt+'--times.sav'
  file1TimeFile_raw        = file1FileSansFExt+'--times.sav_raw'

  file2minOrb               = 11000
  file2maxOrb               = 16499
  file2date                 = '20160205'

  file2Suffix              = STRING(FORMAT='(I0,"--",I0,"--below_aur_oval")',file2minOrb,file2maxOrb)
  file2FileSansFExt        = 'fastLoc_intervals4--'+file2Suffix+'--'+file2date
  file2File                = file2FileSansFExt+'.sav'
  file2TimeFile            = file2FileSansFExt+'--times.sav'
  file2TimeFile_raw        = file2FileSansFExt+'--times.sav_raw'

  fNamePrefix               = 'Dartmouth_fastloc_intervals4'
  fNameSuffix               = '--below_aur_oval.sav'
  fNameSuffLen              = STRLEN(fNameSuffix)

  outDir                    = '/SPENCEdata/Research/database/FAST_ephemeris/fastLoc_intervals4/'

  outMaxSuffix              = STRING(FORMAT='(I0,"--",I0,"--below_aur_oval")',file1minOrb,file2maxOrb)
  outMaxFileSansFExt        = 'fastLoc_intervals4--'+outMaxSuffix+'--'+date
  outMaxFile                = outMaxFileSansFExt+'.sav'
  outMaxTimeFile            = outMaxFileSansFExt+'--times.sav'
  outMaxTimeFile_raw        = outMaxFileSansFExt+'--times.sav_raw'

  RESTORE,outDir+file1File
  fastLoc1                  = fastLoc

  RESTORE,outDir+file1TimeFile
  fastloc_times1            = fastloc_times
  fastloc_delta_t1          = fastloc_delta_t

  RESTORE,outDir+file1TimeFile_raw
  fastloc_times1_raw        = fastloc_times
  fastloc_delta_t1_raw      = fastloc_delta_t

  ;;Now file 2
  RESTORE,outDir+file2File
  fastLoc2                  = fastLoc

  RESTORE,outDir+file2TimeFile
  fastloc_times2            = fastloc_times
  fastloc_delta_t2          = fastloc_delta_t

  RESTORE,outDir+file2TimeFile_raw
  fastloc_times2_raw        = fastloc_times
  fastloc_delta_t2_raw      = fastloc_delta_t

  fastLoc={ORBIT:[fastloc1.orbit,fastloc2.orbit],$
           TIME:[fastloc1.time,fastloc2.time],$
           ALT:[fastloc1.alt,fastloc2.alt],$
           MLT:[fastloc1.mlt,fastloc2.mlt],$
           ILAT:[fastloc1.ilat,fastloc2.ilat],$
           FIELDS_MODE:[fastloc1.fields_mode,fastloc2.fields_mode],$
           SAMPLE_T:[fastloc1.sample_t,fastloc2.sample_t],$
           INTERVAL:[fastloc1.interval,fastloc2.interval],$
           INTERVAL_START:[fastloc1.interval_start,fastloc2.interval_start],$
           INTERVAL_STOP:[fastloc1.interval_stop,fastloc2.interval_stop]}
        ;; INTERVAL_STOP:[fastloc1.INTERVAL_STOP,fastloc2.INTERVAL_STOP],$
        ;; LSHELL:[fastloc1.LSHELL,fastloc2.LSHELL]}
     

  PRINT,'Saving fastLoc to ' + outMaxFile + '...'
  save,fastLoc,FILENAME=outDir+outMaxFile

  ;;Handle den andre
  fastLoc_times                                      = [fastLoc_times1,fastLoc_times2]
  fastLoc_delta_t                                    = [fastLoc_delta_t1,fastLoc_delta_t2]

  PRINT,'Saving fastLoc_times & Co. to ' + outMaxTimeFile + '...'
  save,fastloc_times,fastLoc_delta_t,FILENAME=outDir+outMaxTimeFile
  
  fastLoc_times                                      = [fastLoc_times1_raw,fastLoc_times2_raw]
  fastLoc_delta_t                                    = [fastLoc_delta_t1_raw,fastLoc_delta_t2_raw]

  PRINT,'Saving fastLoc_times_raw & Co. to ' + outMaxTimeFile_raw + '...'
  save,fastLoc_Times,fastLoc_delta_t,FILENAME=outDir+outMaxTimeFile_raw

  RETURN

END