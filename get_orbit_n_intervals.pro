;;06/11/16
FUNCTION GET_ORBIT_N_INTERVALS,orbitNum

  COMPILE_OPT IDL2

  ;;Just here and LOAD_ORBIT_INTERVAL_DB
  COMMON ORB_INTERVALS,OI__intervalArr

  minOrb       = 500
  maxOrb       = 16361

  IF N_ELEMENTS(orbitNum) EQ 0 THEN BEGIN
     PRINT,"No orbit number provided! In that case, -1 intervals ..."
     RETURN,-1
  ENDIF

  IF orbitNum LT minOrb OR orbitNum GT maxOrb THEN BEGIN
     PRINT,FORMAT='("Sorry, can''t provide N intervals for orbits outside the range ",I0,"-",I0)',minOrb,maxOrb
     RETURN,-1
  ENDIF

  IF N_ELEMENTS(OI__intervalArr) EQ 0 THEN BEGIN
     LOAD_ORBIT_INTERVAL_DB
  ENDIF 

  RETURN,OI__intervalArr[orbitNum]

END
