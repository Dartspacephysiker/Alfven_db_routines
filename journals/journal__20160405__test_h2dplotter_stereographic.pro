PRO JOURNAL__20160405__TEST_H2DPLOTTER_STEREOGRAPHIC

  ;;Just pick one
  restore,'../../ACE_FAST/temp/polarplots_Apr_4_16--NORTH--avg--maskMin5--OMNI--GSM--dawnward__0stable__0.00mindelay__ABS_byMin10.0__bzMax2.0.dat'

  inData=h2dStrArr[0].data

  plotTitle = h2dStrArr[0].title

  h2dMask = h2dStrArr[-1].data

  SIMPLE_H2DPLOTTER_STEREOGRAPHIC,inData, $
                                  IN_MLTS=in_mlts, $
                                  IN_ILATS=in_ilats, $
                                  IN_H2DMASK=h2dMask, $
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