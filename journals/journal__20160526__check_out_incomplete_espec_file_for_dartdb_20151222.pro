;;05/26/16
;;We lose about 23000 events to electron energies that are too weak.
PRO JOURNAL__20160526__CHECK_OUT_INCOMPLETE_ESPEC_FILE_FOR_DARTDB_20151222 

  ;;Get 'em back!
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,GOOD_I=good_i,HEMI__GOOD_I='BOTH'
  eSpec_dir     = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'
  file          = 'alf_eSpec_20160522_db--20160526.sav'

  RESTORE,eSpec_dir+file

  ;;Get appropriate indices
  eSpec_i       = WHERE(~espec_missing_events $
                        AND ABS(eSpec_magc_diffs) LT 5.0,nEvents)
  goodSpec_i    = CGSETINTERSECTION(good_i,eSpec_i)
  IF goodSpec_i[0] EQ -1 THEN STOP ;Cry

  ;;Shrink 'em
  CAT_EVENTS_FROM_PARSED_SPECTRAL_STRUCT,goodSpecs,alf_eSpecs,goodSpec_i
  
  ;;Convert 'em
  CONVERT_ESPEC_TO_STRICT_NEWELL_INTERPRETATION,goodSpecs,goodSpecs_interpreted


  ;;Plot 'em
  plots         = ALF_ESPEC_IDENTIFIED_PLOT(goodSpecs, $
                                            NEWELL_ESPEC_INTERPRETED=goodSpecs_interpreted)

  PRINT_ESPEC_STATS,goodSpecs_interpreted,/SKIP_FAILURE_REPORT,/INTERPRETED_STATISTICS
  PRINT_ESPEC_STATS,goodSpecs

  ;;The reason we lose so many events
  CGHISTOPLOT,maximus.max_chare_losscone[good_i], $
              MININPUT=0, $
              MAXINPUT=200, $
              OUTPUT='/SPENCEdata/Research/Satellites/FAST/Alfven_db_routines/plots/20160526--NOT_despun--chare_zoomed--0-200_eV--why_we_lose_so_many_broadband_spec.png', $
              YTITLE='Counts', $
              XTITLE='Characteristic Energy (eV)', $
              TITLE='Screened Alfvén events, both hemispheres'
  STOP

END
