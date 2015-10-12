;2015/04/07
;The purpose of this pro is to now take fastloc output that has been processed by combine_fastloc_intervals and to make a
;'denominator histogram', so to speak, so we know where events are actually happening. 
;This should be standardized so that these files don't get remade all the time.
;For the histogram, these things should only be divided up by altitude,mlt,and ilat.
;
;2015/05/01
;I originally thought that we should have a default delta_t=5 sec between data points in all fastloc* programs, so I hardcoded
;that here. I have since commented it out, and now just use the actual time between data points. If the time between points is
;longer than 10 seconds, I just treat it like a 10-second delta_t (see combine_fastloc_intervals.pro).

;So let's say you wanted to make a time histo for duskward IMF, with By>=5 nT. First get the
;indices file by running get_fastloc_inds__IMF_conds with keyword /MAKE_OUTINDSFILE, then provide
;those indices as the keyword FASTLOC_INDS here.

PRO make_fastloc_histo,FASTLOC_STRUCT=fastLoc,FASTLOC_TIMES=fastLoc_Times,FASTLOC_DELTA_T=fastloc_delta_t, $
                       OUTTIMEHISTO=outTimeHisto, FASTLOC_INDS=fastLoc_inds, $
                       MINMLT=minMLT,MAXMLT=maxMLT,BINMLT=binMLT, $
                       MINILAT=minILAT,MAXILAT=maxILAT,BINILAT=binILAT, $
                       MINALT=minAlt,MAXALT=maxAlt,BINALT=binAlt, $
                       FASTLOCFILE=fastLocFile,FASTLOCTIMEFILE=fastLocTimeFile, $
                       OUTFILEPREFIX=outFilePrefix,OUTFILESUFFIX=outFileSuffix, OUTDIR=outDir, $
                       OUTPUT_TEXTFILE=output_textFile

  ;avoid any trickery
  nFastLoc = N_ELEMENTS(fastLoc.orbit)
  nFastLoc_Times = N_ELEMENTS(fastLoc_Times)
  IF nFastLoc NE nFastLoc_Times THEN BEGIN
     PRINT,"Something is wrong. nFastLoc = " + strcompress(nFastLoc) + " while nFastLoc_Times = " + strcompress(nFastLoc_Times) + "."
     PRINT,"Fix it! In the meantime, we're quitting."
     RETURN
  ENDIF

  IF fastLoc_delta_t EQ !NULL THEN BEGIN
     IF fastLoc_Times EQ !NULL THEN fastLoc_Times = str_to_time(fastLoc.time)
     fastLoc_delta_t = shift(fastLoc_Times,-1)-fastLoc_Times
     save,fastLoc_Times,fastLoc_delta_t,FILENAME=fastLocDir+fastLocTimeFile+'_raw'
     fastLoc_delta_t[-1] = 10.0                             ;treat last element specially, since otherwise it is a huge negative number
     fastLoc_delta_t = ROUND(fastLoc_delta_t*8.0)/8.0 ;round to nearest eigth of a second
     fastLoc_delta_t(WHERE(fastLoc_delta_t GT 10.0)) = 10.0 ;many events with a large delta_t correspond to ends of intervals/orbits
     save,fastLoc_Times,fastLoc_delta_t,FILENAME=fastLocDir+fastLocTimeFile
  ENDIF

  ;Are we only using a user-supplied array of indices?
  IF KEYWORD_SET(fastLoc_inds) THEN BEGIN
     fastLoc={ORBIT:fastLoc.orbit(fastLoc_inds),$
                          TIME:fastLoc.time(fastLoc_inds),$
                          ALT:fastLoc.alt(fastLoc_inds),$
                          MLT:fastLoc.mlt(fastLoc_inds),$
                          ILAT:fastLoc.ilat(fastLoc_inds),$
                          FIELDS_MODE:fastLoc.FIELDS_MODE(fastLoc_inds),$
                          INTERVAL:fastLoc.INTERVAL(fastLoc_inds),$
                          INTERVAL_START:fastLoc.INTERVAL_START(fastLoc_inds),$
                          INTERVAL_STOP:fastLoc.INTERVAL_STOP(fastLoc_inds)$
             }

     fastLoc_Times = fastLoc_Times(fastLoc_inds)
     fastLoc_delta_t = fastLoc_delta_t(fastLoc_inds)
  ENDIF

  ;set up outfilename
  ;It's gotta be standardized!
  minOrb = MIN(fastLoc.orbit,MAX=maxOrb)
  fNameSansPref = STRING(format='(A0,I0,"-",I0,"-",G0.2,"_MLT--",I0,"-",I0,"-",G0.2,"_ILAT--orbs",I0,"-",I0,A0)', $
                         outFilePrefix,minMLT,maxMLT,binMLT,minILAT,maxILAT,binILAT,minOrb,maxOrb,outFileSuffix)
  outFileName=fNameSansPref + ".sav"

  ;are we doing a text file?
  IF KEYWORD_SET(output_textFile) THEN BEGIN
     textFileName='txtoutput/'+fNameSansPref + ".txt"
     
     OPENW,textLun,outDir+textFileName,/GET_LUN
     PRINTF,textLun,"Output from make_fastloc_histo"
     PRINTF,textLun,"The filename gives {min,max,binsize}{MLT,ILAT}--{min,max}Orb"
     PRINTF,textLun,FORMAT='("MLT",T10,"ILAT",T20,"Time in bin (minutes)")'
  ENDIF

  ;set up grid
  nXlines=(maxMLT-minMLT)/binMLT + 1
  nYlines=(maxILAT-minILAT)/binILAT + 1

  mlts=indgen(nXlines)*binMLT+minMLT
  ilats=indgen(nYlines)*binILAT+minILAT

  nMLT = N_ELEMENTS(mlts)
  nILAT = N_ELEMENTS(ilats)

  outTimeHisto = MAKE_ARRAY(nMLT,nILAT,/DOUBLE) ;how long FAST spends in each bin

  ;loop over MLTs and ILATs
  FOR j=0, nILAT-2 DO BEGIN 
     FOR i=0, nMLT-2 DO BEGIN 
        ;; tempNCounts = N_ELEMENTS(WHERE(fastLoc.MLT GE mlts[i] AND fastLoc.MLT LT mlts[i+1] AND $
        ;;                                fastLoc.ILAT GE ilats[j] AND fastLoc.ILAT LT ilats[j+1],/NULL))
        ;; tempBinTime = tempNCounts * delta_T
        tempInds = WHERE(fastLoc.MLT GE mlts[i] AND fastLoc.MLT LT mlts[i+1] AND $
                                       fastLoc.ILAT GE ilats[j] AND fastLoc.ILAT LT ilats[j+1],/NULL)
        IF tempInds NE !NULL THEN BEGIN
           tempBinTime = TOTAL(DOUBLE(fastLoc_delta_t(tempInds)))
           outTimeHisto[i,j] = tempBinTime

           IF KEYWORD_SET(output_textFile) THEN PRINTF,textLun,FORMAT='(F0.2,T10,F0.2,T20,F0.3)',mlts[i],ilats[j],DOUBLE(tempBinTime)/60.0
        ENDIF ELSE tempBinTime = DOUBLE(0.0)
     ENDFOR
  ENDFOR

  ;save the file
  IF NOT KEYWORD_SET(fastLoc_Inds) AND $
  NOT ((outFilePrefix EQ defOutFilePrefix) AND (outFileSuffix EQ defOutFileSuffix)) THEN BEGIN
     save,outTimeHisto,FILENAME=outDir+outFileName
     print,'Saving ' + outDir+outFileName + '...'
  ENDIF ELSE BEGIN
     print,'Not saving ' + outDir+outFileName+'...'
  ENDELSE

  IF KEYWORD_SET(output_textFile) THEN CLOSE,textLun
  
END