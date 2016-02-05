FUNCTION RESIZE_FASTLOC,fastLoc,fastLoc_inds,FASTLOC_TIMES=fastLoc_times,FASTLOC_DELTA_T=fastLoc_delta_t,LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  PRINTF,lun,"Resizing fastLoc..."

  PRINTF,lun,FORMAT='("N elements before, after:",T35,I8,T45,I8)',N_ELEMENTS(fastLoc.orbit),N_ELEMENTS(fastLoc_inds)

  fastLoc={ORBIT:fastLoc.orbit[fastLoc_inds],$
           TIME:fastLoc.time[fastLoc_inds],$
           ALT:fastLoc.alt[fastLoc_inds],$
           MLT:fastLoc.mlt[fastLoc_inds],$
           ILAT:fastLoc.ilat[fastLoc_inds],$
           FIELDS_MODE:fastLoc.fields_mode[fastLoc_inds],$
           SAMPLE_T:fastLoc.sample_t[fastLoc_inds],$
           INTERVAL:fastLoc.INTERVAL[fastLoc_inds],$
           INTERVAL_START:fastLoc.interval_start[fastLoc_inds],$
           INTERVAL_STOP:fastLoc.interval_stop[fastLoc_inds]}
           ;; INTERVAL_STOP:fastLoc.INTERVAL_STOP[fastLoc_inds],$
           ;; LSHELL:fastLoc.lShell[fastLoc_inds]}
  
  IF N_ELEMENTS(fastLoc_Times) NE 0 THEN fastLoc_Times = fastLoc_Times[fastLoc_inds]
  IF N_ELEMENTS(fastLoc_delta_t) NE 0 THEN fastLoc_delta_t = fastLoc_delta_t[fastLoc_inds]
  
  RETURN,fastLoc
  
END