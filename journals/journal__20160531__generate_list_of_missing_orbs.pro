;;05/31/16
PRO JOURNAL__20160531__GENERATE_LIST_OF_MISSING_ORBS

  COMPILE_OPT IDL2

  RESTORE,'~/Research/database/FAST/dartdb/electron_Newell_db/alf_eSpec_2015122_db--MISSING_ORBS--Orbs_500-13680--20160531.sav'

  file1 = 'orbs_and_n_missing--20160531.txt' 
  file = 'orbs_to_redo--20160531.txt' 

  OPENW,lun,'~/Desktop/'+file,/GET_LUN 
  OPENW,missinglun,'~/Desktop/'+file1,/GET_LUN 

  FOR i=0,N_ELEMENTS(missingorbarr[0,*])-1 DO BEGIN 
     PRINTF,lun,FORMAT='("    Orbits ",I0)',missingorbarr[0,i] 
     PRINTF,missinglun,FORMAT='(I0,T10,I0)',missingorbarr[0,i],missingorbarr[1,i] 
  ENDFOR
  
  CLOSE,lun
  CLOSE,missinglun

  FREE_LUN,lun
  FREE_LUN,missinglun
END
