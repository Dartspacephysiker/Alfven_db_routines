;;12/08/16
FUNCTION COMPARE_DELTA_TYPES,db1,db2

  COMPILE_OPT IDL2

  bCode1 = db1.info.dILAT_not_dt OR ISHFT(db1.info.dAngle_not_dt,1) OR ISHFT(db1.info.dx_not_dt,2)
  bCode2 = db2.info.dILAT_not_dt OR ISHFT(db2.info.dAngle_not_dt,1) OR ISHFT(db2.info.dx_not_dt,2)

  RETURN,bCode1 EQ bCode2;;  THEN BEGIN
  ;;    PRINT,"They don't match!"
  ;;    STOP
  ;; ENDIF

END
