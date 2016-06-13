;2016/01/09 Time to map Poynting flux for the DESPUN db!
; Remember, Chaston et al. [2003] justify the use of the Poynting flux estimate in the Alf DB
; Check it out if you're curious
PRO COMBINE_MAPPING_RATIO_FILES__DESPUN_DB,mapRatio,LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  date                 = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  maxOrb               = 16361

  outDir               = '/SPENCEdata/Research/database/FAST/dartdb/saves/mapratio_dbs/'
  ;; outFile              = outDir + 'mapratio_for_20160107_despun_DB--up_to' + $
  ;;                        STRCOMPRESS(maxOrb,/REMOVE_ALL) + '--' + date + '.dat'
  outFile              = outDir + 'mapratio_for_20160508_despun_DB--up_to' + $
                         STRCOMPRESS(maxOrb,/REMOVE_ALL) + '--' + date + '.dat'

  ;; batchDir             = '/SPENCEdata/software/sdt/batch_jobs/map_Poyntingflux__20151217/output__despundb_20160107/'
  batchDir             = '/SPENCEdata/software/sdt/batch_jobs/map_Poyntingflux__20151217/output__despundb_20160611/'
  filePref             = 'mapping_ratio--orb_'

  LOAD_MAXIMUS_AND_CDBTIME,maximus,/DO_DESPUNDB

  uniqOrbs             = maximus.orbit[UNIQ(maximus.orbit)]

  FOR i=0, N_ELEMENTS(uniqOrbs)-1 DO BEGIN

     tempOrb           = uniqOrbs[i]
     tempOrbStr        = STRCOMPRESS(tempOrb,/REMOVE_ALL)
     ;; tempFile          = batchDir+filePref+tempOrbStr
     tempFile          = batchDir+filePref+tempOrbStr+'.sav'
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

  save,mapRatio,FILENAME=outFile

END