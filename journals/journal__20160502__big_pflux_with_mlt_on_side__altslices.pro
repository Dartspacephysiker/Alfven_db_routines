;Let's do dat, because as Professor LaBelle said, we can probably do something more useful than show the size
; of the observed current
PRO JOURNAL__20160502__BIG_PFLUX_WITH_MLT_ON_SIDE__ALTSLICES

  year_and_season_mode = 1
  n_years = 4
  start_year = 1996
  years                = LINDGEN(n_years)+start_year
  yearStr              = STRING(FORMAT='(I0,"-01-01/00:00:00")',years)
  yearUTC              = DOUBLE(STR_TO_TIME(yearStr))
  tBeforeEpoch         = 0 
  tAfterEpoch          = LONG64(365)*24

  restrict_poyntRange  = [5,100000]

  dst_yRange           = [-200,50]
  dst_lineTransp       = 60
  close_window_after_save = 1

  altitudeRanges       = [[3180,4180], $
                          [2180,3180], $
                          [1180,2180], $
                          [0340,1180]] 
  nAltRanges           = N_ELEMENTS(altitudeRanges[0,*])

  ;;************************************************************
  ;;to be outputted
  savePlotPref      = '20160502--pflux_GE_'+ STRCOMPRESS(restrict_poyntRange[0],/REMOVE_ALL)
  ;; scOutPref         = '20160104--Largestorms_combinee--scatterplots--'  ;scatter plots, N and S Hemi

  rmDupes           = 0

  nPlotsPerWindow   = 4
  ;; colors            = ['red','blue','green','orange']
  colors            = ['red','blue','green','purple']

  ;inds are 
  ;;  0 ORBIT
  ;;  1 ALFVENIC
  ;;  2 TIME
  ;;  3 ALT
  ;;  4 MLT
  ;;  5 ILAT
  ;; maxInd            = 6
  ;; yRange_maxInd     = [-200,200]
  ;; yTitle_maxInd     = 'Current density ($\muA/m^2$)'
  maxInd            = 4
  ;; yRange_maxInd     = [54,86]
  yRange_maxInd     = [0,24]
  yTitle_maxInd     = 'MLT'

  symTransparency   = 93
  ;; FOR i = 0, N_ELEMENTS(q1_st)-1,nPlotsPerWindow DO BEGIN
  ;; FOR i = 0, N_ELEMENTS(q1_st)-1,nPlotsPerWindow DO BEGIN


  FOR alt_i = 0,nAltRanges-1 DO BEGIN

     altRange       = altitudeRanges[*,alt_i]

     i = 0
     ;; FOR i = 0, 3,nPlotsPerWindow DO BEGIN


        iFirst         = i
        iLast          = i + nPlotsPerWindow - 1
        ;; scOutFilePref  = STRING(FORMAT='(A0,"--",A0,"--",I0,"-",I0,".png")',scOutPref,yTitle_maxInd,iFirst,iLast)
        savePlotFile   = STRING(FORMAT='(A0,"--",A0,"--",I0,"-",I0,"--altRange_",I0,"-",I0,".png")', $
                                savePlotPref, $
                                yTitle_maxInd, $
                                yearStr[iFirst], $
                                yearStr[iLast], $
                                altRange[0], $
                                altRange[1])
        
        STACKPLOTS_STORMS_ALFVENDBQUANTITIES_OVERLAID, $
           yearUTC, $
           ;; q1_utc[iFirst:iLast], $
           ;; STORMTYPE=1, $
           ;; EPOCHINDS=q1_st[iFirst:iLast], $
           /USE_DARTDB_START_ENDDATE, $
           TBEFOREEPOCH=tBeforeEpoch, $
           TAFTEREPOCH=tAfterEpoch, $
           MAXIND=maxInd, $
           YRANGE_MAXIND=yRange_maxInd, $
           YTITLE_MAXIND=yTitle_maxInd, $
           GEOMAG_YRANGE=dst_yRange, $
           GEOMAG_LINETRANSP=dst_lineTransp, $
           REMOVE_DUPES=rmDupes, $
           ;; RETURNED_NEV_TBINS_AND_HIST=stormtime_returned_tbins_and_nevhist, $
           /SAVEPLOT, $
           SAVEPNAME=savePlotFile, $
           ;; EPOCHPLOT_COLORNAMES=colors, $
           CLOSE_WINDOW_AFTER_SAVE=close_window_after_save, $
           SYMTRANSPARENCY=symTransparency, $
           ;; /DO_SCATTERPLOTS, $
           ;; SCATTEROUTPREFIX=scOutFilePref, $
           /SHOW_DATA_AVAILABILITY, $
           /JUST_ONE_LABEL, $
           /OVERPLOT_ALFVENDBQUANTITY, $
           YEAR_AND_SEASON_MODE=year_and_season_mode, $
           RESTRICT_POYNTRANGE=restrict_poyntRange, $
           RESTRICT_ALTRANGE=altRange

     ;; ENDFOR

  ENDFOR
END
