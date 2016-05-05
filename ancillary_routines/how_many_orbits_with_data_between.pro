PRO HOW_MANY_ORBITS_WITH_DATA_BETWEEN,dbStruct,minOrb,maxOrb, $
                                      OUT_MATCHING_I=out_matching_i, $
                                      PRINT_ORBS=print_orbs, $
                                      LUN=inLun

  COMPILE_OPT idl2

  lun             = N_ELEMENTS(inLun)  GT 0 ? inLun : -1


  minO            = N_ELEMENTS(minOrb) GT 0 ? minOrb : 10200 
  maxO            = N_ELEMENTS(maxOrb) GT 0 ? maxOrb : 12029 

  uniq_orb_i      = UNIQ(dbStruct.orbit) 
  these           = WHERE(dbStruct.orbit GE minO AND dbStruct.orbit LE maxO)

  match_uniq_i    = CGSETINTERSECTION(uniq_orb_i,these,COUNT=nMatch)

  IF KEYWORD_SET(print_orbs) THEN BEGIN
     PRINTF,lun,FORMAT='("Matching orbit",T20,"Gap",T30,"nEvents")'
     oldOrb       = dbStruct.orbit[match_uniq_i[0]]

     FOR i=0,nMatch-1 DO BEGIN
        ind       = match_uniq_i[i]
        orb       = dbStruct.orbit[ind]
        PRINTF,lun,FORMAT='(I0,T20,I0,T30,I0)', $
               orb, $
               orb-oldOrb, $
               N_ELEMENTS(WHERE(dbStruct.orbit[these] EQ dbStruct.orbit[ind]))
        
        oldOrb    = orb
     ENDFOR

  ENDIF

  PRINTF,lun,FORMAT='("N orbits between ",I0," and ",I0,": ",I0)',minO,maxO,nMatch

  out_matching_i  = these

END