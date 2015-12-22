;2015/12/21 Just do the ones that have been problematique
; Remember, Chaston et al. [2003] justify the use of the Poynting flux estimate in the Alf DB
; Check it out if you're curious
PRO COMBINE_MAPPING_RATIO_FILES__SELECT,mapRatio,bad_i,LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout

  date                 = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)
  maxOrb               = 16361

  ;; outDir               = '/SPENCEdata/Research/Cusp/database/'
  ;; outFile              = outDir + 'mapratio_for_20151014_DB--up_to' + $
  ;;                        STRCOMPRESS(maxOrb,/REMOVE_ALL) + '--' + date + '.dat'
  LOAD_MAPPING_RATIO_DB,mapRatio

  problem_orbs         = [514,568,633,687,741,914,1120,1239,1293,1412, $
                          1466,1520,1574,1585,1639,1693,1747,1758,1812,1866, $
                          1920,1931,1983,2039,2158,2212,2742,2817,2947,3034, $
                          3055,3120,3153,3445,4159,4278,4440,4494,4559,4581, $
                          4613,4678,4743,4830,4862,4981,5035,5165,5263,5295, $
                          5328,5414,5447,5663,5696,5826,5945,5956,6021,6335, $
                          6595,6898,7169,7180,7321,7386,7560,7842,7983,8059, $
                          8113,8124,8200,8265,8276,8330,8341]

  batchDir             = '/SPENCEdata/software/sdt/batch_jobs/map_Poyntingflux__20151217/output/'
  filePref             = 'mapping_ratio--orb_'

  load_maximus_and_cdbtime,maximus,cdbTime

  ;; uniqOrbs             = maximus.orbit[UNIQ(maximus.orbit)]

  nBad                 = 0
  bad_i                = !NULL

  FOR i=0, N_ELEMENTS(problem_Orbs)-1 DO BEGIN

     tempOrb           = problem_Orbs[i]
     tempOrbStr        = STRCOMPRESS(tempOrb,/REMOVE_ALL)
     tempFile          = batchDir+filePref+tempOrbStr
     temp_i            = WHERE(maximus.orbit EQ tempOrb)
     nTemp             = N_ELEMENTS(temp_i)

     PRINTF,lun,'**Orbit: ' + STRCOMPRESS(tempOrb,/REMOVE_ALL)

     IF FILE_TEST(tempFile) THEN BEGIN
        restore,tempFile
     
        IF N_ELEMENTS(mag1) EQ nTemp THEN BEGIN

           ;;BUILD_MAPRATIO_STRUCT,mapRatio,mag1,mag2,ratio,times,tempOrb
           dat        = ABS(times-cdbtime[temp_i])
           
           tempBad_ii = WHERE(dat GT 50,/NULL)
           nTempBad   = N_ELEMENTS(tempBad_ii)
           bad_i      = [bad_i,temp_i[tempBad_ii]]

           PRINTF,lun,"N elements with diff > 50 seconds: " + STRCOMPRESS(nTempBad,/REMOVE_ALL)
           
           nBad      += nTempBad

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

  PRINTF,lun,"Total screwy events: " + STRCOMPRESS(nBad,/REMOVE_ALL)

END