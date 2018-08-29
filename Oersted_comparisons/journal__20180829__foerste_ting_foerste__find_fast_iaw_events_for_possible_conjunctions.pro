;2018/08/29
;; ORBIT 12464 IS SO MONEY
PRO JOURNAL__20180829__FOERSTE_TING_FOERSTE__FIND_FAST_IAW_EVENTS_FOR_POSSIBLE_CONJUNCTIONS,orbits

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__maximus_vars.pro  

  cleanEm = 1

  ;; orbits = [11281,11457,11859,12049,12172, $
  ;;           12201,12238,12272,12350,12361, $
  ;;           12362,12365,12366,12368,12371, $
  ;;           12384,12399,12402,12403,12405, $
  ;;           12406]

  ;; ;; wussy orbits
  ;; orbits = [11494,11531,12142,12204,12238,12272,12294,12365,12387]

  LOAD_MAXIMUS_AND_CDBTIME

  IF KEYWORD_SET(cleanEm) THEN BEGIN
     good_i      = ALFVEN_DB_CLEANER( $
                   MAXIMUS__maximus, $
                   SAMPLE_T_RESTRICTION=0, $
                   INCLUDE_32Hz=0, $
                   DISREGARD_SAMPLE_T=0)
  ENDIF ELSE BEGIN
     good_i = LINDGEN(N_ELEMENTS(MAXIMUS__maximus.time))
  ENDELSE

  nOrbits = N_ELEMENTS(orbits)
  FOR k=0,nOrbits-1 DO BEGIN
     orbit = orbits[k]

     PRINT,""
     PRINT,orbit

     FASTi = WHERE(MAXIMUS__maximus.orbit[good_i] EQ orbit,nFASTi)

     IF nFASTi EQ 0 THEN BEGIN
        PRINT,"NADA!"
        CONTINUE
     ENDIF

     FOR kk=0,nFASTi-1 DO BEGIN
        tmpi = good_i[FASTi[kk]]
        PRINT,kk,", ",MAXIMUS__maximus.time[tmpi],", ",MAXIMUS__maximus.width_time[tmpi]
     ENDFOR
  ENDFOR

END