;;2016/04/05 A second test!
PRO JOURNAL__20160405__TEST_H2DPLOTTER_STEREOGRAPHIC__NUMTWO

  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,GOOD_I=good_i,/GET_GOOD_I

  plot_i            = CGSETINTERSECTION(good_i,WHERE(maximus.total_eflux_integ LT 0))

  inData            = ALOG10(ABS(maximus.total_eflux_integ[plot_i]))
  
  maskMin           = 5
  binM              = 1.5

  SIMPLE_H2DPLOTTER_STEREOGRAPHIC,inData, $
                                  PLOT_I=plot_i, $
                                  MASKMIN=maskMin, $
                                  MASKCOLOR=maskColor, $
                                  PLOT_ON_LOGSCALE=logScale, $
                                  UNLOG_LABELS=unlog_labels, $
                                  LABELFORMAT=labelFormat, $
                                  DO_MIDCB_LABEL=do_midCB_label, $
                                  MINMLT=minM,MAXMLT=maxM,BINM=binM, $
                                  SHIFTMLT=shiftM, $
                                  MINILAT=minI,MAXILAT=maxI,BINILAT=binI, $                                    
                                  WHOLECAP=wholeCap,MIDNIGHT=midnight, $
                                  PLOTTITLE=plotTitle, MIRROR=mirror, $
                                  SHOW_PLOT_INTEGRAL=show_plotIntegral, $
                                  DEBUG=debug, $
                                  LOGAVGPLOT=logAvgPlot, $
                                  MEDIANPLOT=medianPlot, $
                                  CURRENT=current, $
                                  POSITION=position, $
                                  NO_COLORBAR=no_colorbar, $
                                  CB_LIMITS=cb_limits, $
                                  CB_FORCE_OOBLOW=cb_force_ooblow, $
                                  CB_FORCE_OOBHIGH=cb_force_oobhigh, $
                                  OUT_H2D_DATA=h2dData, $
                                  _EXTRA=e

END