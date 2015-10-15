;2015/10/15 We need L-shell too

PRO ADD_LSHELL_TO_FASTLOC,fastLoc

  lShell=(cos(fastLoc.ilat*!PI/180.))^(-2)

  fastLoc={ORBIT:fastLoc.orbit,$
           TIME:fastLoc.time,$
           ALT:fastLoc.alt,$
           MLT:fastLoc.mlt,$
           ILAT:fastLoc.ilat,$
           FIELDS_MODE:fastLoc.FIELDS_MODE,$
           INTERVAL:fastLoc.INTERVAL,$
           INTERVAL_START:fastLoc.INTERVAL_START,$
           INTERVAL_STOP:fastLoc.INTERVAL_STOP,$
           LSHELL:lShell}
  
  
END