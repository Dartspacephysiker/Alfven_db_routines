;2018/08/30
;; Now compare my FAST FAC dB and Strangeway's FAST FAC dB
PRO JOURNAL__20180830__COMPARE_MY_FAST_COORD_CONVERSIONS_WITH_SDT_OUTPUT

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__maximus_vars.pro  
  @tplot_com

  doLatLonAltComparison  = 0
  doBGEIComparison       = 0
  doBFACComparison       = 1

  date            = '991015'
  FASTorbit       = 12464

  outDir          = '/SPENCEdata/Research/database/Oersted/'
  FASTdir         = outDir
  FASTfile        = "FAST_dbFac-orb_"+STRING(FORMAT='(I0)',FASTorbit)+".sav"
  FASTCoordFile   = "FAST_dbFac-orb_"+STRING(FORMAT='(I0)',FASTorbit)+"-converted_coords.sav"

  RESTORE,FASTdir+FASTfile
  RESTORE,FASTdir+FASTCoordFile

  interestingTider = ['1999-10-15/05:18:00','1999-10-15/05:28:00']
  maxInteressant   = '1999-10-15/05:23:00'
  t1 = S2T(interestingTider[0])
  t2 = S2T(interestingTider[1])
  tWow = S2T(maxInteressant)

  ;; Get stuff X minutes before and after conjunction
  zoomMin = 1.0
  t1Zoom  = tWow-zoomMin*60
  t2Zoom  = tWow+zoomMin*60

  ;; STOP

  ctNum            = 43         ;better. no oceans of green

  red              = (ctNum EQ 43) ? 235 : 250
  darkRed          = 250
  green            = 130
  blue             = 90
  maxwell          = 50
  black            = 10
  poiple           = 40
  violet           = 60
  hvit             = 255

  ;; varName = 'dB_fac'
  ;; STORE_DATA,varName,DATA={x: db_fac.time, $
  ;;                          y: [[db_fac.o],[db_fac.e],[db_fac.b]]}
  ;; OPTIONS,varName,'labels',['o','e','b']
  ;; OPTIONS,varName,'colors',[red,green,blue]
  ;; OPTIONS,varName,'tplot_routine','mplot'
  ;; OPTIONS,varName,'ytitle',"FAST delta-B"

  lonLatAltWindIdx       = 0
  BGEIWindIdx            = 1
  BFACWindIdx            = 2
  IF KEYWORD_SET(doLatLonAltComparison) THEN BEGIN

     ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;; COMPARE: db_fac.alt and coords.pos.alt

     ;; varName = "AltComparison"
     ;; STORE_DATA,varName,DATA={x: db_fac.time,y: [[db_fac.alt],[coords.pos.geo.alt]]}
     ;; OPTIONS,varName,'colors',[red,green]
     ;; OPTIONS,varName,'labels',['SDT','Spencer']
     ;; OPTIONS,varName,'tplot_routine','mplot'
     ;; OPTIONS,varName,'ytitle',"Altitude (km)"
     ;; tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]

     varName = "AltComparison"
     STORE_DATA,varName,DATA={x: db_fac.time,y: db_fac.alt-coords.pos.geo.alt}
     ;; OPTIONS,varName,'colors',[red,green]
     ;; OPTIONS,varName,'labels',['SDT','Spencer']
     ;; OPTIONS,varName,'tplot_routine','mplot'
     OPTIONS,varName,'ytitle',"Altitude(SDT)-altitude(Spencer) (km)"
     tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]


     ;; From man orbitlib we have
     ;; double    lat, lng            ; /* Geographic latitude, longitude (deg)

     ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;; so COMPARE: db_fac.lat and coords.geo.lat
     varName = "LatComparison"
     STORE_DATA,varName,DATA={x: db_fac.time,y: [[db_fac.lat],[coords.pos.geo.lat]]}
     OPTIONS,varName,'colors',[red,green]
     OPTIONS,varName,'labels',['SDT','Spencer']
     OPTIONS,varName,'tplot_routine','mplot'
     OPTIONS,varName,'ytitle',"Latitude (deg)"
     tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]


     ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;             db_fac.lng and coords.geo.lon
     varName = "LonComparison"
     STORE_DATA,varName,DATA={x: db_fac.time,y: [[db_fac.lng],[coords.pos.geo.lon]]}
     OPTIONS,varName,'colors',[red,green]
     OPTIONS,varName,'labels',['SDT','Spencer']
     OPTIONS,varName,'tplot_routine','mplot'
     OPTIONS,varName,'ytitle',"Longitude (deg)"
     tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]

     ;; Plot it
     LOADCT2,ctNum
     TPLOT,tPltVars,WINDOW=lonLatAltWindIdx,TRANGE=[t1Zoom,t2Zoom],VAR=barVars

     tPltVars = !NULL

  ENDIF

  IF KEYWORD_SET(doBGEIComparison) THEN BEGIN

     ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;; db_fac.b_model and db_fac.bfoot give the FAST B model and footpoint B in GEI coords
     ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;; COMPARE: db_fac.b_model[*,0] and coords.igrf.gei.car.x

     varName = "BGEIx"
     STORE_DATA,varName,DATA={x: db_fac.time,y: [[REFORM(db_fac.b_model[*,0])], $
                                                 [coords.igrf.gei.car.x]]}
     OPTIONS,varName,'colors',[red,green]
     OPTIONS,varName,'labels',['SDT','Spencer']
     OPTIONS,varName,'tplot_routine','mplot'
     OPTIONS,varName,'ytitle',"IGRF B!Dx!N (nT)"
     tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]

     ;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;; ;; COMPARE: db_fac.b_model[*,1] and coords.igrf.gei.car.y

     varName = "BGEIy"
     STORE_DATA,varName,DATA={x: db_fac.time,y: [[REFORM(db_fac.b_model[*,1])], $
                                                 [coords.igrf.gei.car.y]]}
     OPTIONS,varName,'colors',[red,green]
     OPTIONS,varName,'labels',['SDT','Spencer']
     OPTIONS,varName,'tplot_routine','mplot'
     OPTIONS,varName,'ytitle',"IGRF B!Dy!N (nT)"
     tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]

     ;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;; ;; COMPARE: db_fac.b_model[*,2] and coords.igrf.gei.car.z

     varName = "BGEIz"
     STORE_DATA,varName,DATA={x: db_fac.time,y: [[REFORM(db_fac.b_model[*,2])], $
                                                 [coords.igrf.gei.car.z]]}
     OPTIONS,varName,'colors',[red,green]
     OPTIONS,varName,'labels',['SDT','Spencer']
     OPTIONS,varName,'tplot_routine','mplot'
     OPTIONS,varName,'ytitle',"IGRF B!Dz!N (nT)"
     tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]

     ;; Plot it
     WINDOW,BGEIWindIdx
     LOADCT2,ctNum
     TPLOT,tPltVars,WINDOW=BGEIWindIdx,TRANGE=[t1Zoom,t2Zoom],VAR=barVars

     tPltVars = !NULL
  ENDIF

  IF KEYWORD_SET(doBFACComparison) THEN BEGIN

     ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;; db_fac.b_model and db_fac.bfoot give the FAST B model and footpoint B in GEI coords
     ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;; COMPARE: db_fac.b_model[*,0] and coords.igrf.gei.car.x

     varName = "FACx"
     STORE_DATA,varName,DATA={x: db_fac.time,y: [[REFORM(db_fac.o)], $
                                                 [coords.bdiff.fac.car.o]]}
     OPTIONS,varName,'colors',[red,green]
     OPTIONS,varName,'labels',['Strange','Spencer']
     OPTIONS,varName,'tplot_routine','mplot'
     OPTIONS,varName,'ytitle',"B!Dout!N (nT)"
     tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]

     ;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;; ;; COMPARE: db_fac.b_model[*,1] and coords.bdiff.fac.car.y

     varName = "FACy"
     STORE_DATA,varName,DATA={x: db_fac.time,y: [[REFORM(db_fac.e)], $
                                                 [coords.bdiff.fac.car.e]]}
     OPTIONS,varName,'colors',[red,green]
     OPTIONS,varName,'labels',['Strange','Spencer']
     OPTIONS,varName,'tplot_routine','mplot'
     OPTIONS,varName,'ytitle',"B!Deast!N (nT)"
     tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]

     ;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;; ;; COMPARE: db_fac.b_model[*,2] and coords.bdiff.fac.car.z

     varName = "FACz"
     STORE_DATA,varName,DATA={x: db_fac.time,y: [[REFORM(db_fac.b)], $
                                                 [coords.bdiff.fac.car.b]]}
     OPTIONS,varName,'colors',[red,green]
     OPTIONS,varName,'labels',['Strange','Spencer']
     OPTIONS,varName,'tplot_routine','mplot'
     OPTIONS,varName,'ytitle',"B!Db!N (nT)"
     tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]

     ;; Plot it
     WINDOW,BFACWindIdx
     LOADCT2,ctNum
     TPLOT,tPltVars,WINDOW=BFACWindIdx,TRANGE=[t1Zoom,t2Zoom],VAR=barVars

     tPltVars = !NULL
  ENDIF
  ;; fastIGRFMag=SQRT(db_fac.b_model[*,0]*db_fac.b_model[*,0]+db_fac.b_model[*,1]*db_fac.b_model[*,1]+db_fac.b_model[*,2]*db_fac.b_model[*,2])
  ;; myIGRFMag=SQRT(coords.igrf.gei.car.x*coords.igrf.gei.car.x+coords.igrf.gei.car.y*coords.igrf.gei.car.y+coords.igrf.gei.car.z*coords.igrf.gei.car.z)
  

  STOP



END
