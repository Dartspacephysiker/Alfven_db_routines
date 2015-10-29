;2015/10/29 Because the E-field instrument aboard FAST was degrading, the question arose:
;           Do we even want to include data from 2000? The answer seems to be 'no.' See
;           what you think.
;           In short, I am not convinced that there is anything especially wrong with 
;           the data from 2000 — especially based on the scatter plots. I think it's fine.
;           The thing killing y2k data seems to be the sample 
PRO JOURNAL_HOW_MANY_GOOD_ALFVEN_EVENTS_IN_2000

  load_maximus_and_cdbtime,maximus,cdbtime
  
  utc=str_to_time('2000-01-01/00:00:00')
  
  good_i = get_chaston_ind(maximus,'OMNI',/BOTH_HEMIS)
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;How many events in year 2000?
  PRINT,N_ELEMENTS(cgsetintersection(good_i,WHERE(cdbTime GE utc)))
  ; A whopping 9467 — chump change.

  ; If we include those with sample rates GE 32 Hz, we get 24888 events, or about 15000 more.
  PRINT,N_ELEMENTS(cgsetintersection(good_i,WHERE(cdbTime GE utc AND maximus.burst)))
  ; Of those, a whopping 1408 are burst data. Very few.
  
  PRINT,N_ELEMENTS(cgsetintersection(good_i,WHERE(cdbTime LT utc AND maximus.burst GT 0)))
  ; BEFORE 2000, there are 10275 events that are burst data.
  
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Now check out NaNs in delta_e
  N_ELEMENTS(WHERE(FINITE(maximus.delta_e) AND cdbTime GE utc AND (maximus.mag_current LE -10 OR maximus.mag_current GE 10)))
  ; 35170 events with finite delta_e and passing current screening
  
  N_ELEMENTS(WHERE(~FINITE(maximus.delta_e) AND cdbTime GE utc AND (maximus.mag_current LE -10 OR maximus.mag_current GE 10)))
  END
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;When are the NaNs happening?
  finite_i = WHERE(FINITE(maximus.delta_e)
  cghistoplot,cdbtime[WHERE(~FINITE(maximus.delta_e))]
  
  ;;Hmm... most of them are before the year 2000. 
  cgscatter2d,cdbtime[WHERE(FINITE(maximus.delta_e))],maximus.delta_e[WHERE(FINITE(maximus.delta_e))]
  
  plot=plot(cdbtime[WHERE(FINITE(maximus.delta_e))], $
            ALOG10(ABS(maximus.delta_e[WHERE(FINITE(maximus.delta_e))])), $
            TRANSPARENCY=95,/YLOG,SYMBOL='+')

END