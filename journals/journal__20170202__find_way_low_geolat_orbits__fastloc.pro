;;02/02/17
PRO JOURNAL__20170202__FIND_WAY_LOW_GEOLAT_ORBITS__FASTLOC

  COMPILE_OPT IDL2

  for_eSpec_DBs           = 1
  CASE 1 OF
     KEYWORD_SET(for_eSpec_DBs): BEGIN
        outFile_pref      = 'fastLoc_intervals5--20161129--500-16361--Je_times'
        DBDir             = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals5/'
     END
     ELSE: BEGIN
        PRINT,"Not needed for this DB"
        STOP
        outFile_pref      = 'fastLocDB-20160505_v0_0--samp_t_le_0.01'
        DBDir             = '/SPENCEdata/Research/database/FAST/ephemeris/fastLoc_intervals4/'
     END
  ENDCASE

  geofil                  = outFile_pref+'-GEO.sav'
  magfil                  = outFile_pref+'-MAG.sav'

  coordDir                = DBDir+'alternate_coords/'
  saveMagFil              = outFile_pref+'-MAG_lat_GT_35_inds.sav'

  RESTORE,coordDir+geofil
  RESTORE,coordDir+magfil

  !P.MULTI = [0,2,2,0,0]

  MAG_lat_GT_35_i = WHERE(ABS(MAG.lat) GT 35)

  SAVE,MAG_lat_GT_35_i,FILENAME=coordDir+saveMagFil



END
