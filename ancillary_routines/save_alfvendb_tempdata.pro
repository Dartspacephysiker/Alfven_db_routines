PRO SAVE_ALFVENDB_TEMPDATA,TEMPFILE=tempFile,H2DSTRARR=h2dStrArr,DATANAMEARR=dataNameArr,$
                           MAXM=maxM,MINM=minM,MAXI=maxI,MINI=minI, $
                           BINM=binM, $
                           SHIFTM=shiftM, $
                           BINI=binI, $
                           DO_LSHELL=do_lShell,REVERSE_LSHELL=reverse_lShell, $
                           MINL=minL,MAXL=maxL,BINL=binL,$
                           RAWDIR=rawDir,PARAMSTR=paramStr,$
                           CLOCKSTR=clockStr,PLOTMEDORAVG=plotMedOrAvg, $
                           STABLEIMF=stableIMF,HOYDIA=hoyDia,HEMI=hemi, $
                           QUIET=quiet, $
                           OUT_TEMPFILE=out_tempfile, $
                           LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1

  defTempDir='/SPENCEdata/Research/Cusp/ACE_FAST/temp/'

  IF ~KEYWORD_SET(tempFile) THEN tempFile = defTempDir + 'polarplots_'+paramStr+".dat"

  saveStr = 'save'
  IF N_ELEMENTS(h2dStrArr)      GT 0 THEN saveStr += ',h2dStrArr'
  IF N_ELEMENTS(dataNameArr)    GT 0 THEN saveStr += ',dataNameArr'
  IF N_ELEMENTS(maxM)           GT 0 THEN saveStr += ',maxM'
  IF N_ELEMENTS(minM)           GT 0 THEN saveStr += ',minM'
  IF N_ELEMENTS(maxI)           GT 0 THEN saveStr += ',maxI'
  IF N_ELEMENTS(minI)           GT 0 THEN saveStr += ',minI'
  IF N_ELEMENTS(binM)           GT 0 THEN saveStr += ',binM'
  IF N_ELEMENTS(shiftM)         GT 0 THEN saveStr += ',shiftM'
  IF N_ELEMENTS(binI)           GT 0 THEN saveStr += ',binI'
  IF N_ELEMENTS(do_lShell)      GT 0 THEN saveStr += ',do_lShell'
  IF N_ELEMENTS(reverse_lShell) GT 0 THEN saveStr += ',reverse_lShell'
  IF N_ELEMENTS(minL)           GT 0 THEN saveStr += ',minL'
  IF N_ELEMENTS(maxL)           GT 0 THEN saveStr += ',maxL'
  IF N_ELEMENTS(binL)           GT 0 THEN saveStr += ',binL'
  IF N_ELEMENTS(hemi)           GT 0 THEN saveStr += ',hemi'
  IF N_ELEMENTS(paramStr)       GT 0 THEN saveStr += ',paramStr'
  IF N_ELEMENTS(rawDir)         GT 0 THEN saveStr += ',rawDir'
  IF N_ELEMENTS(clockStr)       GT 0 THEN saveStr += ',clockStr'
  IF N_ELEMENTS(plotMedOrAvg)   GT 0 THEN saveStr += ',plotMedOrAvg'
  IF N_ELEMENTS(stableIMF)      GT 0 THEN saveStr += ',stableIMF'
  IF N_ELEMENTS(hoyDia)         GT 0 THEN saveStr += ',hoyDia'
  
  saveStr += ',FILENAME=tempFile'

  IF ~KEYWORD_SET(quiet) THEN PRINTF,lun,'Savestring: ' + saveStr
  void = EXECUTE(saveStr)

  out_tempFile                 = tempFile

  ;; save,h2dStrArr,dataNameArr,maxM,minM,maxI,minI,binM,binI,do_lShell,reverse_lShell,minL,maxL,binL,$
  ;;      rawDir,clockStr,plotMedOrAvg,stableIMF,hoyDia,hemi,paramStr$
  ;;      filename=tempFile
  

END