;;02/06/17
PRO JOURNAL__20170206__NOW_USE_ALFDB_INTO_ESPECDB_LIST_WISELY

  COMPILE_OPT IDL2

  outDir           = '/SPENCEdata/Research/database/FAST/dartdb/saves/'
  alfIntoeSpecFile = 'Dartdb_20151222--500-16361_inc_lower_lats--alfs_into_20170203_eSpecDB.sav'

  RESTORE,outDir+alfIntoeSpecFile


  @common__newell_espec.pro
  IF N_ELEMENTS(NEWELL__eSpec) EQ 0 THEN BEGIN
     LOAD_NEWELL_ESPEC_DB,/DO_NOT_MAP_DELTA_T,/DO_NOT_MAP_FLUXES
  ENDIF

  @common__maximus_vars.pro
  IF N_ELEMENTS(MAXIMUS__maximus) EQ 0 THEN BEGIN
     LOAD_MAXIMUS_AND_CDBTIME
  ENDIF

  nTotAlf   = N_ELEMENTS(MAXIMUS__times)

  alfDB_Newell = 

END
