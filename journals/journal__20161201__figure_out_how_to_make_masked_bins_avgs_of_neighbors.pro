;;12/01/16
PRO JOURNAL__20161201__FIGURE_OUT_HOW_TO_MAKE_MASKED_BINS_AVGS_OF_NEIGHBORS, $
   BINCENTER=binC, $
   BINLEFTLOWER=binLL, $
   BINRIGHTUPPER=binRU, $
   NEW_MASKED=new_masked, $
   VERBOSE=verbose, $
   ULTRA_VERBOSE=ultra_verbose

  COMPILE_OPT IDL2

  LOAD_EQUAL_AREA_BINNING_STRUCT

  @common__ea_binning.pro

  binType                           = -1
  IF KEYWORD_SET(binC ) THEN binType = 0
  IF KEYWORD_SET(binLL) THEN binType = 1
  IF KEYWORD_SET(binRU) THEN binType = 2

  IF binType EQ -1 THEN BEGIN
     IF KEYWORD_SET(verbose) THEN PRINT,"Default: bin center"
     binType = 0
  ENDIF

  CASE binType OF
     0: BEGIN
        MLTguy  = ((EA__s.maxm+EA__s.minm)/2.)
        ILATguy = ((EA__s.maxi+EA__s.mini)/2.)
     END
     1: BEGIN
        MLTguy  = EA__s.minm
        ILATguy = EA__s.mini
     END
     2: BEGIN
        MLTguy  = EA__s.maxm
        ILATguy = EA__s.maxi
     END
  ENDCASE

  ;;Where MLT rows begin and end
  mltrowboundaries = WHERE((EA__s.mini[1:-1] - EA__s.mini[0:-2]) GT 0)
  nRows            = N_ELEMENTS(mltrowboundaries)+1

  ;;Indices for row beginning/ending
  rowstartstop     = [[0,mltrowboundaries+1],[mltrowboundaries,N_ELEMENTS(EA__s.minm)-1]]

  IF KEYWORD_SET(ultra_verbose) THEN BEGIN
     FOR k=0,nRows-1 DO BEGIN 
        PRINT,FORMAT='("Row ",I0," (",I0," bins)")', $
              k+1, $
              (rowstartstop[k,1]-rowstartstop[k,0]+1)
        PRINT,"MLT  : "
        PRINT,FORMAT='(10(F5.2,:,", "))',MLTguy[rowstartstop[k,0]:rowstartstop[k,1]] 
        PRINT,"ILAT : "
        PRINT,FORMAT='(10(F5.2,:,", "))',ILATguy[rowstartstop[k,0]:rowstartstop[k,1]] 
        PRINT,"" 
     ENDFOR
  ENDIF


  ;; masked_i = WHERE(masked,nMasked)
  ;; nMasked = N_ELEMENTS(masked_i)
  
  masked   = MAKE_ARRAY(N_ELEMENTS(EA__s.minM),VALUE=0,/BYTE)
  nMasked  = 3
  masked_i = INDGEN(nMasked)+5
  masked[masked_i] = 255B

  IF nMasked GT 0 THEN BEGIN
     IF KEYWORD_SET(verbose) THEN PRINT,'Calculating masked stuff based on neighbors ...'

     FOR k=0,nMasked-1 DO BEGIN

     cur_i = masked_i[k]
     row = VALUE_LOCATE(rowstartstop[*,0],cur_i)

     ;;Handle row neighbors
     CASE cur_i OF
        rowstartstop[row,0]: BEGIN ;beginning of the row
           neighbor_i = [rowstartstop[row,1],cur_i+1]
        END
        rowstartstop[row,1]: BEGIN ;end of the row
           neighbor_i = [cur_i-1,rowstartstop[row,0]]
        END
        ELSE:                BEGIN ;neither
           neighbor_i = [cur_i-1,cur_i+1]
        END
     ENDCASE

     ;;Handle column neighbors
     CASE row OF
        0:       BEGIN ;First row
           upRowInds = [rowstartstop[row+1,0]:rowstartstop[row+1,1]]
           loRowInds = !NULL
        END
        nRows-1: BEGIN ;Last row
           upRowInds = !NULL
           loRowInds = [rowstartstop[row-1,0]:rowstartstop[row-1,1]]
        END
        ELSE:    BEGIN ;Otherwise
           upRowInds = [rowstartstop[row+1,0]:rowstartstop[row+1,1]]
           loRowInds = [rowstartstop[row-1,0]:rowstartstop[row-1,1]]
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
           FOR kk=0,nNeigh-1 DO BEGIN
              PRINT,FORMAT='(A0,T10,": ",F0.2,T20,F0.2,T30,A0)', $
                    "Nabor " + STRCOMPRESS(kk,/REMOVE_ALL) + ": ", $
                    MLTguy[neighbor_i[kk]], $
                    ILATguy[neighbor_i[kk]], $
                    ( (WHERE(neighbor_i[kk] EQ masked_i))[0] EQ -1 ) ? '' : "Masked!!"
           ENDFOR

           PRINT,''
        ENDIF

     ENDIF

     ENDFOR
  ENDIF

  

END
