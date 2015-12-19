;2015/12/19 Time to map Poyntingf flux
; Remember, Chaston et al. [2003] justify the use of the Poynting flux estimate in the Alf DB
; Check it out if you're curious
PRO COMBINE_MAPPING_RATIO_FILES,mapRatio,LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  date                 = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  maxOrb               = 10000

  outDir               = '/SPENCEdata/Research/Cusp/database/'
  outFile              = outDir + 'mapratio_for_20151014_DB--up_to' + $
                         STRCOMPRESS(maxOrb,/REMOVE_ALL) + '--' + date

  batchDir             = '/SPENCEdata/software/sdt/batch_jobs/map_Poyntingflux__20151217/output/'
  filePref             = 'mapping_ratio--orb_'

  load_maximus_and_cdbtime,maximus

  uniqOrbs             = maximus.orbit[UNIQ(maximus.orbit)]

  FOR i=0, N_ELEMENTS(uniqOrbs)-1 DO BEGIN

     tempOrb           = uniqOrbs[i]
     tempOrbStr        = STRCOMPRESS(tempOrb,/REMOVE_ALL)
     tempFile          = batchDir+filePref+tempOrbStr
     temp_i            = WHERE(maximus.orbit EQ tempOrb)
     nTemp             = N_ELEMENTS(temp_i)

     PRINTF,lun,tempOrb

     IF FILE_TEST(tempFile) THEN BEGIN
        restore,tempFile
     
        IF N_ELEMENTS(mag1) EQ nTemp THEN BEGIN

           BUILD_MAPRATIO_STRUCT,mapRatio,mag1,mag2,ratio,times,tempOrb
           
        ENDIF ELSE BEGIN
           PRINTF,lun,FORMAT='("Mismatch between file for orb ",I0," and alfDB: ",I10,I10)', $
                  tempOrbStr,N_ELEMENTS(mag1),nTemp
           STOP
        ENDELSE
     ENDIF ELSE BEGIN
        PRINTF,lun,'No file for orbit ' + tempOrbStr + ' even though there are ' + $
               STRCOMPRESS(nTemp,/REMOVE_ALL) + ' events for this orb...'
     ENDELSE

     IF tempOrb EQ maxOrb THEN BEGIN
        PRINT,"That's all for now! Max requested orb was " + tempOrbStr
        BREAK
     ENDIF

  ENDFOR

  save,mapRatio

END