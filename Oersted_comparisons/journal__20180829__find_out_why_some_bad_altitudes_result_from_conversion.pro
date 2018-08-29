;2018/08/29
;; The reason why was that in JOURNAL__20180828__CONVERT_OERSTED_ECEF_COORDS_TO_MAGNETIC, I was not converting pos_theta_GEO to radians
;;on line 383 (file version from 2018/08/29)
;; Alt nå funker som det skal
PRO JOURNAL__20180829__FIND_OUT_WHY_SOME_BAD_ALTITUDES_RESULT_FROM_CONVERSION

  COMPILE_OPT IDL2,STRICTARRSUBS

  outDir           = '/SPENCEdata/Research/database/Oersted/'

  inFile           = 'oersted-ml990907.sav'
  timeStrFile      = 'oersted-ml990907.sav-timeStr.sav'
  outFile          = 'oersted-ml990907-parsedCoordinates.sav'

  RESTORE,outDir+inFile

  ;; Look, the spherical coordinates seem to be fine:
  ;; PRINT,max(oersted.ecef.r),min(oersted.ecef.r)
  ;; ;; 7245.16,7026.55
  ;; PRINT,max(oersted.ecef.r)-r_e,min(oersted.ecef.r)-r_e
  ;; ;; 873.96,655.35
  ;; PRINT,max(oersted.ecef.phi),min(oersted.ecef.phi)
  ;; ;; 180.0,-180.0
  ;; PRINT,max(oersted.ecef.theta),min(oersted.ecef.theta)
  ;; ;; 173.51,6.48

  RESTORE,outDir+outFile

  this = WHERE(coords.pos.geo.alt GE 875,nWeirdAlt)

  STOP

END
