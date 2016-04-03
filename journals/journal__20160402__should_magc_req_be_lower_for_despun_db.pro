;2016/04/02 (GC weekend)
;The question comes up: Should the threshold be lower since identification should probably be better?
PRO JOURNAL__20160402__SHOULD_MAGC_REQ_BE_LOWER_FOR_DESPUN_DB

  date               = '20160402'

  do_despun          = 0

  do_clean           = 0

  magLim             = 5
  magLimStr          = STRING(FORMAT='(I0)',magLim)

  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY
  plotDir            = plotDir+'magLim_'+magLimStr+'/'
  IF ~FILE_TEST(plotDir) THEN BEGIN
     PRINT,"Making dir " + plotDir + '...'
     SPAWN,'mkdir ' + plotDir
  ENDIF

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=do_despun
  print,tag_names(maximus)

  IF do_clean THEN BEGIN
     good_i          = GET_CHASTON_IND(maximus,MIN_MAGCURRENT=1,MAX_NEGMAGCURRENT=-1,HEMI='BOTH')
     maximus         = RESIZE_MAXIMUS(maximus,INDS=good_i)
     cleanStr = '--cleaned_DB'
     plotDir         = plotDir + 'cleaned_inds/'
     IF ~FILE_TEST(plotDir) THEN BEGIN
        PRINT,"Making dir " + plotDir + '...'
        SPAWN,'mkdir ' + plotDir
     ENDIF
     ENDIF ELSE BEGIN
        cleanStr = ''
     ENDELSE

  IF KEYWORD_SET(do_despun) THEN despunStr = '--despun' ELSE despunStr = ''


  inds_gt_magLim     = WHERE(    maximus.mag_current  GT  magLim)
  inds_0_magLim      = WHERE(    maximus.mag_current  LE  magLim AND maximus.mag_current GE 0)
  inds_lt_negmagLim  = WHERE(    maximus.mag_current  LT -magLim)
  inds_negmagLim_0   = WHERE(    maximus.mag_current  GE -magLim AND maximus.mag_current LE 0)
  inds_abs_gt_magLim = WHERE(ABS(maximus.mag_current) GT  magLim)
  inds_abs_le_magLim = WHERE(ABS(maximus.mag_current) LE  magLim)

  ;;get the inds
  cghistoplot,maximus.mag_current[inds_gt_magLim],TITLE='mag_current > '+magLimStr+' (signed)', $
              OUTPUT=plotDir+'magc_gt_'+magLimStr+''+cleanStr+despunStr+'--'+date+'.png'
  cghistoplot,maximus.mag_current[inds_0_magLim],TITLE='0 < mag_current < '+magLimStr+' (signed)', $
              OUTPUT=plotDir+'magc_0_'+magLimStr+''+cleanStr+despunStr+'--'+date+'.png',MININPUT=0,MAXINPUT=magLim
  cghistoplot,maximus.mag_current[inds_negmagLim_0],TITLE='-'+magLimStr+' < mag_current < 0 (signed)', $
              OUTPUT=plotDir+'magc_neg'+magLimStr+'_0'+cleanStr+despunStr+'--'+date+'.png',MININPUT=-magLim,MAXINPUT=0
  cghistoplot,maximus.mag_current[inds_lt_negmagLim],TITLE='mag_current < -'+magLimStr+' (signed)', $
              OUTPUT=plotDir+'magc_lt_neg'+magLimStr+''+cleanStr+despunStr+'--'+date+'.png'
  cghistoplot,maximus.mag_current[inds_abs_gt_magLim],TITLE='mag_current > '+magLimStr+' (absolute value)', $
              OUTPUT=plotDir+'magc_abs_gt_'+magLimStr+''+cleanStr+despunStr+'--'+date+'.png'
  cghistoplot,maximus.mag_current[inds_abs_le_magLim],TITLE='mag_current <= '+magLimStr+' (absolute value)', $
              OUTPUT=plotDir+'magc_abs_le_'+magLimStr+''+cleanStr+despunStr+'--'+date+'.png'

  ;;now zoomed in!
  cghistoplot,maximus.mag_current[inds_gt_magLim],TITLE='mag_current > '+magLimStr+' (signed)', $
              OUTPUT=plotDir+'magc_gt_'+magLimStr+'--zoomed'+cleanStr+despunStr+'--'+date+'.png',MAXINPUT=150
  cghistoplot,maximus.mag_current[inds_lt_negmagLim],TITLE='mag_current < -'+magLimStr+' (signed)', $
              OUTPUT=plotDir+'magc_lt_neg'+magLimStr+'--zoomed'+cleanStr+despunStr+'--'+date+'.png',MININPUT=-150
  cghistoplot,maximus.mag_current[inds_abs_gt_magLim],TITLE='mag_current > '+magLimStr+' (absolute value)', $
              OUTPUT=plotDir+'magc_abs_gt_'+magLimStr+'--zoomed'+cleanStr+despunStr+'--'+date+'.png',MININPUT=-150,MAXINPUT=150



