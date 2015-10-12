FUNCTION GET_SATELLITE_INDS,maximus,satellite,LUN=lun

  COMPILE_OPT idl2

  defSatellite = 'OMNI'

  IF ~KEYWORD_SET(satellite) THEN BEGIN
     PRINTF,lun,"No satellite provided! Setting to '" + defSatellite + "' by default..."
     satellite = defSatellite
  ENDIF

  ind_ACEstart=(satellite EQ "ACE") ? 82896 : 0
  
  IF (satellite EQ "ACE") THEN BEGIN
     sat_i= 82896 
     printf,lun,"You're losing " + strtrim(nlost,2) + $
            " current events because ACE data doesn't start until " + strtrim(maximus.time(ind_ACEstart),2) + "."
  ENDIF ELSE BEGIN
     sat_i = 0
  ENDELSE

  RETURN,sat_i

END