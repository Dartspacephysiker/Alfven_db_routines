;2016/05/04 To see what's goin' on a la Marvin Gaye
PRO PRINT_ORBIT_DETAILS_FROM_ORBSTRARR_LIST__OR__PLOT_I,to_be_examined,maximus, $
   ORBIT_DETAILS_FILENAME=orbit_details_filename, $
   ORBIT_DETAILS_HEADER=orbit_details_header, $
   ANCILLARY_DATAPROD=ancillary_dp, $
   ANCILLARY_DP_FORMAT=ancillary_dp_format, $
   ANCILLARY_DP_TITLE=ancillary_dp_title, $
   OUTDIR=outDir, $
   QUIET=quiet

  COMPILE_OPT idl2

  CASE SIZE(to_be_examined,/TYPE) OF
     11: BEGIN
        orbStrArr_list = to_be_examined
     END
     ELSE: BEGIN
        orbStrArr_list = SPLIT_IND_LIST_INTO_ORB_STRUCTARR_LIST(LIST(to_be_examined),maximus)
     END
  ENDCASE

  IF N_ELEMENTS(ancillary_dp_format) GT 0 THEN anc_dp_format = ancillary_dp_format ELSE anc_dp_format = 'I0'
  IF N_ELEMENTS(ancillary_dp_title)  GT 0 THEN anc_dp_title  = ancillary_dp_title  ELSE anc_dp_title  = ' '

  IF ~KEYWORD_SET(outDir) THEN SET_PLOT_DIR,outDir,/FOR_ALFVENDB,/ADD_TODAY
  IF KEYWORD_SET(orbit_details_header) THEN orbDetHeader = orbit_details_header ELSE orbDetHeader = GET_TODAY_STRING(/DO_YYYYMMDD_FMT)

  PRINT,'Saving orbit details to ' + outDir+orbit_details_filename + '...'
  OPENW,lun,outDir+orbit_details_filename,/GET_LUN
  PRINTF,lun,orbDetHeader
  PRINTF,lun,""
  PRINTF,lun,""
  IF KEYWORD_SET(ancillary_dp) THEN BEGIN
     PRINTF,lun,STRING(FORMAT='("Orbit",T8,"Time range",T61,"Latitude range",T80,"MLT range",T95,"N Obs",T103,A0)',anc_dp_title)
  ENDIF ELSE BEGIN
     PRINTF,lun,STRING(FORMAT='("Orbit",T8,"Time range",T61,"Latitude range",T80,"MLT range",T95,"N Obs",T103,A0)','')
  ENDELSE

  PRINTF,lun,STRING(FORMAT='("=====",T8,"==========",T61,"==============",T80,"=========",T95,"=====",T103,A0)','')
  PRINTF,lun,""
  FOR i=0,N_ELEMENTS(orbStrArr_list)-1 DO BEGIN
     PRINTF,lun,"(SEGMENT " + STRCOMPRESS(i,/REMOVE_ALL) + ')'
     PRINTF,lun,''
     FOR j = 0,N_ELEMENTS(orbStrArr_list[i])-1 DO BEGIN
        tmp_i   = orbStrArr_list[i,j].plot_i_list[0]
        lats    = maximus.ilat[tmp_i]
        lons    = maximus.mlt[tmp_i]
        minLat  = MIN(lats,MAX=maxLat)
        minLon  = MIN(lons,MAX=maxLon)
        minTime = maximus.time[tmp_i[0]]
        maxTime = maximus.time[tmp_i[-1]]

        IF N_ELEMENTS(ancillary_dp) GT 0 THEN BEGIN
           anc_dp = ancillary_dp[tmp_i]
        ENDIF ELSE BEGIN
           anc_dp = 0
        ENDELSE

        PRINTF,lun,STRING(FORMAT='(I0,T8,A0," - ",A0,T61,F0.2," - ",F0.2,T80,F0.2," - ",F0.2,T95,I0,T103,' + anc_dp_format + ')', $
                          orbStrArr_list[i,j].orbit, $
                          minTime, $
                          maxTime, $
                          minLat, $
                          maxLat, $
                          minLon, $
                          maxLon, $
                          orbStrArr_list[i,j].N, $
                          anc_dp[0])
        FOR anc_i=1,N_ELEMENTS(anc_dp)-1 DO PRINTF,lun,STRING(FORMAT='(T103,'+anc_dp_format+')',anc_dp[anc_i])
        PRINTF,lun,''
     ENDFOR
  ENDFOR
  IF ~KEYWORD_SET(quiet) THEN PRINT,"Closing " + orbit_details_filename
  CLOSE,lun
  FREE_LUN,lun

END