;;;;;;;;;;;;;;;;;;;
;;Now delta_b plots
;;;;;;;;;;;;;;;;;;;

  cghistoplot,maximus.delta_b[inds_gt_magLim],TITLE='Delta_b for mag_current > '+magLimStr+' (signed)', $
              OUTPUT=plotDir+'delta_b_for_magc_gt_'+magLimStr+''+cleanStr+despunStr+'--'+date+'.png'
  cghistoplot,maximus.delta_b[inds_0_magLim],TITLE='Delta_b for 0 < mag_current < '+magLimStr+' (signed)', $
              OUTPUT=plotDir+'delta_b_for_magc_0_'+magLimStr+''+cleanStr+despunStr+'--'+date+'.png'
  cghistoplot,maximus.delta_b[inds_negmagLim_0],TITLE='Delta_b for -'+magLimStr+' < mag_current < 0 (signed)', $
              OUTPUT=plotDir+'delta_b_for_magc_neg'+magLimStr+'_0'+cleanStr+despunStr+'--'+date+'.png'
  cghistoplot,maximus.delta_b[inds_lt_negmagLim],TITLE='Delta_b for mag_current < -'+magLimStr+' (signed)', $
              OUTPUT=plotDir+'delta_b_for_magc_lt_neg'+magLimStr+''+cleanStr+despunStr+'--'+date+'.png'
  cghistoplot,maximus.delta_b[inds_abs_gt_magLim],TITLE='Delta_b for mag_current > '+magLimStr+' (absolute value)', $
              OUTPUT=plotDir+'delta_b_for_magc_abs_gt_'+magLimStr+''+cleanStr+despunStr+'--'+date+'.png'
  cghistoplot,maximus.delta_b[inds_abs_le_magLim],TITLE='Delta_b for mag_current <= '+magLimStr+' (absolute value)', $
              OUTPUT=plotDir+'delta_b_for_magc_abs_le_'+magLimStr+''+cleanStr+despunStr+'--'+date+'.png'

;;now zoomed in!
  cghistoplot,maximus.delta_b[inds_gt_magLim],TITLE='Delta_b for mag_current > '+magLimStr+' (signed)', $
              OUTPUT=plotDir+'delta_b_for_magc_gt_'+magLimStr+'--zoomed'+cleanStr+despunStr+'--'+date+'.png',MAXINPUT=100
  cghistoplot,maximus.delta_b[inds_0_magLim],TITLE='Delta_b for 0 < mag_current < '+magLimStr+' (signed)', $
              OUTPUT=plotDir+'delta_b_for_magc_0_'+magLimStr+'--zoomed'+cleanStr+despunStr+'--'+date+'.png',MAXINPUT=100
  cghistoplot,maximus.delta_b[inds_negmagLim_0],TITLE='Delta_b for -'+magLimStr+' < mag_current < 0 (signed)', $
              OUTPUT=plotDir+'delta_b_for_magc_neg'+magLimStr+'_0--zoomed'+cleanStr+despunStr+'--'+date+'.png',MAXINPUT=100
  cghistoplot,maximus.delta_b[inds_lt_negmagLim],TITLE='Delta_b for mag_current < -'+magLimStr+' (signed)', $
              OUTPUT=plotDir+'delta_b_for_magc_lt_neg'+magLimStr+'--zoomed'+cleanStr+despunStr+'--'+date+'.png',MAXINPUT=100
  cghistoplot,maximus.delta_b[inds_abs_gt_magLim],TITLE='Delta_b for mag_current > '+magLimStr+' (absolute value)', $
              OUTPUT=plotDir+'delta_b_for_magc_abs_gt_'+magLimStr+'--zoomed'+cleanStr+despunStr+'--'+date+'.png',MAXINPUT=100
  cghistoplot,maximus.delta_b[inds_abs_le_magLim],TITLE='Delta_b for mag_current <= '+magLimStr+' (absolute value)', $
              OUTPUT=plotDir+'delta_b_for_magc_abs_le_'+magLimStr+'--zoomed'+cleanStr+despunStr+'--'+date+'.png',MAXINPUT=100

END