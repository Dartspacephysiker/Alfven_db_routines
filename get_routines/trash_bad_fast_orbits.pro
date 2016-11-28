;;11/24/16
;;The text file with your info:
;;/Research/Satellites/FAST/espec_identification/txt_log_etc/Blacklisted_orbits.txt
FUNCTION TRASH_BAD_FAST_ORBITS,dbStruct,good_i

  COMPILE_OPT IDL2

  PRINT,"Trashing terrible orbits"
  nGStart = N_ELEMENTS(good_i)
  nBTot   = 0

  ;;Mayhem posse
  blackballOrb_ranges      = [[1031,1054]] ;;Original
  blackballOrb_ranges      = [[1028,1055]] ;;After round two in JOURNAL__20161124__POKE_AROUND_SOME_OF_THESE_DAYSIDE_ORBITS_WHERE_BROADBAND_FLUXES_ARE_CRAZY_HUGE, I realized more need to go
  blackballOrb_ranges      = [[1028,1055],[1443,1444],[1465,1466],[1477,1478],[1487,1488],[1496,1499], $
                              [1506,1522],[7804,7837],[11985,12001]] ;Resulting from Round 3

  blackballOrb_ranges      = [[1028,1056],[1443,1444],[1465,1466],[1477,1478],[1487,1488],[1496,1499], $
                              [1506,1522],[1533,1534],[1556,1557],[1564,1565],[1788,1789],[2681,2682], $
                              [3091,3092],[4247,4248],[7804,7837],[11985,12001]] ;Resulting from Round 3

  ;;And individual rogues
  individual_blackballOrbs = [1002,3461,7822,7836,7891,7925] 
  individual_blackballOrbs = [1002,3461,7822,7836,7891,7925,8756] ;Round 3 resultant
  individual_blackballOrbs = [749, $
                              1002,1179,1200,1543,1733,1775,1879,1915,1947,2660,2793,2985, $
                              3015,3025,3054,3059,3123,3135,3296,3345,3360,3372,3461,3489,3680,3868, $
                              4149,4204,4226,4480,4497,4603,4632,4641,4678,4962, $
                              5154,5243,5390,5476,5494,5585,5608,5636,5771,5837, $
                              6232, $
                              7012,7683,7744,7758,7836,7857,7891,7925,7926, $
                              8162,8540,8756,8768, $
                              9401,9406,9596,9830,9980,9990, $
                              10014,10072,10080,10083,10094,10131,10314, $
                              12278,12297,12471,13214,13785, $
                              14297] ;Round 4 resultant

  FOR k=0,N_ELEMENTS(blackballOrb_ranges[0,*])-1 DO BEGIN
     opener = STRING(FORMAT='("Blacked orbits ",I0,"–",I0,T30," : ")',blackballOrb_ranges[0,k],blackballOrb_ranges[1,k])

     blackBall_ii = WHERE(dbStruct.orbit[good_i] GE blackballOrb_ranges[0,k] AND dbStruct.orbit[good_i] LE blackballOrb_ranges[1,k], $
                          nBlackBall, $
                          COMPLEMENT=keeper_ii, $
                          NCOMPLEMENT=nKeeper)

     IF nBlackBall GT 0 THEN BEGIN
        nGood   = N_ELEMENTS(good_i)
        nBTot  += nBlackBall

        good_i  = good_i[keeper_ii]
        ;; good_i  = CGSETDIFFERENCE(good_i,blackBall_i,NORESULT=-1,COUNT=count)
        IF good_i[0] EQ -1 THEN BEGIN
           PRINT,opener+"We've killed every orbit!"
           broken = 1
           BREAK
        ENDIF
        PRINT,opener+'Junked ' + STRCOMPRESS(nGood-nKeeper,/REMOVE_ALL) + ' blackballed events ...'
     ENDIF ELSE BEGIN
        PRINT,opener+"No baddies found in this case ..."
     ENDELSE
  ENDFOR

  IF KEYWORD_SET(broken) THEN STOP

  FOR k=0,N_ELEMENTS(individual_blackballOrbs)-1 DO BEGIN
     opener = STRING(FORMAT='("Blackball orbit ",I0,T30," : ")',individual_blackballOrbs[k])

     ;; blackBall_i = WHERE(dbStruct.orbit EQ individual_blackballOrbs[k],nBlackBall)
     blackBall_ii = WHERE(dbStruct.orbit[good_i] EQ individual_blackballOrbs[k],nBlackBall, $
                          COMPLEMENT=keeper_ii, $
                          NCOMPLEMENT=nKeeper)

     IF nBlackBall GT 0 THEN BEGIN
        nGood   = N_ELEMENTS(good_i)
        nBTot  += nBlackBall

        ;; good_i  = CGSETDIFFERENCE(good_i,blackBall_i,NORESULT=-1,COUNT=count)
        good_i  = good_i[keeper_ii]
        IF good_i[0] EQ -1 THEN BEGIN
           PRINT,opener+"We've killed every orbit!"
           broken = 1
           BREAK
        ENDIF
        PRINT,opener+'Junked ' + STRCOMPRESS(nGood-nKeeper,/REMOVE_ALL) + ' blackballed events ...'
     ENDIF ELSE BEGIN
        PRINT,opener+"No baddies found in this case ..."
     ENDELSE
  ENDFOR

  IF KEYWORD_SET(broken) THEN STOP

  PRINT,"Junked " + STRCOMPRESS(nBTot,/REMOVE_ALL) + " events associated with blackballed orbits"

  RETURN,good_i
END
