;2018/08/27
PRO JOURNAL__20180827__PARSE_OERSTED_CDF

  COMPILE_OPT IDL2,STRICTARRSUBS


  dir  = '/SPENCEdata/Research/database/Oersted/'

  ;; file = 'dms_19970201_12e.001.nc'
  ;; outFile = 'dms_19970201_12e.001.sav'

  ;; file = 'ml990907.cdf'
  ;; outFile = 'oersted-ml990907.sav'

  ;; date = '990907'

  ;; Such money Alf waves for this day
  ;; Run JOURNAL__20180829__FOERSTE_TING_FOERSTE__FIND_FAST_IAW_EVENTS_FOR_POSSIBLE_CONJUNCTIONS with cleanEm=1 to convince yourself, hey?
  date = '991015'
  file = 'ml' + date + '.cdf'
  outFile = 'oersted-ml' + date + '.sav'

  IF FILE_TEST(dir+outFile) THEN BEGIN

     PRINT,"Restoring " + outFile + ' ...'
     RESTORE,dir+outFile

  ENDIF ELSE BEGIN

     id = CDF_OPEN(dir+file)    ; Open a file.

     inq = CDF_INQUIRE(id)
     HELP, inq, /STRUCT 

     attInfo = {ind: 0L, $
                name: '', $
                scope: '', $
                maxentry: 0L, $
                maxzentry: 0L}
     attInfos = REPLICATE(attInfo,inq.nAtts)
     FOR k=0,inq.nAtts-1 DO BEGIN

        CDF_ATTINQ, id, k, name, scope, maxentry, maxzentry

        attInfos[k].ind        = k
        attInfos[k].name       = name
        attInfos[k].scope      = scope
        attInfos[k].maxentry   = maxentry
        attInfos[k].maxzentry  = maxzentry

     ENDFOR


     varInfo = {name: '', $
                type: '', $
                validMin:0.D, $
                validMax: 0.D, $
                units: '', $
                format: '', $
                fillVal: 0.D $
               }
     varInfos = REPLICATE(varInfo,inq.nzvars)
     ;; var = {fieldNam  : '', $
            
     ;;        fieldNam   : '', $
     ;;        fieldNam   : '', $
     ;;        fieldNam   : '', $
     ;;        fieldNam   : '', $
     ;;        fieldNam   : '', $
     ;;       }


     nameList      = LIST()
     dataList      = LIST()
     validMinList  = LIST()
     validMaxList  = LIST()
     unitsList     = LIST()
     formatList    = LIST()
     fillValList   = LIST()

