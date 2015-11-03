;2015/11/03
FUNCTION MAKE_EPOCHSLICE_HIST_STRUCT,yData, $
                                     BINSIZE=binsize, $
                                     MAXVAL=maxVal, $
                                     MINVAL=minVal, $
                                     DO_REVERSE_INDS=do_rev_inds

  IF N_ELEMENTS(yData) GT 0 THEN BEGIN
     hist         = HISTOGRAM(yData, $
                              BINSIZE=binsize, $
                              LOCATIONS=locs, $
                           MIN=minVal, $
                              MAX=maxVal, $
                              REVERSE_INDICES=ri)
  ENDIF

  es_hist_tmplt = {tmplt_es_hist, $
                   hist         : LIST(), $
                   min          : DOUBLE(0), $
                   max          : DOUBLE(0), $
                   binsize      : DOUBLE(0), $
                   ri           : LIST(), $
                   locs         : LIST()}
  
  
  IF N_ELEMENTS(minVal) GT 0 THEN es_hist_tmplt.min = minVal
  IF N_ELEMENTS(maxVal) GT 0 THEN es_hist_tmplt.max = maxVal
  IF N_ELEMENTS(binsize) GT 0 THEN es_hist_tmplt.binsize = binsize
  IF N_ELEMENTS(hist) GT 0 THEN es_hist_tmplt.hist.add,hist
  IF N_ELEMENTS(ri) GT 0 AND KEYWORD_SET(do_rev_inds) THEN es_hist_tmplt.ri.add,ri
  IF N_ELEMENTS(locs) GT 0 THEN es_hist_tmplt.locs.add,locs

  RETURN,es_hist_tmplt

END