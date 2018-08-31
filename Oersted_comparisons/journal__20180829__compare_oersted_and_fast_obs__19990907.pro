;2018/08/29
;; INGENTING HER!
;; 20180830 I know that something is wrong with my FAST coord conversions (see JOURNAL__20180830__COMPARE_MY_FAST_COORD_CONVERSIONS_WITH_SDT_OUTPUT), so hold off on FAST-Ørsted comparison 
PRO JOURNAL__20180829__COMPARE_OERSTED_AND_FAST_OBS__19990907

  COMPILE_OPT IDL2,STRICTARRSUBS

  @common__maximus_vars.pro  
  @tplot_com

  outDir          = '/SPENCEdata/Research/database/Oersted/'

  nyeVei          = 1
  gamleVei        = 0
  reflect_about_tid = 1

  ;; inFile       = 'oersted-ml990907.sav'
  ;; timeStrFile  = 'oersted-ml990907.sav-timeStr.sav'
  ;; outFile      = 'oersted-ml990907-parsedCoordinates.sav'


  ;; date         = '990907'
  ;; FASTorbit    = 12049

  ;; Such money Alfveners for this conj with FAST
  date            = '991015'
  FASTorbit       = 12464

  inFile          = 'oersted-ml' + date + '.sav'
  timeStrFile     = 'oersted-ml' + date + '-timeStr.sav'
  outFile         = 'oersted-ml' + date + '-parseCoordinates.sav'

  FASTdir         = outDir
  FASTfile        = "FAST_dbFac-orb_"+STRING(FORMAT='(I0)',FASTorbit)+".sav"
  FASTCoordFile   = "FAST_dbFac-orb_"+STRING(FORMAT='(I0)',FASTorbit)+"-converted_coords.sav"

  RESTORE,outDir+inFile
  RESTORE,outDir+outFile

  oerstCoord      = TEMPORARY(coords)

  CASE FASTorbit OF
     12049: BEGIN
        interestingTider = ['1999-09-07/02:25:00','1999-09-07/02:45:00']
        maxInteressant   = '1999-09-07/02:36:00'
     END
     12464: BEGIN
        interestingTider = ['1999-10-15/05:18:00','1999-10-15/05:28:00']
        maxInteressant   = '1999-10-15/05:23:00'
     END
  ENDCASE
  t1 = S2T(interestingTider[0])
  t2 = S2T(interestingTider[1])
  tWow = S2T(maxInteressant)

  ;; Get stuff X minutes before and after conjunction
  zoomMin = 2
  t1Zoom = tWow-zoomMin*60
  t2Zoom = tWow+zoomMin*60

  LOAD_MAXIMUS_AND_CDBTIME

  FASTi = WHERE(MAXIMUS__maximus.orbit EQ FASTorbit,nFASTi)

  Oeri  = WHERE(oersted.time GE t1 AND oersted.time LE t2,nOeri)

  PRINT,maximus__maximus.time[FASTi]

  ;; Load up the magnetic field stuff

  IF FILE_TEST(FASTdir+FASTfile) THEN BEGIN

     PRINT,"Restoring " + FASTfile + " ..."

     RESTORE,FASTdir+FASTfile

     IF ~FILE_TEST(FASTdir+FASTCoordFile) THEN BEGIN
        PRINT,"Have you done the necessaries with JOURNAL__20180830__CONVERT_FAST_GSE_POS_AND_GEI_BFIELD_TO_OTHER_COORDINATES??"
        STOP
     ENDIF

     PRINT,"Restoring " + FASTCoordfile + " ..."

     RESTORE,FASTdir+FASTCoordFile

     FASTcoord = TEMPORARY(coords)

  ENDIF ELSE BEGIN

     ;; GET FAST MAG DATA
     UCLA_MAG_DESPIN,TW_MAT=tw_mat,ORBIT=orbit,SPIN_AXIS=spin_axis,DELTA_PHI=delta_phi,/QUIET
     ;;FAC system 1 (ripped from UCLA_MAG_DESPIN)
     ;;   "Field-aligned coordinates defined as:   "
     ;;   "z-along B, y-east (BxR), x-nominally out"
     ;; GET_DATA,'dB_fac_v',DATA=data
     GET_DATA,'dB_fac',DATA=data

     ;; 'B_gei'      Smoothed and deglitched field in GEI coordinates
     GET_DATA,'B_gei',DATA=Bgei

     FASTB_GEI = {time : Bgei.x, $
                  x    : Bgei.y[*,0], $
                  y    : Bgei.y[*,1], $
                  z    : Bgei.y[*,2]}

     GET_FA_ORBIT,data.x,/TIME_ARRAY,STRUC=ephem,/NO_STORE,/ALL

     db_fac = {time          : data.x, $
               orbit         : ephem.orbit, $
               alt           : ephem.alt, $
               ilat          : ephem.ilat, $
               mlt           : ephem.mlt, $
               gei           : {pos : ephem.fa_pos, $
                                vel : ephem.fa_vel}, $
               lat           : ephem.lat, $
               lng           : ephem.lng, $
               bfoot         : ephem.bfoot, $
               b_model       : ephem.b_model, $
               o             : REFORM(data.y[*,0]), $
               e             : REFORM(data.y[*,1]), $
               b             : REFORM(data.y[*,2])}

     PRINT,"Saving " + FASTfile + " ..."
     SAVE,db_fac,FASTB_GEI,FILENAME=FASTdir+FASTfile

  ENDELSE

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

  fastO = db_fac.o
  fastE = db_fac.e
  fastB = db_fac.b

  fastO = fastCoord.bDiff.fac.car.o
  fastE = fastCoord.bDiff.fac.car.e
  fastB = fastCoord.bDiff.fac.car.b
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; gamle vei
  IF KEYWORD_SET(gamleVei) THEN BEGIN

     varName = 'dB_fac'
     STORE_DATA,varName,DATA={x: db_fac.time, $
                              y: [[fastO],[fastE],[fastB]]}
     OPTIONS,varName,'labels',['o','e','b']
     OPTIONS,varName,'colors',[red,green,blue]
     OPTIONS,varName,'tplot_routine','mplot'
     OPTIONS,varName,'ytitle',"FAST delta-B"
     tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]

     varName = 'Oer_fac'
     STORE_DATA,varName,DATA={x: oersted.time, $
                              y: [[oerstCoord.bdiff.fac.car.o],[oerstCoord.bdiff.fac.car.e],[oerstCoord.bdiff.fac.car.b]]}
     OPTIONS,varName,'labels',['o','e','b']
     OPTIONS,varName,'colors',[red,green,blue]
     OPTIONS,varName,'tplot_routine','mplot'
     OPTIONS,varName,'ytitle',"Oersted delta-B"
     tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]

  ENDIF

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Nye vei
  IF KEYWORD_SET(nyeVei) THEN BEGIN
     varName = 'dB_facShift'
     indFAST_t1Zoom = VALUE_CLOSEST2(db_fac.time,t1Zoom,/CONSTRAINED)
     dbFacArr = [[fastO-fastO[indFAST_t1Zoom]], $
                 [fastE-fastE[indFAST_t1Zoom]], $
                 [fastB-fastB[indFAST_t1Zoom]]]
     STORE_DATA,varName,DATA={x: db_fac.time, $
                              y: dbFacArr}
     OPTIONS,varName,'labels',['o','e','b']
     OPTIONS,varName,'colors',[red,green,blue]
     OPTIONS,varName,'tplot_routine','mplot'
     OPTIONS,varName,'ytitle',"FAST delta-B!C(shift)"
     tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]

     varName = 'Oer_facShift'
     indOer_t1Zoom = VALUE_CLOSEST2(oersted.time,t1Zoom,/CONSTRAINED)
     dbFacOerArr = [[oerstCoord.bdiff.fac.car.o-oerstCoord.bdiff.fac.car.o[indOer_t1Zoom]], $
                    [oerstCoord.bdiff.fac.car.e-oerstCoord.bdiff.fac.car.e[indOer_t1Zoom]], $
                    [oerstCoord.bdiff.fac.car.b-oerstCoord.bdiff.fac.car.b[indOer_t1Zoom]]]
     STORE_DATA,varName,DATA={x: oersted.time, $
                              y: dbFacOerArr}
     OPTIONS,varName,'labels',['o','e','b']
     OPTIONS,varName,'colors',[red,green,blue]
     OPTIONS,varName,'tplot_routine','mplot'
     OPTIONS,varName,'ytitle',"Oersted delta-B!C(shift)"
     tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]

  ENDIF

  IF KEYWORD_SET(reflect_about_tid) THEN BEGIN

     nOer = N_ELEMENTS(oerstCoord.bdiff.fac.car.o)
     ;; nFAST = N_ELEMENTS(fastE)

     iWowOer  = VALUE_CLOSEST2(oersted.time,tWow,/CONSTRAINED)
     iT1Oer = VALUE_CLOSEST2(oersted.time,t1Zoom,/ONLY_LE)
     iT2Oer = VALUE_CLOSEST2(oersted.time,t2Zoom,/ONLY_GE)

     nAfter = iT2Oer-iWowOer
     nBef   = iWowOer-iT1Oer
     nShift = nAfter > nBef
     
     ;; iWowFAST = VALUE_CLOSEST2(db_fac.time,tWow,/CONSTRAINED)

     ;; iOer = REVERSE([iT1Oer:iT2Oer:1])
     iOer = [(iWowOer-nShift>0):(iWowOer+nShift<(nOer-1)):1]
     iOerR = REVERSE(iOer)

     oerstCoord.bdiff.fac.car.o[iOer] = oerstCoord.bdiff.fac.car.o[iOerR]
     oerstCoord.bdiff.fac.car.e[iOer] = oerstCoord.bdiff.fac.car.e[iOerR]
     oerstCoord.bdiff.fac.car.b[iOer] = oerstCoord.bdiff.fac.car.b[iOerR]

     indOer_t1Zoom = VALUE_CLOSEST2(oersted.time,t1Zoom,/CONSTRAINED)
     oSubtr = oerstCoord.bdiff.fac.car.o[indOer_t1Zoom]
     eSubtr = oerstCoord.bdiff.fac.car.e[indOer_t1Zoom]
     bSubtr = oerstCoord.bdiff.fac.car.b[indOer_t1Zoom]

     varName = 'dB_facShift'
     indFAST_t1Zoom = VALUE_CLOSEST2(db_fac.time,t1Zoom,/CONSTRAINED)
     dbFacArr = [[fastO-fastO[indFAST_t1Zoom]], $
                 [fastE-fastE[indFAST_t1Zoom]], $
                 [fastB-fastB[indFAST_t1Zoom]]]
     STORE_DATA,varName,DATA={x: db_fac.time, $
                              y: dbFacArr}
     OPTIONS,varName,'labels',['o','e','b']
     OPTIONS,varName,'colors',[red,green,blue]
     OPTIONS,varName,'tplot_routine','mplot'
     OPTIONS,varName,'ytitle',"FAST delta-B!C(shift)"
     tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]

     varName = 'Oer_facShiftRev'
     dbFacOerArr = [[oerstCoord.bdiff.fac.car.o-oSubtr], $
                    [oerstCoord.bdiff.fac.car.e-eSubtr], $
                    [oerstCoord.bdiff.fac.car.b-bSubtr]]
     STORE_DATA,varName,DATA={x: oersted.time, $
                              y: dbFacOerArr}
     OPTIONS,varName,'labels',['o','e','b']
     OPTIONS,varName,'colors',[red,green,blue]
     OPTIONS,varName,'tplot_routine','mplot'
     OPTIONS,varName,'ytitle',"Oersted delta-B!C(shift)"
     tPltVars = N_ELEMENTS(tPltVars) EQ 0 ? varName : [tPltVars,varName]

     ;; CASE 1 OF
     ;;    iWowOer EQ 0: BEGIN
     ;;       STOP
     ;;    END
     ;;    iWowOer EQ (nOer-1): BEGIN
     ;;       STOP
     ;;    END
     ;;    ELSE: BEGIN
           
     ;;       iBoveOer = [iWowOer:(nOer-1):1]
     ;;       i    = [iWowOer:(nOer-1):1]

     ;;    END
     ;; ENDCASE


  ENDIF

  varName = "FASTMLT"
  STORE_DATA,varName,DATA={x:db_fac.time,y:db_fac.mlt}
  barVars = N_ELEMENTS(barVars) EQ 0 ? varName : [varName,barVars]

  varName = "FASTILAT"
  STORE_DATA,varName,DATA={x:db_fac.time,y:db_fac.ilat}
  barVars = N_ELEMENTS(barVars) EQ 0 ? varName : [varName,barVars]

  varName = "FASTALT"
  STORE_DATA,varName,DATA={x:db_fac.time,y:db_fac.alt}
  barVars = N_ELEMENTS(barVars) EQ 0 ? varName : [varName,barVars]

  ;; OerMLT = ((oerstCoord.pos.gsm.sph.phi+180.) MOD 360.)/15.
  ;; varName = 'OerMLT'
  ;; STORE_DATA,varName,DATA={x:oersted.time,y:OerMLT}
  ;; barVars = N_ELEMENTS(barVars) EQ 0 ? varName : [varName,barVars]

  varName = 'OerMLAT'
  STORE_DATA,varName,DATA={x:oersted.time,y:oerstCoord.pos.mag.lat}
  barVars = N_ELEMENTS(barVars) EQ 0 ? varName : [varName,barVars]

  varName = 'OerALT'
  STORE_DATA,varName,DATA={x:oersted.time,y:oerstCoord.pos.geo.alt}
  barVars = N_ELEMENTS(barVars) EQ 0 ? varName : [varName,barVars]

  ;; Plot it
  LOADCT2,ctNum
  TPLOT,tPltVars,TRANGE=[t1Zoom,t2Zoom],VAR=barVars

  STOP


END
