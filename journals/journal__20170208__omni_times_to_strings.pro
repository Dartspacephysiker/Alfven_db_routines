;;2017/02/04
PRO JOURNAL__20170208__OMNI_TIMES_TO_STRINGS

  COMPILE_OPT IDL2

  check_if_exists         = 1
  dry_run                 = 0

  outFile_pref            = 'SW_data--199608_through_200412'
  ;; nCPUsToRun              = 7
  ;; startCPU                = 0
  ;; stopCPU                 = 6

  diag                    = 0 ;diagnostic mode

  create_timeStampsArr      = [1,0,0,0]
  ;; get_GEI_coordsArr         = [0,1,0,0]
  ;; do_GEO_MAG_conversionsArr = [0,0,1,0]
  ;; do_AACGM_conversionsArr   = [0,0,0,0]
  stitch_filesArr           = [0,0,0,1]

  ;; test_single             = 0

  ;;Less-important options
  coordDir                = '/SPENCEdata/Research/database/OMNI/'
  culledDataStr           = 'sw_data.dat'
  orig_routineName        = 'JOURNAL__20170208__OMNI_TIMES_TO_STRINGS'

  RESTORE,coordDir+culledDataStr

  t_to_1970               = 62167219200000.0000D
  times                   = (sw_data.epoch.dat-t_to_1970)/1000.0D

  nThang = N_ELEMENTS(create_timeStampsArr)
  FOR k=0,nThang-1 DO BEGIN

     ;;set 'er up
     create_timeStamps       = create_timeStampsArr[k]
     ;; get_GEI_coords          = get_GEI_coordsArr[k]
     ;; do_GEO_MAG_conversions  = do_GEO_MAG_conversionsArr[k]
     ;; do_AACGM_conversions    = do_AACGM_conversionsArr[k]
     stitch_files            = stitch_filesArr[k]

     PRINT,""
     PRINT,"ITERATION ",k
     PRINT,'create_timeStamps     ',create_timeStamps
     ;; PRINT,'get_GEI_coords        ',get_GEI_coords
     ;; PRINT,'do_GEO_MAG_conversions',do_GEO_MAG_conversions
     ;; PRINT,'do_AACGM_conversions  ',do_AACGM_conversions
     PRINT,'stitch_files          ',stitch_files

     FASTDB_COORDINATE_CONVERSION__PARALLEL, $
        times, $
        NCPUSTORUN=nCPUsToRun, $
        STARTCPU=startCPU, $
        STOPCPU=stopCPU, $
        CREATE_TIMESTAMPS=create_timeStamps, $
        GET_GEI_COORDS=get_GEI_coords, $
        DO_GEO_MAG_CONVERSIONS=do_GEO_MAG_conversions, $
        DO_AACGM_CONVERSIONS=do_AACGM_conversions, $
        STITCH_FILES=stitch_files, $
        ORIG_ROUTINENAME=orig_routineName, $
        COORDDIR=coordDir, $
        OUTFILE_PREF=outFile_pref, $
        DRY_RUN=dry_run, $
        CHECK_IF_EXISTS=check_if_exists, $
        DIAGNOSTIC=diag, $
        OK__CONTINUE_WITH_ONLY_FEW_CPUS=OK__low_CPU_number

  ENDFOR


END
