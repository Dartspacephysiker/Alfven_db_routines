;;12/01/16
PRO JOURNAL__20161201__FIGURE_OUT_HOW_TO_MAKE_MASKED_BINS_AVGS_OF_NEIGHBORS, $
   multVal,data, $
   CENTERSMLT=centersMLT, $
   CENTERSILAT=centersILAT, $
   MINMLT=minM, $
   MAXMLT=maxM, $
   BINMLT=binM, $
   MINILAT=minI, $
   MAXILAT=maxI, $
   BINILAT=binI, $
   EQUAL_AREA_BINNING=EA_binning, $
   BINCENTER=binC, $
   BINLEFTLOWER=binLL, $
   BINRIGHTUPPER=binRU, $
   NEW_VALS=new_vals, $
   VERBOSE=verbose, $
   ULTRA_VERBOSE=ultra_verbose

  COMPILE_OPT IDL2,STRICTARRSUBS

  LOAD_EQUAL_AREA_BINNING_STRUCT

  @common__ea_binning.pro

  ;;EXPERIMENTAL
  binm   = 1.0 *15.
  bini   = 2.0 
  minm   = 0 *15.
  maxm   = 24. *15.
  mini   = 60 
  maxi   = 90 
  shiftm = 0.0 
  GET_H2D_BIN_AREAS,h2dAreas, $
                    CENTERS1=centersMLT,CENTERS2=centersILAT, $
                    BINSIZE1=binM,BINSIZE2=binI, $
                    MAX1=maxM,MAX2=maxI, $
                    MIN1=minM,MIN2=minI, $
                    SHIFT1=shiftM*15.,SHIFT2=shiftI, $
                    EQUAL_AREA_BINNING=EA_binning

  centersMLT  = (centersMLT [0:-2,*   ] + centersMLT [1:-1,*   ])/2.
  centersILAT = (centersILAT[0:-2,*   ] + centersILAT[1:-1,*   ])/2.
  centersMLT  = (centersMLT [*   ,0:-2] + centersMLT [*   ,1:-1])/2.
  centersILAT = (centersILAT[*   ,0:-2] + centersILAT[*   ,1:-1])/2.

  binType                            = -1
  IF KEYWORD_SET(binC ) THEN binType = 0
  IF KEYWORD_SET(binLL) THEN binType = 1
  IF KEYWORD_SET(binRU) THEN binType = 2

  IF binType EQ -1 THEN BEGIN
     IF KEYWORD_SET(verbose) THEN PRINT,"Default: bin center"
     binType = 0
  ENDIF

  CASE KEYWORD_SET(EA_binning) OF
     0: BEGIN

        MLTbinMin  = centersMLT - binM/2.
        MLTbinMax  = centersMLT + binM/2.

        ILATbinMin = centersILAT - binI/2.
        ILATbinMax = centersILAT + binI/2.

        ;;Get our bin type
        CASE binType OF
           0: BEGIN
              MLTguy  = centersMLT
              ILATguy = centersILAT
           END
           1: BEGIN
              MLTguy  = MLTbinMin
              ILATguy = ILATbinMin
           END
           2: BEGIN
              MLTguy  = MLTbinMax
              ILATguy = ILATbinMax
           END
        ENDCASE

     END
     1: BEGIN

        ;;Get our bin type
        CASE binType OF
           0: BEGIN
              MLTguy  = ((EA__s.maxm+EA__s.minm)/2.)*15.
              ILATguy = ((EA__s.maxi+EA__s.mini)/2.)
           END
           1: BEGIN
              MLTguy  = EA__s.minm*15.
              ILATguy = EA__s.mini
           END
           2: BEGIN
              MLTguy  = EA__s.maxm*15.
              ILATguy = EA__s.maxi
           END
        ENDCASE

        MLTbinMin  = EA__s.minm*15.
        MLTbinMax  = EA__s.maxm*15.

        ILATbinMin = EA__s.mini
        ILATbinMax = EA__s.maxi
     END
  ENDCASE

  ;;Where MLT rows begin and end
  mltrowboundaries = WHERE((ILATbinMin[1:-1] - ILATbinMin[0:-2]) GT 0)
  nRows            = N_ELEMENTS(mltrowboundaries)+1

  ;;Indices for row beginning/ending
  rowstartstop     = [[0,mltrowboundaries+1],[mltrowboundaries,N_ELEMENTS(MLTbinMin)-1]]

  IF KEYWORD_SET(ultra_verbose) THEN BEGIN
     FOR k=0,nRows-1 DO BEGIN 
        PRINT,FORMAT='("Row ",I0," (",I0," bins)")', $
              k+1, $
              (rowstartstop[k,1]-rowstartstop[k,0]+1)
        PRINT,"MLT  : "
        PRINT,FORMAT='(10(F7.2,:,", "))',MLTguy[rowstartstop[k,0]:rowstartstop[k,1]] 
        PRINT,"ILAT : "
        PRINT,FORMAT='(10(F5.2,:,", "))',ILATguy[rowstartstop[k,0]:rowstartstop[k,1]] 
        PRINT,"" 
     ENDFOR
  ENDIF


  ;;So what exactly is masked here?
  ;; masked_i = WHERE(masked,nMasked)
  ;; nMasked = N_ELEMENTS(masked_i)
  
  masked           = MAKE_ARRAY(N_ELEMENTS(MLTbinMin),VALUE=0,/BYTE)
  nMasked          = 3
  masked_i         = INDGEN(nMasked)+5
  masked[masked_i] = 255B

  ;;If we weren't given measurements, assume a Gaussian
  meas         = N_ELEMENTS(data) GT 0 ? data : MAKE_ARRAY(N_ELEMENTS(masked),VALUE=1.0,/FLOAT)

  ;;Estimates based on our Gaussian kernel assumption
  ests         = MAKE_ARRAY(N_ELEMENTS(masked),VALUE=0.0,/FLOAT)
  nEsts        = 0
  noEstimate_i = !NULL

  ;;We treat the bin width in each dimension as one standard deviation
  IF N_ELEMENTS(multVal) EQ 0 THEN multVal = 0.5

  sX   = GEO_DIST(MLTbinMin               ,(ILATbinMax+ILATbinMin)/2., $ ;longitudinal distance
                  MLTbinMax               ,(ILATbinMax+ILATbinMin)/2.)*multVal

  sY   = GEO_DIST((MLTbinMax+MLTbinMin)/2.,ILATbinMin               , $ ;latitudinal distance
                  (MLTbinMax+MLTbinMin)/2.,ILATbinMax               )*multVal

  IF nMasked GT 0 THEN BEGIN
     IF KEYWORD_SET(verbose) THEN PRINT,'Calculating masked stuff based on neighbors ...'

     FOR k=0,nMasked-1 DO BEGIN

        cur_i = masked_i[k]
        row = VALUE_LOCATE(rowstartstop[*,0],cur_i)

        ;;Handle row neighbors
        CASE cur_i OF
           rowstartstop[row,0]: BEGIN ;beginning of the row
              neighbor_i = [rowstartstop[row,1],cur_i+1]
              lBinEdge   = [1,0]
              rBinEdge   = [0,0]
           END
           rowstartstop[row,1]: BEGIN ;end of the row
              neighbor_i = [cur_i-1,rowstartstop[row,0]]
              lBinEdge   = [0,0]
              rBinEdge   = [0,1]
           END
           ELSE:                BEGIN ;neither
              neighbor_i = [cur_i-1,cur_i+1]
              lBinEdge   = [0,0]
              rBinEdge   = [0,0]
           END
        ENDCASE
        ;;First two are always side neighbors
        ;; sideNeighbors_i = neighbor_i

        ;;Handle column neighbors
        CASE row OF
           0:       BEGIN       ;First row
              uuRowInds = [rowstartstop[row+2,0]:rowstartstop[row+2,1]]
              upRowInds = [rowstartstop[row+1,0]:rowstartstop[row+1,1]]
              loRowInds = !NULL
              llRowInds = !NULL
           END
           1:       BEGIN
              uuRowInds = [rowstartstop[row+2,0]:rowstartstop[row+2,1]]
              upRowInds = [rowstartstop[row+1,0]:rowstartstop[row+1,1]]
              loRowInds = [rowstartstop[row-1,0]:rowstartstop[row-1,1]]
              llRowInds = !NULL
           END
           nRows-1: BEGIN       ;Last row
              uuRowInds = !NULL
              upRowInds = !NULL
              loRowInds = [rowstartstop[row-1,0]:rowstartstop[row-1,1]]
              llRowInds = [rowstartstop[row-2,0]:rowstartstop[row-2,1]]
           END
           nRows-2: BEGIN       ;Second-to-last row
              uuRowInds = !NULL
              upRowInds = [rowstartstop[row+1,0]:rowstartstop[row+1,1]]
              loRowInds = [rowstartstop[row-1,0]:rowstartstop[row-1,1]]
              llRowInds = [rowstartstop[row-2,0]:rowstartstop[row-2,1]]
           END
           ELSE:    BEGIN       ;Otherwise
              uuRowInds = [rowstartstop[row+2,0]:rowstartstop[row+2,1]]
              upRowInds = [rowstartstop[row+1,0]:rowstartstop[row+1,1]]
              loRowInds = [rowstartstop[row-1,0]:rowstartstop[row-1,1]]
              llRowInds = [rowstartstop[row-2,0]:rowstartstop[row-2,1]]
           END
        ENDCASE

        ;;Handle top row, if exists
        IF N_ELEMENTS(upRowInds) NE 0 THEN BEGIN
           ;;No more than three neighbors
           upDist      = GET_N_MAXIMA_IN_ARRAY(ABS(MLTguy[upRowInds]-MLTguy[cur_i]), $
                                               /DO_MINIMA, $
                                               N=(3 < N_ELEMENTS(upRowInds)), $
                                               OUT_I=upNeighbor_ii)
           neighbor_i  = [neighbor_i,upRowInds[upNeighbor_ii]]
        ENDIF

        ;;Handle bot row, if exists
        IF N_ELEMENTS(loRowInds) NE 0 THEN BEGIN
           loDist      = GET_N_MAXIMA_IN_ARRAY(ABS(MLTguy[loRowInds]-MLTguy[cur_i]), $
                                               /DO_MINIMA, $
                                               N=(3 < N_ELEMENTS(loRowInds)), $
                                               OUT_I=loNeighbor_ii)
           neighbor_i  = [neighbor_i,loRowInds[loNeighbor_ii]]
        ENDIF

        ;;For-real neighbors
        ;; neighbor_i     = CGSETINTERSECTION(neighbor_i,WHERE(~masked),NORESULT=-1,COUNT=nNeigh)
        nNeigh = N_ELEMENTS(neighbor_i)
        IF nNeigh GT 0 THEN BEGIN

           
           
           ;;Ultra-verbose output
           IF KEYWORD_SET(ultra_verbose) THEN BEGIN
              PRINT,FORMAT='(A0,T10,": ",F0.2,T20,F0.2)', $
                    "You", $
                    MLTguy[cur_i], $
                    ILATguy[cur_i]
           ENDIF

           tmpVal = 0.
           FOR kk=0,nNeigh-1 DO BEGIN

              is_sideNeighbor = (kk EQ 0) OR (kk EQ 1)

              tmpN_i    = neighbor_i[kk]

              sorryBro  = ( (WHERE(tmpN_i EQ masked_i))[0] NE -1 )

              tmpDeltaX = GEO_DIST(MLTguy[cur_i ],ILATguy[cur_i ], $  ;longitudinal distance
                                   MLTguy[tmpN_i],ILATguy[cur_i ])

              tmpDeltaY = GEO_DIST(MLTguy[cur_i ],ILATguy[cur_i ], $  ;latitudinal distance
                                   MLTguy[cur_i ],ILATguy[tmpN_i])
                                   
              ;;x integration bounds

              tmpNMLTguy = MLTguy[tmpN_i]
              IntegBinMinX = GEO_DIST(MLTbinMin[cur_i ],ILATguy[cur_i], $ ;Minimum longitudinal bound for integration
                                      MLTguy   [tmpN_i],ILATguy[cur_i]) * ( SIN(!DTOR * (MLTbinMin[cur_i ] - tmpNMLTguy)) LT 0 ? -1 : 1)
              IntegBinMaxX = GEO_DIST(MLTbinMax[cur_i ],ILATguy[cur_i], $ ;Maximum longitudinal bound for integration
                                      MLTguy   [tmpN_i],ILATguy[cur_i]) * ( SIN(!DTOR * (MLTbinMax[cur_i ] - tmpNMLTguy)) LT 0 ? -1 : 1)

              ;;y integration bounds
              IntegBinMinY = GEO_DIST(MLTguy[cur_i],ILATbinMin[cur_i ], $ ;Minimum latitudinal bound for integration
                                      MLTguy[cur_i],ILATguy   [tmpN_i]) * ( SIN(!DTOR * (ILATbinMin[cur_i ] - ILATguy[tmpN_i])) LT 0 ? -1 : 1)
              IntegBinMaxY = GEO_DIST(MLTguy[cur_i],ILATbinMax[cur_i ], $ ;Maximum latitudinal bound for integration
                                      MLTguy[cur_i],ILATguy   [tmpN_i]) * ( SIN(!DTOR * (ILATbinMax[cur_i ] - ILATguy[tmpN_i])) LT 0 ? -1 : 1)

              IF IntegBinMinY GT IntegBinMaxY THEN BEGIN
                 junk = IntegBinMinY
                 IntegBinMinY = IntegBinMaxY
                 IntegBigMaxY = junk
              ENDIF

              ;;Make a 2D Gaussian, get a val              
              tmpVal += ( meas[tmpN_i] * $
                          GAUSS2D(tmpDeltaX, $
                                  tmpDeltaY, $
                                  sX[tmpN_i], $
                                  sY[tmpN_i], $
                                  /INTEGRAL, $
                                  INTEG_XLIM=[IntegBinMinX,IntegBinMaxX], $
                                  INTEG_YLIM=[IntegBinMinY,IntegBinMaxY], $
                                  INTEG_NPTS=96))
              ;; PRINT,tmpVal
              ;;Why can't you shut up?
              IF KEYWORD_SET(ultra_verbose) THEN BEGIN
                 tmpDeltaR = GEO_DIST(MLTguy[cur_i ],ILATguy[cur_i ], $ ;total distance
                                      tmpNMLTguy,ILATguy[tmpN_i])
                                   
                 PRINT,FORMAT='(A0,T10,": ",F0.2,T20,F0.2,T30,A0)', $
                       "Nabor " + STRCOMPRESS(kk,/REMOVE_ALL) + ": ", $
                       tmpNMLTguy, $
                       ILATguy[tmpN_i], $
                       sorryBro ? "Masked!!" : STRCOMPRESS(tmpDeltaR,/REMOVE_ALL)
              ENDIF

           ENDFOR
           ests[cur_i] = tmpVal
           PRINT,tmpVal

           IF KEYWORD_SET(ultra_verbose) THEN BEGIN
              PRINT,''
           ENDIF

        ENDIF ELSE BEGIN
           noEstimate_i = [noEstimate_i,cur_i]
        ENDELSE

     ENDFOR
  ENDIF

  ;; RETURN,ests

END
