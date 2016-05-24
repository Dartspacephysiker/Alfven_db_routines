;2016/04/13 Kristina Lynch rightly pointed out that there could have been a dayside sampling bias for FAST, and maybe that's why
;we observe strange Poynting flux distributions. I highly doubt it, but let's see.

PRO JOURNAL__20160503__PLOT_REDUCED_DISTS_OF_NEVENTS_W_PFLUX_GE_0_05MW_PER_M2_FOR_ALT_SLICES

  hemi                     = 'NORTH'
  pFluxMin                 = 0.05

  inDir                    = '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'
  inFilePref               = 'polarplots_May_3_16--NORTH--avg'
  inFileSuff               = '--pFlux_GE_'+STRING(FORMAT='(G0.2)',pFluxMin)+'NO_IMF_CONSID.dat'

  SET_PLOT_DIR,outDir,/FOR_ALFVENDB,/ADD_TODAY
  outFilePref              = GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + "--pFlux_GE_" + $
                             STRING(FORMAT='(G0.2)',pFluxMin) + "--reduced_MLT_dists"


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;For these alt ranges (500-km delta)
  ;;data ranges, in order of N Events, tHistDenom, and NEvPerMin
  dataRanges               = [[0,250], $
                              [0,3500], $
                              [0,0.5]]

  altRange                 = [[0,4175], $
                              [0340,0680], $
                              [0680,1180], $
                              [1180,1680], $
                              [1680,2180], $
                              [2180,2680], $
                              [2680,3180], $
                              [3180,3680], $
                              [3680,4180]]

  ;; altRange                    = [4000,4175]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;For these alt ranges (1000-km delta)
  ;;data ranges, in order of N Events, tHistDenom, and NEvPerMin
  ;; dataRanges               = [[0,400], $
  ;;                             [000,5000], $
  ;;                             [0,0.2]]

  ;; altRange                 = [[340,1180], $
  ;;                             [1180,2180], $
  ;;                             [2180,3180], $
  ;;                             [3180,4180]]

  nAltRanges               = N_ELEMENTS(altRange[0,*])

  winDimensions            = [1580,600]
  FOR i=0,nAltRanges-1 DO BEGIN

     ;;set up output strings
     plotTitle             = STRING(FORMAT='(I0,"-",I0," km")',altRange[0,i],altRange[1,i])
     altStr                = STRING(FORMAT='("--",I0,"-",I0,"km")', $
                                    altRange[0,i], $
                                    altRange[1,i])

     curPref                = outFilePref + '--'+altStr

     ;;restore file, loop through the three that should be present
     ;;0--tHistDenominator
     ;;1--nEventsPerMin
     ;;2--nEvents
     restore,inDir+inFilePref+altStr+inFileSuff
     nPlots                = N_ELEMENTS(dataNameArr)-1

     ;;handle calculation of reduced dists here since n events per min can't just be summed
     reduced_tHist         = (TOTAL(h2dstrarr[0].data,2))[0:-2]
     reduced_nEvents       = (TOTAL(h2dstrarr[2].data,2))[0:-2]
     reduced_nEvPerMin     = reduced_nEvents/reduced_tHist

     ;;rearrange, putting list in same order as h2dStrArr
     h2dStrArr             = [h2dStrArr[2],h2dStrArr[0],h2dStrArr[1],h2dStrArr[3]]
     dataNameArr           = [dataNameArr[2],dataNameArr[0],dataNameArr[1],dataNameArr[3]]
     reduced_MLT_distList  = LIST(reduced_nEvents, $
                                  reduced_tHist, $
                                  reduced_nEvPerMin)

     ;;Window?
     WINDOW_CUSTOM_SETUP,/MAKE_NEW, $
                         CURRENT_WINDOW=window, $
                         WINDOW_DIMENSIONS=winDimensions, $
                         SPACE_HORIZ_BETWEEN_COLS=0.08, $
                         MARGIN_LEFT=0.055, $
                         NPLOTCOLUMNS=nPlots, $
                         NPLOTROWS=1, $
                         ;; ROW_NAMES=h2dStrArr[0:nPlots-1].title, $
                         ;; COLUMN_NAMES=h2dStrArr[0:nPlots-1].title, $
                         SPACE__XTITLE=0.09, $
                         SPACE__WINTITLE=0.09, $
                         XTITLE='MLT', $
                         WINDOW_TITLE=STRING(FORMAT='(I0,"-",I0," km")', $
                                             altRange[0,i], $
                                             altRange[1,i])
                         


     masked_i              = WHERE(h2dStrArr[-1].data GT 250,/NULL,COMPLEMENT=notMasked_i)

     mlts                  = INDGEN((maxM-minM)/binM)*binM
     xRange                = [MIN(mlts),MAX(mlts)]
     FOR dat_i=0,nPlots-1 DO BEGIN
        ;;If logged, unlog
        IF h2dStrArr[dat_i].is_logged THEN BEGIN
           h2dStrArr[dat_i].data[notMasked_i] = 10.^(h2dStrArr[dat_i].data[notMasked_i])
           tempTitle       = h2dStrArr[dat_i].title
           h2dStrArr[dat_i].title = STRMID(tempTitle,4,STRLEN(tempTitle)-4)
        ENDIF

        ;;Mask the maskables
        ;; h2dStrArr[dat_i].data[masked_i] = 0

        ;;Reduce the distribution
        ;; MLT_dist           = (TOTAL(h2dstrarr[dat_i].data,2))[0:-2]
        
        MLT_dist           = reduced_MLT_distList[dat_i]

        ;;Plot it
        yRange             = dataRanges[*,dat_i]
        plot_temp          = PLOT(mlts, $
                                  MLT_dist, $
                                  XRANGE=xRange, $
                                  YRANGE=yRange, $
                                  XTICKINTERVAL=4, $
                                  ;; TITLE=plotTitle, $
                                  ;; XTITLE='MLT', $
                                  FONT_SIZE=15, $
                                  YTITLE=h2dStrArr[dat_i].title, $
                                  THICK=2, $
                                  POSITION=WINDOW_CUSTOM_NEXT_POS(), $
                                  /HISTOGRAM, $
                                  /CURRENT)

        ;;Save it
        ;; outFile            = outFilePref+altStr+'--'+dataNameArr[dat_i]+'.png'
        ;; PRINT,'Saving ' + outFile + '...'
        ;; plot_temp.save,outDir+outFile, $
        ;;    RESOLUTION=[800,800]

        ;;Close it
        ;; plot_temp.close

     ENDFOR

     ;;Save it
     outFile            = outFilePref+altStr+'--'+$
                          STRING(FORMAT='(3(A0,:,"--"))',dataNameArr[0:nPlots-1])+'.png'
     PRINT,'Saving ' + outFile + '...'
     window.save,outDir+outFile, $
        RESOLUTION=winDimensions
     
     ;;Close it
     window.close

  ENDFOR
END


