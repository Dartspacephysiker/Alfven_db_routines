FUNCTION LSHELL_TO_ILAT_PARABOLA_FIT,x,MINL=x2,MAXL=x3,MINI=y2,MAXI=y3

  IF N_ELEMENTS(minI) EQ 0 THEN minI = 60
  IF N_ELEMENTS(maxI) EQ 0 THEN maxI = 88

  x1   = 1
  y1   = 45

  ;;I want y-y0=a*(x-x0)^2
  c    = (y1-y2)/(y2-y3)
  x0   = (-x1^2+x2^2+c*(x2^2-x3^2))/(2.0*(-x1+x2+c*x2-c*x3))
  a    = (y1-y2)/((x1-x0)^2-(x2-x0)^2)
  y0   = y1-a*(x1-x0)^2

  ilats = a*(x-x0)^2+y0

  RETURN,ilats

END