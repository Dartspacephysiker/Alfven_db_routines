;;06/11/16
PRO JOURNAL__20160611__SEE_HOW_CALCED_CHARE_COMPARES_TO_DB_CHARE

  COMPILE_OPT IDL2

  despun = 0

  date_for_inputs           = '20160609'

  IF KEYWORD_SET(despun) THEN BEGIN
     despunStr              = '--despun'
     dbDate                 = '20160508'
     firstDBOrb             = 502
     unparsedDate           = '20160609'
  ENDIF ELSE BEGIN
     despunStr              = ''
     dbDate                 = '20151222'
     firstDBOrb             = 500
     unparsedDate           = '20160609'
  ENDELSE
  firstOrb                  = 500
  lastOrb                   = 16361

  inDir                     = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'

  ;;Use this file to figure out which Alfven DB inds we have
  winnowedFile              = STRING(FORMAT='("alf_eSpec_",A0,"_db",A0,"--TIME_SERIES_AND_ORBITS_ALIGNED_WITH_DB--WINNOWED--Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                     dbDate, $
                                     despunStr, $
                                     firstDBOrb, $
                                     lastOrb, $
                                     date_for_inputs)
  
  eSpecUnparsedFile         = STRING(FORMAT='("alf_eSpec_",A0,"_db",A0,"--ESPECS_ALIGNED_UNPARSED--Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                     dbDate, $
                                     despunStr, $
                                     ;; failStr, $
                                     firstDBOrb, $
                                     lastOrb, $
                                     unparsedDate)

  RESTORE,inDir+winnowedFile
  RESTORE,inDir+eSpecUnparsedFile

  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbtime,CORRECT_FLUXES=0,DO_DESPUNDB=despun
  LOAD_MAPPING_RATIO_DB,mapRatio,DO_DESPUNDB=despun

  numflux = maximus.esa_current * (DOUBLE(1. / 1.6e-9))

  newchare = ABS(maximus.ELEC_ENERGY_FLUX/numflux*6.242*1.0e11)

  FOR i=0,99 DO PRINT,newchare[i],"  ",maximus.max_chare_losscone[i]

  PRINT,"Obviously, these two do not agree. This is because esa_current is calculated using the whole range of pitch angles (or at least the quantity je_tmp is involved, as opposed to je_tmp_lc)"

  thischare = ABS(jee_out/je_out*6.242*1.0e11)

  FOR i=0,99 DO PRINT,thischare[i], $
                      "    ",maximus.max_chare_losscone[alf_i__good_eSpec[i]], $
                      "    ",((thischare[i]-maximus.max_chare_losscone[alf_i__good_eSpec[i]]) LT -0.1 ? "MAXIMUS" : "")

  diff = thischare[i] - maximus.max_chare_losscone[alf_i__good_eSpec]

  STOP

END