; Walk through all of the zVariables
     FOR varNum = 0, inq.nzvars-1 DO BEGIN
        
                                ; Walk through all of the ZVariable attributes
        FOR attrNum = 0, inq.natts-1 DO BEGIN
           
                                ; Read the variable attribute
           CDF_ATTGET_ENTRY, id, attrNum, varNum, attType, value, $
                             status, /ZVARIABLE, CDF_TYPE=cdfType, $
                             ATTRIBUTE_NAME=attName

           CDF_ATTINQ,id,attrNum,name, scope, maxentry, maxzentry

           IF STATUS NE 1 THEN CONTINUE

           IF STRUPCASE(attName) EQ "FIELDNAM" THEN BEGIN
              PRINT,""
              PRINT,"(",varNum,")"," ",value
              PRINT,"====================================="

              nameList.Add,value
              varInfos[varNum].name = value

              is_zVar = (STRUPCASE(attType) EQ 'ZVAR')
              IF ~is_zVar THEN STOP

              Result = CDF_VARINQ(id,varNum,ZVARIABLE=is_zVar)

              CDF_CONTROL,id,VARIABLE=varNum,ZVARIABLE=is_zVar,GET_VAR_INFO=V

              ;; IF V.maxAllocRec NE -1 AND V.maxRec NE -1 THEN BEGIN
              CDF_VARGET,id,varNum,varData,ZVARIABLE=is_zVar,REC_COUNT=V.maxAllocRec NE -1 ? V.maxAllocRec+1 : !NULL

              dims = SIZE(vardata,/DIMENSIONS) 
              IF N_ELEMENTS(dims) EQ 2 THEN BEGIN
                 IF dims[0] EQ 1 AND dims[1] NE 1 THEN varData = REFORM(varData)
              ENDIF
              ;; ENDIF ELSE BEGIN
              ;;    STOP
              ;; ENDELSE

              IF varNum EQ 0 THEN BEGIN
                 utc = CDF_EPOCH_TO_UTC(varData)
                 tidStr = T2S(utc)
                 PRINT,tidStr
                 dataList.Add,{utc:utc, $
                               tstring:tidStr, $
                               epoch:varData}
              ENDIF ELSE BEGIN
                 dataList.Add,varData
              ENDELSE

           ENDIF ELSE BEGIN 
              PRINT, attName, " (", cdfType, "): ", $
                     value


              CASE STRUPCASE(attName) OF
                 "VALIDMIN": BEGIN
                    validMinList.Add,value
                    varInfos[varNum].validMin = value
                    varInfos[varNum].type = SIZE(value,/TNAME)
                 END
                 "VALIDMAX": BEGIN
                    validMaxList.Add,value
                    varInfos[varNum].validMax = value
                 END
                 "UNITS": BEGIN
                    unitsList.Add,value
                    varInfos[varNum].units = value
                 END
                 "FORMAT": BEGIN
                    formatList.Add,value
                    varInfos[varNum].format = value
                 END
                 "FILLVAL": BEGIN
                    fillValList.Add,value
                    varInfos[varNum].fillVal = value
                 END
              ENDCASE

           ENDELSE
        ENDFOR
     ENDFOR

     CDF_CLOSE, id              ; Close the cdf file.

     times=(dataList[0]).utc+(dataList[1])

     oersted = {time: times, $
                mlt         : dataList[25], $
                qdlat       : dataList[26], $
                qdlon       : dataList[27], $
                modApexLat  : dataList[28], $
                ecef        : {r        : dataList[2], $
                               theta    : dataList[3], $
                               phi      : dataList[4]}, $
                b           : {scalar  : dataList[7], $
                               r        :  REFORM((dataList[9])[0,*]), $
                               theta    : REFORM((dataList[9])[1,*]), $
                               phi      : REFORM((dataList[9])[2,*])}, $
                electrons   : {med  : dataList[13], $
                               high : dataList[14]}, $
                ions        : {med  : dataList[15], $
                               high : dataList[16]}, $
                info        : varInfos $
               }

     STOP

     PRINT,"Saving Oersted struct to " + outFile + ' ...'
     SAVE,oersted,FILENAME=dir+outFile

     ;; 2-4 ECEF R COLAT LONG
     ;; ecef = {r: }

     ;; (           0) The day of the observation
     ;; =====================================
     ;; VALIDMIN (CDF_EPOCH):    6.3086947e+13
     ;; VALIDMAX (CDF_EPOCH):    6.3303206e+13
     ;; UNITS (CDF_CHAR): date
     ;; FORMAT (CDF_CHAR): <year>-<mm.02>-<dom.02>
     ;; FILLVAL (CDF_EPOCH):        0.0000000

     ;; (           1) Time of the day (UTC) of the observation
     ;; =====================================
     ;; VALIDMIN (CDF_REAL8):        0.0000000
     ;; VALIDMAX (CDF_REAL8):        86401.000
     ;; UNITS (CDF_CHAR): s
     ;; FORMAT (CDF_CHAR): F9.3
     ;; FILLVAL (CDF_REAL8):       -1.0000000

     ;; (           2) Position coordinate, ECEF, radius from center of earth
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):       6600.00
     ;; VALIDMAX (CDF_REAL4):       7300.00
     ;; UNITS (CDF_CHAR): km
     ;; FORMAT (CDF_CHAR): F8.3
     ;; FILLVAL (CDF_REAL4):       0.00000

     ;; (           3) Position coordinate, ECEF, co-latitude
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):       0.00000
     ;; VALIDMAX (CDF_REAL4):       180.000
     ;; UNITS (CDF_CHAR): degrees
     ;; FORMAT (CDF_CHAR): F10.5
     ;; FILLVAL (CDF_REAL4):      -1.00000

     ;; (           4) Position coordinate, ECEF, longitude
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):      -180.000
     ;; VALIDMAX (CDF_REAL4):       180.000
     ;; UNITS (CDF_CHAR): degrees
     ;; FORMAT (CDF_CHAR): F10.5
     ;; FILLVAL (CDF_REAL4):      -999.000

     ;; (           5) 
     ;; SIM boresight unit vector
     ;; 1. r (radial component)
     ;; 2. theta (southward component)
     ;; 3. phi (eastward component)
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):      -1.00000
     ;; VALIDMAX (CDF_REAL4):       1.00000
     ;; UNITS (CDF_CHAR): unit vector
     ;; FORMAT (CDF_CHAR): F9.6
     ;; FILLVAL (CDF_REAL4):      -9.00000

     ;; (           6) Position coordinate, information and quality
     ;; =====================================
     ;; VALIDMIN (CDF_UINT1):    0
     ;; VALIDMAX (CDF_UINT1):  255
     ;; UNITS (CDF_CHAR): binary
     ;; FORMAT (CDF_CHAR): I3
     ;; FILLVAL (CDF_UINT1):    0

     ;; (           7) Scalar magnetic measurement
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):       15000.0
     ;; VALIDMAX (CDF_REAL4):       60000.0
     ;; UNITS (CDF_CHAR): nT
     ;; FORMAT (CDF_CHAR): F7.1
     ;; FILLVAL (CDF_REAL4):       0.00000

     ;; (           8) Scalar magnetic measurement, information and quality
     ;; =====================================
     ;; VALIDMIN (CDF_UINT1):    0
     ;; VALIDMAX (CDF_UINT1):  255
     ;; UNITS (CDF_CHAR): binary
     ;; FORMAT (CDF_CHAR): I3
     ;; FILLVAL (CDF_UINT1):    0

     ;; (           9) 
     ;; Vector magnetic measurement
     ;; 1. r (radial component)
     ;; 2. theta (southward component)
     ;; 3. phi (eastward component)
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):      -60000.0
     ;; VALIDMAX (CDF_REAL4):       60000.0
     ;; UNITS (CDF_CHAR): nT
     ;; FORMAT (CDF_CHAR): F8.1
     ;; FILLVAL (CDF_REAL4):      -99999.0

     ;; (          10) 
     ;; Vector magnetic measurement, error estimates
     ;; 1. r (radial component)
     ;; 2. theta (southward component)
     ;; 3. phi (eastward component)
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):       0.00000
     ;; VALIDMAX (CDF_REAL4):       60000.0
     ;; UNITS (CDF_CHAR): nT
     ;; FORMAT (CDF_CHAR): F8.1
     ;; FILLVAL (CDF_REAL4):      -1.00000

     ;; (          11) 
     ;; Vector magnetic measurement, fluctuations in intensity
     ;; 1. f (parallel component)
     ;; 2. east (eastward component)
     ;; 3. orth (orthogonal component)
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):       0.00000
     ;; VALIDMAX (CDF_REAL4):       60000.0
     ;; UNITS (CDF_CHAR): nT
     ;; FORMAT (CDF_CHAR): F8.1
     ;; FILLVAL (CDF_REAL4):      -1.00000

     ;; (          12) Vector magnetic measurement, information and quality
     ;; =====================================
     ;; VALIDMIN (CDF_UINT2):        0
     ;; VALIDMAX (CDF_UINT2):    65535
     ;; UNITS (CDF_CHAR): binary
     ;; FORMAT (CDF_CHAR): I5
     ;; FILLVAL (CDF_UINT2):        0

     ;; (          13) Medium energy electrons
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):       0.00000
     ;; VALIDMAX (CDF_REAL4):   5.00000e+06
     ;; UNITS (CDF_CHAR): flux (counts/second*cm^2*ster)
     ;; FORMAT (CDF_CHAR): F6.0
     ;; FILLVAL (CDF_REAL4):      -1.00000

     ;; (          14) High energy electrons
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):       0.00000
     ;; VALIDMAX (CDF_REAL4):   5.00000e+06
     ;; UNITS (CDF_CHAR): flux (counts/second*cm^2*ster)
     ;; FORMAT (CDF_CHAR): F6.0
     ;; FILLVAL (CDF_REAL4):      -1.00000

     ;; (          15) Medium energy ions
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):       0.00000
     ;; VALIDMAX (CDF_REAL4):   1.00000e+06
     ;; UNITS (CDF_CHAR): flux (counts/second*cm^2*ster)
     ;; FORMAT (CDF_CHAR): F6.0
     ;; FILLVAL (CDF_REAL4):      -1.00000

     ;; (          16) High energy ions
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):       0.00000
     ;; VALIDMAX (CDF_REAL4):   1.00000e+06
     ;; UNITS (CDF_CHAR): flux (counts/second*cm^2*ster)
     ;; FORMAT (CDF_CHAR): F6.0
     ;; FILLVAL (CDF_REAL4):      -1.00000

     ;; (          17) Kpap index, Kp element
     ;; =====================================
     ;; VALIDMIN (CDF_UINT1):    0
     ;; VALIDMAX (CDF_UINT1):   30
     ;; UNITS (CDF_CHAR): 0=0o,1=0+,2=1-,...,27=9o
     ;; FORMAT (CDF_CHAR): I2
     ;; FILLVAL (CDF_UINT1):   99

     ;; (          18) Dst index
     ;; =====================================
     ;; VALIDMIN (CDF_INT2):     -900
     ;; VALIDMAX (CDF_INT2):      900
     ;; UNITS (CDF_CHAR): nT
     ;; FORMAT (CDF_CHAR): I4
     ;; FILLVAL (CDF_INT2):     9999

     ;; (          19) aa index
     ;; =====================================
     ;; VALIDMIN (CDF_INT2):        0
     ;; VALIDMAX (CDF_INT2):      999
     ;; UNITS (CDF_CHAR): nT
     ;; FORMAT (CDF_CHAR): I3
     ;; FILLVAL (CDF_INT2):      -99

     ;; (          20) am index
     ;; =====================================
     ;; VALIDMIN (CDF_INT2):        0
     ;; VALIDMAX (CDF_INT2):      999
     ;; UNITS (CDF_CHAR): nT
     ;; FORMAT (CDF_CHAR): I3
     ;; FILLVAL (CDF_INT2):      -99

     ;; (          21) an index
     ;; =====================================
     ;; VALIDMIN (CDF_INT2):        0
     ;; VALIDMAX (CDF_INT2):      999
     ;; UNITS (CDF_CHAR): nT
     ;; FORMAT (CDF_CHAR): I3
     ;; FILLVAL (CDF_INT2):      -99

     ;; (          22) as index
     ;; =====================================
     ;; VALIDMIN (CDF_INT2):        0
     ;; VALIDMAX (CDF_INT2):      999
     ;; UNITS (CDF_CHAR): nT
     ;; FORMAT (CDF_CHAR): I3
     ;; FILLVAL (CDF_INT2):      -99

     ;; (          23) Longitude Sector index
     ;; =====================================
     ;; VALIDMIN (CDF_INT1):        0
     ;; VALIDMAX (CDF_INT1):        9
     ;; UNITS (CDF_CHAR): K-codes
     ;; FORMAT (CDF_CHAR): I2
     ;; FILLVAL (CDF_INT1):       -1

     ;; (          24) Magnetic field disturbance indices, information and quality
     ;; =====================================
     ;; VALIDMIN (CDF_UINT2):        0
     ;; VALIDMAX (CDF_UINT2):    65535
     ;; UNITS (CDF_CHAR): binary
     ;; FORMAT (CDF_CHAR): I5
     ;; FILLVAL (CDF_UINT2):        0

     ;; (          25) Magnetic Local Time
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):       0.00000
     ;; VALIDMAX (CDF_REAL4):       24.0000
     ;; UNITS (CDF_CHAR): Hours
     ;; FORMAT (CDF_CHAR): F5.1
     ;; FILLVAL (CDF_REAL4):      -1.00000

     ;; (          26) Quasi-Dipole latitude
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):      -90.0000
     ;; VALIDMAX (CDF_REAL4):       90.0000
     ;; UNITS (CDF_CHAR): degrees
     ;; FORMAT (CDF_CHAR): F5.1
     ;; FILLVAL (CDF_REAL4):      -100.000

     ;; (          27) Quasi-Dipole longitude
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):       0.00000
     ;; VALIDMAX (CDF_REAL4):       360.000
     ;; UNITS (CDF_CHAR): degrees
     ;; FORMAT (CDF_CHAR): F5.1
     ;; FILLVAL (CDF_REAL4):      -1.00000

     ;; (          28) Modified Apex latitude
     ;; =====================================
     ;; VALIDMIN (CDF_REAL4):      -90.0000
     ;; VALIDMAX (CDF_REAL4):       90.0000
     ;; UNITS (CDF_CHAR): degrees
     ;; FORMAT (CDF_CHAR): F5.1
     ;; FILLVAL (CDF_REAL4):      -100.000

  ENDELSE

END
