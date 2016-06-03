;;06/02/16
PRO JOURNAL__20160602__MLT_ILAT_DIST_FOR_20151222_ESPEC_ALFDB

  COMPILE_OPT IDL2


  firstOrb                  = 500
  lastOrb                   = 16361
  date                      = '20160602'

  failCodes_string          = 'failCodes_'

  inDir                     = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'
  chunkDir                  = inDir+'fully_parsed/'
  TOTALGLORY                = STRING(FORMAT='("alf_eSpec_20151222_db--TOTAL_ESPECS_",A0,"_Orbs_",I0,"-",I0,"--",A0,".sav")', $
                                     STRUPCASE(failCodes_string), $
                                     firstOrb, $
                                     lastOrb, $
                                     date)

  stormIndDir               = '/SPENCEdata/Research/Satellites/FAST/storms_Alfvens/saves_output_etc/'
  stormIndFileArr           = ['May_31_16--nonstorm--Dstcutoff_-20--NORTH--logAvg--maskMin10--alfDB_indices.sav', $
                               'May_31_16--mainphase--Dstcutoff_-20--NORTH--logAvg--maskMin10--alfDB_indices.sav', $
                               'May_31_16--recoveryphase--Dstcutoff_-20--NORTH--logAvg--maskMin10--alfDB_indices.sav']

  stormFastLocIndices       = ['May_31_16--nonstorm--Dstcutoff_-20--NORTH--logAvg--maskMin10--fastLoc_indices.sav', $
                               'May_31_16--mainphase--Dstcutoff_-20--NORTH--logAvg--maskMin10--fastLoc_indices.sav', $
                               'May_31_16--recoveryphase--Dstcutoff_-20--NORTH--logAvg--maskMin10--fastLoc_indices.sav']
  

  RESTORE,chunkDir+TOTALGLORY
  CONVERT_ESPEC_TO_STRICT_NEWELL_INTERPRETATION,eSpec,newell_eSpec

  eSpec          = TEMPORARY(newell_eSpec)

  SET_PLOT_DIR,plotDir,/FOR_STORMS,/ADD_TODAY,ADD_SUFF='--exploring_first_complete_alfven_Newell_spectra'

  FOR i=0,N_ELEMENTS(stormIndFileArr)-1 DO BEGIN

     RESTORE,stormIndDir+stormIndFileArr[i]

     tempFile              = paramString+'--good_alf_eSpec_i_and_inds_into_eSpec_quantities.sav'
     RESTORE,stormIndDir+tempFile

     tmp_ae     = { x:eSpec.x[stormphase_indices__espec_quantities], $
                    MLT:eSpec.mlt[stormphase_indices__espec_quantities], $
                    ILAT:eSpec.ilat[stormphase_indices__espec_quantities], $
                    mono:eSpec.mono[stormphase_indices__espec_quantities], $
                    broad:eSpec.broad[stormphase_indices__espec_quantities], $
                    diffuse:eSpec.diffuse[stormphase_indices__espec_quantities], $
                    Je:eSpec.Je[stormphase_indices__espec_quantities], $
                    Jee:eSpec.Jee[stormphase_indices__espec_quantities], $
                    nBad_eSpec:eSpec.nBad_eSpec[stormphase_indices__espec_quantities]}
     
  ENDFOR

END
