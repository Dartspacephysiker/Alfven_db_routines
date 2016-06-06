;;06/04/16
PRO CATEGORIZE_ALL_SPECTRA_NEAR_ALFVEN_EVENTS

  COMPILE_OPT IDL2

  LOAD_ALF_NEWELL_ESPEC_DB,!NULL,alf_i__good_eSpec,/DONT_LOAD_IN_MEMORY, $
                           NEWELLDBFILE=NewellDBFile, $
                           NEWELLDBDIR=NewellDBDir
  nToCheck                      = N_ELEMENTS(alf_i__good_eSpec)
  alf_i__good_eSpec             = !NULL
  eSpec                         = !NULL

  inFile                        = STRMID(NewellDBFile,0,STRPOS(newelldbfile,'TOTAL')) + $
                                  'all_good_alf_eSpec_i--' + $
                                  ;; 'all_good_alf_eSpec_i--killed_befs_afts--' + $
                                  STRMID(NewellDBFile,STRPOS(NewellDBFile,'Orbs_'),STRPOS(NewellDBFile,'2016')-STRPOS(NewellDBFile,'Orbs_')) + $
                                  ;; GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + $
                                  '20160604' + $
                                  '.sav'
  outFile                       = STRMID(NewellDBFile,0,STRPOS(newelldbfile,'TOTAL')) + $
                      'all_good_alf_eSpec_i--CATEGORIZED--' + $
                      ;; 'all_good_alf_eSpec_i--killed_befs_afts--CATEGORIZED--' + $
                      STRMID(NewellDBFile,STRPOS(NewellDBFile,'Orbs_'),STRPOS(NewellDBFile,'2016')-STRPOS(NewellDBFile,'Orbs_')) + $
                      GET_TODAY_STRING(/DO_YYYYMMDD_FMT) + '.sav'

  ;;Load up all specs
  LOAD_NEWELL_ESPEC_DB,eSpec,/DONT_LOAD_IN_MEMORY
  CONVERT_ESPEC_TO_STRICT_NEWELL_INTERPRETATION,eSpec,eSpec_interp,/HUGE_STRUCTURE,/VERBOSE
  ;; eSpec_times       = eSpec.x
  ;; nEspecTimes       = N_ELEMENTS(eSpec_times)

  m                    = eSpec_interp.mono
  b                    = eSpec_interp.broad
  d                    = eSpec_interp.diffuse

  eSpec_interp         = !NULL ;eSpec gets killed by CONVERT_ESPEC_TO_STRICT_NEWELL_INTERPRETATION

  ;;Need to get clean logic for later in the prog; otherwise the codes I use for indicating where monos and broads fail to pass the
  ;;test could mess with life
  PRINT,"Killing failcodes in arrays of spectral type identity so that logic is clean..."
  IF (WHERE(m GT 2,mKill))[0] NE -1 THEN BEGIN
     PRINT,FORMAT='("Killed monos  : ",I0)',mKill
     m[WHERE(m GT 2)]  = 0
  ENDIF
  IF (WHERE(b GT 2,bKill))[0] NE -1 THEN BEGIN
     PRINT,FORMAT='("Killed broads  : ",I0)',bKill
     b[WHERE(b GT 2)]  = 0
  ENDIF
  IF (WHERE(d GT 2,dKill))[0] NE -1 THEN BEGIN
     PRINT,FORMAT='("Killed diffuses  : ",I0)',dKill
     d[WHERE(d GT 2)]  = 0
  ENDIF

  ;;Load up that newfangled thing
  PRINT,'Restoring ' + inFile + '...'
  RESTORE,NewellDBDir+inFile

  ;;Purebreds
  pure_b               = MAKE_ARRAY(nToCheck,/BYTE,VALUE=0)
  pure_d               = MAKE_ARRAY(nToCheck,/BYTE,VALUE=0)
  pure_m               = MAKE_ARRAY(nToCheck,/BYTE,VALUE=0)

  ;;Muggles
  mix_bd               = MAKE_ARRAY(nToCheck,/BYTE,VALUE=0)
  mix_bm               = MAKE_ARRAY(nToCheck,/BYTE,VALUE=0)
  mix_dm               = MAKE_ARRAY(nToCheck,/BYTE,VALUE=0)

  ;;Paint horse
  mix_bdm              = MAKE_ARRAY(nToCheck,/BYTE,VALUE=0)

  ;;Anomalous
  anomal               = MAKE_ARRAY(nToCheck,/BYTE,VALUE=0)

  ;;What's the largest number I'm going to see?
  ;; biggest = 0
  ;; FOR i=0,nToCheck-1 DO BEGIN
  ;;    IF N_ELEMENTS(all_alf_eSpec_list__i[i]) GT biggest THEN BEGIN
  ;;       biggest = N_ELEMENTS(all_alf_eSpec_list__i[i])
  ;;       PRINT,"Biggest: " + STRCOMPRESS(biggest,/REMOVE_ALL)
  ;;       PRINT,"Index:   " + STRCOMPRESS(i,/REMOVE_ALL)
  ;;    ENDIF

  ;;    ;; IF ~(i MOD 1000) THEN PRINT,i

  ;; ENDFOR

  ;;Loop vars to get TIC-TOCing
  count                                     = 0
  nToCount                                  = 9999

  TIC
  FOR i=0,nToCheck-1 DO BEGIN
     IF count EQ 0 THEN BEGIN
        clock  = TIC("Clock_"+STRCOMPRESS(i,/REMOVE_ALL))
     ENDIF 

     tmpArr    = all_alf_eSpec_list__i[i]

     IF tmpArr[0] NE -1 THEN BEGIN
        

        tmpB      = b[tmpArr[0]]
        tmpM      = m[tmpArr[0]]
        tmpD      = d[tmpArr[0]]
        FOR j=1,N_ELEMENTS(tmpArr)-1 DO BEGIN
           tmpB   = tmpB + b[tmpArr[j]]            
           tmpM   = tmpM + m[tmpArr[j]]            
           tmpD   = tmpD + d[tmpArr[j]]            
        ENDFOR

        IF tmpB GT 0 THEN tmpB = 1
        IF tmpD GT 0 THEN tmpD = 1
        IF tmpM GT 0 THEN tmpM = 1

        CASE 1 OF
           tmpB AND tmpD AND tmpM: mix_bdm[i]  = 1
           tmpB AND tmpD:           mix_bd[i]  = 1
           tmpB AND tmpM:           mix_bm[i]  = 1
           tmpD AND tmpM:           mix_dm[i]  = 1
           tmpB:                    pure_b[i]  = 1
           tmpD:                    pure_d[i]  = 1
           tmpM:                    pure_m[i]  = 1
           ELSE:                    anomal[i]  = 1
        ENDCASE
     ENDIF

     IF count EQ nToCount THEN BEGIN
        TOC,clock
        count  = 0
     ENDIF ELSE count++

  ENDFOR

  PRINT,FORMAT='(A0,T10,": ",I0)',"pure_b",N_ELEMENTS(WHERE(pure_b,/NULL))  
  PRINT,FORMAT='(A0,T10,": ",I0)',"pure_d",N_ELEMENTS(WHERE(pure_d,/NULL))  
  PRINT,FORMAT='(A0,T10,": ",I0)',"pure_m",N_ELEMENTS(WHERE(pure_m,/NULL))  
  PRINT,FORMAT='(A0,T10,": ",I0)',"mix_bd",N_ELEMENTS(WHERE(mix_bd,/NULL))  
  PRINT,FORMAT='(A0,T10,": ",I0)',"mix_bm",N_ELEMENTS(WHERE(mix_bm,/NULL))  
  PRINT,FORMAT='(A0,T10,": ",I0)',"mix_dm",N_ELEMENTS(WHERE(mix_dm,/NULL))  
  PRINT,FORMAT='(A0,T10,": ",I0)',"mix_bdm",N_ELEMENTS(WHERE(mix_bdm,/NULL)) 
  PRINT,FORMAT='(A0,T10,": ",I0)',"anomal",N_ELEMENTS(WHERE(anomal,/NULL))  

  PRINT,'Saving all these categorized indices...'
  SAVE,pure_b,pure_d,pure_m, $
       mix_bd,mix_bm,mix_dm, $
       mix_bdm, $
       anomal, $
       FILENAME=NewellDBDir+outFile
END
