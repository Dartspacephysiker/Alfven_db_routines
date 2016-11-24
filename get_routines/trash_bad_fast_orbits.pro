;;11/24/16
FUNCTION TRASH_BAD_FAST_ORBITS,dbStruct,good_i

  COMPILE_OPT IDL2

  PRINT,"Trashing terrible orbits"

  ;;Look for Blacklisted_orbits.txt to see the rationale
  blackballOrb_ranges      = [[1031,1054]] ;;Original
  blackballOrb_ranges      = [[1028,1055]] ;;After round two in JOURNAL__20161124__POKE_AROUND_SOME_OF_THESE_DAYSIDE_ORBITS_WHERE_BROADBAND_FLUXES_ARE_CRAZY_HUGE, I realized more need to go

  individual_blackballOrbs = [1002,3461,7822,7836,7891,7925]

  FOR k=0,N_ELEMENTS(blackballOrb_ranges[0,*])-1 DO BEGIN
     PRINT,FORMAT='("Black orbit range: ",I0,", ",I0)',blackballOrb_ranges[0,k],blackballOrb_ranges[1,k]

     blackBall_i = WHERE(dbStruct.orbit GE blackballOrb_ranges[0,k] AND dbStruct.orbit LE blackballOrb_ranges[1,k],nBlackBall)

     IF nBlackBall GT 0 THEN BEGIN
        nGood   = N_ELEMENTS(good_i)
        good_i  = CGSETDIFFERENCE(good_i,blackBall_i,NORESULT=-1,COUNT=count)
        IF good_i[0] EQ -1 THEN BEGIN
           PRINT,"We've killed every orbit!"
           broken = 1
           BREAK
        ENDIF
        PRINT,'Junked ' + STRCOMPRESS(nGood-count,/REMOVE_ALL) + ' blackballed events ...'
     ENDIF
  ENDFOR

  IF KEYWORD_SET(broken) THEN STOP

  FOR k=0,N_ELEMENTS(individual_blackballOrbs)-1 DO BEGIN
     PRINT,FORMAT='("Blackball orbit: ",I0)',individual_blackballOrbs[k]

     blackBall_i = WHERE(dbStruct.orbit EQ individual_blackballOrbs[k],nBlackBall)

     IF nBlackBall GT 0 THEN BEGIN
        nGood   = N_ELEMENTS(good_i)
        good_i  = CGSETDIFFERENCE(good_i,blackBall_i,NORESULT=-1,COUNT=count)
        IF good_i[0] EQ -1 THEN BEGIN
           PRINT,"We've killed every orbit!"
           broken = 1
           BREAK
        ENDIF
        PRINT,'Junked ' + STRCOMPRESS(nGood-count,/REMOVE_ALL) + ' blackballed events ...'
     ENDIF
  ENDFOR

  IF KEYWORD_SET(broken) THEN STOP

  RETURN,good_i
END
