PRO JOURNAL__20160502__HOW_OFTEN_DOES_FAST_COMPLETE_COVERAGE_OF_THE_EARTH


  LOAD_FASTLOC_AND_FASTLOC_TIMES,fastLoc,fastLoc_times

  theseOnes       =  [0:1000:5]

  t               = (fastLoc_times[theseOnes]-fastLoc_times[0])/3600.
  y               = fastLoc.mlt[theseOnes]

  plot            = PLOT(t,y, $
                         ;; LINESTYLE='', $
                         ;; SYMBOL='.', $
                         SYM_THICK=3.0)

  ;;Some disconcerting gaps...
  gaps = ((SHIFT(fastLoc_times,-1))[0:100000]-fastLoc_times[0:100000])/3600.
  print,gaps[WHERE(gaps GT 2)]

  

END