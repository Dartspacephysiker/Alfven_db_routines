;2015/10/20 This files reads what gets parsed by rd_fastloc3_output
;*fastloc_intervals1 uses electron data to get data intervals and outputs FAST ephemeris data at the same resolution as the ESA data.
;*fastloc_intervals2 uses electron data to get data intervals, but outputs data with 5-s resolution (as opposed to the resolution of
;  the particle data).
;*fastloc_intervals3 uses electron data to get data intervals at 5-s resolution, and very importantly includes the sample period of 
;  the fluxgate magnetometer.
;*fastloc_intervals4 uses electron data to get data intervals, with 2.5-s resolution, and corrects an important timing bug in the other
;code!

PRO COMBINE_FASTLOC_INTERVALS4,fastLoc

  ;; date='20160204'
  date            = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  fastLoc_DB      = '/SPENCEdata/software/sdt/batch_jobs/FASTlocation/batch_output__intervals--20160201/'
  contents_file   = './orbits_contained_in_fastloc_'+date+'.txt'

  ;; minOrb       = 14064
  ;; maxOrb       = 16361

  minOrb          = 500
  maxOrb          = 4999

  fNamePrefix     = 'Dartmouth_fastloc_intervals4'
  fNameSuffix     = '--below_aur_oval.sav'
  fNameSuffLen    = STRLEN(fNameSuffix)

  outDir          = '/SPENCEdata/Research/database/time_histos/'
  ;; outSuffix    = '500-3126--below_aur_oval'
  ;; outSuffix    = '3127-5999--below_aur_oval'
  ;; outSuffix    = '6000-10780--below_aur_oval'
  outSuffix       = STRING(FORMAT='(I0,"--",I0,"--below_aur_oval")',minOrb,maxOrb)
  outFileSansFExt = 'fastLoc_intervals4--'+outSuffix+'--'+date
  outFile         = outFileSansFExt+'.sav'
  outTimeFile     = outFileSansFExt+'--times.sav'
  outTimeFile_raw = outFileSansFExt+'--times.sav_raw'

 ;open file to write list of orbits included
  OPENW,outlun,contents_file,/get_lun

  FOR j=minOrb,maxOrb DO BEGIN
     
     filename     = fNamePrefix+'_'+strcompress(j,/remove_all)+'_0'+fNameSuffix
                                ;filename='orb'+strcompress(j,/remove_all)+'_dflux'
     result       = file_which(fastLoc_DB,filename)
     IF result THEN BEGIN
        FOR jj=0,12 DO BEGIN
           result = FILE_WHICH(fastLoc_DB,filename)
           IF result THEN BEGIN
              RESTORE,fastLoc_DB+filename
              print,j,jj
              printf,outlun,j,jj
              IF j GT minOrb THEN BEGIN
                 fastLoc={ORBIT:[fastLoc.orbit,fastLoc_intervals.orbit],$
                          TIME:[fastLoc.time,fastLoc_intervals.time],$
                          ALT:[fastLoc.alt,fastLoc_intervals.alt],$
                          MLT:[fastLoc.mlt,fastLoc_intervals.mlt],$
                          ILAT:[fastLoc.ilat,fastLoc_intervals.ilat],$
                          FIELDS_MODE:[fastLoc.fields_mode,fastLoc_intervals.fields_mode],$
                          SAMPLE_T:[fastLoc.sample_t,fastLoc_intervals.sample_t],$
                          INTERVAL:[fastLoc.interval,fastLoc_intervals.interval],$
                          INTERVAL_START:[fastLoc.interval_start,fastLoc_intervals.interval_start],$
                          INTERVAL_STOP:[fastLoc.interval_stop,fastLoc_intervals.interval_stop]}
                          ;; INTERVAL_STOP:[fastLoc.INTERVAL_STOP,fastLoc_intervals.INTERVAL_STOP],$
                          ;; LSHELL:[fastLoc.LSHELL,fastLoc_intervals.LSHELL]}
              ENDIF ELSE BEGIN
                 fastLoc=fastLoc_intervals
              ENDELSE
           ENDIF
           filename=fNamePrefix+'_'+strcompress(j,/remove_all)+'_'+strcompress(jj+1,/remove_all)+fNameSuffix
        ENDFOR
     ENDIF ELSE PRINT,"Couldn't open " + filename + "!!!"
  ENDFOR
  
  save,fastLoc,FILENAME=outDir+outFile
  
  ;do fastloctimes
  fastloc_times                                   = str_to_time(fastLoc.time)
  fastLoc_delta_t                                 = shift(fastLoc_Times,-1)-fastLoc_Times
  save,fastLoc_Times,fastLoc_delta_t,FILENAME=outDir+outTimeFile_raw
  fastLoc_delta_t[-1]                             = 2.5    ;treat last element specially, since otherwise it is a huge negative number
  ;; fastLoc_delta_t                                = ROUND(fastLoc_delta_t*4.0)/4.0          ;round to nearest quarter of a second
  fastLoc_delta_t[WHERE(fastLoc_delta_t GT 5.0)]  = 2.5    ;many events with a large delta_t correspond to ends of intervals/orbits
  save,fastloc_times,fastLoc_delta_t,FILENAME=outDir+outTimeFile

  RETURN
  
END
