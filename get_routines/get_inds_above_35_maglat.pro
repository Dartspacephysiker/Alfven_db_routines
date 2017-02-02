;;02/02/17
PRO GET_INDS_ABOVE_35_MAGLAT,dBStruct,good_i, $
                             DBDIR=DBDir, $
                             FOR_ALFDB=for_alfDB, $
                             FOR_ESPEC_DB=for_eSpec_DB, $
                             FOR_FASTLOC_DB=for_fastLoc_DB, $
                             FOR_ION_DB=for_ion_DB

  COMPILE_OPT IDL2

  IF N_ELEMENTS(good_i) EQ 0 THEN BEGIN
     good_i = LINDGEN(N_ELEMENTS(dBStruct.orbit))
  ENDIF

  DBStr = GET_FAST_DB_STRING(dBStruct, $
                             FOR_ALFDB=for_alfDB, $
                             FOR_ESPEC_DB=for_eSpec_DB, $
                             FOR_FASTLOC_DB=for_fastLoc_DB, $
                             FOR_ION_DB=for_ion_DB)

  fSuff = '-MAG_lat_GT_35_inds.sav'

  IF KEYWORD_SET(for_alfDB) OR (KEYWORD_SET(for_fastLoc_DB) AND STRMATCH(STRUPCASE(dBStruct.info.DB_extras),'*SAMP_T_LE_0.01')) THEN BEGIN
     PRINT,"You don't need inds above 35 deg MAG latitude!"
     RETURN
  ENDIF

  RESTORE,DBDir+'alternate_coords/'+DBStr+fSuff

  NBef = N_ELEMENTS(good_i)

  good_i = CGSETINTERSECTION(good_i,MAG_lat_GT_35_i,COUNT=nAft)

  nLost = nBef-nAft
  PRINT,"Lost " + STRCOMPRESS(nLost,/REMOVE_ALL) + " inds that are below 35 deg in MAG latitude ..."

END
