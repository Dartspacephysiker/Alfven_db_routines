;2018/08/29
;; INGENTING HER!
PRO JOURNAL__20180829__COMPARE_OERSTED_AND_FAST_OBS__19990907

  COMPILE_OPT IDL2,STRICTARRSUBS

  outDir           = '/SPENCEdata/Research/database/Oersted/'

  ;; inFile           = 'oersted-ml990907.sav'
  ;; timeStrFile      = 'oersted-ml990907.sav-timeStr.sav'
  ;; outFile          = 'oersted-ml990907-parsedCoordinates.sav'


  ;; date         = '990907'
  ;; FASTorbit    = 12049

  ;; Such money Alfveners for this conj with FAST
  date         = '991015'
  FASTorbit    = 12464

  inFile       = 'oersted-ml' + date + '.sav'
  timeStrFile  = 'oersted-ml' + date + '-timeStr.sav'
  outFile      = 'oersted-ml' + date + '-parseCoordinates.sav'


  RESTORE,outDir+inFile
  RESTORE,outDir+outFile

  CASE FASTorbit OF
     12049: BEGIN
        interestingTider = ['1999-09-07/02:25:00','1999-09-07/02:45:00']
        maxInteressant   = '1999-09-07/02:36:00'
     END
     12464: BEGIN
        interestingTider = ['1999-10-15/05:18:00','1999-10-15/05:28:00']
        maxInteressant   = '1999-10-15/05:23:00'
     END
  ENDCASE
  t1 = S2T(interestingTider[0])
  t2 = S2T(interestingTider[1])
  tWow = S2T(maxInteressant)

  @common__maximus_vars.pro  

  LOAD_MAXIMUS_AND_CDBTIME

  FASTi = WHERE(MAXIMUS__maximus.orbit EQ FASTorbit,nFASTi)

  Oeri  = WHERE(oersted.time GE t1 AND oersted.time LE t2,nOeri)

  PRINT,maximus__maximus.time[FASTi]

  STOP

  ;; GET FAST MAG DATA
  UCLA_MAG_DESPIN

  UCLA_MAG_DESPIN,TW_MAT=tw_mat,ORBIT=orbit,SPIN_AXIS=spin_axis,DELTA_PHI=delta_phi,/QUIET
  ;; GET_DATA,'dB_fac_v',DATA=data
  GET_DATA,'dB_fac',DATA=data


END
