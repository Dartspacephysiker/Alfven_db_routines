;2015/08/26
;To be used in conjunction with get_data_availability_for_UTC_range
PRO PRINT_DATA_AVAILABILITY_FOR_UTC_RANGE,T1=t1,T2=t2, $
                                          ;; MAXIMUS=maximus,CDBTIME=cdbtime, $
                                          ;; OUT_INDS=inds, $
                                          UNIQ_ORBS=uniq_orbs,UNIQ_ORB_INDS=uniq_orb_inds, $
                                          INDS_ORBS=inds_orbs,TRANGES_ORBS=tranges_orbs, $
                                          TSPANS_ORBS=tspans_orbs,TSPANTOTAL=tSpanTotal, $
                                          PRETTY=pretty,SUMMARY=summary,EXTRA=extra,LUN=lun,DEBUG=debug

  IF ~KEYWORD_SET(lun) THEN lun = -1 ;stdout

  IF uniq_orb_inds[0] EQ -1 THEN BEGIN

     nUniq_orbs = 0
     IF KEYWORD_SET(debug) THEN BEGIN
        
        PRINTF,lun,FORMAT='("uniq_orb_inds",T14,":",T16,I0)',uniq_orb_inds
        PRINTF,lun,FORMAT='("uniq_orbs",T14,":",T16,I0)',uniq_orbs
        PRINTF,lun,FORMAT='("nUniq_orbs",T14,":",T16,I0)',nUniq_orbs
        
        PRINTF,lun,FORMAT='("inds_orbs",T14,":",T16,I0)',inds_orbs
        PRINTF,lun,FORMAT='("tRanges_orbs",T14,":",T16,I0)',tRanges_orbs
        PRINTF,lun,''
     ENDIF
  ENDIF ELSE BEGIN
     
     nUniq_orbs = N_ELEMENTS(uniq_orb_inds)

     ;; PRINTF,lun,''
     IF KEYWORD_SET(pretty) THEN BEGIN
        PRINTF,lun,'*****Data availability for UTC range*****'
        PRINTF,lun,''
     ENDIF

     IF KEYWORD_SET(t1) AND KEYWORD_SET(t2) THEN PRINTF,lun,'UTC Range: ' + TIME_TO_STR(t1) + ' through ' + TIME_TO_STR(t2)

     IF KEYWORD_SET(extra) THEN BEGIN
        PRINTF,lun,FORMAT='("uniq_orbs",T14,":", (T16, 5(I5,TR7)))',uniq_orbs
        PRINTF,lun,FORMAT='("uniq_orb_inds",T14,":", (T16, 5(I7,TR5)))',uniq_orb_inds
        PRINTF,lun,''
     ENDIF

     IF ~KEYWORD_SET(pretty) AND ~KEYWORD_SET(summary) THEN BEGIN
        PRINTF,lun,FORMAT='("Orbit",T8,"Tspan (h)",T19,"Start time",T41,"Stop time",T65,"Start index",T80,"Stop index")'
     ENDIF

     FOR i=0,nUniq_orbs-1 DO BEGIN
        orb = uniq_orbs[i]

        IF KEYWORD_SET(pretty) THEN PRINTF,lun,FORMAT='("*****Orbit",T14,I5,"*****")',orb

        IF inds_orbs[i,0] NE -1 THEN BEGIN
           IF KEYWORD_SET(pretty) THEN BEGIN
              PRINTF,lun,FORMAT='("Start index",T14,":",T16,I0)',inds_orbs[i,0]
              PRINTF,lun,FORMAT='("Stop index",T14,":",T16,I0)',inds_orbs[i,1]
              PRINTF,lun,''
              PRINTF,lun,FORMAT='("Start time",T14,":",T16,A0)',TIME_TO_STR(tranges_orbs[i,0])
              PRINTF,lun,FORMAT='("Stop time",T14,":",T16,A0)',TIME_TO_STR(tranges_orbs[i,1])
              PRINTF,lun,''
              PRINTF,lun,FORMAT='("Timespan",T14,":",T16,F0.2,TR3,"(hours)")',tspans_orbs[i]/3600.
           ENDIF ELSE BEGIN
              IF ~KEYWORD_SET(SUMMARY) THEN BEGIN
                 PRINTF,lun,FORMAT='(I5,T8,F0.2,T19,A0,T41,A0,T65,I7,T80,I7)',orb,tSpans_orbs[i]/3600., $
                        TIME_TO_STR(tranges_orbs[i,0]),TIME_TO_STR(tranges_orbs[i,1]), $
                        inds_orbs[i,0],inds_orbs[i,1]
              ENDIF
           ENDELSE
        ENDIF ELSE BEGIN
           PRINTF,lun,"This orbit is garbage"
        ENDELSE
     ENDFOR
     PRINTF,lun,''
     PRINTF,lun,FORMAT='("Total number of orbits",T38,":",T40,I0 )',nUniq_orbs
     PRINTF,lun,FORMAT='("Total interval lengths w/ data (hrs)",T38,":",T40,F0.2)',tSpanTotal/3600.
     IF KEYWORD_SET(t1) AND KEYWORD_SET(t2) THEN BEGIN
        PRINTF,lun,FORMAT='("Total time interval checked (hrs)",T38,":",T40,F0.2)',(t2-t1)/3600.
     ENDIF
     PRINTF,lun,''
  ENDELSE


END