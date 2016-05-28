;;05/26/16
;;We lose about 23000 events to electron energies that are too weak.
PRO JOURNAL__20160526__CHECK_OUT_INCOMPLETE_ESPEC_FILE_FOR_DARTDB_20151222

  chare_histo_plotName = GET_TODAY_STRING() + '--20151222_db--NOT_despun--chare_zoomed--0-200_eV--why_we_lose_so_many_broadband_spec.png'
  espec_identified_plotname = GET_TODAY_STRING() + '--20151222_db--NOT_despun--Newell-based_stats.png'

  ;;Get 'em back!
  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,GOOD_I=good_i,HEMI__GOOD_I='BOTH'
  eSpec_dir     = '/SPENCEdata/Research/database/FAST/dartdb/electron_Newell_db/'
  file          = 'alf_eSpec_20151222_db--20160528.sav'

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
  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY,ADD_SUFF='--exploring_partial_alfven_Newell_spectra'
  plots         = ALF_ESPEC_IDENTIFIED_PLOT(goodSpecs, $
                                            NEWELL_ESPEC_INTERPRETED=goodSpecs_interpreted, $
                                            /SAVEPLOT, $
                                            SPNAME=espec_identified_plotname, $
                                            PLOTDIR=plotDir)

  PRINT_ESPEC_STATS,goodSpecs_interpreted,/SKIP_FAILURE_REPORT,/INTERPRETED_STATISTICS
  PRINT_ESPEC_STATS,goodSpecs

  ;;The reason we lose so many events
  CGHISTOPLOT,maximus.max_chare_losscone[good_i], $
              MININPUT=0, $
              MAXINPUT=200, $
              OUTPUT=plotDir+chare_histo_plotName, $
              YTITLE='Counts', $
              XTITLE='Characteristic Energy (eV)', $
              TITLE='Screened Alfvén events, both hemispheres'
  STOP

END
