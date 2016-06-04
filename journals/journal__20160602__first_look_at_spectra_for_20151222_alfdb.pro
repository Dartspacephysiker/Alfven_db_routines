;;06/02/16
PRO JOURNAL__20160602__FIRST_LOOK_AT_SPECTRA_FOR_20151222_ALFDB

  COMPILE_OPT IDL2


  firstOrb                  = 500
  lastOrb                   = 16361
  date                      = '20160603'

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

  SET_PLOT_DIR,plotDir,/FOR_STORMS,/ADD_TODAY,ADD_SUFF='--exploring_first_complete_alfven_Newell_spectra'

  FOR i=0,N_ELEMENTS(stormIndFileArr)-1 DO BEGIN

     plot_i                = !NULL
     RESTORE,stormIndDir+stormIndFileArr[i]


     plot_i__good_espec    = CGSETINTERSECTION(plot_i,alf_i__good_eSpec,INDICES_B=stormphase_indices__espec_quantities)

     IF plot_i__good_eSpec[0] EQ -1 THEN STOP

     PRINT,N_ELEMENTS(plot_i__good_espec)
     tempFile              = paramString+'--good_alf_eSpec_i_and_inds_into_eSpec_quantities.sav'
     PRINT,'Saving to ' + tempFile + '...'
     SAVE,plot_i__good_espec,stormphase_indices__espec_quantities,FILENAME=stormIndDir+tempFile

     tmp_ae = { x:eSpec.x[stormphase_indices__espec_quantities], $
                MLT:eSpec.mlt[stormphase_indices__espec_quantities], $
                ILAT:eSpec.ilat[stormphase_indices__espec_quantities], $
                mono:eSpec.mono[stormphase_indices__espec_quantities], $
                broad:eSpec.broad[stormphase_indices__espec_quantities], $
                diffuse:eSpec.diffuse[stormphase_indices__espec_quantities], $
                Je:eSpec.Je[stormphase_indices__espec_quantities], $
                Jee:eSpec.Jee[stormphase_indices__espec_quantities], $
                nBad_eSpec:eSpec.nBad_eSpec[stormphase_indices__espec_quantities]}
     
     CONVERT_ESPEC_TO_STRICT_NEWELL_INTERPRETATION,tmp_ae,tmp_newell_ae

     ;; plots = ALF_ESPEC_IDENTIFIED_PLOT(tmp_ae, $
     ;;                                   NEWELL_ESPEC_INTERPRETED=tmp_newell_ae, $
     ;;                                   TITLE=paramString, $
     ;;                                   /SAVEPLOT, $
     ;;                                   SPNAME=paramString+'--Newell_plots--20151222_alfdb.png', $
     ;;                                   PLOTDIR=plotDir)

     plots = ALF_ESPEC_IDENTIFIED_PLOT(tmp_newell_ae, $
                                       ;; NEWELL_ESPEC_INTERPRETED=tmp_newell_ae, $
                                       /ONLY_NEWELL, $
                                       TITLE=paramString, $
                                       /SAVEPLOT, $
                                       SPNAME=paramString+'--Newell_plots--20151222_alfdb.png', $
                                       PLOTDIR=plotDir)

     PRINT_ESPEC_STATS,tmp_newell_ae,/SKIP_FAILURE_REPORT,/INTERPRETED_STATISTICS
     PRINT_ESPEC_STATS,tmp_ae

  ENDFOR

END
