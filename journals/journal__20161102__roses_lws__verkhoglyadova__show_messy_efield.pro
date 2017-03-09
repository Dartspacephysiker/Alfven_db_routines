;2016/11/02
;;I need to show all of the issues
PRO JOURNAL__20161102__ROSES_LWS__VERKHOGLYADOVA__SHOW_MESSY_EFIELD, $
   SAVE_PNGS=save_pngs

  COMPILE_OPT idl2,strictarrsubs

  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbtime,CORRECT_FLUXES=0,/DO_NOT_MAP_ANYTHING

  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY

  t197 = STR_TO_TIME('1997-01-01/00:00:00.000')
  t297 = STR_TO_TIME('1997-12-31/23:59:59.999')

  t198 = STR_TO_TIME('1998-01-01/00:00:00.000')
  t298 = STR_TO_TIME('1998-12-31/23:59:59.999')

  t199 = STR_TO_TIME('1999-01-01/00:00:00.000')
  t299 = STR_TO_TIME('1999-11-02/23:59:59.999')

  t1bad = STR_TO_TIME('1999-11-03/00:00:00.000')
  t2bad = STR_TO_TIME('2000-03-31/23:59:59.999')

  t1Arr = [t197,t198,t199,t1bad]
  t2Arr = [t297,t298,t299,t2bad]

  outStrArr = ['1997','1998','1999--OK','1999--BAD']

  outNiceStrArr = ['1997','1998','Jan to Oct 1999, inclusive','Nov 1999 to March 2000, inclusive']

  nLoops   = N_ELEMENTS(t1Arr)

  binSize  = 0.1
  minX     = 1
  maxX     = 3.5

  FOR i=0,nLoops DO BEGIN
     outStr = outStrArr[i]

     inds   = WHERE(cdbTime GE t1Arr[i] AND cdbTime LE t2Arr[i],nHere)

     outFile = 'Maximus--NOT_despun--delta_E_for_'+outStr+'.png'
     IF KEYWORD_SET(save_pngs) THEN PRINT,'Saving to ' + outFile + ' ...'
     CGHISTOPLOT,ALOG10(ABS(maximus.delta_e[inds])), $
                 TITLE="|!4d!XE|, " + outNiceStrArr[i] + ' (' + STRCOMPRESS(nHere,/REMOVE_ALL) + ' obs)', $
                 MININPUT=minX, $
                 MAXINPUT=maxX, $
                 /FREQUENCY, $
                 DATACOLORNAME='black', $
                 /FILLPOLYGON, $
                 POLYCOLOR='gray', $
                 OUTPUT=KEYWORD_SET(save_pngs) ? plotDir+outFile : !NULL, $
                 BINSIZE=binSize
                 ;; BINSIZE=binSize, $
                 ;; MIN_VALUE=0, $
                 ;; MAX_VALUE=maxCount

     IF ~KEYWORD_SET(save_pngs) THEN STOP

  ENDFOR
END
