PRO JOURNAL__20160505__LIST_OF_ORBITS_NEVENTS_GAPS_IN_DESPUN_DB


  do_despun = 1

  outDir    = '/SPENCEdata/Research/Satellites/FAST/Alfven_db_routines/info_on_FAST_database/'
  outFile   = 'Despun_DB--list_of_orbits_gaps_and_nEvents_in_each_orbit.txt'

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=do_despun,/QUIET

  PRINT,'Opening, saving orbit info to ' + outDir+outFile
  OPENW,datLun,outDir+outFile,/GET_LUN

  HOW_MANY_ORBITS_WITH_DATA_BETWEEN,maximus,0,16361,/PRINT_ORBS,LUN=datLun

  CLOSE,datLun
  FREE_LUN,datLun

  PRINT,'Done!'

END